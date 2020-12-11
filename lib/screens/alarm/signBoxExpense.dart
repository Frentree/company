import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:MyCompany/models/expenseModel.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/widgets/card/expenseCard.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:flutter/material.dart';
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
            borderRadius: BorderRadius.circular(3.0.w),
            side: BorderSide(
              width: 1,
              color: boarderColor,
            )
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 2.0.w,
                vertical: 1.0.h),
            child: Container(
              height: 3.0.h,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        word.exDate(),
                        style: customStyle(
                            fontSize: 11.0.sp,
                            fontWeightName: "Regular",
                            fontColor: blueColor),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        word.category(),
                        style: customStyle(
                            fontSize: 11.0.sp,
                            fontWeightName: "Regular",
                            fontColor: blueColor),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        word.amount(),
                        style: customStyle(
                            fontSize: 11.0.sp,
                            fontWeightName: "Regular",
                            fontColor: blueColor),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        word.receipt(),
                        style: customStyle(
                            fontSize: 11.0.sp,
                            fontWeightName: "Regular",
                            fontColor: blueColor),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        word.state(),
                        style: customStyle(
                            fontSize: 11.0.sp,
                            fontWeightName: "Regular",
                            fontColor: blueColor),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "",
                        style: customStyle(
                            fontSize: 11.0.sp,
                            fontWeightName: "Regular",
                            fontColor: blueColor),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "",
                        style: customStyle(
                            fontSize: 11.0.sp,
                            fontWeightName: "Regular",
                            fontColor: blueColor),
                      ),
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
                      borderRadius: BorderRadius.circular(3.0.w),
                      side: BorderSide(
                        width: 1,
                        color: boarderColor,
                      ),
                    ),
                    child: Center(
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 2.0.h),
                          child: Text(
                            word.categoryCon(),
                            style: customStyle(
                                fontColor: blackColor,
                                fontSize: 15.0.sp,
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
                              _expense[index].data(), _expense[index].documentID);
                          return ExpenseCard(
                              context, user.companyCode, _expenseData);
                        }));
              }
            })
      ],
    ));
  }
}
