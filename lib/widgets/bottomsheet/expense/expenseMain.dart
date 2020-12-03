import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/models/expenseModel.dart';
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/provider/user/loginUserInfo.dart';
import 'package:companyplaylist/repos/firebaseRepository.dart';
import 'package:companyplaylist/widgets/form/customInputFormatter.dart';
import 'package:companyplaylist/widgets/popupMenu/choiceImage.dart';
import 'package:companyplaylist/widgets/popupMenu/invalidData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

//테스트 계정
//abc@frentree / fren1212

ExpenseMain(BuildContext context) {
  FirebaseRepository _reposistory = FirebaseRepository();

  LoginUserInfoProvider _loginUserInfoProvider;

  _loginUserInfoProvider =
      Provider.of<LoginUserInfoProvider>(context, listen: false);
  User user = _loginUserInfoProvider.getLoginUser();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _expenseController = TextEditingController();

  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];

  bool _detailClicked = false;
  int _chosenItem = 0;
  int _itemCount = 0;
  _itemCount = entries.length;

  /// Which holds the selected date
  /// Defaults to today's date.
  DateTime selectedDate = DateTime.now();

  /// This decides which day will be enabled
  /// This will be called every time while displaying day in calender.
  bool _decideWhichDayToEnable(DateTime day) {
    if ((day.isAfter(DateTime.now().subtract(Duration(days: 1))) &&
        day.isBefore(DateTime.now().add(Duration(days: 10))))) {
      return true;
    }
    return false;
  }

  String date = "일자를 선택하세요";

  Widget _buildExpenseSizedBox() {
    return SizedBox(
        width: customWidth(context: context, widthSize: 0.5),
        height: customHeight(context: context, heightSize: 0.1),
        child: TextFormField(
          textAlign: TextAlign.right,
          textAlignVertical: TextAlignVertical.center,
          style: customStyle(
            fontSize: 14,
            fontColor: mainColor,
            fontWeightName: 'Regular',
          ),
          controller: _expenseController,
          keyboardType:
              TextInputType.numberWithOptions(signed: true, decimal: true),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
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

  saveExpense() {
    debugPrint("saveExpense Method has been clicked and a user name is " +
        user.name.toString() +
        "and a email is " +
        user.mail.toString());

    ExpenseModel _expenseModel = ExpenseModel(
      name: user.name,
      mail: user.mail,
      companyCode: user.companyCode,
      createDate: Timestamp.now(),
      contentType: _buildChosenItem(_chosenItem),
      buyDate: selectedDate,
      cost: CustomTextInputFormatterReverse(_expenseController.text),
      memo: "",
      imageUrl: "",
      status: 0,
    );
    debugPrint("In an instance of saveExpense() " +
        _expenseModel.name +
        " " +
        _expenseModel.mail +
        " " +
        _expenseModel.companyCode);

    _reposistory.saveExpense(_expenseModel);
  }

  showModalBottomSheet(
      isScrollControlled: false,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20))),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            buildCupertinoDatePicker(BuildContext context) {
              showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20))),
                  context: context,
                  builder: (BuildContext builder) {
                    return Container(
                        padding: EdgeInsets.only(left : 20, right: 20, top: 10),
                        height:
                            MediaQuery.of(context).copyWith().size.height / 2.5,
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
                                    ),
                                    /*Expanded(
                                      flex: 1,
                                      child: CircleAvatar(
                                          radius: 20,
                                          backgroundColor:
                                          _expenseController.text == '' && _chosenItem == 0
                                                  ? disableUploadBtn
                                                  : blueColor,
                                          child: IconButton(
                                            icon: Icon(Icons.arrow_upward),
                                            onPressed: () {
                                              debugPrint("_expenseController.text = " + _expenseController.text);
                                              debugPrint("_chosenItem.text = " + _chosenItem.toString());
                                              Navigator.pop(context);
                                            },
                                          )),
                                    ),*/
                                  ]),
                              Container(
                                height: MediaQuery.of(context)
                                        .copyWith()
                                        .size
                                        .height /
                                    3.2,
                                child: CupertinoDatePicker(
                                  mode: CupertinoDatePickerMode.date,
                                  onDateTimeChanged: (picked) {
                                    if (picked != null &&
                                        picked != selectedDate)
                                      setState(() {
                                        selectedDate = picked;
                                      });
                                  },
                                  initialDateTime: selectedDate,
                                  minimumYear: 2000,
                                  maximumYear: 2025,
                                ),
                              )
                            ]));
                  });
            }

            buildMaterialDatePicker(BuildContext context) async {
              final DateTime picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2025),
                initialEntryMode: DatePickerEntryMode.calendar,
                initialDatePickerMode: DatePickerMode.day,
                selectableDayPredicate: _decideWhichDayToEnable,
                helpText: '날짜를 선택해 주세요',
                cancelText: '취소',
                confirmText: '확인',
                errorFormatText: 'Enter valid date',
                errorInvalidText: 'Enter date in valid range',
                fieldLabelText: 'Booking date',
                fieldHintText: 'Month/Date/Year',
                builder: (context, child) {
                  return Theme(
                    data: ThemeData.light(),
                    child: child,
                  );
                },
              );
              if (picked != null && picked != selectedDate)
                setState(() {
                  selectedDate = picked;
                });
            }

            _selectDate(BuildContext context) {
              final ThemeData theme = Theme.of(context);
              assert(theme.platform != null);
              switch (theme.platform) {
                case TargetPlatform.android:
                case TargetPlatform.fuchsia:
                case TargetPlatform.linux:
                case TargetPlatform.windows:
                  return //debugPrint("android");
                      buildMaterialDatePicker(context);
                case TargetPlatform.iOS:
                case TargetPlatform.macOS:
                  return //debugPrint("iOS");
                      buildCupertinoDatePicker(context);
              }
            }

            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                    top: 10,
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
                              child: PopupMenuButton(
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
                                backgroundColor:
                                _expenseController.text == '' || _chosenItem == 0
                                    ? disableUploadBtn
                                    : blueColor,
                                child: IconButton(
                                  icon: Icon(Icons.arrow_upward),
                                  onPressed: () {
                                    bool _isInput =! (_expenseController.text == '' || _chosenItem == 0);
                                    _isInput ? saveExpense()
                                    : InvalidData(context);
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
                                    DateFormat('yyyy-MM-dd')
                                        .format(selectedDate),
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
                          //String setDate =
                          //Locale myLocale = Localizations.localeOf(context);
                          //debugPrint(myLocale.toString());
                          //buildCupertinoDatePicker(context);
                          //buildMaterialDatePicker(context);
                          _selectDate(context);

                          /*if (setDate != '') {
                            setState(() {
                              date = setDate;
                            });
                          }*/
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
                                  children: [_buildExpenseSizedBox()]),
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
                              padding: EdgeInsets.only(bottom: 20),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: _detailClicked == true ? true : false,
                        child: InkWell(
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
                              padding: EdgeInsets.only(bottom: 20),
                            ),
                          ]),
                          onTap: () {
                            ChoiceImage(context);
                          },
                        ),
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
