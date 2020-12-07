//Firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyplaylist/consts/universalString.dart';
import 'package:companyplaylist/models/expenseModel.dart';
import 'package:companyplaylist/models/userModel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirebaseMethods {
  static final Firestore firestore = Firestore.instance;
  static final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Future<void> saveExpense(ExpenseModel expenseModel) async {
    var map = expenseModel.toMap();

    return await firestore
        .collection(COMPANY)
        .document(expenseModel.companyCode)
        .collection(USER)
        .document(expenseModel.mail)
        .collection(EXPENSE)
        .add(map);
  }

  Future<String> getImageUrl(String email) async {
    String url;
    StorageReference ref = firebaseStorage.ref().child("profile/${email}");

    url = (await ref.getDownloadURL()).toString();
    return url;
  }

  Stream<QuerySnapshot> getGrade(String companyCode) {
    return Firestore.instance
        .collection("company")
        .document(companyCode)
        .collection("grade")
        .orderBy("gradeID", descending: true)
        .snapshots();
  }

  Future<void> deleteUser(String documentID, String companyCode, int level) async {
    return await firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(USER)
        .document(documentID)
        .updateData({
      "level" : FieldValue.arrayRemove([level])
    });
  }

  Future<void> addGrade(String companyCode, String gradeName, int gradeID) async {
    return await firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(GRADE)
        .add({
      "gradeID" : gradeID,
      "gradeName" : gradeName
    });
  }

  Future<void> updateGradeName(String documentID, String gradeName, String companyCode) async {
    return await firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(GRADE)
        .document(documentID)
        .updateData({
          "gradeName" : gradeName
        });
  }

  Future<void> deleteGrade(String documentID, String companyCode) async {
    return await firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(GRADE)
        .document(documentID)
        .delete();
  }

  Stream<QuerySnapshot> getGreadeUserDetail(String companyCode, int level) {
    return firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(USER)
        .where("level", arrayContains: level)
        .snapshots();
  }

  Stream<QuerySnapshot> getGreadeUserAdd(String companyCode) {
    return firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(USER)
        .orderBy("name", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getGreadeUserDelete(String companyCode, int level) {
    return firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(USER)
        .where("level", arrayContains: level)
        .snapshots();
  }

  Future<void> changeGradeUser(String companyCode, List<Map<String,dynamic>> user) async {
    for(int i = 0; i < user.length; i++)
     await firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(USER)
        .document(user[i]['mail'])
        .updateData({
          "level" : user[i]['level']
        });
     return null;
  }
}

class FirestoreApi{
  final Firestore _db = Firestore.instance;
  String path;
  String secondPath;
  String thirdPath;
  String documentId;
  String secondDocumentId;
  CollectionReference ref;

  FirestoreApi.onePath(this.path){
    ref = _db.collection(path);
  }

  FirestoreApi.twoPath(this.path, this.secondPath, this.documentId){
    ref = _db.collection(path).document(documentId).collection(secondPath);
  }

  FirestoreApi.threePath(this.path, this.documentId, this.secondPath, this.secondDocumentId, this.thirdPath){
    ref = _db.collection(path).document(documentId).collection(secondPath).document(secondDocumentId).collection(thirdPath);
  }

  Future<QuerySnapshot> getDataCollection(){
    return ref.getDocuments();
  }

  Stream<QuerySnapshot> streamDataCollection(){
    return ref.snapshots();
  }

  Future<DocumentSnapshot> getDocumentById(String id){
    return ref.document(id).get();
  }

  Future<void> removeDocument(String id){
    return ref.document(id).delete();
  }

  Future<DocumentReference> addDocument(Map data){
    return ref.add(data);
  }

  Future<void> updateDocument(Map data, String id){
    return ref.document(id).updateData(data);
  }

  Future<void> setDocument(Map data, String id){
    return ref.document(id).setData(data);
  }
}