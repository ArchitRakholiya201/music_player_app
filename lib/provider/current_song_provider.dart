
import 'package:flutter/cupertino.dart';
import 'package:on_audio_query/on_audio_query.dart';

class CurrentSongProvider extends ChangeNotifier{

  SongModel? _selectedSong;

  SongModel? get selectedSong => _selectedSong;

  set selectedSong(SongModel? selectedSong) {
    _selectedSong = selectedSong;
    notifyListeners();
  }

  SongModel? _playingSong;

  SongModel? get playingSong => _playingSong;

  set playingSong(SongModel? playingSong) {
    _playingSong = playingSong;
    notifyListeners();
  }

}