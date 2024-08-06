import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:siscom_operasional/controller/auth_controller.dart';
import 'package:siscom_operasional/screen/init_screen.dart';
import 'package:siscom_operasional/screen/login.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';

class Api {


  static var basicAuth = 'Basic ' +
      base64Encode(utf8
          .encode('aplikasioperasionalsiscom:siscom@ptshaninformasi#2022@'));
 
 // static var basicUrl = "http://mobilehris.siscom.id:3000/";
  static var urlImage = 'https://imagehris.siscom.id:4431';

  //static var basicUrl = "http://mobilehris.siscom.id:3000/";
 static var basicUrl = "http://kantor.membersis.com:2626/";

  static var token = '9d590c04119a4433971a1dd622266d38';
  static var luxand = 'https://api.luxand.cloud/photo/similarity';
  static var wappin = 'https://api.wappin.id/v1';

  static var UrlfotoAbsen =
      urlImage + "/${AppData.selectedDatabase}/foto_absen/";
  static var UrlfotoProfile =
      urlImage + "/${AppData.selectedDatabase}/foto_profile/";
  static var UrlgambarDashboard =
      urlImage + "/${AppData.selectedDatabase}/gambar_dashboard/";
  static var UrlfileCuti = urlImage + "/${AppData.selectedDatabase}/file_cuti/";
  static var UrlfileKlaim =
      urlImage + "/${AppData.selectedDatabase}/file_klaim/";
  static var UrlfileTidakhadir =
      urlImage + "/${AppData.selectedDatabase}/file_tidak_masuk_kerja/";
  static var urlGambarDariFinance =
      urlImage + "/${AppData.selectedDatabase}/gambar_banner/";
  static var urlFilePermintaanKandidat =
      urlImage + "/${AppData.selectedDatabase}/file_permintaan_kandida t/";
  static var urlFileKandidat =
      urlImage + "/${AppData.selectedDatabase}/file_kandidat/";

  static var urlFileRecog =
      urlImage + "/${AppData.selectedDatabase}/face_recog/";

  static Future connectionApi(String typeConnect, valFormData, String url,
      {params = ""}) async {
    print("params" + params);
    // var getUrl = basicUrl + url + '?database=demohr' + params;
    var getUrl =
        basicUrl + url + "?database=${AppData.selectedDatabase}" + params;
    print("url ${getUrl}");
    Map<String, String> headers = {
      'Authorization': basicAuth,
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': AppData.setFcmToken,
      'em_id': AppData.informasiUser == null ||
              AppData.informasiUser == "null" ||
              AppData.informasiUser == "" ||
              AppData.informasiUser!.isEmpty
          ? ""
          : AppData.informasiUser![0].em_id
    };

    if (typeConnect == "post") {
      try {
        final url = Uri.parse(getUrl);
        final response =
            await post(url, body: jsonEncode(valFormData), headers: headers);
        if (response.statusCode == 402) {
          var authController = Get.put(AuthController());
          var res = jsonDecode(response.body);
          var resp = res['message'];
          authController.messageLogout.value = resp;
          authController.isautoLogout = true.obs;
          Api().validateAuth(response.statusCode, resp);
          return;
        } else if (response.statusCode == 200) {
          var authController = Get.put(AuthController());
          authController.messageLogout.value = "";
          authController.isautoLogout.value = false;
        } else {
          print("error");
        }

        return response;
      } on SocketException catch (e) {
        print(e);
        return false;
      }
    } else {
      try {
        final url = Uri.parse(getUrl);
        final response = await get(url, headers: headers);
        return response;
      } on SocketException catch (e) {
        print(e);
        return false;
      }
    }
  }

