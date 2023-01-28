import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'package:solar/pages/production_tab.dart';
import 'package:solar/pages/consumption_tab.dart';
import 'package:solar/pages/home_page.dart';

class EnergyPage extends StatefulWidget{

  const EnergyPage({Key? key}) : super(key: key);

  @override
  State<EnergyPage> createState() => _EnergyPageState();
}

class _EnergyPageState extends State<EnergyPage>  with SingleTickerProviderStateMixin {

  late TabController _tabController ;


  final List<FlSpot> dummyData1 = List.generate(8, (index) {
    return FlSpot(index.toDouble(), index * Random().nextDouble());
  });
  final List<FlSpot> dummyData2 = List.generate(8, (index) {
    return FlSpot(index.toDouble(), index * Random().nextDouble());
  });

  @override
  void initState() {
    super.initState();
    _tabController =  TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.black38,
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: Colors.purple,
          elevation: 0,
          // actions: <Widget>[
          //   // action button
          //
          //   IconButton(
          //     icon: const Icon(Icons.settings),
          //     onPressed: () => Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => const HomePage()),
          //     ),
          //   ),
          //
          // ],
          // overflow menu
          bottom: TabBar(
            controller: _tabController,
            tabs: const[
              Tab(
                text: 'Production',
              ),
              Tab(
                text: 'Consumption',
              ),
            ],
          ),
          // title: const Text('Club Management'),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
             ProductionTab(),

            ConsumptionTab(),
          ],
        ),
      ),
    );





  }
}
