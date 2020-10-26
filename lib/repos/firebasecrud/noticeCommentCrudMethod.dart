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
import 'package:companyplaylist/models/noticeCommentModel.dart';
import 'package:companyplaylist/models/workModel.dart';

//Repos
import 'package:companyplaylist/repos/firebaseMethod.dart';

class NoticeCommentCrud {
  FirestoreApi _firestoreApi;
  String companyCode;
  String noticeID;

  List<NoticeCommentModel> notice;

  // firebase connection
  NoticeCommentCrud(this.companyCode, this.noticeID){
    _firestoreApi = FirestoreApi.threePath("company", companyCode, "notice", noticeID, "comment");
  }

  Future<List<NoticeCommentModel>> fetchNoticeComment() async{
    var result = await _firestoreApi.getDataCollection();
    notice = result.documents.map((doc) => NoticeCommentModel.fromMap(doc.data, doc.documentID)).toList();

    return notice;
  }

  Stream<QuerySnapshot> fetchNoticeCommentAsStream(){
    return _firestoreApi.streamDataCollection();
  }

  Future<void> addNoticeCommentDataToFirebase({NoticeCommentModel dataModel}) async{
    await _firestoreApi.addDocument(dataModel.toJson());
    return null;
  }

  Future<NoticeCommentModel> getNoticeCommentDataToFirebaseById({String documentId}) async {
    var doc = await _firestoreApi.getDocumentById(documentId);
    return NoticeCommentModel.fromMap(doc.data, doc.documentID);
  }

  Future<void> removeNoticeCommentDataToFirebase({String documentId}) async {
    await _firestoreApi.removeDocument(documentId);
    return null;
  }

  Future<void> updateNoticeCommentDataToFirebase({NoticeCommentModel dataModel, String documentId}) async {
    await _firestoreApi.updateDocument(dataModel.toJson(), documentId);
    return null;
  }

  Future<void> setNoticeCommentDataToFirebase({NoticeCommentModel dataModel, String documentId}) async{
    await _firestoreApi.setDocument(dataModel.toJson(), documentId);
    return null;
  }
}