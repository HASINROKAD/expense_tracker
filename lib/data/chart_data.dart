import 'package:flutter/material.dart';

class ChartData {
  const ChartData(this.date, this.value, this.color, this.category);

  final String date;
  final double value;
  final Color color;
  final String category;
}