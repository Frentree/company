import 'dart:async';

import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:MyCompany/models/annualModel.dart';
import 'package:MyCompany/models/inquireModel.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/screens/setting/organizationChart.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:MyCompany/widgets/bottomsheet/annual/annualLeaveMain.dart';
import 'package:MyCompany/widgets/bottomsheet/pickMonth.dart';
import 'package:MyCompany/widgets/bottomsheet/pickYear.dart';
import 'package:MyCompany/widgets/dialog/annualDialogList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SettingExpenseAnnualDetail extends StatefulWidget {
  @override
  _SettingExpenseAnnualDetailState createState() => _SettingExpenseAnnualDetailState();
}

class _SettingExpenseAnnualDetailState extends State<SettingExpenseAnnualDetail> {
  User _loginUser;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _commentControll.text = "";
    _teamItem = "전체";
    selectedMonth = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context);
    _loginUser = _loginUserInfoProvider.getLoginUser();

    return Scaffold(
      backgroundColor: whiteColor,
      body: _buildAnnaulBody(context, _loginUser, setState),
    );
  }
}

final TextEditingController _commentControll = TextEditingController();
final ScrollController _scrollController = ScrollController();
String _teamItem = "전체";
DateTime selectedMonth = DateTime.now();

Widget _buildAnnaulBody(BuildContext context, User user, setState) {
  return FutureBuilder<QuerySnapshot>(
    future: FirebaseRepository().getAnnual(
      companyCode: user.companyCode,
      team: _teamItem,
      year: selectedMonth.year.toString()
    ),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

      List<DocumentSnapshot> doc = snapshot.data.docs;

      return Column(
        children: [
          Expanded(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                          (context, index) => _buildAnnaulListItem(context, doc[index], user, setState), //_buildListItem(context, snapshot[index], user),
                      childCount: doc.length),
                ),
              ],
            ),
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
                            DateFormat('yyyy년').format(selectedMonth),
                            style: containerChipStyle,
                          ),
                          onTap: () async {
                            selectedMonth =
                            await pickYear(context, selectedMonth);
                            setState(() {
                              //refreshSelect();
                              //totalCheck();
                            });
                          },
                        ),
                        Padding(padding: EdgeInsets.only(left: 10.0)),
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseRepository().getTeamList(
                              companyCode: user.companyCode,),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Text("");
                              }
                              List<DocumentSnapshot> doc = snapshot.data.docs;
                              List<String> temaName = List();

                              temaName.add("전체");

                              doc.forEach((element) {
                                temaName.add(element.data()["teamName"]);
                              });

                              return PopupMenuButton(
                                  child: RaisedButton(
                                    disabledColor: whiteColor,
                                    child: Text(
                                      _teamItem,
                                      style: containerChipStyle,
                                    ),
                                  ),
                                  onSelected: (value) {
                                    _teamItem = value;
                                    setState(() {});
                                    //debugPrint("result of getIndex function " +
                                    //getIndex().toString());
                                    //debugPrint("result of _expense index " + _expense[index].documentID);

                                  },
                                  itemBuilder: (context) =>
                                      temaName.map((data) => _buildTeamItem(data, context)).toList()
                              );
                            }),
                        cardSpace,
                      ]),
                    ),
                  ),
                ],
              )),
          emptySpace,
        ],
      );
    },
  );
}


Widget _buildAnnaulListItem(BuildContext context, DocumentSnapshot data, User user, setState) {
  final annual = AnnualModel.fromSnapshow(data);
  Format _format = Format();
  return Container(
    child: Card(
      elevation: 0,
      shape: cardShape,
      child: Padding(
        padding: cardPadding,
        child: Container(
          height: cardTitleSizeH.h,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    annual.name,
                    style: cardMainStyle,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    annual.maxAnnual.toString() + " 일",
                    style: cardMainStyle,
                  ),
                )
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    (annual.maxAnnual-annual.useAnnual).toString() + " 일",
                    style: cardMainStyle,
                  ),
                )
              ),
              IconButton(
                iconSize: 15,
                icon: Icon(
                  Icons.arrow_forward_ios
                ),
                onPressed: () {
                  getAnnualListDialog(
                    mail: annual.mail,
                    year: selectedMonth.year.toString(),
                    companyCode: user.companyCode,
                    context: context,
                  );
                },
              )
            ],
          ),
        ),
      ),
    ),
  );
}


/// 결재자 종류 선택 메뉴
PopupMenuItem _buildTeamItem(String data, BuildContext context) {

  return PopupMenuItem(
    height: 7.0.h,
    value: data,
    child: Row(
      children: [
        cardSpace,
        Text(
          data,
          style: defaultRegularStyle,
        ),
      ],
    ),
  );
}

