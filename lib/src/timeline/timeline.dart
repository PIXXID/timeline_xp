import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Widgets
import 'timeline_item.dart';
import 'timeline_day_info.dart';
import 'stage_row.dart';

class TimelineXp extends StatefulWidget {
  const TimelineXp(
      {Key? key,
      required this.width,
      required this.height,
      required this.colors,
      required this.lang,
      required this.projectCount,
      required this.infos,
      required this.elements,
      required this.capacities,
      required this.stages,
      required this.notifications,
      this.defaultDate,
      required this.openDayDetail,
      this.openEditStage,
      this.updateCurrentDate}) : super(key: key);

  final double width;
  final double height;
  final Map<String, Color> colors;
  final String lang;
  final int projectCount;
  final dynamic infos;
  final dynamic elements;
  final dynamic capacities;
  final dynamic stages;
  final dynamic notifications;
  final String? defaultDate;
  final Function(String, double?, List<String>?, List<dynamic>?, dynamic)? openDayDetail;
  final Function(String?)? openEditStage;
  final Function(String?)? updateCurrentDate;

  @override
  State<TimelineXp> createState() => _TimelineXp();
}

class _TimelineXp extends State<TimelineXp> {
  // Liste des jours formatés
  List days = [];

  // Valeur du slider
  double sliderValue = 0.0;
  double sliderMargin = 25;

  // Largeur d'un item jour
  double dayWidth = 40.0;
  double dayMargin = 5;
  // Hauteur de la timeline
  double timelineHeight = 240.0;
  // Diamètre des pins d'alertes
  double alertWidth = 6;
  // Liste des widgets des alertes
  List<Widget> alertList = [];

  // Liste des lignes d'étapes
  List stagesRows = [];
  // Hauteur d'une ligne d'étapes
  double rowHeight = 20.0;

  // Index de l'item jour au centre
  int centerItemIndex = 0;

  // Date de début et date de fin
  DateTime now = DateTime.now();
  DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime endDate = DateTime.now().add(const Duration(days: 60));
  int nowIndex = 0;
  int defaultDateIndex = -1;

  double sliderMaxValue = 10;

  // Controllers des scroll
  final ScrollController _controllerTimeline = ScrollController();
  final ScrollController _controllerStages = ScrollController();

  // Déclenche le scroll dans les 2 controllers (timeline et étapes)
  void _scroll(double sliderValue) {
    // gestion du scroll via le slide
    _controllerTimeline.jumpTo(sliderValue);
  }

