import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MyCompany/consts/colorCode.dart';
import 'package:MyCompany/consts/font.dart';
import 'package:MyCompany/consts/widgetSize.dart';
import 'package:MyCompany/models/companyModel.dart';
import 'package:MyCompany/repos/firebaseRepository.dart';
import 'package:flutter/material.dart';
import 'package:MyCompany/consts/screenSize/login.dart';
import 'package:MyCompany/consts/screenSize/widgetSize.dart';
import 'package:sizer/sizer.dart';

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
      appBar: AppBar(
        backgroundColor: whiteColor,
        title: TextFormField(
          controller: _companyNameCon,
          style: customStyle(
            fontWeightName: "Regular",
            fontColor: mainColor,
            fontSize: textFormFontSize.sp,
          ),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              vertical: textFormFontPaddingH.h,
              horizontal: textFormFontPaddingW.w,
            ),
            hintText: "회사명 검색",
            hintStyle: customStyle(
              fontWeightName: "Regular",
              fontColor: mainColor,
              fontSize: textFormFontSize.sp,
            ),
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
        iconTheme: IconThemeData().copyWith(color: Colors.black),
      ),
      body: searchResults == null
          ? Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 15.0.h,
                      width: 50.0.w,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Icon(
                          Icons.apartment,
                        ),
                      ),
                    ),
                    Container(
                        width: 50.0.w,
                        alignment: Alignment.center,
                        child: Text(
                          "Search Company",
                          style: customStyle(
                            fontSize: 13.0.sp,
                          ),
                        )),
                  ],
                ),
              ),
            )
          : Container(
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
                    return Container(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 15.0.h,
                              width: 50.0.w,
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Icon(
                                  Icons.cancel_outlined,
                                  color: redColor,
                                ),
                              ),
                            ),
                            Container(
                                width: 50.0.w,
                                alignment: Alignment.center,
                                child: Text(
                                  "검색 결과 없음",
                                  style: customStyle(
                                    fontSize: 13.0.sp,
                                  ),
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(cardRadiusW.w),
                            side: BorderSide(
                              width: 1,
                              color: boarderColor,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: cardPaddingW.w,
                              vertical: cardPaddingH.h,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: cardTitleSizeH.h,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    searchCompanyResult[index].companyName,
                                    style: customStyle(
                                      fontSize: cardTitleFontSize.sp,
                                      fontColor: mainColor,
                                      fontWeightName: "Medium",
                                    ),
                                  ),
                                ),
                                Container(
                                  height: widgetDistanceH.h,
                                ),
                                Container(
                                  height: cardSubTitleSizeH.h,
                                  child: Text(
                                    searchCompanyResult[index].companyAddr,
                                    style: customStyle(
                                      fontSize: cardSubTitleFontSize.sp,
                                      fontColor: grayColor,
                                      fontWeightName: "Regular",
                                    ),
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
    );
  }
}
