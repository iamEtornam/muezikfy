import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:marquee/marquee.dart';
import 'package:muezikfy/models/song.dart';
import 'package:muezikfy/providers/auth_provider.dart';
import 'package:muezikfy/utilities/color_schemes.dart';
import 'package:muezikfy/utilities/ui_util.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class PlayingView extends StatefulWidget {
  const PlayingView({super.key, required this.song});

  final Song song;

  @override
  State<PlayingView> createState() => _PlayingViewState();
}

class _PlayingViewState extends State<PlayingView> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'to_playing',
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            'PLAYING',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        body: _PlayerPage(widget.song),
      ),
    );
  }
}

class _PlayerPage extends StatefulWidget {
  const _PlayerPage(this.song);

  final Song song;

  @override
  State<_PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<_PlayerPage>
    with SingleTickerProviderStateMixin {
  AuthProvider? authProvider;
  late AnimationController _animationController;

  AnimatedIconData _animatedIcon = AnimatedIcons.pause_play;
  Duration? duration;

  void iconState() {
    if (authProvider!.audioPlayer.isPlaying()) {
      _animationController.forward();
      setState(() {
        _animatedIcon = AnimatedIcons.pause_play;
      });
    } else {
      _animationController.reverse();
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    iconState();
  }

  void playSong() async {
    try {
      log('songPath: ${widget.song.sUri}');

      List<AudioSource> audioSource = [];
      audioSource.add(AudioSource.uri(
        Uri.parse(widget.song.sUri!),
        tag: MediaItem(
          // Specify a unique ID for each media item:
          id: widget.song.iId.toString(),
          // Metadata to display in the notification:
          album: widget.song.album ?? 'unknown',
          title: widget.song.title ?? 'unknown',
          artUri: Uri.parse(widget.song.sUri ?? defaultArtWork),
        ),
      ));

      duration = await authProvider!.audioPlayer.setAudioSource(audioSource);
      log('duration: $duration');

      if (authProvider!.audioPlayer.isPlaying()) {
        _animationController.forward();
        setState(() {
          _animatedIcon = AnimatedIcons.pause_play;
        });
        authProvider!.audioPlayer.stopAudio();
        await authProvider!.removeNowPlaying(widget.song);
      } else if (authProvider!.audioPlayer.isPaused()) {
        _animationController.reverse();
        setState(() {});
        authProvider!.audioPlayer.playAudio();
        await authProvider!.saveNowPlaying(widget.song);
      } else {
        setState(() {});
        authProvider!.audioPlayer.stopAudio();
        await authProvider!.removeNowPlaying(widget.song);
      }

      authProvider!.audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          duration = null;
        }
      });
      setState(() {});
    } catch (e) {
      log('songPath error: $e');
    }
  }

  void previous() async {
    if (authProvider!.audioPlayer.hasPrevious) {
      authProvider!.audioPlayer.stopAudio();
      await authProvider!.audioPlayer.previous;
      playSong();
    }
  }

  void next() async {
    if (authProvider!.audioPlayer.hasNext) {
      authProvider!.audioPlayer.stopAudio();
      await authProvider!.audioPlayer.next;
      playSong();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          child: Center(
            child: QueryArtworkWidget(
              id: widget.song.iId!,
              type: ArtworkType.AUDIO,
              quality: 100,
              artworkQuality: FilterQuality.high,
              artworkFit: BoxFit.cover,
              artworkHeight: MediaQuery.of(context).size.height / 2,
              artworkWidth: MediaQuery.of(context).size.width,
              size: MediaQuery.of(context).size.height ~/ 2,
              errorBuilder: (p0, p1, p2) {
                return CachedNetworkImage(imageUrl: defaultArtWork);
              },
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          height: MediaQuery.of(context).size.height / 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              musicSeeker(),
              trackDetails(),
              trackControllers(),
              volumnController(),
              additionalOptions()
            ],
          ),
        ),
      ),
    );
  }

  Widget musicSeeker() {
    return StreamBuilder<Duration>(
        stream: authProvider!.audioPlayer.positionStream,
        builder: (context, snapshot) {
          final currentPosition = calculateScaleValue(
              (snapshot.data?.inMilliseconds ?? 0),
              (authProvider!.audioPlayer.duration?.inMilliseconds ?? 100),
              100);
          return Column(
            children: <Widget>[
              Slider(
                onChanged: (val) async {
                  await authProvider!.audioPlayer
                      .seekAudio(Duration(milliseconds: val.toInt()));

               
                },
                value: double.parse(currentPosition.toStringAsFixed(1)),
                max: 100.0,
                min: 0.0,
                activeColor: colorMain,
                inactiveColor: Colors.black38,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  StreamBuilder<Duration>(
                      stream: authProvider!.audioPlayer.positionStream,
                      builder: (context, snapshot) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                              parseToMinutesSeconds(
                                  snapshot.data?.inMilliseconds ?? 0),
                              style: const TextStyle(
                                  fontSize: 12.0, color: Colors.black26)),
                        );
                      }),
                  StreamBuilder<Duration?>(
                      stream: authProvider!.audioPlayer.durationStream,
                      builder: (context, snapshot) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Text(
                              '-${parseToMinutesSeconds(snapshot.data?.inMilliseconds ?? 0)}',
                              style: const TextStyle(
                                  fontSize: 12.0, color: Colors.black26)),
                        );
                      })
                ],
              )
            ],
          );
        });
  }

  Widget trackDetails() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 25,
          width: MediaQuery.sizeOf(context).width,
          child: Marquee(
            text: widget.song.title ?? 'Unknown',
            scrollAxis: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            blankSpace: 100.0,
            velocity: 100.0,
            pauseAfterRound: const Duration(seconds: 0),
            accelerationDuration: const Duration(seconds: 2),
            accelerationCurve: Curves.linear,
            decelerationDuration: const Duration(milliseconds: 500),
            decelerationCurve: Curves.easeOut,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
        ),
        Text(
          '${widget.song.artist}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16.0, color: Colors.black38),
        )
      ],
    );
  }

  Widget trackControllers() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            const Spacer(),
            IconButton(
              onPressed: previous,
              icon: const Icon(
                Icons.fast_rewind,
                size: 50.0,
              ),
            ),
            const SizedBox(
              width: 15.0,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 5.0, bottom: 5.0),
              child: IconButton(
                onPressed: () {
                  playSong();
                },
                icon: authProvider!.audioPlayer.isStopped()
                    ? const Icon(
                        Icons.stop,
                        size: 60.0,
                      )
                    : AnimatedIcon(
                        progress: _animationController,
                        icon: _animatedIcon,
                        size: 60.0,
                      ),
              ),
            ),
            const SizedBox(
              width: 15.0,
            ),
            IconButton(
              onPressed: next,
              icon: const Icon(
                Icons.fast_forward,
                size: 50.0,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget volumnController() {
    return Row(
      children: <Widget>[
        const Icon(
          Icons.volume_mute,
          size: 15,
        ),
        Expanded(
          child: StreamBuilder<double>(
              stream: authProvider!.audioPlayer.volumnStream(),
              builder: (context, snapshot) {
            
                return Slider(
                  onChanged: (val) async {
                    await authProvider!.audioPlayer.setVolume(val);
                  },
                  value: snapshot.data ?? 0.0,
                  max: 100.0,
                  min: 0.0,
                  activeColor: Colors.black,
                  inactiveColor: Colors.black38,
                );
              }),
        ),
        const Icon(
          Icons.volume_up,
          size: 15,
        ),
      ],
    );
  }

  Widget additionalOptions() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
            onPressed: () {},
            icon: const Icon(
              MaterialIcons.favorite_border,
              size: 20.0,
            )),
        IconButton(
            onPressed: () async {
              await authProvider!.audioPlayer.setLoopMode(LoopMode.one);
            },
            icon: const Icon(
              Feather.repeat,
              color: Colors.black,
              size: 20.0,
            )),
        IconButton(
          onPressed: () async {
            await authProvider!.audioPlayer.shuffle;
          },
          icon: const Icon(
            SimpleLineIcons.shuffle,
            size: 20.0,
          ),
        ),
        IconButton(
          onPressed: () async {},
          icon: const Icon(
            Feather.more_horizontal,
            size: 20.0,
          ),
        )
      ],
    );
  }
}
