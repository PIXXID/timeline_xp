import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Widgets
import 'timeline_item.dart';

class TimelineMini extends StatefulWidget {
  const TimelineMini(
      {Key? key,
      required this.width,
      required this.height,
      required this.colors,
      required this.lang,
      required this.projectCount,
      required this.infos,
      required this.elements,
      required this.elementsDone,
      required this.capacities,
      this.defaultDate,
      required this.openDayDetail}) : super(key: key);

  final double width;
  final double height;
  final Map<String, Color> colors;
  final String lang;
  final int projectCount;
  final dynamic infos;
  final dynamic elements;
  final dynamic elementsDone;
  final dynamic capacities;
  final String? defaultDate;
  final Function(String, double?, List<String>?, List<dynamic>?, dynamic)? openDayDetail;

  @override
  State<TimelineMini> createState() => _TimelineMini();
}

class _TimelineMini extends State<TimelineMini> {
  // Liste des jours formatés
  List days = [];

  // Largeur d'un item jour
  double dayWidth = 45.0;
  double dayMargin = 5;
  // Hauteur de la timeline
  double timelineHeight = 160.0;


  // Date de début et date de fin par défaut
  DateTime now = DateTime.now();
  DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime endDate = DateTime.now().add(const Duration(days: 30));
  int nowIndex = 0;
  bool timelineIsEmpty = false; 

  // Initialisation
  @override
  void initState() {
    super.initState();
    debugPrint('------ Timeline mini InitState');
    
    // Vérifie que la timleline recoit bien des élement
    if (widget.elements != null && widget.elements.isNotEmpty) {
      // On positionne les dates de début et de fin
      if (widget.infos['startDate'] != null) {
        startDate = DateTime.parse(widget.infos['startDate']!);
      }
      // Si la timeline n'a aucun élement
      if (widget.infos['endDate'] != null) {
        endDate = DateTime.parse(widget.infos['endDate']!);
      }
    } else {
       // Indique qu'il n'y a pas de données pour cette requete.
      timelineIsEmpty = true;
    }
  
    // Formate la liste des jours pour positionner les éléments correctement
    days = formatElements(startDate, endDate, widget.elements, widget.elementsDone,
        widget.capacities);

    // Calcule l'index de la date du jour
    nowIndex = now.difference(startDate).inDays;
  }

  // Formate la liste des jours pour la timeline
  List formatElements(DateTime startDate, DateTime endDate, List elements, List elementsDone, List capacities) {
    List list = [];
    
    // On récupère le nombre de jours entre la date de début et la date de fin
    int duration = endDate.difference(startDate).inDays;

    // On parcourt les dates pour y associer les jours et les étapes en cours
    for (var dateIndex = 0; dateIndex <= duration; dateIndex++) {
      DateTime date = startDate.add(Duration(days: dateIndex));

      var capacitiesDay = capacities.firstWhere(
        (e) => e['date'] == DateFormat('yyyy-MM-dd').format(date),
        orElse: () => <String, Object>{},
      );

      // Données par défaut
      Map<String, dynamic> day = {
        'date': date,
        'lmax': 0,
      };

      // Informations sur les capacités du jour
      if (capacitiesDay != null) {
        day['lmax'] = widget.infos['lmax'] ?? 0;
        day['capeff'] = capacitiesDay.containsKey('capeff') &&
                capacitiesDay['capeff'] != null
            ? capacitiesDay['capeff']
            : 0;
        day['buseff'] = capacitiesDay.containsKey('buseff') &&
                capacitiesDay['buseff'] != null
            ? capacitiesDay['buseff']
            : 0;
        day['compeff'] = capacitiesDay.containsKey('compeff') &&
                capacitiesDay['compeff'] != null
            ? capacitiesDay['compeff']
            : 0;
      }

      list.add(day);
    }

    return list.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(color: widget.colors['primaryBackground']),
            child: Stack(
                children: [
                  Positioned.fill(
                    child: Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            days.length,
                            (index) => TimelineItem(
                              colors: widget.colors,
                              lang: widget.lang,
                              index: index,
                              nowIndex: nowIndex,
                              days: days,
                              elements: widget.elements,
                              dayWidth: dayWidth,
                              dayMargin: dayMargin,
                              height: timelineHeight,
                              openDayDetail: widget.openDayDetail,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // MESSAGE SI AUCUNE ACTIVITE
                  if (timelineIsEmpty)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.8),
                        padding: const EdgeInsets.all(25),
                        child: Center(
                          child: Text(
                            'Aucune activité ne vous a été attribuée. Vous pouvez consulter le détail des projets en utilisant le menu.',
                            style: TextStyle(
                              color: widget.colors['primaryText'], fontSize: 15),
                            )
                        ),
                      ),
                    )
                ],
            )
          )
        );
  }
}
