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

    double heightDay = height - ((height - 70) / 3) - 72;

    // On calcule la hauteur de chaque barre
    double heightCapeff = 0;
    double heightBuseff = 0;
    double heightCompeff = 0;
    if (days[index]['lmax'] > 0) {
      heightCapeff = (heightDay * days[index]['capeff']) / days[index]['lmax'];
      heightBuseff = (heightDay * days[index]['buseff']) / days[index]['lmax'];
      heightCompeff = (heightDay * days[index]['compeff']) / days[index]['lmax'];
    } else if (days[index]['lmax'] == 0 && days[index]['capeff'] > 0) {
      heightCapeff = heightDay;
    } else if (heightCapeff == 0 && days[index]['buseff'] > 0) {
      heightBuseff = heightDay;
    } else if (heightBuseff == 0 && days[index]['compeff'] > 0) {
      heightCompeff = heightDay;
    }

    // On vérifie s'il y a un dépassement
    Widget overflow = SizedBox(width: dayWidth, height: heightDay / 5);
    double overflowPercent = 0;
    if (heightCompeff > heightDay) {
      overflowPercent = (heightCompeff * 100) / heightDay;
    } else if (heightBuseff > heightDay) {
      overflowPercent = (heightBuseff * 100) / heightDay;
    } else if (heightCapeff > heightDay) {
      overflowPercent = (heightCapeff * 100) / heightDay;
    }
    if (overflowPercent > heightDay / 5 || ((days[index]['capeff'] > 0 || days[index]['buseff'] > 0 || days[index]['compeff'] > 0) && days[index]['lmax'] == 0)) {
      overflowPercent = heightDay / 5;
    }
    if (overflowPercent > 0) {
      overflow = SizedBox(
        width: dayWidth,
        height: heightDay / 5,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: dayMargin / 2),
              width: dayWidth - dayMargin - 15,
              height: overflowPercent - 5,
              decoration: BoxDecoration(
                borderRadius: overflowPercent == heightDay / 5 ? BorderRadius.zero : const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                color: colors['error'],
              ),
              child: ClipRRect(
                borderRadius: overflowPercent == heightDay / 5 ? BorderRadius.zero : const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
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
                    // Debug
                    Text(
                      '${days[index]['lmax']}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          color: colors['primaryText'],
                          fontSize: 10,
                          fontWeight: centerItemIndex == index
                              ? FontWeight.w700
                              : FontWeight.w400),
                    ),
                    Text(
                      '${days[index]['capeff']}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          color: colors['primaryText'],
                          fontSize: 10,
                          fontWeight: centerItemIndex == index
                              ? FontWeight.w700
                              : FontWeight.w400),
                    ),
                    Text(
                      '${days[index]['buseff']}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          color: colors['primaryText'],
                          fontSize: 10,
                          fontWeight: centerItemIndex == index
                              ? FontWeight.w700
                              : FontWeight.w400),
                    ),
                    Text(
                      '${days[index]['compeff']}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          color: colors['primaryText'],
                          fontSize: 10,
                          fontWeight: centerItemIndex == index
                              ? FontWeight.w700
                              : FontWeight.w400),
                    ),
                    // Dépassement
                    overflow,
                    // Barre avec données
                    SizedBox(
                      height: heightDay,
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
                              height: heightDay,
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
                                      borderRadius: overflowPercent == heightDay / 5 ? BorderRadius.zero : const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
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
