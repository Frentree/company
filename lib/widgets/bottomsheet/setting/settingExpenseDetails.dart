import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/models/workApprovalModel.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:MyCompany/widgets/bottomsheet/setting/settingExpenseAnnualDetail.dart';
import 'package:MyCompany/widgets/card/settingExpenseDetailsCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:MyCompany/consts/screenSize/login.dart';



SettingExpenseDetails({BuildContext context, double statusBarHeight}) {
  User _loginUser;
  FirebaseRepository _repository = FirebaseRepository();
  String title = "경비";

  String _selectUserName = "전체";
  String _selectUserMail = "";

  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(pageRadiusW.w),
          topLeft: Radius.circular(pageRadiusW.w),
        ),
      ),
      builder: (context) {
        LoginUserInfoProvider _loginUserInfoProvider =
        Provider.of<LoginUserInfoProvider>(context);
        _loginUser = _loginUserInfoProvider.getLoginUser();

        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: MediaQuery.of(context).size.height - 10.0.h - statusBarHeight,
                padding: EdgeInsets.only(
                  left: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                  right: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                  top: 2.0.h,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(SizerUtil.deviceType == DeviceType.Tablet ? pageRadiusTW.w : pageRadiusMW.w),
                    topRight: Radius.circular(SizerUtil.deviceType == DeviceType.Tablet ? pageRadiusTW.w : pageRadiusMW.w),
                  ),
                  color: whiteColor,
                ),
                child: Column(
                  children: [

                    Container(
                      height: 6.0.h,
                      padding: EdgeInsets.symmetric(
                          horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 0.75.w : 1.0.w
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 6.0.h,
                            width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
                            child: IconButton(
                              constraints: BoxConstraints(),
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.keyboard_arrow_left_sharp,
                                size: SizerUtil.deviceType == DeviceType.Tablet ? iconSizeTW.w : iconSizeMW.w,
                                color: mainColor,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                title,
                                style: defaultMediumStyle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    emptySpace,
                    Card(
                      elevation: 0,
                      shape: cardShape,
                      child: Padding(
                        padding: cardPadding,
                        child: Container(
                          height: cardTitleSizeH.h,
                          child: Row(
                              children: [
                            Container(
                              width: SizerUtil.deviceType == DeviceType.Tablet ? 22.5.w : 33.0.w,
                              alignment: Alignment.center,
                              child: Text(
                                Words.word.name(),
                                style: cardBlueStyle,
                              ),
                            ),
                            cardSpace,
                            Container(
                              width: SizerUtil.deviceType == DeviceType.Tablet ? 22.5.w : 17.5.w,
                              alignment: Alignment.center,
                              child: Text(
                                "금액",
                                style: cardBlueStyle,
                              ),
                            ),
                            cardSpace,
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "입금",
                                  style: cardBlueStyle,
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: _repository.getApprovalExpense(companyCode: _loginUser.companyCode),
                      builder: (context, snapshot) {
                        if(snapshot.data == null){
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        Map<String, List<dynamic>> _expenseData = {};

                        snapshot.data.docs.forEach((element) {
                          if(!_expenseData.keys.contains(element.data()["userMail"])){
                            _expenseData[element.data()["userMail"]] = [];
                          }
                          _expenseData[element.data()["userMail"]].add(element);
                        });

                        print(_expenseData);
                        
                        if(_expenseData.keys.length == 0){
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
                                        "미입금 경비내역이 없습니다.",
                                        style: cardTitleStyle,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        else{
                          return Expanded(
                            child: ListView.builder(
                              itemCount: _expenseData.keys.length,
                              itemBuilder: (context, index){
                                return FutureBuilder(
                                  future: _repository.getMyCompanyInfo(companyCode: _loginUser.companyCode, myMail: _expenseData.keys.elementAt(index)),
                                  builder: (context, snapshot) {
                                    if(snapshot.data == null){
                                      return Center(child: Text(""),);
                                    }
                                    return settingExpenseDetailCard(
                                      context: context,
                                      workApprovalModel: _expenseData[_expenseData.keys.elementAt(index)],
                                      companyUserInfo: snapshot.data,
                                      loginUser: _loginUser,
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        }
                      },
                    )
                  ],
                ),
              );
            });
      }
  );
}
