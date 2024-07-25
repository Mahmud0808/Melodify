import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:melodify/controllers/player_controller.dart';
import 'package:melodify/controllers/song_list_controller.dart';
import 'package:melodify/screens/favorites/favorite_screen.dart';
import 'package:melodify/utility/constants/colors.dart';
import 'package:melodify/utility/widgets/song_row.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../utility/glass_appbar.dart';
import '../../utility/gradient_text.dart';
import '../player/player_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var songListController = Get.find<SongListController>();
    var playerController = Get.find<PlayerController>();

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
              () => const FavoriteScreen(),
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
        if (songListController.isLoadingSongs.value) {
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

        if (songListController.songs.isEmpty) {
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
          songListController: songListController,
          playerController: playerController,
        );
      }),
    );
  }
}

class HomeWidget extends StatelessWidget {
  final SongListController songListController;
  final PlayerController playerController;
  final ScrollController _scrollController = ScrollController();

  HomeWidget({
    super.key,
    required this.songListController,
    required this.playerController,
  });

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
            itemCount: songListController.songs.length,
            controller: _scrollController,
            itemBuilder: (BuildContext context, int index) {
              SongModel song = songListController.songs[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SongRow(
                  key: Key(songListController.songs[index].id.toString()),
                  song: song,
                  onPressedRow: () {
                    if (playerController.songList.isEmpty) {
                      playerController.setSongList(songListController.songs);
                    }

                    if (playerController.currentSong.value != song) {
                      playerController.resetDuration();
                    }

                    if (playerController.isPlaying.value) {
                      playerController.setSongList(songListController.songs);
                      playerController.play(index);
                    }

                    playerController.tempSongList.value =
                        songListController.songs;
                    playerController.tempCurrentSong.value =
                        songListController.songs[index];
                    playerController.tempCurrentSongIndex.value = index;

                    Get.to(
                      () => PlayerScreen(
                        index: index,
                        songList: songListController.songs,
                      ),
                      transition: Transition.downToUp,
                    );
                  },
                  onPressedPlay: () {
                    playerController.setSongList(songListController.songs);
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
      ),
    );
  }
}
