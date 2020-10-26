/*
* work 에 관련된 Firebase Crud
* 이윤혁, 2020-09-23 최초작정
*
* @author 이윤혁
* @version 1.0
* 이윤혁, 마지막 수정일 2020-09-23
*
* */
//Firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyplaylist/models/workModel.dart';

//Repos
import 'package:companyplaylist/repos/firebaseMethod.dart';

class CompanyWorkCrud {
  FirestoreApi _firestoreApi;
  String companyCode;

  List<CompanyWork> work;

  // firebase connection
  CompanyWorkCrud(this.companyCode){
    _firestoreApi = FirestoreApi.twoPath("company", "work", companyCode);
  }

  Future<List<CompanyWork>> fetchCompanyWork() async{
    var result = await _firestoreApi.getDataCollection();
    work = result.documents.map((doc) => CompanyWork.fromMap(doc.data, doc.documentID)).toList();

    return work;
  }

  Stream<QuerySnapshot> fetchCompanyWorkAsStream(){
    return _firestoreApi.streamDataCollection();
  }

  Future<void> addCompanyWorkDataToFirebase({CompanyWork dataModel}) async{
    await _firestoreApi.addDocument(dataModel.toJson());
    return null;
  }

  Future<void> setCompanyWorkDataToFirebase({CompanyWork dataModel, String documentId}) async{
    await _firestoreApi.setDocument(dataModel.toJson(), documentId);
    return null;
  }
}