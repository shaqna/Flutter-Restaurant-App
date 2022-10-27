import 'package:flutter_restaurant_app/data/model/restaurant.dart';

class RestaurantDetail {
  late final Restaurant restaurant;
  bool? _isFavorite;
  late final List<String> categories;
  late final List<String> foods;
  late final List<String> drinks;

  RestaurantDetail({
    required this.restaurant,
    required this.categories,
    required this.foods,
    required this.drinks,
  });

  RestaurantDetail.fromJson(Map<String, dynamic> json) {
    restaurant = Restaurant.fromJson(json);

    var listCategories = json['categories'] as List;
    categories =
        listCategories.map<String>((val) => val['name'].toString()).toList();

    var listFoods = json['menus']['foods'] as List;
    foods = listFoods.map<String>((val) => val['name'].toString()).toList();

    var listDrinks = json['menus']['drinks'] as List;
    drinks = listDrinks.map<String>((val) => val['name'].toString()).toList();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonRestaurant = restaurant.toJson();

    jsonRestaurant['categories'] =
        categories.map((category) => {'name': category}).toList();

    jsonRestaurant['menus'] = {
      'foods': foods
          .map((food) => {
                'name': food,
              })
          .toList(),
      'drinks': drinks
          .map((drink) => {
                'name': drink,
              })
          .toList()
    };

    return jsonRestaurant;
  }

  bool get isFavorite => _isFavorite ?? false;
  set isFavorite(bool status) {
    _isFavorite = status;
  }
}
