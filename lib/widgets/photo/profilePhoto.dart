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
        return CircleAvatar(
          backgroundColor: whiteColor,
          radius: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
          backgroundImage: NetworkImage(snapshot.data['profilePhoto']),
        );
    },
  );
}
