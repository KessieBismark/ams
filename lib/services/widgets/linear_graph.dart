import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../constants/constant.dart';

class SyncCartesianChart extends StatelessWidget {
  final double height;
  final double width;
  final String title;
  final ChartAxis xAxis;
  final ChartAxis yAxis;
  final TooltipBehavior tooltipBehavior;
  final List<CartesianSeries> series;
  final Color? titleColor;
  const SyncCartesianChart({
    super.key,
    required this.height,
    required this.width,
    required this.title,
    this.titleColor,
    required this.series,
    required this.xAxis,
    required this.yAxis,
    required this.tooltipBehavior,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: myWidth(context, width),
      child: SfCartesianChart(
          legend: const Legend(
              isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
          tooltipBehavior: tooltipBehavior,
          title: ChartTitle(
            text: title,
          ),
          primaryXAxis: xAxis,
          primaryYAxis: yAxis,
          series: series),
    );
  }
}
