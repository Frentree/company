//Firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyplaylist/consts/universalString.dart';
import 'package:companyplaylist/models/expenseModel.dart';
import 'package:companyplaylist/models/userModel.dart';
import 'package:flutter/material.dart';

class FirebaseMethods {
  static final Firestore firestore = Firestore.instance;

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
