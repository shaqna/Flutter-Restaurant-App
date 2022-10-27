import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_restaurant_app/data/model/restaurant_detail.dart';
import 'package:flutter_restaurant_app/helper/navigation_helper.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:developer' as developer;

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper? _instance;

  NotificationHelper._getInstance() {
    _instance = this;
  }

  factory NotificationHelper() =>
      _instance ?? NotificationHelper._getInstance();

  Future<void> initNotifications(FlutterLocalNotificationsPlugin plugin) async {
    var initializationSettingAndroid =
        const AndroidInitializationSettings('app_icon');

    var initializationSettingIos = const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    var initializationSettings = InitializationSettings(
      android: initializationSettingAndroid,
      iOS: initializationSettingIos,
    );

    await plugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse details) async {
      final payload = details.payload;
      if (payload != null) {
        developer.log('notification payload: ' + payload, name: 'my.notification.helper');
      }
      selectNotificationSubject.add(payload ?? 'empty payload');
    });
  }

  Future<void> showNotification(FlutterLocalNotificationsPlugin plugin,
      RestaurantDetail restaurant) async {
    var channelId = "1";
    var channelName = "channel_$channelId";
    var channelDescription = 'daily restaurant channel';

    var iosPlatformChannelSpecifics = const DarwinNotificationDetails();
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        channelId, channelName,
        channelDescription: channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: const DefaultStyleInformation(true, true));

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );

    await plugin.show(0, restaurant.restaurant.name,
        "rekomendasi restoran untukmu!", platformChannelSpecifics,
        payload: jsonEncode(restaurant.toJson()));
  }

  void configureSelectNotificationSubject(String route) {
    selectNotificationSubject.stream.listen((String payload) async {
      var restaurant = RestaurantDetail.fromJson(jsonDecode(payload));
      NavigationHelper.intentWithData(route, restaurant);
    });
  }
}
