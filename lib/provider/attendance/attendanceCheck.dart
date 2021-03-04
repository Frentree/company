//Flutter
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:ios_network_info/ios_network_info.dart';
import 'package:wifi/wifi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' as foundation;

//Firebase
import 'package:cloud_firestore/cloud_firestore.dart';

//Model
import 'package:MyCompany/models/attendanceModel.dart';
import 'package:MyCompany/models/userModel.dart';

//Utils
import 'package:MyCompany/utils/date/dateFormat.dart';

//Widget
import 'package:MyCompany/widgets/button/textButton.dart';

import 'package:sizer/sizer.dart';



class AttendanceCheck extends ChangeNotifier {
  Format _format = Format();

  List<String> wifiList = [];
  List<String> tempDocumentId = [];

  //로그인 사용자 정보 저장
  User _loginUser;

  FirebaseRepository _repository = FirebaseRepository();

  //출퇴근 정보 저장
  Attendance _attendance = Attendance();

  //출퇴근 데이터 가져오기
  Attendance getAttendanceData() {
    return _attendance;
  }

  //출퇴근 데이터 저장
  void setAttendanceData(Attendance value) {
    _attendance = value;
    notifyListeners();
  }

  //출근 체크
  Future<Attendance> attendanceCheck() async {
    tempDocumentId = [];
    //자동 로그인 정보를 가져온다
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    if (_sharedPreferences.getString("loginUser") != null) {
      dynamic decodeData =
          jsonDecode(_sharedPreferences.getString("loginUser"));
      decodeData["createDate"] =
          _format.dateTimeToTimeStamp(DateTime.parse(decodeData["createDate"]));
      decodeData["lastModDate"] = _format
          .dateTimeToTimeStamp(DateTime.parse(decodeData["lastModDate"]));

      _loginUser = User.fromMap(decodeData, null);
    } else {
      return null;
    }

    wifiList = await _repository.getWifiName(companyCode: _loginUser.companyCode);

    //연결된 wifi 이름 저장
    Future<String> connectWifiName () async {
      switch (foundation.defaultTargetPlatform) {
        case foundation.TargetPlatform.iOS:
          return await IosNetworkInfo.ssid;
        case foundation.TargetPlatform.android:
          return await Wifi.ssid;
        default:
          return "";
      }
    }

    //날짜
    DateTime today = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day); //오늘 날짜
    DateTime nowTime = DateTime.now();
    DateTime yesterday = today.subtract(Duration(days: 1));

    //오늘 날짜의 출퇴근 데이터를 불러온다.
    var result = await _repository.getMyTodayAttendance(
      companyCode: _loginUser.companyCode,
      loginUserMail: _loginUser.mail,
      today: _format.dateTimeToTimeStamp(today),
    );

    var yesterdayResult = await _repository.getMyTodayAttendance(
      companyCode: _loginUser.companyCode,
      loginUserMail: _loginUser.mail,
      today: _format.dateTimeToTimeStamp(yesterday),
    );

    if(yesterdayResult.docs.length != 0){
      Attendance _temp = Attendance.fromMap(yesterdayResult.docs.first.data(), yesterdayResult.docs.first.id);
      if(_temp.endTime == null){
        _temp.endTime = _format.dateTimeToTimeStamp(DateTime(yesterday.year, yesterday.month, yesterday.day, 18, 00));
      }
      _repository.updateAttendance(companyCode: _loginUser.companyCode, attendanceModel: _temp, documentId: yesterdayResult.docs.first.id);
    }

    //출퇴근 데이터가 없을 경우
    if (result.docs.length == 0) {
      _attendance = Attendance(
        mail: _loginUser.mail,
        name: _loginUser.name,
        status: 0,
        createDate: _format.dateTimeToTimeStamp(today),
      );

      //DB를 생성한다.
      DocumentReference newAttendance = await _repository.saveAttendance(
        attendanceModel: _attendance,
        companyCode: _loginUser.companyCode,
      );

      tempDocumentId.add(newAttendance.id);

      if(tempDocumentId.length == 2){
        _repository.deleteAttendance(
          companyCode: _loginUser.companyCode,
          documentId: tempDocumentId[0],
        );
      }

      _attendance.id = newAttendance.id;

      //wifi 연결 여부 확인
      //wifi에 연결되어 있을 경우
      String wifiName = await connectWifiName();
      if (wifiList.contains(wifiName)) {
        _attendance.status = 1;
        _attendance.attendTime = _format.dateTimeToTimeStamp(nowTime);
        _repository.updateAttendance(
            attendanceModel: _attendance,
            documentId: newAttendance.id,
            companyCode: _loginUser.companyCode);
        return _attendance;
      }

      //wifi에 연결이 안되어 있을 경우
      else {
        return _attendance;
      }
    }

