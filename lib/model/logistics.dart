import 'dart:convert';

import 'package:flutter/foundation.dart';

class LogisticsModel {
  final DateTime date;
  final String name;
  final String house;
  final List<String>? items;

  LogisticsModel({
    required this.date,
    required this.items,
    required this.name,
    required this.house,
  });

  LogisticsModel copyWith({
    required DateTime date,
    required List<String> items,
    required String name,
    required String house,
  }) {
    return LogisticsModel(
      date: date,
      items: items,
      name: name,
      house: house,
    );
  }

  LogisticsModel merge(LogisticsModel model) {
    return LogisticsModel(
      date: model.date,
      items: model.items,
      name: model.name,
      house: model.house,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'items': items,
      'house': house,
      'name': house,
    };
  }

  factory LogisticsModel.fromMap(Map<String, dynamic> map) {
    return LogisticsModel(
      date: map['date'],
      items: List<String>.from(map['items'] ?? []),
      name: map['name'],
      house: map['house'],
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
