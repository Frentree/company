import 'package:flutter/material.dart';
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/provider/loginScreenChange.dart';
import 'package:provider/provider.dart';
import 'package:companyplaylist/widgets/button.dart';

class EamilAuthPage extends StatefulWidget {
  @override
  EamilAuthPageState createState() => EamilAuthPageState();
}

class EamilAuthPageState extends State<EamilAuthPage> {
  TextEditingController _codeTextCon;

  @override
  void initState() {
    super.initState();
    _codeTextCon = TextEditingController();
  }

  @override
  void dispose(){
    _codeTextCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LoginScreenChangeProvider loginScreenChangeProvider = Provider.of<LoginScreenChangeProvider>(context);

    return Column(
      children: <Widget>[
        //상단 글자
        Text(
          "환영합니다.",
          style: customStyle(18, "Medium", blueColor),
        ),

        //공백
        SizedBox(
          height: customHeight(context, 0.05),
        ),

        //코드 입력란
        Container(
            width: customWidth(context, 0.7),
            child: RichText(
              text: TextSpan(
                  style: customStyle(14, "Regular", greyColor),
                  children: <TextSpan>[
                    TextSpan(
                        text: "본인인증 메일을 "
                    ),
                    TextSpan(
                        text: loginScreenChangeProvider.getSendValue(),
                        style: customStyle(14, "Regular", blueColor)
                    ),
                    TextSpan(
                        text: "으로 보냈습니다. 이메일을 확인해주세요. 인증확인 후 로그인 할 수 있습니다"
                    )
                  ]
              ),
            )
        ),

        //공백
        SizedBox(
          height: customHeight(context, 0.4),
        ),

        //요청하기 버튼
        loginScreenRaisedBtn(context, blueColor, "로그인", whiteColor, () => loginScreenChangeProvider.setPageIndex(0)),
      ],
    );
  }
}