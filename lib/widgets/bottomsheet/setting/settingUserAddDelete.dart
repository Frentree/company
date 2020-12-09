import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:MyCompany/models/approvalModel.dart';
import 'package:MyCompany/models/companyUserModel.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/repos/login/loginRepository.dart';
import 'package:MyCompany/screens/setting/gradeMain.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

settingUserAddDelete(BuildContext context) {
  Format _format = Format();
  FirebaseRepository _repository = FirebaseRepository();
  LoginRepository _loginRepository = LoginRepository();
  User _loginUser;

  TextEditingController _retireeNameCon = TextEditingController();

  Future<List<DocumentSnapshot>> searchResults;

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(30),
        topLeft: Radius.circular(30),
      ),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          LoginUserInfoProvider _loginUserInfoProvider =
          Provider.of<LoginUserInfoProvider>(context);
          _loginUser = _loginUserInfoProvider.getLoginUser();
          return GestureDetector(
            onTap: (){
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                height: heightRatio(context: context, heightRatio: 0.895),
                padding: EdgeInsets.symmetric(
                  horizontal: widthRatio(
                    context: context,
                    widthRatio: 0.02,
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                    ),
                    Container(
                      height: heightRatio(
                        context: context,
                        heightRatio: 0.075,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: widthRatio(context: context, widthRatio: 0.1),
                            child: Center(
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ),
                          Container(
                            width: widthRatio(context: context, widthRatio: 0.1),
                            child: Center(
                                child: Icon(Icons.person_add_alt_1_outlined)),
                          ),
                          Container(
                            width: widthRatio(context: context, widthRatio: 0.4),
                            child: font(text: "사용자 추가 요청/삭제"),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: widthRatio(
                          context: context,
                          widthRatio: 0.02,
                        ),
                      ),
                      child: Column(
                        children: [
                          StreamBuilder(
                            stream: _repository.getApproval(
                              companyCode: _loginUser.companyCode,
                            ),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.data == null) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              var _approvalData = [];

                              snapshot.data.documents.forEach((element) {
                                _approvalData.add(element);
                              });

                              return Column(
                                children: [
                                  Container(
                                    height: heightRatio(
                                      context: context,
                                      heightRatio: 0.38,
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: heightRatio(
                                            context: context,
                                            heightRatio: 0.05,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: widthRatio(
                                                    context: context,
                                                    widthRatio: 0.3),
                                                child: font(text: "사용자 추가 요청"),
                                              ),
                                              Container(
                                                width: widthRatio(
                                                    context: context,
                                                    widthRatio: 0.3),
                                                child: Center(
                                                  child: Container(
                                                    width: widthRatio(
                                                        context: context,
                                                        widthRatio: 0.15),
                                                    height: heightRatio(
                                                      context: context,
                                                      heightRatio: 0.03,
                                                    ),
                                                    decoration: BoxDecoration(
                                                        color: blueColor,
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            12)),
                                                    child: font(
                                                      text:
                                                      "${_approvalData.length} 건",
                                                      textStyle: customStyle(
                                                        fontColor: whiteColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: heightRatio(
                                            context: context,
                                            heightRatio: 0.33,),
                                          child: _approvalData.length == 0
                                              ? Center(
                                            child: Container(
                                              width: widthRatio(
                                                  context: context,
                                                  widthRatio: 0.5),
                                              child: font(
                                                  text: "승인할 데이터가 없습니다."),
                                            ),
                                          )
                                              : ListView.separated(
                                            itemCount: _approvalData.length,
                                            itemBuilder: (context, index) {
                                              Approval _approval;
                                              _approval = Approval.fromMap(
                                                _approvalData[index].data(),
                                                _approvalData[index]
                                                    .documentID,
                                              );
                                              return GestureDetector(
                                                child: Container(
                                                  height: heightRatio(
                                                      context: context,
                                                      heightRatio: 0.1),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Container(
                                                        height: heightRatio(
                                                            context: context,
                                                            heightRatio:
                                                            0.06),
                                                        child: Text(
                                                          "[${_approval.name}] 님의 사용자 추가 요청",
                                                          style: customStyle(
                                                            fontSize: 18,
                                                            fontColor:
                                                            grayColor,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                          height: heightRatio(
                                                              context:
                                                              context,
                                                              heightRatio:
                                                              0.04),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                            children: [
                                                              Text(
                                                                "요청일자 ${_format.dateToString(_format.timeStampToDateTime(_approval.requestDate))}",
                                                                style:
                                                                customStyle(
                                                                  fontSize:
                                                                  13,
                                                                  fontColor:
                                                                  grayColor,
                                                                ),
                                                              ),
                                                            ],
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                onTap: (){
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return SimpleDialog(
                                                          title: Text(
                                                            "[${_approval.name}] 님의 사용자 추가 요청",
                                                            style: customStyle(
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets.symmetric(
                                                                vertical: heightRatio(
                                                                  context: context,
                                                                  heightRatio: 0.01,
                                                                ),
                                                                horizontal: widthRatio(
                                                                  context: context,
                                                                  widthRatio: 0.05,
                                                                ),
                                                              ),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                      "이름 : ${_approval.name}"
                                                                  ),
                                                                  Container(
                                                                    height: heightRatio(
                                                                      context: context,
                                                                      heightRatio: 0.01,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                      "이메일 : ${_approval.mail}"
                                                                  ),
                                                                  Container(
                                                                    height: heightRatio(
                                                                      context: context,
                                                                      heightRatio: 0.01,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                      "생년월일 : ${_approval.birthday}"
                                                                  ),
                                                                  Container(
                                                                    height: heightRatio(
                                                                      context: context,
                                                                      heightRatio: 0.01,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                      "전화번호 : ${_approval.phone}"
                                                                  ),
                                                                  Container(
                                                                    height: heightRatio(
                                                                      context: context,
                                                                      heightRatio: 0.01,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                      "요청일자 : ${_format.dateToString(_format.timeStampToDateTime(_approval.requestDate))}"
                                                                  ),
                                                                  Container(
                                                                    height: heightRatio(
                                                                      context: context,
                                                                      heightRatio: 0.02,
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    height: heightRatio(
                                                                      context: context,
                                                                      heightRatio: 0.04,
                                                                    ),
                                                                    width: widthRatio(
                                                                      context: context,
                                                                      widthRatio: 1,
                                                                    ),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        Container(
                                                                          width: widthRatio(
                                                                            context: context,
                                                                            widthRatio: 0.2,
                                                                          ),
                                                                          child: RaisedButton(
                                                                            elevation: 0.0,
                                                                            color: blueColor,
                                                                            child: Text(
                                                                              "승낙",
                                                                              style: customStyle(
                                                                                fontColor: whiteColor,
                                                                              ),
                                                                            ),
                                                                            shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(12),
                                                                            ),
                                                                            onPressed: () async {
                                                                              _approval.state = 1;
                                                                              _approval.signUpApprover = _loginUser.mail;
                                                                              _approval.approvalDate = _format.dateTimeToTimeStamp(DateTime.now());

                                                                              await _repository.updateApproval(
                                                                                companyCode: _loginUser.companyCode,
                                                                                approvalModel: _approval,
                                                                              );
                                                                              await _loginRepository.userApproval(approvalUserMail: _approval.mail, context: context);
                                                                              Navigator.pop(context);
                                                                            },
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          width: widthRatio(
                                                                            context: context,
                                                                            widthRatio: 0.1,
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          width: widthRatio(
                                                                            context: context,
                                                                            widthRatio: 0.2,
                                                                          ),
                                                                          child: RaisedButton(
                                                                            elevation: 0.0,
                                                                            color: blueColor,
                                                                            child: Text(
                                                                              "거절",
                                                                              style: customStyle(
                                                                                fontColor: whiteColor,
                                                                              ),
                                                                            ),
                                                                            shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(12),
                                                                            ),
                                                                            onPressed: () async {
                                                                              _approval.state = 2;
                                                                              _approval.signUpApprover = _loginUser.mail;
                                                                              _approval.approvalDate = _format.dateTimeToTimeStamp(DateTime.now());

                                                                              await _repository.updateApproval(
                                                                                companyCode: _loginUser.companyCode,
                                                                                approvalModel: _approval,
                                                                              );
                                                                              await _loginRepository.userRejection(approvalUserMail: _approval.mail, context: context);
                                                                              Navigator.pop(context);
                                                                            },
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      });
                                                },
                                              );
                                            },
                                            separatorBuilder:
                                                (context, index) {
                                              return Divider();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },),
                          Divider(
                            thickness: 1,
                          ),
                          Container(
                            height: heightRatio(
                              context: context,
                              heightRatio: 0.38,
                            ),
                            width: widthRatio(
                              context: context,
                              widthRatio: 1,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: heightRatio(
                                    context: context,
                                    heightRatio: 0.05,
                                  ),
                                  child: Container(
                                    width: widthRatio(
                                        context: context, widthRatio: 0.35),
                                    child: font(text: "사용자 삭제(퇴사자)"),
                                  ),
                                ),
                                Container(
                                  height: heightRatio(
                                    context: context,
                                    heightRatio: 0.33,
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: heightRatio(
                                            context: context,
                                            heightRatio: 0.06
                                        ),
                                        child: TextFormField(
                                          controller: _retireeNameCon,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: grayColor,
                                                  width: 1
                                              ),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            prefixIcon: Icon(
                                              Icons.search,
                                            ),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                Icons.cancel,
                                              ),
                                              onPressed: (){
                                                _retireeNameCon.clear();
                                              },
                                            ),
                                            hintText: "삭제할 직원 이름을 입력하세요",
                                            hintStyle: TextStyle(
                                                fontFamily: "NotoSansKR",
                                              fontSize: 13,
                                            ),
                                          ),
                                          onFieldSubmitted: ((value){
                                            if(value == "" ){
                                              return null;
                                            }
                                            else{
                                              Future<List<DocumentSnapshot>> result = _repository.searchCompanyUser(
                                                loginUserMail: _loginUser.mail,
                                                companyUserName: _retireeNameCon.text,
                                                companyCode: _loginUser.companyCode,
                                              );
                                              setState((){
                                                searchResults = result;
                                              });
                                            }
                                          }),
                                        ),
                                      ),
                                      Container(
                                        height: heightRatio(
                                            context: context,
                                            heightRatio: 0.01
                                        ),
                                      ),
                                      searchResults == null ? Container() : Expanded(
                                        child: FutureBuilder(
                                          future: searchResults,
                                          builder: (context, snapshot){
                                            if(!snapshot.hasData){
                                              return Center(
                                                child: CircularProgressIndicator(),
                                              );
                                            }
                                            List<CompanyUser> searchCompanyUserResult = [];
                                            print("데이터 ${snapshot.data}");
                                            snapshot.data.forEach((doc){
                                              print(doc.data());
                                              CompanyUser _companyUser = CompanyUser.fromMap(doc.data(), doc.documentID);
                                              searchCompanyUserResult.add(_companyUser);
                                            });
                                            if(searchCompanyUserResult.length == 0){
                                              return Container(
                                                child: Center(
                                                  child: Text("검색 결과 없음"),
                                                ),
                                              );
                                            }
                                            print(searchCompanyUserResult.length);
                                            return ListView.separated(
                                              itemCount: searchCompanyUserResult.length,
                                              itemBuilder: (context, index){
                                                return GestureDetector(
                                                  child: Container(
                                                    height: heightRatio(
                                                        context: context,
                                                        heightRatio: 0.05
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: widthRatio(
                                                            context: context,
                                                            widthRatio: 0.1,
                                                          ),
                                                          child: CircleAvatar(
                                                            backgroundImage: NetworkImage(
                                                              searchCompanyUserResult[index].profilePhoto,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: widthRatio(
                                                            context: context,
                                                            widthRatio: 0.05,
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            searchCompanyUserResult[index].name,
                                                            style: customStyle(
                                                                fontSize: 20
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  onTap: (){
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return SimpleDialog(
                                                            title: Text(
                                                              "[${searchCompanyUserResult[index].name}] 님의 퇴사 처리",
                                                              style: customStyle(
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsets.symmetric(
                                                                  vertical: heightRatio(
                                                                    context: context,
                                                                    heightRatio: 0.01,
                                                                  ),
                                                                  horizontal: widthRatio(
                                                                    context: context,
                                                                    widthRatio: 0.05,
                                                                  ),
                                                                ),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                        "이름 : ${searchCompanyUserResult[index].name}"
                                                                    ),
                                                                    Container(
                                                                      height: heightRatio(
                                                                        context: context,
                                                                        heightRatio: 0.01,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                        "이메일 : ${searchCompanyUserResult[index].mail}"
                                                                    ),
                                                                    Container(
                                                                      height: heightRatio(
                                                                        context: context,
                                                                        heightRatio: 0.01,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                        "생년월일 : ${searchCompanyUserResult[index].birthday}"
                                                                    ),
                                                                    Container(
                                                                      height: heightRatio(
                                                                        context: context,
                                                                        heightRatio: 0.01,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                        "전화번호 : ${searchCompanyUserResult[index].phone}"
                                                                    ),
                                                                    Container(
                                                                      height: heightRatio(
                                                                        context: context,
                                                                        heightRatio: 0.01,
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      height: heightRatio(
                                                                        context: context,
                                                                        heightRatio: 0.02,
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      height: heightRatio(
                                                                        context: context,
                                                                        heightRatio: 0.04,
                                                                      ),
                                                                      width: widthRatio(
                                                                        context: context,
                                                                        widthRatio: 1,
                                                                      ),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Container(
                                                                            width: widthRatio(
                                                                              context: context,
                                                                              widthRatio: 0.2,
                                                                            ),
                                                                            child: RaisedButton(
                                                                              elevation: 0.0,
                                                                              color: blueColor,
                                                                              child: Text(
                                                                                "퇴사",
                                                                                style: customStyle(
                                                                                  fontColor: whiteColor,
                                                                                ),
                                                                              ),
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(12),
                                                                              ),
                                                                              onPressed: () async {
                                                                                await _repository.deleteCompanyUser(companyCode: _loginUser.companyCode, companyUserModel: searchCompanyUserResult[index]);
                                                                                await _loginRepository.userLeave(
                                                                                    context: context,
                                                                                    leaveUserMail: searchCompanyUserResult[index].mail
                                                                                );
                                                                                Future<List<DocumentSnapshot>> result = _repository.searchCompanyUser(
                                                                                  loginUserMail: _loginUser.mail,
                                                                                  companyUserName: _retireeNameCon.text,
                                                                                  companyCode: _loginUser.companyCode,
                                                                                );
                                                                                setState((){
                                                                                  searchResults = result;
                                                                                });
                                                                                Navigator.pop(context);
                                                                              },
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            width: widthRatio(
                                                                              context: context,
                                                                              widthRatio: 0.1,
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            width: widthRatio(
                                                                              context: context,
                                                                              widthRatio: 0.2,
                                                                            ),
                                                                            child: RaisedButton(
                                                                              elevation: 0.0,
                                                                              color: blueColor,
                                                                              child: Text(
                                                                                "취소",
                                                                                style: customStyle(
                                                                                  fontColor: whiteColor,
                                                                                ),
                                                                              ),
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(12),
                                                                              ),
                                                                              onPressed: () async {
                                                                                Navigator.pop(context);
                                                                              },
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        });
                                                  },
                                                );
                                              },
                                              separatorBuilder:
                                                  (context, index) {
                                                return Divider();
                                              },
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
