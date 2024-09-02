import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:siscom_operasional/controller/approval_controller.dart';
import 'package:siscom_operasional/controller/dashboard_controller.dart';
import 'package:siscom_operasional/controller/global_controller.dart';
import 'package:siscom_operasional/screen/pesan/approval.dart';
import 'package:siscom_operasional/screen/pesan/detail_persetujuan_absensi.dart';
import 'package:siscom_operasional/screen/pesan/detail_persetujuan_cuti.dart';
import 'package:siscom_operasional/screen/pesan/detail_persetujuan_dinas_luar.dart';
import 'package:siscom_operasional/screen/pesan/detail_persetujuan_izin.dart';
import 'package:siscom_operasional/screen/pesan/detail_persetujuan_kasbon.dart';
import 'package:siscom_operasional/screen/pesan/detail_persetujuan_klaim.dart';
import 'package:siscom_operasional/screen/pesan/detail_persetujuan_lembur.dart';
import 'package:siscom_operasional/screen/pesan/detail_persetujuan_payroll.dart';
import 'package:siscom_operasional/screen/pesan/detail_persetujuan_tugas_luar.dart';
import 'package:siscom_operasional/screen/pesan/detail_persetujuan_wfh.dart';
import 'package:siscom_operasional/screen/pesan/persetujuan_absensi.dart';
import 'package:siscom_operasional/screen/pesan/persetujuan_cuti.dart';
import 'package:siscom_operasional/screen/pesan/persetujuan_dinas_luar.dart';
import 'package:siscom_operasional/screen/pesan/persetujuan_izin.dart';
import 'package:siscom_operasional/screen/pesan/persetujuan_kasbon.dart';
import 'package:siscom_operasional/screen/pesan/persetujuan_klaim.dart';
import 'package:siscom_operasional/screen/pesan/persetujuan_lembur.dart';
import 'package:siscom_operasional/screen/pesan/persetujuan_payroll.dart';
import 'package:siscom_operasional/screen/pesan/persetujuan_tugas_luar.dart';
import 'package:siscom_operasional/screen/pesan/persetujuan_wfh.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class PesanController extends GetxController {
  PageController menuController = PageController(initialPage: 0);
  RefreshController refreshController = RefreshController(initialRefresh: true);
  var controllerApproval = Get.put(ApprovalController());

  var cari = TextEditingController().obs;

  var selectedView = 0.obs;

  var listNotifikasi = [].obs;
  var dataScreenPersetujuan = [].obs;
  var riwayatPersetujuan = [].obs;
  var allRiwayatPersetujuan = [].obs;

  var jumlahApproveCuti = 0.obs;

  var jumlahApproveLembur = 0.obs;
  var jumlahApproveTidakHadir = 0.obs;
  var jumlahApproveTugasLuar = 0.obs;
  var jumlahApproveDinasLuar = 0.obs;
  var jumlahApproveKlaim = 0.obs;
  var jumlahApprovePayroll = 0.obs;
  var jumlahApproveWfh = 0.obs;
  var jumlahApproveKasbon = 0.obs;
  var jumlahNotifikasiBelumDibaca = 0.obs;
  var jumlahCheckin = 0.obs;

  var jumlahPersetujuan = 0.obs;

  var jumlahRiwayat = 0.obs;

  var stringLoading = "Memuat Data...".obs;
  var stringFilterSelected = "".obs;
  var bulanSelectedSearchHistory = "".obs;
  var tahunSelectedSearchHistory = "".obs;
  var bulanDanTahunNow = "".obs;
  var valuePolaPersetujuan = "".obs;

  var statusScreenInfoApproval = false.obs;
  var statusFilteriwayat = false.obs;
  var statusCari = false.obs;

  var listDummy = [
    "Cuti",
    "Lembur",
    "Tidak Hadir",
    "Tugas Luar",
    "Dinas Luar",
    "Klaim",
    "Payroll",
    "Absensi",
    "WFH",
    "Kasbon"
  ];

  @override
  void onReady() async {
    getTimeNow();
    loadNotifikasi();
    super.onReady();
  }

  void routesIcon() {
    selectedView.value = 0;
  }

  Future<void> getTimeNow() async {
    var dt = DateTime.now();
    bulanSelectedSearchHistory.value = "${dt.month}";
    tahunSelectedSearchHistory.value = "${dt.year}";
    bulanDanTahunNow.value = "${dt.month}-${dt.year}";

    this.bulanSelectedSearchHistory.refresh();
    this.tahunSelectedSearchHistory.refresh();
    this.bulanDanTahunNow.refresh();
    getLoadsysData();
  }

  void getLoadsysData() {
    var connect = Api.connectionApi("get", "", "sysdata");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        for (var element in valueBody['data']) {
          if (element['kode'] == "013") {
            valuePolaPersetujuan.value = "${element['name']}";
            this.valuePolaPersetujuan.refresh();
            loadApproveInfo();
            loadApproveHistory();
          }
        }
      }
    });
  }

  void loadApproveInfo() {
    print("load approval info");
    var urlLoad = valuePolaPersetujuan.value == "1"
        ? "load_approve_info"
        : "load_approve_info_multi";
    statusScreenInfoApproval.value = true;
    var dataUser = AppData.informasiUser;
    var getEmid = dataUser![0].em_id;
    Map<String, dynamic> body = {
      'em_id': getEmid,
      'bulan': bulanSelectedSearchHistory.value,
      'tahun': tahunSelectedSearchHistory.value,
      'date': DateFormat('yyyy-MM-dd').format(DateTime.now())
    };
    print("load data ${getEmid}");
    var connect = Api.connectionApi("post", body, urlLoad);
    connect.then((dynamic res) async {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        print("data persetujuan ${valueBody}");

        if (valueBody['status'] == true) {
          jumlahApproveCuti.value = valueBody['jumlah_cuti'];
          jumlahApproveLembur.value = valueBody['jumlah_lembur'];
          jumlahApproveTidakHadir.value = valueBody['jumlah_tidak_hadir'];
          jumlahApproveTugasLuar.value = valueBody['jumlah_tugasluar'];
          jumlahApproveDinasLuar.value = valueBody['jumlah_dinasluar'];
          jumlahApproveKlaim.value = valueBody['jumlah_klaim'];
          jumlahApprovePayroll.value = valueBody['jumlah_payroll'];
          jumlahCheckin.value = valueBody['jumlah_checkin'];
          jumlahApproveWfh.value = valueBody['jumlah_wfh'];
          jumlahApproveKasbon.value = valueBody['jumlah_kasbon'];

          jumlahPersetujuan.value = jumlahApproveCuti.value +
              jumlahApproveLembur.value +
              jumlahApproveTidakHadir.value +
              jumlahApproveTugasLuar.value +
              jumlahApproveDinasLuar.value +
              jumlahApproveKlaim.value +
              jumlahCheckin.value +
              jumlahApproveWfh.value +
              jumlahApproveKasbon.value;

          this.jumlahApproveCuti.refresh();
          this.jumlahApproveLembur.refresh();
          this.jumlahApproveTidakHadir.refresh();
          this.jumlahApproveTugasLuar.refresh();
          this.jumlahApproveDinasLuar.refresh();
          this.jumlahApproveKlaim.refresh();
          this.jumlahPersetujuan.refresh();
          this.jumlahCheckin.refresh();
          this.jumlahApproveWfh.refresh();
          this.jumlahApproveKasbon.refresh();
          jumlahApprovePayroll.refresh();

          print("Jumlah Approval payroll ${jumlahApprovePayroll}");
          print("Jumlah Approval payroll ${valueBody}");
          loadScreenPersetujuan();
        } else {
          statusScreenInfoApproval.value = false;
          UtilsAlert.showToast(
              "Data periode ${bulanSelectedSearchHistory.value}-${tahunSelectedSearchHistory.value} belum tersedia, harap hubungi HRD");
        }
      }
    });
  }

  void loadApproveHistory() {
    var url = valuePolaPersetujuan.value == "1"
        ? "load_approve_history"
        : "load_approve_history_multi";
    riwayatPersetujuan.value.clear();
    allRiwayatPersetujuan.value.clear();
    var dataUser = AppData.informasiUser;
    var getEmid = dataUser![0].em_id;
    Map<String, dynamic> body = {
      'em_id': getEmid,
      'bulan': bulanSelectedSearchHistory.value,
      'tahun': tahunSelectedSearchHistory.value,
    };
    var connect = Api.connectionApi("post", body, url);
    connect.then((dynamic res) async {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        if (valueBody['status'] == true) {
          var tampungRiwayatPersetujuan = [];
          if (valueBody['data_tidak_hadir'].length != 0) {
            for (var element in valueBody['data_tidak_hadir']) {
              if (element['leave_status'] != 'Pending') {
                var fullName = element['full_name'] ?? "";
                var convertNama = "$fullName";
                var tanggalDari =
                    Constanst.convertDate1("${element['start_date']}");
                var tanggalSampai =
                    Constanst.convertDate1("${element['end_date']}");
                var nama_approve = valuePolaPersetujuan.value == "1"
                    ? element['apply_by']
                    : element['apply2_by'] == "" ||
                            element['apply2_by'] == null ||
                            element['apply2_by'] == "null"
                        ? element['apply_by']
                        : element['apply2_by'];
                var data = {
                  'id': element['id'],
                  'nama_pengaju': convertNama,
                  'title_ajuan': 'Pengajuan Tidak Hadir',
                  'waktu_dari': tanggalDari,
                  'waktu_sampai': tanggalSampai,
                  'durasi': element['leave_duration'],
                  'waktu': element['time_plan'],
                  'waktu2': element['time_plan_to'],
                  'category': element['category'],
                  'waktu_pengajuan': element['atten_date'],
                  'catatan': element['reason'],
                  'status': element['leave_status'],
                  'apply_date': element['apply_date'],
                  'apply_by': nama_approve,
                  'alasan_reject': element['alasan_reject'],
                  'date_selected': element['date_selected'],
                  'nama_tipe': element['nama_tipe'],
                  'type': "Izin",
                  'lainnya': '',
                  'file': element['leave_files']
                };
                tampungRiwayatPersetujuan.add(data);
              }
            }
          }
          if (valueBody['data_cuti'].length != 0) {
            for (var element in valueBody['data_cuti']) {
              if (element['leave_status'] != 'Pending') {
                var fullName = element['full_name'] ?? "";
                var convertNama = "$fullName";
                var tanggalDari =
                    Constanst.convertDate1("${element['start_date']}");
                var tanggalSampai =
                    Constanst.convertDate1("${element['end_date']}");
                var nama_approve = valuePolaPersetujuan.value == "1"
                    ? element['apply_by']
                    : element['apply2_by'] == "" ||
                            element['apply2_by'] == null ||
                            element['apply2_by'] == "null"
                        ? element['apply_by']
                        : element['apply2_by'];
                var data = {
                  'id': element['id'],
                  'nama_pengaju': convertNama,
                  'title_ajuan': 'Pengajuan Cuti',
                  'waktu_dari': tanggalDari,
                  'waktu_sampai': tanggalSampai,
                  'durasi': element['leave_duration'],
                  'waktu': "",
                  'waktu_pengajuan': element['atten_date'],
                  'catatan': element['reason'],
                  'status': element['leave_status'],
                  'apply_date': element['apply_date'],
                  'apply_by': nama_approve,
                  'date_selected': element['date_selected'],
                  'alasan_reject': element['alasan_reject'],
                  'nama_tipe': element['nama_tipe'],
                  'type': 'Cuti',
                  'lainnya': '',
                  'file': element['leave_files']
                };
                tampungRiwayatPersetujuan.add(data);
              }
            }
          }
          if (valueBody['data_dinas_luar'].length != 0) {
            for (var element in valueBody['data_dinas_luar']) {
              if (element['leave_status'] != 'Pending') {
                var fullName = element['full_name'] ?? "";
                var convertNama = "$fullName";
                var tanggalDari =
                    Constanst.convertDate1("${element['start_date']}");
                var tanggalSampai =
                    Constanst.convertDate1("${element['end_date']}");
                var nama_approve = valuePolaPersetujuan.value == "1"
                    ? element['apply_by']
                    : element['apply2_by'] == "" ||
                            element['apply2_by'] == null ||
                            element['apply2_by'] == "null"
                        ? element['apply_by']
                        : element['apply2_by'];
                var data = {
                  'id': element['id'],
                  'nama_pengaju': convertNama,
                  'title_ajuan': 'Pengajuan Dinas Luar',
                  'waktu_dari': tanggalDari,
                  'waktu_sampai': tanggalSampai,
                  'durasi': element['leave_duration'],
                  'waktu': "",
                  'waktu_pengajuan': element['atten_date'],
                  'catatan': element['reason'],
                  'status': element['leave_status'],
                  'apply_date': element['apply_date'],
                  'apply_by': nama_approve,
                  'alasan_reject': element['alasan_reject'],
                  'date_selected': element['date_selected'],
                  'nama_tipe': "",
                  'type': "Dinas Luar",
                  'lainnya': '',
                  'file': element['leave_files']
                };
                tampungRiwayatPersetujuan.add(data);
              }
            }
          }
          if (valueBody['data_lembur'].length != 0) {
            for (var element in valueBody['data_lembur']) {
              if (element['status'] != 'Pending') {
                var fullName = element['full_name'] ?? "";
                var convertNama = "$fullName";
                var nama_approve = valuePolaPersetujuan.value == "1"
                    ? element['approve_by']
                    : element['approve2_by'] == "" ||
                            element['approve2_by'] == null ||
                            element['approve2_by'] == "null"
                        ? element['approve_by']
                        : element['approve2_by'];
                var data = {
                  'id': element['id'],
                  'nama_pengaju': convertNama,
                  'title_ajuan': 'Pengajuan Lembur',
                  'waktu_dari': element['dari_jam'],
                  'waktu_sampai': element['sampai_jam'],
                  'durasi': "",
                  'waktu': "",
                  'waktu_pengajuan': element['atten_date'],
                  'catatan': element['uraian'],
                  'status': element['status'],
                  'apply_date': element['approve_date'],
                  'apply_by': nama_approve,
                  'date_selected': '',
                  'alasan_reject': element['alasan_reject'],
                  'nama_tipe': "",
                  'type': 'Lembur',
                  'lainnya': '',
                  'file': ""
                };
                tampungRiwayatPersetujuan.add(data);
              }
            }
          }
          if (valueBody['data_tugas_luar'].length != 0) {
            for (var element in valueBody['data_tugas_luar']) {
              if (element['status'] != 'Pending') {
                var fullName = element['full_name'] ?? "";
                var convertNama = "$fullName";
                var nama_approve = valuePolaPersetujuan.value == "1"
                    ? element['approve_by']
                    : element['approve2_by'] == "" ||
                            element['approve2_by'] == null ||
                            element['approve2_by'] == "null"
                        ? element['approve_by']
                        : element['approve2_by'];
                var data = {
                  'id': element['id'],
                  'nama_pengaju': convertNama,
                  'title_ajuan': 'Pengajuan Tugas Luar',
                  'waktu_dari': element['dari_jam'],
                  'waktu_sampai': element['sampai_jam'],
                  'durasi': '',
                  'waktu': '',
                  'waktu_pengajuan': element['atten_date'],
                  'catatan': element['uraian'],
                  'status': element['status'],
                  'apply_date': element['approve_date'],
                  'apply_by': nama_approve,
                  'date_selected': '',
                  'alasan_reject': element['alasan_reject'],
                  'nama_tipe': "",
                  'type': 'Tugas Luar',
                  'lainnya': '',
                  'file': ''
                };
                tampungRiwayatPersetujuan.add(data);
              }
            }
          }
          if (valueBody['data_klaim'].length != 0) {
            for (var element in valueBody['data_klaim']) {
              if (element['status'] != 'Pending') {
                var fullName = element['full_name'] ?? "";
                var convertNama = "$fullName";
                var nama_approve = valuePolaPersetujuan.value == "1"
                    ? element['approve_by']
                    : element['approve2_by'] == "" ||
                            element['approve2_by'] == null ||
                            element['approve2_by'] == "null"
                        ? element['approve_by']
                        : element['approve2_by'];
                DateTime fltr1 = DateTime.parse("${element['tgl_ajuan']}");
                DateTime fltr2 = DateTime.parse("${element['created_on']}");
                var tanggalPengajuan =
                    "${DateFormat('dd-MM-yyyy').format(fltr1)}";
                var tanggalPembuatan =
                    "${DateFormat('yyyy-MM-dd').format(fltr2)}";
                var data = {
                  'id': element['id'],
                  'nama_pengaju': convertNama,
                  'title_ajuan': 'Pengajuan Klaim',
                  'waktu_dari': tanggalPengajuan,
                  'waktu_sampai': "",
                  'durasi': "",
                  'waktu': "",
                  'waktu_pengajuan': tanggalPembuatan,
                  'catatan': element['description'],
                  'status': element['status'],
                  'apply_date': element['approve_date'],
                  'apply_by': nama_approve,
                  'date_selected': '',
                  'alasan_reject': element['alasan_reject'],
                  'nama_tipe': "",
                  'type': 'Klaim',
                  'lainnya': element,
                  'file': element['nama_file'],
                };
                tampungRiwayatPersetujuan.add(data);
              }
            }
          }
          if (tampungRiwayatPersetujuan.length != 0) {
            allRiwayatPersetujuan.value = tampungRiwayatPersetujuan;
            var listTanggal = [];
            var finalData = [];
            for (var element in tampungRiwayatPersetujuan) {
              listTanggal.add(element['waktu_pengajuan']);
            }
            listTanggal = listTanggal.toSet().toList();
            for (var element in listTanggal) {
              var valueTurunan = [];
              for (var element1 in tampungRiwayatPersetujuan) {
                if (element == element1['waktu_pengajuan']) {
                  valueTurunan.add(element1);
                }
              }
              var data = {
                'waktu_pengajuan': element,
                'turunan': valueTurunan,
              };
              finalData.add(data);
            }
            finalData.sort((a, b) {
              return DateTime.parse(b['waktu_pengajuan'])
                  .compareTo(DateTime.parse(a['waktu_pengajuan']));
            });
            riwayatPersetujuan.value = finalData;
          }
          jumlahRiwayat.value = allRiwayatPersetujuan.value.length;
          this.riwayatPersetujuan.refresh();
          this.allRiwayatPersetujuan.refresh();
          this.jumlahRiwayat.refresh();
        }
      }
    });
  }

  void filterApproveHistory(title) {
    riwayatPersetujuan.value.clear();
    var data = [];
    allRiwayatPersetujuan.forEach((element) {
      if (element['title_ajuan'] == title) {
        data.add(element);
      }
    });
    data.sort((a, b) {
      return DateTime.parse(b['waktu_pengajuan'])
          .compareTo(DateTime.parse(a['waktu_pengajuan']));
    });
    if (data.length != 0) {
      riwayatPersetujuan.value = data;
      statusFilteriwayat.value = true;
      stringFilterSelected.value = title;
      this.riwayatPersetujuan.refresh();
      this.statusFilteriwayat.refresh();
      this.stringFilterSelected.refresh();
    } else {
      UtilsAlert.showToast('Data tidak ditemukan');
    }
  }

  void clearFilter() {
    UtilsAlert.loadingSimpanData(Get.context!, "Hapus Filter");
    statusFilteriwayat.value = false;
    riwayatPersetujuan.value.clear();
    allRiwayatPersetujuan.value.clear();
    loadApproveHistory();
    Navigator.pop(Get.context!);
    this.statusFilteriwayat.refresh();
    this.riwayatPersetujuan.refresh();
    this.allRiwayatPersetujuan.refresh();
  }

  void loadScreenPersetujuan() {
    dataScreenPersetujuan.value.clear();
    for (var element in listDummy) {
      if (element == "Cuti") {
        var data = {
          'title': element,
          'jumlah_approve': "${jumlahApproveCuti.value}",
        };
        dataScreenPersetujuan.value.add(data);
        this.dataScreenPersetujuan.refresh();
      } else if (element == "Lembur") {
        var data = {
          'title': element,
          'jumlah_approve': "${jumlahApproveLembur.value}",
        };
        dataScreenPersetujuan.value.add(data);
        this.dataScreenPersetujuan.refresh();
      } else if (element == "Tidak Hadir") {
        var data = {
          'title': element,
          'jumlah_approve': "${jumlahApproveTidakHadir.value}",
        };
        dataScreenPersetujuan.value.add(data);
        this.dataScreenPersetujuan.refresh();
      } else if (element == "Tugas Luar") {
        var data = {
          'title': element,
          'jumlah_approve': "${jumlahApproveTugasLuar.value}",
        };
        dataScreenPersetujuan.value.add(data);
        this.dataScreenPersetujuan.refresh();
      } else if (element == "Dinas Luar") {
        var data = {
          'title': element,
          'jumlah_approve': "${jumlahApproveDinasLuar.value}",
        };
        dataScreenPersetujuan.value.add(data);
        this.dataScreenPersetujuan.refresh();
      } else if (element == "Klaim") {
        var data = {
          'title': element,
          'jumlah_approve': "${jumlahApproveKlaim.value}",
        };

        dataScreenPersetujuan.value.add(data);
        this.dataScreenPersetujuan.refresh();
      } else if (element == "Payroll") {
        var data = {
          'title': element,
          'jumlah_approve': "${jumlahApprovePayroll.value}",
        };

        dataScreenPersetujuan.value.add(data);
        this.dataScreenPersetujuan.refresh();
      } else if (element == "Absensi") {
        var data = {
          'title': element,
          'jumlah_approve': "${jumlahCheckin.value}",
        };

        dataScreenPersetujuan.value.add(data);
        this.dataScreenPersetujuan.refresh();
      } else if (element == "WFH") {
        var data = {
          'title': element,
          'jumlah_approve': "${jumlahApproveWfh.value}",
        };

        dataScreenPersetujuan.value.add(data);
        this.dataScreenPersetujuan.refresh();
      } else if (element == "Kasbon") {
        var data = {
          'title': element,
          'jumlah_approve': "${jumlahApproveKasbon.value}",
        };

        dataScreenPersetujuan.value.add(data);
        this.dataScreenPersetujuan.refresh();
      }
    }
    statusScreenInfoApproval.value = false;
  }

  void routeApproval(index) {
    print("Judul : ${index['title']}");
    // if (index['jumlah_approve'] == "0") {
    //   UtilsAlert.showToast("Tidak ada data yang harus di approve");
    // } else {
    index['title'] == "Cuti"
        ? Get.to(PersetujuanCuti(
            title: index['title'],
            bulan: bulanSelectedSearchHistory.value,
            tahun: tahunSelectedSearchHistory.value,
          ))
        : index['title'] == "Lembur"
            ? Get.to(PersetujuanLembur(
                title: index['title'],
                bulan: bulanSelectedSearchHistory.value,
                tahun: tahunSelectedSearchHistory.value,
              ))
            : index['title'] == "Tidak Hadir"
                ? Get.to(PersetujuanIzin(
                    title: index['title'],
                    bulan: bulanSelectedSearchHistory.value,
                    tahun: tahunSelectedSearchHistory.value,
                  ))
                : index['title'] == "Tugas Luar"
                    ? Get.to(PersetujuanTugasLuar(
                        title: index['title'],
                        bulan: bulanSelectedSearchHistory.value,
                        tahun: tahunSelectedSearchHistory.value,
                      ))
                    : index['title'] == "Dinas Luar"
                        ? Get.to(PersetujuanDinasLuar(
                            title: index['title'],
                            bulan: bulanSelectedSearchHistory.value,
                            tahun: tahunSelectedSearchHistory.value,
                          ))
                        : index['title'] == "Klaim"
                            ? Get.to(PersetujuanKlaim(
                                title: index['title'],
                                bulan: bulanSelectedSearchHistory.value,
                                tahun: tahunSelectedSearchHistory.value,
                              ))
                            : index['title'] == "Payroll"
                                ? Get.to(PersetujuanPayroll(
                                    title: index['title'],
                                    bulan: bulanSelectedSearchHistory.value,
                                    tahun: tahunSelectedSearchHistory.value,
                                  ))
                                : index['title'] == "Absensi"
                                    ? Get.to(PersetujuanAbsensi(
                                        title: index['title'],
                                        bulan: bulanSelectedSearchHistory.value,
                                        tahun: tahunSelectedSearchHistory.value,
                                      ))
                                    : index['title'] == "WFH"
                                        ? Get.to(PersetujuanWfh(
                                            title: index['title'],
                                            bulan: bulanSelectedSearchHistory
                                                .value,
                                            tahun: tahunSelectedSearchHistory
                                                .value,
                                          ))
                                        : index['title'] == "Kasbon"
                                            ? Get.to(PersetujuanKasbon(
                                                title: index['title'],
                                                bulan:
                                                    bulanSelectedSearchHistory
                                                        .value,
                                                tahun:
                                                    tahunSelectedSearchHistory
                                                        .value,
                                              ))
                                            : Get.to(Approval(
                                                title: index['title'],
                                                bulan:
                                                    bulanSelectedSearchHistory
                                                        .value,
                                                tahun:
                                                    tahunSelectedSearchHistory
                                                        .value,
                                              ));
    // }
  }

  void routeApprovalNotif({
    required String title,
    required String emIdPengaju,
    required String idx,
    required String delegasi,
    required String url,
  }) async {
    // print("lalala: $url");
    if (title == "Persetujuan Lembur" || url == "Lembur") {
      await controllerApproval.startLoadData(
          'Lembur',
          bulanSelectedSearchHistory.value,
          tahunSelectedSearchHistory.value,
          'persetujuan');
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.to(() => DetailPersetujuanLembur(
              emId: emIdPengaju,
              title: 'Lembur',
              idxDetail: idx,
              delegasi: delegasi,
            ));
      });
    } else if (title == "Approval Cuti" || url == "Cuti") {
      controllerApproval.startLoadData('Cuti', bulanSelectedSearchHistory.value,
          tahunSelectedSearchHistory.value, 'persetujuan');
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.to(() => DetailPersetujuanCuti(
              emId: emIdPengaju,
              title: 'Cuti',
              idxDetail: idx,
              delegasi: delegasi,
            ));
      });
    } else if (title == "Approval Izin" ||
        url == "Izin" ||
        url == "TidakHadir") {
      controllerApproval.startLoadData(
          'Tidak Hadir',
          bulanSelectedSearchHistory.value,
          tahunSelectedSearchHistory.value,
          'persetujuan');
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.to(() => DetailPersetujuanIzin(
              emId: emIdPengaju,
              title: 'Tidak Hadir',
              idxDetail: idx,
              delegasi: delegasi,
            ));
      });
    } else if (title == "Approval Tugas Luar" || url == "TugasLuar") {
      controllerApproval.startLoadData(
          'Tugas Luar',
          bulanSelectedSearchHistory.value,
          tahunSelectedSearchHistory.value,
          'persetujuan');
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.to(() => DetailPersetujuanTugasLuar(
              emId: emIdPengaju,
              title: 'Tugas Luar',
              idxDetail: idx,
              delegasi: delegasi,
            ));
      });
    } else if (url == "DinasLuar") {
      controllerApproval.startLoadData(
          'Dinas Luar',
          bulanSelectedSearchHistory.value,
          tahunSelectedSearchHistory.value,
          'persetujuan');
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.to(() => DetailPersetujuanDinasLuar(
              emId: emIdPengaju,
              title: 'Dinas Luar',
              idxDetail: idx,
              delegasi: delegasi,
            ));
      });
    } else if (title == "Approval Klaim" || url == "Klaim") {
      controllerApproval.startLoadData(
          'Klaim',
          bulanSelectedSearchHistory.value,
          tahunSelectedSearchHistory.value,
          'persetujuan');
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.to(() => DetailPersetujuanKlaim(
              emId: emIdPengaju,
              title: 'Klaim',
              idxDetail: idx,
              delegasi: delegasi,
            ));
      });
    } else if (title == "Approval Payroll" || url == "Payroll") {
      controllerApproval.startLoadData(
          'Payroll',
          bulanSelectedSearchHistory.value,
          tahunSelectedSearchHistory.value,
          'persetujuan');
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.to(() => DetailPersetujuanPayroll(
              emId: emIdPengaju,
              title: 'Payroll',
              idxDetail: idx,
              delegasi: delegasi,
            ));
      });
    } else if (title == "Approval Absensi" || url == "Absensi") {
      controllerApproval.startLoadData(
          'Absensi',
          bulanSelectedSearchHistory.value,
          tahunSelectedSearchHistory.value,
          'persetujuan');
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.to(() => DetailPersetujuanAbsensi(
              emId: emIdPengaju,
              title: 'Absensi',
              idxDetail: idx,
              delegasi: delegasi,
            ));
      });
    } else if (title == "Approval WFH" || url == "WFH") {
      controllerApproval.startLoadData('WFH', bulanSelectedSearchHistory.value,
          tahunSelectedSearchHistory.value, 'persetujuan');
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.to(() => DetailPersetujuanWfh(
              emId: emIdPengaju,
              title: "WFH",
              idxDetail: idx,
              delegasi: delegasi,
            ));
      });
    } else if (title == "Approval Kasbon" || url == "Kasbon") {
      controllerApproval.startLoadData(
          'Kasbon',
          bulanSelectedSearchHistory.value,
          tahunSelectedSearchHistory.value,
          'persetujuan');
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.to(() => DetailPersetujuanKasbon(
              emId: emIdPengaju,
              title: "Kasbon",
              idxDetail: idx,
              delegasi: delegasi,
            ));
      });
    } else {}
  }

  void loadNotifikasi() {
    listNotifikasi.value.clear();
    var dataUser = AppData.informasiUser;
    var getEmid = dataUser![0].em_id;
    var dt = DateTime.now();
    var tanggalSekarang =
        Constanst.convertDate1("${dt.year}-${dt.month}-${dt.day}");
    var getBulan = dt.month <= 9 ? "0${dt.month}" : dt.month;
    Map<String, dynamic> body = {
      'em_id': getEmid,
      'bulan': getBulan,
      'tahun': dt.year
    };
    var connect = Api.connectionApi("post", body, "load_notifikasi");
    connect.then((dynamic res) async {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        for (var element in valueBody['data']) {
          var tanggalDataApi = Constanst.convertDate1("${element['tanggal']}");
          var filterTanggal =
              tanggalDataApi == tanggalSekarang ? 'Hari ini' : tanggalDataApi;
          List listNotif = element['notifikasi'];
          listNotif.sort((a, b) {
            return b['id'].compareTo(a['id']);
          });
          var data = {
            'tanggal': filterTanggal,
            'notifikasi': listNotif,
          };
          listNotifikasi.value.add(data);
        }
        this.listNotifikasi.refresh();
        hitungNotifikasiBelumDibaca();
      }
    });
  }

  void hitungNotifikasiBelumDibaca() {
    var data = [];
    listNotifikasi.value.forEach((element) {
      element['notifikasi'].forEach((element1) {
        if (element1['view'] == 0) {
          data.add(element1);
        }
      });
    });
    jumlahNotifikasiBelumDibaca.value = data.length;
    this.jumlahNotifikasiBelumDibaca.refresh();
  }

  void aksilihatNotif(id) {
    var pisahkanData = [];
    listNotifikasi.value.forEach((element) {
      element['notifikasi'].forEach((element1) {
        if (element1['id'] == id) {
          element1['view'] = 1;
          pisahkanData.add(element1);
        }
      });
    });
    this.listNotifikasi.refresh();
    hitungNotifikasiBelumDibaca();
    updateDataNotif(pisahkanData);
  }

  void redirectToPage(url, arguments) {
    if (url != "") {
      var dashboardController = Get.find<DashboardController>();
      dashboardController.routePageDashboard(url, arguments);
    }
  }

  void updateDataNotif(data) {
    Map<String, dynamic> body = {
      "em_id": data[0]['em_id'],
      "title": data[0]['title'],
      "deskripsi": data[0]['deskripsi'],
      "url": data[0]['url'],
      "atten_date": data[0]['atten_date'],
      "jam": data[0]['jam'],
      "status": data[0]['status'],
      "view": data[0]['view'],
      "val": 'id',
      "cari": data[0]['id']
    };
    var connect = Api.connectionApi("post", body, "edit-notifikasi");
    connect.then((dynamic res) async {
      if (res.statusCode == 200) {
        print("berhasil ganti status notif");
      }
    });
  }

  String convertToIdr(dynamic number, int decimalDigit) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: decimalDigit,
    );
    return currencyFormatter.format(number);
  }

  void filterDetailRiwayatApproval(id, type) {
    var dataDetail = [];
    allRiwayatPersetujuan.forEach((element) {
      if (element['id'] == id && element['type'] == type) {
        dataDetail.add(element);
      }
    });
    print(dataDetail);
    if (dataDetail.length != 0) {
      showDetailRiwayatApproval(dataDetail);
    } else {
      UtilsAlert.showToast('Data tidak tersedia');
    }
  }

  void showDetailRiwayatApproval(dataDetail) {
    List listDateSelected = [];
    if (dataDetail[0]['date_selected'] != "") {
      var data = dataDetail[0]['date_selected'].split(',');
      listDateSelected = data;
    }
    var totalKlaim = dataDetail[0]['type'] == "Klaim"
        ? dataDetail[0]['lainnya']['total_claim']
        : 0;
    var rupiah = convertToIdr(totalKlaim, 0);
    var namaTipe = dataDetail[0]['type'] == "Klaim"
        ? dataDetail[0]['lainnya']['nama_tipe']
        : "";
    var waktu1 = dataDetail[0]['waktu'] == "" || dataDetail[0]['waktu'] == null
        ? "00:00:00"
        : dataDetail[0]['waktu'];
    var waktu2 =
        dataDetail[0]['waktu2'] == "" || dataDetail[0]['waktu2'] == null
            ? "00:00:00"
            : dataDetail[0]['waktu2'];

    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 16,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    flex: 90,
                    child: Text(
                      "Detail Riwayat",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: InkWell(
                        onTap: () {
                          Navigator.pop(Get.context!);
                        },
                        child: const Icon(
                          Iconsax.close_circle,
                          color: Colors.red,
                        )),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Divider(
                height: 5,
                color: Constanst.colorText2,
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  dataDetail[0]['title_ajuan'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Center(
                child: Text(
                  Constanst.convertDate2("${dataDetail[0]['waktu_pengajuan']}"),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                dataDetail[0]['nama_pengaju'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "${dataDetail[0]['title_ajuan']} pada : ",
                style: TextStyle(color: Constanst.colorText2),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    dataDetail[0]['waktu_dari'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  dataDetail[0]['type'] == "Klaim"
                      ? const SizedBox()
                      : const Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Text("s.d",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                  dataDetail[0]['type'] == "Klaim"
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            dataDetail[0]['waktu_sampai'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                ],
              ),
              dataDetail[0]['type'] != "Klaim"
                  ? const SizedBox()
                  : SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Total Klaim",
                            style: TextStyle(color: Constanst.colorText2),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "$rupiah",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Deskripsi",
                style: TextStyle(color: Constanst.colorText2),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                dataDetail[0]['catatan'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              dataDetail[0]['durasi'] == ""
                  ? const SizedBox()
                  : SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Durasi",
                            style: TextStyle(color: Constanst.colorText2),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "${dataDetail[0]['durasi']} Hari",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
              listDateSelected.isEmpty
                  ? const SizedBox()
                  : const SizedBox(
                      height: 10,
                    ),
              listDateSelected.isEmpty
                  ? const SizedBox()
                  : Text(
                      "Tanggal terpilih",
                      style: TextStyle(color: Constanst.colorText2),
                    ),
              const SizedBox(
                height: 5,
              ),
              listDateSelected.isEmpty
                  ? const SizedBox()
                  : ListView.builder(
                      itemCount: listDateSelected.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var tanggalConvert =
                            Constanst.convertDate1(listDateSelected[index]);
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            listDateSelected.length == 1
                                ? const SizedBox()
                                : const Text('-'),
                            Padding(
                              padding: listDateSelected.length == 1
                                  ? const EdgeInsets.only(left: 2)
                                  : const EdgeInsets.only(left: 8),
                              child: Text(
                                tanggalConvert,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        );
                      }),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Tipe",
                style: TextStyle(color: Constanst.colorText2),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    namaTipe == "" || namaTipe == "null" || namaTipe == null
                        ? Text(
                            "${dataDetail[0]['type']} ",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )
                        : Text(
                            "${dataDetail[0]['type']} $namaTipe",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                    dataDetail[0]['nama_tipe'] == "" ||
                            dataDetail[0]['nama_tipe'] == null ||
                            dataDetail[0]['nama_tipe'] == 'null'
                        ? const SizedBox()
                        : Expanded(
                            child: Container(
                              width: double.maxFinite,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  "( ${dataDetail[0]['nama_tipe']}  ${dataDetail[0]['category'] == "" || dataDetail[0]['category'] == null ? "" : " - ${dataDetail[0]['category']}"})",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              dataDetail[0]['waktu'] == "" ||
                      dataDetail[0]['category'] == "FULLDAY"
                  ? const SizedBox()
                  : Text(
                      "Waktu",
                      style: TextStyle(color: Constanst.colorText2),
                    ),
              dataDetail[0]['waktu'] == "" ||
                      dataDetail[0]['category'] == "FULLDAY"
                  ? const SizedBox()
                  : const SizedBox(
                      height: 5,
                    ),
              dataDetail[0]['waktu'] == "" ||
                      dataDetail[0]['category'] == "FULLDAY"
                  ? const SizedBox()
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$waktu1 sd $waktu2",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Tanggal persetujuan / penolakan",
                style: TextStyle(color: Constanst.colorText2),
              ),
              const SizedBox(
                height: 5,
              ),
              dataDetail[0]['apply_date'] == null ||
                      dataDetail[0]['apply_date'] == ''
                  ? const SizedBox(
                      child: Text('Tanggal tidak valid'),
                    )
                  : Text(
                      Constanst.convertDate2("${dataDetail[0]['apply_date']}"),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Status Pengajuan",
                style: TextStyle(color: Constanst.colorText2),
              ),
              const SizedBox(
                height: 5,
              ),
              dataDetail[0]['apply_by'] == null ||
                      dataDetail[0]['apply_by'] == ""
                  ? const SizedBox()
                  : Text(
                      "${dataDetail[0]['status']} oleh ${dataDetail[0]['apply_by']}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: dataDetail[0]['status'] == 'Approve'
                              ? Constanst.color5
                              : dataDetail[0]['status'] == 'Approve2'
                                  ? Constanst.color5
                                  : Constanst.color4),
                    ),
              const SizedBox(
                height: 10,
              ),
              dataDetail[0]['alasan_reject'] == "" ||
                      dataDetail[0]['alasan_reject'] == null
                  ? const SizedBox()
                  : SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Alasan Reject",
                            style: TextStyle(color: Constanst.colorText2),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            dataDetail[0]['alasan_reject'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
              dataDetail[0]['file'] == "" || dataDetail[0]['file'] == null
                  ? const SizedBox()
                  : SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "File",
                            style: TextStyle(color: Constanst.colorText2),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 60,
                                child: Text(
                                  dataDetail[0]['file'].toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                flex: 40,
                                child: InkWell(
                                  onTap: () {
                                    if (dataDetail[0]['title_ajuan'] ==
                                        "Pengajuan Tidak Hadir") {
                                      viewFile(
                                          "tidak_hadir", dataDetail[0]['file']);
                                    } else {
                                      viewFile("cuti", dataDetail[0]['file']);
                                    }
                                    // viewFile(status, file)
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Lihat File",
                                        style: TextStyle(
                                            color: Constanst.colorPrimary),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          color: Constanst.colorPrimary,
                                          size: 20,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      },
    );
  }

  void cariData(value) {
    var textCari = value.toLowerCase();
    List filter = allRiwayatPersetujuan.where((pengaju) {
      var namaPengaju = pengaju['nama_pengaju'].toLowerCase();
      return namaPengaju.contains(textCari);
    }).toList();
    filter.sort((a, b) {
      return DateTime.parse(b['waktu_pengajuan'])
          .compareTo(DateTime.parse(a['waktu_pengajuan']));
    });
    if (filter.isNotEmpty) {
      riwayatPersetujuan.value = filter;
      statusCari.value = true;
      this.riwayatPersetujuan.refresh();
      this.statusCari.refresh();
    }
  }

  void viewFile(status, file) async {
    if (status == "tidak_hadir") {
      var urlViewGambar = Api.UrlfileTidakhadir + file;

      final url = Uri.parse(urlViewGambar);
      if (!await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      )) {
        UtilsAlert.showToast('Tidak dapat membuka file');
      }
    } else {
      var urlViewGambar = Api.UrlfileCuti + file;

      final url = Uri.parse(urlViewGambar);
      if (!await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      )) {
        UtilsAlert.showToast('Tidak dapat membuka file');
      }
    }
  }
}
