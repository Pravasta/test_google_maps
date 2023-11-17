import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapServicesScreen {
  final myLocation = const LatLng(-7.5483356, 110.8658685);

  final listPlaceArroundMyLocation = [
    const LatLng(-7.5596274, 110.8563805), //uns
    const LatLng(-7.5523616, 110.8623821), // Kumlot
    const LatLng(-7.5560692, 110.8538665), // Solo Technopark
    const LatLng(-7.5538968, 110.8646736), // Jepun
  ];

  late GoogleMapController mapController;
  final Set<Marker> markers = {};

  /// untuk selected Map
  MapType selectedMap = MapType.normal;

  /// untuk set init marker ketika buka maps
  onInit() {
    final marker = Marker(
      markerId: const MarkerId('My Kost'),
      position: myLocation,
      onTap: () {
        mapController.animateCamera(
          CameraUpdate.newLatLngZoom(myLocation, 18),
        );
      },
    );

    markers.add(marker);

    anyMarkers();
  }

  /// zoom peta
  zoom(bool isZoomIn) {
    isZoomIn
        ? mapController.animateCamera(CameraUpdate.zoomIn())
        : mapController.animateCamera(CameraUpdate.zoomOut());
  }

  /// anyMarker
  void anyMarkers() {
    for (var location in listPlaceArroundMyLocation) {
      markers.add(
        Marker(
          markerId: MarkerId('Location $location'),
          position: location,
          onTap: () {
            mapController.animateCamera(
              CameraUpdate.newLatLngZoom(location, 18),
            );
          },
        ),
      );
    }
  }

  /// untuk langsung menampilkan banyak marker secara zoom
  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    double? x0, x1, y0, y1;

    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }

    return LatLngBounds(
      northeast: LatLng(x1!, y1!),
      southwest: LatLng(x0!, y0!),
    );
  }

  onMapCreatedLatLngBound() {
    final bound =
        boundsFromLatLngList([myLocation, ...listPlaceArroundMyLocation]);
    mapController.animateCamera(CameraUpdate.newLatLngBounds(bound, 50));
  }
}
