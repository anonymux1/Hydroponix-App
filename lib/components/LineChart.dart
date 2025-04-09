import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class MyLineChart extends StatefulWidget {
  final List<FlSpot> data;
  final String dataType;
  final double minY;
  final double maxY;

  const MyLineChart(
      {Key? key,
      required this.data,
      required this.dataType,
      required this.minY,
      required this.maxY})
      : super(key: key);

  @override
  State<MyLineChart> createState() => _MyLineChartState();
}

class _MyLineChartState extends State<MyLineChart> {
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false), // Hide grid lines
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => Colors.blueGrey.withValues(alpha: 0.8),
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final flSpot = barSpot;
                if (flSpot.barIndex == 0) {
                  return LineTooltipItem(
                    'pH: ${flSpot.y.toStringAsFixed(2)}',
                    TextStyle(color: Colors.white),
                  );
                } else if (flSpot.barIndex == 1) {
                  return LineTooltipItem(
                    'EC: ${flSpot.y.toStringAsFixed(2)}',
                    TextStyle(color: Colors.white),
                  );
                } else if (flSpot.barIndex == 2) {
                  return LineTooltipItem(
                    'Temp: ${flSpot.y.toStringAsFixed(2)}',
                    TextStyle(color: Colors.white),
                  );
                }
                return null;
              }).toList();
            },
          ),
          // handleBuiltInGestures: true,
        ),
        // ...your titlesData, gridData, borderData ...
        minY: widget.minY,
        maxY: widget.maxY, // Adjust based on your data range
        lineBarsData: [
          LineChartBarData(
            spots: widget.data,
            color: Colors.blue,
            isCurved: true,
            barWidth: 2,
            dotData: FlDotData(show: false),
            show: true,
            // title: 'pH',
          ),
        ],
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (widget.data.isEmpty) {
                  return Text(''); // Handle empty data case
                }
                final minTime = DateTime.fromMillisecondsSinceEpoch(
                    widget.data.first.x.toInt() * 1000);
                final maxTime = DateTime.fromMillisecondsSinceEpoch(
                    widget.data.first.x.toInt() * 1000);
                if (value == widget.data.first.x) {
                  final timestamp =
                      DateTime.fromMillisecondsSinceEpoch(value.toInt() * 1000);
                  return Text(
                    '${timestamp.day}/${timestamp.month} ${timestamp.hour}:${timestamp.minute}',
                    style: TextStyle(fontSize: 10),
                  );
                } else if (value == widget.data.last.x) {
                  final timestamp =
                      DateTime.fromMillisecondsSinceEpoch(value.toInt() * 1000);
                  if (minTime.day == maxTime.day &&
                      minTime.month == maxTime.month &&
                      minTime.year == maxTime.year) {
                    return Text(
                      '${timestamp.hour}:${timestamp.minute}',
                      style: TextStyle(fontSize: 10),
                    );
                  } else {
                    return Text(
                      '${timestamp.day}/${timestamp.month} ${timestamp.hour}:${timestamp.minute}',
                      style: TextStyle(fontSize: 10),
                    );
                  }
                } else {
                  return Text(''); // Hide labels for intermediate values
                }
              },
              interval: max((widget.data.last.x - widget.data.first.x) /
                  4,1) // Example interval for hourly data
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: max((widget.maxY - widget.minY) / 4 , 1),
              getTitlesWidget: (value, meta) {
                return Text(
                    value == 0 ? (widget.dataType =='temp'? '°C': widget.dataType): value.toStringAsFixed(0));
              },
            ),
          ),
        ),
      ),
    );
  }
}
