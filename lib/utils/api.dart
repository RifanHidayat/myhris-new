import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:siscom_operasional/utils/app_data.dart';

class Api {
  static var basicAuth = 'Basic ' +
      base64Encode(utf8
          .encode('aplikasioperasionalsiscom:siscom@ptshaninformasi#2022@'));

  static var basicUrl = "http://kantor.membersis.com:2628/";
  static var urlImage='https://imagehris.siscom.id:4431';
  static var token='9d590c04119a4433971a1dd622266d38';
  static var luxand='https://api.luxand.cloud/photo/similarity';


  static var UrlfotoAbsen =urlImage + "/${AppData.selectedDatabase}/foto_absen/";
  static var UrlfotoProfile = urlImage + "/${AppData.selectedDatabase}/foto_profile/";
  static var UrlgambarDashboard = urlImage + "/${AppData.selectedDatabase}/gambar_dashboard/";
  static var UrlfileCuti =urlImage+ "/${AppData.selectedDatabase}/file_cuti/";
  static var UrlfileKlaim = urlImage + "/${AppData.selectedDatabase}/file_klaim/";
  static var UrlfileTidakhadir =urlImage + "/${AppData.selectedDatabase}/file_tidak_masuk_kerja/";
  static var urlGambarDariFinance = urlImage + "/${AppData.selectedDatabase}/gambar_banner/";
  static var urlFilePermintaanKandidat = urlImage+ "/${AppData.selectedDatabase}/file_permintaan_kandidat/";
  static var urlFileKandidat = urlImage + "/${AppData.selectedDatabase}/file_kandidat/";
  static var urlFileRecog = urlImage + "/${AppData.selectedDatabase}/face_recog/";



  static Future connectionApi(
      String typeConnect, valFormData, String url,{params=""}) async {
        print("params" +params);
    var getUrl = basicUrl + url+'?database=${AppData.selectedDatabase}'+params;
    print("url ${getUrl}");
    Map<String, String> headers = {
      'Authorization': basicAuth,
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token':AppData.setFcmToken
    };
    if (typeConnect == "post") {
      try {
        final url = Uri.parse(getUrl);
        final response =
            await post(url, body: jsonEncode(valFormData), headers: headers);
        return response;
      } on SocketException catch (e) {
        return false;
      }
    } else {
      try {
        final url = Uri.parse(getUrl);
        final response = await get(url, headers: headers);
        return response;
      } on SocketException catch (e) {
        return false;
      }
    }
  }

  static Future connectionApiUploadFile(String url, File newFile) async {
    var getUrl = basicUrl + url+"?database=${AppData.selectedDatabase}";
    Map<String, String> headers = {
      'Authorization': basicAuth,
      'Content-type': 'application/json',
      'Accept': 'application/json',
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
}
