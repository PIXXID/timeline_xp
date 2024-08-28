library timeline_xp;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimelineItem extends StatelessWidget {
  const TimelineItem(
      {super.key,
      required this.colors,
      required this.index,
      required this.centerItemIndex,
      required this.days,
      required this.dayWidth,
      required this.dayMargin,
      required this.height,
      required this.isMultiproject,
      this.project,
      required this.openDayDetail});

  final Map<String, Color> colors;
  final int index;
  final int centerItemIndex;
  final List days;
  final double dayWidth;
  final double dayMargin;
  final double height;
  final bool isMultiproject;
  final dynamic project;
  final Function(String, String?)? openDayDetail;

  @override
  Widget build(BuildContext context) {
    DateTime date = days[index]['date'];

    return Align(
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
            // Call back lors du clic
            onTap: () => {
                  openDayDetail?.call(DateFormat('yyyy-MM-dd').format(date),
                      project != null ? 'OKOK' : null)
                },
            child: SizedBox(
                width: dayWidth - dayMargin,
                height: (days[index]['capacityLevelMax'] > 0
                        ? ((height * days[index]['capacityLevel']) /
                            days[index]['capacityLevelMax'])
                        : height) +
                    50,
                child: Column(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(
                            left: dayMargin / 2,
                            right: dayMargin / 2,
                            bottom: dayMargin / 3),
                        width: dayWidth - dayMargin,
                        height: (days[index]['capacityLevelMax'] > 0
                                ? ((height * days[index]['capacityLevel']) /
                                    days[index]['capacityLevelMax'])
                                : height) -
                            20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: colors['accent2'],
                        ),
                        child: Column(
                          mainAxisAlignment: days[index]['capacityLevelMax'] > 0
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.center,
                          children: [
                            if (days[index]['capacityLevelMax'] > 0)
                              Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                      width: dayWidth - dayMargin,
                                      height: days[index]['workLoadLevel'] > 0
                                          ? ((height *
                                                  days[index]
                                                      ['completedLevel']) /
                                              days[index]['workLoadLevel'])
                                          : height,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: isMultiproject
                                            ? colors['accent1']
                                            : colors['primary'],
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          if (isMultiproject)
                                            Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Container(
                                                    width: dayWidth - dayMargin,
                                                    height: days[index][
                                                                'workLoadLevel'] >
                                                            0
                                                        ? ((height *
                                                                days[index][
                                                                    'myCompletedLevel']) /
                                                            days[index][
                                                                'workLoadLevel'])
                                                        : height,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: colors['primary'],
                                                    )))
                                        ],
                                      )))
                            else
                              Center(
                                  child: Icon(Icons.sunny,
                                      color: colors['primaryBackground']))
                          ],
                        )),
                    Text(
                      DateFormat.E('fr_FR').format(date),
                      style: TextStyle(
                          color: colors['primaryText'],
                          fontWeight: centerItemIndex == index
                              ? FontWeight.w700
                              : FontWeight.w400),
                    ),
                    Text(
                      DateFormat('dd').format(date),
                      style: TextStyle(
                          color: colors['primaryText'],
                          fontWeight: centerItemIndex == index
                              ? FontWeight.w700
                              : FontWeight.w400),
                    ),
                    if (days[index]['alertLevel'] != 0)
                      Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Icon(
                            Icons.circle_rounded,
                            size: 13,
                            color: days[index]['alertLevel'] == 1
                                ? colors['warning']
                                : (days[index]['alertLevel'] == 2
                                    ? colors['error']
                                    : Colors.transparent),
                          ))
                    else
                      Container(height: 18)
                  ],
                ))));
  }
}