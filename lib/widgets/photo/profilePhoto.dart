import 'package:MyCompany/consts/colorCode.dart';
import 'package:flutter/material.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:sizer/sizer.dart';

FirebaseRepository _repository = FirebaseRepository();

FutureBuilder profilePhoto({User loginUser}){
  return FutureBuilder(
    future: _repository.photoProfile(loginUser.companyCode, loginUser.mail),
    builder: (context, snapshot){
      if (!snapshot.hasData) {
        return CircularProgressIndicator();
      }
      else
        return Container(
          height: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
          width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
          color: whiteColor,
          child: FittedBox(
            fit: BoxFit.cover,
            child: Image.network(snapshot.data['profilePhoto']),
          )
        );
    },
  );
}
