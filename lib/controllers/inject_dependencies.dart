import 'package:get/get.dart';
import 'package:melodify/controllers/player_controller.dart';
import 'package:melodify/controllers/song_list_controller.dart';

Future<void> injectDependencies() async {
  Get.put(SongListController());
  Get.put(PlayerController());
}
