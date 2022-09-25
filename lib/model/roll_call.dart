import 'dart:convert';

class RollCallModel {
  final int id;
  final DateTime date;
  final int std_id;
  final bool status;

  RollCallModel({
    required this.id,
    required this.date,
    required this.std_id,
    required this.status,
  });

  RollCallModel copyWith({
    required int id,
    required DateTime date,
    required int std_id,
    required bool status,
  }) {
    return RollCallModel(
      id: id, // this.id,
      date: date, // this.date,
      std_id: std_id, // this.std_id,
      status: status,
    );
  }

  RollCallModel merge(RollCallModel model) {
    return RollCallModel(
      id: model.id, // this.id,
      date: model.date, // this.date,
      std_id: model.std_id, // this.std_id,
      status: model.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'std_id': std_id,
      'status': status,
    };
  }

  factory RollCallModel.fromMap(Map<String, dynamic> map) {
    return RollCallModel(
        id: map['id'],
        date: map['date'],
        std_id: map['std_id'],
        status: map['status']);
  }

  String toJson() => json.encode(toMap());

  factory RollCallModel.fromJson(String source) =>
      RollCallModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RollCallModel(id: $id, date: $date, std_id: $std_id)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is RollCallModel &&
        o.id == id &&
        o.date == date &&
        o.std_id == std_id;
  }

  @override
  int get hashCode {
    return id.hashCode ^ date.hashCode ^ std_id.hashCode;
  }
}

class RollCallsModel {
  final String house;
  final int present;
  final int absent;
  final DateTime date;
  RollCallsModel({
    required this.house,
    required this.present,
    required this.absent,
    required this.date,
  });

  RollCallsModel copyWith({
    required String house,
    required int present,
    required int absent,
    required DateTime date,
  }) {
    return RollCallsModel(
      house: house, // this.house,
      present: present, // this.present,
      absent: absent, // this.absent,
      date: date, // this.date,
    );
  }

  RollCallsModel merge(RollCallsModel model) {
    return RollCallsModel(
      house: model.house, // this.house,
      present: model.present, // this.present,
      absent: model.absent, // this.absent,
      date: model.date, // this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'house': house,
      'present': present,
      'absent': absent,
      'date': date,
    };
  }

  factory RollCallsModel.fromMap(Map<String, dynamic> map) {
    return RollCallsModel(
      house: map['house'],
      present: map['present'],
      absent: map['absent'],
      date: map['date'],
    );
  }

  String toJson() => json.encode(toMap());

  factory RollCallsModel.fromJson(String source) =>
      RollCallsModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RollCallsModel(house: $house, present: $present, absent: $absent, date: $date)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is RollCallsModel &&
        o.house == house &&
        o.present == present &&
        o.absent == absent &&
        o.date == date;
  }

  @override
  int get hashCode {
    return house.hashCode ^ present.hashCode ^ absent.hashCode ^ date.hashCode;
  }
}
