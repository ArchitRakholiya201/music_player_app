import 'package:flutter/cupertino.dart';

class FavoriteListProvider extends ChangeNotifier{

  List<int> _favoriteList = [];

  List<int> get favoriteList => _favoriteList;

  set favoriteList(List<int> favoriteList) {
    _favoriteList = favoriteList;
    notifyListeners();
  }

}