library timeline_xp;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'timeline_item.dart';
import 'timeline_item_detail.dart';
import 'stage_row.dart';
import 'custom_thumb_shape.dart';

class Timeline extends StatefulWidget {
  const Timeline(
      {super.key,
      required this.width,
      required this.height,
      required this.colors,
      this.project,
      required this.elements,
      required this.stages,
      required this.openDayDetail,
      required this.openAddStage});

  final double width;
  final double height;
  final Map<String, Color> colors;
  final dynamic project;
  final List elements;
  final List stages;
  final Function(String, String?)? openDayDetail;
  final Function(String?)? openAddStage;

  @override
  State<Timeline> createState() => _Timeline();
}

class _Timeline extends State<Timeline> {
  // Liste des jours formatés
  List days = [];

  // Valeur du slider
  double sliderValue = 0.0;
  double sliderMargin = 25;

  // Largeur d'un item jour
  double dayWidth = 80.0;
  double dayMargin = 24;
  // Hauteur de la timeline
  double timelineHeight = 220.0;
  // Hauteur du détail de la timeline
  double timelineDetailHeight = 40;
  // Hauteur du slider
  double sliderHeight = 50;
  // Hauteur du label de la date
  double dateLabelHeight = 30;

  // Diamètre des pins d'alertes
  double alertWidth = 20;
  // Liste des widgets des alertes
  List<Widget> alertList = [];

  // Liste des lignes d'étapes
  List stagesRows = [];
  // Hauteur d'une ligne d'étapes
  double rowHeight = 30.0;

  // Index de l'item jour au centre
  int centerItemIndex = 0;

  // Multiprojet ? (journal de bord)
  bool isMultiproject = false;

  // Date de début et date de fin
  DateTime now = DateTime.now();
  DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime endDate = DateTime.now().add(const Duration(days: 60));

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
    // Est-ce qu'on est en multiprojets (journal de bord)
    isMultiproject = widget.project != null ? false : true;

    // On positionne les dates de début et de fin
    if (widget.project != null) {
      startDate = DateTime.parse(widget.project['prj_startdate']);
      endDate = DateTime.parse(widget.project['prj_enddate']);
    } else {
      startDate = DateTime(now.year, now.month, now.day)
          .subtract(const Duration(days: 30));
      endDate =
          DateTime(now.year, now.month, now.day).add(const Duration(days: 60));
    }

    // Formate la liste des jours pour positionner les éléments correctement
    days = formatElements(startDate, endDate, widget.elements, widget.stages);

    // Formate la liste des étapes en plusieurs lignes selon les dates
    stagesRows = formatStagesRows(days, widget.stages);

    double stagesHeight = rowHeight * stagesRows.length;
    timelineHeight = (widget.height + 10) -
        (sliderHeight + sliderMargin) -
        dateLabelHeight -
        (isMultiproject ? timelineDetailHeight : 0) -
        stagesHeight -
        80;

    // Écoute du scroll pour :
    // - calculer quel élément est au centre
    // - mettre à jour la valeur du slide
    // - reporter le scroll sur les étapes
    _controllerTimeline.addListener(() {
      if (_controllerTimeline.offset >= 0) {
        // Met à jour les valeurs
        setState(() {
          // On calcule l'élément du center
          int centerValue = (sliderValue / (dayWidth - dayMargin)).round();
          if (centerValue >= 0 && centerValue <= days.length - 1) {
            centerItemIndex = centerValue;
          }

          sliderValue = _controllerTimeline.offset;
        });

        if (stagesRows.isNotEmpty) {
          _controllerStages.jumpTo(sliderValue);
        }
      }
    });

