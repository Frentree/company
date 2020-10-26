//Firestore
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyplaylist/models/bigCategoryModel.dart';
import 'package:companyplaylist/models/noticeCommentModel.dart';
import 'package:companyplaylist/models/noticeModel.dart';
import 'package:companyplaylist/models/workModel.dart';
import 'package:companyplaylist/repos/firebasecrud/companyWorkCrudMethod.dart';
import 'package:companyplaylist/repos/firebasecrud/noticeCommentCrudMethod.dart';
import 'package:companyplaylist/repos/firebasecrud/noticeCrudMethod.dart';

//Repos
import 'package:companyplaylist/repos/firebasecrud/userCrudMethod.dart';
import 'package:companyplaylist/repos/firebasecrud/companyInfoCrudMethod.dart';
import 'package:companyplaylist/repos/firebasecrud/companyUserCrudMethod.dart';
import 'package:companyplaylist/repos/firebasecrud/userAttendanceCrudMethod.dart';

//Model
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/models/companyUserModel.dart';
import 'package:companyplaylist/models/companyModel.dart';
import 'package:companyplaylist/models/attendanceModel.dart';
import 'package:companyplaylist/repos/firebasecrud/workCategoryCrudMethod.dart';



class CrudRepository {
  String companyCode;
  String documentID;

  UserCrud _userCrud = UserCrud();

  CompanyInfoCrud _companyInfoCrud = CompanyInfoCrud();

  CompanyUserCrud _companyUserCrud;

  // Work Crud 2020-09-23, 이윤혁
  CompanyWorkCrud _companyWorkCrud = CompanyWorkCrud("HYOIE13");

  // WorkCategory Crud 2020-09-28, 이윤혁
  WorkCategoryCrud _workCategoryCrud;

  // Notice Crud 2020-09-23, 이윤혁
  NoticeCrud _noticeCrud;

  // Notice Comment 2020-10-21 이윤혁
  NoticeCommentCrud _noticeCommentCrud;

  //
  UserAttendanceCrud _userAttendanceCrud;

  CrudRepository(){}

  CrudRepository.companyUser({this.companyCode}){
    _companyUserCrud = CompanyUserCrud(companyCode);
  }

  // Work Repository 2020-09-23, 이윤혁
  CrudRepository.companyWork({this.companyCode}){
    _companyWorkCrud = CompanyWorkCrud(companyCode);
  }

  // Work Repository 2020-09-28, 이윤혁
  CrudRepository.workCategory({this.companyCode}){
    _workCategoryCrud = WorkCategoryCrud(companyCode);
  }

  //
  CrudRepository.userAttendance({this.companyCode}){
    _userAttendanceCrud = UserAttendanceCrud(companyCode);
  }

  CrudRepository.noticeAttendance({this.companyCode}){
    _noticeCrud = NoticeCrud(companyCode);
  }

  CrudRepository.noticeCommentAttendance({this.companyCode, this.documentID}){
    _noticeCommentCrud = NoticeCommentCrud(companyCode, documentID);
  }

  Future<List<User>> fetchUser() => _userCrud.fetchUser();
  Stream<QuerySnapshot> fetchUserAsStream() => _userCrud.fetchUserAsStream();
  Future<User> getUserDataToFirebaseById({String documentId}) => _userCrud.getUserDataToFirebaseById(documentId: documentId);
  Future<void> removeUserDataToFirebase({String documentId}) => _userCrud.removeUserDataToFirebase(documentId: documentId);
  Future<void> updateUserDataToFirebase({User dataModel, String documentId}) => _userCrud.updateUserDataToFirebase(dataModel: dataModel, documentId: documentId);
  Future<void> setUserDataToFirebase({User dataModel, String documentId}) => _userCrud.setUserDataToFirebase(dataModel: dataModel, documentId: documentId);

