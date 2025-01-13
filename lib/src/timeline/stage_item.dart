import 'package:flutter/material.dart';

class StageItem extends StatelessWidget {
  const StageItem(
      {super.key,
      required this.colors,
      required this.itemWidth,
      required this.height,
      required this.label,
      required this.startDate,
      required this.endDate,
      required this.type,
      required this.prsId,
      required this.progress,
      required this.isMilestone,
      required this.openEditStage});

  final Map<String, Color> colors;
  final double itemWidth;
  final double height;
  final String prsId;
  final String startDate;
  final String endDate;
  final String type;
  final String label;
  final double progress;
  final bool isMilestone;
  //final Function(String?)? openEditStage;
  final Function(String?, String?, String?, String?, String?, double?)? openEditStage;

  @override
  Widget build(BuildContext context) {
    const borderRaduis = BorderRadius.all(Radius.circular(2.5));
    const fontSize = 14.0;

    return Row(children: [
      GestureDetector(
        // Call back lors du clic
        onTap: () {
          openEditStage?.call(prsId, label, type, startDate, endDate, progress);
        },   
        child: Container(
          width: itemWidth,
          height: height,
          decoration: BoxDecoration(
              borderRadius: borderRaduis,
              color: colors['primaryBackground'],
              border: Border.all(color: colors['secondaryBackground']!, width: 1)),
          child: Stack(clipBehavior: Clip.none, children: [
            Container(
                width: itemWidth * progress / 100,
                decoration: BoxDecoration(
                  borderRadius: borderRaduis,
                  color: colors['secondaryBackground'],
                )),
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 20.0),
                  child: Row(
                    mainAxisSize:
                        MainAxisSize.min, // Ajuste la largeur à son contenu
                    children: [
                      Icon(
                        Icons.circle_rounded, // Remplacez par l'icône souhaitée
                        size: fontSize, // Taille de l'icône
                        color:
                            colors['pcolor'], // Même couleur que le texte
                      ),
                      const SizedBox(width: 5), // Espacement entre l'icône et le texte
                      Flexible(
                        child: Text(
                          label,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: colors['primaryText'],
                            fontWeight: FontWeight.w300,
                            fontSize: fontSize,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (isMilestone)
              Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Icon(
                      Icons.flag,
                      size: 15,
                      color: colors['primaryText'],
                    ),
                  ))
          ])),
      )
    ]);
  }
}
