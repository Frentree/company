/*
*
*
* */
//Flutter
import 'package:flutter/material.dart';

import 'package:companyplaylist/repos/login/workScheduleMethod.dart';

class WorkRepository{
   WorkScheduleMethod _workScheduleMethod = WorkScheduleMethod();

   Future<void> workScheduleFirebaseAuth({BuildContext context, String workTitle, String startDate, String endDate, String workContent, String share})
    => _workScheduleMethod.workScheduleFirebaseAuth(context: context, workTitle: workTitle, startDate: startDate, endDate: endDate, workContent: workContent, share: share);
 }