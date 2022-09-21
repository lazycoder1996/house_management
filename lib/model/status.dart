import 'dart:convert';

class StatusModel {
  final int id;
  final String status;
  StatusModel({
    required this.id,
    required this.status,
  });
  // StatusModel({required this.id, required this.status});

  StatusModel copyWith({
    required int id,
    required String status,
  }) {
    return StatusModel(
      id: id,
      status: status,
    );
  }

  StatusModel merge(StatusModel model) {
    return StatusModel(
      id: model.id,
      status: model.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status,
    };
  }

  factory StatusModel.fromMap(Map<String, dynamic> map) {
    return StatusModel(
      id: map['id'],
      status: map['status'],
    );
  }

  String toJson() => json.encode(toMap());

  factory StatusModel.fromJson(String source) =>
      StatusModel.fromMap(json.decode(source));

  @override
  String toString() => 'StatusModel(id: $id, status: $status)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is StatusModel && o.id == id && o.status == status;
  }

  @override
  int get hashCode => id.hashCode ^ status.hashCode;
}
