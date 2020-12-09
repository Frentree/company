import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:MyCompany/models/attendanceModel.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/provider/screen/loginScreenChange.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/screens/alarm/alarmNotice.dart';
import 'package:MyCompany/screens/home/homeSchedule.dart';
import 'package:MyCompany/screens/search/seachAll.dart';
import 'package:MyCompany/screens/search/searchContent.dart';
import 'package:MyCompany/screens/search/searchFilter.dart';
import 'package:MyCompany/widgets/button/textButton.dart';
import 'package:MyCompany/widgets/notImplementedPopup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
class SearchMainPage extends StatelessWidget {
  TextEditingController _seachTitleCon = TextEditingController();

  int tabIndex = 0;
  @override
  Widget build(BuildContext context) {
    LoginScreenChangeProvider loginScreenChangeProvider = Provider.of<LoginScreenChangeProvider>(context);

    Map<String,Widget> _page = {
      "searchAll" : SearchAllPage(),
      "searchFilter" : SearchFilterPage(),
      "searchContent" : SearchContentPage(),
    };

    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: SizedBox(),
          ),
        ],
      ),
    );
  }
}

/*

class SearchMainPage extends StatefulWidget {
  @override
  SearchMainPageState createState() => SearchMainPageState();
}

class SearchMainPageState extends State<SearchMainPage> {
  TextEditingController _seachTitleCon = TextEditingController();

  int tabIndex = 0;


  @override
  Widget build(BuildContext context) {
    LoginScreenChangeProvider loginScreenChangeProvider = Provider.of<LoginScreenChangeProvider>(context);

    Map<String,Widget> _page = {
      "searchAll" : SearchAllPage(),
      "searchFilter" : SearchFilterPage(),
    };

    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: _page[loginScreenChangeProvider.getPageName()],
          ),
        ],
      ),
    );
  }
}
*/
