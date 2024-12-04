import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HeatmapDayItem extends StatelessWidget {
  const HeatmapDayItem(
      {super.key,
      required this.daySize,
      required this.lang,
      required this.colors,
      required this.day,
      required this.selectDay,
      required this.selectedDate,
      required this.elements,
      required this.openDayDetail});

  final double daySize;
  final String lang;
  final Map<String, Color> colors;
  final dynamic day;
  final Function(String?)? selectDay;
  final String? selectedDate;
  final List elements;
  final Function(String, double?, List<String>?, List<dynamic>)? openDayDetail;

  @override
  Widget build(BuildContext context) {
    bool isSelected = false;
    if (selectedDate != null && day['date'] != null) {
      isSelected =
          selectedDate == DateFormat('yyyy-MM-dd').format(day['date']);
    }

    String upcDate = day['date'] != null
        ? DateFormat.d(lang).format(day['date'])
        : '';

    // Calcule la luminance de la couleur de la case pour adapter la couleur du texte
    bool isDarkBackground = day['color'].computeLuminance() < 0.5;

    return GestureDetector(
        onTap: () {
          // On calcule la progression du jour pour le renvoyer en callback
          var selectedDate = DateFormat('yyyy-MM-dd').format(day['date']);

          // Lite des élements présent sur la journée
          var elementsDay = elements
              .where(
                (e) =>
                    e['date'] == selectedDate,
              )
              .toList();

          // Liste des identifiants d'élements
          List<String> preIds = elementsDay
              .map((element) => element['pre_id'] as String)
              .toList();

          // Callback de sélection de la date
          selectDay?.call(selectedDate);

          // Callback de la fonction d'ouverture du jour
          openDayDetail?.call(
              selectedDate,
              0,
              (preIds as List<dynamic>).cast<String>(),
              elementsDay);
        },
        child: Container(
            width: daySize,
            height: daySize,
            padding: EdgeInsets.all(isSelected ? 2.0 : 0),
            decoration: BoxDecoration(
              color: day['color'],
              border: Border.all(
                color: isSelected ? colors['warning']! : Colors.transparent,
                width: isSelected ? 2.0 : 0,
              ),
            ),
            child: Column(children: [
              if (day['icon'] != null)
                Padding(
                    padding: EdgeInsets.only(top: isSelected ? 2 : 6),
                    child: Icon(
                        const IconData(
                          0xe818,
                          fontFamily: 'Swiiipiconsfont',
                        ),
                        color: isDarkBackground
                          ? colors['primaryText']
                          : colors['primaryBackground'],
                        size: 16))
              else
                Text(
                  upcDate,
                  style: TextStyle(
                      fontSize: 10,
                      color: isDarkBackground
                          ? colors['primaryText']
                          : colors['primaryBackground'],
                      fontWeight: FontWeight.w600),
                ),
            ])));
  }
}
