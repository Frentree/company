import 'dart:io';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/screens/alarm/signBoxExpensePickDate.dart';
import 'package:MyCompany/screens/work/workDate.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:MyCompany/models/expenseModel.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/widgets/form/customInputFormatter.dart';
import 'package:MyCompany/widgets/popupMenu/invalidData.dart';
import 'package:sizer/sizer.dart';
//import 'package:tesseract_ocr/tesseract_ocr.dart';

ExpenseMain(BuildContext context) async {
  FirebaseRepository _repository = FirebaseRepository();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  //OCR 관련 변수
  bool _scanning=false;
  String _extractText="";
  File _pickeimage;

  LoginUserInfoProvider _loginUserInfoProvider;

  _loginUserInfoProvider =
      Provider.of<LoginUserInfoProvider>(context, listen: false);
  User user = _loginUserInfoProvider.getLoginUser();

  Reference storageReference = _firebaseStorage.ref().child(
      "expenses/${user.companyCode}/${user.mail}/${DateTime.now().toString()}");

  TextEditingController _detailController = TextEditingController();
  TextEditingController _expenseController = TextEditingController();

  bool _detailClicked = false;
  bool result = false;

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
/*  Widget _buildExpenseSizedBox() {
    return Container(
      width: 100,
      child:
    );
  }*/

  /// 설정한 경비 데이터들을 파이어스토어에 저장하고 URL을 변수에 저장하는 메서드
  saveExpense() {
    //DateTime _searchDate = DateTime(selectedDate.year, selectedDate.month);
    //var _docId = _repository.getExpenseDocument(user.companyCode, user.mail);
    ExpenseModel _expenseModel = ExpenseModel(
      name: user.name,
      mail: user.mail,
      companyCode: user.companyCode,
      createDate: Timestamp.now(),
      contentType: _buildChosenItem(_chosenItem),
      buyDate: _format.dateTimeToTimeStamp(selectedDate),
      cost: CustomTextInputFormatterReverse(_expenseController.text),
      index: null,
      imageUrl: _downloadUrl == null ? "" : _downloadUrl,
      status: "미",
      detailNote: _detailController.text,
      //searchDate: _format.dateTimeToTimeStamp(_searchDate),
      docId: null
    );
    debugPrint(_downloadUrl);

    _returnValue() async {
      await _repository.saveExpense(_expenseModel);
      //_documentID = doc.documentID.toString();
    }
    _returnValue();
  }

  /// 경비 품의 바텀시트
  await showModalBottomSheet(
      isScrollControlled: true,
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
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                  right: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                  top: 2.0.h,
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 6.0.h,
                            width: SizerUtil.deviceType == DeviceType.Tablet ? 22.5.w : 28.0.w,
                            decoration: BoxDecoration(
                              color: chipColorBlue,
                              borderRadius: BorderRadius.circular(
                                  SizerUtil.deviceType == DeviceType.Tablet ? 6.0.w : 8.0.w
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 0.75.w : 1.0.w,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "경비 정산",
                              style: defaultMediumStyle,
                            ),
                          ),
                          cardSpace,
                          Expanded(
                              child: PopupMenuButton(
                                child: RaisedButton(
                                  disabledColor: whiteColor,
                                  child: Text(
                                    _buildChosenItem(_chosenItem),
                                    style: defaultRegularStyle,
                                  ),
                                ),
                                onSelected: (value) async {
                                  _chosenItem = value;
                                  print(_chosenItem);
                                  setState(() {});
                                },
                                itemBuilder: (BuildContext context) => [
                                  PopupMenuItem(
                                    height: 7.0.h,
                                    value: 1,
                                    child: Row(
                                      children: [
                                        cardSpace,
                                        Text(
                                          "중식비",
                                          style: defaultRegularStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    height: 7.0.h,
                                    value: 2,
                                    child: Row(
                                      children: [
                                        //Icon(Icons.delete),
                                        cardSpace,
                                        Text(
                                          "석식비",
                                          style: defaultRegularStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    height: 7.0.h,
                                    value: 3,
                                    child: Row(
                                      children: [
                                        //Icon(Icons.edit),
                                        cardSpace,
                                        Text(
                                          "교통비",
                                          style: defaultRegularStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    height: 7.0.h,
                                    value: 4,
                                    child: Row(
                                      children: [
                                        //Icon(Icons.edit),
                                        cardSpace,
                                        Text(
                                          "기타",
                                          style: defaultRegularStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                          cardSpace,
                          CircleAvatar(
                            radius: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                            backgroundColor: _expenseController.text == "" ? disableUploadBtn : blueColor,
                            child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  Icons.arrow_upward,
                                  color: whiteColor,
                                  size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                                ),
                              onPressed: () async {
                                bool _isInput = !(_expenseController.text == '' || _chosenItem == 0);
                                await _isInput ? saveExpense() : InvalidData(context);

                                result = true;
                                Navigator.of(context).pop(result);
                                return result;
                              },
                            ),
                          ),
                        ],
                      ),
                      emptySpace,
                      Row(
                        children: [
                          Container(
                            height: 6.0.h,
                            width: SizerUtil.deviceType == DeviceType.Tablet ? 22.5.w : 30.0.w,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                                ),
                                cardSpace,
                                Text(
                                  "지출 일자",
                                  style: defaultRegularStyle,
                                ),
                              ],
                            ),
                          ),
                          cardSpace,
                          Expanded(
                            child: InkWell(
                              child: Text(
                                DateFormat('yyyy-MM-dd').format(selectedDate),
                                style: defaultRegularStyle,
                              ),
                              onTap: () async {
                                //_selectDate(context);
                                selectedDate = await pickDate(
                                  context,
                                  selectedDate
                                );
                                setState((){});
                              },
                            ),
                          ),
                        ],
                      ),
                      emptySpace,
                      Row(
                        children: [
                          Container(
                            height: 6.0.h,
                            width: SizerUtil.deviceType == DeviceType.Tablet ? 22.5.w : 30.0.w,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.art_track,
                                  size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                                ),
                                cardSpace,
                                Text(
                                  "지출 금액",
                                  style: defaultRegularStyle,
                                ),
                              ],
                            ),
                          ),
                          cardSpace,
                          Expanded(
                            child: TextFormField(
                              textAlign: TextAlign.right,
                              style: defaultRegularStyle,
                              controller: _expenseController,
                              keyboardType:
                              TextInputType.numberWithOptions(signed: true, decimal: true),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                CustomTextInputFormatter(),
                              ],
                              decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: textFormPadding,
                                  suffixText: '원',
                                  suffixStyle: defaultRegularStyle,
                                  hintText: "금액을 입력하세요",
                                  hintStyle: hintStyle
                              ),
                            ),
                          ),
                        ],
                      ),
                      cardSpace,
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
                                  width: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                                  height: 6.0.h,
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
                                  word.addItem(),
                                  style: defaultRegularStyle,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 8),
                                ),

                              ],
                            ),
                          ],
                        ),
                      ),
                      /*Container(
                        child: Row(
                          children: [
                            Container(
                              width: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                              height: 6.0.h,
                              child: Checkbox(
                                value: _detailClicked,
                                onChanged: (value) {
                                  setState(() {
                                    _detailClicked = value;
                                  });
                                },
                              ),
                            ),
                            cardSpace,
                            Text(
                              word.addItem(),
                              style: defaultRegularStyle,
                            ),
                          ],
                        ),
                      ),*/
                      Visibility(
                        visible: _detailClicked,
                        child: emptySpace,
                      ),
                      Visibility(
                        visible: _detailClicked,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 6.0.h,
                                  width: SizerUtil.deviceType == DeviceType.Tablet ? 22.5.w : 30.0.w,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.chat_bubble_outline,
                                        size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                                      ),
                                      cardSpace,
                                      Text(
                                        word.content(),
                                        style: defaultRegularStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Icon(
                                          Icons.receipt_outlined,
                                          size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                                          color: mainColor,
                                        ),
                                        cardSpace,
                                        Text(
                                          word.content(),
                                          style: defaultRegularStyle,
                                        ),
                                        cardSpace,
                                        cardSpace,
                                        Icon(
                                          Icons.qr_code,
                                          size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                                          color: mainColor,
                                        ),
                                        cardSpace,
                                        Icon(
                                          Icons.linked_camera,
                                          size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                                          color: mainColor,
                                        ),
                                        cardSpace,
                                        Icon(
                                          Icons.image_outlined,
                                          size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                                          color: mainColor,
                                        ),
                                      ],
                                    ),
                                    onTap: (){
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SimpleDialog(
                                            title: Text(
                                              word.select(),
                                              style: defaultMediumStyle,
                                            ),
                                            children: [
                                              SimpleDialogOption(
                                                onPressed: () async {
                                                  setState(() {
                                                    _scanning=true;
                                                  });
                                                  _pickeimage = await ImagePicker.pickImage(source: ImageSource.gallery);
                                                  //_extractText = await TesseractOcr.extractText(_pickeimage.path, language: "kor");
                                                  setState(() {
                                                    _scanning=false;
                                                  });

                                                  print("_extractText ===> " + _extractText);
                                                },
                                                child: Text(
                                                  "OCR",
                                                  style: defaultRegularStyle,
                                                ),
                                              ),
                                              SimpleDialogOption(
                                                onPressed: () {
                                                  _uploadImageToStorage(ImageSource.camera);
                                                },
                                                child: Text(
                                                  word.camera(),
                                                  style: defaultRegularStyle,
                                                ),
                                              ),
                                              SimpleDialogOption(
                                                onPressed: () {
                                                  _uploadImageToStorage(ImageSource.gallery);
                                                },
                                                child: Text(
                                                  word.gallery(),
                                                  style: defaultRegularStyle,
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                            emptySpace,
                            TextFormField(
                              maxLines: 5,
                              maxLengthEnforced: true,
                              controller: _detailController,
                              style: defaultRegularStyle,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                isDense: true,
                                border: OutlineInputBorder(),
                                contentPadding: textFormPadding,
                                hintText: word.contentCon(),
                                hintStyle: hintStyle,
                              ),
                            ),
                          ],
                        ),
                      ),
                      emptySpace,
                    ]),
              ),
            );
          },
        );
      }
      );
  return result;
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
