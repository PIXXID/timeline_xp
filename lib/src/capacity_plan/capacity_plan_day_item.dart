import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CapacityPlanDayItem extends StatelessWidget {
  const CapacityPlanDayItem(
      {super.key,
      required this.colors,
      required this.lang,
      required this.day,
      required this.updateCapacity});

  final Map<String, Color> colors;
  final String lang;
  final dynamic day;
  final Function(dynamic)? updateCapacity;

  @override
  Widget build(BuildContext context) {
    return Text('ok');
  }
}