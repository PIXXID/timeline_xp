import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'release_chart.dart';

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

    // Informations de la journée affichée
    final curDay = day;
    final curStage =
        (curDay['currentStage'] != null && curDay['currentStage'].isNotEmpty)
            ? curDay['currentStage']
            : null;
    final curStageName = (curStage != null) ? curStage['name'] : ' ';
    final curStageProg = (curStage != null) ? curStage['prog'] : -1;
    final curActComp = (curDay['activityCompleted'] != null) ? curDay['activityCompleted'] : 0;
    final curActTot = (curDay['activityTotal'] != null) ? curDay['activityTotal'] : 0;
    final curDelComp = (curDay['delivrableCompleted'] != null) ? curDay['delivrableCompleted'] : 0;
    final curDelTot = (curDay['delivrableTotal'] != null) ? curDay['delivrableTotal'] : 0;
    final curLongDate = (curDay['date'] != null) ? DateFormat.yMMMMd(lang).format(curDay['date']) : '';
    // TODO - A supprimer après contrôle
    final debugInfo = '${curDay['lmax']},${curDay['capeff']},${curDay['buseff'].toStringAsFixed(1)},${curDay['compeff']}';

    // Données de style
    const fontSize = 12.0;
    const fontWeight = FontWeight.w300;
    
    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(children: [
          Row(children: [
            // Nom du stage
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
              return SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.35,
                child: Text(
                  '$curStageName',
                  style: TextStyle(color: colors['primaryText'],
                    fontWeight: fontWeight,
                    fontSize: fontSize),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              );
            }),
            // ProgressBar
            if (curStageProg > -1)
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: ReleaseChart(
                    colors: colors, releaseProgress: curStageProg),
              ),
          ]),
          // Totaux activités / livrables
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.45,
            child: Text(
                  '$curActComp/$curActTot act.  $curDelComp/$curDelTot liv. ($debugInfo)',
                  textAlign: TextAlign.right,
                  style: TextStyle(color: colors['primaryText'], 
                    fontWeight: fontWeight,
                    fontSize: fontSize),
              )
            )
        ])),
        Container(height: 1, color: colors['accent2']),
        // Date affichée
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Align(
            alignment: Alignment.center,
            child: Container(
                width: MediaQuery.sizeOf(context).width * 0.4,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    color: colors['accent2']),
                child: Text(curLongDate,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: colors['primaryText'],
                      fontSize: fontSize, // Taille de l'icône
                      fontWeight: fontWeight),
                )),
          ),
        ),
    ]);
  }
}
