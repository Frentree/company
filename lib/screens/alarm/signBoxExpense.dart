import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:MyCompany/models/alarmModel.dart';
import 'package:MyCompany/models/companyUserModel.dart';
import 'package:MyCompany/models/expenseModel.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/models/workApprovalModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/repos/fcm/pushFCM.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:MyCompany/widgets/bottomsheet/annual/annualLeaveMain.dart';
import 'package:MyCompany/widgets/bottomsheet/pickMonth.dart';
import 'package:MyCompany/widgets/card/expenseCard.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:MyCompany/widgets/popupMenu/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:MyCompany/consts/screenSize/widgetSize.dart';
import 'package:MyCompany/consts/screenSize/login.dart';
import 'package:sizer/sizer.dart';

final word = Words();

class SignBoxExpense extends StatefulWidget {
  @override
  _SignBoxExpenseState createState() => _SignBoxExpenseState();
}

class _SignBoxExpenseState extends State<SignBoxExpense> {
  FirebaseRepository _repository = FirebaseRepository();
  User user;
  DateTime selectedMonth = DateTime.now();

  List<bool> _isSelected = List(100);
  bool _isTotal = false;
  int totalLength = 0;
  String _approvalUserItem = "결재자";
  UserData approvalUser;
  var _expense = [];

