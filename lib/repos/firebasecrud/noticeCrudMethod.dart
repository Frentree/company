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
import 'package:companyplaylist/models/noticeModel.dart';
import 'package:companyplaylist/models/workModel.dart';

//Repos
import 'package:companyplaylist/repos/firebaseMethod.dart';

class NoticeCrud {
  FirestoreApi _firestoreApi;
  String companyCode;

  List<NoticeModel> notice;

  // firebase connection
  NoticeCrud(this.companyCode){
    _firestoreApi = FirestoreApi.twoPath("company", "notice", companyCode);
  }

  Future<List<NoticeModel>> fetchNotice() async{
    var result = await _firestoreApi.getDataCollection();
    notice = result.documents.map((doc) => NoticeModel.fromMap(doc.data, doc.documentID)).toList();

    return notice;
  }

  Future<NoticeModel> getNoticeDataToFirebaseById({String documentId}) async {
    var doc = await _firestoreApi.getDocumentById(documentId);
    return NoticeModel.fromMap(doc.data, doc.documentID);
  }

  Stream<QuerySnapshot> fetchNoticeAsStream(){
    return _firestoreApi.streamDataCollection();
  }

  Future<void> addNoticeDataToFirebase({NoticeModel dataModel}) async{
    await _firestoreApi.addDocument(dataModel.toJson());
    return null;
  }

  Future<void> removeNoticeDataToFirebase({String documentId}) async {
    await _firestoreApi.removeDocument(documentId);
    return null;
  }

  Future<void> updateNoticeDataToFirebase({NoticeModel dataModel, String documentId}) async {
    await _firestoreApi.updateDocument(dataModel.toJson(), documentId);
    return null;
  }

  Future<void> setNoticeDataToFirebase({NoticeModel dataModel, String documentId}) async{
    await _firestoreApi.setDocument(dataModel.toJson(), documentId);
    return null;
  }
}