import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Widgets
import 'timeline_item.dart';
import 'timeline_day_info.dart';
import 'timeline_day_indicators.dart';

class TimelineMini extends StatefulWidget {
  const TimelineMini(
      {Key? key,
      required this.width,
      required this.height,
      required this.colors,
      required this.isDarkMode,
      required this.lang,
      required this.projectCount,
      required this.infos,
      required this.elements,
      required this.elementsDone,
      required this.capacities,
      this.defaultDate,
      required this.openDayDetail,
      this.updateCurrentDate}) : super(key: key);

  final double width;
  final double height;
  final Map<String, Color> colors;
  final bool isDarkMode;
  final String lang;
  final int projectCount;
  final dynamic infos;
  final dynamic elements;
  final dynamic elementsDone;
  final dynamic capacities;
  final String? defaultDate;
  final Function(String, double?, List<String>?, List<dynamic>?, dynamic)? openDayDetail;
  final Function(String?)? updateCurrentDate;

  @override
  State<TimelineMini> createState() => _TimelineMini();
}

class _TimelineMini extends State<TimelineMini> {
  // Liste des jours formatés
  List days = [];

  // Valeur du slider
  double sliderValue = 0.0;
  double sliderMaxValue = 10;

  // Largeur d'un item jour
  double dayWidth = 45.0;
  double dayMargin = 5;
  // Hauteur de la timeline
  double timelineHeight = 160.0;
  // Diamètre des pins d'alertes
  double alertWidth = 6;
  // Liste des widgets des alertes
  List<Widget> alertList = [];

  // Liste des lignes d'étapes
  List stagesRows = [];
  // Hauteur d'une ligne d'étapes
  double rowHeight = 30.0;

  // Index de l'item jour au centre
  int centerItemIndex = 0;

  // Date de début et date de fin par défaut
  DateTime now = DateTime.now();
  DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime endDate = DateTime.now().add(const Duration(days: 30));
  int nowIndex = 0;
  int defaultDateIndex = -1;
  bool timelineIsEmpty = false; 

  // Controllers des scroll
  final ScrollController _controllerTimeline = ScrollController();

  // Déclenche le scroll dans les 2 controllers (timeline et étapes)
  void _scroll(double sliderValue) {
    // gestion du scroll via le slide
    _controllerTimeline.jumpTo(sliderValue);
  }

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

    // Calcule la valeur maximum du slider
    sliderMaxValue = days.length.toDouble() * (dayWidth - dayMargin);

    // Calcule l'index de la date du jour
    nowIndex = now.difference(startDate).inDays;

    // Calcule l'index de la date positionnée par défaut
    if (widget.defaultDate != null) {
      defaultDateIndex = DateTime.parse(widget.defaultDate!).difference(startDate).inDays + 1;
    }

    // Écoute du scroll pour :
    // - calculer quel élément est au centre
    // - mettre à jour la valeur du slide
    // - reporter le scroll sur les étapes
    _controllerTimeline.addListener(() {
      if (_controllerTimeline.offset >= 0 &&
          _controllerTimeline.offset < sliderMaxValue) {
        // Met à jour les valeurs
        setState(() {
          // On calcule l'élément du center
          int centerValue = (sliderValue / (dayWidth - dayMargin)).round();
          if (centerValue >= 0 && centerValue <= days.length - 1) {
            centerItemIndex = centerValue;
          }

          sliderValue = _controllerTimeline.offset;
        });

        if (widget.updateCurrentDate != null && days[centerItemIndex] != null && days[centerItemIndex]['date'] != null) {
          String dayDate = DateFormat('yyyy-MM-dd').format(days[centerItemIndex]['date']);
          widget.updateCurrentDate!.call(dayDate);
        }

      }
    });

