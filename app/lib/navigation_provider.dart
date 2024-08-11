import 'package:flutter/material.dart';

class NavigationProvider with ChangeNotifier {
  int _currentPage = 0;
  String _selectedBuilding = '';

  int get currentPage => _currentPage;
  String get selectedBuilding => _selectedBuilding;

  void setPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  void setSelectedBuilding(String building) {
    _selectedBuilding = building;
    notifyListeners();
  }
}