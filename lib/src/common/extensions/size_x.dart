import 'package:flutter/material.dart';
import 'package:sizing/sizing.dart';

extension SizedBoxDoubleXX on num {
  SizedBox get verticalSpace => SizedBox(height: ss);
  SizedBox get horizontalSpace => SizedBox(width: ss);
}