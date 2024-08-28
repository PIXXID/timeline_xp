library timeline_xp;

import 'package:flutter/material.dart';

import 'release_chart.dart';

class TimelineItemDetail extends StatelessWidget {
  const TimelineItemDetail({
    super.key,
    required this.colors,
    required this.timelineDetailHeight,
    required this.days,
    required this.centerItemIndex,
    required this.isMultiproject,
  });

  final Map<String, Color> colors;
  final double timelineDetailHeight;
  final List days;
  final int centerItemIndex;
  final bool isMultiproject;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      if (!isMultiproject)
        Padding(
            padding: EdgeInsets.fromLTRB(15, (timelineDetailHeight / 2) - 10,
                15, (timelineDetailHeight / 2) - 11),
            child: Row(children: [
              if (days[centerItemIndex]['stages'] != null &&
                  days[centerItemIndex]['stages'].length > 0)
                Row(children: [
                  Text(
                    'Release ${days[centerItemIndex]['stages'][0]['releaseLabel']}',
                    style: TextStyle(color: colors['primaryText']),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: ReleaseChart(
                        colors: colors,
                        releaseProgress: days[centerItemIndex]['stages'][0]
                            ['releaseProgress']),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 25, right: 15),
                      child: Icon(
                        Icons.circle_rounded,
                        size: 10,
                        color: colors['accent2'],
                      )),
                ]),
              Text(
                '${days[centerItemIndex]['activityCompleted'] ?? 0}/${days[centerItemIndex]['activityTotal'] ?? 0} act.  ${days[centerItemIndex]['delivrableCompleted'] ?? 0}/${days[centerItemIndex]['delivrableTotal'] ?? 0} liv.',
                style: TextStyle(color: colors['primaryText']),
              )
            ])),
      Container(height: 1, color: colors['accent2']),
    ]);
  }
}