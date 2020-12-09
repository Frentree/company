//Flutter
import 'package:companyplaylist/repos/firebaseRepository.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:wifi/wifi.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Firebase
import 'package:cloud_firestore/cloud_firestore.dart';

//Model
import 'package:companyplaylist/models/attendanceModel.dart';
import 'package:companyplaylist/models/userModel.dart';

//Utils
import 'package:companyplaylist/utils/date/dateFormat.dart';

//Widget
import 'package:companyplaylist/widgets/button/textButton.dart';

class AttendanceCheck extends ChangeNotifier {
  Format _format = Format();

  List<String> wifiList = ["AndroidWifi"];

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

    //연결된 wifi 이름 저장
    String connectWifiName = await Wifi.ssid;

    //날짜
    DateTime today = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day); //오늘 날짜
    DateTime nowTime = DateTime.now();

    //오늘 날짜의 출퇴근 데이터를 불러온다.
    var result = await _repository.getMyTodayAttendance(
      companyCode: _loginUser.companyCode,
      loginUserMail: _loginUser.mail,
      today: _format.dateTimeToTimeStamp(today),
    );
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

      //wifi 연결 여부 확인
      //wifi에 연결되어 있을 경우
      if (wifiList.contains(connectWifiName)) {
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
      _attendance = Attendance.fromMap(
          result.docs.first.data(), result.docs.first.id);
      if(_attendance.status != 0){
        return _attendance;
      }
      else{
        if (wifiList.contains(connectWifiName)) {
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

  Future<void> manualOffWork(
      {BuildContext context}) async {
    DateTime nowTime = DateTime.now();
    showDialog(
      context: context,
      barrierDismissible: false, //취소 버튼을 통해서만 알림박스를 끌 수 있다.
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("퇴근처리"),
          content: Text("퇴근 하시겠습니까?"),
          actions: <Widget>[
            textBtn(
              btnText: "확인",
              btnAction: () {
                _attendance.status = 3;
                _attendance.endTime = _format.dateTimeToTimeStamp(nowTime);
                _repository.updateAttendance(
                  attendanceModel: _attendance,
                  documentId: _attendance.id,
                  companyCode: _loginUser.companyCode,
                );
                notifyListeners();
                Navigator.pop(context, "OK");
              },
            ),
            textBtn(
              btnText: "취소",
              btnAction: () {
                Navigator.pop(context, "NO");
              },
            ),
          ],
        );
      },
    );
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
              title: Text("출근처리"),
              content: Container(
                height: customHeight(context: context, heightSize: 0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("수동 처리 사유"),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom:
                              customHeight(context: context, heightSize: 0.01)),
                    ),
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
                        SizedBox(
                          width: customWidth(context: context, widthSize: 0.01),
                        ),
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
                        SizedBox(
                          width: customWidth(context: context, widthSize: 0.01),
                        ),
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
                textBtn(
                    btnText: "확인",
                    btnAction: isSelect.contains(true)
                        ? () {
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
                          }
                        : null),
                textBtn(
                  btnText: "취소",
                  btnAction: () {
                    Navigator.pop(context, "NO");
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
