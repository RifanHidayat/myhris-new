import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/absen_controller.dart';
import 'package:siscom_operasional/model/absen_model.dart';
import 'package:siscom_operasional/screen/absen/detail_absen.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';

class LaporanAbsenKaryawanController extends GetxController {
  var historyAbsen = <AbsenModel>[].obs;
  var tempHistoryAbsen = <AbsenModel>[].obs;
  var historyAbsenShow = [].obs;

  var emIdKaryawan = "".obs;
  var bulanSelected = "".obs;
  var namaEmpoloyee = "".obs;
  var loading = "".obs;

  var prosesLoad = false.obs;

  var tempNamaStatus1 = "Semua Riwayat".obs;

  void loadData(emId, bulan, fullName) {
    emIdKaryawan.value = emId;
    bulanSelected.value = bulan;
    namaEmpoloyee.value = fullName;
    this.emIdKaryawan.refresh();
    this.bulanSelected.refresh();
    this.namaEmpoloyee.refresh();
    loadHistoryAbsenEmployee();
  }

  var controller = Get.find<AbsenController>();

  void loadHistoryAbsenEmployee() {
    var listPeriode = bulanSelected.value.split("-");
    var bulan = listPeriode[0];
    var tahun = listPeriode[1];
    historyAbsen.clear();
    historyAbsenShow.clear();

    AppData.startPeriode = controller.startPeriode.value;
    AppData.endPeriode = controller.endPeriode.value;

    Map<String, dynamic> body = {
      'em_id': emIdKaryawan.value,
      'bulan': bulan,
      'tahun': tahun,
    };
    var connect = Api.connectionApi("post", body, "attendance");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        if (valueBody['status'] == true) {
          List data = valueBody['data'];
          loading.value =
              data.length == 0 ? "Data tidak ditemukan" : "Memuat data...";
          for (var el in data) {
            historyAbsen.value.add(AbsenModel(
                date: el['date'],
                id: el['id'] ?? 0,
                em_id: el['em_id'] ?? "",
                atten_date: el['atten_date'] ?? "",
                signin_time: el['signin_time'] ?? "",
                signout_time: el['signout_time'] ?? "",
                working_hour: el['working_hour'] ?? "",
                place_in: el['place_in'] ?? "",
                place_out: el['place_out'] ?? "",
                absence: el['absence'] ?? "",
                overtime: el['overtime'] ?? "",
                earnleave: el['earnleave'] ?? "",
                status: el['status'] ?? "",
                signin_longlat: el['signin_longlat'] ?? "",
                signout_longlat: el['signout_longlat'] ?? "",
                att_type: el['att_type'] ?? "",
                signin_pict: el['signin_pict'] ?? "",
                signout_pict: el['signout_pict'] ?? "",
                signin_note: el['signin_note'] ?? "",
                signout_note: el['signout_note'] ?? "",
                signin_addr: el['signin_addr'] ?? "",
                signout_addr: el['signout_addr'] ?? "",
                reqType: el['reg_type'] ?? 0,
                atttype: el['atttype'] ?? 0,
                namaLembur: el['lembur'],
                namaTugasLuar: el['tugas_luar'],
                namaCuti: el['cuti'],
                namaSakit: el['sakit'],
                namaIzin: el['izin'],
                namaDinasLuar: el['dinas_luar'],
                offDay: el['off_date'],
                namaHariLibur: el['hari_libur'],
                jamKerja: el['jam_kerja'],
                statusView: el['status_view'] ?? false));
            tempHistoryAbsen.value = historyAbsen.value;
            // historyAbsen.value.add(AbsenModel(
            //     id: el['id'] ?? "",
            //     em_id: el['em_id'] ?? "",
            //     atten_date: el['atten_date'] ?? "",
            //     signin_time: el['signin_time'] ?? "",
            //     signout_time: el['signout_time'] ?? "",
            //     working_hour: el['working_hour'] ?? "",
            //     place_in: el['place_in'] ?? "",
            //     place_out: el['place_out'] ?? "",
            //     absence: el['absence'] ?? "",
            //     overtime: el['overtime'] ?? "",
            //     earnleave: el['earnleave'] ?? "",
            //     status: el['status'] ?? "",
            //     signin_longlat: el['signin_longlat'] ?? "",
            //     signout_longlat: el['signout_longlat'] ?? "",
            //     att_type: el['att_type'] ?? "",
            //     signin_pict: el['signin_pict'] ?? "",
            //     signout_pict: el['signout_pict'] ?? "",
            //     signin_note: el['signin_note'] ?? "",
            //     signout_note: el['signout_note'] ?? "",
            //     signin_addr: el['signin_addr'] ?? "",
            //     signout_addr: el['signout_addr'] ?? "",
            //     reqType: el['reg_type'] ?? 0,
            //     atttype: el['atttype'] ?? 0));
          }

          //historyAbsenShow.value = historyAbsen;
          // Set<String> seenDates = {};
          // historyAbsen.value = historyAbsen.where((event) {
          //   if (seenDates.contains(event.date)) {
          //     return false;
          //   } else {
          //     seenDates.add(event.date);
          //     return true;
          //   }
          // }).toList();

          Map<String, AbsenModel> highestIdPerDate = {};

          for (var event in historyAbsen) {
            if (!highestIdPerDate.containsKey(event.date) ||
                event.id! > highestIdPerDate[event.date]!.id!) {
              highestIdPerDate[event.date] = event;
            }
          }

          historyAbsen.value = highestIdPerDate.values.toList();

          historyAbsen.value.forEach((element) {
            print("masuk sini");

            var data = tempHistoryAbsen
                .where((p0) => p0.date == element.date)
                .where((p0) => p0.id != element.id)
                .toList()
              ..sort((a, b) => b.id!.compareTo(a.id as num));
            if (data.length > 0) {
              element.turunan = data;
            } else {
              element.turunan = [];
            }

            // print('data list ${element} tes');
          });
        }
        this.historyAbsen.refresh();
        this.tempHistoryAbsen.refresh();
      }
    });
    AppData.startPeriode = controller.tempStartPeriode.value;
    AppData.endPeriode = controller.tempEndPeriode.value;
  }

  void showTurunan(tanggal) {
    for (var element in historyAbsenShow.value) {
      if (element['atten_date'] == tanggal) {
        if (element['status_view'] == false) {
          element['status_view'] = true;
        } else {
          element['status_view'] = false;
        }
      }
    }
    this.historyAbsenShow.refresh();
  }

  void historySelected(id_absen, status) {
    var getSelected =
        tempHistoryAbsen.value.firstWhere((element) => element.id == id_absen);
    // print(getSelected);
    Get.to(DetailAbsen(
      absenSelected: [getSelected],
      status: false,
    ));
  }

  // void filterData(id) {
  //   if (id == '0') {
  //     detailRiwayat.value = AlldetailRiwayat.value;
  //     this.detailRiwayat.refresh();
  //   } else if (id == '1') {
  //     prosesLoad.value = true;
  //     var tampung = [];
  //     for (var element in AlldetailRiwayat.value) {
  //       print(element);
  //       var listJamMasuk = (element['signin_time']!.split(':'));
  //       var perhitunganJamMasuk1 =
  //           830 - int.parse("${listJamMasuk[0]}${listJamMasuk[1]}");
  //       print(perhitunganJamMasuk1);
  //       if (perhitunganJamMasuk1 <= 0) {
  //         tampung.add(element);
  //       }
  //     }
  // loading.value =
  //     tampung.length == 0 ? "Data tidak tersedia" : "Memuat data...";
  //     var seen = Set<String>();
  //     List t =
  //         tampung.where((country) => seen.add(country['atten_date'])).toList();

  //     detailRiwayat.value = t;
  //     prosesLoad.value = false;
  //     this.detailRiwayat.refresh();
  //   } else if (id == '2') {
  //     prosesLoad.value = true;
  //     var tampung = [];
  //     for (var element in AlldetailRiwayat.value) {
  //       if (element['signout_time'] != '00:00:00') {
  //         var listJamKeluar = (element['signout_time']!.split(':'));
  //         var perhitunganJamKeluar =
  //             1830 - int.parse("${listJamKeluar[0]}${listJamKeluar[1]}");
  //         print(perhitunganJamKeluar);
  //         if (perhitunganJamKeluar <= 0) {
  //           tampung.add(element);
  //         }
  //       }
  //     }
  //     loading.value =
  //         tampung.length == 0 ? "Data tidak tersedia" : "Memuat data...";
  //     detailRiwayat.value = tampung;
  //     prosesLoad.value = false;
  //     this.detailRiwayat.refresh();
  //   } else if (id == '3') {
  //     prosesLoad.value = true;
  //     var tampung = [];
  //     for (var element in AlldetailRiwayat.value) {
  //       if (element['signout_time'] == '00:00:00') {
  //         tampung.add(element);
  //       }
  //     }
  //     loading.value =
  //         tampung.length == 0 ? "Data tidak tersedia" : "Memuat data...";
  //     detailRiwayat.value = tampung;
  //     prosesLoad.value = false;
  //     this.detailRiwayat.refresh();
  //   }
  // }

  void filterData(String value) {
    historyAbsen.clear();

    switch (value) {
      case '0': // Semua Riwayat
        prosesLoad.value = true;
        historyAbsen.value = tempHistoryAbsen.toList();
        Set<String> seenDates = {};
        historyAbsen.value = historyAbsen.where((event) {
          if (seenDates.contains(event.date)) {
            return false;
          } else {
            seenDates.add(event.date);
            return true;
          }
        }).toList();

        historyAbsen.value.forEach((element) {
          var data = tempHistoryAbsen
              .where((p0) => p0.date == element.date)
              .where((p0) => p0.id != element.id)
              .toList();
          if (data.length > 0) {
            element.turunan = data;
          } else {
            element.turunan = [];
          }
        });
        prosesLoad.value = false;
        break;
      case '1': // Terlambat absen masuk (signin_time > 08:30)
        prosesLoad.value = true;
        historyAbsen.value = tempHistoryAbsen
            .where((element) => _isLateSignin(element.signin_time.toString(),
                tambahSatuMenit(element.jamKerja.toString())))
            .toList();
        Set<String> seenDates = {};
        historyAbsen.value = historyAbsen.where((event) {
          if (seenDates.contains(event.date)) {
            return false;
          } else {
            seenDates.add(event.date);
            return true;
          }
        }).toList();

        historyAbsen.value.forEach((element) {
          var data = tempHistoryAbsen
              .where((p0) => p0.date == element.date)
              .where((p0) => p0.id != element.id)
              .toList();
          if (data.length > 0) {
            element.turunan = data;
          } else {
            element.turunan = [];
          }
        });
        loading.value =
            historyAbsen.isEmpty ? "Data tidak tersedia" : "Memuat data...";
        prosesLoad.value = false;
        break;
      case '2': // Pulang lebih lama (signout_time > 18:00)
        prosesLoad.value = true;
        historyAbsen.value = tempHistoryAbsen
            .where((element) => _isLateSignout(element.signout_time.toString()))
            .toList();
        Set<String> seenDates = {};
        historyAbsen.value = historyAbsen.where((event) {
          if (seenDates.contains(event.date)) {
            return false;
          } else {
            seenDates.add(event.date);
            return true;
          }
        }).toList();

        historyAbsen.value.forEach((element) {
          var data = tempHistoryAbsen
              .where((p0) => p0.date == element.date)
              .where((p0) => p0.id != element.id)
              .toList();
          if (data.length > 0) {
            element.turunan = data;
          } else {
            element.turunan = [];
          }
        });
        loading.value =
            historyAbsen.isEmpty ? "Data tidak tersedia" : "Memuat data...";
        prosesLoad.value = false;
        break;
      case '3': // Tidak absen keluar (signout_time == "00:00:00")
        prosesLoad.value = true;
        historyAbsen.value = tempHistoryAbsen
            .where((element) => element.signout_time == "00:00:00")
            .toList();
        Set<String> seenDates = {};
        historyAbsen.value = historyAbsen.where((event) {
          if (seenDates.contains(event.date)) {
            return false;
          } else {
            seenDates.add(event.date);
            return true;
          }
        }).toList();

        historyAbsen.value.forEach((element) {
          var data = tempHistoryAbsen
              .where((p0) => p0.date == element.date)
              .where((p0) => p0.id != element.id)
              .toList();
          if (data.length > 0) {
            element.turunan = data;
          } else {
            element.turunan = [];
          }
        });
        loading.value =
            historyAbsen.isEmpty ? "Data tidak tersedia" : "Memuat data...";
        prosesLoad.value = false;
        break;
    }

    historyAbsen.refresh();
    historyAbsenShow.refresh();
  }

  String tambahSatuMenit(String waktu) {
    // Inisialisasi formatter untuk format jam
    DateFormat format = DateFormat("HH:mm:ss");

    // Parsing string ke DateTime
    DateTime time = format.parse(waktu);

    // Tambahkan 1 menit
    DateTime updatedTime = time.add(Duration(minutes: 1));

    // Ubah kembali ke format string
    String updatedTimeStr = format.format(updatedTime);

    return updatedTimeStr;
  }

  bool _isLateSignin(String signinTime, String jamKerja) {
    return signinTime.compareTo(jamKerja) > 0;
  }

  bool _isLateSignout(String signoutTime) {
    return signoutTime.compareTo("18:00:00") > 0;
  }
}
