//Firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyplaylist/consts/universalString.dart';
import 'package:companyplaylist/models/approvalModel.dart';
import 'package:companyplaylist/models/companyModel.dart';
import 'package:companyplaylist/models/companyUserModel.dart';
import 'package:companyplaylist/models/expenseModel.dart';
import 'package:companyplaylist/models/meetingModel.dart';
import 'package:companyplaylist/models/workModel.dart';
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/utils/date/dateFormat.dart';
import 'package:flutter/material.dart';

class FirebaseMethods {
  static final Firestore firestore = Firestore.instance;

  Future<DocumentReference> saveExpense(ExpenseModel expenseModel) async {
    var map = expenseModel.toMap();

    Future<DocumentReference> doc = firestore
        .collection(COMPANY)
        .document(expenseModel.companyCode)
        .collection(USER)
        .document(expenseModel.mail)
        .collection(EXPENSE)
        .add(map);

    return doc;

    /*return await firestore
        .collection(COMPANY)
        .document(expenseModel.companyCode)
        .collection(USER)
        .document(expenseModel.mail)
        .collection(EXPENSE)
        .add(map);  */
  }

  //사용자 데이터 관련
  Future<void> saveUser({User userModel}) async {
    return await firestore
        .collection(USER)
        .document(userModel.mail)
        .setData(userModel.toJson());
  }

  Future<User> getUser({String userMail}) async {
    var doc = await firestore.collection(USER).document(userMail).get();
    return User.fromMap(doc.data, doc.documentID);
  }

  Future<void> updateUser({User userModel}) async {
    Format _format = Format();
    userModel.lastModDate = _format.dateTimeToTimeStamp(DateTime.now());

    return await firestore
        .collection(USER)
        .document(userModel.mail)
        .updateData(userModel.toJson());
  }

  //회사데이터 관련
  Future<void> saveCompany({Company companyModel}) async {
    return await firestore
        .collection(COMPANY)
        .document(companyModel.companyCode)
        .setData(companyModel.toJson());
  }

  Future<QuerySnapshot> getCompany({String companyName}) async {
    return await firestore
        .collection(COMPANY)
        .where("companyName", isGreaterThanOrEqualTo: companyName)
        .getDocuments();
  }

  Future<void> saveCompanyUser({CompanyUser companyUserModel}) async {
    return await firestore
        .collection(COMPANY)
        .document(companyUserModel.user.companyCode)
        .collection(USER)
        .document(companyUserModel.user.mail)
        .setData(companyUserModel.toJson());
  }

  Future<String> geAppManagerMail({String comapanyCode}) async {
    QuerySnapshot querySnapshot = await firestore
        .collection(COMPANY)
        .document(comapanyCode)
        .collection(USER)
        .where("level", isEqualTo: 5)
        .getDocuments();

    String appManagerMail = querySnapshot.documents.first.documentID;

    return appManagerMail;
  }

  //회사 직원 관련
  Future<Map<String, String>> getColleague(
      {String loginUserMail, String companyCode}) async {
    Map<String, String> colleague = {};
    QuerySnapshot querySnapshot = await firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(USER)
        .orderBy("name")
        .getDocuments();
    querySnapshot.documents.forEach((element) {
      if (element.documentID != loginUserMail) {
        colleague[element.documentID] = element.data["name"];
      }
    });

    return colleague;
  }

  //내외근 데이터 관련 관련
  Future<void> saveWork({WorkModel workModel, String companyCode}) async {
    return await firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(WORK)
        .add(workModel.toJson());
  }

  Future<void> updateWork({WorkModel workModel, String companyCode}) async {
    return await firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(WORK)
        .document(workModel.id)
        .updateData(workModel.toJson());
  }

  Future<void> deleteWork({String documentID, String companyCode}) async {
    return await firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(WORK)
        .document(documentID)
        .delete();
  }

  //회의 데이터 관련 관련
  Future<void> saveMeeting(
      {MeetingModel meetingModel, String companyCode}) async {
    return await firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(WORK)
        .add(meetingModel.toJson());
  }

  Future<void> updateMeeting(
      {MeetingModel meetingModel, String companyCode}) async {
    return await firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(WORK)
        .document(meetingModel.id)
        .updateData(meetingModel.toJson());
  }

  Future<void> deleteMeeting({String documentID, String companyCode}) async {
    return await firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(WORK)
        .document(documentID)
        .delete();
  }

  //Work 데이터 전체 관련
  Stream<QuerySnapshot> getCompanyWork({String companyCode}) {
    return firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(WORK)
        .snapshots();
  }

  Stream<QuerySnapshot> getSelectedDateCompanyWork(
      {String companyCode, Timestamp selectedDate}) {
    return firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(WORK)
        .where("startDate", isEqualTo: selectedDate)
        .orderBy("startTime")
        .snapshots();
  }

  Stream<QuerySnapshot> getSelectedWeekCompanyWork(
      {String companyCode, List<Timestamp> selectedWeek}) {
    return firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(WORK)
        .where("startDate", whereIn: selectedWeek)
        .orderBy("startTime")
        .snapshots();
  }

  //알람 관련
  //사용자 승인
  Future<void> saveApproval(
      {String companyCode,
      String appManagerMail,
      Approval approvalModel}) async {
    return await firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(USER)
        .document(appManagerMail)
        .collection(APPROVAL)
        .add(approvalModel.toJson());
  }

  Stream<QuerySnapshot> getApproval({String companyCode, String managerMail}) {
    return firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(USER)
        .document(managerMail)
        .collection(APPROVAL)
        .where("state", isEqualTo: 0)
        .snapshots();
  }

  Future<void> updateApproval(
      {Approval approvalModel, String companyCode, String managerMail}) async {
    print(approvalModel.toJson());
    return await firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(USER)
        .document(managerMail)
        .collection(APPROVAL)
        .document(approvalModel.id)
        .updateData(approvalModel.toJson());
  }
}

class FirestoreApi {
  final Firestore _db = Firestore.instance;
  String path;
  String secondPath;
  String thirdPath;
  String documentId;
  String secondDocumentId;
  CollectionReference ref;

  FirestoreApi.onePath(this.path) {
    ref = _db.collection(path);
  }

  FirestoreApi.twoPath(this.path, this.secondPath, this.documentId) {
    ref = _db.collection(path).document(documentId).collection(secondPath);
  }

  FirestoreApi.threePath(this.path, this.documentId, this.secondPath,
      this.secondDocumentId, this.thirdPath) {
    ref = _db
        .collection(path)
        .document(documentId)
        .collection(secondPath)
        .document(secondDocumentId)
        .collection(thirdPath);
  }

  Future<QuerySnapshot> getDataCollection() {
    return ref.getDocuments();
  }

  Stream<QuerySnapshot> streamDataCollection() {
    return ref.snapshots();
  }

  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.document(id).get();
  }

  Future<void> removeDocument(String id) {
    return ref.document(id).delete();
  }

  Future<DocumentReference> addDocument(Map data) {
    return ref.add(data);
  }

  Future<void> updateDocument(Map data, String id) {
    return ref.document(id).updateData(data);
  }

  Future<void> setDocument(Map data, String id) {
    return ref.document(id).setData(data);
  }
}
