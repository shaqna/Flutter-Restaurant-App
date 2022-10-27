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

  Future<dynamic> _fetchRestaurantData() async {
    try {
      _state = StateUI.loading;
      final restaurants = await _service.getRestaurants();
      if (restaurants.isEmpty) {
        setStateWithNotifyListener(StateUI.noData);
        return _message = emptyRestaurantMessage;
      } else {
        setStateWithNotifyListener(StateUI.hasData);
        return _restaurants = restaurants;
      }
    } catch (e) {
      setStateWithNotifyListener(StateUI.error);
      return _message = e.toString();
    }
  }

  void searchRestaurant(String query) async {
    try {
      if (query.isEmpty) {
        _fetchRestaurantData();
      } else {
        _state = StateUI.loading;
        final restaurants = await _service.searchRestaurant(query);
        if (restaurant.isEmpty) {
          setStateWithNotifyListener(StateUI.noData);
          _message = emptyRestaurantMessage;
        } else {
          setStateWithNotifyListener(StateUI.hasData);
          _restaurants = restaurants;
        }
      }
    } catch (e) {
      setStateWithNotifyListener(StateUI.error);
      _message = e.toString();
    }
  }

  void onTapRestaurantItem(BuildContext context, String id) async {
  
      RestaurantDetail restaurant = await _service.getRestaurantById(id);

      NavigationHelper.intentWithData(
          RestaurantDetailPage.routeName, restaurant);

    // Navigator.pushNamed(context, RestaurantDetailPage.routeName,
    //         arguments: restaurant);
  }
}
