import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../services/yandex_services.dart';

class YandexScreen extends StatefulWidget {
  const YandexScreen({super.key});

  @override
  State<YandexScreen> createState() => _YandexScreenState();
}

class _YandexScreenState extends State<YandexScreen> {
  late YandexMapController yandexController;
  String currentLocationName = "";
  List<MapObject> markers = [];
  List<PolylineMapObject> polylines = [];
  List<Point> positions = [];
  Point? myLocation;
  Point najotTalim = const Point(
    latitude: 41.2856806,
    longitude: 69.2034646,
  );

  void onMapCreated(YandexMapController controller) {
    setState(() {
      yandexController = controller;

      yandexController.moveCamera(
        animation: const MapAnimation(
          type: MapAnimationType.smooth,
          duration: 1,
        ),
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: najotTalim,
            zoom: 18,
          ),
        ),
      );
    });
  }

  void onCameraPositionChanged(
      CameraPosition position,
      CameraUpdateReason reason,
      bool finish,
      ) {
    myLocation = position.target;
    setState(() {});
  }

  void addMarker() async {
    markers.add(
      PlacemarkMapObject(
        mapId: MapObjectId(UniqueKey().toString()),
        point: myLocation!,
        opacity: 1,
        icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage(
              "assets/marker1.png",
            ),
            scale: 0.5,
          ),
        ),
      ),
    );

    positions.add(myLocation!);

    if (positions.length == 2) {
      polylines = await YandexMapService.getDirection(
        positions[0],
        positions[1],
      );
    }

    setState(() {});
  }

  void getMyCurrentLocation() async {
    await Geolocator.openLocationSettings();

  }

  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: [
        YandexMap(
          onMapCreated: onMapCreated,
          onCameraPositionChanged: onCameraPositionChanged,
          mapType: MapType.map,
          mapObjects: [
            PlacemarkMapObject(
              mapId: const MapObjectId("najotTalim"),
              point: najotTalim,
              opacity: 1,
              icon: PlacemarkIcon.single(
                PlacemarkIconStyle(
                  image: BitmapDescriptor.fromAssetImage(
                    "assets/marker2.png",
                  ),
                  scale: 0.5,
                ),
              ),
            ),
            ...markers,

            ...polylines,
          ],
        ),
        const Align(
          child: Icon(
            Icons.place,
            size: 60,
            color: Colors.blue,
          ),
        ),
        Positioned(
          bottom: 45,
          left: 10,
          child: FloatingActionButton(
            onPressed: getMyCurrentLocation,
            child: const Icon(
              Icons.person,
              size: 30,
            ),
          ),
        ),
      ],
    );
  }
}


//floatingActionButton: FloatingActionButton(
//         onPressed: addMarker,
//         child: const Icon(Icons.add_location),
//       ),