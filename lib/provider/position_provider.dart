
import 'package:flutter/foundation.dart';

class PositionProvider extends ChangeNotifier{

  Duration _duration = const Duration();

  Duration get duration => _duration;

  set duration(Duration duration) {
    _duration = duration;
    notifyListeners();
  }

  Duration _position = const Duration(seconds: 0);

  Duration get position => _position;

  set position(Duration position) {
    _position = position;
    notifyListeners();
  }

  Duration _slider = const Duration(seconds: 0);

  Duration get slider => _slider;

  set slider(Duration slider) {
    _slider = slider;
    notifyListeners();
  }

}