import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:siscom_operasional/model/daily_task_model.dart';
import 'package:siscom_operasional/screen/daily_task/daily_task.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';

class DailyTaskController extends GetxController {
  var tipeAlphaAbsen = 0.obs;
  var catatanAlpha = ''.obs;
  var allTask = <DailyTaskModel>[].obs;
  var listTask = [].obs;
  var idTask = ''.obs;
  var tanggalTaskOld = ''.obs;
  var filterBranch = ''.obs;
  var listTaskPdf = [].obs;
  var tanggalTask = TextEditingController().obs;
  var task = [].obs;
  var catatan = TextEditingController().obs;
  Rx<DateTime> initialDate = DateTime.now().obs;
  var statusForm = false.obs;
  var tahunSelectedSearchHistory = ''.obs;
  var bulanSelectedSearchHistory = ''.obs;
  var bulanDanTahunNow = "".obs;
  var monitoringList = [].obs;
  var date = DateTime.now().obs;
  var tanggal = ''.obs;
  var emId = ''.obs;
  var tempNamaStatus1 = "".obs;
  var tempTask = ''.obs;
  var tempDifficulty = 0.obs;
  var tempTitle = ''.obs;
  var tempTanggalSelesai = ''.obs;
  var tempStatus = 0.obs;
  var filterStatus = 'Semua'.obs;
  var statusDraft = ''.obs;
  var atasanStatus = ''.obs;
  var isFormChanged = false.obs;
  var branchList = [].obs;

  int getBranchIdByName(String branchName) {
    Map<String, int> branchMapping = {
      'Semua Cabang': -1,
      'PT. SHAN INFORMASI SISTEM': 1,
      'PT. REFORMASI ANUGERAH JAVA JAYA': 2,
    };

    return branchMapping[branchName] ?? -1;
  }

  var selectedBranch = 'Semua Cabang'.obs;

