//Firebase
import 'package:cloud_firestore/cloud_firestore.dart';

//Repos
import 'package:companyplaylist/repos/firebaseMethod.dart';

//Model
import 'package:companyplaylist/models/companyUserModel.dart';

class CompanyUserCrud {
  String companyCode;
  FirestoreApi _firestoreApi;

  CompanyUserCrud(this.companyCode){
    _firestoreApi = FirestoreApi.twoPath("company", "user", companyCode);
  }

  List<CompanyUser> user;

  Future<List<CompanyUser>> fetchCompanyUser() async{
    var result = await _firestoreApi.getDataCollection();
    user = result.documents.map((doc) => CompanyUser.fromMap(doc.data, doc.documentID)).toList();

    return user;
  }

  Stream<QuerySnapshot> fetchCompanyUserAsStream(){
    return _firestoreApi.streamDataCollection();
  }

  Future<CompanyUser> getCompanyUserDataToFirebaseById({String documentId}) async {
    var doc = await _firestoreApi.getDocumentById(documentId);
    return CompanyUser.fromMap(doc.data, doc.documentID);
  }

  Future<void> removeCompanyUserDataToFirebase({String documentId}) async {
    await _firestoreApi.removeDocument(documentId);
    return null;
  }

  Future<void> updateCompanyUserDataToFirebase({CompanyUser dataModel, String documentId}) async {
    await _firestoreApi.updateDocument(dataModel.toJson(), documentId);
    return null;
  }

  Future<void> setCompanyUserDataToFirebase({CompanyUser dataModel, String documentId}) async{
    await _firestoreApi.setDocument(dataModel.toJson(), documentId);
    return null;
  }
}
