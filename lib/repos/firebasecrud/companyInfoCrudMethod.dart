//Firebase
import 'package:cloud_firestore/cloud_firestore.dart';

//Repos
import 'package:companyplaylist/repos/firebaseMethod.dart';

//Model
import 'package:companyplaylist/models/companyModel.dart';



class CompanyInfoCrud {
  FirestoreApi _firestoreApi = FirestoreApi.onePath("company");

  List<Company> company;

  Future<List<Company>> fetchCompanyInfo() async{
    var result = await _firestoreApi.getDataCollection();
    company = result.documents.map((doc) => Company.fromMap(doc.data(), doc.documentID)).toList();

    return company;
  }

  Stream<QuerySnapshot> fetchCompanyInfoAsStream(){
    return _firestoreApi.streamDataCollection();
  }

  Future<Company> getCompanyInfoDataToFirebaseById({String documentId}) async {
    var doc = await _firestoreApi.getDocumentById(documentId);
    return Company.fromMap(doc.data(), doc.documentID);
  }

  Future<void> removeCompanyInfoDataToFirebase({String documentId}) async {
    await _firestoreApi.removeDocument(documentId);
    return null;
  }

  Future<void> updateCompanyInfoDataToFirebase({Company dataModel, String documentId}) async {
    await _firestoreApi.updateDocument(dataModel.toJson(), documentId);
    return null;
  }

  Future<void> setCompanyInfoDataToFirebase({Company dataModel, String documentId}) async{
    await _firestoreApi.setDocument(dataModel.toJson(), documentId);
    return null;
  }
}