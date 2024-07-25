import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../controllers/player_controller.dart';
import '../utility/constants/media_controls.dart';
import '../utility/helpers.dart';

class MyAudioHandler extends BaseAudioHandler {
  final AudioPlayer _player;
  final PlayerController _playerController;

  MyAudioHandler(this._playerController)
      : _player = _playerController.audioPlayer {
    _player.playbackEventStream.listen((event) {
      playbackState.add(playbackState.value.copyWith(
        controls: [
          skipToPreviousControl,
          if (_player.playing) pauseControl else playControl,
          skipToNextControl,
        ],
        androidCompactActionIndices: [0, 1, 2],
        systemActions: const {
          MediaAction.seek,
          MediaAction.skipToPrevious,
          MediaAction.playPause,
          MediaAction.skipToNext,
        },
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_player.processingState]!,
        playing: _player.playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: event.currentIndex,
      ));
    });

    _playerController.currentSong.listen((song) {
      if (song != SongModel({})) {
        _updateMediaItem(song);
      }
    });
  }

  @override
  Future<void> play() async {
    if (_playerController.currentSongIndex.value >= 0) {
      _playerController.play(_playerController.currentSongIndex.value);
    } else {
      _playerController.play(_playerController.tempCurrentSongIndex.value);
    }
  }

  @override
  Future<void> pause() async {
    _playerController.pause();
  }

  @override
  Future<void> skipToNext() async {
    _playerController.next();
  }

  @override
  Future<void> skipToPrevious() async {
    _playerController.previous();
  }

  void _updateMediaItem(SongModel song) async {
    final artworkUri = await getArtworkUri(song.id);

    mediaItem.add(MediaItem(
      id: song.id.toString(),
      album: song.album,
      title: song.title,
      artist: song.artist,
      genre: song.genre,
      duration: Duration(
          milliseconds: song.duration?.milliseconds.inMilliseconds ?? 0),
      artUri: artworkUri,
    ));
  }
}
