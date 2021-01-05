import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/screens/work/workContent.dart';
import 'package:MyCompany/widgets/bottomsheet/expense/expenseMain.dart';
import 'package:MyCompany/widgets/bottomsheet/purchase/purchaseMain.dart';
import 'package:MyCompany/widgets/bottomsheet/work/copySchedule.dart';
import 'package:MyCompany/widgets/bottomsheet/work/workContent.dart';
import 'package:MyCompany/widgets/bottomsheet/work/workNotice.dart';
import 'package:MyCompany/widgets/bottomsheet/meeting/meetingMain.dart';
import 'package:MyCompany/widgets/notImplementedPopup.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:flutter/material.dart';
import 'package:MyCompany/consts/screenSize/widgetSize.dart';
import 'package:MyCompany/consts/screenSize/login.dart';
import 'package:sizer/sizer.dart';
final word = Words();

MainBottomSheet({BuildContext context, String companyCode, String mail, double statusBarHeight}) {
  bool result = false;
  void _workBottomMove(int type) async {
    switch (type) {
      case 0: // 최근 일정에서 생성
        result = await CopySchedule(context: context, statusBarHeight: 0.0);
        if (result) {
          Navigator.of(context).pop();
        }
        break;
      case 1: // 내근 일정 생성
      case 2: // 외근 일정 생성
        result = await workContent(context: context, type: type);
        if (result) {
          Navigator.of(context).pop();
        }
        break;
      case 3: // 회의 일정 생성
        result = await meetingMain(context: context);
        if (result) {
          Navigator.of(context).pop();
        }
        break;
      case 4: // 개인 일정 생성
      case 5: // 업무 요청 생성
        break;
      case 6: // 구매 품의 생성
        NotImplementedFunction(context);
        break;
      case 7: // 경비 품의 생성
        result = await ExpenseMain(context);
        if (result) {
          Navigator.of(context).pop();
        }
        break;
      case 9: // 급여 명세 조회
        break;
      case 10: // 공지사항
        result = await WorkNoticeBottomSheet(context, "", "", "");
        if (result) {
          Navigator.of(context).pop();
        }
        break;
      default:
        NotImplementedFunction(context);
        break;
    }
  }

  showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder(
            future: FirebaseRepository().userGrade(companyCode, mail),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return LinearProgressIndicator();
              List<dynamic> grade = snapshot.data['level'];
              bool _isStaff = true;

              bool _isStaffMethod(grade) {
                if (!grade.contains(9) && !grade.contains(8))
                  return _isStaff = true;
                else
                  return _isStaff = false;
              }
              _isStaffMethod(grade);

              return Container(
                height: 34.0.h,
                padding: EdgeInsets.only(
                  left: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                  right: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                  top: 2.0.h,
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 6.0.h,
                      padding: EdgeInsets.symmetric(
                          horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 0.75.w : 1.0.w
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 6.0.h,
                            width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
                            child: IconButton(
                              constraints: BoxConstraints(),
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.keyboard_arrow_down_sharp,
                                size: SizerUtil.deviceType == DeviceType.Tablet ? iconSizeTW.w : iconSizeMW.w,
                                color: mainColor,
                              ),
                              onPressed: (){
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Expanded(
                            child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  word.addSheduleSelect(),
                                  style: defaultMediumStyle,
                                )
                            ),
                          )
                        ],
                      ),
                    ),
                    emptySpace,
                    /// 개발 미완료로 인한 숨김 처리
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          child: Container(
                            height: 6.0.h,
                            decoration: BoxDecoration(
                              color: chipColorBlue,
                              borderRadius: BorderRadius.circular(
                                  SizerUtil.deviceType == DeviceType.Tablet ? 6.0.w : 8.0.w
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 1.5.w : 2.0.w,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              Words.word.copySchedule(),
                              style: defaultMediumStyle,
                            ),
                          ),
                          onTap: (){
                            _workBottomMove(0);
                          },
                        ),
                      ],
                    ),
                    emptySpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        GestureDetector(
                          child: Container(
                            height: 6.0.h,
                            decoration: BoxDecoration(
                              color: chipColorBlue,
                              borderRadius: BorderRadius.circular(
                                  SizerUtil.deviceType == DeviceType.Tablet ? 6.0.w : 8.0.w
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 1.5.w : 2.0.w,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              word.workInSchedule(),
                              style: defaultMediumStyle,
                            ),
                          ),
                          onTap: (){
                            _workBottomMove(1);
                          },
                        ),
                        //cardSpace,
                        GestureDetector(
                          child: Container(
                            height: 6.0.h,
                            decoration: BoxDecoration(
                              color: chipColorBlue,
                              borderRadius: BorderRadius.circular(
                                  SizerUtil.deviceType == DeviceType.Tablet ? 6.0.w : 8.0.w
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 1.5.w : 2.0.w,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              word.workOutSchedule(),
                              style: defaultMediumStyle,
                            ),
                          ),
                          onTap: (){
                            _workBottomMove(2);
                          },
                        ),
                        //cardSpace,
                        GestureDetector(
                          child: Container(
                            height: 6.0.h,
                            decoration: BoxDecoration(
                              color: chipColorBlue,
                              borderRadius: BorderRadius.circular(
                                  SizerUtil.deviceType == DeviceType.Tablet ? 6.0.w : 8.0.w
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 1.5.w : 2.0.w,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              word.meetingSchedule(),
                              style: defaultMediumStyle,
                            ),
                          ),
                          onTap: (){
                            _workBottomMove(3);
                          },
                        ),
                        /// 개발 미완료로 인한 숨김 처리
                        /*ActionChip(
                          backgroundColor: chipColorBlue,
                          label: Text(
                            "개인 일정",
                            style: customStyle(
                                fontSize: 14,
                                fontWeightName: 'Regular',
                                fontColor: mainColor),
                          ),
                          onPressed: () {
                            NotImplementedFunction(context);
                            //_workBottomMove(4);
                          },
                        ),*/
                      ],
                    ),
                    emptySpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[

                        /// 개발 미완료로 인한 숨김 처리
                        /*ActionChip(
                          backgroundColor: chipColorPurple,
                          label: Text(
                            "업무 요청",
                            style: customStyle(
                                fontSize: 14,
                                fontWeightName: 'Regular',
                                fontColor: mainColor),
                          ),
                          onPressed: () {
                            NotImplementedFunction(context);
                            //_workBottomMove(5);
                          },
                        ),*/

                        /// 개발 미완료로 인한 숨김 처리
                        /*ActionChip(
                          backgroundColor: chipColorRed,
                          label: Text(
                            "구매 품의",
                            style: customStyle(
                                fontSize: 14,
                                fontWeightName: 'Regular',
                                fontColor: mainColor),
                          ),
                          onPressed: () {
                            _workBottomMove(6);
                          },
                        ),*/

                        GestureDetector(
                          child: Container(
                            height: 6.0.h,
                            decoration: BoxDecoration(
                              color: chipColorRed,
                              borderRadius: BorderRadius.circular(
                                  SizerUtil.deviceType == DeviceType.Tablet ? 6.0.w : 8.0.w
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 1.5.w : 2.0.w,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              word.settlement(),
                              style: defaultMediumStyle,
                            ),
                          ),
                          onTap: (){
                            _workBottomMove(7);
                          },
                        ),
                        //cardSpace,
                        /// 개발 미완료로 인한 숨김 처리
                        /*ActionChip(
                          backgroundColor: chipColorRed,
                          label: Text(
                            "연차 신청",
                            style: customStyle(
                                fontSize: 14,
                                fontWeightName: 'Regular',
                                fontColor: mainColor),
                          ),
                          onPressed: () {
                            NotImplementedFunction(context);
                            //_workBottomMove(8);
                          },
                        ),*/


                        /// 개발 미구현으로 인한 숨김 처리
                        /*if (!_isStaff) GestureDetector(
                          child: Container(
                            height: 6.0.h,
                            decoration: BoxDecoration(
                              color: chipColorGreen,
                              borderRadius: BorderRadius.circular(
                                  SizerUtil.deviceType == DeviceType.Tablet ? 6.0.w : 8.0.w
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 1.5.w : 2.0.w,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              word.payroll(),
                              style: defaultMediumStyle,
                            ),
                          ),
                          onTap: (){
                            _workBottomMove(9);
                          },
                        ),
                        cardSpace,*/


                        if (!_isStaff) GestureDetector(
                          child: Container(
                            height: 6.0.h,
                            decoration: BoxDecoration(
                              color: chipColorGreen,
                              borderRadius: BorderRadius.circular(
                                  SizerUtil.deviceType == DeviceType.Tablet ? 6.0.w : 8.0.w
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 1.5.w : 2.0.w,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              word.notice(),
                              style: defaultMediumStyle,
                            ),
                          ),
                          onTap: (){
                            _workBottomMove(10);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            });
      });
}
