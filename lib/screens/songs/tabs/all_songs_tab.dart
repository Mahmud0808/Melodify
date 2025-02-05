import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:melodify/controllers/player_controller.dart';
import 'package:melodify/controllers/song_list_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../utility/constants/colors.dart';
import '../../../utility/widgets/song_row.dart';
import '../../player/player_screen.dart';

class AllSongsTab extends StatefulWidget {
  const AllSongsTab({super.key});

  @override
  State<AllSongsTab> createState() => _AllSongsTabState();
}

class _AllSongsTabState extends State<AllSongsTab> {
  @override
  Widget build(BuildContext context) {
    var songListController = Get.find<SongListController>();
    var playerController = Get.find<PlayerController>();

    return Obx(() {
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

      return AllSongsWidget(
        songList: songListController.songs,
        playerController: playerController,
      );
    });
  }
}

class AllSongsWidget extends StatelessWidget {
  final List<SongModel> songList;
  final PlayerController playerController;
  final ScrollController _scrollController = ScrollController();

  AllSongsWidget({
    super.key,
    required this.songList,
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
            itemCount: songList.length,
            controller: _scrollController,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SongRow(
                  song: songList[index],
                  onPressedRow: () {
                    if (playerController.songList.isEmpty) {
                      playerController.setSongList(songList);
                    }

                    if (playerController.isPlaying.value) {
                      playerController.setSongList(songList);
                      playerController.play(index);
                    }

                    playerController.tempSongList.value = songList;
                    playerController.tempCurrentSong.value = songList[index];
                    playerController.tempCurrentSongIndex.value = index;

                    Get.to(
                      () => PlayerScreen(
                        index: index,
                        songList: songList,
                      ),
                      transition: Transition.downToUp,
                    );
                  },
                  onPressedPlay: () {
                    playerController.setSongList(songList);
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
