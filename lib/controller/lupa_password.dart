import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscom_operasional/model/database.dart';
import 'package:siscom_operasional/screen/buat_password_baru.dart';
import 'package:siscom_operasional/screen/kode_verifikasi.dart';
import 'package:siscom_operasional/screen/otp_success.dart';
import 'package:siscom_operasional/screen/succes_change_passwod.dart';
import 'package:siscom_operasional/services/request.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';

import 'package:http/http.dart' as http;

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
    print("email ${email.value.text}");
    tempEmail.value.text = "";
    try {
      UtilsAlert.showLoadingIndicator(Get.context!);
      var response =
          await Request(url: "/login/check-database?email=${email.value.text}")
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

  var basicAuth = 'Basic ' +
      base64Encode(utf8
          .encode('aplikasioperasionalsiscom:siscom@ptshaninformasi#2022@'));

  
   
      Map<String, String> headers = {
    'Authorization': basicAuth,
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'token': AppData.setFcmToken,
  
    
  };
 
    try {
      UtilsAlert.showLoadingIndicator(Get.context!);
      print("tes ${AppData.selectedDatabase}");
      var body = {"email": email.value.text.toString(), "password": password.value.text.toString()};
    
      // var response =
      //     await Request(url: "/new-password", body: body).post();
          var response=await http.post(Uri.parse("http://kantor.membersis.com:3001/new-password?database=${AppData.selectedDatabase}"),body: jsonEncode(body),headers: headers);
      var resp = jsonDecode(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
           Get.back();

        print("masuk sinii");
       Get.off(SuccessCangePasswordPage());
     
       
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
