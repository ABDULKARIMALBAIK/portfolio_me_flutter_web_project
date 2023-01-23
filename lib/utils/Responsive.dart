import 'package:flutter/material.dart';

// We will modify it once we have our final design

class Responsive extends StatelessWidget {
  final Widget? mobile;
  final Widget? mobileLarge;
  final Widget? tablet;
  final Widget? desktop;

  const Responsive({
    Key? key,
    this.mobile,
    this.tablet,
    this.desktop,
    this.mobileLarge,
  }) : super(key: key);

  bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width <= 500;

  // static bool isMobileLarge(BuildContext context) =>
  //     MediaQuery.of(context).size.width <= 700;

  bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 909 && MediaQuery.of(context).size.width >= 600;

  bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 909;

  @override
  Widget build(BuildContext context) {

    final Size _size = MediaQuery.of(context).size;

    if (_size.width >= 909) {
      return desktop!;
    } else if (_size.width >= 600 && _size.width < 909) {
      return tablet!;
    } else if (_size.width >= 500 && mobileLarge != null) {
      return mobileLarge!;
    } else {
      return mobile!;
    }
  }
}