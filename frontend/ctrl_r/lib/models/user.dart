class User {
  final int id;
  final String name;
  final String email;
  final String contact;
  final String token;
  final String matricule;
  final String role;
  User({
    required this.token,
    required this.id,
    required this.name,
    required this.email,
    required this.contact,
    required this.matricule,
    required this.role,
  });

  factory User.fromJson(
      Map<String, dynamic> json, String token, String matrcile,String role) {
    return User(
      token: token,
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      contact: json['contact'] ?? '',
      matricule: matrcile ,
      role: role,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'id': id,
      'name': name,
      'email': email,
      'contact': contact,
      'matricule': matricule,
      'role': role,
    };
  }
}
