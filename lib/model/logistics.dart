import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:house_management/model/student.dart';

class LogisticsModel {
  final DateTime date;
  final List<String>? items;

  LogisticsModel({
    required this.date,
    required this.items,
  });

  LogisticsModel copyWith({
    required DateTime date,
    required List<String> items,
    required StudentModel student,
  }) {
    return LogisticsModel(
      date: date,
      items: items,
    );
  }

  LogisticsModel merge(LogisticsModel model) {
    return LogisticsModel(
      date: model.date,
      items: model.items,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date.millisecondsSinceEpoch,
      'items': items,
    };
  }

  factory LogisticsModel.fromMap(Map<String, dynamic> map) {
    return LogisticsModel(
      date: map['date'],
      items: List<String>.from(map['items'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory LogisticsModel.fromJson(String source) =>
      LogisticsModel.fromMap(json.decode(source));

  @override
  String toString() => 'Logistics(date: $date, items: $items)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is LogisticsModel && o.date == date && listEquals(o.items, items);
  }

  @override
  int get hashCode => date.hashCode ^ items.hashCode;
}
