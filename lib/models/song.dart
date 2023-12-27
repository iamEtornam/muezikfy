class Song {
  String? sUri;
  String? artist;
  int? year;
  dynamic isMusic;
  String? title;
  dynamic genreId;
  int? iSize;
  int? duration;
  dynamic isAlarm;
  String? sDisplayNameWoExt;
  String? albumArtist;
  dynamic genre;
  dynamic isNotification;
  int? track;
  String? sData;
  String? sDisplayName;
  String? album;
  String? composer;
  dynamic isRingtone;
  int? artistId;
  dynamic isPodcast;
  int? bookmark;
  int? dateAdded;
  dynamic isAudiobook;
  int? dateModified;
  int? albumId;
  String? fileExtension;
  int? iId;

  Song(
      {this.sUri,
      this.artist,
      this.year,
      this.isMusic,
      this.title,
      this.genreId,
      this.iSize,
      this.duration,
      this.isAlarm,
      this.sDisplayNameWoExt,
      this.albumArtist,
      this.genre,
      this.isNotification,
      this.track,
      this.sData,
      this.sDisplayName,
      this.album,
      this.composer,
      this.isRingtone,
      this.artistId,
      this.isPodcast,
      this.bookmark,
      this.dateAdded,
      this.isAudiobook,
      this.dateModified,
      this.albumId,
      this.fileExtension,
      this.iId});

  Song.fromJson(Map<String, dynamic> json) {
    sUri = json['_uri'];
    artist = json['artist'];
    year = json['year'];
    isMusic = json['is_music'];
    title = json['title'];
    genreId = json['genre_id'];
    iSize = json['_size'];
    duration = json['duration'];
    isAlarm = json['is_alarm'];
    sDisplayNameWoExt = json['_display_name_wo_ext'];
    albumArtist = json['album_artist'];
    genre = json['genre'];
    isNotification = json['is_notification'];
    track = json['track'];
    sData = json['_data'];
    sDisplayName = json['_display_name'];
    album = json['album'];
    composer = json['composer'];
    isRingtone = json['is_ringtone'];
    artistId = json['artist_id'];
    isPodcast = json['is_podcast'];
    bookmark = json['bookmark'];
    dateAdded = json['date_added'];
    isAudiobook = json['is_audiobook'];
    dateModified = json['date_modified'];
    albumId = json['album_id'];
    fileExtension = json['file_extension'];
    iId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_uri'] = sUri;
    data['artist'] = artist;
    data['year'] = year;
    data['is_music'] = isMusic;
    data['title'] = title;
    data['genre_id'] = genreId;
    data['_size'] = iSize;
    data['duration'] = duration;
    data['is_alarm'] = isAlarm;
    data['_display_name_wo_ext'] = sDisplayNameWoExt;
    data['album_artist'] = albumArtist;
    data['genre'] = genre;
    data['is_notification'] = isNotification;
    data['track'] = track;
    data['_data'] = sData;
    data['_display_name'] = sDisplayName;
    data['album'] = album;
    data['composer'] = composer;
    data['is_ringtone'] = isRingtone;
    data['artist_id'] = artistId;
    data['is_podcast'] = isPodcast;
    data['bookmark'] = bookmark;
    data['date_added'] = dateAdded;
    data['is_audiobook'] = isAudiobook;
    data['date_modified'] = dateModified;
    data['album_id'] = albumId;
    data['file_extension'] = fileExtension;
    data['_id'] = iId;
    return data;
  }
}
