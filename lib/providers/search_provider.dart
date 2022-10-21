import 'package:flutter/material.dart';
import 'package:tubaline_ta/models/search.dart';

class SearchProvider extends ChangeNotifier {
  final Search _search = Search(true, "");
  Search get search => _search;
  bool _isSearch = false;
  bool get isSearch => _isSearch;
  void setisSearch(bool search) {
    _isSearch = search;
    notifyListeners();
  }

  void setSort(bool sort) {
    _search.sort = sort;
    notifyListeners();
  }

  void setKey(String key) {
    _search.key = key;
    notifyListeners();
  }
}
