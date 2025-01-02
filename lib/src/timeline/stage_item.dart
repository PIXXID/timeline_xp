import 'package:flutter/material.dart';

class StageItem extends StatelessWidget {
  const StageItem(
      {super.key,
      required this.colors,
      required this.itemWidth,
      required this.height,
      required this.label,
      required this.prsId,
      required this.progress,
      required this.isMilestone,
      required this.openEditStage});

  final Map<String, Color> colors;
  final double itemWidth;
  final double height;
  final String prsId;
  final String label;
  final double progress;
  final bool isMilestone;
  final Function(String?)? openEditStage;

  @override
  Widget build(BuildContext context) {
    const borderRaduis = BorderRadius.all(Radius.circular(2.5));

    return Row(children: [
      GestureDetector(
        // Call back lors du clic
        onTap: () {
          openEditStage?.call(prsId);
        },   
        child: Container(
          width: itemWidth,
          height: height,
          decoration: BoxDecoration(
              borderRadius: borderRaduis,
              color: const Color(0x00000000),
              border: Border.all(color: colors['accent1']!, width: 0.5)),
          child: Stack(clipBehavior: Clip.none, children: [
            Container(
                width: itemWidth * progress / 100,
                decoration: BoxDecoration(
                  borderRadius: borderRaduis,
                  color: colors['accent1'],
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
                        size: 14, // Taille de l'icône
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
                            fontSize: 12,
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
