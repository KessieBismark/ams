import 'package:get/get.dart';

import 'controller.dart';

class DepartmentBind implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DepartmentCon());
  }
}