  Format _format = Format();
  DateTime startTime = DateTime.now().minute < 30
      ? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
          DateTime.now().hour, 00)
      : DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
          DateTime.now().hour, 30);
  CompanyUser loginUserInfo;
  Fcm fcm = Fcm();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 100; i++) _isSelected[i] = false;
  }

  void refreshSelect() {
    for (int i = 0; i < totalLength; i++) {
      _isSelected[i] = false;
    }
  }

  void fillSelect() {
    for (int i = 0; i < totalLength; i++) {
      _isSelected[i] = true;
    }
  }

  bool itemExist() {
    for (int i = 0; i < totalLength; i++) {
      if (_isSelected[i] == true) return true;
    }
    return false;
  }

  bool totalCheck() {
    for (int i = 0; i < totalLength; i++) {
      if (_isSelected[i] == false) {
        _isTotal = false;
        return _isTotal;
      }
    }
    _isTotal = true;
    return _isTotal;
  }

  bool buttonChecker() {
    bool result = false;
    result = itemExist() && _approvalUserItem != "결재자" ? true : false;
    return result;
  }

  List<String> docIdToList() {
    List<String> _docId = [];

    for (int i = 0; i < totalLength; i++) {
      if (_isSelected[i]) _docId.add(_expense[i].documentID);
    }
    return _docId;
  }

  int totalCost() {
    int total = 0;
    ExpenseModel _eModel = ExpenseModel();
    dynamic _expenseData;

    for (int i = 0; i < totalLength; i++) {
      _expenseData = ExpenseModel.fromMap(
        i,
        _expense[i].data(),
        _expense[i].documentID,
      );
      if (_isSelected[i]) total += _expenseData.cost;
    }
    return total;
  }

  writeExpenseApproval() {
    _repository
        .createAnnualLeave(
      companyCode: user.companyCode,
      workApproval: WorkApproval(
        title: "경비 결재 요청",
        status: "요청",
        user: user.name,
        userMail: user.mail,
        createDate: Timestamp.now(),
        requestDate: _format.dateTimeToTimeStamp(startTime),
        approvalContent: "",
        approvalType: "경비",
        //requestContent: _contentController.text,
        approvalUser: approvalUser.name,
        approvalMail: approvalUser.mail,
        totalCost: totalCost(),
        docIds: docIdToList(),
        //location: _locationController.text,
      ),
    )
        .whenComplete(() async {
      //결재요청 알림 생성
      Alarm _alarmModel = Alarm(
        alarmId: DateTime.now().hashCode,
        createName: user.name,
        createMail: user.mail,
        collectionName: "expenseRequest",
        alarmContents: loginUserInfo.team +
            " " +
            user.name +
            " " +
            loginUserInfo.position +
            "님이 경비정산 결재를 요청했습니다.",
        read: false,
        alarmDate: _format.dateTimeToTimeStamp(DateTime.now()),
      );

      List<String> token = await _repository.getApprovalUserTokens(
          companyCode: user.companyCode, mail: approvalUser.mail);

      //결재자 알림 DB에 저장
      await _repository
          .saveOneUserAlarm(
        alarmModel: _alarmModel,
        companyCode: user.companyCode,
        mail: approvalUser.mail,
      )
          .whenComplete(() async {
        fcm.sendFCMtoSelectedDevice(
            alarmId: _alarmModel.alarmId.toString(),
            tokenList: token,
            name: user.name,
            team: loginUserInfo.team,
            position: loginUserInfo.position,
            collection: "expenseRequest");
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LoginUserInfoProvider _loginUserInfoProvider =
        Provider.of<LoginUserInfoProvider>(context);
    user = _loginUserInfoProvider.getLoginUser();

    return Scaffold(
      body: Column(
        children: [
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
          StreamBuilder(
            stream: _repository.getExpense(
                user.companyCode, user.mail, selectedMonth),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              _expense = [];

              snapshot.data.documents.forEach((element) {
                _expense.add(element);
              });

              totalLength = _expense.length;

              if (_expense.length == 0) {
                return Expanded(
                    child: ListView(children: [
                  Card(
                    elevation: 0,
                    shape: cardShape,
                    child: Padding(
                      padding: cardPadding,
                      child: Container(
                        height: scheduleCardDefaultSizeH.h,
                        alignment: Alignment.center,
                        child: Text(
                          word.categoryCon(),
                          style: cardTitleStyle,
                        ),
                      ),
                    ),
                  ),
                ]));
              } else {
                return Expanded(
                    child: ListView.builder(
                        itemCount: _expense.length,
                        itemBuilder: (context, index) {
                          dynamic _expenseData;
                          _expenseData = ExpenseModel.fromMap(
                            index,
                            _expense[index].data(),
                            _expense[index].documentID,
                          );
                          // debugPrint(
                          //   "on card touched " + _expense[index].documentID);
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _isSelected[index] = !_isSelected[index];
                                totalCheck();
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: _expenseData.isApproved
                                    ? approvedCard
                                    : _isSelected[index]
                                        ? selectedCard
                                        : whiteColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ExpenseCard(
                                  context,
                                  user.companyCode,
                                  _expenseData,
                                  user.id,
                                  _expense[index].documentID),
                            ),
                          );
                        }));
              }
            },
          ),
          Card(
              elevation: 0,
              shape: cardShape,
              child: Row(
                children: [
                  Padding(
                    padding: cardPadding,
                    child: Container(
                      height: scheduleCardDefaultSizeH.h,
                      child: Row(children: [
                        InkWell(
                          child: Text(
                            DateFormat('yyyy년 MM월').format(selectedMonth),
                            style: defaultRegularStyle,
                          ),
                          onTap: () async {
                            selectedMonth =
                                await pickMonth(context, selectedMonth);
                            setState(() {
                              refreshSelect();
                              totalCheck();
                            });
                          },
                        ),
                        Padding(padding: EdgeInsets.only(left: 10.0)),
                        Container(
                          height: 4.0.h,
                          width: SizerUtil.deviceType == DeviceType.Tablet
                              ? 10.0.w
                              : 16.0.w,
                          decoration: BoxDecoration(
                            color: _isTotal ? mainColor : whiteColor,
                            border: Border.all(color: textFieldUnderLine),
                            borderRadius: BorderRadius.circular(
                                SizerUtil.deviceType == DeviceType.Tablet
                                    ? containerChipRadiusTW.w
                                    : containerChipRadiusMW.w),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                SizerUtil.deviceType == DeviceType.Tablet
                                    ? 0.75.w
                                    : 0.3.w,
                          ),
                          alignment: Alignment.center,
                          child: RaisedButton(
                              child: Text("전체",
                                  style: _isTotal
                                      ? defaultRegularStyleWhite
                                      : defaultRegularStyle),
                              color: _isTotal ? mainColor : whiteColor,
                              onPressed: () {
                                setState(() {
                                  totalCheck();
                                  _isTotal ? refreshSelect() : fillSelect();
                                  _isTotal = !_isTotal;
                                });
                              }),
                        ),
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseRepository().getGradeUser(
                                companyCode: user.companyCode, level: 6),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Text("");
                              }
                              List<DocumentSnapshot> doc = snapshot.data.docs;
                              debugPrint("DocumentSnapshot " + doc.toString());
                              return PopupMenuButton(
                                  child: RaisedButton(
                                    disabledColor: whiteColor,
                                    child: Text(
                                      _approvalUserItem,
                                      style: defaultSmallStyle,
                                    ),
                                  ),
                                  onSelected: (value) {
                                    approvalUser = value;
                                    _approvalUserItem =
                                        userNameChangeWithoutTeam(value);
                                    setState(() {});
                                    //debugPrint("result of getIndex function " +
                                    //getIndex().toString());
                                    //debugPrint("result of _expense index " + _expense[index].documentID);
                                  },
                                  itemBuilder: (context) => doc
                                      .map((data) => _buildApprovalItem(
                                          user.companyCode, data, context))
                                      .toList());
                            }),
                        cardSpace,
                        CircleAvatar(
                          radius: SizerUtil.deviceType == DeviceType.Tablet
                              ? 4.5.w
                              : 6.0.w,
                          backgroundColor:
                              buttonChecker() ? blueColor : disableUploadBtn,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              Icons.arrow_upward,
                              color: whiteColor,
                              size: SizerUtil.deviceType == DeviceType.Tablet
                                  ? 4.5.w
                                  : 6.0.w,
                            ),
                            onPressed: () async {
                              var doc = await FirebaseFirestore.instance
                                  .collection("company")
                                  .doc(user.companyCode)
                                  .collection("user")
                                  .doc(user.mail)
                                  .get();
                              loginUserInfo =
                                  CompanyUser.fromMap(doc.data(), doc.id);

                              if (!buttonChecker()) {
                                toastNoItems(context);
                              } else {
                                writeExpenseApproval();
                                toastSuccess(context);
                              }

                              //bool _isInput = !(_expenseController.text == '' || _chosenItem == 0);
                              //await _isInput ? saveExpense() : InvalidData(context);

                              //result = true;
                              //Navigator.of(context).pop(result);
                              //return result;
                            },
                          ),
                        ),
                      ]),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

/// 결재자 종류 선택 메뉴
PopupMenuItem _buildApprovalItem(
    String companyCode, DocumentSnapshot data, BuildContext context) {
  final user = UserData.fromSnapshow(data);
  String approvalUser = userNameChange(user);

  /*if(user.team != "" && user.team != null) {
    approvalUser = user.team + " " + approvalUser;
  }

  if(user.position != "" && user.position != null) {
    approvalUser = approvalUser + " " + user.position;
  }*/

  return PopupMenuItem(
    height: 7.0.h,
    value: user,
    child: Row(
      children: [
        cardSpace,
        Text(
          approvalUser,
          style: defaultRegularStyle,
        ),
      ],
    ),
  );
}
