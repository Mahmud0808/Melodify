import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:melodify/controllers/song_list_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../utility/helpers.dart';

class PlayerController extends GetxController {
  final AudioPlayer audioPlayer = AudioPlayer();
  final SongListController songListController = Get.find<SongListController>();

  final currentSong = SongModel({}).obs;
  final tempCurrentSong = SongModel({}).obs;
  final currentSongIndex = (-1).obs;
  final tempCurrentSongIndex = (-1).obs;
  final isPlaying = false.obs;
  final hasPrev = true.obs;
  final hasNext = false.obs;
  final isShuffleModeEnabled = false.obs;
  final hasPermission = false.obs;
  final isLoading = false.obs;
  final songList = <SongModel>[].obs;
  final tempSongList = <SongModel>[].obs;
  final maxDuration = 0.0.obs;
  final currentDuration = 0.0.obs;
  final isFavoriteSong = false.obs;

  @override
  void onInit() async {
    super.onInit();

    initializeListeners();
  }

  void initializeListeners() {
    audioPlayer.durationStream.listen((event) {
      maxDuration.value = event?.inSeconds.toDouble() ?? 0;
    });

    audioPlayer.positionStream.listen((event) {
      currentDuration.value = event.inSeconds.toDouble();

      if (currentDuration.value == maxDuration.value) {
        pause();
        resetDuration();
      }
    });

    tempCurrentSongIndex.listen((index) {
      hasPrev.value = index > 0;
      hasNext.value = index < tempSongList.length - 1;
    });

    tempCurrentSong.listen((song) {
      isFavoriteSong.value = songListController.isSongInFavorites(song);
    });
  }

  setSongList(List<SongModel> songs) {
    songList.value = songs;
    tempSongList.value = songs;
  }

  setAudioSource() async {
    if (currentSongIndex.value < 0) {
      throw Exception("Current song index can not be -1");
    }

    currentSong.value = songList[currentSongIndex.value];
    final artworkUri = await getArtworkUri(currentSong.value.id);

    audioPlayer.setAudioSource(
      AudioSource.uri(
        Uri.parse(currentSong.value.uri!),
        tag: MediaItem(
            id: currentSong.value.id.toString(),
            title: currentSong.value.title,
            album: currentSong.value.album,
            artist: currentSong.value.artist,
            genre: currentSong.value.genre,
            duration: Duration(
                milliseconds:
                    currentSong.value.duration?.milliseconds.inMilliseconds ??
                        0),
            artUri: artworkUri),
      ),
      initialPosition: Duration(seconds: currentDuration.value.toInt()),
    );
  }

  previous() {
    if (hasPrev.value) {
      resetDuration();
      currentSongIndex.value--;
      tempCurrentSongIndex.value--;
      setAudioSource();
      isFavoriteSong.value = songListController
          .isSongInFavorites(songList[tempCurrentSongIndex.value]);
    }
  }

  next() {
    if (hasNext.value) {
      resetDuration();
      currentSongIndex.value++;
      tempCurrentSongIndex.value++;
      setAudioSource();
      isFavoriteSong.value = songListController
          .isSongInFavorites(songList[tempCurrentSongIndex.value]);
    }
  }

  play(int index) {
    if (currentSongIndex.value != index) {
      currentSongIndex.value = index;
      tempCurrentSongIndex.value = index;

      setAudioSource();
    }

    audioPlayer.play();
    isPlaying.value = true;
  }

  pause() {
    audioPlayer.pause();
    isPlaying.value = false;
  }

  seekTo(seconds) {
    audioPlayer.seek(Duration(seconds: seconds));
  }

  resetDuration() {
    currentDuration.value = const Duration(seconds: 0).inSeconds.toDouble();
  }
}
