import 'dart:async';
import 'dart:convert';

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siscom_operasional/controller/absen_controller.dart';
import 'package:siscom_operasional/controller/auth_controller.dart';
import 'package:siscom_operasional/controller/bpjs.dart';
import 'package:siscom_operasional/controller/cuti_controller.dart';
import 'package:siscom_operasional/controller/global_controller.dart';
import 'package:siscom_operasional/controller/izin_controller.dart';
import 'package:siscom_operasional/controller/klaim_controller.dart';
import 'package:siscom_operasional/controller/lembur_controller.dart';
import 'package:siscom_operasional/controller/tab_controller.dart';
import 'package:siscom_operasional/controller/tracking_controller.dart';
import 'package:siscom_operasional/controller/tugas_luar_controller.dart';
import 'package:siscom_operasional/database/sqlite/sqlite_database_helper.dart';
import 'package:siscom_operasional/model/menu.dart';
import 'package:siscom_operasional/model/menu_dashboard_model.dart';
import 'package:google_maps_utils/google_maps_utils.dart' as maps;
import 'package:siscom_operasional/model/user_model.dart';
import 'package:siscom_operasional/screen/absen/absesi_location.dart';
import 'package:siscom_operasional/screen/absen/camera_view.dart';
import 'package:siscom_operasional/screen/absen/form/form_lembur.dart';
import 'package:siscom_operasional/screen/absen/form/form_pengajuan_izin.dart';
import 'package:siscom_operasional/screen/absen/form/form_tugas_luar.dart';
import 'package:siscom_operasional/screen/absen/history_absen.dart';
import 'package:siscom_operasional/screen/absen/laporan/laporan_absen.dart';
import 'package:siscom_operasional/screen/absen/laporan/laporan_cuti.dart';
import 'package:siscom_operasional/screen/absen/laporan/laporan_dinas_luar.dart';
import 'package:siscom_operasional/screen/absen/laporan/laporan_izin.dart';
import 'package:siscom_operasional/screen/absen/laporan/laporan_klaim.dart';
import 'package:siscom_operasional/screen/absen/laporan/laporan_lembur.dart';
import 'package:siscom_operasional/screen/absen/laporan/laporan_semua_pengajuan.dart';
import 'package:siscom_operasional/screen/absen/laporan/laporan_tugas_luar.dart';
import 'package:siscom_operasional/screen/absen/lembur.dart';
import 'package:siscom_operasional/screen/absen/riwayat_izin.dart';
import 'package:siscom_operasional/screen/absen/tugas_luar.dart';
import 'package:siscom_operasional/screen/absen/form/form_pengajuan_cuti.dart';
import 'package:siscom_operasional/screen/absen/riwayat_cuti.dart';
import 'package:siscom_operasional/screen/absen/izin.dart';
import 'package:siscom_operasional/screen/bpjs/bpjs_kesehatan.dart';
import 'package:siscom_operasional/screen/bpjs/bpjs_ketenagakerjaan.dart';
import 'package:siscom_operasional/screen/init_screen.dart';

import 'package:siscom_operasional/screen/kandidat/form_kandidat.dart';
import 'package:siscom_operasional/screen/kandidat/list_kandidat.dart';
import 'package:siscom_operasional/screen/kasbon/riwayat_kasbon.dart';
import 'package:siscom_operasional/screen/klaim/form_klaim.dart';
import 'package:siscom_operasional/screen/klaim/riwayat_klaim.dart';
import 'package:siscom_operasional/screen/pph21/pphh21.dart';
import 'package:siscom_operasional/screen/slip_gaji/slip_gaji.dart';
import 'package:siscom_operasional/screen/verify_password_payroll.dart';
import 'package:siscom_operasional/services/request.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/custom_dialog.dart';
import 'package:siscom_operasional/utils/widget_textButton.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';
import 'package:flutter_svg/flutter_svg.dart';

var departementAkses = [].obs;

class DashboardController extends GetxController {
  CarouselSliderController corouselDashboard = CarouselSliderController();
  PageController menuController = PageController(initialPage: 0);
  PageController informasiController = PageController(initialPage: 0);
  final controllerTracking = Get.put(TrackingController());
  final tabbController = Get.put(TabbController());
  var controller = Get.put(BpjsController());

  RxString signoutTime = "".obs;
  RxString signinTime = "".obs;
  var status = "".obs;
  var wfhstatus = false.obs;
  var approveStatus = "".obs;
  var wfhlokasi = false.obs;

  RxBool isSearching = false.obs;
  var searchController = TextEditingController();
  var bpjsController = Get.put(BpjsController());

  var controllerAbsensi = Get.put(AbsenController());
  var controllerIzin = Get.put(IzinController());
  var controllerLembur = Get.put(LemburController());
  var controllerCuti = Get.put(CutiController());
  var controllerTugasLuar = Get.put(TugasLuarController());
  var controllerKlaim = Get.put(KlaimController());
  final authController = Get.put(AuthController());

  var menu = <MenuDashboardModel>[].obs;
  var globalCtr = Get.put(GlobalController());
  var dashboardStatusAbsen = false.obs;

  var user = [].obs;
  var menus = <MenuModel>[].obs;
  var isLoadingMenuDashboard = true;
  var bannerDashboard = [].obs;
  var finalMenu = [].obs;
  var informasiDashboard = [].obs;
  var employeeUltah = [].obs;
  var employeeTidakHadir = [].obs;
  var menuShowInMain = [].obs;
  var menuShowInMainNew = [].obs;
  var menuShowInMainUtama = [].obs;
  var isPauseCamera = true;
  var jumlahData = 0.obs;
  var departementAkses = [].obs;

  var timeString = "".obs;
  var dateNow = "".obs;
  var showUlangTahun = false.obs;
  var showPkwt = false.obs;
  var showPengumuman = false.obs;
  var showLaporan = false.obs;

  var selectedPageView = 0.obs;
  var indexBanner = 0.obs;
  var heightPageView = 0.0.obs;
  var heightbanner = 0.0.obs;
  var ratioDevice = 0.0.obs;
  var tinggiHp = 0.0.obs;
  var selectedInformasiView = 0.obs;

  var deviceStatus = false.obs;
  var refreshPagesStatus = false.obs;
  var viewInformasiSisaKontrak = false.obs;

  var timeIn = "".obs;
  var timeOut = "".obs;
  var absenMasukKeluarOffline = Rx<dynamic>(null);
  var textPendingMasuk = false.obs;
  var textPendingKeluar = false.obs;
  var pendingSignoutApr = false.obs;
  var pendingSigninApr = false.obs;

  var absenOfflineStatus = false.obs;
  // var absenOfflineStatusDua = false.obs;
  var isLoading = false.obs;

  GoogleMapController? mapController;

  void toggleSearch() {
    isSearching.value = !isSearching.value;
  }

  void clearText() {
    searchController.clear();
  }

  List sortcardPengajuan = [
    {"id": 1, "nama_pengajuan": "Pengajuan Lembur"},
    {"id": 2, "nama_pengajuan": "Pengajuan Cuti"},
    {"id": 3, "nama_pengajuan": "Pengajuan Tugas Luar"},
    {"id": 4, "nama_pengajuan": "Pengajuan Izin"},
    {"id": 5, "nama_pengajuan": "Pengajuan Klaim"},
    {"id": 6, "nama_pengajuan": "Pengajuan Kandidat"},
  ];

  @override
  void onInit() async {
    // if (menus.length<=0){
    //   dashboardMenu();
    // }
    //  getUserInfo();
    print("loginnn: ${AppData.isLogin}");

    super.onInit();
  }

  Future<void> initData() async {
    absenMasukKeluarOffline.value = await SqliteDatabaseHelper().getAbsensi();
    print("heii:${absenMasukKeluarOffline.value}");
    // SqliteDatabaseHelper().deleteAbsensi();
    // AppData.signoutTime = "";
    // AppData.signingTime = "";
    if (authController.isConnected.value) {
      AppData.signoutTime = "";
      AppData.signingTime = "";
      AppData.temp = false;
      pendingSignoutApr.value = false;
      pendingSigninApr.value = false;
      dashboardStatusAbsen.value = AppData.statusAbsen;
      absenOfflineStatus.value = false;
      // DateTime startDate = await NTP.now();

      DateTime startDate = DateTime.now();

      // if (AppData.informasiUser != null && AppData.informasiUser!.isNotEmpty) {
      var emId = AppData.informasiUser![0].em_id.toString();
      checkAbsenUser(DateFormat('yyyy-MM-dd').format(DateTime.now()), emId);
      // } else {
      //   print("Informasi user tidak tersedia.");
      // }

      updateWorkTime();
      getBannerDashboard();
      updateInformasiUser();
      getEmployeeUltah(DateFormat('yyyy-MM-dd').format(DateTime.now()));
      getMenuDashboard();
      loadMenuShowInMain();
      loadMenuShowInMainUtama();
      getInformasiDashboard();
      getEmployeeBelumAbsen();
      timeString.value = formatDateTime(startDate);
      dateNow.value = dateNoww(startDate);

      Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
      getSizeDevice();
      checkStatusPermission();
      checkHakAkses();
    } else {
      isLoading.value = false;
      GetStorage().write("face_recog", true);
      // authController.login.value = false;
      print("kondisi: ${authController.isConnected.value}");
      dashboardStatusAbsen.value = AppData.statusAbsen;

      DateTime startDate = DateTime.now();
      getBannerDashboard();
      // getMenuDashboard();
      loadMenuShowInMain();
      loadMenuShowInMainUtama();
      timeString.value = formatDateTime(startDate);
      dateNow.value = dateNoww(startDate);

      Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
      getSizeDevice();
      checkStatusPermission();
      checkHakAkses();
      // final service = FlutterBackgroundService();
      // service.invoke("stopService");

      absenMasukKeluarOffline.value = await SqliteDatabaseHelper().getAbsensi();
      // var absenMasukKeluarOfflineDua =
      //     await SqliteDatabaseHelper().getAbsensiDua();
      // print("ini aku: ${absenMasukKeluarOffline.value}");

      if (absenMasukKeluarOffline.value != null) {
        if (absenMasukKeluarOffline.value['signing_time'] != "") {
          signinTime.value =
              absenMasukKeluarOffline.value['signing_time'].toString();
          textPendingMasuk.value = true;
          signoutTime.value =
              AppData.signoutTime != "" && AppData.signoutTime != "00:00:00"
                  ? AppData.signoutTime
                  : "_ _:_ _:_ _";
        } else if (absenMasukKeluarOffline.value['signout_time'] != "") {
          signinTime.value =
              AppData.signingTime != "" && AppData.signingTime != "00:00:00"
                  ? AppData.signingTime
                  : "_ _:_ _:_ _";
          signoutTime.value =
              absenMasukKeluarOffline.value['signout_time'].toString();
          textPendingKeluar.value = true;
        } else if (absenMasukKeluarOffline.value['signing_time'] != "" &&
            absenMasukKeluarOffline.value['signout_time'] != "") {
          signinTime.value =
              absenMasukKeluarOffline.value['signing_time'].toString();
          signoutTime.value =
              absenMasukKeluarOffline.value['signout_time'].toString();
          textPendingMasuk.value = true;
          textPendingKeluar.value = true;
        }
      } else {
        signinTime.value =
            AppData.signingTime != "" && AppData.signingTime != "00:00:00"
                ? AppData.signingTime
                : "_ _:_ _:_ _";
        signoutTime.value =
            AppData.signoutTime != "" && AppData.signoutTime != "00:00:00"
                ? AppData.signoutTime
                : "_ _:_ _:_ _";
      }

      if ((AppData.signingTime == "" || AppData.signingTime == "00:00:00") &&
          (AppData.signoutTime == "" || AppData.signoutTime == "00:00:00")) {
        absenOfflineStatus.value = false;
        absenControllre.absenStatus.value = false;
        AppData.statusAbsen = false;
        // AppData.dateLastAbsen = absenMasukKeluarOffline['atten_date'];
      } else if ((AppData.signingTime != "" ||
              AppData.signingTime != "00:00:00") &&
          (AppData.signoutTime == "" || AppData.signoutTime == "00:00:00")) {
        absenOfflineStatus.value = AppData.statusAbsenOffline;
        if (absenOfflineStatus.value == true) {
          pendingSigninApr.value = true;
          textPendingMasuk.value = AppData.textPendingMasuk;
          textPendingKeluar.value = AppData.textPendingKeluar;
        }
        absenControllre.absenStatus.value = true;
        AppData.statusAbsen = true;
        // AppData.dateLastAbsen = absenMasukKeluarOffline['atten_date'];
      } else if ((AppData.signingTime != "" ||
              AppData.signingTime != "00:00:00") &&
          (AppData.signoutTime != "" || AppData.signoutTime != "00:00:00")) {
        absenOfflineStatus.value = AppData.statusAbsenOffline;

        absenControllre.absenStatus.value = false;
        AppData.statusAbsen = false;
        if (absenOfflineStatus.value == true) {
          pendingSignoutApr.value = true;
          textPendingKeluar.value = AppData.textPendingKeluar;
          pendingSigninApr.value = false;
          textPendingMasuk.value = AppData.textPendingMasuk;
          if (absenMasukKeluarOffline.value['signing_time'] != "") {
            pendingSigninApr.value = true;
            textPendingMasuk.value = AppData.textPendingMasuk;
            textPendingKeluar.value = AppData.textPendingKeluar;
            absenControllre.absenStatus.value = true;
            AppData.statusAbsen = true;
          } else if (AppData.temp == true) {
            pendingSigninApr.value = true;
            textPendingMasuk.value = AppData.textPendingMasuk;
            textPendingKeluar.value = AppData.textPendingKeluar;
            absenControllre.absenStatus.value = true;
            AppData.statusAbsen = true;
          }
        }
        // AppData.dateLastAbsen = absenMasukKeluarOffline['atten_date'];
      }
      print(AppData.signingTime);
      print(AppData.signoutTime);
      print("status:${AppData.statusAbsenOffline}");
    }
  }

