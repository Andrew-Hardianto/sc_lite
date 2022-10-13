import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sc_lite/service/main_service.dart';

class ApprovalMap extends StatefulWidget {
  final double lat;
  final double lng;
  const ApprovalMap({
    super.key,
    required this.lat,
    required this.lng,
  });

  @override
  State<ApprovalMap> createState() => _ApprovalMapState();
}

class _ApprovalMapState extends State<ApprovalMap> {
  final mainService = MainService();
  Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> newMarker = {};

  double latitude = -7.05770065;
  double longitude = 110.41586081;
  dynamic customIcon;

  @override
  void initState() {
    super.initState();
    getIcon();
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

  getIcon() async {
    var iconMarker = await mainService.bitmapDescriptorFromSvgAsset(
        context, 'assets/icon/general/pin-map.svg');
    print(iconMarker);
    setState(() {
      customIcon = iconMarker;
    });
    // BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(24, 24)),
    //         'assets/icon/general/Pin-Maps.png')
    //     .then((d) {
    //   print({'b': d});
    //   setState(() {
    //     customIcon = d;
    //   });
    // });
  }

  getLocation() async {
    final GoogleMapController mapCtrl = await _controller.future;

    try {
      mapCtrl.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(widget.lat, widget.lng), zoom: 15),
        ),
      );
      if (mounted) {
        setState(() {
          newMarker.add(
            Marker(
              markerId: const MarkerId('m1'),
              position: LatLng(widget.lat, widget.lng),
              icon: BitmapDescriptor.defaultMarker,
            ),
          );
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
            latitude,
            longitude,
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
