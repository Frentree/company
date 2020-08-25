import 'dart:async';
import 'package:flutter/material.dart';

import 'package:companyplaylist/locator.dart';
import 'package:companyplaylist/DataModel/API_model.dart';
import 'package:companyplaylist/DataModel/work_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CRUDModel extends ChangeNotifier {
  Api _api = locator<Api>();

  List<Work> work;

  Future<List<Work>> fetchWork() async{
    var result = await _api.getDataCollection();
    work = result.documents.map((doc) => Work.fromMap(doc.data, doc.documentID)).toList();

    return work;
  }

  Stream<QuerySnapshot> fetchWorkAsStream(){
    print(_api);
    return _api.streamDataCollection();
  }

  Future<Work> getWorkById(String id) async{
    var doc = await _api.getDocumentById(id);
    return Work.fromMap(doc.data, doc.documentID);
  }

  Future removeWork(String id) async{
    await _api.removeDocument(id);
    return null;
  }

  Future updateWork(Work data, String id) async{
    await _api.updateDocument(data.toJson(), id);
    return null;
  }

  Future addWork(Work data) async{
    var result = await _api.addDocument(data.toJson());
    return null;
  }
}
