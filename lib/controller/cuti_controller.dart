import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:siscom_operasional/controller/global_controller.dart';
import 'package:siscom_operasional/screen/absen/form/berhasil_pengajuan.dart';
import 'package:siscom_operasional/screen/absen/form/form_pengajuan_cuti.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/custom_dialog.dart';
import 'package:siscom_operasional/utils/widget_textButton.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class CutiController extends GetxController {
  var nomorAjuan = TextEditingController().obs;
  var dariTanggal = TextEditingController().obs;
  var sampaiTanggal = TextEditingController().obs;
  var alasan = TextEditingController().obs;
  var focus = FocusNode();
  var cari = TextEditingController().obs;
  var departemen = TextEditingController().obs;
  var showTipe = false.obs;

  var filePengajuan = File("").obs;
  var startDate = "".obs;
  var endDate = "".obs;
  var allTipe = [].obs;
  var allEmployee = [].obs;
  var dataTypeAjuan = [].obs;
  var AlllistHistoryAjuan = [].obs;
  var listHistoryAjuan = [].obs;
  var tanggalSelected = [].obs;
  var departementAkses = [].obs;
  var allNameLaporanCuti = [].obs;
  var allNameLaporanCutiCopy = [].obs;
  var tanggalSelectedEdit = [].obs;
  var durasiCutiMelahirkan = 0.obs;
  var messageApi = ''.obs;
  Rx<List<String>> allEmployeeDelegasi = Rx<List<String>>([]);
  Rx<List<String>> allTipeFormCutiDropdown = Rx<List<String>>([]);
  var showStatus = false.obs;
  var isRequiredFile = '0'.obs;

  var limitCuti = 0.obs;
  var cutLeave = 1.obs;

  var dateSelected = 0.obs;

  var statusFormPencarian = false.obs;

  var jumlahCuti = 0.0.obs;
  var typeIdEdit = 0.obs;
  var cutiTerpakai = 0.0.obs;
  var persenCuti = 0.0.obs;
  var durasiIzin = 0.obs;
  var jumlahData = 0.obs;

  var isBackDate = "0".obs;

  var tempNamaStatus1 = "Semua Status".obs;

  var namaFileUpload = "".obs;
  var stringSelectedTanggal = "".obs;
  var selectedTypeCuti = "".obs;
  var selectedDelegasi = "".obs;
  var bulanSelectedSearchHistory = "".obs;
  var tahunSelectedSearchHistory = "".obs;
  var bulanDanTahunNow = "".obs;
  var idEditFormCuti = "".obs;
  var atten_date_edit = "".obs;
  var emDelegationEdit = "".obs;
  var idDepartemenTerpilih = "".obs;
  var namaDepartemenTerpilih = "".obs;
  var valuePolaPersetujuan = "".obs;

  var allowMinus = 0.obs;

  var stringLoading = "Memuat Data...".obs;

  var statusForm = false.obs;
  var statusHitungCuti = false.obs;
  var screenTanggalSelected = true.obs;
  var uploadFile = false.obs;
  var statusCari = false.obs;
  var showButtonlaporan = false.obs;
  var statusLoadingSubmitLaporan = false.obs;
  var messageApproval = "".obs;

  var dataTypeAjuanDummy1 = ["Semua Status", "Approve", "Rejected", "Pending"];
  var dataTypeAjuanDummy2 = [
    "Semua Status",
    "Approve 1",
    "Approve 2",
    "Rejected",
    "Pending"
  ];

  GlobalController globalCt = Get.find<GlobalController>();

  @override
  void onReady() async {
    getTimeNow();
    loadCutiUser();
    getLoadsysData();
    loadAllEmployeeDelegasi();
    //loadDataTypeCuti();
    loadDataAjuanCuti();
    getDepartemen(1, "");
    super.onReady();
  }

  void showInputCari() {
    statusFormPencarian.value = !statusFormPencarian.value;
  }

  void getDepartemen(status, tanggal) {
    jumlahData.value = 0;
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
              idDepartemenTerpilih.value = "${departementAkses[0]['id']}";
              namaDepartemenTerpilih.value = departementAkses[0]['name'];
              departemen.value.text = departementAkses[0]['name'];
              showButtonlaporan.value = true;
            }
          }
        }
      }
    });
  }

  void getTimeNow() {
    var dt = DateTime.now();
    bulanSelectedSearchHistory.value = "${dt.month}";
    tahunSelectedSearchHistory.value = "${dt.year}";
    bulanDanTahunNow.value = "${dt.month}-${dt.year}";

    var dateString = "${dt.year}-${dt.month}-${dt.day}";
    var afterConvert = Constanst.convertDate1(dateString);
    if (idEditFormCuti.value == "") {
      dariTanggal.value.text = "$afterConvert";
      sampaiTanggal.value.text = "$afterConvert";
    }
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

  void loadDataTypeCuti({durasi}) {
    UtilsAlert.showLoadingIndicator(Get.context!);
    print("load data cuti");
    allTipeFormCutiDropdown.value.clear();
    selectedTypeCuti.value = '';
    allTipe.value.clear();
    //  UtilsAlert.showLoadingIndicator(Get.context!);

    var body = {'durasi': '${durasi}'};
    print('ini body cuti tipe : $body');
    var connect = Api.connectionApi("post", body, "cuti-tipe");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        var data = valueBody['data'];
        print("data tipe cuti ${data}");
        for (var element in data) {
          allTipeFormCutiDropdown.value.add(element['name']);
          var data = {
            'id': element['id'],
            'name': element['name'],
            'status': element['status'],
            'leave_day': element['leave_day'],
            'select_date': element['select_date'],
            'allow_minus': element['allow_minus'],
            'cut_leave': element['cut_leave'],
            'upload_file': element['upload_file'],
            'back_date': element['backdate'],
            'active': false,
          };

          allTipe.value.add(data);
        }
        if (allTipe.value.length > 0) {
          var getFirst = allTipe.value.first;

          if (!statusForm.value) {
            selectedTypeCuti.value = getFirst['name'].toString();
            dateSelected.value = getFirst['select_date'];
            allowMinus.value = getFirst['allow_minus'];
            isRequiredFile.value = getFirst['upload_file'].toString();
            isBackDate.value = getFirst['back_date'].toString();
            cutLeave.value = getFirst['cut_leave'];
            limitCuti.value = getFirst['leave_day'];
            Get.back();
          } else {
            var getFirstEdit = allTipe.value.firstWhere(
              (element) => element['id'] == typeIdEdit.value,
              orElse: () =>
                  getFirst, 
            );

            selectedTypeCuti.value = getFirstEdit['name'].toString();
            dateSelected.value = getFirstEdit['select_date'];
            allowMinus.value = getFirstEdit['allow_minus'];
            isRequiredFile.value = getFirstEdit['upload_file'].toString();
            isBackDate.value = getFirstEdit['back_date'].toString();
            cutLeave.value = getFirstEdit['cut_leave'];
            limitCuti.value = getFirstEdit['leave_day'];
            Get.back();
          }

          showStatus.value = true;
          showTipe.value = true;
        } else {
          showStatus.value = false;
          UtilsAlert.showToast("Data tipe sakit/izi tidak tersedia");
          showTipe.value = false;
          Get.back();
        }

        this.allTipe.refresh();
        this.selectedTypeCuti.refresh();
        this.allTipeFormCutiDropdown.refresh();
        this.allowMinus.refresh();
      }
    });
  }

  void loadDataTypeCutiEdit({durasi, detailData}) {
    UtilsAlert.showLoadingIndicator(Get.context!);
    print("load data cuti $durasi");
    allTipeFormCutiDropdown.value.clear();
    allTipe.value.clear();
    //  UtilsAlert.showLoadingIndicator(Get.context!);

    var body = {'durasi': '${durasi}'};
    var connect = Api.connectionApi("post", body, "cuti-tipe");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        var data = valueBody['data'];
        print("data tipe cuti ${data}");
        for (var element in data) {
          allTipeFormCutiDropdown.value.add(element['name']);
          var data = {
            'id': element['id'],
            'name': element['name'],
            'status': element['status'],
            'leave_day': element['leave_day'],
            'select_date': element['select_date'],
            'allow_minus': element['allow_minus'],
            'cut_leave': element['cut_leave'],
            'upload_file': element['upload_file'],
            'back_date': element['backdate'],
            'active': false,
          };

          allTipe.value.add(data);
        }
        if (allTipe.value.length > 0) {
          if (statusForm.value == false) {
            var getFirst = allTipe.value.first;
            selectedTypeCuti.value = getFirst['name'];
            dateSelected.value = getFirst['select_date'];
            allowMinus.value = getFirst['allow_minus'];
            isRequiredFile.value = getFirst['upload_file'].toString();
            isBackDate.value = getFirst['back_date'].toString();
            limitCuti.value = getFirst['leave_day'];
            cutLeave.value = getFirst['cut_leave'];
            Get.back();
          } else {
            var getFirst = allTipe.value
                .firstWhere((element) => element['id'] == typeIdEdit.value);
            selectedTypeCuti.value = getFirst['name'];

            dateSelected.value = getFirst['select_date'];
            allowMinus.value = getFirst['allow_minus'];
            isRequiredFile.value = getFirst['upload_file'].toString();
            isBackDate.value = getFirst['back_date'].toString();
            limitCuti.value = getFirst['leave_day'];
            cutLeave.value = getFirst['cut_leave'];
            Get.back();
          }

          showStatus.value = true;
          showTipe.value = true;
          Get.to(FormPengajuanCuti(
            dataForm: [detailData, true],
          ));
          // Get.back();
        } else {
          showStatus.value = false;
          UtilsAlert.showToast("Data tipe sakit/izi tidak tersedia");
          showTipe.value = false;
          Get.back();
        }

        this.allTipe.refresh();
        this.selectedTypeCuti.refresh();
        this.allTipeFormCutiDropdown.refresh();
        this.allowMinus.refresh();
      }
    });
  }

  void loadDataTypeCuti1() {
    // print("load data cuti");
    // allTipeFormCutiDropdown.value.clear();
    // allTipe.value.clear();

    // Map<String, dynamic> body = {'val': 'status', 'cari': '1'};
    // var connect = Api.connectionApi("post", body, "whereOnce-leave_types");
    // connect.then((dynamic res) {
    //   if (res.statusCode == 200) {
    //     var valueBody = jsonDecode(res.body);
    //     var data = valueBody['data'];
    //     print("data tipe cuti ${data}");
    //     for (var element in data) {
    //       allTipeFormCutiDropdown.value.add(element['name']);
    //       var data = {
    //         'id': element['id'],
    //         'name': element['name'],
    //         'status': element['status'],
    //         'leave_day': element['leave_day'],
    //         'select_date': element['select_date'],
    //         'allow_minus': element['allow_minus'],
    //         'cut_leave': element['cut_leave'],
    //         'upload_file': element['upload_file'],
    //         'back_date': element['backdate'],
    //         'active': false,
    //       };

    //       allTipe.value.add(data);
    //     }
    //     if (statusForm.value == false) {
    //       var getFirst = allTipe.value.first;
    //       selectedTypeCuti.value = getFirst['name'];
    //       dateSelected.value = getFirst['select_date'];
    //       allowMinus.value = getFirst['allow_minus'];
    //       isRequiredFile.value = getFirst['upload_file'].toString();
    //       isBackDate.value = getFirst['back_date'].toString();
    //     } else {
    //       var getFirst = allTipe.value
    //           .firstWhere((element) => element['id'] == typeIdEdit.value);
    //       selectedTypeCuti.value = getFirst['name'];

    //       dateSelected.value = getFirst['select_date'];
    //       allowMinus.value = getFirst['allow_minus'];
    //       isRequiredFile.value = getFirst['upload_file'].toString();
    //       isBackDate.value = getFirst['back_date'].toString();
    //     }

    //     this.allTipe.refresh();
    //     this.selectedTypeCuti.refresh();
    //     this.allTipeFormCutiDropdown.refresh();
    //     this.allowMinus.refresh();
    //   }
    // });
  }
  void loadDataAjuanCuti() {
    AlllistHistoryAjuan.value.clear();
    listHistoryAjuan.value.clear();
    stringLoading.value = "Memuat Data...";
    var dataUser = AppData.informasiUser;
    var getEmid = dataUser![0].em_id;
    Map<String, dynamic> body = {
      'em_id': getEmid,
      'bulan': bulanSelectedSearchHistory.value,
      'tahun': tahunSelectedSearchHistory.value,
      'ajuan': '1',
    };
    var connect = Api.connectionApi("post", body, "history-emp_leave");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        if (valueBody['status'] == false) {
          stringLoading.value = "Tidak ada pengajuan";
          this.stringLoading.refresh();
        } else {
          AlllistHistoryAjuan.value = valueBody['data'];
          listHistoryAjuan.value = valueBody['data'];
          if (listHistoryAjuan.value.isEmpty) {
            stringLoading.value = "Tidak ada pengajuan";
          } else {
            stringLoading.value = "Memuat Data...";
          }
          this.listHistoryAjuan.refresh();
          this.AlllistHistoryAjuan.refresh();
          this.stringLoading.refresh();
        }
      }
    });
  }

  void loadDataAjuanCutiEdit({durasi, data}) {
    AlllistHistoryAjuan.value.clear();
    listHistoryAjuan.value.clear();
    stringLoading.value = "Memuat Data...";
    var dataUser = AppData.informasiUser;
    var getEmid = dataUser![0].em_id;
    Map<String, dynamic> body = {
      'em_id': getEmid,
      'bulan': bulanSelectedSearchHistory.value,
      'tahun': tahunSelectedSearchHistory.value,
      'ajuan': '1',
    };
    var connect = Api.connectionApi("post", body, "history-emp_leave");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        if (valueBody['status'] == false) {
          stringLoading.value = "Tidak ada pengajuan";
          this.stringLoading.refresh();
        } else {
          AlllistHistoryAjuan.value = valueBody['data'];
          listHistoryAjuan.value = valueBody['data'];
          if (listHistoryAjuan.value.isEmpty) {
            stringLoading.value = "Tidak ada pengajuan";
          } else {
            stringLoading.value = "Memuat Data...";
          }
          this.listHistoryAjuan.refresh();
          this.AlllistHistoryAjuan.refresh();
          this.stringLoading.refresh();
        }
      }
    });
  }

  void cariData(value) {
    var text = value.toLowerCase();
    var data = [];
    for (var element in AlllistHistoryAjuan.value) {
      var nomorAjuan = element['nomor_ajuan'].toLowerCase();
      if (nomorAjuan == text) {
        data.add(element);
      }
    }
    if (data.isEmpty) {
      stringLoading.value = "Tidak ada pengajuan";
    } else {
      stringLoading.value = "Memuat data...";
    }

    listHistoryAjuan.value = data;
    statusCari.value = true;
    this.listHistoryAjuan.refresh();
    this.stringLoading.refresh();
    this.statusCari.refresh();
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
    AlllistHistoryAjuan.value.forEach((element) {
      if (name == "Semua Status") {
        dataFilter.add(element);
      } else {
        if (element['leave_status'] == filter) {
          dataFilter.add(element);
        }
      }
    });
    listHistoryAjuan.value = dataFilter;
    this.listHistoryAjuan.refresh();
    if (dataFilter.isEmpty) {
      stringLoading.value = "Anda tidak memiliki\nRiwayat Pengajuan Cuti";
    } else {
      stringLoading.value = "Memuat Data...";
    }
  }

  void loadAllEmployeeDelegasi() {
    print("load all employee");
    allEmployeeDelegasi.value.clear();
    allEmployee.value.clear();
    var dataUser = AppData.informasiUser;
    var getDepGroup = dataUser![0].dep_group;
    var getDepId = dataUser![0].dep_id;
    var full_name = dataUser[0].full_name;

    // Map<String, dynamic> body = {'val': 'dep_group_id', 'cari': getDepGroup};
    // var connect = Api.connectionApi("post", body, "whereOnce-employee");
    var emid = dataUser[0].em_id;
    Map<String, dynamic> body = {
      'em_id': emid,
      'dep_group_id': getDepGroup,
      'dep_id': getDepId
    };
    var connect = Api.connectionApi("post", body, "employee-divisi");
    allEmployeeDelegasi.value.insert(0, "NONE");
    connect.then((dynamic res) {
      if (res == false) {
        //UtilsAlert.koneksiBuruk();
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
          if (statusForm.value == false) {
            var listFirst = allEmployeeDelegasi.value;
            var fullName = allEmployeeDelegasi.value[0];
            String namaUserPertama = "$fullName";
            selectedDelegasi.value = namaUserPertama;
          }
          this.allEmployee.refresh();
          this.allEmployeeDelegasi.refresh();
          this.selectedDelegasi.refresh();
        }
      }
    });
  }

  void checkingDelegation(em_id) {
    print('delegasi em id ${em_id}');

    // if (em_id=="null" || em_id == "" || em_id==null){

    // }else{

    if (em_id == "") {
    } else {
      var getData =
          allEmployee.value.firstWhere((element) => element["em_id"] == em_id);
      selectedDelegasi.value = getData["full_name"];
      this.selectedDelegasi.refresh();
    }

    //}
    print("data employee ${em_id},${allEmployee.value}");
  }

  void loadCutiUserMelahirkan() {
    var validasiTipeSelected = validasiSelectedType();
    print(validasiTipeSelected);
    var dataUser = AppData.informasiUser;
    var getEmid = dataUser![0].em_id;
    Map<String, dynamic> body = {
      'val': 'em_id',
      'cari': getEmid,
      'em_id': getEmid,
      'type_id': validasiTipeSelected
    };
    var connect = Api.connectionApi("post", body, "load_cuti_melahirkan");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
      }
    });
  }

  void loadCutiUser() {
    print("load cuti user");

    var dataUser = AppData.informasiUser;

    var getEmid = dataUser![0].em_id;

    Map<String, dynamic> body = {
      'val': 'em_id',
      'cari': getEmid,
    };
    var connect = Api.connectionApi("post", body, "whereOnce-assign_leave");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        if (valueBody['data'].isNotEmpty) {
          var totalDay =
              double.parse(valueBody['data'][0]['total_day'].toString());
          var terpakai =
              double.parse(valueBody['data'][0]['terpakai'].toString());
          print("ini data cuti user ${valueBody['data']}");
          if (totalDay == 0) {
            statusHitungCuti.value = false;
            this.statusHitungCuti.refresh();
          } else {
            jumlahCuti.value = totalDay;
            // cutLeave.value = 1;
            cutiTerpakai.value = terpakai;
            this.jumlahCuti.refresh();
            this.cutiTerpakai.refresh();
            statusHitungCuti.value = true;
            hitungCuti(totalDay, terpakai);
            this.statusHitungCuti.refresh();
          }
        } else {
          statusHitungCuti.value = false;
          this.statusHitungCuti.refresh();
        }
      }
    });
  }

  void hitungCuti(totalDay, terpakai) {
    var hitung1 = (terpakai / totalDay) * 100;
    // var convert1 = hitung1.toInt();
    var convert1 = hitung1;
    print("conver nilai ${convert1}");

    var convertedValue =
        double.parse(convert1 > 100 || convert1 < 0 ? "100" : "${convert1}") /
            100;
    persenCuti.value = convertedValue;
    this.persenCuti.refresh();
  }

  void takeFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png']);

    if (result != null) {
      PlatformFile file = result.files.first;
      if (file.size > 5000000) {
        UtilsAlert.showToast("Maaf file terlalu besar...Max 5MB");
      } else {
        namaFileUpload.value = "${file.name}";
        filePengajuan.value = await saveFilePermanently(file);
        uploadFile.value = true;
      }
    } else {
      UtilsAlert.showToast("Gagal mengambil file");
    }
  }

  Future<File> saveFilePermanently(PlatformFile file) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final newFile = File('${appStorage.path}/${file.name}');
    return File(file.path!).copy(newFile.path);
  }

  void validasiKirimPengajuan() async {
    if (isRequiredFile.value == "1" && uploadFile.value == false) {
      UtilsAlert.showToast("Form unggah file harus di isi");
    } else if (alasan.value.text == "") {
      UtilsAlert.showToast("Form Catatan Harus di isi");
    } else {
      var hitung = jumlahCuti.value - cutiTerpakai.value;

      if (hitung <= 0 || hitung == 0) {
        if (allowMinus.value == 0) {
          if (cutLeave.value == 1) {
            UtilsAlert.showToast("Cuti anda sudah habis");
            return;
          }
        }
      }
      if (cutLeave.value == 1) {
        if (tanggalSelected == 0) {
          UtilsAlert.showToast("Form * harus di isi");
          return;
        }
      }

      if (uploadFile.value == true) {
        UtilsAlert.loadingSimpanData(Get.context!, "Sedang Menyimpan File");
        var connectUpload = await Api.connectionApiUploadFile(
            "upload_form_cuti", filePengajuan.value);
        var valueBody = jsonDecode(connectUpload);
        if (valueBody['status'] == true) {
          UtilsAlert.showToast("Berhasil upload file");
          Navigator.pop(Get.context!);
          checkNomorAjuan();
        } else {
          Navigator.pop(Get.context!);
          UtilsAlert.showToast("Gagal kirim file");
        }
      } else {
        if (statusForm.value == false) {
          if (tanggalSelected.value.isEmpty) {
            UtilsAlert.showToast("Harap isi tanggal ajuan");
          } else {
            UtilsAlert.loadingSimpanData(Get.context!, "Sedang Menyimpan Data");
            checkNomorAjuan();
          }
        } else {
          UtilsAlert.loadingSimpanData(Get.context!, "Proses edit data");
          urutkanTanggalSelected();
          kirimFormAjuanCuti(nomorAjuan.value.text);
        }
      }
    }
  }

  void checkNomorAjuan() {
    urutkanTanggalSelected();
    var dt = DateTime.now();
    var dateString = "${dt.year}-${dt.month}-${dt.day}";
    var afterConvert = Constanst.convertDate1(dateString);
    var convertTanggalBikinPengajuan = statusForm.value == false
        ? Constanst.convertDateSimpan(afterConvert)
        : atten_date_edit.value;

    Map<String, dynamic> body = {
      'atten_date': convertTanggalBikinPengajuan,
      'pola': 'CT'
    };
    var connect = Api.connectionApi("post", body, "emp_leave_lastrow");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        if (valueBody['status'] == true) {
          if (valueBody['data'].isEmpty) {
            var now = DateTime.now();
            var convertBulan = now.month <= 9 ? "0${now.month}" : now.month;
            var finalNomor = "CT${now.year}${convertBulan}0001";
            kirimFormAjuanCuti(finalNomor);
          } else {
            var getNomorAjuanTerakhir = valueBody['data'][0]['nomor_ajuan'];
            var keyNomor = getNomorAjuanTerakhir.replaceAll("CT", '');
            var hasilTambah = int.parse(keyNomor) + 1;
            var finalNomor = "CT$hasilTambah";
            kirimFormAjuanCuti(finalNomor);
          }
        } else {
          UtilsAlert.showToast(
              "Data periode $convertTanggalBikinPengajuan belum tersedia, harap hubungi HRD");
        }
      }
    });
  }

  void checkNomorAjuanDalamAntrian(nomorAjuanTerakhirDalamAntrian) {
    var getNomorAjuanTerakhir = nomorAjuanTerakhirDalamAntrian;
    var keyNomor = getNomorAjuanTerakhir.replaceAll("CT", '');
    var hasilTambah = int.parse(keyNomor) + 1;
    var finalNomor = "CT$hasilTambah";
    kirimFormAjuanCuti(finalNomor);
  }

  void urutkanTanggalSelected() {
    var tampungStringTanggal = "";
    print('ini tanggal: $tanggalSelected');
    print('ini tanggal: $tanggalSelectedEdit');

    // Menentukan daftar tanggal yang akan diproses
    List<dynamic> tanggalDiproses =
        statusForm.value ? tanggalSelected.value : tanggalSelected.value;

    if (tanggalDiproses.isNotEmpty) {
      // Konversi ke DateTime dan hapus duplikasi
      List<DateTime> hasilConvert = tanggalDiproses
          .map((element) => element is DateTime
              ? element
              : DateTime.parse(element.toString()))
          .toSet()
          .toList();

      // Urutkan tanggal
      hasilConvert.sort((a, b) => a.compareTo(b));

      if (hasilConvert.isNotEmpty) {
        DateTime dari = hasilConvert.first;
        DateTime sampai = hasilConvert.last;

        // Generate semua tanggal dalam rentang tersebut
        List<String> semuaTanggal = [];
        for (DateTime date = dari;
            date.isBefore(sampai.add(Duration(days: 1)));
            date = date.add(Duration(days: 1))) {
          semuaTanggal.add(DateFormat('yyyy-MM-dd').format(date));
        }

        // Set hasil ke variabel yang sesuai
        dariTanggal.value.text = DateFormat('yyyy-MM-dd').format(dari);
        sampaiTanggal.value.text = DateFormat('yyyy-MM-dd').format(sampai);
        durasiIzin.value = semuaTanggal.length;
        stringSelectedTanggal.value = semuaTanggal.join(',');

        // Debugging
        print("Dari tanggal: ${dariTanggal.value.text}");
        print("Sampai tanggal: ${sampaiTanggal.value.text}");
        print("Durasi izin: ${durasiIzin.value}");
        print("String selected tanggal: ${stringSelectedTanggal.value}");

        // Refresh semua nilai
        dariTanggal.refresh();
        sampaiTanggal.refresh();
        durasiIzin.refresh();
        stringSelectedTanggal.refresh();
      }
    }
  }

  void kirimFormAjuanCuti(getNomorAjuanTerakhir) async {
    var dataUser = AppData.informasiUser;
    var getEmid = dataUser![0].em_id;
    var getFullName = dataUser[0].full_name;
    var validasiTipeSelected = validasiSelectedType();
    var validasiDelegasiSelected = validasiSelectedDelegasi();
    var validasiDelegasiSelectedToken = validasiSelectedDelegasiToken();
    var dt = DateTime.now();
    var dateString = "${dt.year}-${dt.month}-${dt.day}";
    var afterConvert = Constanst.convertDate1(dateString);
    var convertTanggalBikinPengajuan = statusForm.value == false
        ? Constanst.convertDateSimpan(afterConvert)
        : atten_date_edit.value;
    Map<String, dynamic> body;

    if (selectedTypeCuti.value
        .toString()
        .toLowerCase()
        .toLowerCase()
        .contains("Cuti Melahirkan".toLowerCase())) {
      body = {
        'em_id': '$getEmid',
        'typeid': validasiTipeSelected,
        'nomor_ajuan': getNomorAjuanTerakhir,
        'leave_type': 'FULLDAY',
        'start_date': startDate.value,
        'end_date': endDate.value,
        'leave_duration': durasiIzin.value,
        'date_selected': stringSelectedTanggal.value,
        'apply_date': '',
        'reason': alasan.value.text,
        'leave_status': 'Pending',
        'atten_date': convertTanggalBikinPengajuan,
        'em_delegation': validasiDelegasiSelected,
        'leave_files': namaFileUpload.value,
        'ajuan': '1',
        'created_by': getEmid,
        'menu_name': 'Cuti',
        'apply_status': "Pending"
      };
    } else {
      body = {
        'em_id': '$getEmid',
        'typeid': validasiTipeSelected,
        'nomor_ajuan': getNomorAjuanTerakhir,
        // 'leave_type': 'Full Day',
        'leave_type': 'FULLDAY',
        'start_date': dariTanggal.value.text,
        'end_date': sampaiTanggal.value.text,
        'leave_duration': durasiIzin.value,
        'date_selected': stringSelectedTanggal.value,
        'apply_date': '',
        'reason': alasan.value.text,
        'leave_status': 'Pending',
        'atten_date': convertTanggalBikinPengajuan,
        'em_delegation': validasiDelegasiSelected,
        'leave_files': namaFileUpload.value,
        'ajuan': '1',
        'created_by': getEmid,
        'menu_name': 'Cuti',
        'apply_status': "Pending",
        'total_cuti': jumlahCuti.toInt(),
        'cut_leave': cutLeave.value
      };
    }

    var typeNotifFcm = "Pengajuan Cuti";
    if (statusForm.value == false) {
      body['activity_name'] =
          "Membuat Pengajuan Cuti. alasan = ${alasan.value.text}";
      var connect = Api.connectionApi("post", body, "cuti");
      connect.then((dynamic res) {
        if (res.statusCode == 200) {
          var valueBody = jsonDecode(res.body);
          if (valueBody['status'] == true) {
            var stringTanggal =
                "${dariTanggal.value.text} sd ${sampaiTanggal.value.text}";
            // kirimNotifikasiToDelegasi(
            //     getFullName,
            //     convertTanggalBikinPengajuan,
            //     validasiDelegasiSelected,
            //     validasiDelegasiSelectedToken,
            //     stringTanggal,
            //     typeNotifFcm);
            // kirimNotifikasiToReportTo(getFullName, convertTanggalBikinPengajuan,
            //     getEmid, "Cuti", stringTanggal);
            Navigator.pop(Get.context!);

            var pesan1 = "Pengajuan ${selectedTypeCuti.value} berhasil di buat";
            var pesan2 =
                "Selanjutnya silahkan menunggu atasan kamu untuk menyetujui pengajuan yang telah dibuat atau langsung";
            var pesan3 = "konfirmasi via WhatsApp";
            var dataPengajuan = {
              'nameType': '${selectedTypeCuti.value}',
              'nomor_ajuan': '${getNomorAjuanTerakhir}',
            };
            for (var item in globalCt.konfirmasiAtasan) {
              var pesan;
              if (item['em_gender'] == "PRIA") {
                pesan =
                    "Hallo pak ${item['full_name']}, saya ${getFullName} mengajukan ${selectedTypeCuti.value} dengan nomor ajuan ${getNomorAjuanTerakhir}";
              } else {
                pesan =
                    "Hallo bu ${item['full_name']}, saya ${getFullName} mengajukan ${selectedTypeCuti.value} dengan nomor ajuan ${getNomorAjuanTerakhir}";
              }
              kirimNotifikasiToDelegasi1(
                  getFullName,
                  convertTanggalBikinPengajuan,
                  item['em_id'],
                  validasiDelegasiSelectedToken,
                  stringTanggal,
                  typeNotifFcm,
                  pesan);
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
            print('ini value body cuti ${valueBody}');
            if (valueBody['message'] == "ulang") {
              var nomorAjuanTerakhirDalamAntrian =
                  valueBody['data'][0]['nomor_ajuan'];
              checkNomorAjuanDalamAntrian(nomorAjuanTerakhirDalamAntrian);
            } else if (valueBody['message'] == 'gagal ambil data') {
              Navigator.pop(Get.context!);
              messageApi.value = "Data periode $convertTanggalBikinPengajuan belum tersedia, harap hubungi HRD";
              // UtilsAlert.showToast(
              //     "Data periode $convertTanggalBikinPengajuan belum tersedia, harap hubungi HRD");
            } else {
              Navigator.pop(Get.context!);
              messageApi.value = valueBody['message'];
              // UtilsAlert.showToast(valueBody['message']);
            }
          }
        }
      });
    } else {
      body['val'] = "id";
      body['cari'] = idEditFormCuti.value;
      body['activity_name'] =
          "Edit Pengajuan Cuti. Tanggal Pengajuan = $convertTanggalBikinPengajuan";
      print('ini body edit cuti $body');
      var connect = Api.connectionApi("post", body, "edit-emp_leave");
      connect.then((dynamic res) {
        var valueBody = jsonDecode(res.body);
        if (res.statusCode == 200) {
          Navigator.pop(Get.context!);

          var pesan1 = "Pengajuan ${selectedTypeCuti.value} berhasil di edit";
          var pesan2 =
              "Selanjutnya silahkan menunggu atasan kamu untuk menyetujui pengajuan yang telah dibuat atau langsung";
          var pesan3 = "konfirmasi via WhatsApp";
          var dataPengajuan = {
            'nameType': '${selectedTypeCuti.value}',
            'nomor_ajuan': '${getNomorAjuanTerakhir}',
          };

          Get.offAll(BerhasilPengajuan(
            dataBerhasil: [pesan1, pesan2, pesan3, dataPengajuan],
          ));
        }else{
          Navigator.pop(Get.context!);
          messageApi.value = valueBody['message'];
              // UtilsAlert.showToast(valueBody['message']);
        }
      });
    }
  }

  void kirimNotifikasiToDelegasi(getFullName, convertTanggalBikinPengajuan,
      validasiDelegasiSelected, fcmTokenDelegasi, stringTanggal, typeNotifFcm) {
    var dt = DateTime.now();
    var description =
        'Anda mendapatkan delegasi pekerjaan dari $getFullName untuk pengajuan $selectedTypeCuti, tanggal pengajuan $stringTanggal';
    var jamSekarang = DateFormat('HH:mm:ss').format(dt);
    Map<String, dynamic> body = {
      'em_id': validasiDelegasiSelected,
      'title': 'Delegasi Pengajuan Cuti',
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
      stringTanggal,
      typeNotifFcm,
      pesan) {
    var dt = DateTime.now();
    var description =
        'Anda mendapatkan delegasi pekerjaan dari $getFullName untuk pengajuan $selectedTypeCuti, tanggal pengajuan $stringTanggal';
    var jamSekarang = DateFormat('HH:mm:ss').format(dt);
    Map<String, dynamic> body = {
      'em_id': validasiDelegasiSelected,
      'title': 'Approval Cuti',
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
      getFullName, convertTanggalBikinPengajuan, getEmid, type, stringTanggal) {
    var dt = DateTime.now();
    var jamSekarang = DateFormat('HH:mm:ss').format(dt);
    Map<String, dynamic> body = {
      'emId_pengaju': getEmid,
      'title': 'Pengajuan Cuti',
      'deskripsi':
          'Anda mendapatkan pengajuan $type dari $getFullName, tanggal pengajuan $stringTanggal',
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

  String validasiSelectedType() {
    var result = [];
    for (var element in allTipe.value) {
      if (element['name'] == selectedTypeCuti.value) {
        result.add(element);
      }
    }
    return "${result[0]['id']}";
  }

  String validasiSelectedDelegasi() {
    var result = [];
    for (var element in allEmployee.value) {
      var fullName = element['full_name'] ?? "";
      var namaElement = "$fullName";
      if (namaElement == selectedDelegasi.value) {
        result.add(element);
      }
    }
    if (result.isEmpty) {
      return "";
    } else {
      return "${result[0]['em_id']}";
    }
  }

  String validasiSelectedDelegasiToken() {
    var result = [];
    for (var element in allEmployee.value) {
      var fullName = element['full_name'] ?? "";
      var namaElement = "$fullName";
      if (namaElement == selectedDelegasi.value) {
        result.add(element);
      }
    }
    if (result.isEmpty) {
      return "";
    } else {
      return "${result[0]['token_notif']}";
    }
  }

  String validasiHitungIzin() {
    var getDari = dariTanggal.value.text.split('-');
    var getSampai = sampaiTanggal.value.text.split('-');
    var hitung;
    if (getDari[1] == getSampai[1]) {
      hitung = (int.parse(getSampai[0]) - int.parse(getDari[0])) + 1;
    } else {
      // get dari
      var year = int.parse(getDari[2]);
      var bulan = int.parse(getDari[1]);
      DateTime convert1 = new DateTime(year, bulan + 1, 0);
      var allDayMonthDari = "${convert1.day}";
      var proses1 = int.parse(allDayMonthDari) - int.parse(getDari[0]);
      // get sampai
      hitung = (proses1 + int.parse(getSampai[0])) + 1;
    }
    return "$hitung";
  }

  // void batalkanPengajuanCuti(index) {
  //   showGeneralDialog(
  //     barrierDismissible: false,
  //     context: Get.context!,
  //     barrierColor: Colors.black54, // space around dialog
  //     transitionDuration: Duration(milliseconds: 200),
  //     transitionBuilder: (context, a1, a2, child) {
  //       return ScaleTransition(
  //         scale: CurvedAnimation(
  //             parent: a1,
  //             curve: Curves.elasticOut,
  //             reverseCurve: Curves.easeOutCubic),
  //         child: CustomDialog(
  //           // our custom dialog
  //           title: "Peringatan",
  //           content: "Yakin Batalkan Pengajuan ?",
  //           positiveBtnText: "Batalkan",
  //           negativeBtnText: "Kembali",
  //           style: 1,
  //           buttonStatus: 1,
  //           positiveBtnPressed: () {
  //             batalkanPengajuan(index);
  //           },
  //         ),
  //       );
  //     },
  //     pageBuilder: (BuildContext context, Animation animation,
  //         Animation secondaryAnimation) {
  //       return null!;
  //     },
  //   );
  // }

  void batalkanPengajuanCuti(index) {
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
                ),
                SizedBox(height: 16.0)
              ],
            ),
          ),
        );
      },
    );
  }

  void batalkanPengajuan(index) {
    UtilsAlert.loadingSimpanData(Get.context!, "Batalkan Pengajuan");
    var dataUser = AppData.informasiUser;
    var getEmid = dataUser![0].em_id;
    Map<String, dynamic> body = {
      'menu_name': 'Cuti',
      'activity_name':
          'Membatalkan form pengajuan Cuti. Tanggal = ${index["start_date"]} sd Tanggal = ${index["end_date"]} Durasi Cuti = ${index["leave_duration"]} Alasan = ${index["reason"]}',
      'created_by': '$getEmid',
      'val': 'id',
      'cari': '${index["id"]}',
      'status_transaksi': 0,
      'start_date': '${index["atten_date"]}',
      'leave_status': "Cancel"
    };
    print("body ${body}");
    var connect = Api.connectionApi("post", body, "edit-emp_leave");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        Navigator.pop(Get.context!);
        Navigator.pop(Get.context!);
        Navigator.pop(Get.context!);
        UtilsAlert.showToast("Berhasil batalkan pengajuan");
        onReady();
      }
    });
  }

  // void showModalBatalPengajuan(index) {
  //   showModalBottomSheet(
  //     context: Get.context!,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(
  //         top: Radius.circular(10.0),
  //       ),
  //     ),
  //     builder: (context) {
  //       return Column(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           SizedBox(
  //             height: 16,
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.only(left: 16, right: 16),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Row(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Expanded(
  //                       flex: 90,
  //                       child: Row(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Container(
  //                             height: 40,
  //                             width: 40,
  //                             decoration: BoxDecoration(
  //                               color: Constanst.colorBGRejected,
  //                               shape: BoxShape.circle,
  //                             ),
  //                             child: Center(
  //                               child: Icon(
  //                                 Iconsax.minus_cirlce,
  //                                 color: Colors.red,
  //                               ),
  //                             ),
  //                           ),
  //                           Padding(
  //                             padding: EdgeInsets.only(left: 6),
  //                             child: Padding(
  //                               padding: EdgeInsets.only(top: 6),
  //                               child: Text(
  //                                 "Batalkan Pengajuan Cuti",
  //                                 style: TextStyle(
  //                                     fontWeight: FontWeight.bold,
  //                                     fontSize: 16),
  //                               ),
  //                             ),
  //                           )
  //                         ],
  //                       ),
  //                     ),
  //                     Expanded(
  //                         flex: 10,
  //                         child: InkWell(
  //                           onTap: () => Navigator.pop(Get.context!),
  //                           child: Padding(
  //                             padding: EdgeInsets.only(top: 6),
  //                             child: Icon(Iconsax.close_circle),
  //                           ),
  //                         ))
  //                   ],
  //                 ),
  //                 SizedBox(
  //                   height: 16,
  //                 ),
  //                 Text(
  //                   "Data pengajuan yang telah kamu buat akan di hapus. Yakin ingin membatalkan pengajuan?",
  //                   textAlign: TextAlign.justify,
  //                   style: TextStyle(color: Constanst.colorText2),
  //                 ),
  //                 SizedBox(
  //                   height: 16,
  //                 ),
  //                 Row(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Expanded(
  //                       child: Padding(
  //                         padding: const EdgeInsets.only(right: 5),
  //                         child: TextButtonWidget(
  //                           title: "Ya, Batalkan",
  //                           onTap: () async {
  //                             print("dat ${index}");
  //                             batalkanPengajuan(index);
  //                           },
  //                           colorButton: Constanst.colorButton1,
  //                           colortext: Constanst.colorWhite,
  //                           border: BorderRadius.circular(10.0),
  //                         ),
  //                       ),
  //                     ),
  //                     Expanded(
  //                       child: InkWell(
  //                         onTap: () => Navigator.pop(Get.context!),
  //                         child: Container(
  //                             decoration: BoxDecoration(
  //                                 borderRadius: Constanst.borderStyle2,
  //                                 border: Border.all(
  //                                     color: Constanst.colorPrimary)),
  //                             child: Center(
  //                               child: Padding(
  //                                 padding: EdgeInsets.only(top: 12, bottom: 12),
  //                                 child: Text(
  //                                   "Urungkan",
  //                                   style: TextStyle(
  //                                       color: Constanst.colorPrimary),
  //                                 ),
  //                               ),
  //                             )),
  //                       ),
  //                     )
  //                   ],
  //                 )
  //               ],
  //             ),
  //           ),
  //           SizedBox(
  //             height: 16,
  //           )
  //         ],
  //       );
  //     },
  //   );
  // }

  void showDetailRiwayat(detailData, apply_by, alasanReject) {
    var nomorAjuan = detailData['nomor_ajuan'];
    var tanggalMasukAjuan = detailData['atten_date'];
    var tanggalMasukAjuanDate = DateTime.parse(detailData['atten_date']);
    var namaTypeAjuan = detailData['name'];
    var tanggalAjuanDari = detailData['start_date'];
    var tanggalAjuanSampai = detailData['end_date'];
    var tanggalAjuanDariDate = DateTime.parse(detailData['start_date']);
    var alasan = detailData['reason'];
    var durasi = detailData['leave_duration'];
    var typeAjuan = detailData['leave_status'];
    var tanggalMasuk = DateTime(tanggalMasukAjuanDate.year,
        tanggalMasukAjuanDate.month, tanggalMasukAjuanDate.day);
    var tanggalDari = DateTime(tanggalAjuanDariDate.year,
        tanggalAjuanDariDate.month, tanggalAjuanDariDate.day);

    Duration difference = tanggalDari.difference(tanggalMasuk);
    print('ini data diferent ${difference.inDays}');
    print('ini data diferent ${tanggalMasuk}');
    print('ini data diferent ${tanggalDari}');
    print('ini data diferent ${difference}');
    if (valuePolaPersetujuan.value == "1") {
      typeAjuan = detailData['leave_status'];
    } else {
      typeAjuan = detailData['leave_status'] == "Approve"
          ? "Approve 1"
          : detailData['leave_status'] == "Approve2"
              ? "Approve 2"
              : detailData['leave_status'];
    }
    var leave_files = detailData['leave_files'];
    var listTanggalTerpilih = detailData['date_selected'].split(',');
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
                          "Tanggal Cuti",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Constanst.fgSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        detailData['date_selected'] == null ||
                                detailData['date_selected'] == "" ||
                                detailData['date_selected'] == "null"
                            ? Text(
                                "${Constanst.convertDate6(tanggalAjuanDari)} - ${Constanst.convertDate6(tanggalAjuanSampai)}",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Constanst.fgPrimary,
                                ),
                              )
                            : Container(),
                        detailData['date_selected'] == null ||
                                detailData['date_selected'] == "" ||
                                detailData['date_selected'] == "null"
                            ? Container()
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
                                            : '$tanggalConvert,',
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
                          "Durasi Cuti",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Constanst.fgSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "$durasi Hari",
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
                          "Catatan",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Constanst.fgSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "$alasan",
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
                                      Text("Rejected by $apply_by",
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
                                      Text("Approved by $apply_by",
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
                        typeAjuan == "Approve 2" ||
                        typeAjuan == "Rejected"
                    ? const SizedBox(height: 16)
                    : Padding(
                      padding: const EdgeInsets.only(bottom: 16.0, top: 16.0),
                      child: Row(
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
                                    batalkanPengajuanCuti(detailData);
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
                                    print(detailData.toString());
                                    loadDataTypeCutiEdit(
                                        durasi: difference.inDays.toString(),
                                        detailData: detailData);
                                    // Get.to(FormPengajuanCuti(
                                    //   dataForm: [detailData, true],
                                    // ));
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
                        ),
                    )
              ],
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
}
