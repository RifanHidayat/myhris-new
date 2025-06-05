import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/services/request.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';

class PengumumanController extends GetxController {
  var pengumumanList = [].obs;
  var pollingList = [].obs;
  var isLoading = true.obs;
  var saveTemprorary = [].obs;
  var isLoadingPolling = true.obs;
  var employees = [].obs;

  var jumlahNotifikasiBelumDibaca = 0.obs;
  var isCheckingPolling = true.obs;
  var idPolling = "0".obs;
  @override
  void onInit() {
    super.onInit();
    getPengumuman();
  }

// fitur search//////////////////////////////////////////////
  var originalList = [];
  void pencarianNamaPeraturan(String value) {
    if (originalList.isEmpty) {
      originalList = List.from(pengumumanList);
    }

    var textCari = value.toLowerCase();

    var filter = originalList.where((peraturan) {
      var namaPeraturan = peraturan['title'].toLowerCase();
      return namaPeraturan.contains(textCari);
    }).toList();

    if (filter.isNotEmpty) {
      pengumumanList.value = filter;
    } else {
      pengumumanList.value = [];
    }
    this.pengumumanList.refresh();
  }
// fitur search////////////////////////////////////////

  RxBool isSearching = false.obs;
  var searchController = TextEditingController();

  void toggleSearch() {
    isSearching.value = !isSearching.value;
  }

  void clearText() {
    searchController.clear();
    pencarianNamaPeraturan('');
  }

  Future<void> getPengumuman() async {
    print("masuk sini");
    try {
      var connect = await Api.connectionApi("get", {}, "notice");
      if (connect == false) {
        // UtilsAlert.koneksiBuruk();
        print("Koneksi gagal");
      } else {
        if (connect.statusCode == 200) {
          var valueBody = jsonDecode(connect.body);
          var data = valueBody['data'];
          // var filter1 = [];
          // var dt = DateTime.now();
        //   for (var element in data) {
        //     DateTime dt2 = DateTime.parse("${element['end_date']}");
        //     if (dt2.isBefore(dt)) {
        //       if (DateFormat('yyyy-MM-dd').format(dt) ==
        //           DateFormat('yyyy-MM-dd').format(dt2)) {
        //         filter1.add(element);
        //       }
        //     } else {
        //       filter1.add(element);
        //     }
        //   }
        // print('data pengumuman ${filter1}');
        //   filter1.sort((a, b) => b['begin_date']
        //       .toUpperCase()
        //       .compareTo(a['begin_date'].toUpperCase()));

          pengumumanList.value = data;
          var belumDibaca = pengumumanList.where((pengumuman) {
          return pengumuman['is_view'] == 0; 
        }).length;
        jumlahNotifikasiBelumDibaca.value = belumDibaca;
        jumlahNotifikasiBelumDibaca.refresh();
          // getJumlahNotifikasi();

        }else{
          print('yah error uy ${connect.statusCode}: ${connect.body}');
        }
      }
    } catch (e) {
      print("Error getPengumuman: $e");
    }
  }

