import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'colors.dart';

SizedBox sizedBox(double height, double width) => SizedBox(
      height: height,
      width: width,
    );
displayToastMessage(String message) {
  return Fluttertoast.showToast(msg: message);
}

var colorizeColors = [
  kPrimaryGreen,
  kPrimaryMint,
];

var colorizeTextStyle = TextStyle(
  fontSize: 22.0,
);
