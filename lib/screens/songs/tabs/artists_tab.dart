import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../controllers/song_list_controller.dart';
import '../../../utility/constants/colors.dart';
import '../../../utility/widgets/artist_row.dart';
import '../../../controllers/player_controller.dart';

class ArtistsTab extends StatefulWidget {
  const ArtistsTab({super.key});

  @override
  State<ArtistsTab> createState() => _ArtistsTabState();
}

class _ArtistsTabState extends State<ArtistsTab> {
  @override
  Widget build(BuildContext context) {
    var songListController = Get.put(SongListController());
    var playerController = Get.put(PlayerController());

    songListController.fetchArtists();

    return Obx(() {
      if (songListController.isLoadingArtists.value) {
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

      if (songListController.artists.isEmpty) {
        return const Center(
          child: Text(
            "No artist found",
            style: TextStyle(
              fontSize: 14,
              color: textColorPrimary,
            ),
          ),
        );
      }

      return AllAlbumsWidget(
        artists: songListController.artists,
        playerController: playerController,
      );
    });
  }
}

class AllAlbumsWidget extends StatelessWidget {
  final List<ArtistModel> artists;
  final PlayerController playerController;
  final ScrollController _scrollController = ScrollController();

  AllAlbumsWidget({
    super.key,
    required this.artists,
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
            itemCount: artists.length,
            controller: _scrollController,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Obx(
                  () => ArtistRow(
                    index: index,
                    currentSongIndex: -1,
                    artist: artists[index],
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
