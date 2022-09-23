import 'dart:convert';

class ExeatModel {
  final int id;
  final DateTime departure;
  final String name;
  final String reason;
  final String destination;
  final DateTime expectedReturn;
  final DateTime? dateReturned;
  ExeatModel({
    required this.id,
    required this.name,
    required this.departure,
    required this.reason,
    required this.destination,
    required this.expectedReturn,
    this.dateReturned,
  });

  ExeatModel copyWith({
    required int id,
    required String name,
    required DateTime departure,
    required String reason,
    required String destination,
    required DateTime expectedReturn,
    DateTime? dateReturned,
  }) {
    return ExeatModel(
      id: id,
      name: name,
      departure: departure,
      reason: reason,
      destination: destination,
      expectedReturn: expectedReturn,
      dateReturned: dateReturned,
    );
  }

  ExeatModel merge(ExeatModel model) {
    return ExeatModel(
      id: model.id,
      name: model.name,
      departure: model.departure,
      reason: model.reason,
      destination: model.destination,
      expectedReturn: model.expectedReturn,
      dateReturned: model.dateReturned,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'departure': departure,
      'reason': reason,
      'destination': destination,
      'expected_return': expectedReturn,
      'date_returned': dateReturned,
    };
  }

  factory ExeatModel.fromMap(Map<String, dynamic> map) {
    return ExeatModel(
      id: map['id'],
      name: map['name'],
      departure: map['date_issued'],
      reason: map['reason'],
      destination: map['destination'],
      expectedReturn: map['expected_return'],
      dateReturned: map['date_returned'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ExeatModel.fromJson(String source) =>
      ExeatModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ExeatModel(departure: $departure, reason: $reason, destination: $destination, expectedReturn: $expectedReturn, dateReturned: $dateReturned)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ExeatModel &&
        o.departure == departure &&
        o.reason == reason &&
        o.destination == destination &&
        o.expectedReturn == expectedReturn &&
        o.dateReturned == dateReturned;
  }

  @override
  int get hashCode {
    return departure.hashCode ^
        reason.hashCode ^
        destination.hashCode ^
        expectedReturn.hashCode ^
        dateReturned.hashCode;
  }
}
