import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:hikedex/models/summit.dart';
import 'package:http/http.dart' as http;

class ApiProvider extends ChangeNotifier {
  /// Internal, private state of the cart.
  final List<Summit> _summits = [];
  final String _apiRoot = 'http://192.168.5.151:5000/api/v1';
  final String _country = "England";

  Summit? _selectedSummit = null;

  void selectSummit(Summit summit) {
    _selectedSummit = summit;
    notifyListeners();
  }

  Summit? nearbySummit(LatLng pos) {
    for (var summit in _summits) {
      if (summit.inRange(pos.latitude, pos.longitude)) {
        print("Found nearby summit: ${summit.name}");
        return summit;
      }
    }
    print("No nearby summits");
    return null;
  }

  void deselectSummit() {
    _selectedSummit = null;
    notifyListeners();
  }

  Summit? get selectedSummit => _selectedSummit;

  bool get hasSummits => !_summits.isEmpty;

  List<Summit> get summits => _summits;

  Future<void> downloadSummits(LatLng pos) async {
    print("Downloading summits");
    // make a post request to the api root /summits
    // parameters: country, lat, lon.
    final response = await http.post(
      Uri.parse('$_apiRoot/summits'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'country': _country,
        'lat': pos.latitude.toString(),
        'lon': pos.longitude.toString()
      }),
    );
    // parse the response using the Summit.fromJson method
    // and add it to the _summits list.
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body)["data"];
      // for id, data in data.items():

      data.forEach((id, dat) {
        // add id to dat
        dat = {...dat, "id": id};
        _summits.add(Summit.fromJson(dat));
      });
      print("Summits downloaded: ${_summits.length}");
      notifyListeners();
    } else {
      throw Exception('Failed to load summits');
    }
  }
}