  @override
  void onReady() async {
    await getTimeNow();
  }

  
  void getBranch() {
    var connect = Api.connectionApi('get', {}, 'cabang');
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        branchList.clear();
        var valueBody = jsonDecode(res.body);
        print('ini get barnch ${valueBody['data']}');
        branchList.add({'name':'Semua Cabang', 'id':-1 });
        for (var data in valueBody['data']) {
          branchList.add(data);
          print('ini branch list $branchList');
        }
        // List data = valueBody['data'];
        // if (data.isNotEmpty) {
        //   var listFirst = data.firstWhere((element) => element['name'] != null,
        //       orElse: () => null);
        //   if (listFirst != null) {
        //     var fullName = listFirst['name'] ?? "";
        //     String namaUserPertama = "$fullName";
        //     filterBranch.value = namaUserPertama;
        //   }
        // }
        // branchList.refresh;
        // filterBranch.refresh;
        // print(branchList);
      } else {
        print('error ${res.body}');
      }
    });
  }


  void getMonitor() async {
    monitoringList.clear();
    var connect = Api.connectionApi("get", {}, "getDailyMonitoring");
    connect.then(
      (dynamic response) {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body)['data'];
          print(data);
          monitoringList.add(data);
          print(monitoringList);
          tempNamaStatus1.value = monitoringList[0][0]['full_name'];
          emId.value = monitoringList[0][0]['em_id'];
          print('ini emid dari monitoring ${emId.value}');
          atasanStatus.value = 'draft';
          loadAllTask(emId.value);
        } else {
          Get.snackbar("error", "gagal");
        }
      },
    );
  }

  void kirimDailyTask() {
    if (statusDraft.value != 'draft') {
      if (tanggalTask.value.text == '' || tanggalTask.value.text == '') {
        Get.back();
        UtilsAlert.showToast('Tanggal Tidak boleh kosong');
        return;
      }
      bool isTaskEmpty = listTask.any((task) =>
          task['judul'].trim().isEmpty || task['task'].trim().isEmpty);
      if (isTaskEmpty) {
        Get.back();
        UtilsAlert.showToast('Judul task atau rincian tidak boleh kosong');
        return;
      }
    }

    var polaInput =
        DateFormat('EEEE, dd-MM-yyyy', 'id'); // 'id' untuk lokal Indonesia
    var polaOutput = DateFormat('yyyy-MM-dd');
    var atten_date;
    var emId = AppData.informasiUser![0].em_id;
    try {
      var parsedDate = polaInput.parse(tanggalTask.value.text);
      atten_date = polaOutput.format(parsedDate);
      print('Tanggal Terformat: $atten_date');
    } catch (e) {
      print('Format tanggal tidak valid: ${tanggalTask.value.text}');
    }

    print(task);

    Map<String, dynamic> body = {
      'atten_date': atten_date,
      'em_id': emId,
      'tanggal_old': tanggalTaskOld.value,
      'list_task': listTask,
      'status': statusDraft.value,
    };
    if (statusDraft != 'draft') {
      if (statusForm.value == false) {
        var connect = Api.connectionApi("post", body, "insertTaskDaily");
        connect.then((dynamic res) {
          var valueBody = jsonDecode(res.body);
          if (res.statusCode == 200) {
            print(valueBody);
            Get.back();
            Get.back();
            loadAllTask(emId);
            UtilsAlert.showToast(valueBody.message);
          } else {
            UtilsAlert.showToast(valueBody['message']);
            print(valueBody['message']);
            Get.back();
          }
        });
      } else {
        body['id'] = listTask.isEmpty ? "" : task[0]['daily_task_id'];
        var connect = Api.connectionApi("post", body, "updateTaskDaily");
        connect.then((dynamic res) {
          var valueBody = jsonDecode(res.body);
          if (res.statusCode == 200) {
            print(valueBody);
            Get.back();
            Get.back();
            loadAllTask(emId);
            UtilsAlert.showToast(valueBody['message']);
          } else {
            UtilsAlert.showToast(valueBody['message']);
            print(valueBody['message']);
            Get.back();
          }
        });
      }
    } else {
      if (statusForm.value == false) {
        var connect = Api.connectionApi("post", body, "insertDraftDaily");
        connect.then((dynamic res) {
          var valueBody = jsonDecode(res.body);
          if (res.statusCode == 200) {
            print(valueBody);
            // Get.back();
            // Get.back();
            loadAllTask(emId);
            UtilsAlert.showToast(valueBody.message);
          } else {
            UtilsAlert.showToast(valueBody['message']);
            print(valueBody['message']);
            // Get.back();
          }
        });
      } else {
        body['id'] = listTask.isEmpty ? "" : task[0]['daily_task_id'];
        var connect = Api.connectionApi("post", body, "updateDraftDaily");
        connect.then((dynamic res) {
          var valueBody = jsonDecode(res.body);
          if (res.statusCode == 200) {
            print(valueBody);
            // Get.back();
            // Get.back();
            loadAllTask(emId);
            UtilsAlert.showToast(valueBody['message']);
          } else {
            UtilsAlert.showToast(valueBody['message']);
            print(valueBody['message']);
            // Get.back();
          }
        });
      }
    }
  }

  Future<void> getTimeNow() async {
    var dt = DateTime.parse(AppData.endPeriode);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    bulanSelectedSearchHistory.value = "${twoDigits(dt.month)}";
    tahunSelectedSearchHistory.value = "${dt.year}";
    bulanDanTahunNow.value = "${twoDigits(dt.month)}-${dt.year}";
    tanggal.value = '${dt.year}-${twoDigits(dt.month)}-${dt.hour}';
    print('ini tanggal sekarang $bulanSelectedSearchHistory');
  }

  void setFormChanged() {
    isFormChanged.value = true;
  }

  void resetFormState() {
    isFormChanged.value = false;
  }

  void loadAllTask(emId) {
    allTask.clear();
    Map<String, dynamic> body = {
      'atten_date': tanggal.value,
      'atasanStatus': atasanStatus.value,
      'em_id': emId,
      'bulan': bulanSelectedSearchHistory.value,
      'tahun': tahunSelectedSearchHistory.value,
    };
    var connect = Api.connectionApi("post", body, "getAllTaskDaily");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        print('ini data daily ${valueBody['data']}');
        for (var element in valueBody['data'][0]) {
          allTask.add(DailyTaskModel(
              date: element['date'] ?? '',
              id: element['id'] ?? 0,
              em_id: element['em_id'] ?? "",
              atten_date: element['tgl_buat'],
              signin_time: element['signin_time'] ?? "",
              signout_time: element['signout_time'] ?? "",
              working_hour: element['working_hour'] ?? "",
              place_in: element['place_in'] ?? "",
              place_out: element['place_out'] ?? "",
              absence: element['absence'] ?? "",
              overtime: element['overtime'] ?? "",
              earnleave: element['earnleave'] ?? "",
              status: element['status'] ?? "",
              signin_longlat: element['signin_longlat'] ?? "",
              signout_longlat: element['signout_longlat'] ?? "",
              att_type: element['att_type'] ?? "",
              signin_pict: element['signin_pict'] ?? "",
              signout_pict: element['signout_pict'] ?? "",
              signin_note: element['signin_note'] ?? "",
              signout_note: element['signout_note'] ?? "",
              signin_addr: element['signin_addr'] ?? "",
              signout_addr: element['signout_addr'] ?? "",
              reqType: element['reg_type'] ?? 0,
              atttype: element['atttype'] ?? 0,
              namaLembur: element['lembur'],
              namaTugasLuar: element['tugas_luar'],
              namaCuti: element['cuti'],
              namaSakit: element['sakit'],
              namaIzin: element['izin'],
              namaDinasLuar: element['dinas_luar'],
              offDay: element['off_date'],
              namaHariLibur: element['hari_libur'],
              jamKerja: element['jam_kerja'],
              jamPulang: element['jam_pulang'],
              breakoutTime: element['total_status_0'],
              breakoutNote: element['total_status_1'],
              breakoutPict: element['jumlah_task'],
              breakoutPlace: element['place_break_out'],
              breakinTime: element['status_pengajuan'],
              breakinNote: element['breakin_note'],
              breakinPict: element['breakin_pict'],
              breakinPlace: element['place_break_in'],
              breakinAddr: element['breakin_addr'],
              breakoutAddr: element['breakout_addr'],
              statusView: element['status_view'] ?? false));
        }
      }
    });
  }

  Future<void> loadTask(id) async {
    listTask.clear();
    task.clear();
    Map<String, dynamic> body = {
      'id': id,
      'bulan': bulanSelectedSearchHistory.value,
      'tahun': tahunSelectedSearchHistory.value
    };
    try {
      var res = await Api.connectionApi("post", body, "getTaskDaily");
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        var dataList =
            valueBody['data'] is List ? valueBody['data'] : [valueBody['data']];
        task.addAll(dataList);
        for (var tas in dataList) {
          listTask.add({
            'id': tas['id'],
            'judul': tas['judul'],
            'task': tas['rincian'],
            'level': tas['level'],
            'status': tas['status'],
            'tgl_finish': tas['tgl_finish'] == null
                ? ''
                : Constanst.convertDate(tas['tgl_finish'])
          });
        }

        print('ini task $task');
        Get.back();
      } else {
        print("Error: ${res.statusCode} - ${res.body}");
        Get.back();
      }
    } catch (e) {
      print("Exception saat load task: $e");
      Get.back();
    }
  }

  Future<void> loadTaskPDF(em_id) async {
    listTaskPdf.clear();
    Map<String, dynamic> body = {
      'em_id': em_id,
      'bulan': bulanSelectedSearchHistory.value,
      'tahun': tahunSelectedSearchHistory.value
    };
    try {
      var res = await Api.connectionApi("post", body, "getTaskDailyPDF");
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        var dataList =
            valueBody['data'] is List ? valueBody['data'] : [valueBody['data']];
        listTaskPdf.addAll(dataList);
        print('ini task $listTaskPdf');
        Get.back();
      } else {
        print("Error: ${res.statusCode} - ${res.body}");
        Get.back();
      }
    } catch (e) {
      print("Exception saat load task: $e");
      Get.back();
    }
  }

  Future<void> generateAndOpenPdf(em_id) async {
    await loadTaskPDF(em_id);
    final pdf = pw.Document();
    final pdfColor = Colors.red;
    final int colorInt = pdfColor.value;
    final imageData = await rootBundle.load('assets/icon.png');
    final user = listTaskPdf[0];
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            // Header
            pw.Center(
              child: pw.Column(
                children: [
                  pw.SizedBox(height: 30),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.SizedBox(
                        width: 70,
                        child: pw.Image(
                          pw.MemoryImage(imageData.buffer.asUint8List()),
                          width: 70,
                        ),
                      ),
                      pw.SizedBox(width: 25),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'PT . SHAN INFORMASI SISTEM',
                            style: pw.TextStyle(
                              fontSize: 24,
                              color: PdfColor.fromInt(colorInt),
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.SizedBox(height: 8),
                          pw.Text(
                            'BEST SOLUTION FOR BUSINESS CONTROL',
                            style: pw.TextStyle(
                              fontSize: 11.5,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 12),
                  pw.Divider(thickness: 1),
                ],
              ),
            ),

            pw.SizedBox(height: 20),

            // Title
            pw.Center(
              child: pw.Text(
                'DAILY TASK',
                style:
                    pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
            ),

            pw.SizedBox(height: 20),

            _buildInfoRow("NAMA KARYAWAN", user['full_name']),
            _buildInfoRow("DIVISI", user['divisi']),
            _buildInfoRow("JABATAN", user['jabatan']),
            _buildInfoRow("POSISI", user['posisi']),
            _buildInfoRow("PERIODE BULAN",
                Constanst.convertGetMonth(user['tgl_buat']).toUpperCase()),

            pw.SizedBox(height: 20),

            // Tabel Task
            _buildTaskTable(),
          ];
        },
      ),
    );

    // Simpan PDF
    final outputDir = await getTemporaryDirectory();
    final filePath = '${outputDir.path}/daily_task_report.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    // Buka PDF
    final result = await OpenFile.open(filePath);
    if (result.type != ResultType.done) {
      // Get.snackbar('Error', 'Failed to open PDF', snackPosition: SnackPosition.BOTTOM);
    }
  }

