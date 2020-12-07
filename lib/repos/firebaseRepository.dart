import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyplaylist/models/approvalModel.dart';
import 'package:companyplaylist/models/attendanceModel.dart';
import 'package:companyplaylist/models/companyModel.dart';
import 'package:companyplaylist/models/companyUserModel.dart';
import 'package:companyplaylist/models/expenseModel.dart';
import 'package:companyplaylist/models/meetingModel.dart';
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/models/workModel.dart';
import 'package:companyplaylist/repos/firebaseMethod.dart';

class FirebaseRepository {
  FirebaseMethods _firebaseMethods = FirebaseMethods();

  Future<void> saveExpense(ExpenseModel expenseModel) =>
      _firebaseMethods.saveExpense(expenseModel);

  Future<void> saveUser({User userModel}) => _firebaseMethods.saveUser(
        userModel: userModel,
      );

  Future<User> getUser({String userMail}) => _firebaseMethods.getUser(
        userMail: userMail,
      );

  Future<void> updateUser({User userModel}) => _firebaseMethods.updateUser(
        userModel: userModel,
      );

  Future<void> saveCompany({Company companyModel}) =>
      _firebaseMethods.saveCompany(
        companyModel: companyModel,
      );

  Future<List<DocumentSnapshot>> getCompany({String companyName}) =>
      _firebaseMethods.getCompany(
        companyName: companyName,
      );

  Future<void> saveCompanyUser({CompanyUser companyUserModel}) =>
      _firebaseMethods.saveCompanyUser(companyUserModel: companyUserModel);

  Future<String> geAppManagerMail({String companyCode}) =>
      _firebaseMethods.geAppManagerMail(companyCode: companyCode);

  Future<void> saveWork({WorkModel workModel, String companyCode}) =>
      _firebaseMethods.saveWork(
        workModel: workModel,
        companyCode: companyCode,
      );

  Future<void> updateWork({WorkModel workModel, String companyCode}) =>
      _firebaseMethods.updateWork(
        workModel: workModel,
        companyCode: companyCode,
      );

  Future<void> deleteWork({String documentID, String companyCode}) =>
      _firebaseMethods.deleteWork(
        documentID: documentID,
        companyCode: companyCode,
      );

  Future<void> saveMeeting({MeetingModel meetingModel, String companyCode}) =>
      _firebaseMethods.saveMeeting(
        meetingModel: meetingModel,
        companyCode: companyCode,
      );

  Future<void> updateMeeting({MeetingModel meetingModel, String companyCode}) =>
      _firebaseMethods.updateMeeting(
        meetingModel: meetingModel,
        companyCode: companyCode,
      );

  Future<void> deleteMeeting({String documentID, String companyCode}) =>
      _firebaseMethods.deleteWork(
        documentID: documentID,
        companyCode: companyCode,
      );

  Stream<QuerySnapshot> getCompanyWork({String companyCode}) =>
      _firebaseMethods.getCompanyWork(
        companyCode: companyCode,
      );

  Stream<QuerySnapshot> getSelectedDateCompanyWork(
          {String companyCode, Timestamp selectedDate}) =>
      _firebaseMethods.getSelectedDateCompanyWork(
        companyCode: companyCode,
        selectedDate: selectedDate,
      );

  Stream<QuerySnapshot> getSelectedWeekCompanyWork(
          {String companyCode, List<Timestamp> selectedWeek}) =>
      _firebaseMethods.getSelectedWeekCompanyWork(
        companyCode: companyCode,
        selectedWeek: selectedWeek,
      );

  Future<Map<String, String>> getColleague(
          {String loginUserMail, String companyCode}) =>
      _firebaseMethods.getColleague(
          loginUserMail: loginUserMail, companyCode: companyCode);

  Future<DocumentReference> saveAttendance(
      {Attendance attendanceModel, String companyCode}) => _firebaseMethods.saveAttendance(
    attendanceModel: attendanceModel,
    companyCode: companyCode,
  );

  Future<QuerySnapshot> getMyTodayAttendance(
          {String companyCode, String loginUserMail, Timestamp today}) =>
      _firebaseMethods.getMyTodayAttendance(
        companyCode: companyCode,
        loginUserMail: loginUserMail,
        today: today,
      );

  Future<void> updateAttendance(
      {Attendance attendanceModel, String documentId ,String companyCode}) => _firebaseMethods.updateAttendance(
    attendanceModel: attendanceModel,
    documentId: documentId,
    companyCode: companyCode,
  );

  Future<void> saveApproval(
          {String companyCode,
          String appManagerMail,
          Approval approvalModel}) =>
      _firebaseMethods.saveApproval(
        companyCode: companyCode,
        appManagerMail: appManagerMail,
        approvalModel: approvalModel,
      );

  Stream<QuerySnapshot> getApproval({String companyCode, String managerMail}) =>
      _firebaseMethods.getApproval(
        companyCode: companyCode,
        managerMail: managerMail,
      );

  Future<void> updateApproval(
          {Approval approvalModel, String companyCode, String managerMail}) =>
      _firebaseMethods.updateApproval(
        approvalModel: approvalModel,
        companyCode: companyCode,
        managerMail: managerMail,
      );
}
