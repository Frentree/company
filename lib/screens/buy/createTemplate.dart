
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:flutter/material.dart';

class CreateBuyRequest extends StatefulWidget {
  @override
  _CreateBuyRequestState createState() => _CreateBuyRequestState();
}

class _CreateBuyRequestState extends State<CreateBuyRequest> {
  final _dateToBuy = TextEditingController();
  final _itemToBuy = TextEditingController();
  final _relevantPrj = TextEditingController();
  final _priceExpected = TextEditingController();
  final _detail = TextEditingController();
  final _userToApprove = TextEditingController();
  final _relevantLink = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: mainColor,
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Column(
              children: <Widget>[
                //상단 로고
                Container(
                  width: customWidth(context: context, widthSize: 0.96),
                  height: customHeight(
                    context: context,
                    heightSize: 0.13,
                  ),
                  decoration: BoxDecoration(color: mainColor),

                  //출근 버튼 및 상태 표시
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height:
                        customHeight(context: context, heightSize: 0.041),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: customWidth(
                                    context: context, widthSize: 0.01),
                              ),
                              Icon(
                                Icons.power_settings_new,
                                color: Colors.white,
                              ),
                              Text(
                                "근무중",
                                style: customStyle(                        fontSize: 15,
                                  fontWeightName: "Regular",
                                  fontColor: whiteColor,),
                              ),
                            ],
                          ),
                          Row(children: [
                            Icon(
                              Icons.account_circle_rounded,
                              color: Colors.white,
                              size: 35.0,
                            ),
                            SizedBox(
                              width: customWidth(
                                  context: context, widthSize: 0.041),
                            ),
                          ]),
                        ],
                      ),
                      SizedBox(
                        height: customHeight(
                          context: context,
                          heightSize: 0.03,
                        ),
                      ),
                    ],
                  ),
                ),

                //페이지 타이틀 및 취소 버튼
                Expanded(
                    child: Container(
                        padding: EdgeInsets.only(top: 5),
                        width: customWidth(
                          context: context,
                          widthSize: 1,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25)),
                            color: whiteColor),
                        child: SingleChildScrollView(
                            child: Column(children: <Widget>[
                              Container(
                                  width:
                                  customWidth(context: context, widthSize: 1),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                          width: MediaQuery.of(context).size.width *
                                              0.2,
                                          child: IconButton(
                                            alignment: Alignment.centerLeft,
                                            icon: Icon(Icons.close),
                                            color: Colors.black,
                                            iconSize: 20.0,
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          )),
                                      SizedBox(
                                          width: MediaQuery.of(context).size.width *
                                              0.3,
                                          child: Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black87),
                                                  borderRadius:
                                                  BorderRadius.circular(7.0),
                                                  color: Colors.white,
                                                ),
                                                width: 40,
                                                height: 40,
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "구매",
                                                    style: customStyle(
                                                      fontSize: 16,
                                                      fontWeightName: "Regular",
                                                      fontColor: mainColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "품의 생성",
                                                style: customStyle(
                                                  fontSize: 16,
                                                  fontWeightName: "Regular",
                                                  fontColor: mainColor,
                                                ),
                                              ),

                                            ],
                                          )),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width *
                                            0.25,
                                      ),
                                    ],
                                  )),
                            ]))))
              ],
            )));
  }
}
