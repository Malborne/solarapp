import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:solar/components/legend_widget.dart';
import 'package:solar/components/touch_bar.dart';
import 'package:solar/util/graphing_functions.dart';
import 'dart:math';


class SolarPage extends StatefulWidget {
  final priceData;
  const SolarPage({super.key, required this.priceData});

  @override
  State<SolarPage> createState() => _SolarPageState();
}
const double convRatio = 10.82/10;
class _SolarPageState extends State<SolarPage> {

  List<int> xCount = [24,7,30,12,24];

  late int _index;
  bool isLoaded = false;
  double maxPrice = 170;
  double minPrice = 110;
  late List<FlSpot> dummyData1;
  late List<FlSpot> priceSpots;

  Map<String, double> maxMin(List<dynamic> values,int count) {
    double max = values[0]['value'];
    double min = values[0]['value'];
    for(int i = 0;i<count;i++) {
      if (values[i]['value']>max) {
        max = values[i]['value'];
      } else if (values[i]['value']<min) {
        min = values[i]['value'];
      }
    }
    return {
      'max':max,
      'min':min
    };
  }
  @override
  void initState() {
    super.initState();
    _index =  0;
    priceSpots = List.generate(xCount[_index], (index) {
      return FlSpot(index.toDouble(), 10*index * Random().nextDouble());
    });

    maxPrice = widget.priceData[0]['areas']['Oslo']['Max'][0]*convRatio;
    minPrice = widget.priceData[0]['areas']['Oslo']['Min'][0]*convRatio;

    // NordPool().hourly(areas: ['Oslo']).then((priceData) {
    //   // print(priceData);
    //   maxPrice = 1.01*priceData['areas']['Oslo']['Max'][0]*convRatio;
    //   minPrice = priceData['areas']['Oslo']['Min'][0]*convRatio;
    //   print('maxPrice: $maxPrice');

      priceSpots = List.generate(xCount[_index], (index) {
        //TODO: make sure the index does not go out of range if you generate the wrong data
       double value = widget.priceData[0]['areas']['Oslo']['values'][index]['value']/10 *10.82; //Convert from MWh/Eur to kWh/øre
       dummyData1 = priceSpots;
       setState(() {
         isLoaded = true;
       });
        return FlSpot(index.toDouble(), value);
      });
      // print(priceData);
    // }).timeout(Duration(seconds: 3)).catchError((onError) {
    //   // print('Price data timeout');
    //   print(onError);
    //
    // });

    dummyData1 = List.generate(xCount[_index], (index) {
      return FlSpot(index.toDouble(), index * Random().nextDouble());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      body: SafeArea(

        child: Column(
          children: [
            Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Solar Energy Production',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              color: Colors.white12.withOpacity(0.07),
              elevation: 1,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20,bottom:5,left: 5,right: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const[
                        Text('Current Price',style: TextStyle(
                          color: Colors.white,
                          // fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        ),
                        Text('183 øre',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const[
                        Text('Price Tomorrow',style: TextStyle(
                          color: Colors.white,
                          // fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        ),
                        Text('176 øre',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            LegendsListWidget(
              legends: [
                Legend('Solar Production (kWh)', Colors.red),
                Legend('Price (NOK/kWh)', Colors.blue),
              ],
            ),
            const SizedBox(height: 30),
            AspectRatio(

              aspectRatio: 1.3,
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: LineChart(
                  LineChartData(
                    minY: roundDown(minPrice.floor(), 5).toDouble(),
                    maxY: roundUp(maxPrice.floor(), 5).toDouble(),
                    lineTouchData: LineTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: false,
                            // getTitlesWidget: titleFunctions[3],
                          // reservedSize: 36
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        axisNameSize: 25,
                        axisNameWidget: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(xTitle(_index),),
                        ),
                        sideTitles: SideTitles(
                          interval: 1,
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: titleFunctions[_index],
                          // reservedSize: 20,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          // interval: 4,
                          reservedSize: 36,
                        ),
                      ),
                    ),

                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      // The red line
                      LineChartBarData(
                        spots: dummyData1,
                        isCurved: true,
                        barWidth: 1,
                        color: Colors.red,
                        show: false,

                      ),
                      LineChartBarData(
                        spots: priceSpots,
                        isCurved: true,
                        barWidth: 1,
                        color: Colors.blue,
                        show: isLoaded,

                      ),
                    ],
                  ),
                  swapAnimationDuration: const Duration(milliseconds: 300),
                ),
              ),
            ),

            ]
                  ),
      const SizedBox(
        height: 15,
      ),

      TouchBar(
          color: Colors.grey.shade800.withOpacity(0.1),
          count: 5,
        screenWidth: MediaQuery.of(context).size.width,
        keys: [GlobalKey(),GlobalKey(),GlobalKey(),GlobalKey(),GlobalKey()],
          names: const ['Day','Week','Month','Year','Tomorrow'],
          stateChanged: (index){
            setState(() {
              _index = index;
              isLoaded = false;
              dummyData1 = List.generate(xCount[_index], (index) {
                return FlSpot(index.toDouble(), index * Random().nextDouble());
              });
              priceSpots = dummyData1;
              // NordPool().getByIndex(index: index).then((priceData) {
                priceSpots = List.generate(xCount[_index], (index) {
                  //TODO: make sure the index does not go out of range if you generate the wrong data
                  final values = widget.priceData[_index]['areas']['Oslo']['values'];
                  maxPrice = (maxMin(values,xCount[_index])['max']??240)/10 *10.82;
                  minPrice = (maxMin(values,xCount[_index])['min']??100)/10 *10.82;
                  print('max Price: $maxPrice');
                  print('min Price: $minPrice');
                  double value = values[index]['value']/10 *10.82; //Convert from MWh/Eur to kWh/øre


                  // dummyData1 = priceSpots;
                  setState(() {
                    isLoaded = true;
                  });
                  return FlSpot(index.toDouble(), value);
                });
              // });
              // priceSpots = List.generate(xCount[_index], (index) {
              //   return FlSpot(index.toDouble(), index * Random().nextDouble());
              // });
            });
          },
      ),
          ],
        )
      )
    );
  }
}
