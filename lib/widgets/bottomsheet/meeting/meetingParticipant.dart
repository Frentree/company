
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/models/companyUserModel.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sizer/sizer.dart';
import 'package:sizer/sizer_ext.dart';
import 'package:sizer/sizer_util.dart';


Map<dynamic,dynamic> chkUser = Map();


MeetingParticipant({BuildContext context, Map<dynamic,dynamic> companyUser, User loginUser}) async {
  bool isChk = false;
  int close = 0;

  if(companyUser != null){
    chkUser = Map.from(companyUser);
  } else {
    chkUser.clear();
  }
  await showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 40.0.h,
        padding: EdgeInsets.only(
          left: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
          right: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
          top: 2.0.h,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      iconSize: 18,
                      icon: Icon(Icons.arrow_back_ios_outlined),
                      onPressed: () {
                        //return companyUser;
                        close = 0;
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(child: Center(child: Text("참가자", style: defaultRegularStyle,))),
                    IconButton(
                      iconSize: 20,
                      icon: Icon(Icons.check),
                      onPressed: () {
                        //return chkUser;
                        close = 1;
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseRepository().getCompanyUsers(
                      companyCode: loginUser.companyCode,
                      mail: loginUser.mail
                    ),
                    builder: (context, snapshot) {
                      if(!snapshot.hasData){
                        return Container();
                      }
                      return _buildList(context, snapshot.data.docs, loginUser, isChk);
                    },
                  ),
                ),
              ]
          ),
        ),
      );
    },
  );
  if(close == 0) {
    return companyUser;
  } else {
    if(chkUser.length == 0){
      return null;
    }else {
      return chkUser;
    }
  }
}

Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot, User user, isChk) {
  return CustomScrollView(
    slivers: [
      SliverList(
        delegate: SliverChildBuilderDelegate(
                (context, index) => _buildListItem(context, snapshot[index], user, isChk),
            childCount: snapshot.length),
      ),
    ],
  );
}

Widget _buildListItem(BuildContext context, DocumentSnapshot data, User user, isChk) {
  final companyUser = CompanyUser.fromSnapshow(data);
  if(companyUser.mail != user.mail) {
    return Container(
      padding: cardPadding,
      height: 5.0.h,
      child: _buildUserList(context, companyUser, user.companyCode, isChk),
    );
  } else {
    return Container();
  }
}


Widget _buildUserList(BuildContext context, CompanyUser user, String companyCode, isChk) {
  isChk = chkUser.containsKey(user.mail);
  return StatefulBuilder(
    builder: (context, setState) {
      return InkWell(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              value: isChk,
              onChanged: (val){
                setState((){
                  isChk = val;
                  if(isChk) {
                    chkUser[user.mail] = user.name;
                  } else {
                    chkUser.remove(user.mail);
                  }
                });
              },
            ),
            CircleAvatar(
              backgroundColor: whiteColor,
              radius: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
              backgroundImage: NetworkImage(user.profilePhoto),
            ),
            Text(
              user.team,
              style: defaultRegularStyleGray,
            ),
            cardSpace,
            Text(
              user.name,
              style: defaultRegularStyle,
            ),
            cardSpace,
            Text(
              user.position,
              style: defaultRegularStyleGray,
            ),
          ],
        ),
        onTap: () {
          setState((){
            isChk = !isChk;
            if(isChk) {
              chkUser[user.mail] = user.name;
            } else {
              chkUser.remove(user.mail);
            }
          });
        },
      );
    },
  );
}
