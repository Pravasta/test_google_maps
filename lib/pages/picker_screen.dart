import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_flutter/services/picker_service.dart';
import 'package:provider/provider.dart';

class PickerScreen extends StatefulWidget {
  const PickerScreen({super.key});

  @override
  State<PickerScreen> createState() => _PickerScreenState();
}

class _PickerScreenState extends State<PickerScreen> {
  @override
  Widget build(BuildContext context) {
    final service = Provider.of<PickerServiceScreen>(context);

    Widget infoLocationSection({required Placemark placemark}) {
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white60,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.blueGrey,
              blurRadius: 20,
              offset: Offset.zero,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(placemark.street!),
                  Text(
                    '${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.postalCode}, ${placemark.country}',
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget myLocationSection() {
      return Positioned(
        top: 16,
        right: 16,
        child: FloatingActionButton(
          onPressed: () => service.onMyLocation(),
          child: const Icon(Icons.my_location_outlined),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: service.myLocation,
                zoom: 18,
              ),
              onLongPress: (argument) => service.onLongPress(argument),
              markers: service.markers,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              onMapCreated: (controller) {
                service.mapController = controller;
                service.onInit();
                setState(() {});
              },
            ),
            myLocationSection(),
            if (service.placemark == null)
              const SizedBox()
            else
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: infoLocationSection(placemark: service.placemark!),
              ),
          ],
        ),
      ),
    );
  }
}
