import 'package:flutter/material.dart';

import 'stage_item.dart';
// Tools
import 'package:timeline_xp/src/tools/tools.dart';

class StageRow extends StatefulWidget {
  const StageRow(
      {super.key,
      required this.colors,
      required this.stagesList,
      required this.centerItemIndex,
      required this.dayWidth,
      required this.dayMargin,
      required this.height,
      required this.openEditStage,
      required this.openEditElement});

  final Map<String, Color> colors;
  final List stagesList;
  final int centerItemIndex;
  final double dayWidth;
  final double dayMargin;
  final double height;
  final Function(String?, String?, String?, String?, String?, double?, String?)? openEditStage;
  final Function(String?, String?, String?, String?, String?, double?, String?)? openEditElement;

  @override
  State<StageRow> createState() => _StageRow();
}

class _StageRow extends State<StageRow> {
  List<Widget> list = [];
  
  // Variables pour le Stack et le positionnement
  double currentPosition = 0;
  List<Widget> spacers = [];
  List<Widget> stageItems = [];
  List<Widget> labels = [];

  // Initialisation
  @override
  void initState() {
    _buildStageList();
    super.initState();
  }

  // Méthode appelée lorsque les paramètres changent
  @override
  void didUpdateWidget(StageRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.centerItemIndex != oldWidget.centerItemIndex) {
      // Reconstruire la liste des étapes si l'index central change
      _buildStageList();
      setState(() {}); // Demander un rebuild
    }
  }

  // Construit la liste de stages et éléments
  void _buildStageList() {
    // Réinitialiser toutes les listes et positions
    list.clear();
    spacers.clear();
    stageItems.clear();
    labels.clear();
    currentPosition = 0;
    
    // On vérifie si la timeline affiche un ou plusieurs projets
    Set<String> uniquePrjIds = {};
    if (widget.stagesList.isNotEmpty) {
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
      bool isStage = ['milestone', 'cycle', 'sequence', 'stage'].contains(widget.stagesList[index]['type']);
      
      // Construction du label du stage
      String label = '';
      if (isStage) {
        // Affiche le nom du projet seulement si plusieurs prjId
        if (uniquePrjIds.length > 1) {
          label += (widget.stagesList[index]['pname'] != null) ? widget.stagesList[index]['pname'] + ' - ' : '';
        }
        // Nom du stage
        label += (widget.stagesList[index]['name'] != null) ? widget.stagesList[index]['name'] + progressLabel : '';
      } else {
        label += widget.stagesList[index]['pre_name'] ?? '';
      }
      
      // On ajoute la couleur du projet pour l'icon
      if (widget.stagesList[index]['pcolor'] != null) {
        widget.colors['pcolor'] = formatStringToColor(widget.stagesList[index]['pcolor'])!;
      } else {
        widget.colors['pcolor'] = Color(int.parse('ffffff', radix: 16));
      }
      
      // Largeur de l'item
      double itemWidth = daysWidth * (widget.dayWidth - widget.dayMargin);
      
      // On récupère l'ancien étape de la liste
      var previousItem = index > 0 ? widget.stagesList[index - 1] : null;
      
      // On calcule l'espace avant cet élément
      double spacerWidth = 0;
      if (previousItem != null) {
        int daysBetweenElements = widget.stagesList[index]['startDateIndex'] - previousItem['endDateIndex'] - 1;
        if (daysBetweenElements > 0) {
          spacerWidth = daysBetweenElements * (widget.dayWidth - widget.dayMargin);
        }
      } else {
        spacerWidth = widget.stagesList[index]['startDateIndex'] * (widget.dayWidth - widget.dayMargin);
      }
      
      // Ajouter un spacer si nécessaire
      if (spacerWidth > 0) {
        spacers.add(
          Positioned(
            left: currentPosition,
            child: SizedBox(
              width: spacerWidth,
              height: widget.height,
            )
          )
        );
        currentPosition += spacerWidth;
      }
      
      // Position pour cet élément
      double stageItemPosition = currentPosition;
      
      // Ajoute le StageItem
      String entityId = widget.stagesList[index]['prs_id'] ?? widget.stagesList[index]['pre_id'];
      stageItems.add(
        Positioned(
          left: stageItemPosition,
          child: StageItem(
            colors: Map.from(widget.colors),
            dayWidth: widget.dayWidth,
            dayMargin: widget.dayMargin,
            itemWidth: itemWidth,
            daysNumber: daysWidth,
            height: widget.height,
            entityId: entityId,
            type: widget.stagesList[index]['type'] ?? widget.stagesList[index]['nat'],
            label: label,
            icon: widget.stagesList[index]['icon'],
            users: widget.stagesList[index]['users'],
            startDate: widget.stagesList[index]['sdate'],
            endDate: widget.stagesList[index]['sdate'],
            progress: widget.stagesList[index]['prog'] != null ? widget.stagesList[index]['prog'].toDouble() : 0,
            prjId: widget.stagesList[index]['prj_id'],
            pname: widget.stagesList[index]['pname'],
            parentStageId: widget.stagesList[index]['prs_id'],
            isStage: isStage,
            isUniqueProject: uniquePrjIds.length > 1 ? false : true,
            openEditStage: widget.openEditStage,
            openEditElement: widget.openEditElement
          )
        )
      );
      
      // On vérifie si l'élément est au centre de l'écran
      // Dans ce cas on affiche le label
      if (!isStage &&
        widget.stagesList[index]['startDateIndex'] <= widget.centerItemIndex && widget.stagesList[index]['endDateIndex'] >= widget.centerItemIndex) {
        // Ajoute le label associé
        labels.add(
          Positioned(
            left: stageItemPosition + 25, // Décalage vers la droite par rapport au StageItem
            top: 6, // Positionnement vertical
            child: Container(
              height: widget.height - 12,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(2.5)),
                color: widget.colors['secondaryBackground'],
                border: Border.all(color: widget.colors['accent1']!, width: 1)
              ),
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: widget.colors['primaryText'],
                  fontWeight: FontWeight.w300,
                  fontSize: 12,
                ),
              ),
            )
          )
        );
      }
      
      // Mise à jour de la position courante pour le prochain élément
      currentPosition += itemWidth;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        // Cette largeur est essentielle pour éviter l'erreur "size.isFinite is not true"
        width: currentPosition,
        height: widget.height,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ...spacers,
            ...stageItems,
            ...labels,
          ],
        ),
      ),
    );
  }
}
