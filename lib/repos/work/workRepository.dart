/*
*
*
* */
//Flutter
import 'package:companyplaylist/models/bigCategoryModel.dart';
import 'package:flutter/material.dart';

import 'package:companyplaylist/repos/work/workScheduleMethod.dart';

class WorkRepository{
   WorkScheduleMethod _workScheduleMethod = WorkScheduleMethod();

   // 내근, 외근 등록
   Future<void> workScheduleFirebaseAuth({BuildContext context, String createUid, String workTitle, String startDate, String endDate, String workContent, List<Map<String,String>> share, String bigCategory, String type})
    => _workScheduleMethod.workScheduleFirebaseAuth(
        createUid : createUid,
        context: context,
        workTitle: workTitle,
        startDate: startDate,
        endDate: endDate,
        workContent: workContent,
        share: share,
        type: type,
        bigCategory: bigCategory
    );

   Future<List<WorkCategory>> workCategoryFirebaseAuth({BuildContext context}) => _workScheduleMethod.workCategoryFirebaseAuth();
 }