import 'package:flutter/material.dart';

class HoverCardProvider extends ChangeNotifier{

  bool _hovered;

  HoverCardProvider(this._hovered);

  bool get getHover => _hovered;

  void setHover(bool state){
    _hovered = state;
    notifyListeners();
  }

}