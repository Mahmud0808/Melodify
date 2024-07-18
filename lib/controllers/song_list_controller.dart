import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongListController extends GetxController {
  final OnAudioQuery audioQuery = OnAudioQuery();
  final hasPermission = false.obs;

  final isLoadingSongs = false.obs;
  final isLoadingAlbums = false.obs;
  final isLoadingArtists = false.obs;
  final isLoadingGenres = false.obs;

  var songs = <SongModel>[].obs;
  var albums = <AlbumModel>[].obs;
  var artists = <ArtistModel>[].obs;
  var genres = <GenreModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    checkAndRequestPermissions();
  }

  checkAndRequestPermissions({bool retry = false}) async {
    if (await audioQuery.permissionsStatus() != true) {
      hasPermission.value = await audioQuery.permissionsRequest();
    } else {
      hasPermission.value = true;
    }
  }

  fetchSongs() async {
    if (songs.isEmpty) {
      isLoadingSongs.value = true;

      songs.value = await audioQuery.querySongs(
        sortType: SongSortType.TITLE,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );

      isLoadingSongs.value = false;
    }
  }

  fetchAlbums() async {
    if (albums.isEmpty) {
      isLoadingAlbums.value = true;

      albums.value = await audioQuery.queryAlbums(
        sortType: AlbumSortType.ALBUM,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );

      isLoadingAlbums.value = false;
    }
  }

  fetchArtists() async {
    if (artists.isEmpty) {
      isLoadingArtists.value = true;

      artists.value = await audioQuery.queryArtists(
        sortType: ArtistSortType.ARTIST,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );

      isLoadingArtists.value = false;
    }
  }

  fetchGenres() async {
    if (genres.isEmpty) {
      isLoadingGenres.value = true;

      genres.value = await audioQuery.queryGenres(
        sortType: GenreSortType.GENRE,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );

      isLoadingGenres.value = false;
    }
  }
}
