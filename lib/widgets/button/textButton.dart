//Flutter
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:flutter/material.dart';

InkWell textBtn({String btnText, TextStyle btnTextStyle, btnAction}){
  return InkWell(
      child: Text(
        btnText,
        style: btnTextStyle,
      ),
      onTap: btnAction
  );
}

InkWell tabBtn({BuildContext context, double heightSize, double widthSize, String btnText, int tabIndexVariable, int tabOrder, Function tabAction}){
  return InkWell(
    child: Container(
      height: customHeight(
        context: context,
        heightSize: heightSize,
      ),
      width: customWidth(
        context: context,
        widthSize: widthSize
      ),
      child: Center(
        child: Text(
          btnText,
          style: customStyle(
            fontSize: 16,
            fontWeightName: "Medium",
            fontColor: mainColor
          ),
        ),
      ),
      decoration: tabIndexVariable == tabOrder ? BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: whiteColor
      ) : null
    ),
    onTap: tabAction,
  );
}

InkWell tabBtnWithUnderline({BuildContext context, double heightSize, double widthSize, String btnText, int tabIndexVariable, int tabOrder, Function tabAction}){
  return InkWell(
    child: Container(
        height: customHeight(
          context: context,
          heightSize: heightSize,
        ),
        width: customWidth(
            context: context,
            widthSize: widthSize
        ),
        child: Center(
          child: Text(
            btnText,
            style: customStyle(
                fontSize: 16,
                fontWeightName: "Medium",
                fontColor: tabIndexVariable == tabOrder ? mainColor : grayColor
            ),
          ),
        ),
        decoration: tabIndexVariable == tabOrder ? BoxDecoration(
          //borderRadius: BorderRadius.circular(8),
            color: whiteColor,
            border: Border(
                bottom: BorderSide(
                  color: mainColor,
                  width: 1.0,
                )
            )
        ) : null
    ),
    onTap: tabAction,
  );
}


Container filterBtn({BuildContext context, double heightSize, double widthSize, String btnText, int tabIndexVariable, int tabOrder, Function tabAction, Color color}){
  return Container(
    padding: EdgeInsets.all(1),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: tabColor
    ),
    child: Container(
      height: customHeight(
        context: context,
        heightSize: heightSize,
      ),
      width: customWidth(
          context: context,
          widthSize: widthSize
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: whiteColor
      ),
      child: InkWell(
        child: Container(
            child: Center(
              child: Text(
                btnText,
                style: customStyle(
                    fontSize: 14,
                    fontWeightName: "Medium",
                    fontColor: mainColor
                ),
              ),
            ),
            decoration: tabIndexVariable == tabOrder ? BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: color
            ) : null
        ),
        onTap: tabAction,
      ),
    ),
  );
}

InkWell manualOnWorkBtn({BuildContext context, String btnText, Function btnAction, bool isSelect}) {
  return InkWell(
    child: Container(
      width: customWidth(
          context: context,
          widthSize: 0.21
      ),
      height: customHeight(
          context: context,
          heightSize: 0.04
      ),

      decoration: BoxDecoration(
        color: isSelect ? mainColor : whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: mainColor,
        )
      ),
      child: Center(
        child: Text(
          btnText,
          style: customStyle(
              fontSize: 14,
              fontWeightName: "Regular",
              fontColor: isSelect ? whiteColor : mainColor
          ),
        ),
      )
    ),
    onTap: btnAction,
  );
}
