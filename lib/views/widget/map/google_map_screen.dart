import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // late final GoogleMapController _mapCtrl;
  Completer<GoogleMapController> _controller = Completer();
  Location location = Location();
  final Set<Marker> newMarker = {};

  double officeLatitude = -6.2793;
  double officeLongitude = 107.0054;
  double toleranceInMeter = 100;

  // late LocationData currentLocation;

  @override
  void initState() {
    super.initState();
    // getCurrentLocation();
    getLocation();
  }

  @override
  void dispose() {
    // _mapCtrl.dispose();
    _disposeController();
    newMarker.clear();
    super.dispose();
  }

  Future<void> _disposeController() async {
    final GoogleMapController controller = await _controller.future;
    controller.dispose();
  }

  getLocation() async {
    // _mapCtrl = controller;
    final GoogleMapController mapCtrl = await _controller.future;

    try {
      location.onLocationChanged.listen((LocationData currentLocation) {
        mapCtrl.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(
                    currentLocation.latitude!, currentLocation.longitude!),
                zoom: 15),
          ),
        );
        if (mounted) {
          setState(() {
            newMarker.add(Marker(
              markerId: const MarkerId('m1'),
              position:
                  LatLng(currentLocation.latitude!, currentLocation.longitude!),
            ));
          });
        }
      });
    } catch (err) {
      print('PlatformException $err');
    }
  }

  // getCurrentLocation() {
  //   location.onLocationChanged.listen((LocationData loc) {
  //     currentLocation = location as LocationData;
  //     if (mounted) {
  //       setState(() {
  //         newMarker.add(Marker(
  //           markerId: const MarkerId('m1'),
  //           position: LatLng(loc.latitude!, loc.longitude!),
  //         ));
  //       });
  //     }
  //   });
  // }

  // void updatePinOnMap() async {
  //   CameraPosition cPosition = CameraPosition(
  //     zoom: 18,
  //     target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
  //   );
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));

  //   setState(() {
  //     // updated position
  //     var pinPosition =
  //         LatLng(currentLocation.latitude!, currentLocation.longitude!);

  //     newMarker.removeWhere((m) => m.markerId.value == 'sourcePin');
  //     newMarker.add(
  //       Marker(
  //         markerId: MarkerId('sourcePin'),

  //         position: pinPosition, // updated position
  //         // icon: sourceIcon,
  //       ),
  //     );
  //   });
  // }

  // showPinsOnMap() {
  //   var pinPosition =
  //       LatLng(currentLocation.latitude!, currentLocation.longitude!);

  //   // add the initial source location pin
  //   newMarker.add(
  //     Marker(
  //       markerId: MarkerId('sourcePin'),
  //       position: pinPosition,
  //       onTap: () {},
  //       // icon: sourceIcon,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // CameraPosition initialCameraPosition = CameraPosition(
    //   target: LatLng(
    //     currentLocation.latitude != null
    //         ? currentLocation.latitude!
    //         : officeLatitude,
    //     currentLocation.longitude != null
    //         ? currentLocation.longitude!
    //         : officeLongitude,
    //   ),
    //   zoom: 16,
    // );

    return ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(10),
      ),
      child: GoogleMap(
        initialCameraPosition:
            // initialCameraPosition,
            CameraPosition(
          target: LatLng(
            officeLatitude,
            officeLongitude,
          ),
          zoom: 16,
        ),
        markers: newMarker,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
