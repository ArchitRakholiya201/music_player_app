
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_player_app/provider/position_provider.dart';

class MusicPlayerProvider extends ChangeNotifier{

  MusicPlayerProvider(this._positionProvider, this._audioPlayer){
    init();
  }

  final PositionProvider _positionProvider;

  PositionProvider get positionProvider => _positionProvider;

  final AudioPlayer _audioPlayer;

  AudioPlayer get audioPlayer => _audioPlayer;

  // set audioPlayer(AudioPlayer player) {
  //   _audioPlayer = player;
  //   notifyListeners();
  // }

  bool _isSongPlaying = false;

  bool get isSongPlaying => _isSongPlaying;

  set isSongPlaying(bool isSongPlaying) {
    _isSongPlaying = isSongPlaying;
    notifyListeners();
  }

  void init(){

    print("Music player initializing .....");

    // _audioPlayer = AudioPlayer();
    _audioPlayer.onDurationChanged.listen((Duration d) {
      _positionProvider.duration = d;
    });

    _audioPlayer.onPositionChanged.listen((Duration  p) {
      _positionProvider.position = p;
    });

    _audioPlayer.onPlayerComplete.listen((event) {

      print('........music player provider song completed......');

      _isSongPlaying = false;

      _positionProvider.duration = const Duration();
      _positionProvider.position = const Duration(seconds: 0);

      print('..................................................');

    });

  }

}