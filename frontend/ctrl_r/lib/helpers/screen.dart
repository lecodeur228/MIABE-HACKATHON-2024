import 'package:flutter/material.dart';

extension ScreenSize on BuildContext {
  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;
  double heightPercent(double value) => height * value / 100;
  double widthPercent(double value) => width * value / 100;
}
