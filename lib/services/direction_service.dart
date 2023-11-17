import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:maps_flutter/model/direction_model.dart';

class DirectionService with ChangeNotifier {
  late GoogleMapController mapController;
  late final Set<Marker> markers = {};
  final myLocation = const LatLng(-7.5483356, 110.8658685);
  final unsLocation = const LatLng(-7.5596274, 110.8563805);

  late final Set<Polyline> polylines = {};

  final Location location = Location();

  bool isNavigation = false;

  /// untuk inisiasi marker 2 location secara manual
  onInit(GoogleMapController controller) {
    /// myLocation Marker
    final myLocationMarker = Marker(
      markerId: const MarkerId('myLocation'),
      position: myLocation,
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRed,
      ),
    );

    /// uns Marker
    final unsLocationMarker = Marker(
      markerId: const MarkerId('unsLocation'),
      position: unsLocation,
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueBlue,
      ),
    );

    mapController = controller;
    markers.addAll([myLocationMarker, unsLocationMarker]);
    notifyListeners();
  }

  /// menggambar rute location dapat menggunakan polyline
  Future<void> setPolyline(
      LatLng titikAwal, LatLng tujuan, BuildContext context) async {
    final scaffold = ScaffoldMessenger.of(context);

    final result = await Direction.getDirections(
      googleMapsApiKey: "AIzaSyBgwiWbM1tQcSkQ5zZ8PwKMsm7PT8o9hD4",
      origin: titikAwal,
      destination: tujuan,
    );

    // atur polyline dan ubah view maps
    final polylineCoordinate = <LatLng>[];
    if (result != null && result.polylinePoints.isNotEmpty) {
      polylineCoordinate.addAll(result.polylinePoints);
    }

    final polyLine = Polyline(
      polylineId: const PolylineId('default-polyline'),
      color: Colors.blue,
      width: 7,
      points: polylineCoordinate,
    );

    polylines.add(polyLine);
    notifyListeners();

    if (result == null) {
      scaffold.showSnackBar(
        const SnackBar(
          content: Text('Belum Bayar Biiling'),
        ),
      );
    } else {
      print('Result tidak null : $result');
      mapController.animateCamera(
        CameraUpdate.newLatLngBounds(result.bounds, 50),
      );
    }
  }

  /// untuk setup location fiture hp
  Future<void> setUpLocation() async {
    late bool serviceEnabled;
    late PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        print('Location Service tidak tersedia');
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        print('Location permission ditolak');
        return;
      }
    }
  }

  /// update lokasi perangkat, dan pasangkan pada init state
  onInitState() {
    Future.microtask(() async => await setUpLocation());

    location.onLocationChanged.listen((currLocation) {
      if (isNavigation) {
        final latLng = LatLng(currLocation.latitude!, currLocation.longitude!);

        CameraPosition cameraPosition = CameraPosition(
          target: latLng,
          zoom: 16,
          tilt: 80,
          bearing: 30,
        );

        mapController.animateCamera(
          CameraUpdate.newCameraPosition(cameraPosition),
        );

        markers
            .removeWhere((element) => element.markerId.value == 'myLocation');
        markers.add(
          Marker(
            markerId: const MarkerId('myLocation'),
            position: latLng,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueMagenta),
          ),
        );
      }
    });
  }
}
