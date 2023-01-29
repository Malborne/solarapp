import 'package:flutter/material.dart';
import '../components/indication_circle.dart';
import 'package:timer_builder/timer_builder.dart';

class HomePage extends StatefulWidget {
  final weatherData;
  final priceData;

  const HomePage(
      {super.key, required this.weatherData, required this.priceData});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double temperature;
  late double priceRealTime;
  int currentHour = DateTime.now().hour;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    updateUI(widget.weatherData, widget.priceData);
  }

  void updateUI(weatherData, priceData) {
    if (weatherData == null) {
      temperature = 0;
      return;
    }
    if (priceData == null) {
      priceRealTime = 0;
      return;
    }

    setState(() {
      temperature = weatherData['current_weather']['temperature'];
      priceRealTime = widget.priceData['Hours']['areas']['Oslo']['values']
          [currentHour]['value'];
      // temperature = 20;
    });
//    print(temperature.toStringAsFixed(1));
  }

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    var diameter = (orientation == Orientation.portrait
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.height) /
        3.5;
    return Scaffold(
      backgroundColor: Colors.black38,
      body: SafeArea(
        child: Center(
          heightFactor: 1.3,
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing:
                orientation == Orientation.portrait ? diameter / 6 : diameter,
            runSpacing: 30,
            children: [
              IndicationCircle(
// onPressed: (){},
                successColor: Colors.red,
                failColor: Colors.brown,
                diameter: diameter,
                successPercentage: 80,
                outlineWidth: 4,
                mainText: '2359 W',
                subText: 'Production',
              ),
              TimerBuilder.periodic(const Duration(hours: 1),
                  alignment: const Duration(hours: 1), builder: (context) {
                currentHour = DateTime.now().hour;
                priceRealTime = widget.priceData['Hours']['areas']['Oslo']
                    ['values'][currentHour]['value'];

                return IndicationCircle(
// onPressed: (){},
                  successColor: Colors.green,
                  failColor: Colors.brown,
                  diameter: diameter,
                  successPercentage: priceRealTime / 200 * 100,
                  outlineWidth: 4,
                  mainText: '${priceRealTime.toStringAsFixed(1)} €/MWh',
                  subText:
                      '${currentHour.toString().padLeft(2, '0')}:00 - ${((currentHour + 1) % 24).toString().padLeft(2, '0')}:00',
                );
              }),
              IndicationCircle(
// onPressed: (){},
                successColor: Colors.blue,
                failColor: Colors.brown,
                diameter: diameter,
                successPercentage: temperature * 2,
                outlineWidth: 4,
                mainText:
                    widget.weatherData == null ? '-- °C' : '$temperature °C',
                subText: 'Temperature',
              ),

              IndicationCircle(
// onPressed: (){},
                successColor: Colors.yellow.shade800,
                failColor: Colors.brown,
                diameter: diameter,
                successPercentage: 80,
                outlineWidth: 4,
                mainText: '5000 kWh',
                subText: 'Consumption',
              ),
              IndicationCircle(
// onPressed: (){},
                successColor: Colors.teal.shade800,
                failColor: Colors.brown,
                diameter: diameter,
                successPercentage: 60,
                outlineWidth: 4,
                mainText: '7350 kWh',
                subText: 'PV Yield',
              ),
              IndicationCircle(
// onPressed: (){},
                successColor: Colors.deepOrange.shade600,
                failColor: Colors.brown,
                diameter: diameter,
                successPercentage: 90,
                outlineWidth: 4,
                mainText: '1820 NOK',
                subText: 'Money Saved',
              ),
              IndicationCircle(
// onPressed: (){},
                successColor: Colors.purple,
                failColor: Colors.brown,
                diameter: diameter,
                successPercentage: 60,
                outlineWidth: 4,
                mainText: '4318 NOK',
                subText: 'Total Cost',
              ),
              // SizedBox(
              //   height: (orientation==Orientation.portrait?MediaQuery.of(context).size.height:MediaQuery.of(context).size.width) * 0.1,
              //   width: double.infinity,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
