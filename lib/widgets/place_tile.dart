import 'package:flutter/material.dart';
import '../data/campus_data.dart';
import '../models/place.dart';
import '../screens/place_detail_screen.dart';
import '../state/campus_controller.dart';

class PlaceTile extends StatelessWidget {
  const PlaceTile({super.key, required this.place, required this.controller});
  final Place place;
  final CampusController controller;

  @override
  Widget build(BuildContext context) {
    final building = CampusData.buildingById(place.building)?.name ?? place.name;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: place.category.color.withValues(alpha: 0.15),
          child: Icon(place.category.icon, color: place.category.color),
        ),
        title: Text(place.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('$building • ${place.floor} floor${place.room.isEmpty ? '' : ' • ${place.room}'}'),
        trailing: Icon(controller.isFavourite(place) ? Icons.bookmark : Icons.chevron_right),
        onTap: () {
          controller.markVisited(place);
          Navigator.push(context, MaterialPageRoute(
            builder: (_) => PlaceDetailScreen(place: place, controller: controller)));
        },
      ),
    );
  }
}
