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

  String getFileExtension(String filePath) {
    int dotIndex = filePath.lastIndexOf('.');
    if (dotIndex != -1 && dotIndex != filePath.length - 1) {
      return filePath.substring(dotIndex + 1);
    }
    return '';
  }
}
