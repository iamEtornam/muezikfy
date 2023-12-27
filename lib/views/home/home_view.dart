import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:marquee/marquee.dart';
import 'package:muezikfy/models/song.dart';
import 'package:muezikfy/providers/auth_provider.dart';
import 'package:muezikfy/resources/resources.dart';
import 'package:muezikfy/routes.dart';
import 'package:muezikfy/services/songs_persistence_service.dart';
import 'package:muezikfy/shared_widgets/custom_progress_indicator.dart';
import 'package:muezikfy/shared_widgets/song_list_tile.dart';
import 'package:muezikfy/shared_widgets/status_friends_widget.dart';
import 'package:muezikfy/utilities/color_schemes.dart';
import 'package:muezikfy/utilities/ui_util.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final SongsPersistenceService _songsPersistenceService =
      SongsPersistenceService();
  final ScrollController _scrollController = ScrollController();
  UniqueKey _listViewKey = UniqueKey();
  bool isSelected = false;
  int? _currentIndex;
  final selectedSongListner = ValueNotifier<Song?>(null);
  Duration? duration;
  AuthProvider? authProvider;
  List<AudioSource> audioSource = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      authProvider = Provider.of<AuthProvider>(context, listen: false);
      setState(() {});
      final person = await authProvider!.getUser();
      if (!mounted) return;
      if (person == null) {
        GoRouter.of(context).goNamed(RoutesName.profile);
        return;
      }
      final storagePermission = await requestStoragePermission(context);

      if (storagePermission) {
        fetchSongs();
      }
      fetchSongs();
    });
  }

  fetchSongs() async {
    List<SongModel> songs = await authProvider!.audioQuery.querySongs();
    log("querySongs ${songs.length}");
    await _songsPersistenceService.insertSongs(songs: songs);
    audioSource = [];
    audioSource.addAll(songs.map((e) => AudioSource.file(
          e.data,
          tag: MediaItem(
            // Specify a unique ID for each media item:
            id: e.id.toString(),
            // Metadata to display in the notification:
            album: e.album ?? 'unknown',
            title: e.title,
            artUri: Uri.parse(e.uri ?? defaultArtWork),
          ),
        )));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    log('isplay ${authProvider?.audioPlayer.isPlaying()}');
    return authProvider == null
        ? const Scaffold(body: CustomProgressIndicator())
        : ValueListenableBuilder<Song?>(
            valueListenable: selectedSongListner,
            builder: (context, selectedSong, _) {
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
                    IconButton(
                        icon: const Icon(Icons.search), onPressed: () {}),
                    IconButton(
                        icon: const Icon(Icons.logout_rounded),
                        onPressed: () {
                          _songsPersistenceService.deleteDatabase();
                          authProvider!.signOut();
                          context.goNamed(RoutesName.login);
                        })
                  ],
                ),
                drawer: Drawer(
                    child: ListView(
                  children: [
                    UserAccountsDrawerHeader(
                      decoration:
                          BoxDecoration(color: colorMain.withOpacity(.3)),
                      currentAccountPicture: CachedNetworkImage(
                        imageUrl: authProvider!.currentPhotoUrl ?? '',
                        width: 80,
                        height: 80,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey.withOpacity(.3), width: 1.0),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(90.0)),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator.adaptive(
                                    value: downloadProgress.progress),
                        errorWidget: (context, url, error) => CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey.withOpacity(.3),
                          child: SvgPicture.asset(Svgs.person),
                        ),
                        fit: BoxFit.cover,
                        color: const Color(0xFFF5F5F5),
                      ),
                      accountName: Text(
                        authProvider!.currentDisplayName ?? 'unknown',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      accountEmail: Text(
                        authProvider!.currentEmail ?? 'unknown',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 13, fontWeight: FontWeight.w400),
                      ),
                    ),
                    ListTile(
                        onTap: () {
                          GoRouter.of(context).pushNamed(RoutesName.profile);
                        },
                        leading: const Icon(Icons.person),
                        title: const Text(
                          'Profile',
                        )),
                    const Divider()
                  ],
                )),
                body: RefreshIndicator.adaptive(
                  onRefresh: () async {
                    fetchSongs();
                    setState(() {});
                  },
                  child: ListView(
                    controller: _scrollController,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              'what are your friends listening to?',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontWeight: FontWeight.normal),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                            ),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () =>
                                      context.pushNamed(RoutesName.personList),
                                  borderRadius: BorderRadius.circular(10),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 70,
                                          height: 70,
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.grey,
                                                  width: 2)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: CircleAvatar(
                                              radius: 33,
                                              backgroundColor:
                                                  colorMain.withOpacity(.5),
                                              backgroundImage:
                                                  const ExactAssetImage(
                                                      Images.avatar),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        SizedBox(
                                            width: 90,
                                            child: Text(
                                              'Add friends',
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall,
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  height: 80,
                                  width: 1,
                                  color: Colors.grey,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: StreamBuilder<
                                          DocumentSnapshot<
                                              Map<String, dynamic>>>(
                                      stream: authProvider!.getFriends,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                                ConnectionState.waiting &&
                                            snapshot.data == null) {
                                          return const CustomProgressIndicator();
                                        }
                                        if (!snapshot.hasData) {
                                          return const SizedBox.shrink();
                                        }
                                        final friends =
                                            snapshot.data?.data()?['friends'];

                                        if (friends == null) {
                                          return const SizedBox.shrink();
                                        }
                                        return SizedBox(
                                          height: 110,
                                          width: size.width,
                                          child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: friends.length,
                                              itemBuilder: (context, index) =>
                                                  StatusFriendsWidget(
                                                    onTap: () async {
                                                      final mSong =
                                                          await authProvider!
                                                              .getNowPlaying(
                                                                  friends[
                                                                      index]);
                                                      if (mSong == null) return;
                                                      if (!mounted) return;
                                                      context.pushNamed(
                                                          RoutesName.playing,
                                                          extra: mSong);
                                                    },
                                                    friendId: friends[index],
                                                  )),
                                        );
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
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
                      FutureBuilder<List<Song>>(
                          future: _songsPersistenceService.getAllSongs(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.waiting &&
                                snapshot.data == null) {
                              return const CustomProgressIndicator();
                            }

                            final songs = snapshot.data ?? [];
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                songs.isEmpty) {
                              return const Center(
                                child: Text('No songs found'),
                              );
                            }

                            return StreamBuilder<int?>(
                                stream: authProvider!.audioPlayer
                                    .currentAudioStream(),
                                builder: (context, snapshot) {
                                  if (authProvider!.audioPlayer.isPlaying()) {
                                    _currentIndex = snapshot.data!;

                                    authProvider!.saveNowPlaying(selectedSong!);
                                    authProvider!.uploadSong(
                                        file: File(selectedSong.sData!)
                                            .readAsBytesSync(),
                                        path: selectedSong.sData!);
                                  }
                                  if (snapshot.data != null) {
                                    selectedSongListner.value =
                                        songs[snapshot.data!];
                                  }
                                  return ListView.separated(
                                      key: _listViewKey,
                                      controller: _scrollController,
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 10, 16, 24),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        final song = songs[index];
                                        return SongListTile(
                                          song: song,
                                          authProvider: authProvider!,
                                          isSelected:
                                              _isThisCitizenSelected(index),
                                          isPlaying: authProvider!.audioPlayer
                                              .isPlaying(),
                                          onTap: () async {
                                            _tapped(index);
                                            selectedSongListner.value = song;

                                            playSong();
                                          },
                                        );
                                      },
                                      separatorBuilder: (_, __) =>
                                          const SizedBox(
                                            height: 5,
                                          ),
                                      itemCount: songs.length);
                                });
                          })
                    ],
                  ),
                ),
                bottomNavigationBar: selectedSongListner.value == null
                    ? const SizedBox()
                    : GestureDetector(
                        onTap: () => context.pushNamed(RoutesName.playing,
                            extra: selectedSong),
                        onVerticalDragStart: (details) => context
                            .pushNamed(RoutesName.playing, extra: selectedSong),
                        child: Hero(
                          tag: 'to_playing',
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 5000),
                            curve: Curves.easeInOut,
                            padding: const EdgeInsets.all(10),
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
                                const SizedBox(
                                  width: 10,
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: QueryArtworkWidget(
                                    id: selectedSong!.iId!,
                                    type: ArtworkType.AUDIO,
                                    size: 60,
                                  ),
                                ),
                                const SizedBox(
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
                                        text: selectedSong.title!,
                                        scrollAxis: Axis.horizontal,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        blankSpace: 90.0,
                                        velocity: 100.0,
                                        pauseAfterRound:
                                            const Duration(seconds: 0),
                                        accelerationDuration:
                                            const Duration(seconds: 2),
                                        accelerationCurve: Curves.linear,
                                        decelerationDuration:
                                            const Duration(milliseconds: 500),
                                        decelerationCurve: Curves.easeOut,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    SizedBox(
                                      width: size.width - 245,
                                      child: Text(
                                        selectedSong.artist ?? 'unknown',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                                fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    IconButton(
                                        icon: const Icon(
                                            Icons.skip_previous_rounded),
                                        onPressed: previous),
                                    GestureDetector(
                                      onTap: () {
                                        playSong();
                                        setState(() {});
                                      },
                                      child: Container(
                                        width: 45,
                                        height: 45,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(90),
                                            gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Colors.deepOrangeAccent
                                                      .withOpacity(.5),
                                                  Colors.deepOrangeAccent
                                                      .withOpacity(.5),
                                                  Colors.deepOrangeAccent,
                                                  Colors.deepOrange,
                                                ])),
                                        child: Icon(
                                          authProvider!.audioPlayer.isPlaying()
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                        icon: const Icon(Icons.skip_next),
                                        onPressed: next),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
              );
            });
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

  void previous() async {
    if (authProvider!.audioPlayer.hasPrevious) {
      authProvider!.audioPlayer.stopAudio();
      _tapped((_currentIndex ?? 0) - 1);
      await authProvider!.audioPlayer.previous;
      playSong();
    }
  }

  void next() async {
    if (authProvider!.audioPlayer.hasNext) {
      authProvider!.audioPlayer.stopAudio();
      _tapped((_currentIndex ?? 0) + 1);
      await authProvider!.audioPlayer.next;
      playSong();
    }
  }

  void _tapped(int index) {
    _currentIndex = index;
    _listViewKey = UniqueKey();

    setState(() {});
  }

  void playSong() async {
    try {
      duration = await authProvider!.audioPlayer
          .setAudioSource(audioSource, selectedIndex: _currentIndex);
      log('duration: $duration');

      if (authProvider!.audioPlayer.isPlaying()) {
        authProvider!.audioPlayer.pauseAudio();
      } else if (authProvider!.audioPlayer.isPaused()) {
        authProvider!.audioPlayer.seekAudio(authProvider!.audioPlayer.position);
        authProvider!.audioPlayer.playAudio();
      } else {
        authProvider!.audioPlayer.playAudio();
        await authProvider!.saveNowPlaying(selectedSongListner.value!);
        await authProvider!.uploadSong(
            file: File(selectedSongListner.value!.sData!).readAsBytesSync(),
            path: selectedSongListner.value!.sData!);
      }
      authProvider!.audioPlayer.playerStateStream.listen((state) {
        if (authProvider!.audioPlayer.isPlaying()) {
          authProvider!.saveNowPlaying(selectedSongListner.value!);
          authProvider!.uploadSong(
              file: File(selectedSongListner.value!.sData!).readAsBytesSync(),
              path: selectedSongListner.value!.sData!);
        }
        if (state.processingState == ProcessingState.completed) {
          duration = null;
          authProvider!.audioPlayer.stopAudio();
          authProvider!.removeNowPlaying(selectedSongListner.value!);
        }
      });
      setState(() {});
    } catch (e) {
      log('songPath error: $e');
    }
  }

  Future<bool> requestStoragePermission(BuildContext context) async {
    return await authProvider!.hasPermission();
  }
}
