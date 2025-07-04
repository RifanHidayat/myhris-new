import 'dart:convert';
import 'dart:io';
// import 'package:background_location_tracker/background_location_tracker.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:siscom_operasional/controller/api_controller.dart';
import 'package:siscom_operasional/controller/auth_controller.dart';
import 'package:siscom_operasional/controller/dashboard_controller.dart';
import 'package:siscom_operasional/controller/internet_controller.dart';
import 'package:siscom_operasional/controller/tracking_controller.dart';
import 'package:siscom_operasional/model/user_model.dart';
import 'package:siscom_operasional/screen/akun/edit_personal_data.dart';
import 'package:siscom_operasional/screen/init_screen.dart';
import 'package:siscom_operasional/screen/login.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/custom_dialog.dart';
import 'package:siscom_operasional/utils/widget_textButton.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';

class SettingController extends GetxController {
  var fotoUser = File("").obs;
  final controllerTracking = Get.put(TrackingController());
  final internetController = Get.find<InternetController>(tag: 'AuthController');
  Rx<List<String>> jenisKelaminDropdown = Rx<List<String>>([]);
  Rx<List<String>> golonganDarahDropdown = Rx<List<String>>([]);

  var nomorIdentitas = TextEditingController().obs;
  var fullName = TextEditingController().obs;
  var namaBelakang = TextEditingController().obs;
  var tanggalLahir = TextEditingController().obs;
  var email = TextEditingController().obs;
  var telepon = TextEditingController().obs;
  var cari = TextEditingController().obs;
  var departemen = TextEditingController().obs;

  var passwordLama = TextEditingController().obs;
  var passwordBaru = TextEditingController().obs;

  var jenisKelamin = "".obs;
  var golonganDarah = "".obs;
  var base64fotoUser = "".obs;
  var namaDepartemenTerpilih = "".obs;
  var loading = "Memuat data...".obs;
  var tanggalAkhirKontrak = "".obs;

  var showpasswordLama = false.obs;
  var showpasswordBaru = false.obs;
  var refreshPageStatus = false.obs;
  var statusLoadingSubmitLaporan = false.obs;

  var idDepartemenTerpilih = 0.obs;
  var jumlahData = 0.obs;

  var listPusatBantuan = [].obs;
  var listDepartement = [].obs;
  var infoEmployee = [].obs;
  var infoEmployeeAll = [].obs;

  var dataJenisKelamin = ["PRIA", "WANITA"];
  var dataGolonganDarah = ['O+', 'O-', 'A+', 'A-', 'B+', 'B-', 'AB+', 'OB+'];

  var apiController = Get.put(ApiController());
  var authController = Get.put(AuthController());
// datedata
  var bulanSelectedSearchHistory = "".obs;
  var tahunSelectedSearchHistory = "".obs;
  var bulanDanTahunNow = "".obs;
  var stringPersenAbsenTepatWaktu = "".obs;
  var stringBulan = "".obs;
  var beginPayroll = "".obs;
  var endPayroll = "".obs;
  var beginBulan = "".obs;
  var endBulanBulan = "".obs;
  var statusPencarian = false.obs;
  var statusFormPencarian = false.obs;
  var visibleWidget = false.obs;
  var bulanStart = "".obs;
  var bulanEnd = "".obs;
  var tahunStart = "".obs;
  var branchList = [].obs;
  var selectBranch = ''.obs;

  RxBool isSearching = false.obs;
  var searchController = TextEditingController();

  void toggleSearch() {
    isSearching.value = !isSearching.value;
  }

  void clearText() {
    searchController.clear();
    pencarianNamaKaryawan('');
  }

  @override
  void onReady() async {
    setDate(DateTime.now());
    // getTimeNow();
    toRouteSimpanData();
    // getPusatBantuan();
    allDepartement();
    getUserInfo();
    //checkSelesaiKontrak();
    getBranch();
    super.onReady();
  }

