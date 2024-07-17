import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:melodify/screens/player/player_controller.dart';
import 'package:melodify/utility/constants/colors.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../utility/custom_appbar.dart';
import '../player/player_screen.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size(
          double.infinity,
          56.0,
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: const CustomAppBar(),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!controller.hasPermission.value) {
          return const Center(
            child: Text(
              "No permission to access music files",
              style: TextStyle(
                fontSize: 14,
                color: whiteColor,
              ),
            ),
          );
        }

        if (controller.songs.isEmpty) {
          return const Center(
            child: Text(
              "No song found",
              style: TextStyle(
                fontSize: 14,
                color: whiteColor,
              ),
            ),
          );
        }

        return HomeWidget(controller: controller);
      }),
    );
  }
}

class HomeWidget extends StatelessWidget {
  final PlayerController controller;

  const HomeWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: controller.songs.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: MusicTileWidget(
            controller: controller,
            index: index,
          ),
        );
      },
    );
  }
}

class MusicTileWidget extends StatelessWidget {
  final int index;
  final PlayerController controller;

  const MusicTileWidget({
    super.key,
    required this.controller,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final SongModel song = controller.songs[index];

    return GestureDetector(
      onTap: () {
        Get.to(
          Player(
            index: index,
          ),
          transition: Transition.downToUp,
        );

        if (controller.currentlyPlayingIndex.value != index) {
          controller.resetDuration();
        }

        controller.playSong(index);
      },
      child: Container(
        decoration: const BoxDecoration(
          color: bgDarkColor,
        ),
        width: double.infinity,
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
                  color: bgColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(18),
                  ),
                ),
                child: const Icon(
                  Icons.music_note,
                  color: whiteColor,
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
                      fontSize: 17,
                      color: whiteColor,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    song.artist ?? "Unknown Artist",
                    style: const TextStyle(
                      fontSize: 15,
                      color: whiteColorVariant,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Obx(() => controller.currentlyPlayingIndex.value == index
                ? controller.isPlaying.value
                    ? IconButton(
                        onPressed: () {
                          controller.pauseSong();
                        },
                        icon: const Icon(
                          Icons.pause_rounded,
                          size: 36,
                          color: whiteColorVariant,
                        ),
                      )
                    : IconButton(
                        onPressed: () {
                          controller.playSong(index);
                        },
                        icon: const Icon(
                          Icons.play_arrow_rounded,
                          size: 36,
                          color: whiteColorVariant,
                        ),
                      )
                : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}
