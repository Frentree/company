import 'package:flutter/material.dart';

import 'package:companyplaylist/locator.dart';
import 'package:companyplaylist/DataModel/API_model.dart';
import 'package:companyplaylist/datamodel2/userInfoModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfoCRUD extends ChangeNotifier{
  Api _api = userInfoLocator<Api>();

  List<UserInfo> userInfo;

  Future<List<UserInfo>> fetchUserInfo() async{
    var result = await _api.getDataCollection();

    userInfo = result.documents.map((doc) => UserInfo.fromMap(doc.data, doc.documentID)).toList();

    return userInfo;
  }

  Stream<QuerySnapshot> fetchUserInfoAsStream(){
    return _api.streamDataCollection();
  }

  Future<UserInfo> getUserInfoById(String id) async{
    var doc = await _api.getDocumentById(id);
    return UserInfo.fromMap(doc.data, doc.documentID);
  }

  Future removeUserInfo(String id) async{
    await _api.removeDocument(id);
    return null;
  }

  Future updateUserInfo(UserInfo data, String id) async{
    await _api.updateDocument(data.toJon(), id);
    return null;
  }

  Future addUserInfo(UserInfo data) async{
    var result = await _api.addDocument(data.toJon());
    return null;
  }
}