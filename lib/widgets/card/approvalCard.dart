import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/models/workApprovalModel.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

Card ApprovalCard({BuildContext context, String companyCode, WorkApproval model}) {
  Format _format = Format();
  var returnString = NumberFormat("###,###", "en_US");

  return Card(
    elevation: 0,
    shape: cardShape,
    child: Padding(
        padding: cardPadding,
        child: Container(
            height: scheduleCardDefaultSizeH.h,
            child: Row(
              children: [
                Container(
                  width: SizerUtil.deviceType == DeviceType.Tablet ? 15.0.w : 13.0.w,
                  alignment: Alignment.center,
                  child: Text(
                    model.approvalType,
                    style: containerChipStyle,
                  ),
                ),
                cardSpace,
                Container(
                  width: SizerUtil.deviceType == DeviceType.Tablet ? 17.0.w : 15.0.w,
                  alignment: Alignment.center,
                  child: Text(
                    model.approvalUser,
                    style: containerChipStyle,
                  ),
                ),
                cardSpace,
                Container(
                  width: SizerUtil.deviceType == DeviceType.Tablet ? 19.0.w : 17.0.w,
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

                /// 기능 미구현으로 인한 숨김 처리
                //_popupMenu(context),
              ],
            )
        )
    ),
  );
}