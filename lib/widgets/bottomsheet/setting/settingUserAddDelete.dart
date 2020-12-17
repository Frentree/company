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
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:MyCompany/consts/screenSize/login.dart';
import 'package:MyCompany/consts/screenSize/widgetSize.dart';

final word = Words();
final _formKeyEnteredDate = GlobalKey<FormState>();

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
                      child: Column(
                        children: [
                          Expanded(
                            child: StreamBuilder(
                              stream: _repository.getApproval(companyCode: _loginUser.companyCode),
                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                if (snapshot.data == null) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                var _approvalData = [];

                                snapshot.data.documents.forEach((element) {
                                  _approvalData.add(element);
                                });

                                return Container(
                                  padding: cardPadding,
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 5.0.h,
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              child: Text(
                                                word.requestUser(),
                                                style: defaultRegularStyle,
                                              ),
                                            ),
                                            Container(
                                              height: 4.0.h,
                                              width: SizerUtil.deviceType == DeviceType.Tablet ? 15.0.w : 20.0.w,
                                              decoration: BoxDecoration(
                                                color: blueColor,
                                                borderRadius: BorderRadius.circular(
                                                    SizerUtil.deviceType == DeviceType.Tablet ? containerChipRadiusTW.w : containerChipRadiusMW.w
                                                ),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 0.75.w : 1.0.w,
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                "${_approvalData.length} ${word.count()}",
                                                style: defaultMediumWhiteStyle,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      emptySpace,
                                      Expanded(
                                        child: Container(
                                          child: _approvalData.length == 0 ? Center(
                                            child: Text(
                                              word.noDataApprove(),
                                              style: defaultMediumStyle,
                                            ),
                                          ): ListView.builder(
                                            itemCount: _approvalData.length,
                                            itemBuilder: (context, index){
                                              Approval _approval;
                                              _approval = Approval.fromMap(
                                                _approvalData[index].data(),
                                                _approvalData[index].documentID,
                                              );
                                              return GestureDetector(
                                                child: Card(
                                                  elevation: 0,
                                                  shape: cardShape,
                                                  child: Padding(
                                                    padding: cardPadding,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          height: cardTitleSizeH.h,
                                                          alignment: Alignment.centerLeft,
                                                          child: Text(
                                                            "[${_approval.name}] ${word.forAddUser()}",
                                                            style: cardTitleStyle,
                                                          ),
                                                        ),
                                                        emptySpace,
                                                        Container(
                                                          alignment: Alignment.centerRight,
                                                          height: cardSubTitleSizeH.h,
                                                          child: Text(
                                                            "${word.requestDate()}" + " ${_format.dateToString(_format.timeStampToDateTime(_approval.requestDate))}",
                                                            style: cardSubTitleStyle,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                onTap: (){
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        String dropDownPositionValue = word.notSelect();
                                                        String dropDownTeamValue = word.notSelect();
                                                        TextEditingController _enteredDateController = MaskedTextController(mask: '0000.00.00');
                                                        return StatefulBuilder(
                                                          builder: (context, setState) {
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
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            "${word.team()} : ",
                                                                            style: customStyle(
                                                                              fontSize: 12.0.sp,
                                                                            ),
                                                                          ),
                                                                          StreamBuilder(
                                                                            stream: _repository.getTeamList(companyCode: _loginUser.companyCode),
                                                                            builder: (context, snapshot) {
                                                                              if(!snapshot.hasData) return Text("");

                                                                              List<DocumentSnapshot> list = snapshot.data.documents;

                                                                              List<String> buttonList = List();
                                                                              buttonList.add(word.notSelect());
                                                                              list.map((value) {
                                                                                buttonList.add(value['teamName']);
                                                                              }).toList();

                                                                              return DropdownButton(
                                                                                value: dropDownTeamValue,

                                                                                onChanged: (value) {
                                                                                  setState(() {
                                                                                    dropDownTeamValue = value;
                                                                                  });
                                                                                },
                                                                                items: buttonList.map<DropdownMenuItem<String>>((value) {
                                                                                  return DropdownMenuItem<String>(
                                                                                    value: value,
                                                                                    child: Text(value,
                                                                                      style: customStyle(
                                                                                        fontSize: 12.0.sp,
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                }).toList(),
                                                                              );
                                                                            },
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            "${word.position()} : ",
                                                                            style: customStyle(
                                                                              fontSize: 12.0.sp,
                                                                            ),
                                                                          ),
                                                                          StreamBuilder(
                                                                            stream: _repository.getPositionList(companyCode: _loginUser.companyCode),
                                                                            builder: (context, snapshot) {
                                                                              if(!snapshot.hasData) return Text("");

                                                                              List<DocumentSnapshot> list = snapshot.data.documents;

                                                                              List<String> buttonList = List();
                                                                              buttonList.add(word.notSelect());
                                                                              list.map((value) {
                                                                                buttonList.add(value['position']);
                                                                              }).toList();

                                                                              return DropdownButton(
                                                                                value: dropDownPositionValue,

                                                                                onChanged: (value) {
                                                                                  setState(() {
                                                                                    dropDownPositionValue = value;
                                                                                  });
                                                                                },
                                                                                items: buttonList.map<DropdownMenuItem<String>>((value) {
                                                                                  return DropdownMenuItem<String>(
                                                                                    value: value,
                                                                                    child: Text(value,
                                                                                      style: customStyle(
                                                                                        fontSize: 12.0.sp,
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                }).toList(),
                                                                              );
                                                                            },
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            "${word.enteredDate()} : ",
                                                                            style: customStyle(
                                                                              fontSize: 12.0.sp,
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            child: Form(
                                                                              key: _formKeyEnteredDate,
                                                                              child: TextFormField(
                                                                                controller: _enteredDateController,
                                                                                style: customStyle(
                                                                                  fontSize: 12.0.sp,
                                                                                ),
                                                                                decoration: InputDecoration(
                                                                                  hintText: word.enteredDateCon(),
                                                                                  border: InputBorder.none,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ],
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
                                                                                  await _loginRepository.userApproval(
                                                                                    context: context,
                                                                                    approvalUserMail: _approval.mail,
                                                                                    position: dropDownPositionValue,
                                                                                    teamName: dropDownTeamValue,
                                                                                    enteredDate: _enteredDateController.text
                                                                                  );
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
                                                                            ),
                                                                            /*Container(
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
                                                                          )*/
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      });
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          ),
                          Divider(
                            thickness: 0.2.h,
                          ),
                          Expanded(
                            child: Container(
                              padding: cardPadding,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _retireeNameCon,
                                    style: defaultRegularStyle,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding: textFormPadding,
                                      hintText: word.deleteUserCon(),
                                      hintStyle: hintStyle,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: textFieldUnderLine,
                                        )
                                      ),
                                      prefixIconConstraints: BoxConstraints(),
                                      prefixIcon: Container(
                                        padding: EdgeInsets.symmetric(horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 0.75.w : 1.0.w),
                                        child: Icon(
                                          Icons.search,
                                          size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                                        ),
                                      ),
                                      suffixIconConstraints: BoxConstraints(),
                                      suffixIcon: Container(
                                        padding: EdgeInsets.symmetric(horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 0.75.w : 1.0.w),
                                        child: GestureDetector(
                                          child: Icon(
                                            Icons.cancel,
                                            size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                                          ),
                                          onTap: (){
                                            _retireeNameCon.clear();
                                          },
                                        ),
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
                                  emptySpace,
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
                                              child: Text(
                                                word.noSearch(),
                                                style: defaultMediumStyle,
                                              ),
                                            ),
                                          );
                                        }
                                        return ListView.builder(
                                          itemCount: searchCompanyUserResult.length,
                                          itemBuilder: (context, index){
                                            return GestureDetector(
                                              child: Card(
                                                elevation: 0,
                                                shape: cardShape,
                                                child: Padding(
                                                  padding: cardPadding,
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        height: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
                                                        width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
                                                        color: whiteColor,
                                                        child: FittedBox(
                                                          fit: BoxFit.cover,
                                                          child: Image.network( searchCompanyUserResult[index].profilePhoto),
                                                        )
                                                      ),
                                                      cardSpace,
                                                      cardSpace,
                                                      Container(
                                                        child: Text(
                                                          searchCompanyUserResult[index].name,
                                                          style: cardTitleStyle,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            )
                          ),
                        ],
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
