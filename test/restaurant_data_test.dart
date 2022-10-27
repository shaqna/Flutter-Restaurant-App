import 'package:flutter_restaurant_app/data/model/restaurant.dart';
import 'package:flutter_restaurant_app/data/model/restaurant_detail.dart';
import 'package:flutter_restaurant_app/data/service/restaurant_service.dart';
import 'package:flutter_restaurant_app/utils/const_object.dart';
import 'package:flutter_restaurant_app/utils/dummy_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import 'restaurant_data_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group(
    'fetchRestaurant',
    () {
      test(
        "should returns list of restaurant if fetching successfully",
        () async {
          final client = MockClient();
          when(client.get(Uri.parse('$baseUrl/list'))).thenAnswer(
              (_) async => http.Response(restaurantListDummyResponse, 200));
          var restaurantList =
              await RestaurantService(client: client).getRestaurants();
          expect(restaurantList.runtimeType, List<Restaurant>);
        },
      );

      test(
        'should return restaurant detail if fetching successfully',
        () async {
          final client = MockClient();
          when(client.get(Uri.parse('$baseUrl/detail/1'))).thenAnswer(
              (_) async => http.Response(restaurantDetailDummyResponse, 200));

          var restaurantDetail =
              await RestaurantService(client: client).getRestaurantById("1");
          expect(restaurantDetail.runtimeType, RestaurantDetail);
        },
      );
    },
  );
}
