import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:siscom_operasional/controller/absen_controller.dart';
import 'package:siscom_operasional/model/absen_model.dart';
import 'package:siscom_operasional/model/monitoring_data_model.dart';
import 'package:siscom_operasional/model/monitoring_model.dart';
import 'package:siscom_operasional/screen/absen/detail_absen.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/custom_dialog.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';

class MonitoringController extends GetxController {
  var monitoringList = <MonitoringModel>[].obs;
  var tempNamaStatus1 = "${AppData.informasiUser![0].full_name}".obs;
  var emId = "${AppData.informasiUser![0].em_id}".obs;

  var isLoading = true.obs;

  var bulanDanTahunNow = "".obs;

  var bulanSelectedStartPeriod = ''.obs;
  var tahunSelectedStartPeriod = ''.obs;
  var startPeriode = ''.obs;

  var bulanSelectedEndPeriod = ''.obs;
  var tahunSelectedEndPeriod = ''.obs;
  var endPeriode = ''.obs;

  var prosesLoad = false.obs;

  var historyAbsen = <MonitoringDataModel>[].obs;
  var tempHistoryAbsen = <MonitoringDataModel>[].obs;
  var historyAbsenShow = [].obs;

  var emIdKaryawan = "".obs;
  var bulanSelected = "".obs;
  var namaEmpoloyee = "".obs;
  var loading = "".obs;

  var tempStartPeriode = "".obs;
  var tempEndPeriode = "".obs;

  var listDetailLaporanEmployee = [].obs;
  var alllistDetailLaporanEmployee = [].obs;
  var valuePolaPersetujuan = "".obs;

  var sisaCuti = "".obs;

  void getMonitor() async {
    var connect = Api.connectionApi("get", {}, "employee-monitoring");
    connect.then(
      (dynamic response) {
        if (response.statusCode == 200) {
          List data = jsonDecode(response.body)['data'];
          var resultGet =
              data.map((item) => MonitoringModel.fromMap(item)).toList();
          monitoringList.value = resultGet;
          isLoading.value = false;
        } else {
          // Get.snackbar("error", "gagal");
        }
      },
    );
  }

  Future<void> getTimeNow() async {
    tempStartPeriode.value = AppData.startPeriode;
    tempEndPeriode.value = AppData.endPeriode;

    var ds = DateTime.parse(AppData.startPeriode);

    bulanSelectedStartPeriod.value = "${ds.month}";
    tahunSelectedStartPeriod.value = "${ds.year}";
    startPeriode.value = AppData.startPeriode;

    var dt = DateTime.parse(AppData.endPeriode);

    bulanSelectedEndPeriod.value = "${dt.month}";
    tahunSelectedEndPeriod.value = "${dt.year}";
    print('ini akhir periode get time ${bulanSelectedEndPeriod.value}');
    bulanDanTahunNow.value = "${dt.month}-${dt.year}";
    endPeriode.value = AppData.endPeriode;
  }

  String parseFlexibleDate(String date) {
    // Ubah tanggal yang seperti '2024-06-1' menjadi '2024-06-01'
    List<String> parts = date.split('-');
    String year = parts[0];
    String month = parts[1].padLeft(2, '0'); // Tambahkan 0 jika bulan < 10
    String day = parts[2].padLeft(2, '0'); // Tambahkan 0 jika hari < 10

    // Format ulang string date agar bisa diparsing oleh DateTime
    String formattedDate = '$year-$month-$day';
    return formattedDate;
  }

  List<String> generateBulanPeriode(String startPeriode, String endPeriode) {
    var tempStartPeriod = DateTime.parse(parseFlexibleDate(startPeriode));
    var tempEndPeriod = DateTime.parse(parseFlexibleDate(endPeriode));

    if (tempStartPeriod.year == tempEndPeriod.year &&
        tempStartPeriod.month == tempEndPeriod.month) {
      return [DateFormat('yyyy-MM').format(tempStartPeriod)];
    }

    List<String> monthsList = [];
    DateTime current = DateTime(tempStartPeriod.year, tempStartPeriod.month);

    while (current.isBefore(tempEndPeriod) ||
        (current.year == tempEndPeriod.year &&
            current.month == tempEndPeriod.month)) {
      monthsList.add(DateFormat('yyyy-MM').format(current));

      current = DateTime(current.year, current.month + 1, 1);
    }

    return monthsList;
  }

