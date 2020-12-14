import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:muezikfy/services/songs_persistence_service.dart';
import 'package:muezikfy/shared_widgets/custom_progress_indicator.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  final SongsPersistenceService _songsPersistenceService = SongsPersistenceService();

  @override
  void initState() {
    loginAuthState();
    super.initState();
  }

  Future loginAuthState() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    if (_firebaseAuth?.currentUser != null) {
      List<SongInfo> songs = await audioQuery.getSongs();

      await _songsPersistenceService.insertSongs(songs: songs);
      Navigator.pushNamedAndRemoveUntil(
          context, '/homeView', (route) => false);
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
