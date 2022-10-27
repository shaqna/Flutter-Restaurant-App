import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant_app/data/model/restaurant.dart';
import 'package:flutter_restaurant_app/data/model/restaurant_detail.dart';
import 'package:flutter_restaurant_app/data/service/restaurant_service.dart';
import 'package:flutter_restaurant_app/pages/restaurant_detail_page.dart';
import 'package:flutter_restaurant_app/provider/favorite_provider.dart';
import 'package:flutter_restaurant_app/provider/restaurant_provider.dart';
import 'package:flutter_restaurant_app/utils/const_object.dart';
import 'package:flutter_restaurant_app/utils/state_ui.dart';
import 'package:flutter_restaurant_app/widgets/platform_widget.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class FavoritePage extends StatelessWidget {
  static const routeName = '/favorite-page';
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
          "Restoran favorit",
          style: Theme.of(context)
              .textTheme
              .subtitle1
              ?.copyWith(color: Colors.white),
        )),
        body: _buildContent(context));
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(
            "Restoran favorit",
            style: Theme.of(context)
                .textTheme
                .subtitle1
                ?.copyWith(color: Colors.white),
          ),
          transitionBetweenRoutes: false,
        ),
        child: _buildContent(context));
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, right: 6),
      child: Expanded(child: _listBuilder()),
    );
  }

  Widget _listBuilder() {
    return Consumer<FavoriteProvider>(
      builder: (context, provider, _) {
        switch (provider.state) {
          case StateFavorite.hasData:
            return ListView.builder(
              itemCount: provider.restaurant.length,
              itemBuilder: (context, index) {
                return _buildRestaurantItem(
                    context, provider.restaurant[index]);
              },
            );
          case StateFavorite.empty:
            return Center(
              child: Text(provider.message),
            );
        }
      },
    );
  }

  Widget _buildRestaurantItem(BuildContext context, Restaurant restaurant) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      leading: Image.network(
        mediumResolutionPictureUrl + restaurant.pictureId,
        width: 100.0,
      ),
      title: Text(restaurant.name),
      subtitle: Text(restaurant.city),
      onTap: () async {
        RestaurantDetail restaurantDetail =
            await RestaurantService(client: http.Client())
                .getRestaurantById(restaurant.id);

        Navigator.pushNamed(context, RestaurantDetailPage.routeName,
            arguments: restaurantDetail);
      },
    );
  }
}
