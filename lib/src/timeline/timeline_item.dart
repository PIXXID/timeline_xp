import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimelineItem extends StatelessWidget {
  const TimelineItem(
      {super.key,
      required this.colors,
      required this.lang,
      required this.index,
      required this.centerItemIndex,
      required this.nowIndex,
      required this.days,
      required this.dayWidth,
      required this.dayMargin,
      required this.height,
      required this.openDayDetail});

  final Map<String, Color> colors;
  final String lang;
  final int index;
  final int centerItemIndex;
  final int nowIndex;
  final List days;
  final double dayWidth;
  final double dayMargin;
  final double height;
  final Function(String, double?)? openDayDetail;

  @override
  Widget build(BuildContext context) {
    DateTime date = days[index]['date'];

    double dayProgress = 0;
    if (days[index] != null &&
        days[index]['busyEffort'] != null &&
        days[index]['busyEffort'] > 0) {
      dayProgress =
          100 * days[index]['completedEffort'] / days[index]['busyEffort'];
    }

    return Align(
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
            // Call back lors du clic
            onTap: () => {
                  openDayDetail?.call(
                      DateFormat('yyyy-MM-dd').format(date), dayProgress)
                },
            child: SizedBox(
                width: dayWidth - dayMargin,
                height: (days[index]['capacityLevelMax'] > 0
                        ? ((height * days[index]['capacityEffort']) /
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
                                ? ((height * days[index]['capacityEffort']) /
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
                                    height: days[index]['busyEffort'] > 0
                                        ? ((height *
                                                days[index]
                                                    ['completedEffort']) /
                                            days[index]['busyEffort'])
                                        : height,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: colors['primary'],
                                    ),
                                  ))
                            else
                              Center(
                                  child: Icon(Icons.sunny,
                                      color: colors['primaryBackground']))
                          ],
                        )),
                    Text(
                      DateFormat.E(lang).format(date),
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
                    if (index == nowIndex)
                      Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Icon(
                            Icons.circle_rounded,
                            size: 13,
                            color: colors['accent2'],
                          ))
                    else if (days[index]['alertLevel'] != 0)
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
