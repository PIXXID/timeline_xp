import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HeatmapDayItem extends StatelessWidget {
  const HeatmapDayItem(
      {super.key,
      required this.daySize,
      required this.lang,
      required this.colors,
      required this.day,
      required this.selectedDate,
      required this.elements,
      required this.openDayDetail});

  final double daySize;
  final String lang;
  final Map<String, Color> colors;
  final dynamic day;
  final String? selectedDate;
  final List elements;
  final Function(String, double?, List<String>?, List<dynamic>, dynamic)? openDayDetail;

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
          if (day['capeff'] > 0) {
            // On calcule la progression du jour pour le renvoyer en callback
            var selectedDate = DateFormat('yyyy-MM-dd').format(day['date']);

            // Liste des élements présent sur la journée
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

            // Indicateurs de capacité et charges
            dynamic dayIndicators = {
              'capacity': day['capeff'],
              'busy': day['buseff'],
              'completed': day['compeff']
            };

            // Callback de la fonction d'ouverture du jour
            openDayDetail?.call(
                selectedDate,
                0,
                (preIds as List<dynamic>).cast<String>(),
                elementsDay,
                dayIndicators);
          }
        },
        child: Container(
            width: daySize,
            height: daySize,
            padding: EdgeInsets.all(isSelected ? 2.0 : 0),
            decoration: BoxDecoration(
              color: day['capeff'] > 0 ? day['color'] : colors['secondaryBackground'],
              border: Border.all(
                color: isSelected ? colors['primary']! : Colors.transparent,
                width: isSelected ? 2.0 : 0,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                      size: 18))
              else if (day['capeff'] == 0)
                Center(
                  child: SizedBox(
                    height: daySize,
                    child: Icon(
                        Icons.sunny,
                        color: colors['secondaryText'],
                        size: 14)))
              else
                Text(
                  upcDate,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkBackground
                        ? colors['primaryText']
                        : colors['primaryBackground'],
                    fontWeight: FontWeight.w600),
                ),
            ])));
  }
}
