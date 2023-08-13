import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:hikedex/providers/apiProvider.dart';

class SelectArea extends StatefulWidget {
  const SelectArea({super.key});

  @override
  State<SelectArea> createState() => _SelectAreaState();
}

class _SelectAreaState extends State<SelectArea> {
  LatLng _currentCenter = LatLng(0, 0);
  @override
  Widget build(BuildContext context) {
    CurrentLocationLayer currentLocationLayer = CurrentLocationLayer();
    return FutureBuilder(
      future: currentLocationLayer.positionStream.first,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              FlutterMap(
                options: MapOptions(
                  rotation: 0,
                  interactiveFlags:
                      InteractiveFlag.all & ~InteractiveFlag.rotate,
                  maxZoom: 10.0,
                  minZoom: 8.0,
                  center: snapshot.data.latLng,
                  onMapReady: () {
                    setState(() {
                      _currentCenter = snapshot.data.latLng;
                    });
                  },
                  onPositionChanged: (MapPosition position, bool hasGesture) {
                    setState(() {
                      _currentCenter = position.center!;
                    });
                  },
                  zoom: 10.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                    maxZoom: 19,
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: _currentCenter,
                        builder: (ctx) => Icon(
                          Icons.add,
                          color: Colors.green[900],
                        ),
                      ),
                    ],
                  ),
                  CircleLayer(
                    circles: [
                      CircleMarker(
                        point: _currentCenter,
                        color: Colors.green.withOpacity(0.4),
                        borderColor: Colors.green,
                        borderStrokeWidth: 2,
                        useRadiusInMeter: true,
                        radius: 15000,
                      ),
                    ],
                  ),
                  // currentLocationLayer,
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  // round corners
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Set Home Region',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          'Careful! This is your only free region.',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.secondary,
                                foregroundColor:
                                    Theme.of(context).colorScheme.onSecondary,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                fixedSize: const Size.fromHeight(50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: () {
                                // use apiprovider to download summits
                                var dl = Provider.of<ApiProvider>(context,
                                        listen: false)
                                    .downloadSummits(_currentCenter);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      // Only fill the space it needs
                                      content: IntrinsicHeight(
                                        child: Column(
                                          children: [
                                            const CircularProgressIndicator(),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Tying laces...',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                                // then navigate to home page
                                dl.then((value) {
                                  Navigator.popUntil(
                                      context, ModalRoute.withName('/'));
                                });
                              },
                              child: Text(
                                'Confirm',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
