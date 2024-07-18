import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../controllers/song_list_controller.dart';
import '../../../utility/constants/colors.dart';
import '../../../utility/widgets/album_row.dart';
import '../../../controllers/player_controller.dart';

class AlbumsTab extends StatefulWidget {
  const AlbumsTab({super.key});

  @override
  State<AlbumsTab> createState() => _AlbumsTabState();
}

class _AlbumsTabState extends State<AlbumsTab> {
  @override
  Widget build(BuildContext context) {
    var songListController = Get.put(SongListController());
    var playerController = Get.put(PlayerController());

    songListController.fetchAlbums();

    return Obx(() {
      if (songListController.isLoadingAlbums.value) {
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

      if (songListController.albums.isEmpty) {
        return const Center(
          child: Text(
            "No album found",
            style: TextStyle(
              fontSize: 14,
              color: textColorPrimary,
            ),
          ),
        );
      }

      return AllAlbumsWidget(
        albums: songListController.albums,
        playerController: playerController,
      );
    });
  }
}

class AllAlbumsWidget extends StatelessWidget {
  final List<AlbumModel> albums;
  final PlayerController playerController;
  final ScrollController _scrollController = ScrollController();

  AllAlbumsWidget({
    super.key,
    required this.albums,
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
            itemCount: albums.length,
            controller: _scrollController,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Obx(
                  () => AlbumRow(
                    index: index,
                    currentSongIndex: -1,
                    album: albums[index],
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