  Future<void> loadMonitoringAbsenTerlambat() async {
    historyAbsen.value.clear();
    historyAbsenShow.value.clear();

    AppData.startPeriode = startPeriode.value;
    AppData.endPeriode = endPeriode.value;

    print("${AppData.startPeriode} sampai ${AppData.endPeriode}");

    List<String> listDates = generateBulanPeriode(
      AppData.startPeriode,
      AppData.endPeriode,
    );

    print(listDates);
    var dates = listDates.join(',');
    print('ini dates $dates');
    print('em id : ${emId.value}');

    var response = await ApiRequest(
      url: "attendance-terlambat",
      body: {},
      temParams: {
        "dates": dates,
        "em_id": emId.value,
      },
    ).get();

    print('ini response ${response.body}');

    if (response.statusCode == 200) {
      var valueBody = jsonDecode(response.body);

      if (valueBody['status'] == true) {
        List data = valueBody['data'];
        print('ini data absen terlambat $valueBody');
        loading.value =
            data.length == 0 ? "Data tidak ditemukan" : "Memuat data...";
        for (var el in data) {
          historyAbsen.value.add(MonitoringDataModel(
            emId: el['em_id'] ?? "",
            branchId: el['branch_id'] ?? "",
            attenDate: el['atten_date'] ?? "",
            signinTime: el['signin_time'] ?? "",
            signoutTime: el['signout_time'] ?? "",
            workingHour: el['working_hour'] ?? "",
            placeIn: el['place_in'] ?? "",
            placeOut: el['place_out'] ?? "",
            absence: el['absence'] ?? "",
            overtime: el['overtime'] ?? "",
            earnleave: el['earnleave'] ?? "",
            status: el['status'] ?? "",
            signinLonglat: el['signin_longlat'] ?? "",
            signoutLonglat: el['signout_longlat'] ?? "",
            signinPict: el['signin_pict'] ?? "",
            signoutPict: el['signout_pict'] ?? "",
            signinNote: el['signin_note'] ?? "",
            signoutNote: el['signout_note'] ?? "",
            signinAddr: el['signin_addr'] ?? "",
            signoutAddr: el['signout_addr'] ?? "",
            breakoutTime: el['breakout_time'] ?? "",
            breakinTime: el['breakin_time'] ?? "",
            breakoutLonglat: el['breakout_longlat'] ?? "",
            breakinLonglat: el['breakin_longlat'] ?? "",
            breakoutPict: el['breakout_pict'] ?? "",
            breakinPict: el['breakin_pict'] ?? "",
            breakinNote: el['breakin_note'] ?? "",
            breakoutNote: el['breakout_note'] ?? "",
            placeBreakIn: el['place_break_in'] ?? "",
            breakinAddr: el['breakin_addr'] ?? "",
            placeBreakOut: el['place_break_out'] ?? "",
            breakoutAddr: el['breakout_addr'] ?? "",
            atttype: el['atttype'] ?? 0,
            regType: el['reg_type'] ?? 0,
            jamKerja: el['jam_kerja'],
            jamPulang: el['jam_pulang']
          ));
          tempHistoryAbsen.value = historyAbsen.value;
        }
      }
    }
    this.historyAbsen.refresh();
    this.historyAbsenShow.refresh();
    AppData.startPeriode = tempStartPeriode.value;
    AppData.endPeriode = tempEndPeriode.value;
  }

  bool validateStartPeriod(String startMonth, String startYear, String endMonth, String endYear) {
    var temp = DateTime.parse("${AppData.informasiUser![0].periodeAwal}-01");
    int selectedStartMonthInt = int.parse(startMonth);
    int selectedStartYearInt = int.parse(startYear);
    int selectedEndMounthInt = int.parse(endMonth);
    int selectedEndYearInt = int.parse(endYear);

    // Ambil bulan dan tahun dari temp
    int tempStartMonth = temp.month;
    int tempStartYear = temp.year;

    // Cek apakah tahun dari start periode sama dengan tempStartPeriode
    if (selectedStartYearInt < tempStartYear) {
      UtilsAlert.showToast(
          "Tahun periode awal tidak boleh lebih dari periode default $tempStartYear");
      return false;
    }

    if (selectedStartYearInt > selectedEndYearInt) {
      UtilsAlert.showToast(
        'Tahun periode awal tidak boleh lebig besar dari periode akhir tahun'
      );
      return false;
    }

    if (selectedStartYearInt == selectedEndYearInt && selectedStartMonthInt > selectedEndMounthInt){
      UtilsAlert.showToast(
        'Bulan awal periode tidak boleh lebih besar dari bulan akhir periode'
      );
      return false;
    }

    // if (selectedStartYearInt > DateTime.now().year) {
    //   UtilsAlert.showToast(
    //     'Tahun awal tidak boleh lebih besar dari tahun sekarang'
    //   );
    //   return false;
    // }

    // if (selectedStartYearInt == DateTime.now().year && selectedStartMonthInt > DateTime.now().month) {
    //   UtilsAlert.showToast(
    //     'Bulan awal tidak boleh lebih besar dari bulan sekarang'
    //   );
    //   return false;
    // }

    // Jika tahun sama, cek apakah bulan yang dipilih lebih besar dari bulan tempStartPeriode
    if (selectedStartYearInt == tempStartYear && selectedStartMonthInt < tempStartMonth) {
      print('ini tahun awal $selectedStartYearInt');
      print('ini tahun akhir $selectedEndYearInt');
      UtilsAlert.showToast(
          "Bulan periode awal tidak boleh lebih dari bulan default ${Constanst.bulanIndo(tempStartMonth.toString())}");
      return false;
    }
    print('ini tahun awal $selectedStartYearInt');
    print('ini tahun akhir $selectedEndYearInt');

    return true;
  }

