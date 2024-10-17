import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'heatmap_month_item.dart';


class Heatmap extends StatefulWidget {
  const Heatmap({
    super.key,
    required this.width,
    required this.height,
    required this.lang,
    required this.colors,
    required this.daySize,
    required this.dateInterval,
    required this.capacities,
    required this.selectDay,
  });

  final double width;
  final double height;
  final String lang;
  final Map<String, Color> colors;
  final double daySize;
  final dynamic dateInterval;
  final dynamic capacities;
  final Function(String?)? selectDay;

  @override
  State<Heatmap> createState() => _Heatmap();
}

class _Heatmap extends State<Heatmap> {
  String? selectedDate = "";
  int selectedDateMonthIndex = 0;

  // Liste des jours/mois formatés
  List months = [];

  // Date de début et date de fin
  DateTime now = DateTime.now();
  DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime endDate = DateTime.now().add(const Duration(days: 60));

  // Conroller de scroll pour scroller jusqu'au mois en cours
  final ScrollController _controllerHeatmap = ScrollController();

  // Initialisation
  @override
  void initState() {
    super.initState();

    // On positionne les dates de début et de fin
    if (widget.dateInterval['prj_startdate'] != null) {
      startDate = DateTime.parse(widget.dateInterval['prj_startdate']!);
    }
    if (widget.dateInterval['prj_enddate'] != null) {
      endDate = DateTime.parse(widget.dateInterval['prj_enddate']!);
    }

    // On récupère les données formatées
    months = formatData(startDate, endDate, widget.capacities, widget.lang, widget.colors);

    setState(() {
      // On met à jour la date sélectionnée avec la date par défaut = aujourd'hui
      selectedDate = DateFormat('yyyy-MM-dd').format(now);
    });

    // On récupère le mois du jour par défaut pour récupérer son index dans les mois affichés
    int currentMonth = int.parse(DateFormat.M().format(now));
    int monthIndex = months.indexWhere((m) {
      return int.parse(m['monthNum']) == currentMonth.toInt();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controllerHeatmap.jumpTo((monthIndex + 1) * (widget.daySize * 4));
    });
  }

  Color? formatStringToColor(String? color) {
    if (color == null || color.isEmpty) {
      return null; // Si la chaîne est nulle ou vide, on retourne null
    }

    // On enlève le # si présent
    String cleanedColor = color.replaceAll('#', '');

    // Si la chaîne a 6 caractères, on ajoute 'FF' pour une opacité maximale
    if (cleanedColor.length == 6) {
      cleanedColor = 'FF$cleanedColor';
    }

    try {
      // Conversion de la chaîne en entier et retour de la couleur
      return Color(int.parse(cleanedColor, radix: 16));
    } catch (e) {
      // En cas d'erreur de parsing, retourne null
      return null;
    }
  }

  // Retourne le numéro de la semaine
  int weeksNumber(DateTime date) {
    // Trouver le premier jour de l'année
    DateTime firstDayOfYear = DateTime(date.year, 1, 1);

    // Calculer le jour de la semaine pour le premier jour de l'année
    int firstDayWeekday = firstDayOfYear.weekday;

    // Calculer le nombre de jours entre la date et le premier jour de l'année
    int daysDifference = date.difference(firstDayOfYear).inDays + 1;

    // Calculer le numéro de la semaine en se basant sur la différence de jours
    return ((daysDifference + firstDayWeekday) / 7).ceil();
  }

