import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:hikedex/models/summit.dart';
import 'package:hikedex/utils/textloader.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:hikedex/providers/apiProvider.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late Stream<LocationMarkerPosition?>
      locationStream; // Stream to listen to location updates

  @override
  void initState() {
    super.initState();
    CurrentLocationLayer currentLocationLayer = CurrentLocationLayer();
    locationStream = currentLocationLayer.positionStream;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LocationMarkerPosition?>(
      stream: locationStream,
      builder: (BuildContext context,
          AsyncSnapshot<LocationMarkerPosition?> snapshot) {
        if (snapshot.hasData) {
          return _buildMapWithLocation(snapshot.data!.latLng);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildMapWithLocation(LatLng currentLocation) {
    Summit? nearbySummit =
        Provider.of<ApiProvider>(context).nearbySummit(currentLocation);
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        FlutterMap(
          options: MapOptions(
            center: currentLocation,
            zoom: 13.0,
            onMapEvent: (p0) {
              Provider.of<ApiProvider>(context, listen: false).deselectSummit();
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
              maxZoom: 19,
            ),
            CurrentLocationLayer(), // Assuming CurrentLocationLayer includes user marker
            MarkerClusterLayerWidget(
              options: MarkerClusterLayerOptions(
                maxClusterRadius: 120,
                size: const Size(40, 40),
                fitBoundsOptions: FitBoundsOptions(
                  padding: EdgeInsets.all(50),
                ),
                markers: Provider.of<ApiProvider>(context)
                    .summits
                    .map((e) => e.getMarker(context))
                    .toList(),
                polygonOptions: PolygonOptions(
                    borderColor: Colors.blueAccent,
                    color: Colors.black12,
                    borderStrokeWidth: 3),
                builder: (context, markers) {
                  return FloatingActionButton(
                    onPressed: null,
                    child: Text(markers.length.toString()),
                  );
                },
              ),
            ),
          ],
        ),
        AnimatedPositioned(
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 200),
          left: 0,
          right: 0,
          bottom: (Provider.of<ApiProvider>(context).selectedSummit == null) &&
                  (nearbySummit == null)
              ? -200
              : 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: nearbySummit != null
                ? _buildNearbySummitCheckin(nearbySummit)
                : _buildSummitInfo(),
          ),
        ),
      ],
    );
  }

  Widget _buildNearbySummitCheckin(Summit summit) {
    return Container(
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
              summit.name,
              style: CustomText.apply(
                style: Theme.of(context).textTheme.headlineLarge,
                weight: FontWeight.bold,
              ),
              // textAlign: TextAlign.center,
            ),
            Text(summit.score.round().toString() + " points"),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Theme.of(context).colorScheme.onSecondary,
                    textStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    fixedSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Check in',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummitInfo() {
    return Container(
      // round corners
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      width: double.infinity,
      child: IntrinsicHeight(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Row(
                children: [
                  IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Provider.of<ApiProvider>(context)
                                      .selectedSummit
                                      ?.name ==
                                  null
                              ? ""
                              : Provider.of<ApiProvider>(context)
                                  .selectedSummit!
                                  .name,
                          style: CustomText.apply(
                            style: Theme.of(context).textTheme.headlineSmall,
                            weight: FontWeight.bold,
                          ),
                          // textAlign: TextAlign.center,
                        ),
                        Text(Provider.of<ApiProvider>(context)
                                    .selectedSummit
                                    ?.score ==
                                null
                            ? ""
                            : Provider.of<ApiProvider>(context)
                                    .selectedSummit!
                                    .score
                                    .round()
                                    .toString() +
                                " XP"),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // tree icon
                  Icon(
                    Icons.landscape,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 50,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              // icons: bookmark, map, send
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.bookmark_border,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.map,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.send,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                SizedBox(width: 8),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(8),
              // white background, no padding, same color as foreground
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).colorScheme.secondary,
              ),
              child: Row(
                // cirular avatar
                children: [
                  CircleAvatar(
                    radius: 30,
                    child: Icon(
                      Icons.person,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "John Doe",
                        style: CustomText.apply(
                          style: Theme.of(context).textTheme.labelLarge,
                          color: Theme.of(context).colorScheme.onSecondary,
                          weight: FontWeight.w900,
                        ),
                        // textAlign: TextAlign.center,
                      ),
                      Text(
                        "14 days",
                        style: CustomText.apply(
                          style: Theme.of(context).textTheme.labelLarge,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // row of three shield icons
                  Row(
                    children: [
                      Icon(
                        Icons.shield_sharp,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.shield_sharp,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.shield_outlined,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                      SizedBox(width: 4),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
