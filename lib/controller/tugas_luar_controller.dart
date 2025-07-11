import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/global_controller.dart';
import 'package:siscom_operasional/screen/absen/form/berhasil_pengajuan.dart';
import 'package:siscom_operasional/screen/absen/form/form_lembur.dart';
import 'package:siscom_operasional/screen/absen/form/form_tugas_luar.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/custom_dialog.dart';
import 'package:siscom_operasional/utils/widget_textButton.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class TugasLuarController extends GetxController {
  var nomorAjuan = TextEditingController().obs;
  var tanggalTugasLuar = TextEditingController().obs;
  var dariJam = TextEditingController().obs;
  var sampaiJam = TextEditingController().obs;
  var catatan = TextEditingController().obs;
  var cari = TextEditingController().obs;
  var dariTanggal = TextEditingController().obs;
  var sampaiTanggal = TextEditingController().obs;

  var tanggalSelectedEdit = <DateTime>[].obs;

  Rx<List<String>> allEmployeeDelegasi = Rx<List<String>>([]);
  Rx<List<String>> allTipeFormTugasLuar = Rx<List<String>>([]);

  var statusFormPencarian = false.obs;

  var tempNamaStatus1 = "Semua Status".obs;
  var tempNamaTipe1 = "Tugas Luar".obs;

  var bulanSelectedSearchHistory = "".obs;
  var tahunSelectedSearchHistory = "".obs;
  var bulanDanTahunNow = "".obs;
  var selectedDropdownDelegasi = "".obs;
  var idpengajuanTugasLuar = "".obs;
  var emDelegation = "".obs;
  var valuePolaPersetujuan = "".obs;
  var idEditFormTugasLuar = "".obs;
  var selectedDropdownFormTugasLuarTipe = "".obs;
  var stringSelectedTanggal = "".obs;
  var loadingString = "Sedang Memuat...".obs;

  var statusForm = false.obs;
  var directStatus = false.obs;
  var showButtonlaporan = false.obs;
  var statusCari = false.obs;
  var viewTugasLuar = true.obs;
  var screenTanggalSelected = true.obs;

  var selectedType = 0.obs;
  var durasiIzin = 0.obs;

  var listTugasLuar = [].obs;
  var listTugasLuarAll = [].obs;

  var listDinasLuar = [].obs;
  var listDinasLuarAll = [].obs;

  var allEmployee = [].obs;
  var dataTypeAjuan = [].obs;
  var departementAkses = [].obs;
  var tanggalSelected = [].obs;

  Rx<DateTime> initialDate = DateTime.now().obs;

  var dataTypePengajuan = ["Tugas Luar", "Dinas Luar"];

  var dataTypeAjuanDummy1 = ["Semua Status", "Approve", "Rejected", "Pending"];
  var dataTypeAjuanDummy2 = [
    "Semua Status",
    "Approve 1",
    "Approve 2",
    "Rejected",
    "Pending"
  ];

  GlobalController globalCt = Get.find<GlobalController>();

  // @override
  // void onReady() async {
  //   super.onReady();
  //   getTimeNow();
  //   getLoadsysData();
  //   loadTipePengajuan();
  //   loadDataTugasLuar();
  //   loadDataDinasLuar();
  //   loadAllEmployeeDelegasi();
  //   getDepartemen(1, "");
  // }

  @override
  void onInit() {
    getTimeNow();
    getLoadsysData();
    loadTipePengajuan();
    loadDataTugasLuar();
    loadDataDinasLuar();
    getDepartemen(1, "");
    loadAllEmployeeDelegasi();
    super.onInit();
  }

  void removeAll() {
    tanggalTugasLuar.value.text = "";
    dariJam.value.text = "";
    sampaiJam.value.text = "";
    catatan.value.text = "";
  }

  void showInputCari() {
    statusFormPencarian.value = !statusFormPencarian.value;
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

  void loadTipePengajuan() {
    for (var element in dataTypePengajuan) {
      allTipeFormTugasLuar.value.add("$element");
    }
    var listFirst = allTipeFormTugasLuar.value.first;
    selectedDropdownFormTugasLuarTipe.value = listFirst;
  }

  void gantiTypeAjuan(value) {
    if (value == "Tugas Luar") {
      viewTugasLuar.value = true;
    } else if (value == "Dinas Luar") {
      viewTugasLuar.value = false;
    }
    selectedDropdownFormTugasLuarTipe.value = value;
    this.viewTugasLuar.refresh();
    this.selectedDropdownFormTugasLuarTipe.refresh();
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

  void getTimeNow() {
    var dt = DateTime.now();
    bulanSelectedSearchHistory.value = "${dt.month}";
    tahunSelectedSearchHistory.value = "${dt.year}";
    bulanDanTahunNow.value = "${dt.month}-${dt.year}";

    if (idpengajuanTugasLuar.value == "") {
      tanggalTugasLuar.value.text =
          Constanst.convertDate("${initialDate.value}");
    }

    this.tanggalTugasLuar.refresh();
    this.bulanSelectedSearchHistory.refresh();
    this.tahunSelectedSearchHistory.refresh();
    this.bulanDanTahunNow.refresh();
  }

  void loadDataTugasLuar() {
    listTugasLuarAll.value.clear();
    listTugasLuar.value.clear();
    var dataUser = AppData.informasiUser;
    var getEmid = dataUser![0].em_id;
    Map<String, dynamic> body = {
      'em_id': getEmid,
      'bulan': bulanSelectedSearchHistory.value,
      'tahun': tahunSelectedSearchHistory.value,
      'status': '2'
    };
    var connect = Api.connectionApi("post", body, "history-emp_labor");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        if (valueBody['status'] == false) {
          loadingString.value = "Tidak ada pengajuan";
          this.loadingString.refresh();
        } else {
          for (var element in valueBody['data']) {
            if (element['ajuan'] == 2) {
              listTugasLuar.value.add(element);
              listTugasLuarAll.value.add(element);
            }
          }

          if (listTugasLuar.value.length == 0) {
            loadingString.value = "Tidak ada pengajuan";
          } else {
            loadingString.value = "Sedang Memuat...";
          }

          this.listTugasLuar.refresh();
          this.loadingString.refresh();
        }
      }
    });
  }

  void loadDataDinasLuar() {
    print("Load data dinas luar");
    listDinasLuar.value.clear();
    listDinasLuarAll.value.clear();
    var dataUser = AppData.informasiUser;
    var getEmid = dataUser![0].em_id;
    Map<String, dynamic> body = {
      'em_id': getEmid,
      'bulan': bulanSelectedSearchHistory.value,
      'tahun': tahunSelectedSearchHistory.value,
    };

    var connect = Api.connectionApi("post", body, "emp_leave_load_dinasluar");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);

        if (valueBody['status'] == false) {
          loadingString.value = "Tidak ada pengajuan";
          this.loadingString.refresh();
        } else {
          print("data dinas luar ${valueBody} d");
          listDinasLuar.value = valueBody['data'];
          listDinasLuarAll.value = valueBody['data'];
          this.listDinasLuar.refresh();
          this.listDinasLuarAll.refresh();
        }
      }
    });
  }

  // void loadAllEmployeeDelegasi() {
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
  //         if (idpengajuanTugasLuar.value == "") {
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
    print("-----------data employeee delegasi-------------");
    allEmployeeDelegasi.value.clear();
    allEmployee.value.clear();
    var dataUser = AppData.informasiUser;
    var getDepGroup = dataUser![0].dep_group;
    var full_name = dataUser[0].full_name;
    var emid = dataUser[0].em_id;
    Map<String, dynamic> body = {'em_id': emid, 'dep_group_id': getDepGroup};
    var connect = Api.connectionApi("post", body, "employee-delegasi");
    // Map<String, dynamic> body = {'val': 'dep_group_id', 'cari': getDepGroup};
    // var connect = Api.connectionApi("post", body, "whereOnce-employee");
    connect.then((dynamic res) {
      if (res == false) {
        //UtilsAlert.koneksiBuruk();
      } else {
        if (res.statusCode == 200) {
          var valueBody = jsonDecode(res.body);
          var data = valueBody['data'];
          for (var element in data) {
            print("data status ${element['status']}");
            if (element['status'] == 'ACTIVE') {
              var fullName = element['full_name'] ?? "";
              String namaUser = "$fullName";
              if (namaUser != full_name) {
                allEmployeeDelegasi.value.add(namaUser);
              }
              allEmployee.value.add(element);
            }
          }
          if (idpengajuanTugasLuar.value == "") {
            List data = valueBody['data'];

            if (data.isNotEmpty){
              List listFirst = data
                .where((element) => element['full_name'] != full_name)
                .toList()
                ;
            var fullName = listFirst.isNotEmpty?listFirst[0]:"" ;
            String namaUserPertama = "$fullName";
            selectedDropdownDelegasi.value = namaUserPertama;

            }
            
          }

          this.allEmployee.refresh();
          this.allEmployeeDelegasi.refresh();
          this.selectedDropdownDelegasi.refresh();
        }
      }
    });
  }

  void checkDelegation(em_id) {
    var getData =
        allEmployee.value.firstWhere((element) => element["em_id"] == em_id);
    selectedDropdownDelegasi.value = getData["full_name"];
    this.selectedDropdownDelegasi.refresh();
  }

  void changeTypeAjuan(name) {
    var getTypeFilter = name == "Approve 1"
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
    if (viewTugasLuar.value) {
      if (name == "Semua Status") {
        List filter = [];
        for (var element in listTugasLuarAll) {
          filter.add(element);
        }
        listTugasLuar.value = filter;
        loadingString.value = listTugasLuar.value.length != 0
            ? "Memuat data..."
            : "Tidak ada pengajuan";
        this.loadingString.refresh();
        this.listTugasLuar.refresh();
      } else {
        List filter = [];
        for (var element in listTugasLuarAll.value) {
          if (element['status'] == getTypeFilter) {
            filter.add(element);
          }
        }
        listTugasLuar.value = filter;
        loadingString.value = listTugasLuar.value.length != 0
            ? "Memuat data..."
            : "Tidak ada pengajuan";
        this.loadingString.refresh();
        this.listTugasLuar.refresh();
      }
    } else {
      if (name == "Semua Status") {
        List filter = [];
        for (var element in listDinasLuarAll) {
          filter.add(element);
        }
        listDinasLuar.value = filter;
        loadingString.value = listDinasLuar.value.length != 0
            ? "Memuat data..."
            : "Tidak ada pengajuan";
        this.loadingString.refresh();
        this.listDinasLuar.refresh();
      } else {
        List filter = [];
        for (var element in listDinasLuarAll.value) {
          if (element['leave_status'] == getTypeFilter) {
            filter.add(element);
          }
        }
        listDinasLuar.value = filter;
        loadingString.value = listDinasLuar.value.length != 0
            ? "Memuat data..."
            : "Tidak ada pengajuan";
        this.loadingString.refresh();
        this.listDinasLuar.refresh();
      }
    }
  }

  void validasiKirimPengajuan() {
    if (viewTugasLuar.value) {
      if (tanggalTugasLuar.value.text == "" ||
          dariJam.value.text == "" ||
          sampaiJam.value.text == "" ||
          catatan.value.text == "" ||
          selectedDropdownDelegasi.value == "") {
        print(initialDate.value);
        UtilsAlert.showToast("Lengkapi form *");
      } else {
        if (statusForm.value == false) {
          UtilsAlert.loadingSimpanData(Get.context!, "Sedang Menyimpan");
          checkNomorAjuan();
        } else {
          UtilsAlert.loadingSimpanData(Get.context!, "Sedang Menyimpan");
          kirimPengajuan(nomorAjuan.value.text);
        }
      }
    } else if (!viewTugasLuar.value) {
      if (tanggalSelected.value.length == 0) {
        UtilsAlert.showToast("Pilih tanggal terlebih dahulu");
      } else if (catatan.value.text == "") {
        UtilsAlert.showToast("Isi catatan terlebih dahulu");
      } else if (selectedDropdownDelegasi.value == "") {
        UtilsAlert.showToast("Pilih pemberi tugas terlebih dahulu");
      } else {
        if (statusForm.value == false) {
          UtilsAlert.loadingSimpanData(Get.context!, "Sedang Menyimpan");
          checkNomorAjuanDinasLuar(statusForm.value);
        } else {
          UtilsAlert.loadingSimpanData(Get.context!, "Sedang Menyimpan");
          urutkanTanggalSelected(statusForm.value);
          kirimPengajuanDinasLuar(statusForm.value, nomorAjuan.value.text);
        }
      }
    }
  }

  void changeTypeSelected(index) {
    if (index == 0) {
      viewTugasLuar.value = true;
    } else {
      viewTugasLuar.value = false;
    }
    selectedType.value = index;
    this.selectedType.refresh();
    this.viewTugasLuar.refresh();
  }

  void checkNomorAjuan() {
    var listTanggal = tanggalTugasLuar.value.text.split(',');
    var getTanggal = listTanggal[1].replaceAll(' ', '');
    var tanggalTugasLuarEditData = Constanst.convertDateSimpan(getTanggal);
    var polaFormat = DateFormat('yyyy-MM-dd');
    var tanggalPengajuanInsert = polaFormat.format(initialDate.value);
    var finalTanggalPengajuan = statusForm.value == false
        ? tanggalPengajuanInsert
        : tanggalTugasLuarEditData;

    Map<String, dynamic> body = {
      'atten_date': finalTanggalPengajuan,
      'pola': 'TL'
    };
    var connect = Api.connectionApi("post", body, "emp_labor_lastrow");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        if (valueBody['status'] == true) {
          if (valueBody['data'].isEmpty) {
            var now = DateTime.now();
            var convertBulan = now.month <= 9 ? "0${now.month}" : now.month;
            var finalNomor = "TL${now.year}${convertBulan}0001";
            kirimPengajuan(finalNomor);
          } else {
            var getNomorAjuanTerakhir = valueBody['data'][0]['nomor_ajuan'];
            var keyNomor = getNomorAjuanTerakhir.replaceAll("TL", '');
            var hasilTambah = int.parse(keyNomor) + 1;
            var finalNomor = "TL$hasilTambah";
            kirimPengajuan(finalNomor);
          }
        } else {
          UtilsAlert.showToast(
              "Data periode $finalTanggalPengajuan belum tersedia, harap hubungi HRD");
        }
      }
    });
  }

  void checkNomorAjuanDalamAntrian1(nomorAjuanTerakhirDalamAntrian) {
    var getNomorAjuanTerakhir = nomorAjuanTerakhirDalamAntrian;
    var keyNomor = getNomorAjuanTerakhir.replaceAll("TL", '');
    var hasilTambah = int.parse(keyNomor) + 1;
    var finalNomor = "TL$hasilTambah";
    kirimPengajuan(finalNomor);
  }

  void checkNomorAjuanDinasLuar(value) {
    urutkanTanggalSelected(value);
    var listTanggal = tanggalTugasLuar.value.text.split(',');
    var getTanggal = listTanggal[1].replaceAll(' ', '');
    var tanggalTugasLuarEditData = Constanst.convertDateSimpan(getTanggal);
    var polaFormat = DateFormat('yyyy-MM-dd');
    var tanggalPengajuanInsert = polaFormat.format(initialDate.value);
    var finalTanggalPengajuan = statusForm.value == false
        ? tanggalPengajuanInsert
        : tanggalTugasLuarEditData;

    Map<String, dynamic> body = {
      'atten_date': finalTanggalPengajuan,
      'pola': 'DL'
    };
    var connect = Api.connectionApi("post", body, "emp_leave_lastrow");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        if (valueBody['status'] == true) {
          if (valueBody['data'].isEmpty) {
            var now = DateTime.now();
            var convertBulan = now.month <= 9 ? "0${now.month}" : now.month;
            var finalNomor = "DL${now.year}${convertBulan}0001";
            kirimPengajuanDinasLuar(value, finalNomor);
          } else {
            var getNomorAjuanTerakhir = valueBody['data'][0]['nomor_ajuan'];
            var keyNomor = getNomorAjuanTerakhir.replaceAll("DL", '');
            var hasilTambah = int.parse(keyNomor) + 1;
            var finalNomor = "DL$hasilTambah";
            kirimPengajuanDinasLuar(value, finalNomor);
          }
        } else {
          UtilsAlert.showToast(
              "Data periode $finalTanggalPengajuan belum tersedia, harap hubungi HRD");
        }
      }
    });
  }

  void checkNomorAjuanDalamAntrian2(status, nomorAjuanTerakhirDalamAntrian) {
    var getNomorAjuanTerakhir = nomorAjuanTerakhirDalamAntrian;
    var keyNomor = getNomorAjuanTerakhir.replaceAll("DL", '');
    var hasilTambah = int.parse(keyNomor) + 1;
    var finalNomor = "DL$hasilTambah";
    kirimPengajuanDinasLuar(status, finalNomor);
  }

  void urutkanTanggalSelected(status) {
    var hasilConvert = [];
    var tampungStringTanggal = "";
    if (status == true) {
      if (tanggalSelectedEdit.value.isNotEmpty) {
        tanggalSelectedEdit.value.forEach((element) {
          var inputFormat = DateFormat('yyyy-MM-dd');
          String formatted = inputFormat.format(element);
          hasilConvert.add(formatted);
        });
        hasilConvert.sort((a, b) {
          return DateTime.parse(a).compareTo(DateTime.parse(b));
        });
        var getFirst = hasilConvert.first;
        var getLast = hasilConvert.last;
        dariTanggal.value.text = getFirst;
        sampaiTanggal.value.text = getLast;
        durasiIzin.value = hasilConvert.length;
        hasilConvert.forEach((element) {
          if (tampungStringTanggal == "") {
            tampungStringTanggal = element;
          } else {
            tampungStringTanggal = "$tampungStringTanggal,$element";
          }
        });
        stringSelectedTanggal.value = tampungStringTanggal;
        this.dariTanggal.refresh();
        this.sampaiTanggal.refresh();
        this.durasiIzin.refresh();
        this.stringSelectedTanggal.refresh();
      }
    } else {
      if (tanggalSelected.value.isNotEmpty) {
        tanggalSelected.value.forEach((element) {
          var inputFormat = DateFormat('yyyy-MM-dd');
          String formatted = inputFormat.format(element);
          hasilConvert.add(formatted);
        });
        hasilConvert.sort((a, b) {
          return DateTime.parse(a).compareTo(DateTime.parse(b));
        });
        var getFirst = hasilConvert.first;
        var getLast = hasilConvert.last;
        dariTanggal.value.text = getFirst;
        sampaiTanggal.value.text = getLast;
        durasiIzin.value = hasilConvert.length;
        hasilConvert.forEach((element) {
          if (tampungStringTanggal == "") {
            tampungStringTanggal = element;
          } else {
            tampungStringTanggal = "$tampungStringTanggal,$element";
          }
        });
        stringSelectedTanggal.value = tampungStringTanggal;
        this.dariTanggal.refresh();
        this.sampaiTanggal.refresh();
        this.durasiIzin.refresh();
        this.stringSelectedTanggal.refresh();
      }
    }
  }

  void cariData(value) {
    if (viewTugasLuar.value) {
      var textCari = value.toLowerCase();
      var filter = listTugasLuarAll.where((ajuan) {
        var getAjuan = ajuan['nomor_ajuan'].toLowerCase();
        return getAjuan.contains(textCari);
      }).toList();
      listTugasLuar.value = filter;
      statusCari.value = true;
      this.listTugasLuar.refresh();
      this.statusCari.refresh();

      if (listTugasLuar.value.isEmpty) {
        loadingString.value = "Tidak ada pengajuan";
      } else {
        loadingString.value = "Memuat data...";
      }
      this.loadingString.refresh();
    } else {
      var textCari = value.toLowerCase();
      var filter = listDinasLuarAll.where((ajuan) {
        var getAjuan = ajuan['nomor_ajuan'].toLowerCase();
        return getAjuan.contains(textCari);
      }).toList();
      listDinasLuar.value = filter;
      statusCari.value = true;
      this.listDinasLuar.refresh();
      this.statusCari.refresh();

      if (listDinasLuar.value.isEmpty) {
        loadingString.value = "Tidak ada pengajuan";
      } else {
        loadingString.value = "Memuat data...";
      }
      this.loadingString.refresh();
    }
  }

  void kirimPengajuan(getNomorAjuanTerakhir) {
    var listTanggal = tanggalTugasLuar.value.text.split(',');
    var getTanggal = listTanggal[1].replaceAll(' ', '');
    var tanggalTugasLuarEditData = Constanst.convertDateSimpan(getTanggal);
    var dataUser = AppData.informasiUser;
    var getEmid = dataUser![0].em_id;
    var getFullName = dataUser[0].full_name;
    var validasiDelegasiSelected = validasiSelectedDelegasi();
    var validasiDelegasiSelectedToken = validasiSelectedDelegasiToken();
    var polaFormat = DateFormat('yyyy-MM-dd');
    var tanggalPengajuanInsert = polaFormat.format(initialDate.value);
    var finalTanggalPengajuan = statusForm.value == false
        ? tanggalPengajuanInsert
        : tanggalTugasLuarEditData;
    var hasilDurasi = hitungDurasi();

    Map<String, dynamic> body = {
      'em_id': getEmid,
      'nomor_ajuan': getNomorAjuanTerakhir,
      'dari_jam': dariJam.value.text,
      'sampai_jam': sampaiJam.value.text,
      'durasi': hasilDurasi,
      'atten_date': finalTanggalPengajuan,
      'status': 'PENDING',
      'approve_date': '',
      'em_delegation': validasiDelegasiSelected,
      'uraian': catatan.value.text,
      'ajuan': '2',
      'created_by': getEmid,
      'menu_name': 'Tugas Luar',
      'approve_status': 'Pending'
    };
    if (statusForm.value == false) {
      body['activity_name'] =
          "Membuat Pengajuan Tugas Luar. alasan = ${catatan.value.text}";
      var connect = Api.connectionApi("post", body, "tugas-luar");
      connect.then((dynamic res) {
        if (res.statusCode == 200) {
          var valueBody = jsonDecode(res.body);
          var typeNotifFcm = "Pengajuan Tugas Luar";
          if (valueBody['status'] == true) {
            var stringWaktu =
                "${dariJam.value.text} sd ${sampaiJam.value.text}";
            kirimNotifikasiToDelegasi(
                getFullName,
                finalTanggalPengajuan,
                validasiDelegasiSelected,
                validasiDelegasiSelectedToken,
                stringWaktu,
                1,
                typeNotifFcm);
            // kirimNotifikasiToReportTo(getFullName, finalTanggalPengajuan,
            //     getEmid, "Tugas Luar", stringWaktu);
            Navigator.pop(Get.context!);
            var pesan1 = "Pengajuan Tugas Luar berhasil di buat";
            var pesan2 =
                "Selanjutnya silahkan menunggu atasan kamu untuk menyetujui pengajuan yang telah dibuat atau langsung";
            var pesan3 = "konfirmasi via WhatsApp";
            var dataPengajuan = {
              'nameType': 'TUGAS LUAR',
              'nomor_ajuan': '${getNomorAjuanTerakhir}',
            };

            for (var item in globalCt.konfirmasiAtasan) {
              print(item['token_notif']);
              var pesan;
              if (item['em_gender'] == "PRIA") {
                pesan =
                    "Hallo pak ${item['full_name']}, saya ${getFullName} mengajukan DINAS LUAR dengan nomor ajuan ${getNomorAjuanTerakhir}";
              } else {
                pesan =
                    "Hallo bu ${item['full_name']}, saya ${getFullName} mengajukan DINAS LUAR dengan nomor ajuan ${getNomorAjuanTerakhir}";
              }
              // kirimNotifikasiToDelegasi1(
              //     getFullName,
              //     finalTanggalPengajuan,
              //     validasiDelegasiSelected,
              //     validasiDelegasiSelectedToken,
              //     stringWaktu,
              //     1,
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
              checkNomorAjuanDalamAntrian1(nomorAjuanTerakhirDalamAntrian);
            } else if (valueBody['message'] == "date") {
              Navigator.pop(Get.context!);
              UtilsAlert.showToast(valueBody['error']);
            } else {
              Navigator.pop(Get.context!);
              UtilsAlert.showToast(
                  "Data periode $finalTanggalPengajuan belum tersedia, harap hubungi HRD");
            }
          }
        }
      });
    } else {
      body['val'] = "id";
      body['cari'] = idpengajuanTugasLuar.value;
      body['activity_name'] =
          "Edit Pengajuan Tugas Luar. Tanggal Pengajuan = $finalTanggalPengajuan";
      var connect = Api.connectionApi("post", body, "edit-emp_labor");
      connect.then((dynamic res) {
        if (res.statusCode == 200) {
          Navigator.pop(Get.context!);

          var pesan1 = "Pengajuan Tugas Luar berhasil di edit";
          var pesan2 =
              "Selanjutnya silahkan menunggu atasan kamu untuk menyetujui pengajuan yang telah dibuat atau langsung";
          var pesan3 = "konfirmasi via WhatsApp";
          var dataPengajuan = {
            'nameType': 'TUGAS LUAR',
            'nomor_ajuan': '${getNomorAjuanTerakhir}',
          };
          Get.offAll(BerhasilPengajuan(
            dataBerhasil: [pesan1, pesan2, pesan3, dataPengajuan],
          ));
        }
      });
    }
  }

  void kirimPengajuanDinasLuar(status, getNomorAjuanTerakhir) async {
    var dataUser = AppData.informasiUser;
    var getEmid = "${dataUser![0].em_id}";
    var getFullName = "${dataUser[0].full_name}";
    var validasiDelegasiSelected = validasiSelectedDelegasi();
    var validasiDelegasiSelectedToken = validasiSelectedDelegasiToken();

    var listTanggal = tanggalTugasLuar.value.text.split(',');
    var getTanggal = listTanggal[1].replaceAll(' ', '');
    var tanggalDinasLuarEditData = Constanst.convertDateSimpan(getTanggal);

    var polaFormat = DateFormat('yyyy-MM-dd');
    var tanggalPengajuanInsert = polaFormat.format(initialDate.value);

    var convertTanggalBikinPengajuan = statusForm.value == false
        ? tanggalPengajuanInsert
        : tanggalDinasLuarEditData;

    Map<String, dynamic> body = {
      'em_id': '$getEmid',
      'typeid': 0,
      'nomor_ajuan': getNomorAjuanTerakhir,
      // 'leave_type': 'Full Day',
      'leave_type': 'FULLDAY',
      'start_date': dariTanggal.value.text,
      'end_date': sampaiTanggal.value.text,
      'leave_duration': durasiIzin.value,
      'date_selected': stringSelectedTanggal.value,
      'time_plan': "00:00:00",
      'apply_date': '',
      'reason': catatan.value.text,
      'leave_status': 'Pending',
      'atten_date': convertTanggalBikinPengajuan,
      'em_delegation': validasiDelegasiSelected,
      'leave_files': "",
      'ajuan': "4",
      'apply_status': "Pending"
    };
    var typeNotifFcm = "Pengajuan Dinas Luar";
    if (status == false) {
      body['created_by'] = getEmid;
      body['menu_name'] = "Dinas Luar";
      body['activity_name'] =
          "Membuat Pengajuan Dinas Luar. alasan = ${catatan.value.text}";
      var connect = Api.connectionApi("post", body, "kirimPengajuanTMK");
      connect.then((dynamic res) {
        if (res.statusCode == 200) {
          var valueBody = jsonDecode(res.body);
          if (valueBody['status'] == true) {
            var stringWaktu =
                "${dariTanggal.value.text} sd ${sampaiTanggal.value.text}";
            kirimNotifikasiToDelegasi(
                getFullName,
                convertTanggalBikinPengajuan,
                validasiDelegasiSelected,
                validasiDelegasiSelected,
                stringWaktu,
                2,
                typeNotifFcm);
            // kirimNotifikasiToReportTo(getFullName, convertTanggalBikinPengajuan,
            //     getEmid, "Dinas Luar", stringWaktu);
            Navigator.pop(Get.context!);

            var pesan1 = "Pengajuan Dinas Luar berhasil di buat";
            var pesan2 =
                "Selanjutnya silahkan menunggu atasan kamu untuk menyetujui pengajuan yang telah dibuat atau langsung";
            var pesan3 = "konfirmasi via WhatsApp";
            var dataPengajuan = {
              'nameType': 'Dinas Luar',
              'nomor_ajuan': '${getNomorAjuanTerakhir}',
            };
            for (var item in globalCt.konfirmasiAtasan) {
              print(item['token_notif']);
              var pesan;
              if (item['em_gender'] == "PRIA") {
                pesan =
                    "Hallo pak ${item['full_name']}, saya ${getFullName} mengajukan  TUGAS LUAR dengan nomor ajuan ${getNomorAjuanTerakhir}";
              } else {
                pesan =
                    "Hallo bu ${item['full_name']}, saya ${getFullName} mengajukan TUGAS LUAR dengan nomor ajuan ${getNomorAjuanTerakhir}";
              }
              // kirimNotifikasiToDelegasi1(
              //     getFullName,
              //     convertTanggalBikinPengajuan,
              //     item['em_id'],
              //     validasiDelegasiSelected,
              //     stringWaktu,
              //     2,
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
              checkNomorAjuanDalamAntrian2(
                  status, nomorAjuanTerakhirDalamAntrian);
            } else if (valueBody['message'] == "date") {
              Navigator.pop(Get.context!);
              UtilsAlert.showToast(valueBody['error']);
            } else {
              Navigator.pop(Get.context!);
              UtilsAlert.showToast(
                  "Data periode $convertTanggalBikinPengajuan belum tersedia, harap hubungi HRD");
            }
          }
        }
      });
    } else {
      body['val'] = 'id';
      body['cari'] = idpengajuanTugasLuar.value;
      body['created_by'] = getEmid;
      body['menu_name'] = "Dinas Luar";
      body['activity_name'] =
          "Edit form Pengajuan Dinas Luar. Tanggal pengajuan = ${dariTanggal.value.text} sd ${sampaiTanggal.value.text} Alasan Pengajuan = ${catatan.value.text}";
      var connect = Api.connectionApi("post", body, "edit-emp_leave");
      connect.then((dynamic res) {
        if (res.statusCode == 200) {
          Navigator.pop(Get.context!);

          var pesan1 = "Pengajuan Dinas Luar berhasil di edit";
          var pesan2 =
              "Selanjutnya silahkan menunggu atasan kamu untuk menyetujui pengajuan yang telah dibuat atau langsung";
          var pesan3 = "konfirmasi via WhatsApp";
          var dataPengajuan = {
            'nameType': 'Dinas Luar',
            'nomor_ajuan': '${getNomorAjuanTerakhir}',
          };

          Get.offAll(BerhasilPengajuan(
            dataBerhasil: [pesan1, pesan2, pesan3, dataPengajuan],
          ));
        }
      });
    }
  }

  void kirimNotifikasiToDelegasi(
      getFullName,
      convertTanggalBikinPengajuan,
      validasiDelegasiSelected,
      fcmTokenDelegasi,
      stringWaktu,
      type,
      typeNotifFcm) {
    var dt = DateTime.now();
    var jamSekarang = DateFormat('HH:mm:ss').format(dt);
    var tanggalSekarang = DateFormat('yyyy-MM-dd').format(dt);

    var title_ct =
        type == 1 ? "Pemberi Tugas Tugas Luar" : "Pemberi Tugas Dinas Luar";
    var desk_ct = type == 1
        ? "Anda mendapatkan pengajuan TUGAS LUAR dari  $getFullName dengan pemberi tugas anda, tanggal pengajuan $stringWaktu"
        : "Anda mendapatkan pengajuan DINAS LUAR dari $getFullName dengan pemberi tugas anda, tanggal pengajuan $stringWaktu";
    Map<String, dynamic> body = {
      'em_id': validasiDelegasiSelected,
      'title': title_ct,
      'deskripsi': desk_ct,
      'url': '',
      'atten_date': tanggalSekarang,
      'jam': jamSekarang,
      'status': '2',
      'view': '0',
    };
    var connect = Api.connectionApi("post", body, "insert-notifikasi");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        globalCt.kirimNotifikasiFcm(
            title: typeNotifFcm, message: desk_ct, tokens: fcmTokenDelegasi);
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
      type,
      typeNotifFcm,
      pesan) {
    var dt = DateTime.now();
    var jamSekarang = DateFormat('HH:mm:ss').format(dt);

    var title_ct = type == 1 ? "Approval Tugas Luar" : "Approval Dinas Luar";
    var desk_ct = type == 1
        ? "Anda mendapatkan pengajuan TUGAS LUAR dari  $getFullName dengan pemberi tugas anda, tanggal pengajuan $stringWaktu"
        : "Anda mendapatkan pengajuan DINAS LUAR dari $getFullName dengan pemberi tugas anda, tanggal pengajuan $stringWaktu";

    Map<String, dynamic> body = {
      'em_id': validasiDelegasiSelected,
      'title': title_ct,
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
        //     title: typeNotifFcm, message: desk_ct, tokens: fcmTokenDelegasi);
        // UtilsAlert.showToast("Berhasil kirim delegasi");
      }
    });
  }

  void kirimNotifikasiToReportTo(
      getFullName, convertTanggalBikinPengajuan, getEmid, type, stringWaktu) {
    var dt = DateTime.now();
    var jamSekarang = DateFormat('HH:mm:ss').format(dt);
    var title_ct =
        type == "Tugas Luar" ? "Pengajuan Tugas Luar" : "Pengajuan Dinas Luar";
    var desk_ct = type == "Tugas Luar"
        ? "Anda mendapatkan pengajuan $type dari $getFullName, pada jam $stringWaktu"
        : "Anda mendapatkan pengajuan $type dari $getFullName, tanggal pengajuan $stringWaktu";
    Map<String, dynamic> body = {
      'emId_pengaju': getEmid,
      'title': title_ct,
      'deskripsi': desk_ct,
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
        result.add(element);
      }
    }
    return "${result[0]['em_id']}";
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
    var dari = format.parse("${dariJam.value.text}");
    var sampai = format.parse("${sampaiJam.value.text}");
    var hasil1 = "${sampai.difference(dari)}";
    var hasilAkhir = hasil1.replaceAll(':00.000000', '');
    return "$hasilAkhir";
  }

  void showModalBatalPengajuan(index) {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Iconsax.info_circle5,
                          color: Constanst.color4,
                          size: 30,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "Batalkan Pengajuan",
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Constanst.fgPrimary),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () => Get.back(),
                      customBorder: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Icon(
                        Icons.close,
                        color: Constanst.fgSecondary,
                        size: 26,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  "Data pengajuan yang telah kamu buat akan di hapus. Yakin ingin membatalkan pengajuan?",
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Constanst.fgPrimary),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Constanst
                                .border, // Set the desired border color
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Get.back();
                            batalkanPengajuan(index);
                          },
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Constanst.color4,
                              backgroundColor: Constanst.colorWhite,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                              // padding: EdgeInsets.zero,
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0)),
                          child: Text(
                            'Ya, Batalkan',
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
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Constanst.colorWhite,

                            backgroundColor: Constanst.colorPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                            // padding: const EdgeInsets.fromLTRB(20, 12, 20, 12)
                          ),
                          child: Text(
                            'Kembali',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                color: Constanst.colorWhite,
                                fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void batalkanPengajuan(index) {
    print("data index baru ${index}");
    print(viewTugasLuar);
    if (viewTugasLuar.value) {
      UtilsAlert.loadingSimpanData(Get.context!, "Batalkan Pengajuan");
      var dataUser = AppData.informasiUser;
      var getEmid = dataUser![0].em_id;
      Map<String, dynamic> body = {
        'menu_name': 'Tugas Luar',
        'activity_name':
            'Membatalkan form pengajuan Tugas Luar. Waktu  Tugas Luar = ${index["dari_jam"]} sd ${index["sampai_jam"]} Alasan Pengajuan = ${index["reason"]} Tanggal Pengajuan = ${index["atten_date"]}',
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
          loadDataTugasLuar();
          loadDataDinasLuar();
        }
      });
    } else {
      UtilsAlert.loadingSimpanData(Get.context!, "Batalkan Pengajuan");
      var dataUser = AppData.informasiUser;
      var getEmid = dataUser![0].em_id;
      Map<String, dynamic> body = {
        'menu_name': 'Dinas Luar',
        'activity_name':
            'Membatalkan form pengajuan Dinas Luar. Tanggal pengajuan = ${index["start_date"]} sd ${index["end_date"]} Alasan Pengajuan = ${index["reason"]}',
        'created_by': '$getEmid',
        'val': 'id',
        'cari': '${index["id"]}',
        'status_transaksi': 0,
        'start_date': '${index["start_date"]}',
        'leave_status': "Cancel"
      };
      var connect = Api.connectionApi("post", body, "edit-emp_leave");
      connect.then((dynamic res) {
        if (res.statusCode == 200) {
          Navigator.pop(Get.context!);
          Navigator.pop(Get.context!);
          UtilsAlert.showToast("Berhasil batalkan pengajuan");
          loadDataTugasLuar();
          loadDataDinasLuar();
        }
      });
    }
  }

  void showDetailRiwayat(tipe, detailData, approve_by, alasanReject) {
    var nomorAjuan = detailData['nomor_ajuan'];
    var tanggalMasukAjuan = detailData['tgl_ajuan'];
    var tanggalTugas = detailData['atten_date'];
    var namaTypeAjuan = "Dinas Luar";
    var tanggalAjuanDari = detailData['start_date'];
    var tanggalAjuanSampai = detailData['end_date'];
    var alasan = detailData['reason'] ?? detailData['uraian'];
    var durasi = detailData['leave_duration'];
    // var typeAjuan = detailData['leave_status'];
    var typeAjuan;
    if (valuePolaPersetujuan.value == "1") {
      typeAjuan = detailData['leave_status'];
    } else {
      typeAjuan = detailData['leave_status'] == "Approve"
          ? "Approve 1"
          : detailData['leave_status'] == "Approve2"
              ? "Approve 2"
              : detailData['leave_status'];
    }
    var jamAjuan = detailData['time_plan'];
    var leave_files = detailData['leave_files'];
    var listTanggalTerpilih =
        tipe == "Dinas Luar" ? detailData['date_selected'].split(',') : "";
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      builder: (context) {
        return SafeArea(
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
                        ),
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
                                Constanst.convertDate6("$tanggalMasukAjuan"),
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Constanst.fgPrimary,
                                ),
                              ),
                            ],
                          ),
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
                          "Nama Pengajuan",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Constanst.fgSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tipe,
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
                          "Tanggal $tipe",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Constanst.fgSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // detailData['date_selected'] == null ||
                        //         detailData['date_selected'] == "" ||
                        //         detailData['date_selected'] == "null"
                        //     ? Text(
                        //         "${Constanst.convertDate(tanggalAjuanDari)} - ${Constanst.convertDate(tanggalAjuanSampai)}",
                        //         style: GoogleFonts.inter(
                        //           fontWeight: FontWeight.w500,
                        //           fontSize: 16,
                        //           color: Constanst.fgPrimary,
                        //         ),
                        //       )
                        //     : Container(),
                        // listTanggalTerpilih.length == 1
                        //     ? Text(
                        //         "${Constanst.convertDate("$tanggalAjuanDari")}")
                        //     : listTanggalTerpilih.length == 2
                        //         ? Text(
                        //             "${Constanst.convertDate("$tanggalAjuanDari")}  dan  ${Constanst.convertDate("$tanggalAjuanSampai")}")
                        //         : Text(
                        //             "${Constanst.convertDate("$tanggalAjuanDari")}  sd  ${Constanst.convertDate("$tanggalAjuanSampai")}"),
                        detailData['date_selected'] == null ||
                                detailData['date_selected'] == "" ||
                                detailData['date_selected'] == "null"
                            ? Text(
                                detailData['atten_date'],
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Constanst.fgPrimary,
                                ),
                              )
                            : Row(
                                children: List.generate(
                                    listTanggalTerpilih.length, (index) {
                                  var nomor = index + 1;
                                  var tanggalConvert = Constanst.convertDate7(
                                      listTanggalTerpilih[index]);
                                  var tanggalConvert2 = Constanst.convertDate5(
                                      listTanggalTerpilih[index]);
                                  return Row(
                                    children: [
                                      Text(
                                        index == listTanggalTerpilih.length - 1
                                            ? tanggalConvert2
                                            : '$tanggalConvert, ',
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Constanst.fgPrimary,
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                        const SizedBox(height: 12),
                        Divider(
                          height: 0,
                          thickness: 1,
                          color: Constanst.border,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Durasi $tipe",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Constanst.fgSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${tipe == "Tugas Luar" ? "1" : "${durasi}"} Hari",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Constanst.fgPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        //         jamAjuan == "" ||
                        //     jamAjuan == "NULL" ||
                        //     jamAjuan == null ||
                        //     jamAjuan == "00:00:00"
                        // ? SizedBox()
                        // : Row(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Expanded(
                        //         flex: 30,
                        //         child: Text("Jam"),
                        //       ),
                        //       Expanded(
                        //         flex: 2,
                        //         child: Text(":"),
                        //       ),
                        //       Expanded(
                        //         flex: 68,
                        //         child: Text("$jamAjuan sd $sampaiJamAjuan"),
                        //       )
                        //     ],
                        //   ),
                        Divider(
                          height: 0,
                          thickness: 1,
                          color: Constanst.border,
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
                          "${alasan == "null" || alasan == null ? "" : "$alasan"}",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Constanst.fgPrimary,
                          ),
                        ),
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
                                          color: Constanst.infoLight,
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
                        typeAjuan == 'Rejected'
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Iconsax.close_circle,
                                    color: Constanst.color4,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Rejected by $approve_by",
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              color: Constanst.fgPrimary,
                                              fontSize: 14)),
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
                                ],
                              )
                            : typeAjuan == "Approve" ||
                                    typeAjuan == "Approve 1" ||
                                    typeAjuan == "Approve 2"
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
                                      Text("Approved by $approve_by",
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
                                                  'nameType': '$namaTypeAjuan',
                                                  'nomor_ajuan': '$nomorAjuan',
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
                typeAjuan == "Approve" ||
                        typeAjuan == "Approve 1" ||
                        typeAjuan == "Approve 2"
                    ? Container()
                    : const SizedBox(height: 16),
                typeAjuan == "Approve" ||
                        typeAjuan == "Approve 1" ||
                        typeAjuan == "Approve 2"
                    ? Container()
                    : Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 40,
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Constanst
                                      .border, // Set the desired border color
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Get.back();
                                  showModalBatalPengajuan(detailData);
                                },
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Constanst.color4,
                                    backgroundColor: Constanst.colorWhite,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 0,
                                    // padding: EdgeInsets.zero,
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 0)),
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
                                  viewTugasLuar.value = true;
                                  Get.to(FormTugasLuar(
                                    dataForm: [detailData, true],
                                  ));
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Constanst.colorWhite,
                                  backgroundColor: Constanst.colorPrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
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
                      )
              ],
            ),
          ),
        );
      },
    );
  }

  void viewLampiranAjuan(value) async {
    var urlViewGambar = Api.UrlfileTidakhadir + value;

    final url = Uri.parse(urlViewGambar);
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      UtilsAlert.showToast('Tidak dapat membuka file');
    }
  }
}
