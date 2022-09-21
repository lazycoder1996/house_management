import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as m;

parseColor(String color) {
  switch (color.toLowerCase()) {
    case "red":
      return Colors.red;
    case "yellow":
      return Colors.yellow;
    case "green":
      return Colors.green;
    case "grey":
      return m.Colors.grey;
    case "blue":
      return Colors.blue;
  }
}
