import 'package:tcc_app/models/plant.dart';
import 'package:tcc_app/models/user.dart';

class Cultivation {
  int? id;
  final String name;
  final User user;
  final Plant plant;

  Cultivation({
    this.id,
    required this.name,
    required this.user,
    required this.plant,
  });

  factory Cultivation.fromJson(Map<String, dynamic> json) {
    return Cultivation(
      id: json['id'] as int?,
      name: json['name'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      plant: Plant.fromJson(json['plant'] as Map<String, dynamic>),
    );
  }

  static List<Cultivation> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Cultivation.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson({bool forCreation = false}) {
    return {
      'id': id,
      'name': name,
      'user': user.id,
      'plant': plant.id,
    };
  }
}
