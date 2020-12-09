import 'dart:io';
import 'package:companyplaylist/utils/date/dateFormat.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/models/expenseModel.dart';
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/provider/user/loginUserInfo.dart';
import 'package:companyplaylist/repos/firebaseRepository.dart';
import 'package:companyplaylist/widgets/form/customInputFormatter.dart';
import 'package:companyplaylist/widgets/popupMenu/invalidData.dart';

ExpenseMain(BuildContext context) {
  FirebaseRepository _reposistory = FirebaseRepository();
  final Firestore _db = Firestore.instance;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  LoginUserInfoProvider _loginUserInfoProvider;

  _loginUserInfoProvider =
      Provider.of<LoginUserInfoProvider>(context, listen: false);
  User user = _loginUserInfoProvider.getLoginUser();

  Reference storageReference = _firebaseStorage.ref().child(
      "expenses/${user.companyCode}/${user.mail}/${DateTime.now().toString()}");

  TextEditingController _detailController = TextEditingController();
  TextEditingController _expenseController = TextEditingController();

  bool _detailClicked = false;
  int _chosenItem = 0;
  String _documentID;
  String _downloadUrl;

  /// Which holds the selected date
  /// Defaults to today's date.
  DateTime selectedDate = DateTime.now();
  Format _format = Format();

  /// This decides which day will be enabled
  /// This will be called every time while displaying day in calender.
  bool _decideWhichDayToEnable(DateTime day) {
    if ((day.isAfter(DateTime.now().subtract(Duration(days: 1))) &&
        day.isBefore(DateTime.now().add(Duration(days: 10))))) {
      return true;
    }
    return false;
  }

  // 이미지 파일 업로드 메서드
  void _uploadImageToStorage(ImageSource source) async {
    File image = await ImagePicker.pickImage(source: source);

    if (image == null) return;

    // 파일 업로드
    UploadTask storageUploadTask = storageReference.putFile(image);

    // 파일 업로드 완료까지 대기
    await storageUploadTask;

    // 업로드한 사진의 URL 획득
    _downloadUrl = await storageReference.getDownloadURL();

    _db
        .collection("company")
        .document(user.companyCode)
        .collection("user")
        .document(user.mail)
        .collection("expense")
        .document(_documentID)
        .updateData({"imageUrl": _downloadUrl});
  }

  /// 금액 입력 텍스트 위젯
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

  /// 설정한 경비 데이터들을 파이어스토어에 저장하고 URL을 변수에 저장하는 메서드
  saveExpense() {
    ExpenseModel _expenseModel = ExpenseModel(
      name: user.name,
      mail: user.mail,
      companyCode: user.companyCode,
      createDate: Timestamp.now(),
      contentType: _buildChosenItem(_chosenItem),
      buyDate: _format.dateTimeToTimeStamp(selectedDate),
      cost: CustomTextInputFormatterReverse(_expenseController.text),
      memo: "",
      imageUrl: _downloadUrl == null ? "" : _downloadUrl,
      status: 0,
      detailNote: _detailController.text,
    );
    debugPrint(_downloadUrl);

    _returnValue() async {
      DocumentReference doc = await _reposistory.saveExpense(_expenseModel);
      _documentID = doc.documentID.toString();
    }
    _returnValue();
  }

  /// 경비 품의 바텀시트
  showModalBottomSheet(
      isScrollControlled: false,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20))),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {

            /// iOS용 데이트 피커 위젯
            buildCupertinoDatePicker(BuildContext context) {
              showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20))),
                  context: context,
                  builder: (BuildContext builder) {
                    return Container(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 10),
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
                                    Expanded(
                                      flex: 1,
                                      child: CircleAvatar(
                                          radius: 20,
                                          backgroundColor: blueColor,
                                          child: IconButton(
                                            icon: Icon(Icons.arrow_upward),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          )),
                                    ),
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

            /// 안드로이드용 데이트 피커 위젯
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

            /// 플랫폼 종류 인식 후 데이트 피커 제공 메서드
            _selectDate(BuildContext context) {
              final ThemeData theme = Theme.of(context);
              assert(theme.platform != null);
              switch (theme.platform) {
                case TargetPlatform.android:
                case TargetPlatform.fuchsia:
                case TargetPlatform.linux:
                case TargetPlatform.windows:
                  return
                      buildMaterialDatePicker(context);
                case TargetPlatform.iOS:
                case TargetPlatform.macOS:
                  return
                      buildCupertinoDatePicker(context);
              }
            }

            // 경비 품의 바텀시트 드로잉
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
                                    _expenseController.text == '' ||
                                            _chosenItem == 0
                                        ? disableUploadBtn
                                        : blueColor,
                                child: IconButton(
                                  icon: Icon(Icons.arrow_upward),
                                  onPressed: () {
                                    bool _isInput =
                                        !(_expenseController.text == '' ||
                                            _chosenItem == 0);
                                    _isInput
                                        ? saveExpense()
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
                          _selectDate(context);
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
                                Padding(
                                  padding: EdgeInsets.only(right: 8),
                                ),
                                Visibility(
                                    visible:
                                        _detailClicked == true ? true : false,
                                    child: Container(
                                      width: customWidth(
                                          context: context, widthSize: 0.5),
                                      child: TextField(
                                        controller: _detailController,
                                        keyboardType: TextInputType.multiline,
                                        style: customStyle(
                                          fontSize: 14,
                                          fontColor: mainColor,
                                          fontWeightName: 'regular',
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "상세 내용을 입력하세요",
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    )),
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
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return SimpleDialog(
                                    title: Text(
                                      "선택",
                                      style: customStyle(
                                          fontColor: mainColor,
                                          fontSize: 14
                                      ),
                                    ),
                                    children: [
                                      SimpleDialogOption(
                                        onPressed: () {
                                          _uploadImageToStorage(ImageSource.camera);
                                        },
                                        child: Text(
                                          "카메라",
                                          style: customStyle(
                                              fontColor: mainColor,
                                              fontSize: 13
                                          ),
                                        ),
                                      ),
                                      SimpleDialogOption(
                                        onPressed: () {
                                          _uploadImageToStorage(ImageSource.gallery);
                                        },
                                        child:Text(
                                          "갤러리",
                                          style: customStyle(
                                              fontColor: mainColor,
                                              fontSize: 13
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                });
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

/// 경비 항목 선택 메뉴
/// 추후 사용자 정의 화면 생성 및 해당 화면에서 생성된 데이터 리턴 적용 필요
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
