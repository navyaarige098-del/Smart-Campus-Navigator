# Adding campus data

All campus data lives in `lib/data/campus_data.dart`. Map units are metres; the map is 400 × 600.

## Add a place inside an existing building
```dart
Place(
  id: 'cn_lab',                       // unique id
  name: 'Networks Lab',
  category: PlaceCategory.lab,
  building: 'cse',                    // id from CampusData.buildings
  floor: '2nd',
  room: 'C-210',
  entranceNode: 'r2',                 // junction nearest the building entrance
  tags: ['networking', 'cisco'],
),
```

## Add a new building
1. Add a `Building(id, name, Rect.fromLTWH(x, y, w, h), color)` to `buildings`.
2. If it is not next to an existing junction, add a node to `nodes` and connect it with a road in `roads`.
3. Add its places with `entranceNode` set to that junction.
4. Run `flutter test` – the "every place reachable" test checks the new node is connected.
