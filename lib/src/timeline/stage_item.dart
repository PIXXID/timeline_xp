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
      required this.elementLength,
      required this.label,
      this.icon,
      this.users,
      required this.startDate,
      required this.endDate,
      required this.type,
      required this.entityId,
      required this.progress,
      required this.prjId,
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
  final int elementLength;
  final String entityId;
  final String startDate;
  final String endDate;
  final String type;
  final String label;
  final String? icon;
  final String? users;
  final double progress;
  final String prjId;
  final String parentStageId;
  final bool isStage;
  final bool isUniqueProject;
  final Function(String?, String?, String?, String?, String?, double?, String?)? openEditStage;
  final Function(String?, String?, String?, String?, String?, double?, String?)? openEditElement;

  @override
  Widget build(BuildContext context) {
    const borderRaduis = BorderRadius.all(Radius.circular(2.5));
    const fontSize = 14.0;

    String typeLabel;
    switch(type) {
      case 'delivrable':
        typeLabel = 'Livrable';
        break;
      case 'activity':
        typeLabel = 'Activité';
        break;
      case 'task':
        typeLabel = 'Tâche';
        break;
      case 'attachment':
        typeLabel = 'Fichier';
        break;
      case 'reminder':
        typeLabel = 'Rappel';
        break;
      default:
        typeLabel = type;
    }

    List<String> usersList = [];
    if (users != null) {
      usersList = users!.split(',');
    }

    return Row(children: [
      GestureDetector(
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
            Container(
              width: itemWidth,
              height: height,
              decoration: BoxDecoration(
                  borderRadius: borderRaduis,
                  color: colors['secondaryBackground'],
                  border: Border.all(color: colors['secondaryBackground']!, width: 1)),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                      width: itemWidth * progress / 100,
                      decoration: BoxDecoration(
                        borderRadius: borderRaduis,
                        color: colors['primary'],
                      )),
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
                        ))
              ])),
            if (isStage)
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 20.0),
                    child: Row(
                      mainAxisSize:
                          MainAxisSize.min, // Ajuste la largeur à son contenu
                      children: [
                        // Affiche l'icône seulement en multi-projet
                        if (!isUniqueProject)
                          Icon(
                            Icons.circle_rounded,
                            size: fontSize,
                            color:
                                colors['pcolor'],
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
            if (!isStage)
              Row(
                children: [
                if (usersList.isNotEmpty)
                  const SizedBox(width: 5),
                if (usersList.isNotEmpty)
                  Stack(
                    children: [
                      for (int i = 0; i < usersList.length; i++)
                        Padding(
                          padding: EdgeInsets.only(left: i * 10),
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: colors['primaryBackground'],
                                shape: BoxShape.circle,
                                border: Border.all(color: colors['secondaryBackground']!, width: 1)
                              ),
                              child: Center(
                                child: Text(
                                  usersList[i],
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: colors['primaryText'],
                                    fontWeight: FontWeight.w300,
                                    fontSize: fontSize - 2,
                                  ),
                                )
                              ),
                            )
                          )
                      ]
                  ),
                ClipRRect(
                  child: SizedBox(
                    width: daysNumber > elementLength ? itemWidth : (dayWidth - dayMargin) * elementLength,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 20.0),
                        child: Row(
                          mainAxisSize:
                              MainAxisSize.min, // Ajuste la largeur à son contenu
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: colors['pcolor'] ?? colors['primaryText']!,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                child: Text(
                                  typeLabel,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: colors['primaryText'],
                                    fontWeight: FontWeight.w300,
                                    fontSize: fontSize - 2,
                                  ),
                                )
                              )
                            ),
                            if (icon != null)
                              const SizedBox(width: 5),
                            if (icon != null)
                              Text(
                                icon!,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: colors['primaryText'],
                                  fontWeight: FontWeight.w300,
                                  fontSize: fontSize,
                                ),
                              ),
                            const SizedBox(width: 5),
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
                  ),
                )
              ]),
            Text(
              startDate,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: colors['primaryText'],
                fontWeight: FontWeight.w300,
                fontSize: fontSize,
              ),
            ),
        ]),
      )
    ]);
  }
}
