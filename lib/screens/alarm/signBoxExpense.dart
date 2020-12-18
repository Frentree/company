import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
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
            shape: cardShape,
            child: Padding(
              padding: cardPadding,
              child: Container(
                height: scheduleCardDefaultSizeH.h,
                child: Row(
                  children: [
                    Container(
                      width: SizerUtil.deviceType == DeviceType.Tablet ? 19.0.w : 17.0.w,
                      alignment: Alignment.center,
                      child: Text(
                        word.exDate(),
                        style: cardBlueStyle,
                      ),
                    ),
                    cardSpace,
                    Container(
                      width: SizerUtil.deviceType == DeviceType.Tablet ? 15.0.w : 13.0.w,
                      alignment: Alignment.center,
                      child: Text(
                        word.category(),
                        style: cardBlueStyle,
                      ),
                    ),
                    cardSpace,
                    Container(
                      width: SizerUtil.deviceType == DeviceType.Tablet ? 15.0.w : 13.0.w,
                      alignment: Alignment.center,
                      child: Text(
                        word.amount(),
                        style: cardBlueStyle,
                      ),
                    ),
                    cardSpace,
                    Container(
                      width: SizerUtil.deviceType == DeviceType.Tablet ? 11.0.w : 9.0.w,
                      alignment: Alignment.center,
                      child: Text(
                        word.receipt(),
                        style: cardBlueStyle,
                      ),
                    ),
                    cardSpace,
                    Container(
                      width: SizerUtil.deviceType == DeviceType.Tablet ? 11.0.w : 9.0.w,
                      alignment: Alignment.center,
                      child: Text(
                        word.state(),
                        style: cardBlueStyle,
                      ),
                    ),
                  ]
                ),
              ),
            ),
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
                  child: ListView(
                    children: [
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
                    ]
                  )
                );
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: _expense.length,
                    itemBuilder: (context, index) {
                      dynamic _expenseData;
                      _expenseData = ExpenseModel.fromMap(
                        _expense[index].data(),
                        _expense[index].documentID,
                      );
                      return ExpenseCard(context, user.companyCode, _expenseData);
                    }
                  )
                );
              }
            },
          )
        ],
      ),
    );
  }
}
