# Architecture

The app is split into three layers.

| Layer | Files | Responsibility |
|---|---|---|
| Presentation | `lib/screens/*`, `lib/widgets/*` | Screens, campus map painter, list tiles |
| State | `lib/state/campus_controller.dart` | Search, filters, favourites, recent places, theme; `notifyListeners()` |
| Data | `lib/models`, `lib/data`, `lib/services` | Place model, campus graph, route finding, local storage |

## Data flow
1. A screen calls a method on `CampusController` (e.g. `toggleFavourite`).
2. The controller updates its state, calls `notifyListeners()` and saves through `StorageService`.
3. Every screen wrapped in `ListenableBuilder` rebuilds with the new state.

## Route finding
- Road junctions are graph nodes with (x, y) coordinates in metres (`CampusData.nodes`).
- Road segments are undirected edges weighted by straight-line distance (`CampusData.roads`).
- Each place stores `entranceNode`, the junction nearest its building entrance.
- `RouteService.shortestPath` runs Dijkstra's algorithm between the two entrance nodes.
- Walking time = distance ÷ 1.2 m/s. Consecutive segments in the same compass
  direction are merged into one instruction ("Walk 190 m north").

## Campus map
`CampusMap` is a `CustomPainter` inside an `InteractiveViewer`. Map units are scaled to the
screen width; taps are converted back to map units to find the building that was tapped.
