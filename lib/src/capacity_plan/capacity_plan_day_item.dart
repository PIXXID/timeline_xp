import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CapacityPlanDayItem extends StatelessWidget {
  const CapacityPlanDayItem(
      {super.key,
      required this.colors,
      required this.lang,
      required this.height,
      required this.day,
      required this.updateDay});

  final Map<String, Color> colors;
  final String lang;
  final double height;
  final dynamic day;
  final Function(Map<String, dynamic>, int) updateDay;

  final double daySize = 25;
  
  @override
  Widget build(BuildContext context) {
    final double daySize = (height / 7) - 20;

    return Container(
      width: daySize + 10,
      height: day['upl_effort_total'] * (daySize + 6),
      child: Column(
        verticalDirection: VerticalDirection.up,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(DateFormat.MMM(lang).format(day['date']).toUpperCase(),
            style: TextStyle(
              color: colors['primaryText'],
              fontWeight: FontWeight.w600,
              fontSize: 10,
            )),
          Text('${DateFormat.E(lang).format(day['date'])[0].toUpperCase()} ${DateFormat.d(lang).format(day['date'])}',
            style: TextStyle(
              color: colors['primaryText'],
              fontWeight: FontWeight.w600,
              fontSize: 10,
            )),
          for (int index = 0; index < day['hours'].length; index++)
            GestureDetector(
              // Call back lors du clic
              onTap: () => {
                updateDay.call(day, index)
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 1.0),
                child: Container(
                  width: daySize,
                  height: 25.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(index == day['hours'].length - 1 ? 6.0 : 0.0),
                      topRight: Radius.circular(index == day['hours'].length - 1 ? 6.0 : 0.0),
                      bottomLeft: Radius.circular(index == 0 ? 6.0 : 0.0),
                      bottomRight: Radius.circular(index == 0 ? 6.0 : 0.0)),
                    color: day['hours'][index]['prj_color'],
                  ),
                )
              )
            ),
          if (day['alert'])
            Container(
              width: 10,
              height: 10,
              color: Colors.red
            )
        ]
      )
    );
  }
}