  Future<List<Company>> fetchCompanyInfo() => _companyInfoCrud.fetchCompanyInfo();
  Stream<QuerySnapshot> fetchCompanyInfoAsStream() => _companyInfoCrud.fetchCompanyInfoAsStream();
  Future<Company> getCompanyInfoDataToFirebaseById({String documentId}) => _companyInfoCrud.getCompanyInfoDataToFirebaseById(documentId: documentId);
  Future<void> removeCompanyInfoDataToFirebase({String documentId}) => _companyInfoCrud.removeCompanyInfoDataToFirebase(documentId: documentId);
  Future<void> updateCompanyInfoDataToFirebase({Company dataModel, String documentId}) => _companyInfoCrud.updateCompanyInfoDataToFirebase(dataModel: dataModel, documentId: documentId);
  Future<void> setCompanyInfoDataToFirebase({Company dataModel, String documentId}) => _companyInfoCrud.setCompanyInfoDataToFirebase(dataModel: dataModel, documentId: documentId);

  Future<List<CompanyUser>> fetchCompanyUser() => _companyUserCrud.fetchCompanyUser();
  Stream<QuerySnapshot> fetchCompanyUserAsStream() => _companyUserCrud.fetchCompanyUserAsStream();
  Future<CompanyUser> getCompanyUserDataToFirebaseById({String documentId}) => _companyUserCrud.getCompanyUserDataToFirebaseById(documentId: documentId);
  Future<void> removeCompanyUserDataToFirebase({String documentId}) => _companyUserCrud.removeCompanyUserDataToFirebase(documentId: documentId);
  Future<void> updateCompanyUserDataToFirebase({CompanyUser dataModel, String documentId}) => _companyUserCrud.updateCompanyUserDataToFirebase(dataModel: dataModel, documentId: documentId);
  Future<void> setCompanyUserDataToFirebase({CompanyUser dataModel, String documentId}) => _companyUserCrud.setCompanyUserDataToFirebase(dataModel: dataModel, documentId: documentId);

  Future<List<Attendance>> fetchUserAttendance() => _userAttendanceCrud.fetchUserAttendance();
  Stream<QuerySnapshot> fetchUserAttendanceAsStream() => _userAttendanceCrud.fetchUserAttendanceAsStream();
  Future<Attendance> getUserAttendanceDataToFirebaseById({String documentId}) => _userAttendanceCrud.getUserAttendanceDataToFirebaseById(documentId: documentId);
  Future<void> removeUserAttendanceDataToFirebase({String documentId}) => _userAttendanceCrud.removeUserAttendanceDataToFirebase(documentId: documentId);
  Future<void> updateUserAttendanceDataToFirebase({Attendance dataModel, String documentId}) => _userAttendanceCrud.updateUserAttendanceDataToFirebase(dataModel: dataModel, documentId: documentId);
  Future<void> addUserAttendanceDataToFirebase({Attendance dataModel}) => _userAttendanceCrud.addUserAttendanceDataToFirebase(dataModel: dataModel);

  // companyWork Repository 2020-09-23, 이윤혁
  Future<List<CompanyWork>> fetchCompanyWork() => _companyWorkCrud.fetchCompanyWork();
  Stream<QuerySnapshot> fetchCompanyWorkAsStream() => _companyWorkCrud.fetchCompanyWorkAsStream();
  // Future<CompanyUser> getCompanyWorkDataToFirebaseById({String documentId}) => _companyWorkCrud.getCompanyUserDataToFirebaseById(documentId: documentId);
  // Future<void> removeCompanyWorkDataToFirebase({String documentId}) => _companyWorkCrud.removeCompanyUserDataToFirebase(documentId: documentId);
  // Future<void> updateCompanyWorkDataToFirebase({CompanyUser dataModel, String documentId}) => _companyWorkCrud.updateCompanyUserDataToFirebase(dataModel: dataModel, documentId: documentId);
  Future<void> setCompanyWorkDataToFirebase({CompanyWork dataModel, String documentId}) => _companyWorkCrud.setCompanyWorkDataToFirebase(dataModel: dataModel, documentId: documentId);
  Future<void> addCompanyWorkDataToFirebase({CompanyWork dataModel}) => _companyWorkCrud.addCompanyWorkDataToFirebase(dataModel: dataModel);


