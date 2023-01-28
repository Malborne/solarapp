import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:solar/components/legend_widget.dart';
import 'package:solar/components/touch_bar.dart';
import 'package:solar/util/generate_bar_data.dart';
import 'package:solar/util/graphing_functions.dart';
class ConsumptionTab extends StatefulWidget {
  const ConsumptionTab({Key? key}) : super(key: key);

  @override
  State<ConsumptionTab> createState() => _ConsumptionTabState();
}

class _ConsumptionTabState extends State<ConsumptionTab> {
  // static const gridColor = Color(0xffffb3ba);
  static Color gridColor = Colors.red.shade400;
  static const pvColor = Color(0xff578eff);
  static const betweenSpace = 0.0;
  static const double barWidth = 5.0;

  List<int> xCount = [24,7,30,12];

  late int _index;

  @override
  void initState() {
    super.initState();
    _index =  0;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,

        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Energy Consumption',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                LegendsListWidget(
                  legends: [
                    Legend('Grid Energy (kWh)', pvColor),
                    Legend('PV Energy (kWh)', gridColor),
                  ],
                ),
                const SizedBox(height: 14),
                AspectRatio(
                  aspectRatio: 1,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceBetween,
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 2,
                            // getTitlesWidget: bottomTitles,
                            reservedSize: 16,
                          ),
                        ),
                        rightTitles: AxisTitles(),
                        topTitles: AxisTitles(),
                        bottomTitles: AxisTitles(
                          axisNameWidget: Text(xTitle(_index)),
                          sideTitles: SideTitles(
                            // interval: 10,
                            showTitles: true,
                            getTitlesWidget: titleFunctions[_index],
                            // reservedSize: 20,
                          ),
                        ),
                      ),
                      barTouchData: BarTouchData(enabled: true),
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(show: false),
                      barGroups: generateGroupDataList(
                          n: xCount[_index],
                          barWidth: barWidth,
                          betweenSpace: betweenSpace,
                          gridColor: gridColor,
                          pvColor: pvColor),
                      maxY: 8 + (betweenSpace * 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
          TouchBar(
            color: Colors.grey.shade800.withOpacity(0.1),
            count: 4,
            screenWidth: MediaQuery.of(context).size.width,
            keys: [GlobalKey(),GlobalKey(),GlobalKey(),GlobalKey()],
            names: const ['Day','Week','Month','Year'],
            stateChanged: (index){
              setState(() {
                _index = index;
              });
            },
          ),
        ],
      ),
    );
  }
  }

