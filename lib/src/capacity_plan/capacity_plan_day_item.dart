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
  
  OverlayEntry? _overlayEntry;
  
  void _showOverlay(BuildContext context, List alert) {
    final overlay = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 100.0,
        left: 50.0,
        child: Container(
            padding: const EdgeInsets.all(10.0),
            width: 300,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(12.0)),
              color: widget.colors['primaryBackground'],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'La capacité insufisante :',
                      style: TextStyle(
                        fontSize: 14,
                        color: widget.colors['primaryText']
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: GestureDetector(
                            onTap: () {
                              widget.resetDay.call(widget.day);
                              _removeOverlay();
                            },
                            child: Icon(
                              Icons.replay_rounded,
                              size: 18,
                              color: widget.colors['primaryText']
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
                              color: widget.colors['primaryText']
                            )
                          )
                        ),
                      ]
                    )
                  ]
                ),
                for (var alert in widget.day['alerts'])
                  Row(children: [
                    Text(
                      '${alert['prj_name']}',
                      style: TextStyle(
                        fontSize: 14,
                        color: widget.colors['primaryText']
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          color: formatStringToColor(alert['prj_color'].toString())
                        )
                      )
                    ),
                  ],
                )
              ],
            )
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
    double dayHeight = (widget.height - 20) / widget.maxEffortTotal;

    return Opacity(
      opacity: widget.day['readOnly'] ? 0.6 : 1,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        width: widget.daySize - 20,
        child: Column(
          verticalDirection: VerticalDirection.up,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(DateFormat.MMM(widget.lang).format(widget.day['date']).toUpperCase(),
              style: TextStyle(
                color: widget.colors['primaryText'],
                fontWeight: FontWeight.w600,
                fontSize: 10,
              )),
            Text('${DateFormat.E(widget.lang).format(widget.day['date'])[0].toUpperCase()} ${DateFormat.d(widget.lang).format(widget.day['date'])}',
              style: TextStyle(
                color: widget.colors['primaryText'],
                fontWeight: FontWeight.w600,
                fontSize: 10,
              )),
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
            if (widget.day['alerts'] != null && widget.day['alerts'].length > 0)
              GestureDetector(
                onTap: () => _showOverlay(context, widget.day['alerts']),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: FaIcon(
                    FontAwesomeIcons.circleExclamation,
                    size: 20,
                    color: widget.colors['error']
                  )
                )
              )
          ]
        )
      )
    );
  }
}