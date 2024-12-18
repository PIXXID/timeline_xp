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
  });

  final Map<String, Color> colors;
  final dynamic day;
  final String lang;

  @override
  Widget build(BuildContext context) {

    final curEltCompleted =(day['elementCompleted'] != null) ? day['elementCompleted'] : 0;
    final curEltPending = (day['elementPending'] != null) ? day['elementPending'] : 0;
    final curLongDate = (day['date'] != null) ? DateFormat.yMMMMd(lang).format(day['date']) : '';

    // Données de style
    const fontSize = 12.0;
    const fontWeight = FontWeight.w300;
    
    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(children: [
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.6,
            child:
              // Icon pour comptage des élements
              Row(
                children:<Widget> [
                Icon(
                  Icons.data_thresholding_outlined, // Remplacez par l'icône souhaitée
                  size: fontSize, // Taille de l'icône
                  color: colors['accent2'], // Même couleur que le texte
                ),
                const SizedBox(width: 4),
                Text(
                  "${day['buseff'].toStringAsFixed(1)}h / ${day['capeff']}h",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: colors['primaryText'],
                    fontSize: 11,
                  ),
                ),
                const SizedBox(width: 15),
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
          // Dat du jour
          SizedBox(
            child: Text(
              curLongDate,
              textAlign: TextAlign.center,
              style: 
                TextStyle(color: colors['primaryText'], 
                fontWeight: fontWeight,
                fontSize: fontSize),
            )
          ),
        ])),
        Container(height: 1, color: colors['accent2']),
        // Date affichée
        const Padding(
          padding: EdgeInsets.only(bottom: 20)
        ),
    ]);
  }
}
