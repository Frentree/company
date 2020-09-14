import 'package:flutter/material.dart';
import 'package:companyplaylist/repos/firebaseMethod.dart';
import 'package:companyplaylist/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserCrud extends ChangeNotifier {
  FirestoreApi _firestoreApi = FirestoreApi("user");

  List<User> user;

  Future<List<User>> fetchUser() async{
    var result = await _firestoreApi.getDataCollection();
    user = result.documents.map((doc) => User.fromMap(doc.data, doc.documentID)).toList();

    return user;
  }

  Stream<QuerySnapshot> fetchUserAsStream(){
    return _firestoreApi.streamDataCollection();
  }

  Future<User> getUserByID(String id) async {
    var doc = await _firestoreApi.getDocumentById(id);
    return User.fromMap(doc.data, doc.documentID);
  }

  Future removeUser(String id) async {
    await _firestoreApi.removeDocument(id);
    return null;
  }

  Future updateUser(User data, String id) async {
    await _firestoreApi.updateDocument(data.toJson(), id);
    return null;
  }

  Future addUser(User data, String id) async {
    await _firestoreApi.setDocument(data.toJson(),id);
    return null;
  }
}