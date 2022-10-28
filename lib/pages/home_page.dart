import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant_app/data/model/restaurant.dart';
import 'package:flutter_restaurant_app/pages/favorite_page.dart';
import 'package:flutter_restaurant_app/pages/settings_page.dart';
import 'package:flutter_restaurant_app/provider/restaurant_provider.dart';
import 'package:flutter_restaurant_app/utils/const_object.dart';
import 'package:flutter_restaurant_app/utils/state_ui.dart';
import 'package:flutter_restaurant_app/utils/strings.dart';
import 'package:flutter_restaurant_app/widgets/platform_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';
  const HomePage({super.key});

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
        title: const Text('Restaurant App'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, FavoritePage.routeName);
              },
              child: const Icon(
                Icons.favorite,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, SettingsPage.routeName);
              },
              child: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant App'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, FavoritePage.routeName);
              },
              child: const Icon(
                Icons.favorite,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, SettingsPage.routeName);
              },
              child: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, right: 6, top: 3),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: TextFormField(
              decoration: const InputDecoration(hintText: "Cari Restoran"),
              onChanged: (query) {
                Provider.of<RestaurantProvider>(context, listen: false)
                    .searchRestaurant(query);
              },
            ),
          ),
          const SizedBox(height: 4),
          Expanded(child: _listBuilder())
        ],
      ),
    );
  }

  Widget _listBuilder() {
    return Consumer<RestaurantProvider>(builder: (context, provider, _) {
      switch (provider.state) {
        case StateUI.loading:
          return const Center(
            child: CircularProgressIndicator(),
          );
        case StateUI.noData:
          return Center(
            child: Text(provider.message),
          );
        case StateUI.error:
          return Center(
            child: Text(provider.message),
          );
        case StateUI.hasData:
          return ListView.builder(
            itemCount: provider.restaurant.length,
            itemBuilder: (context, index) {
              return _buildRestaurantItem(context, provider.restaurant[index]);
            },
          );
      }
    });
  }

  Widget _buildRestaurantItem(BuildContext context, Restaurant restaurant) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      leading: CachedNetworkImage(
        imageUrl: mediumResolutionPictureUrl + restaurant.pictureId,
        errorWidget: (context, url, error) => const Icon(Icons.error),
        placeholder: (context, url) => const CircularProgressIndicator(),
      ),
      title: Text(restaurant.name),
      subtitle: Text(restaurant.city),
      onTap: () async {
        Provider.of<RestaurantProvider>(context, listen: false)
            .onTapRestaurantItem(context, restaurant.id);
      },
    );
  }
}
