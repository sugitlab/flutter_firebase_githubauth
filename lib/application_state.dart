import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:github_sign_in/github_sign_in.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp();

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loginState = ApplicationLoginState.loggedIn;
      } else {
        _loginState = ApplicationLoginState.loggedOut;
      }
      notifyListeners();
    });
  }

  ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;
  ApplicationLoginState get loginState => _loginState;

  void signIn(BuildContext context) async {
    try {
      var userCred = await signInWithGitHub(context);
      print(userCred.user);
    } on FirebaseAuthException catch (e) {}
  }

  Future<UserCredential> signInWithGitHub(BuildContext context) async {
    final GitHubSignIn gitHubSignIn = GitHubSignIn(
      clientId: '738724722abe75924f46',
      clientSecret: '8a2b978578f66710649f8f0ef2e675b63fc221f0',
      redirectUrl: 'https://fir-flutter-codelab-b8b32.firebaseapp.com/__/auth/handler',
    );
    final result = await gitHubSignIn.signIn(context);
    final AuthCredential githubAuthCredential = GithubAuthProvider.credential(result.token);
    return await FirebaseAuth.instance.signInWithCredential(githubAuthCredential);
  }
}

enum ApplicationLoginState {
  loggedOut,
  loggedIn,
}
