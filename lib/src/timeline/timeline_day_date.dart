import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimelineDayDate extends StatefulWidget {
  final Map<String, Color> colors;
  final String lang;
  final int index;
  final int centerItemIndex;
  final int nowIndex;
  final List days;
  final double dayWidth;
  final double dayMargin;
  final double height;

  const TimelineDayDate(
      {super.key,
      required this.colors,
      required this.lang,
      required this.index,
      required this.centerItemIndex,
      required this.nowIndex,
      required this.days,
      required this.dayWidth,
      required this.dayMargin,
      required this.height});

  @override
  State<TimelineDayDate> createState() => _TimelineDayDate();
}

class _TimelineDayDate extends State<TimelineDayDate>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    dynamic day = widget.days[widget.index];
    dynamic colors = widget.colors;
    double margin = widget.dayMargin;

    final DateTime date = day['date'];
    Color dayTextColor = colors['primaryText'] ?? Colors.white;

    // Gestion de l'affichage des dates en fonction de la la date au centre.
    int idxCenter = widget.centerItemIndex - widget.index;
    if (idxCenter == 0) {
      dayTextColor = colors['primaryText']!;
    } else if ((idxCenter >= 1 && idxCenter < 4) ||
        (idxCenter <= -1 && idxCenter > -4)) {
      dayTextColor = colors['secondaryText']!;
    } else if ((idxCenter >= 4 && idxCenter < 6) ||
        (idxCenter <= -4 && idxCenter > -6)) {
      dayTextColor = colors['accent1']!;
    } else {
      dayTextColor = Colors.transparent;
    }

    return Align(
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
            child: SizedBox(
                width: widget.dayWidth - margin,
                height: widget.height,
                child: Column(
                  children: <Widget>[
                    // Dates
                    Text(
                      DateFormat.E(widget.lang)
                          .format(date)
                          .toUpperCase()
                          .substring(0, 1),
                      style: TextStyle(
                          color: dayTextColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      DateFormat('dd').format(date),
                      style: TextStyle(
                          color: dayTextColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                    // Météo
                    if (day['eicon'] != null)
                      Padding(
                          padding: const EdgeInsets.only(top: 3, bottom: 5),
                          child: Text(
                            '${day['eicon']}',
                            style: TextStyle(
                              color: colors['primaryText'],
                              fontWeight: FontWeight.w300,
                              fontSize: 12,
                            ),
                          ))
                    else
                      Container(height: 28),
                  ],
                ))));
  }
}
