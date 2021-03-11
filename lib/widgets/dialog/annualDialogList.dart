import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:MyCompany/models/annualModel.dart';
import 'package:MyCompany/models/workModel.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

// 유저 연차 정보 다이얼로그
Future<void> getAnnualListDialog({BuildContext context, String mail, String companyCode, String year}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      TextEditingController _gradeNameEditController = TextEditingController();
      return AlertDialog(
        title: Text(
          "연차 사용 내역",
          style: defaultMediumStyle,
        ),
        content: Container(
          width: SizerUtil.deviceType == DeviceType.Tablet ? 45.0.w : 35.0.w,
          height: 200,
          child: StreamBuilder(
            stream: FirebaseRepository().selectAnnualLeave(mail: mail, companyCode: companyCode, date: year),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

              return _buildList(context, snapshot.data.docs, companyCode);
            },
          )
        ),
        actions: [
          FlatButton(
            child: Text(
              Words.word.confirm(),
              style: buttonBlueStyle,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot, String companyCode) {
  /*return ListView(
    children: snapshot.map((data) => _buildListItem(context, data, companyCode)).toList(),
  );*/
  return CustomScrollView(
    slivers: [
      SliverList(
        delegate: SliverChildBuilderDelegate((context, index) => _buildListItem(context, snapshot[index], companyCode), childCount: snapshot.length),
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
    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: grayColor))),
    child: _buildUserList(context, work, companyCode),
  );
}

Widget _buildUserList(BuildContext context, WorkModel work, String companyCode) {
  Format _format = Format();
  return Row(
    children: [
      Expanded(
        child: Container(
          alignment: Alignment.centerLeft,
          child: Text(_format.yearMonthDay(work.startTime), style: defaultMediumStyle),
        ),
      ),
      cardSpace,
      Container(
        alignment: Alignment.center,
        child: Text(work.type.toString(), style: defaultMediumStyle),
      ),
    ],
  );
}

// 유저 연차 정보 수정 다이얼로그
Future<void> updateAnnualDialog({BuildContext context, AnnualModel model}) {
  TextEditingController _maxAnnualTextController = TextEditingController();
  _maxAnnualTextController.text = model.maxAnnual.toString();

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      TextEditingController _gradeNameEditController = TextEditingController();
      return AlertDialog(
        title: Text(
          "총 연차 수정",
          style: defaultMediumStyle,
        ),
        content: Container(
            width: SizerUtil.deviceType == DeviceType.Tablet ? 45.0.w : 35.0.w,
            height: 80,
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "총 연차일",
                      style: defaultMediumStyle,
                    ),
                    cardSpace,
                    cardSpace,
                    cardSpace,
                    Expanded(
                      child: TextFormField(
                        controller: _maxAnnualTextController,
                        decoration: InputDecoration(
                          hintText: "수정할 총 연차일을 입력해주세요",
                          hintStyle: defaultRegularStyleGray
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    )
                  ],
                ),
              ],
            ),
        ),
        actions: [
          FlatButton(
            child: Text(
              Words.word.update(),
              style: buttonBlueStyle,
            ),
            onPressed: () {
              model.reference.update({
                "maxAnnual" : num.parse(_maxAnnualTextController.text)
              });
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text(
              Words.word.cencel(),
              style: buttonBlueStyle,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
