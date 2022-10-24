import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_restaurant_app/data/model/restaurant.dart';
import 'package:flutter_restaurant_app/data/model/restaurant_detail.dart';
import 'package:flutter_restaurant_app/utils/const_object.dart';
import 'package:flutter_restaurant_app/utils/strings.dart';
import 'package:http/http.dart' as http;

enum State { empty }

class RestaurantService {
  static Future<List<Restaurant>> getRestaurants() async {
    try {
      var response = await http.get(Uri.parse('$baseUrl/list'));
      var jsonResult = jsonDecode(response.body);
      List<Restaurant> restaurants = [];
      if (!jsonResult['error']) {
        var list = jsonResult['restaurants'] as List;
        restaurants = list.map((value) => Restaurant.fromJson(value)).toList();
      }

      if (restaurants.isEmpty) {
        throw State.empty;
      }

      return restaurants;
    } catch (state) {
      if (state == State.empty) {
        throw emptyRestaurantMessage;
      }
      throw connectionErrorMessage;
    }
  }

  static Future<RestaurantDetail> getRestaurantById(String id) async {
    try {
      var response = await http.get(Uri.parse('$baseUrl/detail/$id'));
      var jsonResult = jsonDecode(response.body);
      var restaurantDetail =
          RestaurantDetail.fromJson(jsonResult['restaurant']);

      return restaurantDetail;
    } catch (error) {
      throw connectionErrorMessage;
    }
  }

  static Future<List<Restaurant>> searchRestaurant(String query) async {
    try {
      query = query.replaceAll(' ', '%20');
      var response = await http.get(Uri.parse('$baseUrl/search?q=$query'));
      var jsonResult = jsonDecode(response.body);

      List<Restaurant> restaurants = [];

      if (!jsonResult['error']) {
        restaurants = (jsonResult['restaurants'] as List)
            .map((value) => Restaurant.fromJson(value))
            .toList();
      }

      if (restaurants.isEmpty) {
        throw State.empty;
      }

      return restaurants;
    } catch (state) {
      if (state == State.empty) {
        throw notFoundRestaurantMessage;
      }
      throw connectionErrorMessage;
    }
  }
}
