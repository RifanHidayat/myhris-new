import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';

class Request {
  late final String url;
  late final dynamic body;
  var  params;

  

  Request({required this.url, this.body,this.params});

  static var basicAuth = 'Basic ' +
      base64Encode(utf8
          .encode('aplikasioperasionalsiscom:siscom@ptshaninformasi#2022@'));

  
  var baseUrl=Api.basicUrl;   
      Map<String, String> headers = {
    'Authorization': basicAuth,
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'token': AppData.setFcmToken,
    'em_id':AppData.informasiUser==null || AppData.informasiUser=="null" || AppData.informasiUser=="" || AppData.informasiUser!.isEmpty ?"":AppData.informasiUser![0].em_id
  }; 
  

  
Future<http.Response> get() async {
    print("url get ${baseUrl+url+"?database=${AppData.selectedDatabase.toString().trim()}&start_periode=${AppData.startPeriode}&end_periode=${AppData.endPeriode}"+params??""}");
    return await http
        .get(Uri.parse("${baseUrl+url+"?database=${AppData.selectedDatabase.toString().trim()}&start_periode=${AppData.startPeriode}&end_periode=${AppData.endPeriode}"+params??""}"), headers: headers)
        .timeout(Duration(minutes: 2));
  }
  Future<http.Response> post() async {
      print("urll${baseUrl+url+"?database=${AppData.selectedDatabase.toString()}"}");
      print(body);
    return await http
        .post(Uri.parse("${baseUrl+url+"?database=${AppData.selectedDatabase.toString()}"}"), body: jsonEncode(body), headers: headers)
        .timeout(Duration(minutes: 2));
  }

  Future<http.Response> patch() {
    return http.patch(Uri.parse(url), body: body).timeout(Duration(minutes: 2));
  }

  Future<http.Response> delete() {
    return http
        .delete(Uri.parse(url), body: body)
        .timeout(Duration(minutes: 2));
  }

  //tampa database
  
    Future<http.Response> getCheckDatabase() async {
  
    return await http
        .get(Uri.parse(baseUrl+url), headers: headers)
        .timeout(Duration(minutes: 2));


  }
}
