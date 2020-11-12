/*
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/junhyun/crossScrollTest.dart';
import 'package:companyplaylist/repos/tableCalendar/table_calendar.dart';
import 'package:companyplaylist/widgets/form/textFormField.dart';
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

  int _value = 1;

  List<ListItem> _dropdownItems = [
    ListItem(1, "First Value"),
    ListItem(2, "Second Item"),
    ListItem(3, "Third Item"),
    ListItem(4, "Fourth Item")
  ];

  List<DropdownMenuItem<ListItem>> _dropdownMenuItems;
  ListItem _selectedItem;

  @override
  void initState() {
    super.initState();
    _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
    _selectedItem = _dropdownMenuItems[0].value;
  }

  List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<ListItem>> items = List();
    for (ListItem listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Row(
            children: [
              SizedBox(
                  width: 140.0,
                  child: Text(listItem.name,
                      style: customStyle(                        fontSize: 14,
                        fontWeightName: "Regular",
                        fontColor: mainColor,))),
              Container(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<ListItem>(
                      value: _selectedItem,
                      items: _dropdownMenuItems,
                      */
/*[
                        DropdownMenuItem(
                          child: Text("First Item"),
                          value: 1,
                        ),
                        DropdownMenuItem(
                          child: Text("Second Item"),
                          value: 2,
                        ),
                        DropdownMenuItem(child: Text("Third Item"), value: 3),
                        DropdownMenuItem(child: Text("Fourth Item"), value: 4)
                      ],*//*

                      onChanged: (value) {
                        setState(() {
                          _selectedItem = value;
                        });
                      }),
                ),
              )
            ],
          ),
          value: listItem,
        ),
      );
    }
    return items;
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
                Expanded(
                    child: Container(
                        padding: EdgeInsets.only(
                          top: 5,
                          left: customHeight(
                            context: context,
                            heightSize: 0.02,
                          ),
                          right: customHeight(
                            context: context,
                            heightSize: 0.02,
                          ),
                        ),
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
                                          )],
                                      )),
                                  */
/*SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                  ),*//*

                                  SizedBox(
                                    width: 70,
                                    child: RaisedButton(
                                        child: Text("Test"),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CrossScrollTest()),
                                          );
                                        }),
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: customHeight(
                              context: context,
                              heightSize: 0.03,
                            ),
                          ),
                          Column(children: <Widget>[
                            textFormFieldWithOutlinedBorder(
                              textEditingController: _itemToBuy,
                              hintText: "구매 요청 품목",
                            ),
                          ]),
                          SizedBox(
                            height: customHeight(
                              context: context,
                              heightSize: 0.03,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              left: customHeight(
                                context: context,
                                heightSize: 0.02,
                              ),
                              right: customHeight(
                                context: context,
                                heightSize: 0.03,
                              ),
                            ),
                            width: customWidth(
                              context: context,
                              widthSize: 1,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                  color: inputBoarderColor,
                                )),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<ListItem>(
                                  value: _selectedItem,
                                  items: _dropdownMenuItems,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedItem = value;
                                    });
                                  }),
                            ),
                          )
                        ]))))
              ],
            )));
  }
}

class ListItem {
  int value;
  String name;

  ListItem(this.value, this.name);
}
*/
