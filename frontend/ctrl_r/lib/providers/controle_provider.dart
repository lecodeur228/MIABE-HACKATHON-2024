import 'package:ctrl_r/models/controle.dart';
import 'package:flutter/foundation.dart';

class ControleProvider extends ChangeNotifier {
  final List<Controle> _controles = [];

  List<Controle> get controles => _controles;
  void loadControles(List<Controle> value) {
    // print("provider data : ${value[1].matricule}");
    _controles.addAll(value);
    notifyListeners();
  }

  List<Controle> searchControles(String query) {
    // Filtrer les contrôles en fonction du critère de recherche
    return _controles.where((controle) {
      // Recherchez exactement la correspondance de la plaque d'immatriculation
      return controle.plaque.toUpperCase() == query.toUpperCase();
    }).toList();
  }
}
