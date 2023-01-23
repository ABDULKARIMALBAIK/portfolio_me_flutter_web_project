import 'dart:ui';

import 'package:flutter/material.dart';

class AppColor{
  Color  primaryColorLight() => Colors.green;
  Color  primaryColorDark() => Colors.greenAccent;

  Color  accentColorLight() => Colors.yellowAccent;
  Color  accentColorDark() => Colors.yellow;

  Color  backgroundColorLight() => Color(0xFFECECEC);   //FFECECEC
  Color  backgroundColorDark() => Color(0xFF0E0E0E);

  Color  cardColorLight() => Colors.white;
  Color  cardColorDark() => Color(0xFF181818);    //0xFF181818

  Color  textTitleColorLight() => Colors.black;
  Color  textTitleColorDark() => Colors.white;

  Color  textBodyColorLight() => Colors.black26;
  Color  textBodyColorDark() => Colors.white38;

}