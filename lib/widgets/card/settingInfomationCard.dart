import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/repos/firebaseRepository.dart';
import 'package:companyplaylist/repos/login/loginRepository.dart';
import 'package:companyplaylist/widgets/bottomsheet/setting/settingMyPageUpdate.dart';
import 'package:companyplaylist/widgets/form/textFormField.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

// 내 정보 화면
Widget getMyInfomationCard({BuildContext context, User user}){
  return Padding(
    padding: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
    child: Column(
      children: [
        Row(
          children: [
            Container(
              color: whiteColor,
              alignment: Alignment.center,
              width: customWidth(
                  context: context,
                  widthSize: 0.1
              ),
              child: GestureDetector(
                child: Container(
                  height: customHeight(
                      context: context,
                      heightSize: 0.05
                  ),
                  width: customWidth(
                      context: context,
                      widthSize: 0.1
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: whiteColor,
                      border: Border.all(color: whiteColor, width: 2)
                  ),
                  child: FutureBuilder(
                    future: Firestore.instance.collection("company").document(user.companyCode).collection("user").document(user.mail).get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Icon(
                            Icons.person_outline
                        );
                      }
                      return Image.network(
                          snapshot.data['profilePhoto']
                      );
                    },
                  ),
                ),
                onTap: (){
                },
              ),
            ),
            Padding(padding: EdgeInsets.only(left: 10)),
            Expanded(
              child: Text(
                user.name,
                style: customStyle(
                  fontSize: 14,
                  fontColor: mainColor,
                  fontWeightName: 'Medium',
                ),
              ),
            ),

            Text(
              "개발팀",
              style: customStyle(
                fontSize: 14,
                fontColor: grayColor,
                fontWeightName: 'Medium',
              ),
            ),
            Padding(padding: EdgeInsets.only(left: 15)),
            Text(
              "사원",
              style: customStyle(
                fontSize: 14,
                fontColor: grayColor,
                fontWeightName: 'Medium',
              ),
            ),
            Padding(padding: EdgeInsets.only(left: 15)),
            ActionChip(
              backgroundColor: blueColor,
              label: Text(
                "수정",
                style: customStyle(
                  fontSize: 14,
                  fontColor: whiteColor,
                  fontWeightName: 'Medium',
                ),
              ),
              onPressed: () {
                SettingMyPageUpdate(context);
              },
            ),

          ],
        ),
        SizedBox(
          height: customHeight(
              context: context,
              heightSize: 0.01
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                "입사일",
                style: customStyle(
                  fontSize: 14,
                  fontColor: mainColor,
                  fontWeightName: 'Medium',
                ),
              ),
            ),
            Expanded(
              child: Text(
                "2018.11.01",
                style: customStyle(
                  fontSize: 14,
                  fontColor: grayColor,
                  fontWeightName: 'Medium',
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: customHeight(
              context: context,
              heightSize: 0.01
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                "이메일",
                style: customStyle(
                  fontSize: 14,
                  fontColor: mainColor,
                  fontWeightName: 'Medium',
                ),
              ),
            ),
            Expanded(
              child: Text(
                user.mail,
                style: customStyle(
                  fontSize: 14,
                  fontColor: grayColor,
                  fontWeightName: 'Medium',
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: customHeight(
              context: context,
              heightSize: 0.01
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                "전화번호",
                style: customStyle(
                  fontSize: 14,
                  fontColor: mainColor,
                  fontWeightName: 'Medium',
                ),
              ),
            ),
            Expanded(
              child: Text(
                user.phone,
                style: customStyle(
                  fontSize: 14,
                  fontColor: grayColor,
                  fontWeightName: 'Medium',
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: customHeight(
              context: context,
              heightSize: 0.01
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                "계정탈퇴",
                style: customStyle(
                  fontSize: 14,
                  fontColor: mainColor,
                  fontWeightName: 'Medium',
                ),
              ),
            ),
            Expanded(
              child: Text(
                "",
                style: customStyle(
                  fontSize: 14,
                  fontColor: grayColor,
                  fontWeightName: 'Medium',
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

// 회사 정보
Widget getCompanyInfomationCard({BuildContext context, User user}){
  return Padding(
    padding: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
    child: FutureBuilder(
      future: FirebaseRepository().getCompanyInfo(companyCode: user.companyCode),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return SizedBox();

        return Column(
          children: [
            Row(
              children: [

                Stack(
                  children: [
                    Container(
                      color: mainColor,
                      width: customWidth(
                        context: context,
                        widthSize: 0.2
                      ),
                      child: Center(
                        child: Container(
                            color: whiteColor,
                            alignment: Alignment.center,
                            width: customWidth(
                                context: context,
                                widthSize: 0.2
                            ),
                            child: Image.network(
                                snapshot.data['companyPhoto'] != "" ? snapshot.data['companyPhoto'] :
                                "https://firebasestorage.googleapis.com/v0/b/app-dev-c912f.appspot.com/o/defaultImage%2Fnoimage.png?alt=media&token=c447305b-d623-444e-a163-fc1b3e393699"
                            ),
                        ),
                      ),
                    )
                  ],
                ),
                Expanded(child: Padding(padding: EdgeInsets.only(left: 10))),

                ActionChip(
                  backgroundColor: blueColor,
                  label: Text(
                    "수정",
                    style: customStyle(
                      fontSize: 14,
                      fontColor: whiteColor,
                      fontWeightName: 'Medium',
                    ),
                  ),
                  onPressed: () {
                    SettingMyPageUpdate(context);
                  },
                ),

              ],
            ),
            SizedBox(
              height: customHeight(
                  context: context,
                  heightSize: 0.01
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "회사명",
                    style: customStyle(
                      fontSize: 14,
                      fontColor: mainColor,
                      fontWeightName: 'Medium',
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    snapshot.data["companyName"],
                    style: customStyle(
                      fontSize: 14,
                      fontColor: mainColor,
                      fontWeightName: 'Medium',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: customHeight(
                  context: context,
                  heightSize: 0.01
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "사업자 no",
                    style: customStyle(
                      fontSize: 14,
                      fontColor: mainColor,
                      fontWeightName: 'Medium',
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    snapshot.data["companyNo"],
                    style: customStyle(
                      fontSize: 14,
                      fontColor: mainColor,
                      fontWeightName: 'Medium',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: customHeight(
                  context: context,
                  heightSize: 0.01
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    "주소",
                    style: customStyle(
                      fontSize: 14,
                      fontColor: mainColor,
                      fontWeightName: 'Medium',
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    snapshot.data["companyAddr"],
                    style: customStyle(
                      fontSize: 14,
                      fontColor: mainColor,
                      fontWeightName: 'Medium',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: customHeight(
                  context: context,
                  heightSize: 0.01
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    "전화번호",
                    style: customStyle(
                      fontSize: 14,
                      fontColor: mainColor,
                      fontWeightName: 'Medium',
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    snapshot.data["companyPhone"],
                    style: customStyle(
                      fontSize: 14,
                      fontColor: mainColor,
                      fontWeightName: 'Medium',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: customHeight(
                  context: context,
                  heightSize: 0.01
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    "웹사이트",
                    style: customStyle(
                      fontSize: 14,
                      fontColor: mainColor,
                      fontWeightName: 'Medium',
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    snapshot.data["companyWeb"],
                    style: customStyle(
                      fontSize: 14,
                      fontColor: mainColor,
                      fontWeightName: 'Medium',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: customHeight(
                  context: context,
                  heightSize: 0.01
              ),
            ),
          ],
        );
      },
    ),
  );
}
