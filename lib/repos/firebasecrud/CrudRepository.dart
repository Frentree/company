//Firestore
import 'package:cloud_firestore/cloud_firestore.dart';

//Repos
import 'package:companyplaylist/repos/firebasecrud/userCrudMethod.dart';

//Model
import 'package:companyplaylist/models/userModel.dart';


class CrudRepository {
  UserCrud _userCrud = UserCrud();

  Future<List<User>> fetchUser() => _userCrud.fetchUser();
  Stream<QuerySnapshot> fetchUserAsStream() => _userCrud.fetchUserAsStream();
  Future<User> getUserDataToFirebaseById(String id) => _userCrud.getUserDataToFirebaseByID(id);
  Future<void> removeUserDataToFirebase(String id) => _userCrud.removeUserDataToFirebase(id);
  Future<void> updateUserDataToFirebase(User data, String id) => _userCrud.updateUserDataToFirebase(data, id);
  Future<void> addUserDataToFirebase(User data) => _userCrud.addUserDataToFirebase(data);
}