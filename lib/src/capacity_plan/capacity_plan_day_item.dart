import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CapacityPlanDayItem extends StatelessWidget {
  CapacityPlanDayItem(
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
  
  OverlayEntry? _overlayEntry;

  void _showOverlay(BuildContext context, List alert) {
    final overlay = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 100.0,
        left: 50.0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            width: 300,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(12.0)),
              color: colors['primaryBackground'],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'La capacité insufisante :',
                      style: TextStyle(color: colors['primaryText']),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: GestureDetector(
                            onTap: () {
                              resetDay.call(day);
                              _removeOverlay();
                            },
                            child: Icon(
                              Icons.replay_rounded,
                              size: 18,
                              color: colors['primaryText']
                            )
                          )
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: GestureDetector(
                            onTap: () => _removeOverlay(),
                            child: Icon(
                              Icons.close_rounded,
                              size: 18,
                              color: colors['primaryText']
                            )
                          )
                        ),
                      ]
                    )
                  ]
                ),
                for (var alert in day['alerts'])
                  Row(children: [
                    Container(
                      child: Text(
                      '${alert['prj_name']}',
                      style: TextStyle(color: colors['primaryText']),
                    )),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: alert['prj_color']
                        )
                      )
                    ),
                  ],
                )
              ],
            )
          ),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    double dayHeight = (height - 20) / maxEffortTotal;

    return SizedBox(
      width: daySize,
      height: maxEffortTotal * dayHeight,
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
                  height: dayHeight,
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
          if (day['alerts'] != null && day['alerts'].length > 0)
            GestureDetector(
              onTap: () => _showOverlay(context, day['alerts']),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: FaIcon(
                  FontAwesomeIcons.circleExclamation,
                  size: 20,
                  color: colors['error']
                )
              )
            )
        ]
      )
    );
  }
}