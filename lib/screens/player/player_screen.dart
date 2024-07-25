import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:melodify/controllers/player_controller.dart';
import 'package:melodify/controllers/song_list_controller.dart';
import 'package:melodify/utility/constants/colors.dart';
import 'package:melodify/utility/custom_slider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:unicons/unicons.dart';

import '../../utility/widgets/time_display.dart';

class PlayerScreen extends StatelessWidget {
  final int index;
  final List<SongModel> songList;

  const PlayerScreen({
    super.key,
    required this.index,
    required this.songList,
  });

  @override
  Widget build(BuildContext context) {
    final playerController = Get.find<PlayerController>();
    final songListController = Get.find<SongListController>();

    return Scaffold(
      backgroundColor: colorBackgroundVariant,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            UniconsLine.arrow_left,
            color: textColorPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            decoration: BoxDecoration(
              color: colorBackground,
              borderRadius: BorderRadius.circular(36),
            ),
            alignment: Alignment.center,
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: Obx(
                () => QueryArtworkWidget(
                  id: playerController
                      .tempSongList[playerController.tempCurrentSongIndex.value]
                      .id,
                  size: 8000,
                  type: ArtworkType.AUDIO,
                  artworkWidth: double.infinity,
                  artworkHeight: double.infinity,
                  artworkQuality: FilterQuality.high,
                  artworkBorder: BorderRadius.circular(36),
                  nullArtworkWidget: const Icon(
                    UniconsLine.music_note,
                    size: 80,
                    color: textColorSecondary,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: colorBackground,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(36),
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Row(
                      children: [
                        Expanded(
                          child: Obx(
                            () => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  playerController
                                      .tempSongList[playerController
                                          .tempCurrentSongIndex.value]
                                      .title,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                    color: textColorPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  playerController
                                          .tempSongList[playerController
                                              .tempCurrentSongIndex.value]
                                          .artist ??
                                      "Unknown artist",
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    color: textColorSecondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 18,
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colorBackgroundVariant,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Obx(() {
                            bool isFavorite =
                                playerController.isFavoriteSong.value;
                            Color iconColor = isFavorite
                                ? Colors.redAccent
                                : textColorSecondary.withAlpha(160);

                            return GestureDetector(
                              onTap: () {
                                if (isFavorite) {
                                  songListController.removeSongFromFavorites(
                                      playerController.tempSongList[
                                          playerController
                                              .tempCurrentSongIndex.value]);
                                  playerController.isFavoriteSong.value = false;
                                } else {
                                  songListController.addSongToFavorites(
                                      playerController.tempSongList[
                                          playerController
                                              .tempCurrentSongIndex.value]);
                                  playerController.isFavoriteSong.value = true;
                                }

                                songListController.tempFavorites.value =
                                    songListController.songs
                                        .where((song) => songListController
                                            .isSongInFavorites(song))
                                        .toList();
                              },
                              child: Icon(
                                Icons.favorite,
                                color: iconColor,
                                size: 36,
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackShape: PlayerSliderTrackShape(),
                      thumbShape: PlayerSliderThumbShape(
                        thumbRadius: 12.0,
                      ),
                      thumbColor: purpleColor,
                      activeTrackColor: purpleColor,
                      inactiveTrackColor: colorBackgroundVariant,
                      overlayColor: purpleColor.withAlpha(32),
                      trackHeight: 8,
                    ),
                    child: Obx(
                      () => Slider(
                        min: 0.0,
                        max: playerController.maxDuration.value,
                        value: playerController.currentDuration.value,
                        onChanged: (newValue) {
                          playerController.seekTo(newValue.toInt());
                          newValue = newValue;
                        },
                      ),
                    ),
                  ),
                  Obx(
                    () => TimeDisplay(
                      startTime: playerController.currentDuration.value,
                      endTime: playerController.maxDuration.value,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            onPressed: playerController.hasPrev.value
                                ? () {
                                    playerController.previous();
                                  }
                                : null,
                            icon: Icon(
                              UniconsLine.previous,
                              size: 48,
                              color: textColorSecondary.withAlpha(
                                  playerController.hasPrev.value ? 160 : 60),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: colorBackgroundVariant,
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: InkWell(
                              onTap: () {
                                if (playerController.isPlaying.value) {
                                  playerController.pause();
                                } else {
                                  playerController.setSongList(songList);
                                  playerController.play(playerController
                                      .tempCurrentSongIndex.value);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(18),
                                child: playerController.isPlaying.value
                                    ? const Icon(
                                        Icons.pause_rounded,
                                        size: 48,
                                        color: textColorSecondary,
                                      )
                                    : const Icon(
                                        Icons.play_arrow_rounded,
                                        size: 48,
                                        color: textColorSecondary,
                                      ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: playerController.hasNext.value
                                ? () {
                                    playerController.next();
                                  }
                                : null,
                            icon: Icon(
                              UniconsLine.step_forward,
                              size: 48,
                              color: textColorSecondary.withAlpha(
                                  playerController.hasNext.value ? 160 : 60),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