  void getJumlahNotifikasi() async {
    try {
      var connect = Api.connectionApi('get', {}, "notice/count");
      final response = await connect;
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // jumlahNotifikasiBelumDibaca.value = data["data"];
        // jumlahNotifikasiBelumDibaca.refresh();
        print('response notif pengumuman : $data');
        print("Jumlah Notifikasi: ${jumlahNotifikasiBelumDibaca.value}");
      } else {
        print("Error ${response.body}");
      }
    } catch (e) {
    print("Error  Terjadi kesalahan: $e");
    }
  }

  void updateDataNotif(data) {
    Map<String, dynamic> body = {
      "notice_id": data,
      "em_id": AppData.informasiUser![0].em_id,
    };
    var connect = Api.connectionApi("post", body, "notice/count/save");
    connect.then((dynamic res) async {
      if (res.statusCode == 200) {
        getPengumuman();
        print("berhasil ganti status notif");
      }
    });
  }

  Future<bool> getEmployee(id) async {
    try {
      var emId = AppData.informasiUser![0].em_id;
      var data = await Request(
              url: 'notice-polling-employee',
              params: '&em_id=${emId}&polling_id=${id}')
          .get();

      var response = jsonDecode(data.body);

      if (data.statusCode == 200) {
        employees.value = response['data'];
        return true;
      } else {
        employees.value = [];
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> getPolling({id}) async {
    var body = {"id": id};
    isLoadingPolling.value = true;
    var connect = Api.connectionApi("post", body, "notice-polling");
    Future.delayed(const Duration(seconds: 1), () {
      connect.then((dynamic res) {
        if (res == false) {
          isLoadingPolling.value = false;
          // UtilsAlert.koneksiBuruk();
        } else {
          isLoadingPolling.value = false;
          if (res.statusCode == 200) {
            var valueBody = jsonDecode(res.body);
            var data = valueBody['data'];
            isCheckingPolling.value = valueBody['is_polling'];
            idPolling.value = valueBody['id_polling'].toString();
            pollingList.value = data;
            print("data informasi polling new ${valueBody}");

            // var filter1 = [];
            // var dt = DateTime.now();
            // for (var element in data) {
            //   DateTime dt2 = DateTime.parse("${element['end_date']}");
            //   if (dt2.isBefore(dt)) {
            //     if (DateFormat('yyyy-MM-dd').format(dt) ==
            //         DateFormat('yyyy-MM-dd').format(dt2)) {
            //       filter1.add(element);
            //     }
            //   } else {
            //     filter1.add(element);
            //   }
            // }
            // filter1.sort((a, b) => b['begin_date']
            //     .toUpperCase()
            //     .compareTo(a['begin_date'].toUpperCase()));

            // pengumumanList.value = filter1;
          }
        }
      });
    });
  }

  Future<void> savdPolling({idPolling, idPertanyaan}) async {
    UtilsAlert.showLoadingIndicator(Get.context!);
    var body = {"polling_id": idPolling, 'pertanyaan_id': idPertanyaan};
    isLoadingPolling.value = true;
    var connect = Api.connectionApi("post", body, "notice-polling-save");
    Future.delayed(const Duration(seconds: 1), () {
      connect.then((dynamic res) {
        if (res == false) {
          isLoadingPolling.value = false;
          // UtilsAlert.koneksiBuruk();

          getPolling(id: idPertanyaan);
          UtilsAlert.showToast("Gagal simpan pilihan");
        } else {
          isLoadingPolling.value = false;
          if (res.statusCode == 200) {
            Get.back();
            getPolling(id: idPertanyaan);
            UtilsAlert.showToast("Berhasil simpan pilihan");

            // var valueBody = jsonDecode(res.body);
            // var data = valueBody['data'];
            // isCheckingPolling.value = valueBody['is_polling'];
            // idPolling.value = valueBody['id_polling'];
            // pollingList.value = data;
            // print("data informasi polling ${data}");

            // var filter1 = [];
            // var dt = DateTime.now();
            // for (var element in data) {
            //   DateTime dt2 = DateTime.parse("${element['end_date']}");
            //   if (dt2.isBefore(dt)) {
            //     if (DateFormat('yyyy-MM-dd').format(dt) ==
            //         DateFormat('yyyy-MM-dd').format(dt2)) {
            //       filter1.add(element);
            //     }
            //   } else {
            //     filter1.add(element);
            //   }
            // }
            // filter1.sort((a, b) => b['begin_date']
            //     .toUpperCase()
            //     .compareTo(a['begin_date'].toUpperCase()));

            // pengumumanList.value = filter1;
          }
        }
      });
    });
  }

  String formatTanggal(String tanggalString) {
    DateTime tanggal = DateTime.parse(tanggalString);
    return DateFormat('d MMMM yyyy', 'id_ID').format(tanggal);
  }
}
