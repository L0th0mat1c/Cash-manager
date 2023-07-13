import 'package:flutter/material.dart';

class MainAppControllerProvider extends ChangeNotifier {
  int _indexPage = 0;
  bool _scan = false;
  int _messageCard;

  void setIndexPage(int index) {
    _indexPage = index;
    notifyListeners();
  }

  void setScan(bool bool) {
    _scan = bool;
    notifyListeners();
  }

  void setMessageCard(int msg) {
    _messageCard = msg;
    notifyListeners();
  }

  int get getMessageCard => _messageCard;
  bool get getScan => _scan;
  int get getIndexPage => _indexPage;
}
