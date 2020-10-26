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
import 'package:companyplaylist/models/bigCategoryModel.dart';
import 'package:companyplaylist/models/workModel.dart';

//Repos
import 'package:companyplaylist/repos/firebaseMethod.dart';

class WorkCategoryCrud {
  FirestoreApi _firestoreApi;
  String companyCode;

  List<bigCategoryModel> work;

  // firebase connection
  WorkCategoryCrud(this.companyCode){
    _firestoreApi = FirestoreApi.twoPath("company", "bigCategory", companyCode);
  }

  Future<List<bigCategoryModel>> fetchWorkCategory () async{
    var result = await _firestoreApi.getDataCollection();
    work = result.documents.map((doc) => bigCategoryModel.fromMap(doc.data, doc.documentID)).toList();

    return work;
  }

  Stream<QuerySnapshot> fetchWorkCategoryAsStream(){
    return _firestoreApi.streamDataCollection();
  }

  Future<void> addWorkCategoryDataToFirebase({bigCategoryModel dataModel}) async{
    await _firestoreApi.addDocument(dataModel.toJson());
    return null;
  }

  Future<void> setWorkCategoryDataToFirebase({bigCategoryModel dataModel, String documentId}) async{
    await _firestoreApi.setDocument(dataModel.toJson(), documentId);
    return null;
  }
}