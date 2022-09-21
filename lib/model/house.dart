import 'dart:convert';

class HouseModel {
  final int id;
  final String color;
  final String name;
  HouseModel({
    required this.id,
    required this.color,
    required this.name,
  });

  // HouseModel({required this.id, required this.color, required this.name});

  HouseModel copyWith({
    required int id,
    required String color,
    required String name,
  }) {
    return HouseModel(
      id: id,
      color: color,
      name: name,
    );
  }

  HouseModel merge(HouseModel model) {
    return HouseModel(
      id: model.id,
      color: model.color,
      name: model.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'house_id': id,
      'color': color,
      'name': name,
    };
  }

  factory HouseModel.fromMap(Map<String, dynamic> map) {
    return HouseModel(
      id: map['house_id'],
      color: map['color'],
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory HouseModel.fromJson(String source) =>
      HouseModel.fromMap(json.decode(source));

  @override
  String toString() => 'HouseModel(id: $id, color: $color, name: $name)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is HouseModel && o.id == id && o.color == color && o.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ color.hashCode ^ name.hashCode;
}
