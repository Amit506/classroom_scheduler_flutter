

import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';




class AuthService  with ChangeNotifier{
final googleSignIn = GoogleSignIn();
static FirebaseAuth instance = FirebaseAuth.instance;

Stream<User> get  authState => instance.authStateChanges();

// GoogleSignInAccount get  currentUser => googleSignIn.currentUser;
User get currentUser => instance.currentUser;
Future<UserCredential> login() async{
    final GoogleSignInAccount user = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await user.authentication;
    final AuthCredential credential =  GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final UserCredential userCredential = await instance.signInWithCredential(credential);
    

  return userCredential;
}

logout() async{
  await instance.signOut();
  await googleSignIn.signOut();
  
}


}