import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:siscom_operasional/model/peraturan_perusahaan_model.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:open_file_plus/open_file_plus.dart';

class PeraturanPerusahaanController extends GetxController {
  var peraturanList = <Peraturan>[].obs;
  var isLoading = true.obs;
  var saveTemprorary = [].obs;

  List<Peraturan> originalList = [];
  void pencarianNamaPeraturan(String value) {
    if (originalList.isEmpty) {
      originalList = List.from(peraturanList);
    }

    var textCari = value.toLowerCase();

    var filter = originalList.where((peraturan) {
      var namaPeraturan = peraturan.title.toLowerCase();
      return namaPeraturan.contains(textCari);
    }).toList();

    if (filter.isNotEmpty) {
      peraturanList.value = filter;
    } else {
      peraturanList.value = [];
    }
    this.peraturanList.refresh();
  }

   RxBool isSearching = false.obs;
  var searchController = TextEditingController();

  void toggleSearch() {
    isSearching.value = !isSearching.value;
  }

  void clearText() {
    searchController.clear();
    pencarianNamaPeraturan('');
  }

  void fetchPeraturan() async {
    var connect = Api.connectionApi("get", {}, "peraturan-perusahaan");
    connect.then(
      (dynamic response) {
        if (response.statusCode == 200) {
          List data = jsonDecode(response.body)['data'];
          var resultGet = data.map((item) => Peraturan.fromMap(item)).toList();
          print(data);
          peraturanList.value = resultGet;
          isLoading.value = false;
        } else {
          isLoading.value = false;
          debugPrint('Error ${response.statusCode} Failed to load data! ${response.body}');
        }
      },
    );
  } 

  String formatTanggal(String tanggalString) {
    DateTime tanggal = DateTime.parse(tanggalString);
    return DateFormat('d MMMM yyyy', 'id_ID').format(tanggal);
  }

  Future<void> downloadFile(String fileName) async {
    try {
      Directory? dir = await getApplicationDocumentsDirectory();
      String filePath = '${dir.path}/$fileName';

      String fullUrl = Api.fileDoc + fileName;

      var response = await http.get(Uri.parse(Uri.encodeFull(fullUrl)));

      if (response.statusCode == 200) {
        File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        await OpenFile.open(filePath);
        print('File downloaded and opened successfully: $filePath');
      } else {
        print('Failed to download file: ${response.statusCode}');
        print("tes : ${fullUrl}");
      }
    } catch (e) {
      print('Error while downloading file: $e');
    }
  }
}