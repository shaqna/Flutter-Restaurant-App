const restaurantListDummyResponse = '''
        {
          "error": false,
          "message": "success",
          "restaurants": [
            {
              "id": "1", "name": "mock", "description": "mock", 
              "pictureId": "1", "city": "mock", "rating": 5.0
            },
            {
              "id": "2", "name": "mock", "description": "mock", 
              "pictureId": "2", "city": "mock", "rating": 5.0
            }
          ]
        }
      ''';

const restaurantDetailDummyResponse = '''
        {
          "error": false,
          "message": "success",
          "restaurant": {
              "id": "1",
              "name": "mock",
              "description": "mock",
              "city": "mock",
              "address": "mock",
              "pictureId": "1",
              "categories": [ { "name": "mock 1" }, { "name": "mock 2" } ],
              "menus": {
                  "foods": [ { "name": "Mock 1" }, { "name": "Mock 2" } ],
                  "drinks": [ { "name": "Mock 2" }, { "name": "Mock 2" } ]
              },
              "rating": 5.0,
              "customerReviews": [
                { "name": "Mock", "review": "Mock", "date": "Mock" }
              ]
          }
      }
      ''';
