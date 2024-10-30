import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:carousel_slider/carousel_slider.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Widgets
import 'capacity_plan_day_item.dart';
import 'capacity_plan_filter_item.dart';

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
    required this.uspId,
    required this.projects,
    required this.planning,
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
  final String uspId;
  final dynamic projects;
  final dynamic planning;
  final dynamic capacities;
  final Function(List)? updateCapacity;

  @override
  State<CapacityPlan> createState() => _CapacityPlan();
}

class _CapacityPlan extends State<CapacityPlan> {

  // Liste des semaines sur la période demandée
  List weeks = [];

  // Date du jour
  DateTime now = DateTime.now();

  // Projet sélectionnée dans le filtre
  Map<String, dynamic> selectedProject = { 'prj_id': null, 'prj_color': null };

  // Liste des jours modifiés
  List<Map<String, dynamic>> modifiedDays = [];

  // Initialisation
  @override
  void initState() {
    super.initState();

    selectedProject = { 'prj_id': null, 'prj_color': widget.colors['accent2'] };

    weeks = formatCapacities(DateTime.parse(widget.startDate), DateTime.parse(widget.endDate), widget.planning, widget.capacities);
  }

  // Formate la liste des jours pour la timeline
  List formatCapacities(DateTime startDate, DateTime endDate, List planning, List capacities) {
    List list = [];

    // On récupère le premier jour de la semaine en cours
    DateTime weekFirstDate = startDate.subtract(Duration(days: startDate.weekday - 1));
    DateTime weekLastDate = endDate.add(Duration(days: DateTime.daysPerWeek - endDate.weekday));

    // On récupère le nombre de jours entre la date de début et la date de fin
    int duration = weekLastDate.difference(weekFirstDate).inDays + 1;

    int oldWeekIndex = 0;

    // On parcourt les dates pour y associer les jours et les étapes en cours
    for (var dateIndex = 0; dateIndex < duration; dateIndex++) {
      // Date
      DateTime date = weekFirstDate.add(Duration(days: dateIndex));
      int weekDay = date.weekday != 7 ? date.weekday : 0;

      // Numéro de la semaine du mois en cours
      int weekIndex = weeksNumber(date);

      // On vérifie si on a changé de semaine dans ce cas on en ajoute une nouvelle
      if (oldWeekIndex != weekIndex) {
        list.add([]);
      }

      var planningDay = planning.firstWhere(
        (p) => p['upl_day'] == weekDay,
        orElse: () => <String, int>{},
      );
      int upl_effort_total = planning.isNotEmpty ? planningDay['upl_effort_total'] : 0;
      
      // On positionne les jours dans la semaine
      list[list.length - 1].add({
        "date": date,
        "upl_effort_total": upl_effort_total,
        "alert": false,
        "hours": []
      });

      // On récupère s'il y a des données dans les capacity pour ce jour
      var projectDays = capacities.where(
        (e) => e['upc_date'] == DateFormat('yyyy-MM-dd').format(date)
      ).toList();

      // On positionne les heures occupées pour chaque projet
      if (projectDays.isNotEmpty) {
        for (var project in projectDays) {
          list[list.length - 1][list[list.length - 1].length - 1]['hours'] = [
            ...list[list.length - 1][list[list.length - 1].length - 1]['hours'],
            ...List<Map<String, dynamic>>.generate(project['upc_capactity_effort'], (int i) => { 'prj_id': project['prj_id'], 'prj_color': project['prj_color'], 'upc_user_busy_effort': project['upc_user_busy_effort']
            })
          ];
        }
      }

      // On remplit heures restantes
      // On calcule les heures vides non attribuées
      int remainingDays = list[list.length - 1][list[list.length - 1].length - 1]['upl_effort_total'] - list[list.length - 1][list[list.length - 1].length - 1]['hours'].length;
      // Si il y a des heures non attribuées, on les ajoute à la liste
      if (remainingDays > 0) {
        list[list.length - 1][list[list.length - 1].length - 1]['hours'] = [
          ...list[list.length - 1][list[list.length - 1].length - 1]['hours'],
          ...List<Map<String, dynamic>>.generate(remainingDays, (int i) => { 'prj_id': null, 'prj_color': widget.colors['accent2'], 'upc_user_busy_effort': 0 })
        ];
      } else if (remainingDays < 0) {
        // On limite le nombre d'heure à la capacité disponible (si trop de capacity hour ce jour)
        list[list.length - 1][list[list.length - 1].length - 1]['hours'] = list[list.length - 1][list[list.length - 1].length - 1]['hours'].sublist(0, list[list.length - 1][list[list.length - 1].length - 1]['upl_effort_total']);
      }

      // On met à jour la semaine (permet de voir si ça à changé l'itération suivante)
      oldWeekIndex = weekIndex;
    }

    return list;
  }

  // On récuère et on met à jour la valeur saisie dans le filtre
  updateFilter(Map<String, dynamic> project) {
    setState(() => {
      selectedProject = project
    });
  }

