import 'package:flutter/scheduler.dart';
import 'package:solar/errors/exceptions.dart';
import 'package:solar/services/nordpool.dart';
import 'package:solar/services/weather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/networking.dart';
import 'main_screen.dart';
import 'package:geolocator/geolocator.dart';
class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  dynamic weatherData;
  dynamic priceData;
  bool isOnline = false;
  bool weatherLoaded = false;
  bool priceLoaded = false;
  Map _source = {ConnectivityResult.none: false};
  final NetworkConnectivity _networkConnectivity = NetworkConnectivity.instance;
  String string = '';
  WeatherModel weather = WeatherModel();
  final int timeout = 5; //timeout allowed in seconds (5 seconds)
  late Duration timeoutDuration =  Duration(seconds: timeout);

  void getData() {
    // try {
      WeatherModel()
          .getLocationWeather()
          .then((value) {
            setState(() {
              weatherLoaded = true;
              weatherData = value;
            });
            print('weather Data received: $weatherLoaded');
          })
          .timeout(timeoutDuration)
          .onError((e, stackTrace) {

            if (e is PermissionDeniedException) {
              setState(() {
                weatherLoaded = true;
                weatherData = null;
              });
            }
             if (e is LocationServiceDisabledException) {
              print('Location Services disabled');
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Enable Location Services'),
                  content: const Text(
                      'Location Services Disabled. Please Enable location services or choose the location manually'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        setState(() {
                          weatherLoaded = true;
                          weatherData = null;
                        });
                        Navigator.pop(context, 'Cancel');
                      },
                      child: const Text('Choose Manually'),
                    ),
                    TextButton(
                      onPressed: () => Geolocator.openLocationSettings(),
                      child: const Text('Enable Location'),
                    ),
                  ],
                ),
              );
            }
            else if (e is LocationDeniedForeverException) {
              print('Location denied forever');
              setState(() {
                weatherLoaded = true;
                weatherData = null;
              });
              //TODO: check if the location is already stored in the app or has been chosen manually
              // showDialog<String>(
              //   context: context,
              //   builder: (BuildContext context) => AlertDialog(
              //     title: const Text('Access to location'),
              //     content: const Text(
              //         'Access to Location Services denied, please allow location permission to in the settings or choose the location manually.'),
              //     actions: <Widget>[
              //       TextButton(
              //         onPressed: () => Navigator.pop(context, 'Cancel'),
              //         child: const Text('Choose Manually'),
              //       ),
              //       TextButton(
              //         onPressed: () => Geolocator.openAppSettings(),
              //         child: const Text('Allow'),
              //       ),
              //     ],
              //   ),
              // );
            }
            else {//Unkown error occured
              print(e);
            }
            // setState(() {
            //   weatherLoaded = false;
            //   weatherData = null;
            // });
            print('weather Error Occured: $weatherLoaded');
          });
    // } on PermissionDeniedException catch (e) {
    //   print('Location permission denied');
    // }
    //     on LocationServiceDisabledException catch (e) {
    //
    //     print('Location Services disabled');
    //   }
    //   on LocationDeniedForeverException catch(e){
    //     print('Location denied forever');
    //   } on Exception catch(e) {
    //   print(e);
    // }

    NordPool()
        .getAll(areas: ['Oslo'])
        .then((value) {
          setState(() {
            priceLoaded = true;
            priceData = value;
          });
          print('Price Data received: $priceLoaded');
        })
        .timeout(timeoutDuration)
        .onError((error, stackTrace) {
          print(error);
          setState(() {
            priceLoaded = false;
            priceData = null;
          });
          print('Price Error Occured: $priceLoaded');
        });
  }

  // @override
  // void dispose() {
  //   _networkConnectivity.disposeStream();
  //   super.dispose();
  // }

  @override
  void initState() {
    super.initState();
    _networkConnectivity.initialise();

    _networkConnectivity.myStream.listen((source) {
      _source = source;
      print('source $_source');
      // 1.
      switch (_source.keys.toList()[0]) {
        case ConnectivityResult.mobile:
        case ConnectivityResult.wifi:
          isOnline = true;
          break;
        case ConnectivityResult.none:
        default:
          isOnline = false;
      }
    });

    SchedulerBinding.instance.addPostFrameCallback((_) {
      //Add a 1 second delay to allow to check the connection
      Future.delayed(const Duration(seconds: 1)).then((value) {
        if (isOnline) {
          getData();
         var countdown = timeout;

          Timer.periodic(const Duration(seconds: 1), (timer) {
            print('Countdown: $countdown');
          if (priceLoaded && weatherLoaded) {
            timer.cancel();
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MainScreen(
                    priceData: priceData,
                    weatherData: weatherData,
                  ),
                ));
          }

          countdown--;
          if(countdown == 0 && !(priceLoaded&&weatherLoaded)){
            timer.cancel();
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Error'),
                  content: const Text(
                      'Failed to get the data from the server. Check your internet connection and try again.'),
                  actions: <Widget>[
                    // TextButton(
                    //   onPressed: () => Navigator.pop(context, 'Cancel'),
                    //   child: const Text('Cancel'),
                    // ),
                    TextButton(
                      onPressed: () => Navigator.of(context)
                          .pushReplacement(MaterialPageRoute(
                        builder: (context) => LoadingScreen(),
                      )),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );

          }
        });


        } else {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('No Internet'),
              content: const Text(
                  'Failed to connect to the internet. Check your WiFi or Mobile data settings and try again.'),
              actions: <Widget>[
                // TextButton(
                //   onPressed: () => Navigator.pop(context, 'Cancel'),
                //   child: const Text('Cancel'),
                // ),
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => LoadingScreen(),
                  )),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SpinKitDoubleBounce(
          color: Colors.white,
          size: 100,
        ),
      ),
    );
  }
}
