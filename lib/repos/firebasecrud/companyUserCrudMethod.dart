//Firebase
import 'package:cloud_firestore/cloud_firestore.dart';

//Repos
import 'package:companyplaylist/repos/firebaseMethod.dart';

//Model
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/models/companyModel.dart';



class CompanyUserCrud {
  String companyCode;
  FirestoreApi _firestoreApi;

  CompanyUserCrud(this.companyCode){
    _firestoreApi = FirestoreApi.twoPath("company", "user", companyCode);
  }

  List<User> user;

  Future<List<User>> fetchCompanyUser() async{
    var result = await _firestoreApi.getDataCollection();
    user = result.documents.map((doc) => User.fromMap(doc.data, doc.documentID)).toList();

    return user;
  }

  Stream<QuerySnapshot> fetchCompanyUserAsStream(){
    return _firestoreApi.streamDataCollection();
  }

  Future<User> getCompanyUserDataToFirebaseById(String id) async {
    var doc = await _firestoreApi.getDocumentById(id);
    return User.fromMap(doc.data, doc.documentID);
  }

  Future removeCompanyUserDataToFirebase(String id) async {
    await _firestoreApi.removeDocument(id);
    return null;
  }

  Future updateCompanyUserDataToFirebase(User data, String id) async {
    await _firestoreApi.updateDocument(data.toJson(), id);
    return null;
  }

  Future addCompanyUserDataToFirebase(User data) async {
    await _firestoreApi.addDocument(data.toJson());
    return null;
  }
}
