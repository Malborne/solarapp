import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:solar/components/legend_widget.dart';
import 'package:solar/components/oval_button.dart';
import 'package:solar/components/reusable_bar.dart';
import 'package:solar/util/generate_bar_data.dart';
import 'package:solar/util/graphing_functions.dart';
import 'package:solar/components/touch_bar.dart';
class ProductionTab extends StatefulWidget {
  const ProductionTab({Key? key}) : super(key: key);

  @override
  State<ProductionTab> createState() => _ProductionTabState();
}

class _ProductionTabState extends State<ProductionTab> {
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
                  'Energy Production',
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
                          axisNameWidget: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(xTitle(_index)),
                          ),
                          axisNameSize: 25,
                          sideTitles: SideTitles(
                            // interval: 10,
                            showTitles: true,
                            getTitlesWidget: titleFunctions[_index],
                            // reservedSize: 20,
                          ),
                        ),
                      ),
                      barTouchData: BarTouchData(enabled: false),
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
          // ReusableBar(
          //   color: Colors.black12.withOpacity(0.1),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //     // crossAxisAlignment: CrossAxisAlignment.stretch,
          //     children:  [
          //       Padding(
          //         padding: const EdgeInsets.symmetric(horizontal: 8),
          //         child: OvalButton(
          //           text: 'Day',
          //           onPressed: ()=> setState(() {
          //             _index = 0;
          //           }),
          //         ),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.symmetric(horizontal: 8),
          //         child: OvalButton(
          //           text: 'Week',
          //           onPressed: ()=> setState(() {
          //             _index = 1;
          //           }),
          //         ),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.symmetric(horizontal: 8),
          //         child: OvalButton(
          //           text: 'Month',
          //           onPressed: ()=> setState(() {
          //             _index = 2;
          //           }),
          //         ),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.symmetric(horizontal: 8),
          //         child: OvalButton(
          //           text: 'Year',
          //           onPressed: ()=> setState(() {
          //             _index = 3;
          //           }),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          TouchBar(
            color: Colors.grey.shade800.withOpacity(0.1),
            count: 4,
            screenWidth: MediaQuery.of(context).size.width,
            keys: [GlobalKey(),GlobalKey(),GlobalKey(),GlobalKey()],
            names: ['Day','Week','Month','Year'],
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
