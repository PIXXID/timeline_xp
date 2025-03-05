import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/*
* Affichage des informations lors du survol d'une journée
* Permet d'affichee la date et les éléments présent dans la journée
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
    // Données de style
    const fontSize = 14.0;

    return 
      GestureDetector(
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
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '${DateFormat.E(lang).format(day['date'])} ${DateFormat.yMMMMd(lang).format(day['date'])}',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: colors['primaryText'],
                          fontSize: fontSize,
                        )
                      ),
                    ]),
              ),
            ])
      );
  }
}
