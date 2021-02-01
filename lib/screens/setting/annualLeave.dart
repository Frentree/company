import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/models/workModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/repos/firebaseMethod.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/widgets/dialog/organizationChartDialogList.dart';
import 'package:MyCompany/widgets/notImplementedPopup.dart';
import 'package:MyCompany/widgets/popupMenu/expensePopupMenu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

final word = Words();

class AnnualLeavePage extends StatefulWidget {
  @override
  _AnnualLeavePageState createState() => _AnnualLeavePageState();
}

class _AnnualLeavePageState extends State<AnnualLeavePage> {
  @override
  Widget build(BuildContext context) {
    LoginUserInfoProvider _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context);
    _loginUser = _loginUserInfoProvider.getLoginUser();

    return Scaffold(
      backgroundColor: whiteColor,
      body: _buildBody(context, _loginUser),
    );
  }

  User _loginUser;
}

Widget _buildBody(BuildContext context, User user) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseRepository().selectAnnualLeave(
      mail: user.mail,
      companyCode: user.companyCode,
    ),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

      return _buildList(context, snapshot.data.docs, user.companyCode);
    },
  );
}

Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot, String companyCode) {
  print(snapshot.length.toString());
  return CustomScrollView(
    slivers: [
      SliverList(
        delegate: SliverChildBuilderDelegate(
                (context, index) => _buildListItem(context, snapshot[index], companyCode),
            childCount: snapshot.length),
      ),

    ],
  );
  /*return ListView.builder(
    itemCount: snapshot.length,
    itemBuilder: (context, index) {
      return _buildListItem(context, snapshot[index], companyCode);
    },
  );*/
}

Widget _buildListItem(BuildContext context, DocumentSnapshot data, String companyCode) {
  final work = WorkModel.fromSnapshow(data);

  return Container(
    padding: cardPadding,
    height: 20.0.h,
    decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(
                color: grayColor
            )
        )
    ),
    child: _buildUserList(context, work, companyCode),
  );
}

Widget _buildUserList(BuildContext context, WorkModel work, String companyCode) {

  return StatefulBuilder(
    builder: (context, setState) {
     return Text(work.title.toString());

    },
  );

}
