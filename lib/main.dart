import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant_app/config/colors_config.dart';
import 'package:flutter_restaurant_app/config/routes_config.dart';
import 'package:flutter_restaurant_app/config/text_themes_config.dart';
import 'package:flutter_restaurant_app/pages/home_page.dart';
import 'package:flutter_restaurant_app/widgets/platform_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
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
      initialRoute: HomePage.routeName,
      routes: routes(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoApp(
      theme: const CupertinoThemeData(primaryColor: primaryColor),
      initialRoute: HomePage.routeName,
      routes: routes(context),
    );
  }
}
