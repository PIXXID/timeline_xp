import 'package:flutter/material.dart';

import 'stage_item.dart';
// Tools
import 'package:timeline_xp/src/tools/tools.dart';

class StageRow extends StatefulWidget {
  const StageRow(
      {super.key,
      required this.colors,
      required this.stagesList,
      required this.dayWidth,
      required this.dayMargin,
      required this.height,
      required this.openEditStage});

  final Map<String, Color> colors;
  final List stagesList;
  final double dayWidth;
  final double dayMargin;
  final double height;
  final Function(String?, String?, String?, String?, String?, double?, String?)? openEditStage;

  @override
  State<StageRow> createState() => _StageRow();
}

class _StageRow extends State<StageRow> {
  List<Widget> list = [];

  // Initialisation
  @override
  void initState() {

    // On vérifie si la timeline affiche un ou plusieurs projets.
    Set<String> uniquePrjIds = {};
    if(widget.stagesList.isNotEmpty) {
      for (var item in widget.stagesList) {
        String? prjId = item['prj_id'];
        if (prjId != null) {
          uniquePrjIds.add(prjId);
        }
      }
    }

    // On boucle sur les étapes de la ligne
    for (int index = 0; index < widget.stagesList.length; index++) {
      // Nombre de jour de durée
      int daysWidth = widget.stagesList[index]['endDateIndex'] -
          widget.stagesList[index]['startDateIndex'] +
          1;

       // Taux de progresion
      String progressLabel = (widget.stagesList[index]['prog'] != null && widget.stagesList[index]['prog'] > 0) ? ' (${widget.stagesList[index]['prog']}%)' : '';

      // Construction du label du stage
      String label = '';
      // Affiche le nom du projet seulement si plusieurs prjId
      if(uniquePrjIds.length > 1) {
        label += (widget.stagesList[index]['pname'] != null) ? widget.stagesList[index]['pname'] + ' - ' : '';
      }
      // Nom du stage
      label += (widget.stagesList[index]['name'] != null) ? widget.stagesList[index]['name'] + progressLabel : '';
     
      // On ajoute la couleur du projet pour l'icon
      if(widget.stagesList[index]['pcolor'] != null) {
        widget.colors['pcolor'] = formatStringToColor(widget.stagesList[index]['pcolor'])!;
      } else {
        widget.colors['pcolor'] = Color(int.parse('ffffff', radix: 16));
      }

      // Largeur de l'item
      double itemWidth = daysWidth * (widget.dayWidth - widget.dayMargin);
      // On récupère l'ancien étape de la liste
      var previousStage = index > 0 ? widget.stagesList[index - 1] : null;
      
      // On crée le vide entre l'ancien étape (s'il y en a un) et le nouveau
      if (previousStage != null) {
        list.add(SizedBox(
          width: (widget.stagesList[index]['startDateIndex'] -
                  previousStage['endDateIndex'] - 1) *
              (widget.dayWidth - widget.dayMargin),
        ));
      } else {
         list.add(SizedBox(
           width: widget.stagesList[index]['startDateIndex'] *
               (widget.dayWidth - widget.dayMargin),
         ));
      }

      String id = widget.stagesList[index]['prs_id'] != null ? widget.stagesList[index]['prs_id'] : widget.stagesList[index]['pre_id'];
      debugPrint("==========");
      debugPrint('$id');

      list.add(StageItem(
          colors: Map.from(widget.colors),
          itemWidth: itemWidth,
          height: widget.height,
          id: id,
          type: widget.stagesList[index]['type'],
          label: label,
          startDate: widget.stagesList[index]['sdate'],
          endDate: widget.stagesList[index]['sdate'],
          progress: widget.stagesList[index]['prog'] != null ? widget.stagesList[index]['prog'].toDouble() : 0,
          prjId: widget.stagesList[index]['prj_id'],
          isMilestone: widget.stagesList[index]['type'] == 'milestone',
          isUniqueProject: uniquePrjIds.length > 1 ? false : true,
          openEditStage: widget.openEditStage));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: list);
  }
}
