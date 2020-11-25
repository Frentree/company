import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/provider/screen/loginScreenChange.dart';
import 'package:companyplaylist/widgets/button/textButton.dart';
import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchFilterPage extends StatefulWidget {
  @override
  SearchFilterPageState createState() => SearchFilterPageState();
}

class SearchFilterPageState extends State<SearchFilterPage> {
  // 작성자
  int writerFilter = 0;
  // 분류
  int classFilter = 0;
  // 기간
  int dateFilter = 0;
  // 정렬
  int sortFilter = 0;

  bool isfilter = true;

  TextEditingController _seachTitleCon = TextEditingController();

  int tabIndex = 1;


  @override
  Widget build(BuildContext context) {
    LoginScreenChangeProvider loginScreenChangeProvider = Provider.of<LoginScreenChangeProvider>(context);

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
          Container(
            width: customWidth(widthSize: 1, context: context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                filterBtn(
                    context: context,
                    heightSize: 0.04,
                    widthSize: 0.3,
                    btnText: "전체검색",
                    tabIndexVariable: tabIndex,
                    tabOrder: 0,
                    color: tabColor,
                    tabAction: () {
                      setState(() {
                        tabIndex = 0;
                        loginScreenChangeProvider.setPageName(pageName: "searchAll");
                      });
                    }),
                filterBtn(
                    context: context,
                    heightSize: 0.04,
                    widthSize: 0.3,
                    btnText: "필터검색",
                    tabIndexVariable: tabIndex,
                    tabOrder: 1,
                    color: tabColor,
                    tabAction: () {
                      setState(() {
                        tabIndex = 1;
                        loginScreenChangeProvider.setPageName(pageName: "searchFilter");
                      });
                    }),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "작성자",
                              style: customStyle(
                                fontColor: mainColor,
                                fontSize: 14,
                                fontWeightName: 'Bold',
                              ),
                            ),
                            Row(
                              children: [
                                filterBtn(
                                    context: context,
                                    heightSize: 0.04,
                                    widthSize: 0.18,
                                    btnText: "나",
                                    tabIndexVariable: writerFilter,
                                    tabOrder: 0,
                                    color: tabColor,
                                    tabAction: () {
                                      setState(() {
                                        writerFilter = 0;
                                      });
                                    }),
                                Padding(padding: EdgeInsets.only(left: 10)),
                                filterBtn(
                                    context: context,
                                    heightSize: 0.04,
                                    widthSize: 0.18,
                                    btnText: "동료",
                                    tabIndexVariable: writerFilter,
                                    tabOrder: 1,
                                    color: tabColor,
                                    tabAction: () {
                                      setState(() {
                                        writerFilter = 1;
                                      });
                                    }),
                                Padding(padding: EdgeInsets.only(left: 10)),
                                filterBtn(
                                    context: context,
                                    heightSize: 0.04,
                                    widthSize: 0.18,
                                    btnText: "전체",
                                    tabIndexVariable: writerFilter,
                                    tabOrder: 2,
                                    color: tabColor,
                                    tabAction: () {
                                      setState(() {
                                        writerFilter = 2;
                                      });
                                    }),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "분류",
                              style: customStyle(
                                fontColor: mainColor,
                                fontSize: 14,
                                fontWeightName: 'Bold',
                              ),
                            ),
                            Row(
                              children: [
                                filterBtn(
                                    context: context,
                                    heightSize: 0.04,
                                    widthSize: 0.18,
                                    btnText: "일정",
                                    tabIndexVariable: classFilter,
                                    tabOrder: 0,
                                    color: tabColor,
                                    tabAction: () {
                                      setState(() {
                                        classFilter = 0;
                                      });
                                    }),
                                Padding(padding: EdgeInsets.only(left: 10)),
                                filterBtn(
                                    context: context,
                                    heightSize: 0.04,
                                    widthSize: 0.18,
                                    btnText: "업무요청",
                                    tabIndexVariable: classFilter,
                                    tabOrder: 1,
                                    color: tabColor,
                                    tabAction: () {
                                      setState(() {
                                        classFilter = 1;
                                      });
                                    }),
                                Padding(padding: EdgeInsets.only(left: 10)),
                                filterBtn(
                                    context: context,
                                    heightSize: 0.04,
                                    widthSize: 0.18,
                                    btnText: "경비",
                                    tabIndexVariable: classFilter,
                                    tabOrder: 2,
                                    color: tabColor,
                                    tabAction: () {
                                      setState(() {
                                        classFilter = 2;
                                      });
                                    }),
                                Padding(padding: EdgeInsets.only(left: 10)),
                                filterBtn(
                                    context: context,
                                    heightSize: 0.04,
                                    widthSize: 0.18,
                                    btnText: "알림",
                                    tabIndexVariable: classFilter,
                                    tabOrder: 3,
                                    color: tabColor,
                                    tabAction: () {
                                      setState(() {
                                        classFilter = 3;
                                      });
                                    }),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            filterBtn(
                                context: context,
                                heightSize: 0.04,
                                widthSize: 0.18,
                                btnText: "전체",
                                tabIndexVariable: classFilter,
                                tabOrder: 4,
                                color: tabColor,
                                tabAction: () {
                                  setState(() {
                                    classFilter = 4;
                                  });
                                }),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "기간",
                              style: customStyle(
                                fontColor: mainColor,
                                fontSize: 14,
                                fontWeightName: 'Bold',
                              ),
                            ),
                            Row(
                              children: [
                                filterBtn(
                                    context: context,
                                    heightSize: 0.04,
                                    widthSize: 0.18,
                                    btnText: "1주일",
                                    tabIndexVariable: dateFilter,
                                    tabOrder: 0,
                                    color: tabColor,
                                    tabAction: () {
                                      setState(() {
                                        dateFilter = 0;
                                      });
                                    }),
                                Padding(padding: EdgeInsets.only(left: 10)),
                                filterBtn(
                                    context: context,
                                    heightSize: 0.04,
                                    widthSize: 0.18,
                                    btnText: "2주일",
                                    tabIndexVariable: dateFilter,
                                    tabOrder: 1,
                                    color: tabColor,
                                    tabAction: () {
                                      setState(() {
                                        dateFilter = 1;
                                      });
                                    }),
                                Padding(padding: EdgeInsets.only(left: 10)),
                                filterBtn(
                                    context: context,
                                    heightSize: 0.04,
                                    widthSize: 0.18,
                                    btnText: "한달",
                                    tabIndexVariable: dateFilter,
                                    tabOrder: 2,
                                    color: tabColor,
                                    tabAction: () {
                                      setState(() {
                                        dateFilter = 2;
                                      });
                                    }),
                                Padding(padding: EdgeInsets.only(left: 10)),
                                filterBtn(
                                    context: context,
                                    heightSize: 0.04,
                                    widthSize: 0.18,
                                    btnText: "6개월",
                                    tabIndexVariable: dateFilter,
                                    tabOrder: 3,
                                    color: tabColor,
                                    tabAction: () {
                                      setState(() {
                                        dateFilter = 3;
                                      });
                                    }),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            filterBtn(
                                context: context,
                                heightSize: 0.04,
                                widthSize: 0.18,
                                btnText: "기한 설정",
                                tabIndexVariable: dateFilter,
                                tabOrder: 4,
                                color: tabColor,
                                tabAction: () {
                                  setState(() {
                                    dateFilter = 4;
                                  });
                                }),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "정렬",
                              style: customStyle(
                                fontColor: mainColor,
                                fontSize: 14,
                                fontWeightName: 'Bold',
                              ),
                            ),
                            Row(
                              children: [
                                filterBtn(
                                    context: context,
                                    heightSize: 0.04,
                                    widthSize: 0.18,
                                    btnText: "작성자순",
                                    tabIndexVariable: sortFilter,
                                    tabOrder: 0,
                                    color: tabColor,
                                    tabAction: () {
                                      setState(() {
                                        sortFilter = 0;
                                      });
                                    }),
                                Padding(padding: EdgeInsets.only(left: 10)),
                                filterBtn(
                                    context: context,
                                    heightSize: 0.04,
                                    widthSize: 0.18,
                                    btnText: "분류순",
                                    tabIndexVariable: sortFilter,
                                    tabOrder: 1,
                                    color: tabColor,
                                    tabAction: () {
                                      setState(() {
                                        sortFilter = 1;
                                      });
                                    }),
                                Padding(padding: EdgeInsets.only(left: 10)),
                                filterBtn(
                                    context: context,
                                    heightSize: 0.04,
                                    widthSize: 0.18,
                                    btnText: "최신일자순",
                                    tabIndexVariable: sortFilter,
                                    tabOrder: 2,
                                    color: tabColor,
                                    tabAction: () {
                                      setState(() {
                                        sortFilter = 2;
                                      });
                                    }),

                              ],
                            ),

                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: customWidth(
                                context: context,
                                widthSize: 0.4
                            ),
                            height: customHeight(
                                context: context,
                                heightSize: 0.06
                            ),
                            decoration: BoxDecoration(
                              color: tabColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: InkWell(
                              child: Center(
                                child: Text(
                                  "필터 초기화",
                                  style: customStyle(
                                      fontSize: 14,
                                      fontWeightName: 'Bold',
                                      fontColor: mainColor
                                  ),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  writerFilter = 0;
                                  classFilter = 0;
                                  dateFilter = 0;
                                  sortFilter = 0;
                                });
                              },
                            ),
                          ),
                          Container(
                            width: customWidth(
                                context: context,
                                widthSize: 0.4
                            ),
                            height: customHeight(
                                context: context,
                                heightSize: 0.06
                            ),
                            decoration: BoxDecoration(
                              color: mainColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: InkWell(
                              child: Center(
                                child: Text(
                                  "필터 검색",
                                  style: customStyle(
                                      fontSize: 14,
                                      fontWeightName: 'Bold',
                                      fontColor: whiteColor
                                  ),
                                ),
                              ),
                              onTap: (){
                                setState(() {
                                  isfilter = false;
                                  loginScreenChangeProvider.setPageName(pageName: "searchContent");
                                });
                              },
                            ),
                          ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );

  }
}
