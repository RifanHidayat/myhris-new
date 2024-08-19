import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatController extends GetxController {
  // var listFoto = [].obs;
  String getTanggal() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    return formattedDate;
  }

  String getWaktu() {
    DateTime now = DateTime.now();
    String formattedTime = DateFormat('HH:mm:ss').format(now);
    return formattedTime;
  }
}
