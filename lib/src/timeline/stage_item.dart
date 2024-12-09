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
              borderRadius: (const BorderRadius.all(Radius.circular(7))),
              color: colors['primaryBackground'],
              border: Border.all(color: colors['accent2']!)),
          child: Stack(clipBehavior: Clip.none, children: [
            Container(
                margin: const EdgeInsets.all(3.0),
                width: itemWidth * progress / 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: colors['primary'],
                )),
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 20.0),
                    child: Text(label,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: TextStyle(
                            color: colors['primaryText'],
                            fontWeight: FontWeight.w300,
                            fontSize: 12)))),
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
