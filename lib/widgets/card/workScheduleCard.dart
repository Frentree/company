//Flutter
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/widgets/bottomsheet/work/workContent.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Const
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';


import 'package:MyCompany/models/workModel.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';


import 'package:sizer/sizer.dart';

final word = Words();

Card workScheduleCard({BuildContext context, String companyCode, WorkModel workModel, bool isDetail}) {
  return Card(
    elevation: 0,
    shape: cardShape,
    child: Padding(
        padding: cardPadding,
        child: isDetail
            ? workDetailContents(
                context: context,
                companyCode: companyCode,
                workModel: workModel,
                isDetail: isDetail,
              )
            : titleCard(
                context: context,
                companyCode: companyCode,
                workModel: workModel,
                isDetail: isDetail,
              )
    ),
  );
}

Container titleCard({BuildContext context, String companyCode, WorkModel workModel, bool isDetail}) {
  Format _format = Format();

  return Container(
    height: scheduleCardDefaultSizeH.h,
    child: Row(
      children: [
        //시간대
        Container(
          width: SizerUtil.deviceType == DeviceType.Tablet ? 9.0.w : 12.0.w,
          child: Text(
            _format.timeToString(workModel.startTime),
            style: cardBlueStyle,
          ),
        ),
        //업무 타입입
        Container(
          height: 4.0.h,
          width: SizerUtil.deviceType == DeviceType.Tablet ? 13.5.w : 18.0.w,
          decoration: containerChipDecoration,
          padding: EdgeInsets.symmetric(
              horizontal: SizerUtil.deviceType == DeviceType.Tablet ? 0.75.w : 1.0.w,
          ),
          alignment: Alignment.center,
          child: Text(
            workModel.type == "내근" ? word.workIn() : word.workOut(),
            style: containerChipStyle,
          ),
        ),
        cardSpace,
        //제목
        Container(
          width: workModel.type == "외근" ? SizerUtil.deviceType == DeviceType.Tablet ? 38.0.w : 22.0.w : SizerUtil.deviceType == DeviceType.Tablet ? 53.5.w : 37.0.w,
          child: Text(
            workModel.title,
            style: cardTitleStyle,
          ),
        ),
        Visibility(
          visible: workModel.type == "외근",
          child: Container(
            width: SizerUtil.deviceType == DeviceType.Tablet ? 15.5.w : 15.0.w,
            child: Text(
              workModel.location == "" ? "" : "[${workModel.location}]",
              style: cardTitleStyle,
            ),
          ),
        ),
        //popup 버튼
        isDetail ? popupMenu(
          context: context,
          workModel: workModel,
          companyCode: companyCode,
        ) : Container(),
      ],
    ),
  );
}

Column workDetailContents({BuildContext context, String companyCode, WorkModel workModel, bool isDetail}) {
  Format _format = Format();
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      titleCard(context: context, companyCode: companyCode, workModel: workModel, isDetail: isDetail),
      emptySpace,
      Visibility(
        visible: workModel.contents != "",
        child: Padding(
          padding: EdgeInsets.only(left: SizerUtil.deviceType == DeviceType.Tablet ? 9.75.w : 13.0.w),
          child: Text(
            workModel.contents,
            style: cardContentsStyle,
          ),
        ),
      ),
      Visibility(
        visible: workModel.contents != "",
        child: emptySpace,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            _format.dateToString(_format.timeStampToDateTime(workModel.lastModDate)),
            style: cardSubTitleStyle,
          ),
          Text(
            workModel.createDate == workModel.lastModDate ? " 작성됨" : " 수정됨",
            style: cardSubTitleStyle,
          ),
        ],
      )
    ],
  );
}

Container popupMenu({BuildContext context, WorkModel workModel, String companyCode}) {
  FirebaseRepository _repository = FirebaseRepository();
  return Container(
    width: SizerUtil.deviceType == DeviceType.Tablet ? 7.5.w : 10.0.w,
    alignment: Alignment.center,
    child: PopupMenuButton(
      padding: EdgeInsets.zero,
      icon: Icon(
        Icons.more_vert_sharp,
        size: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
      ),
      onSelected: (value) async {
        if (value == 1) {
          workContent(
            context: context,
            workModel: workModel,
            type: workModel.type == "내근" ? 1 : 2,
          );
        } else {
          await _repository.deleteWork(
            documentID: workModel.id,
            companyCode: companyCode,
          );
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          height: 7.0.h,
          value: 1,
          child: Row(
            children: [
              Container(
                child: Icon(
                  Icons.edit,
                  size: SizerUtil.deviceType == DeviceType.Tablet ? popupMenuIconSizeTW.w : popupMenuIconSizeMW.w,
                ),
              ),
              Padding(padding: EdgeInsets.only(left: SizerUtil.deviceType == DeviceType.Tablet ? 1.5.w : 2.0.w)),
              Text(
                word.update(),
                style: popupMenuStyle,
              )
            ],
          ),
        ),
        PopupMenuItem(
          height: 7.0.h,
          value: 2,
          child: Row(
            children: [
              Icon(
                Icons.delete,
                size: SizerUtil.deviceType == DeviceType.Tablet ? popupMenuIconSizeTW.w : popupMenuIconSizeMW.w,
              ),
              Padding(padding: EdgeInsets.only(left: SizerUtil.deviceType == DeviceType.Tablet ? 1.5.w : 2.0.w)),
              Text(
                word.delete(),
                style: popupMenuStyle,
              )
            ],
          ),
        ),
      ],
    ),
  );
}
