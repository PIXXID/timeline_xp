import 'package:flutter/material.dart';

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
  });

  final Map<String, Color> colors;
  final dynamic day;
  final String lang;

  @override
  Widget build(BuildContext context) {

    final curEltCompleted =(day['elementCompleted'] != null) ? day['elementCompleted'] : 0;
    final curEltPending = (day['elementPending'] != null) ? day['elementPending'] : 0;
    const double badgeWidth = 35;
    const double badgeHeight = 18;

    // Données de style
    const fontSize = 10.0;
    
    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
        child: Row(       
          children:<Widget> [
            Icon(
              Icons.schedule,
              size: 14,
              color: colors['primaryText'],
            ),
            const SizedBox(width: 4),
            Text(
              "Term.",
              style: TextStyle(
                color: colors['primaryText'],
                fontSize: 10,
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
                    fontSize: 11,
                  ),
                )
              )
            ),
            const SizedBox(width: 5),
            Text(
              "Plan.",
              style: TextStyle(
                color: colors['primaryText'],
                fontSize: 10,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              width: badgeWidth,
              height: badgeHeight,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(2.5)),
                  color: colors['accent2'],
                  border: Border.all(color: colors['accent2']!)),
              child: Center(
                child: Text(
                  "${day['buseff'].floor()}h",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colors['primaryText'],
                    fontSize: 11,
                  ),
                )
              )
            ),
            const SizedBox(width: 5),
            Text(
              "Cap.",
              textAlign: TextAlign.right,
              style: TextStyle(
                color: colors['primaryText'],
                fontSize: 10,
              ),
            ),
            const SizedBox(width: 4),
            Container(
                width: badgeWidth,
                height: badgeHeight,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(2.5)),
                    color: const Color(0x00000000),
                    border: Border.all(color: colors['accent2']!)),
                child: Center(
                  child: Text(
                    "${day['capeff'].floor()}h",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colors['primaryText'],
                      fontSize: 11,
                    ),
                  )
                )
              ),
            const SizedBox(width: 10),
            for (var index = 0; index < curEltCompleted; index++)
                Icon(
                  Icons.check_circle_rounded,
                  size: fontSize,
                  color: colors['primary'],
                ),
            for (var index = 0; index < curEltPending; index++)
                Icon(
                  Icons.circle_rounded,
                  size: fontSize,
                  color: colors['accent1'],
                ),
          ]),
        ),
        // Date affichée
        const Padding(
          padding: EdgeInsets.only(bottom: 10)
        ),
    ]);
  }
}
