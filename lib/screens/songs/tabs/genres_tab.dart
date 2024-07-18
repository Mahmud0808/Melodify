import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:melodify/utility/widgets/genre_row.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../controllers/song_list_controller.dart';
import '../../../utility/constants/colors.dart';
import '../../player/player_controller.dart';

class GenresTab extends StatefulWidget {
  const GenresTab({super.key});

  @override
  State<GenresTab> createState() => _GenresTabState();
}

class _GenresTabState extends State<GenresTab> {
  @override
  Widget build(BuildContext context) {
    var songListController = Get.put(SongListController());
    var playerController = Get.put(PlayerController());

    songListController.fetchGenres();

    return Obx(() {
      if (songListController.isLoadingGenres.value) {
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

      if (songListController.genres.isEmpty) {
        return const Center(
          child: Text(
            "No genre found",
            style: TextStyle(
              fontSize: 14,
              color: textColorPrimary,
            ),
          ),
        );
      }

      return AllAlbumsWidget(
        genres: songListController.genres,
        playerController: playerController,
      );
    });
  }
}

class AllAlbumsWidget extends StatelessWidget {
  final List<GenreModel> genres;
  final PlayerController playerController;
  final ScrollController _scrollController = ScrollController();

  AllAlbumsWidget({
    super.key,
    required this.genres,
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
            itemCount: genres.length,
            controller: _scrollController,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Obx(
                  () => GenreRow(
                    index: index,
                    currentSongIndex: -1,
                    genre: genres[index],
                    isSongPlaying: false,
                    onPressedRow: () {},
                    onPressedPlay: () {},
                    onPressedPause: () {},
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
