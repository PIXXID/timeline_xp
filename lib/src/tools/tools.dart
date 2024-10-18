// FONCTIONS PARTAGÉES DE L'APPLICATION
import 'package:flutter/material.dart';

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