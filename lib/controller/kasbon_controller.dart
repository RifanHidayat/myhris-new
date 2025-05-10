import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/global_controller.dart';
import 'package:siscom_operasional/screen/absen/form/berhasil_pengajuan.dart';
import 'package:siscom_operasional/screen/kasbon/form_kasbon.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/custom_dialog.dart';
import 'package:siscom_operasional/utils/widget_textButton.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class KasbonController extends GetxController {
  var nomorAjuan = TextEditingController().obs;
  var tanggalKasbon = TextEditingController().obs;
  var dariJam = TextEditingController().obs;
  var sampaiJam = TextEditingController().obs;
  var durasi = TextEditingController().obs;
  var catatan = TextEditingController().obs;
  var cari = TextEditingController().obs;
  var totalPinjaman = TextEditingController().obs;
  var durasiCicilan = TextEditingController().obs;
  // var id = "".obs;

  Rx<List<String>> typeKasbon = Rx<List<String>>([]);
  Rx<List<String>> allEmployeeDelegasi = Rx<List<String>>([]);

  var statusFormPencarian = false.obs;

  var tempNamaStatus1 = "Semua Status".obs;

  var bulanSelectedSearchHistory = "".obs;
  var tahunSelectedSearchHistory = "".obs;
  var bulanDanTahunNow = "".obs;
  var selectedDropdownDelegasi = "".obs;
  var selectedDropdownDelegasiTemp = "".obs;
  var idpengajuanKasbon = "".obs;
  var emIdDelegasi = "".obs;
  var valuePolaPersetujuan = "".obs;
  var selectedTypeKasbon = "".obs;
  var loadingString = "Memuat Data...".obs;

  var statusForm = false.obs;
  var directStatus = false.obs;
  var showButtonlaporan = false.obs;
  var statusCari = false.obs;
  var viewTypeKasbon = false.obs;

  var listKasbon = [].obs;
  var listKasbonAll = [].obs;
  var listDetailKasbon = [].obs;
  var allTypeKasbon = [].obs;
  var allEmployee = [].obs;
  var dataTypeAjuan = [].obs;
  var departementAkses = [].obs;

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
    print("on ready");
    super.onReady();
    // getTimeNow();
    // getLoadsysData();
    // // loadDataKasbon();
    // loadAllEmployeeDelegasi();
    // getTypeKasbon();
    // getDepartemen(1, "");
  }

  void showInputCari() {
    statusFormPencarian.value = !statusFormPencarian.value;
  }

  void removeAll() {
    tanggalKasbon.value.text = "";
    dariJam.value.text = "";
    sampaiJam.value.text = "";
    catatan.value.text = "";
    totalPinjaman.value.text = "";
    durasiCicilan.value.text = "";
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

  void getTypeKasbon() {
    print("get data atype kasbon");
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
        print("overtime data ${overtimeData}");
        loadDataTypeOvertime(overtimeData);
      }
    });
  }

  void loadDataTypeOvertime(overtimeData) {
    typeKasbon.value.clear();
    var connect = Api.connectionApi("get", "", "overtime");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        print(valueBody);

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
        if (tampung.isEmpty) {
          viewTypeKasbon.value = false;
          this.viewTypeKasbon.refresh();
        } else {
          viewTypeKasbon.value = true;
          for (var element in tampung) {
            typeKasbon.value.add(element['name']);
            var data = {
              'id': element['id'],
              'name': element['name'],
            };
            allTypeKasbon.value.add(data);
          }
          var getFirst = tampung.first;
          selectedTypeKasbon.value = getFirst['name'];
          this.viewTypeKasbon.refresh();
          this.typeKasbon.refresh();
          this.allTypeKasbon.refresh();
          this.selectedTypeKasbon.refresh();
        }
      }
    });
  }

  void getTimeNow() {
    var dt = DateTime.now();
    bulanSelectedSearchHistory.value = "${dt.month}";
    tahunSelectedSearchHistory.value = "${dt.year}";
    bulanDanTahunNow.value = "${dt.month}-${dt.year}";

    if (idpengajuanKasbon.value == "") {
      tanggalKasbon.value.text = Constanst.convertDate("${initialDate.value}");
    }

    this.tanggalKasbon.refresh();
    this.bulanSelectedSearchHistory.refresh();
    this.tahunSelectedSearchHistory.refresh();
    this.bulanDanTahunNow.refresh();
  }

  void loadDataKasbon() {
    listKasbonAll.value.clear();
    listKasbon.value.clear();
    var dataUser = AppData.informasiUser;
    var getEmid = dataUser![0].em_id;
    Map<String, dynamic> body = {
      'em_id': getEmid,
      // 'bulan': bulanSelectedSearchHistory.value,
      // 'tahun': tahunSelectedSearchHistory.value,
    };
    print("body loadDataKasbon ${body}");
    var connect = Api.connectionApi("post", body, "employee-loan-history");
    connect.then((dynamic res) {
      print("body loadDataKasbon ${res.statusCode}");
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        print("body loadDataKasbon ${valueBody}");
        // if (valueBody['status'] == false) {
        //   loadingString.value = "Anda tidak memiliki\nRiwayat Pengajuan Kasbon";
        //   this.loadingString.refresh();
        // } else {
        for (var element in valueBody['data']) {
          // if (element['ajuan'] == 1) {
          listKasbon.value.add(element);
          listKasbonAll.value.add(element);
          // }
        }
        if (listKasbon.value.length == 0) {
          loadingString.value = "Anda tidak memiliki\nRiwayat Pengajuan Kasbon";
        } else {
          loadingString.value = "Memuat Data...";
        }

        this.listKasbon.refresh();
        this.listKasbonAll.refresh();
        this.loadingString.refresh();
      }
      // }
    });
  }

  void loadDataDetailKasbon(id) {
    listDetailKasbon.value.clear();

    Map<String, dynamic> body = {
      'id': id,
    };
    print("body loadDataKasbon ${body}");
    var connect = Api.connectionApi("post", body, "employee-loan-detail");
    connect.then((dynamic res) {
      print("body loadDataKasbon ${res.statusCode}");
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        print("body loadDataKasbon ${valueBody}");
        // if (valueBody['status'] == false) {
        //   loadingString.value = "Anda tidak memiliki\nRiwayat Pengajuan Kasbon";
        //   this.loadingString.refresh();
        // } else {
        for (var element in valueBody['data']) {
          // if (element['ajuan'] == 1) {
          listDetailKasbon.value.add(element);

          // }
        }
        if (listDetailKasbon.value.length == 0) {
          loadingString.value = "Anda tidak memiliki\nRiwayat Pengajuan Kasbon";
        } else {
          loadingString.value = "Memuat Data...";
        }

        this.listDetailKasbon.refresh();
        this.loadingString.refresh();
      }
      // }
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
  //         if (idpengajuanKasbon.value == "") {
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
        //UtilsAlert.koneksiBuruk();
      } else {
        if (res.statusCode == 200) {
          var valueBody = jsonDecode(res.body);
          var data = valueBody['data'];
          print("data delegasi ${data}");
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
          if (idpengajuanKasbon.value == "") {
            List data = valueBody['data'];
            var listFirst = data
                .where((element) => element['full_name'] != full_name)
                .toList()
                .first;
            var fullName = listFirst['full_name'] ?? "";
            String namaUserPertama = "$fullName";
            selectedDropdownDelegasi.value = namaUserPertama;
          }

          this.allEmployee.refresh();
          this.allEmployeeDelegasi.refresh();
          this.selectedDropdownDelegasi.refresh();
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

  void validasiKirimPengajuan() {
    print("data ${tanggalKasbon.value.text}");
    print("data ${totalPinjaman.value.text}");
    print("data ${bulanDanTahunNow.value}");
    print("data ${catatan.value.text}");
    print("data ${durasiCicilan.value.text}");
    if (tanggalKasbon.value.text == "" ||
        // dariJam.value.text == "" ||
        // sampaiJam.value.text == "" ||
        selectedTypeKasbon.value == "" ||
        catatan.value.text == "" ||
        totalPinjaman.value.text == "" ||
        durasiCicilan.value.text == "") {
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
  }

  void checkNomorAjuan() {
    var listTanggal = tanggalKasbon.value.text.split(',');
    var getTanggal = listTanggal[1].replaceAll(' ', '');
    var tanggalKasbonEditData = Constanst.convertDateSimpan(getTanggal);
    var polaFormat = DateFormat('yyyy-MM-dd');
    var tanggalPengajuanInsert = polaFormat.format(initialDate.value);
    var finalTanggalPengajuan = statusForm.value == false
        ? tanggalPengajuanInsert
        : tanggalKasbonEditData;

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

  String convertDateString(String dateString) {
    // Define the input format
    DateFormat inputFormat = DateFormat(
        'EEEE, dd-MM-yyyy', 'id_ID'); // 'id_ID' locale for Indonesian

    // Parse the input date string
    DateTime parsedDate = inputFormat.parse(dateString);

    // Define the output format
    DateFormat outputFormat = DateFormat('yyyy-MM-dd');

    // Format the parsed date to the desired output format
    String formattedDate = outputFormat.format(parsedDate);

    return formattedDate;
  }

  int convertCurrencyString(String currency) {
    // Remove the currency symbol and any dots
    String cleanedString = currency.replaceAll(RegExp(r'[^\d]'), '');

    // Parse the cleaned string to an integer
    int value = int.parse(cleanedString);

    return value;
  }

  String formatDateToYYYYMMDD(DateTime date) {
    // Define the output format
    DateFormat outputFormat = DateFormat('yyyy-MM-dd');

    // Format the current date to the desired output format
    String formattedDate = outputFormat.format(date);

    return formattedDate;
  }

  String convertToIdr(dynamic number, int decimalDigit) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: decimalDigit,
    );
    return currencyFormatter.format(number);
  }

  String formatDate(String dateString) {
    // Parse the original date string to a DateTime object
    DateTime dateTime = DateTime.parse(
        '$dateString-01'); // Add a day to create a valid DateTime object

    // Initialize the date formatting for the Indonesian locale
    initializeDateFormatting('id_ID', null);

    // Format the DateTime object to 'MMMM yyyy' in Indonesian
    String formattedDate = DateFormat('MMMM yyyy', 'id_ID').format(dateTime);

    return formattedDate;
  }

  void kirimPengajuan(getNomorAjuanTerakhir) {
    // check id type kasbon
    var finalIdKasbon = checkKasbon();
    var listTanggal = tanggalKasbon.value.text.split(',');
    var getTanggal = listTanggal[1].replaceAll(' ', '');
    var tanggalKasbonEditData = Constanst.convertDateSimpan(getTanggal);
    var dataUser = AppData.informasiUser;
    var getEmid = dataUser![0].em_id;
    var getFullName = dataUser[0].full_name;
    // var validasiDelegasiSelected = validasiSelectedDelegasi();
    // var validasiDelegasiSelectedToken = validasiSelectedDelegasiToken();
    var polaFormat = DateFormat('yyyy-MM-dd');
    var tanggalPengajuanInsert = polaFormat.format(initialDate.value);
    var finalTanggalPengajuan = statusForm.value == false
        ? tanggalPengajuanInsert
        : tanggalKasbonEditData;
    // var hasilDurasi = hitungDurasi();
    Map<String, dynamic> body = {
      'em_id': getEmid,
      'tanggal_pinjaman': convertDateString(tanggalKasbon.value.text),
      'total_pinjaman': convertCurrencyString(totalPinjaman.value.text),
      'durasi_cicil': convertCurrencyString(durasiCicilan.value.text),
      'ket': catatan.value.text,
      'periode':
          "${tahunSelectedSearchHistory.value}-${bulanSelectedSearchHistory.value}",
      'tanggal': formatDateToYYYYMMDD(DateTime.now()),
      'id': idpengajuanKasbon.value,

      // 'typeid': finalIdKasbon,
      // 'nomor_ajuan': getNomorAjuanTerakhir,
      // 'dari_jam': dariJam.value.text,
      // 'sampai_jam': sampaiJam.value.text,
      // 'durasi': hasilDurasi,
      // 'atten_date': finalTanggalPengajuan,
      // 'status': 'PENDING',
      // 'approve_date': '',
      // 'em_delegation': validasiDelegasiSelected,
      // 'ajuan': '1',
      // 'created_by': getEmid,
      // 'menu_name': 'Kasbon',
      // 'approve_status': "pending",
    };
    var typeNotifFcm = "Pengajuan Kasbon";
    print("body kirim kasbon ${body}");
    if (statusForm.value == false) {
      print("sampe sini input");
      body['activity_name'] =
          "Membuat Pengajuan Kasbon. alasan = ${catatan.value.text}";
      var connect = Api.connectionApi("post", body, "employee-loan-insert");

      connect.then((dynamic res) {
        print("sampe ${res.statusCode}");
        if (res.statusCode == 200) {
          var valueBody = jsonDecode(res.body);
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
            //     getEmid, "Kasbon", stringWaktu);
            Navigator.pop(Get.context!);
            var pesan1 = "Pengajuan kasbon berhasil dibuat";
            var pesan2 =
                "Selanjutnya silahkan menunggu atasan kamu untuk menyetujui pengajuan yang telah dibuat atau langsung";
            var pesan3 = "konfirmasi via WhatsApp";
            var dataPengajuan = {
              'nameType': 'KASBON',
              'nomor_ajuan': '${getNomorAjuanTerakhir}',
            };
            for (var item in globalCt.konfirmasiAtasan) {
              print(item['token_notif']);
              var pesan;
              if (item['em_gender'] == "PRIA") {
                pesan =
                    "Hallo pak ${item['full_name']}, saya ${getFullName} mengajukan KASBON dengan nomor ajuan ${getNomorAjuanTerakhir}";
              } else {
                pesan =
                    "Hallo bu ${item['full_name']}, saya ${getFullName} mengajukan KASBON dengan nomor ajuan ${getNomorAjuanTerakhir}";
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
        }
      });
    } else {
      body['val'] = "id";
      body['cari'] = idpengajuanKasbon.value;
      body['activity_name'] =
          "Edit Pengajuan Kasbon. Tanggal Pengajuan = $finalTanggalPengajuan";
      var connect = Api.connectionApi("post", body, "employee-loan-update");
      connect.then((dynamic res) {
        if (res.statusCode == 200) {
          Navigator.pop(Get.context!);
          var pesan1 = "Pengajuan kasbon berhasil di edit";
          var pesan2 =
              "Selanjutnya silahkan menunggu atasan kamu untuk menyetujui pengajuan yang telah dibuat atau langsung";
          var pesan3 = "konfirmasi via WhatsApp";
          var dataPengajuan = {
            'nameType': 'KASBON',
            'nomor_ajuan': '${getNomorAjuanTerakhir}',
          };
          Get.offAll(BerhasilPengajuan(
            dataBerhasil: [pesan1, pesan2, pesan3, dataPengajuan],
          ));
        }
      });
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
    listKasbonAll.value.forEach((element) {
      if (name == "Semua Status") {
        dataFilter.add(element);
      } else {
        if (element['status'] == filter) {
          dataFilter.add(element);
        }
      }
    });
    listKasbon.value = dataFilter;
    this.listKasbon.refresh();
    if (dataFilter.isEmpty) {
      loadingString.value = "Anda tidak memiliki\nRiwayat Pengajuan Kasbon";
    } else {
      loadingString.value = "Memuat Data...";
    }
  }

  String checkKasbon() {
    var result = "";
    for (var element in allTypeKasbon.value) {
      if (element['name'] == selectedTypeKasbon.value) {
        result = "${element['id']}";
      }
    }
    return result;
  }

  void cariData(value) {
    var textCari = value.toLowerCase();
    var filter = listKasbonAll.where((ajuan) {
      var getAjuan = ajuan['nomor_ajuan'].toLowerCase();
      return getAjuan.contains(textCari);
    }).toList();
    listKasbon.value = filter;
    statusCari.value = true;
    this.listKasbon.refresh();
    this.statusCari.refresh();

    if (listKasbon.value.isEmpty) {
      loadingString.value = "Anda tidak memiliki\nRiwayat Pengajuan Kasbon";
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
    //     'Anda mendapatkan delegasi pekerjaan dari $getFullName untuk Pengajuan Kasbon, waktu pengajuan $stringWaktu';

    var description =
        'Anda mendapatkan pengajuan kasbon dari $getFullName dengan pemberi tugas anda, waktu pengajuan $stringWaktu';
    Map<String, dynamic> body = {
      'em_id': validasiDelegasiSelected,
      'title': 'Pemberi Tugas Pengajuan Kasbon',
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
      stringWaktu,
      typeNotifFcm,
      pesan) {
    var dt = DateTime.now();
    var jamSekarang = DateFormat('HH:mm:ss').format(dt);
    // var description =
    //     'Anda mendapatkan delegasi pekerjaan dari $getFullName untuk Pengajuan Kasbon, waktu pengajuan $stringWaktu';

    var description =
        'Anda mendapatkan pengajuan kasbon dari $getFullName dengan pemberi tugas anda, waktu pengajuan $stringWaktu';
    Map<String, dynamic> body = {
      'em_id': validasiDelegasiSelected,
      'title': 'Approval Kasbon',
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
      getFullName, convertTanggalBikinPengajuan, getEmid, type, stringWaktu) {
    var dt = DateTime.now();
    var jamSekarang = DateFormat('HH:mm:ss').format(dt);
    Map<String, dynamic> body = {
      'emId_pengaju': getEmid,
      'title': 'Pengajuan Kasbon',
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

  // String validasiSelectedDelegasi() {
  //   var result = [];
  //   for (var element in allEmployee.value) {
  //     var fullName = element['full_name'] ?? "";
  //     var namaElement = "$fullName";
  //     if (namaElement == selectedDropdownDelegasi.value) {
  //       result.add(element);
  //     }
  //   }
  //   return "${result[0]['em_id']}";
  // }

  // String validasiSelectedDelegasiToken() {
  //   var result = [];
  //   for (var element in allEmployee.value) {
  //     var fullName = element['full_name'] ?? "";
  //     var namaElement = "$fullName";
  //     if (namaElement == selectedDropdownDelegasi.value) {
  //       result.add(element);
  //     }
  //   }
  //   return "${result[0]['token_notif']}";
  // }

  // String hitungDurasi() {
  //   var format = DateFormat("HH:mm");
  // var dari = format.parse("${dariJam.value.text}");
  // var sampai = format.parse("${sampaiJam.value.text}");
  //   var hasil1 = "${sampai.difference(dari)}";
  //   var hasilAkhir = hasil1.replaceAll(':00.000000', '');
  //   return "$hasilAkhir";
  // }

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
                                  "Batalkan Pengajuan Kasbon",
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

  void showDetailKasbon(detailData, approve, alasanReject) {
    var nomorAjuan = detailData['nomor'];
    var tanggalMasukAjuan = detailData['tanggal_ajuan'];
    var tanggalPinjaman = detailData['tanggal_pinjaman'];
    var namaTypeAjuan = detailData['type'];
    var keterangan = detailData['description'];
    var durasi_cicil = detailData['durasi_cicil'];
    var total_loan = detailData['total_loan'];
    var id = detailData['id'];
    loadDataDetailKasbon(id);

    // String yang ingin dipisahkan
    var periode = detailData['periode'];
    // Memisahkan string berdasarkan karakter "-"
    // List<String> parts = date.split('-');
    // String year = parts[0];
    // String month = parts[1];

    // tahunSelectedSearchHistory.value = year;
    // bulanSelectedSearchHistory.value = month;

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
    // var dariJam = detailData['dari_jam'];
    // var sampaiJam = detailData['sampai_jam'];
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
        return DefaultTabController(
          length: 2,
          child: SafeArea(
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
                  TabBar(
                    indicatorColor: Constanst.onPrimary,
                    indicatorWeight: 4.0,
                    labelPadding: const EdgeInsets.fromLTRB(0, 14, 0, 14),
                    indicatorSize: TabBarIndicatorSize.label,
                    physics: const BouncingScrollPhysics(),
                    labelColor: Constanst.onPrimary,
                    unselectedLabelColor: Constanst.fgSecondary,
                    tabs: [
                      Text(
                        "Detail",
                        style: GoogleFonts.inter(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "Cicilan Pinjaman",
                        style: GoogleFonts.inter(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 1,
                    height: 1,
                    color: Constanst.fgBorder,
                  ),
                  SizedBox(height: 12),
                  Container(
                    height: 540,
                    child: TabBarView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: Constanst.colorNonAktif)),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                            tanggalMasukAjuan == null
                                                ? ''
                                                : Constanst.convertDate6(
                                                    "$tanggalMasukAjuan"),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                  border: Border.all(
                                      color: Constanst.colorNonAktif)),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Text(
                                    //   "Nama Pengajuan",
                                    //   style: GoogleFonts.inter(
                                    //     fontWeight: FontWeight.w400,
                                    //     fontSize: 14,
                                    //     color: Constanst.fgSecondary,
                                    //   ),
                                    // ),
                                    // const SizedBox(height: 4),
                                    // Text(
                                    //   "$namaTypeAjuan",
                                    //   style: GoogleFonts.inter(
                                    //     fontWeight: FontWeight.w500,
                                    //     fontSize: 16,
                                    //     color: Constanst.fgPrimary,
                                    //   ),
                                    // ),
                                    // const SizedBox(height: 12),
                                    // Divider(
                                    //   height: 0,
                                    //   thickness: 1,
                                    //   color: Constanst.border,
                                    // ),
                                    // const SizedBox(height: 12),

                                    Text(
                                      "Total Loan",
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: Constanst.fgSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "$total_loan",
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
                                      "Tanggal Pinjaman",
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: Constanst.fgSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      Constanst.convertDate6(
                                          "$tanggalPinjaman"),
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
                                    // const SizedBox(height: 12),
                                    // Row(
                                    //   children: [
                                    //     Expanded(
                                    //       child: Column(
                                    //         crossAxisAlignment: CrossAxisAlignment.start,
                                    //         mainAxisAlignment: MainAxisAlignment.start,
                                    //         children: [
                                    //           Text(
                                    //             "Dari Jam",
                                    //             style: GoogleFonts.inter(
                                    //               fontWeight: FontWeight.w400,
                                    //               fontSize: 14,
                                    //               color: Constanst.fgSecondary,
                                    //             ),
                                    //           ),
                                    //           const SizedBox(height: 4),
                                    //           Text(
                                    //             dariJam,
                                    //             style: GoogleFonts.inter(
                                    //               fontWeight: FontWeight.w500,
                                    //               fontSize: 16,
                                    //               color: Constanst.fgPrimary,
                                    //             ),
                                    //           ),
                                    //           const SizedBox(height: 12),
                                    //           Divider(
                                    //             height: 0,
                                    //             thickness: 1,
                                    //             color: Constanst.border,
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     ),
                                    //     const SizedBox(width: 24),
                                    //     Expanded(
                                    //       child: Column(
                                    //         crossAxisAlignment: CrossAxisAlignment.start,
                                    //         mainAxisAlignment: MainAxisAlignment.start,
                                    //         children: [
                                    //           Text(
                                    //             "Sampai Jam",
                                    //             style: GoogleFonts.inter(
                                    //               fontWeight: FontWeight.w400,
                                    //               fontSize: 14,
                                    //               color: Constanst.fgSecondary,
                                    //             ),
                                    //           ),
                                    //           const SizedBox(height: 4),
                                    //           Text(
                                    //             sampaiJam,
                                    //             style: GoogleFonts.inter(
                                    //               fontWeight: FontWeight.w500,
                                    //               fontSize: 16,
                                    //               color: Constanst.fgPrimary,
                                    //             ),
                                    //           ),
                                    //           const SizedBox(height: 12),
                                    //           Divider(
                                    //             height: 0,
                                    //             thickness: 1,
                                    //             color: Constanst.border,
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
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
                                      "$keterangan",
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
                                      "Periode Cicilan",
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: Constanst.fgSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      // formatDate(periode),
                                      periode,
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
                                      "Durasi Cicilan",
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: Constanst.fgSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "$durasi_cicil",
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                    viewLampiranAjuan(
                                                        leave_files);
                                                  },
                                                  child: Text(
                                                    "$leave_files",
                                                    style: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16,
                                                      color:
                                                          Constanst.fgPrimary,
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                  Text("Rejected by $approve",
                                                      style: GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Constanst
                                                              .fgPrimary,
                                                          fontSize: 14)),
                                                  const SizedBox(height: 6),
                                                  Text(
                                                    alasanReject,
                                                    style: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Constanst
                                                            .fgSecondary,
                                                        fontSize: 14),
                                                  )
                                                ],
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
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Constanst
                                                              .fgPrimary,
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text("Pending Approval",
                                                          style: GoogleFonts.inter(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Constanst
                                                                  .fgPrimary,
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
                                                            globalCt
                                                                .showDataPilihAtasan(
                                                                    dataEmployee);
                                                          },
                                                          child: Text(
                                                              "Konfirmasi via Whatsapp",
                                                              style: GoogleFonts.inter(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Constanst
                                                                      .infoLight,
                                                                  fontSize:
                                                                      14))),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            status == "Approve" ||
                                    status == "Approve 1" ||
                                    status == "Approve 2"
                                ? Container()
                                : Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 16.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 40,
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 0),
                                            margin: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 0),
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
                                                  foregroundColor:
                                                      Constanst.color4,
                                                  backgroundColor:
                                                      Constanst.colorWhite,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  elevation: 0,
                                                  // padding: EdgeInsets.zero,
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
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
                                                Get.to(FormKasbon(
                                                  dataForm: [detailData, true],
                                                ));
                                              },
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor:
                                                    Constanst.colorWhite,
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
                        Obx(
                          () => Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: listDetailKasbon.value.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                  color:
                                                      Constanst.colorNonAktif)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Periode Pinjaman",
                                                  style: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14,
                                                    color:
                                                        Constanst.fgSecondary,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  formatDate(listDetailKasbon
                                                      .value[index]['periode']),
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
                                                  "Jumlah Bayar",
                                                  style: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14,
                                                    color:
                                                        Constanst.fgSecondary,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  convertToIdr(
                                                      listDetailKasbon
                                                              .value[index]
                                                          ['amount'],
                                                      0),
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
                                                  "Status",
                                                  style: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14,
                                                    color:
                                                        Constanst.fgSecondary,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  listDetailKasbon.value[index]
                                                      ['status'],
                                                  style: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    color: Constanst.fgPrimary,
                                                  ),
                                                ),
                                                const SizedBox(height: 12),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
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
      'id': '${index["id"]}',
      // 'menu_name': 'Kasbon',
      // 'activity_name':
      //     'Membatalkan form pengajuan Kasbon. Waktu Kasbon = ${index["dari_jam"]} sd ${index["sampai_jam"]} Alasan Pengajuan = ${index["reason"]} Tanggal Pengajuan = ${index["atten_date"]}',
      // 'created_by': '$getEmid',
      // 'val': 'id',
      // 'cari': '${index["id"]}',
      // 'status_transaksi': 0,
      // 'atten_date': '${index["atten_date"]}',
    };
    var connect = Api.connectionApi("post", body, "employee-loan-delete");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        Navigator.pop(Get.context!);
        Navigator.pop(Get.context!);
        UtilsAlert.showToast("Berhasil batalkan pengajuan");
        Api().checkLogin();
        loadDataKasbon();
        onReady();
      }
    });
  }
}
