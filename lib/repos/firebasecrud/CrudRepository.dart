//Firestore
import 'package:cloud_firestore/cloud_firestore.dart';

//Repos
import 'package:companyplaylist/repos/firebasecrud/userCrudMethod.dart';
import 'package:companyplaylist/repos/firebasecrud/companyInfoCrudMethod.dart';
import 'package:companyplaylist/repos/firebasecrud/companyUserCrudMethod.dart';

//Model
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/models/companyModel.dart';



class CrudRepository {
  String companyCode;

  UserCrud _userCrud = UserCrud();
  CompanyInfoCrud _companyInfoCrud = CompanyInfoCrud();
  CompanyUserCrud _companyUserCrud;

  CrudRepository(){}
  CrudRepository.companyUser(this.companyCode){
    _companyUserCrud = CompanyUserCrud(companyCode);
  }

  Future<List<User>> fetchUser() => _userCrud.fetchUser();
  Stream<QuerySnapshot> fetchUserAsStream() => _userCrud.fetchUserAsStream();
  Future<User> getUserDataToFirebaseById(String id) => _userCrud.getUserDataToFirebaseById(id);
  Future<void> removeUserDataToFirebase(String id) => _userCrud.removeUserDataToFirebase(id);
  Future<void> updateUserDataToFirebase(User data, String id) => _userCrud.updateUserDataToFirebase(data, id);
  Future<void> addUserDataToFirebase(User data) => _userCrud.addUserDataToFirebase(data);
  Future<void> setUserDataToFirebase(User data, String id) => _userCrud.setUserDataToFirebase(data, id);

  Future<List<Company>> fetchCompanyInfo() => _companyInfoCrud.fetchCompanyInfo();
  Stream<QuerySnapshot> fetchCompanyInfoAsStream() => _companyInfoCrud.fetchCompanyInfoAsStream();
  Future<Company> getCompanyInfoDataToFirebaseById(String id) => _companyInfoCrud.getCompanyInfoDataToFirebaseById(id);
  Future<void> removeCompanyInfoDataToFirebase(String id) => _companyInfoCrud.removeCompanyInfoDataToFirebase(id);
  Future<void> updateCompanyInfoDataToFirebase(Company data, String id) => _companyInfoCrud.updateCompanyInfoDataToFirebase(data, id);
  Future<void> addCompanyInfoDataToFirebase(Company data) => _companyInfoCrud.addCompanyInfoDataToFirebase(data);
  Future<void> setCompanyInfoDataToFirebase(Company data, String id) => _companyInfoCrud.setCompanyInfoDataToFirebase(data, id);

  Future<List<User>> fetchCompanyUser() => _companyUserCrud.fetchCompanyUser();
  Stream<QuerySnapshot> fetchCompanyUserAsStream() => _companyUserCrud.fetchCompanyUserAsStream();
  Future<User> getCompanyUserDataToFirebaseById(String id) => _companyUserCrud.getCompanyUserDataToFirebaseById(id);
  Future<void> removeCompanyUserDataToFirebase(String id) => _companyUserCrud.removeCompanyUserDataToFirebase(id);
  Future<void> updateCompanyUserDataToFirebase(User data, String id) => _companyUserCrud.updateCompanyUserDataToFirebase(data, id);
  Future<void> addCompanyUserDataToFirebase(User data) => _companyUserCrud.addCompanyUserDataToFirebase(data);
}