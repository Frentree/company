import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MeetingMainDetail extends StatefulWidget {
  @override
  _MeetingMainDetailState createState() => _MeetingMainDetailState();
}

class _MeetingMainDetailState extends State<MeetingMainDetail> {
  @override
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  bool isButtonChk = false;

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
        right: SizerUtil.deviceType == DeviceType.Tablet ? 3.0.w : 4.0.w,
        top: 4.0.h,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                iconSize: 18,
                icon: Icon(Icons.arrow_back_ios_outlined),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Expanded(child: SizedBox()),
              IconButton(
                iconSize: 20,
                icon: Icon(Icons.check),
                onPressed: () {

                },
              ),
            ],
          ),
          Row(
            children: [
              Text("일정선택"),
              Text("일정선택")
            ],
          )
        ],
      ),
    );
  }
}


String _buildChosenItem(int chosenItem) {
  String _chosenItem = chosenItem.toString();
  switch (_chosenItem) {
    case '0':
      return "선택 안함";
    case '1':
      return "일주일";
    case '2':
      return "한  달";
    case '3':
      return "일  년";
  }
}