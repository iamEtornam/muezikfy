import 'package:muezikfy/models/song.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sqflite/sqflite.dart';

class SongsPersistenceService {
  static const tableSongs = """
  CREATE TABLE IF NOT EXISTS my_songs(_id INTEGER PRIMARY KEY, _data TEXT, album_artwork TEXT, _display_name TEXT, artist TEXT, year TEXT, album TEXT, composer TEXT, is_music BOOLEAN, is_ringtone BOOLEAN, title TEXT, uri TEXT, artist_id TEXT, is_podcast BOOLEAN, duration TEXT, _size TEXT, is_alarm BOOLEAN, bookmark TEXT, album_id TEXT, is_notification BOOLEAN, track TEXT);""";

  Future<Database> initialiseDatabase() async {
    final Future<Database> database =
        openDatabase(join(await getDatabasesPath(), 'muezikfy_songs.db'),
            onCreate: (db, version) async {
      await db.execute(tableSongs);
    }, version: 1);
    return database;
  }

  Future<bool> insertSongs({required List<AudioModel> songs}) async {
    Song song;
    final Database db = await initialiseDatabase();
    await db.execute('DELETE FROM my_songs');
    songs.forEach((element) {
      song = Song(
          album: element.album,
          albumId: element.albumId,
          artist: element.artist,
          artistId: element.artistId,
          bookmark: element.bookmark,
          composer: element.composer,
          displayName: element.displayNameWOExt,
          duration: element.duration,
          isAlarm: element.isAlarm,
          isMusic: element.isMusic,
          isNotification: element.isNotification,
          isPodcast: element.isPodcast,
          isRingtone: element.isRingtone,
          size: element.size,
          title: element.title,
          track: element.track,
          uri: element.uri,
          data: element.data);

      db.insert(
        'my_songs',
        song.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
    return true;
  }

  Future<List<Song>> getAllSongs() async {
    final Database db = await initialiseDatabase();

    final List<Map<String, dynamic>> maps = await db.query('my_songs');
    return List.generate(
        maps.length,
        (index) => Song(
              data: maps[index]['_data'],
              album: maps[index]['album'],
              albumId: maps[index]['album_id'],
              artist: maps[index]['artist'],
              artistId: maps[index]['artist_id'],
              bookmark: maps[index]['bookmark'],
              composer: maps[index]['composer'],
              displayName: maps[index]['_display_name'],
              duration: maps[index]['duration'],
              isAlarm: maps[index]['is_alarm'] == 1 ? true : false,
              isMusic: maps[index]['is_music'] == 1 ? true : false,
              isNotification:
                  maps[index]['is_notification'] == 1 ? true : false,
              isPodcast: maps[index]['is_podcast'] == 1 ? true : false,
              isRingtone: maps[index]['is_ringtone'] == 1 ? true : false,
              size: maps[index]['_size'],
              title: maps[index]['title'],
              track: maps[index]['track'],
              uri: maps[index]['uri'],
            ));
  }
}