  static Future connectionApiUploadFile(String url, File newFile) async {
    var getUrl = basicUrl + url + "?database=${AppData.selectedDatabase}";

    Map<String, String> headers = {
      'Authorization': basicAuth,
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': AppData.setFcmToken,
      'em_id': AppData.informasiUser == null ||
              AppData.informasiUser == "null" ||
              AppData.informasiUser == "" ||
              AppData.informasiUser!.isEmpty
          ? ""
          : AppData.informasiUser![0].em_id
    };

    try {
      final url = Uri.parse(getUrl);
      var request = http.MultipartRequest('POST', url);
      request.files.add(
        await http.MultipartFile.fromPath('sampleFile', newFile.path),
      );
      request.headers.addAll(headers);
      var response = await request.send();
      var respStr = await response.stream.bytesToString();
      return respStr;
    } on SocketException catch (e) {
      return false;
    }
  }

  Future<void> checkLogin() async {
    // var response = await http.post(Uri.parse(basicUrl +
    //     '/validate-login-sesssion?database=${AppData.selectedDatabase}'));

    // try {
    //   validateAuth(response.statusCode);
    // } catch (e) {
    //   print(e);
    // }
  }

  validateAuth(code, message) {
    if (code == 402 || code == "" || code == null) {
      AppData.isLogin = false;
      Get.offAll(Login());

      _stopForegroundTask();

      return;
    }
  }

  Future<bool> _stopForegroundTask() async {
    return await FlutterForegroundTask.stopService();
  }
}

class ApiRequest {
  late final String url;
  late final dynamic body;
  late final dynamic temParams;

  static var basicAuth = 'Basic ' +
      base64Encode(utf8
          .encode('aplikasioperasionalsiscom:siscom@ptshaninformasi#2022@'));
   // static var basicUrl = "http://mobilehris.siscom.id:3000/";
  static var basicUrl = "http://kantor.membersis.com:2626/";
 // static var basicUrl = "http://mobilehris.siscom.id:3000/";
  Map<String, String> headers = {
    'Authorization': basicAuth,
    'Content-type': 'application/json',
    'Accept': 'application/json',
    // 'token': AppData.setFcmToken,
    // 'em_id': 'SIS202305048'
  };

  var params = {
    'database': AppData.selectedDatabase,
    // 'database': 'demohr',
  };

  ApiRequest({required this.url, this.body, this.temParams});

  Future<http.Response> get() async {
    print("Hostname ${headers}");
    if (temParams != null) {
      headers.addAll(temParams);
    }

    print(basicUrl + url);
    return await http
        .get(Uri.parse(basicUrl + url).replace(queryParameters: headers),
            headers: headers)
        .timeout(Duration(minutes: 3));
  }

  Future<http.Response> post() async {
    print(params);
    print(temParams);
    if (temParams != null) {
      params.addAll(temParams);
    }

    print("basic ${basicUrl + url}");
    return await http
        .post(Uri.parse(basicUrl + url).replace(queryParameters: params),
            body: jsonEncode(body), headers: headers)
        .timeout(Duration(minutes: 2));
  }

  Future<http.Response> patch() async {
    print(headers);
    print(temParams);
    if (temParams != null) {
      headers.addAll(temParams);
    }

    print(basicUrl + url);
    return await http
        .patch(Uri.parse(basicUrl + url).replace(queryParameters: headers),
            body: jsonEncode(body), headers: headers)
        .timeout(Duration(minutes: 2));
  }

  Future<http.Response> delete() async {
    // print("Hostname ${AppData.hostInformation![0].hostname}");
    // print("Hostname ${AppData.hostInformation![0].port}");
    // print("Hostname ${AppData.hostInformation![0].dbname}");
    // print("periode ${AppData.periode}");
    // print("Kode cabang ${AppData.kodeCabang}");
    if (temParams != null) {
      headers.addAll(temParams);
    }

    print(basicUrl + url);
    return await http
        .delete(Uri.parse(basicUrl + url).replace(queryParameters: headers),
            body: jsonEncode(body), headers: headers)
        .timeout(Duration(minutes: 3));
  }
}
