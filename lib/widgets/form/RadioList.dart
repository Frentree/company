import 'package:companyplaylist/models/bigCategoryModel.dart';
import 'package:companyplaylist/repos/work/workRepository.dart';
import 'package:flutter/material.dart';

/*class RadioWidget extends StatefulBuilder {
  Future<Null> createRadio(BuildContext context, String radioGroup, bigCategory) async {
    final RadioListTile radioListTile = await RadioListTile(
      title: Text("$bigCategory"),
      value: bigCategory,
      groupValue: radioGroup,
      onChanged: (value) {
        setState(() {
          radioGroup = value;
        });
      },
    );
  }
}*/

class RadioList extends StatefulWidget
{
  @override
  RadioWidget createState() => RadioWidget();
}

class RadioWidget extends State {

  WorkRepository _workRepository = WorkRepository();
  String categoryGroup = "category";


  // 빅카테고리 리스트
  List<Widget> workCategoryList(BuildContext context, String project) {
    List<Widget> children = [];

    List<WorkCategory> list;

    Future<List<WorkCategory>> workCategory =
        _workRepository.workCategoryFirebaseAuth(context: context);

    workCategory.then((value) => value.forEach((element) {
          WorkCategory category = WorkCategory(
              createUid: element.createUid,
              createDate: element.createDate,
              bigCategoryTitle: element.bigCategoryTitle,
              bigCategoryContent: element.bigCategoryContent);

          //children.add(createRadio(context, categoryGroup, element.bigCategoryTitle));
          print("element ================> ${element.bigCategoryTitle}");
          children.add(
            RadioListTile(
              title: Text(element.bigCategoryTitle),
              value: element.bigCategoryTitle,
              groupValue: _project,
              onChanged: (value) {
                setState(() {
                  _project = value;
                  isSelected = true;
                });
                print(value);
              },
            ),
          );
        }));

    return children;
  }

  createRadio(BuildContext context, String radioGroup,String bigCategory) {
    return RadioListTile(
      title: Text("$bigCategory"),
      value: bigCategory,
      groupValue: radioGroup,
      onChanged: (value) {
        setState(() {
          radioGroup = value;
        });
      },
    );
  }

  String bigCategoryTitle = "";
  String _project = "a";
  bool isSelected = false;

  String isCategoryName() {
    if (isSelected == false) {
      return "관련 프로젝트를 선택하세요";
    } else {
      return _project;
    }
  }

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black26),
        borderRadius: BorderRadius.all(Radius.circular(5.0) // POINT
            ),
      ),
      child: ExpansionTile(
        title: Text("${isCategoryName()}"),
        children: workCategoryList(context, _project),
      ),
    );
  }
}