  // On met à jour la journée modifiée dans le tableau des modifications et on le renvoie à la page FlutterFlow
  updateDay(Map<String, dynamic> day, int hourIndex) {

    // Met à jour la couleur de l'heure dans la journée
    day['hours'][hourIndex] = { 'prj_id': selectedProject['prj_id'], 'prj_color': selectedProject['prj_color'] };

    // On reconstruit les capacities mis à jour par projet
    // On sépare les projets par heure
    List dayProjects = [];
    for (Map<String, dynamic> hour in day['hours']) {
      if (hour['prj_id'] != null) {
        // Si premier élément, on l'ajoute
        if (dayProjects.length == 0) {
          dayProjects.add({ 'usp_id': widget.uspId, 'prj_id': hour['prj_id'], 'upc_date': day['date'], 'upc_capactity_effort': 1 });
        } else {
          // On vérifie si le projet est déjà dans la liste
          int existingProjectIndex = dayProjects.indexWhere(
            (p) => p['prj_id'] == hour['prj_id']
          );
          if (existingProjectIndex != -1) {
            // Si le projet est dans la liste, on incrémente upc_capactity_effort
            dayProjects[existingProjectIndex]['upc_capactity_effort'] += 1;

            // On vérifie si on doit afficher une alerte si le nombre d'heures disponibles saisies
            // pour le projet est inférieure au nombre d'heures déjà affectées
            if (dayProjects[existingProjectIndex]['upc_capactity_effort'] != null && dayProjects[existingProjectIndex]['upc_capactity_effort'] < (hour['upc_user_busy_effort'] ?? 0)) {
              outerLoop: for (int weekIndex = 0; weekIndex < weeks.length; weekIndex++) {
                for (Map<String, dynamic> weekDay in weeks[weekIndex]) {
                  if (day['date'] == weekDay['date']) {
                    day['date']['alert'] = true;
                    // Si on a trouvé, on met à jour les 2 boucles
                    break outerLoop;
                  }
                }
              }
            }
          } else {
            // Si le projet n'est pas dans la liste, on l'ajoute
            dayProjects.add({ 'usp_id': widget.uspId, 'prj_id': hour['prj_id'], 'upc_date': day['date'], 'upc_capactity_effort': 1 });
          }
        }
      } else {
        dayProjects.add({ 'usp_id': widget.uspId, 'prj_id': null, 'upc_date': day['date'], 'upc_capactity_effort': 1 });
      }
    }

    // On applique le jour sélectionné à la liste de jours modifiés
    // On remet à 0 les capacity pour le jour modifié (pourgérer les supressions)
    modifiedDays.removeWhere(
      (d) => d['upc_date'] == day['date']
    );
    // On parcourt chaque projet pour l'ajouter à la liste des capacity modifiées 
    for (Map<String, dynamic> capacity in dayProjects) {
      int modifiedDaysIndex = modifiedDays.indexWhere(
        (d) => d['upc_date'] == capacity['upc_date'] && d['prj_id'] == capacity['prj_id']
      );
      // On tient à jour le tableau des modifications
      if (modifiedDaysIndex != -1) {
        modifiedDays[modifiedDaysIndex] = capacity;
      } else {
        modifiedDays.add(capacity);
      }
    }

    // Met à jour les valeurs et refresh l'affichage
    setState(() => {});

    // On envoie le callback avec la liste des modifications
    if (widget.updateCapacity != null) {
      widget.updateCapacity!.call(modifiedDays);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              enableInfiniteScroll: false,
              enlargeCenterPage: false,
              viewportFraction: 1.0,
              aspectRatio: 4/3,
            ),
            items: weeks.map((week) {
              return LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return Container(
                    color: Colors.transparent,
                    height: constraints.maxHeight,
                    width: 50 * 7,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        for (dynamic day in week)
                          CapacityPlanDayItem(
                            colors: widget.colors,
                            lang: widget.lang,
                            height: constraints.maxHeight,
                            day: day,
                            updateDay: updateDay,
                          )
                      ]
                    )
                  );
                },
              );
            }).toList(),
          ),
          if (widget.readOnly == true)
            Row(children: [
              for (dynamic project in widget.projects)
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: Container(
                        width: 15,
                        height: 15,
                        color: project['prj_color']
                      )
                    )
                  ),
                  Text(project['prj_name'],
                    style: TextStyle(
                      color: widget.colors['primaryText'],
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    )),
                ]))
            ])
          else
            Container(
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                color: widget.colors['primaryBackground'],
              ),
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: FaIcon(
                      FontAwesomeIcons.brush,
                      size: 36,
                      color: widget.colors['accent2']
                    )
                  ),
                  CapacityPlanFilterItem(
                      colors: widget.colors,
                      lang: widget.lang,
                      project: { 'prj_name': 'Aucun', 'prj_id': null, 'prj_color': widget.colors['accent2'] },
                      updateFilter: updateFilter
                    ),
                  for (dynamic project in widget.projects)
                    CapacityPlanFilterItem(
                      colors: widget.colors,
                      lang: widget.lang,
                      project: project,
                      updateFilter: updateFilter
                    )
                ]
              )
            )
        ]
      )
    );
  }
  
}