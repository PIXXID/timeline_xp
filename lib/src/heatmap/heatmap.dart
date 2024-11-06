import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Widgets
import 'heatmap_month_item.dart';

// Tools
import 'package:timeline_xp/src/tools/tools.dart';

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

  // Labels des jours de la semaine (traductibles) pour la légende de gauche
  List<String> daysLabels = [];

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
    months = formatData(
        startDate, endDate, widget.capacities, widget.lang, widget.colors);

    // On prend des dates qui correspondent aux jours de la semaine qu'on veut
    daysLabels.add(DateFormat.E(widget.lang)
        .format(DateTime.parse('2024-10-14'))); // Lundi
    daysLabels.add(DateFormat.E(widget.lang)
        .format(DateTime.parse('2024-10-15'))); // Mardi
    daysLabels.add(DateFormat.E(widget.lang)
        .format(DateTime.parse('2024-10-16'))); // Mercredi
    daysLabels.add(DateFormat.E(widget.lang)
        .format(DateTime.parse('2024-10-17'))); // Jeudi
    daysLabels.add(DateFormat.E(widget.lang)
        .format(DateTime.parse('2024-10-18'))); // Vendredi

    setState(() {
      // On met à jour la date sélectionnée avec la date par défaut = aujourd'hui
      selectedDate = DateFormat('yyyy-MM-dd').format(now);
    });

    // Scroll sur la date du jour
    // On récupère le mois du jour par défaut pour récupérerdexWher son index dans les mois affichés
    int currentMonth = int.parse(DateFormat.M().format(now));
    int monthIndex = months.indexWhere((m) {
      return int.parse(m['monthNum']) == currentMonth.toInt();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      double scrollValue = (monthIndex + 1) * (widget.daySize * 4.33);
      _controllerHeatmap.jumpTo(scrollValue > 0 ? scrollValue : 0);
    });
  }

  // Formatte la liste des mois/semaines/jours pour l'afficher sous forme de heatmap
  List formatData(DateTime startDate, DateTime endDate, List capacities,
      String lang, Map<String, Color> colors) {
    List months = [];

    // On récupère le nombre de jours entre la date de début et la date de fin
    int duration = endDate.difference(startDate).inDays;

    // On parcours chaque date pour créer la liste de mois/jours
    int oldMonthIndex = int.parse(DateFormat.M().format(startDate));
    int oldWeekIndex = weeksNumber(startDate, 1);
    for (var dateIndex = 0; dateIndex < duration - 1; dateIndex++) {
      // Date de l'itération
      DateTime date = startDate.add(Duration(days: dateIndex));

      String weekDay = DateFormat.E().format(date);

      // Si les jours sont différents de samedi/dimanche
      if (weekDay != 'Sat' && weekDay != 'Sun') {
        // Numéro du mois en cours
        int monthIndex = int.parse(DateFormat.M().format(date));
        // Numéro de la semaine du mois en cours
        int weekIndex = weeksNumber(date, 1);

        // On vérifie si aucun mois ou si on a changé de mois dans ce cas on en ajoute un nouveau
        if (months.isEmpty || oldMonthIndex != monthIndex) {
          // On ajoute un nouveau mois
          months.add({
            'monthNum': DateFormat.M(lang).format(date),
            'label': DateFormat.yMMMM(lang).format(date),
            'weeks': [
              {"Mon": {}, "Tue": {}, "Wed": {}, "Thu": {}, "Fri": {}}
            ]
          });
        }

        // On vérifie si on a changé de semaine dans ce cas on en ajoute une nouvelle
        if (oldWeekIndex != weekIndex) {
          months[months.length - 1]['weeks']
              .add({"Mon": {}, "Tue": {}, "Wed": {}, "Thu": {}, "Fri": {}});
        }

        // On récupère s'il y a des données dans les capacity pour ce jour
        var capacitiesDay = capacities.firstWhere(
          (e) => e['upc_date'] == DateFormat('yyyy-MM-dd').format(date),
          orElse: () => <String, Object>{},
        );

        // On calcule les lundis, mardis...
        months[months.length - 1]['weeks']
            [months[months.length - 1]['weeks'].length - 1][weekDay] = {
          'upc_date': date,
          'color': capacitiesDay != null && capacitiesDay.containsKey('color')
              ? formatStringToColor(capacitiesDay['color'])
              : colors['primaryText'],
          'icon': capacitiesDay != null && capacitiesDay.containsKey('icon')
              ? capacitiesDay['icon']
              : null
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

    widget.selectDay?.call(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          Padding(
              padding: const EdgeInsets.only(left: 35),
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
                            selectedDate: selectedDate);
                        // return Container();
                      }))),
          Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Container(
                  width: 25,
                  color: widget.colors['primaryBackground'],
                  child: ListView.builder(
                      itemCount: daysLabels.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SizedBox(
                            width: 20,
                            height: widget.daySize + 3,
                            child: Center(
                                child: Text(
                              daysLabels[index].split('')[0].toUpperCase(),
                              style: TextStyle(
                                color: widget.colors['accent2'],
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            )));
                      }))),
        ]));
  }
}
