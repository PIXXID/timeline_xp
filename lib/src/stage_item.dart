library timeline_xp;

import 'package:flutter/material.dart';

class StageItem extends StatelessWidget {
  StageItem(
      {super.key,
      required this.colors,
      required this.dayWidth,
      required this.dayMargin,
      required this.itemWidth,
      required this.height,
      required this.label,
      required this.prsId,
      required this.progress,
      required this.isMultiproject,
      required this.isMilestone,
      required this.openAddStage});

  final Map<String, Color> colors;
  final double dayWidth;
  final double dayMargin;
  final double itemWidth;
  final double height;
  final String prsId;
  final String label;
  final int progress;
  final bool isMultiproject;
  final bool isMilestone;
  final Function(String?)? openAddStage;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
          width: itemWidth,
          height: height,
          decoration: BoxDecoration(
              borderRadius: (!isMultiproject
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10))
                  : const BorderRadius.all(Radius.circular(10))),
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
                            fontWeight: FontWeight.w500)))),
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
      if (!isMultiproject)
        SizedBox(
            height: height,
            width: dayWidth - dayMargin,
            child: ElevatedButton(
                onPressed: () {
                  openAddStage?.call(prsId);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors['primaryBackground'],
                  padding: const EdgeInsets.all(0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  elevation: 0,
                  side: BorderSide(
                    width: 1.0,
                    color: colors['accent2']!,
                  ),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                ),
                child: Icon(
                  Icons.add,
                  size: 20,
                  color: colors['primaryText'],
                )))
    ]);
  }
}