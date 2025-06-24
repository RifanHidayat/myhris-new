import 'dart:convert';

import 'package:get/get.dart';
import 'package:siscom_operasional/services/request.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';

class UserController {
  var jadwalKerja = [].obs;
  var isLoading = false.obs;

  Future<void> generateJadwalKerja() async {
    try {
      isLoading.value = true;
      var request = Request(url: 'jadwal-kerja',params: "").get();
      var response = await request; // pastikan .get() mengembalikan Future

      if (response.statusCode == 200) {
        var body = json.decode(response.body);

     
        jadwalKerja.value = body['data'];


        isLoading.value = false;
      } else {
    
        isLoading.value = false;
        print("Server error: ${response.statusCode}");
      }
    } catch (e) {
       
      isLoading.value = false;
      print("Terjadi kesalahan: $e");
    }
  }
}
