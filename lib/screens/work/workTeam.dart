// 팀을 선택하는 bottom sheet 입니다.

import 'dart:convert';

import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/models/companyUserModel.dart';
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/provider/user/loginUserInfo.dart';
import 'package:companyplaylist/repos/firebasecrud/companyUserCrudMethod.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

 workTeamPage(BuildContext context) async {
  //LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context);
  List<Map<String,String>> _teamList = List();

  // 로그인된 유저 정보 갖고 온다.
  SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
  User _loginUser = User.fromMap(await json.decode(_sharedPreferences.getString("loginUser")), null);

  String timeTitle = "";

  CompanyUserCrud _companyUser = CompanyUserCrud(_loginUser.companyCode);
  List<bool> _isValue = [];
  List<CompanyUser> _companyUserCategory = await _companyUser.fetchCompanyUser();

  // 자신의 계정 제거
  _companyUserCategory.removeWhere((element) => element.mail.endsWith(_loginUser.mail));

  for(var i=0 ; i < _companyUserCategory.length; i++){
    _isValue.add(false);
  }

  /*_companyUserCategory.then((value) =>
      value.forEach((element) {
        CompanyUser _cuMethod = CompanyUser();
        _cuMethod.name = element.name;
        _cuMethod.mail = element.mail;
        _companyUserList.add(_cuMethod);

      })
  );*/

  await showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20)
          )
      ),
      context: context,
      builder: (BuildContext context){
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState){
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                padding: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 10),
                height: 300,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          InkWell(
                            child: Text(
                              "취소",
                              style: customStyle(
                                fontSize: 14,
                                fontWeightName: "Regular",
                                fontColor: redColor
                              ),
                            ),
                            onTap: ()  {
                              Navigator.pop(context);
                            },
                          ),
                          Text(
                            "$timeTitle",
                            style: customStyle(
                                fontSize: 14,
                                fontWeightName: "Regular",
                                fontColor: mainColor
                            ),
                          ),
                          InkWell(
                            child: Text(
                              "완료",
                              style: customStyle(
                                  fontSize: 14,
                                  fontWeightName: "Regular",
                                  fontColor: redColor
                              ),
                            ),
                            onTap: () => {
                              Navigator.pop(context)
                            },
                          ),
                        ],
                      ),
                      SingleChildScrollView(
                        child: Container(
                          height: 200,
                          child: ListView.builder(
                            itemCount: _companyUserCategory.length,
                            itemBuilder: (BuildContext context, int index){
                              return CheckboxListTile(
                                title: Text(_companyUserCategory[index].name),
                                value: _isValue[index],
                                secondary: const Icon(Icons.ac_unit),
                                onChanged: (value){
                                  setState(() {
                                    _isValue[index] = value;

                                    if(value == true){
                                      Map<String, String> map = {
                                        "mail" : _companyUserCategory[index].mail,
                                        "name" : _companyUserCategory[index].name
                                      };
                                      _teamList.add(map);
                                    } else {
                                      Map<String, String> map = {
                                        "mail" : _companyUserCategory[index].mail,
                                        "name" : _companyUserCategory[index].name
                                      };
                                      _teamList.remove(map);
                                    }
                                  });
                                },
                              );
                            }
                          ),
                        ),
                      ),
                      /* Padding(
                        padding: EdgeInsets.only(bottom: 15),
                      ),*/
                    ]
                ),
              ),
            );
          },
        );
      }
  );
  return _teamList;
}