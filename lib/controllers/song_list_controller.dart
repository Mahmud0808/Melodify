import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongListController extends GetxController {
  final OnAudioQuery audioQuery = OnAudioQuery();
  final hasPermission = false.obs;

  final isLoadingSongs = false.obs;
  final isLoadingAlbums = false.obs;
  final isLoadingArtists = false.obs;
  final isLoadingGenres = false.obs;
  final isLoadingFavorites = false.obs;

  var songs = <SongModel>[].obs;
  var albums = <AlbumModel>[].obs;
  var artists = <ArtistModel>[].obs;
  var genres = <GenreModel>[].obs;
  var favorites = <SongModel>[].obs;
  var tempFavorites = <SongModel>[].obs;

  @override
  void onInit() async {
    super.onInit();

    await checkAndRequestPermissions();

    fetchSongs();
    fetchAlbums();
    fetchArtists();
    fetchGenres();
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

      fetchFavorites();

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

  fetchFavorites() async {
    isLoadingFavorites.value = true;

    favorites.value = songs.where((song) => isSongInFavorites(song)).toList();
    tempFavorites.value = favorites;

    isLoadingFavorites.value = false;
  }

  void addSongToFavorites(SongModel song) {
    GetStorage().write(song.id.toString(), true);
  }

  void removeSongFromFavorites(SongModel song) {
    GetStorage().remove(song.id.toString());
  }

  bool isSongInFavorites(SongModel song) {
    return GetStorage().read(song.id.toString()) == true;
  }
}
