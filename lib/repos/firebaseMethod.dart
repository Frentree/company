//Firebase
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreApi{
  final Firestore _db = Firestore.instance;
  String path;
  String secondPath;
  String documentId;
  CollectionReference ref;

  FirestoreApi.onePath(this.path){
    ref = _db.collection(path);
  }

  FirestoreApi.twoPath(this.path, this.secondPath, this.documentId){
    ref = _db.collection(path).document(documentId).collection(secondPath);
  }

  Future<QuerySnapshot> getDataCollection(){
    return ref.getDocuments();
  }

  Stream<QuerySnapshot> streamDataCollection(){
    return ref.snapshots();
  }

  Future<DocumentSnapshot> getDocumentById(String id){
    return ref.document(id).get();
  }

  Future<void> removeDocument(String id){
    return ref.document(id).delete();
  }

  Future<DocumentReference> addDocument(Map data){
    return ref.add(data);
  }

  Future<void> updateDocument(Map data, String id){
    return ref.document(id).updateData(data);
  }

  Future<void> setDocument(Map data, String id){
    return ref.document(id).setData(data);
  }
}