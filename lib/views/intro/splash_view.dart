import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muezikfy/services/songs_persistence_service.dart';
import 'package:muezikfy/shared_widgets/custom_progress_indicator.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final OnAudioQuery audioQuery = OnAudioQuery();
  final SongsPersistenceService _songsPersistenceService =
      SongsPersistenceService();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loginAuthState(context);
    });
    super.initState();
  }

  Future loginAuthState(BuildContext context) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    if (_firebaseAuth.currentUser != null) {
      List<AudioModel> songs = await audioQuery.queryAudios();

      await _songsPersistenceService.insertSongs(songs: songs);
      Navigator.pushNamedAndRemoveUntil(context, '/homeView', (route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, '/loginView', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Spacer(),
          CustomProgressIndicator(),
          SizedBox(
            height: 24,
          )
        ],
      ),
    );
  }
}
