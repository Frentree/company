import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/models/companyModel.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:MyCompany/consts/screenSize/size.dart';
import 'package:MyCompany/consts/screenSize/style.dart';

class CompanySearchPage extends StatefulWidget {
  Company company;

  CompanySearchPage(this.company, {Key key}) : super(key: key);

  @override
  CompanySearchPageState createState() => CompanySearchPageState();
}

class CompanySearchPageState extends State<CompanySearchPage> {
  FirebaseRepository _repository = FirebaseRepository();

  TextEditingController _companyNameCon;
  Future<List<DocumentSnapshot>> searchResults;

  @override
  void initState() {
    super.initState();
    _companyNameCon = TextEditingController();
  }

  @override
  void dispose() {
    _companyNameCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_companyNameCon.text == "" && widget.company != null) {
      _companyNameCon.text = widget.company.companyName;
      searchResults = _repository.getCompany(companyName: _companyNameCon.text);
    }
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 10.0.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 2,
                    color: boarderColor,
                  )
                )
              ),
              child: Row(
                children: [
                  Container(
                    width: SizerUtil.deviceType == DeviceType.Tablet ? 15.0.w : 20.0.w,
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      padding: SizerUtil.deviceType == DeviceType.Tablet ? EdgeInsets.only(left: 3.0.w) : EdgeInsets.zero,
                      icon: Icon(
                        Icons.arrow_back_sharp,
                        color: mainColor,
                        size: SizerUtil.deviceType == DeviceType.Tablet ? iconSizeTW.w : iconSizeMW.w,
                      ),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Container(
                    width: SizerUtil.deviceType == DeviceType.Tablet ? 60.0.w : 80.0.w,
                    child: TextFormField(
                      controller: _companyNameCon,
                      style: defaultRegularStyle,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: textFormPadding,
                        hintText: "회사명 검색",
                        hintStyle: hintStyle,
                        border: InputBorder.none,
                      ),
                      onFieldSubmitted: ((value) {
                        if (value == "") {
                          searchResults = null;
                        } else {
                          Future<List<DocumentSnapshot>> result =
                          _repository.getCompany(companyName: _companyNameCon.text);
                          setState(() {
                            searchResults = result;
                          });
                        }
                      }),
                    ),
                  ),
                ],
              ),
            ),
            searchResults == null
                ? Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 15.0.h,
                            width: SizerUtil.deviceType == DeviceType.Tablet ? 37.5.w : 50.0.w,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Icon(
                                Icons.apartment,
                              ),
                            ),
                          ),
                          Container(
                              width: SizerUtil.deviceType == DeviceType.Tablet ? 37.5.w : 50.0.w,
                              alignment: Alignment.center,
                              child: Text(
                                "Search Company",
                                style: defaultRegularStyle,
                              )),
                        ],
                      ),
                    ),
                  )
                : Expanded(
                    child: FutureBuilder(
                      future: searchResults,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        List<Company> searchCompanyResult = [];
                        snapshot.data.forEach((doc) {
                          Company _company =
                              Company.fromMap(doc.data(), doc.documentID);
                          searchCompanyResult.add(_company);
                        });

                        if (_companyNameCon.text == "" ||
                            searchCompanyResult.length == 0) {
                          return Expanded(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 15.0.h,
                                    width: SizerUtil.deviceType == DeviceType.Tablet ? 37.5.w : 50.0.w,
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Icon(
                                        Icons.cancel_outlined,
                                        color: redColor,
                                      ),
                                    ),
                                  ),
                                  Container(
                                      width: SizerUtil.deviceType == DeviceType.Tablet ? 37.5.w : 50.0.w,
                                      alignment: Alignment.center,
                                      child: Text(
                                        "검색 결과 없음",
                                        style: defaultRegularStyle,
                                      )),
                                ],
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount: searchCompanyResult.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              child: Card(
                                elevation: 0,
                                shape: cardShape,
                                child: Padding(
                                  padding: cardPadding,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: cardTitleSizeH.h,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          searchCompanyResult[index].companyName,
                                          style: cardTitleStyle,
                                        ),
                                      ),
                                      emptySpace,
                                      Container(
                                        height: cardSubTitleSizeH.h,
                                        child: Text(
                                          searchCompanyResult[index].companyAddr,
                                          style: cardSubTitleStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.pop(context, searchCompanyResult[index]);
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
