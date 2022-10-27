import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant_app/helper/background_service.dart';
import 'package:flutter_restaurant_app/helper/date_time_helper.dart';
import 'package:flutter_restaurant_app/helper/settings_service.dart';

class ScheduleProvider with ChangeNotifier{
  late final SettingService _settingService;
  bool _isScheduled = false;
  bool get isScheduled => _isScheduled;

  ScheduleProvider({ required SettingService settingService}){
    _settingService = settingService;
    initializationStatus();
  }

  void initializationStatus() async{
    _isScheduled = await _settingService.getScheduleStatus();
    notifyListeners();
  }

  Future<bool> setScheduledStatus(bool value) async{
    _isScheduled = await _settingService.setStatusSchedule(value);
    notifyListeners();
    if(_isScheduled){
      return await AndroidAlarmManager.periodic(
          const Duration(hours: 24),
          1,
          BackgroundService.callback,
          startAt: DateTimeHelper.format(),
          exact: true,
          wakeup: true,
      );
    }else{
      return await AndroidAlarmManager.cancel(1);
    }
  }
}