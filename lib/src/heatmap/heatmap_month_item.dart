import 'package:flutter/material.dart';

import 'heatmap_day_item.dart';

class HeatmapMonthItem extends StatelessWidget {
  const HeatmapMonthItem(
      {super.key,
      required this.daySize,
      required this.lang,
      required this.colors,
      required this.index,
      required this.months,
      required this.selectDay,
      required this.selectedDate,
      required this.elements,
      required this.openDayDetail});

  final double daySize;
  final String lang;
  final Map<String, Color> colors;
  final int index;
  final List months;
  final Function(String?)? selectDay;
  final String? selectedDate;
  final List elements;
  final Function(String, double?, List<String>?, List<dynamic>)? openDayDetail;

  @override
  Widget build(BuildContext context) {
    int weeksNumber = 5;

    if (months[index]['weeks'] != null) {
      weeksNumber = months[index]['weeks'].length;
    }

    double dayMargin = daySize / 10;

    Widget emptyContainer =
        Container(width: daySize, height: daySize, color: colors['accent2']);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          '${months[index]['label'].toUpperCase()}',
          textAlign: TextAlign.left,
          style: TextStyle(
            color: colors['primaryText'],
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
      SizedBox(
          width: ((weeksNumber * daySize) + ((weeksNumber - 1) * (dayMargin)))
              .toDouble(),
          height: (daySize + dayMargin) * 5,
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: weeksNumber,
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(width: dayMargin);
              },
              itemBuilder: (BuildContext context, int weekIndex) {
                return SizedBox(
                  height: daySize * 5, // 5 Lignes
                  child: Column(
                    children: [
                      // Lundi
                      if (months[index]['weeks'][weekIndex]['Mon'].isEmpty)
                        emptyContainer
                      else
                        HeatmapDayItem(
                            daySize: daySize,
                            lang: lang,
                            colors: colors,
                            day: months[index]['weeks'][weekIndex]['Mon'],
                            selectDay: selectDay,
                            selectedDate: selectedDate,
                            elements: elements,
                            openDayDetail: openDayDetail),
                      SizedBox(height: dayMargin),
                      // Mardi
                      if (months[index]['weeks'][weekIndex]['Tue'].isEmpty)
                        emptyContainer
                      else
                        HeatmapDayItem(
                            daySize: daySize,
                            lang: lang,
                            colors: colors,
                            day: months[index]['weeks'][weekIndex]['Tue'],
                            selectDay: selectDay,
                            selectedDate: selectedDate,
                            elements: elements,
                            openDayDetail: openDayDetail),
                      SizedBox(height: dayMargin),
                      // Mercredi
                      if (months[index]['weeks'][weekIndex]['Wed'].isEmpty)
                        emptyContainer
                      else
                        HeatmapDayItem(
                            daySize: daySize,
                            lang: lang,
                            colors: colors,
                            day: months[index]['weeks'][weekIndex]['Wed'],
                            selectDay: selectDay,
                            selectedDate: selectedDate,
                            elements: elements,
                            openDayDetail: openDayDetail),
                      SizedBox(height: dayMargin),
                      // Jeudi
                      if (months[index]['weeks'][weekIndex]['Thu'].isEmpty)
                        emptyContainer
                      else
                        HeatmapDayItem(
                            daySize: daySize,
                            lang: lang,
                            colors: colors,
                            day: months[index]['weeks'][weekIndex]['Thu'],
                            selectDay: selectDay,
                            selectedDate: selectedDate,
                            elements: elements,
                            openDayDetail: openDayDetail),
                      SizedBox(height: dayMargin),
                      // Vendredi
                      if (months[index]['weeks'][weekIndex]['Fri'].isEmpty)
                        emptyContainer
                      else
                        HeatmapDayItem(
                            daySize: daySize,
                            lang: lang,
                            colors: colors,
                            day: months[index]['weeks'][weekIndex]['Fri'],
                            selectDay: selectDay,
                            selectedDate: selectedDate,
                            elements: elements,
                            openDayDetail: openDayDetail),
                    ],
                  ),
                );
              }))
    ]);
  }
}
