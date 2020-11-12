import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/provider/user/loginUserInfo.dart';
import 'package:companyplaylist/widgets/bottomsheet/dateSetBottomSheet.dart';
import 'package:companyplaylist/widgets/popupMenu/expensePopupMenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

ExpenseMain(BuildContext context) {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _expenseController = TextEditingController();

  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];

  User _loginUser;
  bool _detailClicked = false;
  int _chosenItem = 0;
  int _itemCount = 0;
  _itemCount = entries.length;
  int _expenses = 8000;

  String date = "일자를 선택하세요";

  Widget _buildExpenseSizedBox() {
    return SizedBox(
        width: customWidth(
            context: context, widthSize: 0.5),
        height: customHeight(
            context: context, heightSize: 0.1),
        child: TextFormField(textAlign: TextAlign.right,
          textAlignVertical: TextAlignVertical.center,
          style: customStyle(
            fontSize: 14,
            fontColor: mainColor,
            fontWeightName: 'Regular',
          ),
          controller: _expenseController,
          keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
          inputFormatters: /*<TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],*/
          [FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            CustomTextInputFormatter(),
            ],
          decoration: InputDecoration(
            suffixText: '원',
            suffixStyle: TextStyle(color: Colors.black),
            hintText: "금액을 입력하세요",
            hintStyle: customStyle(
              fontSize: 14,
              fontColor: mainColor,
              fontWeightName: 'Regular',
            ),
          ),
        ));
  }

  showModalBottomSheet(
      isScrollControlled: false,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20))),
      context: context,
      builder: (BuildContext context) {
        LoginUserInfoProvider _loginUserInfoProvider =
            Provider.of<LoginUserInfoProvider>(context);
        _loginUser = _loginUserInfoProvider.getLoginUser();

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                    top: 30,
                    left: 20,
                    right: 20,
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Chip(
                              backgroundColor: chipColorBlue,
                              label: Text(
                                "경비 정산",
                                style: customStyle(
                                  fontSize: 14,
                                  fontColor: mainColor,
                                  fontWeightName: 'Regular',
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                          ),
                          Expanded(
                              flex: 5,
                              child:
                                  /*TextField(
                              controller: _titleController,
                              autofocus: true,
                              decoration:
                                  InputDecoration(hintText: '항목을 선택해 주세제요'),
                            ),*/
                                  PopupMenuButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    width: 1,
                                    color: boarderColor,
                                  ),
                                ),
                                padding: EdgeInsets.only(
                                    right: customWidth(
                                        context: context, widthSize: 0.04)),
                                child: RaisedButton(
                                  disabledColor: Colors.white,
                                  child: Text(
                                    _buildChosenItem(_chosenItem),
                                    style: customStyle(
                                        fontSize: 14,
                                        fontWeightName: "regular",
                                        fontColor: mainColor),
                                  ),
                                ),
                                onSelected: (value) async {
                                  _chosenItem = value;
                                  print(_chosenItem);
                                  setState(() {});
                                },
                                itemBuilder: (BuildContext context) => [
                                  PopupMenuItem(
                                    value: 1,
                                    child: Row(
                                      children: [
                                        //Icon(Icons.edit),
                                        SizedBox(width: 3),
                                        Text("중식비",
                                            style: TextStyle(fontSize: 14))
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 2,
                                    child: Row(
                                      children: [
                                        //Icon(Icons.delete),
                                        SizedBox(width: 3),
                                        Text("석식비",
                                            style: TextStyle(fontSize: 14))
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 3,
                                    child: Row(
                                      children: [
                                        //Icon(Icons.edit),
                                        SizedBox(width: 3),
                                        Text("교통비",
                                            style: TextStyle(fontSize: 14))
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 4,
                                    child: Row(
                                      children: [
                                        //Icon(Icons.edit),
                                        SizedBox(width: 3),
                                        Text("기타",
                                            style: TextStyle(fontSize: 14))
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                          ),
                          Expanded(
                            flex: 1,
                            child: CircleAvatar(
                                radius: 20,
                                backgroundColor: _titleController.text == ''
                                    ? Colors.black12
                                    : _titleController.text == ''
                                        ? Colors.black12
                                        : Colors.blue,
                                child: IconButton(
                                  icon: Icon(Icons.arrow_upward),
                                  onPressed: () {
                                    if (_titleController.text != '') {
                                    } else if (_titleController.text == '') {
                                      // 제목 미입력

                                    } else {
                                      // 내용 미입력

                                    }
                                  },
                                )),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 5),
                      ),
                      InkWell(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                          SizedBox(
                            width: customWidth(
                                context: context, widthSize: 0.37),
                            child: Row(children: [
                              Icon(Icons.calendar_today, color: mainColor),
                              Padding(
                                padding: EdgeInsets.only(left: 5),
                              ),
                              Text(
                                "지출 일자",
                                style: customStyle(
                                    fontSize: 14,
                                    fontWeightName: "regular",
                                    fontColor: mainColor),
                              )
                            ]),
                          ),
                          Row(
                            children: [
                              Text(
                                date,
                                style: customStyle(
                                    fontSize: 14,
                                    fontWeightName: "regular",
                                    fontColor: mainColor),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 22),
                              ),
                            ],
                          ),

                        ]),
                        onTap: () async {
                          String setDate =
                              await dateSetBottomSheet(context);
                          if (setDate != '') {
                            setState(() {
                              date = setDate;
                            });
                          }
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 5),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          InkWell(
                            child: Row(children: [
                              SizedBox(
                                width: customWidth(
                                    context: context, widthSize: 0.37),
                                child: Row(children: [
                                  Icon(Icons.art_track, color: mainColor),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5),
                                  ),
                                  Text(
                                    "지출 금액",
                                    style: customStyle(
                                        fontSize: 14,
                                        fontWeightName: "regular",
                                        fontColor: mainColor),
                                  )
                                ]),
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    _buildExpenseSizedBox()
                                  ]),
                            ]),
                            onTap: () {
                              _buildExpenseSizedBox();
                            },
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 5),
                      ),
                      GestureDetector(
                        onTap: () {
                          _detailClicked = !_detailClicked;
                          setState(() {});
                        },
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  height: 22.0,
                                  width: 22.0,
                                  child: IconButton(
                                    padding: EdgeInsets.all(0.0),
                                    icon: _detailClicked == true
                                        ? Icon(Icons.keyboard_arrow_up)
                                        : Icon(Icons.keyboard_arrow_down),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8),
                                ),
                                Text(
                                  "추가 항목(옵션)",
                                  style: customStyle(
                                      fontSize: 14,
                                      fontWeightName: "regular",
                                      fontColor: mainColor),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 15),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: _detailClicked == true ? true : false,
                        child: Column(children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: customWidth(
                                      context: context, widthSize: 0.37),
                                  child: Row(children: [
                                    Icon(
                                      Icons.receipt_outlined,
                                      color: mainColor,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 8),
                                    ),
                                    Text(
                                      "영수증 첨부",
                                      style: customStyle(
                                          fontSize: 14,
                                          fontWeightName: "regular",
                                          fontColor: mainColor),
                                    ),
                                  ]),
                                ),
                                SizedBox(
                                    child: Row(children: [
                                  Icon(
                                    Icons.linked_camera,
                                    color: mainColor,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 15),
                                  ),
                                  Icon(
                                    Icons.image_outlined,
                                    color: mainColor,
                                  ),
                                ]))
                              ]),
                          Padding(
                            padding: EdgeInsets.only(bottom: 15),
                          ),
                        ]),
                      ),
                    ]),
              ),
            );
          },
        );
      });



}

String _buildChosenItem(int chosenItem) {
  String _chosenItem = chosenItem.toString();
  switch (_chosenItem) {
    case '0':
      return "항목을 선택해 주세요";
    case '1':
      return "중식비";
    case '2':
      return "석식비";
    case '3':
      return "교통비";
    case '4':
      return "기타";
  }
}

//FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));

class CustomTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length == 0) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      int selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.extentOffset;
      List<String> chars = newValue.text.replaceAll(' ', '').split('');
      chars = newValue.text.replaceAll(',', '').split('');
      String newString = '';
      for (int i = 0; i < chars.length; i++) {
        if (i % 3 == 0 && i != 0) newString += ',';
        newString += chars[i];
      }

      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
          offset: newString.length - selectionIndexFromTheRight,
        ),
      );
    } else {
      return newValue;
    }
  }
}