  bool validateEndPeriod(
      String startMonth, String startYear, String endMonth, String endYear) {
    int startMonthInt = int.parse(startMonth);
    int endMonthInt = int.parse(endMonth);
    int startYearInt = int.parse(startYear);
    int endYearInt = int.parse(endYear);
    var temp = DateTime.parse("${AppData.informasiUser![0].periodeAwal}-01");
    int tempStartMonth = temp.month;
    int tempStartYear = temp.year;

    print('temp waktu $temp');

    if (endYearInt < tempStartYear) {
      UtilsAlert.showToast(
          "Tahun periode akhir tidak boleh kurang dari periode default $tempStartYear");
      return false;
    }

    if (endYearInt < startYearInt) {
      UtilsAlert.showToast(
        'Tahun periode akhir tidak boleh kurang dari periode awal'
      );
      return false;
    }

    if (endYearInt == startYearInt && endMonthInt < startMonthInt) {
      UtilsAlert.showToast(
        'Bulan akhir periode tidak boleh lebih besar dari bulan awal periode'
      );
      return false;
    }

    // if (endYearInt > DateTime.now().year) {
    //   UtilsAlert.showToast(
    //     'Tahun akhir tidak boleh lebih besar dari tahun sekarang'
    //   );
    //   return false;
    // }

    // if (endYearInt == DateTime.now().year && endMonthInt > DateTime.now().month) {
    //   UtilsAlert.showToast(
    //     'Bulan akhir tidak boleh lebih besar dari bulan sekarang'
    //   );
    //   return false;
    // }
    // Cek apakah tahun dari start periode sama dengan tempStartPeriode

    // Jika tahun sama, cek apakah bulan yang dipilih lebih besar dari bulan tempStartPeriode
    if (endYearInt == tempStartYear && endMonthInt < tempStartMonth) {
      print('ini tahun awal $startYearInt');
      print('ini tahun akhir $endYearInt');
      UtilsAlert.showToast(
          "Bulan periode awal tidak boleh lebih dari bulan default ${Constanst.bulanIndo(tempStartMonth.toString())}");
      return false;
    }
    return true;
  }

  Future<void> loadMonitoringPulangCepat() async {
    historyAbsen.value.clear();
    historyAbsenShow.value.clear();

    AppData.startPeriode = startPeriode.value;
    AppData.endPeriode = endPeriode.value;

    print("${AppData.startPeriode} sampai ${AppData.endPeriode}");

    List<String> listDates = generateBulanPeriode(
      AppData.startPeriode,
      AppData.endPeriode,
    );

    print(listDates);
    var dates = listDates.join(',');
    print(dates);
    print('ini dates $dates');
    print('em id : ${emId.value}');

    var response = await ApiRequest(
      url: "attendance-pulang-cepat",
      body: {},
      temParams: {
        "dates": dates,
        "em_id": emId.value,
      },
    ).get();

    if (response.statusCode == 200) {
      print('ini response pulang cepat : ${response.body}');
      var valueBody = jsonDecode(response.body);

      if (valueBody['status'] == true) {
        List data = valueBody['data'];
        print('ini data pulang cepat : $data');
        loading.value =
            data.length == 0 ? "Data tidak ditemukan" : "Memuat data...";
        for (var el in data) {
          historyAbsen.value.add(MonitoringDataModel(
            emId: el['em_id'] ?? "",
            branchId: el['branch_id'] ?? "",
            attenDate: el['atten_date'] ?? "",
            signinTime: el['signin_time'] ?? "",
            signoutTime: el['signout_time'] ?? "",
            workingHour: el['working_hour'] ?? "",
            placeIn: el['place_in'] ?? "",
            placeOut: el['place_out'] ?? "",
            absence: el['absence'] ?? "",
            overtime: el['overtime'] ?? "",
            earnleave: el['earnleave'] ?? "",
            status: el['status'] ?? "",
            signinLonglat: el['signin_longlat'] ?? "",
            signoutLonglat: el['signout_longlat'] ?? "",
            signinPict: el['signin_pict'] ?? "",
            signoutPict: el['signout_pict'] ?? "",
            signinNote: el['signin_note'] ?? "",
            signoutNote: el['signout_note'] ?? "",
            signinAddr: el['signin_addr'] ?? "",
            signoutAddr: el['signout_addr'] ?? "",
            breakoutTime: el['breakout_time'] ?? "",
            breakinTime: el['breakin_time'] ?? "",
            breakoutLonglat: el['breakout_longlat'] ?? "",
            breakinLonglat: el['breakin_longlat'] ?? "",
            breakoutPict: el['breakout_pict'] ?? "",
            breakinPict: el['breakin_pict'] ?? "",
            breakinNote: el['breakin_note'] ?? "",
            breakoutNote: el['breakout_note'] ?? "",
            placeBreakIn: el['place_break_in'] ?? "",
            breakinAddr: el['breakin_addr'] ?? "",
            placeBreakOut: el['place_break_out'] ?? "",
            breakoutAddr: el['breakout_addr'] ?? "",
            atttype: el['atttype'] ?? 0,
            regType: el['reg_type'] ?? 0,
            jamKerja: el['jam_kerja'],
            jamPulang: el['jam_pulang']
          ));
          tempHistoryAbsen.value = historyAbsen.value;
        }
      }
    }
    this.historyAbsen.refresh();
    this.historyAbsenShow.refresh();
    AppData.startPeriode = tempStartPeriode.value;
    AppData.endPeriode = tempEndPeriode.value;
  }

