import 'package:MyCompany/models/alarmModel.dart';
import 'package:MyCompany/models/inquireModel.dart';
import 'package:MyCompany/models/workApprovalModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MyCompany/models/approvalModel.dart';
import 'package:MyCompany/models/attendanceModel.dart';
import 'package:MyCompany/models/commentListModel.dart';
import 'package:MyCompany/models/commentModel.dart';
import 'package:MyCompany/models/companyModel.dart';
import 'package:MyCompany/models/companyUserModel.dart';
import 'package:MyCompany/models/expenseModel.dart';
import 'package:MyCompany/models/meetingModel.dart';
import 'package:MyCompany/models/noticeModel.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/models/workModel.dart';
import 'package:MyCompany/repos/firebaseMethod.dart';

class FirebaseRepository {
  FirebaseMethods _firebaseMethods = FirebaseMethods();

  // 경비 청구 항목 저장 메서드
  Future<void> saveExpense(ExpenseModel expenseModel) =>
      _firebaseMethods.saveExpense(expenseModel);

  // 경비 청구 항목 수정 메서드
  Future<void> updateExpense(ExpenseModel expenseModel, String companyCode, String docId) =>
      _firebaseMethods.updateExpense(expenseModel, companyCode, docId);

  // 경비 항목 조회 메서드
  Stream<QuerySnapshot> getExpense(String companyCode, String uid, DateTime thisMonth) =>
      _firebaseMethods.getExpense(companyCode, uid, thisMonth);

  // 경비 항목 삭제 메서드
  Future<void> deleteExpense(String companyCode, String documentID, String uid) =>
      _firebaseMethods.deleteExpense(companyCode, documentID, uid);

  // 경비 결재 완료 후 프로세스
  Future<void> postProcessApprovedExpense(User user, WorkApproval model, int type) =>
      _firebaseMethods.postProcessApprovedExpense(user, model, type);

  // 결재자 경비 항목 조회 메서드
  Future<List<ExpenseModel>> getExpenses(WorkApproval model, String companyCode) =>
      _firebaseMethods.getExpenses(model, companyCode);

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

  Future<void> deleteCompanyUser(
          {String companyCode, CompanyUser companyUserModel}) =>
      _firebaseMethods.deleteCompanyUser(
          companyCode: companyCode, companyUserModel: companyUserModel);

  /*Future<List<DocumentSnapshot>> getCompany({String companyName}) =>
      _firebaseMethods.getCompany(
        companyName: companyName,
      );*/

  Future<List<DocumentSnapshot>> getCompany() =>
      _firebaseMethods.getCompany();

  Future<List<DocumentSnapshot>> searchCompanyUser(
          {String companyUserName, String companyCode, String loginUserMail}) =>
      _firebaseMethods.searchCompanyUser(
        companyCode: companyCode,
        companyUserName: companyUserName,
        loginUserMail: loginUserMail,
      );

  Future<void> saveCompanyUser({CompanyUser companyUserModel}) =>
      _firebaseMethods.saveCompanyUser(companyUserModel: companyUserModel);

  Future<void> saveAlarm({Alarm alarmModel, String companyCode, String mail}) => _firebaseMethods.saveAlarm(
    alarmModel: alarmModel,
    companyCode: companyCode,
    mail: mail
  );

  Future<void> saveOneUserAlarm({Alarm alarmModel, String companyCode, String mail}) => _firebaseMethods.saveOneUserAlarm(
    alarmModel: alarmModel,
    companyCode: companyCode,
    mail: mail
  );

  Future<void> saveAttendeesUserAlarm({Alarm alarmModel, String companyCode, List<String> mail}) => _firebaseMethods.saveAttendeesUserAlarm(
    alarmModel: alarmModel,
    companyCode: companyCode,
    mail: mail,
  );

  Future<void> deleteAlarm({String companyCode, String mail, String documentID}) => _firebaseMethods.deleteAlarm(
    companyCode: companyCode,
    mail: mail,
    documentID: documentID,
  );

  Future<void> updateReadAlarm({String companyCode, String mail, String alarmId}) => _firebaseMethods.updateReadAlarm(
    companyCode: companyCode,
    mail: mail,
    alarmId: alarmId,
  );

  Stream<QuerySnapshot> getNoReadAlarm({String companyCode, String mail}) => _firebaseMethods.getNoReadAlarm(
    companyCode: companyCode,
    mail: mail,
  );

  Stream<QuerySnapshot> getAllAlarm({String companyCode, String mail}) => _firebaseMethods.getAllAlarm(
    companyCode: companyCode,
    mail: mail,
  );

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

  Stream<QuerySnapshot> getNowOutCompanyWork({String companyCode, String userMail}) => _firebaseMethods.getNowOutCompanyWork(companyCode: companyCode, userMail: userMail);

