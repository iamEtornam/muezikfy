// To parse this JSON data, do
//
//     final song = songFromMap(jsonString);

import 'dart:convert';

List<Song> songFromMap(String str) => List<Song>.from(json.decode(str).map((x) => Song.fromMap(x)));

String songToMap(List<Song> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));


class Song {
  Song({
    this.data,
    this.albumArtwork,
    this.displayName,
    this.artist,
    this.year,
    this.album,
    this.composer,
    this.isMusic,
    this.isRingtone,
    this.title,
    this.uri,
    this.artistId,
    this.isPodcast,
    this.duration,
    this.size,
    this.isAlarm,
    this.bookmark,
    this.albumId,
    this.isNotification,
    this.track,
  });

  String data;
  dynamic albumArtwork;
  String displayName;
  String artist;
  dynamic year;
  String album;
  dynamic composer;
  bool isMusic;
  bool isRingtone;
  String title;
  String uri;
  String artistId;
  bool isPodcast;
  String duration;
  String size;
  bool isAlarm;
  dynamic bookmark;
  String albumId;
  bool isNotification;
  String track;

  factory Song.fromMap(Map<String, dynamic> json) => Song(
    data: json["_data"] == null ? null : json["_data"],
    albumArtwork: json["album_artwork"],
    displayName: json["_display_name"] == null ? null : json["_display_name"],
    artist: json["artist"] == null ? null : json["artist"],
    year: json["year"],
    album: json["album"] == null ? null : json["album"],
    composer: json["composer"],
    isMusic: json["is_music"] == null ? null : json["is_music"],
    isRingtone: json["is_ringtone"] == null ? null : json["is_ringtone"],
    title: json["title"] == null ? null : json["title"],
    uri: json["uri"] == null ? null : json["uri"],
    artistId: json["artist_id"] == null ? null : json["artist_id"],
    isPodcast: json["is_podcast"] == null ? null : json["is_podcast"],
    duration: json["duration"] == null ? null : json["duration"],
    size: json["_size"] == null ? null : json["_size"],
    isAlarm: json["is_alarm"] == null ? null : json["is_alarm"],
    bookmark: json["bookmark"],
    albumId: json["album_id"] == null ? null : json["album_id"],
    isNotification: json["is_notification"] == null ? null : json["is_notification"],
    track: json["track"] == null ? null : json["track"],
  );

  Map<String, dynamic> toMap() => {
    "_data": data == null ? null : data,
    "album_artwork": albumArtwork,
    "_display_name": displayName == null ? null : displayName,
    "artist": artist == null ? null : artist,
    "year": year,
    "album": album == null ? null : album,
    "composer": composer,
    "is_music": isMusic == null ? null : isMusic,
    "is_ringtone": isRingtone == null ? null : isRingtone,
    "title": title == null ? null : title,
    "uri": uri == null ? null : uri,
    "artist_id": artistId == null ? null : artistId,
    "is_podcast": isPodcast == null ? null : isPodcast,
    "duration": duration == null ? null : duration,
    "_size": size == null ? null : size,
    "is_alarm": isAlarm == null ? null : isAlarm,
    "bookmark": bookmark,
    "album_id": albumId == null ? null : albumId,
    "is_notification": isNotification == null ? null : isNotification,
    "track": track == null ? null : track,
  };
}
