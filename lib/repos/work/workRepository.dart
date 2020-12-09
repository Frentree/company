/*
//Flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MyCompany/models/bigCategoryModel.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:MyCompany/repos/work/workScheduleMethod.dart';

class WorkRepository{
  WorkScheduleMethod _workScheduleMethod = WorkScheduleMethod();

  // 내근, 외근 등록
  Future<void> workScheduleFirebaseAuth({
    BuildContext context,
    String workTitle,
    Timestamp startDate,
    Timestamp startTime,
    Timestamp createDate,
    String workContents,
    List<Map<String,String>> share,
    int progress,
    String location,
    String timeTest,
    String type,
    User user,
  })
  => _workScheduleMethod.workScheduleFirebaseAuth(
    context: context,
    workTitle: workTitle,
    workContents: workContents,
    startDate: startDate,
    startTime: startTime,
    createDate: createDate,
    share: share,
    progress: progress,
    location: location,
    type: type,
    timeTest: timeTest,
    user : user,
  );

  Future<List<bigCategoryModel>> workCategoryFirebaseAuth({BuildContext context}) => _workScheduleMethod.workCategoryFirebaseAuth();
}
*/
