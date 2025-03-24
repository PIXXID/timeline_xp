import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    const borderRadius = BorderRadius.all(Radius.circular(2.5));
    const fontSize = 14.0;

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
                  color: colors['secondaryBackground'],
                  border: Border.all(color: colors['primaryBackground']!, width: 2)),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                      width: itemWidth * progress / 100,
                      decoration: BoxDecoration(
                        borderRadius: borderRadius,
                        color: colors['primary'],
                      )),
                   
                  // TEXTE STAGES
                  if (isStage)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 10.0),
                        child: Row(
                          mainAxisSize:
                              MainAxisSize.min, // Ajuste la largeur à son contenu
                          children: [
                            // Affiche l'icône seulement en multi-projet
                            if (!isUniqueProject && pname != null)
                              Container(
                                decoration: BoxDecoration(
                                color: colors['pcolor'] ?? colors['primaryText']!,
                                borderRadius: BorderRadius.circular(2),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                  child: Text(
                                    pname!,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: colors['primaryText'],
                                      fontWeight: FontWeight.w300,
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
                                    width: 18,
                                    height: 18,
                                    decoration: BoxDecoration(
                                      color: colors['secondaryBackground'],
                                      shape: BoxShape.circle,
                                      border: Border.all(color: colors['primaryBackground']!, width: 1),
                                    ),
                                    child: Center(
                                      child: Text(
                                        usersList[0],
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: colors['primaryText'],
                                          fontWeight: FontWeight.w300,
                                          fontSize: fontSize - 2,
                                        ),
                                      )
                                    ),
                                  ),
                                if (usersList.length > 1)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 14),
                                    child: Container(
                                      width: 18,
                                      height: 18,
                                      decoration: BoxDecoration(
                                        color: colors['secondaryBackground'],
                                        shape: BoxShape.circle,
                                        border: Border.all(color: colors['primaryBackground']!, width: 1),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '+${usersList.length - 1}',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: colors['primaryText'],
                                            fontWeight: FontWeight.w300,
                                            fontSize: fontSize - 2,
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
                                    fontWeight: FontWeight.w300,
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
                                    fontWeight: FontWeight.w300,
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
        ]),
      );
  }
}
