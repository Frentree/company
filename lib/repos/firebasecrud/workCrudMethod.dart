//Firebase
import 'package:cloud_firestore/cloud_firestore.dart';

//Repos
import 'package:companyplaylist/repos/firebaseMethod.dart';

//Model
import 'package:companyplaylist/models/attendanceModel.dart';

class UserAttendanceCrud {
  String companyCode;
  FirestoreApi _firestoreApi;

  UserAttendanceCrud(this.companyCode){
    _firestoreApi = FirestoreApi.twoPath("company", "attendance", companyCode);
  }

  List<Attendance> attendance;

  Future<List<Attendance>> fetchUserAttendance() async{
    var result = await _firestoreApi.getDataCollection();
    attendance = result.documents.map((doc) => Attendance.fromMap(doc.data, doc.documentID)).toList();

    return attendance;
  }

  Stream<QuerySnapshot> fetchUserAttendanceAsStream(){
    return _firestoreApi.streamDataCollection();
  }

  Future<Attendance> getUserAttendanceDataToFirebaseById({String documentId}) async {
    var doc = await _firestoreApi.getDocumentById(documentId);
    return Attendance.fromMap(doc.data, doc.documentID);
  }

  Future<void> removeUserAttendanceDataToFirebase({String documentId}) async {
    await _firestoreApi.removeDocument(documentId);
    return null;
  }

  Future<void> updateUserAttendanceDataToFirebase({Attendance dataModel, String documentId}) async {
    await _firestoreApi.updateDocument(dataModel.toJson(), documentId);
    return null;
  }

  Future<void> addUserAttendanceDataToFirebase({Attendance dataModel}) async{
    await _firestoreApi.addDocument(dataModel.toJson());
    return null;
  }
}
