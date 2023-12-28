import 'package:just_audio/just_audio.dart';

class MyAudioPlayer {
  static final MyAudioPlayer _instance = MyAudioPlayer._internal();

  factory MyAudioPlayer() => _instance;
  late AudioPlayer _audioPlayer;

  MyAudioPlayer._internal() {
    _audioPlayer = AudioPlayer();
  }

  bool isPlaying() => _audioPlayer.playing;

  int? currentAudioIndex() => _audioPlayer.currentIndex;

  currentAudioStream() => _audioPlayer.currentIndexStream;

  bool isPaused() => _audioPlayer.position != _audioPlayer.duration;

  bool isStopped() => _audioPlayer.position == _audioPlayer.duration;

  setLoopMode(LoopMode mode) => _audioPlayer.setLoopMode(mode);

  playAudio() => _audioPlayer.play();

  pauseAudio() => _audioPlayer.pause();

  stopAudio() => _audioPlayer.stop();

  seekAudio(Duration position) => _audioPlayer.seek(position);

  setVolume(double volume) => _audioPlayer.setVolume(volume);

  setSpeed(double speed) => _audioPlayer.setSpeed(speed);

  Future<Duration?> setAudioSource(List<AudioSource> mediaItems,
          {int? selectedIndex = 0}) =>
      _audioPlayer.setAudioSource(
          ConcatenatingAudioSource(
              children: mediaItems.map((mediaItem) => mediaItem).toList()),
          initialIndex: selectedIndex);

  get duration => _audioPlayer.duration;

  get position => _audioPlayer.position;

  get bufferedPosition => _audioPlayer.bufferedPosition;

  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;

  get positionStream => _audioPlayer.positionStream;

  get bufferedPositionStream => _audioPlayer.bufferedPositionStream;

  get durationStream => _audioPlayer.durationStream;

  bool get hasNext => _audioPlayer.hasNext;

  bool get hasPrevious => _audioPlayer.hasPrevious;

  Future<void>  get next => _audioPlayer.seekToNext();

  Future<void> get previous => _audioPlayer.seekToPrevious();

  Future<void> get shuffle => _audioPlayer.shuffle();

  volumnStream() => _audioPlayer.volumeStream;
}
