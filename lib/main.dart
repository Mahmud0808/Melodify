import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:melodify/controllers/player_controller.dart';
import 'package:melodify/screens/tabview/tabview_widget.dart';
import 'package:melodify/utility/constants/colors.dart';

import 'controllers/inject_dependencies.dart';
import 'handler/audio_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await GetStorage.init();
  await injectDependencies();
  await AudioService.init(
    builder: () => MyAudioHandler(Get.find<PlayerController>()),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.drdisgaree.melodify.channel.audio',
      androidNotificationChannelName: 'Music Player',
      androidNotificationIcon: 'drawable/ic_stat_music_note',
      androidNotificationOngoing: true,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Melodify',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
          fontFamily: "CircularStd",
          scaffoldBackgroundColor: colorBackground,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
          )),
      home: const MainTabView(),
    );
  }
}
