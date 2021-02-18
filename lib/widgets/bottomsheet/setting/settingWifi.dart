import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/repos/login/loginRepository.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:MyCompany/consts/screenSize/login.dart';
import 'package:wifi/wifi.dart';
import 'package:MyCompany/models/wifiListModel.dart';

final _formKeyEnteredDate = GlobalKey<FormState>();

settingWifi({BuildContext context, double statusBarHeight}) async {
  Format _format = Format();
  FirebaseRepository _repository = FirebaseRepository();
  LoginRepository _loginRepository = LoginRepository();
  User _loginUser;


  List<WifiResult> allWifiList = await Wifi.list('');

  Map<String, bool> tempWifiMap = {};

  bool isModify = false;

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
                              onPressed: (){
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Expanded(
                            child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "WIFI 허용 목록",
                                  style: defaultMediumStyle,
                                )
                            ),
                          )
                        ],
                      ),
                    ),
                    emptySpace,
                    Expanded(
                      child: Padding(
                        padding: cardPadding,
                        child: FutureBuilder(
                          future: _repository.getWifiList(companyCode: _loginUser.companyCode),
                          builder: (context, snapshot){
                            if(!snapshot.hasData){
                              return CircularProgressIndicator();
                            }
                            else{
                              List<WifiList> useWifiList = [];
                              List<String> availableWifiList = [];

                              //현재 사용중인 와이파이 리스트 가져오기
                              snapshot.data.forEach((doc){
                                WifiList _wifi = WifiList.fromMap(doc.data(), doc.documentID);
                                useWifiList.add(_wifi);
                              });

                              if(isModify == false){
                                tempWifiMap = {};
                                useWifiList.forEach((element) {
                                  tempWifiMap.addAll({element.wifiName: true});
                                });
                              }

                              allWifiList.forEach((element) {
                                if(element.ssid != "" && (tempWifiMap.containsKey(element.ssid) == false || (tempWifiMap[element.ssid]) == false) && availableWifiList.contains(element.ssid) == false){
                                  availableWifiList.add(element.ssid);
                                }
                              });
                              return ListView(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          if(isModify == true){
                                            List<String> useWifiName = [];
                                            List<String> deleteWifiName = [];

                                            tempWifiMap.forEach((key, value) {
                                              if(useWifiList.where((element) => element.wifiName == key).isNotEmpty){
                                                if(value == false){
                                                  deleteWifiName.add(useWifiList.where((element) => element.wifiName == key).first.id);
                                                }
                                              }
                                              else{
                                                if(value == true){
                                                  useWifiName.add(key);
                                                }
                                              }
                                            });
                                            await _repository.addWifiList(wifiList: useWifiName, loginUser: _loginUser);
                                            await _repository.deleteWifiList(companyCode: _loginUser.companyCode, documentID: deleteWifiName);
                                          }
                                          setState(() {
                                            isModify = !isModify;
                                          });
                                        },
                                        child: Container(
                                          height: 4.0.h,
                                          width: SizerUtil.deviceType == DeviceType.Tablet ? 15.0.w : 20.0.w,
                                          decoration: BoxDecoration(
                                            color: isModify == false ? blueColor : redColor,
                                            borderRadius: BorderRadius.circular(
                                                SizerUtil.deviceType == DeviceType.Tablet ? containerChipRadiusTW.w : containerChipRadiusMW.w
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 0.75.w : 1.0.w,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            isModify == false ? "수정" : "완료",
                                            style: defaultMediumWhiteStyle,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  emptySpace,
                                  Text(
                                    "현재 사용중인 목록",
                                    style: defaultRegularStyle,
                                  ),
                                  emptySpace,
                                  Container(
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: tempWifiMap.values.where((element) => element == true).length,
                                        itemBuilder: (context, index){
                                          String _wifiName = tempWifiMap.entries.where((element) => element.value == true).elementAt(index).key;
                                          return Card(
                                            elevation: 0,
                                            shape: cardShape,
                                            child: Padding(
                                              padding: cardPadding,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    width: SizerUtil.deviceType == DeviceType.Tablet ? 72.0.w : 50.0.w,
                                                    height: cardTitleSizeH.h,
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(
                                                      _wifiName,
                                                      style: cardTitleStyle,
                                                    ),
                                                  ),
                                                  isModify ? IconButton(
                                                    constraints: BoxConstraints(),
                                                    padding: EdgeInsets.zero,
                                                    icon: Icon(
                                                      Icons.cancel,
                                                      color: blueColor,
                                                      size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                                                    ),
                                                    onPressed: (){
                                                      setState((){
                                                        tempWifiMap.update(_wifiName, (value) => false);
                                                        availableWifiList.add(_wifiName);
                                                      });
                                                    },
                                                  ) : Container()
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                    ),
                                  ),
                                  emptySpace,
                                  Text(
                                    "사용가능한 네트워크",
                                    style: defaultRegularStyle,
                                  ),
                                  emptySpace,
                                  Container(
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: availableWifiList.length,
                                        itemBuilder: (context, index){
                                          return Card(
                                            elevation: 0,
                                            shape: cardShape,
                                            child: Padding(
                                              padding: cardPadding,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    width: SizerUtil.deviceType == DeviceType.Tablet ? 72.0.w : 50.0.w,
                                                    height: cardTitleSizeH.h,
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(
                                                      availableWifiList[index],
                                                      style: cardTitleStyle,
                                                    ),
                                                  ),
                                                  isModify ? IconButton(
                                                    constraints: BoxConstraints(),
                                                    padding: EdgeInsets.zero,
                                                    icon: Icon(
                                                      Icons.add_circle,
                                                      color: blueColor,
                                                      size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
                                                    ),
                                                    onPressed: (){
                                                      setState((){
                                                        if(tempWifiMap.containsKey(availableWifiList[index])){
                                                          tempWifiMap.update(availableWifiList[index], (value) => true);
                                                        }
                                                        else{
                                                          tempWifiMap.addAll({availableWifiList[index]: true});
                                                        }
                                                        availableWifiList.removeAt(index);
                                                      });
                                                    },
                                                  ) : Container()
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                    ),
                                  ),
                                ],
                              );
                            }
                          }
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
