import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Widgets
import 'capacity_plan_day_item.dart';

// Tools
import 'package:timeline_xp/src/tools/tools.dart';

class CapacityPlan extends StatefulWidget {
  CapacityPlan({
    super.key,
    required this.width,
    required this.height,
    required this.lang,
    required this.colors,
    required this.readOnly,
    this.duplicateWeek,
    required this.startDate,
    required this.endDate,
    required this.projects,
    required this.capacities,
    required this.updateCapacity,
  });

  final double width;
  final double height;
  final String lang;
  final Map<String, Color> colors;
  final bool readOnly;
  String? duplicateWeek;
  final String startDate;
  final String endDate;
  final dynamic projects;
  final dynamic capacities;
  final Function(dynamic)? updateCapacity;

  @override
  State<CapacityPlan> createState() => _CapacityPlan();
}

class _CapacityPlan extends State<CapacityPlan> {

  List weeks = [];

  DateTime now = DateTime.now();

  // Initialisation
  @override
  void initState() {
    super.initState();

    weeks = formatCapacities(DateTime.parse(widget.startDate), DateTime.parse(widget.endDate), widget.capacities);
  }

  int oldWeekIndex = 0;
  // Formate la liste des jours pour la timeline
  List formatCapacities(DateTime startDate, DateTime endDate, List capacities) {
    List list = [];

    // On récupère le premier jour de la semaine en cours
    DateTime weekFirstDate = startDate.subtract(Duration(days: startDate.weekday - 1));
    DateTime weekLastDate = startDate.add(Duration(days: DateTime.daysPerWeek - endDate.weekday));

    // On récupère le nombre de jours entre la date de début et la date de fin
    int duration = weekLastDate.difference(weekFirstDate).inDays;

    // On parcourt les dates pour y associer les jours et les étapes en cours
    for (var dateIndex = 0; dateIndex < duration - 1; dateIndex++) {
      // Date
      DateTime date = weekFirstDate.add(Duration(days: dateIndex));
      // Jour de la semaine en cours
      String weekDay = DateFormat.E().format(date);

      // Numéro de la semaine du mois en cours
      int weekIndex = weeksNumber(date);

      // On vérifie si on a changé de semaine dans ce cas on en ajoute une nouvelle
      if (oldWeekIndex != weekIndex) {
        list[list.length - 1]
            .add({"Mon": {}, "Tue": {}, "Wed": {}, "Thu": {}, "Fri": {}});
      }

      // On positionne les jours dans la semaine
      list[list.length - 1][weekDay] = {
        "upc_date": date,
        "upc_capacity_hour": 0,
        "upc_user_busy_hour": 0
      };

    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: CarouselView(
              itemExtent: 330,
              shrinkExtent: 200,
              children: weeks.map((index) => CapacityPlanDayItem(
                  colors: widget.colors,
                  lang: widget.lang,
                  day: weeks[index],
                  updateCapacity: widget.updateCapacity
                )
              ),
            ),
          )
          // ListView.builder(
          //   scrollDirection: Axis.horizontal,
          //   itemCount: days.length,
          //   itemBuilder: (BuildContext context, int index) {
          //     return CapacityPlanDayItem(
          //       colors: widget.colors,
          //       lang: widget.lang,
          //       day: days[index],
          //       updateCapacity: widget.updateCapacity
          //     );
          //   }
          // )
        ]
      )
    );
  }
  
}