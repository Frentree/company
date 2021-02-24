import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/models/inquireAdminModel.dart';
import 'package:MyCompany/screens/setting/organizationChart.dart';
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:MyCompany/widgets/bottomsheet/setting/settingInquireAdminChatDetail.dart';
import 'package:MyCompany/widgets/bottomsheet/setting/settingInquireDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:MyCompany/consts/screenSize/login.dart';



SettingInquireAdminChat({BuildContext context, InquireAdminModel model}) {
  User _loginUser;

  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        LoginUserInfoProvider _loginUserInfoProvider =
        Provider.of<LoginUserInfoProvider>(context);
        _loginUser = _loginUserInfoProvider.getLoginUser();

        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                padding: EdgeInsets.only(
                  left: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                  right: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
                  top: 4.0.h,
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
                                model.mail,
                                style: defaultMediumStyle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    emptySpace,
                    Expanded(
                      child: SettingInquireAdminChatDetail(model : model),
                    ),
                  ],
                ),
              );
            });
      }
  );
}
