import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:melodify/screens/player/player_controller.dart';
import 'package:melodify/utility/constants/colors.dart';
import 'package:melodify/utility/custom_slider.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayerScreen extends StatelessWidget {
  final int index;

  const PlayerScreen({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<PlayerController>();

    return Scaffold(
      backgroundColor: colorBackgroundVariant,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back,
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
                  id: controller
                      .songs[controller.currentSongIndex.value].id,
                  type: ArtworkType.AUDIO,
                  artworkWidth: double.infinity,
                  artworkHeight: double.infinity,
                  artworkQuality: FilterQuality.high,
                  artworkBorder: BorderRadius.circular(36),
                  nullArtworkWidget: const Icon(
                    Icons.music_note,
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
                                  controller
                                      .songs[controller
                                          .currentSongIndex.value]
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
                                  controller
                                          .songs[controller
                                              .currentSongIndex.value]
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
                            Color iconColor =
                                controller.currentSongIsFavorite.value
                                    ? Colors.redAccent
                                    : textColorSecondary.withAlpha(160);

                            return GestureDetector(
                              onTap: () {
                                if (controller.currentSongIsFavorite.value) {
                                  controller.removeSongFromFavorites();
                                } else {
                                  controller.addSongToFavorites();
                                }
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
                      trackShape: CustomTrackShape(),
                      thumbShape: CustomThumbShape(
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
                        max: controller.max.value,
                        value: controller.value.value,
                        onChanged: (newValue) {
                          controller.changeCurrentDuration(newValue.toInt());
                          newValue = newValue;
                        },
                      ),
                    ),
                  ),
                  Obx(
                    () => TimeDisplayWidget(
                      startTime: controller.currentPosition.value,
                      endTime: controller.duration.value,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            onPressed: controller.hasPrev.value
                                ? () {
                                    controller.goToPreviousSong();

                                    if (controller.isPlaying.value) {
                                      controller.playSong(controller
                                          .currentSongIndex.value);
                                    }
                                  }
                                : null,
                            icon: Icon(
                              Icons.skip_previous_outlined,
                              size: 48,
                              color: textColorSecondary.withAlpha(
                                  controller.hasPrev.value ? 160 : 60),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: colorBackgroundVariant,
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: InkWell(
                              onTap: () {
                                if (controller.isPlaying.value) {
                                  controller.pauseSong();
                                } else {
                                  controller.playSong(
                                      controller.currentSongIndex.value);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(18),
                                child: controller.isPlaying.value
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
                            onPressed: controller.hasNext.value
                                ? () {
                                    controller.goToNextSong();

                                    if (controller.isPlaying.value) {
                                      controller.playSong(controller
                                          .currentSongIndex.value);
                                    }
                                  }
                                : null,
                            icon: Icon(
                              Icons.skip_next_outlined,
                              size: 48,
                              color: textColorSecondary.withAlpha(
                                  controller.hasNext.value ? 160 : 60),
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

class TimeDisplayWidget extends StatelessWidget {
  final String startTime;
  final String endTime;

  const TimeDisplayWidget({
    super.key,
    required this.startTime,
    required this.endTime,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              startTime,
              style: const TextStyle(
                fontSize: 13,
                color: textColorSecondary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              endTime,
              style: const TextStyle(
                fontSize: 13,
                color: textColorSecondary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