  void showBottomBranch() {
    showModalBottomSheet(
      context: Get.context!,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pilih Cabang",
                    style: GoogleFonts.inter(
                        color: Constanst.fgPrimary,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                  InkWell(
                      customBorder: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      onTap: () => Navigator.pop(Get.context!),
                      child: Icon(
                        Icons.close,
                        size: 26,
                        color: Constanst.fgSecondary,
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Divider(
                thickness: 1,
                height: 0,
                color: Constanst.border,
              ),
            ),
            Expanded(
              child: Obx(() {
                return SingleChildScrollView(
                  child: ListView.builder(
                    itemCount: branchList.length,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      var name = branchList[index]['name'];
                      var idBrach = branchList[index]['id'];
                      var isSelected = selectBranch.value == name;
                      print('ini brachid $idBrach');
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              selectBranch.value = name;
                              AppData.selectBranch = idBrach.toString();
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 16, 16, 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      name,
                                      style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Constanst.fgPrimary),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  isSelected
                                      ? Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 2,
                                                  color: Constanst.onPrimary),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(3),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Constanst.onPrimary,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: Constanst.onPrimary),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(2),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                            ),
                                          ),
                                        )
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }

  void setDate(DateTime date) {
    var defaultDate = date;
    if (AppData.informasiUser![0].beginPayroll != 1 &&
        defaultDate.day > AppData.informasiUser![0].endPayroll) {
      defaultDate =
          DateTime(defaultDate.year, defaultDate.month + 1, defaultDate.day);
    }

    DateTime tanggalAwalBulan =
        DateTime(defaultDate.year, defaultDate.month, 1);
    DateTime tanggalAkhirBulan =
        DateTime(defaultDate.year, defaultDate.month + 1, 0);
    // Get.snackbar(
    //   "Periode: ${DateFormat('yyyy MMMM dd').format(tanggalAwalBulan)}",
    //   "sampai ${DateFormat('yyyy MMMM dd').format(tanggalAkhirBulan)}",
    // );

    bulanSelectedSearchHistory.value = "${defaultDate.month}";
    tahunSelectedSearchHistory.value = "${defaultDate.year}";
    bulanDanTahunNow.value = "${defaultDate.month}-${defaultDate.year}";
    stringBulan.value = DateFormat('MMMM').format(defaultDate);
    beginPayroll.value = DateFormat('MMMM').format(defaultDate);
    endPayroll.value = DateFormat('MMMM').format(defaultDate);

    DateTime sp = DateTime(defaultDate.year, defaultDate.month, 1);
    DateTime ep =
        DateTime(defaultDate.year, defaultDate.month, tanggalAkhirBulan.day);
    var startPeriode = DateFormat('yyyy-MM-dd').format(sp);
    var endPeriode = DateFormat('yyyy-MM-dd').format(ep);

    DateTime previousMonthDate =
        DateTime(defaultDate.year, defaultDate.month - 1, defaultDate.day);

    if (AppData.informasiUser![0].beginPayroll >
        AppData.informasiUser![0].endPayroll) {
      beginPayroll.value = DateFormat('MMMM').format(previousMonthDate);
      bulanStart.value = DateFormat('MM').format(previousMonthDate);

      startPeriode = DateFormat('yyyy-MM-dd').format(DateTime(defaultDate.year,
          defaultDate.month - 1, AppData.informasiUser![0].beginPayroll));
      endPeriode = DateFormat('yyyy-MM-dd').format(DateTime(defaultDate.year,
          defaultDate.month, AppData.informasiUser![0].endPayroll));
    } else if (AppData.informasiUser![0].beginPayroll == 1) {
      beginPayroll.value = DateFormat('MMMM').format(defaultDate);
      bulanStart.value = DateFormat('MM').format(defaultDate);
    }

    AppData.startPeriode = startPeriode;
    AppData.endPeriode = endPeriode;

    // Get.snackbar(
    //   "Mulai Payroll: ${startPeriode}",
    //   "Selesai Payroll: ${endPeriode}",
    // );

    stringBulan.refresh();
    beginPayroll.refresh();
    endPayroll.refresh();
    bulanSelectedSearchHistory.refresh();
    tahunSelectedSearchHistory.refresh();
    bulanDanTahunNow.refresh();
    bulanEnd.refresh();
    bulanStart.refresh();
    tahunStart.refresh();
  }

  logout() async {
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
            content: "Yakin Keluar Akun",
            positiveBtnText: "Keluar",
            negativeBtnText: "Kembali",
            style: 1,
            buttonStatus: 1,
            positiveBtnPressed: () async {
              AppData.isLogin = false;
              UtilsAlert.loadingSimpanData(context, "Tunggu Sebentar...");
              if (internetController.isConnected.value) {
                aksiEditLastLogin();
                //fungsi stopTracking
                controllerTracking.bagikanlokasi.value = "tidak aktif";
                // await LocationDao().clear();
                // await _getLocations();
                // await BackgroundLocationTrackerManager.stopTracking();
                // final service = FlutterBackgroundService();
                // FlutterBackgroundService().invoke("setAsBackground");

                // service.invoke("stopService");
                controllerTracking.stopService();
                controllerTracking.isTrackingLokasi.value = false;
                print(
                    "stopTracking ${AppData.informasiUser![0].isViewTracking.toString()}");
              } else {
                UtilsAlert.showToast('yes berhasil logout offline');
                print('yes berhasil logout offline');
                Navigator.pop(Get.context!);
                _stopForegroundTask();
                Get.offAll(Login());
                AppData.isLogin = false;
              }
            },
          ),
        );
      },
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return null!;
      },
    );
    // }
  }

  void dateMin(dateInput) {
    var dtnw = DateTime.now();
    var satuBulanKemudian = DateTime(dtnw.year, dtnw.month - 1, dtnw.day);
    if (DateTime.parse(beginPayroll.value)
        .isAfter(DateTime.parse(endPayroll.value))) {
      dtnw = satuBulanKemudian;
    }
  }

  void aksiEditLastLogin() async {
  var dataUser = AppData.informasiUser;
  var getEmid = dataUser![0].em_id;
  authController.isautoLogout.value = true;

  Map<String, dynamic> body = {
    'last_login': '0000-00-00 00:00:00',
    'em_id': getEmid
  };

  var connect = await Api.connectionApi("post", body, "edit_last_login_clear");

  if (connect == null) {
    print("Gagal melakukan koneksi ke API!");
    return;
  }

  if (connect.statusCode == 200) {
    var valueBody = jsonDecode(connect.body);
    print('ini value logout ${valueBody['data']}');

    Navigator.pop(Get.context!);
    _stopForegroundTask();
    Get.offAll(Login());
    AppData.isLogin = false;
  } else {
    print("Error: ${connect.statusCode}");
  }
}


  validateAuth(code) {
    print("kode validate");
    if (code == 401) {
      // AppData.informasiUser = null;
      Navigator.pop(Get.context!);
      _stopForegroundTask();
      Get.offAll(Login());
      AppData.isLogin = false;
    }
  }

  Future<bool> _stopForegroundTask() async {
    return await FlutterForegroundTask.stopService();
  }

  void toRouteSimpanData() {
    jenisKelaminDropdown.value.clear();
    golonganDarahDropdown.value.clear();
    for (var element in dataJenisKelamin) {
      jenisKelaminDropdown.value.add(element);
    }
    this.jenisKelaminDropdown.refresh();
    for (var element in dataGolonganDarah) {
      golonganDarahDropdown.value.add(element);
    }
    this.golonganDarahDropdown.refresh();
    var date =
        Constanst.convertDate1("${AppData.informasiUser![0].em_birthday}");
    nomorIdentitas.value.text = "${AppData.informasiUser![0].em_id}";
    fullName.value.text = "${AppData.informasiUser![0].full_name}";
    tanggalLahir.value.text = date;
    email.value.text = "${AppData.informasiUser![0].em_email}";
    telepon.value.text = "${AppData.informasiUser![0].em_phone}";

    jenisKelamin.value = "${AppData.informasiUser![0].em_gender}";
    golonganDarah.value = "${AppData.informasiUser![0].em_blood_group}";
  }

  void editDataPersonalInfo() {
    var convertTanggalSimpan =
        Constanst.convertDateSimpan(tanggalLahir.value.text);
    UtilsAlert.loadingSimpanData(Get.context!, "Sedang Menyimpan");
    Map<String, dynamic> body = {
      'val': 'em_code',
      'cari': nomorIdentitas.value.text,
      'full_name': fullName.value.text,
      'em_birthday': convertTanggalSimpan,
      'em_email': email.value.text,
      'em_phone': telepon.value.text,
      'em_gender': jenisKelamin.value,
      'em_blood_group': golonganDarah.value
    };
    var connect = Api.connectionApi(
      "post",
      body,
      "edit-employee",
    );
    connect.then((dynamic res) async {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        List<UserModel> getData = <UserModel>[];
        var data = UserModel(
            em_id: "${AppData.informasiUser![0].em_id}",
            full_name: fullName.value.text,
            em_email: email.value.text,
            em_phone: telepon.value.text,
            em_birthday: convertTanggalSimpan,
            em_gender: jenisKelamin.value,
            em_blood_group: golonganDarah.value,
            emp_jobTitle: "${AppData.informasiUser![0].emp_jobTitle}",
            emp_departmen: "${AppData.informasiUser![0].emp_departmen}",
            emp_att_working: AppData.informasiUser![0].emp_att_working);
        getData.add(data);
        AppData.informasiUser = getData;
        Navigator.pop(Get.context!);
        UtilsAlert.berhasilSimpanData(Get.context!, "Data Berhasil diubah");
        await Future.delayed(const Duration(seconds: 3));
        Navigator.pop(Get.context!);
        Get.offAll(InitScreen());
      }
    });
  }

  void allDepartement() async {
    var data = await apiController.getDepartemen();
    listDepartement.value = data;
    this.listDepartement.refresh();
    var addDummy = {
      'id': 0,
      'name': 'SEMUA DIVISI',
      'inisial': 'AD',
    };
    listDepartement.value.insert(0, addDummy);
    idDepartemenTerpilih.value = 0;
    namaDepartemenTerpilih.value = 'SEMUA DIVISI';
    departemen.value.text = 'SEMUA DIVISI';
    this.idDepartemenTerpilih.refresh();
    this.namaDepartemenTerpilih.refresh();
    this.listDepartement.refresh();
  }

  void getUserInfo() async {
    statusLoadingSubmitLaporan.value = true;
    var depId = idDepartemenTerpilih.value;

    Map<String, dynamic> body = {'dep_id': depId};
    var connect = Api.connectionApi(
      "post",
      body,
      "cari_informasi_employee",
    );
    print(body);
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        infoEmployee.value = valueBody['data'];
        infoEmployeeAll.value = valueBody['data'];
        print(valueBody['data']);
        loading.value = infoEmployee.value.length == 0
            ? "Data tidak tersedia"
            : "Memuat data...";
        jumlahData.value = infoEmployee.value.length;
        statusLoadingSubmitLaporan.value = false;
        infoEmployee.value.sort((a, b) => a['full_name']
            .toUpperCase()
            .compareTo(b['full_name'].toUpperCase()));
        this.jumlahData.refresh();
        this.loading.refresh();
        this.statusLoadingSubmitLaporan.refresh();
        this.infoEmployee.refresh();
      } else {
        print('error ${res.body}');
      }
    }).catchError((e) {
      statusLoadingSubmitLaporan.value = false;
      jumlahData.value = 0;
      this.jumlahData.refresh();

      this.loading.refresh();
      this.statusLoadingSubmitLaporan.refresh();
      this.infoEmployee.refresh();
    });
  }

  void checkSelesaiKontrak() async {
    var dataUser = AppData.informasiUser;
    var getEmid = dataUser![0].em_id;
    Map<String, dynamic> body = {'val': 'em_id', 'cari': '$getEmid'};
    var connect = Api.connectionApi(
      "post",
      body,
      "whereOnce-employee_history",
    );
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        print('status karyawan ${valueBody['data'][0]['description']}');
        if (valueBody['data'][0]['description'] != "PERMANENT") {
          tanggalAkhirKontrak.value = valueBody['data'][0]['end_date'];
        } else {
          tanggalAkhirKontrak.value = "";
        }
        this.tanggalAkhirKontrak.refresh();
      }
    });
  }

  void pencarianNamaKaryawan(value) {
    var textCari = value.toLowerCase();
    var filter = infoEmployeeAll.where((laporan) {
      var namaEmployee = laporan['full_name'].toLowerCase();
      return namaEmployee.contains(textCari);
    }).toList();
    infoEmployee.value = filter;
    this.infoEmployee.refresh();
  }

  void ubahPassword() {
    if (passwordLama.value.text == "" || passwordBaru.value.text == "") {
      UtilsAlert.showToast("Lengkapi form");
    } else {
      var dataUser = AppData.informasiUser;
      var getEmid = dataUser![0].em_id;
      UtilsAlert.loadingSimpanData(Get.context!, "Sedang Menyimpan");
      Map<String, dynamic> body = {
        'em_id': getEmid,
        'password_lama': passwordLama.value.text,
        'password_baru': passwordBaru.value.text
      };
      var connect = Api.connectionApi(
        "post",
        body,
        "validasiGantiPassword",
      );
      connect.then((dynamic res) async {
        if (res.statusCode == 200) {
          var valueBody = jsonDecode(res.body);
          if (valueBody['status'] == false) {
            Navigator.pop(Get.context!);
            UtilsAlert.showToast(valueBody['message']);
          } else {
            AppData.passwordUser = passwordBaru.value.text;
            authController.password.value.text = passwordBaru.value.text;
            Navigator.pop(Get.context!);
            UtilsAlert.berhasilSimpanData(Get.context!, "Data Berhasil diubah");
            await Future.delayed(const Duration(seconds: 2));
            Navigator.pop(Get.context!);
            aksiEditLastLogin();
            authController.messageNewPassword.value =
                "Silahkan login menggunakan password baru";
          }
        }
      });
    }
  }

  void getBranch() {
    var connect = Api.connectionApi('get', {}, 'cabang');
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        branchList.clear();
        var valueBody = jsonDecode(res.body);
        print('ini get barnch ${valueBody['data']}');
        for (var data in valueBody['data']) {
          branchList.add(data);
        }
        List data = valueBody['data'];
        if (data.isNotEmpty) {
          var listFirst = data.firstWhere((element) => element['name'] != null,
              orElse: () => null);
          if (listFirst != null) {
            var fullName = listFirst['name'] ?? "";
            String namaUserPertama = "$fullName";
            selectBranch.value = namaUserPertama;
          }
        }
        branchList.refresh;
        selectBranch.refresh;
        print(branchList);
      } else {
        print('error ${res.body}');
      }
    });
  }

  void getPusatBantuan() {
    listPusatBantuan.value.clear();
    var connect = Api.connectionApi(
      "get",
      {},
      "faq",
    );
    connect.then((dynamic res) {
      if (res == false) {
        //UtilsAlert.koneksiBuruk();
      } else {
        if (res.statusCode == 200) {
          var valueBody = jsonDecode(res.body);
          listPusatBantuan.value = valueBody['data'];
          listPusatBantuan.forEach((element) {
            element['status'] = false;
          });
          // for (var element in valueBody['data']) {
          //   var data = {
          //     'idx': element['idx'],
          //     'question': element['question'],
          //     'answered': element['answered'],
          //     'status': false
          //   };
          //   listPusatBantuan.value.add(data);
          //}
          this.listPusatBantuan.refresh();
        }
      }
    });
  }

  void changeStatusPusatBantuan(id) {
    listPusatBantuan.value.forEach((element) {
      if (element['idx'] == id) {
        if (element['status'] == false) {
          element['status'] = true;
        } else {
          element['status'] = false;
        }
      } else {
        element['status'] = false;
      }
    });
    this.listPusatBantuan.refresh();
  }

  // void validasigantiFoto() {
  //   showDialog(
  //     context: Get.context!,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.all(Radius.circular(15.0))),
  //           content: Column(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Center(
  //                   child: Text(
  //                     "Ubah Foto",
  //                     style: GoogleFonts.inter(fontWeight: FontWeight.bold),
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: 10,
  //                 ),
  //                 Row(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   children: [
  //                     Expanded(
  //                         child: Padding(
  //                       padding: const EdgeInsets.all(8.0),
  //                       child: TextButtonWidget2(
  //                           title: "Camera",
  //                           onTap: () {
  //                             Navigator.pop(Get.context!);
  //                             ubahFotoCamera();
  //                           },
  //                           colorButton: Constanst.colorPrimary,
  //                           colortext: Constanst.colorWhite,
  //                           border: BorderRadius.circular(5.0),
  //                           icon: Icon(
  //                             Iconsax.camera,
  //                             size: 18,
  //                             color: Constanst.colorWhite,
  //                           )),
  //                     )),
  //                     Expanded(
  //                         child: Padding(
  //                       padding: const EdgeInsets.all(8.0),
  //                       child: TextButtonWidget2(
  //                           title: "Galery",
  //                           onTap: () {
  //                             Navigator.pop(Get.context!);
  //                             ubahFotoGalery();
  //                           },
  //                           colorButton: Constanst.colorPrimary,
  //                           colortext: Constanst.colorWhite,
  //                           border: BorderRadius.circular(5.0),
  //                           icon: Icon(
  //                             Iconsax.gallery_edit,
  //                             size: 18,
  //                             color: Constanst.colorWhite,
  //                           )),
  //                     ))
  //                   ],
  //                 ),
  //                 SizedBox(
  //                   height: 10,
  //                 ),
  //               ]));
  //     },
  //   );
  // }

  void validasigantiFoto() {
    showModalBottomSheet(
      context: Get.context!,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Ubah Foto Profile",
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Constanst.fgPrimary,
                      ),
                    ),
                    InkWell(
                      customBorder: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      onTap: () {
                        Navigator.pop(Get.context!);
                      },
                      child: Icon(
                        Icons.close,
                        size: 26,
                        color: Constanst.fgSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 0,
                thickness: 1,
                color: Constanst.fgBorder,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(Get.context!);
                  ubahFotoCamera();
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Iconsax.camera,
                            size: 26,
                            color: Constanst.fgPrimary,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Text(
                              "Buka Kamera",
                              style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Constanst.fgPrimary),
                            ),
                          )
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Constanst.fgSecondary,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(Get.context!);
                  ubahFotoGalery();
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Iconsax.gallery,
                            size: 26,
                            color: Constanst.fgPrimary,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Text(
                              "Pilih dari Galeri",
                              style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Constanst.fgPrimary),
                            ),
                          )
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Constanst.fgSecondary,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(Get.context!);
                  validasiHapusFoto();
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Iconsax.trash,
                        size: 26,
                        color: Constanst.color4,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          "Hapus Foto",
                          style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Constanst.color4),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void validasiHapusFoto() {
    showModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Hapus Foto Profile",
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Constanst.fgPrimary,
                      ),
                    ),
                    InkWell(
                      customBorder: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      onTap: () {
                        Navigator.pop(Get.context!);
                      },
                      child: Icon(
                        Icons.close,
                        size: 26,
                        color: Constanst.fgSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 0,
                thickness: 1,
                color: Constanst.fgBorder,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Apakah Anda yakin ingin menghapus Foto Profile?",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Constanst.fgPrimary,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        height: 42,
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Constanst.fgBorder,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(Get.context!);
                            authController.hapusFoto();
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Constanst.color4,
                            backgroundColor: Constanst.colorWhite,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Hapus',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Constanst.color4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Constanst.colorWhite,
                            backgroundColor: Constanst.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                            padding: const EdgeInsets.fromLTRB(0, 12, 0, 12)),
                        child: Text(
                          'Batal',
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Constanst.colorWhite),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // void validasiHapusFoto() {
  //   showModalBottomSheet(
  //     context: Get.context!,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(
  //         top: Radius.circular(15.0),
  //       ),
  //     ),
  //     builder: (context) {
  //       return Column(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           SizedBox(
  //             height: 8,
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.only(left: 16, right: 16),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 Row(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Expanded(
  //                       flex: 90,
  //                       child: Row(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Padding(
  //                             padding: EdgeInsets.only(left: 8, top: 5),
  //                             child: Text(
  //                               "Hapus",
  //                               style: GoogleFonts.inter(
  //                                   fontSize: 16, fontWeight: FontWeight.bold),
  //                             ),
  //                           )
  //                         ],
  //                       ),
  //                     ),
  //                     Expanded(
  //                       flex: 10,
  //                       child: Padding(
  //                         padding: const EdgeInsets.only(top: 2),
  //                         child: InkWell(
  //                           onTap: () {
  //                             Navigator.pop(Get.context!);
  //                           },
  //                           child: Icon(
  //                             Iconsax.close_circle,
  //                             color: Colors.red,
  //                           ),
  //                         ),
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //                 SizedBox(
  //                   height: 16,
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.only(left: 8),
  //                   child: InkWell(
  //                     onTap: () {
  //                       Navigator.pop(Get.context!);
  //                       ubahFotoCamera();
  //                     },
  //                     child: Row(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Icon(
  //                           Iconsax.camera,
  //                           color: Constanst.colorPrimary,
  //                         ),
  //                         Padding(
  //                           padding: EdgeInsets.only(left: 18, top: 3),
  //                           child: Text(
  //                             "Buka Kamera",
  //                             style: GoogleFonts.inter(
  //                                 fontWeight: FontWeight.bold,
  //                                 color: Constanst.colorText3),
  //                           ),
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: 16,
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.only(left: 8),
  //                   child: InkWell(
  //                     onTap: () {
  //                       Navigator.pop(Get.context!);
  //                       ubahFotoGalery();
  //                     },
  //                     child: Row(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Icon(
  //                           Iconsax.gallery_add,
  //                           color: Constanst.colorPrimary,
  //                         ),
  //                         Padding(
  //                           padding: EdgeInsets.only(left: 18, top: 3),
  //                           child: Text(
  //                             "Pilih dari Galeri",
  //                             style: GoogleFonts.inter(
  //                                 fontWeight: FontWeight.bold,
  //                                 color: Constanst.colorText3),
  //                           ),
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: 16,
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.only(left: 8),
  //                   child: InkWell(
  //                     onTap: () {
  //                       Navigator.pop(Get.context!);
  //                       // ubahFotoGalery();
  //                     },
  //                     child: Row(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Icon(
  //                           Iconsax.trash,
  //                           color: Constanst.colorPrimary,
  //                         ),
  //                         Padding(
  //                           padding: EdgeInsets.only(left: 18, top: 3),
  //                           child: Text(
  //                             "Hapus Foto",
  //                             style: GoogleFonts.inter(
  //                                 fontWeight: FontWeight.bold,
  //                                 color: Constanst.colorText3),
  //                           ),
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: 16,
  //                 ),
  //               ],
  //             ),
  //           ),
  //           SizedBox(
  //             height: 8,
  //           )
  //         ],
  //       );
  //     },
  //   );
  // }

  void ubahFotoCamera() async {
    fotoUser.value = File("");
    base64fotoUser.value = "";
    final getFoto = await ImagePicker().pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 100,
        maxHeight: 350,
        maxWidth: 350);
    if (getFoto == null) {
      UtilsAlert.showToast("Gagal mengambil gambar");
    } else {
      fotoUser.value = File(getFoto.path);
      var bytes = File(getFoto.path).readAsBytesSync();
      base64fotoUser.value = base64Encode(bytes);
      aksiGantiFoto();
    }
  }

  void ubahFotoGalery() async {
    fotoUser.value = File("");
    base64fotoUser.value = "";
    this.fotoUser.refresh();
    this.base64fotoUser.refresh();
    final getFoto = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
        maxHeight: 350,
        maxWidth: 350);
    if (getFoto == null) {
      UtilsAlert.showToast("Gagal mengambil gambar");
    } else {
      fotoUser.value = File(getFoto.path);
      var bytes = File(getFoto.path).readAsBytesSync();
      base64fotoUser.value = base64Encode(bytes);
      aksiGantiFoto();
    }
  }

  void aksiGantiFoto() {
    UtilsAlert.loadingSimpanData(Get.context!, "Sedang Menyimpan");
    var dataUser = AppData.informasiUser;
    var getEmid = dataUser![0].em_id;

    Map<String, dynamic> body = {
      'em_id': getEmid,
      'created_by': getEmid,
      'base64_foto_profile': base64fotoUser.value,
      'menu_name': "Setting Profile",
      'activity_name': "Mengganti foto profile",
    };
    print(body);

    var connect = Api.connectionApi(
      "post",
      body,
      "edit_foto_user",
    );
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        var getImage = valueBody['nama_file'];
        List<UserModel> getData = <UserModel>[];
        var data = UserModel(
          em_id: "${dataUser[0].em_id}",
          des_id: dataUser[0].des_id,
          dep_id: dataUser[0].dep_id,
          full_name: "${dataUser[0].full_name}",
          em_email: "${dataUser[0].em_email}",
          em_phone: "${dataUser[0].em_phone}",
          em_birthday: "${dataUser[0].em_birthday}",
          em_gender: "${dataUser[0].em_gender}",
          em_image: "$getImage",
          em_joining_date: "${dataUser[0].em_joining_date}",
          em_status: "${dataUser[0].em_status}",
          em_blood_group: "${dataUser[0].em_blood_group}",
          emp_jobTitle: "${dataUser[0].emp_jobTitle}",
          emp_departmen: "${dataUser[0].emp_departmen}",
          emp_att_working: dataUser[0].emp_att_working,
        );
        getData.add(data);
        AppData.informasiUser = getData;
        Navigator.pop(Get.context!);
        Get.offAll(InitScreen());
        UtilsAlert.showToast("Foto profile berhasil diubah");
      }
    });
  }

  void filterDataArray() {
    var data = listDepartement.value;
    var seen = Set<String>();
    List filter = data.where((divisi) => seen.add(divisi['name'])).toList();
    listDepartement.value = filter;
    this.listDepartement.refresh();
  }

  showDataDepartemenAkses(status) {
    filterDataArray();
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
            padding:
                EdgeInsets.fromLTRB(0, AppBar().preferredSize.height, 0, 0),
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 90,
                          child: Text(
                            "Pilih Divisi",
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                        Expanded(
                            flex: 10,
                            child: InkWell(
                                onTap: () => Navigator.pop(Get.context!),
                                child: Icon(Iconsax.close_circle)))
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Flexible(
                      flex: 3,
                      child: Padding(
                          padding: EdgeInsets.only(left: 8, right: 8),
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: BouncingScrollPhysics(),
                              itemCount: listDepartement.value.length,
                              itemBuilder: (context, index) {
                                var id = listDepartement.value[index]['id'];
                                var dep_name =
                                    listDepartement.value[index]['name'];
                                return InkWell(
                                  onTap: () {
                                    print("tes");
                                    idDepartemenTerpilih.value = id;
                                    namaDepartemenTerpilih.value = dep_name;
                                    departemen.value.text =
                                        listDepartement.value[index]['name'];
                                    this.departemen.refresh();
                                    Navigator.pop(context);
                                    getUserInfo();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color:
                                              id == idDepartemenTerpilih.value
                                                  ? Constanst.colorPrimary
                                                  : Colors.transparent,
                                          borderRadius: Constanst
                                              .styleBoxDecoration1.borderRadius,
                                          border: Border.all(
                                              color: Constanst.colorText2)),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        child: Center(
                                          child: Text(
                                            dep_name,
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.bold,
                                                color: id ==
                                                        idDepartemenTerpilih
                                                            .value
                                                    ? Colors.white
                                                    : Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              })),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    String formattedDate = DateFormat('d MMMM yyyy', 'id_ID').format(dateTime);

    return formattedDate;
  }

  void lineInfoPenggunaKontrak() async {
    showGeneralDialog(
      barrierDismissible: false,
      context: Get.context!,
      barrierColor: Colors.black54, // space around dialog
      transitionDuration: const Duration(milliseconds: 200),
      transitionBuilder: (context, a1, a2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
              parent: a1,
              curve: Curves.elasticOut,
              reverseCurve: Curves.easeOutCubic),
          child: Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              // margin: const EdgeInsets.only(
              //     top: 0), // Memastikan kotak berada di bawah lingkaran
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.only(
                right: 16,
                left: 16,
                bottom: 32,
                top: 8,
              ), // Memberi jarak di dalam kotak
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment
                        .center, // Sejajarkan semua elemen secara vertikal
                    children: [
                      Image.asset(
                        "assets/icon_kontrak.png",
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        // Memastikan teks bisa meluas dan tidak terpotong
                        child: Text(
                          "Reminder",
                          style: GoogleFonts.inter(
                            color: Constanst.fgPrimary,
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          size: 20,
                          color: Constanst.fgPrimary,
                        ),
                        onPressed: () {
                          Get.back(); // Menutup dialog ketika ikon 'x' ditekan
                        },
                        padding:
                            EdgeInsets.zero, // Menghilangkan padding default
                        constraints:
                            const BoxConstraints(), // Mengatur ulang constraints agar ukuran minimal
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 1,
                    height: 0,
                    color: Constanst.fgBorder,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Pastikan Anda tidak melewati batas waktu penting!",
                    style: GoogleFonts.inter(
                      color: Constanst.fgPrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment
                        .center, // Sejajarkan semua elemen secara vertikal
                    children: [
                      Image.asset(
                        "assets/waktu_tersisa.png",
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(width: 8),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Waktu Tersisa",
                            style: GoogleFonts.inter(
                              color: Constanst.fgSecondary,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            AppData.informasiUser![0].sisaKontrakFormat
                                        .toString() !=
                                    "null"
                                ? AppData.informasiUser![0].sisaKontrakFormat
                                    .toString()
                                : "-",
                            style: GoogleFonts.inter(
                              color: Constanst.fgPrimary,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(
                    thickness: 1,
                    height: 0,
                    color: Constanst.fgBorder,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment
                        .center, // Sejajarkan semua elemen secara vertikal
                    children: [
                      Image.asset(
                        "assets/lama_bekerja.png",
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(width: 8),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Lama Bekerja",
                            style: GoogleFonts.inter(
                              color: Constanst.fgSecondary,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            AppData.informasiUser![0].lamaBekerjaFormat
                                .toString(),
                            style: GoogleFonts.inter(
                              color: Constanst.fgPrimary,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(
                    thickness: 1,
                    height: 0,
                    color: Constanst.fgBorder,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment
                        .center, // Sejajarkan semua elemen secara vertikal
                    children: [
                      Image.asset(
                        "assets/tanggal_berakhir.png",
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(width: 8),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tanggal Berakhir",
                            style: GoogleFonts.inter(
                              color: Constanst.fgSecondary,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            AppData.informasiUser![0].tanggalBerakhirKontrak
                                        .toString() !=
                                    ""
                                ? formatDate(AppData
                                    .informasiUser![0].tanggalBerakhirKontrak
                                    .toString())
                                : "-",
                            style: GoogleFonts.inter(
                              color: Constanst.fgPrimary,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return null!;
      },
    );
  }
}
