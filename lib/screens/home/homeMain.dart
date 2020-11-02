//Flutter
<<<<<<< HEAD
import 'package:companyplaylist/widgets/album/widgetMain.dart';
=======
import 'package:companyplaylist/screens/alarm/alarmMain.dart';
import 'package:companyplaylist/screens/setting/settingMain.dart';
>>>>>>> 8fcdebe5f026297d9a1e9438e3fbb410912d0ae5
import 'package:companyplaylist/widgets/bottomsheet/mainBottomSheet.dart';
import 'package:companyplaylist/widgets/bottomsheet/setting/settingMain.dart';
import 'package:flutter/material.dart';

//Const
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';

//Screen
import 'package:companyplaylist/screens/home/homeScheduleMain.dart';

class HomeMainPage extends StatefulWidget {
  @override
  HomeMainPageState createState() => HomeMainPageState();
}

class HomeMainPageState extends State<HomeMainPage> {
  //불러올 페이지 리스트
<<<<<<< HEAD
  List<Widget> _page = [HomeScheduleMainPage()];
=======
  List<Widget> _page = [HomeScheduleMainPage(),AlarmMainPage(),null,AlarmMainPage(), SettingMainPage()];
>>>>>>> 8fcdebe5f026297d9a1e9438e3fbb410912d0ae5

  //현재 페이지 인덱스
  int _currentPateIndex = 0;

  //페이지 이동
  void _pageChange(int pageIndex){
    if(pageIndex == 2){
      MainBottomSheet(context);
    }
    else if(pageIndex == 4){
      //SettingMain(context);
    }
    else{
      setState(() {
        _currentPateIndex = pageIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 11,
            child: _page[_currentPateIndex],
          ),

          //배너
          Expanded(
            flex: 2,
            child: Container(
              color: bottomColor,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: customHeight(context: context, heightSize: 0.04)),
                    child: Text(
                      "슬기로운 회사 생활",
                      style: customStyle(
                        fontSize: 16,
                        fontWeightName: "Regular",
                        fontColor: whiteColor,
                      ),
                    ),
                  ),
                  Image.asset("images/bannerImage.jpg")
                ],
              ),
            ),
          )
        ],
      ),

      //네비게이션 바
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: whiteColor,
        selectedItemColor: mainColor,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _pageChange,
        currentIndex: _currentPateIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_today,
              size: customHeight(
                context: context,
                heightSize: 0.04,
              ),
            ),
            title: Text(
              "Schedule"
            )
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              size: customHeight(
                context: context,
                heightSize: 0.04,
              ),
            ),
            title: Text(
              "Search"
            )
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle_outline,
                size: customHeight(
                  context: context,
                  heightSize: 0.06,
                ),
                color: blueColor,
              ),
              title: Text(
                  "Create"
              )
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.notifications_none,
                size: customHeight(
                  context: context,
                  heightSize: 0.04,
                ),
              ),
              title: Text(
                  "Push"
              )
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.menu,
                size: customHeight(
                  context: context,
                  heightSize: 0.04,
                ),
              ),
              title: Text(
                  "Setting"
              )
          ),
        ],
      ),
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert Dialog title"),
          content: new Text("Alert Dialog body"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
