import 'package:ctrl_r/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider extends ChangeNotifier {
  Position? _position;

  Position? get position => _position;

  void loadPosition() async {
      Position position = await LocationService.determinePosition();
      print('User location: ${position.latitude}, ${position.longitude}');
 
      _position = position;
      notifyListeners();
    
  }
}
