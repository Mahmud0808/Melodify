import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';

String formatDuration(double seconds) {
  int totalSeconds = seconds.toInt();
  int hours = totalSeconds ~/ 3600;
  int minutes = (totalSeconds % 3600) ~/ 60;
  int remainingSeconds = totalSeconds % 60;

  if (hours > 0) {
    return '$hours:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  } else {
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}

Future<Uri> getArtworkUri(int songId) async {
  final OnAudioQuery audioQuery = OnAudioQuery();

  final artworkBytes = await audioQuery.queryArtwork(
    songId,
    ArtworkType.AUDIO,
    format: ArtworkFormat.PNG,
  );

  if (artworkBytes != null) {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/song_$songId.png');
    await file.writeAsBytes(artworkBytes);
    return Uri.file(file.path);
  }

  final byteData = await rootBundle.load('assets/images/no_artwork.png');
  final tempDir = await getTemporaryDirectory();
  final file = File('${tempDir.path}/no_artwork.png');
  await file.writeAsBytes(byteData.buffer.asUint8List());
  return Uri.file(file.path);
}
