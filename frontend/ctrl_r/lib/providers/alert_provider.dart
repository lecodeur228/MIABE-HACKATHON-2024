import 'package:ctrl_r/models/alert.dart';
import 'package:flutter/material.dart';

class AlertProvider extends ChangeNotifier {
  final List<Alert> _alerts = [];

  List<Alert> get alerts => _alerts;

  void loadAlerts(List<Alert> alerts) {
    _alerts.addAll(alerts);
    notifyListeners();
  }
}
