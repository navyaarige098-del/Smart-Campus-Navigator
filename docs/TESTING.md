# Testing

Run all tests with `flutter test`. CI runs `flutter analyze`, `flutter test` and `flutter build web` on every push.

| File | Test | Type |
|---|---|---|
| route_service_test.dart | Shortest path Main Gate → CSE Block | Unit |
| route_service_test.dart | Route distance (290 m) and walking time (4 min) | Unit |
| route_service_test.dart | Directions merge straight segments | Unit |
| route_service_test.dart | Same building gives zero distance | Unit |
| route_service_test.dart | Every place reachable from the gate | Unit |
| search_test.dart | Search by name, room and tag | Unit |
| search_test.dart | Filter by category | Unit |
| search_test.dart | Favourites saved and reloaded | Unit |
| search_test.dart | Recent list keeps the latest 5 | Unit |
| place_model_test.dart | Empty query matches every place | Unit |
| place_model_test.dart | Search is case-insensitive | Unit |
| place_model_test.dart | Place ids are unique | Unit |
| place_model_test.dart | Every place points to a known building and junction | Unit |
| widget_test.dart | Home screen shows title and categories | Widget |
