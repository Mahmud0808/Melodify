import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:unicons/unicons.dart';

import '../constants/colors.dart';

class SongRow extends StatelessWidget {
  final SongModel song;
  final VoidCallback onPressedRow;
  final VoidCallback onPressedPlay;
  final VoidCallback onPressedPause;

  const SongRow({
    super.key,
    required this.song,
    required this.onPressedRow,
    required this.onPressedPlay,
    required this.onPressedPause,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      width: double.infinity,
      child: InkWell(
        onTap: onPressedRow,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              QueryArtworkWidget(
                id: song.id,
                type: ArtworkType.AUDIO,
                artworkBorder: BorderRadius.circular(18),
                artworkHeight: 80,
                artworkWidth: 80,
                nullArtworkWidget: Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: colorBackgroundVariant,
                    borderRadius: BorderRadius.all(
                      Radius.circular(18),
                    ),
                  ),
                  child: const Icon(
                    UniconsLine.music_note,
                    color: textColorPrimary,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title,
                      style: const TextStyle(
                        fontSize: 18,
                        color: textColorPrimary,
                        fontWeight: FontWeight.w300,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      song.artist ?? "Unknown Artist",
                      style: const TextStyle(
                        fontSize: 15,
                        color: textColorSecondary,
                        fontWeight: FontWeight.w300,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
