import 'dart:async';

import 'package:geolocator/geolocator.dart';
import '../errors/exceptions.dart';

class Location {
  double latitude = -1;
  double longitude = -1;

//  Location({this.latitude, this.longitude});
  static Future<bool> handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      //TODO: Add a card to give an option for the user to Enable Location
      throw const LocationServiceDisabledException();
      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        throw const PermissionDeniedException('');
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.

        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever appropriately.
      throw LocationDeniedForeverException();

      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    return true;
  }

  Future<Map<String, dynamic>> getCurrentLocation() async {
    // try {
    Map<String, dynamic> location;
    bool locationFound = true;
      await handlePermission();

      //      .onError((e, stackTrace) async{
      //   if (e is PermissionDeniedException)  {
      //     isDenied = true;
      //     print('Error handled inside location');
      //     return false;
      //   } else {
      //     throw Future.error(e!,stackTrace);
      //   }
      // });
        Position position = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.low,
                timeLimit: const Duration(seconds: 3))
            .onError((e, stackTrace) async {
          // if (e is TimeoutException) {
          Position? p = await Geolocator.getLastKnownPosition();
          print('Getting the last known location');
          latitude = p?.latitude ?? 0;
          longitude = p?.longitude ?? 0;
          if (p == null) {
            //NO last known position found
            print('No location found');
            locationFound = false;
          }
          return Position(
              longitude: longitude,
              latitude: latitude,
              timestamp: DateTime.now(),
              accuracy: 10,
              altitude: 0,
              heading: 0,
              speed: 0,
              speedAccuracy: 1);
          // }
        });
        latitude = position.latitude;
        longitude = position.longitude;
        location = {
          'Latitude': latitude,
          'Longitude': longitude,
          'locationFound': locationFound
        };


      return location;
      // } catch (e) {
      //   print(e);
      //   return [0,0,0];
      // }

  }

  // Future<Map<String, dynamic>> getLastKnownLocation() async {
  //   bool locationFound = true;
  //   print('Getting last known location');
  //   Position? p = await Geolocator.getLastKnownPosition();
  //   print('Getting the last known location');
  //   latitude = p?.latitude ?? 0;
  //   longitude = p?.longitude ?? 0;
  //   if (p == null) {
  //     // print('latitude: $latitude');
  //     //NO last known position found
  //     print('No location found');
  //     locationFound = false;
  //   }
  //   return {
  //     'Latitude': latitude,
  //     'Longitude': longitude,
  //     'locationFound': locationFound
  //   };
  // }
}
