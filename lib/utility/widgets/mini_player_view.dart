import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:melodify/controllers/player_controller.dart';
import 'package:melodify/screens/player/player_screen.dart';
import 'package:melodify/utility/constants/colors.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:unicons/unicons.dart';

class MiniPlayerView extends StatefulWidget {
  const MiniPlayerView({super.key});

  @override
  State<MiniPlayerView> createState() => _MiniPlayerViewState();
}

class _MiniPlayerViewState extends State<MiniPlayerView> {
  final playerController = Get.find<PlayerController>();

  @override
  void initState() {
    super.initState();

    playerController.isPlaying.listen((isPlaying) {
      if (isPlaying) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.down,
      child: Obx(
        () {
          final currentSong = playerController.currentSong.value;
          final currentSongIndex = playerController.currentSongIndex.value;

          if (currentSong == SongModel({}) || currentSongIndex < 0) {
            return const SizedBox.shrink();
          }

          return Card(
            margin: const EdgeInsets.all(0),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(18),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            color: Colors.black12,
            child: SizedBox(
              height: 84,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 48,
                    sigmaY: 48,
                  ),
                  child: Column(
                    children: [
                      _MiniPlayerListTile(),
                      _MiniPlayerProgressBar(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MiniPlayerListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final playerController = Get.find<PlayerController>();

    return Obx(
      () => ListTile(
        dense: false,
        onTap: () {
          Get.to(
            () => PlayerScreen(
              index: playerController.currentSongIndex.value,
              songList: playerController.songList,
            ),
            transition: Transition.downToUp,
          );
        },
        title: Text(
          playerController.currentSong.value.title,
          style: const TextStyle(
            color: textColorPrimary,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          playerController.currentSong.value.artist ?? "Unknown Artist",
          style: const TextStyle(
            color: textColorSecondary,
            fontWeight: FontWeight.w300,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        leading: QueryArtworkWidget(
          id: playerController.currentSong.value.id,
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
        trailing: _MiniPlayerControls(),
      ),
    );
  }
}

class _MiniPlayerControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final playerController = Get.find<PlayerController>();

    return Obx(
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
                if (playerController.isPlaying.value) {
                  playerController.pause();
                } else {
                  playerController
                      .play(playerController.currentSongIndex.value);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  playerController.isPlaying.value
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  size: 28,
                  color: textColorSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: playerController.hasNext.value
                ? () {
                    playerController.next();
                  }
                : null,
            icon: Icon(
              UniconsLine.step_forward,
              size: 28,
              color: textColorSecondary
                  .withAlpha(playerController.hasNext.value ? 160 : 60),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniPlayerProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final playerController = Get.find<PlayerController>();

    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(top: 8),
        child: LinearProgressIndicator(
          minHeight: 4,
          color: purpleColor,
          backgroundColor: Colors.transparent,
          value: playerController.maxDuration.value > 0
              ? playerController.currentDuration.value /
                  playerController.maxDuration.value
              : 0,
        ),
      ),
    );
  }
}
