//Flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//Firebase
import 'package:firebase_auth/firebase_auth.dart';


class FirebaseAuthProvider with ChangeNotifier {
  //Firebase 인증 instance
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //로그인한 사용자
  User _user;

  //유저 데이터 업데이트
  //UserUpdateInfo updateInfo = UserUpdateInfo();


  //폰 인증 여부 변수
  bool _isPhoneVerify = false;

  //인증 ID
  String verificationId;

  //Firebase 에서 마지막 전달받은 응답
  String _lastFirebaseResponse = "";

  //로그인한 사용자 가져오기
  User getUser() {
    return _user;
  }

  //로그인한 사용자 저장
  void setUer({User user}){
    _user = user;
    notifyListeners();
  }

  //마지막 응답 저장
  void setLastFirebaseMessage({String message}){
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
  Future<bool> signUpWithEmail({String mail, String password, String name}) async {
    try {
      UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: mail,
          password: password
      );

      if(result.user != null) {
        //updateInfo.displayName = name;
        result.user.updateProfile();
        return true;
      }

      return false;

    } on PlatformException catch (e) {
      setLastFirebaseMessage(message: e.code);
      return false;
    }
  }

  //이메일로 로그인
  Future<bool> singInWithEmail({String mail, String password}) async {
    debugPrint("signInWithEmail has been executed");
    try{
      debugPrint("try initiated");
      var result = await _firebaseAuth.signInWithEmailAndPassword(
          email: mail,
          password: password
      );
      if(result != null) {
        setUer(user: result.user);
        return true;
      }
      return false;
    } on PlatformException catch (e) {
      setLastFirebaseMessage(message: e.code);
      return false;
    }
  }

  //핸드폰 번호 인증
  Future<bool> verifyPhone({String phoneNumber}) async {
    print("min");
    //핸드폰 번호 인증이 실패했을 때
    final PhoneVerificationFailed verificationFailed = (FirebaseAuthException authException){
      print("인증 실패");
      setLastFirebaseMessage(message: authException.message);
      return false;
    };

    final PhoneVerificationCompleted verificationCompleted =(PhoneAuthCredential credential){
      return true;
    };

    //인증번호 전송
    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      print("코드 전송");
      verificationId = verId;
      _isPhoneVerify =  true;
      notifyListeners();
    };

    final PhoneCodeAutoRetrievalTimeout phoneCodeAutoRetrievalTimeout = (String verId) {
      setLastFirebaseMessage(message: "코드 전송에 실패했습니다.");
      return false;
    };

    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: "+82" + phoneNumber,
      timeout: Duration(seconds: 30),
      verificationFailed:verificationFailed,
      verificationCompleted: verificationCompleted,
      codeSent: smsSent,
      codeAutoRetrievalTimeout: phoneCodeAutoRetrievalTimeout,
    );

    return true;
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
  Future<bool> isVerifySuccess({String smsCode}) async {
    AuthCredential authCredential = await PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
    try {
      UserCredential result = await _firebaseAuth.signInWithCredential(authCredential);
      if(result != null){
        return true;
      }
      return false;
    } on PlatformException catch (e){
      setLastFirebaseMessage(message: e.code);
      return false;
    }
  }

  //패스워드 확인
  Future<bool> confirmPassword({String mail, String password, String name}) async {
    try {
      var result = await _firebaseAuth.signInWithEmailAndPassword(
          email: mail,
          password: password
      );
      if(result.user != null) {
        return true;
      } else {
        return false;
      }

    } on PlatformException catch (e) {
      setLastFirebaseMessage(message: e.code);
      return false;
    }
  }

  //패스워드 변경
  Future<bool> updatePassword({String mail, String password, String name}) async {
    try {
      _user.updatePassword(password);

      return true;

    } on PlatformException catch (e) {
      setLastFirebaseMessage(message: e.code);
      return false;
    }
  }
}