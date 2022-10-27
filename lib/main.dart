import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_restaurant_app/config/colors_config.dart';
import 'package:flutter_restaurant_app/config/providers.dart';
import 'package:flutter_restaurant_app/config/routes_config.dart';
import 'package:flutter_restaurant_app/config/text_themes_config.dart';
import 'package:flutter_restaurant_app/helper/background_service.dart';
import 'package:flutter_restaurant_app/helper/navigation_helper.dart';
import 'package:flutter_restaurant_app/helper/notification_helper.dart';
import 'package:flutter_restaurant_app/pages/home_page.dart';
import 'package:flutter_restaurant_app/pages/restaurant_detail_page.dart';
import 'package:flutter_restaurant_app/widgets/platform_widget.dart';
import 'package:provider/provider.dart';

final FlutterLocalNotificationsPlugin localNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper _notificationService = NotificationHelper();
  final BackgroundService _reminderService = BackgroundService();

  _reminderService.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }

  await _notificationService.initNotifications(localNotificationsPlugin);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final NotificationHelper _notification = NotificationHelper();

  @override
  void initState() {
    super.initState();
    _notification
        .configureSelectNotificationSubject(RestaurantDetailPage.routeName);
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: PlatformWidget(
        androidBuilder: _buildAndroid,
        iosBuilder: _buildIos,
      ),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      theme: ThemeData(
        primaryColor: primaryColor,
        appBarTheme: AppBarTheme(
            elevation: 0,
            color: primaryColor,
            titleTextStyle: Theme.of(context).textTheme.headline6?.copyWith(
                  color: Colors.white,
                )),
        textTheme: textTheme,
      ),
      navigatorKey: navigatorKey,
      initialRoute: HomePage.routeName,
      routes: routes(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoApp(
      theme: const CupertinoThemeData(primaryColor: primaryColor),
      initialRoute: HomePage.routeName,
      navigatorKey: navigatorKey,
      routes: routes(context),
    );
  }
}
