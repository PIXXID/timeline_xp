library timeline_xp;

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ReleaseChart extends StatefulWidget {
  const ReleaseChart({
    super.key,
    required this.colors,
    required this.releaseProgress,
  });

  final Map<String, Color> colors;
  final int releaseProgress;

  @override
  State<StatefulWidget> createState() => ReleaseChartState();
}

class ReleaseChartState extends State<ReleaseChart> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 10,
        height: 10,
        child: PieChart(
          PieChartData(
            sectionsSpace: 0, // Espacement entre les sections
            centerSpaceRadius: 5,
            sections: _getSections(widget.colors, widget.releaseProgress),
          ),
        ));
  }

  List<PieChartSectionData> _getSections(colors, releaseProgress) {
    return [
      PieChartSectionData(
          color: colors['accent2'],
          value: 100,
          radius: 5, // Taille de la section
          showTitle: false),
      PieChartSectionData(
          color: colors['primary'],
          value: releaseProgress.toDouble(),
          radius: 5, // Taille de la section
          showTitle: false),
    ];
  }
}