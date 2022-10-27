import 'package:flutter_restaurant_app/data/database/local_database.dart';
import 'package:flutter_restaurant_app/data/service/restaurant_service.dart';
import 'package:flutter_restaurant_app/helper/settings_service.dart';
import 'package:flutter_restaurant_app/provider/favorite_provider.dart';
import 'package:flutter_restaurant_app/provider/restaurant_provider.dart';
import 'package:flutter_restaurant_app/provider/schedule_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:http/http.dart' as http;

List<SingleChildWidget> providers = [
  ChangeNotifierProvider<RestaurantProvider>(
    create: (context) => RestaurantProvider(
      service: RestaurantService(
        client: http.Client()
      )
    )
  ),
  ChangeNotifierProvider<FavoriteProvider>(
    create: (context) => FavoriteProvider(
      database: LocalDatabase()
    )
  ),
  ChangeNotifierProvider<ScheduleProvider>(
    create: (context) => ScheduleProvider(
      settingService: SettingService()
    )
  )
];