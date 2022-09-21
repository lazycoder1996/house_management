import 'dart:convert';

class ProgrammeModel {
  final String name;
  final int id;
  ProgrammeModel({
    required this.name,
    required this.id,
  });

  // ProgrammeModel({required this.name, required this.id});

  ProgrammeModel copyWith({
    required String name,
    required int id,
  }) {
    return ProgrammeModel(
      name: name,
      id: id,
    );
  }

  ProgrammeModel merge(ProgrammeModel model) {
    return ProgrammeModel(
      name: model.name,
      id: model.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
    };
  }

  factory ProgrammeModel.fromMap(Map<String, dynamic> map) {
    return ProgrammeModel(
      name: map['name'],
      id: map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProgrammeModel.fromJson(String source) =>
      ProgrammeModel.fromMap(json.decode(source));

  @override
  String toString() => 'ProgrammeModel(name: $name, id: $id)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ProgrammeModel && o.name == name && o.id == id;
  }

  @override
  int get hashCode => name.hashCode ^ id.hashCode;
}
