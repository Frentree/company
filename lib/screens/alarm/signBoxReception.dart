import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/models/companyUserModel.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/models/workApprovalModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:MyCompany/widgets/approval/approvalDetail.dart';
import 'package:MyCompany/widgets/bottomsheet/expense/expenseDetail.dart';
import 'package:MyCompany/widgets/card/approvalCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;

class SignBoxReception extends StatefulWidget {
  @override
  _SignBoxReceptionState createState() => _SignBoxReceptionState();
}

List<WorkApproval> approvalList;

class _SignBoxReceptionState extends State<SignBoxReception> {
  String orderByType = "createDate";
  bool _isOrderBy = true;
  LoginUserInfoProvider _loginUserInfoProvider;
  User loginUser;

  String approvalType = "종류";
  String status = "상태";
  String userMail = "";
  String user = "요청자";
  List<DateTime> dateRange = List(2);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    approvalList = List();

  }

  @override
  Widget build(BuildContext context) {
    _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context, listen: false);
    loginUser = _loginUserInfoProvider.getLoginUser();
    return Scaffold(
      /*floatingActionButton: FloatingActionButton(
        child: Text("결재"),
        onPressed: (){},
      ),*/
      body: Column(
        children: [
          Card(
            elevation: 0,
            shape: cardShape,
            child: Padding(
              padding: cardPadding,
              child: Container(
                height: cardTitleSizeH.h,
                child: Row(children: [
                  Container(
                    width: SizerUtil.deviceType == DeviceType.Tablet ? 15.0.w : 13.0.w,
                    alignment: Alignment.centerLeft,
                    child: PopupMenuButton(
                      child: RaisedButton(
                        padding: EdgeInsets.zero,
                        disabledColor: whiteColor,
                        child: Text(
                          approvalType,
                          style: cardBlueStyle,
                        ),
                      ),
                      onSelected: (value){
                        setState(() {
                          if(value == "전체"){
                            approvalType = "종류";
                          }
                          else{
                            approvalType = value;
                          }
                        });
                      },
                      itemBuilder: (context){
                        return <PopupMenuEntry<String>>[
                          PopupMenuItem(
                            height: 7.0.h,
                            value: "전체",
                            child: Row(
                              children: [
                                Text(
                                  "전체",
                                  style: defaultRegularStyle,
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            height: 7.0.h,
                            value: "경비",
                            child: Row(
                              children: [
                                Text(
                                  "경비",
                                  style: defaultRegularStyle,
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            height: 7.0.h,
                            value: "반차",
                            child: Row(
                              children: [
                                Text(
                                  "반차",
                                  style: defaultRegularStyle,
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            height: 7.0.h,
                            value: "연차",
                            child: Row(
                              children: [
                                Text(
                                  "연차",
                                  style: defaultRegularStyle,
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            height: 7.0.h,
                            value: "업무",
                            child: Row(
                              children: [
                                Text(
                                  "업무",
                                  style: defaultRegularStyle,
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            height: 7.0.h,
                            value: "외근",
                            child: Row(
                              children: [
                                Text(
                                  "외근",
                                  style: defaultRegularStyle,
                                ),
                              ],
                            ),
                          ),
                        ];
                      },
                    ),
                  ),
                  cardSpace,
                  Container(
                    width: SizerUtil.deviceType == DeviceType.Tablet ? 21.0.w : 19.0.w,
                    alignment: Alignment.center,
                    child: PopupMenuButton(
                      child: RaisedButton(
                        padding: EdgeInsets.zero,
                        disabledColor: whiteColor,
                        child: Text(
                          dateRange[0] == null ? "요청일자" : "${Format().dateToString(dateRange[0]).substring(6, 10)}" + (dateRange[1] == null ? "" : " ~ " + Format().dateToString(dateRange[1]).substring(6, 10)),
                          style: cardBlueStyle,
                        ),
                      ),
                      onSelected: (value){
                        if(value != null){
                          setState(() {
                            dateRange = value;
                          });
                        }
                      },
                      itemBuilder: (context){
                        DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
                        return <PopupMenuEntry<List<DateTime>>>[
                          PopupMenuItem(
                            height: 7.0.h,
                            value: [null, null],
                            child: Row(
                              children: [
                                Text(
                                  "전체",
                                  style: defaultRegularStyle,
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            height: 7.0.h,
                            value: [today.subtract(Duration(days: 7)), today],
                            child: Row(
                              children: [
                                Text(
                                  "1주일",
                                  style: defaultRegularStyle,
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            height: 7.0.h,
                            value: [today.subtract(Duration(days: 31)), today],
                            child: Row(
                              children: [
                                Text(
                                  "1개월",
                                  style: defaultRegularStyle,
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            height: 7.0.h,
                            value: null,
                            child: Row(
                              children: [
                                GestureDetector(
                                  child: Text(
                                    "기간선택",
                                    style: defaultRegularStyle,
                                  ),
                                  onTap: () async {
                                    print("기간선택 클릭");
                                    Navigator.pop(context, null);
                                    DateTime firstDate = dateRange[0] != null ? dateRange[0] : DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
                                    List<DateTime> pickedDateTime = await DateRangePicker.showDatePicker(
                                      context: context,
                                      initialFirstDate: firstDate,
                                      initialLastDate: dateRange[1] == null ? DateTime(firstDate.year, firstDate.month, firstDate.day, 23, 59) :dateRange[1],
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime(DateTime.now().year+2),
                                    );
                                    if (pickedDateTime != null && pickedDateTime.length >= 1) {
                                      setState(() {
                                        int i = 0;
                                        pickedDateTime.forEach((element) {
                                          dateRange[i] = element;
                                          i++;
                                        });

                                        if(pickedDateTime.length != 2){
                                          dateRange[1] = DateTime(dateRange[0].year, dateRange[0].month, dateRange[0].day, 23, 59);
                                        }
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ];
                      },
                    ),
                  ),
                  /*Container(
                    width: SizerUtil.deviceType == DeviceType.Tablet ? 21.0.w : 19.0.w,
                    alignment: Alignment.center,
                    child: GestureDetector(
                      child: Text(
                        dateRange[0] == null ? "요청일자" : "${Format().dateToString(dateRange[0]).substring(6, 10)}" + (dateRange[1] == null ? "" : " ~ " + Format().dateToString(dateRange[1]).substring(6, 10)),
                        style: cardBlueStyle,
                      ),
                      onTap: () async {
                        DateTime firstDate = dateRange[0] != null ? dateRange[0] : DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
                        List<DateTime> pickedDateTime = await DateRangePicker.showDatePicker(
                          context: context,
                          initialFirstDate: firstDate,
                          initialLastDate: dateRange[1] == null ? DateTime(firstDate.year, firstDate.month, firstDate.day, 23, 59) :dateRange[1],
                          firstDate: DateTime(2020),
                          lastDate: DateTime(DateTime.now().year+2),
                        );
                        if (pickedDateTime != null && pickedDateTime.length >= 1) {
                          setState(() {
                            int i = 0;
                            pickedDateTime.forEach((element) {
                              dateRange[i] = element;
                              i++;
                            });

                            if(pickedDateTime.length != 2){
                              dateRange[1] = DateTime(dateRange[0].year, dateRange[0].month, dateRange[0].day, 23, 59);
                            }
                          });
                        }
                      },
                    ),
                  ),*/
                  cardSpace,
                  Container(
                    width: SizerUtil.deviceType == DeviceType.Tablet ? 15.0.w : 13.0.w,
                    alignment: Alignment.center,
                    child: PopupMenuButton(
                      child: RaisedButton(
                        padding: EdgeInsets.zero,
                        disabledColor: whiteColor,
                        child: Text(
                          status,
                          style: cardBlueStyle,
                        ),
                      ),
                      onSelected: (value){
                        setState(() {
                          if(value == "전체"){
                            status = "상태";
                          }
                          else{
                            status = value;
                          }
                        });
                      },
                      itemBuilder: (context){
                        return <PopupMenuEntry<String>>[
                          PopupMenuItem(
                            height: 7.0.h,
                            value: "전체",
                            child: Row(
                              children: [
                                Text(
                                  "전체",
                                  style: defaultRegularStyle,
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            height: 7.0.h,
                            value: "요청",
                            child: Row(
                              children: [
                                Text(
                                  "요청",
                                  style: defaultRegularStyle,
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            height: 7.0.h,
                            value: "승인",
                            child: Row(
                              children: [
                                Text(
                                  "승인",
                                  style: defaultRegularStyle,
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            height: 7.0.h,
                            value: "반려",
                            child: Row(
                              children: [
                                Text(
                                  "반려",
                                  style: defaultRegularStyle,
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            height: 7.0.h,
                            value: "입금완료",
                            child: Row(
                              children: [
                                Text(
                                  "입금완료",
                                  style: defaultRegularStyle,
                                ),
                              ],
                            ),
                          ),
                        ];
                      },
                    ),
                  ),
                  cardSpace,
                  Expanded(
                    child: Center(
                      child: StreamBuilder(
                        stream: FirebaseRepository().getColleagueInfo(companyCode: loginUser.companyCode),
                        builder: (context, snapshot) {
                          if(!snapshot.hasData){
                            return Text(
                              user,
                              style: cardBlueStyle,
                            );
                          }
                          List<DocumentSnapshot> doc = snapshot.data.docs;
                          doc.add(null);
                          return PopupMenuButton(
                            child: RaisedButton(
                              disabledColor: whiteColor,
                              child: Text(
                                user,
                                style: cardBlueStyle,
                              ),
                            ),
                            onSelected: (value) {
                              setState(() {
                                if(value == "all"){
                                  user = "요청자";
                                  userMail = "";
                                }
                                else{
                                  user = "${value.team} ${value.name} ${value.position}";
                                  userMail = value.mail;
                                }
                              });
                            },
                            itemBuilder: (context) => doc.map((data) => _buildUserItem(data)).toList(),
                          );
                        },
                      ),
                    )
                  ),
                ]),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseRepository().requestAnnualLeave(
              companyCode: loginUser.companyCode,
              whereUser: "approvalMail",
              mail: loginUser.mail,
              isOrderBy: _isOrderBy,
              orderByType: orderByType,
            ),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              List<DocumentSnapshot> document = [];
              snapshot.data.docs.forEach((element) {
                if(dateRange[0] != null){
                }
                if((approvalType == "종류" ? element.data()["approvalType"] != approvalType : element.data()["approvalType"] == approvalType)
                    && (status == "상태" ? element.data()["status"] != status : element.data()["status"] == status)
                    && (userMail == "" ? element.data()["userMail"] != userMail : element.data()["userMail"] == userMail)
                    && (dateRange[0] == null ? element.data()["requestDate"] != null : dateRange[0].isBefore(Format().timeStampToDateTime((element.data()["createDate"]))) && dateRange[1].isAfter(Format().timeStampToDateTime((element.data()["createDate"]))))
                ){
                  document.add(element);
                }
              });



              return Expanded(
                  child: ListView(
                children: document.map((data) => _buildApprovalRequestList(context, data, loginUser)).toList(),
              ));
            },
          )
        ],
      ),
    );
  }
}

/// 사용자 선택 메뉴
PopupMenuItem _buildUserItem(DocumentSnapshot data) {
  final user = data != null ? CompanyUser.fromMap(data.data(), "") : null;

  return PopupMenuItem(
    height: 7.0.h,
    value: user != null ? user : "all",
    child: Row(
      children: [
        cardSpace,
        Text(
          user != null ? "${user.team} ${user.name} ${user.position}" : "전체",
          style: defaultRegularStyle,
        ),
      ],
    ),
  );
}

Widget _buildApprovalRequestList(BuildContext context, DocumentSnapshot data, User user) {
  final approval = WorkApproval.fromSnapshow(data);

  return StatefulBuilder(
    builder: (context, setState) {
      return InkWell(
        child: ApprovalCard(
            context:context,
            companyCode: user.companyCode,
            model: approval
        ),
        onTap: () {
          //상세보기
          switch(approval.approvalType) {
            case "연차" :
            case "반차" :
            case "외근" :
            case "업무" :
              annualLeaveApprovalBottomSheet(
                context: context,
                companyCode: user.companyCode,
                model: approval
              );
              break;
            case "경비" :
              ExpenseDetail(context, user.companyCode, approval, 2);
              break;
            default :
              break;
          };
        }
      );
    },
  );
}
