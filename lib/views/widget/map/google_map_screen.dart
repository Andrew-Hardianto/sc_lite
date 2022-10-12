import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  final double lat;
  final double lng;
  const MapScreen({
    Key? key,
    required this.lat,
    required this.lng,
  }) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // late final GoogleMapController _mapCtrl;
  Completer<GoogleMapController> _controller = Completer();
  Location location = Location();
  final Set<Marker> newMarker = {};

  double officeLatitude = -7.05770065;
  double officeLongitude = 110.41586081;

  // late LocationData currentLocation;

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  void dispose() {
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
      // location.onLocationChanged.listen((LocationData currentLocation) {
      //   mapCtrl.animateCamera(
      //     CameraUpdate.newCameraPosition(
      //       CameraPosition(
      //           target: LatLng(
      //               currentLocation.latitude!, currentLocation.longitude!),
      //           zoom: 15),
      //     ),
      //   );
      //   if (mounted) {
      //     setState(() {
      //       newMarker.add(Marker(
      //         markerId: const MarkerId('m1'),
      //         position:
      //             LatLng(currentLocation.latitude!, currentLocation.longitude!),
      //       ));
      //     });
      //   }
      // });
      mapCtrl.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(widget.lat, widget.lng), zoom: 15),
        ),
      );
      if (mounted) {
        setState(() {
          newMarker.add(Marker(
            markerId: const MarkerId('m1'),
            position: LatLng(widget.lat, widget.lng),
          ));
        });
      }
    } catch (err) {
      print('PlatformException $err');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(10),
      ),
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
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
