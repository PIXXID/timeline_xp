import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Widgets
import 'capacity_plan_day_item.dart';
import 'capacity_plan_filter_item.dart';

// Tools
import 'package:timeline_xp/src/tools/tools.dart';

class CapacityPlan extends StatefulWidget {
  const CapacityPlan({
    super.key,
    required this.width,
    required this.height,
    required this.lang,
    required this.colors,
    required this.debounceTime,
    required this.startDate,
    required this.endDate,
    required this.projects,
    required this.planning,
    required this.capacities,
    required this.updateCapacity,
  });

  final double width;
  final double height;
  final int debounceTime;
  final String lang;
  final Map<String, Color> colors;
  final String startDate;
  final String endDate;
  final dynamic projects;
  final dynamic planning;
  final dynamic capacities;
  final Function(List<Map<String, dynamic>>)? updateCapacity;

  @override
  State<CapacityPlan> createState() => _CapacityPlanState();
}

class _CapacityPlanState extends State<CapacityPlan> {

  Timer? _debounceTimer;

  double daySize = 25;

  // Liste des semaines sur la période demandée
  Map<String, dynamic> weeks = {};

  // Date du jour
  DateTime now = DateTime.now();

  // Projet sélectionnée dans le filtre
  Map<String, dynamic> selectedProject = { 'prj_id': null, 'prj_color': null };

  // Liste des jours modifiés
  List<Map<String, dynamic>> modifiedDays = [];

  final ScrollController _scrollController = ScrollController();
  // double _scrollAmount = 500.0;
  double weekWidth = 500;

