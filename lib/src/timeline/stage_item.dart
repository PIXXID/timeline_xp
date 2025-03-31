import 'package:flutter/material.dart';

class StageItem extends StatelessWidget {
  const StageItem(
      {super.key,
      required this.colors,
      required this.dayWidth,
      required this.dayMargin,
      required this.itemWidth,
      required this.daysNumber,
      required this.height,
      required this.label,
      this.icon,
      this.users,
      required this.startDate,
      required this.endDate,
      required this.type,
      required this.entityId,
      required this.progress,
      required this.prjId,
      this.pname,
      required this.parentStageId,
      required this.isStage,
      required this.isUniqueProject,
      required this.openEditStage,
      required this.openEditElement});

  final Map<String, Color> colors;
  final double dayWidth;
  final double dayMargin;
  final double itemWidth;
  final int daysNumber;
  final double height;
  final String entityId;
  final String startDate;
  final String endDate;
  final String type;
  final String label;
  final String? icon;
  final String? users;
  final double progress;
  final String prjId;
  final String? pname;
  final String parentStageId;
  final bool isStage;
  final bool isUniqueProject;
  final Function(String?, String?, String?, String?, String?, double?, String?)? openEditStage;
  final Function(String?, String?, String?, String?, String?, double?, String?)? openEditElement;

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(4));
    const fontSize = 14.0;
    const fontWeight = FontWeight.w400;
    // Couleur du texte dynamique en fonction de la couleur du projet
    Color fontColor = ThemeData.estimateBrightnessForColor((colors['pcolor'] ?? colors['primaryText']!)) == Brightness.dark ? Colors.white : Colors.black;
    Color backgroundColor = (colors['pcolor'] ?? colors['primaryText'])!.withAlpha(150);
    Color completeColor = colors['pcolor'] ?? colors['primaryText']!;

    List<String> usersList = [];
    if (users != null) {
      usersList = users!.split(',');
    }

    return GestureDetector(
        // Call back lors du clic
        onTap: () {
          if (isStage) {
            openEditStage?.call(entityId, label, type, startDate, endDate, progress, prjId);
          } else {
            openEditElement?.call(entityId, label, type, startDate, endDate, progress, prjId);
          }
        },
        child: Stack(
          children: [
            // FOND DU STAGE/ELEMENT
            Container(
              width: itemWidth,
              height: height,
              decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  color: backgroundColor),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                      width: itemWidth * progress / 100,
                      decoration: BoxDecoration(
                        borderRadius: borderRadius,
                        color: completeColor,
                      )),
                   
                  // TEXTE STAGES
                  if (isStage)
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 3.0, left: 5.0, right: 10.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // Ajuste la largeur à son contenu
                          children: [
                            // Affiche le badge seulement en multi-projet
                            if (!isUniqueProject)
                              Container(
                                decoration: BoxDecoration(
                                color: completeColor,
                                borderRadius: borderRadius,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                  child: Text(
                                    pname ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: fontColor,
                                      fontWeight: fontWeight,
                                      fontSize: fontSize,
                                    ),
                                  )
                                )
                              ),
                            const SizedBox(width: 5), // Espacement entre l'icône et le texte
                            Flexible(
                              child: Text(
                                label,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: fontColor,
                                  fontWeight: fontWeight,
                                  fontSize: fontSize,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (type == 'milestone')
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Icon(
                          Icons.flag,
                          size: 15,
                          color: colors['primaryText'],
                        ),
                      )),

                  // TEXTE ELEMENT
                  if (!isStage)
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 2.0),
                        child: Row(
                          children: [
                            // COMPTEUR USERS
                            if (usersList.isNotEmpty)
                              Stack(
                                children: [
                                  Container(
                                    width: 19,
                                    height: 19,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withAlpha(220),
                                      shape: BoxShape.circle
                                    ),
                                    child: Center(
                                      child: Text(
                                        usersList[0],
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: fontWeight,
                                          fontSize: fontSize,
                                        ),
                                      )
                                    ),
                                  ),
                                if (usersList.length > 1)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 19),
                                    child: Container(
                                      width: 19,
                                      height: 19,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withAlpha(220),
                                        shape: BoxShape.circle
                                      ),
                                      child: Center(
                                        child: Text(
                                          '+${usersList.length - 1}',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: fontWeight,
                                            fontSize: fontSize - 4,
                                          ),
                                        ),
                                      )
                                    )
                                  )
                              ]),
                            // ICON
                            if (daysNumber > 1) ...{
                              if (icon != null)
                                const SizedBox(width: 5),
                                Text(
                                  icon ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: colors['primaryText'],
                                    fontWeight: fontWeight,
                                    fontSize: fontSize,
                                  ),
                                ),
                              // LABEL
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  label,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: colors['primaryText'],
                                    fontWeight: fontWeight,
                                    fontSize: fontSize,
                                  ),
                                ),
                              )
                            },
                          ]
                        )
                      )
                    )
              ])),
            if (isStage)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: itemWidth-10,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors['primaryBackground'],
                  ),
                ),
              ),
            ),


        ]),
      );
  }
}

//colors['primaryBackground']