    //출퇴근 데이터가 있을 경우
    else {
      print("데이터가 있습니다.");
      String wifiName = await connectWifiName();
      _attendance = Attendance.fromMap(
          result.docs.first.data(), result.docs.first.id);
      if(_attendance.status != 0){
        return _attendance;
      }
      else{
        if (wifiList.contains(wifiName)) {
          _attendance.status = 1;
          _attendance.attendTime = _format.dateTimeToTimeStamp(nowTime);
          _repository.updateAttendance(
              attendanceModel: _attendance,
              documentId: result.docs.first.id,
              companyCode: _loginUser.companyCode);
          return _attendance;
        }

        //wifi에 연결이 안되어 있을 경우
        else {
          return _attendance;
        }
      }
    }
  }

  String attendanceStatus(int attendanceStatus) {
    switch (attendanceStatus) {
      case 0:
        return "출근전";
        break;
      case 1:
        return "내근";
        break;
      case 2:
        return "외근";
        break;
      default:
        return "퇴근";
    }
  }

  Future<void> attendanceChange({BuildContext context, int nowStatus}) async {
    List<bool> isSelect = [false, false];

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                "근무 상태 변경",
                style: defaultMediumStyle,
              ),
              content: Container(
                height: 10.0.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "근무 상태를 선택해 주세요",
                      style: defaultRegularStyle,
                    ),
                    emptySpace,
                    Row(
                      children: [
                        manualOnWorkBtn(
                          context: context,
                          btnText: nowStatus == 1 ? "외근" : nowStatus == 2 ? "내근" : "퇴근 철회",
                          btnAction: (){
                            setState(() {
                              isSelect[0] = !isSelect[0];
                              isSelect[1] = false;
                            });
                          },
                          isSelect: isSelect[0]
                        ),
                        cardSpace,
                        Visibility(
                          visible: nowStatus != 3,
                          child: manualOnWorkBtn(
                              context: context,
                              btnText: "퇴근",
                              btnAction: (){
                                setState(() {
                                  isSelect[1] = !isSelect[1];
                                  isSelect[0] = false;
                                });
                              },
                              isSelect: isSelect[1]
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              actions: [
                FlatButton(
                  child: Text(
                    "확인",
                    style: buttonBlueStyle,
                  ),
                  onPressed: isSelect.contains(true) ? () async {
                    if(isSelect[0] == true){
                      if(nowStatus == 1){
                        _attendance.status = 2;
                      }
                      else if(nowStatus == 2){
                        _attendance.status = 1;
                      }
                      else{
                        await cancelOffWork(context: context);
                      }
                      _repository.updateAttendance(
                        attendanceModel: _attendance,
                        documentId: _attendance.id,
                        companyCode: _loginUser.companyCode,
                      );
                      notifyListeners();
                      Navigator.pop(context, "OK");
                    }
                    else{
                      bool result = await manualOffWork(context: context);
                      if(result){
                        Navigator.of(context).pop();
                      }
                    }
                  } : null,
                ),
                FlatButton(
                  child: Text(
                    "취소",
                    style: buttonBlueStyle,
                  ),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    );
  }

  manualOffWork({BuildContext context}) async {
    bool result = false;
    DateTime nowTime = DateTime.now();
    await showDialog(
      context: context,
      barrierDismissible: false, //취소 버튼을 통해서만 알림박스를 끌 수 있다.
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "퇴근처리",
            style: defaultMediumStyle,
          ),
          content: Text(
            "퇴근 하시겠습니까?",
            style: defaultRegularStyle,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "확인",
                style: buttonBlueStyle,
              ),
              onPressed: (){
                _attendance.status = 3;
                _attendance.endTime = _format.dateTimeToTimeStamp(nowTime);
                _repository.updateAttendance(
                  attendanceModel: _attendance,
                  documentId: _attendance.id,
                  companyCode: _loginUser.companyCode,
                );
                notifyListeners();
                result = true;
                Navigator.of(context).pop(result);
                return result;
              },
            ),
            FlatButton(
              child: Text(
                "취소",
                style: buttonBlueStyle,
              ),
              onPressed: (){
                result = false;
                Navigator.of(context).pop(result);
                return result;
              },
            ),
          ],
        );
      },
    );
    return result;
  }

  cancelOffWork({BuildContext context}) async {
    List<bool> isSelect = [false, false];
    bool result = false;
    await showDialog(
      context: context,
      barrierDismissible: false, //취소 버튼을 통해서만 알림박스를 끌 수 있다.
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                "퇴근처리 철회",
                style: defaultMediumStyle,
              ),
              content: Container(
                height: 10.0.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "근무 상태 선택",
                      style: defaultRegularStyle,
                    ),
                    emptySpace,
                    Row(
                      children: [
                        manualOnWorkBtn(
                            context: context,
                            btnText: "내근",
                            btnAction: () {
                              setState(() {
                                isSelect[0] = !isSelect[0];
                                isSelect[1] = false;
                              });
                            },
                            isSelect: isSelect[0]),
                        cardSpace,
                        manualOnWorkBtn(
                            context: context,
                            btnText: "외근",
                            btnAction: () {
                              setState(() {
                                isSelect[1] = !isSelect[1];
                                isSelect[0] = false;
                              });
                            },
                            isSelect: isSelect[1]),
                      ],
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    "확인",
                    style: buttonBlueStyle,
                  ),
                  onPressed: isSelect.contains(true) ? () {
                    if (isSelect[0] == true) {
                      _attendance.status = 1;
                    } else {
                      _attendance.status = 2;
                    }
                    _attendance.endTime = null;
                    _repository.updateAttendance(
                      attendanceModel: _attendance,
                      documentId: _attendance.id,
                      companyCode: _loginUser.companyCode,
                    );
                    notifyListeners();
                    result = true;
                    Navigator.of(context).pop(result);
                    return result;
                  } : null,
                ),
                FlatButton(
                  child: Text(
                    "취소",
                    style: buttonBlueStyle,
                  ),
                  onPressed: () {
                    result = false;
                    Navigator.of(context).pop(result);
                    return result;
                  },
                ),
              ],
            );
          },
        );
      },
    );
    return result;
  }

  Future<void> manualOnWork({BuildContext context}) async {
    DateTime nowTime = DateTime.now();
    List<bool> isSelect = [false, false, false];
    await showDialog(
      context: context,
      barrierDismissible: false, //취소 버튼을 통해서만 알림박스를 끌 수 있다.
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                "출근처리",
                style: defaultMediumStyle,
              ),
              content: Container(
                height: 10.0.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "수동 처리 사유",
                      style: defaultRegularStyle,
                    ),
                    emptySpace,
                    Row(
                      children: [
                        manualOnWorkBtn(
                            context: context,
                            btnText: "외근",
                            btnAction: () {
                              _attendance.manualOnWorkReason = 0;
                              setState(() {
                                isSelect[0] = !isSelect[0];
                                isSelect[1] = false;
                                isSelect[2] = false;
                              });
                            },
                            isSelect: isSelect[0]),
                        cardSpace,
                        manualOnWorkBtn(
                            context: context,
                            btnText: "기기고장",
                            btnAction: () {
                              _attendance.manualOnWorkReason = 1;
                              setState(() {
                                isSelect[1] = !isSelect[1];
                                isSelect[0] = false;
                                isSelect[2] = false;
                              });
                            },
                            isSelect: isSelect[1]),
                        cardSpace,
                        manualOnWorkBtn(
                            context: context,
                            btnText: "착오",
                            btnAction: () {
                              _attendance.manualOnWorkReason = 2;
                              setState(() {
                                isSelect[2] = !isSelect[2];
                                isSelect[0] = false;
                                isSelect[1] = false;
                              });
                            },
                            isSelect: isSelect[2]),
                      ],
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    "확인",
                    style: buttonBlueStyle,
                  ),
                  onPressed: isSelect.contains(true) ? () {
                    if (isSelect[0] == true) {
                      _attendance.status = 2;
                    } else {
                      _attendance.status = 1;
                    }
                    _attendance.attendTime =
                        _format.dateTimeToTimeStamp(nowTime);
                    _repository.updateAttendance(
                      attendanceModel: _attendance,
                      documentId: _attendance.id,
                      companyCode: _loginUser.companyCode,
                    );

                    notifyListeners();
                    Navigator.pop(context, "OK");
                  } : null,
                ),
                FlatButton(
                  child: Text(
                    "취소",
                    style: buttonBlueStyle,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