  Future<List<WorkModel>> getWorkForAlarm({String companyCode, String userMail}) => _firebaseMethods.getWorkForAlarm(companyCode: companyCode, userMail: userMail);



  Future<Map<DateTime, List<CompanyUser>>> getBirthday({String companyCode}) => _firebaseMethods.getBirthday(companyCode: companyCode);

  Future<Map<String, String>> getColleague(
          {String loginUserMail, String companyCode}) =>
      _firebaseMethods.getColleague(
          loginUserMail: loginUserMail, companyCode: companyCode);

  Future<CompanyUser> getMyCompanyInfo({String companyCode, String myMail}) => _firebaseMethods.getMyCompanyInfo(companyCode: companyCode, myMail: myMail);

  Stream<QuerySnapshot> getColleagueInfo(
          {String companyCode}) =>
      _firebaseMethods.getColleagueInfo(companyCode: companyCode);

  Future<DocumentReference> saveAttendance(
          {Attendance attendanceModel, String companyCode}) =>
      _firebaseMethods.saveAttendance(
        attendanceModel: attendanceModel,
        companyCode: companyCode,
      );

  Future<void> deleteAttendance({String companyCode, String documentId}) => _firebaseMethods.deleteAttendance(
    companyCode: companyCode,
    documentId: documentId,
  );

  Future<QuerySnapshot> getMyTodayAttendance(
          {String companyCode, String loginUserMail, Timestamp today}) =>
      _firebaseMethods.getMyTodayAttendance(
        companyCode: companyCode,
        loginUserMail: loginUserMail,
        today: today,
      );

  Stream<QuerySnapshot> getColleagueNowAttendance(
          {String companyCode, String loginUserMail, Timestamp today}) =>
      _firebaseMethods.getColleagueNowAttendance(
        companyCode: companyCode,
        loginUserMail: loginUserMail,
        today: today,
      );

  Stream<QuerySnapshot> getMyAttendance({String companyCode, String loginUserMail, DateTime thisMonth}) => _firebaseMethods.getMyAttendance(
    companyCode: companyCode,
    loginUserMail: loginUserMail,
    thisMonth: thisMonth,
  );

  Stream<QuerySnapshot> getAllAttendance({String companyCode, DateTime thisMonth}) => _firebaseMethods.getAllAttendance(
    companyCode: companyCode,
    thisMonth: thisMonth,
  );

