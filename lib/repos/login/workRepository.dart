/*
*
*
* */
//Flutter
import 'package:flutter/material.dart';

import 'package:companyplaylist/repos/login/workScheduleMethod.dart';

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
 }