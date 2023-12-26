import 'dart:convert';
import 'dart:developer';

import 'package:muezikfy/models/song.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SongsPersistenceService {
  static const tableSongs = """
  CREATE TABLE IF NOT EXISTS my_songs(_id BIGINT PRIMARY KEY,
    _uri VARCHAR(255),
    artist VARCHAR(255),
    year INT,
    is_music BOOLEAN,
    title VARCHAR(255),
    genre_id BIGINT,
    _size BIGINT,
    duration INT,
    is_alarm BOOLEAN,
    _display_name_wo_ext VARCHAR(255),
    album_artist VARCHAR(255),
    genre VARCHAR(255),
    is_notification BOOLEAN,
    track INT,
    _data VARCHAR(255),
    _display_name VARCHAR(255),
    album VARCHAR(255),
    composer VARCHAR(255),
    is_ringtone BOOLEAN,
    artist_id BIGINT,
    is_podcast BOOLEAN,
    bookmark INT,
    date_added BIGINT,
    is_audiobook BOOLEAN,
    date_modified BIGINT,
    album_id BIGINT,
    file_extension VARCHAR(10));""";

  Future<Database> initialiseDatabase() async {
    final Future<Database> database =
        openDatabase(join(await getDatabasesPath(), 'muezikfy_songs.db'),
            onCreate: (db, version) async {
      await db.execute(tableSongs);
    }, version: 1);
    return database;
  }

  Future<bool> insertSongs({required List<SongModel> songs}) async {
    Song song;
    final Database db = await initialiseDatabase();
    await db.execute('DELETE FROM my_songs');
    songs.forEach((element) {
      song = Song(
          iId: element.id,
          album: element.album,
          albumId: element.albumId,
          artist: element.artist,
          artistId: element.artistId,
          bookmark: element.bookmark,
          composer: element.composer,
          sDisplayNameWoExt: element.displayNameWOExt,
          sDisplayName: element.displayName,
          duration: element.duration,
          isAlarm: element.isAlarm,
          isMusic: element.isMusic,
          isNotification: element.isNotification,
          isPodcast: element.isPodcast,
          isRingtone: element.isRingtone,
          iSize: element.size,
          title: element.title,
          track: element.track,
          sUri: element.uri,
          sData: element.data);

      db.insert(
        'my_songs',
        song.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
    return true;
  }

  Future<List<Song>> getAllSongs() async {
    try {
      final Database db = await initialiseDatabase();

      final List<Map<String, dynamic>> maps = await db.query('my_songs');
      return List.generate(maps.length, (index) => Song.fromJson(maps[index]));
    } catch (e) {
      return [];
    }
  }

  deleteDatabase() async {
    final Database db = await initialiseDatabase();
    await db.database.delete('my_songs');
  }
}
