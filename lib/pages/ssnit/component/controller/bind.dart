import 'package:ams/pages/ssnit/component/controller/controller.dart';
import 'package:get/get.dart';

class SsnitBind implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SsnitCon());
  }
}