  Future<void> loadMonitoringCuti() async {
    listDetailLaporanEmployee.value.clear();
    alllistDetailLaporanEmployee.value.clear();

    AppData.startPeriode = startPeriode.value;
    AppData.endPeriode = endPeriode.value;

    print("${AppData.startPeriode} sampai ${AppData.endPeriode}");

    List<String> listDates = generateBulanPeriode(
      AppData.startPeriode,
      AppData.endPeriode,
    );

    print(listDates);
    var dates = listDates.join(',');
    print(dates);

    var response = await ApiRequest(
      url: "history-cuti",
      body: {},
      temParams: {
        "dates": dates,
        "em_id": emId.value,
      },
    ).get();

    if (response.statusCode == 200) {
      var valueBody = jsonDecode(response.body);
      print("cuy: $valueBody");
      if (valueBody['status'] == true) {
        List data = valueBody['data'];
        listDetailLaporanEmployee.value = data;
        alllistDetailLaporanEmployee.value = data;
        sisaCuti.value = valueBody['sisa_cuti'].toString();
        print("tttesssss ${sisaCuti.value}");
        print("cuylah: ${listDetailLaporanEmployee.value}");
        this.listDetailLaporanEmployee.refresh();
        this.alllistDetailLaporanEmployee.refresh();
        loading.value = data.length == 0 ? "Data tidak ditemukan" : "Memuat data...";
      }
    }
    this.listDetailLaporanEmployee.refresh();
    this.alllistDetailLaporanEmployee.refresh();
    AppData.startPeriode = tempStartPeriode.value;
    AppData.endPeriode = tempEndPeriode.value;
  }

  Future<void> loadMonitoringIzin() async {
    listDetailLaporanEmployee.value.clear();
    alllistDetailLaporanEmployee.value.clear();

    AppData.startPeriode = startPeriode.value;
    AppData.endPeriode = endPeriode.value;

    print("${AppData.startPeriode} sampai ${AppData.endPeriode}");

    List<String> listDates = generateBulanPeriode(
      AppData.startPeriode,
      AppData.endPeriode,
    );

    print(listDates);
    var dates = listDates.join(',');
    print('dates $dates');

    var response = await ApiRequest(
      url: "history-izin",
      body: {},
      temParams: {
        "dates": dates,
        "em_id": emId.value,
      },
    ).get();

    if (response.statusCode == 200) {
      var valueBody = jsonDecode(response.body);
      print("cuy: $valueBody");
      if (valueBody['status'] == true) {
        List data = valueBody['data'];
        listDetailLaporanEmployee.value = data;
        alllistDetailLaporanEmployee.value = data;
        print("cuylah: ${listDetailLaporanEmployee.value}");
        this.listDetailLaporanEmployee.refresh();
        this.alllistDetailLaporanEmployee.refresh();
        loading.value =
            data.length == 0 ? "Data tidak ditemukan" : "Memuat data...";
      }
    } else{
      print('error ${response.body}');
    }
    this.listDetailLaporanEmployee.refresh();
    this.alllistDetailLaporanEmployee.refresh();
    AppData.startPeriode = tempStartPeriode.value;
    AppData.endPeriode = tempEndPeriode.value;
  }
}
