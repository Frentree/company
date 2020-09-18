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
    company = result.documents.map((doc) => Company.fromMap(doc.data, doc.documentID)).toList();

    return company;
  }

  Stream<QuerySnapshot> fetchCompanyInfoAsStream(){
    return _firestoreApi.streamDataCollection();
  }

  Future<Company> getCompanyInfoDataToFirebaseById(String id) async {
    var doc = await _firestoreApi.getDocumentById(id);
    return Company.fromMap(doc.data, doc.documentID);
  }

  Future removeCompanyInfoDataToFirebase(String id) async {
    await _firestoreApi.removeDocument(id);
    return null;
  }

  Future updateCompanyInfoDataToFirebase(Company data, String id) async {
    await _firestoreApi.updateDocument(data.toJson(), id);
    return null;
  }

  Future addCompanyInfoDataToFirebase(Company data) async {
    await _firestoreApi.addDocument(data.toJson());
    return null;
  }

  Future setCompanyInfoDataToFirebase(Company data, String id) async{
    await _firestoreApi.setDocument(data.toJson(), id);
    return null;
  }
}