import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HeatmapDayItem extends StatelessWidget {
  const HeatmapDayItem(
      {super.key,
      required this.daySize,
      required this.lang,
      required this.colors,
      required this.day,
      required this.selectDay,
      required this.selectedDate});

  final double daySize;
  final String lang;
  final Map<String, Color> colors;
  final dynamic day;
  final Function(String?)? selectDay;
  final String? selectedDate;

  @override
  Widget build(BuildContext context) {
    bool isSelected = false;
    if (selectedDate != null && day['upc_date'] != null) {
      isSelected = selectedDate == DateFormat('yyyy-MM-dd').format(day['upc_date']);
    }

    String upcDate = day['upc_date'] != null ? DateFormat.d(lang).format(day['upc_date']) : '';

    return GestureDetector(
      // Call back lors du clic
      onTap: () => {
        selectDay?.call(
          DateFormat('yyyy-MM-dd').format(day['upc_date'])
        )
      },
      child: Container(
        width: daySize,
        height: daySize,
        padding: EdgeInsets.all(isSelected ? 2.0 : 0),
        decoration: BoxDecoration(
          color: day['color'],
          border: Border.all(
            color: isSelected ? colors['warning']! : Colors.transparent,
            width: isSelected ? 2.0 : 0,
          ),
        ),
        child: Column(
          children: [
            Text(
              upcDate,
              style: TextStyle(
                  fontSize: 10,
                  color: colors['primaryText'],
                  fontWeight: FontWeight.w600
                ),
            ),
            if (day['icon'] != null)
              Padding(
                padding: const EdgeInsets.all(3),
                child: Icon(
                  // IconData(
                  //   0xe818,
                  //   fontFamily: 'Swiiipiconsfont',
                  // ),
                  Icons.warning_amber,
                  color: colors['primaryText'],
                  size: 18
                )
              )
          ]
        )
      )
    );
  }
}