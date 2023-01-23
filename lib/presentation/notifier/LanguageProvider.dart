import 'package:flutter/material.dart';
import 'dart:ui';

class LanguageProvider extends ChangeNotifier {

  late Locale _currentLanguage;
  late bool _isArabicLanguage;

  LanguageProvider(){
    _currentLanguage = Locale('en');
    _isArabicLanguage = false;
  }



  bool get isArabicLanguage => _isArabicLanguage;

  set setLanguage(bool isArabic) {
    _isArabicLanguage = isArabic;

    //Arabic Language
    if(_isArabicLanguage)
      _currentLanguage = Locale('ar');
    //English Language
    else
      _currentLanguage = Locale('en');

    notifyListeners();
  }

  Locale get getLanguage =>  _currentLanguage;


}