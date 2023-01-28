
import 'package:flutter/material.dart';
import '../components/indication_circle.dart';
import '../components/location_dialog.dart';
import '../services/weather.dart';
import '../services/location.dart';

class HomePage extends StatefulWidget {
   final weatherData;
  const HomePage({super.key, required this.weatherData});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double temperature;
@override
  void  initState()  {
    // TODO: implement initState
    super.initState();

    updateUI(widget.weatherData);
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
    return  Scaffold(
      backgroundColor: Colors.black38,
      body: SafeArea(
        child: Center(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(

                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:  [
              IndicationCircle(
// onPressed: (){},
                successColor: Colors.red,
                failColor: Colors.brown,
                diameter: MediaQuery.of(context).size.width/3.5,
                successPercentage: 80,
                outlineWidth: 4,
                mainText: '2359 W',
                subText: 'Production',
              ),
              IndicationCircle(
// onPressed: (){},
                successColor: Colors.green,
                failColor: Colors.brown,
                diameter: MediaQuery.of(context).size.width/3.5,
                successPercentage: 60,
                outlineWidth: 4,
                mainText: '120 øre/kW',
                subText: '20:00 - 21:00',
              ),
              IndicationCircle(
// onPressed: (){},
                successColor: Colors.blue,
                failColor: Colors.brown,
                diameter: MediaQuery.of(context).size.width/3.5,
                successPercentage: temperature*2,
                outlineWidth: 4,
                mainText: widget.weatherData == null?'-- °C':'$temperature °C',
                subText: 'Temperature',
              ),

  ],
),
              Row(

                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:  [
                  IndicationCircle(
// onPressed: (){},
                    successColor: Colors.yellow.shade800,
                    failColor: Colors.brown,
                    diameter: MediaQuery.of(context).size.width/3.5,
                    successPercentage: 80,
                    outlineWidth: 4,
                    mainText: '5000 kWh',
                    subText: 'Consumption',
                  ),
                  IndicationCircle(
// onPressed: (){},
                    successColor: Colors.teal.shade800,
                    failColor: Colors.brown,
                    diameter: MediaQuery.of(context).size.width/3.5,
                    successPercentage: 60,
                    outlineWidth: 4,
                    mainText: '7350 kWh',
                    subText: 'PV Yield',
                  ),
                  IndicationCircle(
// onPressed: (){},
                    successColor: Colors.deepOrange.shade600,
                    failColor: Colors.brown,
                    diameter: MediaQuery.of(context).size.width/3.5,
                    successPercentage: 90,
                    outlineWidth: 4,
                    mainText: '1820 NOK',
                    subText: 'Money Saved',
                  ),

                ],
              ),
              Row(

                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:  [
                  IndicationCircle(
// onPressed: (){},
                    successColor: Colors.purple,
                    failColor: Colors.brown,
                    diameter: MediaQuery.of(context).size.width/3.5,
                    successPercentage: 60,
                    outlineWidth: 4,
                    mainText: '4318 NOK',
                    subText: 'Total Cost',
                  ),



                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.1,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

