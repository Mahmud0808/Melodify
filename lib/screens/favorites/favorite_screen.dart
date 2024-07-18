import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:melodify/controllers/player_controller.dart';
import 'package:melodify/utility/constants/colors.dart';
import 'package:melodify/utility/widgets/song_row.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../utility/glass_appbar.dart';
import '../player/player_screen.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const GlassAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Favorites",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w300,
                color: textColorPrimary,
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

        // Filter the favorite songs
        var favoriteSongs = controller.songs
            .where((song) => controller.isSongModelInFavorites(song))
            .toList();

        if (favoriteSongs.isEmpty) {
          return const Center(
            child: Text(
              "No favorite song found",
              style: TextStyle(
                fontSize: 14,
                color: textColorPrimary,
              ),
            ),
          );
        }

        return FavoriteWidget(
          favoriteSongs: favoriteSongs,
          controller: controller,
        );
      }),
    );
  }
}

class FavoriteWidget extends StatelessWidget {
  final PlayerController controller;
  final ScrollController _scrollController = ScrollController();
  final List<SongModel> favoriteSongs;

  FavoriteWidget({
    super.key,
    required this.controller,
    required this.favoriteSongs,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollbarTheme(
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
          itemCount: favoriteSongs.length,
          controller: _scrollController,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Obx(
                () => SongRow(
                  song: favoriteSongs[index],
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
    );
  }
}