  Future<void> updateAttendance(
          {Attendance attendanceModel,
          String documentId,
          String companyCode}) =>
      _firebaseMethods.updateAttendance(
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

  Stream<DocumentSnapshot> getCompanyInfos({String companyCode}) =>
      _firebaseMethods.getCompanyInfos(companyCode);

  Future<void> updateApproval({Approval approvalModel, String companyCode}) =>
      _firebaseMethods.updateApproval(
        approvalModel: approvalModel,
        companyCode: companyCode,
      );

  Future<void> updateCompany(
          {String companyCode,
          String companyName,
          String companyNo,
          String companyAddr,
          String companyPhone,
          String companyWeb,
          String url}) =>
      _firebaseMethods.updateCompany(companyCode, companyName, companyNo,
          companyAddr, companyPhone, companyWeb, url);

  // 프로필 이미지 갖고오기
  Future<DocumentSnapshot> photoProfile(String companyCode, String mail) =>
      _firebaseMethods.photoProfile(companyCode, mail);

  // 프로필 이미지 변경
  Future<void> updatePhotoProfile(
          {String companyCode, String mail, String url}) =>
      _firebaseMethods.updatePhotoProfile(companyCode, mail, url);

  //WIFI 리스트 가져오기
  Future<List<DocumentSnapshot>> getWifiList({String companyCode}) => _firebaseMethods.getWifiList(
    companyCode: companyCode
  );

  Future<List<String>> getWifiName({String companyCode}) => _firebaseMethods.getWifiName(
      companyCode: companyCode
  );

  Future<void> addWifiList({List<String> wifiList, User loginUser}) => _firebaseMethods.addWifiList(
    wifiList: wifiList,
    loginUser: loginUser,
  );

  Future<void> deleteWifiList({String companyCode, List<String> documentID}) => _firebaseMethods.deleteWifiList(
    companyCode: companyCode,
    documentID: documentID,
  );


  //FCM 토큰 업데이트
  Future<void> updateToken({String companyCode, String mail, String token}) => _firebaseMethods.updateToken(
    companyCode: companyCode,
    mail: mail,
    token: token,
  );

  //FCM 토큰 가져오기
  Future<List<String>> getTokens({String companyCode, String mail}) => _firebaseMethods.getTokens(
    companyCode: companyCode,
    mail: mail
  );

  Future<List<String>> getAttendeesTokens({String companyCode, List<String> mail}) => _firebaseMethods.getAttendeesTokens(
    companyCode: companyCode,
    mail: mail,
  );

  Future<List<String>> getApprovalUserTokens({String companyCode, String mail}) => _firebaseMethods.getApprovalUserTokens(
      companyCode: companyCode,
      mail: mail
  );

  // 프로필 핸드폰번호 변경
  Future<void> updatePhone({String companyCode, String mail, String phone}) =>
      _firebaseMethods.updatePhone(companyCode, mail, phone);

  Stream<QuerySnapshot> getGrade(String companyCode) =>
      _firebaseMethods.getGrade(companyCode);

  Stream<QuerySnapshot> getGradeUser({String companyCode, int level}) =>
      _firebaseMethods.getGradeUser(companyCode, level);

  Future<void> userGrade(String companyCode, String mail) =>
      _firebaseMethods.userGrade(companyCode, mail);

  Future<void> deleteUser(String documentID, String companyCode, int level) =>
      _firebaseMethods.deleteUser(documentID, companyCode, level);

  Future<void> addGrade(String companyCode, String gradeName, int gradeID) =>
      _firebaseMethods.addGrade(companyCode, gradeName, gradeID);

  Future<void> updateGradeName(
          String documentID, String gradeName, String companyCode) =>
      _firebaseMethods.updateGradeName(documentID, gradeName, companyCode);

  // 권한 삭제
  Future<void> deleteGrade(String documentID, String companyCode) =>
      _firebaseMethods.deleteGrade(documentID, companyCode);

  // 권한 삭제시 유저 권한 없애기
  Future<void> deleteUserGrade(
          String documentID, String companyCode, int level) =>
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
  Future<void> addGradeUser(
          String companyCode, List<Map<String, dynamic>> user) =>
      _firebaseMethods.addGradeUser(companyCode, user);

  // 권한 - 사용자 추가
  Future<void> deleteGradeUser(
          String companyCode, List<Map<String, dynamic>> user) =>
      _firebaseMethods.deleteGradeUser(companyCode, user);

  // 공지사항 - 추가
  Future<void> addNotice({String companyCode, NoticeModel notice}) =>
      _firebaseMethods.addNotice(companyCode, notice);

  // 공지사항 - 삭제
  Future<void> deleteNotice({String companyCode, String documentID}) =>
      _firebaseMethods.deleteNotice(companyCode, documentID);

  //공지사항 불러오기
  Stream<QuerySnapshot> getNoticeList({String companyCode}) =>
      _firebaseMethods.getNoticeList(companyCode);

  // 공지사항 - 댓글
  Stream<QuerySnapshot> getNoticeCommentList(
          {String companyCode, String documentID}) =>
      _firebaseMethods.getNoticeCommentList(companyCode, documentID);

  // 공지사항 - 대댓글
  Stream<QuerySnapshot> getNoticeCommentsList(
          {String companyCode,
          String noticeDocumentID,
          String commntDocumentID}) =>
      _firebaseMethods.getNoticeCommentsList(
          companyCode, noticeDocumentID, commntDocumentID);

  // 공지사항 - 댓글 추가
  Future<void> addNoticeComment(
          {String companyCode,
          String noticeDocumentID,
          CommentModel comment}) =>
      _firebaseMethods.addNoticeComment(companyCode, noticeDocumentID, comment);

  // 공지사항 - 댓글 수정
  Future<void> updateNoticeComment(
          {String companyCode,
          String noticeDocumentID,
          String commntDocumentID,
          String comment}) =>
      _firebaseMethods.updateNoticeComment(
          companyCode, noticeDocumentID, commntDocumentID, comment);

  // 공지사항 - 댓글 삭제
  Future<void> deleteNoticeComment(
          {String companyCode,
          String noticeDocumentID,
          String commntDocumentID}) =>
      _firebaseMethods.deleteNoticeComment(
          companyCode, noticeDocumentID, commntDocumentID);

  // 공지사항 - 대댓글 추가
  Future<void> addNoticeComments(
          {String companyCode,
          String noticeDocumentID,
          String commntDocumentID,
          CommentListModel comment}) =>
      _firebaseMethods.addNoticeComments(
          companyCode, noticeDocumentID, commntDocumentID, comment);

  // 공지사항 - 대댓글 수정
  Future<void> updateNoticeComments(
          {String companyCode,
          String noticeDocumentID,
          String commntDocumentID,
          String commntsDocumentID,
          String comment}) =>
      _firebaseMethods.updateNoticeComments(companyCode, noticeDocumentID,
          commntDocumentID, commntsDocumentID, comment);

  // 공지사항 - 대댓글 삭제
  Future<void> deleteNoticeComments(
          {String companyCode,
          String noticeDocumentID,
          String commntDocumentID,
          String commntsDocumentID}) =>
      _firebaseMethods.deleteNoticeComments(
          companyCode, noticeDocumentID, commntDocumentID, commntsDocumentID);

  // 팀추가
  Future<void> addOrganizationChart({String companyCode, String teamName}) =>
      _firebaseMethods.addOrganizationChart(companyCode, teamName);

  // 팀명 수정
  Future<void> modifyOrganizationChartName(
          {String companyCode, String teamName, String documentID}) =>
      _firebaseMethods.modifyOrganizationChartName(
          companyCode, teamName, documentID);

  //팀 불러오기
  Stream<QuerySnapshot> getTeamList({String companyCode}) =>
      _firebaseMethods.getTeamList(companyCode);

  //팀 유저 불러오기
  Stream<QuerySnapshot> getUserTeam({String companyCode, String teamName}) =>
      _firebaseMethods.getUserTeam(companyCode, teamName);

  //팀 삭제
  Future<void> deleteUserOrganizationChart(
          {String documentID, String companyCode, String teamName}) async =>
      _firebaseMethods.deleteUserOrganizationChart(
          documentID, companyCode, teamName);

  // 팀 - 사용자 추가
  Future<void> addTeamUser(
          {String companyCode, List<Map<String, dynamic>> user}) =>
      _firebaseMethods.addTeamUser(companyCode, user);

  // 팀 - 사용자 삭제 데이터 갖고오기
  Stream<QuerySnapshot> getTeamUserDelete(
          String companyCode, String teamName) =>
      _firebaseMethods.getTeamUserDelete(companyCode, teamName);

  // 직급추가
  Future<void> addPosition({String companyCode, String position}) =>
      _firebaseMethods.addPosition(companyCode, position);

  // 직급명 수정
  Future<void> modifyPositionName(
          {String companyCode, String position, String documentID}) =>
      _firebaseMethods.modifyPositionName(companyCode, position, documentID);

  //직급 불러오기
  Stream<QuerySnapshot> getPositionList({String companyCode}) =>
      _firebaseMethods.getPositionList(companyCode);

  //직급 유저 불러오기
  Stream<QuerySnapshot> getUserPosition(
          {String companyCode, String position}) =>
      _firebaseMethods.getUserPosition(companyCode, position);

  //직급 삭제
  Future<void> deleteUserPosition(
          {String documentID, String companyCode, String position}) async =>
      _firebaseMethods.deleteUserPosition(documentID, companyCode, position);

  // 직급 - 사용자 추가
  Future<void> addPositionUser(
          {String companyCode, List<Map<String, dynamic>> user}) =>
      _firebaseMethods.addPositionUser(companyCode, user);

  // 직급 - 사용자 삭제 데이터 갖고오기
  Stream<QuerySnapshot> getPositionUserDelete(
          String companyCode, String position) =>
      _firebaseMethods.getPositionUserDelete(companyCode, position);

  // 계정삭제
  Future<void> deleteAccount({String companyCode, String mail}) =>
      _firebaseMethods.deleteAccount(companyCode, mail);

  // 회사가입된 유저 정보 갖고오기
  Future<CompanyUser> getComapnyUser({String companyCode, String mail}) =>
      _firebaseMethods.getComapnyUser(companyCode, mail);

  // 최근일정 갖고오기
  Stream<QuerySnapshot> getCopyMyShedule({String companyCode, String mail, int count}) =>
      _firebaseMethods.getCopyMyShedule(companyCode, mail, count);

  Future<void> createAnnualLeave({String companyCode, WorkApproval workApproval}) =>
      _firebaseMethods.createAnnualLeave(companyCode, workApproval);

  Stream<QuerySnapshot> requestAnnualLeave({String companyCode, String whereUser, String mail, String orderByType, bool isOrderBy}) =>
      _firebaseMethods.requestAnnualLeave(companyCode, whereUser, mail, orderByType, isOrderBy);

  Stream<QuerySnapshot> getRequestUser({String companyCode, String mail}) =>
      _firebaseMethods.getRequestUser(companyCode, mail);

  Stream<QuerySnapshot> selectAnnualLeave({String companyCode, String whereUser, String mail, String orderByType, bool isOrderBy, String date}) =>
      _firebaseMethods.selectAnnualLeave(companyCode, whereUser, mail, orderByType, isOrderBy, date);

  Stream<QuerySnapshot> getQnA({String mail}) =>
      _firebaseMethods.getQnA(mail) ;

  Future<void> createQnA({InquireModel model}) =>
      _firebaseMethods.createQnA(model);

  Stream<QuerySnapshot> getQnAAdmin() =>
      _firebaseMethods.getQnAAdmin() ;

  Future<void> senderQnAReset({String mail}) =>
      _firebaseMethods.senderQnAReset(mail);
}
