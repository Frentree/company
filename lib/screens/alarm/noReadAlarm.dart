import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/models/alarmModel.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class NoReadAlarm extends StatefulWidget {
  @override
  NoReadAlarmState createState() => NoReadAlarmState();
}

class NoReadAlarmState extends State<NoReadAlarm> {
  User _loginUser;
  FirebaseRepository _repository = FirebaseRepository();

  Format _format = Format();

  @override
  Widget build(BuildContext context) {
    LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context);
    _loginUser = _loginUserInfoProvider.getLoginUser();
    return Scaffold(
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: _repository.getNoReadAlarm(companyCode: _loginUser.companyCode, mail: _loginUser.mail),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              List<DocumentSnapshot> document = snapshot.data.docs;

              var _alarmData = [];

              snapshot.data.docs.forEach((element) {
                _alarmData.add(element);
              });

              if(_alarmData.length == 0){
                return Expanded(
                  child: ListView(
                    children: [
                      Card(
                        elevation: 0,
                        shape: cardShape,
                        child: Padding(
                          padding: cardPadding,
                          child: Container(
                            height: scheduleCardDefaultSizeH.h,
                            alignment: Alignment.center,
                            child: Text(
                              "읽지않은 알림이 없습니다.",
                              style: cardTitleStyle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else{
                return Expanded(
                  child: ListView.builder(
                    itemCount: _alarmData.length,
                    itemBuilder: (context, index){
                      Alarm alarm = Alarm.fromMap(_alarmData[index].data(), _alarmData[index].documentID);

                      return GestureDetector(
                        onTap: (){
                          _repository.updateReadAlarm(
                            companyCode: _loginUser.companyCode,
                            mail: _loginUser.mail,
                            alarmId: alarm.alarmId.toString(),
                          );
                        },
                        child: Card(
                          elevation: 0,
                          shape: cardShape,
                          child: Padding(
                            padding: cardPadding,
                            child: Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: 9.0.h,
                                    alignment: Alignment.center,
                                    child: FutureBuilder(
                                      future: FirebaseRepository().photoProfile(_loginUser.companyCode, alarm.createMail),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return CircularProgressIndicator();
                                        }
                                        else{
                                          return CircleAvatar(
                                            backgroundColor: whiteColor,
                                            radius: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                                            backgroundImage: NetworkImage(snapshot.data['profilePhoto']),
                                          );
                                        }
                                      }
                                    ),
                                  ),
                                  cardSpace,
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width: SizerUtil.deviceType == DeviceType.Tablet ? 67.0.w : 55.0.w,
                                        height: 6.0.h,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          alarm.alarmContents,
                                          style: cardTitleStyle,
                                        ),
                                      ),
                                      Container(
                                        height: 3.0.h,
                                        child: Text(
                                          _format.timeStampToDateTimeString(alarm.alarmDate),
                                          style: cardSubTitleStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
