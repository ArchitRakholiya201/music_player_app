
import 'package:flutter/cupertino.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongListProvider extends ChangeNotifier{

  List<SongModel> _songList = [];

  List<SongModel> get songList => _songList;

  set songList(List<SongModel> songList) {
    _songList = songList;
    notifyListeners();
  }

}