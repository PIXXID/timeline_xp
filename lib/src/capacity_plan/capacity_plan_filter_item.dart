import 'package:flutter/material.dart';

// Tools
import 'package:timeline_xp/src/tools/tools.dart';

class CapacityPlanFilterItem extends StatelessWidget {
  const CapacityPlanFilterItem(
      {super.key,
      required this.colors,
      required this.lang,
      required this.project,
      required this.selectedProject,
      required this.updateFilter});

  final Map<String, Color> colors;
  final String lang;
  final dynamic project;
  final Map<String, dynamic> selectedProject;
  final Function(Map<String, dynamic>) updateFilter;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Call back lors du clic
      onTap: () => {
        updateFilter.call({ 'prj_id': project['prj_id'], 'prj_color': project['prj_color'] })
      },
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          color: colors['primaryBackground'],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),  
                    curve: Curves.easeInOut,
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      border: Border.all(width: 3, color: selectedProject['prj_id'] == project['prj_id'] ? colors['primaryText']! : Colors.transparent),
                      color: formatStringToColor(project['prj_color'].toString())
                    )
                  ),
                  if (project['prj_id'] == null)
                    Transform.rotate(
                      angle: -45,
                      child: Container(
                        width: 25,
                        height: 2,
                        color: Colors.red
                      )
                    )
                ],
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