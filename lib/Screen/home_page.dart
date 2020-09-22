/*
//하단바 입니다.

import 'package:flutter/material.dart';

//Screen
import 'package:companyplaylist/Screen/schedule_page.dart';
import 'package:companyplaylist/Screen/search_page.dart';
import 'package:companyplaylist/Screen/push_page.dart';
import 'package:companyplaylist/Screen/setting_page.dart';

//Theme
import 'package:companyplaylist/Theme/theme.dart';
import 'package:flutter/rendering.dart';

//BottomSheet
import 'package:companyplaylist/BottomSheet/main_bottom_sheet.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  //불러올 페이지 리스트
  List<Widget> _page = [SchedulePage(), SearchPage(), null,PushPage(), SettingPage()];

  int _currentIndex = 0;

  void _onTap(int index) {
    if(index == 2){
      mainBottomSheet(context);
    }
    else{
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 9,
            child: _page[_currentIndex],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.red,
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: white_color,
        selectedItemColor: top_color,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _onTap,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_today,
              size: 25,
            ),
            title: Text(
              "Schedule"
            )
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                size: 25,
              ),
              title: Text(
                  "Search"
              )
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle_outline,
                size: 40,
                color: blue_color,
              ),
              title: Text(
                  "Create"
              )
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.notifications_none,
                size: 25,
              ),
              title: Text(
                  "Push"
              )
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.menu,
                size: 25,
              ),
              title: Text(
                  "Setting"
              )
          ),
        ],
      ),
    );
  }
}*/
