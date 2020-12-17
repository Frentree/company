import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/screens/home/homeMain.dart';
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
import 'package:MyCompany/i18n/word.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:MyCompany/consts/screenSize/login.dart';
import 'package:MyCompany/consts/screenSize/widgetSize.dart';

final word = Words();

settingUserAddDelete({BuildContext context, double statusBarHeight}) {
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
              print(statusBarHeight);
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
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
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(SizerUtil.deviceType == DeviceType.Tablet ? tabRadiusTW.w : tabRadiusMW.w),
                        color: tabColor,
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
                              onPressed: (){
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Expanded(
                            child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  word.userAddRquestAndDelete(),
                                  style: defaultMediumStyle,
                                )
                            ),
                          )
                        ],
                      ),
                    ),
                    emptySpace,
                    Expanded(
                      child: Container(
                        color: Colors.grey,
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
                                      color: Colors.yellow,
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
                                                    word.requestUser(),
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
                                                            "${_approvalData.length} ${word.count()}",
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
                                                  word.noDataApprove(),
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
                                                            "[${_approval.name}] ${word.forAddUser()}",
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
                                                                  "${word.requestDate()}" + " ${_format.dateToString(_format.timeStampToDateTime(_approval.requestDate))}",
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
                                                              "[${_approval.name}] ${word.forAddUser()}",
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
                                                                      "${word.name()} : ${_approval.name}",
                                                                      style: customStyle(
                                                                        fontSize: 12.0.sp,
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                        height: 1.5.h
                                                                    ),
                                                                    Text(
                                                                      "${word.email()} : ${_approval.mail}",
                                                                      style: customStyle(
                                                                        fontSize: 12.0.sp,
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                        height:1.5.h
                                                                    ),
                                                                    Text(
                                                                      "${word.birthDay()} : ${_approval.birthday}",
                                                                      style: customStyle(
                                                                        fontSize: 12.0.sp,
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      height: 1.5.h,
                                                                    ),
                                                                    Text(
                                                                      "${word.phone()} : ${_approval.phone}",
                                                                      style: customStyle(
                                                                        fontSize: 12.0.sp,
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      height: 1.5.h,
                                                                    ),
                                                                    Text(
                                                                      "${word.requestDate()} : ${_format.dateToString(_format.timeStampToDateTime(_approval.requestDate))}",
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
                                                                                word.accept(),
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
                                                                                word.refusal(),
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
                            /*Divider(
                              thickness: 1,
                            ),*/
                            Container(
                              color: Colors.green,
                              height: 36.5.h,
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
                                          word.deleteUser(),
                                          style: customStyle(
                                            fontSize: 12.0.sp,
                                          ),
                                        )
                                    ),
                                  ),
                                  Container(
                                    color: Colors.teal,
                                    height:10.0.h,
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
                                              hintText: word.deleteUserCon(),
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
                                                    child: Text(word.noSearch(),style: customStyle(
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
                                                                "[${searchCompanyUserResult[index].name}] ${word.resignationProcess()}",
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
                                                                        "${word.name()} : ${searchCompanyUserResult[index].name}",
                                                                        style: customStyle(
                                                                          fontSize: 12.0.sp,
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                          height: 1.5.h
                                                                      ),
                                                                      Text(
                                                                        "${word.email()} : ${searchCompanyUserResult[index].mail}",
                                                                        style: customStyle(
                                                                          fontSize: 12.0.sp,
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                          height: 1.5.h
                                                                      ),
                                                                      Text(
                                                                        "${word.birthDay()} : ${searchCompanyUserResult[index].birthday}",
                                                                        style: customStyle(
                                                                          fontSize: 12.0.sp,
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                          height: 1.5.h
                                                                      ),
                                                                      Text(
                                                                        "${word.phone()} : ${searchCompanyUserResult[index].phone}",
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
                                                                                  word.confirm(),
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
                                                                                  word.cencel(),
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
                    ),
                    emptySpace,
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
