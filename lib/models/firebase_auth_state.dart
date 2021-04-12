import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:instagram_clone_coding/repo/user_network_repository.dart';
import 'package:instagram_clone_coding/utils/simple_snackbar.dart';

class FirebaseAuthState extends ChangeNotifier {
  FirebaseAuthStatus _firebaseAuthStatus = FirebaseAuthStatus.progress;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User _firebaseUser;
  FacebookLogin _facebookLogin;

  void watchAuthChange() {
    _firebaseAuth.authStateChanges().listen((user) {
      if (user == null && _firebaseUser == null) {
        changeFirebaseAuthStatus();
        return;
      } else if (user != _firebaseUser) {
        _firebaseUser = user;
        changeFirebaseAuthStatus();
      }
    });
  }

  void registerUser(BuildContext context,
      {@required String email, @required String password}) async {
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(
            email: email.trim(), password: password.trim())
        .catchError((error) {
      print(error.code);

      String _message = "";
      switch (error.code) {
        case 'invalid-email':
          _message = "입력한 이메일 주소 유형을 확인해 주세요";
          break;
        case 'weak-password':
          _message = "대문자,소문자,숫자 그리고 특수문자를 활용해 비밀번호를 생성해 주세요";
          break;
        case 'operation-not-allowed':
          _message = "해당 이메일이 비활성화 상태입니다. 이메일을 확인해 주세요";
          break;
        case 'email-already-in-use':
          _message = "해당 이메일은 이미 사용중 입니다";
          break;
      }
      SnackBar snackBar = SnackBar(
        content: Text(_message),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });

    _firebaseUser = userCredential.user;
    if (_firebaseUser == null) {
      SnackBar snackBar = SnackBar(
        content: Text("로그인 정보를 다시 확인해 주세요"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      await userNetworkRepository.attemptCreateUser(
          userKey: _firebaseUser.uid, email: _firebaseUser.email);
    }
  }

  void login(BuildContext context,
      {@required String email, @required String password}) async {
    changeFirebaseAuthStatus(FirebaseAuthStatus.progress);
    UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(
            email: email.trim(), password: password.trim())
        .catchError((error) {
      print(error.code);
      changeFirebaseAuthStatus(FirebaseAuthStatus.signout);
      String _message = "";
      switch (error.code) {
        case 'invalid-email':
          _message = "입력한 이메일 주소 유형을 확인해 주세요";
          break;
        case 'user-disabled':
          _message = "해당 유저는 금지 됐습니다";
          break;
        case 'user-not-found':
          _message = "이메일을 찾을 수 없습니다";
          break;
        case 'wrong-password':
          _message = "비밀번호를 확인해 주세요";
          break;
      }
      print(_message);
      simpleSnackbar(context, _message);
      // SnackBar snackBar = SnackBar(
      //   content: Text(_message),
      // );
      // Scaffold.of(context).showSnackBar(snackBar);
    });

    if(userCredential != null) {
      _firebaseUser = userCredential.user;

      if (_firebaseUser == null) {
        simpleSnackbar(context, "로그인 정보를 다시 확인해 주세요");
      }
    }
  }

  void signOut() async {
    changeFirebaseAuthStatus(FirebaseAuthStatus.progress);
    _firebaseAuthStatus = FirebaseAuthStatus.signout;
    if (_firebaseUser != null) {
      _firebaseUser = null;
      if (await _facebookLogin.isLoggedIn) {
        await _facebookLogin.logOut();
      }
      await _firebaseAuth.signOut();
    }
    notifyListeners();
  }

  void changeFirebaseAuthStatus([FirebaseAuthStatus firebaseAuthStatus]) {
    if (firebaseAuthStatus != null) {
      _firebaseAuthStatus = firebaseAuthStatus;
    } else {
      if (_firebaseUser != null) {
        _firebaseAuthStatus = FirebaseAuthStatus.signin;
      } else {
        _firebaseAuthStatus = FirebaseAuthStatus.signout;
      }
    }
    notifyListeners();
  }

  void loginWithFacebook(BuildContext context) async {
    changeFirebaseAuthStatus(FirebaseAuthStatus.progress);

    if (_facebookLogin == null) _facebookLogin = FacebookLogin();
    final result = await _facebookLogin.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        _handleFacebookTokenWithFirebase(context, result.accessToken.token);
        break;
      case FacebookLoginStatus.cancelledByUser:
        simpleSnackbar(context, 'User cancel facebook sign in');
        break;
      case FacebookLoginStatus.error:
        simpleSnackbar(context, 'Facebook 로그인중 오류가 발생하였습니다');
        _facebookLogin.logOut();
        break;
    }
  }

  void _handleFacebookTokenWithFirebase(
      BuildContext context, String token) async {
    //todo: 토큰을 사용하여 파이어베이스로 로그인
    final AuthCredential credential = FacebookAuthProvider.credential(token);

    _firebaseUser =
        (await _firebaseAuth.signInWithCredential(credential)).user;

    if (_firebaseUser == null) {
      simpleSnackbar(context, 'Facebook 로그인에 실패하였습니다');
    } else {
      await userNetworkRepository.attemptCreateUser(
          userKey: _firebaseUser.uid, email: _firebaseUser.email);
    }
    notifyListeners();
  }

  FirebaseAuthStatus get firebaseAuthStatus => _firebaseAuthStatus;

  User get firebaseUser => _firebaseUser;
}

enum FirebaseAuthStatus { signout, progress, signin }