  // Formatte la liste des mois/semaines/jours pour l'afficher sous forme de heatmap
  List formatData(DateTime startDate, DateTime endDate, List capacities, String lang, Map<String, Color> colors) {
    List months = [];

    // On récupère le nombre de jours entre la date de début et la date de fin
    int duration = endDate.difference(startDate).inDays;

    // On parcours chaque date pour créer la liste de mois/jours
    int oldMonthIndex = int.parse(DateFormat.M().format(startDate));
    int oldWeekIndex = weeksNumber(startDate);
    for (var dateIndex = 0; dateIndex < duration - 1; dateIndex++) {
      // Date de l'itération
      DateTime date = startDate.add(Duration(days: dateIndex));
      
      String weekDay = DateFormat.E().format(date);

      // Si les jours sont différents de samedi/dimanche
      if (weekDay != 'Sat' && weekDay != 'Sun') {
        // Numéro du mois en cours
        int monthIndex = int.parse(DateFormat.M().format(date));
        // Numéro de la semaine du mois en cours
        int weekIndex = weeksNumber(date);

        // On vérifie si aucun mois ou si on a changé de mois dans ce cas on en ajoute un nouveau
        if (months.isEmpty || oldMonthIndex != monthIndex) {
          // On ajoute un nouveau mois
          months.add({
            'monthNum': DateFormat.M(lang).format(date),
            'label': DateFormat.yMMMM(lang).format(date),
            'weeks': [{ "Mon": {}, "Tue": {}, "Wed": {}, "Thu": {}, "Fri": {}}]
          });
        }

        // On vérifie si on a changé de semaine dans ce cas on en ajoute une nouvelle
        if (oldWeekIndex != weekIndex) {
          months[months.length - 1]['weeks'].add({ "Mon": {}, "Tue": {}, "Wed": {}, "Thu": {}, "Fri": {}});
        }

        // On récupère s'il y a des données dans les capacity pour ce jour
        var capacitiesDay = capacities.firstWhere(
          (e) => e['upc_date'] == DateFormat('yyyy-MM-dd').format(date),
          orElse: () => <String, Object>{},
        );

        // On calcule les lundis, mardis...
        months[months.length - 1]['weeks'][months[months.length - 1]['weeks'].length - 1][weekDay] = {
          'upc_date': date,
          'color': capacitiesDay != null && capacitiesDay.containsKey('color') ? formatStringToColor(capacitiesDay['color']) : colors['accent1'],
          'icon': capacitiesDay != null && capacitiesDay.containsKey('icon') ? capacitiesDay['icon'] : null
        };

        // On met à jour la semaine (permet de voir si ça à changé l'itération suivante)
        oldWeekIndex = weekIndex;
        // On met à jour le mois (permet de voir si ça à changé l'itération suivante)
        oldMonthIndex = monthIndex;
      }
    }

    return months;
  }

  dynamic _selectDay(String? date) {
    setState(() {
      selectedDate = date;
    });

    widget.selectDay?.call(
      selectedDate
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: ListView.separated(
                controller: _controllerHeatmap,
                scrollDirection: Axis.horizontal,
                itemCount: months.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(width: 15);
                },
                itemBuilder: (BuildContext context, int index) {
                  return HeatmapMonthItem(
                    daySize: widget.daySize,
                    lang: widget.lang,
                    colors: widget.colors,
                    index: index,
                    months: months,
                    selectDay: _selectDay,
                    selectedDate: selectedDate
                  );
                  // return Container();
                }
              )
            )
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Container(
              width: 20,
              color: widget.colors['primaryBackground'],
              child: Column(
                children: [
                  SizedBox(
                    width: 20,
                    height: widget.daySize + 2,
                    child: Center(
                      child: Text('L',
                        style: TextStyle(
                          color: widget.colors['accent2'],
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      )
                    )
                  ),
                  SizedBox(
                    width: 20,
                    height: widget.daySize + 3,
                    child: Center(
                      child: Text('M',
                        style: TextStyle(
                          color: widget.colors['accent2'],
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      )
                    )
                  ),
                  SizedBox(
                    width: 20,
                    height: widget.daySize + 3,
                    child: Center(
                      child: Text('M',
                        style: TextStyle(
                          color: widget.colors['accent2'],
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      )
                    ),
                  ),
                  SizedBox(
                    width: 20,
                    height: widget.daySize + 3,
                    child: Center (
                      child: Text('J',
                        style: TextStyle(
                          color: widget.colors['accent2'],
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      )
                    ),
                  ),
                  SizedBox(
                    width: 20,
                    height: widget.daySize + 3,
                    child: Center(
                      child: Text('V',
                        style: TextStyle(
                          color: widget.colors['accent2'],
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      )
                    ),
                  )
                ],
              )
            )
          )
        ]
      )
    );
  }
}