/*
*
*
*

//Flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyplaylist/models/bigCategoryModel.dart';
import 'package:flutter/material.dart';

import 'package:companyplaylist/repos/work/workScheduleMethod.dart';

class WorkRepository{
   WorkScheduleMethod _workScheduleMethod = WorkScheduleMethod();

   // 내근, 외근 등록
   Future<void> workScheduleFirebaseAuth({
     BuildContext context,
     String createUid,
     String name,
     String workTitle,
     Timestamp startDate,
     Timestamp createDate,
     String workContents,
     List<Map<String,String>> share,
     int progress,
     String location,
     String timeTest,
     String type})
    => _workScheduleMethod.workScheduleFirebaseAuth(
      context: context,
      createUid : createUid,
      name: name,
      workTitle: workTitle,
      workContents: workContents,
      startDate: startDate,
      createDate: createDate,
      share: share,
      progress: progress,
      location: location,
      type: type,
      timeTest: timeTest,
    );

   Future<List<bigCategoryModel>> workCategoryFirebaseAuth({BuildContext context}) => _workScheduleMethod.workCategoryFirebaseAuth();
 }
*/
