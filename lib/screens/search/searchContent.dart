import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/provider/screen/loginScreenChange.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/widgets/button/textButton.dart';
import 'package:MyCompany/widgets/card/searchDataCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchContentPage extends StatefulWidget {
  @override
  SearchContentPageState createState() => SearchContentPageState();
}

class SearchContentPageState extends State<SearchContentPage> {
  final Firestore _db = Firestore.instance;

  TextEditingController _seachTitleCon = TextEditingController();

  int tabIndex = 0;

  User _loginUser;
  LoginUserInfoProvider _loginUserInfoProvider;

  String content = "";

  @override
  Widget build(BuildContext context) {
    LoginScreenChangeProvider loginScreenChangeProvider = Provider.of<LoginScreenChangeProvider>(context);
    _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context);
    _loginUser = _loginUserInfoProvider.getLoginUser();

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
              height: customHeight(context: context, heightSize: 0.06),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: tabColor),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  height: customHeight(context: context, heightSize: 0.9),
                  width: customWidth(
                    context: context,
                    widthSize: 0.9,
                  ),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: whiteColor),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Icon(
                          Icons.zoom_in_outlined,
                          color: tabColor,
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Container(
                          height: customHeight(context: context, heightSize: 1),
                          child: TextField(
                            controller: _seachTitleCon,
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '검색어를 입력해주세요',
                            ),
                            style: customStyle(
                              fontSize: 14,
                              fontColor: mainColor,
                              fontWeightName: 'Medium',
                            ),
                            onSubmitted: (value) {
                              setState(() {
                                content = value;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: Icon(
                            Icons.close_sharp,
                            color: tabColor,
                            size: 18,
                          ),
                          onPressed: () {
                            _seachTitleCon.text = "";
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          SizedBox(
            height: 15,
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  child: FutureBuilder(
                    future: _db
                        .collection('company')
                        .document(_loginUser.companyCode)
                        .collection("notice")
                        .where("caseSearch", arrayContains: content)
                        .getDocuments(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        if (_seachTitleCon.text == "" || _seachTitleCon.text == null) {
                          return Text("");
                        } else {
                          return Text.rich(
                            TextSpan(
                                text: _seachTitleCon.text,
                                style: customStyle(
                                  fontSize: 12,
                                  fontColor: blueColor,
                                  fontWeightName: 'Bold',
                                ),
                                children: [
                                  TextSpan(
                                    text: " 검색어에 대해 공지사항에서 0건 검색되었습니다.",
                                    style: customStyle(
                                      fontSize: 12,
                                      fontColor: mainColor,
                                      fontWeightName: 'Regular',
                                    ),
                                  ),
                                ]),
                          );
                        }
                      }

                      List<DocumentSnapshot> documents = snapshot.data.documents;

                      return Column(
                        children: [
                          _seachTitleCon.text.trim() != ""
                              ? Text.rich(
                            TextSpan(
                                text: _seachTitleCon.text,
                                style: customStyle(
                                  fontSize: 12,
                                  fontColor: blueColor,
                                  fontWeightName: 'Bold',
                                ),
                                children: [
                                  TextSpan(
                                    text: " 검색어에 대해 공지사항에서 " + documents.length.toString() + "건 검색되었습니다.",
                                    style: customStyle(
                                      fontSize: 12,
                                      fontColor: mainColor,
                                      fontWeightName: 'Regular',
                                    ),
                                  ),
                                ]),
                          )
                              : Text(""),
                          SizedBox(
                            height: customHeight(heightSize: 0.01, context: context),
                          ),
                          Container(
                              child: Column(
                                children: [
                                  Column(
                                    children: getSearchNoticeDataList(documents, context),
                                  ),
                                  SizedBox(
                                    height: customHeight(heightSize: 0.01, context: context),
                                  ),
                                  (documents.length > 4)
                                      ? InkWell(
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: customWidth(context: context, widthSize: 1),
                                      child: Text(
                                        "더보기",
                                        style: customStyle(
                                          fontColor: blueColor,
                                          fontSize: 12,
                                          fontWeightName: 'Medium',
                                        ),
                                      ),
                                    ),
                                    onTap: () {},
                                  )
                                      : Text(""),
                                ],
                              )),
                          SizedBox(
                            height: customHeight(heightSize: 0.01, context: context),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Container(
                  child: FutureBuilder(
                    future: _db
                        .collection('company')
                        .document(_loginUser.companyCode)
                        .collection("work")
                        .where("caseSearch", arrayContains: content)
                        .getDocuments(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        if (_seachTitleCon.text == "") {
                          return Text.rich(
                            TextSpan(
                                text: _seachTitleCon.text,
                                style: customStyle(
                                  fontSize: 12,
                                  fontColor: blueColor,
                                  fontWeightName: 'Bold',
                                ),
                                children: [
                                  TextSpan(
                                    text: "",
                                    style: customStyle(
                                      fontSize: 12,
                                      fontColor: mainColor,
                                      fontWeightName: 'Regular',
                                    ),
                                  ),
                                ]),
                          );
                        } else {
                          return Text.rich(
                            TextSpan(
                                text: _seachTitleCon.text,
                                style: customStyle(
                                  fontSize: 12,
                                  fontColor: blueColor,
                                  fontWeightName: 'Bold',
                                ),
                                children: [
                                  TextSpan(
                                    text: "검색어에 대해 일정에서 0건 검색되었습니다.",
                                    style: customStyle(
                                      fontSize: 12,
                                      fontColor: mainColor,
                                      fontWeightName: 'Regular',
                                    ),
                                  ),
                                ]),
                          );
                        }
                      }

                      List<DocumentSnapshot> documents = snapshot.data.documents;

                      return Column(
                        children: [
                          (_seachTitleCon.text != "")
                              ? Text.rich(
                            TextSpan(
                                text: _seachTitleCon.text,
                                style: customStyle(
                                  fontSize: 12,
                                  fontColor: blueColor,
                                  fontWeightName: 'Bold',
                                ),
                                children: [
                                  TextSpan(
                                    text: " 검색어에 대해 일정에서 " + documents.length.toString() + "건 검색되었습니다.",
                                    style: customStyle(
                                      fontSize: 12,
                                      fontColor: mainColor,
                                      fontWeightName: 'Regular',
                                    ),
                                  ),
                                ]),
                          )
                              : Text(""),
                          SizedBox(
                            height: customHeight(heightSize: 0.01, context: context),
                          ),
                          Container(
                            child: Column(
                              children: [
                                Column(
                                  children: getSearchWorkDataList(documents, context),
                                ),
                                (documents.length > 4)
                                    ? InkWell(
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: customWidth(context: context, widthSize: 1),
                                    child: Text(
                                      "더보기",
                                      style: customStyle(
                                        fontColor: blueColor,
                                        fontSize: 12,
                                        fontWeightName: 'Medium',
                                      ),
                                    ),
                                  ),
                                  onTap: () {},
                                )
                                    : Text(""),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
