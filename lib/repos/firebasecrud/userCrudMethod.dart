//Flutter
import 'package:flutter/material.dart';

//Firebase
import 'package:cloud_firestore/cloud_firestore.dart';

//Repos
import 'package:companyplaylist/repos/firebaseMethod.dart';

//Model
import 'package:companyplaylist/models/userModel.dart';



class UserCrud {
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

  Future<User> getUserDataToFirebaseByID(String id) async {
    var doc = await _firestoreApi.getDocumentById(id);
    return User.fromMap(doc.data, doc.documentID);
  }

  Future removeUserDataToFirebase(String id) async {
    await _firestoreApi.removeDocument(id);
    return null;
  }

  Future updateUserDataToFirebase(User data, String id) async {
    await _firestoreApi.updateDocument(data.toJson(), id);
    return null;
  }

  Future addUserDataToFirebase(User data) async {
    await _firestoreApi.addDocument(data.toJson());
    return null;
  }
}