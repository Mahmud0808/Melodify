import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayerController extends GetxController {
  final OnAudioQuery audioQuery = OnAudioQuery();
  final AudioPlayer audioPlayer = AudioPlayer();

  final hasPermission = false.obs;
  final isLoading = false.obs;
  var songs = <SongModel>[].obs;
  var currentSongIndex = (-1).obs;
  var isPlaying = false.obs;

  var duration = "".obs;
  var currentPosition = "".obs;

  var max = 0.0.obs;
  var value = 0.0.obs;

  var hasPrev = false.obs;
  var hasNext = true.obs;

  var currentSongIsFavorite = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkAndRequestPermissions();
  }

  checkAndRequestPermissions({bool retry = false}) async {
    if (await audioQuery.permissionsStatus() != true) {
      hasPermission.value = await audioQuery.permissionsRequest();
    } else {
      hasPermission.value = true;
    }

    if (hasPermission.value) {
      fetchSongs();
    }
  }

  fetchSongs() async {
    isLoading.value = true;
    var fetchedSongs = await audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    songs.value = fetchedSongs;
    isLoading.value = false;
  }

  setAudioSource() {
    if (currentSongIndex.value == -1) {
      throw Exception("Current song index can not be -1");
    }

    final currentSong = songs[currentSongIndex.value];

    audioPlayer.setAudioSource(
      AudioSource.uri(
        Uri.parse(currentSong.uri!),
        tag: MediaItem(
          id: currentSong.id.toString(),
          album: currentSong.album,
          title: currentSong.title,
        ),
      ),
      initialPosition: Duration(seconds: value.value.toInt()),
    );
  }

  goToPreviousSong() {
    if (hasPrev.value) {
      resetDuration();
      currentSongIndex.value -= 1;
      setAudioSource();
      currentSongIsFavorite.value = isSongInFavorites();
    }
  }

  goToNextSong() {
    if (hasNext.value) {
      resetDuration();
      currentSongIndex.value += 1;
      setAudioSource();
      currentSongIsFavorite.value = isSongInFavorites();
    }
  }

  playSong(int index) {
    try {
      currentSongIndex.value = index;
      setAudioSource();
      audioPlayer.play();
      isPlaying.value = true;

      updatePosition();

      hasPrev.value = index > 0;
      hasNext.value = index < songs.length - 1;

      currentSongIsFavorite.value = isSongInFavorites();
    } catch (e) {
      log(e.toString());
    }
  }

  pauseSong() {
    try {
      audioPlayer.pause();
      isPlaying.value = false;
    } catch (e) {
      log(e.toString());
    }
  }

  updatePosition() {
    audioPlayer.durationStream.listen((event) {
      duration.value = event.toString().split(".")[0];
      max.value = event!.inSeconds.toDouble();
    });

    audioPlayer.positionStream.listen((event) {
      currentPosition.value = event.toString().split(".")[0];
      value.value = event.inSeconds.toDouble();

      if (value.value == max.value) {
        pauseSong();
        resetDuration();
      }
    });
  }

  changeCurrentDuration(seconds) {
    var duration = Duration(seconds: seconds);
    audioPlayer.seek(duration);
  }

  resetDuration() {
    value.value = const Duration(seconds: 0).inSeconds.toDouble();
  }

  addSongToFavorites() {
    GetStorage().write(songs[currentSongIndex.value].id.toString(), true);
    currentSongIsFavorite.value = true;
  }

  removeSongFromFavorites() {
    GetStorage().remove(songs[currentSongIndex.value].id.toString());
    currentSongIsFavorite.value = false;
  }

  isSongInFavorites() {
    return GetStorage().read(songs[currentSongIndex.value].id.toString()) ==
        true;
  }

  isSongModelInFavorites(song) {
    return GetStorage().read(song.id.toString()) ==
        true;
  }
}