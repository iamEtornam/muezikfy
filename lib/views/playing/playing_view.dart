import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';
import 'package:muezikfy/models/song.dart';
import 'package:muezikfy/providers/auth_provider.dart';
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
  double _volumeValue = 0.0;
  late AnimationController _animationController;

  AnimatedIconData _animatedIcon = AnimatedIcons.pause_play;
  Duration? duration;

  void iconState() {
    if (authProvider!.audioPlayer.playing) {
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
      duration = await authProvider!.audioPlayer.setUrl(widget.song.sUri!);
      log('duration: $duration');

      if (authProvider!.audioPlayer.playing) {
        _animationController.forward();
        setState(() {
          _animatedIcon = AnimatedIcons.pause_play;
        });
        authProvider!.audioPlayer.stop();
        await authProvider!.removeNowPlaying(widget.song);
      } else {
        _animationController.reverse();
        setState(() {});
        authProvider!.audioPlayer.play();
        await authProvider!.saveNowPlaying(widget.song);
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
          return Column(
            children: <Widget>[
              Slider(
                onChanged: (val) async {
                  await authProvider!.audioPlayer
                      .seek(Duration(milliseconds: val.toInt()));

                  setState(() {});
                },
                value: calculateScaleValue(
                    (snapshot.data?.inMilliseconds ?? 0),
                    (authProvider!.audioPlayer.duration?.inMilliseconds ?? 100),
                    100),
                max: 100.0,
                min: 0.0,
                activeColor: Colors.black,
                divisions: 2,
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
          child: Marquee(
            text: widget.song.title ?? 'Unknown',
            scrollAxis: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            blankSpace: 100.0,
            velocity: 100.0,
            pauseAfterRound: const Duration(seconds: 3),
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
              onPressed: () async {
                if (authProvider!.audioPlayer.hasPrevious) {
                  await authProvider!.audioPlayer.seekToPrevious();
                }
              },
              icon: const Icon(
                Icons.fast_rewind,
                color: Colors.black,
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
                icon: AnimatedIcon(
                  progress: _animationController,
                  icon: _animatedIcon,
                  color: Colors.black,
                  size: 60.0,
                ),
              ),
            ),
            const SizedBox(
              width: 15.0,
            ),
            IconButton(
              onPressed: () async {
                if (authProvider!.audioPlayer.hasNext) {
                  await authProvider!.audioPlayer.seekToNext();
                }
              },
              icon: const Icon(
                Icons.fast_forward,
                color: Colors.black,
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
    return Stack(
      alignment: Alignment.centerLeft,
      children: <Widget>[
        const Icon(
          Icons.volume_mute,
          color: Colors.black,
          size: 15,
        ),
        Positioned(
          left: 15.0,
          right: 15.0,
          child: Slider(
            onChanged: (val) async {
              await authProvider!.audioPlayer.setVolume(_volumeValue);

              setState(() {
                _volumeValue = val;
              });
            },
            value: _volumeValue,
            max: 100.0,
            min: 0.0,
            activeColor: Colors.black,
            divisions: 2,
            inactiveColor: Colors.black38,
            onChangeStart: (val) {
              setState(() {
                _volumeValue = val;
              });
            },
            onChangeEnd: (val) {
              setState(() {
                _volumeValue = val;
              });
            },
          ),
        ),
        const Align(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.volume_up,
            color: Colors.black,
            size: 15,
          ),
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
              color: Colors.black,
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
            await authProvider!.audioPlayer.shuffle();
          },
          icon: const Icon(
            SimpleLineIcons.shuffle,
            color: Colors.black,
            size: 20.0,
          ),
        ),
        IconButton(
          onPressed: () async {},
          icon: const Icon(
            Feather.more_horizontal,
            color: Colors.black,
            size: 20.0,
          ),
        )
      ],
    );
  }
}
