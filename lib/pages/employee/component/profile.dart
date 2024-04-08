import 'package:ams/pages/employee/component/controller.dart';
import 'package:ams/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../services/constants/constant.dart';
import '../../../services/widgets/pie_chart.dart';
import '../../../services/widgets/waiting.dart';
import 'models/emp_models.dart';
import 'profile_widget/widget.dart';

class EmpProfile extends StatelessWidget {
  final EmployeeCon controller;
  final EmpListModel model;
  const EmpProfile({super.key, required this.controller, required this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(
            height: 50,
          ),
          if (Responsive.isDesktop(context))
            FirstRow(model: model, controller: controller),
          if (!Responsive.isDesktop(context))
            MobileFirstRow(model: model, controller: controller),
          if (Responsive.isDesktop(context))
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => controller.cDraw.value
                    ? const MWaiting()
                    : SyncRadalBar(
                        height: myHeight(context, 2.5),
                        width: myWidth(context, 2.5),
                        title: "dfd",
                        image: model.picture!,
                        tooltipBehavior: TooltipBehavior(enable: true),
                        series: <CircularSeries>[
                          RadialBarSeries<ChartData, String>(
                            animationDuration: 1,
                            dataSource: controller.cData,
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
                            dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                                labelPosition: ChartDataLabelPosition.inside,
                                overflowMode: OverflowMode.trim),
                          ),
                        ],
                      )),
                SizedBox(
                  height: myHeight(context, 2.7),
                  width: myWidth(context, 2.1),
                  child: Obx(
                    () => controller.getData.value
                        ? const MWaiting()
                        : const ProfileTable(),
                  ),
                )
              ],
            ),
          if (!Responsive.isDesktop(context))
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => controller.cDraw.value
                    ? const MWaiting()
                    : SyncRadalBar(
                        height: myHeight(context, 2.5),
                        width: myWidth(context, 2.5),
                        title: "dfd",
                        image: model.picture!,
                        tooltipBehavior: TooltipBehavior(enable: true),
                        series: <CircularSeries>[
                          RadialBarSeries<ChartData, String>(
                            animationDuration: 1,
                            dataSource: controller.cData,
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
                            dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                                labelPosition: ChartDataLabelPosition.inside,
                                overflowMode: OverflowMode.trim),
                          ),
                        ],
                      )),
                Obx(
                  () => controller.getData.value
                      ? const MWaiting()
                      : const ProfileTable(),
                )
              ],
            )
        ],
      ),
    );
  }
}

class ChartData {
  final String? x;
  final int y;

  ChartData({required this.x, required this.y});
}
