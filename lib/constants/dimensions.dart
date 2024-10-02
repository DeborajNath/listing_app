import 'package:flutter/material.dart';

class Dimensions {
  static double widthP(BuildContext context) {
    return MediaQuery.of(context).size.width / 393;
  }

  static double heightP(BuildContext context) {
    return MediaQuery.of(context).size.height / 852;
  }

  // Size without status-bar and navigation-bar
  static double heightF(BuildContext context) {
    return (MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.bottom -
            MediaQuery.of(context).padding.top) /
        852;
  }
}