// Fungsi untuk membuat row informasi karyawan
  pw.Widget _buildInfoRow(String title, String value) {
    return pw.Container(
      padding: pw.EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            flex: 24,
            child: pw.Text(title,
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold, fontSize: 10.0)),
          ),
          pw.Text(":"),
          pw.SizedBox(width: 4),
          pw.Expanded(
            flex: 68,
            child: pw.Text(value,
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.normal, fontSize: 10.0)),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildTaskTable() {
    final headers = [
      "No",
      "Tanggal",
      "Judul",
      "Rincian Task",
      "Tingkat Kesulitan",
      "Status",
      "Tgl Finish",
      "Durasi"
    ];

    final Map<String, int> tanggalRowSpan = {};
    final List<List<String>> data = [];

    final Map<String, List<Map<String, dynamic>>> groupedByTanggal = {};

    for (var task in listTaskPdf) {
      String tanggal = Constanst.convertDate(task['tgl_buat']);
      groupedByTanggal.putIfAbsent(tanggal, () => []).add(task);
    }

    int no = 1;

    final sortedEntries = groupedByTanggal.entries.toList()
      ..sort((a, b) {
        // Sort berdasarkan tanggal
        final dateA =
            DateTime.tryParse(a.value[0]['tgl_buat'] ?? '') ?? DateTime(2000);
        final dateB =
            DateTime.tryParse(b.value[0]['tgl_buat'] ?? '') ?? DateTime(2000);
        return dateA.compareTo(dateB);
      });
    for (var entry in sortedEntries) {
      final tanggal = entry.key;
      final tasks = entry.value;

      for (int i = 0; i < tasks.length; i++) {
        var task = tasks[i];

        var level;
        switch (task['level']) {
          case '1':
            level = 'Sangat Mudah';
            break;
          case '2':
            level = 'Mudah';
            break;
          case '3':
            level = 'Normal';
            break;
          case '4':
            level = 'Sulit';
            break;
          case '5':
            level = 'Sangat Sulit';
            break;
          default:
            level = "Tidak Diketahui";
        }

        DateTime? tglBuat = task['tgl_buat'] != null
            ? DateTime.tryParse(task['tgl_buat'])
            : null;
        DateTime? tglFinish = task['tgl_finish'] != null
            ? DateTime.tryParse(task['tgl_finish'])
            : null;

        String durasi = "-";
        if (tglBuat != null && tglFinish != null) {
          durasi = '${tglFinish.difference(tglBuat).inDays + 1} Hari';
        }

        data.add([
          i == 0 ? no.toString() : '', // No hanya di baris pertama per tanggal
          i == 0 ? tanggal : '', // Tanggal hanya di baris pertama per tanggal
          task['judul'],
          task['rincian'],
          level.toString(),
          task['status']?.toString() == '0' ? 'Ongoing' : 'Finish',
          task['tgl_finish'] == null
              ? '-'
              : Constanst.convertDate1(task['tgl_finish']),
          durasi
        ]);
      }

      no++; // Naikkan nomor setelah satu kelompok tanggal selesai
    }
    ;

    return pw.Table(
      border: pw.TableBorder.all(width: 1),
      columnWidths: {
        0: pw.FixedColumnWidth(40), // No
        1: pw.FixedColumnWidth(80), // Hari
        2: pw.FixedColumnWidth(80), // Judul
        3: pw.FixedColumnWidth(160), // Rincian Task
        4: pw.FixedColumnWidth(120), // Tingkat Kesulitan
        5: pw.FixedColumnWidth(80), // Status
        6: pw.FixedColumnWidth(80), // Tgl Finish
        7: pw.FixedColumnWidth(80), // Durasi
      },
      children: [
        // Header Tabel
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.grey300),
          children: headers.map((header) {
            return pw.Padding(
              padding: pw.EdgeInsets.all(8),
              child: pw.Text(
                header,
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 6.0),
                textAlign: pw.TextAlign.center,
              ),
            );
          }).toList(),
        ),

        ..._buildMergedTableRows(data, tanggalRowSpan),
      ],
    );
  }

  List<pw.TableRow> _buildMergedTableRows(
      List<List<String>> data, Map<String, int> tanggalRowSpan) {
    List<pw.TableRow> rows = [];
    String lastDate = "";

    for (var row in data) {
      String currentDate = row[1];

      rows.add(
        pw.TableRow(
          verticalAlignment: pw.TableCellVerticalAlignment.middle,
          children: [
            tanggalRowSpan[currentDate] != null && lastDate == currentDate
                ? pw.SizedBox.shrink()
                : pw.Container(
                    alignment: pw.Alignment.center,
                    padding: pw.EdgeInsets.all(6),
                    child: pw.Text(row[0], style: pw.TextStyle(fontSize: 6.0)),
                  ),
            tanggalRowSpan[currentDate] != null && lastDate == currentDate
                ? pw.SizedBox.shrink()
                : pw.Container(
                    alignment: pw.Alignment.center,
                    padding: pw.EdgeInsets.all(6),
                    child: pw.Text(row[1], style: pw.TextStyle(fontSize: 6.0)),
                  ),
            for (int i = 2; i < row.length; i++)
              pw.Padding(
                padding: pw.EdgeInsets.all(6),
                child: pw.Text(
                  row[i],
                  textAlign:
                      (i == 3) ? pw.TextAlign.justify : pw.TextAlign.center,
                  style: pw.TextStyle(fontSize: 6.0),
                ),
              ),
          ],
        ),
      );

      lastDate = currentDate;
    }

    return rows;
  }
}
