import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_flutter/services/maps_services.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  final service = MapServicesScreen();

  @override
  void initState() {
    super.initState();
    service.onInit();
  }

  @override
  Widget build(BuildContext context) {
    zoomContent() {
      return Positioned(
        bottom: 16,
        right: 16,
        child: Column(
          children: [
            FloatingActionButton.small(
              onPressed: () => service.zoom(true),
              child: const Icon(Icons.add),
            ),
            FloatingActionButton.small(
              onPressed: () => service.zoom(false),
              child: const Icon(Icons.remove),
            ),
          ],
        ),
      );
    }

    mapTypeContent() {
      PopupMenuItem<MapType> popMenuItem(String title, MapType? value) {
        return PopupMenuItem(
          value: value,
          child: Text(title),
        );
      }

      return Positioned(
        top: 16,
        right: 16,
        child: FloatingActionButton.small(
          onPressed: null,
          child: PopupMenuButton<MapType>(
            onSelected: (value) {
              setState(() {
                service.selectedMap = value;
              });
            },
            offset: const Offset(0, 54),
            icon: const Icon(Icons.layers_outlined),
            itemBuilder: (context) => [
              popMenuItem('Normal', MapType.normal),
              popMenuItem('Satellite', MapType.satellite),
              popMenuItem('Terrain', MapType.terrain),
              popMenuItem('Hybrid', MapType.hybrid),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Stack(children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: service.myLocation,
              zoom: 18,
            ),
            mapType: service.selectedMap,
            markers: service.markers,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            onMapCreated: (controller) {
              service.mapController = controller;
              setState(() {});

              service.onMapCreatedLatLngBound();
            },
          ),
          mapTypeContent(),
          zoomContent(),
        ]),
      ),
    );
  }
}