  void popUpRefresh(BuildContext context) async {
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
            title: "Informasi",
            content: "Anda harus merefresh lokasi terlebih dahulu!",
            positiveBtnText: "Refresh",
            style: 1,
            buttonStatus: 1,
            positiveBtnPressed: () async {
              controllerAbsensi.statusDeteksi2.value = false;
              Get.back();
              if (!authController.isConnected.value) {
                controllerAbsensi.refreshPageOffline();
              } else {
                controllerAbsensi.refreshPage();
              }
              update();
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

  Future<void> checkAbsenUser(convert, getEmid) async {
    print("tes ${AppData.informasiUser![0].startTime.toString()}");
    var startTime = "";
    var endTime = "";
    var startDate = "";
    var endDate = "";
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

    //alur normal
    if (totalMinutes1 < totalMinutes2) {
      startTime = AppData.informasiUser![0].startTime;
      endTime = AppData.informasiUser![0].endTime;

      startDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      //alur beda hari
    } else if (totalMinutes1 > totalMinutes2) {
      var waktu3 =
          TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
      int totalMinutes3 = waktu3.hour * 60 + waktu3.minute;

      if (totalMinutes2 > totalMinutes3) {
        print("masuk sini view las user");
        startTime = AppData.informasiUser![0].endTime;
        endTime = AppData.informasiUser![0].startTime;

        startTime = AppData.informasiUser![0].endTime;
        endTime = AppData.informasiUser![0].startTime;

        startDate = DateFormat('yyyy-MM-dd')
            .format(DateTime.now().add(const Duration(days: -1)));

        endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      } else {
        print("masuk sini view las user 2");
        startTime = AppData.informasiUser![0].endTime;
        endTime = AppData.informasiUser![0].startTime;

        endDate = DateFormat('yyyy-MM-dd')
            .format(DateTime.now().add(const Duration(days: 2)));

        startDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      }
    } else {
      startTime = AppData.informasiUser![0].startTime;
      endTime = AppData.informasiUser![0].endTime;

      startDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      print(
          "Waktu 1 sama dengan waktu 2 new ${totalMinutes1}  ${totalMinutes2}");
    }
    Map<String, dynamic> body = {
      'atten_date': DateFormat('yyyy-MM-dd')
          .format(DateTime.now().add(const Duration(days: -1))),
      'em_id': getEmid,
      'database': AppData.selectedDatabase,
      'start_date': startDate,
      'end_date': endDate,
      'start_time': startTime,
      'end_time': endTime,
      'pola': globalCtr.valuePolaPersetujuan.value.toString(),
    };
    print("data param ${body}");
    var connect = Api.connectionApi("post", body, "view_last_absen_user2");
    Future.delayed(const Duration(milliseconds: 500), () {
      connect.then((dynamic res) async {
        if (res.statusCode == 200) {
          var valueBody = jsonDecode(res.body);
          print("data login new ${valueBody}");
          // print(
          //     "hasil view_last_absen_user1 wfhstatus.valu ${valueBody['data'][0]['place_in'].toString()}");
          // var data = valueBody['wfh'] ?? valueBody['data'];
          var data = valueBody['data'];
          List wfh = valueBody['wfh'];
          List offiline = valueBody['offiline'];
          // status.value = valueBody['wfh'].toString == "[]"
          //     ? ""
          //     : valueBody['wfh'][0]['status'];

          status.value = data.toString();
          print("hasil status.value ${status.value}");
          // print(
          //     "hasil view_last_absen_user1 wfhstatus.valu ${wfhstatus.value.toString()}");
          // print("hasil view_last_absen_user1 status ${valueBody['wfh']}");
          // print("hasil view_last_absen_user1 ${valueBody['data'].toString()}");
          // print("hasil view_last_absen_user1 status.valu ${status.value}");

          // signinTime.value = wfh[0]['signing_time'].toString();

          // var wfh = valueBody['wfh'];
          if (wfh.isEmpty) {
            if (offiline.isEmpty) {
              if (data.isEmpty) {
                AppData.statusAbsen = false;
                signoutTime.value = '00:00:00';
                signinTime.value = '00:00:00';

                AppData.statusAbsenOffline = false;
              } else {
                wfhlokasi.value =
                    valueBody['data'][0]['place_in'].toString() == "WFH"
                        ? true
                        : false;

                AppData.statusAbsen =
                    data[0]['signout_time'] == "00:00:00" ? true : false;
                dashboardStatusAbsen.value =
                    data[0]['signout_time'] == "00:00:00" ? true : false;

                signoutTime.value = data[0]['signout_time'].toString();
                signinTime.value = data[0]['signin_time'].toString();

                AppData.statusAbsenOffline = false;
              }
            } else {
              AppData.temp = false;
              //if (data.isNotEmpty && offiline.isNotEmpty)
              if (offiline[0]['signing_time'].toString() != "00:00:00" &&
                  offiline[0]['signout_time'].toString() == "00:00:00" &&
                  data.isEmpty) {
                AppData.temp = true;
                absenOfflineStatus.value = true;
                pendingSigninApr.value = true;
                AppData.statusAbsenOffline = true;
                absenControllre.absenStatus.value = true;
                AppData.statusAbsen = true;
                signinTime.value = offiline[0]['signing_time'].toString();
                signoutTime.value = '00:00:00';
                // if (data.isNotEmpty) {
                //   signoutTime.value = data[0]['signout_time'].toString();
                // }

                // AppData.dateLastAbsen = absenMasukKeluarOffline['atten_date'];
              } else if (offiline[0]['signing_time'].toString() == "00:00:00" &&
                  offiline[0]['signout_time'].toString() != "00:00:00" &&
                  data[0]['signout_time'] == "00:00:00" &&
                  data[0]['signin_time'] != "00:00:00") {
                print("atuh");
                absenOfflineStatus.value = true;
                pendingSignoutApr.value = true;
                AppData.statusAbsenOffline = true;
                absenControllre.absenStatus.value = false;
                AppData.statusAbsen = false;
                signinTime.value = data[0]['signin_time'].toString();
                signoutTime.value = offiline[0]['signout_time'].toString();
                // AppData.dateLastAbsen = absenMasukKeluarOffline['atten_date'];
              } else if (offiline[0]['signing_time'].toString() == "00:00:00" &&
                  offiline[0]['signout_time'].toString() != "00:00:00" &&
                  data.isEmpty) {
                absenOfflineStatus.value = true;
                pendingSignoutApr.value = true;
                pendingSigninApr.value = true;
                AppData.statusAbsenOffline = true;
                absenControllre.absenStatus.value = false;
                AppData.statusAbsen = false;
                signinTime.value = offiline[0]['signing_time'].toString();
                signoutTime.value = offiline[0]['signout_time'].toString();
              } else if (offiline[0]['signing_time'].toString() != "00:00:00" &&
                  offiline[0]['signout_time'].toString() != "00:00:00" &&
                  data.isEmpty) {
                absenOfflineStatus.value = true;
                pendingSignoutApr.value = true;
                pendingSigninApr.value = true;
                AppData.statusAbsenOffline = true;
                absenControllre.absenStatus.value = false;
                AppData.statusAbsen = false;
                signinTime.value = offiline[0]['signing_time'].toString();
                signoutTime.value = offiline[0]['signout_time'].toString();
                // AppData.dateLastAbsen = absenMasukKeluarOffline['atten_date'];
              } else if ((offiline[0]['signing_time'].toString() ==
                      data[0]['signin_time'].toString()) &&
                  (offiline[0]['signout_time'].toString() ==
                      data[0]['signout_time'].toString()) &&
                  offiline[0]['signing_time'].toString() != "00:00:00" &&
                  offiline[0]['signout_time'].toString() != "00:00:00") {
                absenOfflineStatus.value = false;
                pendingSignoutApr.value = false;
                AppData.statusAbsenOffline = false;
                absenControllre.absenStatus.value = false;
                AppData.statusAbsen = false;
                signinTime.value = data[0]['signin_time'].toString();
                signoutTime.value = data[0]['signout_time'].toString();
                // AppData.dateLastAbsen = absenMasukKeluarOffline['atten_date'];
              } else if (offiline[0]['signing_time'].toString() ==
                      data[0]['signin_time'].toString() &&
                  offiline[0]['signing_time'].toString() != "00:00:00") {
                absenOfflineStatus.value = false;
                pendingSignoutApr.value = false;
                AppData.statusAbsenOffline = false;
                absenControllre.absenStatus.value = true;
                AppData.statusAbsen = true;
                signinTime.value = data[0]['signin_time'].toString();
                signoutTime.value = data[0]['signout_time'].toString();
                // AppData.dateLastAbsen = absenMasukKeluarOffline['atten_date'];
              } else if (offiline[0]['signout_time'].toString() ==
                      data[0]['signout_time'].toString() &&
                  offiline[0]['signout_time'].toString() != "00:00:00") {
                print("Kesiniiii");
                absenOfflineStatus.value = false;
                pendingSignoutApr.value = false;
                AppData.statusAbsenOffline = false;
                absenControllre.absenStatus.value = false;
                AppData.statusAbsen = false;
                signinTime.value = data[0]['signin_time'].toString();
                signoutTime.value = data[0]['signout_time'].toString();
                // AppData.dateLastAbsen = absenMasukKeluarOffline['atten_date'];
              }

              textPendingMasuk.value =
                  (offiline[0]['signing_time'].toString() == "00:00:00");

              textPendingKeluar.value =
                  (offiline[0]['signout_time'].toString() == "00:00:00");

              var absenMasukKeluarOffline =
                  await SqliteDatabaseHelper().getAbsensi();
              if (absenMasukKeluarOffline != null) {
                if (absenMasukKeluarOffline['signing_time'] != "") {
                  signinTime.value =
                      absenMasukKeluarOffline['signing_time'].toString();
                  pendingSigninApr.value = true;
                  textPendingMasuk.value = true;
                } else if (absenMasukKeluarOffline['signout_time'] != "") {
                  signoutTime.value =
                      absenMasukKeluarOffline['signout_time'].toString();
                  pendingSignoutApr.value = true;
                  textPendingKeluar.value = true;
                }
              }
            }
          } else {
            wfhstatus.value = wfh.isEmpty ? false : true;
            controllerAbsensi.absenStatus.value = wfh.isEmpty ? false : true;
            approveStatus.value = valueBody['wfh'][0]['status'].toString();
            // if (data.isEmpty) {
            signinTime.value = wfh[0]['signing_time'].toString();
            controllerAbsensi.nomorAjuan.value =
                wfh[0]['nomor_ajuan'].toString();
            // status.value = wfh[0]['status'].toString();

            // status.value = "ad";
            // controllerAbsensi.absenStatus.value = true;
          }

          AppData.textPendingMasuk = textPendingMasuk.value;
          AppData.textPendingKeluar = textPendingKeluar.value;

          AppData.signingTime = signinTime.value;
          AppData.signoutTime = signoutTime.value;
          print("hasil signinTime ${signinTime.value}");
          print("hasil signinTime ${signoutTime.value}");
        } else {
          isLoading.value = false;
        }
      }).catchError((error) async {
        absenMasukKeluarOffline.value =
            await SqliteDatabaseHelper().getAbsensi();
        // var absenMasukKeluarOfflineDua =
        //     await SqliteDatabaseHelper().getAbsensiDua();
        // print("ini aku: ${absenMasukKeluarOffline.value}");

        if (absenMasukKeluarOffline.value != null) {
          if (absenMasukKeluarOffline.value['signing_time'] != "") {
            signinTime.value =
                absenMasukKeluarOffline.value['signing_time'].toString();
            textPendingMasuk.value = true;
            signoutTime.value =
                AppData.signoutTime != "" && AppData.signoutTime != "00:00:00"
                    ? AppData.signoutTime
                    : "_ _:_ _:_ _";
          } else if (absenMasukKeluarOffline.value['signout_time'] != "") {
            signinTime.value =
                AppData.signingTime != "" && AppData.signingTime != "00:00:00"
                    ? AppData.signingTime
                    : "_ _:_ _:_ _";
            signoutTime.value =
                absenMasukKeluarOffline.value['signout_time'].toString();
            textPendingKeluar.value = true;
          } else if (absenMasukKeluarOffline.value['signing_time'] != "" &&
              absenMasukKeluarOffline.value['signout_time'] != "") {
            signinTime.value =
                absenMasukKeluarOffline.value['signing_time'].toString();
            signoutTime.value =
                absenMasukKeluarOffline.value['signout_time'].toString();
            textPendingMasuk.value = true;
            textPendingKeluar.value = true;
          }
        } else {
          signinTime.value =
              AppData.signingTime != "" && AppData.signingTime != "00:00:00"
                  ? AppData.signingTime
                  : "_ _:_ _:_ _";
          signoutTime.value =
              AppData.signoutTime != "" && AppData.signoutTime != "00:00:00"
                  ? AppData.signoutTime
                  : "_ _:_ _:_ _";
        }

        if ((AppData.signingTime == "" || AppData.signingTime == "00:00:00") &&
            (AppData.signoutTime == "" || AppData.signoutTime == "00:00:00")) {
          absenOfflineStatus.value = false;
          absenControllre.absenStatus.value = false;
          AppData.statusAbsen = false;
          // AppData.dateLastAbsen = absenMasukKeluarOffline['atten_date'];
        } else if ((AppData.signingTime != "" ||
                AppData.signingTime != "00:00:00") &&
            (AppData.signoutTime == "" || AppData.signoutTime == "00:00:00")) {
          absenOfflineStatus.value = AppData.statusAbsenOffline;
          if (absenOfflineStatus.value == true) {
            pendingSigninApr.value = true;
            textPendingMasuk.value = true;
          }
          absenControllre.absenStatus.value = true;
          AppData.statusAbsen = true;
          // AppData.dateLastAbsen = absenMasukKeluarOffline['atten_date'];
        } else if ((AppData.signingTime != "" ||
                AppData.signingTime != "00:00:00") &&
            (AppData.signoutTime != "" || AppData.signoutTime != "00:00:00")) {
          absenOfflineStatus.value = AppData.statusAbsenOffline;

          absenControllre.absenStatus.value = false;
          AppData.statusAbsen = false;
          if (absenOfflineStatus.value == true) {
            pendingSignoutApr.value = true;
            textPendingKeluar.value = true;
            pendingSigninApr.value = false;
            textPendingMasuk.value = false;
            if (absenMasukKeluarOffline.value['signing_time'] != "") {
              pendingSigninApr.value = true;
              textPendingMasuk.value = true;
              absenControllre.absenStatus.value = true;
              AppData.statusAbsen = true;
            } else if (AppData.temp == true) {
              pendingSigninApr.value = true;
              textPendingMasuk.value = false;
              absenControllre.absenStatus.value = true;
              AppData.statusAbsen = true;
            }
          }
          // AppData.dateLastAbsen = absenMasukKeluarOffline['atten_date'];
        }
        isLoading.value = false;
      });
    });
  }

  void widgetButtomSheetOfflineAbsen(
      {required String title, required String status}) {
    showModalBottomSheet(
      context: Get.context!,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12.0),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Koneksi Anda Terputus",
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              color: Constanst.fgPrimary,
                              fontSize: 16),
                        ),
                        InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: const Icon(Icons.close))
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Constanst.infoLight1,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Icon(
                            Iconsax.info_circle5,
                            color: Constanst.colorPrimary,
                            size: 26,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Menunggu indikator menjadi hijau atau anda yakin ingin melakukan absen secara offline? \n\nKeterangan: Absen offline membutuhkan approval",
                              textAlign: TextAlign.left,
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  color: Constanst.fgPrimary,
                                  fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          Get.back();
                          controllerAbsensi.titleAbsen.value = title;
                          Get.to(AbsensiLocation(
                            status: status,
                          ));
                        },
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Constanst.colorWhite,
                            backgroundColor: Constanst.colorPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                            // padding: EdgeInsets.zero,
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0)),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 12.0, bottom: 12.0),
                          child: Text(
                            'Ya',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                color: Constanst.colorWhite,
                                fontSize: 15),
                          ),
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

  void widgetButtomSheetWfhDelete() {
    showModalBottomSheet(
      context: Get.context!,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12.0),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Batalkan absen WFH",
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              color: Constanst.fgPrimary,
                              fontSize: 16),
                        ),
                        InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: const Icon(Icons.close))
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Constanst.infoLight1,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Icon(
                            Iconsax.info_circle5,
                            color: Constanst.colorPrimary,
                            size: 26,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Anda yakin ingin membatalkan absen WFH?",
                              textAlign: TextAlign.left,
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  color: Constanst.fgPrimary,
                                  fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          wfhDelete();
                          Get.back();
                          Get.offAll(InitScreen());

                          refreshPagesStatus.value = true;
                          await Future.delayed(const Duration(seconds: 2));
                          updateInformasiUser();
                          controller.employeDetaiBpjs();
                          controllerAbsensi.employeDetail();

                          controller.onInit();

                          controllerAbsensi.userShift();
                          initData();
                          Future.delayed(const Duration(milliseconds: 500), () {
                            controllerAbsensi.absenStatus.value =
                                AppData.statusAbsen;
                            authController.signinTime.value = signinTime.value;
                            authController.signoutTime.value =
                                signoutTime.value;
                            // absenControllre.absenStatus.value =
                            //     controller.dashboardStatusAbsen.value;
                          });
                          tabbController.checkuserinfo();

                          // Get.back();
                          // updateInformasiUser();

                          // initData();
                          // controllerAbsensi.getTimeNow();

                          // checkAbsenUser(
                          //     DateFormat('yyyy-MM-dd').format(DateTime.now()),
                          //     AppData.informasiUser![0].em_id);
                          // // controllerBpj.employeDetaiBpjs();

                          // controllerAbsensi.employeDetail();

                          // controllerAbsensi.absenStatus.value =
                          //     AppData.statusAbsen;
                          // authController.signinTime.value = signinTime.value;
                          // authController.signoutTime.value = signoutTime.value;
                          // Future.delayed(const Duration(milliseconds: 500), () {
                          //   initData();
                          //   controllerAbsensi.absenStatus.value =
                          //       AppData.statusAbsen;
                          //   authController.signinTime.value = signinTime.value;
                          //   authController.signoutTime.value =
                          //       signoutTime.value;
                          //   // controllerAbsensi.absenStatus.value =
                          //   //     controller.dashboardStatusAbsen.value;
                          // });

                          // // Api().checkLogin();
                          // // Add a listener to the scroll controller
                          // // _scrollController.addListener(_scrollListener);
                          // // controller.loadMenuShowInMain();
                          // // tabbController.checkuserinfo();
                          // if (controllerTracking.bagikanlokasi.value ==
                          //     "aktif") {
                          //   controllerTracking.absenSelfie();
                          // }

                          print(
                              "interval ${AppData.informasiUser![0].interval.toString()}");
                        },
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Constanst.colorWhite,
                            backgroundColor: Constanst.colorPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                            // padding: EdgeInsets.zero,
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0)),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 12.0, bottom: 12.0),
                          child: Text(
                            'Ya',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                color: Constanst.colorWhite,
                                fontSize: 15),
                          ),
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

  void wfhDelete() {
    Map<String, dynamic> body = {
      'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'nomor_ajuan': controllerAbsensi.nomorAjuan.value,
    };
    print(body);

    var dataUser = AppData.informasiUser;

    var getFullName = "${dataUser![0].full_name}";
    var convertTanggalBikinPengajuan =
        // status == false
        //     ? Constanst.convertDateSimpan(
        //         pilihTanggalTelatAbsen.value.toString())
        //     :
        controllerAbsensi.pilihTanggalTelatAbsen.value.toString();
    var getEmid = "${dataUser![0].em_id}";
    var stringTanggal =
        "${controllerAbsensi.tglAjunan.value} sd ${controllerAbsensi.tglAjunan.value}";
    var typeNotifFcm = "Pengajuan WFH";
    var now = DateTime.now();
    var convertBulan = now.month <= 9 ? "0${now.month}" : now.month;
    var getNomorAjuanTerakhir = controllerAbsensi.nomorAjuan.value;

    for (var item in globalCtr.konfirmasiAtasan) {
      print("Token notif ${item['token_notif']}");
      var pesan;
      if (item['em_gender'] == "PRIA") {
        pesan =
            "Hallo pak ${item['full_name']}, saya ${getFullName} membatalkan pengajuan Absen WFH dengan nomor ajuan ${getNomorAjuanTerakhir}";
      } else {
        pesan =
            "Hallo bu ${item['full_name']}, saya ${getFullName} membatalkan pengajuan Absen WFH dengan nomor ajuan ${getNomorAjuanTerakhir}";
      }

      controllerAbsensi.kirimNotifikasiToDelegasi1(
          getFullName,
          convertTanggalBikinPengajuan,
          item['em_id'],
          '',
          stringTanggal,
          typeNotifFcm,
          pesan,
          'Approval WFH');

      if (item['token_notif'] != null) {
        globalCtr.kirimNotifikasiFcm(
          title: typeNotifFcm,
          message: pesan,
          tokens: item['token_notif'],
        );
      }
    }

    var connect = Api.connectionApi("post", body, "wfh-delete");

    connect.then((dynamic res) {
      print("data res ${res.statusCode}");
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        print("data valueBody ${valueBody}");
      }
    });
  }

  // Future<void> checkAbsenUser(convert, getEmid) {
  //   print("view last absen user");
  //   print("tes ${AppData.informasiUser![0].startTime.toString()}");
  //   var startTime = "";
  //   var endTime = "";
  //   var startDate = "";
  //   var endDate = "";
  //   TimeOfDay waktu1 = TimeOfDay(
  //       hour: int.parse(
  //           AppData.informasiUser![0].startTime.toString().split(':')[0]),
  //       minute: int.parse(AppData.informasiUser![0].startTime
  //           .toString()
  //           .split(':')[1]));

  //   TimeOfDay waktu2 = TimeOfDay(
  //       hour: int.parse(
  //           AppData.informasiUser![0].endTime.toString().split(':')[0]),
  //       minute: int.parse(AppData.informasiUser![0].startTime
  //           .toString()
  //           .split(':')[1])); // Waktu kedua

  //   int totalMinutes1 = waktu1.hour * 60 + waktu1.minute;
  //   int totalMinutes2 = waktu2.hour * 60 + waktu2.minute;

  //   //alur normal
  //   if (totalMinutes1 < totalMinutes2) {
  //     startTime = AppData.informasiUser![0].startTime;
  //     endTime = AppData.informasiUser![0].endTime;

  //     startDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  //     endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  //   //alur beda hari
  //   } else if (totalMinutes1 > totalMinutes2) {

  //     var waktu3 =
  //         TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
  //     int totalMinutes3 = waktu3.hour * 60 + waktu3.minute;

  //     if (totalMinutes2 > totalMinutes3) {

  //     startTime = AppData.informasiUser![0].endTime;
  //     endTime = AppData.informasiUser![0].startTime;

  //     startDate = DateFormat('yyyy-MM-dd')
  //          .format(DateTime.now().add(Duration(days: -1)));

  //       endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  //     } else {

  //       startTime = AppData.informasiUser![0].endTime;
  //       endTime = AppData.informasiUser![0].startTime;

  //       endDate = DateFormat('yyyy-MM-dd')
  //       .format(DateTime.now().add(Duration(days: 1)));

  //       startDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  //     }
  //   } else {
  //     startTime = AppData.informasiUser![0].startTime;
  //     endTime = AppData.informasiUser![0].endTime;

  //     startDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  //     endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  //     print("Waktu 1 sama dengan waktu 2");
  //   }
  //   Map<String, dynamic> body = {
  //     'atten_date': DateFormat('yyyy-MM-dd')
  //         .format(DateTime.now().add(Duration(days: -1))),
  //     'em_id': getEmid,
  //     'database': AppData.selectedDatabase,
  //     'start_date': startDate,
  //     'end_date': endDate,
  //     'start_time': startTime,
  //     'end_time': endTime,

  //   };
  //   var connect = Api.connectionApi("post", body, "view_last_absen_user");

  //   connect.then((dynamic res) {
  //     if (res.statusCode == 200) {
  //       var valueBody = jsonDecode(res.body);
  //       print("data login ${valueBody}");
  //       var data = valueBody['data'];
  //       if (data.isEmpty) {

  //         AppData.statusAbsen = false;

  //       } else {

  //             AppData.statusAbsen =
  //             data[0]['signout_time'] == "00:00:00" ? true : false;

  //       }
  //     }
  //   });
  // }

  //Future<void> checkAbsenUser(convert, getEmid) async {
  //   // Map<String, dynamic> body = {'atten_date': convert, 'em_id': getEmid};
  //   // print(body);
  //   print("view last absen user");
  //   var startTime = "";
  //   var endTime = "";

  //   var startDate = "";
  //   var endDate = "";

  //   //sekarang jam 03:00
  //   // start time 05:00
  //   //end entimenua 02:04
  //   //jika star time lebih besar dari end time maka  akan memeriksa attendance dari start time di hari sebelumya  tanggal sekarang dengan end time
  //   //

  //   TimeOfDay waktu1 = TimeOfDay(
  //       hour: int.parse(
  //           AppData.informasiUser![0].startTime.toString().split(':')[0]),
  //       minute: int.parse(AppData.informasiUser![0].startTime
  //           .toString()
  //           .split(':')[1]));

  //   // Waktu pertama
  //   TimeOfDay waktu2 = TimeOfDay(
  //       hour: int.parse(
  //           AppData.informasiUser![0].endTime.toString().split(':')[0]),
  //       minute: int.parse(AppData.informasiUser![0].startTime
  //           .toString()
  //           .split(':')[1]));

  //   // Waktu kedua
  //   int totalMinutes1 = waktu1.hour * 60 + waktu1.minute;
  //   int totalMinutes2 = waktu2.hour * 60 + waktu2.minute;
  //   if (totalMinutes1 < totalMinutes2) {
  //     startTime = AppData.informasiUser![0].startTime;
  //     endTime = AppData.informasiUser![0].endTime;

  //     startDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  //     endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  //   } else if (totalMinutes1 > totalMinutes2) {
  //     var waktu3 =
  //         TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
  //     int totalMinutes3 = waktu3.hour * 60 + waktu3.minute;

  //     if (totalMinutes2 > totalMinutes3) {
  //       startTime = AppData.informasiUser![0].endTime;
  //       endTime = AppData.informasiUser![0].startTime;
  //       startDate = DateFormat('yyyy-MM-dd')
  //           .format(DateTime.now().add(Duration(days: -1)));
  //       endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  //     } else {
  //       startTime = AppData.informasiUser![0].endTime;
  //       endTime = AppData.informasiUser![0].startTime;
  //       startDate = DateFormat('yyyy-MM-dd')
  //           .format(DateTime.now().add(Duration(days: 1)));
  //       endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  //     }
  //   } else {
  //     startTime = AppData.informasiUser![0].startTime;
  //     endTime = AppData.informasiUser![0].endTime;

  //     startDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  //     endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  //     print("Waktu 1 sama dengan waktu 2");
  //   }
  //   Map<String, dynamic> body = {
  //     'atten_date': convert,
  //     'em_id': getEmid,
  //     'database': AppData.selectedDatabase,
  //     'start_date': startDate,
  //     'end_date': endDate,
  //     'start_time': startTime,
  //     'emd_time': endTime
  //   };

  //   var connect = Api.connectionApi("post", body, "view_last_absen_user");

  //   connect.then((dynamic res) {
  //     print("status code ${res.statusCode }");
  //   if (res.statusCode == 200) {
  //     var valueBody = jsonDecode(res.body);
  //         List data = valueBody['data'];

  //   if (data.isEmpty) {
  //     AppData.statusAbsen = false;

  //      Future.delayed(Duration.zero, () {});
  //   } else {
  //         AppData.statusAbsen =
  //               data[0]['signout_time'] == "00:00:00" ? true : false;

  //     //  var tanggalTerakhirAbsen = data[0]['atten_date'];
  //     //     if (tanggalTerakhirAbsen == endDate) {
  //     //       // print("siggin time ${data[0]['sign_time']}");
  //     //       AppData.statusAbsen =
  //     //           data[0]['signout_time'] == "00:00:00" ? true : false;

  //     //     } else {
  //     //       AppData.statusAbsen = false;
  //     //     }

  //   }

  //   }
  // });
  //   // var value = await connect;
  //   // var valueBody = jsonDecode(value.body);

  //   // List data = valueBody['data'];

  //   // print('data response $valueBody');
  //   // if (data.isEmpty) {
  //   //   AppData.statusAbsen = false;

  //   //   // Future.delayed(Duration.zero, () {});
  //   // } else {
  //   //   var now = DateTime.parse(DateFormat("yyyy-MM-dd hh:mm:dd")
  //   //       .format(DateTime.parse(DateTime.now().toString())));
  //   //   var newStartDate = DateTime.parse(DateFormat('yyy-MM-dd hh:mm:ss')
  //   //       .format(DateTime.parse(startDate + " " + startTime)));
  //   //   var newEndDate = DateTime.parse(DateFormat('yyy-MM-dd hh:mm:ss')
  //   //       .format(DateTime.parse(endDate + " " + endTime)));

  //   //   if (now.isAfter(newStartDate) && now.isBefore(newEndDate)) {
  //   //     AppData.statusAbsen =
  //   //         data[0]['signout_time'] == "00:00:00" ? true : false;
  //   //   } else {
  //   //     if (totalMinutes1 < totalMinutes2) {
  //   //       var tanggalTerakhirAbsen = data[0]['atten_date'];
  //   //       if (tanggalTerakhirAbsen == convert) {
  //   //         // print("siggin time ${data[0]['sign_time']}");
  //   //         AppData.statusAbsen =
  //   //             data[0]['signout_time'] == "00:00:00" ? true : false;
  //   //       } else {
  //   //         AppData.statusAbsen = false;
  //   //       }
  //   //     } else {
  //   //       AppData.statusAbsen = false;
  //   //     }
  //   //   }
  //   // }
  //}

  //   Future<void> checkAbsenUser(convert, getEmid) async {
  //   // Map<String, dynamic> body = {'atten_date': convert, 'em_id': getEmid};
  //   // print(body);
  //   print("view last absen user");

  //   //sekarang jam 03:00
  //   // start time 05:00
  //   //end entimenua 02:04
  //   //jika star time lebih besar dari end time maka  akan memeriksa attendance dari start time di hari sebelumya  tanggal sekarang dengan end time
  //   //
  //   // TimeOfDay waktu1 = TimeOfDay(
  //   //     hour: int.parse(
  //   //         AppData.informasiUser![0].startTime.toString().split(':')[0]),
  //   //     minute: int.parse(AppData.informasiUser![0].startTime
  //   //         .toString()
  //   //         .split(':')[1])); // Waktu pertama
  //   // TimeOfDay waktu2 = TimeOfDay(
  //   //     hour: int.parse(
  //   //         AppData.informasiUser![0].endTime.toString().split(':')[0]),
  //   //     minute: int.parse(AppData.informasiUser![0].startTime
  //   //         .toString()
  //   //         .split(':')[1])); // Waktu kedua
  //   // int totalMinutes1 = waktu1.hour * 60 + waktu1.minute;
  //   // int totalMinutes2 = waktu2.hour * 60 + waktu2.minute;
  //   // if (totalMinutes1 < totalMinutes2) {
  //   //   startTime = AppData.informasiUser![0].startTime;
  //   //   endTime = AppData.informasiUser![0].endTime;

  //   //   startDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  //   //   endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  //   // } else if (totalMinutes1 > totalMinutes2) {
  //   //   var waktu3 =
  //   //       TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
  //   //   int totalMinutes3 = waktu3.hour * 60 + waktu3.minute;

  //   //   if (totalMinutes2 > totalMinutes3) {
  //   //     startTime = AppData.informasiUser![0].endTime;
  //   //     endTime = AppData.informasiUser![0].startTime;
  //   //     startDate = DateFormat('yyyy-MM-dd')
  //   //         .format(DateTime.now().add(Duration(days: -1)));
  //   //     endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  //   //   } else {
  //   //     startTime = AppData.informasiUser![0].endTime;
  //   //     endTime = AppData.informasiUser![0].startTime;
  //   //     startDate = DateFormat('yyyy-MM-dd')
  //   //         .format(DateTime.now().add(Duration(days: 1)));
  //   //     endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  //   //   }
  //   // } else {
  //   //   startTime = AppData.informasiUser![0].startTime;
  //   //   endTime = AppData.informasiUser![0].endTime;

  //   //   startDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  //   //   endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  //   //   print("Waktu 1 sama dengan waktu 2");
  //   // }
  //   Map<String, dynamic> body = {
  //     'atten_date': convert,
  //     'em_id': getEmid,
  //     'database': AppData.selectedDatabase,

  //   };

  //   print(" last absen ${body}");

  //   print("List absen usernew ");

  //   var connect = Api.connectionApi("post", body, "view_last_absen_user");

  //   connect.then((dynamic res) {
  //     print("status code ${res.statusCode }");
  //   if (res.statusCode == 200) {
  //     var valueBody = jsonDecode(res.body);
  //         List data = valueBody['data'];

  //   if (data.isEmpty) {
  //     AppData.statusAbsen = false;

  //      Future.delayed(Duration.zero, () {});
  //   } else {

  //      var tanggalTerakhirAbsen = data[0]['atten_date'];
  //         if (tanggalTerakhirAbsen == convert) {
  //           // print("siggin time ${data[0]['sign_time']}");
  //           AppData.statusAbsen =
  //               data[0]['signout_time'] == "00:00:00" ? true : false;

  //         } else {
  //           AppData.statusAbsen = false;
  //         }

  //   }

  //   }
  // });

  // }
  // conne.then((dynamic res) {
  //   if (res.statusCode == 200) {
  //     var valueBody = jsonDecode(res.body);

  //     print("value body ${valueBody}");

  //   }
  // });

  Future<bool> checkValidasipayroll({type, page}) async {
    var dataUser = AppData.informasiUser;
    var getEmid = dataUser![0].em_id;
    var desId = dataUser![0].des_id;
    UtilsAlert.showLoadingIndicator(Get.context!);

    try {
      Map<String, dynamic> body = {
        'em_id': getEmid.toString(),
        'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        "designation_id": desId,
        'type': type.toString()
      };
      print(body);

      var response = await Request(url: "validasi-payroll", body: body).post();
      var res = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Get.back();
        Get.back();
        Get.to(page);
        //  UtilsAlert.showToast(res['message']);

        return true;
      }
      if (res['em_ids'] == null ||
          res['em_ids'] == "" ||
          res['em_ids'] == "null") {
      } else {
        globalCtr.kirimNotifikasiFcm(
            title: "Approval payroll",
            message:
                "Halo pak saya mengajukan approval untuk melihat ${type == "slip_gaji" ? "Slip gaji" : ""}");
      }
      Get.back();
      Get.back();
      UtilsAlert.showToast(res['message']);
      return false;
    } catch (e) {
      UtilsAlert.showToast(e);
      return false;
      print(e.toString());
    }
  }

  Future<void> getDepartemen() async {
    controllerAbsensi.showButtonlaporan.value = false;
    print("get departement ${controllerAbsensi.showButtonlaporan.value}");
    departementAkses.value = [];
    print("get departement ");
    jumlahData.value = 0;
    var connect = Api.connectionApi("get", {}, "all_department");
    connect.then((dynamic res) {
      if (res == false) {
        // UtilsAlert.koneksiBuruk();
      } else {
        if (res.statusCode == 200) {
          var valueBody = jsonDecode(res.body);
          var dataDepartemen = valueBody['data'];

          var dataUser = AppData.informasiUser;
          var hakAkses = dataUser == null || dataUser == "null"
              ? ""
              : dataUser[0].em_hak_akses;

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
          // print("hak akses ${dataUser![0].em_hak_akses}");
          this.departementAkses.refresh();
          if (departementAkses.value.isNotEmpty) {
            print("get departement ${departementAkses} ");
            controllerAbsensi.showButtonlaporan.value = true;
          } else {
            controllerAbsensi.showButtonlaporan.value = false;
          }
        }
      }
    });
  }

  Future<void> kirimNotification({
    title,
    body,
    token,
    bulan,
    tahun,
  }) async {}

  Future<void> getUserInfo() async {
    var userTampung = AppData.informasiUser!
        .map((element) => {
              'em_id': element.em_id,
              'des_id': element.des_id,
              'dep_id': element.dep_id,
              'full_name': element.full_name,
              'em_email': element.em_email,
              'em_phone': element.em_phone,
              'em_birthday': element.em_birthday,
              'em_gender': element.em_gender,
              'em_image': element.em_image,
              'em_joining_date': element.em_joining_date,
              'em_status': element.em_status,
              'em_blood_group': element.em_blood_group,
              'posisi': element.posisi,
              'emp_jobTitle': element.emp_jobTitle,
              'emp_departmen': element.emp_departmen,
              'em_control': element.em_control,
              'emp_att_working': element.emp_att_working,
              'em_hak_akses': element.em_hak_akses,
              'branch_name': element.branchName,
              'begin_payroll': element.beginPayroll,
              'end_payroll': element.endPayroll,
              'nomor_bpjs_kesehatan': element.nomorBpjsKesehatan,
              'nomor_bpjs_tenagakerja': element.nomorBpjsTenagakerja,
              'time_in': element.timeIn,
              'time_out': element.timeOut
            })
        .toList();
    user.value = userTampung;
    this.user.refresh();
    refreshPagesStatus.value = false;
    getDepartemen();
  }

  Future<void> checkHakAkses() async {
    var dataUser = AppData.informasiUser;
    var hakAkses = dataUser![0].em_hak_akses;
    print("ini hak akses $hakAkses");
    if (hakAkses == "") {
      viewInformasiSisaKontrak.value = false;
    } else {
      viewInformasiSisaKontrak.value = true;
    }
    print('ini status sisa kontrak $viewInformasiSisaKontrak');
    this.viewInformasiSisaKontrak.refresh();
  }

  Future<void> checkStatusPermission() async {
    var statusCamera = Permission.camera.status;
    statusCamera.then((value) {
      if (value != PermissionStatus.granted) {
        widgetButtomSheetAktifCamera(type: 'loadfirst');
      } else {
        var statusLokasi = Permission.location.status;
        statusLokasi.then((value) {
          if (value != PermissionStatus.granted) {
            widgetButtomSheetAktifCamera(type: 'loadfirst');
          }
        });
      }
    });
  }

  Future<void> updateInformasiUser() async {
    controllerTracking.isLoadingDetailTracking.value = true;
    print("informasi hak akseesss");
    var dataUser = AppData.informasiUser;
    var getEmid = dataUser![0].em_id;
    var body = {'em_id': getEmid};
    var connect = Api.connectionApi("post", body, "refresh_employee");
    connect.then((dynamic res) async {
      var valueBody = jsonDecode(res.body);
      print("data refresh employee ${valueBody}");

      if (valueBody['status'] == false) {
        UtilsAlert.showToast(valueBody['message']);
        Navigator.pop(Get.context!);
      } else {
        print("data employee baru new ${valueBody['data']}");
        AppData.informasiUser = null;
        List<UserModel> getData = [];
        var isBackDateSakit = "0";
        var isBackDateIzin = "0";
        var isBackDateCuti = "0";
        var isBackDateTugasLuar = "0";
        var isBackDateDinasLuar = "0";
        var isBackDateLembur = "0";

        for (var element in valueBody['data']) {
          if (element['back_date'] == "" || element['back_date'] == null) {
          } else {
            List isBackDates = element['back_date'].toString().split(',');
            isBackDateSakit = isBackDates[0].toString();
            isBackDateIzin = isBackDates[1].toString();
            isBackDateCuti = isBackDates[2].toString();
            isBackDateTugasLuar = isBackDates[3].toString();
            isBackDateDinasLuar = isBackDates[4].toString();
            isBackDateLembur = isBackDates[5].toString();
          }
          var data = UserModel(
            isBackDateSakit: isBackDateSakit,
            isBackDateIzin: isBackDateIzin,
            isBackDateCuti: isBackDateCuti,
            isBackDateTugasLuar: isBackDateTugasLuar,
            isBackDateDinasLuar: isBackDateDinasLuar,
            isBackDateLembur: isBackDateLembur,
            em_id: element['em_id'] ?? "",
            des_id: element['des_id'] ?? 0,
            dep_id: element['dep_id'] ?? 0,
            dep_group: element['dep_group'] ?? 0,
            full_name: element['full_name'] ?? "",
            em_email: element['em_email'] ?? "",
            em_phone: element['em_phone'] ?? "",
            em_birthday: element['em_birthday'] ?? "1999-09-09",
            em_gender: element['em_gender'] ?? "",
            em_image: element['em_image'] ?? "",
            em_joining_date: element['em_joining_date'] ?? "1999-09-09",
            em_status: element['em_status'] ?? "",
            em_blood_group: element['em_blood_group'] ?? "",
            posisi: element['posisi'] ?? "",
            emp_jobTitle: element['emp_jobTitle'] ?? "",
            emp_departmen: element['emp_departmen'] ?? "",
            em_control: element['em_control'] ?? 0,
            em_control_acess: element['em_control_access'] ?? 0,
            emp_att_working: element['emp_att_working'] ?? 0,
            em_hak_akses: element['em_hak_akses'] ?? "",
            beginPayroll: element['begin_payroll'],
            endPayroll: element['end_payroll'],
            startTime: element['time_attendance'].toString().split(',')[0],
            endTime: element['time_attendance'].toString().split(',')[1],
            branchName: element['branch_name'],
            nomorBpjsKesehatan: element['nomor_bpjs_kesehatan'],
            nomorBpjsTenagakerja: element['nomor_bpjs_tenagakerja'],
            timeIn: element['time_in'],
            interval: element['interval'],
            timeOut: element['time_out'],
            interval_tracking: element['interval_tracking'],
            isViewTracking: element['is_view_tracking'],
            is_tracking: element['is_tracking'],
            tanggalBerakhirKontrak: element['tanggal_berakhir_kontrak'],
            sisaKontrak: element['sisa_kontrak'],
            sisaKontrakFormat: element['sisa_kontrak_format'],
            lamaBekerja: element['lama_bekerja'],
            lamaBekerjaFormat: element['lama_bekerja_format'],
          );
          print(element['posisi']);
          getData.add(data);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(
              "interval_tracking", element['interval_tracking'].toString());
          await prefs.setString("em_id", element['em_id'].toString());
          await prefs.setString("", element['em_id'].toString());

          print("interval tracking ${element['interval_tracking'].toString()}");
        }
        AppData.informasiUser = getData;

        getUserInfo();

        controllerTracking.isLoadingDetailTracking.value = false;
        controllerTracking.isTracking();
      }
      //   Api().validateAuth(res.statusCode );
    });
  }

  Future<void> updateWorkTime() async {
    print("informasi hak akses work schdule");
    var dataUser = AppData.informasiUser;
    var getEmid = dataUser == null || dataUser == "null" || dataUser == ""
        ? ""
        : dataUser[0].em_id;
    var body = {
      'em_id': getEmid,
      'date': DateFormat('yyyy-MM-dd').format(DateTime.now())
    };
    var connect = Api.connectionApi("post", body, "work-schedule");
    connect.then((dynamic res) {
      var valueBody = jsonDecode(res.body);
      print("data error wrok ${valueBody}");
      print("data body ${body}");

      if (valueBody['status'] == false) {
        // Navigator.pop(Get.context!);
      } else {
        print("data work time ${valueBody['data']}");
        timeIn.value = valueBody['data']['time_in'];
        timeOut.value = valueBody['data']['time_out'];
      }
      //   Api().validateAuth(res.statusCode );
    });
  }

  Future<void> getMenuDashboard() async {
    finalMenu.clear();
    var connect = Api.connectionApi("get", {}, "getMenu");
    Future.delayed(const Duration(seconds: 1), () {
      connect.then((dynamic res) {
        if (res == false) {
          // UtilsAlert.koneksiBuruk();
          isLoading.value = false;
        } else {
          if (res.statusCode == 200) {
            var valueBody = jsonDecode(res.body);
            var temporary = valueBody['data'];
            temporary.firstWhere((element) => element['index'] == 0)['status'] =
                true;
            finalMenu.value = temporary;
            // var dataFinal = [];
            // for (var element in temporary) {
            //   var convert = [];
            //   for (var element1 in element['menu']) {
            //     convert.add(element1);
            //   }
            //   if (convert.length > 3) {
            //     var lengthMenu = convert.length;
            //     var hitung = lengthMenu - 3;
            //     int howMany = hitung;
            //     convert.length = convert.length - howMany;
            //     convert.add({'nama_menu': 'Menu Lainnya', 'gambar': 'menu_lainnya.png'});
            //     var data = {
            //       'index': element['index'],
            //       'nama_modul': element['nama_modul'],
            //       'status': element['status'],
            //       'menu': convert
            //     };
            //     dataFinal.add(data);
            //   } else {
            //     var data = {
            //       'index': element['index'],
            //       'nama_modul': element['nama_modul'],
            //       'status': element['status'],
            //       'menu': convert
            //     };
            //     dataFinal.add(data);
            //   }
            // }
            // print(dataFinal);
          }
        }
      }).catchError((error) {
        isLoading.value = false;
      });
    });
  }

  Future<void> getSizeDevice() async {
    double width = MediaQuery.of(Get.context!).size.width;
    double height = MediaQuery.of(Get.context!).size.height;
    tinggiHp.value = height;
    if (width <= 395.0 || width <= 425.0) {
      print("kesini mobile kecil");
      deviceStatus.value = false;
      heightbanner.value = 120.0;
      heightPageView.value = 155.0;
      ratioDevice.value = 2.0;
    } else if (width >= 425.0) {
      print("kesini mobile besar");
      heightbanner.value = 200.0;
      heightPageView.value = 180.0;
      ratioDevice.value = 3.0;
      deviceStatus.value = true;
    }
  }

  Future<void> loadMenuShowInMain() async {
    if (authController.isConnected.value) {
      menuShowInMain.clear();
      var connect = Api.connectionApi("get", {}, "menu_dashboard",
          params: "&em_id=${AppData.informasiUser![0].em_id}");
      Future.delayed(const Duration(seconds: 1), () {
        connect.then((dynamic res) async {
          print("res.statusCode: ${res.statusCode}");
          if (res == false) {
            // UtilsAlert.koneksiBuruk();
          } else {
            absenControllre.showButtonlaporan.value = false;
            controllerIzin.showButtonlaporan.value = false;
            controllerLembur.showButtonlaporan.value = false;

            controllerTugasLuar.showButtonlaporan.value = false;
            controllerKlaim.showButtonlaporan.value = false;
            controllerCuti.showButtonlaporan.value = false;

            if (res.statusCode == 200) {
              var valueBody = jsonDecode(res.body);
              var temporary = valueBody['data'];

              List tempData = temporary;

              print("data temporary ${temporary}");

              List<Map<String, dynamic>> menus = [];

              for (var element in tempData[0]['menu']) {
                print("Nama Menu ${element['nama']}");

                // menyimpan ke sqlite
                menus.add({
                  'id': element['id'],
                  'nama': element['nama'],
                  'url': element['url'],
                  'gambar': element['gambar'],
                  'status': element['status'],
                });

                if (element['nama'] == "Absensi") {
                  absenControllre.showButtonlaporan.value = true;
                }

                if (element['nama'].toString().trim() == "Izin") {
                  print("masuk sini ${element['nama'].toString().trim()}");
                  controllerIzin.showButtonlaporan.value = true;
                }

                if (element['nama'] == "Lembur") {
                  controllerLembur.showButtonlaporan.value = true;
                }
                if (element['nama'] == "Cuti") {
                  controllerCuti.showButtonlaporan.value = true;
                }
                if (element['nama'] == "Tugas Luar") {
                  controllerTugasLuar.showButtonlaporan.value = true;
                }
                if (element['nama'] == "Klaim") {
                  controllerKlaim.showButtonlaporan.value = true;
                }
              }

              SqliteDatabaseHelper().insertMenus(menus);

              menuShowInMain.value = menus;
              menuShowInMainNew.value = temporary;
            }
          }
        }).catchError((error) async {
          menuShowInMain.clear();
          absenControllre.showButtonlaporan.value = false;
          controllerIzin.showButtonlaporan.value = false;
          controllerLembur.showButtonlaporan.value = false;

          controllerTugasLuar.showButtonlaporan.value = false;
          controllerKlaim.showButtonlaporan.value = false;
          controllerCuti.showButtonlaporan.value = false;

          var menusUtama = await SqliteDatabaseHelper().getMenus();

          for (var element in menusUtama) {
            print("Nama Menu ${element['nama']}");

            if (element['nama'] == "Absensi") {
              absenControllre.showButtonlaporan.value = true;
            }

            if (element['nama'].toString().trim() == "Izin") {
              print("masuk sini ${element['nama'].toString().trim()}");
              controllerIzin.showButtonlaporan.value = true;
            }

            if (element['nama'] == "Lembur") {
              controllerLembur.showButtonlaporan.value = true;
            }
            if (element['nama'] == "Cuti") {
              controllerCuti.showButtonlaporan.value = true;
            }
            if (element['nama'] == "Tugas Luar") {
              controllerTugasLuar.showButtonlaporan.value = true;
            }
            if (element['nama'] == "Klaim") {
              controllerKlaim.showButtonlaporan.value = true;
            }
          }
          menuShowInMain.value = menusUtama;
        });
      });
    } else {
      menuShowInMain.clear();
      absenControllre.showButtonlaporan.value = false;
      controllerIzin.showButtonlaporan.value = false;
      controllerLembur.showButtonlaporan.value = false;

      controllerTugasLuar.showButtonlaporan.value = false;
      controllerKlaim.showButtonlaporan.value = false;
      controllerCuti.showButtonlaporan.value = false;

      var menusUtama = await SqliteDatabaseHelper().getMenus();

      for (var element in menusUtama) {
        print("Nama Menu ${element['nama']}");

        if (element['nama'] == "Absensi") {
          absenControllre.showButtonlaporan.value = true;
        }

        if (element['nama'].toString().trim() == "Izin") {
          print("masuk sini ${element['nama'].toString().trim()}");
          controllerIzin.showButtonlaporan.value = true;
        }

        if (element['nama'] == "Lembur") {
          controllerLembur.showButtonlaporan.value = true;
        }
        if (element['nama'] == "Cuti") {
          controllerCuti.showButtonlaporan.value = true;
        }
        if (element['nama'] == "Tugas Luar") {
          controllerTugasLuar.showButtonlaporan.value = true;
        }
        if (element['nama'] == "Klaim") {
          controllerKlaim.showButtonlaporan.value = true;
        }
      }
      menuShowInMain.value = menusUtama;
    }
  }

  Future<void> loadMenuShowInMainUtama() async {
    if (authController.isConnected.value) {
      showPengumuman.value = false;
      showPkwt.value = false;
      showUlangTahun.value = false;
      showLaporan.value = false;
      // menuShowInMain.value.clear();
      var connect = Api.connectionApi("get", {}, "menu_dashboard_utama",
          params: "&em_id=${AppData.informasiUser![0].em_id}");
      Future.delayed(const Duration(seconds: 1), () {
        connect.then((dynamic res) async {
          if (res == false) {
            // UtilsAlert.koneksiBuruk();
          } else {
            if (res.statusCode == 200) {
              var valueBody = jsonDecode(res.body);

              var temporary = valueBody['data'];

              List<Map<String, dynamic>> menusUtama = [];
              for (var element in temporary) {
                menusUtama.add({
                  'id': element['id'],
                  'nama': element['nama'],
                  'url': element['url'],
                  'gambar': element['gambar'],
                  'status': element['status'],
                });
              }
              SqliteDatabaseHelper().insertMenusUtama(menusUtama);

              menuShowInMainUtama.value = menusUtama;

              if (menuShowInMainUtama.isNotEmpty) {
                List menuPengumuman = menuShowInMainUtama
                    .where((p0) =>
                        p0['url'].toString().toLowerCase().trim() ==
                        "InfoHrd".toLowerCase().toString().trim())
                    .toList();
                List menuPkwt = menuShowInMainUtama
                    .where((p0) =>
                        p0['url'].toString().toLowerCase().trim() ==
                        "PKWT".toLowerCase().toString().trim())
                    .toList();
                List menuUlangtahun = menuShowInMainUtama
                    .where((p0) =>
                        p0['url'].toString().toLowerCase().trim() ==
                        "UlangTahun".toLowerCase().toString().trim())
                    .toList();
                List menuLaporan = menuShowInMainUtama
                    .where((p0) =>
                        p0['url'].toString().toLowerCase().trim() ==
                        "Laporan".toLowerCase().toString().trim())
                    .toList();

                if (menuPengumuman.isNotEmpty) {
                  showPengumuman.value = true;
                }
                if (menuPkwt.isNotEmpty) {
                  showPkwt.value = true;
                }
                if (menuUlangtahun.isNotEmpty) {
                  showUlangTahun.value = true;
                }
                if (menuLaporan.isNotEmpty) {
                  showLaporan.value = true;
                }
              }
            }
          }
        }).catchError(
          (error) async {
            var menusUtama = await SqliteDatabaseHelper().getMenusUtama();
            menuShowInMainUtama.value = menusUtama;

            print("mehehe: ${menuShowInMainUtama.value}");

            if (menuShowInMainUtama.isNotEmpty) {
              List menuPengumuman = menuShowInMainUtama
                  .where((p0) =>
                      p0['url'].toString().toLowerCase().trim() ==
                      "InfoHrd".toLowerCase().toString().trim())
                  .toList();
              List menuPkwt = menuShowInMainUtama
                  .where((p0) =>
                      p0['url'].toString().toLowerCase().trim() ==
                      "PKWT".toLowerCase().toString().trim())
                  .toList();
              List menuUlangtahun = menuShowInMainUtama
                  .where((p0) =>
                      p0['url'].toString().toLowerCase().trim() ==
                      "UlangTahun".toLowerCase().toString().trim())
                  .toList();
              List menuLaporan = menuShowInMainUtama
                  .where((p0) =>
                      p0['url'].toString().toLowerCase().trim() ==
                      "Laporan".toLowerCase().toString().trim())
                  .toList();

              if (menuPengumuman.isNotEmpty) {
                showPengumuman.value = true;
              }
              if (menuPkwt.isNotEmpty) {
                showPkwt.value = true;
              }
              if (menuUlangtahun.isNotEmpty) {
                showUlangTahun.value = true;
              }
              if (menuLaporan.isNotEmpty) {
                showLaporan.value = true;
              }
            }
          },
        );
      });
    } else {
      // menuShowInMain.value.clear();
      var menusUtama = await SqliteDatabaseHelper().getMenusUtama();
      menuShowInMainUtama.value = menusUtama;

      print("mehehe: ${menuShowInMainUtama.value}");

      if (menuShowInMainUtama.isNotEmpty) {
        List menuPengumuman = menuShowInMainUtama
            .where((p0) =>
                p0['url'].toString().toLowerCase().trim() ==
                "InfoHrd".toLowerCase().toString().trim())
            .toList();
        List menuPkwt = menuShowInMainUtama
            .where((p0) =>
                p0['url'].toString().toLowerCase().trim() ==
                "PKWT".toLowerCase().toString().trim())
            .toList();
        List menuUlangtahun = menuShowInMainUtama
            .where((p0) =>
                p0['url'].toString().toLowerCase().trim() ==
                "UlangTahun".toLowerCase().toString().trim())
            .toList();
        List menuLaporan = menuShowInMainUtama
            .where((p0) =>
                p0['url'].toString().toLowerCase().trim() ==
                "Laporan".toLowerCase().toString().trim())
            .toList();

        if (menuPengumuman.isNotEmpty) {
          showPengumuman.value = true;
        }
        if (menuPkwt.isNotEmpty) {
          showPkwt.value = true;
        }
        if (menuUlangtahun.isNotEmpty) {
          showUlangTahun.value = true;
        }
        if (menuLaporan.isNotEmpty) {
          showLaporan.value = true;
        }
      }
    }
  }

  Future<void> getInformasiDashboard() async {
    print("masuk sini");
    var connect = Api.connectionApi("get", {}, "notice");
    Future.delayed(const Duration(seconds: 1), () {
      connect.then((dynamic res) {
        print("masuk sini 1");

        if (res == false) {
          // UtilsAlert.koneksiBuruk();
        } else {
          if (res.statusCode == 200) {
            var valueBody = jsonDecode(res.body);
            var data = valueBody['data'];
            print("data informasi ${data}");
            var filter1 = [];
            var dt = DateTime.now();
            for (var element in data) {
              DateTime dt2 = DateTime.parse("${element['end_date']}");
              if (dt2.isBefore(dt)) {
              } else {
                filter1.add(element);
              }
            }
            filter1.sort((a, b) => b['begin_date']
                .toUpperCase()
                .compareTo(a['begin_date'].toUpperCase()));
            informasiDashboard.value = filter1;
            getEmployeeUltah(dt);
          }
        }
      });
    });
  }

  Future<void> getEmployeeUltah(dt) async {
    employeeUltah.clear();
    print("ulang tahun ${dt}");
    var tanggal =
        "${DateFormat('yyyy-MM-dd').format(DateTime.parse(dt.toString()))}";
    Map<String, dynamic> body = {
      'dateNow': tanggal,
    };
    var connect = Api.connectionApi("post", body, "informasi_employee_ultah");
    Future.delayed(const Duration(seconds: 1), () {
      connect.then((dynamic res) {
        if (res.statusCode == 200) {
          var valueBody = jsonDecode(res.body);
          employeeUltah.value = valueBody['data'];
          print("data ualgn tahun ${employeeUltah.length}");
          this.employeeUltah.refresh();
        }
      });
    });
  }

  Future<void> getEmployeeBelumAbsen() async {
    var dt = DateTime.now();
    var tanggal = "${DateFormat('yyyy-MM-dd').format(dt)}";
    Map<String, dynamic> body = {'atten_date': tanggal, 'status': "0"};
    var connect = Api.connectionApi("post", body, "load_laporan_belum_absen");
    Future.delayed(const Duration(seconds: 1), () {
      connect.then((dynamic res) {
        if (res.statusCode == 200) {
          var valueBody = jsonDecode(res.body);
          List data = valueBody['data'];
          print("data pengajuan" + valueBody['data_pengajuan1'].toString());
          data.addAll(valueBody['data_pengajuan1']);
          data.addAll(valueBody['data_pengajuan2']);
          data.sort((a, b) => a['full_name']
              .toUpperCase()
              .compareTo(b['full_name'].toUpperCase()));

          employeeTidakHadir.value = data;
          print("data tidak hadir ${employeeTidakHadir}");
          final ids = employeeTidakHadir.map((e) => e['em_id']).toSet();
          employeeTidakHadir.retainWhere((x) => ids.remove(x['em_id']));

          this.employeeTidakHadir.refresh();
        }
      });
    });
  }

  // Future<void> getMenuDashboard() {
  //   print("jalan 1");
  //   var connect = Api.connectionApi("get", {}, "menu_dashboard");
  //   connect.then((dynamic res) {
  //     if (res == false) {
  //       UtilsAlert.koneksiBuruk();
  //     } else {
  //       if (res.statusCode == 200) {
  //         var valueBody = jsonDecode(res.body);
  //         List<MenuDashboardModel> getData = [];
  //         for (var element in valueBody['data']) {
  //           var data = MenuDashboardModel(
  //               gambar: element['gambar'], title: element['title']);
  //           getData.add(data);
  //         }
  //         menuDashboard.value = getData;
  //         this.menuDashboard.refresh();
  //       }
  //     }
  //   });
  // }

  Future<void> getBannerDashboard() async {
    if (authController.isConnected.value) {
      bannerDashboard.clear();
      // var connect = Api.connectionApi("get", {}, "banner_dashboard");
      var connect = Api.connectionApi("get", {}, "banner_from_finance");
      Future.delayed(const Duration(seconds: 1), () {
        connect.then((dynamic res) async {
          if (res == false) {
            // UtilsAlert.koneksiBuruk();
            bannerDashboard.clear();
            var banners = await SqliteDatabaseHelper().getBanners();
            bannerDashboard.value = banners;
            print(" banner :${bannerDashboard.value}");
            bannerDashboard.refresh();
          } else {
            if (res.statusCode == 200) {
              var valueBody = jsonDecode(res.body);

              var banners = List<Map<String, dynamic>>.from(
                  valueBody['data'].map((banner) => {
                        'id': banner['id'],
                        'img': banner['img'],
                      }));

              SqliteDatabaseHelper().insertBanners(banners);

              bannerDashboard.value = banners;
              bannerDashboard.refresh();
            }
          }
        }).catchError((error) async {
          bannerDashboard.clear();
          var banners = await SqliteDatabaseHelper().getBanners();
          bannerDashboard.value = banners;
          bannerDashboard.refresh();
        });
      });
    } else {
      bannerDashboard.clear();
      var banners = await SqliteDatabaseHelper().getBanners();
      bannerDashboard.value = banners;
      print(" banner :${bannerDashboard.value}");
      bannerDashboard.refresh();
    }
  }

  Future<void> _getTime() async {
    // DateTime startDate = await NTP.now();
    DateTime startDate = DateTime.now();
    final DateTime now = startDate;
    final String formattedDateTime = formatDateTime(now);
    timeString.value = formattedDateTime;
  }

  String formatDateTime(DateTime dateTime) {
    return DateFormat('HH:mm:ss').format(dateTime);
  }

  String dateNoww(DateTime dateTime) {
    var hari = DateFormat('EEEE').format(dateTime);
    var convertHari = Constanst.hariIndo(hari);
    var tanggal = DateFormat('dd MMMM yyyy').format(dateTime);
    return "$convertHari, $tanggal";
  }

  bool validasiAbsenMasukUser() {
    return AppData.informasiUser![0].emp_att_working == 0 ? true : false;
  }

  Future<bool> radiusNotOpen() async {
    UtilsAlert.showLoadingIndicator(Get.context!);
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var latUser = position.latitude;
    var langUser = position.longitude;
    // print(latUser);
    // var latUser = -6.1716917;
    // var langUser = 106.7305503;

    var from = Point(latUser, langUser);

    var settingInformation = AppData.infoSettingApp;
    print("setting ${settingInformation![0].longlat_comp}");

    var stringLatLang = settingInformation![0].longlat_comp;

    var defaultRadius = " ${settingInformation[0].radius}";
    print(stringLatLang.toString());

    var listLatLang = (stringLatLang!.split(','));
    var latDefault = listLatLang[0];
    var langDefault = listLatLang[1];
    var to = Point(double.parse(latDefault), double.parse(langDefault));

    num distance = maps.SphericalUtils.computeDistanceBetween(from, from);
    print('Distance: $distance meters');
    var filter = double.parse((distance).toStringAsFixed(0));
    if (filter <= double.parse(defaultRadius)) {
      Navigator.pop(Get.context!);
      UtilsAlert.showToast("Silahkan absen");
      return true;
    } else {
      Navigator.pop(Get.context!);
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
            child: CustomDialog(
              title: "Info",
              content:
                  "Jarak radius untuk melakukan absen adalah $defaultRadius m",
              positiveBtnText: "",
              negativeBtnText: "OK",
              style: 2,
              buttonStatus: 2,
              positiveBtnPressed: () {},
            ),
          );
        },
        pageBuilder: (BuildContext context, Animation animation,
            Animation secondaryAnimation) {
          return null!;
        },
      );
      return false;
    }
  }

  Future<void> changePageModul(page) async {
    selectedPageView.value = page;
    for (var element in menuShowInMain.value) {
      if (element['index'] == page) {
        element['status'] = true;
      } else {
        element['status'] = false;
      }
    }
    bool checkMenu = checkJumlahMenu(page);
    if (checkMenu) {
      if (deviceStatus.value == false) {
        heightPageView.value = 155.0;
      } else {
        heightPageView.value = 180.0;
      }
    } else {
      if (deviceStatus.value == false) {
        heightPageView.value = 90.0;
      } else {
        heightPageView.value = 90.0;
      }
    }
    // menuController.animateToPage(page,
    //     duration: const Duration(milliseconds: 300), curve: Curves.decelerate);
    menuController.jumpToPage(page);
    this.menuShowInMain.refresh();
    this.heightPageView.refresh();
  }

  bool checkJumlahMenu(page) {
    bool? status;
    menuShowInMain.forEach((element) {
      if (element['index'] == page) {
        var hitung = element['menu'].length;
        if (hitung > 4) {
          status = true;
        } else {
          status = false;
        }
      }
    });
    return status!;
  }

  void routePageDashboard(url, arguments) {
    print(url);
    if (url == "HistoryAbsen") {
      Get.to(HistoryAbsen(), arguments: arguments);
    } else if (url == "TidakMasukKerja") {
      Get.to(RiwayatIzin(), arguments: arguments);
    } else if (url == "Lembur") {
      Get.to(Lembur(), arguments: arguments);
    } else if (url == "FormPengajuanCuti") {
      Get.to(FormPengajuanCuti(
        dataForm: [[], false],
      ));
    } else if (url == "RiwayatCuti") {
      Get.to(RiwayatCuti(), arguments: arguments);
      // } else if (url == "Izin") {
      //   Get.to(Izin(), arguments: arguments);
    } else if (url == "TugasLuar") {
      Get.to(TugasLuar(), arguments: arguments);
    } else if (url == "Klaim") {
      Get.to(Klaim(), arguments: arguments);
    } else if (url == "Kasbon") {
      Get.to(Kasbon(), arguments: arguments);
    } else if (url == "FormKlaim") {
      Get.to(FormKlaim(
        dataForm: [[], false],
      ));
    } else if (url == "Kandidat") {
      var dataUser = AppData.informasiUser;
      var getHakAkses = dataUser![0].em_hak_akses;
      if (getHakAkses == "" || getHakAkses == null || getHakAkses == "null") {
        UtilsAlert.showToast('Maaf anda tidak memiliki akses menu ini');
      } else {
        Get.to(Kandidat());
      }
    } else if (url == "SlipGaji") {
      //  Get.to(PPh21page());

      Get.to(VerifyPasswordPayroll(
        page: const SlipGaji(),
        titlepage: "slip_gaji",
      ));
      // Get.to(VerifyPasswordPayroll(
      //   page: SlipGaji(),
      //   titlepage: "slip_gaji",
      // ));
    } else if (url == "Pph21") {
      //  Get.to(PPh21page());
      Get.to(const PPh21page());

      // Get.to(VerifyPasswordPayroll(
      //     page: PPh21page(),
      //     titlepage: "pph21",
      //   ));
      // Get.to(VerifyPasswordPayroll(
      //   page: SlipGaji(),
      //   titlepage: "slip_gaji",
      // ));
    } else if (url == "BpjsKesehatan") {
      if (AppData.informasiUser![0].nomorBpjsKesehatan == "" ||
          AppData.informasiUser![0].nomorBpjsKesehatan == null) {
        UtilsAlert.showToast(
            "Nomor BPJS anda belum tersedia,harap hubungi HRD");
      } else {
        Get.to(BpjsKesehatan());
        // Get.to(VerifyPasswordPayroll(
        //   page: BpjsKesehatan(),
        //   titlepage: "bpjs_kesehatan",
        // ));
      }
    } else if (url == "BpjsTenagaKerja") {
      if (AppData.informasiUser![0].nomorBpjsTenagakerja == "" ||
          AppData.informasiUser![0].nomorBpjsTenagakerja == null) {
        UtilsAlert.showToast("\ anda belum tersedia,harap hubungi HRD");
      } else {
        Get.to(BpjsKetenagakerjaan());

        // Get.to(VerifyPasswordPayroll(
        //   page: BpjsKetenagakerjaan(),
        //   titlepage: "bpjs_ketenagakerjaan",
        // ));
      }
    } else if (url == "lainnya") {
      widgetButtomSheetMenuLebihDetail();
    } else {
      UtilsAlert.showToast("Tahap Development");
    }
  }

  void routeSortcartForm(id) {
    if (id == 1) {
      Get.to(FormLembur(
        dataForm: [[], false],
      ));
    } else if (id == 2) {
      Get.to(FormPengajuanCuti(
        dataForm: [[], false],
      ));
    } else if (id == 3) {
      Get.to(FormTugasLuar(
        dataForm: [[], false],
      ));
    } else if (id == 4) {
      controllerIzin.changeTypeSelected(controllerIzin.selectedType.value);
      Get.to(FormPengajuanIzin(
        dataForm: [[], false],
      ));
    } else if (id == 5) {
      Get.to(FormKlaim(
        dataForm: [[], false],
      ));
    } else if (id == 6) {
      var dataUser = AppData.informasiUser;
      var getHakAkses = dataUser![0].em_hak_akses;
      if (getHakAkses == "" || getHakAkses == null || getHakAkses == "null") {
        UtilsAlert.showToast('Maaf anda tidak memiliki akses menu ini');
      } else {
        Get.to(FormKandidat(
          dataForm: [[], false],
        ));
      }
    } else {
      UtilsAlert.showToast("Tahap Development");
    }
  }

  void routeSortcartFormLaporan(id) {
    if (id == 1) {
      Get.to(LaporanLembur(
        title: 'lembur',
      ));
    } else if (id == 2) {
      Get.to(LaporanCuti(
        title: 'cuti',
      ));
    } else if (id == 3) {
      Get.to(LaporanTugasLuar(
        title: 'tugas_luar',
      ));
    } else if (id == 4) {
      Get.to(LaporanIzin(
        title: 'izin',
      ));
    } else if (id == 5) {
      Get.to(LaporanKlaim(
        title: 'klaim',
      ));
    } else if (id == 6) {
      var dataUser = AppData.informasiUser;
      var getHakAkses = dataUser![0].em_hak_akses;
      if (getHakAkses == "" || getHakAkses == null || getHakAkses == "null") {
        UtilsAlert.showToast('Maaf anda tidak memiliki akses menu ini');
      } else {
        Get.to(LaporanTugasLuar(
          title: 'tugas_luar',
        ));
      }
    } else {
      UtilsAlert.showToast("Tahap Development");
    }
  }

  void widgetButtomSheetAktifCamera({type, typewfh}) {
    showModalBottomSheet(
      context: Get.context!,
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
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            type == "checkTracking"
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5),
                                    child:
                                        Image.asset("assets/vector_camera.png"),
                                  ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: Image.asset("assets/vector_map.png"),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        type == "checkTracking"
                            ? const SizedBox(
                                child: Column(
                                  children: [
                                    Text(
                                      "Aktifkan Lokasi",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Text(
                                      "Di latar belakang",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              )
                            : const Text(
                                "Aktifkan Kamera dan Lokasi",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                        const SizedBox(
                          height: 15,
                        ),
                        type == "checkTracking"
                            ? const Text(
                                "SISCOM HRIS mengumpulkan data lokasi untuk mengaktifkan Absensi & Tracking bahkan jika aplikasi ditutup atau tidak digunakan.",
                                textAlign: TextAlign.center,
                              )
                            : const Text(
                                "Aplikasi ini memerlukan akses pada kamera dan lokasi pada perangkat Anda",
                                textAlign: TextAlign.center,
                              ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextButtonWidget(
                          title: "Lanjutkan",
                          onTap: () async {
                            if (type == "checkTracking") {
                              print('kesini');
                              Get.back();
                              await controllerAbsensi.deteksiFakeGps(context);
                              if (controllerAbsensi.statusDeteksi.value ==
                                      false &&
                                  controllerAbsensi.statusDeteksi2.value ==
                                      false) {
                                if (authController.isConnected.value &&
                                    !absenControllre.coordinate.value) {
                                  controllerAbsensi.kirimDataAbsensi(
                                      typewfh: typewfh);
                                } else {
                                  controllerAbsensi.kirimDataAbsensiOffline(
                                      typewfh: typewfh);
                                }
                              } else if (controllerAbsensi
                                          .statusDeteksi.value ==
                                      false &&
                                  controllerAbsensi.statusDeteksi2.value ==
                                      true) {
                                if (context.mounted) {
                                  popUpRefresh(context);
                                }
                              }
                            } else if (type == "offlineAbsensi") {
                              // print("kesini dong");
                              Get.back();
                              await controllerAbsensi.deteksiFakeGps(context);
                              if (controllerAbsensi.statusDeteksi.value ==
                                      false &&
                                  controllerAbsensi.statusDeteksi2.value ==
                                      false) {
                                controllerAbsensi.kirimDataAbsensiOffline(
                                    typewfh: typewfh);
                              } else if (controllerAbsensi
                                          .statusDeteksi.value ==
                                      false &&
                                  controllerAbsensi.statusDeteksi2.value ==
                                      true) {
                                if (context.mounted) {
                                  popUpRefresh(context);
                                }
                              }
                            } else {
                              Navigator.pop(context);
                              await Permission.camera.request();
                              await Permission.location.request();
                            }
                          },
                          colorButton: Constanst.colorButton1,
                          colortext: Constanst.colorWhite,
                          border: BorderRadius.circular(15.0),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            )
          ],
        );
      },
    );
  }

  void widgetButtomSheetWfh() {
    showModalBottomSheet(
      context: Get.context!,
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
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: Image.asset("assets/vector_map.png"),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Tipe lokasi ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "Anda memilih tipe lokasi WFH",
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        TextButtonWidget(
                          title: "Lanjutkan",
                          onTap: () async {
                            widgetButtomSheetAktifCamera(
                                type: 'checkTracking', typewfh: 'wfh');
                          },
                          colorButton: Constanst.colorButton1,
                          colortext: Constanst.colorWhite,
                          border: BorderRadius.circular(15.0),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            )
          ],
        );
      },
    );
  }

  void widgetButtomSheetFormPengajuan() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      backgroundColor: Constanst.colorWhite,
      builder: (context) {
        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.add_square5,
                          color: Constanst.infoLight,
                          size: 26,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(
                            "Buat Pengajuan",
                            style: GoogleFonts.inter(
                                color: Constanst.fgPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pop(Get.context!);
                        },
                        child: Icon(
                          Icons.close,
                          size: 24,
                          color: Constanst.fgSecondary,
                        ))
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Divider(
                  height: 0,
                  thickness: 1,
                  color: Constanst.fgBorder,
                ),
              ),
              ListView.builder(
                  itemCount: sortcardPengajuan.length,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    var id = sortcardPengajuan[index]['id'];
                    var gambar = sortcardPengajuan[index]['gambar'];
                    return InkWell(
                      // highlightColor: Colors.white,
                      onTap: () {
                        Get.back();
                        routeSortcartForm(id);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 12, bottom: 12, left: 16, right: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  id == 1
                                      ? 'assets/4_lembur.svg'
                                      : id == 2
                                          ? 'assets/5_cuti.svg'
                                          : id == 3
                                              ? 'assets/6_tugas_luar.svg'
                                              : id == 4
                                                  ? 'assets/3_izin.svg'
                                                  : id == 5
                                                      ? 'assets/7_klaim.svg'
                                                      : id == 6
                                                          ? 'assets/8_kandidat.svg'
                                                          : 'assets/2_absen.svg',
                                  height: 35,
                                  width: 35,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: Text(
                                    sortcardPengajuan[index]['nama_pengajuan'],
                                    style: GoogleFonts.inter(
                                        color: Constanst.fgPrimary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Icon(
                                Icons.add,
                                size: 18,
                                color: Constanst.infoLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ],
          ),
        );
      },
    );
  }

  void widgetButtomSheetFormLaporan() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      backgroundColor: Constanst.colorWhite,
      builder: (context) {
        return Obx(
          () => SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Iconsax.document_text5,
                            color: Constanst.infoLight,
                            size: 26,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Text(
                              "Cek Laporan",
                              style: GoogleFonts.inter(
                                  color: Constanst.fgPrimary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.pop(Get.context!);
                          },
                          child: Icon(
                            Icons.close,
                            size: 24,
                            color: Constanst.fgSecondary,
                          ))
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Divider(
                    height: 0,
                    thickness: 1,
                    color: Constanst.fgBorder,
                  ),
                ),
                controllerAbsensi.showButtonlaporan.value == false
                    ? const SizedBox()
                    : InkWell(
                        // highlightColor: Colors.white,
                        onTap: () {
                          Get.back();
                          Get.to(LaporanAbsen(
                            dataForm: "",
                          ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 12, bottom: 12, left: 16, right: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/2_absen.svg',
                                    height: 35,
                                    width: 35,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: Text(
                                      'Laporan Absensi',
                                      style: GoogleFonts.inter(
                                          color: Constanst.fgPrimary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 18,
                                  color: Constanst.fgSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                controllerIzin.showButtonlaporan.value == false
                    ? const SizedBox()
                    : InkWell(
                        // highlightColor: Colors.white,
                        onTap: () {
                          Get.back();
                          Get.to(LaporanIzin(
                            title: 'tidak_hadir',
                          ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 12, bottom: 12, left: 16, right: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/3_izin.svg',
                                    height: 35,
                                    width: 35,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: Text(
                                      'Laporan Izin',
                                      style: GoogleFonts.inter(
                                          color: Constanst.fgPrimary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 18,
                                  color: Constanst.fgSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                controllerLembur.showButtonlaporan.value == false
                    ? const SizedBox()
                    : InkWell(
                        // highlightColor: Colors.white,
                        onTap: () {
                          Get.back();
                          Get.to(LaporanLembur(
                            title: 'lembur',
                          ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 12, bottom: 12, left: 16, right: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/4_lembur.svg',
                                    height: 35,
                                    width: 35,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: Text(
                                      'Laporan Lembur',
                                      style: GoogleFonts.inter(
                                          color: Constanst.fgPrimary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 18,
                                  color: Constanst.fgSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                controllerCuti.showButtonlaporan.value == false
                    ? const SizedBox()
                    : InkWell(
                        // highlightColor: Colors.white,
                        onTap: () {
                          Get.back();
                          Get.to(LaporanCuti(
                            title: 'cuti',
                          ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 12, bottom: 12, left: 16, right: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/5_cuti.svg',
                                    height: 35,
                                    width: 35,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: Text(
                                      'Laporan Cuti',
                                      style: GoogleFonts.inter(
                                          color: Constanst.fgPrimary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 18,
                                  color: Constanst.fgSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                controllerTugasLuar.showButtonlaporan.value == false
                    ? const SizedBox()
                    : InkWell(
                        // highlightColor: Colors.white,
                        onTap: () {
                          Get.back();
                          Get.to(LaporanTugasLuar(
                            title: 'tugas_luar',
                          ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 12, bottom: 12, left: 16, right: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/6_tugas_luar.svg',
                                    height: 35,
                                    width: 35,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: Text(
                                      'Laporan Tugas Luar',
                                      style: GoogleFonts.inter(
                                          color: Constanst.fgPrimary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 18,
                                  color: Constanst.fgSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                controllerKlaim.showButtonlaporan.value == false
                    ? const SizedBox()
                    : InkWell(
                        // highlightColor: Colors.white,
                        onTap: () {
                          Get.back();
                          Get.to(LaporanKlaim(
                            title: 'klaim',
                          ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 12, bottom: 12, left: 16, right: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/7_klaim.svg',
                                    height: 35,
                                    width: 35,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: Text(
                                      'Laporan Klaim',
                                      style: GoogleFonts.inter(
                                          color: Constanst.fgPrimary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 18,
                                  color: Constanst.fgSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Future<void> widgetButtomSheetFormLaporan() {
  //   showModalBottomSheet(
  //     context: Get.context!,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(
  //         top: Radius.circular(16.0),
  //       ),
  //     ),
  //     backgroundColor: Constanst.colorWhite,
  //     builder: (context) {
  //       return SafeArea(
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
  //               child: Row(
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     children: [
  //                       Icon(
  //                         Iconsax.document_text5,
  //                         color: Constanst.infoLight,
  //                         size: 26,
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.only(left: 12),
  //                         child: Text(
  //                           "Cek Laporan",
  //                           style: GoogleFonts.inter(
  //                               color: Constanst.fgPrimary,
  //                               fontSize: 18,
  //                               fontWeight: FontWeight.w500),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   InkWell(
  //                       onTap: () {
  //                         Navigator.pop(Get.context!);
  //                       },
  //                       child: Icon(
  //                         Icons.close,
  //                         size: 24,
  //                         color: Constanst.fgSecondary,
  //                       ))
  //                 ],
  //               ),
  //             ),
  //             const SizedBox(height: 16),
  //             Padding(
  //               padding: const EdgeInsets.only(left: 16, right: 16),
  //               child: Divider(
  //                 height: 0,
  //                 thickness: 1,
  //                 color: Constanst.fgBorder,
  //               ),
  //             ),
  //             ListView.builder(
  //                 itemCount: sortcardPengajuan.length,
  //                 physics: const BouncingScrollPhysics(),
  //                 shrinkWrap: true,
  //                 scrollDirection: Axis.vertical,
  //                 itemBuilder: (context, index) {
  //                   var id = sortcardPengajuan[index]['id'];
  //                   var gambar = sortcardPengajuan[index]['gambar'];
  //                   return InkWell(
  //                     // highlightColor: Colors.white,
  //                     onTap: () {
  //                       Get.back();
  //                       routeSortcartFormLaporan(id);
  //                     },
  //                     child: Padding(
  //                       padding: const EdgeInsets.only(
  //                           top: 12, bottom: 12, left: 16, right: 16),
  //                       child: Row(
  //                         crossAxisAlignment: CrossAxisAlignment.center,
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [
  //                           Row(
  //                             children: [
  //                               SvgPicture.asset(
  //                                 id == 1
  //                                     ? 'assets/4_lembur.svg'
  //                                     : id == 2
  //                                         ? 'assets/5_cuti.svg'
  //                                         : id == 3
  //                                             ? 'assets/6_tugas_luar.svg'
  //                                             : id == 4
  //                                                 ? 'assets/3_izin.svg'
  //                                                 : id == 5
  //                                                     ? 'assets/7_klaim.svg'
  //                                                     : id == 6
  //                                                         ? 'assets/8_kandidat.svg'
  //                                                         : 'assets/8_kandidat.svg',
  //                                 height: 35,
  //                                 width: 35,
  //                               ),
  //                               Padding(
  //                                 padding: const EdgeInsets.only(left: 12.0),
  //                                 child: Text(
  //                                   id == 1
  //                                       ? 'Laporan Lembur'
  //                                       : id == 2
  //                                           ? 'Laporan Cuti'
  //                                           : id == 3
  //                                               ? 'Laporan Tugas Luar'
  //                                               : id == 4
  //                                                   ? 'Laporan Izin'
  //                                                   : id == 5
  //                                                       ? 'Laporan Klaim'
  //                                                       : id == 6
  //                                                           ? 'Laporan Kandidat'
  //                                                           : 'Laporan Absensi',
  //                                   style: GoogleFonts.inter(
  //                                       color: Constanst.fgPrimary,
  //                                       fontSize: 16,
  //                                       fontWeight: FontWeight.w500),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                           Padding(
  //                             padding: const EdgeInsets.only(top: 5),
  //                             child: Icon(
  //                               Icons.arrow_forward_ios_rounded,
  //                               size: 18,
  //                               color: Constanst.fgSecondary,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   );
  //                 }),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  void widgetButtomSheetMenuLebihDetail() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      backgroundColor: Constanst.colorWhite,
      builder: (context) {
        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/1_more.svg',
                          height: 26,
                          width: 26,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(
                            "Semua Menu",
                            style: GoogleFonts.inter(
                                color: Constanst.fgPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pop(Get.context!);
                        },
                        child: Icon(
                          Icons.close,
                          size: 24,
                          color: Constanst.fgSecondary,
                        ))
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Divider(
                  height: 0,
                  thickness: 1,
                  color: Constanst.fgBorder,
                ),
              ),
              const SizedBox(height: 16),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(menuShowInMainNew.length, (index) {
                  var data = menuShowInMainNew[index];
                  return data['menu'].length <= 0
                      ? const SizedBox()
                      : InkWell(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 16, right: 16),
                                child: Text(
                                  data['nama_modul'].toString(),
                                  style: GoogleFonts.inter(
                                      color: Constanst.fgPrimary,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Wrap(
                                direction: Axis.horizontal,
                                runSpacing: 16.0, // gap between lines
                                children: List.generate(data['menu'].length,
                                    (idxMenu) {
                                  var gambar = data['menu'][idxMenu]['gambar'];
                                  print(gambar);
                                  var namaMenu = data['menu'][idxMenu]['nama'];
                                  return data['menu'][idxMenu]['id'] == 8
                                      ? const SizedBox()
                                      : SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4,
                                          child: InkWell(
                                            onTap: () => routePageDashboard(
                                                data['menu'][idxMenu]['url'],
                                                null),
                                            highlightColor: Colors.white,
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  gambar != ""
                                                      ? Stack(
                                                          children: [
                                                            Container(
                                                              height: 42,
                                                              width: 42,
                                                              decoration: BoxDecoration(
                                                                  color: Constanst
                                                                      .infoLight1,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              100.0)),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                left: 8,
                                                                top: 8,
                                                              ),
                                                              child: SvgPicture
                                                                  .asset(
                                                                gambar ==
                                                                        "watch.png"
                                                                    ? 'assets/2_absen.svg'
                                                                    : gambar ==
                                                                            "tidak_masuk.png"
                                                                        ? 'assets/3_izin.svg'
                                                                        : gambar ==
                                                                                "clock.png"
                                                                            ? 'assets/4_lembur.svg'
                                                                            : gambar == "riwayat_cuti.png"
                                                                                ? 'assets/5_cuti.svg'
                                                                                : gambar == "tugas_luar.png"
                                                                                    ? 'assets/6_tugas_luar.svg'
                                                                                    : gambar == "limit_claim.png"
                                                                                        ? 'assets/7_klaim.svg'
                                                                                        : gambar == "profile_kandidat.png"
                                                                                            ? 'assets/8_kandidat.svg'
                                                                                            : gambar == "slip_gaji.png"
                                                                                                ? 'assets/9_slip_gaji.svg'
                                                                                                : gambar == "pph.png"
                                                                                                    ? 'assets/10_pph_21.svg'
                                                                                                    : gambar == "bpjstng.png"
                                                                                                        ? 'assets/11_bpjs_kes.svg'
                                                                                                        : gambar == "bpjsksh.png"
                                                                                                            ? 'assets/12_bpjs_ket.svg'
                                                                                                            : gambar == "kasbon.png"
                                                                                                                ? 'assets/13_kasbon.svg'
                                                                                                                : 'assets/12_bpjs_ket.svg',
                                                                height: 42,
                                                                width: 42,
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : Container(
                                                          color: Constanst
                                                              .colorButton1,
                                                          height: 32,
                                                          width: 32,
                                                        ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    namaMenu.length > 20
                                                        ? namaMenu.substring(
                                                                0, 20) +
                                                            '...'
                                                        : namaMenu,
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.inter(
                                                        color:
                                                            Constanst.fgPrimary,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ]),
                                          ),
                                        );
                                }),
                              ),
                              SizedBox(height: index == 0 ? 32 : 0),
                            ],
                          ),
                        );
                  //                 style
                }),
              ),
              const SizedBox(height: 16),
              // Flexible(
              //   flex: 3,
              //   child: Padding(
              //     padding: EdgeInsets.only(left: 8, right: 8),
              //     child: ListView.builder(
              //         shrinkWrap: true,
              //         scrollDirection: Axis.vertical,
              //         physics: BouncingScrollPhysics(),
              //         itemCount: finalMenu.value.length,
              //         itemBuilder: (context, index) {
              //           return Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             mainAxisAlignment: MainAxisAlignment.start,
              //             children: [
              //               Text(
              //                 finalMenu.value[index]['nama_modul'],
              //                 style: TextStyle(fontWeight: FontWeight.bold),
              //               ),
              //               SizedBox(
              //                 height: 10,
              //               ),
              //               Padding(
              //                   padding: EdgeInsets.only(left: 8, right: 8),
              //                   child: GridView.builder(
              //                       physics: NeverScrollableScrollPhysics(),
              //                       padding: EdgeInsets.all(0),
              //                       shrinkWrap: true,
              //                       itemCount:
              //                           finalMenu.value[index]['menu'].length,
              //                       scrollDirection: Axis.vertical,
              //                       gridDelegate:
              //                           SliverGridDelegateWithFixedCrossAxisCount(
              //                         crossAxisCount: 4,
              //                       ),
              //                       itemBuilder: (context, idxMenu) {
              //                         var gambar = finalMenu[index]['menu']
              //                             [idxMenu]['gambar'];
              //                         var url = finalMenu[index]['menu']
              //                             [idxMenu]['url'];
              //                         var namaMenu = finalMenu[index]['menu']
              //                             [idxMenu]['nama_menu'];
              //                         return InkWell(
              //                           onTap: () {
              //                             Navigator.pop(context);
              //                             routePageDashboard(url);
              //                           },
              //                           highlightColor: Colors.white,
              //                           child: Column(
              //                               crossAxisAlignment:
              //                                   CrossAxisAlignment.center,
              //                               children: [
              //                                 gambar != ""
              //                                     ? Container(
              //                                         decoration: BoxDecoration(
              //                                             color: Constanst
              //                                                 .colorButton2,
              //                                             borderRadius: Constanst
              //                                                 .styleBoxDecoration1
              //                                                 .borderRadius),
              //                                         child: Padding(
              //                                           padding:
              //                                               const EdgeInsets
              //                                                       .only(
              //                                                   left: 3,
              //                                                   right: 3,
              //                                                   top: 3,
              //                                                   bottom: 3),
              //                                           child:
              //                                               CachedNetworkImage(
              //                                             imageUrl:
              //                                                 Api.UrlgambarDashboard +
              //                                                     gambar,
              //                                             progressIndicatorBuilder:
              //                                                 (context, url,
              //                                                         downloadProgress) =>
              //                                                     Container(
              //                                               alignment: Alignment
              //                                                   .center,
              //                                               height: MediaQuery.of(
              //                                                           context)
              //                                                       .size
              //                                                       .height *
              //                                                   0.5,
              //                                               width:
              //                                                   MediaQuery.of(
              //                                                           context)
              //                                                       .size
              //                                                       .width,
              //                                               child: CircularProgressIndicator(
              //                                                   value: downloadProgress
              //                                                       .progress),
              //                                             ),
              //                                             fit: BoxFit.cover,
              //                                             width: 32,
              //                                             height: 32,
              //                                             color: Constanst
              //                                                 .colorPrimary,
              //                                           ),
              //                                         ),
              //                                       )
              //                                     : Container(
              //                                         color: Constanst
              //                                             .colorButton2,
              //                                         height: 32,
              //                                         width: 32,
              //                                       ),
              //                                 SizedBox(
              //                                   height: 3,
              //                                 ),
              //                                 Center(
              //                                   child: Text(
              //                                     namaMenu.length > 20
              //                                         ? namaMenu.substring(
              //                                                 0, 20) +
              //                                             '...'
              //                                         : namaMenu,
              //                                     textAlign: TextAlign.center,
              //                                     style: TextStyle(
              //                                         fontSize: 10,
              //                                         color:
              //                                             Constanst.colorText3),
              //                                   ),
              //                                 ),
              //                               ]),
              //                         );
              //                       })),
              //               Divider(
              //                 height: 5,
              //                 color: Constanst.colorText2,
              //               ),
              //               SizedBox(
              //                 height: 10,
              //               ),
              //             ],
              //           );
              //         }),
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }

  Future dashboardMenu() async {
    try {
      isLoadingMenuDashboard = true;
      UtilsAlert.showLoadingIndicator(Get.context!);
      var response = await Request(
              url: "/dashboard/menu",
              params: '&em_id=${AppData.informasiUser![0].em_id}')
          .get();
      var resp = jsonDecode(response.body);
      if (response.statusCode == 200) {
        isLoadingMenuDashboard = false;
        menus.value = MenuModel.fromJsonToList(resp['data']);
        Get.back();
        return true;
      } else {
        isLoadingMenuDashboard = false;
        menu.value = [];
        Get.back();
        return false;
      }
    } catch (e) {
      isLoadingMenuDashboard = false;
      menu.value = [];
      print(e);
      Get.back();

      return false;
    }
  }
}
