import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:muezikfy/models/person.dart';
import 'package:muezikfy/models/song.dart';
import 'package:muezikfy/services/my_audio_player.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<bool> signInWithApple() async {
    bool isSuccessful = false;

    try {
      final authResult =
          await _firebaseAuth.signInWithProvider(AppleAuthProvider());
      final firebaseUser = authResult.user;
      isSuccessful = firebaseUser != null;
    } catch (e) {
      isSuccessful = false;
    }
    return isSuccessful;
  }

  Future<bool> signInWithGoogle() async {
    bool isSuccessful = false;
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final user = userCredential.user;
      final displayName = googleUser?.displayName?.split(' ');
      final photoUrl = googleUser?.photoUrl;
      final email = googleUser?.email;

      await updateUser(Person(
        firstName: displayName![0],
        lastName: displayName[displayName.length - 1],
        photoUrl: photoUrl ?? '',
        email: email!,
        createdAt: DateTime.now().toString(),
        userId: user!.uid,
        discoverable: true,
      ));

      isSuccessful = true;
    } catch (e) {
      isSuccessful = false;
    }
    return isSuccessful;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  String? get currentUserId => _firebaseAuth.currentUser?.uid;

  String? get currentEmail => _firebaseAuth.currentUser?.email;

  String? get currentDisplayName => _firebaseAuth.currentUser?.displayName;

  String? get currentPhotoUrl => _firebaseAuth.currentUser?.photoURL;

  String? get currentPhoneNumber => _firebaseAuth.currentUser?.phoneNumber;

  MyAudioPlayer get audioPlayer => MyAudioPlayer();

  OnAudioQuery get audioQuery => OnAudioQuery();

  Stream<DocumentSnapshot<Map<String, dynamic>>> get getFriends =>
      _firestore.collection('persons').doc(currentUserId).snapshots();

  Query<Map<String, dynamic>> get personsQuery => _firestore
      .collection('persons')
      .where('discoverable', isEqualTo: true)
      .where('user_id', isNotEqualTo: currentUserId!);

  Future<Person?> getUser() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('persons').doc(currentUserId).get();
    if (snapshot.exists) {
      return Person.fromJson(snapshot.data()!);
    } else {
      return null;
    }
  }

  Future<void> updateUser(Person person) async {
    return _firestore
        .collection('persons')
        .doc(currentUserId)
        .set(person.toJson(), SetOptions(merge: true));
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getFriendProfile(
      String friendId) {
    return _firestore.collection('persons').doc(currentUserId).snapshots();
  }

  Future<String> uploadPhoto(
      {required Uint8List file, required String path}) async {
    final storageRef = _firebaseStorage.ref();

    final fileName = path.split('/').last;

    final imageRef = storageRef.child(fileName);
    await imageRef.putData(file);
    final downloadUrl = await imageRef.getDownloadURL();
    return downloadUrl;
  }

  Future<void> addPersonAsFriend(String friendId) {
    return _firestore.collection('persons').doc(currentUserId).update({
      'friends': FieldValue.arrayUnion([friendId])
    });
  }

  Future<void> removePersonAsFriend(String friendId) {
    return _firestore.collection('persons').doc(currentUserId).update({
      'friends': FieldValue.arrayRemove([friendId])
    });
  }

  Future<void> saveNowPlaying(Song song) async {
    return await _firestore
        .collection('now_playing')
        .doc(currentUserId)
        .set(song.toJson(), SetOptions(merge: true));
  }

  Future<void> removeNowPlaying(Song song) async {
    return await _firestore
        .collection('now_playing')
        .doc(currentUserId)
        .delete();
  }

  Future<Song?> getNowPlaying(String friendId) async {
    final snapshot =
        await _firestore.collection('now_playing').doc(friendId).get();
    if (snapshot.exists) {
      return Song.fromJson(snapshot.data()!);
    } else {
      return null;
    }
  }

  Future<void> uploadSong(
      {required Uint8List file, required String path}) async {
    final storageRef = _firebaseStorage.ref();

    final fileName = path.split('/').last;

    final imageRef = storageRef.child('songs/$fileName');
    await imageRef.putData(file);
    final downloadUrl = await imageRef.getDownloadURL();
    return await _firestore.collection('now_playing').doc(currentUserId).set({
      '_uri': downloadUrl,
    }, SetOptions(merge: true));
  }

  Future<bool> hasPermission() async {
    final hasPermission = await audioQuery.checkAndRequest(
      retryRequest: true,
    );
    return hasPermission;
  }
}
