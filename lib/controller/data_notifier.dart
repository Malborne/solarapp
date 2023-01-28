import 'package:flutter/cupertino.dart';

class DataNotifier extends ChangeNotifier {
  double _temperature = double.infinity;

  double get temperature => _temperature;
}