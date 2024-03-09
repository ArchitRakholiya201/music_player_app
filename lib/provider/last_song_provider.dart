
import 'package:flutter/cupertino.dart';
import 'package:on_audio_query/on_audio_query.dart';

class LastSongProvider extends ChangeNotifier{

  SongModel? _lastSong;

  SongModel? get lastSong => _lastSong;

  set lastSong(SongModel? lastSong) {
    _lastSong = lastSong;
    notifyListeners();
  }

}