//Firebase
import 'package:cloud_firestore/cloud_firestore.dart';

//Repos
import 'package:companyplaylist/repos/firebaseMethod.dart';

//Model
import 'package:companyplaylist/models/userModel.dart';



class UserCrud {
  FirestoreApi _firestoreApi = FirestoreApi.onePath("user");

  List<User> user;

  Future<List<User>> fetchUser() async{
    var result = await _firestoreApi.getDataCollection();
    user = result.documents.map((doc) => User.fromMap(doc.data, doc.documentID)).toList();

    return user;
  }

  Stream<QuerySnapshot> fetchUserAsStream(){
    return _firestoreApi.streamDataCollection();
  }

  Future<User> getUserDataToFirebaseById({String documentId}) async {
    var doc = await _firestoreApi.getDocumentById(documentId);
    return User.fromMap(doc.data, doc.documentID);
  }

  Future<void> removeUserDataToFirebase({String documentId}) async {
    await _firestoreApi.removeDocument(documentId);
    return null;
  }

  Future<void> updateUserDataToFirebase({User dataModel, String documentId}) async {
    await _firestoreApi.updateDocument(dataModel.toJson(), documentId);
    return null;
  }

  Future<void> setUserDataToFirebase({User dataModel, String documentId}) async{
    await _firestoreApi.setDocument(dataModel.toJson(), documentId);
    return null;
  }
}