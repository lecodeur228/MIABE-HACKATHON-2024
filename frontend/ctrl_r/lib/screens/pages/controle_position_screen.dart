import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ctrl_r/models/controle.dart';

class ControlePositionScreen extends StatefulWidget {
  final Controle controle;
  final Color color;
  const ControlePositionScreen(
      {super.key, required this.controle, required this.color});

  @override
  State<ControlePositionScreen> createState() => _ControlePositionScreenState();
}

class _ControlePositionScreenState extends State<ControlePositionScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Endroid du contrôle"),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(double.parse(widget.controle.latitude),
                  double.parse(widget.controle.longitude)),
              zoom: 15,
            ),
            markers: {
              Marker(
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue),
                markerId: MarkerId(widget.controle.id.toString()),
                position: LatLng(double.parse(widget.controle.latitude),
                    double.parse(widget.controle.longitude)),
                infoWindow: InfoWindow(
                  title: widget.controle.plaque,
                  snippet: widget.controle.nomConducteur,
                ),
              ),
            },
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informations du contrôle',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Plaque: ${widget.controle.plaque}'),
                    Text('Nom du conducteur: ${widget.controle.nomConducteur}'),
                    // Ajoutez d'autres informations du contrôle ici
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
