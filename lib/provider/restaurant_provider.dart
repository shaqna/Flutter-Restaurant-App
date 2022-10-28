import 'package:flutter/cupertino.dart';
import 'package:flutter_restaurant_app/data/model/restaurant.dart';
import 'package:flutter_restaurant_app/data/model/restaurant_detail.dart';
import 'package:flutter_restaurant_app/data/service/restaurant_service.dart';
import 'package:flutter_restaurant_app/helper/navigation_helper.dart';
import 'package:flutter_restaurant_app/pages/restaurant_detail_page.dart';
import 'package:flutter_restaurant_app/utils/state_ui.dart';
import 'package:flutter_restaurant_app/utils/strings.dart';

class RestaurantProvider extends ChangeNotifier {
  late final RestaurantService _service;
  late List<Restaurant> _restaurants;
  List<Restaurant> get restaurant => _restaurants;

  late StateUI _state;
  StateUI get state => _state;

  String _message = '';
  String get message => _message;

  RestaurantProvider({required RestaurantService service}) {
    _service = service;
    _fetchRestaurantData();
  }

  void setStateWithNotifyListener(StateUI state) {
    _state = state;
    notifyListeners();
  }

  void _fetchRestaurantData() async {
    setStateWithNotifyListener(StateUI.loading);
    try {
      final restaurants = await _service.getRestaurants();
      if (restaurants.isEmpty) {
        _message = emptyRestaurantMessage;
        setStateWithNotifyListener(StateUI.noData);
      } else {
        _restaurants = restaurants;
        setStateWithNotifyListener(StateUI.hasData);
      }
    } catch (e) {
      _message = e.toString();
      setStateWithNotifyListener(StateUI.error);
    }
  }

  void searchRestaurant(String query) async {
    if (query.isEmpty) {
      _fetchRestaurantData();
    } else {
      setStateWithNotifyListener(StateUI.loading);
      try {
        final restaurants = await _service.searchRestaurant(query);
        if (restaurants.isEmpty) {
          _message = emptyRestaurantMessage;
          setStateWithNotifyListener(StateUI.noData);
        } else {
          _restaurants = restaurants;
          setStateWithNotifyListener(StateUI.hasData);
        }
      } catch (e) {
        _message = e.toString();
        setStateWithNotifyListener(StateUI.error);
      }
    }
  }

  void onTapRestaurantItem(BuildContext context, String id) async {
    setStateWithNotifyListener(StateUI.loading);
    try {
      RestaurantDetail restaurant = await _service.getRestaurantById(id);
      setStateWithNotifyListener(StateUI.hasData);
      NavigationHelper.intentWithData(
          RestaurantDetailPage.routeName, restaurant);

      // Navigator.pushNamed(context, RestaurantDetailPage.routeName,
      //         arguments: restaurant);
    } catch (e) {
      _message = e.toString();
      setStateWithNotifyListener(StateUI.error);
    }
  }
}
