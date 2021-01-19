import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/models/workApprovalModel.dart';
import 'package:MyCompany/provider/user/loginUserInfo.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:MyCompany/widgets/approval/approvalDetail.dart';
import 'package:MyCompany/widgets/card/approvalCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SignBoxPurchase extends StatefulWidget {
  @override
  _SignBoxPurchaseState createState() => _SignBoxPurchaseState();
}

class _SignBoxPurchaseState extends State<SignBoxPurchase> {
  String orderByType = "status";
  bool _isOrderBy = true;
  LoginUserInfoProvider _loginUserInfoProvider;
  User user;

  @override
  Widget build(BuildContext context) {
    _loginUserInfoProvider = Provider.of<LoginUserInfoProvider>(context, listen: false);
    user = _loginUserInfoProvider.getLoginUser();
    return Scaffold(
      body: Column(
        children: [
          Card(
            elevation: 0,
            shape: cardShape,
            child: Padding(
              padding: cardPadding,
              child: Container(
                height: cardTitleSizeH.h,
                child: Row(children: [
                  Container(
                    width: SizerUtil.deviceType == DeviceType.Tablet ? 15.0.w : 13.0.w,
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Text(
                          "종류",
                          style: cardBlueStyle,
                        ),
                      ],
                    ),
                  ),
                  cardSpace,
                  cardSpace,
                  Container(
                    width: SizerUtil.deviceType == DeviceType.Tablet ? 21.0.w : 19.0.w,
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Text(
                          "요청일자",
                          style: cardBlueStyle,
                        ),
                      ],
                    ),
                  ),
                  cardSpace,
                  Container(
                    width: SizerUtil.deviceType == DeviceType.Tablet ? 15.0.w : 13.0.w,
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Text(
                          "상태",
                          style: cardBlueStyle,
                        ),
                      ],
                    ),
                  ),
                  cardSpace,
                  Container(
                    width: SizerUtil.deviceType == DeviceType.Tablet ? 18.0.w : 16.0.w,
                    alignment: Alignment.center,
                    child: Text(
                      "대상일",
                      style: cardBlueStyle,
                    ),
                  ),
                  /*Container(
                        width: SizerUtil.deviceType == DeviceType.Tablet ? 11.0.w : 9.0.w,
                        alignment: Alignment.center,
                        child: Text(
                          "옵션",
                          style: cardBlueStyle,
                        ),
                      ),*/
                ]),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseRepository().requestAnnualLeave(
              companyCode: user.companyCode,
              mail: user.mail,
              isOrderBy: _isOrderBy,
              orderByType: orderByType,
            ),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              List<DocumentSnapshot> document = snapshot.data.docs;

              return Expanded(
                  child: ListView(
                children: document.map((data) => _buildApprovalRequestList(context, data, user)).toList(),
              ));
            },
          )
        ],
      ),
    );
  }
}

Widget _buildApprovalRequestList(BuildContext context, DocumentSnapshot data, User user) {
  final approval = WorkApproval.fromSnapshow(data);

  return StatefulBuilder(
    builder: (context, setState) {
      return InkWell(
        child: RequestApprovalCard(
            context:context,
            companyCode: user.companyCode,
            model: approval
        ),
        onTap: () {
          //상세보기
          switch(approval.approvalType) {
            case "연차" :
            case "반차" :
              annualLeaveRequestApprovalBottomSheet(
                context: context,
                companyCode: user.companyCode,
                model: approval
              );
              break;
            default :
              break;
          };
        }
      );
    },
  );
}
