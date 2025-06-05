
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetController extends GetxController {
  var isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initConnectionListener();
  }

  void _initConnectionListener() {
    InternetConnectionCheckerPlus().onStatusChange.listen((InternetConnectionStatus status) {
      isConnected.value = (status == InternetConnectionStatus.connected);
    });
  }
}
