import 'dart:convert';

class ItemModel {
  final int id;
  final String name;

  ItemModel({required this.id, required this.name});

  // ItemModel({required this.id, required this.name});

  ItemModel copyWith({
    required int id,
    required String name,
    required int price,
  }) {
    return ItemModel(
      id: id,
      name: name,
    );
  }

  ItemModel merge(ItemModel model) {
    return ItemModel(
      id: model.id,
      name: model.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id'],
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemModel.fromJson(String source) =>
      ItemModel.fromMap(json.decode(source));

  @override
  String toString() => 'ItemModel(id: $id, name: $name)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ItemModel && o.id == id && o.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
