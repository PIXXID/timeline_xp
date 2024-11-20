import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../shared/dotted_separator.dart';
import '../shared/hatched_background_painter.dart';

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
  final Function(String, double?, List<String>?)? openDayDetail;

  @override
  Widget build(BuildContext context) {
    DateTime date = days[index]['date'];

    // On calcule la hauteur de chaque barre
    double heightLmax = height - ((height - 70) / 3) - 70;
    double heightCapeff = 0;
    double heightBuseff = 0;
    double heightCompeff = 0;
    if (heightLmax > 0) {
      heightCapeff = (height * days[index]['capeff']) / heightLmax;
    } else if (heightLmax == 0 && days[index]['capeff'] > 0) {
      heightCapeff = height;
    }
    if (heightCapeff > 0) {
      heightBuseff = (height * days[index]['buseff']) / heightCapeff;
    } else if (heightCapeff == 0 && days[index]['buseff'] > 0) {
      heightBuseff = height;
    }
    if (heightBuseff > 0) {
      heightCompeff = (height * days[index]['compeff']) / heightBuseff;
    } else if (heightBuseff == 0 && days[index]['compeff'] > 0) {
      heightCompeff = height;
    }

    // On vérifie s'il y a un dépassement
    Widget overflow = SizedBox(width: dayWidth, height: heightLmax / 5);
    double overflowPercent = 0;
    if (heightCompeff > heightLmax) {
      overflowPercent = (heightCompeff * 100) / heightLmax;
    } else if (heightBuseff > heightLmax) {
      overflowPercent = (heightBuseff * 100) / heightLmax;
    } else if (heightCapeff > heightLmax) {
      overflowPercent = (heightCapeff * 100) / heightLmax;
    }
    if (overflowPercent > heightLmax / 5) {
      overflowPercent = heightLmax / 5;
    }
    if (overflowPercent > 0) {
      overflow = SizedBox(
        width: dayWidth,
        height: heightLmax / 5,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: dayMargin / 2),
              width: dayWidth - dayMargin - 15,
              height: overflowPercent - 5,
              decoration: BoxDecoration(
                borderRadius: overflowPercent == heightLmax / 5 ? BorderRadius.zero : const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                color: colors['error'],
              ),
              child: ClipRRect(
                borderRadius: overflowPercent == heightLmax / 5 ? BorderRadius.zero : const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                child: CustomPaint(
                  painter: HatchedBackgroundPainter(
                    color: colors['primaryText']!.withOpacity(0.3),
                  ),
                )
              )
            ),
            const SizedBox(
              height: 2
            ),
            DottedSeparator(
              color: colors['accent2']!,
              dashWidth: 5
            ),
            const SizedBox(
              height: 2
            ),
          ],
        )
      );
    }

    return Align(
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
            // Call back lors du clic
            onTap: () {
              // On calcule la progression du jour pour le renvoyer en callback
              double dayProgress = 0;
              if (days[index] != null &&
                  days[index]['buseff'] != null &&
                  days[index]['buseff'] > 0) {
                dayProgress = 100 * days[index]['compeff'] / days[index]['buseff'];
              }
              openDayDetail?.call(
                DateFormat('yyyy-MM-dd').format(date), dayProgress, (days[index]['preIds'] as List<dynamic>).cast<String>());
              },
            child: SizedBox(
                width: dayWidth - dayMargin,
                height: height,
                child: Column(
                  children: <Widget>[
                    // Dépassement
                    overflow,
                    // Barre avec données
                    SizedBox(
                      height: heightLmax,
                      child: Stack(
                        children: [
                          // Barre vide
                          if (heightCapeff == 0 && heightBuseff == 0 && heightCompeff == 0)
                            Container(
                              margin: EdgeInsets.only(
                                left: dayMargin / 2,
                                right: dayMargin / 2,
                                bottom: dayMargin / 3),
                              width: dayWidth - dayMargin - 15,
                              height: heightLmax,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: colors['accent2'],
                              ),
                              child: Center(child: Icon(Icons.sunny, color: colors['primaryBackground']))
                            )
                          else
                            // Barre de capacité
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: dayMargin / 2,
                                  right: dayMargin / 2,
                                  bottom: dayMargin / 3),
                                width: dayWidth - dayMargin - 15,
                                height: heightCapeff,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: colors['accent2'],
                                ),
                              ),
                            ),
                            // Barre de travail affecté
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: dayMargin / 2,
                                  right: dayMargin / 2,
                                  bottom: dayMargin / 3),
                                width: dayWidth - dayMargin - 16,
                                height: heightBuseff,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: colors['accent1'],
                                ),
                                child: Builder(builder: (context) {
                                  if (heightBuseff > heightCapeff) {
                                    return ClipRRect(
                                      borderRadius: overflowPercent == heightLmax / 5 ? BorderRadius.zero : const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                      child: CustomPaint(
                                        painter: HatchedBackgroundPainter(
                                          color: colors['primaryText']!.withOpacity(0.3),
                                        ),
                                      )
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                })
                              )
                            ),
                            // Barre de tavail effectué
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: dayMargin / 2,
                                  right: dayMargin / 2,
                                  bottom: dayMargin / 3),
                                width: dayWidth - dayMargin - 16,
                                height: heightCompeff,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: colors['primary'],
                                ),
                                child: Builder(builder: (context) {
                                  if (heightCompeff > heightBuseff) {
                                    return ClipRRect(
                                      borderRadius: overflowPercent == heightLmax / 5 ? BorderRadius.zero : const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                      child: CustomPaint(
                                        painter: HatchedBackgroundPainter(
                                          color: colors['primaryText']!.withOpacity(0.3),
                                        ),
                                      )
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                })
                              )
                            )
                        ]
                      ),
                    ),
                    // Dates
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
                    // Alertes
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
