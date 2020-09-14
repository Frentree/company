import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class FirebaseAuthProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser _user;
  bool _isPhoneVerify = false;

  FirebaseAuthProvider() {
    _prepareUser();
  }

  FirebaseUser getUser() {
    return _user;
  }

  void setUer(FirebaseUser value){
    _user = value;
    notifyListeners();
  }

  void _prepareUser() {
    _firebaseAuth.currentUser().then((FirebaseUser currentUser){
      setUer(currentUser);
    });
  }

  String _lastFirebaseResponse = ""; //Firebase 마지막 메시지(이메일 중복 체크 용)

  Future<bool> signUpWithEmail(String mail, String password) async {
    try {
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: mail,
          password: password
      );

      if(result.user != null) {
        return true;
      }

      return false;

    } on PlatformException catch (e) {
      setLastFirebaseMessage(e.code);
      return false;
    }
  }

  setLastFirebaseMessage(String message){
    _lastFirebaseResponse = message;
  }

  getLastFirebaseMessage() {
    String returnValue = _lastFirebaseResponse;
    _lastFirebaseResponse = null;
    return returnValue;
  }

  Future<bool> singInWithEmail(String mail, String password) async {
    try{
      var result = await _firebaseAuth.signInWithEmailAndPassword(
          email: mail,
          password: password
      );

      if(result != null) {
        print("로그인 성공");
        setUer(result.user);
        return true;
      }
      return false;
    } on PlatformException catch (e) {
      print("로그인 실패");
      setLastFirebaseMessage(e.code);
      return false;
    }
  }

  Future<void> verifyPhone(String phoneNumber, String verificationId, bool test) async {
    final PhoneVerificationFailed verificationFailed = (AuthException authException){
      print("인증실패");
      setLastFirebaseMessage(authException.message);
      print(authException.message);
      return false;
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      print("코드 전송");
      verificationId = verId;
      _isPhoneVerify =  true;
      notifyListeners();
    };

    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: Duration(seconds: 30),
      verificationFailed:verificationFailed,
      codeSent: smsSent,
    );
  }

  bool getPhoneVerifyResult(){
    return _isPhoneVerify;
  }
}