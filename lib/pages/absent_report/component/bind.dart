import 'package:get/get.dart';

import 'controller.dart';

class AbsentReportBind implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AbsentReportCon());
  }
}