  // Initialisation
  @override
  void initState() {
    super.initState();
    debugPrint('------ Timeline InitState');
    
    // On positionne les dates de début et de fin
    if (widget.infos['startDate'] != null) {
      startDate = DateTime.parse(widget.infos['startDate']!);
    }
    if (widget.infos['endDate'] != null) {
      endDate = DateTime.parse(widget.infos['endDate']!);
    }

    // Formate la liste des jours pour positionner les éléments correctement
    days = formatElements(startDate, endDate, widget.elements,
        widget.capacities, widget.notifications, widget.stages);

    // Formate la liste des étapes en plusieurs lignes selon les dates
    stagesRows = formatStagesRows(startDate, endDate, days, widget.stages);

    // On positionne le stage de la première ligne par jour
    days = getStageByDay(days, stagesRows);

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

        if (stagesRows.isNotEmpty) {
          _controllerStages.jumpTo(sliderValue);
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
  List formatElements(DateTime startDate, DateTime endDate, List elements,
      List capacities, List notifications, List stages) {
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
        'taskTotal': 0,
        'taskCompleted': 0,
        'elementCompleted': 0,
        'elementPending': 0,
        'preIds': [],
        'stage': {}
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
            if(element['status'] == 'validated' || element['status'] == 'finished') {
                day['elementCompleted'] += 1;
            } else if (element['status'] == 'pending' || element['status'] == 'inprogress') {
                day['elementPending'] += 1;
            }
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

      // Calcul des points d'alertes
      double progress = day['capeff'] > 0 ? (day['buseff'] / day['capeff']) * 100 : 0;
      if (progress > 99) {
        day['alertLevel'] = 2;
      } else if (progress > 80) {
        day['alertLevel'] = 1;
      }

      list.add(day);
    }

    return list.toList();
  }

  // Formate les étapes par lignes pour qu'ils ne se cheveauchent pas
  List formatStagesRows(
      DateTime startDate, DateTime endDate, List days, List stages) {
    List rows = [];

    // On parcourt les étapes pour construire les lignes
    for (int i = 0; i < stages.length - 1; i++) {
      // Dates des stages
      DateTime stageStartDate = DateTime.parse(stages[i]['sdate']);
      DateTime stageEndDate = DateTime.parse(stages[i]['edate']);

      // Prend en compte les stages commencant avant le premier élement
      if (stageStartDate.compareTo(startDate) < 0) {
        stageStartDate = startDate;
      }

      // On récupère les index des dates dans la liste
      int startDateIndex = days.indexWhere((d) =>
          DateFormat('yyyy-MM-dd').format(d["date"]) ==
          DateFormat('yyyy-MM-dd').format(stageStartDate));
      int endDateIndex = days.indexWhere((d) =>
          DateFormat('yyyy-MM-dd').format(d['date']) == DateFormat('yyyy-MM-dd').format(stageEndDate));

      stages[i]['startDateIndex'] = startDateIndex;
      stages[i]['endDateIndex'] = endDateIndex;

      // Exclue les stages hos plages de dates
      if (startDateIndex == -1 || endDateIndex == -1) {
        continue;
      }

      // Si aucun row, on crée le premier
      if (rows.isEmpty) {
        rows.add([stages[i]]);
      } else {
        // Si on au moins un row, on les parcourt pour voir dans lequel on peut se placer sans cheveaucher un autre créneau
        var added = false;
        for (var row in rows) {
          // On cherche si on cheveauche un existant
          var overlapIndex = row.indexWhere((r) {
            return (((r['endDateIndex'] + 1) >
                    stages[i]['startDateIndex'])
                ? true
                : false);
          });
          // Si il n'y a pas de cheveauchement, on l'ajoute à ce row
          if (overlapIndex == -1) {
            row.add(stages[i]);
            added = true;
            break;
          }
        }

        // Si on a pas trouvé de place dans un row existant, on créer un nouveau row
        if (!added) {
          rows.add([stages[i]]);
        }
      }
    }
    return rows;
  }

  // Positionne le stage du premier niveau pour chaque jour
  List getStageByDay(List days, List stages) {
    // On boucle sur les jours
    if (stages.isNotEmpty) {
      int index = 0;
      for (var day in days) {
        // Pour chaque jour, on récupère le stage correspondant du premier niveau
        int stageDate = stages[0].indexWhere((s) {
          return (s['startDateIndex'].toInt() <= index &&
              s['endDateIndex'].toInt() >= index);
        });
        if (stageDate != -1) {
          day['currentStage'] = stages[0][stageDate];
        }

        index++;
      }
    }

    return days;
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
            child: Stack(
                // Trait rouge indiquant le jour en cours
                children: [
                  Positioned(
                    left: screenCenter,
                    top: 0,
                    child: Container(
                      height: timelineHeight + (rowHeight * (stagesRows.length > 2 ? 2 : stagesRows.length)) + 18, // 18 = margin stages : 8 + Container vide paddingTop : 10
                      width: 1,
                      decoration: BoxDecoration(color: widget.colors['error']),
                    ),
                  ),           
                  Column(
                    children: <Widget>[
                      // Timeline
                      SizedBox(
                        width: screenWidth,
                        height: timelineHeight - 20,
                        child: ListView.builder(
                            controller: _controllerTimeline,
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(
                                horizontal: firstElementMargin),
                            itemCount: days.length,
                            itemBuilder: (BuildContext context, int index) {
                              return TimelineItem(
                                  colors: widget.colors,
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
                      // Stages
                      Container(
                          constraints: BoxConstraints(
                            minHeight: 1,
                            minWidth: double.infinity,
                            maxHeight: (rowHeight * 3) + 10,
                            maxWidth: double.infinity,
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Stack(children: [
                              Column(
                                children: List.generate(stagesRows.length,
                                    (rowIndex) {
                                return SingleChildScrollView(
                                    controller: _controllerStages,
                                    scrollDirection: Axis.horizontal,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: firstElementMargin),
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 2.0),
                                        width: days.length *
                                            (dayWidth - dayMargin),
                                        height: rowHeight,
                                        child: StageRow(
                                            colors: widget.colors,
                                            stagesList: stagesRows[rowIndex],
                                            dayWidth: dayWidth,
                                            dayMargin: dayMargin,
                                            height: rowHeight,
                                            openEditStage:
                                                widget.openEditStage)));
                              })),
                            ]),
                          )),
                      Container(
                        padding: const EdgeInsets.only(top: 10.0),
                      ),
                      TimelineDayInfo(
                          day: days[centerItemIndex],
                          colors: widget.colors,
                          lang: widget.lang
                      ),
                      Container(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 0),
                          child: Stack(clipBehavior: Clip.none, children: [
                            // Alertes positionnées
                            SizedBox(
                                width: screenWidth - (sliderMargin * 2),
                                height: 40,
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        left: sliderMargin - (alertWidth / 2)),
                                    child: Builder(builder: (context) {
                                      List<Widget> alerts = [];
                                      double screenWidthMargin =
                                          screenWidth - ((sliderMargin) * 4);

                                      // Point sur le jour en cours
                                      alerts.add(Positioned(
                                          left: (nowIndex) *
                                              screenWidthMargin /
                                              days.length,
                                          top: 0,
                                          child: GestureDetector(
                                              // Call back lors du clic
                                              onTap: () {
                                                scrollTo(nowIndex);
                                              },
                                              child: Icon(
                                                Icons.circle_rounded,
                                                size: alertWidth + 2,
                                                color: widget.colors['primary'],
                                              ))));

                                      if (days.isNotEmpty) {
                                        // On parcourt les jours et on ajoute les alertes
                                        for (var index = 0;
                                            index < days.length;
                                            index++) {
                                          if (days[index]['alertLevel'] != 0) {
                                            alerts.add(Positioned(
                                                left: (index) *
                                                    screenWidthMargin /
                                                    days.length,
                                                top: 0,
                                                child: GestureDetector(
                                                    // Call back lors du clic
                                                    onTap: () {
                                                      setState(() {
                                                        sliderValue =
                                                            index.toDouble();
                                                      });
                                                    },
                                                    child: Icon(
                                                      Icons.circle_rounded,
                                                      size: alertWidth,
                                                      color: days[index][
                                                                  'alertLevel'] ==
                                                              1
                                                          ? widget
                                                              .colors['warning']
                                                          : (days[index][
                                                                      'alertLevel'] ==
                                                                  2
                                                              ? widget.colors[
                                                                  'error']
                                                              : Colors
                                                                  .transparent),
                                                    ))));
                                          }
                                        }
                                      }

                                      return Stack(
                                          children: alerts.isNotEmpty
                                              ? alerts
                                              : [const SizedBox()]);
                                    })
                              )
                            ),
                            // Slider
                            Positioned(
                                bottom: 0,
                                child: SizedBox(
                                    width: screenWidth - (sliderMargin * 2),
                                    child: SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                        thumbColor: widget.colors['primary'],
                                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 4.0),
                                        activeTrackColor:
                                            widget.colors['primary'],
                                        inactiveTrackColor:
                                            widget.colors['accent2'],
                                        trackHeight: 2,
                                      ),
                                      child: Slider(
                                        value: sliderValue,
                                        min: 0,
                                        max: sliderMaxValue,
                                        divisions: days.length,
                                        onChanged: (double value) {
                                          sliderValue = value;
                                          _scroll(value);
                                        },
                                      ),
                                    )))
                          ])),
                    ],
                  )
                ])));
  }
}
