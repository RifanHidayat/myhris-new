import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:siscom_operasional/controller/global_controller.dart';
import 'package:siscom_operasional/screen/absen/form/berhasil_pengajuan.dart';
import 'package:siscom_operasional/screen/absen/form/form_lembur.dart';
import 'package:siscom_operasional/screen/klaim/form_klaim.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/custom_dialog.dart';
import 'package:siscom_operasional/utils/helper.dart';
import 'package:siscom_operasional/utils/widget_textButton.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class KlaimController extends GetxController {
  var nomorAjuan = TextEditingController().obs;
  var tanggalKlaim = TextEditingController().obs;
  var durasi = TextEditingController().obs;
  var catatan = TextEditingController().obs;
  var cari = TextEditingController().obs;
  var totalKlaim = TextEditingController().obs;

  Rx<List<String>> allTypeKlaim = Rx<List<String>>([]);
  Rx<List<String>> allEmployeeDelegasi = Rx<List<String>>([]);

  var statusFormPencarian = false.obs;

  var filePengajuan = File("").obs;

  var tempNamaStatus1 = "Semua Status".obs;

  var bulanSelectedSearchHistory = "".obs;
  var tahunSelectedSearchHistory = "".obs;
  var bulanDanTahunNow = "".obs;
  var selectedDropdownDelegasi = "".obs;
  var selectedDropdownType = "".obs;
  var idpengajuanKlaim = "".obs;
  var emIdDelegasi = "".obs;
  var valuePolaPersetujuan = "".obs;
  var tanggalTerpilih = "".obs;
  var tanggalShow = "".obs;
  var namaFileUpload = "".obs;
  var loadingString = "Memuat Data...".obs;

  var statusForm = false.obs;
  var directStatus = false.obs;
  var showButtonlaporan = false.obs;
  var statusCari = false.obs;
  var uploadFile = false.obs;

  var listKlaim = [].obs;
  var listKlaimAll = [].obs;
  var allEmployee = [].obs;
  var allType = [].obs;
  var dataTypeAjuan = [].obs;
  var departementAkses = [].obs;
  var limitTransaksi = 0.obs;
  var saldo = 0.obs;

  Rx<DateTime> initialDate = DateTime.now().obs;

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
    super.onReady();
    getTimeNow();
    getLoadsysData();
    getTypeKlaim();
    loadDataKlaim();
    loadAllEmployeeDelegasi();
    getDepartemen(1, "");
  }

  void removeAll() {
    tanggalKlaim.value.text = "";
    catatan.value.text = "";
  }

  void showInputCari() {
    statusFormPencarian.value = !statusFormPencarian.value;
  }

  void getDepartemen(status, tanggal) {
    var connect = Api.connectionApi("get", {}, "all_department");
    connect.then((dynamic res) {
      if (res == false) {
        ////UtilsAlert.koneksiBuruk();
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

    if (idpengajuanKlaim.value == "") {
      tanggalKlaim.value.text = "${DateFormat('yyyy-MM-dd').format(dt)}";
      tanggalShow.value = "${DateFormat('dd MMMM yyyy').format(dt)}";
      tanggalTerpilih.value = "${DateFormat('yyyy-MM-dd').format(dt)}";
    }

    this.tanggalKlaim.refresh();
    this.bulanSelectedSearchHistory.refresh();
    this.tahunSelectedSearchHistory.refresh();
    this.bulanDanTahunNow.refresh();
  }

  void getTypeKlaim() {
    allType.value.clear();
    allTypeKlaim.value.clear();
    var connect = Api.connectionApi("get", "", "cost");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        var data = valueBody['data'];
        print("data klaim ${valueBody}");
        for (var element in data) {
          allTypeKlaim.value.add("${element['name']}");
          var data = {
            'type_id': element['id'],
            'name': element['name'],
            'max_biaya': element['max_biaya'],
            'active': false,
          };
          allType.value.add(data);
        }
        if (idpengajuanKlaim == "") {
          var listFirst = allTypeKlaim.value.first;
          var t = allType
              .where((p0) => p0['name'].toString() == listFirst.toString())
              .toList();
              
          selectedDropdownType.value = listFirst;

          getSaldo(id: t.first['type_id']);
        }
      }
    });
  }

  void getSaldo({id}) {
    print("saldo new ");

    var body = {
      "em_id": AppData.informasiUser==null || AppData.informasiUser!.isNotEmpty?"":AppData.informasiUser![0].em_id,
      "cost_id": id,
      "pola": globalCt.valuePolaPersetujuan.value.toString(),
      'date': DateFormat('yyyy-MM-dd').format(DateTime.now())
    };
    print("body ${body}");
    var connect = Api.connectionApi("post", body, "emp-claim-saldo");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        print("value body ${valueBody}");

        saldo.value = int.parse(valueBody['saldo'].toString());

        limitTransaksi.value = int.parse(valueBody['saldo'].toString()) -
            int.parse(valueBody['total_klaim'].toString());
      }
    });
  }

  void checkTypeEdit(id) {
    for (var element in allType.value) {
      if ("${element['type_id']}" == "$id") {
        selectedDropdownType.value = element['name'];
      }
    }
    this.selectedDropdownType.refresh();
  }

  String convertToIdr(dynamic number, int decimalDigit) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: decimalDigit,
    );
    return currencyFormatter.format(number);
  }

  void loadDataKlaim() {
    listKlaimAll.value.clear();
    listKlaim.value.clear();
    var dataUser = AppData.informasiUser;
    var getEmid = dataUser![0].em_id;
    Map<String, dynamic> body = {
      'em_id': getEmid,
      'bulan': bulanSelectedSearchHistory.value,
      'tahun': tahunSelectedSearchHistory.value,
    };
    var connect = Api.connectionApi("post", body, "history-emp_claim");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        if (valueBody['status'] == false) {
          loadingString.value = "Tidak ada pengajuan";
          this.loadingString.refresh();
        } else {
          listKlaim.value = valueBody['data'];
          listKlaimAll.value = valueBody['data'];
          if (listKlaim.value.length == 0) {
            loadingString.value = "Tidak ada pengajuan";
          } else {
            loadingString.value = "Memuat Data...";
          }
          this.listKlaim.refresh();
          this.listKlaimAll.refresh();
          this.loadingString.refresh();
        }
      }
    });
  }

  void loadAllEmployeeDelegasi() {
    allEmployeeDelegasi.value.clear();
    allEmployee.value.clear();
    var dataUser = AppData.informasiUser;
    var getDepGroup = dataUser![0].dep_group;
    var full_name = dataUser[0].full_name;
    Map<String, dynamic> body = {'val': 'dep_group_id', 'cari': getDepGroup};
    var connect = Api.connectionApi("post", body, "whereOnce-employee");
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
          if (idpengajuanKlaim.value == "") {
            var listFirst = valueBody['data'].first;
            var fullName = listFirst['full_name'] ?? "";
            String namaUserPertama = "$fullName";
            selectedDropdownDelegasi.value = namaUserPertama;
          } else {
            for (var element in allEmployee) {
              if (element['em_id'] == emIdDelegasi.value) {
                selectedDropdownDelegasi.value = element['full_name'];
              }
            }
          }
          this.allEmployee.refresh();
          this.allEmployeeDelegasi.refresh();
          this.selectedDropdownDelegasi.refresh();
        }
      }
    });
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
        this.namaFileUpload.refresh();
        this.filePengajuan.refresh();
        this.uploadFile.refresh();
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
    if (tanggalKlaim.value.text == "" ||
        catatan.value.text == "" ||
        tanggalTerpilih.value == "") {
      UtilsAlert.showToast("Lengkapi form *");
    }
    // else if (totalKlaim.value.text == "Rp" ||
    //     totalKlaim.value.text == "Rp 0") {
    //   UtilsAlert.showToast("Nominal klaim tidak bisa 0");
    // }
    else {
      if (uploadFile.value == true) {
        // UtilsAlert.loadingSimpanData(Get.context!, "Sedang Menyimpan File");
        // var connectUpload = await Api.connectionApiUploadFile(
        //     "upload_form_klaim", filePengajuan.value);
        // var valueBody = jsonDecode(connectUpload);
        // if (valueBody['status'] == true) {
        //   UtilsAlert.showToast("Berhasil upload file");
        //   Navigator.pop(Get.context!);
        //   if (statusForm.value == false) {
        //     UtilsAlert.loadingSimpanData(Get.context!, "Sedang Menyimpan");
        //     checkNomorAjuan(statusForm.value);
        //   } else {
        //     UtilsAlert.loadingSimpanData(Get.context!, "Sedang Menyimpan");
        //     kirimPengajuan(nomorAjuan.value.text);
        //   }
        // } else {
        //   UtilsAlert.showToast("Gagal kirim file");
        // }
      } else {
        if (statusForm.value == false) {
          UtilsAlert.loadingSimpanData(Get.context!, "Sedang Menyimpan");
          checkNomorAjuan(statusForm.value);
        } else {
          UtilsAlert.loadingSimpanData(Get.context!, "Sedang Menyimpan");
          kirimPengajuan(nomorAjuan.value.text);
        }
      }
    }
  }

  void checkNomorAjuan(value) {
    var finalTanggalPengajuan = tanggalKlaim.value.text;
    Map<String, dynamic> body = {
      'atten_date': finalTanggalPengajuan,
      'pola': 'KL'
    };
    var connect = Api.connectionApi("post", body, "emp_klaim_lastrow");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        if (valueBody['status'] == true) {
          var data = valueBody['data'];
          if (valueBody['data'].length == 0) {
            var now = DateTime.now();
            var convertBulan = now.month <= 9 ? "0${now.month}" : now.month;
            var finalNomor = "KL${now.year}${convertBulan}0001";
            kirimPengajuan(finalNomor);
          } else {
            var getNomorAjuanTerakhir = valueBody['data'][0]['nomor_ajuan'];
            var keyNomor = getNomorAjuanTerakhir.replaceAll("KL", '');
            var hasilTambah = int.parse(keyNomor) + 1;
            var finalNomor = "KL$hasilTambah";
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
    var keyNomor = getNomorAjuanTerakhir.replaceAll("KL", '');
    var hasilTambah = int.parse(keyNomor) + 1;
    var finalNomor = "KL$hasilTambah";
    kirimPengajuan(finalNomor);
  }

  void kirimPengajuan(getNomorAjuanTerakhir) {
    // data employee
    var dataUser = AppData.informasiUser;
    var getEmid = dataUser![0].em_id;
    var getFullName = dataUser[0].full_name;
    // cari type klaim
    var idSelectedType = cariTypeSelected();
    // filter total klaim
    var cv1 = totalKlaim.value.text.replaceAll('Rp', '');
    var cv2 = cv1.replaceAll('.', '');
    int cv3 = int.parse(cv2);
    // variabel upload file
    var nameFile;
    if (idpengajuanKlaim == "") {
      nameFile = uploadFile.value == true ? namaFileUpload.value : "";
    } else {
      nameFile = namaFileUpload.value;
    }
    print("data ${globalCt.konfirmasiAtasan}");

    var convertTanggalBikinPengajuan =
        Constanst.convertDateSimpan(tanggalTerpilih.value);
    Map<String, dynamic> body = {
      'em_id': getEmid,
      'nomor_ajuan': getNomorAjuanTerakhir,
      'tgl_ajuan': tanggalTerpilih.value,
      'cost_id': idSelectedType,
      'description': catatan.value.text,
      'total_claim': '$cv3',
      'status': 'PENDING',
      'nama_file': nameFile,
      'created_on': "${DateTime.now()}",
      'atten_date': tanggalKlaim.value.text,
      'created_by': getEmid,
      'menu_name': 'Klaim',
      'saldo_claim': limitTransaksi.value.toString(),
      'sisa_claim': (limitTransaksi.value - cv3).toString(),
      'approve_status': "Pending"
    };
    var typeNotifFcm = "Pengajuan Klaim";
    if (statusForm.value == false) {
      body['activity_name'] =
          "Membuat Pengajuan Klaim. alasan = ${catatan.value.text}";
      var connect = Api.connectionApi("post", body, "klaim");
      connect.then((dynamic res) {
        if (res.statusCode == 200) {
          var valueBody = jsonDecode(res.body);
          if (valueBody['status'] == true) {
            // kirimNotifikasiToReportTo(
            //     getFullName, tanggalKlaim.value.text, getEmid, "Klaim");
            Navigator.pop(Get.context!);
            var pesan1 = "Pengajuan klaim berhasil dibuat";
            var pesan2 =
                "Selanjutnya silahkan menunggu atasan kamu untuk menyetujui pengajuan yang telah dibuat atau langsung";
            var pesan3 = "konfirmasi via WhatsApp";
            var dataPengajuan = {
              'nameType': 'KLAIM',
              'nomor_ajuan': '${getNomorAjuanTerakhir}',
            };
            for (var item in globalCt.konfirmasiAtasan) {
              print(item['token_notif']);
              var pesan;
              if (item['em_gender'] == "PRIA") {
                pesan =
                    "Hallo pak ${item['full_name']}, saya ${getFullName} mengajukan Klaim dengan nomor ajuan ${getNomorAjuanTerakhir}";
              } else {
                pesan =
                    "Hallo bu ${item['full_name']}, saya ${getFullName} mengajukan Klaim dengan nomor ajuan ${getNomorAjuanTerakhir}";
              }
              kirimNotifikasiToDelegasi1(
                  getFullName,
                  convertTanggalBikinPengajuan,
                  item['em_id'],
                  "",
                  "",
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
            if (valueBody['message'] == "ulang") {
              var nomorAjuanTerakhirDalamAntrian =
                  valueBody['data'][0]['nomor_ajuan'];
              checkNomorAjuanDalamAntrian(nomorAjuanTerakhirDalamAntrian);
            } else {
              Navigator.pop(Get.context!);
              UtilsAlert.showToast(
                  "Data periode ${tanggalKlaim.value.text} belum tersedia, harap hubungi HRD");
            }
          }
        }
      });
    } else {
      body['val'] = "id";
      body['cari'] = idpengajuanKlaim.value;
      body['activity_name'] =
          "Edit Pengajuan Klaim. Tanggal Pengajuan = ${tanggalKlaim.value.text}";
      var connect = Api.connectionApi("post", body, "edit-emp_claim");
      connect.then((dynamic res) {
        if (res.statusCode == 200) {
          Navigator.pop(Get.context!);
          var pesan1 = "Pengajuan klaim berhasil di edit";
          var pesan2 =
              "Selanjutnya silahkan menunggu atasan kamu untuk menyetujui pengajuan yang telah dibuat atau langsung";
          var pesan3 = "konfirmasi via WhatsApp";
          var dataPengajuan = {
            'nameType': 'KLAIM',
            'nomor_ajuan': '${getNomorAjuanTerakhir}',
          };
          Get.offAll(BerhasilPengajuan(
            dataBerhasil: [pesan1, pesan2, pesan3, dataPengajuan],
          ));
        }
      });
    }
  }

  void kirimNotifikasiToDelegasi1(
      getFullName,
      convertTanggalBikinPengajuan,
      validasiDelegasiSelected,
      fcmTokenDelegasi,
      stringTanggal,
      typeNotifFcm,
      pesan) {
    print("kirim notifikasin approval");
    var dt = DateTime.now();
    var jamSekarang = DateFormat('HH:mm:ss').format(dt);
    // var description =
    //     'Anda mendapatkan delegasi pekerjaan dari $getFullName untuk pengajuan $selectedDropdownFormTidakMasukKerjaTipe, tanggal pengajuan $stringTanggal';
    Map<String, dynamic> body = {
      'em_id': validasiDelegasiSelected,
      'title': 'Approval Klaim',
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
        print(" berhasil mengajukan klaim notifikasi");
        // globalCt.kirimNotifikasiFcm(
        //     title: typeNotifFcm,
        //     message: description,
        //     tokens: fcmTokenDelegasi);
        // UtilsAlert.showToast("Berhasil kirim delegasi");
      }
    });
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
    listKlaimAll.value.forEach((element) {
      if (name == "Semua Status") {
        dataFilter.add(element);
      } else {
        if (element['status'] == filter) {
          dataFilter.add(element);
        }
      }
    });
    listKlaim.value = dataFilter;
    this.listKlaim.refresh();
    if (dataFilter.isEmpty) {
      loadingString.value = "Tidak ada Pengajuan";
    } else {
      loadingString.value = "Memuat Data...";
    }
  }

  void cariData(value) {
    var textCari = value.toLowerCase();
    var filter = listKlaimAll.where((ajuan) {
      var getAjuan = ajuan['nomor_ajuan'].toLowerCase();
      return getAjuan.contains(textCari);
    }).toList();
    listKlaim.value = filter;
    statusCari.value = true;
    this.listKlaim.refresh();
    this.statusCari.refresh();

    if (listKlaim.value.isEmpty) {
      loadingString.value = "Tidak ada pengajuan";
    } else {
      loadingString.value = "Memuat Data...";
    }
    this.loadingString.refresh();
  }

  void kirimNotifikasiToReportTo(
      getFullName, convertTanggalBikinPengajuan, getEmid, type) {
    var dt = DateTime.now();
    var jamSekarang = DateFormat('HH:mm:ss').format(dt);
    Map<String, dynamic> body = {
      'emId_pengaju': getEmid,
      'title': 'Pengajuan Klaim',
      'deskripsi':
          'Anda mendapatkan pengajuan $type dari $getFullName, waktu pengajuan $convertTanggalBikinPengajuan',
      'url': '',
      'atten_date': convertTanggalBikinPengajuan,
      'jam': jamSekarang,
      'status': '2',
      'view': '0',
    };
    var connect = Api.connectionApi("post", body, "notifikasi_reportTo");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        UtilsAlert.showToast("re berhasil di kirim");
      }
    });
  }

  String cariTypeSelected() {
    var result = [];
    for (var element in allType.value) {
      var nameType = element['name'] ?? "";
      if (nameType == selectedDropdownType.value) {
        result.add(element);
      }
    }
    return "${result[0]['type_id']}";
  }

  void showModalBatalPengajuan(index) {
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
    DateTime ftr1 = DateTime.parse(index["created_on"]);
    var filterTanggal = "${DateFormat('yyyy-MM-dd').format(ftr1)}";
    Map<String, dynamic> body = {
      'menu_name': 'Klaim',
      'activity_name':
          'Membatalkan form pengajuan Klaim. Alasan Pengajuan = ${index["reason"]} Tanggal Pengajuan = $filterTanggal',
      'created_by': '$getEmid',
      'val': 'id',
      'cari': '${index["id"]}',
      'status_transaksi': 0,
      'atten_date': filterTanggal,
    };
    print("data body ${body}");
    var connect = Api.connectionApi("post", body, "edit-emp_claim");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        Navigator.pop(Get.context!);
        Navigator.pop(Get.context!);
        Navigator.pop(Get.context!);
        UtilsAlert.showToast("Berhasil batalkan pengajuan");
        loadDataKlaim();
      }
    });
  }

  void showDetailRiwayat(detailData, apply_by, alasanReject) {
    var nomorAjuan = detailData['nomor_ajuan'];
    // var tanggalMasukAjuan = detailData['atten_date'];
    var namaTypeAjuan = detailData['name'];
    var tanggalPengajuan = detailData['created_on'];
    DateTime fltr1 = DateTime.parse("${detailData['tgl_ajuan']}");
    var tanggalAjuan = DateFormat('dd MMMM yyyy').format(fltr1);
    var totalKlaim = detailData['total_claim'];
    var rupiah = convertToIdr(totalKlaim, 0);
    var alasan = detailData['reason'];
    var durasi = detailData['leave_duration'];
    var uraian = detailData['description'];

    var typeAjuan = detailData['leave_status'];
    var sisaKlaim = detailData['sisa_claim'];
    var saldo = detailData['saldo_claim'];

    if (valuePolaPersetujuan.value == "1") {
      typeAjuan = detailData['status'];
    } else {
      typeAjuan = detailData['status'] == "Approve"
          ? "Approve 1"
          : detailData['status'] == "Approve2"
              ? "Approve 2"
              : detailData['status'];
    }

    var nama_file = detailData['nama_file'];
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
                                Constanst.convertDate6("$tanggalPengajuan"),
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
                          "Tanggal Klaim",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Constanst.fgSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tanggalAjuan,
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
                          "Sisa Saldo",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Constanst.fgSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          toCurrency(saldo.toString()),
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
                          "Total Klaim",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Constanst.fgSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          rupiah,
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
                          "Sisa Klaim",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Constanst.fgSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          toCurrency(sisaKlaim.toString()),
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
                          "$uraian",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Constanst.fgPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        nama_file == "" ||
                                nama_file == "NULL" ||
                                nama_file == null
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
                                        viewLampiranAjuan(nama_file);
                                      },
                                      child: Text(
                                        "$nama_file",
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
                                  print(detailData.toString());
                                  Get.to(FormKlaim(
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
    var urlViewGambar = Api.UrlfileKlaim + value;

    final url = Uri.parse(urlViewGambar);
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      UtilsAlert.showToast('Tidak dapat membuka file');
    }
  }
}
