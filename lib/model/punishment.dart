import 'dart:convert';

class PunishmentModel {
  final int id;
  final int std_id;
  final DateTime date_issued;
  final String cause;
  final String punishment;
  final int working_days;
  final String status;

  PunishmentModel({
    required this.id,
    required this.std_id,
    required this.date_issued,
    required this.cause,
    required this.punishment,
    required this.working_days,
    required this.status,
  });

  PunishmentModel copyWith({
    required int id,
    required int std_id,
    required DateTime date_issued,
    required String cause,
    required String punishment,
    required int working_days,
    required String status,
  }) {
    return PunishmentModel(
      id: id, // this.id,
      std_id: std_id, // this.std_id,
      date_issued: date_issued, // this.date_issued,
      cause: cause, // this.cause,
      punishment: punishment, // this.punishment,
      working_days: working_days, // this.working_days,
      status: status, // this.status,
    );
  }

  PunishmentModel merge(PunishmentModel model) {
    return PunishmentModel(
      id: model.id, // this.id,
      std_id: model.std_id, // this.std_id,
      date_issued: model.date_issued, // this.date_issued,
      cause: model.cause, // this.cause,
      punishment: model.punishment, // this.punishment,
      working_days: model.working_days, // this.working_days,
      status: model.status, // this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'std_id': std_id,
      'date_issued': date_issued.millisecondsSinceEpoch,
      'cause': cause,
      'punishment': punishment,
      'working_days': working_days,
      'status': status,
    };
  }

  factory PunishmentModel.fromMap(Map<String, dynamic> map) {
    return PunishmentModel(
      id: map['id'],
      std_id: map['std_id'],
      date_issued: map['date_issued'],
      cause: map['cause'],
      punishment: map['punishment'],
      working_days: map['working_days'],
      status: map['status'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PunishmentModel.fromJson(String source) =>
      PunishmentModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PunishmentModel(id: $id, std_id: $std_id, date_issued: $date_issued, cause: $cause, punishment: $punishment, working_days: $working_days, status: $status)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is PunishmentModel &&
        o.id == id &&
        o.std_id == std_id &&
        o.date_issued == date_issued &&
        o.cause == cause &&
        o.punishment == punishment &&
        o.working_days == working_days &&
        o.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        std_id.hashCode ^
        date_issued.hashCode ^
        cause.hashCode ^
        punishment.hashCode ^
        working_days.hashCode ^
        status.hashCode;
  }
}
