import 'package:audio_service/audio_service.dart';

const playControl = MediaControl(
  androidIcon: 'drawable/ic_action_play_arrow',
  label: 'Play',
  action: MediaAction.play,
);

const pauseControl = MediaControl(
  androidIcon: 'drawable/ic_action_pause',
  label: 'Pause',
  action: MediaAction.pause,
);

const skipToNextControl = MediaControl(
  androidIcon: 'drawable/ic_action_skip_next',
  label: 'Next',
  action: MediaAction.skipToNext,
);

const skipToPreviousControl = MediaControl(
  androidIcon: 'drawable/ic_action_skip_previous',
  label: 'Previous',
  action: MediaAction.skipToPrevious,
);

const stopControl = MediaControl(
  androidIcon: 'drawable/ic_action_stop',
  label: 'Stop',
  action: MediaAction.stop,
);

final List<MediaControl> controls = [
  skipToPreviousControl,
  pauseControl,
  playControl,
  skipToNextControl,
  stopControl,
];
