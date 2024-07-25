import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:unicons/unicons.dart';

import '../constants/colors.dart';

class GenreRow extends StatelessWidget {
  final int index;
  final int currentSongIndex;
  final GenreModel genre;
  final bool isSongPlaying;
  final VoidCallback onPressedRow;
  final VoidCallback onPressedPlay;
  final VoidCallback onPressedPause;

  const GenreRow({
    super.key,
    required this.index,
    required this.currentSongIndex,
    required this.genre,
    required this.isSongPlaying,
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
                id: genre.id,
                type: ArtworkType.GENRE,
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
                    UniconsLine.headphones_alt,
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
                      genre.genre,
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
                      "${genre.numOfSongs} song${genre.numOfSongs > 1 ? "s" : ""}",
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
