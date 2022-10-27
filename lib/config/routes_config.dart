import 'package:flutter/material.dart';
import 'package:flutter_restaurant_app/data/model/restaurant_detail.dart';
import 'package:flutter_restaurant_app/pages/favorite_page.dart';
import 'package:flutter_restaurant_app/pages/home_page.dart';
import 'package:flutter_restaurant_app/pages/restaurant_detail_page.dart';
import 'package:flutter_restaurant_app/pages/settings_page.dart';

Map<String, WidgetBuilder> routes(BuildContext context) => {
  HomePage.routeName: (context) => const HomePage(),
  RestaurantDetailPage.routeName: (context) =>  RestaurantDetailPage(
    restaurant: ModalRoute.of(context)?.settings.arguments as RestaurantDetail
  ),
  SettingsPage.routeName: (context) => const SettingsPage(),
  FavoritePage.routeName: (context) => const FavoritePage()
};
