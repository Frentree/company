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
   Future<void> workScheduleFirebaseAuth({BuildContext context, String workTitle, String startDate, String endDate, String workContent, String share, String bigCategory, String type})
    => _workScheduleMethod.workScheduleFirebaseAuth(
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