import 'package:flutter/material.dart';

import 'stage_item.dart';

class StageRow extends StatefulWidget {
  const StageRow(
      {super.key,
      required this.colors,
      required this.stagesList,
      required this.dayWidth,
      required this.dayMargin,
      required this.height,
      required this.isMultiproject,
      required this.openAddStage});

  final Map<String, Color> colors;
  final List stagesList;
  final double dayWidth;
  final double dayMargin;
  final double height;
  final bool isMultiproject;
  final Function(String?)? openAddStage;

  @override
  State<StageRow> createState() => _StageRow();
}

class _StageRow extends State<StageRow> {
  List<Widget> list = [];

  // Initialisation
  @override
  void initState() {
    // On boucle sur les étapes de la ligne
    for (int index = 0; index < widget.stagesList.length; index++) {
      // Nombre de jour de durée
      int daysWidth = widget.stagesList[index]['endDateIndex'] -
          widget.stagesList[index]['startDateIndex'] +
          1;
      String label = widget.stagesList[index]['name'];
      // Largeur de l'item
      double itemWidth = daysWidth * (widget.dayWidth - widget.dayMargin);
      // On récupère l'ancien étape de la liste
      var previousStage = index > 0 ? widget.stagesList[index - 1] : null;

      // On crée le vide entre l'ancien étape (s'il y en a un) et le nouveau
      if (previousStage != null) {
        list.add(SizedBox(
          width: (widget.stagesList[index]['startDateIndex'] -
                  previousStage['endDateIndex'] -
                  (widget.isMultiproject ? 1 : 2)) *
              (widget.dayWidth - widget.dayMargin),
        ));
      } else {
        list.add(SizedBox(
          width: widget.stagesList[index]['startDateIndex'] *
              (widget.dayWidth - widget.dayMargin),
        ));
      }

      list.add(StageItem(
          colors: widget.colors,
          dayWidth: widget.dayWidth,
          itemWidth: itemWidth,
          dayMargin: widget.dayMargin,
          height: widget.height,
          prsId: widget.stagesList[index]['prs_id'],
          label: label,
          progress: widget.stagesList[index]['progress'],
          isMilestone: widget.stagesList[index]['type'] == 'milestone',
          isMultiproject: widget.isMultiproject,
          openAddStage: widget.openAddStage));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: list);
  }
}
