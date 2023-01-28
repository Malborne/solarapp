import 'package:flutter/scheduler.dart';
import 'package:solar/services/nordpool.dart';
import 'package:solar/services/weather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/networking.dart';
import 'main_screen.dart';



class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  dynamic weatherData;
  dynamic priceData;
  bool isOnline = false;
  bool weatherLoaded =false;
  bool priceLoaded = false;
  Map _source = {ConnectivityResult.none: false};
  final NetworkConnectivity _networkConnectivity = NetworkConnectivity.instance;
  String string = '';
  WeatherModel weather = WeatherModel();
  void getData() {

    WeatherModel().getLocationWeather().then((value) {

      setState(() {
        weatherLoaded = true;
        weatherData = value;
      });
      print('weather Data received: $weatherLoaded');
    }).timeout(Duration(seconds: 3)).onError((error, stackTrace) {
      print(error);
      setState(() {
        weatherLoaded = true;
        weatherData = null;
      });
      print('weather Error Occured: $weatherLoaded');
    });

    NordPool().getAll(areas: ['Oslo']).then((value) {
      setState(() {
        priceLoaded = true;
        priceData = value;
      });
      print('Price Data received: $priceLoaded');
    }).timeout(Duration(seconds: 10)).onError((error, stackTrace) {
      print(error);
     setState(() {
       priceLoaded = true;
       priceData = null;
     });
      print('Price Error Occured: $priceLoaded');
    });
  }

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
          isOnline =  _source.values.toList()[0] ? true : false;
        break;
        case ConnectivityResult.none:
        default:
        isOnline = false;
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (isOnline) {
        getData();

      }
      else {

      }
    if(priceLoaded && weatherLoaded) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
             MainScreen(
              priceData: priceData,
              weatherData: weatherData,
            ),
          ));
    }
    });
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
