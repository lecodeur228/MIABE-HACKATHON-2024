import 'package:ctrl_r/helpers/date_helper.dart';

class Alert {
  final int id;
  final int userId;
  final String plaque;
  final String motif;
  final String description;
  final String createdAt;

  Alert({
    required this.id,
    required this.userId,
    required this.plaque,
    required this.motif,
    required this.description,
    required this.createdAt,
  });

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json['id'] as int,
      userId: int.parse( json['user_id']),
      plaque: json['plaque'] as String,
      motif: json['motif'] as String,
      description: json['description'] as String,
      createdAt: DateHelper.formatTimestamp(json['created_at'] as String),
    );
  }
}
