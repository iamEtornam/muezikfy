import 'dart:io';

import 'package:easy_permission_validator/easy_permission_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';
import 'package:muezikfy/models/song.dart';
import 'package:muezikfy/services/songs_persistence_service.dart';
import 'package:muezikfy/shared_widgets/custom_progress_indicator.dart';
import 'package:muezikfy/shared_widgets/song_list_tile.dart';
import 'package:muezikfy/shared_widgets/status_friends_widget.dart';
import 'package:muezikfy/utilities/ui_util.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final SongsPersistenceService _songsPersistenceService =
      SongsPersistenceService();
  final AudioPlayer player = AudioPlayer();
  final ScrollController _scrollController = ScrollController();
  UniqueKey _listViewKey = UniqueKey();
  bool isSelected = false;
  int? _currentIndex;
  Song? song;
  Duration? duration;
  late BuildContext buildContext;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      requestStoragePermission(buildContext);
    });
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MUEZIKFY',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                firebaseAuth.signOut();
              })
        ],
      ),
      drawer: Drawer(),
      body: ListView(
        controller: _scrollController,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: Text(
              'what are your friends listening to?',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontWeight: FontWeight.normal),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 16,
              top: 6,
            ),
            child: SizedBox(
              height: 110,
              width: size.width,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 20,
                  itemBuilder: (context, index) =>
                      StatusFriendsWidget(avatar: '', name: 'Kofi')),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: Text(
              'Songs',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Platform.isIOS
              ? Column(
                  children: [Text('No songs here')],
                )
              : FutureBuilder<List<Song>>(
                  future: _songsPersistenceService.getAllSongs(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting &&
                        snapshot.data == null) {
                      return CustomProgressIndicator();
                    }

                    return ListView.separated(
                        key: _listViewKey,
                        controller: _scrollController,
                        padding: EdgeInsets.fromLTRB(16, 10, 16, 24),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return SongListTile(
                            songTitle: snapshot.data?[index].title ?? 'unknown',
                            songDuration: duration == null
                                ? parseToMinutesSeconds(
                                    snapshot.data?[index].duration ?? 0)
                                : parseToMinutesSeconds(
                                    duration?.inMilliseconds ?? 0),
                            songCover: snapshot.data![index].audioId!,
                            songArtise:
                                snapshot.data?[index].artist ?? 'unknown',
                            isSelected: _isThisCitizenSelected(index),
                            onTap: () async {
                              _tapped(index);
                              playSong(songPath: snapshot.data![index].data!);
                              setState(() {
                                song = snapshot.data![index];
                              });
                            },
                          );
                        },
                        separatorBuilder: (_, __) => SizedBox(
                              height: 10,
                            ),
                        itemCount:
                            snapshot.data == null ? 0 : snapshot.data!.length);
                  })
        ],
      ),
      bottomNavigationBar: song == null
          ? SizedBox()
          : GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/playingView'),
              onVerticalDragStart: (details) =>
                  Navigator.pushNamed(context, '/playingView'),
              child: Hero(
                tag: 'to_playing',
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 5000),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.all(10),
                  width: size.width,
                  height: 90,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                        Colors.orangeAccent.withOpacity(.5),
                        Colors.orangeAccent.withOpacity(.5),
                        Colors.orangeAccent.withOpacity(.5),
                        Colors.orange.withOpacity(.5),
                        Colors.orangeAccent.withOpacity(.5),
                      ])),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: QueryArtworkWidget(
                          id: song!.audioId!,
                          type: ArtworkType.AUDIO,
                          size: 60,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: size.width - 245,
                            height: 25,
                            child: Marquee(
                              text: song!.title!,
                              scrollAxis: Axis.horizontal,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              blankSpace: 100.0,
                              velocity: 100.0,
                              pauseAfterRound: Duration(seconds: 3),
                              accelerationDuration: Duration(seconds: 2),
                              accelerationCurve: Curves.linear,
                              decelerationDuration: Duration(milliseconds: 500),
                              decelerationCurve: Curves.easeOut,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(
                            width: size.width - 245,
                            child: Text(
                              song?.artist ?? 'unknown',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(fontWeight: FontWeight.normal),
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Row(
                        children: [
                          IconButton(
                              icon: Icon(Icons.skip_previous_rounded),
                              onPressed: () {}),
                          InkWell(
                            onTap: () {},
                            child: Container(
                              width: 45,
                              height: 45,
                              child: Icon(
                                Icons.pause,
                                color: Colors.white,
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(90),
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.deepOrangeAccent.withOpacity(.5),
                                        Colors.deepOrangeAccent.withOpacity(.5),
                                        Colors.deepOrangeAccent,
                                        Colors.deepOrange,
                                      ])),
                            ),
                          ),
                          IconButton(
                              icon: Icon(Icons.skip_next), onPressed: () {}),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  bool _isThisCitizenSelected(int index) {
    if (_currentIndex == null) {
      return false;
    }

    if (_currentIndex == index) {
      return true;
    }

    return false;
  }

  void _tapped(int index) {
    _currentIndex = index;
    _listViewKey = UniqueKey();

    setState(() {});
  }

  void playSong({required String songPath}) async {
    print(songPath);
    duration = await player.setFilePath(songPath);
    if (player.playing) {
      player.stop();
      player.play();
    } else {
      player.play();
    }

    player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        duration = null;
      }
    });
    print('*********************');
    print(player.duration);
    print(duration);
  }

  requestStoragePermission(BuildContext context) async {
    final permissionValidator = EasyPermissionValidator(
      context: context,
      appName: 'Easy Permission Validator',
    );
    await permissionValidator.storage();
  }
}
