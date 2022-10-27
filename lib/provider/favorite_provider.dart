import 'package:flutter/material.dart';
import 'package:flutter_restaurant_app/data/database/local_database.dart';
import 'package:flutter_restaurant_app/data/model/restaurant.dart';
import 'package:flutter_restaurant_app/utils/state_ui.dart';
import 'package:flutter_restaurant_app/utils/strings.dart';

class FavoriteProvider with ChangeNotifier {
  late final LocalDatabase _database;

  late List<Restaurant> _restaurants;
  List<Restaurant> get restaurant => _restaurants;

  StateFavorite _state = StateFavorite.empty;
  StateFavorite get state => _state;

  String _message = '';
  String get message => _message;

  FavoriteProvider({required LocalDatabase database}) {
    _database = database;
    _getAllRestaurants();
  }

  void setStateWithNotifyListener(StateFavorite state) {
    _state = state;
    notifyListeners();
  }

  Future<dynamic> _getAllRestaurants() async {
    try {
      final restaurants = await _database.getRestaurants();
      if (restaurants.isEmpty) {
        setStateWithNotifyListener(StateFavorite.empty);
        return _message = emptyFavoriteMessage;
      } else {
        setStateWithNotifyListener(StateFavorite.hasData);
        return _restaurants = restaurants;
      }
    } catch (e) {
      return _message = e.toString();
    }
  }

  Future<void> addRestaurant(Restaurant restaurant) async {
    await _database.addFavorite(restaurant);
    _getAllRestaurants();
  }

  Future<Restaurant> getRestaurantById(String id) async {
    return await _database.getRestaurantById(id);
  }

  void deleteRestaurant(String id) async {
    await _database.deleteFavorite(id);
    _getAllRestaurants();
  }
}
