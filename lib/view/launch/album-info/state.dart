part of 'main.dart';

abstract class _State extends WidgetState {
  late final args = argumentsAs<ViewNavigationArguments>();

  late final album = args!.param<AudioAlbumType>()!;

  late final String albumId = album.uid;
  late final String albumName = album.name;
  late final int albumPlaysCount = album.plays;
  late final String albumDuration = cacheBucket.duration(album.duration);
  late final String albumTrackCount = album.track.toString();
  late final List<String> albumGenre =
      cacheBucket.genreList(album.genre).map((e) => e.name).toList();
  late final List<String> albumYear = album.year;

  late final Iterable<AudioMetaType> albumTrack = audio.metaByUd([albumId]);

  late final Iterable<int> albumArtists =
      albumTrack.map((e) => e.trackInfo.artists).expand((i) => i).toSet();
  late final List<int> albumTrackIds = albumTrack.map((e) => e.trackInfo.id).toList();

  void _playAll() {
    core.audio.queuefromAlbum([albumId]);
  }
}
