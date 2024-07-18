import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:melodify/controllers/player_controller.dart';
import 'package:melodify/utility/constants/colors.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MiniPlayerView extends StatefulWidget {
  const MiniPlayerView({super.key});

  @override
  State<MiniPlayerView> createState() => _MiniPlayerViewState();
}

class _MiniPlayerViewState extends State<MiniPlayerView> {
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());

    return Dismissible(
      key: const Key('mini_player'),
      direction: DismissDirection.down,
      onDismissed: (direction) {
        Feedback.forLongPress(context);
        // pageManager.stop();
      },
      child: Dismissible(
        key: const Key("sfafs"),
        confirmDismiss: (direction) {
          // if (direction == DismissDirection.startToEnd) {
          //   pageManager.previous();
          // } else {
          //   pageManager.next();
          // }
          return Future.value(false);
        },
        child: Obx(
          () => controller.isPlaying.value
              ? Card(
                  margin: const EdgeInsets.all(0),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  color: Colors.black12,
                  child: SizedBox(
                    height: 80,
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 48,
                          sigmaY: 48,
                        ),
                        child: ListTile(
                          dense: false,
                          onTap: () {
                            // TODO
                          },
                          title: Text(
                            controller
                                .songs[controller.currentSongIndex.value].title,
                            style: const TextStyle(
                              color: textColorPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            controller.songs[controller.currentSongIndex.value]
                                    .artist ??
                                "Unknown Artist",
                            style: const TextStyle(
                              color: textColorSecondary,
                              fontWeight: FontWeight.w300,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          leading: QueryArtworkWidget(
                            id: controller
                                .songs[controller.currentSongIndex.value].id,
                            type: ArtworkType.AUDIO,
                            artworkBorder: BorderRadius.circular(12),
                            artworkHeight: 48,
                            artworkWidth: 48,
                            nullArtworkWidget: Container(
                              width: 48,
                              height: 48,
                              decoration: const BoxDecoration(
                                color: colorBackgroundVariant,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                              child: const Icon(
                                Icons.album_rounded,
                                color: textColorPrimary,
                                size: 20,
                              ),
                            ),
                          ),
                          trailing: Obx(
                            () => Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: colorBackgroundVariant,
                                    borderRadius: BorderRadius.circular(120),
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
                                      padding: const EdgeInsets.all(10),
                                      child: controller.isPlaying.value
                                          ? const Icon(
                                              Icons.pause_rounded,
                                              size: 28,
                                              color: textColorSecondary,
                                            )
                                          : const Icon(
                                              Icons.play_arrow_rounded,
                                              size: 28,
                                              color: textColorSecondary,
                                            ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
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
                                    size: 28,
                                    color: textColorSecondary.withAlpha(
                                        controller.hasNext.value ? 160 : 60),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
