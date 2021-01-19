// 내 결재함 화면에서 경비 청구 리스트 보여줄 때 사용하는 카드 위젯

import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/models/expenseModel.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/repos/showSnackBarMethod.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:MyCompany/widgets/alarm/expenseImageDialog.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:MyCompany/widgets/popupMenu/toast.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

final word = Words();

Card ExpenseCard(BuildContext context, String companyCode, ExpenseModel model,
    String uid, String docId) {
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
                  width: SizerUtil.deviceType == DeviceType.Tablet
                      ? 16.0.w
                      : 17.0.w,
                  alignment: Alignment.center,
                  child: Text(
                    _format.dateFormatForExpenseCard(model.buyDate),
                    style: containerChipStyle,
                  ),
                ),
                cardSpace,
                Container(
                  width: SizerUtil.deviceType == DeviceType.Tablet
                      ? 15.0.w
                      : 13.0.w,
                  alignment: Alignment.center,
                  child: Text(
                    model.contentType == "석식비"
                        ? word.dinner()
                        : model.contentType == "중식비"
                            ? word.lunch()
                            : model.contentType == "교통비"
                                ? word.transportation()
                                : word.etc(),
                    style: containerChipStyle,
                  ),
                ),
                cardSpace,
                Container(
                  width: SizerUtil.deviceType == DeviceType.Tablet
                      ? 15.0.w
                      : 13.0.w,
                  alignment: Alignment.centerRight,
                  child: Text(
                    returnString.format(model.cost),
                    style: containerChipStyle,
                  ),
                ),
                cardSpace,
                Container(
                  width: SizerUtil.deviceType == DeviceType.Tablet
                      ? 15.0.w
                      : 13.0.w,
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      ExpenseImageDialog(context, model.imageUrl);
                    },
                    child: model.imageUrl == ""
                        ? Container()
                        : Icon(
                            Icons.receipt_long_outlined,
                            size: SizerUtil.deviceType == DeviceType.Tablet
                                ? iconSizeTW.w
                                : iconSizeMW.w,
                          ),
                  ),
                ),
                cardSpace,
                Container(
                  width:
                      SizerUtil.deviceType == DeviceType.Tablet ? 6.0.w : 9.0.w,
                  alignment: Alignment.center,
                  child: Text(
                    model.status.toString(),
                    style: containerChipStyle,
                  ),
                ),
                _popupMenu(context, companyCode, docId, uid),
              ],
            ))),
  );
}

Container _popupMenu(
    BuildContext context, String companyCode, String docId, String uid) {
  bool _checker = true;
  FirebaseRepository _repository = FirebaseRepository();
  void showToast(String msg, {int duration, int gravity}) {}

  return Container(
    width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 5.0.w,
    alignment: Alignment.center,
    child: PopupMenuButton(
        icon: Icon(
          Icons.arrow_forward_ios_sharp,
          size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
        ),
        onSelected: (value) async {},
        itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                height: 7.0.h,
                value: 1,
                child: Row(
                  children: [
                    Container(
                      child: Icon(
                        Icons.edit,
                        size: SizerUtil.deviceType == DeviceType.Tablet
                            ? popupMenuIconSizeTW.w
                            : popupMenuIconSizeMW.w,
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            left: SizerUtil.deviceType == DeviceType.Tablet
                                ? 1.5.w
                                : 2.0.w)),
                    Text(
                      word.update(),
                      style: popupMenuStyle,
                    )
                  ],
                ),
              ),
              PopupMenuItem(
                height: 7.0.h,
                value: 2,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text(
                                  "삭제하시겠습니까?",
                                  style: defaultRegularStyle,
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text(
                                "Ok",
                                style: buttonBlueStyle,
                              ),
                              onPressed: () {
                                _repository.deleteExpense(
                                    companyCode, docId, uid);
                                toastDelete(context);
                                Navigator.pop(context);
                              },
                            ),
                            FlatButton(
                              child: Text(
                                "Cancel",
                                style: buttonBlueStyle,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete,
                        size: SizerUtil.deviceType == DeviceType.Tablet
                            ? popupMenuIconSizeTW.w
                            : popupMenuIconSizeMW.w,
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              left: SizerUtil.deviceType == DeviceType.Tablet
                                  ? 1.5.w
                                  : 2.0.w)),
                      Text(
                        word.delete(),
                        style: popupMenuStyle,
                      )
                    ],
                  ),
                ),
              ),
            ]),
  );
}
