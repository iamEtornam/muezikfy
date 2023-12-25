// To parse this JSON data, do
//
//     final song = songFromMap(jsonString);

import 'dart:convert';

List<Song> songFromMap(String str) =>
    List<Song>.from(json.decode(str).map((x) => Song.fromMap(x)));

String songToMap(List<Song> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Song {
  Song({
    this.audioId,
    this.data,
    this.displayName,
    this.artist,
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

  int? audioId;
  String? data;
  String? displayName;
  String? artist;
  String? album;
  dynamic composer;
  bool? isMusic;
  bool? isRingtone;
  String? title;
  String? uri;
  int? artistId;
  bool? isPodcast;
  int? duration;
  int? size;
  bool? isAlarm;
  dynamic bookmark;
  int? albumId;
  bool? isNotification;
  int? track;

  factory Song.fromMap(Map<String, dynamic> json) => Song(
        audioId: json["audioId"] == null ? null : json["audioId"],
        data: json["_data"] == null ? null : json["_data"],
        displayName:
            json["_display_name"] == null ? null : json["_display_name"],
        artist: json["artist"] == null ? null : json["artist"],
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
        isNotification:
            json["is_notification"] == null ? null : json["is_notification"],
        track: json["track"] == null ? null : json["track"],
      );

  Map<String, dynamic> toMap() => {
        "audioId": audioId == null ? null : audioId,
        "_data": data == null ? null : data,
        "_display_name": displayName == null ? null : displayName,
        "artist": artist == null ? null : artist,
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
