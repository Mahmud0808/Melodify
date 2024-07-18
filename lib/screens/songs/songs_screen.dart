import 'package:flutter/material.dart';
import 'package:melodify/screens/songs/tabs/albums_tab.dart';
import 'package:melodify/screens/songs/tabs/all_songs_tab.dart';
import 'package:melodify/screens/songs/tabs/artists_tab.dart';
import 'package:melodify/screens/songs/tabs/genres_tab.dart';

import '../../utility/constants/colors.dart';
import '../../utility/glass_appbar.dart';

class SongsScreen extends StatefulWidget {
  const SongsScreen({super.key});

  @override
  State<SongsScreen> createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen>
    with SingleTickerProviderStateMixin {
  TabController? _scrollController;
  int selectTab = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = TabController(length: 4, vsync: this);
    _scrollController?.addListener(() {
      selectTab = _scrollController?.index ?? 0;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlassAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Songs",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w300,
                color: textColorPrimary,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: kToolbarHeight + 24,
            child: TabBar(
              controller: _scrollController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicator: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(120),
              ),
              labelStyle: const TextStyle(
                color: colorBackground,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                color: textColorPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              labelPadding: const EdgeInsets.symmetric(horizontal: 4),
              dividerColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              tabs: [
                Tab(
                  height: 52,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: selectTab == 0 ? textColorPrimary : colorBackgroundVariant,
                        borderRadius: BorderRadius.circular(120),
                      ),
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text('All Songs'),
                      ),
                    ),
                  ),
                ),
                Tab(
                  height: 52,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: selectTab == 1 ? textColorPrimary : colorBackgroundVariant,
                      borderRadius: BorderRadius.circular(120),
                    ),
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text('Albums'),
                    ),
                  ),
                ),
                Tab(
                  height: 52,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: selectTab == 2 ? textColorPrimary : colorBackgroundVariant,
                      borderRadius: BorderRadius.circular(120),
                    ),
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text('Artists'),
                    ),
                  ),
                ),
                Tab(
                  height: 52,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 18),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: selectTab == 3 ? textColorPrimary : colorBackgroundVariant,
                        borderRadius: BorderRadius.circular(120),
                      ),
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text('Genres'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _scrollController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                AllSongsTab(),
                AlbumsTab(),
                ArtistsTab(),
                GenresTab(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
