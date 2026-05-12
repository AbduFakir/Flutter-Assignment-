import 'package:flutter/foundation.dart';

class NavigationController extends ChangeNotifier {
  NavigationController({int initialIndex = 0}) : _index = initialIndex;

  int _index;

  int get index => _index;

  void select(int value) {
    if (_index == value) return;
    _index = value;
    notifyListeners();
  }
}
