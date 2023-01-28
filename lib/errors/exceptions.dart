

class LocationDeniedForeverException implements Exception {
  String errMsg() => 'Location Services Permission Denied Forever';
  LocationDeniedForeverException();
}

// class LocationServiceDisabledException implements Exception {
//   String errMsg() => 'Location Services disabled';
//   LocationServiceDisabledException();
// }