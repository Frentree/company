import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/models/expenseModel.dart';
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/provider/user/loginUserInfo.dart';
import 'package:companyplaylist/repos/firebaseRepository.dart';
import 'package:companyplaylist/widgets/card/expenseCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignBoxExpense extends StatefulWidget {
  @override
  _SignBoxExpenseState createState() => _SignBoxExpenseState();
}

class _SignBoxExpenseState extends State<SignBoxExpense> {
  FirebaseRepository _repository = FirebaseRepository();
  User user;

  @override
  void initState() {
    super.initState();
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              width: 1,
              color: boarderColor,
            )
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: customWidth(context: context, widthSize: 0.02),
                vertical: customHeight(context: context, heightSize: 0.01)),
            child: Container(
              height: customHeight(context: context, heightSize: 0.03),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      "지출일자",
                      style: customStyle(
                          fontSize: timeFontSize,
                          fontWeightName: "Regular",
                          fontColor: blueColor),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      "항목",
                      style: customStyle(
                          fontSize: timeFontSize,
                          fontWeightName: "Regular",
                          fontColor: blueColor),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      "금액",
                      style: customStyle(
                          fontSize: timeFontSize,
                          fontWeightName: "Regular",
                          fontColor: blueColor),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      "영수증",
                      style: customStyle(
                          fontSize: timeFontSize,
                          fontWeightName: "Regular",
                          fontColor: blueColor),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(left: 1),
                      )
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      "상태",
                      style: customStyle(
                          fontSize: timeFontSize,
                          fontWeightName: "Regular",
                          fontColor: blueColor),
                    ),
                  ),

                ]
              )
            ),
          )
        ),
        StreamBuilder(
            stream: _repository.getExpense(user.companyCode, user.mail),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              var _expense = [];
              snapshot.data.documents.forEach((element) {
                _expense.add(element);
              });

              if (_expense.length == 0) {
                return Expanded(
                    child: ListView(children: [
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        width: 1,
                        color: boarderColor,
                      ),
                    ),
                    child: Center(
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: customHeight(
                                  context: context, heightSize: 0.02)),
                          child: Text(
                            "항목이 없습니다.",
                            style: customStyle(
                                fontColor: blackColor,
                                fontSize: 16,
                                fontWeightName: "Medium"),
                          )),
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
                              _expense[index].data, _expense[index].documentID);
                          return ExpenseCard(
                              context, user.companyCode, _expenseData);
                        }));
              }
            })
      ],
    ));
  }
}
