import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/model/database.dart';
import 'package:siscom_operasional/screen/buat_password_baru.dart';
import 'package:siscom_operasional/screen/kode_verifikasi.dart';
import 'package:siscom_operasional/screen/otp_success.dart';
import 'package:siscom_operasional/screen/succes_change_passwod.dart';
import 'package:siscom_operasional/services/request.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/helper.dart';
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
  var mobileCtr = TextEditingController().obs;

  var waToken = "".obs;

  var nameTemp = "".obs;

  var emailTemp = "".obs;

  RxInt levelClock = 0.obs;
  Timer? _timer;
  int remainingSecond = 0;
  final time = '00.00.'.obs;

  Future<bool> dataabse() async {
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

      var response = await Request(
              url: "/login/send-email",
              params: "&email=${email.value.text}&kode=${kode}")
          .get();
      var resp = jsonDecode(response.body);

      if (response.statusCode == 200) {
        emailTemp.value = email.value.text;
        AppData.kodeVerifikasi = kode.toString();
        Get.back();
        Get.back();
        _startTimer(120);
        Get.to(KodeVerifikasiPage(
          type: 'email',
        ));
      } else {
        Get.back();
      }
    } catch (e) {
      print(e);
      Get.back();
    }
  }

  Future<void> checkNoHp() async {
    print("tes");
    UtilsAlert.showLoadingIndicator(Get.context!);
    tempEmail.value.text = "";

    final Random random = Random();

    var kode = random.nextInt(9000) + 1000;

    try {
      UtilsAlert.showLoadingIndicator(Get.context!);

      var response = await Request(
              url: "/login/cek-no-hp",
              params:
                  "&email=${email.value.text}&kode=${kode}&mobile_phone=${mobileCtr.value.text}")
          .get();
      var resp = jsonDecode(response.body);
      print("data ${resp}");

      if (response.statusCode == 200) {
        List data = resp['data'];

        print(data);
        AppData.kodeVerifikasi = kode.toString();

        if (data.isNotEmpty) {
          nameTemp.value = data[0]['full_name'];
          emailTemp.value = data[0]['em_email'];

          if (data[0]['em_mobile'] == mobileCtr.value.text.toString()) {
            // sendWa(
            //     email: data[0]['em_email'],
            //     code: kode,
            //     nama: data[0]['full_name'],
            //     numbderPhone: mobileCtr.value.text);
            getToken(
                email: data[0]['em_email'],
                code: kode,
                nama: data[0]['full_name'],
                numbderPhone: mobileCtr.value.text);
          } else {
            UtilsAlert.showToast("Nomor belum terdaftar");
            Get.back();
            Get.back();
          }
        } else {
          UtilsAlert.showToast("user tidak ditemukan");
          Get.back();
          Get.back();
        }
      } else {
        UtilsAlert.showToast(resp['message']);
        Get.back();
        Get.back();
      }
    } catch (e) {
      print(e);
      Get.back();
      Get.back();
    }
  }

  Future<void> sendWa({email, code, nama, numbderPhone, token}) async {
    var basicAuth = 'Basic ' +
        base64Encode(utf8
            .encode('aplikasioperasionalsiscom:siscom@ptshaninformasi#2022@'));
    Map<String, String> headers = {
 
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token.toString().trim()}',
    };
    try {
      var body = {
        "client_id": "0552",
        "project_id": "4389",
        "type": "otp_desktop2",
        "recipient_number":
            formatPhoneNumberTo62(numbderPhone.toString()).toString().trim(),
        "language_code": "id",
        "params": {
          "1": email,
          "2": code.toString(),
          "3": nama.toString(),
          "4": numbderPhone.toString(),
          "5": selectedPerusahaan.value,
          "6": "19/06/202"
        }
      };
      print(headers);

      var response = await http.post(
          Uri.parse("${Api.wappin}/message/do-send-hsm"),
          body: jsonEncode(body),
          headers: headers);
      var resp = jsonDecode(response.body);
      print(resp);

      if (response.statusCode == 200) {
        Get.back();

        Get.back();

        _startTimer(120);
        Get.to(KodeVerifikasiPage(
          type: "wa",
        ));
      } else {
        Get.back();
      }
    } catch (e) {
      print(e);
      Get.back();
    }
  }

  Future<void> getToken({email, code, nama, numbderPhone}) async {
    var basicAuth = 'Basic ' +
        base64Encode(
            utf8.encode('0552:0b845715a25eb5ee4727ecd7d92c1272a6da97f4'));
    Map<String, String> headers = {
      'Authorization': basicAuth,
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    try {
      var body = {
        "username": "0552",
        "password": "0b845715a25eb5ee4727ecd7d92c1272a6da97f4",
      };

      var response = await http.post(Uri.parse("${Api.wappin}/token/get"),
          body: jsonEncode(body), headers: headers);
      var resp = jsonDecode(response.body);
      print(resp);

      if (response.statusCode == 200) {
        waToken.value = resp['data']['access_token'];
        print("token ${resp['data']['access_token']}");
        sendWa(
            email: email,
            code: code,
            nama: nama,
            numbderPhone: numbderPhone,
            token: resp['data']['access_token']);
      } else {
        Get.back();
        UtilsAlert.showToast("Gagal mengirim otp");
      }
    } catch (e) {
      print(e);
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
      var body = {
        "email": email.value.text,
        "password": password.value.text.toString()
      };
      print(body);

      // var response =
      //     await Request(url: "/new-password", body: body).post();
      var response = await http.post(
          Uri.parse(
              "http://kantor.membersis.com:3001/new-password?database=${AppData.selectedDatabase}"),
          body: jsonEncode(body),
          headers: headers);
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

  Future<void> sendWaRepear() async {
    UtilsAlert.showLoadingIndicator(Get.context!);
    final Random random = Random();

    var kode = random.nextInt(9000) + 1000;
    var basicAuth = 'Basic ' +
        base64Encode(utf8
            .encode('aplikasioperasionalsiscom:siscom@ptshaninformasi#2022@'));
    Map<String, String> headers = {
      'Authorization': basicAuth,
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${waToken.value.toString().trim()}',
    };
    try {
      print("tes ${AppData.selectedDatabase}");
      var body = {
        "client_id": "0552",
        "project_id": "4389",
        "type": "otp_desktop2",
        "recipient_number": formatPhoneNumberTo62(mobileCtr.value.text),
        "language_code": "id",
        "params": {
          "1": emailTemp.value.toString(),
          "2": kode.toString(),
          "3": nameTemp.value.toLowerCase(),
          "4": mobileCtr.value.text,
          "5": selectedPerusahaan.value,
          "6": "19/06/202"
        }
      };

      var response = await http.post(
          Uri.parse("https://api.wappin.id/v1/message/do-send-hsm/"),
          body: jsonEncode(body),
          headers: headers);
      var resp = jsonDecode(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        Get.back();
        UtilsAlert.showToast("OTP berhasil dikirim");
        AppData.kodeVerifikasi = kode.toString();
        // Get.back();
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
