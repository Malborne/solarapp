import 'package:geolocator/geolocator.dart';

class Location {
   double latitude =-1;
   double longitude =-1;
//  Location({this.latitude, this.longitude});
  static Future<bool>  handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      //TODO: Add a card to give an option for the user to Enable Location

      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.


        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.


      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    return true;
  }
  Future<List<double>> getCurrentLocation() async {
    try {
        handlePermission();
      Position position = await Geolocator
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
      latitude = position.latitude;
      longitude = position.longitude;
      // print('longitude: $longitude');
      return[latitude,longitude,1];
    } catch (e) {
      print(e);
      return [0,0,0];
    }
  }
}
