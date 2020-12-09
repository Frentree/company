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

  // 경비 청구 항목 저장 메서드
  Future<DocumentReference> saveExpense(ExpenseModel expenseModel) =>
      _firebaseMethods.saveExpense(expenseModel);

  Stream<QuerySnapshot> getExpense(String companyCode, String uid) =>
    _firebaseMethods.getExpense(companyCode, uid);

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
        approvalModel: approvalModel,
      );

  Stream<QuerySnapshot> getApproval({String companyCode}) =>
      _firebaseMethods.getApproval(
        companyCode: companyCode,
      );

  Future<DocumentSnapshot> getCompanyInfo({String companyCode}) =>
      _firebaseMethods.getCompanyInfo(
        companyCode: companyCode,
      );

  Future<void> updateApproval(
          {Approval approvalModel, String companyCode}) =>
      _firebaseMethods.updateApproval(
        approvalModel: approvalModel,
        companyCode: companyCode,
      );
  // 프로필 이미지
  Future<DocumentSnapshot> photoProfile(String companyCode, String mail) =>
      _firebaseMethods.photoProfile(companyCode, mail);

  Stream<QuerySnapshot> getGrade(String companyCode) =>
      _firebaseMethods.getGrade(companyCode);

  Future<void> userGrade(String companyCode, String mail) =>
      _firebaseMethods.userGrade(companyCode, mail);

  Future<void> deleteUser(String documentID, String companyCode, int level) =>
      _firebaseMethods.deleteUser(documentID, companyCode, level);

  Future<void> addGrade(String companyCode, String gradeName, int gradeID) =>
      _firebaseMethods.addGrade(companyCode, gradeName, gradeID);

  Future<void> updateGradeName(String documentID, String gradeName, String companyCode) =>
      _firebaseMethods.updateGradeName(documentID, gradeName, companyCode);

  // 권한 삭제
  Future<void> deleteGrade(String documentID, String companyCode) =>
      _firebaseMethods.deleteGrade(documentID, companyCode);

  // 권한 삭제시 유저 권한 없애기
  Future<void> deleteUserGrade(String documentID, String companyCode, int level) =>
      _firebaseMethods.deleteUserGrade(documentID, companyCode, level);

  // 등급 권한 유저 갖고오기
  Stream<QuerySnapshot> getGreadeUserDetail(String companyCode, int level) =>
      _firebaseMethods.getGreadeUserDetail(companyCode, level);

  // 권한 - 사용자 추가시 데이터 갖고오기
  Stream<QuerySnapshot> getGreadeUserAdd(String companyCode) =>
      _firebaseMethods.getGreadeUserAdd(companyCode);

  // 권한 - 사용자 삭제 데이터 갖고오기
  Stream<QuerySnapshot> getGreadeUserDelete(String companyCode, int level) =>
      _firebaseMethods.getGreadeUserDelete(companyCode, level);

  // 권한 - 사용자 추가
  Future<void> addGradeUser(String companyCode, List<Map<String,dynamic>> user) =>
      _firebaseMethods.addGradeUser(companyCode, user);

  // 권한 - 사용자 추가
  Future<void> deleteGradeUser(String companyCode, List<Map<String,dynamic>> user) =>
      _firebaseMethods.deleteGradeUser(companyCode, user);
}
