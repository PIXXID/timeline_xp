import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CapacityPlanFilterItem extends StatelessWidget {
  const CapacityPlanFilterItem(
      {super.key,
      required this.colors,
      required this.lang,
      required this.project,
      required this.updateFilter});

  final Map<String, Color> colors;
  final String lang;
  final dynamic project;
  final Function(Map<String, dynamic>) updateFilter;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Call back lors du clic
      onTap: () => {
        updateFilter.call({ 'prj_id': project['prj_id'], 'prj_color': project['prj_color'] })
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          color: colors['primaryBackground'],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: Container(
                  width: 25,
                  height: 25,
                  color: project['prj_color']
                )
              ),
              Text(project['prj_name'],
                style: TextStyle(
                  color: colors['primaryText'],
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                )),
            ]
          )
        )
      )
    );
  }
}