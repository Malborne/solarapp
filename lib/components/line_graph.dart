import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
class LineGraph extends StatefulWidget {
  final List<FlSpot> data;
  const LineGraph({super.key,
  required this.data
  });

  @override
  State<LineGraph> createState() => _LineGraphState();
}

class _LineGraphState extends State<LineGraph> {



  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      child: LineChart(
        LineChartData(
          borderData: FlBorderData(show: false),
          lineBarsData: [
            // The red line
            LineChartBarData(
              spots: widget.data,
              isCurved: true,
              barWidth: 3,
              color: Colors.red
            ),

            // The blue line

          ],
        ),
      ),
    );
  }
}
