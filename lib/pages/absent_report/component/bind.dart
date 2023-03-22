import 'package:ams/pages/absent_report/component/controller.dart';
import 'package:get/get.dart';

class AbsentReportBind implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AbsentReportCon());
  }
}
