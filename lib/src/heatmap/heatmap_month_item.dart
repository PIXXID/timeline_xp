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
      required this.selectedDate,
      required this.elements,
      required this.openDayDetail});

  final double daySize;
  final String lang;
  final Map<String, Color> colors;
  final int index;
  final List months;
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
          height: (daySize + dayMargin) * 7,
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: weeksNumber,
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(width: dayMargin);
              },
              itemBuilder: (BuildContext context, int weekIndex) {
                return SizedBox(
                  height: daySize * 7,
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
                            selectedDate: selectedDate,
                            elements: elements,
                            openDayDetail: openDayDetail),
                      SizedBox(height: dayMargin),
                      // Samedi
                      if (months[index]['weeks'][weekIndex]['Sat'].isEmpty)
                        emptyContainer
                      else
                        HeatmapDayItem(
                            daySize: daySize,
                            lang: lang,
                            colors: colors,
                            day: months[index]['weeks'][weekIndex]['Sat'],
                            selectedDate: selectedDate,
                            elements: elements,
                            openDayDetail: openDayDetail),
                      SizedBox(height: dayMargin),
                      // Dimanche
                      if (months[index]['weeks'][weekIndex]['Sun'].isEmpty)
                        emptyContainer
                      else
                        HeatmapDayItem(
                            daySize: daySize,
                            lang: lang,
                            colors: colors,
                            day: months[index]['weeks'][weekIndex]['Sun'],
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
