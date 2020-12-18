import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/models/workModel.dart';
import 'package:MyCompany/widgets/card/meetingScheduleCard.dart';
import 'package:MyCompany/widgets/card/workScheduleCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(

            padding: EdgeInsets.only(
              left: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
              right: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
              top: 2.0.h,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(SizerUtil.deviceType == DeviceType.Tablet ? pageRadiusTW.w : pageRadiusMW.w),
                topRight: Radius.circular(SizerUtil.deviceType == DeviceType.Tablet ? pageRadiusTW.w : pageRadiusMW.w),
              ),
              color: whiteColor,
            ),
            child: Column(
              children: [
                Container(
                  height: 6.0.h,
                  padding: EdgeInsets.symmetric(
                      horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 0.75.w : 1.0.w
                  ),
                  child: Row(
                    children: [
                      Container(
                        child: IconButton(
                          constraints: BoxConstraints(),
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.close,
                            size: SizerUtil.deviceType == DeviceType.Tablet ? iconSizeTW.w : iconSizeMW.w,
                            color: mainColor,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            name,
                            style: defaultMediumStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                emptySpace,
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
        ),
      );
    },
  );
}
