import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_flutter/services/direction_service.dart';
import 'package:provider/provider.dart';

class DirectionScreen extends StatefulWidget {
  const DirectionScreen({super.key});

  @override
  State<DirectionScreen> createState() => _DirectionScreenState();
}

class _DirectionScreenState extends State<DirectionScreen> {
  @override
  void initState() {
    final provider = Provider.of<DirectionService>(context, listen: false);
    super.initState();
    provider.onInitState();
  }

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<DirectionService>(context);

    Widget buttonDirectionSection() {
      return Positioned(
        bottom: 16,
        right: 16,
        child: Column(
          children: [
            FloatingActionButton(
              onPressed: () async {
                setState(() {
                  service.isNavigation = false;

                  service.markers
                      .removeWhere((m) => m.markerId.value == 'myLocation');
                  service.markers.add(Marker(
                    markerId: const MarkerId('myLocation'),
                    position: service.myLocation,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed,
                    ),
                  ));
                });

                await service.setPolyline(
                  service.myLocation,
                  service.unsLocation,
                  context,
                );
              },
              child: const Icon(Icons.directions),
            ),
            const SizedBox(height: 8),
            FloatingActionButton(
              onPressed: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Bayar Billing dulu, biar jalan.. Hehehee cukup pakai credit Card Aja kok...'),
                  ),
                );
                setState(() {
                  service.isNavigation = true;
                });
              },
              child: const Icon(Icons.navigation),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            GoogleMap(
              polylines: service.polylines,
              initialCameraPosition: CameraPosition(
                target: service.myLocation,
                zoom: 18,
              ),
              markers: service.markers,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              myLocationButtonEnabled: false,
              onMapCreated: (controller) async {
                service.onInit(controller);
              },
            ),
            buttonDirectionSection(),
          ],
        ),
      ),
    );
  }
}
