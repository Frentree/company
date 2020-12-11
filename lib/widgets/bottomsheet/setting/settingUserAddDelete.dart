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
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:MyCompany/consts/screenSize/login.dart';
import 'package:MyCompany/consts/screenSize/widgetSize.dart';

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
        topRight: Radius.circular(pageRadiusW.w),
        topLeft: Radius.circular(pageRadiusW.w),
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
                height: 90.0.h,
                padding: EdgeInsets.symmetric(
                  horizontal: 3.0.w,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(pageRadiusW.w),
                    topRight: Radius.circular(pageRadiusW.w),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 1.0.h),
                    ),
                    Container(
                      height: 7.0.h,
                      child: Row(
                        children: [
                          Container(
                            width: 10.0.w,
                            child: Center(
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  size: iconSizeW.w,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ),
                          Container(
                            width: 15.0.w,
                            child: Center(
                                child: Icon(Icons.person_add_alt_1_outlined, size: iconSizeW.w,)),
                          ),
                          Container(
                              width: 50.0.w,
                              child: Text(
                                "사용자 추가 요청/삭제",
                                style: customStyle(
                                    fontSize: homePageDefaultFontSize.sp
                                ),
                              )
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.0.w,
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
                                    height: 38.0.h,
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 5.0.h,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: 30.0.w,
                                                child: Text(
                                                  "사용자 추가 요청",
                                                  style: customStyle(
                                                    fontSize: 12.0.sp,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 30.0.w,
                                                child: Center(
                                                  child: Container(
                                                      width: 15.0.w,
                                                      height: 4.0.h,
                                                      decoration: BoxDecoration(
                                                          color: blueColor,
                                                          borderRadius:
                                                          BorderRadius.circular(12.0.w)),
                                                      child: Center(
                                                        child: Text(
                                                          "${_approvalData.length} 건",
                                                          style: customStyle(
                                                            fontSize: 12.0.sp,
                                                          ),
                                                        ),
                                                      )
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 30.0.h,
                                          child: _approvalData.length == 0
                                              ? Center(
                                              child: Text(
                                                "승인할 데이터가 없습니다.",
                                                style: customStyle(
                                                    fontSize: 13.0.sp
                                                ),
                                              )
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
                                                  height: 10.0.h,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Container(
                                                        height: 6.0.h,
                                                        child: Text(
                                                          "[${_approval.name}] 님의 사용자 추가 요청",
                                                          style: customStyle(
                                                            fontSize: 15.0.sp,
                                                            fontColor:
                                                            grayColor,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                          height: 4.0.h,
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
                                                                  13.0.sp,
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
                                                              fontSize: 15.0.sp,
                                                            ),
                                                          ),
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets.symmetric(
                                                                  vertical: 1.0.h,
                                                                  horizontal: 8.0.w
                                                              ),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    "이름 : ${_approval.name}",
                                                                    style: customStyle(
                                                                      fontSize: 12.0.sp,
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                      height: 1.5.h
                                                                  ),
                                                                  Text(
                                                                    "이메일 : ${_approval.mail}",
                                                                    style: customStyle(
                                                                      fontSize: 12.0.sp,
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                      height:1.5.h
                                                                  ),
                                                                  Text(
                                                                    "생년월일 : ${_approval.birthday}",
                                                                    style: customStyle(
                                                                      fontSize: 12.0.sp,
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    height: 1.5.h,
                                                                  ),
                                                                  Text(
                                                                    "전화번호 : ${_approval.phone}",
                                                                    style: customStyle(
                                                                      fontSize: 12.0.sp,
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    height: 1.5.h,
                                                                  ),
                                                                  Text(
                                                                    "요청일 : ${_format.dateToString(_format.timeStampToDateTime(_approval.requestDate))}",
                                                                    style: customStyle(
                                                                      fontSize: 12.0.sp,
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    height: 3.0.h,
                                                                  ),
                                                                  Container(
                                                                    height: 4.0.h,
                                                                    width: 100.0.w,
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        Container(
                                                                          width: 20.0.w,
                                                                          child: RaisedButton(
                                                                            elevation: 0.0,
                                                                            color: blueColor,
                                                                            child: Text(
                                                                              "승낙",
                                                                              style: customStyle(
                                                                                fontColor: whiteColor,
                                                                                fontSize: 12.0.sp,
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
                                                                          width: 10.0.w,
                                                                        ),
                                                                        Container(
                                                                          width: 20.0.w,
                                                                          child: RaisedButton(
                                                                            elevation: 0.0,
                                                                            color: blueColor,
                                                                            child: Text(
                                                                              "거절",
                                                                              style: customStyle(
                                                                                fontColor: whiteColor,
                                                                                fontSize: 12.0.sp,
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
                            height: 38.0.h,
                            width: widthRatio(
                              context: context,
                              widthRatio: 1,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 5.0.h,
                                  child: Container(
                                      width: 35.0.w,
                                      child: Text(
                                        "사용자 삭제(퇴사자)",
                                        style: customStyle(
                                          fontSize: 12.0.sp,
                                        ),
                                      )
                                  ),
                                ),
                                Container(
                                  height: 33.0.h,
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 8.0.h,
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
                                                fontSize: 11.0.sp
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
                                        height: 1.0.h,
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
                                            snapshot.data.forEach((doc){
                                              print(doc.data());
                                              CompanyUser _companyUser = CompanyUser.fromMap(doc.data(), doc.documentID);
                                              searchCompanyUserResult.add(_companyUser);
                                            });
                                            if(searchCompanyUserResult.length == 0){
                                              return Container(
                                                child: Center(
                                                  child: Text("검색 결과 없음",style: customStyle(
                                                      fontSize: 13.0.sp
                                                  ),),
                                                ),
                                              );
                                            }
                                            print(searchCompanyUserResult.length);
                                            return ListView.separated(
                                              itemCount: searchCompanyUserResult.length,
                                              itemBuilder: (context, index){
                                                return GestureDetector(
                                                  child: Container(
                                                    height: 5.0.h,
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: 10.0.w,
                                                          child: CircleAvatar(
                                                            backgroundImage: NetworkImage(
                                                              searchCompanyUserResult[index].profilePhoto,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 5.0.w,
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            searchCompanyUserResult[index].name,
                                                            style: customStyle(
                                                              fontSize: 20.0.sp,
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
                                                                fontSize: 15.0.sp,
                                                              ),
                                                            ),
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsets.symmetric(
                                                                    vertical: 1.0.h,
                                                                    horizontal: 8.0.w
                                                                ),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      "이름 : ${searchCompanyUserResult[index].name}",
                                                                      style: customStyle(
                                                                        fontSize: 12.0.sp,
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                        height: 1.5.h
                                                                    ),
                                                                    Text(
                                                                      "이메일 : ${searchCompanyUserResult[index].mail}",
                                                                      style: customStyle(
                                                                        fontSize: 12.0.sp,
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                        height: 1.5.h
                                                                    ),
                                                                    Text(
                                                                      "생년월일 : ${searchCompanyUserResult[index].birthday}",
                                                                      style: customStyle(
                                                                        fontSize: 12.0.sp,
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                        height: 1.5.h
                                                                    ),
                                                                    Text(
                                                                      "전화번호 : ${searchCompanyUserResult[index].phone}",
                                                                      style: customStyle(
                                                                        fontSize: 12.0.sp,
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                        height: 1.5.h
                                                                    ),
                                                                    Container(
                                                                      height: 3.0.h,
                                                                    ),
                                                                    Container(
                                                                      height: 4.0.h,
                                                                      width: 100.0.w,
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Container(
                                                                            width: 20.0.w,
                                                                            child: RaisedButton(
                                                                              elevation: 0.0,
                                                                              color: blueColor,
                                                                              child: Text(
                                                                                "퇴사",
                                                                                style: customStyle(
                                                                                  fontColor: whiteColor,
                                                                                  fontSize: 12.0.sp,
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
                                                                            width: 10.0.w,
                                                                          ),
                                                                          Container(
                                                                            width: 20.0.w,
                                                                            child: RaisedButton(
                                                                              elevation: 0.0,
                                                                              color: blueColor,
                                                                              child: Text(
                                                                                "취소",
                                                                                style: customStyle(
                                                                                  fontColor: whiteColor,
                                                                                  fontSize: 12.0.sp,
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