  // Initialisation
  @override
  void initState() {
    super.initState();

    selectedProject = { 'prj_id': null, 'prj_color': '#5C5E71' };

    weeks = formatCapacities(DateTime.parse(widget.startDate), DateTime.parse(widget.endDate), widget.planning, widget.capacities);

    // Exécuter une seule fois après la construction du widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // On scroll sur la date du jour par défaut
      _scrollRight();
    });
  }

  // Formate la liste des jours pour la timeline
  Map<String, dynamic> formatCapacities(DateTime startDate, DateTime endDate, List planning, List capacities) {

    Map<String, dynamic> weeksResult = { 'maxEffortTotal': 0, 'list': [] };

    // On récupère le premier jour de la semaine en cours
    DateTime weekFirstDate = startDate.subtract(Duration(days: startDate.weekday - 1));
    DateTime weekLastDate = endDate.add(Duration(days: DateTime.daysPerWeek - endDate.weekday));

    // On récupère le nombre de jours entre la date de début et la date de fin
    int duration = weekLastDate.difference(weekFirstDate).inDays + 1;

    int oldWeekNumber = 0;
    int weekIndex = -1;
    int dateIndex = 0;
    int maxEffortTotal = 0;
    // On parcourt les dates pour y associer les jours et les étapes en cours
    for (var i = 0; i < duration; i++) {
      // Date
      DateTime date = weekFirstDate.add(Duration(days: i));

      // Numéro de la semaine du mois en cours
      int weekNumber = weeksNumber(date, 0);

      // On vérifie si on a changé de semaine dans ce cas on en ajoute une nouvelle
      if (oldWeekNumber != weekNumber) {
        weeksResult['maxEffortTotal'] = maxEffortTotal;
        weeksResult['list'].add([]);
        weekIndex++;
        maxEffortTotal = 0;
        dateIndex = 0;
      }
      
      // Ajoute le jour de la boucle formatté à la semaine en cours
      var formatedDay = formatDay(date, weekIndex, dateIndex, planning, capacities);
      weeksResult['list'][weeksResult['list'].length - 1].add(formatedDay);

      if (maxEffortTotal < formatedDay['upl_effort_total']) {
        maxEffortTotal = formatedDay['upl_effort_total'];
      }
      
      dateIndex++;
      // On met à jour la semaine (permet de voir si ça à changé l'itération suivante)
      oldWeekNumber = weekNumber;
    }

    return weeksResult;
  }

  // Renvoie le jour demandé formatté
  Map<String, dynamic> formatDay(DateTime date, int weekIndex, int dayIndex, List planning, List capacities) {

    // On récupère le nom du jour de la semaine
    int weekDay = date.weekday != 7 ? date.weekday : 0;
    // On récupère l'effort total saisi dans le planning pour le jour de la semaine
    var planningDay = planning.firstWhere(
      (p) => p['upl_day'] == weekDay,
      orElse: () => <String, int>{},
    );
    int uplEffortTotal = planning.isNotEmpty ? planningDay['upl_effort_total'] : 0;

    // On positionne les jours dans la semaine
    Map<String, dynamic> dayDate = {
      "date": date,
      "weekIndex": weekIndex,
      "dayIndex": dayIndex,
      "upl_effort_total": uplEffortTotal,
      "busy_effort": [],
      "readOnly": date.difference(now).inDays < 0,
      "hours": []
    };

    // On récupère s'il y a des données dans les capacity pour ce jour
    var projectDays = capacities.where(
      (e) => e['upc_date'] == DateFormat('yyyy-MM-dd').format(date)
    ).toList();

    // On positionne les heures occupées pour chaque projet
    if (projectDays.isNotEmpty) {
      for (var project in projectDays) {
        // On remplit les valeurs des heures
        dayDate['hours'] = [
          ...dayDate['hours'],
          ...List<Map<String, dynamic>>.generate(project['upc_capacity_effort'], (int i) => { 'prj_id': project['prj_id'], 'prj_name': project['prj_name'], 'prj_color': project['prj_color'] })
        ];
        // On remplit le nombre d'heures déjà affectés par projet
        if (dayDate['busy_effort'].indexWhere((d) => project['prj_id'] == d['prj_id']) != -1) {
          dayDate['busy_effort'] = { "prj_id": project['prj_id'], "upc_user_busy_effort": project['upc_user_busy_effort'] };
        } else {
          dayDate['busy_effort'].add({ "prj_id": project['prj_id'], "upc_user_busy_effort": project['upc_user_busy_effort'] });
        }
      }
    }

    // On remplit heures restantes
    // On calcule les heures vides non attribuées
    int remainingDays = dayDate['upl_effort_total'] - dayDate['hours'].length;
    // Si il y a des heures non attribuées, on les ajoute à la liste
    if (remainingDays > 0) {
      dayDate['hours'] = [
        ...dayDate['hours'],
        ...List<Map<String, dynamic>>.generate(remainingDays, (int i) => { 'prj_id': null, 'prj_name': null, 'prj_color': '#5C5E71' })
      ];
    } else if (remainingDays < 0) {
      // On limite le nombre d'heure à la capacité disponible (si trop de capacity hour ce jour)
      dayDate['hours'] = dayDate['hours'].sublist(0, dayDate['upl_effort_total']);
    }

    return dayDate;
  }

  // On récuère et on met à jour la valeur saisie dans le filtre
  void updateFilter(Map<String, dynamic> project) {
    selectedProject = project;
    setState(() => {});
  }

  // On met à jour la journée modifiée dans le tableau des modifications et on le renvoie à la page FlutterFlow
  void updateDay(Map<String, dynamic> day, int hourIndex) {

    // Met à jour la couleur de l'heure dans la journée
    day['hours'][hourIndex]['prj_id'] = selectedProject['prj_id'];
    day['hours'][hourIndex]['prj_color'] = selectedProject['prj_color'];
    
    // On reconstruit les capacities mis à jour par projet
    // On sépare les projets par heure
    List dayProjects = [];

    // On positionne les projets déjà présents sur le jour (pour les conserver en cas de suppression totale du projet)
    for (Map<String, dynamic> projectEffort in day['busy_effort']) {
      dayProjects.add({ 'prj_id': projectEffort['prj_id'], 'upc_date': DateFormat('yyyy-MM-dd').format(day['date']), 'upc_capacity_effort': 0 });
    }
    if (dayProjects.indexWhere((s) => s['prj_id'] == selectedProject['prj_id']) != -1) {
      dayProjects.add({ 'prj_id': selectedProject['prj_id'], 'upc_date': DateFormat('yyyy-MM-dd').format(day['date']), 'upc_capacity_effort': 0 });
    }

    // On parcours les projets 
    for (Map<String, dynamic> hour in day['hours']) {
      if (hour['prj_id'] != null) {
        // Si premier élément, on l'ajoute
        if (dayProjects.isEmpty) {
          dayProjects.add({ 'prj_id': hour['prj_id'], 'upc_date': DateFormat('yyyy-MM-dd').format(day['date']), 'upc_capacity_effort': 1 });
        } else {
          // On vérifie si le projet est déjà dans la liste
          int existingProjectIndex = dayProjects.indexWhere(
            (p) => p['prj_id'] == hour['prj_id']
          );
          if (existingProjectIndex != -1) {
            // Si le projet est dans la liste, on incrémente upc_capacity_effort
            dayProjects[existingProjectIndex]['upc_capacity_effort'] += 1;
          } else {
            // Si le projet n'est pas dans la liste, on l'ajoute
            dayProjects.add({ 'prj_id': hour['prj_id'], 'upc_date': DateFormat('yyyy-MM-dd').format(day['date']), 'upc_capacity_effort': 1 });
          }
        }
      }
    }

    // On applique le jour sélectionné à la liste de jours modifiés
    // On remet à 0 les capacity pour le jour modifié (pour gérer les supressions)
    modifiedDays.removeWhere(
      (d) => d['upc_date'] == DateFormat('yyyy-MM-dd').format(day['date'])
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
       // Annule le précédent timer s'il existe
      _debounceTimer?.cancel();
      // Démarre un nouveau timer
      _debounceTimer = Timer(Duration(milliseconds: widget.debounceTime), () {
        // Déclenche le call back
        widget.updateCapacity!.call(modifiedDays);
        // // Remet à 0 les données
        // modifiedDays = [];
      });
    }
  }

  // Annule les modifications du jour
  void resetDay(Map<String, dynamic> day) {
    weeks['list'][day['weekIndex']][day['dayIndex']] = formatDay(day['date'], day['weekIndex'], day['dayIndex'], widget.planning, widget.capacities);
    setState(() => {});
  }

  // Fonction pour faire défiler vers la droite
  void _scrollRight() {
    if (_scrollController.position.pixels < _scrollController.position.maxScrollExtent) {
      _scrollController.animateTo(
        _scrollController.offset + weekWidth,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Fonction pour faire défiler vers la gauche
  void _scrollLeft() {
    if (_scrollController.position.pixels > _scrollController.position.minScrollExtent) {
      _scrollController.animateTo(
        _scrollController.offset - weekWidth,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel(); // Nettoie le timer lors de la destruction du widget
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    weekWidth = MediaQuery.of(context).size.width - 30;
    daySize = (weekWidth) / 7;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // Liste des semaines et des jours
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15),
                child: GestureDetector(
                  onHorizontalDragEnd: (DragEndDetails details) {
                    if (details.velocity.pixelsPerSecond.dx < 0) {
                      // Glissement vers la gauche (défile vers la droite)
                      _scrollRight();
                    } else if (details.velocity.pixelsPerSecond.dx > 0) {
                      // Glissement vers la droite (défile vers la gauche)
                      _scrollLeft();
                    }
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: weeks['list'].length,
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        width: weekWidth,
                        height: 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            for (dynamic day in weeks['list'][index])
                              CapacityPlanDayItem(
                                colors: widget.colors,
                                lang: widget.lang,
                                daySize: daySize,
                                height: 200,
                                maxEffortTotal: weeks['maxEffortTotal'],
                                day: day,
                                resetDay: resetDay,
                                updateDay: updateDay,
                              )
                          ]
                        )
                      );
                    }
                  )
                )
              )
          ),
          // Filtres des projets
          Container(
            height: 60,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(12.0)),
              color: widget.colors['primaryBackground'],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: FaIcon(
                      FontAwesomeIcons.brush,
                      size: 36,
                      color: widget.colors['secondaryText']
                    )
                  ),
                  CapacityPlanFilterItem(
                      colors: widget.colors,
                      lang: widget.lang,
                      project: const { 'prj_name': 'Aucun', 'prj_id': null, 'prj_color': '#5C5E71' },
                      selectedProject: selectedProject,
                      updateFilter: updateFilter
                    ),
                  for (dynamic project in widget.projects)
                    CapacityPlanFilterItem(
                      colors: widget.colors,
                      lang: widget.lang,
                      project: project,
                      selectedProject: selectedProject,
                      updateFilter: updateFilter
                    )
                ]
              )
            )
          )
        ]
      )
    );
  }
  
}