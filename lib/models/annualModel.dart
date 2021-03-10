/*
연차 모델

작성자 이름 이윤혁
작성자 이메일
컬렉션 이름 company/<companyCode>/annual
읽음여부
*/

import 'package:cloud_firestore/cloud_firestore.dart';

class AnnualModel {
  String mail;
  String name;
  num maxAnnual;
  num useAnnual;
  String year;
  DocumentReference reference;

  AnnualModel({
    this.mail,
    this.name,
    this.maxAnnual,
    this.useAnnual,
    this.year,
  });

  AnnualModel.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['mail'] != null),
        assert(map['name'] != null),
        assert(map['maxAnnual'] != null),
        assert(map['useAnnual'] != null),
        assert(map['year'] != null),
        mail = map['mail'],
        name = map['name'],
        maxAnnual = map['maxAnnual'],
        useAnnual = map['useAnnual'],
        year = map['year'];

  AnnualModel.fromSnapshow(DocumentSnapshot snapshot) : this.fromMap(snapshot.data(), reference: snapshot.reference);

  toJson() {
    return {
      "mail": mail,
      "name": name,
      "maxAnnual": maxAnnual,
      "useAnnual": useAnnual,
      "year": year,
    };
  }
}
