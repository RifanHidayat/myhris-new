import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/global_controller.dart';
import 'package:siscom_operasional/controller/pesan_controller.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/custom_dialog.dart';
import 'package:siscom_operasional/utils/widget_textButton.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class ApprovalController extends GetxController {
  var cari = TextEditingController().obs;
  var alasanReject = TextEditingController().obs;

  var alasan1 = TextEditingController().obs;
  var alasan2 = TextEditingController().obs;
  var taskControllers = <TextEditingController>[].obs;
  ScrollController scrollController = ScrollController();
  List<FocusNode> focusNodes = [];

  var isLoadingAlasan = false.obs;
  var listAlasan = [].obs;

  var searchSp = [].obs;
  var searchTl = [].obs;

  var titleAppbar = "".obs;
  var bulanSelected = "".obs;
  var tahunSelected = "".obs;
  var fullNameDelegasi = "".obs;
  var fullNameApprove2 = [].obs;
  var valuePolaPersetujuan = "".obs;
  var loadingString = "Memuat Data...".obs;

  var statusCari = false.obs;
  var listStatusPengajuan = <Map<String, String>>[].obs;

  var statusPemgajuanIzin = 'none'.obs;
  var listStatusPengajuanSP = [
            {'name': "None", 'value': "none"},
            {'name': "Potong Cuti", 'value': "potong_cuti"},
            {'name': "Potong Gaji", 'value': "potong_gaji"},
          ].obs;
  var listStatusPengajuanSPTolak = [
    {'name': "None", 'value': "none"},
    {'name': "Teguran Lisan", 'value': "teguran_lisan"}
  ].obs;
  var statusPemgajuanSP = ''.obs;
  // var statusPemgajuanSPTolak = ''.obs;
  var konsekuemsiList = [].obs;
  var statusPengajuan = false;

  var totalPercent = 0.0.obs;
  var totalPercentage = 0.0.obs;
  var listTask = [].obs;
  var listNotModif = [].obs;
  var listData = [].obs;
  var listDataAll = [].obs;
  var listDataRiwayat = [].obs;
  var detailData = [].obs;
  var showButton = false.obs;

  var jumlahCuti = 0.obs;
  var typeIdEdit = 0.obs;
  var cutiTerpakai = 0.obs;
  var persenCuti = 0.0.obs;
  var durasiIzin = 0.obs;

  var tempNamaTipe1 = "Tugas Luar".obs;

  var statusHitungCuti = false.obs;

  var controllerGlobal = Get.find<GlobalController>();

  var saldo = 0.obs;
  var limitTransaksi = 0.obs;

  var startTime = "".obs;
  var endTime = "".obs;
  var startDate = "".obs;
  var endDate = "".obs;

  void showInputCari() {
    statusCari.value = !statusCari.value;
  }

  Future<void> startLoadData(title, bulan, tahun, status) async {
    getLoadsysData(title, bulan, tahun, status);
  }

  void updateListStatus() {
    print('ini di update gak sih');
    print('ini di update gak sih${searchSp}');
    print('searchSp: ${searchSp.value}, searchTl: ${searchTl.value}');
    print(searchSp.isEmpty || searchTl.isEmpty);
    listStatusPengajuan.value = searchSp.isNotEmpty || searchTl.isNotEmpty
        ? [
            {'name': "None", 'value': "none"},
            {'name': "Surat Peringatan", 'value': "surat_peringatan"}
          ]
        : [
            {'name': "None", 'value': "none"},
            {'name': "Teguran Lisan", 'value': "teguran_lisan"},
            {'name': "Surat Peringatan", 'value': "surat_peringatan"}
          ];
    listStatusPengajuan.refresh();
    print(listStatusPengajuan);
  }


  void getSaldo({emId, id}) {
    print("saldo new ");

    var body = {"em_id": AppData.informasiUser![0].em_id, "cost_id": id};
    var connect = Api.connectionApi("post", body, "emp-claim-saldo");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        print("value body ${valueBody}");

        saldo.value = int.parse(valueBody['saldo'].toString());
        limitTransaksi.value = int.parse(valueBody['limit'].toString());
        limitTransaksi.value =
            int.parse(valueBody['limit'].toString()) - saldo.value;
      }
    });
  }

  void getLoadsysData(title, bulan, tahun, status) {
    print("Judul persetujuan ${title}");
    var connect = Api.connectionApi("get", "", "sysdata");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        // debugPrint('ini apaan siinin ${valueBody}', wrapWidth: 1000);
        for (var element in valueBody['data']) {
          if (element['kode'] == "013") {
            valuePolaPersetujuan.value = "${element['name']}";
            this.valuePolaPersetujuan.refresh();
            print(valuePolaPersetujuan.value);
            titleAppbar.value = title;
            bulanSelected.value = bulan;
            tahunSelected.value = tahun;
            jumlahCuti.value = 0;
            this.jumlahCuti.refresh();
            if (title == "Cuti") {
              loadDataCuti(status);
            } else if (title == "Lembur") {
              loadDataLembur(status);
            } else if (title == "Tidak Hadir") {
              loadDataTidakHadir(status);
            } else if (title == "Tugas Luar") {
              loadDataTugasLuar(status);
            } else if (title == "Dinas Luar") {
              loadDataDinasLuar(status);
            } else if (title == "Klaim") {
              loadDataKlaim(status);
            } else if (title == "Payroll") {
              loadApprovePayroll(status);
            } else if (title == "Absensi") {
              loadAbsensi(status);
            } else if (title == "WFH") {
              loadwfh(status);
            } else if (title == "Kasbon") {
              loadkasbon(status);
            } else if (title == "Surat Peringatan") {
              loadSuratPeringatan(status);
            } else if (title == 'Teguran Lisan') {
              loadTeguranLisan(status);
            } else if (title == 'Shift'){
              loadShift(status);
            }
          }
        }
      }
    });
  }

  void loadDataCuti(status) {
    var urlLoad = valuePolaPersetujuan.value == "1"
        ? "spesifik_approval"
        : "spesifik_approval_multi";
    listNotModif.value.clear();
    listData.value.clear();
    listDataRiwayat.value.clear();
    listDataAll.value.clear();
    var dataUser = AppData.informasiUser;
    var getEmCode = dataUser![0].em_id;
    var body = {
      'em_id': getEmCode,
      'name_data': 'cuti',
      'bulan': bulanSelected.value,
      'tahun': tahunSelected.value,
      'status': status == "riwayat" ? '' : 'pending',
    };
    print("Parameter ${body}");
    var connect = Api.connectionApi("post", body, urlLoad);
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        if (valueBody['data'].length == 0) {
          loadingString.value = 'Tidak ada pengajuan';
        }
        listNotModif.value = valueBody['data'];
        for (var element in valueBody['data']) {
          print("Inpu time ${element['input_time']}");
          var fullName = element['full_name'] ?? "";
          var convertNama = "$fullName";
          var tanggalDari = Constanst.convertDate1("${element['start_date']}");
          var tanggalSampai = Constanst.convertDate1("${element['end_date']}");
          var filterStatus = element['leave_status'] == "Approve"
              ? "Approve 1"
              : element['leave_status'];
          var data = {
            'id': element['id'],
            'nama_pengaju': convertNama,
            'emId_pengaju': element['em_id'],
            'title_ajuan': 'Pengajuan Cuti',
            'waktu_dari': tanggalDari,
            'waktu_sampai': tanggalSampai,
            'durasi': element['leave_duration'],
            'leave_status': filterStatus,
            'delegasi': element['em_delegation'],
            'nama_approve1': element['apply_by'],
            'nama_approve2': element['apply2_by'],
            'waktu_pengajuan': element['atten_date'],
            'catatan': element['reason'],
            'type': 'Cuti',
            'category': element['category'],
            'em_report_to': element['em_report_to'],
            'em_report2_to': element['em_report2_to'],
            'lainnya': "",
            'nama_pengajuan': element['nama_pengajuan'],
            'file': element['leave_files'],
            'nama_divisi': element['nama_divisi'],
            'nomor_ajuan': element['nomor_ajuan'],
            'image': element['image'],
            'apply_status': element['apply_status'],
            'apply2_status': element['apply2_status'],
            'nama_tipe': element['nama_tipe'],
            'cut_leave': element['cut_leave']
          };
          listData.value.add(data);
          listDataRiwayat.value.add(data);
          listDataAll.value.add(data);
        }
        listData.value.sort(
            (a, b) => b['waktu_pengajuan'].compareTo(a['waktu_pengajuan']));
        this.listData.refresh();
        this.listNotModif.refresh();
      }
    });
  }

  void loadDataLembur(status) {
    var urlLoad = valuePolaPersetujuan.value == "1"
        ? "spesifik_approval"
        : "spesifik_approval_multi";
    listNotModif.value.clear();
    listData.value.clear();
    listDataAll.value.clear();
    var dataUser = AppData.informasiUser;
    var getEmCode = dataUser![0].em_id;
    var body = {
      'em_id': getEmCode,
      'name_data': 'lembur',
      'bulan': bulanSelected.value,
      'tahun': tahunSelected.value,
      'status': status == "riwayat" ? '' : 'pending',
    };
    var connect = Api.connectionApi("post", body, urlLoad);
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        debugPrint("data lembur value ${valueBody['data']}", wrapWidth: 1000);
        if (valueBody['data'].length == 0) {
          loadingString.value = 'Tidak ada pengajuan';
        }
        listNotModif.value = valueBody['data'];
        for (var element in valueBody['data']) {
          var fullName = element['full_name'] ?? "";
          var convertNama = "$fullName";
          var filterStatus =
              element['status'] == "Approve" ? "Approve 1" : element['status'];
          var data = {
            'id': element['id'],
            'nama_pengaju': convertNama,
            'date_selected': element['date_selected'],
            'title_ajuan': 'Pengajuan Lembur',
            'waktu_dari': element['dari_jam'],
            'waktu_sampai': element['sampai_jam'],
            'durasi': "",
            'leave_status': filterStatus,
            'delegasi': element['em_delegation'],
            'nama_approve1': element['approve_by'],
            'nama_approve2': element['approve2_by'],
            'waktu_pengajuan': element['atten_date'],
            'catatan': element['uraian'],
            'type': 'Lembur',
            'category': element['nama_pengajuan'],
            'lainnya': "",
            'file': "",
            'em_report_to': element['em_report_to'],
            'em_report2_to': element['em_report2_to'],
            'nama_pengajuan': element['nama_pengajuan'],
            'nama_divisi': element['nama_divisi'],
            'nomor_ajuan': element['nomor_ajuan'],
            'approve_status': element['approve_status'],
            'approve2_status': element['approve2_status'],
            'image': element['image'],
            'status': element['status'],
            'em_ids': element['em_ids'],
            'em_id_pengaju': element['em_id'],
            'dinilai': element['dinilai'],
            'nama_delegasi': element['nama_delegasi']
          };
          listData.value.sort(
              (a, b) => b['waktu_pengajuan'].compareTo(a['waktu_pengajuan']));
          listData.value.add(data);
          listDataAll.value.add(data);
        }
        this.listData.refresh();
        this.listNotModif.refresh();
      } else {
        print('ini error lembur appooval ${res.statusCode} : ${res.body}');
      }
    });
  }

  void loadApprovePayroll(status) {
    print("-------------------data payroll--------------------");

    listNotModif.value.clear();
    listData.value.clear();
    listDataAll.value.clear();
    var dataUser = AppData.informasiUser;
    var getEmCode = dataUser![0].em_id;
    var body = {
      'em_id': getEmCode,
      'name_data': 'lembur',
      'bulan': bulanSelected.value,
      'tahun': tahunSelected.value,
      'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'status': status == "riwayat" ? '' : 'pending',
    };
    var connect = Api.connectionApi("post", body, 'list_approve_payroll');

    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);

        print("data payroll ${valueBody}");
        if (valueBody['data'].length == 0) {
          loadingString.value = 'Tidak ada pengajuan';
        }
        print(valueBody['data']);
        listNotModif.value = valueBody['data'];
        for (var element in valueBody['data']) {
          var fullName = element['full_name'] ?? "";
          var convertNama = "$fullName";
          var filterStatus =
              element['approve_id'] == null ? "Pending" : "Approved";
          var data = {
            'id': element['id'],
            'nama_pengaju': convertNama,
            'title_ajuan': 'Pengajuan Lembur',
            'nama_approve1': element['approved_id'],
            'waktu_pengajuan': element['created_date'],
            'catatan': element['description'],
            'type': 'payroll',
            'category': "",
            'lainnya': "",
            'file': "",
            'nama_divisi': element['nama_divisi'],
            'full_name': element['full_name'],
            'em_email': element['em_email'],
            'em_report_to': element['em_report_to'],
            'em_report2_to': element['em_report2_to'],
            'nomor_ajuan': element['nomor_ajuan'],
            'image': element['image'],
          };
          listData.value.sort(
              (a, b) => b['waktu_pengajuan'].compareTo(a['waktu_pengajuan']));
          listData.value.add(data);
          listDataAll.value.add(data);
        }
        this.listData.refresh();
        this.listNotModif.refresh();
      }
    });
  }

  void loadAbsensi(status) {
    print("data absensi");
    var urlLoad = valuePolaPersetujuan.value == "1"
        ? "spesifik_approval"
        : "spesifik_approval_multi";
    listNotModif.value.clear();
    listData.value.clear();
    listDataAll.value.clear();
    var dataUser = AppData.informasiUser;
    var getEmCode = dataUser![0].em_id;
    var body = {
      'em_id': getEmCode,
      'name_data': 'absensi',
      'bulan': bulanSelected.value,
      'tahun': tahunSelected.value,
      'status': status == "riwayat" ? '' : 'pending',
    };
    var connect = Api.connectionApi("post", body, urlLoad);
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        print("value body ${valueBody}");
        if (valueBody['data'].length == 0) {
          loadingString.value = 'Tidak ada pengajuan';
        }
        listNotModif.value = valueBody['data'];

        print("data body 2 ${valueBody['data']}");
        for (var element in valueBody['data']) {
          var fullName = element['full_name'] ?? "";
          var convertNama = "$fullName";
          var tanggalDari = Constanst.convertDate1("${element['atten_date']}");
          var tanggalSampai =
              Constanst.convertDate1("${element['atten_date']}");
          var filterStatus = element['leave_status'];
          var data = {
            'id': element['id'],
            'nama_pengaju': convertNama,
            'emId_pengaju': element['em_id'],
            'em_id': element['em_id'],
            'title_ajuan': 'Pengajuan Absensi',
            'waktu_dari': "${tanggalDari} ${element['dari_jam'] ?? "_ _:_ _"}",
            'waktu_sampai': "${tanggalDari} ${element['sampai_jam']}",
            'durasi': element['leave_duration'],
            'leave_status': filterStatus,
            'delegasi': element['em_delegation'],
            'nama_approve1': element['approve_by'],
            'nama_approve2': element['approve2_by'],
            'waktu_pengajuan': element['tgl_ajuan'],
            'atten_date': element['atten_date'],
            'catatan': element['reason'],
            'type': 'absensi',
            'category': element['category'],
            'lainnya': "",
            'file': element['req_file'] ?? "",
            'dari_jam': element['dari_jam'],
            'sampai_jam': element['sampai_jam'],
            'breakout_time': element['breakout_time'],
            'breakin_time': element['breakin_time'],
            'deskripsi': element['uraian'],
            'nomor_ajuan': element['nomor_ajuan'],
            'em_report_to': element['em_report_to'],
            'em_report2_to': element['em_report2_to'],
            'nama_divisi': element['nama_divisi'],
            'place_in': element['place_in'],
            'place_out': element['place_out'],
            'approve_id': element['approve_id'],
            'approve_by': element['approve_by'],
            'approve_date': element['approve_date'],
            'status': element['status'],
            'approve_status': element['approve_status'],
            'approve2_status': element['approve2_status'],
            'catatan_masuk': element['sigin_note'],
            'catatan_keluar': element['signout_note'],
            'lokasi_masuk': element['signin_addr'],
            'lokasi_keluar': element['signout_addr'],
            'foto_masuk': element['signin_pict'],
            'foto_keluar': element['signout_pict'],
          };
          listData.value.add(data);
          listDataAll.value.add(data);
          print("data body list data ${listData}");
        }
        listData.value.sort(
            (a, b) => b['waktu_pengajuan'].compareTo(a['waktu_pengajuan']));
        this.listData.refresh();
        this.listNotModif.refresh();
      }
    });
  }

  void loadShift(status) {
    print("data shift");
    var urlLoad = valuePolaPersetujuan.value == "1"
        ? "spesifik_approval"
        : "spesifik_approval_multi";
    listNotModif.value.clear();
    listData.value.clear();
    listDataAll.value.clear();
    var dataUser = AppData.informasiUser;
    var getEmCode = dataUser![0].em_id;
    var body = {
      'em_id': getEmCode,
      'name_data': 'shift',
      'bulan': bulanSelected.value,
      'tahun': tahunSelected.value,
      'status': status == "riwayat" ? '' : 'pending',
    };
    var connect = Api.connectionApi("post", body, urlLoad);
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        print("value body ${valueBody}");
        if (valueBody['data'].length == 0) {
          loadingString.value = 'Tidak ada pengajuan';
        }
        listNotModif.value = valueBody['data'];
        for (var element in valueBody['data']) {
          var fullName = element['full_name'] ?? "";
          var convertNama = "$fullName";
              Constanst.convertDate1("${element['atten_date']}");
          var filterStatus = element['status'];
          var data = {
            'id': element['id'],
            'nama_pengaju': convertNama,
            'emId_pengaju': element['em_id'],
            'em_id': element['em_id'],
            'title_ajuan': 'Pengajuan Shift',
            'leave_status': filterStatus,
            'delegasi': element['em_delegation'],
            'nama_approve1': element['approve_by'],
            'nama_approve2': element['approve2_by'],
            'waktu_pengajuan': element['tgl_ajuan'],
            'atten_date': element['atten_date'],
            'catatan': element['uraian'],
            'type': 'Shift',
            'category': element['category'],
            'deskripsi': element['uraian'],
            'nomor_ajuan': element['nomor_ajuan'],
            'em_report_to': element['em_report_to'],
            'em_report2_to': element['em_report2_to'],
            'approve_id': element['approve_id'],
            'approve_by': element['approve_by'],
            'approve_date': element['approve_date'],
            'status': element['status'],
            'approve_status': element['approve_status'],
            'approve2_status': element['approve2_status'],
            'dari_tgl': element['dari_tgl'],
            'sampai_tgl': element['sampai_tgl'],
            'name_delegasi': element['replace_name'],
            'name_old': element['name_old'],
            'time_in_old': element['time_in_old'],
            'time_out_old': element['time_out_old'],
            'work_id_old': element['work_id_old'],
            'name_new': element['name_new'],
            'time_in_new': element['time_in_new'],
            'time_out_new': element['time_out_new'],
            'work_id_new': element['work_id_new'],
          };
          listData.value.add(data);
          listDataAll.value.add(data);
          print("data body list data ${listData}");
        }
        listData.value.sort(
            (a, b) => b['waktu_pengajuan'].compareTo(a['waktu_pengajuan']));
        this.listData.refresh();
        this.listNotModif.refresh();
      }
    });
  }

  void loadwfh(status) {
    print("data wfh");
    var urlLoad = valuePolaPersetujuan.value == "1"
        ? "spesifik_approval"
        : "spesifik_approval_multi";
    listNotModif.value.clear();
    listData.value.clear();
    listDataAll.value.clear();
    var dataUser = AppData.informasiUser;
    var getEmCode = dataUser![0].em_id;
    var body = {
      'em_id': getEmCode,
      'name_data': 'wfh',
      'bulan': bulanSelected.value,
      'tahun': tahunSelected.value,
      'status': status == "riwayat" ? '' : 'pending',
    };
    var connect = Api.connectionApi("post", body, urlLoad);
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        print("value body ${valueBody}");
        if (valueBody['data'].length == 0) {
          loadingString.value = 'Tidak ada pengajuan';
        }
        listNotModif.value = valueBody['data'];

        print("data body 2 ${valueBody['data']}");
        for (var element in valueBody['data']) {
          var fullName = element['full_name'] ?? "";
          var convertNama = "$fullName";
          var tanggalDari = Constanst.convertDate1("${element['atten_date']}");
          var tanggalSampai =
              Constanst.convertDate1("${element['atten_date']}");
          var filterStatus = element['leave_status'];
          var data = {
            'id': element['id'],
            'nama_pengaju': convertNama,
            'emId_pengaju': element['em_id'],
            'em_id': element['em_id'],
            'title_ajuan': 'Pengajuan WFH',
            'waktu_dari': "${tanggalDari} ${element['dari_jam'] ?? "_ _:_ _"}",
            'waktu_sampai': "${tanggalDari} ${element['sampai_jam']}",
            'durasi': element['leave_duration'],
            'leave_status': filterStatus,
            'delegasi': element['em_delegation'],
            'nama_approve1': element['approve_by'],
            'nama_approve2': element['approve2_by'],
            'waktu_pengajuan': element['atten_date'],
            'catatan': element['reason'],
            'type': 'wfh',
            'category': element['category'],
            'lainnya': "",
            'file': element['req_file'] ?? "",
            'dari_jam': element['dari_jam'],
            'sampai_jam': element['sampai_jam'],
            'deskripsi': element['uraian'],
            'nomor_ajuan': element['nomor_ajuan'],
            'em_report_to': element['em_report_to'],
            'em_report2_to': element['em_report2_to'],
            'nama_divisi': element['nama_divisi'],
            'place_in': element['place_in'],
            'place_out': element['place_out'],
            'approve_id': element['approve_id'],
            'approve_by': element['approve_by'],
            'approve_date': element['approve_date'],
            'status': element['status'],
            'approve_status': element['approve_status'],
            'approve2_status': element['approve2_status']
          };
          listData.value.add(data);
          listDataAll.value.add(data);
          print("data body 2 ${valueBody['data']}");
        }
        listData.value.sort(
            (a, b) => b['waktu_pengajuan'].compareTo(a['waktu_pengajuan']));
        this.listData.refresh();
        this.listNotModif.refresh();
      }
    });
  }

  void loadkasbon(status) {
    print("data wfh");
    var urlLoad = valuePolaPersetujuan.value == "1"
        ? "spesifik_approval"
        : "spesifik_approval_multi";
    listNotModif.value.clear();
    listData.value.clear();
    listDataAll.value.clear();
    var dataUser = AppData.informasiUser;
    var getEmCode = dataUser![0].em_id;
    var body = {
      'em_id': getEmCode,
      'name_data': 'kasbon',
      'bulan': bulanSelected.value,
      'tahun': tahunSelected.value,
      'status': status == "riwayat" ? '' : 'pending',
    };
    var connect = Api.connectionApi("post", body, urlLoad);
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        print("value body ${valueBody}");
        if (valueBody['data'].length == 0) {
          loadingString.value = 'Tidak ada pengajuan';
        }
        listNotModif.value = valueBody['data'];

        print("data body 2 ${valueBody['data']}");
        for (var element in valueBody['data']) {
          var fullName = element['full_name'] ?? "";
          var convertNama = "$fullName";
          var tanggalDari =
              Constanst.convertDate1("${element['tanggal_ajuan']}");
          var tanggalSampai =
              Constanst.convertDate1("${element['tanggal_ajuan']}");
          var filterStatus = element['leave_status'];
          var data = {
            'id': element['id'],
            'nama_pengaju': convertNama,
            'emId_pengaju': element['em_id'],
            'em_id': element['em_id'],
            'title_ajuan': 'Pengajuan Kasbon',
            'waktu_dari': "${tanggalDari} ${element['dari_jam'] ?? "_ _:_ _"}",
            'waktu_sampai': "${tanggalDari} ${element['sampai_jam']}",
            'durasi': element['leave_duration'],
            'leave_status': filterStatus,
            'delegasi': element['em_delegation'],
            'nama_approve1': element['approve_by'],
            'nama_approve2': element['approve2_by'],
            'waktu_pengajuan': element['atten_date'],
            'catatan': element['reason'],
            'type': 'kasbon',
            'category': element['category'],
            'lainnya': "",
            'file': element['req_file'] ?? "",
            'dari_jam': element['dari_jam'],
            'sampai_jam': element['sampai_jam'],
            'deskripsi': element['uraian'],
            'nomor_ajuan': element['nomor_ajuan'],
            'em_report_to': element['em_report_to'],
            'em_report2_to': element['em_report2_to'],
            'nama_divisi': element['nama_divisi'],
            'place_in': element['place_in'],
            'place_out': element['place_out'],
            'approve_id': element['approve_id'],
            'approve_by': element['approve_by'],
            'approve_date': element['approve_date'],
            'status': element['status'],
            'approve_status': element['approve_status'],
            'approve2_status': element['approve2_status'],
            'tanggal_ajuan': element['tanggal_ajuan'],
            'description': element['description'],
            'total_pinjaman': element['total_pinjaman'],
            'durasi_cicil': element['durasi_cicil'],
            'periode': element['periode']
          };
          listData.value.add(data);
          listDataAll.value.add(data);
          print("data body 2 ${valueBody['data']}");
        }
        // listData.value.sort(
        //     (a, b) => b['waktu_pengajuan'].compareTo(a['waktu_pengajuan']));
        this.listData.refresh();
        this.listNotModif.refresh();
      }
    });
  }

  void loadDataTidakHadir(status) {
    var urlLoad = valuePolaPersetujuan.value == "1"
        ? "spesifik_approval"
        : "spesifik_approval_multi";
    listNotModif.value.clear();
    listData.value.clear();
    listDataAll.value.clear();
    var dataUser = AppData.informasiUser;
    var getEmCode = dataUser![0].em_id;
    var body = {
      'em_id': getEmCode,
      'name_data': 'tidak_hadir',
      'bulan': bulanSelected.value,
      'tahun': tahunSelected.value,
      'status': status == "riwayat" ? '' : 'pending',
    };
    var connect = Api.connectionApi("post", body, urlLoad);
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        if (valueBody['data'].length == 0) {
          loadingString.value = 'Tidak ada pengajuan';
        }
        ;
        listNotModif.value = valueBody['data'];
        for (var element in valueBody['data']) {
          var fullName = element['full_name'] ?? "";
          var convertNama = "$fullName";
          var tanggalDari = Constanst.convertDate1("${element['start_date']}");
          var tanggalSampai = Constanst.convertDate1("${element['end_date']}");
          var filterStatus = element['leave_status'] == "Approve"
              ? "Approve 1"
              : element['leave_status'];
          var data = {
            'id': element['id'],
            'nama_pengaju': convertNama,
            'title_ajuan': 'Pengajuan Tidak Hadir',
            'waktu_dari': tanggalDari,
            'waktu_sampai': tanggalSampai,
            'durasi': element['leave_duration'],
            'leave_status': filterStatus,
            'delegasi': element['em_delegation'],
            'nama_approve1': element['apply_by'],
            'nama_approve2': element['apply2_by'],
            'waktu_pengajuan': element['atten_date'],
            'catatan': element['reason'],
            'type': element['nama_tipe'],
            'category': element['category'],
            'jamAjuan': element['time_plan'],
            'sampaiJamAjaun': element['time_plan_to'],
            'lainnya': "",
            'nama_pengajuan': element['nama_pengajuan'],
            'emId_pengaju': element['em_id'],
            'file': element['leave_files'],
            'em_report_to': element['em_report_to'],
            'em_report2_to': element['em_report2_to'],
            'nama_divisi': element['nama_divisi'],
            'nomor_ajuan': element['nomor_ajuan'],
            'image': element['image'],
            'date_selected': element['date_selected'],
            'apply_status': element['apply_status'],
            'apply2_status': element['apply2_status'],
            'input_time': element['input_time']
          };
          listData.value.add(data);
          listDataAll.value.add(data);
        }
        listData.value.sort(
            (a, b) => b['waktu_pengajuan'].compareTo(a['waktu_pengajuan']));
        this.listData.refresh();
        this.listNotModif.refresh();
      }
    });
  }

  Future<void> searchSuratPeringatan(em_id) async {
    searchSp.value.clear();
    Map<String, dynamic> body = {
      'em_id': em_id,
    };

    var connect = Api.connectionApi("post", body, 'surat_peringatan_search');
    await connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        for (var element in valueBody['data']) {
          var data = {
            'nomor': element['nomor'],
            'nama': element['nama'],
            'exp': element['exp_date'],
            'status': element['status']
          };
          searchSp.value.add(data);
        }
        updateListStatus();
      } else {
        UtilsAlert.showToast('yah error');
      }
    });
  }

  Future<void> searchTeguranLisan(em_id) async {
    searchTl.value.clear();
    Map<String, dynamic> body = {
      'em_id': em_id,
    };

    var connect = Api.connectionApi("post", body, 'teguran_lisan_search');
    await connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        print('ini tl $valueBody');
        for (var element in valueBody['data']) {
          var data = {
            'nomor': element['nomor'],
            'nama': element['nama'],
            'exp': element['exp_date'],
            'status': element['status']
          };
          searchTl.value.add(data);
        }
        print(valueBody);
        updateListStatus();
      } else {
        UtilsAlert.showToast('yah error');
      }
    });
  }

  void loadSuratPeringatan(status) {
    print("data sp");
    var urlLoad = valuePolaPersetujuan.value == "1"
        ? "spesifik_approval"
        : "spesifik_approval_multi";
    listNotModif.value.clear();
    listData.value.clear();
    listDataAll.value.clear();
    var dataUser = AppData.informasiUser;
    var getEmCode = dataUser![0].em_id;
    Map<String, dynamic> body = {
      'em_id': getEmCode,
      'name_data': 'surat_peringatan',
      'bulan': bulanSelected.value,
      'tahun': tahunSelected.value,
      'status': status == "riwayat" ? '' : 'pending',
    };
    var connect = Api.connectionApi("post", body, urlLoad);
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        // Get.snackbar("tes555 :", '${valueBody['data']}');
        print("value body ${valueBody}");
        if (valueBody['data'].length == 0) {
          loadingString.value = 'Tidak ada pengajuan';
        }
        var filteredData = valueBody['data'];
        if (status == "riwayat") {
          filteredData = valueBody['data'].where((element) {
            print("Status element: ${element['approve_status']}");
            return element['approve_status'] != 'Pending';
          }).toList();
        }
        debugPrint("Filtered data: $filteredData", wrapWidth: 5000);

        listNotModif.value = filteredData;
        for (var element in filteredData) {
          var fullName = element['full_name'] ?? "";
          var convertNama = "$fullName";
          // var tanggalDari = Constanst.convertDate1("${element['atten_date']}");
          // var tanggalSampai = Constanst.convertDate1("${element['atten_date']}");
          var filterStatus = element['leave_status'];
          var data = {
            'id': element['id'],
            'nama_pengaju': convertNama,
            'emId_pengaju': element['em_id'],
            'em_id': element['em_id'],
            'title_ajuan': 'Surat Peringatan',
            'tanggal_ajuan': element['atten_date'],
            'waktu_dari': "-",
            'waktu_sampai': "-",
            'durasi': element['leave_duration'],
            'nama': element['nama'],
            'leave_status': filterStatus,
            'delegasi': element['em_delegation'],
            'nama_approve1': element['approve_by'],
            'nama_approve2': element['approve2_by'],
            'waktu_pengajuan': element['atten_date'],
            'catatan': element['reason'],
            'type': 'Surat Peringatan',
            'category': element['category'],
            'lainnya': "",
            'file': element['req_file'] ?? "",
            'uraian': element['uraian'],
            'nomor_ajuan': element['nomor_ajuan'],
            'em_report_to': element['em_report_to'],
            'em_report2_to': element['em_report2_to'],
            'nama_divisi': element['nama_divisi'],
            'place_in': element['place_in'],
            'place_out': element['place_out'],
            'approve_id': element['approve_id'],
            'approve_by': element['approve_by'],
            'approve_date': element['approve_date'],
            'status': element['status'],
            'approve_status': element['approve_status'],
            'approve2_status': element['approve2_status'],
            'catatan_masuk': element['catatan_masuk'],
            'catatan_keluar': element['catatan_keluar'],
            'lokasi_masuk': element['lokasi_masuk'],
            'lokasi_keluar': element['lokasi_keluar'],
            'foto_masuk': element['foto_masuk'],
            'foto_keluar': element['foto_keluar'],
          };
          listData.value.add(data);
          listDataAll.value.add(data);
        }
        this.listData.refresh();
        this.listNotModif.refresh();
      }
    });
  }

  void aksiMenyetujuiSp(pilihan) {
    List dataEditFinal = [];
    for (var element in listNotModif.value) {
      if (element['id'] == detailData[0]['id']) {
        dataEditFinal.add(element);
      }
    }
    Map<String, dynamic> body = {
      'nomor_ajuan': detailData[0]['nomor_ajuan'].toString(),
      'em_id': AppData.informasiUser![0].em_id,
      'tanggal': formatDate(detailData[0]['tanggal_ajuan'].toString()),
      'status': pilihan == 'Tolak' ? 'Rejected' : 'Approve',
      'id': detailData[0]['id'].toString(),
      'alasan': alasanReject.value.text,
      'tipe_sp': detailData[0]['nama'].toString(),
      'approval_id': AppData.informasiUser![0].em_id,
      'list_konsekuensi': konsekuemsiList,
      'konsekuesi':
          statusPemgajuanSP.value == '' ? 'none' : statusPemgajuanSP.value
    };
    print("body approval 1 ${body.toString()}");
    var connect = Api.connectionApi("post", body, "surat_peringatan/approval");
    connect.then((dynamic res) {
      var dt = DateTime.now();

      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        print("response valueBody ${valueBody.toString()}");
        Get.back();
        Get.back();
        Get.back();
        Get.back();
        if (statusPemgajuanSP.value == 'potong_cuti') {
          cariEmployee(dataEditFinal);
        }
        startLoadData(
            'Surat Peringatan', "${dt.month}", "${dt.year}", 'persetujuan');
      }
    });
  }

  void fetchAlasan(id) {
    print("info delegasi");
    isLoadingAlasan.value = true;
    var connect = Api.connectionApi("get", {}, "surat_peringatan/${id}/alasan");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        isLoadingAlasan.value = false;
        listAlasan.value = valueBody['data'];
      }
    });
  }

  void fetchAlasanTeguranLisan(id) {
    isLoadingAlasan.value = true;
    var connect = Api.connectionApi("get", {}, "teguran_lisan/${id}");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        isLoadingAlasan.value = false;
        listAlasan.value = valueBody['data'];
      }
    });
  }

  void loadTeguranLisan(status) {
    var urlLoad = valuePolaPersetujuan.value == "1"
        ? "spesifik_approval"
        : "spesifik_approval_multi";
    listNotModif.value.clear();
    listData.value.clear();
    listDataAll.value.clear();
    var dataUser = AppData.informasiUser;
    var getEmCode = dataUser![0].em_id;
    Map<String, dynamic> body = {
      'em_id': getEmCode,
      'name_data': 'teguran_lisan',
      'bulan': bulanSelected.value,
      'tahun': tahunSelected.value,
      'status': status == "riwayat" ? '' : 'pending',
    };
    var connect = Api.connectionApi("post", body, urlLoad);
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        // Get.snackbar("tes555 :", '${valueBody['data']}');
        print("value body ${valueBody}");
        if (valueBody['data'].length == 0) {
          loadingString.value = 'Tidak ada pengajuan';
        }
        var filteredData = valueBody['data'];
        if (status == "riwayat") {
          filteredData = valueBody['data'].where((element) {
            print("Status element: ${element['approve_status']}");
            return element['approve_status'] != 'Pending';
          }).toList();
        }
        debugPrint("Filtered data: $filteredData", wrapWidth: 5000);

        listNotModif.value = filteredData;
        for (var element in filteredData) {
          var fullName = element['full_name'] ?? "";
          var convertNama = "$fullName";
          var filterStatus = element['leave_status'];
          var data = {
            'id': element['id'],
            'nama_pengaju': convertNama,
            'emId_pengaju': element['em_id'],
            'em_id': element['em_id'],
            'title_ajuan': 'Surat teguran Lisan',
            'tanggal_ajuan': element['atten_date'],
            'waktu_dari': "-",
            'waktu_sampai': "-",
            'durasi': element['leave_duration'],
            'nama': element['nama'],
            'leave_status': filterStatus,
            'delegasi': element['em_delegation'],
            'nama_approve1': element['approve_by'],
            'nama_approve2': element['approve2_by'],
            'waktu_pengajuan': element['atten_date'],
            'catatan': element['pelangaran'],
            'type': 'Teguran Lisan',
            'category': element['category'],
            'lainnya': "",
            'file': element['req_file'] ?? "",
            'uraian': element['uraian'],
            'nomor_ajuan': element['nomor_ajuan'],
            'em_report_to': element['em_report_to'],
            'em_report2_to': element['em_report2_to'],
            'nama_divisi': element['nama_divisi'],
            'place_in': element['place_in'],
            'place_out': element['place_out'],
            'approve_id': element['approve_id'],
            'approve_by': element['approve_by'],
            'approve_date': element['approve_date'],
            'status': element['status'],
            'approve_status': element['approve_status'],
            'approve2_status': element['approve2_status'],
            'catatan_masuk': element['catatan_masuk'],
            'catatan_keluar': element['catatan_keluar'],
            'lokasi_masuk': element['lokasi_masuk'],
            'lokasi_keluar': element['lokasi_keluar'],
            'foto_masuk': element['foto_masuk'],
            'foto_keluar': element['foto_keluar'],
          };
          listData.value.add(data);
          listDataAll.value.add(data);
        }
        this.listData.refresh();
        this.listNotModif.refresh();
      }
    });
  }

  void aksiMenyetujuiTeguranLisan(pilihan) {
    Map<String, dynamic> body = {
      'nomor_ajuan': detailData[0]['nomor_ajuan'].toString(),
      'em_id': AppData.informasiUser![0].em_id,
      'tanggal': formatDate(detailData[0]['tanggal_ajuan'].toString()),
      'status': pilihan == 'Tolak' ? 'Rejected' : 'Approve',
      'id': detailData[0]['id'].toString(),
      'alasan': alasanReject.value.text
    };
    print("body approval 1 ${body.toString()}");
    var connect = Api.connectionApi("post", body, "teguran_lisan/approval");
    connect.then((dynamic res) {
      var dt = DateTime.now();

      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        print("response valueBody ${valueBody.toString()}");
        Get.back();
        Get.back();
        Get.back();

        startLoadData(
            'Teguran Lisan', "${dt.month}", "${dt.year}", 'persetujuan');
      }
    });
  }

  void aksiMenyetujuiShift(pilihan) {
    Map<String, dynamic> body = {
      'nomor_ajuan': detailData[0]['nomor_ajuan'].toString(),
      'em_id': AppData.informasiUser![0].em_id,
      'tanggal': formatDate(detailData[0]['waktu_pengajuan'].toString()),
      'status': pilihan == 'Tolak' ? 'Rejected' : 'Approve',
      'id': detailData[0]['id'].toString(),
      'alasan': alasan1.value.text == '' ? alasan2.value.text : alasan1.value.text
    };
    var connect = Api.connectionApi("post", body, "shift/approval");
    connect.then((dynamic res) {
      var dt = DateTime.now();
      if (res.statusCode == 200) {
        Get.back();
        Get.back();
        Get.back();
        startLoadData(
            'Shift', "${dt.month}", "${dt.year}", 'persetujuan');
      } else{
        UtilsAlert.showToast('gagal approve shift');
      }
    });
  }

  void loadDataTugasLuar(status) {
    var urlLoad = valuePolaPersetujuan.value == "1"
        ? "spesifik_approval"
        : "spesifik_approval_multi";
    listNotModif.value.clear();
    listData.value.clear();
    listDataAll.value.clear();
    var dataUser = AppData.informasiUser;
    var getEmCode = dataUser![0].em_id;
    var body = {
      'em_id': getEmCode,
      'name_data': 'tugas_luar',
      'bulan': bulanSelected.value,
      'tahun': tahunSelected.value,
      'status': status == "riwayat" ? '' : 'pending',
    };
    var connect = Api.connectionApi("post", body, urlLoad);
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        if (valueBody['data'].length == 0) {
          loadingString.value = 'Tidak ada pengajuan';
        }
        ;
        listNotModif.value = valueBody['data'];
        print("data tugas ${valueBody['data']}");
        for (var element in valueBody['data']) {
          var fullName = element['full_name'] ?? "";
          var convertNama = "$fullName";
          var filterStatus =
              element['status'] == "Approve" ? "Approve 1" : element['status'];
          var data = {
            'id': element['id'],
            'nama_pengaju': convertNama,
            'title_ajuan': 'Pengajuan Tugas Luar',
            'waktu_dari': element['dari_jam'],
            'waktu_sampai': element['sampai_jam'],
            'durasi': '',
            'leave_status': filterStatus,
            'delegasi': element['em_delegation'],
            'nama_approve1': element['approve_by'],
            'approve_status': element['approve_status'],
            'approve2_status': element['approve2_status'],
            'nama_approve2': element['approve2_by'],
            'waktu_pengajuan': element['atten_date'],
            'catatan': element['uraian'],
            'type': 'Tugas Luar',
            'category': element['category'],
            'lainnya': "",
            'file': '',
            'em_report_to': element['em_report_to'],
            'em_report2_to': element['em_report2_to'],
            'nama_divisi': element['nama_divisi'],
            'nomor_ajuan': element['nomor_ajuan'],
            'image': element['image'],
          };
          listData.value.add(data);
          listDataAll.value.add(data);
        }
        listData.value.sort(
            (a, b) => b['waktu_pengajuan'].compareTo(a['waktu_pengajuan']));
        this.listData.refresh();
        this.listNotModif.refresh();
      }
    });
  }

  void loadDataPayroll() {}

  void loadDataDinasLuar(status) {
    var urlLoad = valuePolaPersetujuan.value == "1"
        ? "spesifik_approval"
        : "spesifik_approval_multi";
    listNotModif.value.clear();
    listData.value.clear();
    listDataAll.value.clear();
    var dataUser = AppData.informasiUser;
    var getEmCode = dataUser![0].em_id;
    var body = {
      'em_id': getEmCode,
      'name_data': 'dinas_luar',
      'bulan': bulanSelected.value,
      'tahun': tahunSelected.value,
      'status': status == "riwayat" ? '' : 'pending',
    };
    var connect = Api.connectionApi("post", body, urlLoad);
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        print(valueBody);
        if (valueBody['data'].length == 0) {
          loadingString.value = 'Tidak ada pengajuan';
        }
        ;
        listNotModif.value = valueBody['data'];
        for (var element in valueBody['data']) {
          var fullName = element['full_name'] ?? "";
          var convertNama = "$fullName";
          var tanggalDari = Constanst.convertDate1("${element['start_date']}");
          var tanggalSampai = Constanst.convertDate1("${element['end_date']}");
          var filterStatus = element['leave_status'] == "Approve"
              ? "Approve 1"
              : element['leave_status'];
          var data = {
            'id': element['id'],
            'nama_pengaju': convertNama,
            'title_ajuan': 'Pengajuan Dinas Luar',
            'waktu_dari': tanggalDari,
            'waktu_sampai': tanggalSampai,
            'durasi': element['leave_duration'],
            'leave_status': filterStatus,
            'delegasi': element['em_delegation'],
            'nama_approve1': element['apply_by'],
            'nama_approve2': element['apply2_by'],
            'waktu_pengajuan': element['atten_date'],
            'catatan': element['reason'],
            'type': "Dinas Luar",
            'category': "",
            'lainnya': "",
            'file': element['leave_files'],
            'em_report_to': element['em_report_to'],
            'em_report2_to': element['em_report2_to'],
            'nama_divisi': element['nama_divisi'],
            'nomor_ajuan': element['nomor_ajuan'],
            'image': element['image'],
            'apply_status': element['apply_status'],
            'apply2_status': element['apply2_status'],
          };
          listData.value.add(data);
          listDataAll.value.add(data);
        }
        listData.value.sort(
            (a, b) => b['waktu_pengajuan'].compareTo(a['waktu_pengajuan']));
        this.listData.refresh();
        this.listNotModif.refresh();
      }
    });
  }

  void loadDataKlaim(status) {
    var urlLoad = valuePolaPersetujuan.value == "1"
        ? "spesifik_approval"
        : "spesifik_approval_multi";
    listNotModif.value.clear();
    listData.value.clear();
    listDataAll.value.clear();
    var dataUser = AppData.informasiUser;
    var getEmCode = dataUser![0].em_id;
    var body = {
      'em_id': getEmCode,
      'name_data': 'klaim',
      'bulan': bulanSelected.value,
      'tahun': tahunSelected.value,
      'status': status == "riwayat" ? '' : 'pending',
    };
    var connect = Api.connectionApi("post", body, urlLoad);
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        print('ini data klaim $valueBody');
        if (valueBody['data'].length == 0) {
          loadingString.value = 'Tidak ada pengajuan';
        }
        listNotModif.value = valueBody['data'];
        for (var element in valueBody['data']) {
          var fullName = element['full_name'] ?? "";
          var convertNama = "$fullName";
          DateTime fltr1 = DateTime.parse("${element['tgl_ajuan']}");
          DateTime fltr2 = DateTime.parse("${element['created_on']}");
          var tanggalDari = "${DateFormat('dd-MM-yyyy').format(fltr1)}";
          var tanggalSampai = "${DateFormat('dd-MM-yyyy').format(fltr1)}";
          var tanggalPembuatan = "${DateFormat('yyyy-MM-dd').format(fltr2)}";
          var filterStatus =
              element['status'] == "Approve" ? "Approve 1" : element['status'];
          var data = {
            'id': element['id'],
            'nama_pengaju': convertNama,
            'title_ajuan': 'Pengajuan Klaim',
            'waktu_dari': tanggalDari,
            'waktu_sampai': "",
            'durasi': "",
            'leave_status': filterStatus,
            'delegasi': "",
            'nama_approve1': element['approve_by'],
            'nama_approve2': element['approve2_by'],
            'waktu_pengajuan': tanggalPembuatan,
            'catatan': element['description'],
            'type': "Klaim",
            'category': element['category'],
            'lainnya': element,
            'file': element['nama_file'],
            'em_report_to': element['em_report_to'],
            'em_report2_to': element['em_report2_to'],
            'nama_divisi': element['nama_divisi'],
            'nomor_ajuan': element['nomor_ajuan'],
            'image': element['image'],
            "id_ajuan": element["id_ajua"],
            "saldo_klaim": element['saldo_claim'],
            "sisa_klaim": element['sisa_claim']
          };
          listData.value.add(data);
          listDataAll.value.add(data);
        }
        listData.value.sort(
            (a, b) => b['waktu_pengajuan'].compareTo(a['waktu_pengajuan']));
        this.listData.refresh();
        this.listNotModif.refresh();
      }
    });
  }

  void cariData(value) {
    var textCari = value.toLowerCase();
    var filter = listDataAll.where((laporan) {
      var namaEmployee = laporan['nama_pengaju'].toLowerCase();
      return namaEmployee.contains(textCari);
    }).toList();
    listData.value = filter;
    statusCari.value = true;
    this.listData.refresh();
    this.statusCari.refresh();
  }

  void getDetailData(idxDetail, emId, title, delegasi) {
    if (title.toString().toLowerCase().contains('cuti')) {
      loadCutiPengaju(emId);
    }
    if (title != "Klaim") {
      infoDelegasi(delegasi);
    }
    detailData.value.clear();
    for (var element in listData.value) {
      if ("${element['id']}" == "$idxDetail") {
        detailData.value.add(element);
        print('detail data ${detailData.value}');
      }
    }
    this.detailData.refresh();
  }

  void infoDelegasi(delegasi) {
    print("info delegasi");
    var body = {
      'val': 'em_id',
      'cari': delegasi,
    };
    var connect = Api.connectionApi("post", body, "whereOnce-employee");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        print(valueBody);
        fullNameDelegasi.value = valueBody['data'][0]['full_name'];
        this.fullNameDelegasi.refresh();
      }
    });
  }

  void updateTotalPercentage() {
    int total = 0;
    int count = taskControllers.length;

    for (var controller in taskControllers) {
      int value = int.tryParse(controller.text) ?? 0;
      total += value;
    }

    // Ubah hasil pembagian ke tipe double
    totalPercentage.value = count > 0 ? (total / count).toDouble() : 0.0;
  }

  void infoTask(emPengaju) {
    listTask.clear();
    taskControllers.clear();
    var body = {'nomor_ajuan': emPengaju};
    var connect = Api.connectionApi("post", body, "lembur/detail");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        debugPrint('ini data task $valueBody');
        if (valueBody['data'] is List) {
          double totalPercentage = 0.0;
          for (var task in valueBody['data']) {
            listTask.add(task);
            taskControllers.add(TextEditingController());
            print('task: $listTask');
            double taskPercentage =
                double.tryParse(task['persentase'].toString()) ?? 0.0;
            totalPercentage += taskPercentage;
            totalPercent.value = double.parse(
                (totalPercentage / listTask.length).toStringAsFixed(2));
            ;
          }
          listTask.refresh();
          taskControllers.refresh();
        } else {
          print('Unexpected data format');
        }
      } else {
        print('Failed to fetch tasks: ${res.statusCode} : ${res.body}');
      }
    }).catchError((e) {
      print('Error fetching tasks: $e');
    });
  }

  void infoIds(emIds) {
    var listEmId = emIds.split(",");
    print("info delegasi");
    fullNameApprove2.clear();
    for (var emId in listEmId) {
      var body = {
        'val': 'em_id',
        'cari': emId,
      };
      var connect = Api.connectionApi("post", body, "whereOnce-employee");
      connect.then((dynamic res) {
        if (res.statusCode == 200) {
          var valueBody = jsonDecode(res.body);
          if (valueBody['data'] is List && valueBody['data'].isNotEmpty) {
            var fullName = valueBody['data'][0]['full_name'];
            print('Full name for $emId: $fullName');
            print('lah ini dong yang kepangggil');
            fullNameApprove2.add(fullName);
          } else if (valueBody['data'] is Map) {
            var fullName = valueBody['data']['full_name'];
            print('Full name for $emId: $fullName');
            print('ini kepanggil');
            fullNameApprove2.add(fullName);
          } else {
            print('Unexpected data format for $emId');
          }
        }
      }).catchError((e) {
        print('Error fetching data for $emId: $e');
      });
    }
  }

  String convertToIdr(dynamic number, int decimalDigit) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: decimalDigit,
    );
    return currencyFormatter.format(number);
  }

  void loadCutiPengaju(emId) {
    print("load cuti pengajuan");
    var body = {
      'val': 'em_id',
      'cari': emId,
    };
    var connect = Api.connectionApi("post", body, "whereOnce-assign_leave");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        print('dat cuti ${res.body}');
        var valueBody = jsonDecode(res.body);
        if (valueBody['data'].isNotEmpty) {
          var totalDay = valueBody['data'][0]['total_day'];
          var terpakai = valueBody['data'][0]['terpakai'];
          print("ini data cuti user ${valueBody['data']}");
          jumlahCuti.value = totalDay;
          cutiTerpakai.value = terpakai;
          this.jumlahCuti.refresh();
          this.cutiTerpakai.refresh();
          statusHitungCuti.value = true;
          hitungCuti(totalDay, terpakai);
          this.statusHitungCuti.refresh();
        } else {
          statusHitungCuti.value = false;
          this.statusHitungCuti.refresh();
        }
      } else {
        print('erro data cuti user ${res.body}');
      }
    });
  }

  void hitungCuti(totalDay, terpakai) {
    var hitung1 = (terpakai / totalDay) * 100;
    // var convert1 = hitung1.toInt();
    var convert1 = hitung1;
    var convertedValue =
        double.parse("${convert1 > 100 || convert1 < 0 ? "100" : convert1}") /
            100;
    persenCuti.value = convertedValue;
    this.persenCuti.refresh();
  }

  void showBottomAlasanReject() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Iconsax.close_circle,
                        color: Colors.red,
                        size: 24,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8, top: 2),
                        child: Text(
                          "Alasan Tolak Pengajuan",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: Constanst.borderStyle1,
                        border: Border.all(
                            width: 1.0,
                            color: Color.fromARGB(255, 211, 205, 205))),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 8,
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: TextField(
                        cursorColor: Colors.black,
                        controller: alasanReject.value,
                        maxLines: null,
                        maxLength: 225,
                        autofocus: true,
                        decoration: new InputDecoration(
                            border: InputBorder.none,
                            hintText: "Alasan Menolak"),
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.done,
                        style: TextStyle(
                            fontSize: 12.0, height: 2.0, color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButtonWidget(
                          title: "Kembali",
                          onTap: () => Navigator.pop(Get.context!),
                          colorButton: Colors.red,
                          colortext: Colors.white,
                          border: BorderRadius.circular(8.0),
                        ),
                      )),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButtonWidget(
                          title: "Tolak",
                          onTap: () {
                            if (alasanReject.value.text != "") {
                              Navigator.pop(Get.context!);
                              validasiMenyetujui(false);
                            } else {
                              UtilsAlert.showToast(
                                  "Harap isi alasan terlebih dahulu");
                            }
                          },
                          colorButton: Constanst.colorPrimary,
                          colortext: Colors.white,
                          border: BorderRadius.circular(8.0),
                        ),
                      ))
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30,
            )
          ],
        );
      },
    );
  }

  void validasiMenyetujui(pilihan) {
    int styleChose = pilihan == false ? 1 : 2;
    var stringPilihan = pilihan == false ? 'Tolak' : 'Menyetujui';
    showGeneralDialog(
      barrierDismissible: false,
      context: Get.context!,
      barrierColor: Colors.black54, // space around dialog
      transitionDuration: Duration(milliseconds: 200),
      transitionBuilder: (context, a1, a2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
              parent: a1,
              curve: Curves.elasticOut,
              reverseCurve: Curves.easeOutCubic),
          child: CustomDialog(
            // our custom dialog
            title: "Peringatan",
            content: "Yakin $stringPilihan Pengajuan ini ?",
            positiveBtnText: "Lanjutkan",
            negativeBtnText: "Kembali",
            style: styleChose,
            buttonStatus: 1,
            positiveBtnPressed: () {
              print("data detail ${detailData[0]['type']}");
              // if (detailData[0]['type'] == 'absensi' ||
              //     detailData[0]['type'] == 'Absensi') {
              //   print("masuk sini  ${detailData[0]['type']}");

              //   approvalAbsensi(
              //       pilihan: pilihan,
              //       date: detailData[0]['waktu_pengajuan'].toString(),
              //       leaveStatus: detailData[0]['leave_status'].toString(),
              //       status: styleChose.toString(),
              //       checkin: detailData[0]['dari_jam'].toString(),
              //       checkout: detailData[0]['sampai_jam'].toString(),
              //       image: detailData[0]['file'].toString(),
              //       note: detailData[0]['deskripsi'].toString(),
              //       ajuanEmid: detailData[0]['em_id'].toString(),
              //       id: detailData[0]['id'].toString());
              // } else {
              //   print("Aksi menyetujui  ${detailData[0]['type']}");
              //   UtilsAlert.loadingSimpanData(
              //       Get.context!, "Proses $stringPilihan pengajuan");
              //   aksiMenyetujui(pilihan);
              // }
              // controllerGlobal.kirimNotifikasi(
              //     title: 'Izin',
              //     status: 'approve',
              //     pola: controllerGlobal.valuePolaPersetujuan.value.toString(),
              //     statusApproval: valuePolaPersetujuan == 1 ||
              //             valuePolaPersetujuan == "1"
              //         ? "1"
              //         : valuePolaPersetujuan == 2 || valuePolaPersetujuan == "2"
              //             ? detailData[0]['nama_approve1'] == "" ||
              //                     detailData[0]['nama_approve1'] == "null" ||
              //                     detailData[0]['nama_approve1'] == null
              //                 ? "1"
              //                 : "2"
              //             : "1",
              //     emId: AppData.informasiUser![0].em_id,
              //     nomor: detailData[0]['nomor_ajuan']);
            },
          ),
        );
      },
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return null!;
      },
    );
  }

  void validasiMenyetujui1(pilihan) {
    int styleChose = pilihan == false ? 1 : 2;
    var stringPilihan = pilihan == false ? 'Tolak' : 'Menyetujui';
    showGeneralDialog(
      barrierDismissible: false,
      context: Get.context!,
      barrierColor: Colors.black54, // space around dialog
      transitionDuration: Duration(milliseconds: 200),
      transitionBuilder: (context, a1, a2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
              parent: a1,
              curve: Curves.elasticOut,
              reverseCurve: Curves.easeOutCubic),
          child: CustomDialog(
            // our custom dialog
            title: "Peringatan",
            content: "Yakin $stringPilihan Pengajuan ini ?",
            positiveBtnText: "Lanjutkan",
            negativeBtnText: "Kembali",
            style: styleChose,
            buttonStatus: 1,
            positiveBtnPressed: () {},
          ),
        );
      },
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return null!;
      },
    );
  }

  void aksiMenyetujui(pilihan) {
    print("object ${detailData[0]['type']}");
    List dataEditFinal = [];
    for (var element in listNotModif.value) {
      if (element['id'] == detailData[0]['id']) {
        dataEditFinal.add(element);
      }
    }
    var listKonsekuensi = '';
    print(konsekuemsiList);
    listKonsekuensi =
        konsekuemsiList.map((item) => item['konsekuensi']).join(',');
    var statusPengajuannew = '';
    print("ini valuepola persetujuan${valuePolaPersetujuan.value}");
    if (detailData[0]['type'] == 'Cuti' ||
        detailData[0]['type'] == "Izin" ||
        detailData[0]['type'] == "Sakit") {
      print('kesini lgak');
      if (valuePolaPersetujuan.value == '1' ||
          valuePolaPersetujuan.value == 1) {
        statusPengajuannew = statusPemgajuanIzin.value;
        // listKonsekuensi = konsekuemsiList.map((item) => item['konsekuensi']).join(',');
        print('ini list konsekuensi ${listKonsekuensi}');
      } else if (valuePolaPersetujuan.value == '2' ||
          valuePolaPersetujuan.value == 2) {
        if (dataEditFinal[0]['leave_status'] == 'Pending' ||
            dataEditFinal[0]['leave_status'] == 'Approve1' ||
            dataEditFinal[0]['leave_status'] == 'Approve 1') {
          // listKonsekuensi = konsekuemsiList.map((item) => item['konsekuensi']).join(',');
          print('ini list konsekuensi ${listKonsekuensi}');
        } else {
          // listKonsekuensi = konsekuemsiList.map((item) => item['konsekuensi']).join(',');
          print('ini list konsekuensi ${listKonsekuensi}');
        }
      }
    }

    var dt = DateTime.now();
    var dateString = "${dt.day}-${dt.month}-${dt.year}";
    var tanggalNow = Constanst.convertDateSimpan(dateString);
    print(dataEditFinal);
    print("type ${detailData[0]['type']}");
    var url_tujuan;

    if (detailData[0]['type'] == 'Klaim') {
      url_tujuan = 'edit-emp_claim';
    } else {
      url_tujuan = detailData[0]['type'] == 'Tugas Luar' ||
              detailData[0]['type'] == 'Lembur' &&
                  detailData[0]['dinilai'] == 'N'
          ? 'edit-emp_labor-approval'
          : detailData[0]['type'] == 'Lembur' && detailData[0]['dinilai'] == 'Y'
              ? 'edit-emp_labor-approval-task'
              : detailData[0]['type'] == 'wfh'
                  ? 'wfh-approval'
                  : 'edit-emp_leave-approval';
    }

    if (valuePolaPersetujuan.value == "1") {
      if (pilihan == true && url_tujuan == "edit-emp_leave-approval") {
        print("kesiniiii atuh");
        validasiPemakaianCuti(dataEditFinal);
      }
    } else {
      if (pilihan == true && url_tujuan == "edit-emp_leave-approval") {
        if (dataEditFinal[0]['leave_status'] == "Approve") {
          print("kesiniiii atuh");
          validasiPemakaianCuti(dataEditFinal);
        }
      }
    }
    var dataUser = AppData.informasiUser;
    var getEmpid = dataUser![0].em_id;
    var fullName = dataUser[0].full_name ?? "";
    var namaAtasanApprove = "$fullName";

    var statusPengajuan = "";
    var applyDate1 = "";
    var applyBy1 = "";
    var applyId1 = "";
    var applyStatus = null;

    var applyDate2 = "";
    var applyBy2 = "";
    var applyId2 = "";
    var apply2Status = null;
    print("tes wfh 22 ${tanggalNow}");
    if (valuePolaPersetujuan.value == "1") {
      statusPengajuan = pilihan == true ? 'Approve' : 'Rejected';
      applyDate1 = tanggalNow;
      applyBy1 = namaAtasanApprove;
      applyId1 = "$getEmpid";
      applyStatus = statusPengajuan;
      applyDate2 = "";
      applyBy2 = "";
      applyId2 = "";
      apply2Status = null;
    } else {
      if (url_tujuan == "edit-emp_leave-approval") {
        print("tes wfh ${tanggalNow}");
        if (dataEditFinal[0]['leave_status'] == "Pending") {
          statusPengajuan = pilihan == true ? 'Approve' : 'Rejected';
          applyDate1 = tanggalNow;
          applyBy1 = namaAtasanApprove;
          applyId1 = "$getEmpid";
          applyStatus = pilihan == true ? 'Approve' : 'Rejected';
          applyDate2 = "";
          applyBy2 = "";
          applyId2 = "";
          apply2Status = "Pending";
        } else if (dataEditFinal[0]['leave_status'] == "Approve") {
          // print("tes wfh ${tanggalNow}");
          statusPengajuan = pilihan == true ? 'Approve2' : 'Rejected';
          applyDate1 = dataEditFinal[0]['apply_date'];
          applyBy1 = dataEditFinal[0]['apply_by'];
          applyId1 = dataEditFinal[0]['apply_id'];

          applyStatus = dataEditFinal[0]['apply_status'];

          applyDate2 = tanggalNow;
          applyBy2 = namaAtasanApprove;
          applyId2 = "$getEmpid";
          apply2Status = pilihan == true ? 'Approve' : 'Rejected';
        }
      } else {
        print("tes wfh status ${dataEditFinal[0]['status']}");
        if (dataEditFinal[0]['status'] == "Pending") {
          print("tes wfh ${tanggalNow}");
          statusPengajuan = pilihan == true ? 'Approve' : 'Rejected';

          applyDate1 = tanggalNow;
          applyBy1 = namaAtasanApprove;
          applyId1 = "$getEmpid";
          applyDate2 = "";
          applyBy2 = "";
          applyId2 = "";
          applyStatus = pilihan == true ? 'Approve' : 'Rejected';
          apply2Status = 'Pending';
        } else if (dataEditFinal[0]['status'] == "Approve") {
          print("tes wfh ${tanggalNow}");
          statusPengajuan = pilihan == true ? 'Approve2' : 'Rejected';
          applyDate1 = dataEditFinal[0]['approve_date'];
          applyBy1 = dataEditFinal[0]['approve_by'];
          applyId1 = dataEditFinal[0]['approve_id'].toString();
          applyStatus = dataEditFinal[0]['approve_status'].toString();
          apply2Status = pilihan == true ? 'Approve' : 'Rejected';
          applyDate2 = tanggalNow;
          applyBy2 = namaAtasanApprove;
          applyId2 = "$getEmpid";
        }
      }
    }
    double totalPercentage = 0.0;
    for (var task in listTask) {
      double taskPercentage =
          double.tryParse(task['persentase'].toString()) ?? 0.0;
      totalPercentage += taskPercentage;
    }
    totalPercent.value =
        double.parse((totalPercentage / listTask.length).toStringAsFixed(2));
    print('total persen $totalPercent');
    var alasanRejectShow = alasanReject.value.text != ""
        ? ", Alasan pengajuan di tolak = ${alasanReject.value.text}"
        : "";
    if (url_tujuan == 'edit-emp_leave-approval') {
      // emp_leave
      var body = {
        'em_id': dataEditFinal[0]['em_id'],
        'typeid': dataEditFinal[0]['typeid'],
        'leave_type': dataEditFinal[0]['leave_type'],
        'start_date': dataEditFinal[0]['start_date'],
        'end_date': dataEditFinal[0]['end_date'],
        'leave_duration': dataEditFinal[0]['leave_duration'],
        'approve_date': applyDate1,
        'approve_by': applyBy1,
        'approve_id': applyId1,
        'approve2_date': applyDate2,
        'approve2_by': applyBy2,
        'approve2_id': applyId2,
        'alasan_reject': alasanReject.value.text,
        'reason': dataEditFinal[0]['reason'],
        'leave_status': statusPengajuan,
        'atten_date': dataEditFinal[0]['atten_date'],
        'em_delegation': dataEditFinal[0]['em_delegation'],
        'leave_files': dataEditFinal[0]['leave_files'],
        'ajuan': dataEditFinal[0]['ajuan'],
        'created_by': getEmpid,
        'menu_name': detailData[0]['type'],
        'val': 'id',
        'cari': dataEditFinal[0]['id'],
        'activity_name':
            "$statusPengajuan Pengajuan ${detailData[0]['type']} pada tanggal $tanggalNow. Pengajuan atas nama ${detailData[0]['nama_pengaju']} $alasanRejectShow",
        'apply_status': applyStatus,
        'apply2_status': apply2Status,
        'konsekuensi': listKonsekuensi,
        'tipe_surat': statusPemgajuanIzin.value,
      };

      print("body new ${body}");

      var connect = Api.connectionApi("post", body, "edit-emp_leave-approval");
      connect.then((dynamic res) {
        print('kesini gak sih lu');
        if (res.statusCode == 200) {
          if (pilihan == true) {
            if (valuePolaPersetujuan.value == '1') {
              if (statusPengajuan == 'Approve') {
                insertAbsensiUserAfterApprove(dataEditFinal);
              }
            } else {
              if (statusPengajuan == 'Approve2') {
                insertAbsensiUserAfterApprove(dataEditFinal);
              }
            }
          }
          print('berhasil sampai sini edit emp leave');
          print('pola persetujuan ${valuePolaPersetujuan.value}');
          print('pilihan $pilihan');
          print('status pengajuan $statusPengajuan');
          insertNotifikasi(dataEditFinal, statusPengajuan, tanggalNow, dt,
              pilihan, namaAtasanApprove, url_tujuan, alasanRejectShow);
        } else {
          print('gagal appproveeeee');
        }
      });
    } else if (url_tujuan == 'edit-emp_labor-approval' ||
        url_tujuan == 'edit-emp_labor-approval-task') {
      var body = {
        'em_id': dataEditFinal[0]['em_id'],
        'dari_jam': dataEditFinal[0]['dari_jam'],
        'sampai_jam': dataEditFinal[0]['sampai_jam'],
        'atten_date': dataEditFinal[0]['atten_date'],
        'status': statusPengajuan,
        'approve_date': applyDate1,
        'approve_by': applyBy1,
        'approve_id': applyId1,
        'approve2_date': applyDate2,
        'approve2_by': applyBy2,
        'approve2_id': applyId2,
        'tasks': listTask,
        'total_persentase': totalPercent.isNaN ? 0.0 : totalPercent.value,
        'alasan1': alasan1.value.text,
        'alasan2': alasan2.value.text,
        'em_delegation': dataEditFinal[0]['em_delegation'],
        'uraian': dataEditFinal[0]['uraian'],
        'ajuan': dataEditFinal[0]['ajuan'],
        'created_by': getEmpid,
        'menu_name': detailData[0]['type'],
        'val': 'id',
        'cari': dataEditFinal[0]['id'],
        'activity_name':
            "$statusPengajuan Pengajuan ${detailData[0]['type']} pada tanggal $tanggalNow. Pengajuan atas nama ${detailData[0]['nama_pengaju']} $alasanRejectShow",
        "approve_status": applyStatus,
        "approve2_status": apply2Status
      };
      print('inipersentasi cuti ${totalPercent.value}');
      print("body approval lembur ${body.toString()}");
      var connect = Api.connectionApi("post", body, url_tujuan);
      connect.then((dynamic res) {
        if (res.statusCode == 200) {
          print('response aproval lembur ${res.body}');
          print('berhasil sampai sini edit emp labor');
          insertNotifikasi(dataEditFinal, statusPengajuan, tanggalNow, dt,
              pilihan, namaAtasanApprove, url_tujuan, alasanRejectShow);
        } else {
          print('gagal ${res.statusCode} ${res.body}');
        }
      });
    } else if (url_tujuan == 'edit-emp_claim') {
      var body = {
        'status': statusPengajuan,
        'atten_date': detailData[0]['waktu_pengajuan'],
        'approve_date': applyDate1,
        'approve_by': applyBy1,
        'approve_id': applyId1,
        'approve2_date': applyDate2,
        'approve2_by': applyBy2,
        'approve2_id': applyId2,
        'alasan_reject': alasanReject.value.text,
        'created_by': getEmpid,
        'menu_name': detailData[0]['type'],
        'val': 'id',
        'cari': dataEditFinal[0]['id'],
        'activity_name':
            "$statusPengajuan Pengajuan ${detailData[0]['type']} pada tanggal $tanggalNow. Pengajuan atas nama ${detailData[0]['nama_pengaju']} $alasanRejectShow"
      };
      print("body ${body}");
      var connect = Api.connectionApi("post", body, 'edit-emp_claim');
      connect.then((dynamic res) {
        if (res.statusCode == 200) {
          print('berhasil sampai sini klaim');
          insertNotifikasiClaim(
              dataEditFinal,
              statusPengajuan,
              tanggalNow,
              dt,
              pilihan,
              namaAtasanApprove,
              url_tujuan,
              alasanRejectShow,
              detailData[0]['em_id']);
        }
      });
    } else if (url_tujuan == 'wfh-approval') {
      print('tes print');
      var body = {
        'em_id': dataEditFinal[0]['em_id'],
        'dari_jam': dataEditFinal[0]['dari_jam'],
        'sampai_jam': dataEditFinal[0]['sampai_jam'],
        'atten_date': dataEditFinal[0]['atten_date'],
        'status': statusPengajuan,
        'approve_date': applyDate1,
        'approve_by': applyBy1,
        'approve_id': applyId1,
        'approve2_date': applyDate2,
        'approve2_by': applyBy2,
        'approve2_id': applyId2,
        'alasan_reject': alasanReject.value.text,
        'em_delegation': dataEditFinal[0]['em_delegation'],
        'uraian': dataEditFinal[0]['uraian'],
        'ajuan': dataEditFinal[0]['ajuan'],
        'created_by': getEmpid,
        'menu_name': detailData[0]['type'],
        'val': 'id',
        'cari': dataEditFinal[0]['id'],
        'activity_name':
            "$statusPengajuan Pengajuan ${detailData[0]['type']} pada tanggal $tanggalNow. Pengajuan atas nama ${detailData[0]['nama_pengaju']} $alasanRejectShow",
        "approve_status": applyStatus,
        "approve2_status": apply2Status,
        'pola': controllerGlobal.valuePolaPersetujuan.value.toString(),
      };
      print("body approval ${body.toString()}");
      var connect = Api.connectionApi("post", body, "wfh-approval");
      connect.then((dynamic res) {
        if (res.statusCode == 200) {
          print('berhasil sampai sini edit emp labor');
          var pesanController = Get.find<PesanController>();
          pesanController.loadApproveInfo();
          startLoadData(titleAppbar.value, bulanSelected.value,
              tahunSelected.value, 'persetujuan');
          Navigator.pop(Get.context!);
          Navigator.pop(Get.context!);
          UtilsAlert.showToast(
              "Pengajuan ${detailData[0]['type']} berhasil di $statusPengajuan");
          Get.back();
          // insertNotifikasi(dataEditFinal, statusPengajuan, tanggalNow, dt,
          //     pilihan, namaAtasanApprove, url_tujuan, alasanRejectShow);
        }
      });
    }
  }

  String formatDate(String dateString) {
    // Parse the original date string to a DateTime object
    DateTime dateTime = DateTime.parse(dateString);

    // Format the DateTime object to 'yyyy-MM-dd'
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

    return formattedDate;
  }

  void aksiMenyetujuiKasbon(pilihan) {
    // print("object ${detailData[0]['type']}");
    // List dataEditFinal = [];
    // for (var element in listNotModif.value) {
    //   if (element['id'] == detailData[0]['id']) {
    //     dataEditFinal.add(element);
    //   }
    // }
    // var dt = DateTime.now();
    // var dateString = "${dt.day}-${dt.month}-${dt.year}";
    // var tanggalNow = Constanst.convertDateSimpan(dateString);

    // print("type ${detailData[0]['type']}");
    // var url_tujuan;

    // if (detailData[0]['type'] == 'Klaim') {
    //   url_tujuan = 'edit-emp_claim';
    // } else {
    //   url_tujuan = detailData[0]['type'] == 'Tugas Luar' ||
    //           detailData[0]['type'] == 'Lembur'
    //       ? 'edit-emp_labor'
    //       : detailData[0]['type'] == 'wfh'
    //           ? 'wfh-approval'
    //           : 'edit-emp_leave';
    // }

    // if (valuePolaPersetujuan.value == "1") {
    //   if (pilihan == true && url_tujuan == "edit-emp_leave") {
    //     print("kesiniiii atuh");
    //     validasiPemakaianCuti(dataEditFinal);
    //   }
    // } else {
    //   if (pilihan == true && url_tujuan == "edit-emp_leave") {
    //     if (dataEditFinal[0]['leave_status'] == "Approve") {
    //       print("kesiniiii atuh");
    //       validasiPemakaianCuti(dataEditFinal);
    //     }
    //   }
    // }
    // var dataUser = AppData.informasiUser;
    // var getEmpid = dataUser![0].em_id;
    // var fullName = dataUser[0].full_name ?? "";
    // var namaAtasanApprove = "$fullName";

    // var statusPengajuan = "";
    // var applyDate1 = "";
    // var applyBy1 = "";
    // var applyId1 = "";
    // var applyStatus = null;

    // var applyDate2 = "";
    // var applyBy2 = "";
    // var applyId2 = "";
    // var apply2Status = null;
    // print("tes wfh 22 ${tanggalNow}");
    // if (valuePolaPersetujuan.value == "1") {
    //   statusPengajuan = pilihan == true ? 'Approve' : 'Rejected';
    //   applyDate1 = tanggalNow;
    //   applyBy1 = namaAtasanApprove;
    //   applyId1 = "$getEmpid";
    //   applyStatus = statusPengajuan;
    //   applyDate2 = "";
    //   applyBy2 = "";
    //   applyId2 = "";
    //   apply2Status = null;
    // } else {
    //   if (url_tujuan == "edit-emp_leave") {
    //     print("tes wfh ${tanggalNow}");
    //     if (dataEditFinal[0]['leave_status'] == "Pending") {
    //       print("tes wfh ${tanggalNow}");
    //       statusPengajuan = pilihan == true ? 'Approve' : 'Rejected';
    //       applyDate1 = tanggalNow;
    //       applyBy1 = namaAtasanApprove;
    //       applyId1 = "$getEmpid";
    //       applyStatus = pilihan == true ? 'Approve' : 'Rejected';
    //       applyDate2 = "";
    //       applyBy2 = "";
    //       applyId2 = "";
    //       apply2Status = "Pending";
    //     } else if (dataEditFinal[0]['leave_status'] == "Approve") {
    //       print("tes wfh ${tanggalNow}");
    //       statusPengajuan = pilihan == true ? 'Approve2' : 'Rejected';
    //       applyDate1 = dataEditFinal[0]['apply_date'];
    //       applyBy1 = dataEditFinal[0]['apply_by'];
    //       applyId1 = dataEditFinal[0]['apply_id'];

    //       applyStatus = dataEditFinal[0]['apply_status'];

    //       applyDate2 = tanggalNow;
    //       applyBy2 = namaAtasanApprove;
    //       applyId2 = "$getEmpid";
    //       apply2Status = pilihan == true ? 'Approve' : 'Rejected';
    //     }
    //   } else {
    //     print("tes wfh status ${dataEditFinal[0]['status']}");
    //     if (dataEditFinal[0]['status'] == "Pending") {
    //       print("tes wfh ${tanggalNow}");
    //       statusPengajuan = pilihan == true ? 'Approve' : 'Rejected';

    //       applyDate1 = tanggalNow;
    //       applyBy1 = namaAtasanApprove;
    //       applyId1 = "$getEmpid";
    //       applyDate2 = "";
    //       applyBy2 = "";
    //       applyId2 = "";
    //       applyStatus = pilihan == true ? 'Approve' : 'Rejected';
    //       apply2Status = 'Pending';
    //     } else if (dataEditFinal[0]['status'] == "Approve") {
    //       print("tes wfh ${tanggalNow}");
    //       statusPengajuan = pilihan == true ? 'Approve2' : 'Rejected';
    //       applyDate1 = dataEditFinal[0]['approve_date'];
    //       applyBy1 = dataEditFinal[0]['approve_by'];
    //       applyId1 = dataEditFinal[0]['approve_id'].toString();
    //       applyStatus = dataEditFinal[0]['approve_status'].toString();
    //       apply2Status = pilihan == true ? 'Approve' : 'Rejected';
    //       applyDate2 = tanggalNow;
    //       applyBy2 = namaAtasanApprove;
    //       applyId2 = "$getEmpid";
    //     }
    //   }
    // }

    // var alasanRejectShow = alasanReject.value.text != ""
    //     ? ", Alasan pengajuan di tolak = ${alasanReject.value.text}"
    //     : "";
    // if (url_tujuan == 'edit-emp_leave') {
    // emp_leave
    var body = {
      'nomor_ajuan': detailData[0]['nomor_ajuan'].toString(),
      'em_id': AppData.informasiUser![0].em_id,
      'tanggal': formatDate(detailData[0]['tanggal_ajuan'].toString()),
      'status': pilihan == 'Tolak' ? 'Reject' : 'Approve',
    };
    print("body approval 1 ${body.toString()}");
    var connect = Api.connectionApi("post", body, "employee-loan-approval");
    connect.then((dynamic res) {
      var dt = DateTime.now();

      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        print("response valueBody ${valueBody.toString()}");
        Get.back();
        Get.back();
        Get.back();
        startLoadData('Kasbon', "${dt.month}", "${dt.year}", 'persetujuan');
      }
    });
    // connect.then((dynamic res) {
    //   if (res.statusCode == 200) {
    //     if (pilihan == true) {
    //       if (valuePolaPersetujuan.value == '1') {
    //         if (statusPengajuan == 'Approve') {
    //           insertAbsensiUserAfterApprove(dataEditFinal);
    //         }
    //       } else {
    //         if (statusPengajuan == 'Approve2') {
    //           insertAbsensiUserAfterApprove(dataEditFinal);
    //         }
    //       }
    //     }
    //     print('berhasil sampai sini edit emp leave');
    //     print('pola persetujuan ${valuePolaPersetujuan.value}');
    //     print('pilihan $pilihan');
    //     print('status pengajuan $statusPengajuan');
    //     insertNotifikasi(dataEditFinal, statusPengajuan, tanggalNow, dt,
    //         pilihan, namaAtasanApprove, url_tujuan, alasanRejectShow);
    //   }
    // });
    // }
    // else if (url_tujuan == 'edit-emp_labor') {
    //   var  body = {
    //     'em_id': dataEditFinal[0]['em_id'],
    //     'dari_jam': dataEditFinal[0]['dari_jam'],
    //     'sampai_jam': dataEditFinal[0]['sampai_jam'],
    //     'atten_date': dataEditFinal[0]['atten_date'],
    //     'status': statusPengajuan,
    //     'approve_date': applyDate1,
    //     'approve_by': applyBy1,
    //     'approve_id': applyId1,
    //     'approve2_date': applyDate2,
    //     'approve2_by': applyBy2,
    //     'approve2_id': applyId2,
    //     'alasan_reject': alasanReject.value.text,
    //     'em_delegation': dataEditFinal[0]['em_delegation'],
    //     'uraian': dataEditFinal[0]['uraian'],
    //     'ajuan': dataEditFinal[0]['ajuan'],
    //     'created_by': getEmpid,
    //     'menu_name': detailData[0]['type'],
    //     'val': 'id',
    //     'cari': dataEditFinal[0]['id'],
    //     'activity_name':
    //         "$statusPengajuan Pengajuan ${detailData[0]['type']} pada tanggal $tanggalNow. Pengajuan atas nama ${detailData[0]['nama_pengaju']} $alasanRejectShow",
    //     "approve_status": applyStatus,
    //     "approve2_status": apply2Status
    //   };
    //   print("body approval 2 ${body.toString()}");
    //   var connect = Api.connectionApi("post", body, "edit-emp_labor");
    //   connect.then((dynamic res) {
    //     if (res.statusCode == 200) {
    //       print('berhasil sampai sini edit emp labor');
    //       insertNotifikasi(dataEditFinal, statusPengajuan, tanggalNow, dt,
    //           pilihan, namaAtasanApprove, url_tujuan, alasanRejectShow);
    //     }
    //   });
    // } else if (url_tujuan == 'edit-emp_claim') {
    //   var  body = {
    //     'status': statusPengajuan,
    //     'atten_date': detailData[0]['waktu_pengajuan'],
    //     'approve_date': applyDate1,
    //     'approve_by': applyBy1,
    //     'approve_id': applyId1,
    //     'approve2_date': applyDate2,
    //     'approve2_by': applyBy2,
    //     'approve2_id': applyId2,
    //     'alasan_reject': alasanReject.value.text,
    //     'created_by': getEmpid,
    //     'menu_name': detailData[0]['type'],
    //     'val': 'id',
    //     'cari': dataEditFinal[0]['id'],
    //     'activity_name':
    //         "$statusPengajuan Pengajuan ${detailData[0]['type']} pada tanggal $tanggalNow. Pengajuan atas nama ${detailData[0]['nama_pengaju']} $alasanRejectShow"
    //   };
    //   print("body ${body}");
    //   var connect = Api.connectionApi("post", body, 'edit-emp_claim');
    //   connect.then((dynamic res) {
    //     if (res.statusCode == 200) {
    //       print('berhasil sampai sini klaim');
    //       insertNotifikasiClaim(
    //           dataEditFinal,
    //           statusPengajuan,
    //           tanggalNow,
    //           dt,
    //           pilihan,
    //           namaAtasanApprove,
    //           url_tujuan,
    //           alasanRejectShow,
    //           detailData[0]['em_id']);
    //     }
    //   });
    // } else if (url_tujuan == 'wfh-approval') {
    //   print('tes print');
    //   var  body = {
    //     'em_id': dataEditFinal[0]['em_id'],
    //     'dari_jam': dataEditFinal[0]['dari_jam'],
    //     'sampai_jam': dataEditFinal[0]['sampai_jam'],
    //     'atten_date': dataEditFinal[0]['atten_date'],
    //     'status': statusPengajuan,
    //     'approve_date': applyDate1,
    //     'approve_by': applyBy1,
    //     'approve_id': applyId1,
    //     'approve2_date': applyDate2,
    //     'approve2_by': applyBy2,
    //     'approve2_id': applyId2,
    //     'alasan_reject': alasanReject.value.text,
    //     'em_delegation': dataEditFinal[0]['em_delegation'],
    //     'uraian': dataEditFinal[0]['uraian'],
    //     'ajuan': dataEditFinal[0]['ajuan'],
    //     'created_by': getEmpid,
    //     'menu_name': detailData[0]['type'],
    //     'val': 'id',
    //     'cari': dataEditFinal[0]['id'],
    //     'activity_name':
    //         "$statusPengajuan Pengajuan ${detailData[0]['type']} pada tanggal $tanggalNow. Pengajuan atas nama ${detailData[0]['nama_pengaju']} $alasanRejectShow",
    //     "approve_status": applyStatus,
    //     "approve2_status": apply2Status,
    //     'pola': controllerGlobal.valuePolaPersetujuan.value.toString(),
    //   };
    //   print("body approval 3 ${body.toString()}");
    //   var connect = Api.connectionApi("post", body, "wfh-approval");
    //   connect.then((dynamic res) {
    //     if (res.statusCode == 200) {
    //       print('berhasil sampai sini edit emp labor');
    //       insertNotifikasi(dataEditFinal, statusPengajuan, tanggalNow, dt,
    //           pilihan, namaAtasanApprove, url_tujuan, alasanRejectShow);
    //     }
    //   });
    // }
  }

  void validasiPemakaianCuti(dataEditFinal) {
    print("validaasi pemakaian cuti");
    print(dataEditFinal);
    var body = {'val': 'name', 'cari': dataEditFinal[0]['nama_tipe']};
    var connect = Api.connectionApi("post", body, "whereOnce-leave_types");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        var statusPemotongan = valueBody['data'][0]['cut_leave'];
        if (statusPemotongan == 1) {
          cariEmployee(dataEditFinal);
        }
      } else {
        // UtilsAlert.showToast("yap");
      }
    });
  }

  insertAbsensiUserAfterApprove(dataEditFinal) {
    var body = {
      'dataAbsen': dataEditFinal,
    };
    var connect =
        Api.connectionApi("post", body, "insert_absen_approve_pengajuan");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        if (valueBody['status'] == true) {
          UtilsAlert.showToast('Berhasil menyetujui pengajuan employee');
        } else {
          print(valueBody);
        }
      }
    });
  }

  Future<bool>? arppovalpayroll({id}) {
    UtilsAlert.showLoadingIndicator(Get.context!);
    var emId = AppData.informasiUser![0].em_id;
    var body = {
      'id': id,
      'em_id': emId,
      'date': DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()
    };
    var connect = Api.connectionApi("post", body, "approve_emp_mobile_payroll");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        if (valueBody['status'] == true) {
          Get.back();
          Get.back();
          Get.back();
          UtilsAlert.showToast('Berhasil menyetujui pengajuan employee');
          return true;
        } else {
          UtilsAlert.showToast('gagal approved');
          Get.back();
          return false;
        }
      } else {
        UtilsAlert.showToast('gagal approved');
        Get.back();
        return false;
      }
    });
  }

  void checkTime() {
    TimeOfDay waktu1 = TimeOfDay(
        hour: int.parse(
            AppData.informasiUser![0].startTime.toString().split(':')[0]),
        minute: int.parse(
            AppData.informasiUser![0].startTime.toString().split(':')[1]));

    TimeOfDay waktu2 = TimeOfDay(
        hour: int.parse(
            AppData.informasiUser![0].endTime.toString().split(':')[0]),
        minute: int.parse(AppData.informasiUser![0].endTime
            .toString()
            .split(':')[1])); // Waktu kedua

    int totalMinutes1 = waktu1.hour * 60 + waktu1.minute;
    int totalMinutes2 = waktu2.hour * 60 + waktu2.minute;

    print('ini total menit1 ${totalMinutes1}');
    print('ini total menit ${totalMinutes2}');

    //alur normal
    if (totalMinutes1 < totalMinutes2) {
      startTime.value = AppData.informasiUser![0].startTime;
      endTime.value = AppData.informasiUser![0].endTime;

      startDate.value = DateFormat('yyyy-MM-dd').format(DateTime.now());
      endDate.value = DateFormat('yyyy-MM-dd').format(DateTime.now());

      //alur beda hari
    } else if (totalMinutes1 > totalMinutes2) {
      var waktu3 =
          TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
      int totalMinutes3 = waktu3.hour * 60 + waktu3.minute;

      if (totalMinutes2 > totalMinutes3) {
        print("masuk sini view las user");
        startTime.value = AppData.informasiUser![0].endTime;
        endTime.value = AppData.informasiUser![0].startTime;

        startTime.value = AppData.informasiUser![0].endTime;
        endTime.value = AppData.informasiUser![0].startTime;

        startDate.value = DateFormat('yyyy-MM-dd')
            .format(DateTime.now().add(const Duration(days: -1)));

        endDate.value = DateFormat('yyyy-MM-dd').format(DateTime.now());
      } else {
        print("masuk sini view las user 2");
        startTime.value = AppData.informasiUser![0].endTime;
        endTime.value = AppData.informasiUser![0].startTime;

        endDate.value = DateFormat('yyyy-MM-dd')
            .format(DateTime.now().add(const Duration(days: 2)));

        startDate.value = DateFormat('yyyy-MM-dd').format(DateTime.now());
      }
    } else {
      startTime.value = AppData.informasiUser![0].startTime;
      endTime.value = AppData.informasiUser![0].endTime;

      startDate.value = DateFormat('yyyy-MM-dd').format(DateTime.now());
      endDate.value = DateFormat('yyyy-MM-dd').format(DateTime.now());
      print(
          "Waktu 1 sama dengan waktu 2 new ${totalMinutes1}  ${totalMinutes2}");
    }
  }

  Future<bool>? approvalAbsensi(
      {required date,
      required status,
      required checkin,
      required checkout,
      required image,
      required note,
      required ajuanEmid,
      required id,
      place_in,
      place_out,
      apBy1,
      apdDate1,
      apId1,
      leaveStatus,
      pola,
      pilihan}) {
    checkTime();
    print("status leave ${leaveStatus}");
    UtilsAlert.showLoadingIndicator(Get.context!);
    var emId = AppData.informasiUser![0].em_id;
    var name = AppData.informasiUser![0].full_name;
    var statusPengajuan = "";
    var applyDate1 = "";
    var applyBy1 = "";
    var applyId1 = "";
    var applyDate2 = "";
    var applyBy2 = "";
    var applyId2 = "";

    var applyStatus = null;
    var apply2Status = null;

    if (pola == "1" || pola == 1) {
      statusPengajuan = pilihan == true ? 'Approve' : 'Rejected';
      applyDate1 =
          DateFormat('yyyy-MM-dd').format(DateTime.parse(date)).toString();
      applyBy1 = name;
      applyId1 = emId;
      applyDate2 = "";
      applyBy2 = "";
      applyId2 = "";
      applyStatus = pilihan == true ? 'Approve' : 'Rejected';
    } else {
      if (leaveStatus == "Pending") {
        statusPengajuan = pilihan == true ? 'Approve' : 'Rejected';

        applyDate1 =
            DateFormat('yyyy-MM-dd').format(DateTime.parse(date)).toString();
        applyBy1 = name;
        applyId1 = emId;

        applyDate2 = "";
        applyBy2 = "";
        applyId2 = "";
        applyStatus = pilihan == true ? 'Approve' : 'Rejected';
        apply2Status = pilihan == true ? 'Pending' : 'Rejected';
        status = pilihan == true ? 'Approve' : 'Rejected';
      } else if (leaveStatus == "Approve") {
        statusPengajuan = pilihan == true ? 'Approve2' : 'Rejected';
        applyDate1 = apdDate1;
        applyBy1 = apBy1;
        applyId1 = apId1;
        applyDate2 =
            DateFormat('yyyy-MM-dd').format(DateTime.parse(date)).toString();
        applyBy2 = name;
        applyId2 = emId;
        apply2Status = pilihan == true ? 'Approve' : 'Rejected';
        status = pilihan == true ? 'Approve2' : 'Rejected';
      }
    }
    var alasanRejectShow = alasanReject.value.text != ""
        ? ", Alasan pengajuan di tolak = ${alasanReject.value.text}"
        : "";

    var listKonsekuensi = '';
    print(konsekuemsiList);
    listKonsekuensi =
        konsekuemsiList.map((item) => item['konsekuensi']).join(',');
    var body = {
      'id': id.toString(),
      'em_id': ajuanEmid.toString(),
      'date': DateFormat('yyyy-MM-dd').format(DateTime.parse(date)).toString(),
      'bulan': DateFormat('MM').format(DateTime.parse(date)).toString(),
      'tahun': DateFormat('yyyy').format(DateTime.parse(date)).toString(),
      'status': status,
      'signin_time': checkin.toString(),
      'signout_time': checkout.toString(),
      'approved_id': emId.toString(),
      'approved_by': name.toString(),
      'approved_date':
          DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
      "image": image.toString(),
      "note": note.toString(),
      "ajuan_em_id": ajuanEmid.toString(),
      'alasan_reject': alasanReject.value.text,
      'place_in': place_in,
      'place_out': place_out,
      "pola": pola,
      "approve_id1": applyId1,
      "approve_by1": applyBy1,
      "approve_date1": applyDate1,
      "approve_id2": applyId2,
      "approve_by2": applyBy2,
      "approve_date2": applyDate2,
      "approve_status": applyStatus ?? "Pending",
      "approve2_status": apply2Status,
      "startTime": startTime.value,
      "endTime": endTime.value,
      "startDate": startDate.value,
      "endDate": endDate.value,
      'konsekuensi': listKonsekuensi,
      'tipe_surat': statusPemgajuanIzin.value,
    };
    print("body approve new 2 ${body}");

    var connect =
        Api.connectionApi("post", body, "approval-employee-attendance");
    connect.then((dynamic res) {
      var valueBody = jsonDecode(res.body);

      print("gagal ${valueBody}");

      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        if (valueBody['status'] == true) {
          loadAbsensi('persetujuan');
          Get.back();
          Get.back();
          Get.back();
          Get.back();
          UtilsAlert.showToast(valueBody['message']);

          return true;
        } else {
          //  UtilsAlert.showToast('gagal approved');

          Get.back();
          return false;
        }
      } else {
        UtilsAlert.showToast('gagal approved');
        Get.back();
        return false;
      }
    });
  }

  void cariEmployee(dataEditFinal) {
    print("cari employee");
    var body = {'val': 'full_name', 'cari': dataEditFinal[0]['full_name']};
    var connect = Api.connectionApi("post", body, "whereOnce-employee");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        var getEmidEmployee = valueBody['data'][0]['em_id'];
        potongCuti(dataEditFinal, getEmidEmployee);
        insertProd3(dataEditFinal, getEmidEmployee);
      }
    });
  }

  void insertProd3(dataEditFinal, getEmidEmployee) {
    print('ini data finalllll gokill ${dataEditFinal}');

    String namaPengajuan =
        dataEditFinal[0]['nama_penagjuan'].toString().toLowerCase();
    String type;

    if (namaPengajuan.startsWith('sakit')) {
      type = 'S';
    } else if (namaPengajuan.startsWith('izin')) {
      type = 'I';
    } else if (namaPengajuan.startsWith('cuti')) {
      type = 'C';
    } else {
      type = namaPengajuan[0].toUpperCase();
    }

    String tanggalSekarang = DateTime.now().toIso8601String().split('T')[0];

    var body = {
      'type': type,
      'nomor_ajuan': dataEditFinal[0]['nomor_ajuan'],
      'tanggal_ajuan': dataEditFinal[0]['atten_date'],
      'tanggal': tanggalSekarang,
      'nourut': '0001',
      'em_id': getEmidEmployee,
      'absen': dataEditFinal[0]['leave_duration'] == null ||
              dataEditFinal[0]['leave_duration'] == ''
          ? 1
          : dataEditFinal[0]['leave_duration'],
      'flag': '2'
    };
    print(body);
    var connect = Api.connectionApi("post", body, "masuk_prod3");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        UtilsAlert.showToast("${valueBody['message']}");
      } else {
        UtilsAlert.showToast("${res.body}");
      }
    });
  }

  void potongCuti(dataEditFinal, getEmidEmployee) {
    print(dataEditFinal);

    var body = {
      'em_id': getEmidEmployee,
      'terpakai': dataEditFinal[0]['nama'] == 'Surat Peringatan 1' ||
              dataEditFinal[0]['nama'] == 'Surat Peringatan 2' ||
              dataEditFinal[0]['nama'] == 'Surat Peringatan 3'
          ? '1'
          : dataEditFinal[0]['leave_duration'],
    };
    print(body);
    var connect = Api.connectionApi("post", body, "potong_cuti");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        UtilsAlert.showToast("${valueBody['message']}");
      }
    });
  }

  void insertNotifikasi(dataEditFinal, statusPengajuan, tanggalNow, dt, pilihan,
      namaAtasanApprove, url_tujuan, alasanRejectShow) {
    var statusNotif = pilihan == true ? 1 : 0;
    var jamSekarang = DateFormat('HH:mm:ss').format(dt);
    var url_notifikasi = detailData[0]['type'] == 'Cuti'
        ? 'RiwayatCuti'
        : detailData[0]['type'] == 'Izin' || detailData[0]['type'] == 'Sakit'
            ? 'TidakMasukKerja'
            : detailData[0]['type'] == 'Lembur'
                ? 'Lembur'
                : detailData[0]['type'] == 'Tugas Luar'
                    ? 'TugasLuar'
                    : '';
    var title = "Pengajuan ${detailData[0]['type']} telah di $statusPengajuan";
    var stringDeskripsi =
        "Pengajuan ${detailData[0]['type']} kamu telah di $statusPengajuan oleh $namaAtasanApprove $alasanRejectShow";
    var body = {
      'title': title,
      'deskripsi': stringDeskripsi,
      'url': url_notifikasi,
      'atten_date': tanggalNow,
      'jam': jamSekarang,
      'status': statusNotif,
      'view': '0',
    };
    if (url_tujuan == 'edit-emp_leave-approval') {
      body['em_id'] = dataEditFinal[0]['em_id'];
    } else if (url_tujuan == 'edit-emp_labor-approval' ||
        url_tujuan == 'edit-emp_labor-approval-task') {
      body['em_id'] = dataEditFinal[0]['em_id'];
    } else if (url_tujuan == 'edit-emp_claim') {
      body['em_id'] = dataEditFinal[0]['em_id'];
    }

    var connect = Api.connectionApi("post", body, "insert-notifikasi");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        var pesanController = Get.find<PesanController>();
        pesanController.loadApproveInfo();
        startLoadData(titleAppbar.value, bulanSelected.value,
            tahunSelected.value, 'persetujuan');
        Navigator.pop(Get.context!);
        Navigator.pop(Get.context!);
        UtilsAlert.showToast(
            "Pengajuan ${detailData[0]['type']} berhasil di $statusPengajuan");
        Get.back();
      }
    });
  }

  void insertNotifikasiClaim(dataEditFinal, statusPengajuan, tanggalNow, dt,
      pilihan, namaAtasanApprove, url_tujuan, alasanRejectShow, emid) {
    var statusNotif = pilihan == true ? 1 : 0;
    var jamSekarang = DateFormat('HH:mm:ss').format(dt);
    var url_notifikasi = detailData[0]['type'] == 'Cuti'
        ? 'RiwayatCuti'
        : detailData[0]['type'] == 'Izin' || detailData[0]['type'] == 'Sakit'
            ? 'TidakMasukKerja'
            : detailData[0]['type'] == 'Lembur'
                ? 'Lembur'
                : detailData[0]['type'] == 'Tugas Luar'
                    ? 'TugasLuar'
                    : '';
    var title = "Pengajuan ${detailData[0]['type']} telah di $statusPengajuan";
    var stringDeskripsi =
        "Pengajuan ${detailData[0]['type']} kamu telah di $statusPengajuan oleh $namaAtasanApprove $alasanRejectShow";
    var body = {
      'title': title,
      'deskripsi': stringDeskripsi,
      'url': url_notifikasi,
      'atten_date': tanggalNow,
      'jam': jamSekarang,
      'status': statusNotif,
      'view': '0',
    };
    if (url_tujuan == 'edit-emp_leave') {
      body['em_id'] = dataEditFinal[0]['em_id'];
    } else if (url_tujuan == 'edit-emp_labor') {
      body['em_id'] = dataEditFinal[0]['em_id'];
    } else if (url_tujuan == 'edit-emp_claim') {
      body['em_id'] = dataEditFinal[0]['em_id'];
    }

    var connect = Api.connectionApi("post", body, "insert-notifikasi");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        var pesanController = Get.find<PesanController>();
        pesanController.loadApproveInfo();
        startLoadData(titleAppbar.value, bulanSelected.value,
            tahunSelected.value, 'persetujuan');
        Navigator.pop(Get.context!);
        Navigator.pop(Get.context!);
        UtilsAlert.showToast(
            "Pengajuan ${detailData[0]['type']} berhasil di $statusPengajuan");
        Get.back();
      }
    });
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
    } else if (status == "cuti") {
      var urlViewGambar = Api.UrlfileCuti + file;

      final url = Uri.parse(urlViewGambar);
      if (!await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      )) {
        UtilsAlert.showToast('Tidak dapat membuka file');
      }
    } else if (status == "klaim") {
      var urlViewGambar = Api.UrlfileKlaim + file;

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
