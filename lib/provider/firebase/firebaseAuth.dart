//Flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//Firebase
import 'package:firebase_auth/firebase_auth.dart';


class FirebaseAuthProvider with ChangeNotifier {
  //Firebase 인증 instance
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //로그인한 사용자
  FirebaseUser _user;

  //폰 인증 여부 변수
  bool _isPhoneVerify = false;

  //인증 ID
  String verificationId;

  //Firebase 에서 마지막 전달받은 응답
  String _lastFirebaseResponse = "";

  FirebaseAuthProvider() {
    _prepareUser();
  }

  //로그인한 사용자 가져오기
  FirebaseUser getUser() {
    return _user;
  }

  //로그인한 사용자 저장
  void setUer(FirebaseUser value){
    _user = value;
    notifyListeners();
  }

  //최근 로그인한 사용자 저장
  void _prepareUser() {
    _firebaseAuth.currentUser().then((FirebaseUser currentUser){
      setUer(currentUser);
    });
  }

  //마지막 응답 저장
  void setLastFirebaseMessage(String message){
    _lastFirebaseResponse = message;
  }

  //마지막 응답 가져오기
  String getLastFirebaseMessage() {
    String returnValue = _lastFirebaseResponse;
    _lastFirebaseResponse = null;
    return returnValue;
  }

  //Firebase 에러 메시지 처리
  String manageErrorMessage() {
    String test = getLastFirebaseMessage();

    switch(test) {
      case 'ERROR_INVALID_VERIFICATION_CODE' :
        return '인증 코드를 다시 확인해 주세요.';
        break;

      case "ERROR_EMAIL_ALREADY_IN_USE" :
        return '이미 사용 중인 이메일 입니다.';
        break;

      case 'ERROR_WRONG_PASSWORD' :
      case 'ERROR_USER_NOT_FOUND' :
        return '이메일 또는 비밀번호가 올바르지 않습니다';
        break;

      default :
        return '오류가 발생했습니다.';
        break;
    }
  }

  //이메일로 회원 가입
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
      print(e.code);
      setLastFirebaseMessage(e.code);
      return false;
    }
  }

  //이메일로 로그인
  Future<bool> singInWithEmail(String mail, String password) async {
    try{
      var result = await _firebaseAuth.signInWithEmailAndPassword(
          email: mail,
          password: password
      );

      if(result != null) {
        setUer(result.user);
        return true;
      }
      return false;
    } on PlatformException catch (e) {
      print(e.code);
      setLastFirebaseMessage(e.code);
      return false;
    }
  }

  //핸드폰 번호 인증
  Future<void> verifyPhone(String phoneNumber) async {
    //핸드폰 번호 인증이 실패했을 때
    final PhoneVerificationFailed verificationFailed = (AuthException authException){
      setLastFirebaseMessage(authException.message);
      return false;
    };

    //인증번호 전송
    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      verificationId = verId;
      _isPhoneVerify =  true;
      notifyListeners();
    };

    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: "+82" + phoneNumber,
      timeout: Duration(seconds: 30),
      verificationFailed:verificationFailed,
      codeSent: smsSent,
    );
  }

  //핸드폰 인증 결과 가져오기
  bool getPhoneVerifyResult(){
    return _isPhoneVerify;
  }

  //핸드폰 인증 결과 초기화
  void setPhonVerifyResultFalse(){
    _isPhoneVerify = false;
    notifyListeners();
  }

  //인증번호 인증
  Future<bool> isVerifySuccess(String smsCode) async {
    AuthCredential authCredential = await PhoneAuthProvider.getCredential(verificationId: verificationId, smsCode: smsCode);
    try {
      AuthResult result = await _firebaseAuth.signInWithCredential(authCredential);
      if(result != null){
        return true;
      }
      return false;
    } on PlatformException catch (e){
      print(e.code);
      setLastFirebaseMessage(e.code);
      return false;
    }
  }
}