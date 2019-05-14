import 'package:flutter/material.dart';
import 'package:waterledger/constants/constants.dart';

double applyUnitsConversion(Units currentUnits, Units newUnits, double amount) {
  if ((currentUnits == Units.FLOZ && newUnits == Units.FLOZ) ||
      (currentUnits == Units.ML && newUnits == Units.ML)) {
    return amount;
  }
  if (currentUnits == Units.FLOZ && newUnits == Units.ML) {
    return amount * FLOZ_ML_RATIO;
  }
  if (newUnits == Units.FLOZ && currentUnits == Units.ML) {
    return amount / FLOZ_ML_RATIO;
  }
  throw "something went wrong";
}

String unitToString(Units units) {
  if (units == Units.FLOZ) {
    return "FL oz.";
  }
  if (units == Units.ML) {
    return "ML";
  }
  throw "Incorrect units";
}

int getElapsedTime(TimeOfDay start, TimeOfDay end) {
  return ((end.hour - start.hour) % 24) * 60 + (end.minute - start.minute);
}
