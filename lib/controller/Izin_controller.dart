import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:siscom_operasional/controller/global_controller.dart';
import 'package:siscom_operasional/model/atasan_model.dart';
import 'package:siscom_operasional/screen/absen/form/berhasil_pengajuan.dart';
import 'package:siscom_operasional/screen/absen/form/form_pengajuan_izin.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/custom_dialog.dart';
import 'package:siscom_operasional/utils/widget_textButton.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class IzinController extends GetxController {
  var cari = TextEditingController().obs;
  var nomorAjuan = TextEditingController().obs;
  var dariTanggal = TextEditingController().obs;
  var sampaiTanggal = TextEditingController().obs;
  var jamAjuan = TextEditingController().obs;
  var sampaiJamAjuan = TextEditingController().obs;
  var alasan = TextEditingController().obs;
  var departemen = TextEditingController().obs;
  var izinTerpakai = 0.obs;
  var jumlahIzin = 0.obs;
  var percentIzin = 0.0.obs;
  var showDurationIzin = false.obs;
  var inputTime = 0.obs;

  var typeTap = 0.obs;

  var filePengajuan = File("").obs;

  var dataTypeAjuan = [].obs;
  var AlllistHistoryAjuan = [].obs;
  var allNameLaporanTidakhadir = [].obs;
  var allNameLaporanTidakhadirCopy = [].obs;

  var listHistoryAjuan = [].obs;
  var allTipe = [].obs;
  var allEmployee = [].obs;
  var tanggalSelected = [].obs;
  var departementAkses = [].obs;
  var konfirmasiAtasan = [].obs;
  var tanggalSelectedEdit = <DateTime>[].obs;
  var isRequiredFile = '0'.obs;
  var isBackdate = "0".obs;

  var isLoadingzin = false.obs;

  Rx<List<String>> allEmployeeDelegasi = Rx<List<String>>([]);
  Rx<List<String>> allTipeFormTidakMasukKerja = Rx<List<String>>([]);
  var izinCategory = [].obs;
  Rx<List<String>> allTipeFormTidakMasukKerja1 = Rx<List<String>>([]);

  var statusFormPencarian = false.obs;

  var tempNamaStatus1 = "Semua Status".obs;
  var tempNamaTipe1 = "Semua Tipe".obs;

  var bulanSelectedSearchHistory = "".obs;
  var tahunSelectedSearchHistory = "".obs;
  var bulanDanTahunNow = "".obs;
  var namaFileUpload = "".obs;
  var tanggalBikinPengajuan = "".obs;
  var idEditFormTidakMasukKerja = "".obs;
  var emDelegationEdit = "".obs;
  var idDepartemenTerpilih = "".obs;
  var namaDepartemenTerpilih = "".obs;
  var loadingString = "Memuat Data...".obs;

  var stringSelectedTanggal = "".obs;
  var valuePolaPersetujuan = "".obs;

  var selectedTypeAjuan = "Semua Status".obs;

  var selectedDropdownFormTidakMasukKerjaTipe = "".obs;
  var selectedDropdownFormTidakMasukKerjaDelegasi = "".obs;

  var selectedType = 0.obs;
  var durasiIzin = 0.obs;
  var jumlahData = 0.obs;

  var screenTanggalSelected = true.obs;
  var uploadFile = false.obs;
  var statusCari = false.obs;
  var showTipe = false.obs;
  var showButtonlaporan = false.obs;
  var statusLoadingSubmitLaporan = false.obs;
  var viewFormWaktu = false.obs;

  var dataTypeAjuanDummy1 = ["Semua Status", "Approve", "Rejected", "Pending"];
  var dataTypeAjuanDummy2 = [
    "Semua Status",
    "Approve 1",
    "Approve 2",
    "Rejected",
    "Pending"
  ];
  var globalCt = Get.put(GlobalController());
  @override
  void onReady() async {
    super.onReady();
  }

  @override
  void onInit() {
    getTimeNow();
    // getLoadsysData();
    //loadAllEmployeeDelegasi();
    // loadTypeSakit();
    // loadDataAjuanIzin();
    // getDepartemen(1, "");
    super.onInit();
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
    var outputFormat1 = DateFormat('MM');
    var outputFormat2 = DateFormat('yyyy');
    bulanSelectedSearchHistory.value = outputFormat1.format(dt);
    tahunSelectedSearchHistory.value = outputFormat2.format(dt);
    bulanDanTahunNow.value =
        "${bulanSelectedSearchHistory.value}-${tahunSelectedSearchHistory.value}";

    var dateString = "${dt.year}-${dt.month}-${dt.day}";
    var afterConvert = Constanst.convertDate1(dateString);
    if (idEditFormTidakMasukKerja.value == "") {
      dariTanggal.value.text = "$afterConvert";
      sampaiTanggal.value.text = "$afterConvert";
      tanggalBikinPengajuan.value = "$afterConvert";
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

  void loadDataAjuanIzin() {
    AlllistHistoryAjuan.value.clear();
    listHistoryAjuan.value.clear();
    var dataUser = AppData.informasiUser;
    var getEmid = dataUser![0].em_id;
    Map<String, dynamic> body = {
      'em_id': getEmid,
      'bulan': bulanSelectedSearchHistory.value,
      'tahun': tahunSelectedSearchHistory.value,
    };
    var connect = Api.connectionApi("post", body, "emp_leave_load_izin");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        if (valueBody['status'] == false) {
          loadingString.value = "Anda tidak memiliki\nRiwayat Pengajuan Izin";
          this.loadingString.refresh();
        } else {
          AlllistHistoryAjuan.value = valueBody['data'];
          for (var element in valueBody['data']) {
            // if (element['category'] == 'FULLDAY') {
            listHistoryAjuan.value.add(element);
            // }
          }
          if (listHistoryAjuan.value.length == 0) {
            loadingString.value = "Anda tidak memiliki\nRiwayat Pengajuan Izin";
          } else {
            loadingString.value = "Sedang memuat data...";
          }
          this.listHistoryAjuan.refresh();
          this.AlllistHistoryAjuan.refresh();
          this.loadingString.refresh();
        }
      }
    });
  }

  Future<bool> loadDataAjuanIzinCategori({id}) async {
    print("masuk sini");
    // AlllistHistoryAjuan.value.clear();
    // listHistoryAjuan.value.clear();
    var dataUser = AppData.informasiUser;
    var getEmid = dataUser![0].em_id;
    Map<String, dynamic> body = {
      'em_id': getEmid,
      'bulan': bulanSelectedSearchHistory.value,
      'tahun': tahunSelectedSearchHistory.value,
      'type_id': id.toString()
    };
    var connect =
        Api.connectionApi("post", body, "emp_leave_load_izin_Kategori");
    await connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        print("data value body ${valueBody}");
        if (valueBody['status'] == false) {
          // loadingString.value =  "Anda tidak memiliki\nRiwayat Pengajuan Izin";
          izinCategory.value = [];
          this.loadingString.refresh();
          izinTerpakai.value = 0;
          return true;
        } else {
          izinTerpakai.value = valueBody['jumlah_data'];
          izinCategory.value = valueBody['data'];
          return true;
        }
      }
    });
    return true;
  }

  void cariData(value) {
    var text = value.toLowerCase();
    var filter = AlllistHistoryAjuan.where((ajuan) {
      var getAjuan = ajuan['nomor_ajuan'].toLowerCase();
      return getAjuan.contains(text);
    }).toList();
    listHistoryAjuan.value = filter;
    statusCari.value = true;
    this.listHistoryAjuan.refresh();
    this.statusCari.refresh();
    // var data = [];
    // for (var element in AlllistHistoryAjuan) {
    //   var nomorAjuan = element['nomor_ajuan'].toLowerCase();
    //   if (nomorAjuan == text) {
    //     data.add(element);
    //   }
    // }
    // if (data.isEmpty) {
    //   loadingString.value =  "Anda tidak memiliki\nRiwayat Pengajuan Izin";
    // } else {
    //   loadingString.value = "Memuat data...";
    // }
    // listHistoryAjuan.value = data;
    // statusCari.value = true;

    if (listHistoryAjuan.value.isEmpty) {
      loadingString.value = "Anda tidak memiliki\nRiwayat Pengajuan Izin";
    } else {
      loadingString.value = "Memuat data...";
    }

    this.loadingString.refresh();
  }

  void loadAllEmployeeDelegasi() {
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
    Future.delayed(Duration(seconds: 1), () {
      connect.then((dynamic res) {
        if (res == false) {
          //UtilsAlert.koneksiBuruk();
        } else {
          if (res.statusCode == 200) {
            var valueBody = jsonDecode(res.body);
            List  data = valueBody['data'];
            
            for (var element in data) {
                 print("status new new${element['status'] }");
              if (element['status'] == 'ACTIVE') {
             
                var fullName = element['full_name'] ?? "";
                String namaUser = "$fullName";

                if (namaUser != full_name) {
                  allEmployeeDelegasi.value.add(namaUser);
                }
                allEmployee.value.add(element);
              }
            }
            if (idEditFormTidakMasukKerja == "") {
              List data = valueBody['data'];
              // var listFirst = data
              //     .where((element) => element['full_name'] != full_name)
              //     .toList()
              //     .first;
              // var fullName = listFirst['full_name'] ?? "";
              var fullName = allEmployeeDelegasi.value[0];
              String namaUserPertama = "$fullName";
              selectedDropdownFormTidakMasukKerjaDelegasi.value =
                  namaUserPertama;
            }

            this.allEmployee.refresh();
            this.allEmployeeDelegasi.refresh();
            this.selectedDropdownFormTidakMasukKerjaDelegasi.refresh();
          }
        }
      });
    });
  }

  void validasiEmdelegation(em_id) {
    var dapatData = allEmployee.value
        .where((element) => element['em_id'] == emDelegationEdit.value)
        .toList();
    if (dapatData.isNotEmpty) {
      selectedDropdownFormTidakMasukKerjaDelegasi.value =
          dapatData[0]['full_name'];
      this.selectedDropdownFormTidakMasukKerjaDelegasi.refresh();
    }
  }

  void loadTypeSakit() {
    allTipeFormTidakMasukKerja1.value.clear();
    allTipeFormTidakMasukKerja.value.clear();
    isLoadingzin.value = true;
    showTipe.value = false;
    allTipe.value.clear();
    Map<String, dynamic> body = {'val': 'status', 'cari': '2'};
    var connect = Api.connectionApi("post", body, "whereOnce-leave_types");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        var data = valueBody['data'];

        print("data type sakit new  ${data}");
        for (var element in data) {
          allTipeFormTidakMasukKerja1.value
              .add("${element['name']} - ${element['category']}");

          allTipeFormTidakMasukKerja.value
              .add("${element['name']} - ${element['category']}");

          var data = {
            'type_id': element['id'],
            'name': element['name'],
            'status': element['status'],
            'category': element['category'],
            'leave_day': element['leave_day'],
            'cut_leave': element['cut_leave'],
            'upload_file': element['upload_file'],
            'input_time': element['input_time'],
            'back_date': element['backdate'] ?? "0",
            'ajuan': 2,
            'active': false,
          };
          allTipe.value.add(data);

          print(data);
        }
        if (idEditFormTidakMasukKerja == "") {
          var listFirst = allTipeFormTidakMasukKerja.value.first;
          selectedDropdownFormTidakMasukKerjaTipe.value = listFirst;

          if (allTipe[0]['input_time'] == null) {
          } else {
            inputTime.value = int.parse(allTipe[0]['input_time'].toString());
            isBackdate.value = allTipe[0]['back_date'].toString();
          }
        }
        loadTypeIzin();
      }
    });
  }

  void loadTypeIzin() {
    Map<String, dynamic> body = {'val': 'status', 'cari': '3'};
    var connect = Api.connectionApi("post", body, "whereOnce-leave_types");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        var data = valueBody['data'];

        for (var element in data) {
          allTipeFormTidakMasukKerja1.value
              .add("${element['name']} - ${element['category']}");
          allTipeFormTidakMasukKerja.value
              .add("${element['name']} - ${element['category']}");
          var data = {
            'leave_day': element['leave_day'],
            'type_id': element['id'],
            'name': element['name'],
            'status': element['status'],
            'category': element['category'],
            'cut_leave': element['cut_leave'],
            'upload_file': element['upload_file'],
            'input_time': element['input_time'],
            'back_date': element['backdate'] ?? "0",
            'ajuan': 3,
            'active': false,
          };
          allTipe.value.add(data);
        }
        showTipe.value = true;
        this.showTipe.refresh();
        this.allTipe.refresh();
        this.allTipeFormTidakMasukKerja.refresh();
        this.allTipeFormTidakMasukKerja1.refresh();
        changeTypeSelected(2);

        var getFirst = allTipe.value.first;

        isRequiredFile.value = getFirst['upload_file'].toString();

        var data1 = allTipe.value
            .where((element) => allTipeFormTidakMasukKerja.value
                .toString()
                .toLowerCase()
                .contains(element['name'].toString().toLowerCase()))
            .toList();

        if (data1[0]['leave_day'] > 0) {
          loadDataAjuanIzinCategori(id: data1[0]['id']);
          showDurationIzin.value = true;
          jumlahIzin.value = data[0]['leave_day'];
          percentIzin.value = double.parse(
              ((izinTerpakai.value / jumlahIzin.value) * 100).toString());
        } else {
          showDurationIzin.value = false;
        }

        if (data1[0]['input_time'] == null) {
        } else {
          inputTime.value = int.parse(data[0]['input_time'].toString());
        }
        jamAjuan.value.text = "";
        sampaiJamAjuan.value.text = "";
        isLoadingzin.value = false;
      }
    });
  }

  void gantiTypeAjuan(value) {
    var listData = value.split('-');
    var kategori = listData[1].replaceAll(' ', '');
    selectedDropdownFormTidakMasukKerjaTipe.value = value;
    if (kategori == "FULLDAY") {
      viewFormWaktu.value = false;
    } else if (kategori == "HALFDAY") {
      viewFormWaktu.value = true;
    }
    this.viewFormWaktu.refresh();
    this.selectedDropdownFormTidakMasukKerjaTipe.refresh();
  }

  void changeTypeSelected(index) {
    typeTap.value = index;
    listHistoryAjuan.value.clear();
    if (index == 0) {
      allTipeFormTidakMasukKerja.value =
          allTipeFormTidakMasukKerja1.value.where((element) {
        return element.toString().contains("FULLDAY");
      }).toList();
      AlllistHistoryAjuan.value.forEach((element) {
        if (element['category'] == "FULLDAY") {
          listHistoryAjuan.value.add(element);
        }
      });
    } else if (index == 2) {
      allTipeFormTidakMasukKerja.value =
          allTipeFormTidakMasukKerja1.value.toList();
      AlllistHistoryAjuan.value.forEach((element) {
        listHistoryAjuan.value.add(element);
      });
    } else {
      allTipeFormTidakMasukKerja.value =
          allTipeFormTidakMasukKerja1.value.where((element) {
        return element.toString().contains("HALFDAY");
      }).toList();
      AlllistHistoryAjuan.value.forEach((element) {
        if (element['category'] == "HALFDAY") {
          listHistoryAjuan.value.add(element);
        }
      });
    }
    if (idEditFormTidakMasukKerja.value == "") {
      this.allTipe.refresh();
      this.allTipeFormTidakMasukKerja.refresh();
      var listFirst = allTipeFormTidakMasukKerja.value.first;
      selectedDropdownFormTidakMasukKerjaTipe.value = listFirst;
      this.selectedDropdownFormTidakMasukKerjaTipe.refresh();
    }
    loadingString.value = listHistoryAjuan.value.length == 0
        ? "Anda tidak memiliki\nRiwayat Pengajuan Izin"
        : "Memuat data...";
    selectedType.value = index;
    this.loadingString.refresh();
    this.listHistoryAjuan.refresh();
    this.selectedType.refresh();
    typeAjuanRefresh("Semua Status");
  }

  void typeAjuanRefresh(name) {
    print("name ${name}");
    for (var element in dataTypeAjuan.value) {
      if (element['nama'] == name) {
        element['status'] = true;
      } else {
        element['status'] = false;
      }
    }
    this.dataTypeAjuan.refresh();
  }

  void validasiTypeWhenEdit(value) {
    var selected = [];
    for (var element in allTipe.value) {
      if (element['name'] == value) {
        selected.add(element);
      }
    }
    selectedDropdownFormTidakMasukKerjaTipe.value =
        "${selected[0]['name']} - ${selected[0]['category']}";
    this.selectedDropdownFormTidakMasukKerjaTipe.refresh();
    if (selected[0]['category'] == "HALFDAY") {
      viewFormWaktu.value = true;
    } else {
      viewFormWaktu.value = false;
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
    if (name == "Semua Status") {
      var type = selectedType.value == 0 ? "FULLDAY" : "HALFDAY";
      listHistoryAjuan.value.clear();
      for (var element in AlllistHistoryAjuan) {
        if (element['category'] == type) {
          listHistoryAjuan.value.add(element);
        }
      }
      this.listHistoryAjuan.refresh();
      this.selectedType.refresh();
    } else {
      var type = selectedType.value == 0 ? "FULLDAY" : "HALFDAY";
      listHistoryAjuan.value.clear();
      for (var element in AlllistHistoryAjuan.value) {
        if (element['leave_status'] == filter) {
          if (element['category'] == type) {
            listHistoryAjuan.value.add(element);
          }
        }
      }
      this.listHistoryAjuan.refresh();
      this.selectedType.refresh();
    }
    loadingString.value = listHistoryAjuan.value.length != 0
        ? "Memuat data..."
        : "Anda tidak memiliki\nRiwayat Pengajuan Izin";
    this.loadingString.refresh();
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
        // print(file.name);
        // print(file.bytes);
        // print(file.size);
        // print(file.extension);
        // print(file.path);
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

  void validasiKirimPengajuan(status) {
    if (uploadFile.value == false && isRequiredFile.value == "1") {
      UtilsAlert.showToast("Form * harus diisi");
      return;
    }
    print("tanggal selecetd ${tanggalSelected.value.isEmpty}");
    print(viewFormWaktu.value);
    if (viewFormWaktu.value == true) {
      // if (jamAjuan.value.text == "" ||
      //     sampaiJamAjuan.value.text == "" ||
      //     alasan.value.text == "") {
      //   UtilsAlert.showToast("Form * harus di isi");
      // } else {
      if (status == true) {
        if (tanggalSelectedEdit.value.isEmpty) {
          UtilsAlert.showToast("Pilih tanggal terlebih dahulu");
        } else {
          nextKirimPengajuan(status);
        }
      } else {
        if (tanggalSelected.value.isEmpty) {
          UtilsAlert.showToast("Pilih tanggal terlebih dahulu");
        } else {
          nextKirimPengajuan(status);
        }
      }
      // }
    } else {
      // if (alasan.value.text == "") {
      //   UtilsAlert.showToast("Form * harus di isi");
      // } else

      if (tanggalSelectedEdit.value.isNotEmpty) {
        nextKirimPengajuan(status);

        // if (tanggalSelectedEdit.value.isNotEmpty){

        // }else {
        //   if (tanggalSelected.value.isEmpty){
        //      UtilsAlert.showToast("Pilih tanggal terlebih dahulu");

        //   }else{
        //       nextKirimPengajuan(status);

        //   }
        // }
      } else {
        if (tanggalSelected.value.isEmpty) {
          UtilsAlert.showToast("Pilih tanggal terlebih dahulu");
        } else {
          nextKirimPengajuan(status);
        }
      }
    }
  }

  void nextKirimPengajuan(status) async {
    print("masuk");
    if (uploadFile.value == true) {
      UtilsAlert.loadingSimpanData(Get.context!, "Sedang Menyimpan File");
      var connectUpload = await Api.connectionApiUploadFile(
          "upload_form_tidakMasukKerja", filePengajuan.value);
      var valueBody = jsonDecode(connectUpload);
      if (valueBody['status'] == true) {
        UtilsAlert.showToast("Berhasil upload file");
        Navigator.pop(Get.context!);
        checkNomorAjuan(status);
      } else {
        UtilsAlert.showToast("Gagal kirim file");
      }
    } else {
      if (status == false) {
        UtilsAlert.loadingSimpanData(Get.context!, "Sedang Menyimpan Data");
        checkNomorAjuan(status);
      } else {
        UtilsAlert.loadingSimpanData(Get.context!, "Proses edit data");
        urutkanTanggalSelected(status);
        kirimFormAjuanTidakMasukKerja(status, nomorAjuan.value.text);
      }
    }
  }

  void checkNomorAjuan(status) {
    print(tanggalBikinPengajuan.value);
    urutkanTanggalSelected(status);
    var convertTanggalBikinPengajuan = status == false
        ? Constanst.convertDateSimpan(tanggalBikinPengajuan.value)
        : tanggalBikinPengajuan.value;
    // print("tanggal bikin ajun" + convertTanggalBikinPengajuan);
    // print(
    //     "new type  ${allTipe.value} ${selectedDropdownFormTidakMasukKerjaTipe.value}");

    var data = allTipe.value
        .where((element) => selectedDropdownFormTidakMasukKerjaTipe.value
            .toString()
            .toLowerCase()
            .trim()
            .contains("${element['name']} - ${element['category']}"
                .toString()
                .toLowerCase()
                .trim()))
        .toList();

    var statusA = data[0]['status'].toString();
    var cutLeave = data[0]['cut_leave'].toString();
    print("data izin  nwew");
    print(statusA);
    print(cutLeave);

    var pola = "";
    if (statusA == "1") {
      pola = "CT";
    } else if (statusA == "3") {
      pola = "IZ";
    } else if (statusA == "2") {
      if (cutLeave == "0") {
        pola = "SD";
      } else {
        pola = "ST";
      }
    }

    // var pola = selectedDropdownFormTidakMasukKerjaTipe.value
    //         .toString()
    //         .contains("SAKIT DENGAN")
    //     ? "SD"
    //     : selectedDropdownFormTidakMasukKerjaTipe.value
    //             .toString()
    //             .contains("SAKIT TANPA")
    //         ? "ST"
    //         : "IZ";

    Map<String, dynamic> body = {
      'atten_date': convertTanggalBikinPengajuan,
      'pola': pola
    };
    print("body pola new ${body}");

    var connect = Api.connectionApi("post", body, "emp_leave_lastrow");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        if (valueBody['status'] == true) {
          if (valueBody['data'].isEmpty) {
            var now = DateTime.now();
            var convertBulan = now.month <= 9 ? "0${now.month}" : now.month;
            var finalNomor = "$pola${now.year}${convertBulan}0001";
            kirimFormAjuanTidakMasukKerja(status, finalNomor);
          } else {
            var getNomorAjuanTerakhir = valueBody['data'][0]['nomor_ajuan'];
            var keyNomor = getNomorAjuanTerakhir.replaceAll("$pola", '');
            var hasilTambah = int.parse(keyNomor) + 1;
            var finalNomor = "$pola$hasilTambah";
            kirimFormAjuanTidakMasukKerja(status, finalNomor);
          }
        } else {
          UtilsAlert.showToast(
              "Data periode $convertTanggalBikinPengajuan belum tersedia, harap hubungi HRD");
        }
      }
    });
  }

  void checkNomorAjuanDalamAntrian(status, nomorAjuanTerakhirDalamAntrian) {
    // var pola =
    // selectedDropdownFormTidakMasukKerjaTipe.value ==
    //         allTipe.value[0]['name']
    // var pola = selectedDropdownFormTidakMasukKerjaTipe.value
    //         .toString()
    //         .trim()
    //         .toLowerCase()
    //         .contains(allTipe.value[0]['name'].toString().trim().toLowerCase())
    //     ? "SD"
    //     : "ST";
    urutkanTanggalSelected(status);
    var convertTanggalBikinPengajuan = status == false
        ? Constanst.convertDateSimpan(tanggalBikinPengajuan.value)
        : tanggalBikinPengajuan.value;
    // print("tanggal bikin ajun" + convertTanggalBikinPengajuan);
    // print(
    //     "new type  ${allTipe.value} ${selectedDropdownFormTidakMasukKerjaTipe.value}");

    var data = allTipe.value
        .where((element) => selectedDropdownFormTidakMasukKerjaTipe.value
            .toString()
            .toLowerCase()
            .trim()
            .contains("${element['name']} - ${element['category']}"
                .toString()
                .toLowerCase()
                .trim()))
        .toList();

    var statusA = data[0]['status'].toString();
    var cutLeave = data[0]['cut_leave'].toString();
    print("data izin  nwew");
    print(statusA);
    print(cutLeave);

    var pola = "";
    if (statusA == "1") {
      pola = "CT";
    } else if (statusA == "3") {
      pola = "IZ";
    } else if (statusA == "2") {
      if (cutLeave == "0") {
        pola = "SD";
      } else {
        pola = "ST";
      }
    }

    var getNomorAjuanTerakhir = nomorAjuanTerakhirDalamAntrian;
    var keyNomor = getNomorAjuanTerakhir.replaceAll("$pola", '');
    var hasilTambah = int.parse(keyNomor) + 1;
    var finalNomor = "$pola$hasilTambah";
    kirimFormAjuanTidakMasukKerja(status, finalNomor);
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

  void kirimFormAjuanTidakMasukKerja(status, getNomorAjuanTerakhir) async {
    print("masuk ini ${tanggalBikinPengajuan.value}");
    var dataUser = AppData.informasiUser;
    var getEmid = "${dataUser![0].em_id}";
    var getFullName = "${dataUser[0].full_name}";

    var validasiTipeSelected = validasiSelectedType();
    var getAjuanType = validasiTypeAjuan();
    var validasiDelegasiSelected = validasiSelectedDelegasi();
    var validasiDelegasiSelectedToken = validasiSelectedDelegasiToken();

    var timeValue =
        viewFormWaktu.value == false ? "00:00:00" : "${jamAjuan.value.text}";
    var timeValue2 = viewFormWaktu.value == false
        ? "00:00:00"
        : "${sampaiJamAjuan.value.text}";

    var convertTanggalBikinPengajuan = status == false
        ? Constanst.convertDateSimpan(tanggalBikinPengajuan.value)
        : tanggalBikinPengajuan.value;

    var category = "";

    List type = allTipe
        .where(
            (p0) => p0['type_id'].toString() == validasiTipeSelected.toString())
        .toList();
    if (type.isNotEmpty) {
      category = type[0]['category'];
    }

    Map<String, dynamic> body = {
      'em_id': '$getEmid',
      'typeid': validasiTipeSelected,
      'nomor_ajuan': getNomorAjuanTerakhir,
      'leave_type': category,
      'start_date': dariTanggal.value.text,
      'end_date': sampaiTanggal.value.text,
      'leave_duration': durasiIzin.value,
      'date_selected': stringSelectedTanggal.value,
      'time_plan': timeValue,
      'time_plan_to': timeValue2,
      'apply_date': '',
      'reason': alasan.value.text,
      'leave_status': 'Pending',
      'atten_date': convertTanggalBikinPengajuan,
      'em_delegation': validasiDelegasiSelected,
      'leave_files': namaFileUpload.value,
      'ajuan': getAjuanType,
      'type': ' ${selectedDropdownFormTidakMasukKerjaTipe.value}',
      'apply_status': "Pending"
    };

    print("data body izin ${body}");
    if (status == false) {
      body['created_by'] = getEmid;
      body['menu_name'] = "Tidak Hadir";
      body['activity_name'] =
          "Membuat Pengajuan tidak hadir. alasan = ${alasan.value.text}";
      var connect = Api.connectionApi("post", body, "izin");
      connect.then((dynamic res) {
        if (res.statusCode == 200) {
          var typeNotifFcm = "Pengajuan Izin";
          var valueBody = jsonDecode(res.body);
          if (valueBody['status'] == true) {
            var stringTanggal =
                "${dariTanggal.value.text} sd ${sampaiTanggal.value.text}";

            kirimNotifikasiToDelegasi(
                getFullName,
                convertTanggalBikinPengajuan,
                validasiDelegasiSelected,
                validasiDelegasiSelectedToken,
                stringTanggal,
                typeNotifFcm);
            // kirimNotifikasiToReportTo(getFullName, convertTanggalBikinPengajuan,
            //     getEmid, stringTanggal);

            Navigator.pop(Get.context!);

            var pesan1 =
                "Pengajuan ${selectedDropdownFormTidakMasukKerjaTipe.value} berhasil di buat";
            var pesan2 =
                "Selanjutnya silahkan menunggu atasan kamu untuk menyetujui pengajuan yang telah dibuat atau langsung";
            var pesan3 = "konfirmasi via WhatsApp";
            var dataPengajuan = {
              'nameType': '${selectedDropdownFormTidakMasukKerjaTipe.value}',
              'nomor_ajuan': '${getNomorAjuanTerakhir}',
            };

            for (var item in globalCt.konfirmasiAtasan) {
              print("Token notif ${item['token_notif']}");
              var pesan;
              if (item['em_gender'] == "PRIA") {
                pesan =
                    "Hallo pak ${item['full_name']}, saya ${getFullName} mengajukan ${selectedDropdownFormTidakMasukKerjaTipe.value} dengan nomor ajuan ${getNomorAjuanTerakhir}";
              } else {
                pesan =
                    "Hallo bu ${item['full_name']}, saya ${getFullName} mengajukan ${selectedDropdownFormTidakMasukKerjaTipe.value} dengan nomor ajuan ${getNomorAjuanTerakhir}";
              }
              // kirimNotifikasiToDelegasi1(
              //     getFullName,
              //     convertTanggalBikinPengajuan,
              //     item['em_id'],
              //     validasiDelegasiSelectedToken,
              //     stringTanggal,
              //     typeNotifFcm,
              //     pesan);
              // if (item['token_notif'] != null) {
              //   globalCt.kirimNotifikasiFcm(
              //       title: typeNotifFcm,
              //       message: pesan,
              //       tokens: item['token_notif']);
              // }
            }
            loadTypeSakit();

            Get.offAll(BerhasilPengajuan(
              dataBerhasil: [pesan1, pesan2, pesan3, dataPengajuan],
            ));
          } else {
            print(valueBody['message']);
            if (valueBody['message'] == "ulang") {
              var nomorAjuanTerakhirDalamAntrian =
                  valueBody['data'][0]['nomor_ajuan'];
              checkNomorAjuanDalamAntrian(
                  status, nomorAjuanTerakhirDalamAntrian);
            }
            if (valueBody['message'] == "date") {
              Navigator.pop(Get.context!);
              UtilsAlert.showToast(valueBody['error']);
            } else {
              Navigator.pop(Get.context!);
              UtilsAlert.showToast(
                  "Data periode $convertTanggalBikinPengajuan belum tersedia, harap hubungi HRD");
            }
          }
        } else {
          var valueBody = jsonDecode(res.body);
          UtilsAlert.showToast(valueBody['message']);
          Get.back();
        }
      });
    } else {
      body['val'] = 'id';
      body['cari'] = idEditFormTidakMasukKerja.value;
      body['created_by'] = getEmid;
      body['menu_name'] = "Tidak Hadir";
      body['activity_name'] =
          "Edit form pengajuan Tidak Hadir. Tanggal pengajuan = ${dariTanggal.value.text} sd ${sampaiTanggal.value.text} Alasan Pengajuan = ${alasan.value.text}";
      var connect = Api.connectionApi("post", body, "edit-emp_leave");
      connect.then((dynamic res) {
        if (res.statusCode == 200) {
          Navigator.pop(Get.context!);

          var pesan1 =
              "Pengajuan ${selectedDropdownFormTidakMasukKerjaTipe.value} berhasil di edit";
          var pesan2 =
              "Selanjutnya silahkan menunggu atasan kamu untuk menyetujui pengajuan yang telah dibuat atau langsung";
          var pesan3 = "konfirmasi via WhatsApp";
          var dataPengajuan = {
            'nameType': '${selectedDropdownFormTidakMasukKerjaTipe.value}',
            'nomor_ajuan': '${getNomorAjuanTerakhir}',
          };
          loadTypeSakit();
          Get.offAll(BerhasilPengajuan(
            dataBerhasil: [pesan1, pesan2, pesan3, dataPengajuan],
          ));
        }
      });
    }
  }

  void kirimNotifikasiToDelegasi(getFullName, convertTanggalBikinPengajuan,
      validasiDelegasiSelected, fcmTokenDelegasi, stringTanggal, typeNotifFcm) {
    var dt = DateTime.now();
    var jamSekarang = DateFormat('HH:mm:ss').format(dt);
    var description =
        'Anda mendapatkan delegasi pekerjaan dari $getFullName untuk pengajuan $selectedDropdownFormTidakMasukKerjaTipe, tanggal pengajuan $stringTanggal';
    Map<String, dynamic> body = {
      'em_id': validasiDelegasiSelected,
      'title': 'Delegasi Pengajuan Tidak Hadir',
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
        UtilsAlert.showToast("Berhasil kirim delegasi");
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
    var jamSekarang = DateFormat('HH:mm:ss').format(dt);
    // var description =
    //     'Anda mendapatkan delegasi pekerjaan dari $getFullName untuk pengajuan $selectedDropdownFormTidakMasukKerjaTipe, tanggal pengajuan $stringTanggal';
    Map<String, dynamic> body = {
      'em_id': validasiDelegasiSelected,
      'title': 'Approval Izin',
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
        UtilsAlert.showToast("Berhasil kirim delegasi");
      }
    });
  }

  void kirimNotifikasiToReportTo(
      getFullName, convertTanggalBikinPengajuan, getEmid, stringTanggal) {
    var dt = DateTime.now();
    var jamSekarang = DateFormat('HH:mm:ss').format(dt);
    Map<String, dynamic> body = {
      'emId_pengaju': getEmid,
      'title': 'Pengajuan Tidak Hadir',
      'deskripsi':
          'Anda mendapatkan pengajuan $selectedDropdownFormTidakMasukKerjaTipe dari $getFullName , tanggal pengajuan $stringTanggal',
      'url': '',
      'atten_date': convertTanggalBikinPengajuan,
      'jam': jamSekarang,
      'status': '2',
      'view': '0',
    };
    print(body);
    var connect = Api.connectionApi("post", body, "notifikasi_reportTo");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        UtilsAlert.showToast("Pengajuan berhasil di kirim");
      }
    });
  }

  String validasiSelectedType() {
    var result = [];
    var getDataType = selectedDropdownFormTidakMasukKerjaTipe.value.split('-');
    var kategoriTerpilih = getDataType[0].replaceAll(' ', '');
    for (var element in allTipe.value) {
      var namaType = element['name'].replaceAll(' ', '');
      if (namaType == kategoriTerpilih) {
        result.add(element);
      }
    }
    return "${result[0]['type_id']}";
  }

  int validasiTypeAjuan() {
    var result = [];
    var getDataType = selectedDropdownFormTidakMasukKerjaTipe.value.split('-');
    var kategoriTerpilih = getDataType[0].replaceAll(' ', '');
    for (var element in allTipe.value) {
      var namaType = element['name'].replaceAll(' ', '');
      if (namaType == kategoriTerpilih) {
        result.add(element);
      }
    }
    return result[0]['ajuan'];
  }

  String validasiSelectedDelegasi() {
    var result = [];
    for (var element in allEmployee.value) {
      var fullName = element['full_name'] ?? "";
      var namaElement = "$fullName";
      if (namaElement == selectedDropdownFormTidakMasukKerjaDelegasi.value) {
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
      if (namaElement == selectedDropdownFormTidakMasukKerjaDelegasi.value) {
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
    var getDari = Constanst.convertOnlyDate(dariTanggal.value.text);
    var getSampai = Constanst.convertOnlyDate(sampaiTanggal.value.text);
    var hitung = (int.parse(getSampai) - int.parse(getDari)) + 1;
    return "$hitung";
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
    UtilsAlert.loadingSimpanData(Get.context!, "Batalkan Pengajuan");
    var dataUser = AppData.informasiUser;
    var getEmid = dataUser![0].em_id;
    Map<String, dynamic> body = {
      'menu_name': 'Izin',
      'activity_name':
          'Membatalkan form pengajuan Izin. Tanggal pengajuan = ${index["start_date"]} sd ${index["end_date"]} Alasan Pengajuan = ${index["reason"]}',
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
        loadDataAjuanIzin();
        Navigator.pop(Get.context!);
        Navigator.pop(Get.context!);
        UtilsAlert.showToast("Berhasil batalkan pengajuan");
        onReady();
      }
    });
  }

  void pencarianNamaKaryawan(value) {
    var textCari = value.toLowerCase();
    var filter = allNameLaporanTidakhadirCopy.where((laporan) {
      var namaEmployee = laporan['full_name'].toLowerCase();
      return namaEmployee.contains(textCari);
    }).toList();
    allNameLaporanTidakhadir.value = filter;
    statusCari.value = true;
    this.allNameLaporanTidakhadir.refresh();
    this.statusCari.refresh();
  }

  void showDetailRiwayat(detailData, approve_by, alasanReject) {
    var nomorAjuan = detailData['nomor_ajuan'];
    var tanggalMasukAjuan = detailData['atten_date'];
    var namaTypeAjuan = detailData['name'];
    var categoryAjuan = detailData['category'];
    var tanggalAjuanDari = detailData['start_date'];
    var tanggalAjuanSampai = detailData['end_date'];
    var inputTime = detailData['input_time'];
    var alasan = detailData['reason'];
    var durasi = detailData['leave_duration'];
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
    var jamAjuan =
        detailData['time_plan'] == null || detailData['time_plan'] == ""
            ? "00:00:00"
            : detailData['time_plan'];
    var sampaiJamAjuan =
        detailData['time_plan_to'] == null || detailData['time_plan_to'] == ""
            ? "00:00:00"
            : detailData['time_plan_to'];
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
                          "$categoryAjuan - $namaTypeAjuan",
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
                          "Tanggal Izin",
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
                                "${Constanst.convertDate(tanggalAjuanDari)} - ${Constanst.convertDate(tanggalAjuanSampai)}",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Constanst.fgPrimary,
                                ),
                              )
                            : Container(),
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
                            ? Container()
                            : Container(
                                child: Wrap(
                                  children: List.generate(
                                      listTanggalTerpilih.length, (index) {
                                    var nomor = index + 1;
                                    var tanggalConvert = Constanst.convertDate7(
                                        listTanggalTerpilih[index]);
                                    var tanggalConvert2 =
                                        Constanst.convertDate5(
                                            listTanggalTerpilih[index]);
                                    return StreamBuilder<Object>(
                                        stream: null,
                                        builder: (context, snapshot) {
                                          return Text(
                                            index ==
                                                    listTanggalTerpilih.length -
                                                        1
                                                ? tanggalConvert2
                                                : '$tanggalConvert, ',
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: Constanst.fgPrimary,
                                            ),
                                          );
                                        });
                                  }),
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
                          "Durasi Izin",
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

                        // Divider(
                        //   height: 0,
                        //   thickness: 1,
                        //   color: Constanst.border,
                        // ),
                        // const SizedBox(height: 12),
                        // Container(
                        //   child: Row(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     mainAxisAlignment: MainAxisAlignment.start,
                        //     children: [
                        //       Expanded(
                        //         flex: 50,
                        //         child: Container(
                        //           child: Column(
                        //             crossAxisAlignment: CrossAxisAlignment.start,
                        //     mainAxisAlignment: MainAxisAlignment.start,
                        //             children: [
                        //               Text(
                        //                 "Dari Jam",
                        //                 style: GoogleFonts.inter(
                        //                   fontWeight: FontWeight.w400,
                        //                   fontSize: 14,
                        //                   color: Constanst.fgSecondary,
                        //                 ),
                        //               ),
                        //               const SizedBox(height: 4),
                        //               Text(
                        //                 "$durasi Hari",
                        //                 style: GoogleFonts.inter(
                        //                   fontWeight: FontWeight.w500,
                        //                   fontSize: 16,
                        //                   color: Constanst.fgPrimary,
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //               Expanded(
                        //         flex: 50,
                        //         child: Container(
                        //           child: Column(
                        //             crossAxisAlignment: CrossAxisAlignment.start,
                        //     mainAxisAlignment: MainAxisAlignment.start,
                        //             children: [
                        //               Text(
                        //                 "Sampai Jam",
                        //                 style: GoogleFonts.inter(
                        //                   fontWeight: FontWeight.w400,
                        //                   fontSize: 14,
                        //                   color: Constanst.fgSecondary,
                        //                 ),
                        //               ),
                        //               const SizedBox(height: 4),
                        //               Text(
                        //                 "$durasi Hari",
                        //                 style: GoogleFonts.inter(
                        //                   fontWeight: FontWeight.w500,
                        //                   fontSize: 16,
                        //                   color: Constanst.fgPrimary,
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       )
                        //     ],
                        //   ),
                        // ),
                        inputTime.toString() == "0"
                            ? SizedBox()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 12),
                                  Divider(
                                    height: 0,
                                    thickness: 1,
                                    color: Constanst.border,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    "Jam",
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Constanst.fgSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  inputTime.toString() == "2"
                                      ? Text(
                                          "$jamAjuan sd $sampaiJamAjuan",
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: Constanst.fgPrimary,
                                          ),
                                        )
                                      : Text(
                                          " $sampaiJamAjuan",
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: Constanst.fgPrimary,
                                          ),
                                        ),
                                  const SizedBox(height: 12),
                                ],
                              ),

                        // Divider(
                        //   height: 0,
                        //   thickness: 1,
                        //   color: Constanst.border,
                        // ),

                        // const SizedBox(height: 12),

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
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
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
                                    print(detailData.toString());
                                    Get.to(FormPengajuanIzin(
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
