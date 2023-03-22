
import 'controller.dart';
import 'package:get/get.dart';

class AbsentBind implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AbsenteeCon());
  }
}
