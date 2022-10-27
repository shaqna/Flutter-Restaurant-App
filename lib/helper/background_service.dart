import 'dart:isolate';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter_restaurant_app/data/model/restaurant.dart';
import 'package:flutter_restaurant_app/data/model/restaurant_detail.dart';
import 'package:flutter_restaurant_app/data/service/restaurant_service.dart';
import 'package:flutter_restaurant_app/helper/notification_helper.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_restaurant_app/main.dart';

final ReceivePort port = ReceivePort();

class BackgroundService{
  static BackgroundService? _instance;
  static const String _isolateName = 'isolate';
  static SendPort? _uiSendPort;

  BackgroundService._internal(){
    _instance = this;
  }

  factory BackgroundService() => _instance ?? BackgroundService._internal();

  void initializeIsolate(){
    IsolateNameServer.registerPortWithName(port.sendPort, _isolateName);
  }

  static Future<void> callback() async{
    final NotificationHelper notificationService = NotificationHelper();
    List<Restaurant> res = await RestaurantService(
      client: http.Client()
    ).getRestaurants();

    Restaurant randomRestaurant = (res..shuffle()).first;

    RestaurantDetail restaurant = await RestaurantService(
      client: http.Client()
    ).getRestaurantById(randomRestaurant.id);

    await notificationService.showNotification(
        localNotificationsPlugin,
        restaurant
    );

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }
}