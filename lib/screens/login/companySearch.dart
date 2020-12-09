import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/consts/widgetSize.dart';
import 'package:companyplaylist/models/companyModel.dart';
import 'package:companyplaylist/repos/firebaseRepository.dart';
import 'package:flutter/material.dart';

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
    if(_companyNameCon.text == "" && widget.company != null){
      _companyNameCon.text = widget.company.companyName;
      searchResults = _repository.getCompany(companyName: _companyNameCon.text);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        title: TextFormField(
          controller: _companyNameCon,
          decoration: InputDecoration(
            hintText: "회사명 검색",
            border: InputBorder.none,
          ),
          onFieldSubmitted: ((value) {
            if(value == ""){
              searchResults = null;
            }
            else{
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
      body: searchResults == null ? Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: heightRatio(
                  context: context,
                  heightRatio: 0.15,
                ),
                width: widthRatio(
                  context: context,
                  widthRatio: 0.3
                ),
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Icon(
                    Icons.apartment,
                  ),
                ),
              ),
              Container(
                width: widthRatio(
                    context: context,
                    widthRatio: 0.3
                ),
                child: font(
                  text: "Search Company"
                ),
              ),
            ],
          ),
        ),
      ) : Container(
        child: FutureBuilder(
          future: searchResults,
          builder: (context, snapshot){
            if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            List<Company> searchCompanyResult = [];
            snapshot.data.forEach((doc){
              Company _company = Company.fromMap(doc.data(), doc.documentID);
              searchCompanyResult.add(_company);
            });

            if(_companyNameCon.text == "" || searchCompanyResult.length == 0){
              return Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: heightRatio(
                          context: context,
                          heightRatio: 0.15,
                        ),
                        width: widthRatio(
                            context: context,
                            widthRatio: 0.3
                        ),
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: Icon(
                            Icons.close,
                            color: redColor,
                          ),
                        ),
                      ),
                      Container(
                        width: widthRatio(
                            context: context,
                            widthRatio: 0.3
                        ),
                        child: font(
                            text: "검색결과 없음"
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: searchCompanyResult.length,
              itemBuilder: (context, index){
                return GestureDetector(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        width: 1,
                        color: boarderColor,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: widthRatio(
                          context: context,
                          widthRatio: 0.02,
                        ),
                        vertical: heightRatio(
                          context: context,
                          heightRatio: 0.01,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: heightRatio(
                              context: context,
                              heightRatio: 0.04
                            ),
                            child: font(
                              text: searchCompanyResult[index].companyName,
                              textStyle: customStyle(
                                fontColor: mainColor,
                                fontWeightName: "Medium",
                              ),
                            ),
                          ),
                          Container(
                            height: heightRatio(
                                context: context,
                                heightRatio: 0.03
                            ),
                            child: font(
                              text: searchCompanyResult[index].companyAddr,
                              textStyle: customStyle(
                                fontColor: grayColor,
                                fontWeightName: "Regular",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: (){
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
