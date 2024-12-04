import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimelineItem extends StatelessWidget {
  const TimelineItem(
      {super.key,
      required this.colors,
      required this.lang,
      required this.index,
      required this.centerItemIndex,
      required this.nowIndex,
      required this.days,
      required this.elements,
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
  final List elements;
  final double dayWidth;
  final double dayMargin;
  final double height;
  final Function(String, double?, List<String>?, List<dynamic>)? openDayDetail;

  @override
  Widget build(BuildContext context) {

    final DateTime date = days[index]['date'];
    Color? busyColor = colors['accent1'];

    // Hauteur MAX
    double heightLmax = height - 80; 
    // On calcule la hauteur de chaque barre
    double heightCapeff = 0;
    double heightBuseff = 0;
    double heightCompeff = 0;
    if (days[index]['capeff'] > 0) {
      heightCapeff = (heightLmax * days[index]['capeff']) / ((days[index]['lmax'] > 0) ? days[index]['lmax'] : 1);
    }
    if (days[index]['buseff'] > 0) {
      heightBuseff = (heightLmax * days[index]['buseff']) / ((days[index]['lmax'] > 0) ? days[index]['lmax'] : 1);
    }
    if (days[index]['compeff'] > 0) {
      heightCompeff = (heightLmax * days[index]['compeff']) / ((days[index]['lmax'] > 0) ? days[index]['lmax'] : 1);
    }

    // Fond Rouge si la charge dépasse la capacité
    if (heightBuseff >= heightLmax) {
      busyColor = colors['error'];
      heightBuseff = heightLmax;
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
                dayProgress =
                    100 * days[index]['compeff'] / days[index]['buseff'];
              }

              // Lite des élements présent sur la journée
              var elementsDay = elements
                  .where(
                    (e) => e['date'] == DateFormat('yyyy-MM-dd').format(days[index]['date']),
                  )
                  .toList();

              // Callback de la fonction d'ouverture du jour
              openDayDetail?.call(
                  DateFormat('yyyy-MM-dd').format(date),
                  dayProgress,
                  (days[index]['preIds'] as List<dynamic>).cast<String>(),
                  elementsDay);
            },
            child: SizedBox(
                width: dayWidth - dayMargin,
                height: height,
                child: Column(
                  children: <Widget>[
                    // Barre avec données
                    SizedBox(
                      height: heightLmax + 10,
                      child: Stack(children: [
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
                            height: (heightCapeff > 0) ? heightCapeff : heightLmax,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: colors['accent2'],
                            ),
                            child:
                              Center(
                                child:
                                // Icon soleil si aucune capacité
                                (heightCapeff == 0 && heightBuseff == 0 && heightCompeff == 0) ?
                                  Icon(Icons.sunny, color: colors['primaryBackground']) : null
                              )
                          )
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
                                color: busyColor,
                              ),
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
                            ))
                      ]),
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
                            size: 12,
                            color: colors['accent2'],
                          ))
                    else if (days[index]['alertLevel'] != 0)
                      Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Icon(
                            Icons.circle_rounded,
                            size: 12,
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
