import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:melodify/screens/favorites/favorite_screen.dart';
import 'package:melodify/screens/player/player_controller.dart';
import 'package:melodify/utility/constants/colors.dart';
import 'package:melodify/utility/widgets/song_row.dart';

import '../../utility/glass_appbar.dart';
import '../../utility/gradient_text.dart';
import '../player/player_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: GlassAppBar(
        leadingIcon: const Icon(
          Icons.sort_rounded,
          color: textColorPrimary,
        ),
        trailingIcon: IconButton(
          onPressed: () {
            Get.to(
              const FavoriteScreen(),
              transition: Transition.rightToLeftWithFade,
            );
          },
          icon: const Icon(
            Icons.favorite_border_rounded,
            color: textColorPrimary,
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Me",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w500,
                color: textColorPrimary,
              ),
            ),
            GradientText(
              'lodify',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w500,
              ),
              gradient: LinearGradient(
                colors: gradientPrimary,
              ),
            ),
          ],
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
                color: textColorPrimary,
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
                color: textColorPrimary,
              ),
            ),
          );
        }

        return HomeWidget(
          controller: controller,
        );
      }),
    );
  }
}

class HomeWidget extends StatelessWidget {
  final PlayerController controller;
  final ScrollController _scrollController = ScrollController();

  HomeWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ScrollbarTheme(
        data: ScrollbarThemeData(
          thumbColor: WidgetStateProperty.all(colorSecondary),
          radius: const Radius.circular(20),
        ),
        child: Scrollbar(
          thickness: 6,
          radius: const Radius.circular(20),
          controller: _scrollController,
          interactive: true,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: controller.songs.length,
            controller: _scrollController,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Obx(
                  () => SongRow(
                    song: controller.songs[index],
                    isSongPlaying: controller.isPlaying.value,
                    onPressedRow: () {
                      if (controller.currentSongIndex.value != index) {
                        controller.resetDuration();
                      }

                      controller.playSong(index);

                      Get.to(
                        PlayerScreen(
                          index: index,
                        ),
                        transition: Transition.downToUp,
                      );
                    },
                    onPressedPlay: () {
                      controller.playSong(index);
                    },
                    onPressedPause: () {
                      controller.pauseSong();
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
