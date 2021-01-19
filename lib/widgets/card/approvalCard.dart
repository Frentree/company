import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/models/workApprovalModel.dart';
import 'package:MyCompany/screens/alarm/signBoxReception.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

Card RequestApprovalCard({BuildContext context, String companyCode, WorkApproval model}) {
  Format _format = Format();
  var returnString = NumberFormat("###,###", "en_US");

  return Card(
    elevation: 0,
    shape: cardShape,
    child: Padding(
        padding: cardPadding,
        child: Container(
            height: cardTitleSizeH.h,
            child: Row(
              children: [
                Container(
                  width: SizerUtil.deviceType == DeviceType.Tablet ? 10.0.w : 8.0.w,
                  alignment: Alignment.center,
                  child: Text(
                    model.approvalType,
                    style: containerChipStyle,
                  ),
                ),
                cardSpace,
                Container(
                  width: SizerUtil.deviceType == DeviceType.Tablet ? 21.0.w : 19.0.w,
                  alignment: Alignment.centerRight,
                  child: Text(
                    _format.dateFormatForExpenseCard(model.createDate),
                    style: containerChipStyle,
                  ),
                ),
                cardSpace,
                Container(
                  width: SizerUtil.deviceType == DeviceType.Tablet ? 21.0.w : 19.0.w,
                  alignment: Alignment.center,
                  child: Text(
                    model.status,
                    style: containerChipStyle,
                  ),
                ),
                Visibility(
                  visible: model.approvalType == "연차" || model.approvalType == "반차",
                  child: Container(
                    width: SizerUtil.deviceType == DeviceType.Tablet ? 19.0.w : 17.0.w,
                    alignment: Alignment.centerRight,
                    child: Text(
                      _format.dateFormatForExpenseCard(model.requestDate),
                      style: containerChipStyle,
                    ),
                  ),
                ),
                cardSpace,
                /// 기능 미구현으로 인한 숨김 처리
                //_popupMenu(context),
              ],
            )
        )
    ),
  );
}

Widget ApprovalCard({BuildContext context, String companyCode, WorkApproval model}) {
  Format _format = Format();
  var returnString = NumberFormat("###,###", "en_US");
  bool isChk = false;

  return StatefulBuilder(
    builder: (context, setState) {
      return Card(
        elevation: 0,
        shape: cardShape,
        child: Padding(
            padding: cardPadding,
            child: Container(
                height: cardTitleSizeH.h,
                child: Row(
                  children: [
                    Visibility(
                      visible: model.status == "요청",
                      child: Container(
                        width: SizerUtil.deviceType == DeviceType.Tablet ? 10.0.w : 8.0.w,
                        alignment: Alignment.center,
                        child: Checkbox(
                          value: isChk,
                          onChanged: (value) {
                            setState(() {
                              isChk = value;
                            });
                            if(isChk){
                              approvalList.add(model);
                            } else {
                              approvalList.remove(model);
                            }
                          },
                        ),
                      ),
                    ),
                    cardSpace,
                    Container(
                      width: SizerUtil.deviceType == DeviceType.Tablet ? 10.0.w : 8.0.w,
                      alignment: Alignment.center,
                      child: Text(
                        model.approvalType,
                        style: containerChipStyle,
                      ),
                    ),
                    cardSpace,
                    Container(
                      width: SizerUtil.deviceType == DeviceType.Tablet ? 21.0.w : 19.0.w,
                      alignment: Alignment.centerRight,
                      child: Text(
                        _format.dateFormatForExpenseCard(model.createDate),
                        style: containerChipStyle,
                      ),
                    ),
                    cardSpace,
                    Container(
                      width: SizerUtil.deviceType == DeviceType.Tablet ? 21.0.w : 19.0.w,
                      alignment: Alignment.center,
                      child: Text(
                        model.status,
                        style: containerChipStyle,
                      ),
                    ),
                    Visibility(
                      visible: model.approvalType == "연차" || model.approvalType == "반차",
                      child: Container(
                        width: SizerUtil.deviceType == DeviceType.Tablet ? 19.0.w : 17.0.w,
                        alignment: Alignment.centerRight,
                        child: Text(
                          _format.dateFormatForExpenseCard(model.requestDate),
                          style: containerChipStyle,
                        ),
                      ),
                    ),
                    cardSpace,
                    /// 기능 미구현으로 인한 숨김 처리
                    //_popupMenu(context),
                  ],
                )
            )
        ),
      );
    }
  );
}