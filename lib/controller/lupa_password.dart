import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscom_operasional/model/database.dart';
import 'package:siscom_operasional/screen/buat_password_baru.dart';
import 'package:siscom_operasional/screen/kode_verifikasi.dart';
import 'package:siscom_operasional/services/request.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';

class LupaPasswordController extends GetxController {
  var menus = [
    {"name": "Email", "is_active": 1},
    {"name": "Nomor HP", "is_active": 0}
  ].obs;
  var username = TextEditingController().obs;
  var password = TextEditingController().obs;
  var password1 = TextEditingController().obs;
  var email = TextEditingController().obs;
  var tempEmail = TextEditingController().obs;
  var showpassword = false.obs;
  var showpassword1 = false.obs;
  var databases = <DatabaseModel>[].obs;
  var selectedDb = "".obs;
  var selectedPerusahaan = "".obs;
  var perusahaan = TextEditingController();
  var tempVerifikasiKode = "".obs;

  RxInt levelClock = 0.obs;
  Timer? _timer;
  int remainingSecond = 0;
  final time = '00.00.'.obs;

  Future<bool> dataabse() async {
    tempEmail.value.text = "";
    try {
      UtilsAlert.showLoadingIndicator(Get.context!);
      var response =
          await Request(url: "/login/check-database?email=rifan@siscom.co.id")
              .getCheckDatabase();
      var resp = jsonDecode(response.body);

      if (response.statusCode == 200) {
        tempEmail.value.text = email.value.text;
        databases.value = DatabaseModel.fromJsonToList(resp['data']);
        Get.back();
        return true;
      } else {
        Get.back();
        databases.value = [];
        return false;
      }
    } catch (e) {
      print(e);
      Get.back();
      databases.value = [];
      return false;
    }
  }

  Future<void> sendEmail() async {
    print("tes");
    UtilsAlert.showLoadingIndicator(Get.context!);
    tempEmail.value.text = "";

    final Random random = Random();

    var kode = random.nextInt(9000) + 1000;

    try {
      UtilsAlert.showLoadingIndicator(Get.context!);
      print("tes");
      var response = await Request(
              url: "/login/send-email",
              params: "&email=${email.value.text}&kode=${kode}")
          .get();
      var resp = jsonDecode(response.body);

      if (response.statusCode == 200) {
        AppData.kodeVerifikasi = kode.toString();
        Get.back();
        _startTimer(120);
        Get.to(KodeVerifikasiPage());
      } else {
        Get.back();
      }
    } catch (e) {
      print(e);
      Get.back();
    }
  }

  Future<void> changeNewPassword() async {
    print("tesz");

   
 
    try {
      UtilsAlert.showLoadingIndicator(Get.context!);
      print("tes ${AppData.selectedDatabase}");
      var body = {"email": email.value.text.toString(), "password": password.value.text.toString()};
    
      var response =
          await Request(url: "/new-password-baru", body: jsonEncode(body)).post();
      var resp = jsonDecode(response.body);
      print(resp);

      if (response.statusCode == 200) {
      
        Get.back();

        Get.off(BuatPasswordbaru());
      } else {
        Get.back();
      }
    } catch (e) {
      print(e);
      Get.back();
    }
  }

  Future<void> sendEmailRepeat() async {
    print("tes");
    UtilsAlert.showLoadingIndicator(Get.context!);
    tempEmail.value.text = "";

    final Random random = Random();

    var kode = random.nextInt(9000) + 1000;

    try {
      UtilsAlert.showLoadingIndicator(Get.context!);
      print("tes");
      var response = await Request(
              url: "/login/send-email",
              params: "&email=${email.value.text}&kode=${kode}")
          .get();
      var resp = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Get.back();
        UtilsAlert.showToast("OTP berhasil dikirim");
        AppData.kodeVerifikasi = kode.toString();
        Get.back();
        _startTimer(120);
      } else {
        Get.back();
      }
    } catch (e) {
      print(e);
      Get.back();
    }
  }

  _startTimer(int seconds) {
    const duration = Duration(seconds: 1);
    remainingSecond = seconds;
    _timer = Timer.periodic(duration, (timer) {
      if (remainingSecond == 0) {
        timer.cancel();
      } else {
        int minutes = remainingSecond ~/ 60;
        int seconds = remainingSecond % 60;
        time.value = minutes.toString().padLeft(2, "0") +
            ":" +
            seconds.toString().padLeft(2, "0");
        remainingSecond--;
      }
    });
  }
}
