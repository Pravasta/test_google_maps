import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geo;

class PickerServiceScreen with ChangeNotifier {
  final myLocation = const LatLng(-7.5483356, 110.8658685);

  late GoogleMapController mapController;
  final Set<Marker> markers = {};

  final Location location = Location();
  late bool serviceEnabled;
  late PermissionStatus permissionGranted;
  late LocationData locationData;

  geo.Placemark? placemark;

  /// Untuk initstate location
  onInit() async {
    /// ini untuk mendapatkan detail lokasi kita saat ini
    final info = await geo.placemarkFromCoordinates(
        myLocation.latitude, myLocation.longitude);

    final place = info[0];
    final street = place.street;
    final address =
        "${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";

    placemark = place;
    notifyListeners();

    defineMarker(myLocation, street!, address);

    final marker = Marker(
      markerId: const MarkerId('My Kost'),
      position: myLocation,
    );

    markers.add(marker);
  }

  /// untuk dapatkan location kita secara auto
  void onMyLocation() async {
    // nyalakan service
    serviceEnabled = await location.serviceEnabled();
    // cek apakah nyala
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      // Jika ditolak
      if (!serviceEnabled) {
        print('Location tidak tersedia');
        return;
      }
    }

    // cek apakah ada izin permisi
    permissionGranted = await location.hasPermission();
    // Cek apakah ditolak, jika iya ?
    if (permissionGranted == PermissionStatus.denied) {
      // ajukan request permisi
      permissionGranted = await location.requestPermission();
      // cek apakah tidak diizinkan ?
      if (permissionGranted != PermissionStatus.granted) {
        print('Location permisi ditolak');
        return;
      }
    }

    // dapatkan Lokasi perangkat saya ketika diizinkan
    locationData = await location.getLocation();

    // Dapatkan Latlng
    final latLng = LatLng(locationData.latitude!, locationData.longitude!);

    /// dapatkan info dari GeoCoding untuk dapatkan info coordinat latlang kita,
    /// lalu tentukan place nya, jalan, dan alamat
    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    final place = info[0];
    final street = place.street;
    final address =
        "${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";

    placemark = place;
    notifyListeners();

    defineMarker(latLng, street!, address);

    mapController.animateCamera(CameraUpdate.newLatLng(latLng));
  }

  /// definisikan marker sesuai lokasi kita
  void defineMarker(LatLng latLng, String street, String address) {
    final marker = Marker(
      markerId: const MarkerId('Source'),
      position: latLng,
      infoWindow: InfoWindow(
        title: street,
        snippet: address,
      ),
    );

    markers.clear();
    markers.add(marker);
    notifyListeners();
  }

  /// untuk berpindah marker
  void onLongPress(LatLng latLng) async {
    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    final place = info[0];
    final street = place.street;
    final address =
        "${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";

    placemark = place;
    notifyListeners();

    // Untuk mengetahui lokasi yang diguanakan oleh user
    defineMarker(latLng, street!, address);

    mapController.animateCamera(CameraUpdate.newLatLng(latLng));
  }
}
