//Firebase
import 'package:cloud_firestore/cloud_firestore.dart';

//Repos
import 'package:companyplaylist/repos/firebaseMethod.dart';

//Model
import 'package:companyplaylist/models/attendanceModel.dart';

class AttendanceCrud {
  String companyCode;
  FirestoreApi _firestoreApi;

  AttendanceCrud(this.companyCode){
    _firestoreApi = FirestoreApi.twoPath("company", "attendance", companyCode);
  }

  List<Attendance> attendance;

  Future<List<Attendance>> fetchAttendance() async{
    var result = await _firestoreApi.getDataCollection();
    attendance = result.documents.map((doc) => Attendance.fromMap(doc.data(), doc.documentID)).toList();

    return attendance;
  }

  Stream<QuerySnapshot> fetchAttendanceAsStream(){
    return _firestoreApi.streamDataCollection();
  }

  Future<Attendance> getAttendanceDataToFirebaseById({String documentId}) async {
    var doc = await _firestoreApi.getDocumentById(documentId);
    return Attendance.fromMap(doc.data(), doc.documentID);
  }

  Future<void> removeAttendanceDataToFirebase({String documentId}) async {
    await _firestoreApi.removeDocument(documentId);
    return null;
  }

  Future<void> updateAttendanceDataToFirebase({Attendance dataModel, String documentId}) async {
    await _firestoreApi.updateDocument(dataModel.toJson(), documentId);
    return null;
  }

  Future<void> setAttendanceDataToFirebase({Attendance dataModel, String documentId}) async{
    await _firestoreApi.setDocument(dataModel.toJson(), documentId);
    return null;
  }
}
