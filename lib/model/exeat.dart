import 'dart:convert';

class ExeatModel {
  final DateTime departure;
  final String reason;
  final String destination;
  final DateTime expectedReturn;
  final DateTime dateReturned;
  ExeatModel({
    required this.departure,
    required this.reason,
    required this.destination,
    required this.expectedReturn,
    required this.dateReturned,
  });

  ExeatModel copyWith({
    required DateTime departure,
    required String reason,
    required String destination,
    required DateTime expectedReturn,
    required DateTime dateReturned,
  }) {
    return ExeatModel(
      departure: departure,
      reason: reason,
      destination: destination,
      expectedReturn: expectedReturn,
      dateReturned: dateReturned,
    );
  }

  ExeatModel merge(ExeatModel model) {
    return ExeatModel(
      departure: model.departure,
      reason: model.reason,
      destination: model.destination,
      expectedReturn: model.expectedReturn,
      dateReturned: model.dateReturned,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'departure': departure.millisecondsSinceEpoch,
      'reason': reason,
      'destination': destination,
      'expectedReturn': expectedReturn.millisecondsSinceEpoch,
      'dateReturned': dateReturned.millisecondsSinceEpoch,
    };
  }

  factory ExeatModel.fromMap(Map<String, dynamic> map) {
    return ExeatModel(
      departure: map['depature'],
      reason: map['reason'],
      destination: map['destination'],
      expectedReturn: map['expected_return'],
      dateReturned: map['dateReturned'],
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
