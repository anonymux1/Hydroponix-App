import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../components/LineChart.dart';
import '../models/SystemList.dart';
import '../models/SystemLogs.dart';
import '../services/analyze_controller.dart';
import 'package:get/get.dart';

class AnalyzeScreen extends StatefulWidget {
  final SystemList? userSystemList;
  final Map<String, List<SystemLog>>? allSysLogs;
  final Map<String, List<SystemLog>>? latestReadings;
  const AnalyzeScreen(this.userSystemList, this.allSysLogs, this.latestReadings,
      {Key? key})
      : super(key: key); // Constructor

  @override
  _AnalyzeScreenState createState() => _AnalyzeScreenState();
}

class _AnalyzeScreenState extends State<AnalyzeScreen> {
  final _analyzeController = Get.put(AnalyzeController());

  @override
  Widget build(BuildContext context) {
    List<String>? Ids =
        _analyzeController.getSystemIdList(widget.userSystemList);
    String? _sel = Ids?.isNotEmpty == true ? Ids![0] : null;
    print("anacontroller ${_sel}");
    print("All logs: ${widget.allSysLogs.toString()}");
    print("System logs : ${widget.allSysLogs?[_sel].toString()}");
    final pHlogs =
        _analyzeController.getChartData(widget.allSysLogs, _sel, 'pH');
    final EClogs =
        _analyzeController.getChartData(widget.allSysLogs, _sel, 'EC');
    final templogs =
        _analyzeController.getChartData(widget.allSysLogs, _sel, 'temp');
    final haspHData = pHlogs.isNotEmpty;
    final hasECData = EClogs.isNotEmpty;
    final hasTempData = templogs.isNotEmpty;
    print("templogs: ${templogs.toString()}");
    if (Ids == null) {
      return Scaffold(
          body: SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.all(16.0),
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.height * 0.40,
                  child: Card(
                      child: ListTile(
                    leading: Icon(Icons.warning),
                    title: Text("No Systems Added to the Account"),
                    subtitle: Text("Add systems and view historical data here"),
                  )))));
    }
    return Scaffold(
        body: SingleChildScrollView(
      // Or Column, ListView as needed
      child: Container(
        padding: EdgeInsets.all(8.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            DropdownButton<String>(
              value: _sel,
              isExpanded: true,
              items: Ids.map((sysId) => DropdownMenuItem(
                    value: sysId,
                    child: Text(_analyzeController.getSysName(
                            widget.userSystemList, sysId) ??
                        ""),
                  )).toList(),
              onChanged: (newValue) {
                setState(() {
                  _sel = newValue;
                });
              },
            ),
            if (!haspHData || !hasECData || !hasTempData) ...[
              Container(
                  padding: EdgeInsets.only(left: 40.0, right: 2.0, top:16.0, bottom: 16.0),
                  width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height * 0.25,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        '${!hasTempData ? 'Temperature' : ''} ${!haspHData ? (!hasTempData ? ' and pH' : 'pH') : ''} ${!hasECData ? (!hasTempData || !haspHData ? ' and EC' : 'EC') : ''} Data not found',
                        textAlign: TextAlign.center, // Add textAlign property
                      ),
                    ),
                  ))
            ],
            if (hasTempData) ...[
              Container(
                padding: EdgeInsets.only(bottom: 8.0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.25,
                child: MyLineChart(
                    data: templogs.cast<FlSpot>(),
                    dataType: 'temp',
                    minY: 0,
                    maxY: 40),
              )
            ],
            if (hasECData) ...[
              Container(
                padding: EdgeInsets.only(bottom: 8.0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.25,
                child: MyLineChart(
                  data: EClogs.cast<FlSpot>(),
                  dataType: 'EC',
                  minY: 0,
                  maxY: 4,
                ),
              )
            ],
            if (haspHData) ...[
              Container(
                padding: EdgeInsets.only(bottom: 8.0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.25,
                child: MyLineChart(
                    data: pHlogs.cast<FlSpot>(),
                    dataType: 'pH',
                    minY: 0,
                    maxY: 14),
              )
            ],
          ],
        ),
      ),
    ));
  }
}