    // Exécuter une seule fois après la construction du widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // On scroll sur la date du jour par défaut
      scrollTo(widget.defaultDate != null ? defaultDateIndex : nowIndex);
    });
  }

  // Destruction du widget
  @override
  void dispose() {
    // On enlève l'écoute du scroll de la timeline
    _controllerTimeline.removeListener(() {});
    super.dispose();
  }

  // Formate la liste des jours pour la timeline
  List formatElements(DateTime startDate, DateTime endDate, List elements, List elementsDone, List capacities) {
    List list = [];
    
    // On récupère le nombre de jours entre la date de début et la date de fin
    int duration = endDate.difference(startDate).inDays;

    // On parcourt les dates pour y associer les jours et les étapes en cours
    for (var dateIndex = 0; dateIndex <= duration; dateIndex++) {
      DateTime date = startDate.add(Duration(days: dateIndex));

      var elementDay = elements
          .where(
            (e) => e['date'] == DateFormat('yyyy-MM-dd').format(date),
          )
          .toList();

      var capacitiesDay = capacities.firstWhere(
        (e) => e['date'] == DateFormat('yyyy-MM-dd').format(date),
        orElse: () => <String, Object>{},
      );

      // Données par défaut
      Map<String, dynamic> day = {
        'date': date,
        'lmax': 0,
        'activityTotal': 0,
        'activityCompleted': 0,
        'delivrableTotal': 0,
        'delivrableCompleted': 0,
        'elementCompleted': 0,
        'elementPending': 0,
        'preIds': [],
      };

      // Si on a des éléments on les comptes
      if (elementDay.isNotEmpty) {
        // On boucle sur les éléments pour compter le nombre d'activité/livrables/tâches
        for (Map<String, dynamic> element in elementDay) {
          if (day['preIds'].indexOf(element['pre_id']) == -1) {
            // On construit la liste des éléments (qui sera transmise lors du clic)
            day['preIds'].add(element['pre_id']);

            // Selon le type d'éléments on construit les compteurs
            switch (element['nat']) {
              case 'activity':
                if (element['status'] == 'status') {
                  day['activityCompleted'] += 1;
                }
                day['activityTotal']++;
                break;
              case 'delivrable':
                if (element['status'] == 'status') {
                  day['delivrableCompleted'] += 1;
                }
                day['delivrableTotal']++;
                break;
              case 'task':
                if (element['status'] == 'status') {
                  day['taskCompleted'] += 1;
                }
                day['taskTotal']++;
                break;
            }

            // Compte le nombres d'element terminé et en attente/encours
            if (element['status'] == 'validated' || element['status'] == 'finished') {
                day['elementCompleted'] += 1;
            } else if (element['status'] == 'pending' || element['status'] == 'inprogress') {
                day['elementPending'] += 1;
            }
          }
        }
      }

      // Ajoute les élements terminée dans la liste des preIds
      if (elementsDone.isNotEmpty) {
        for (dynamic element in elementsDone) {         
          // Date et preId
          if (element['date'] == DateFormat('yyyy-MM-dd').format(date) && day['preIds'].indexOf(element['pre_id']) == -1) {
            day['preIds'].add(element['pre_id']);
          }
        }
      }

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

  // Scroll à une date
  void scrollTo(int dateIndex) {
    if (dateIndex >= 0) {
      // On calcule la valeur du scroll en fonction de la date
      double scroll = dateIndex * (dayWidth - dayMargin);

      // Met à jour la valeur du scroll et scroll
      setState(() {
        sliderValue = scroll;
      });
      _scroll(sliderValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    // On calcule le padding pour avoir le début et la fin de la timeline au milieu de l'écran
    double screenWidth = MediaQuery.sizeOf(context).width;
    double firstElementMargin = ((screenWidth - (dayWidth - dayMargin)) / 2);
    double screenCenter = (screenWidth / 2);

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(color: widget.colors['primaryBackground']),
            child: Stack(
                // Trait rouge indiquant le jour en cours
                children: [
                  Positioned(
                    left: screenCenter,
                    top: 35,
                    child: Container(
                      height: 85,
                      width: 1,
                      decoration: BoxDecoration(color: widget.colors['error']),
                    ),
                  ),
                  Positioned.fill(
                    child: Column(
                      children: <Widget>[
                        // TIMELINE DYNAMIQUE
                        SizedBox(
                          width: screenWidth,
                          height: timelineHeight - 30,
                          child: ListView.builder(
                              controller: _controllerTimeline,
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.symmetric(
                                  horizontal: firstElementMargin),
                              itemCount: days.length,
                              itemBuilder: (BuildContext context, int index) {
                                return TimelineItem(
                                    colors: widget.colors,
                                    isDarkMode: widget.isDarkMode,
                                    lang: widget.lang,
                                    index: index,
                                    centerItemIndex: centerItemIndex,
                                    nowIndex: nowIndex,
                                    days: days,
                                    elements: widget.elements,
                                    dayWidth: dayWidth,
                                    dayMargin: dayMargin,
                                    height: timelineHeight,
                                    openDayDetail: widget.openDayDetail);
                              }),
                        ),
                        // INFO DU JOUR
                        TimelineDayInfo(
                          day: days[centerItemIndex],
                          colors: widget.colors,
                          lang: widget.lang,
                          elements: widget.elements,
                          openDayDetail: widget.openDayDetail),
                      ],
                    )
                  ),
                  Positioned.fill(
                    left: 1,
                    top: 35,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      // INDICATEURS
                      child: TimelineDayIndicators(
                          day: days[centerItemIndex],
                          colors: widget.colors,
                          isDarkMode: widget.isDarkMode,
                          lang: widget.lang,
                          elements: widget.elements)
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
