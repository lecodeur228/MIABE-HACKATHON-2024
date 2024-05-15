class Controle {
  final int id;
  final String plaque;
  final String nomConducteur;
  final int permitConduire;
  final int dateValiditeCarteGrise;
  final DateTime? dateExpiration;
  final int carteVisiteTechnique;
  final int assurance;
  final int tvm;
  final String matricule;
  final String longitude;
  final String latitude;
  final DateTime createdAt;

  Controle({
    required this.id,
    required this.plaque,
    required this.nomConducteur,
    required this.permitConduire,
    required this.dateValiditeCarteGrise,
    required this.dateExpiration,
    required this.carteVisiteTechnique,
    required this.assurance,
    required this.tvm,
    required this.matricule,
    required this.longitude,
    required this.latitude,
    required this.createdAt,
  });

  factory Controle.fromJson(Map<String, dynamic> json) {
    return Controle(
      id: json['id'] == null
          ? 0
          : json['id'] is String
              ? int.parse(json['id'])
              : json['id'],
      plaque: json['plaque'],
      nomConducteur: json['nom_conducteur'],
      permitConduire: json['permit_conduire'] is String
          ? int.parse(json['permit_conduire'])
          : json['permit_conduire'],
      dateValiditeCarteGrise: json['date_validite_carte_grise'] is String
          ? int.parse(json['date_validite_carte_grise'])
          : json['date_validite_carte_grise'],
      dateExpiration: json['date_expiration'] != null
          ? DateTime.parse(json['date_expiration'])
          : null,
      carteVisiteTechnique: json['carte_visite_technique'] is String
          ? int.parse(json['carte_visite_technique'])
          : json['carte_visite_technique'],
      assurance: json['assurance'] is String
          ? int.parse(json['assurance'])
          : json['assurance'],
      tvm: json['tvm'] is String ? int.parse(json['tvm']) : json['tvm'],
      matricule: json['matricule'] ?? "00000",
      longitude: json['longitude'],
      latitude: json['latitude'],
      createdAt: json['created_at'] != null?  DateTime.parse(json['created_at']) : DateTime.parse("2024-01-02"),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['plaque'] = plaque;
    data['nom_conducteur'] = nomConducteur;
    data['permit_conduire'] = permitConduire;
    data['date_validite_carte_grise'] = dateValiditeCarteGrise;
    data['date_expiration'] = dateExpiration?.toIso8601String();
    data['carte_visite_technique'] = carteVisiteTechnique;
    data['assurance'] = assurance;
    data['tvm'] = tvm;
    data['matricule'] = matricule;
    data['longitude'] = longitude;
    data["latitude"] = latitude;
    data['created_at'] = createdAt.toIso8601String();
    return data;
  }
}
