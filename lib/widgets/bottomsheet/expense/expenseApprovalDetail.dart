import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/models/workApprovalModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/repos/fcm/pushFCM.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:MyCompany/widgets/popupMenu/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

final word = Words();

ExpenseApprovalDetail(
    BuildContext context, String companyCode, WorkApproval model) async {
  FirebaseRepository _repository = FirebaseRepository();
  Format _format = Format();
  bool result = false;
  User _loginUser;
  DateTime startTime = DateTime.parse(model.requestDate.toDate().toString());
  var returnString = NumberFormat("###,###", "en_US");

  await showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      LoginUserInfoProvider _loginUserInfoProvider =
      Provider.of<LoginUserInfoProvider>(context);
      _loginUser = _loginUserInfoProvider.getLoginUser();
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left:
                  SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                  right:
                  SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                  top: 2.0.h,
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 6.0.h,
                          width: SizerUtil.deviceType == DeviceType.Tablet
                              ? 22.5.w
                              : 30.0.w,
                          decoration: BoxDecoration(
                            color: chipColorBlue,
                            borderRadius: BorderRadius.circular(
                                SizerUtil.deviceType == DeviceType.Tablet
                                    ? 6.0.w
                                    : 8.0.w),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal:
                            SizerUtil.deviceType == DeviceType.Tablet
                                ? 0.75.w
                                : 1.0.w,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "상세 내용",
                            style: defaultMediumStyle,
                          ),
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                    Card(
                      elevation: 0,
                      shape: cardShape,
                      child: Padding(
                        padding: cardPadding,
                        child: Container(
                          height: scheduleCardDefaultSizeH.h,
                          child: Row(children: [
                            Container(
                              width: SizerUtil.deviceType == DeviceType.Tablet
                                  ? 19.0.w
                                  : 17.0.w,
                              alignment: Alignment.center,
                              child: Text(
                                word.exDate(),
                                style: cardBlueStyle,
                              ),
                            ),
                            cardSpace,
                            Container(
                              width: SizerUtil.deviceType == DeviceType.Tablet
                                  ? 15.0.w
                                  : 13.0.w,
                              alignment: Alignment.center,
                              child: Text(
                                word.category(),
                                style: cardBlueStyle,
                              ),
                            ),
                            cardSpace,
                            Container(
                              width: SizerUtil.deviceType == DeviceType.Tablet
                                  ? 15.0.w
                                  : 13.0.w,
                              alignment: Alignment.center,
                              child: Text(
                                word.amount(),
                                style: cardBlueStyle,
                              ),
                            ),
                            cardSpace,
                            Container(
                              width: SizerUtil.deviceType == DeviceType.Tablet
                                  ? 15.0.w
                                  : 13.0.w,
                              alignment: Alignment.center,
                              child: Text(
                                word.receipt(),
                                style: cardBlueStyle,
                              ),
                            ),
                            cardSpace,
                            Container(
                              width: SizerUtil.deviceType == DeviceType.Tablet
                                  ? 11.0.w
                                  : 9.0.w,
                              alignment: Alignment.center,
                              child: Text(
                                word.state(),
                                style: cardBlueStyle,
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),

                    emptySpace,
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
