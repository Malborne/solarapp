import 'package:flutter/material.dart';
import 'package:solar/services/weather.dart';

import '../components/location_dialog.dart';
import '../services/location.dart';

class LocationScreen extends StatefulWidget {
  final locationWeather;
  LocationScreen({this.locationWeather});
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();
  late double temperature;
  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeather);
  }

  void updateUI(weatherData) {
    if (weatherData == null) {

      temperature = 0;
      return;
    }
    setState(() {
      temperature = weatherData['current_weather']['temperature'];
      // temperature = 20;
    });
//    print(temperature.toStringAsFixed(1));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      bool locationPermission = await Location.handlePermission();
                      // print('Location permission: ${locationPermission?'granted':'denied'}');
                      if (!locationPermission){
                        showDialog<double>(
                            context: context,
                            builder: (BuildContext context) {
                              return  const EnableLocDialog();
                            });
                      }
                      var weatherData = await weather.getLocationWeather();
                      updateUI(weatherData);
                    },
                    child: const Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),

                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
//                      flex: 2,
                      child: Text(
                        temperature.toStringAsFixed(0) + '°' ?? '20°',
                      ),
                    ),

                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
