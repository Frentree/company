import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyplaylist/models/expenseModel.dart';
import 'package:companyplaylist/repos/firebaseMethod.dart';

class FirebaseRepository {
  FirebaseMethods _firebaseMethods = FirebaseMethods();

  Future<void> saveExpense(ExpenseModel expenseModel) =>
      _firebaseMethods.saveExpense(expenseModel);

  Future<String> getImageUrl(String email) =>
      _firebaseMethods.getImageUrl(email);

  Stream<QuerySnapshot> getGrade(String companyCode) =>
      _firebaseMethods.getGrade(companyCode);

  Future<void> deleteUser(String documentID, String companyCode, int level) =>
      _firebaseMethods.deleteUser(documentID, companyCode, level);

  Future<void> addGrade(String companyCode, String gradeName, int gradeID) =>
      _firebaseMethods.addGrade(companyCode, gradeName, gradeID);

  Future<void> updateGradeName(String documentID, String gradeName, String companyCode) =>
      _firebaseMethods.updateGradeName(documentID, gradeName, companyCode);

  // 권한 삭제
  Future<void> deleteGrade(String documentID, String companyCode) =>
      _firebaseMethods.deleteGrade(documentID, companyCode);

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
  Future<void> changeGradeUser(String companyCode, List<Map<String,dynamic>> user) =>
      _firebaseMethods.changeGradeUser(companyCode, user);
}