part of 'main.dart';

abstract class _State extends WidgetState {
  late final args = argumentsAs<ViewNavigationArguments>();

  late final AudioArtistType artist = args!.param<AudioArtistType>()!;
  late final int artistId = artist.id;

  late final Iterable<AudioTrackType> track =
      cacheBucket.track.where((e) => e.artists.contains(artistId));
  late final List<String> artistAlbumId = track.map((e) => e.uid).toSet().toList();
  late final Iterable<AudioAlbumType> artistAlbum =
      artistAlbumId.map((e) => cacheBucket.albumById(e));
  late final List<int> artistRecommendedId = track
      .where((e) => e.artists.length > 1)
      .map((e) => e.artists)
      .expand((e) => e)
      .toSet()
      .toList(); //..removeWhere((e) => e == artistId);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int get artistPlaysCount => artist.plays;
  String get artistDuration => cacheBucket.duration(artist.duration);
  String get artistTrackCount => artist.track.toString();
  String get artistAlbumCount => artist.album.toString();

  // Iterable<AudioTrackType> get track => cacheBucket.track.where((e) => e.artists.contains(artistId));

  // Iterable<AudioMetaType> get artistTrack => track.map((e) => cacheBucket.meta(e.id)).take(10);
  // Iterable<AudioMetaType> get artistTrack => track.map((e) => cacheBucket.meta(e.id));
  List<int> get artistTrackIds => track.map((e) => e.id).toList();

  // List<String> get artistAlbumId => track.map((e) => e.uid).toSet().toList();

  // Iterable<AudioAlbumType> get artistAlbum => artistAlbumId.map(
  //   (e) => cacheBucket.albumById(e)
  // );

  // List<int> get artistRecommendedId => track.where(
  //   (e) => e.artists.length > 1
  // ).map((e) => e.artists).expand((e) => e).toSet().toList();//..removeWhere((e) => e == artistId);

  // Iterable<AudioArtistType> get artistRecommended => artistRecommendedId.where((e) => e != artistId).map(
  //   (e) => cacheBucket.artistById(e)
  // );
  Iterable<int> get artistRecommended => artistRecommendedId.where((e) => e != artistId);

  // Iterable<AudioArtistType> get artistRelated => cacheBucket.trackByUid(artistAlbumId).map(
  //   (e) => e.artists
  // ).map((e) => e).expand((e) => e).toSet().where(
  //   (e) => !artistRecommendedId.contains(e)
  // ).map(
  //   (e) => cacheBucket.artistById(e)
  // );
  Iterable<int> get artistRelated => cacheBucket
      .trackByUid(artistAlbumId)
      .map((e) => e.artists)
      .expand((e) => e)
      .toSet()
      .where((e) => !artistRecommendedId.contains(e));

  List<String> get artistYear =>
      artistAlbum.map((e) => e.year.where((x) => x != '')).expand((e) => e).toSet().toList()
        ..sort((a, b) => a.compareTo(b));

  void _playAll() {
    audio.queuefromTrack(track.map((e) => e.id).toList(), group: true);
  }
}
