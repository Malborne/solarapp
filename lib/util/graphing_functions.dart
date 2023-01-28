import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

 List<Widget Function(double, TitleMeta)?> titleFunctions = [dailyTitles,weeklyTitles,monthlyTitles,annualTitles,dailyTitles];


Widget annualTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.white,
    fontSize: 10,
  );
  String text;
  switch (value.toInt()) {
    case 0:
      text = 'JAN';
      break;
    case 1:
      text = 'FEB';
      break;
    case 2:
      text = 'MAR';
      break;
    case 3:
      text = 'APR';
      break;
    case 4:
      text = 'MAY';
      break;
    case 5:
      text = 'JUN';
      break;
    case 6:
      text = 'JUL';
      break;
    case 7:
      text = 'AUG';
      break;
    case 8:
      text = 'SEP';
      break;
    case 9:
      text = 'OCT';
      break;
    case 10:
      text = 'NOV';
      break;
    case 11:
      text = 'DEC';
      break;
    default:
      text = '';
  }
  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Text(text, style: style),
    ),
  );
}

Widget monthlyTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.white,
    fontSize: 10,
  );
  String text = (value.toInt()+1)%3==0||(value.toInt()+1)==1?(value.toInt()+1).toString():'';

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Text(text, style: style),
    ),
  );
}

Widget weeklyTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.white,
    fontSize: 10,
  );
  String text;
  switch (value.toInt()) {
    case 0:
      text = 'SUN';
      break;
    case 1:
      text = 'MON';
      break;
    case 2:
      text = 'TUE';
      break;
    case 3:
      text = 'WED';
      break;
    case 4:
      text = 'THU';
      break;
    case 5:
      text = 'FRI';
      break;
    case 6:
      text = 'SAT';
      break;
    default:
      text = '';
  }
  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Text(text, style: style),
    ),
  );
}

Widget dailyTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.white,
    fontSize: 10,
  );
  String text = (value.toInt())%6==0||(value.toInt())==23?'${(value.toInt())}:00':'';

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Text(text, style: style),
    ),
  );
}

String xTitle (int index){
  String text;
  switch(index){
    case 0:
    case 4:
      text = 'Hour';
      break;
    case 1:
      text = 'Day of the Week';
      break;
    case 2:
      text = 'Day of the Month';
      break;
    case 3:
      text = 'Month';
      break;
    default:
      text = '';
  }
  return text;
}

int weekNum() {
  final now = DateTime.now();
  final firstJan  =  DateTime(now.year, 1, 1);
  return (now.difference(firstJan).inDays / 7).ceil();
}

int roundDown(int number, int factor) {
  if (factor < 1) throw RangeError.range(factor, 1, null, "factor");
  return number - (number % factor);
}
int roundUp(int number, int factor) => roundDown(number + (factor - 1), factor);