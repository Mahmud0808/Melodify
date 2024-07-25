import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:melodify/controllers/player_controller.dart';
import 'package:melodify/controllers/song_list_controller.dart';
import 'package:melodify/utility/constants/colors.dart';
import 'package:melodify/utility/widgets/song_row.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../utility/glass_appbar.dart';
import '../player/player_screen.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var songListController = Get.find<SongListController>();
    var playerController = Get.find<PlayerController>();

    songListController.fetchFavorites();

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
        if (songListController.isLoadingFavorites.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!songListController.hasPermission.value) {
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

        if (songListController.favorites.isEmpty) {
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
          songListController: songListController,
          playerController: playerController,
        );
      }),
    );
  }
}

class FavoriteWidget extends StatelessWidget {
  final PlayerController playerController;
  final SongListController songListController;
  final ScrollController scrollController = ScrollController();

  FavoriteWidget({
    super.key,
    required this.songListController,
    required this.playerController,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (songListController.tempFavorites != songListController.favorites) {
        songListController.fetchFavorites();
      }

      return ScrollbarTheme(
        data: ScrollbarThemeData(
          thumbColor: WidgetStateProperty.all(colorSecondary),
          radius: const Radius.circular(20),
        ),
        child: Scrollbar(
          thickness: 6,
          radius: const Radius.circular(20),
          controller: scrollController,
          interactive: true,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: songListController.favorites.length,
            controller: scrollController,
            itemBuilder: (BuildContext context, int index) {
              SongModel song = songListController.favorites[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SongRow(
                  song: song,
                  onPressedRow: () {
                    if (playerController.songList.isEmpty) {
                      playerController
                          .setSongList(songListController.favorites);
                    }

                    if (playerController.currentSong.value != song) {
                      playerController.resetDuration();
                    }

                    if (playerController.isPlaying.value) {
                      playerController
                          .setSongList(songListController.favorites);
                      playerController.play(index);
                    }

                    playerController.tempSongList.value =
                        songListController.favorites;
                    playerController.tempCurrentSong.value =
                        songListController.favorites[index];
                    playerController.tempCurrentSongIndex.value = index;

                    Get.to(
                      () => PlayerScreen(
                        index: index,
                        songList: songListController.favorites,
                      ),
                      transition: Transition.rightToLeftWithFade,
                    );
                  },
                  onPressedPlay: () {
                    playerController.setSongList(songListController.favorites);
                    playerController.play(index);
                  },
                  onPressedPause: () {
                    playerController.pause();
                  },
                ),
              );
            },
          ),
        ),
      );
    });
  }
}