  // WorkCategory Repository 2020-09-28, 이윤혁
  Future<List<bigCategoryModel>> fetchWorkCategory() => _workCategoryCrud.fetchWorkCategory();
  Stream<QuerySnapshot> fetchWorkCategoryAsStream() => _workCategoryCrud.fetchWorkCategoryAsStream();
  // Future<CompanyUser> getCompanyWorkDataToFirebaseById({String documentId}) => _workCategoryCrud.getWorkCategoryToFirebaseById(documentId: documentId);
  // Future<void> removeCompanyWorkDataToFirebase({String documentId}) => _workCategoryCrud.removeWorkCategoryDataToFirebase(documentId: documentId);
  // Future<void> updateCompanyWorkDataToFirebase({WorkCategory dataModel, String documentId}) => _workCategoryCrud.updateWorkCategoryDataToFirebase(dataModel: dataModel, documentId: documentId);
  Future<void> setWorkCategoryDataToFirebase({bigCategoryModel dataModel, String documentId}) => _workCategoryCrud.setWorkCategoryDataToFirebase(dataModel: dataModel, documentId: documentId);
  Future<void> addWorkCategoryDataToFirebase({bigCategoryModel dataModel}) => _workCategoryCrud.addWorkCategoryDataToFirebase(dataModel: dataModel);


  // Notice Repository 2020-10-13, 이윤혁
  Future<List<NoticeModel>> fetchNotice() => _noticeCrud.fetchNotice();
  Stream<QuerySnapshot> fetchNoticeAsStream() => _noticeCrud.fetchNoticeAsStream();
  Future<NoticeModel> getNoticeDataToFirebaseById({String documentId}) => _noticeCrud.getNoticeDataToFirebaseById(documentId: documentId);
  Future<void> removeNoticeDataToFirebase({String documentId}) => _noticeCrud.removeNoticeDataToFirebase(documentId: documentId);
  Future<void> updateNoticeDataToFirebase({NoticeModel dataModel, String documentId}) => _noticeCrud.updateNoticeDataToFirebase(dataModel: dataModel, documentId: documentId);
  Future<void> setNoticeDataToFirebase({NoticeModel dataModel, String documentId}) => _noticeCrud.setNoticeDataToFirebase(dataModel: dataModel, documentId: documentId);
  Future<void> addNoticeDataToFirebase({NoticeModel dataModel}) => _noticeCrud.addNoticeDataToFirebase(dataModel: dataModel);

  // NoticeComment Repository 2020-10-21, 이윤혁
  Future<List<NoticeCommentModel>> fetchNoticeComment() => _noticeCommentCrud.fetchNoticeComment();
  Stream<QuerySnapshot> fetchNoticeCommentAsStream() => _noticeCommentCrud.fetchNoticeCommentAsStream();
  Future<NoticeCommentModel> getNoticeCommentDataToFirebaseById({String documentId}) => _noticeCommentCrud.getNoticeCommentDataToFirebaseById(documentId: documentId);
  Future<void> removeNoticeCommentDataToFirebase({String documentId}) => _noticeCommentCrud.removeNoticeCommentDataToFirebase(documentId: documentId);
  Future<void> updateNoticeCommentDataToFirebase({NoticeCommentModel dataModel, String documentId}) => _noticeCommentCrud.updateNoticeCommentDataToFirebase(dataModel: dataModel, documentId: documentId);
  Future<void> setNoticeCommentDataToFirebase({NoticeCommentModel dataModel, String documentId}) => _noticeCommentCrud.setNoticeCommentDataToFirebase(dataModel: dataModel, documentId: documentId);
  Future<void> addNoticeCommentDataToFirebase({NoticeCommentModel dataModel}) => _noticeCommentCrud.addNoticeCommentDataToFirebase(dataModel: dataModel);

}