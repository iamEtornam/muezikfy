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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_uri'] = this.sUri;
    data['artist'] = this.artist;
    data['year'] = this.year;
    data['is_music'] = this.isMusic;
    data['title'] = this.title;
    data['genre_id'] = this.genreId;
    data['_size'] = this.iSize;
    data['duration'] = this.duration;
    data['is_alarm'] = this.isAlarm;
    data['_display_name_wo_ext'] = this.sDisplayNameWoExt;
    data['album_artist'] = this.albumArtist;
    data['genre'] = this.genre;
    data['is_notification'] = this.isNotification;
    data['track'] = this.track;
    data['_data'] = this.sData;
    data['_display_name'] = this.sDisplayName;
    data['album'] = this.album;
    data['composer'] = this.composer;
    data['is_ringtone'] = this.isRingtone;
    data['artist_id'] = this.artistId;
    data['is_podcast'] = this.isPodcast;
    data['bookmark'] = this.bookmark;
    data['date_added'] = this.dateAdded;
    data['is_audiobook'] = this.isAudiobook;
    data['date_modified'] = this.dateModified;
    data['album_id'] = this.albumId;
    data['file_extension'] = this.fileExtension;
    data['_id'] = this.iId;
    return data;
  }
}
