import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/models/attendanceModel.dart';
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/provider/screen/loginScreenChange.dart';
import 'package:companyplaylist/provider/user/loginUserInfo.dart';
import 'package:companyplaylist/screens/alarm/alarmNotice.dart';
import 'package:companyplaylist/screens/home/homeSchedule.dart';
import 'package:companyplaylist/screens/search/seachAll.dart';
import 'package:companyplaylist/screens/search/searchContent.dart';
import 'package:companyplaylist/screens/search/searchFilter.dart';
import 'package:companyplaylist/widgets/button/textButton.dart';
import 'package:companyplaylist/widgets/notImplementedPopup.dart';
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
