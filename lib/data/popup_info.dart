import 'package:flutter/material.dart';

/* Air Quality Index      Qualitative name
      1                   Good     , Very low health risk
      2                   Fair     , Low health risk
      3                   Moderate , Medium health risk
      4                   Poor     , High health risk
      5                   Very Poor, Very high health risk
*/

// learn more about calculation of Air Quality index:
// https://en.wikipedia.org/wiki/Air_quality_index#CAQI

class PopupInfo {
  int aqi;
  List<String> description;
  Color color;

  PopupInfo(this.aqi, this.description, this.color);
}

PopupInfo getPopupInfo(int aqi) {
  switch (aqi) {
    case 1:
      return PopupInfo(1, ['Good', 'Very Low Health Risk'],
          const Color.fromARGB(153, 122, 182, 119));
    case 2:
      return PopupInfo(2, ['Fair', 'Low Health Risk'],
          const Color.fromARGB(153, 163, 187, 77));
    case 3:
      return PopupInfo(3, ['Moderate', 'Medium Health Risk'],
          const Color.fromARGB(153, 194, 194, 53));
    case 4:
      return PopupInfo(4, ['Poor', 'High Health Risk'],
          const Color.fromARGB(153, 194, 166, 52));
    case 5:
      return PopupInfo(5, ['Very Poor', 'Very High Health Risk'],
          const Color.fromARGB(153, 194, 107, 53));
    default:
      return PopupInfo(0, ['Invalid', 'Invalid'], Colors.grey);
  }
}
