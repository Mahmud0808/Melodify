import 'package:flutter/material.dart';
import 'package:melodify/screens/songs/songs_screen.dart';
import 'package:melodify/utility/constants/colors.dart';

import '../../utility/widgets/mini_player_view.dart';
import '../home/home_screen.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  int selectTab = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);

    tabController?.addListener(() {
      selectTab = tabController?.index ?? 0;
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    tabController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          TabBarView(
            controller: tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              HomeScreen(),
              SongsScreen(),
            ],
          ),
          const MiniPlayerView(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: colorBackground, boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 12,
            offset: Offset(0, -3),
          )
        ]),
        child: BottomAppBar(
            color: colorBackground,
            elevation: 0,
            child: TabBar(
              controller: tabController,
              indicatorColor: Colors.transparent,
              indicatorWeight: 1,
              labelColor: colorPrimary,
              labelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              unselectedLabelColor: textColorSecondary.withAlpha(160),
              unselectedLabelStyle: const TextStyle(
                fontSize: 0,
                color: Colors.transparent,
              ),
              dividerColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              tabs: [
                Tab(
                  text: "Home",
                  icon: Image.asset(
                    selectTab == 0
                        ? "assets/images/home_tab.png"
                        : "assets/images/home_tab_un.png",
                    width: 20,
                    height: 20,
                  ),
                ),
                Tab(
                  text: "Songs",
                  icon: Image.asset(
                    selectTab == 1
                        ? "assets/images/songs_tab.png"
                        : "assets/images/songs_tab_un.png",
                    width: 20,
                    height: 20,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