    super.initState();
  }

  // Destruction du widget
  @override
  void dispose() {
    // On enlève l'écoute du scroll de la timeline
    _controllerTimeline.removeListener(() {});
    super.dispose();
  }

  // Formate la liste des jours pour la timeline
  List formatElements(
      DateTime startDate, DateTime enDate, List elements, List stages) {
    List list = [];

    // On récupère le nombre de jours entre la date de début et la date de fin
    int duration = endDate.difference(startDate).inDays;

    // On parcourt les dates pour y associer les jours et les étapes en cours
    for (var dateIndex = 0; dateIndex < duration - 1; dateIndex++) {
      DateTime date = startDate.add(Duration(days: dateIndex));
      // Liste des étapes du jour
      List stagesByDay = [];

      var elementDay = elements.firstWhere(
          (e) => e['date'] == DateFormat('yyyy-MM-dd').format(date),
          orElse: () => null);

      // On regarde quels sont les étapes en cours ce jour
      stagesByDay = stages
          .where((s) =>
              date.isAfter(DateTime.parse(s['startDate'])) &&
              date.isBefore(DateTime.parse(s['endDate'])))
          .toList();

      if (elementDay != null) {
        elementDay['date'] = DateTime.parse(elementDay['date']);
        elementDay['stages'] = stagesByDay;
        list.add(elementDay);
      } else {
        list.add({
          'date': date,
          'capacityLevelMax': 0,
          'alertLevel': 0,
          stages: stagesByDay
        });
      }
    }

    return list.toList();
  }

  // Formate les étapes par lignes pour qu'ils ne se cheveauchent pas
  List formatStagesRows(List days, List stages) {
    List rows = [];

    // On parcourt les étapes pour construire les lignes
    for (int i = 0; i < stages.length - 1; i++) {
      DateTime stageStartDate = DateTime.parse(stages[i]['startDate']);
      DateTime stageEndDate = DateTime.parse(stages[i]['endDate']);
      if (stageStartDate.compareTo(startDate) > 0 &&
          stageEndDate.compareTo(endDate) < 0) {
        // On récupère les index des dates dans la liste
        int startDateIndex =
            days.indexWhere((d) => d['date'] == stageStartDate);
        int endDateIndex = days.indexWhere((d) => d['date'] == stageEndDate);
        stages[i]['startDateIndex'] = startDateIndex;
        stages[i]['endDateIndex'] = endDateIndex;

        // Si aucun row, on crée le premier
        if (rows.isEmpty) {
          rows.add([stages[i]]);
        } else {
          // Si on au moins un row, on les parcourt pour voir dans lequel on peut se placer sans cheveaucher un autre créneau
          var added = false;
          for (var row in rows) {
            // On cherche si on cheveauche un existant
            var overlapIndex = row.indexWhere((r) =>
                r['startDateIndex'] < stages[i]['endDateIndex'] + 1 &&
                r['endDateIndex'] > stages[i]['startDateIndex'] + 1);
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
    }

    // Si on est sur la page projet, on ajoute un ligne avec un bouton
    if (!isMultiproject) {
      rows.add([]);
    }

    return rows;
  }

  // Renvoie le nombre de semaines depuis le début de l'année
  int weeksNumber(DateTime date) {
    final now = DateTime.now();
    final firstJan = DateTime(now.year, 1, 1);
    final from = DateTime.utc(firstJan.year, firstJan.month, firstJan.day);
    final currentDate = DateTime.utc(date.year, date.month, date.day);
    return ((currentDate.difference(from).inDays + 1) / 7).ceil();
  }

  @override
  Widget build(BuildContext context) {
    // On calcule le padding pour avoir le début et la fin de la timeline au milieu de l'écran
    double screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Stack(

                /// Fond indiquant le jour en cours
                children: [
                  Positioned(
                    left: (screenWidth / 2) - (dayWidth / 2),
                    top: 0,
                    child: Container(
                      height: timelineHeight +
                          (stagesRows.length *
                              (rowHeight > 2 ? rowHeight : 2)) +
                          (isMultiproject ? 60 : (timelineDetailHeight - 10)),
                      width: dayWidth - dayMargin,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                            const Color(0xffffffff).withAlpha(0),
                            const Color(0xffffffff).withAlpha(70),
                          ],
                              stops: const [
                            0,
                            0.8
                          ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter)),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      SizedBox(
                        width: screenWidth,
                        height: timelineHeight + 50,
                        child: ListView.builder(
                            controller: _controllerTimeline,
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(
                                horizontal: (screenWidth / 2) -
                                    ((dayWidth - dayMargin) / 2)),
                            itemCount: days.length,
                            itemBuilder: (BuildContext context, int index) {
                              return TimelineItem(
                                  colors: widget.colors,
                                  index: index,
                                  centerItemIndex: centerItemIndex,
                                  days: days,
                                  dayWidth: dayWidth,
                                  dayMargin: dayMargin,
                                  height: timelineHeight,
                                  isMultiproject: isMultiproject,
                                  openDayDetail: widget.openDayDetail);
                            }),
                      ),
                      Container(
                          constraints: BoxConstraints(
                            minHeight: 1,
                            minWidth: double.infinity,
                            maxHeight: (rowHeight * 2) + 8,
                            maxWidth: double.infinity,
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Stack(

                                /// Fond indiquant le jour en cours
                                children: [
                                  Column(
                                      children: List.generate(stagesRows.length,
                                          (rowIndex) {
                                    return SingleChildScrollView(
                                        controller: _controllerStages,
                                        scrollDirection: Axis.horizontal,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: (screenWidth / 2) -
                                                ((dayWidth - dayMargin) / 2)),
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
                                                stagesList:
                                                    stagesRows[rowIndex],
                                                dayWidth: dayWidth,
                                                dayMargin: dayMargin,
                                                height: rowHeight,
                                                isMultiproject: isMultiproject,
                                                openAddStage:
                                                    widget.openAddStage)));
                                  })),
                                  if (!isMultiproject)
                                    Positioned(
                                        left: (screenWidth / 2) -
                                            ((dayWidth - dayMargin) / 2),
                                        bottom: 0,
                                        child: SizedBox(
                                            height: rowHeight,
                                            width: dayWidth - dayMargin,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      widget.colors[
                                                          'primaryBackground'],
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  tapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                  elevation: 0,
                                                  side: BorderSide(
                                                    width: 1.0,
                                                    color: widget
                                                        .colors['accent2']!,
                                                  ),
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                ),
                                                onPressed: () {
                                                  widget.openAddStage
                                                      ?.call(null);
                                                },
                                                child: Icon(
                                                  Icons.add,
                                                  size: 20,
                                                  color: widget
                                                      .colors['primaryText'],
                                                ))))
                                ]),
                          )),
                      Container(height: 2, color: widget.colors['accent2']),
                      TimelineItemDetail(
                          colors: widget.colors,
                          timelineDetailHeight: timelineDetailHeight,
                          days: days,
                          centerItemIndex: centerItemIndex,
                          isMultiproject: isMultiproject),
                      Padding(
                          padding: const EdgeInsets.only(bottom: 25),
                          child: Container(
                              padding: const EdgeInsets.only(
                                  left: 10, top: 5, right: 10, bottom: 5),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                  color: widget.colors['accent2']),
                              child: Text(
                                '${DateFormat.MMMM('fr_FR').format(days[centerItemIndex]['date'])}    S${weeksNumber(days[centerItemIndex]['date'])}',
                                style: TextStyle(
                                    color: widget.colors['primaryText'],
                                    fontSize: 11, // Taille de l'icône
                                    fontWeight: FontWeight.w400),
                              ))),
                      Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: sliderMargin),
                          child: Stack(clipBehavior: Clip.none, children: [
                            // Alertes positionnées
                            SizedBox(
                                width: screenWidth - (sliderMargin * 2),
                                height: 50,
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        left: sliderMargin - (alertWidth / 2)),
                                    child: Builder(builder: (context) {
                                      List<Widget> alerts = [];
                                      double screenWidthMargin =
                                          screenWidth - ((sliderMargin) * 4);
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
                                    }))),
                            // Slider
                            Positioned(
                                bottom: 0,
                                child: SizedBox(
                                    width: screenWidth - (sliderMargin * 2),
                                    child: SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                        thumbShape: CustomThumbShape(
                                            colors: widget.colors,
                                            iconLeft:
                                                Icons.chevron_left_rounded,
                                            iconRight:
                                                Icons.chevron_right_rounded),
                                        activeTrackColor:
                                            widget.colors['primary'],
                                        inactiveTrackColor:
                                            widget.colors['accent2'],
                                        trackHeight: 8,
                                      ),
                                      child: Slider(
                                        value: sliderValue,
                                        min: 0,
                                        max: days.length.toDouble() *
                                            (dayWidth - dayMargin),
                                        divisions: days.length,
                                        onChanged: (double value) {
                                          sliderValue = value;
                                          _scroll(value);
                                        },
                                      ),
                                    )))
                          ])),
                    ],
                  ),
                ])));
  }
}