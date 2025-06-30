import 'dart:convert';
import 'dart:ffi';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/global_controller.dart';
import 'package:siscom_operasional/screen/absen/form/berhasil_pengajuan.dart';
import 'package:siscom_operasional/screen/absen/form/form_lembur.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/custom_dialog.dart';
import 'package:siscom_operasional/utils/widget_textButton.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class LemburController extends GetxController {
  var isFormChanged = false.obs;
  var nomorAjuan = TextEditingController().obs;
  var tanggalLembur = TextEditingController().obs;
  var dariJam = TextEditingController().obs;
  var sampaiJam = TextEditingController().obs;
  var statusJam = "".obs;
  var durasi = TextEditingController().obs;
  var catatan = TextEditingController().obs;
  var cari = TextEditingController().obs;
  var cariBerhubungan = TextEditingController().obs;
  var stringCari = ''.obs;
  var cariAtas = TextEditingController().obs;
  var stringCariAtas = ''.obs;
  var dinilai = 'N'.obs;

  Rx<List<String>> typeLembur = Rx<List<String>>([]);
  Rx<List<String>> allEmployeeDelegasi = Rx<List<String>>([]);

  var statusFormPencarian = false.obs;
  var statusFormPencarianBerhubungan = false.obs;
  var statusFormPencarianAtas = false.obs;
  var focusNodes = <FocusNode>[].obs;
  var keyboardStates = <bool>[].obs;
  var listTaskControllers = <TextEditingController>[].obs;
  var statusDraft = ''.obs;
  var tempNamaStatus1 = "Semua Status".obs;
  var tempTask = ''.obs;
  var tempDifficulty = 0.obs;

  var bulanSelectedSearchHistory = "".obs;
  var tahunSelectedSearchHistory = "".obs;
  var bulanDanTahunNow = "".obs;
  var selectedDropdownDelegasi = "".obs;
  var selectedDropdownDelegasiTemp = "".obs;
  var selectedDropdownEmploy = [].obs;
  var selectedDropdownEmployTemp = "".obs;
  var idpengajuanLembur = "".obs;
  var emIdDelegasi = "".obs;
  var valuePolaPersetujuan = "".obs;
  var selectedTypeLembur = "".obs;
  var loadingString = "Memuat Data...".obs;

  var statusForm = false.obs;
  var directStatus = false.obs;
  var showButtonlaporan = false.obs;
  var statusCari = false.obs;
  var statusCariBerhubugan = false.obs;
  var viewTypeLembur = false.obs;

  var isSelected = false.obs;
  var listLembur = [].obs;
  var listLemburAll = [].obs;
  var allTypeLembur = [].obs;
  var allEmployee = [].obs;
  var infoEmployeeAll = [].obs;
  var dataTypeAjuan = [].obs;
  var departementAkses = [].obs;

  var listTask = [].obs;

  Rx<DateTime> initialDate = DateTime.now().obs;

  var dataTypeAjuanDummy1 = ["Semua Status", "Approve", "Rejected", "Pending"];
  var dataTypeAjuanDummy2 = [
    "Semua Status",
    "Approve 1",
    "Approve 2",
    "Rejected",
    "Pending"
  ];

  void removeTask(int index) {
    listTask.removeAt(index);
    listTaskControllers[index].dispose();
    focusNodes[index].dispose();
    listTaskControllers.removeAt(index);
    focusNodes.removeAt(index);
    keyboardStates.removeAt(index);
  }

  void setFormChanged() {
    isFormChanged.value = true;
  }

  void resetFormState() {
    isFormChanged.value = false;
  }

  GlobalController globalCt = Get.find<GlobalController>();
  @override
  void onReady() async {
    print("on ready");
    super.onReady();
    getTimeNow();
    getLoadsysData();
    loadDataLembur();
    loadAllEmployeeDelegasi();
    getUserInfo();
    getTypeLembur();
    getDepartemen(1, "");
  }

  void showInputCari() {
    statusFormPencarian.value = !statusFormPencarian.value;
  }

  void showInputCariBerhubungan() {
    statusFormPencarianBerhubungan.value =
        !statusFormPencarianBerhubungan.value;
  }

  void showInputCariAtasPerintah() {
    statusFormPencarianAtas.value = !statusFormPencarianAtas.value;
  }

  void removeAll() async {
    listTask.clear();
    idpengajuanLembur.value = "";
    tanggalLembur.value.text = "";
    dariJam.value.text = "";
    sampaiJam.value.text = "";
    catatan.value.text = "";
  }

  void getDepartemen(status, tanggal) {
    var connect = Api.connectionApi("get", {}, "all_department");
    connect.then((dynamic res) {
      if (res == false) {
        //UtilsAlert.koneksiBuruk();
      } else {
        if (res.statusCode == 200) {
          var valueBody = jsonDecode(res.body);
          var dataDepartemen = valueBody['data'];

          var dataUser = AppData.informasiUser;
          var hakAkses = dataUser![0].em_hak_akses;
          print(hakAkses);
          if (hakAkses != "" || hakAkses != null) {
            if (hakAkses == '0') {
              var data = {
                'id': 0,
                'name': 'SEMUA DIVISI',
                'inisial': 'AD',
                'parent_id': '',
                'aktif': '',
                'pakai': '',
                'ip': '',
                'created_by': '',
                'created_on': '',
                'modified_by': '',
                'modified_on': ''
              };
              departementAkses.add(data);
            }
            var convert = hakAkses!.split(',');
            for (var element in dataDepartemen) {
              if (hakAkses == '0') {
                departementAkses.add(element);
              }
              for (var element1 in convert) {
                if ("${element['id']}" == element1) {
                  print('sampe sini');
                  departementAkses.add(element);
                }
              }
            }
          }
          this.departementAkses.refresh();
          if (departementAkses.value.isNotEmpty) {
            if (status == 1) {
              showButtonlaporan.value = true;
            }
          }
        }
      }
    });
  }

  void getUserInfo() async {
    var dataUser = AppData.informasiUser;
    var getDepGroup = dataUser![0].dep_group;
    var full_name = dataUser[0].full_name;
    var emid = dataUser[0].em_id;
    Map<String, dynamic> body = {'dep_id': 0};
    var connect = Api.connectionApi(
      "post",
      body,
      "berhubungan-dengan",
    );
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        var data = valueBody['data'];
        infoEmployeeAll.clear();
        for (var element in data) {
          if (element['status'] == 'ACTIVE' &&
              element['em_id'] != AppData.informasiUser![0].em_id) {
            var fullName = element['full_name'] ?? "";
            infoEmployeeAll.value.add(element);
          }
        }
        if (idpengajuanLembur.value == "") {
          selectedDropdownEmploy.clear();
          List data = valueBody['data'];
          var listFirst = data
              .where((element) => element['full_name'] != full_name)
              .toList()
              .first;
          var fullName = listFirst['full_name'] ?? "";
          print(fullName);
          String namaUserPertama = "$fullName";
          selectedDropdownEmploy.add(namaUserPertama);
        }
        this.infoEmployeeAll.refresh();
        this.selectedDropdownEmploy.refresh();
      }
    }).catchError((e) {
      print('error get employee $e');
    });
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
            getTypeAjuan();
          }
        }
      }
    });
  }

  void getTypeAjuan() {
    if (valuePolaPersetujuan.value == "1") {
      dataTypeAjuan.value.clear();
      for (var element in dataTypeAjuanDummy1) {
        var data = {'nama': element, 'status': false};
        dataTypeAjuan.value.add(data);
      }
      dataTypeAjuan.value.firstWhere(
          (element) => element['nama'] == 'Semua Status')['status'] = true;
      this.dataTypeAjuan.refresh();
    } else {
      dataTypeAjuan.value.clear();
      for (var element in dataTypeAjuanDummy2) {
        var data = {'nama': element, 'status': false};
        dataTypeAjuan.value.add(data);
      }
      dataTypeAjuan.value.firstWhere(
          (element) => element['nama'] == 'Semua Status')['status'] = true;
      this.dataTypeAjuan.refresh();
    }
  }

  void getTypeLembur() {
    print("get data atype lembur");
    var dataUser = AppData.informasiUser;
    var getEmid = dataUser![0].em_id;
    Map<String, dynamic> body = {
      'val': "em_id",
      'cari': "$getEmid",
    };
    var connect = Api.connectionApi("post", body, "whereOnce-employee");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        var overtimeData = valueBody['data'][0]['overtime_id'];
        loadDataTypeOvertime(overtimeData);
      }
    });
  }

  void loadDataTypeOvertime(overtimeData) {
    typeLembur.value.clear();
    var connect = Api.connectionApi("get", "", "overtime");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);

        var data = valueBody['data'];
        List overtimeUser = overtimeData.split(',');
        List tampung = [];
        for (var element in data) {
          for (var element1 in overtimeUser) {
            if ("${element['id']}" == element1) {
              tampung.add(element);
            }
          }
        }
        print(tampung);
        if (tampung.isEmpty) {
          viewTypeLembur.value = false;
          this.viewTypeLembur.refresh();
        } else {
          viewTypeLembur.value = true;
          for (var element in tampung) {
            typeLembur.value.add(element['name']);
            var data = {
              'id': element['id'],
              'name': element['name'],
              'dinilai': element['dinilai']
            };
            allTypeLembur.value.add(data);
            print('ini gak kepangil');
          }
          var getFirst = tampung.first;
          selectedTypeLembur.value = getFirst['name'];
          dinilai.value = getFirst['dinilai'];
          this.viewTypeLembur.refresh();
          this.typeLembur.refresh();
          this.allTypeLembur.refresh();
          this.selectedTypeLembur.refresh();
        }
      }
    });
  }

  void getTimeNow() {
    var dt = DateTime.now();
    bulanSelectedSearchHistory.value = "${dt.month}";
    tahunSelectedSearchHistory.value = "${dt.year}";
    bulanDanTahunNow.value = "${dt.month}-${dt.year}";

    if (idpengajuanLembur.value == "") {
      tanggalLembur.value.text = Constanst.convertDate("${initialDate.value}");
    }

    this.tanggalLembur.refresh();
    this.bulanSelectedSearchHistory.refresh();
    this.tahunSelectedSearchHistory.refresh();
    this.bulanDanTahunNow.refresh();
  }

  void loadDataLembur() {
    listLemburAll.value.clear();
    listLembur.value.clear();
    var dataUser = AppData.informasiUser;
    var getEmid = dataUser![0].em_id;
    Map<String, dynamic> body = {
      'em_id': getEmid,
      'bulan': bulanSelectedSearchHistory.value,
      'tahun': tahunSelectedSearchHistory.value,
    };
    var connect = Api.connectionApi("post", body, "history-emp_labor");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        debugPrint("ini history lembur ${jsonEncode(valueBody['data'])}",
            wrapWidth: 1000);
        if (valueBody['status'] == false) {
          loadingString.value = "Anda tidak memiliki\nRiwayat Pengajuan Lembur";
          this.loadingString.refresh();
        } else {
          for (var element in valueBody['data']) {
            if (element['ajuan'] == 1) {
              listLembur.value.add(element);
              listLemburAll.value.add(element);
            }
          }
          if (listLembur.value.length == 0) {
            loadingString.value =
                "Anda tidak memiliki\nRiwayat Pengajuan Lembur";
          } else {
            loadingString.value = "Memuat Data...";
          }

          this.listLembur.refresh();
          this.listLemburAll.refresh();
          this.loadingString.refresh();
        }
      }
    });
  }

  // void loadAllEmployeeDelegasi() {
  //   print("load delegasi");
  //   allEmployeeDelegasi.value.clear();
  //   allEmployee.value.clear();
  //   var dataUser = AppData.informasiUser;
  //   var getDepGroup = dataUser![0].dep_group;
  //   var full_name = dataUser[0].full_name;
  //   Map<String, dynamic> body = {'val': 'dep_group_id', 'cari': getDepGroup};
  //   var connect = Api.connectionApi("post", body, "whereOnce-employee");
  //   connect.then((dynamic res) {
  //     if (res == false) {
  //       UtilsAlert.koneksiBuruk();
  //     } else {
  //       if (res.statusCode == 200) {
  //         var valueBody = jsonDecode(res.body);
  //         var data = valueBody['data'];
  //         for (var element in data) {
  //           if (element['status'] == 'ACTIVE') {
  //             var fullName = element['full_name'] ?? "";
  //             String namaUser = "$fullName";
  //             if (namaUser != full_name) {
  //               allEmployeeDelegasi.value.add(namaUser);
  //             }
  //             allEmployee.value.add(element);
  //           }
  //         }
  //         if (idpengajuanLembur.value == "") {
  //           var listFirst = valueBody['data'].first;
  //           var fullName = listFirst['full_name'] ?? "";
  //           String namaUserPertama = "$fullName";
  //           selectedDropdownDelegasi.value = namaUserPertama;
  //         }
  //         this.allEmployee.refresh();
  //         this.allEmployeeDelegasi.refresh();
  //         this.selectedDropdownDelegasi.refresh();
  //       }
  //     }
  //   });
  // }

  void loadAllEmployeeDelegasi() {
    allEmployeeDelegasi.value.clear();
    allEmployee.value.clear();
    var dataUser = AppData.informasiUser;
    var getDepGroup = dataUser![0].dep_group;
    var full_name = dataUser[0].full_name;
    var emid = dataUser[0].em_id;
    Map<String, dynamic> body = {'em_id': emid, 'dep_group_id': getDepGroup};
    var connect = Api.connectionApi("post", body, "employee-delegasi");
    connect.then((dynamic res) {
      if (res == false) {
        print('ini error');
      } else {
        if (res.statusCode == 200) {
          var valueBody = jsonDecode(res.body);
          var data = valueBody['data'];
          for (var element in data) {
            if (element['status'] == 'ACTIVE') {
              var fullName = element['full_name'] ?? "";
              String namaUser = "$fullName";
              if (namaUser != full_name) {
                allEmployeeDelegasi.value.add(namaUser);
              }
              allEmployee.value.add(element);
            }
          }
          if (idpengajuanLembur.value == "") {
            List data = valueBody['data'];
            if (body.isNotEmpty){
  var listFirst = data
                .where((element) => element['full_name'] != full_name)
                .toList();
                
            var fullName = listFirst.isNotEmpty?listFirst[0]['full_name']:"r";
            String namaUserPertama = "$fullName";
            selectedDropdownDelegasi.value = namaUserPertama;

            }
          
          }

          this.allEmployee.refresh();
          this.allEmployeeDelegasi.refresh();
          this.selectedDropdownDelegasi.refresh();
        } else {
          print('ini error ${res.statusCode} ${res.body}');
        }
      }
    });
  }

  void checkingDelegation(em_id) {
    var getData =
        allEmployee.value.firstWhere((element) => element["em_id"] == em_id);
    selectedDropdownDelegasi.value = getData['full_name'];
    this.selectedDropdownDelegasi.refresh();
  }

  void infoIds(emIds) {
    var listEmId = emIds.split(",");
    print("info delegasi");
    selectedDropdownEmploy.clear();
    for (var emId in listEmId) {
      Map<String, dynamic> body = {
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
            selectedDropdownEmploy.add(fullName);
          } else if (valueBody['data'] is Map) {
            var fullName = valueBody['data']['full_name'];
            print('Full name for $emId: $fullName');
            print('ini kepanggil');
            selectedDropdownEmploy.add(fullName);
          } else {
            print('Unexpected data format for $emId');
          }
        }
      }).catchError((e) {
        print('Error fetching data for $emId: $e');
      });
    }
  }

  void infoTask(emPengaju) {
    listTask.clear();
    Map<String, dynamic> body = {'nomor_ajuan': emPengaju};
    print('ini body infoTask $body');
    var connect = Api.connectionApi("post", body, "lembur/detail");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        if (valueBody['data'] is List) {
          for (var task in valueBody['data']) {
            listTask.add(task);
            print('task: $listTask');
          }
          listTask.refresh();
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


  void validasiKirimPengajuan() {
    print("data selected ${selectedTypeLembur.value}");
    bool isTaskEmpty = listTask.any((task) => task['task'].trim().isEmpty);
    print('ini isTaskEmpaty ${isTaskEmpty}');
    if (statusDraft.value != 'draft') {
      if (selectedTypeLembur.value == '') {
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
            content: " Anda belum punya hak lembur, kalau ada pertanyaan silahkan menghubungi HRD",
            positiveBtnText: "Hubungi HRD",
            negativeBtnText: "Tidak",
            style: 1,
            buttonStatus: 1,
            negativeBtnPressed: (){
              loadDataLembur();
              Get.back();
              Get.back();
            },
            positiveBtnPressed: () async {
              var global = globalCt.dataHrd[0];
              print('ini glonal hrd ${global}');
              var full_name =
                          global[0]['full_name'];
                      
                      var nohp = global[0]['em_mobile'];
                      var jeniKelamin =
                          global[0]['em_gender'];
              globalCt.kirimKonfirmasiWaHrd(full_name, nohp, jeniKelamin);
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
      if (tanggalLembur.value.text == "" ||
          dariJam.value.text == "" ||
          sampaiJam.value.text == "" ||
          catatan.value.text == "" ||
          selectedDropdownDelegasi.value == "" ||
          selectedDropdownEmploy.isEmpty
          ) {
        print('ini kepangil');
        UtilsAlert.showToast("Lengkapi form *");
      } else if (isTaskEmpty) {
        UtilsAlert.showToast("Wajib isi keterangan task");
      } else if (listTask.isEmpty) {
        UtilsAlert.showToast("Isi Task terlebih dahulu");
      } 
      else {
        if (statusForm.value == false) {
          print('ini kepangil');
          UtilsAlert.loadingSimpanData(Get.context!, "Sedang Menyimpan");
          checkNomorAjuan();
        } else {
          print('ini kepangil');
          UtilsAlert.loadingSimpanData(Get.context!, "Sedang Menyimpan");
          kirimPengajuan(nomorAjuan.value.text);
        }
      }
    } else {
      kirimPengajuan(nomorAjuan.value.text);
    }
  }

  void checkNomorAjuan() {
    var listTanggal = tanggalLembur.value.text.split(',');
    var getTanggal = listTanggal[1].replaceAll(' ', '');
    var tanggalLemburEditData = Constanst.convertDateSimpan(getTanggal);
    var polaFormat = DateFormat('yyyy-MM-dd');
    var tanggalPengajuanInsert = polaFormat.format(initialDate.value);
    var finalTanggalPengajuan = statusForm.value == false
        ? tanggalPengajuanInsert
        : tanggalLemburEditData;

    Map<String, dynamic> body = {
      'atten_date': finalTanggalPengajuan,
      'pola': 'LB'
    };
    var connect = Api.connectionApi("post", body, "emp_labor_lastrow");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        if (valueBody['status'] == true) {
          var data = valueBody['data'];
          print(data);
          if (valueBody['data'].length == 0) {
            var now = DateTime.now();
            var convertBulan = now.month <= 9 ? "0${now.month}" : now.month;
            var finalNomor = "LB${now.year}${convertBulan}0001";
            kirimPengajuan(finalNomor);
          } else {
            var getNomorAjuanTerakhir = valueBody['data'][0]['nomor_ajuan'];
            var keyNomor = getNomorAjuanTerakhir.replaceAll("LB", '');
            var hasilTambah = int.parse(keyNomor) + 1;
            var finalNomor = "LB$hasilTambah";
            print("final nomor ${finalNomor}");
            kirimPengajuan(finalNomor);
          }
        } else {
          UtilsAlert.showToast(
              "Data periode $finalTanggalPengajuan belum tersedia, harap hubungi HRD");
        }
      }
    });
  }

  void checkNomorAjuanDalamAntrian(nomorAjuanTerakhirDalamAntrian) {
    var getNomorAjuanTerakhir = nomorAjuanTerakhirDalamAntrian;
    var keyNomor = getNomorAjuanTerakhir.replaceAll("LB", '');
    var hasilTambah = int.parse(keyNomor) + 1;
    var finalNomor = "LB$hasilTambah";
    kirimPengajuan(finalNomor);
  }

  void kirimPengajuan(getNomorAjuanTerakhir) {
    // check id type lembur
    var finalIdLembur = checkLembur();
    var listTanggal = tanggalLembur.value.text.split(',');
    var getTanggal = listTanggal.isNotEmpty && listTanggal[0].trim().isNotEmpty
        ? (listTanggal.length > 1
            ? listTanggal[1].trim()
            : listTanggal[0].trim())
        : DateFormat('yyyy-MM-dd')
            .format(DateTime.now()); // Gunakan tanggal sekarang jika kosong

    print('ini get tanggal ${getTanggal}');
    var tanggalLemburEditData;
    var polaFormat = DateFormat('yyyy-MM-dd');
    var tanggalPengajuanInsert;
    try {
      tanggalLemburEditData = Constanst.convertDateSimpan(getTanggal);
      tanggalPengajuanInsert = polaFormat.format(initialDate.value);
      print('Tanggal berhasil dikonversi: $tanggalLemburEditData');
      print('Tanggal berhasil dikonversi: $tanggalPengajuanInsert');
    } catch (e) {
      print('Error saat mengonversi tanggal: $e');
      tanggalLemburEditData = polaFormat.format(DateTime.now());
      tanggalPengajuanInsert = polaFormat.format(DateTime.now());
    }
    var dataUser = AppData.informasiUser;
    var getEmid = dataUser![0].em_id;
    var getFullName = dataUser[0].full_name;
    var validasiDelegasiSelected = validasiSelectedDelegasi();
    var validasiEmploySelected = validasiSelectedEmploy();
    var validasiDelegasiSelectedToken = validasiSelectedDelegasiToken();

    var finalTanggalPengajuan = statusForm.value == false
        ? tanggalPengajuanInsert
        : tanggalLemburEditData;
    var hasilDurasi = hitungDurasi();
    var body = {
      'em_id': getEmid,
      'typeid': finalIdLembur,
      'nomor_ajuan': getNomorAjuanTerakhir,
      'dari_jam': dariJam.value.text == '' ? '00:00:00' : dariJam.value.text,
      'sampai_jam':
          sampaiJam.value.text == '' ? '00:00:00' : sampaiJam.value.text,
      'durasi': hasilDurasi,
      'atten_date': finalTanggalPengajuan,
      'status': 'PENDING',
      'approve_date': '',
      'em_delegation': validasiDelegasiSelected,
      'em_ids': validasiEmploySelected,
      'tasks': listTask,
      'uraian': catatan.value.text,
      'ajuan': '1',
      'created_by': getEmid,
      'menu_name': 'Lembur',
      'approve_status': "pending",
      'status_pengajuan': statusDraft.value
    };
    var typeNotifFcm = "Pengajuan Lembur";
    print('ini body $body');
    print('ini status form ${statusForm.value}');
    if (statusDraft != 'draft') {
      if (statusForm.value == false) {
        print("sampe sini input");
        body['activity_name'] =
            "Membuat Pengajuan Lembur. alasan = ${catatan.value.text}";
        var connect = Api.connectionApi("post", body, "lembur");
        connect.then((dynamic res) {
          var valueBody = jsonDecode(res.body);
          if (res.statusCode == 200) {
            if (valueBody['status'] == true) {
              var stringWaktu =
                  "${dariJam.value.text} sd ${sampaiJam.value.text}";
              // kirimNotifikasiToDelegasi(
              //     getFullName,
              //     finalTanggalPengajuan,
              //     validasiDelegasiSelected,
              //     validasiDelegasiSelectedToken,
              //     stringWaktu,
              //     typeNotifFcm);
              // kirimNotifikasiToReportTo(getFullName, finalTanggalPengajuan,
              //     getEmid, "Lembur", stringWaktu);
              Navigator.pop(Get.context!);
              var pesan1 = "Pengajuan lembur berhasil dibuat";
              var pesan2 =
                  "Selanjutnya silahkan menunggu atasan kamu untuk menyetujui pengajuan yang telah dibuat atau langsung";
              var pesan3 = "konfirmasi via WhatsApp";
              var dataPengajuan = {
                'nameType': 'LEMBUR',
                'nomor_ajuan': '${getNomorAjuanTerakhir}',
              };
              for (var item in globalCt.konfirmasiAtasan) {
                print(item['token_notif']);
                var pesan;
                if (item['em_gender'] == "PRIA") {
                  pesan =
                      "Hallo pak ${item['full_name']}, saya ${getFullName} mengajukan LEMBUR dengan nomor ajuan ${getNomorAjuanTerakhir}";
                } else {
                  pesan =
                      "Hallo bu ${item['full_name']}, saya ${getFullName} mengajukan LEMBUR dengan nomor ajuan ${getNomorAjuanTerakhir}";
                }
                // kirimNotifikasiToDelegasi1(
                //     getFullName,
                //     finalTanggalPengajuan,
                //     item['em_id'],
                //     validasiDelegasiSelectedToken,
                //     stringWaktu,
                //     typeNotifFcm,
                //     pesan);

                // if (item['token_notif'] != null) {
                //   globalCt.kirimNotifikasiFcm(
                //       title: typeNotifFcm,
                //       message: pesan,
                //       tokens: item['token_notif']);
                // }
              }

              Get.offAll(BerhasilPengajuan(
                dataBerhasil: [pesan1, pesan2, pesan3, dataPengajuan],
              ));
            } else {
              if (valueBody['message'] == "ulang") {
                var nomorAjuanTerakhirDalamAntrian =
                    valueBody['data'][0]['nomor_ajuan'];
                checkNomorAjuanDalamAntrian(nomorAjuanTerakhirDalamAntrian);
              }
              if (valueBody['message'] == "date") {
                Navigator.pop(Get.context!);
                UtilsAlert.showToast(valueBody['error']);
              } else {
                Navigator.pop(Get.context!);
                UtilsAlert.showToast(
                    "Data periode $finalTanggalPengajuan belum tersedia, harap hubungi HRD");
              }
            }
          } else {
            Get.back();
            UtilsAlert.showToast(valueBody['message']);
          }
        });
      } else {
        print('ini id pengajuan lembur : ${idpengajuanLembur.value}');
        body['id'] = idpengajuanLembur.value;
        body['cari'] = finalIdLembur;
        body['activity_name'] =
            "Edit Pengajuan Lembur. Tanggal Pengajuan = $finalTanggalPengajuan";
        var connect = Api.connectionApi("post", body, "edit-lembur");
        connect.then((dynamic res) {
          var valueBody = jsonDecode(res.body);
          if (res.statusCode == 200) {
            Navigator.pop(Get.context!);
            var pesan1 = "Pengajuan lembur berhasil di edit";
            var pesan2 =
                "Selanjutnya silahkan menunggu atasan kamu untuk menyetujui pengajuan yang telah dibuat atau langsung";
            var pesan3 = "konfirmasi via WhatsApp";
            var dataPengajuan = {
              'nameType': 'LEMBUR',
              'nomor_ajuan': '${getNomorAjuanTerakhir}',
            };
            Get.offAll(BerhasilPengajuan(
              dataBerhasil: [pesan1, pesan2, pesan3, dataPengajuan],
            ));
          } else {
            Get.back();
            print(body);
            print('error edit lembur ${res.statusCode} ${res.body}');
            UtilsAlert.showToast(valueBody['message']);
          }
        });
      }
    } else {
      if (statusForm.value == false) {
        var connect = Api.connectionApi("post", body, "lembur_draft");
        connect.then((dynamic res) {
          var valueBody = jsonDecode(res.body);
          if (res.statusCode == 200) {
            if (valueBody['status'] == true) {
              UtilsAlert.showToast('Berhasil Simpan Draft');
              loadDataLembur();
            }
          }
        });
      } else {
        body['id'] = idpengajuanLembur.value;
        body['cari'] = finalIdLembur;
        var connect = Api.connectionApi("post", body, "lembur_draft_update");
        connect.then((dynamic res) {
          var valueBody = jsonDecode(res.body);
          if (res.statusCode == 200) {
            if (valueBody['status'] == true) {
              UtilsAlert.showToast('Berhasil Edit Draft');
              loadDataLembur();
            }
          }
        });
      }
    }
  }

  void changeTypeAjuan(name) {
    var filter = name == "Approve 1"
        ? "Approve"
        : name == "Approve 2"
            ? "Approve2"
            : name == "Rejected"
                ? "Rejected"
                : name == "Pending"
                    ? "Pending"
                    : "Approve";
    for (var element in dataTypeAjuan.value) {
      if (element['nama'] == name) {
        element['status'] = true;
      } else {
        element['status'] = false;
      }
    }
    this.dataTypeAjuan.refresh();
    var dataFilter = [];
    listLemburAll.value.forEach((element) {
      if (name == "Semua Status") {
        dataFilter.add(element);
      } else {
        if (element['status'] == filter) {
          dataFilter.add(element);
        }
      }
    });
    listLembur.value = dataFilter;
    this.listLembur.refresh();
    if (dataFilter.isEmpty) {
      loadingString.value = "Anda tidak memiliki\nRiwayat Pengajuan Lembur";
    } else {
      loadingString.value = "Memuat Data...";
    }
  }

  String checkLembur() {
    var result = "";
    for (var element in allTypeLembur.value) {
      if (element['name'] == selectedTypeLembur.value) {
        result = "${element['id']}";
      }
    }
    return result;
  }

  void cariData(value) {
    var textCari = value.toLowerCase();
    var filter = listLemburAll.where((ajuan) {
      var getAjuan = ajuan['nomor_ajuan'].toLowerCase();
      return getAjuan.contains(textCari);
    }).toList();
    listLembur.value = filter;
    statusCari.value = true;
    this.listLembur.refresh();
    this.statusCari.refresh();

    if (listLembur.value.isEmpty) {
      loadingString.value = "Anda tidak memiliki\nRiwayat Pengajuan Lembur";
    } else {
      loadingString.value = "Memuat data...";
    }
    this.loadingString.refresh();
  }

  void kirimNotifikasiToDelegasi(getFullName, convertTanggalBikinPengajuan,
      validasiDelegasiSelected, fcmTokenDelegasi, stringWaktu, typeNotifFcm) {
    var dt = DateTime.now();
    var jamSekarang = DateFormat('HH:mm:ss').format(dt);
    // var description =
    //     'Anda mendapatkan delegasi pekerjaan dari $getFullName untuk Pengajuan Lembur, waktu pengajuan $stringWaktu';

    var description =
        'Anda mendapatkan pengajuan lembur dari $getFullName dengan pemberi tugas anda, waktu pengajuan $stringWaktu';
    Map<String, dynamic> body = {
      'em_id': validasiDelegasiSelected,
      'title': 'Pemberi Tugas Pengajuan Lembur',
      'deskripsi': description,
      'url': '',
      'atten_date': convertTanggalBikinPengajuan,
      'jam': jamSekarang,
      'status': '2',
      'view': '0',
    };
    var connect = Api.connectionApi("post", body, "insert-notifikasi");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        globalCt.kirimNotifikasiFcm(
            title: typeNotifFcm,
            message: description,
            tokens: fcmTokenDelegasi);
        // UtilsAlert.showToast("Berhasil kirim delegasi");
      }
    });
  }

  void kirimNotifikasiToDelegasi1(
      getFullName,
      convertTanggalBikinPengajuan,
      validasiDelegasiSelected,
      fcmTokenDelegasi,
      stringWaktu,
      typeNotifFcm,
      pesan) {
    var dt = DateTime.now();
    var jamSekarang = DateFormat('HH:mm:ss').format(dt);
    // var description =
    //     'Anda mendapatkan delegasi pekerjaan dari $getFullName untuk Pengajuan Lembur, waktu pengajuan $stringWaktu';

    var description =
        'Anda mendapatkan pengajuan lembur dari $getFullName dengan pemberi tugas anda, waktu pengajuan $stringWaktu';
    Map<String, dynamic> body = {
      'em_id': validasiDelegasiSelected,
      'title': 'Approval Lembur',
      'deskripsi': pesan,
      'url': '',
      'atten_date': convertTanggalBikinPengajuan,
      'jam': jamSekarang,
      'status': '2',
      'view': '0',
    };
    var connect = Api.connectionApi("post", body, "insert-notifikasi");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        // globalCt.kirimNotifikasiFcm(
        //     title: typeNotifFcm,
        //     message: description,
        //     tokens: fcmTokenDelegasi);
        // UtilsAlert.showToast("Berhasil kirim delegasi");
      }
    });
  }

  void kirimNotifikasiToReportTo(
      getFullName, convertTanggalBikinPengajuan, getEmid, type, stringWaktu) {
    var dt = DateTime.now();
    var jamSekarang = DateFormat('HH:mm:ss').format(dt);
    Map<String, dynamic> body = {
      'emId_pengaju': getEmid,
      'title': 'Pengajuan Lembur',
      'deskripsi':
          'Anda mendapatkan pengajuan $type dari $getFullName, waktu pengajuan $stringWaktu',
      'url': '',
      'atten_date': convertTanggalBikinPengajuan,
      'jam': jamSekarang,
      'status': '2',
      'view': '0',
    };
    var connect = Api.connectionApi("post", body, "notifikasi_reportTo");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        UtilsAlert.showToast("Pengajuan berhasil di kirim");
      }
    });
  }

  String validasiSelectedDelegasi() {
    var result = [];
    for (var element in allEmployee.value) {
      var fullName = element['full_name'] ?? "";
      var namaElement = "$fullName";
      if (namaElement == selectedDropdownDelegasi.value) {
        result.add(element['em_id']);
      }
    }
    return result[0];
  }

  String validasiSelectedEmploy() {
    var result = <String>{};
    for (var selectedName in selectedDropdownEmploy) {
      for (var element in infoEmployeeAll.value) {
        var fullName = element['full_name'] ?? "";
        if (fullName == selectedName) {
          print('ini fullName $fullName');
          result.add(element['em_id']);
        }
      }
    }
    return result.join(',');
  }

  String validasiSelectedDelegasiToken() {
    var result = [];
    for (var element in allEmployee.value) {
      var fullName = element['full_name'] ?? "";
      var namaElement = "$fullName";
      if (namaElement == selectedDropdownDelegasi.value) {
        result.add(element);
      }
    }
    return "${result[0]['token_notif']}";
  }

  String hitungDurasi() {
    var format = DateFormat("HH:mm");

    try {
      // Cek apakah input kosong, jika iya, gunakan waktu sekarang dengan format "HH:mm"
      String dariText = dariJam.value.text.isNotEmpty
          ? dariJam.value.text
          : format.format(DateTime.now());
      String sampaiText = sampaiJam.value.text.isNotEmpty
          ? sampaiJam.value.text
          : format.format(DateTime.now());

      // Parsing jam
      var dari = format.parse(dariText);
      var sampai = format.parse(sampaiText);

      // Jika 'sampai' lebih kecil dari 'dari', tambahkan satu hari ke 'sampai'
      if (sampai.isBefore(dari)) {
        sampai = sampai.add(Duration(days: 1));
      }

      // Hitung durasi dalam jam dan menit
      Duration durasi = sampai.difference(dari);
      int jam = durasi.inHours;
      int menit = durasi.inMinutes % 60;

      // Format output menjadi HH:mm
      return "${jam.toString().padLeft(2, '0')}:${menit.toString().padLeft(2, '0')}";
    } catch (e) {
      print('Error parsing date: $e');
      return "00:00"; // Default return jika terjadi error
    }
  }

  void showModalBatalPengajuan(index) {
    showModalBottomSheet(
      context: Get.context!,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0),
        ),
      ),
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 90,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Constanst.colorBGRejected,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  Iconsax.minus_cirlce,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 6),
                              child: Padding(
                                padding: EdgeInsets.only(top: 6),
                                child: Text(
                                  "Batalkan Pengajuan Lembur",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 10,
                          child: InkWell(
                            onTap: () => Navigator.pop(Get.context!),
                            child: Padding(
                              padding: EdgeInsets.only(top: 6),
                              child: Icon(Iconsax.close_circle),
                            ),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Data pengajuan yang telah kamu buat akan di hapus. Yakin ingin membatalkan pengajuan?",
                    textAlign: TextAlign.justify,
                    style: TextStyle(color: Constanst.colorText2),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: TextButtonWidget(
                            title: "Ya, Batalkan",
                            onTap: () async {
                              batalkanPengajuan(index);
                            },
                            colorButton: Constanst.colorButton1,
                            colortext: Constanst.colorWhite,
                            border: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => Navigator.pop(Get.context!),
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: Constanst.borderStyle2,
                                  border: Border.all(
                                      color: Constanst.colorPrimary)),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 12, bottom: 12),
                                  child: Text(
                                    "Urungkan",
                                    style: TextStyle(
                                        color: Constanst.colorPrimary),
                                  ),
                                ),
                              )),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 16,
            )
          ],
        );
      },
    );
  }

  void showDetailLembur(detailData, approve, alasanReject) {
    print('ini showDetailDataLembur $detailData');
    var nomorAjuan = detailData['nomor_ajuan'];
    var dinalai = detailData['dinalai'];
    var id_lembur = detailData['id'];
    infoTask(id_lembur);
    var tanggalMasukAjuan = detailData['atten_date'];
    var tanggalAjuan = detailData['tgl_ajuan'];
    var namaTypeAjuan = detailData['type'];
    var uraian = detailData['uraian'];
    var durasi = detailData['leave_duration'];
    var status;
    if (valuePolaPersetujuan.value == "1") {
      status = detailData['status'];
    } else {
      status = detailData['status'] == "Approve"
          ? "Approve 1"
          : detailData['status'] == "Approve2"
              ? "Approve 2"
              : detailData['status'];
    }
    var leave_files = detailData['leave_files'];
    var dariJam = detailData['dari_jam'];
    var sampaiJam = detailData['sampai_jam'];
    // var listTanggalTerpilih = detailData['date_selected'].split(',');
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      builder: (context) {
        return Container(
          // height: MediaQuery.of(context).size.height * 0.75,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),
                  Center(
                    child: Container(
                        height: 6,
                        width: 34,
                        decoration: BoxDecoration(
                            color: Constanst.colorNeutralBgTertiary,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20.0),
                            ))),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Constanst.colorNonAktif)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Tanggal Pengajuan",
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Constanst.fgSecondary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  Constanst.convertDate6(tanggalAjuan),
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Constanst.fgPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "No. Pengajuan",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Constanst.fgSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                nomorAjuan,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Constanst.fgPrimary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Constanst.colorNonAktif)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tipe lembur",
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Constanst.fgSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "$namaTypeAjuan",
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Constanst.fgPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Divider(
                            height: 0,
                            thickness: 1,
                            color: Constanst.border,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Tanggal Lembur",
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Constanst.fgSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            tanggalMasukAjuan,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Constanst.fgPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Divider(
                            height: 0,
                            thickness: 1,
                            color: Constanst.border,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Dari Jam",
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: Constanst.fgSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      dariJam,
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Constanst.fgPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Divider(
                                      height: 0,
                                      thickness: 1,
                                      color: Constanst.border,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Sampai Jam",
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: Constanst.fgSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      sampaiJam,
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Constanst.fgPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Divider(
                                      height: 0,
                                      thickness: 1,
                                      color: Constanst.border,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Catatan",
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Constanst.fgSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "$uraian",
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Constanst.fgPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Divider(
                            height: 0,
                            thickness: 1,
                            color: Constanst.border,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Rincian tugas",
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Constanst.fgSecondary,
                            ),
                          ),
                          Obx(() {
                            return Column(
                              children: [
                                ...listTask.asMap().entries.map((entry) {
                                  var index = entry.key;
                                  var task = entry.value;
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "${index + 1}. ${task['task']}",
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: Constanst.fgPrimary,
                                            ),
                                          ),
                                        ),
                                        dinilai == "Y"
                                            ? Text(
                                                '${task['persentase'].toString()}%',
                                                style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                  color: Constanst.fgPrimary,
                                                ),
                                              )
                                            : SizedBox(),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            );
                          }),
                          const SizedBox(height: 12),
                          leave_files == "" ||
                                  leave_files == "NULL" ||
                                  leave_files == null
                              ? const SizedBox()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Divider(
                                      height: 0,
                                      thickness: 1,
                                      color: Constanst.border,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      "File disematkan",
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: Constanst.fgSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    InkWell(
                                        onTap: () {
                                          viewLampiranAjuan(leave_files);
                                        },
                                        child: Text(
                                          "$leave_files",
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: Constanst.fgPrimary,
                                          ),
                                        )),
                                    const SizedBox(height: 12),
                                  ],
                                ),
                          Divider(
                            height: 0,
                            thickness: 1,
                            color: Constanst.border,
                          ),
                          const SizedBox(height: 12),
                          status == 'Rejected'
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Iconsax.close_circle,
                                      color: Constanst.color4,
                                      size: 22,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Rejected by $approve",
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w500,
                                                color: Constanst.fgPrimary,
                                                fontSize: 14),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            alasanReject,
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w400,
                                                color: Constanst.fgSecondary,
                                                fontSize: 14),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : status == "Approve" ||
                                      status == "Approve 1" ||
                                      status == "Approve 2"
                                  ? Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Iconsax.tick_circle,
                                          color: Colors.green,
                                          size: 22,
                                        ),
                                        const SizedBox(width: 8),
                                        Text("Approved by $approve",
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w500,
                                                color: Constanst.fgPrimary,
                                                fontSize: 14)),
                                      ],
                                    )
                                  : Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Iconsax.timer,
                                          color: Constanst.color3,
                                          size: 22,
                                        ),
                                        const SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Pending Approval",
                                                style: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w500,
                                                    color: Constanst.fgPrimary,
                                                    fontSize: 14)),
                                            const SizedBox(height: 4),
                                            InkWell(
                                                onTap: () {
                                                  var dataEmployee = {
                                                    'nameType':
                                                        '$namaTypeAjuan',
                                                    'nomor_ajuan':
                                                        '$nomorAjuan',
                                                  };
                                                  globalCt.showDataPilihAtasan(
                                                      dataEmployee);
                                                },
                                                child: Text(
                                                    "Konfirmasi via Whatsapp",
                                                    style: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            Constanst.infoLight,
                                                        fontSize: 14))),
                                          ],
                                        ),
                                      ],
                                    ),
                        ],
                      ),
                    ),
                  ),
                  status == "Approve" ||
                          status == "Approve 1" ||
                          status == "Approve 2"
                      ? Container()
                      : status == "Rejected"
                          ? Container()
                          : Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 40,
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      margin:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Constanst
                                              .border, // Set the desired border color
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // Get.back();
                                          batalkanPengajuan(detailData);
                                        },
                                        style: ElevatedButton.styleFrom(
                                            foregroundColor: Constanst.color4,
                                            backgroundColor:
                                                Constanst.colorWhite,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            elevation: 0,
                                            // padding: EdgeInsets.zero,
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 0)),
                                        child: Text(
                                          'Batalkan',
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              color: Constanst.color4,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: SizedBox(
                                      height: 40,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Get.to(FormLembur(
                                            dataForm: [detailData, true],
                                          ));
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Constanst.colorWhite,
                                          backgroundColor:
                                              Constanst.colorPrimary,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          elevation: 0,
                                          // padding: const EdgeInsets.fromLTRB(20, 12, 20, 12)
                                        ),
                                        child: Text(
                                          'Edit',
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              color: Constanst.colorWhite,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void viewLampiranAjuan(value) async {
    var urlViewGambar = Api.UrlfileCuti + value;

    final url = Uri.parse(urlViewGambar);
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      UtilsAlert.showToast('Tidak dapat membuka file');
    }
  }

  void batalkanPengajuan(index) {
    UtilsAlert.loadingSimpanData(Get.context!, "Batalkan Pengajuan");
    var dataUser = AppData.informasiUser;
    var getEmid = dataUser![0].em_id;
    Map<String, dynamic> body = {
      'menu_name': 'Lembur',
      'activity_name':
          'Membatalkan form pengajuan Lembur. Waktu Lembur = ${index["dari_jam"]} sd ${index["sampai_jam"]} Alasan Pengajuan = ${index["reason"]} Tanggal Pengajuan = ${index["atten_date"]}',
      'created_by': '$getEmid',
      'val': 'id',
      'cari': '${index["id"]}',
      'status_transaksi': 0,
      'atten_date': '${index["atten_date"]}',
    };
    var connect = Api.connectionApi("post", body, "edit-emp_labor");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        Navigator.pop(Get.context!);
        Navigator.pop(Get.context!);
        UtilsAlert.showToast("Berhasil batalkan pengajuan");
        onReady();
      }
    });
  }
}
