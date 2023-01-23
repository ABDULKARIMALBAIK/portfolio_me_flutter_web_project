import 'package:flutter/material.dart';
import 'package:portfolio_me/utils/ThemeAppGenerator.dart';

class ThemeProvider extends ChangeNotifier {

  late ScrollController scrollController;
  late ThemeData _currentTheme;
  late bool _isLightTheme;

  ThemeProvider(){
    scrollController = ScrollController();
    _isLightTheme = false;
    _currentTheme = ThemeAppGenerator().darkTheme();
  }

  ScrollController get getScroll => scrollController;

  set setScroll(int i) {
    scrollController.animateTo(
      i == 0 ? 100 : 0,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
    notifyListeners();
  }



  bool get isLightTheme => _isLightTheme;

  void setTheme(bool isLight) {
    _isLightTheme = isLight;

    //Light Theme
    if(_isLightTheme)
      _currentTheme = ThemeAppGenerator().lightTheme();
    //Dark Theme
    else
      _currentTheme = ThemeAppGenerator().darkTheme();

    notifyListeners();
  }

  ThemeData get getTheme =>  _currentTheme;

}