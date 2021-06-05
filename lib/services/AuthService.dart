import 'dart:async';

import 'package:classroom_scheduler_flutter/Pages.dart/AuthenticationScreen.dart/LoginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService with ChangeNotifier {
  StreamSubscription<User> _subscription;
  bool _isSignedIn = false;
  AuthService() {
    _subscription = instance.authStateChanges().listen(
      (result) {
        _isSignedIn = result != null;
        notifyListeners();
      },
    );
  }
  bool get isSigned => _isSignedIn;

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  final googleSignIn = GoogleSignIn();
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static FirebaseAuth instance = FirebaseAuth.instance;
  static CollectionReference users = _firestore.collection('Users');
  Stream<User> get authState => instance.authStateChanges();

// GoogleSignInAccount get  currentUser => googleSignIn.currentUser;
  User get currentUser => instance.currentUser;
  Future<UserCredential> login() async {
    final GoogleSignInAccount user = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await user.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final UserCredential userCredential =
        await instance.signInWithCredential(credential);
    await users.doc(userCredential.user.uid).set({
      "userName": userCredential.user.displayName,
      "userEmail": userCredential.user.email,
      "phoneNumber": userCredential.user.phoneNumber,
      "photoUrl": userCredential.user.photoURL,
      "uid": userCredential.user.uid,
    });

    return userCredential;
  }

  Future logout(BuildContext context) async {
    await instance.signOut();
    await googleSignIn.signOut().then((value) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => LogInPage(),
          ),
          (route) => false);
    });
  }
}
