import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/models/workModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/screens/work/workDate.dart';
import 'package:MyCompany/widgets/card/meetingScheduleCard.dart';
import 'package:MyCompany/widgets/card/workScheduleCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:MyCompany/models/meetingModel.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:MyCompany/consts/screenSize/widgetSize.dart';
import 'package:MyCompany/consts/screenSize/login.dart';
import 'package:sizer/sizer.dart';

coScheduleDetail(
    {BuildContext context, List<dynamic> scheduleData, String name, String loginUserMail}) async {
  Format _format = Format();
  FirebaseRepository _repository = FirebaseRepository();

  await showModalBottomSheet(
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(pageRadiusW.w),
        topLeft: Radius.circular(pageRadiusW.w),
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
            left: 5.0.w,
            right: 5.0.w,
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
                      size: iconSizeW.w,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Text(
                      name,
                    style: customStyle(
                      fontSize: homePageDefaultFontSize,
                      fontWeightName: "Regular",
                    ),
                  ),
                  Container(
                    width: iconSizeW.w,
                  )
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 1.0.h)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.0.w),
                height: 35.0.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.0.w),
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
              Padding(padding: EdgeInsets.only(bottom: 2.0.h)),
            ],
          ),
        ),
      );
    },
  );
}
