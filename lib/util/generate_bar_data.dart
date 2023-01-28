import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';
BarChartGroupData generateGroupData(
    int x,
    double gridEnergy,
    double pvEnergy,
    double barWidth,
    double betweenSpace,
    Color pvColor,
    Color gridColor,

    ) {
  return BarChartGroupData(
    x: x,
    groupVertically: true,
    barRods: [

      BarChartRodData(
        fromY:  0,
        toY:  gridEnergy,
        color: pvColor,
        width: barWidth,
      ),
      BarChartRodData(
        fromY:  gridEnergy + betweenSpace,
        toY:  gridEnergy + betweenSpace + pvEnergy,
        color: gridColor,
        width: barWidth,
      ),
    ],
  );
}

List<BarChartGroupData> generateGroupDataList({ required int n,required double barWidth,required double betweenSpace,required Color gridColor,required Color pvColor}) {
  List<BarChartGroupData> chartGroupList = [];
  for( var i = 0 ; i < n; i++) {
    double gridEnergy = 5 * Random().nextDouble();
    double pvEnergy = 3 * Random().nextDouble();
    chartGroupList.add(generateGroupData(i,gridEnergy,pvEnergy,barWidth,betweenSpace,pvColor,gridColor));
  }
  return chartGroupList;
}