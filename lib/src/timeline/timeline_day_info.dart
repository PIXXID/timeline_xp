import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/*
* Affichage des informations lors du survol d'une journée
* Permet d'afficher la séquence, les informations de progressions
* et la date survolée
*/
class TimelineDayInfo extends StatelessWidget {
  const TimelineDayInfo({
    super.key,
    required this.day,
    required this.colors,
    required this.lang,
    required this.elements,
    required this.openDayDetail
  });

  final Map<String, Color> colors;
  final dynamic day;
  final String lang;
  final List elements;
  final Function(String, double?, List<String>?, List<dynamic>, dynamic)?
      openDayDetail;

  @override
  Widget build(BuildContext context) {
    final curEltCompleted =
        (day['elementCompleted'] != null) ? day['elementCompleted'] : 0;
    final curEltPending =
        (day['elementPending'] != null) ? day['elementPending'] : 0;
    const double badgeWidth = 45;
    const double badgeHeight = 22;

    // Données de style
    const fontSize = 14.0;

    return 
      Align(
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
            onTap: () {
              // On calcule la progression du jour pour le renvoyer en callback
              double dayProgress = 0;
              if (day != null &&
                  day['buseff'] != null &&
                  day['buseff'] > 0) {
                dayProgress =
                    100 * day['compeff'] / day['buseff'];
              }
              // Lite des élements présent sur la journée
              var elementsDay = elements
                  .where(
                    (e) => e['date'] == DateFormat('yyyy-MM-dd').format(day['date']),
                  )
                  .toList();
              // Indicateurs de capacité et charges
              dynamic dayIndicators = {
                'capacity': day['capeff'],
                'busy': day['buseff'],
                'completed': day['compeff']
              };
              // Callback de la fonction d'ouverture du jour
              openDayDetail?.call(
                  DateFormat('yyyy-MM-dd').format(day['date']),
                  dayProgress,
                  (day['preIds'] as List<dynamic>).cast<String>(),
                  elementsDay,
                  dayIndicators);
            },
            child:
              Column(
                children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          DateFormat.yMMMMd(lang).format(day['date']),
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: colors['primaryText'],
                            fontSize: fontSize,
                          )
                        ),
                        Icon(
                          Icons.blur_linear_outlined,
                          size: fontSize + 4,
                          color: colors['primaryBackground'],
                        ),
                        for (var index = 0; index < curEltCompleted; index++)
                          Icon(
                            Icons.check_circle,
                            size: fontSize + 4,
                            color: colors['primary'],
                          ),
                        for (var index = 0; index < curEltPending; index++)
                          Icon(
                            Icons.circle_rounded,
                            size: fontSize + 4,
                            color: colors['secondaryBackground'],
                          ),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: 
                    Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                    Text(
                      "Capacité",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: colors['primaryText'],
                        fontSize: fontSize -1,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                        width: badgeWidth,
                        height: badgeHeight,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(2.5)),
                            color: const Color(0x00000000),
                            border: Border.all(color: colors['secondaryText']!)),
                        child: Center(
                            child: Text(
                          "${day['capeff'].floor()}h",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: colors['primaryText'],
                            fontSize: fontSize,
                          ),
                        ))),
                    const SizedBox(width: 8),
                    Text(
                      "Planifié",
                      style: TextStyle(
                        color: colors['primaryText'],
                        fontSize: fontSize-1,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                        width: badgeWidth,
                        height: badgeHeight,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(2.5)),
                            color: colors['secondaryText'],
                            border: Border.all(color: colors['secondaryText']!)),
                        child: Center(
                            child: Text(
                          "${day['buseff'].floor()}h",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: colors['primaryText'],
                            fontSize: fontSize,
                          ),
                        ))),
                    const SizedBox(width: 8),
                    Text(
                      "Terminé",
                      style: TextStyle(
                        color: colors['primaryText'],
                        fontSize: fontSize-1,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                        width: badgeWidth,
                        height: badgeHeight,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(2.5)),
                            color: colors['primary'],
                            border: Border.all(color: colors['primary']!)),
                        child: Center(
                            child: Text(
                          "${day['compeff'].floor()}h",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: colors['primaryText'],
                            fontSize: fontSize,
                          ),
                        ))),
                  ]),
                ),
                // Date affichée
                const Padding(padding: EdgeInsets.only(bottom: 20)),
              ])
        )
      );
  }
}
