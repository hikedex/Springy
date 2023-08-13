// From JSON. Summit has lat, lon, score, name

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hikedex/providers/apiProvider.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

double summit_checkin_radius = 500.0;

class Summit {
  final int id;
  final String name;
  final double lat;
  final double lon;
  final double score;

  Summit(
      {required this.id,
      required this.name,
      required this.lat,
      required this.lon,
      required this.score});

  factory Summit.fromJson(Map<dynamic, dynamic> json) {
    return Summit(
      id: int.parse(json['id']),
      name: json['name'],
      lat: json['lat'],
      lon: json['lon'],
      score: json['score'],
    );
  }

  double distance(double lat, double lon) {
    return Geolocator.distanceBetween(lat, lon, this.lat, this.lon);
  }

  bool inRange(double lat, double lon) {
    return distance(lat, lon) < summit_checkin_radius;
  }

  Marker getMarker(BuildContext context) {
    return Marker(
      width: 40.0,
      height: 40.0,
      rotate: false,
      point: LatLng(lat, lon),
      builder: (ctx) => Container(
        // white circle border
        decoration: BoxDecoration(
          color: Theme.of(ctx).colorScheme.primaryContainer.withOpacity(0.5),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
        ),
        // color: Theme.of(ctx).colorScheme.primaryContainer.withOpacity(0.5),
        // shape: const CircleBorder(),
        child: InkWell(
          onTap: () {
            Provider.of<ApiProvider>(context, listen: false).selectSummit(this);
          },
          child: Icon(Icons.change_history),
        ),
      ),
    );
  }
}
