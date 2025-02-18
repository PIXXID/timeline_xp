import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Tools
import 'package:timeline_xp/src/tools/tools.dart';

class CapacityPlanDayItem extends StatefulWidget {
  const CapacityPlanDayItem(
      {super.key,
      required this.colors,
      required this.lang,
      required this.daySize,
      required this.height,
      required this.maxEffortTotal,
      required this.day,
      required this.resetDay,
      required this.updateDay});

  final Map<String, Color> colors;
  final String lang;
  final double daySize;
  final double height;
  final int maxEffortTotal;
  final dynamic day;
  final Function(Map<String, dynamic>) resetDay;
  final Function(Map<String, dynamic>, int) updateDay;

  @override
  State<CapacityPlanDayItem> createState() => _CapacityPlanDayItemState();
}

class _CapacityPlanDayItemState extends State<CapacityPlanDayItem> {
  
  @override
  Widget build(BuildContext context) {
    double dayHeight = (widget.height - 20) / widget.maxEffortTotal;

    debugPrint('${widget.day}');

    return Opacity(
      opacity: widget.day['readOnly'] ? 0.5 : 1,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        width: widget.daySize - 20,
        child: Column(
          verticalDirection: VerticalDirection.up,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('${DateFormat.MMM(widget.lang).format(widget.day['date']).toUpperCase().substring(0, 3)}.',
              style: TextStyle(
                color: widget.colors['primaryText'],
                fontWeight: FontWeight.w600,
                fontSize: 10,
              )),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text('${DateFormat.E(widget.lang).format(widget.day['date'])[0].toUpperCase()} ${DateFormat.d(widget.lang).format(widget.day['date'])}',
                style: TextStyle(
                  color: widget.colors['primaryText'],
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ))),
            if (widget.day['hours'].length > 0)
              for (int index = 0; index < widget.day['hours'].length; index++)
                GestureDetector(
                  // Call back lors du clic
                  onTap: () {
                    if (!widget.day['readOnly']) {
                        widget.updateDay.call(widget.day, index);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1.0),
                    child: Container(
                      width: widget.daySize,
                      height: dayHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(index == widget.day['hours'].length - 1 ? 6.0 : 0.0),
                          topRight: Radius.circular(index == widget.day['hours'].length - 1 ? 6.0 : 0.0),
                          bottomLeft: Radius.circular(index == 0 ? 6.0 : 0.0),
                          bottomRight: Radius.circular(index == 0 ? 6.0 : 0.0)),
                        color: formatStringToColor(widget.day['hours'][index]['prj_color'].toString()),
                      ),
                    )
                  )
                ),
            if (widget.day['hours'].length == 0)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 1.0),
                child: Container(
                  width: widget.daySize,
                  height: widget.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(6.0)
                    ),
                    color: widget.colors['secondaryBackground'],
                  ),
                  child: Icon(Icons.sunny,
                      color: widget.colors['secondaryText'],
                      size: 14)
                )
              ),
          ]
        )
      )
    );
  }
}