import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SyncPieChart extends StatelessWidget {
  final double height;
  final double width;
  final String title;
  final List<PieSeries> series;
  final TooltipBehavior tooltipBehavior;

  final Color? titleColor;
  const SyncPieChart(
      {super.key,
      required this.height,
      required this.width,
      required this.title,
      this.titleColor,
      required this.series,
      required this.tooltipBehavior});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: height,
        width: width,
        child: SfCircularChart(
            legend: const Legend(
                isVisible: true, overflowMode: LegendItemOverflowMode.none),
            tooltipBehavior: tooltipBehavior,
            // title: ChartTitle(
            //   text: title,
            // ),

            series: series));
  }
}
