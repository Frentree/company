import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/models/workModel.dart';
import 'package:companyplaylist/provider/user/loginUserInfo.dart';
import 'package:companyplaylist/screens/work/workDate.dart';
import 'package:companyplaylist/widgets/card/meetingScheduleCard.dart';
import 'package:companyplaylist/widgets/card/workScheduleCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:companyplaylist/models/meetingModel.dart';
import 'package:companyplaylist/repos/firebaseRepository.dart';
import 'package:companyplaylist/utils/date/dateFormat.dart';

coScheduleDetail(
    {BuildContext context, List<dynamic> scheduleData, String name, String loginUserMail}) async {
  Format _format = Format();
  FirebaseRepository _repository = FirebaseRepository();

  await showModalBottomSheet(
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(20),
        topLeft: Radius.circular(20),
      ),
    ),
    context: context,
    builder: (BuildContext context) {
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.close,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Text(
                      name,
                    style: customStyle(
                      fontSize: 15,
                      fontWeightName: "Regular",
                    ),
                  ),
                  Container(),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 5)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: customWidth(context: context, widthSize: 0.03)),
                height: customHeight(
                  context: context,
                  heightSize: 0.4
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: grayColor
                  ),
                ),
                child: ListView.builder(
                  itemCount: scheduleData.length,
                  itemBuilder: (context, index){
                    dynamic _data;
                    if(scheduleData[index].data()["type"] == "내근" || scheduleData[index].data()["type"] == "외근"){
                      _data = WorkModel.fromMap(scheduleData[index].data(), scheduleData[index].documentID);
                    }
                    else if(scheduleData[index].data()["type"] == "미팅"){
                      _data = MeetingModel.fromMap(scheduleData[index].data(), scheduleData[index].documentID);
                    }

                    switch(_data.type){
                      case "내근":
                      case "외근":
                        return workDetailContents(
                          context: context,
                          workModel: _data,
                          isDetail: false,
                          companyCode: "",
                        );
                        break;
                      case "미팅":
                        return meetingDetailContents(
                          context: context,
                          meetingModel: _data,
                          companyCode: "",
                          isDetail: false,
                          loginUserMail: loginUserMail,
                        );
                        break;
                      default:
                        return Container();
                    }
                  },
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 20)),
            ],
          ),
        ),
      );
    },
  );
}
