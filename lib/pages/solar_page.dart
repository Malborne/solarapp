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

// const double convRatio = 10.82/10;//NOK/kWh
const double convRatio = 1; //EUR/MWh

class _SolarPageState extends State<SolarPage> {
  late List<Widget Function(double, TitleMeta)?> titleFunctions = [
    dailyTitles,
    weeklyTitles2,
    monthlyTitles2,
    annualTitles2,
    dailyTitles
  ];

  List<int> xCount = [24, 7, 30, 12, 24];

  late int _index;
  bool isLoaded = false;
  double maxPrice = 170;
  double minPrice = 110;
  late double priceToday;
  late double priceTomorrow;
  late List<FlSpot> dummyData1;
  late List<FlSpot> priceSpots;

  Map<String, double> maxMin(List<dynamic> values, int count) {
    double max = values[0]['value'];
    double min = values[0]['value'];
    for (int i = 0; i < count; i++) {
      if (values[i]['value'] > max) {
        max = values[i]['value'];
      } else if (values[i]['value'] < min) {
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
    _index = 0;

    priceToday =
        widget.priceData['Days']['areas']['Oslo']['values'][1]['value'];
    priceTomorrow =
        widget.priceData['Days']['areas']['Oslo']['values'][0]['value'];
    priceSpots = List.generate(xCount[_index], (index) {
      return FlSpot(index.toDouble(), 10 * index * Random().nextDouble());
    });

    maxPrice = widget.priceData['Hours']['areas']['Oslo']['Max'][0] * convRatio;
    minPrice = widget.priceData['Hours']['areas']['Oslo']['Min'][0] * convRatio;

    // NordPool().hourly(areas: ['Oslo']).then((priceData) {
    //   // print(priceData);
    //   maxPrice = 1.01*priceData['areas']['Oslo']['Max'][0]*convRatio;
    //   minPrice = priceData['areas']['Oslo']['Min'][0]*convRatio;
    //   print('maxPrice: $maxPrice');

    priceSpots = List.generate(xCount[_index], (index) {
      //TODO: make sure the index does not go out of range if you generate the wrong data
      // print('Key is ${getKeyFromIndex(index)} and index: $index');
      double value = widget.priceData[getKeyFromIndex(_index)]['areas']['Oslo']
              ['values'][index]['value'] *
          convRatio; //Convert from MWh/Eur to kWh/øre
      // print(value);
      // dummyData1 = priceSpots;
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
      double y2 = index * Random().nextDouble();
      //Rescale the data to the fit the graph with the major axis on the left
      double spot =
          (y2 - 0) / (xCount[_index] - 0) * (maxPrice - minPrice) + minPrice;
      // (Y2 - minY2) / (maxY2 - minY2) * (maxY - minY) + minY
      return FlSpot(index.toDouble(), spot);
    });
  }

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;

    return Scaffold(
        backgroundColor: Colors.black38,
        body: SafeArea(
            child: ListView(
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
                                children: [
                                  const Text(
                                    'Current Price',
                                    style: TextStyle(
                                      color: Colors.white,
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    '${priceToday.round()} €/MWh',
                                    style: const TextStyle(
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
                                children: [
                                  const Text(
                                    'Price Tomorrow',
                                    style: TextStyle(
                                      color: Colors.white,
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    '${priceTomorrow.round()} €/MWh',
                                    style: const TextStyle(
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
                          // Legend('Solar Production (kWh)', Colors.red),
                          Legend('Price (€/MWh)', Colors.blue),
                        ],
                      ),
                      const SizedBox(height: 30),
                      AspectRatio(
                        aspectRatio:
                        orientation == Orientation.portrait ? 1.3 : 3.5,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: LineChart(
                        LineChartData(
                          minY: roundDown(minPrice.floor(), 10).toDouble(),
                          maxY: roundUp(maxPrice.floor(), 10).toDouble(),
                          lineTouchData: LineTouchData(enabled: true),
                          titlesData: FlTitlesData(
                            show: true,
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(
                                      showTitles: false,
                                      getTitlesWidget: rightAxisTitles,
                                      reservedSize: 36),
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
                ]),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: TouchBar(
                color: Colors.grey.shade800.withOpacity(0.1),
                count: 5,
                screenWidth: MediaQuery.of(context).size.width,
                keys: [
                  GlobalKey(),
                  GlobalKey(),
                  GlobalKey(),
                  GlobalKey(),
                  GlobalKey()
                ],
                names: const ['Day', 'Week', 'Month', 'Year', 'Tomorrow'],
                stateChanged: (index) {
                  setState(() {
                    _index = index;
                    isLoaded = false;

                    // NordPool().getByIndex(index: index).then((priceData) {
                    priceSpots = List.generate(xCount[_index], (index) {
                      //TODO: make sure the index does not go out of range if you generate the wrong data
                      var values = widget.priceData[getKeyFromIndex(_index)]
                          ['areas']['Oslo']['values'];
                      setState(() {
                        maxPrice =
                            (maxMin(values, xCount[_index])['max'] ?? 240) *
                                convRatio;
                        minPrice =
                            (maxMin(values, xCount[_index])['min'] ?? 100) *
                                convRatio;
                      });
                      // print('max Price: $maxPrice');
                      // print('min Price: $minPrice');
                      if (_index == 1 || _index == 3 || _index == 2) {
                        //Week or year
                        values = values
                            .take(xCount[_index])
                            .toList()
                            .reversed
                            .toList();
                      }
                      double value = values[index]['value'] *
                          convRatio; //Convert from MWh/Eur to kWh/øre

                      setState(() {
                        isLoaded = true;
                      });
                      return FlSpot(index.toDouble(), value);
                    });
                    dummyData1 = List.generate(xCount[_index], (index) {
                      double y2 = index * Random().nextDouble();
                      // print('Original value $index: $y2');
                      //Rescale the data to the fit the graph with the major axis on the left
                      double spot = (y2 - 0) /
                              (xCount[_index] - 0) *
                              (maxPrice - minPrice) +
                          minPrice;
                      // (Y2 - minY2) / (maxY2 - minY2) * (maxY - minY) + minY
                      return FlSpot(index.toDouble(), spot);
                    });
                    // });
                    // priceSpots = List.generate(xCount[_index], (index) {
                    //   return FlSpot(index.toDouble(), index * Random().nextDouble());
                    // });
                  });
                },
              ),
            ),
          ],
            )));
  }

  Widget rightAxisTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontSize: 10,
    );
    //getting the orignial value from the scaled value
    double spot =
        (value - minPrice) * (xCount[_index] - 0) / (maxPrice - minPrice) + 0;
    // print('restored Original: $spot');
    //OriginalValue = (scaled-minY)*(maxY2-MinY2)/(maxY-minY)+minY
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text('${spot.toInt()}'),
    );
  }

  Widget monthlyTitles2(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontSize: 10,
    );
    List<dynamic> datesList = widget.priceData['Days']['areas']['Oslo']
            ['values']
        .toList()
        .reversed
        .toList()
        .map((v) => DateTime.parse(v['end'].toString()))
        .toList();
    // print(datesList);
    // DateTime start = DateTime.parse(widget.priceData['Days']['start'].toString());
    // String text = (value.toInt()+1)%3==0||(value.toInt()+1)==1?(value.toInt()+1).toString():'';

    String text = (value.toInt() + 1) % 6 == 0 || (value.toInt() + 1) == 1
        ? '${datesList[value.toInt()].day}/${datesList[value.toInt()].month}/${datesList[value.toInt()].year.toString().substring(datesList[value.toInt()].year.toString().length - 2)}'
        : '';
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Text(text, style: style),
      ),
    );
  }

  Widget annualTitles2(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontSize: 10,
    );

    List<dynamic> datesList = widget.priceData['Months']['areas']['Oslo']
            ['values']
        .toList()
        .take(12)
        .toList()
        .reversed
        .toList()
        .map((v) => DateTime.parse(v['start'].toString()))
        .toList();

    String text = value.toInt() % 3 == 0 || value.toInt() == 11
        ? '${getMonthNames(datesList[value.toInt()].month)} ${datesList[value.toInt()].year.toString().substring(datesList[value.toInt()].year.toString().length - 2)}'
        : '';
    // print(datesList);
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Text(text, style: style),
      ),
    );
  }
}
