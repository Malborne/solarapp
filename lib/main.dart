import 'package:flutter/material.dart';
import 'package:solar/pages/loading_screen.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:solar/services/nordpool.dart';
import 'package:solar/services/weather.dart';
void main() => runApp(MultiProvider(
     providers: [
        FutureProvider(
            create: (_) => WeatherModel().getTempFromWeatherData(),
            initialData: 0),
        // FutureProvider(create: (_)=>NordPool().getAll(), initialData: null),
        //TODO: Add isOnline her to the provider list
        // ChangeNotifierProvider(create: (_){}, initialData: false),
      ],
      child: const MyApp(),
    ));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return  MaterialApp(
      title: _title,
      theme: ThemeData.dark().copyWith(
        primaryColorDark: Colors.purple,
        canvasColor: Colors.black,
        backgroundColor: Colors.black,
      ),
      home:  LoadingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}




