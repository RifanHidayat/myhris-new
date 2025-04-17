import 'dart:async';
import 'dart:convert';
import 'dart:io';
// import 'package:background_location_tracker/background_location_tracker.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siscom_operasional/controller/absen_controller.dart';
import 'package:siscom_operasional/controller/global_controller.dart';
import 'package:siscom_operasional/controller/tracking_controller.dart';
import 'package:siscom_operasional/database/sqlite/sqlite_database_helper.dart';
import 'package:siscom_operasional/model/database.dart';
import 'package:siscom_operasional/model/user_model.dart';
import 'package:siscom_operasional/screen/absen/camera_view_register.dart';
import 'package:siscom_operasional/screen/dashboard.dart';
import 'package:siscom_operasional/screen/init_screen.dart';
import 'package:siscom_operasional/services/request.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/custom_dialog.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';
import 'package:http/http.dart' as http;

class AuthController extends GetxController {
  var username = TextEditingController().obs;
  var password = TextEditingController().obs;
  var email = TextEditingController().obs;
  var tempEmail = TextEditingController().obs;
  var showpassword = false.obs;

  RxString signoutTime = "".obs;
  RxString signinTime = "".obs;

  var databases = <DatabaseModel>[].obs;
  var selectedDb = "".obs;
  var selectedPerusahaan = "".obs;
  var perusahaan = TextEditingController();

  var isautoLogout = false.obs;
  var messageLogout = "".obs;
  var messageNewPassword = "".obs;
 
  var controllerAbsnsi = Get.find<AbsenController>(tag: 'absen controller');
  final controllerTracking = Get.put(TrackingController());
  var globalCtr = Get.put(GlobalController());
  // var isConnected = true.obs;
  // Timer? timer;
  // var ping = 0.obs;
  // var login = false.obs;
  // var errorServer = false.obs;
  // var offiline = [].obs;
  // var datas = [].obs;
  // var kirims = false.obs;

  @override
  void onInit() {
    super.onInit();
    // checking();
  }

  @override
  void onReady() {
    print("on readty");
    email.value.text = AppData.emailUser;
    password.value.text = AppData.passwordUser;
    selectedPerusahaan.value = AppData.selectedPerusahan;
    perusahaan.text = AppData.selectedPerusahan;
    print("perusaan ${AppData.selectedPerusahan}");
    selectedDb.value = AppData.selectedDatabase;
    super.onReady();
  }

  // Future<void> checking() async {
  //   Connectivity().onConnectivityChanged.listen((result) async {
  //     print("woyyy: ${result[0].toString() == "${ConnectivityResult.none}"}");
  //     if (result[0].toString() == "${ConnectivityResult.none}") {
  //       print('Tidak ada koneksi internet');
  //       isConnected.value = false;
  //       _cancelTimer();
  //     } else {
  //       // await _checkConnection();
  //       isConnected.value = true;
  //       print('ada koneksi internet');
  //       timer = Timer.periodic(const Duration(seconds: 5), (Timer t) async {
  //         // _checkConnection();
  //         if (AppData.isLogin == true) {
  //           if (AppData.loginOffline == true) {
  //             if (AppData.emailUser != '') {
  //               await sendDataUserOflline();
  //             }
  //           }

  //           var absenMasukKeluarOffline =
  //               await SqliteDatabaseHelper().getAbsensi();
  //           print("absenMasukKeluarOffline : $absenMasukKeluarOffline");
  //           if (absenMasukKeluarOffline != null) {
  //             if (kirims.value == false) {
  //               print('kesini');
  //               sendAbsensiOffline();
  //             }
  //           }
  //         }
  //       });
  //     }
  //   });
  // }

  // Future<void> _checkConnection() async {
  //   try {
  //     final result = await InternetAddress.lookup('google.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       final stopwatch = Stopwatch()..start();
  //       final socket = await Socket.connect('google.com', 443,
  //           timeout: const Duration(seconds: 5));
  //       socket.destroy();
  //       stopwatch.stop();

  //       final ping = stopwatch.elapsedMilliseconds;

  //       if (ping > 800) {
  //         print('Koneksi internet jelek $ping');
  //         isConnected.value = false;
  //       } else {
  //         print('Koneksi internet baik $ping');
  //         isConnected.value = true;
  //         if (AppData.isLogin == true) {
  //           if (AppData.loginOffline == true) {
  //             if (AppData.emailUser != '') {
  //               await sendDataUserOflline();
  //             }
  //           }

  //           var absenMasukKeluarOffline =
  //               await SqliteDatabaseHelper().getAbsensi();
  //           print("absenMasukKeluarOffline : $absenMasukKeluarOffline");
  //           if (absenMasukKeluarOffline != null) {
  //             if (kirims.value == false) {
  //               sendAbsensiOffline();
  //             }
  //           }
  //           // }
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     print('Error saat mencoba koneksi: $e');
  //     isConnected.value = false;
  //     _cancelTimer();
  //     checking();
  //   }
  // }

  // Future<void> _checkConnection() async {
  //   // try {
  //   final response = await http.get(Uri.parse('https://www.google.com'));
  //   print(response.statusCode);

  //   if (response.statusCode == 200) {
  //     // Jika respons berhasil
  //     // final ping =
  //     //     response.contentLength;

  //     print('Koneksi internet baik');
  //     isConnected.value = true;

  //     if (AppData.isLogin == true) {
  //       if (AppData.loginOffline == true) {
  //         if (AppData.emailUser != '') {
  //           await sendDataUserOflline();
  //         }
  //       }

  //       var absenMasukKeluarOffline = await SqliteDatabaseHelper().getAbsensi();
  //       print("absenMasukKeluarOffline : $absenMasukKeluarOffline");
  //       if (absenMasukKeluarOffline != null) {
  //         if (kirims.value == false) {
  //           sendAbsensiOffline();
  //         }
  //       }
  //     }
  //   } else {
  //     // Jika status code tidak 200
  //     print('Koneksi internet jelek, status code: ${response.statusCode}');
  //     isConnected.value = false;
  //   }
  //   // }
  //   // catch (e) {
  //   //   print('Error saat mencoba koneksi: $e');
  //   //   isConnected.value = false;
  //   //   _cancelTimer();
  //   //   checking();
  //   // }
  // }

  // void _cancelTimer() {
  //   timer!.cancel();
  //   timer = null;
  // }

  // void sendAbsensiOffline() async {
  //   _cancelTimer();
  //   await checkAbsenUserOffline(DateFormat('yyyy-MM-dd').format(DateTime.now()),
  //       AppData.informasiUser![0].em_id);
  //   var absenMasukKeluarOffline = await SqliteDatabaseHelper().getAbsensi();
  //   Future.delayed(const Duration(seconds: 1), () {
  //     var body = {
  //       'em_id': absenMasukKeluarOffline!['em_id'].toString(),
  //       'atten_date': absenMasukKeluarOffline['atten_date'].toString(),
  //       'signin_time': absenMasukKeluarOffline['signing_time'].toString(),
  //       'place_in': absenMasukKeluarOffline['place_in'].toString(),
  //       'signin_longlat': absenMasukKeluarOffline['signin_longlat'].toString(),
  //       'signin_pict': absenMasukKeluarOffline['signin_pict'].toString(),
  //       'signin_note': absenMasukKeluarOffline['signin_note'].toString(),
  //       'signin_addr': absenMasukKeluarOffline['signin_addr'].toString(),
  //       'signout_time': absenMasukKeluarOffline['signout_time'].toString(),
  //       'place_out': absenMasukKeluarOffline['place_out'].toString(),
  //       'signout_longlat':
  //           absenMasukKeluarOffline['signout_longlat'].toString(),
  //       'signout_pict': absenMasukKeluarOffline['signout_pict'].toString(),
  //       'signout_note': absenMasukKeluarOffline['signout_note'].toString(),
  //       'signout_addr': absenMasukKeluarOffline['signout_addr'].toString(),
  //       'id': 19,
  //     };

  //     if ((offiline.isNotEmpty &&
  //             offiline[0]['signing_time'].toString() != "00:00:00" &&
  //             datas.isEmpty) ||
  //         ((offiline.isNotEmpty &&
  //             offiline[0]['signing_time'].toString() !=
  //                 datas[0]['signin_time'].toString()))) {
  //     } else {
  //       var connect = Api.connectionApi("post", body, "attendance-offiline");
  //       connect.then((dynamic res) {
  //         // errorServer.value = false;
  //         print(res.statusCode);
  //         if (res.statusCode == 200) {
  //           SqliteDatabaseHelper().deleteAbsensi();
  //           print("kekirim");
  //           kirims.value == true;
  //           Get.offAll(InitScreen());
  //         } else {
  //           UtilsAlert.showToast("terjadi kesalhan");
  //         }
  //       }).catchError((error) {
  //         // errorServer.value = true;
  //         // UtilsAlert.showToast("terjadi kesalhan");
  //       }).whenComplete(() {
  //         checking();
  //       });
  //     }
  //   });
  // }

  bool validateEmail(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty || !regex.hasMatch(value))
      return false;
    else
      return true;
  }

  void registrasiAkun() {
    var validasiEmail = validateEmail(email.value.text);
    if (validasiEmail) {
      UtilsAlert.showLoadingIndicator(Get.context!);
      Map<String, dynamic> body = {
        'email': email.value.text,
        'username': username.value.text,
        'password': password.value.text,
      };
      var connect = Api.connectionApi("post", body, "registrasi");
      connect.then((dynamic res) {
        if (res.statusCode == 200) {
          var valueBody = jsonDecode(res.body);
          if (valueBody['status'] == true) {
            username.value.text = "";
            email.value.text = "";
            password.value.text = "";
            UtilsAlert.showToast("Berhasil registrasi akun");
            Navigator.pop(Get.context!);
            Navigator.pop(Get.context!);
          }
          print(res.body);
        }
      });
    } else {
      UtilsAlert.showToast("Email tidak valid");
    }
  }

  Future<void> loginUser() async {
    final box = GetStorage();
    // var connectivityResult = await Connectivity().checkConnectivity();
    // var offline =
    //     (connectivityResult[0].toString() == "${ConnectivityResult.none}");

    // if (!isConnected.value) {
    //   String? savedEmail = AppData.emailUser;
    //   String? savedPassword = AppData.passwordUser;
    //   if (savedEmail == email.value.text &&
    //       savedPassword == password.value.text) {
    //     AppData.loginOffline = true;
    //     AppData.isLogin = true;
    //     fillLastLoginUserNew(
    //         AppData.informasiUser![0].em_id, AppData.informasiUser);
    //     checkAbsenUser(DateFormat('yyyy-MM-dd').format(DateTime.now()),
    //         AppData.informasiUser![0].em_id);
    //     UtilsAlert.showToast("Login offline berhasil");
    //   } else {
    //     UtilsAlert.showToast("Login offline gagal, data tidak cocok");
    //   }
    // } else {
    // AppData.loginOffline = false;
    var fcm_registration_token = await FirebaseMessaging.instance.getToken();
    //  var fcm_registration_token = "1";
    // print("fcmtoken ${fcm_registration_token}");
    UtilsAlert.showLoadingIndicator(Get.context!);
    Map<String, dynamic> body = {
      'email': email.value.text,
      'password': password.value.text,
      'token_notif': fcm_registration_token,
      'database': selectedDb.value
    };
    var connect = Api.connectionApi("post", body, "login");
    connect.then((dynamic res) async {
      var valueBody = jsonDecode(res.body);
      print('data login ${valueBody}');
      if (valueBody['status'] == false) {
        UtilsAlert.showToast(valueBody['message']);
        Navigator.pop(Get.context!);
      } else {
        print("nama database ${selectedDb.value}");
        AppData.selectedDatabase = selectedDb.value;
        AppData.selectedPerusahan = selectedPerusahaan.value;

        List<UserModel> getData = [];

        var lastLoginUser = "";
        var getEmId = "";
        var getAktif = "";
        var idMobile = "";

        print("data login 2 new new ${valueBody['data']}");
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

            print("data back date ");
            print("1 ${isBackDates[0].toString()}");
            print("2 ${isBackDates[1].toString()}");
            print("3 ${isBackDates[2].toString()}");
            print("4 ${isBackDates[3].toString()}");
            print(
                "dinas luar ${isBackDates[4].toString()} ${isBackDateDinasLuar}");
            print("6 ${isBackDates[5].toString()}");
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
              beginPayroll: element['begin_payroll'] ?? 1,
              endPayroll: element['end_payroll'] ?? 31,
              branchName: element['branch_name'] ?? "",
              startTime: element['time_attendance'].toString().split(',')[0],
              endTime: element['time_attendance'].toString().split(',')[1],
              nomorBpjsKesehatan: element['nomor_bpjs_kesehatan'] ?? 0,
              nomorBpjsTenagakerja: element['nomor_bpjs_tenagakerja'] ?? 0,
              timeIn: element['time_in'] ?? "",
              timeOut: element['time_out'] ?? "",
              interval: element['interval'],
              interval_tracking: element['interval_tracking'],
              isViewTracking: element['is_view_tracking'],
              is_tracking: element['is_tracking'],
              tipeAbsen: element['tipe_absen']
              //   startTime: "00:01",
              // endTime: "23:59",
              );

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(
              "interval_tracking", element['interval_tracking'].toString());
          await prefs.setString("em_id", element['em_id'].toString());

          print('data login ${data}');

          if (element['file_face'] == "" || element['file_face'] == null) {
            box.write("face_recog", false);
          } else {
            box.write("face_recog", true);
          }
          getData.add(data);
          AppData.informasiUser = getData;
          lastLoginUser = "${element['last_login']}";
          getEmId = "${element['em_id']}";
          getAktif = "${element['status_aktif']}";

          AppData.isLogin = true;
          AppData.setFcmToken = fcm_registration_token.toString();
          print(element.toString());

          if (AppData.informasiUser![0].is_tracking.toString() == '1') {
            controllerTracking.bagikanlokasi.value = "aktif";
            // await BackgroundLocationTrackerManager.startTracking();
            // final service = FlutterBackgroundService();
            // FlutterBackgroundService().invoke("setAsBackground");

            // service.startService();
            controllerTracking.updateStatus('1');
            controllerTracking.isTrackingLokasi.value = true;
            // controllerTracking.detailTracking(emIdEmployee: '');
            print(
                "startTracking is_tracking ${AppData.informasiUser![0].is_tracking.toString()}");
          } else {
            controllerTracking.bagikanlokasi.value = "tidak aktif";
            // await LocationDao().clear();
            // await _getLocations();
            // await BackgroundLocationTrackerManager.stopTracking();
            // final service = FlutterBackgroundService();
            // FlutterBackgroundService().invoke("setAsBackground");

            // service.invoke("stopService");
            controllerTracking.updateStatus('0');
            controllerTracking.isTrackingLokasi.value = false;
            print(
                "stopTracking is_tracking ${AppData.informasiUser![0].is_tracking.toString()}");
          }
        }

        if (getAktif == "ACTIVE") {
          if (lastLoginUser == "" ||
              lastLoginUser == "null" ||
              lastLoginUser == null ||
              lastLoginUser == "0000-00-00 00:00:00") {
            fillLastLoginUserNew(getEmId, getData);
            checkAbsenUser(DateFormat('yyyy-MM-dd').format(DateTime.now()),
                AppData.informasiUser![0].em_id);
          } else {
            AppData.emailUser = email.value.text;
            AppData.passwordUser = password.value.text;

            var filterLastLogin = Constanst.convertDate1("$lastLoginUser");
            var dateNow = DateTime.now();
            var convert = DateFormat('dd-MM-yyyy').format(dateNow);

            if (convert != filterLastLogin) {
              fillLastLoginUserNew(getEmId, getData);
              checkAbsenUser(DateFormat('yyyy-MM-dd').format(DateTime.now()),
                  AppData.informasiUser![0].em_id);
            } else {
              //  UtilsAlert.showToast("Anda telah masuk di perangkat lain");
              Navigator.pop(Get.context!);
              validasiLogin();
            }
          }
        } else {
          UtilsAlert.showToast("Maaf status anda sudah tidak aktif");
          Navigator.pop(Get.context!);
        }
      }
    });
    // }
  }

  Future<void> loginUser1() async {
    final box = GetStorage();
    var fcm_registration_token = await FirebaseMessaging.instance.getToken();
    //  var fcm_registration_token = "1";

    //  print("fcmtoken ${fcm_registration_token}");

    UtilsAlert.showLoadingIndicator(Get.context!);
    Map<String, dynamic> body = {
      'email': email.value.text,
      'password': password.value.text,
      'token_notif': fcm_registration_token,
      'database': selectedDb.value
    };
    var connect = Api.connectionApi("post", body, "login");
    connect.then((dynamic res) async {
      var valueBody = jsonDecode(res.body);
      print('data login 2 new ${valueBody}');
      if (valueBody['status'] == false) {
        UtilsAlert.showToast(valueBody['message']);
        Navigator.pop(Get.context!);
      } else {
        AppData.selectedDatabase = selectedDb.value;
        AppData.selectedPerusahan = selectedPerusahaan.value;

        List<UserModel> getData = [];

        var lastLoginUser = "";
        var getEmId = "";
        var getAktif = "";
        var idMobile = "";

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
              beginPayroll: element['begin_payroll'] ?? 1,
              endPayroll: element['end_payroll'] ?? 31,
              branchName: element['branch_name'] ?? "",
              startTime: element['time_attendance'].toString().split(',')[0],
              endTime: element['time_attendance'].toString().split(',')[1],
              nomorBpjsKesehatan: element['nomor_bpjs_kesehatan'] ?? 0,
              nomorBpjsTenagakerja: element['nomor_bpjs_tenagakerja'] ?? 0,
              timeIn: element['time_in'] ?? "",
              timeOut: element['time_out'] ?? "",
              interval: element['interval'],
              interval_tracking: element['interval_tracking'],
              isViewTracking: element['is_view_tracking'],
              is_tracking: element['is_tracking'],
              tipeAbsen: element['tipe_absen'],
              // startTime: "00:01",
              // endTime: "23:59",
              );

          if (element['file_face'] == "" || element['file_face'] == null) {
            box.write("face_recog", false);
          } else {
            box.write("face_recog", true);
          }
          getData.add(data);
          AppData.informasiUser = getData;
          lastLoginUser = "${element['last_login']}";
          getEmId = "${element['em_id']}";
          getAktif = "${element['status_aktif']}";

          AppData.isLogin = true;
          print(element.toString());
          AppData.setFcmToken = fcm_registration_token.toString();
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(
              "interval_tracking", element['interval_tracking'].toString());
          await prefs.setString("em_id", element['em_id'].toString());
        }

        if (getAktif == "ACTIVE") {
          AppData.emailUser = email.value.text;
          AppData.passwordUser = password.value.text;
          fillLastLoginUserNew(getEmId, getData);
          checkAbsenUser(DateFormat('yyyy-MM-dd').format(DateTime.now()),
              AppData.informasiUser![0].em_id);
        } else {
          UtilsAlert.showToast("Maaf status anda sudah tidak aktif");
          Navigator.pop(Get.context!);
        }
      }
    });
  }

  void fillLastLoginUser(getEmId, getData) {
    var now = DateTime.now();

    var jam = "${DateFormat('yyyy-MM-dd HH:mm:ss').format(now)}";
    Map<String, dynamic> body = {
      'last_login': jam,
      'em_id': getEmId,
      'database': AppData.selectedDatabase
    };
    var connect = Api.connectionApi("post", body, "edit_last_login");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        print(valueBody['data']);
        if (valueBody['status'] == true) {
          var dateNow = DateTime.now();
          var convert = DateFormat('yyyy-MM-dd').format(dateNow);
          checkAbsenUser(convert, getEmId);
          AppData.emailUser = email.value.text;
          AppData.passwordUser = password.value.text;
          AppData.informasiUser = getData;
        }
      }
    });
  }

  // Future<void> sendDataUserOflline() async {
  //   _cancelTimer();
  //   final box = GetStorage();
  //   var fcm_registration_token = await FirebaseMessaging.instance.getToken();
  //   //  var fcm_registration_token = "1";

  //   //  print("fcmtoken ${fcm_registration_token}");

  //   // UtilsAlert.showLoadingIndicator(Get.context!);
  //   print(AppData.emailUser);
  //   print(AppData.passwordUser);
  //   if (AppData.emailUser != "" &&
  //       AppData.passwordUser != "" &&
  //       AppData.setFcmToken != "" &&
  //       AppData.selectedDatabase != "") {
  //     Map<String, dynamic> body = {
  //       'email': AppData.emailUser,
  //       'password': AppData.passwordUser,
  //       'token_notif': AppData.setFcmToken,
  //       'database': AppData.selectedDatabase,
  //     };

  //     var connect = Api.connectionApi("post", body, "login");
  //     connect.then((dynamic res) async {
  //       var valueBody = jsonDecode(res.body);
  //       print('data login 2 new ${valueBody}');
  //       if (valueBody['status'] == false) {
  //         UtilsAlert.showToast(valueBody['message']);
  //         Navigator.pop(Get.context!);
  //       } else {
  //         AppData.selectedDatabase = selectedDb.value;
  //         AppData.selectedPerusahan = selectedPerusahaan.value;

  //         List<UserModel> getData = [];

  //         var lastLoginUser = "";
  //         var getEmId = "";
  //         var getAktif = "";
  //         var idMobile = "";

  //         var isBackDateSakit = "0";
  //         var isBackDateIzin = "0";
  //         var isBackDateCuti = "0";

  //         var isBackDateTugasLuar = "0";
  //         var isBackDateDinasLuar = "0";
  //         var isBackDateLembur = "0";

  //         for (var element in valueBody['data']) {
  //           if (element['back_date'] == "" || element['back_date'] == null) {
  //           } else {
  //             List isBackDates = element['back_date'].toString().split(',');
  //             isBackDateSakit = isBackDates[0].toString();
  //             isBackDateIzin = isBackDates[1].toString();
  //             isBackDateCuti = isBackDates[2].toString();

  //             isBackDateTugasLuar = isBackDates[3].toString();
  //             isBackDateDinasLuar = isBackDates[4].toString();
  //             isBackDateLembur = isBackDates[5].toString();
  //           }
  //           var data = UserModel(
  //               isBackDateSakit: isBackDateSakit,
  //               isBackDateIzin: isBackDateIzin,
  //               isBackDateCuti: isBackDateCuti,
  //               isBackDateTugasLuar: isBackDateTugasLuar,
  //               isBackDateDinasLuar: isBackDateDinasLuar,
  //               isBackDateLembur: isBackDateLembur,
  //               em_id: element['em_id'] ?? "",
  //               des_id: element['des_id'] ?? 0,
  //               dep_id: element['dep_id'] ?? 0,
  //               dep_group: element['dep_group'] ?? 0,
  //               full_name: element['full_name'] ?? "",
  //               em_email: element['em_email'] ?? "",
  //               em_phone: element['em_phone'] ?? "",
  //               em_birthday: element['em_birthday'] ?? "1999-09-09",
  //               em_gender: element['em_gender'] ?? "",
  //               em_image: element['em_image'] ?? "",
  //               em_joining_date: element['em_joining_date'] ?? "1999-09-09",
  //               em_status: element['em_status'] ?? "",
  //               em_blood_group: element['em_blood_group'] ?? "",
  //               posisi: element['posisi'] ?? "",
  //               emp_jobTitle: element['emp_jobTitle'] ?? "",
  //               emp_departmen: element['emp_departmen'] ?? "",
  //               em_control: element['em_control'] ?? 0,
  //               em_control_acess: element['em_control_access'] ?? 0,
  //               emp_att_working: element['emp_att_working'] ?? 0,
  //               em_hak_akses: element['em_hak_akses'] ?? "",
  //               beginPayroll: element['begin_payroll'] ?? 1,
  //               endPayroll: element['end_payroll'] ?? 31,
  //               branchName: element['branch_name'] ?? "",
  //               startTime: element['time_attendance'].toString().split(',')[0],
  //               endTime: element['time_attendance'].toString().split(',')[1],
  //               nomorBpjsKesehatan: element['nomor_bpjs_kesehatan'] ?? 0,
  //               nomorBpjsTenagakerja: element['nomor_bpjs_tenagakerja'] ?? 0,
  //               timeIn: element['time_in'] ?? "",
  //               timeOut: element['time_out'] ?? "",
  //               interval: element['interval'],
  //               interval_tracking: element['interval_tracking'],
  //               isViewTracking: element['is_view_tracking'],
  //               is_tracking: element['is_tracking']
  //               // startTime: "00:01",
  //               // endTime: "23:59",
  //               );

  //           if (element['file_face'] == "" || element['file_face'] == null) {
  //             box.write("face_recog", false);
  //           } else {
  //             box.write("face_recog", true);
  //           }
  //           getData.add(data);
  //           AppData.informasiUser = getData;
  //           lastLoginUser = "${element['last_login']}";
  //           getEmId = "${element['em_id']}";
  //           getAktif = "${element['status_aktif']}";

  //           AppData.isLogin = true;
  //           AppData.loginOffline = false;

  //           print(element.toString());
  //           AppData.setFcmToken = fcm_registration_token.toString();
  //           final prefs = await SharedPreferences.getInstance();
  //           await prefs.setString(
  //               "interval_tracking", element['interval_tracking'].toString());
  //           await prefs.setString("em_id", element['em_id'].toString());
  //         }

  //         AppData.emailUser = email.value.text;
  //         AppData.passwordUser = password.value.text;
  //         fillLastLoginUserNew(getEmId, getData);
  //         checkAbsenUser(DateFormat('yyyy-MM-dd').format(DateTime.now()),
  //             AppData.informasiUser![0].em_id);

  //         if (getAktif == "ACTIVE") {
  //         } else {
  //           UtilsAlert.showToast("Maaf status anda sudah tidak aktif");
  //           Navigator.pop(Get.context!);
  //         }
  //       }
  //     }).catchError((error) {
  //       // errorServer.value = true;
  //     }).whenComplete(() {
  //       checking();
  //     });
  //   }
  // }

  void fillLastLoginUserNew(getEmId, getData) async {
    var now = DateTime.now();
    var jam = "${DateFormat('yyyy-MM-dd HH:mm:ss').format(now)}";
    // var connectivityResult = await Connectivity().checkConnectivity();
    // var offline =
    //     (connectivityResult[0].toString() == "${ConnectivityResult.none}");

    Map<String, dynamic> body = {
      'last_login': jam,
      'em_id': getEmId,
      'database': AppData.selectedDatabase
    };

    // if (!isConnected.value) {
    //   AppData.emailUser = email.value.text;
    //   AppData.passwordUser = password.value.text;
    //   AppData.informasiUser = getData;
    //   isautoLogout.value = false;
    // } else {
    var connect = Api.connectionApi("post", body, "edit_last_login");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        print(valueBody['data']);
        if (valueBody['status'] == true) {
          checkAbsenUser(DateFormat('yyyy-MM-dd').format(now), getEmId);
          AppData.emailUser = email.value.text;
          AppData.passwordUser = password.value.text;
          AppData.informasiUser = getData;
          isautoLogout.value = false;
        }
      }
    });
    // }
  }

  // void fillLastLoginUserOffline(getEmId, getData) async {
  //   var now = DateTime.now();
  //   var jam = "${DateFormat('yyyy-MM-dd HH:mm:ss').format(now)}";
  //   // var connectivityResult = await Connectivity().checkConnectivity();
  //   // var offline =
  //   //     (connectivityResult[0].toString() == "${ConnectivityResult.none}");

  //   Map<String, dynamic> body = {
  //     'last_login': jam,
  //     'em_id': getEmId,
  //     'database': AppData.selectedDatabase
  //   };

  //   if (!isConnected.value) {
  //     AppData.emailUser = email.value.text;
  //     AppData.passwordUser = password.value.text;
  //     AppData.informasiUser = getData;
  //     isautoLogout.value = false;
  //   } else {
  //     var connect = Api.connectionApi("post", body, "edit_last_login");
  //     connect.then((dynamic res) {
  //       if (res.statusCode == 200) {
  //         var valueBody = jsonDecode(res.body);
  //         print(valueBody['data']);
  //         if (valueBody['status'] == true) {
  //           checkAbsenUserOffline(
  //               DateFormat('yyyy-MM-dd').format(now), getEmId);
  //           AppData.emailUser = email.value.text;
  //           AppData.passwordUser = password.value.text;
  //           AppData.informasiUser = getData;
  //           isautoLogout.value = false;
  //         }
  //       }
  //     });
  //   }
  // }

  void checkAbsenUser(convert, getEmid) async {
    // skema menggunakan jam reset
    messageNewPassword.value = "";
    print("view last absen user 3");
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
        startTime = AppData.informasiUser![0].endTime;
        endTime = AppData.informasiUser![0].startTime;

        startDate = DateFormat('yyyy-MM-dd')
            .format(DateTime.now().add(const Duration(days: -1)));

        endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      } else {
        startTime = AppData.informasiUser![0].endTime;
        endTime = AppData.informasiUser![0].startTime;

        endDate = DateFormat('yyyy-MM-dd')
            .format(DateTime.now().add(const Duration(days: 1)));

        startDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      }
    } else {
      startTime = AppData.informasiUser![0].startTime;
      endTime = AppData.informasiUser![0].endTime;

      startDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      print("Waktu 1 sama dengan waktu 2");
    }
    // var connectivityResult = await Connectivity().checkConnectivity();
    // var offline =
    //     (connectivityResult[0].toString() == "${ConnectivityResult.none}");

    // if (!isConnected.value) {
    //   isautoLogout.value = false;
    //   Get.offAll(InitScreen());
    // } else {
    Map<String, dynamic> body = {
      'atten_date': DateFormat('yyyy-MM-dd')
          .format(DateTime.now().add(const Duration(days: -1))),
      'em_id': getEmid,
      'database': AppData.selectedDatabase,
      'start_date': startDate,
      'end_date': endDate,
      'start_time': startTime,
      'end_time': endTime,
    };

    print("param view last absen ${body}");

    var connect = Api.connectionApi("post", body, "view_last_absen_user2");

    connect.then((dynamic res) async {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        print("data login ${valueBody}");
        var data = valueBody['data'];

        var date = AppData.informasiUser![0].startTime.toString().split(':');
        var date2 = AppData.informasiUser![0].startTime.toString().split(':');

        //skema pertama
        if (data.isEmpty) {
          isautoLogout.value = false;
          signoutTime.value = '00:00:00';
          signinTime.value = '00:00:00';
          AppData.statusAbsen = false;
          Get.offAll(InitScreen());
        } else {
          isautoLogout.value = false;
          AppData.statusAbsen =
              data[0]['signout_time'] == "00:00:00" ? true : false;

          signoutTime.value = data[0]['signout_time'].toString();
          signinTime.value = data[0]['signin_time'].toString();
          print("ini login: ${AppData.isLogin}");
          Get.offAll(InitScreen());
        }
      }
    });
    // }
    //sekema tidak menggunakan jam reset
  }

  // Future<void> checkAbsenUserOffline(convert, getEmid) async {
  //   // skema menggunakan jam reset
  //   messageNewPassword.value = "";
  //   print("view last absen user 3");
  //   print("tes ${AppData.informasiUser![0].startTime.toString()}");
  //   var startTime = "";
  //   var endTime = "";
  //   var startDate = "";
  //   var endDate = "";
  //   TimeOfDay waktu1 = TimeOfDay(
  //       hour: int.parse(
  //           AppData.informasiUser![0].startTime.toString().split(':')[0]),
  //       minute: int.parse(
  //           AppData.informasiUser![0].startTime.toString().split(':')[1]));

  //   TimeOfDay waktu2 = TimeOfDay(
  //       hour: int.parse(
  //           AppData.informasiUser![0].endTime.toString().split(':')[0]),
  //       minute: int.parse(AppData.informasiUser![0].endTime
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

  //     //alur beda hari
  //   } else if (totalMinutes1 > totalMinutes2) {
  //     var waktu3 =
  //         TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
  //     int totalMinutes3 = waktu3.hour * 60 + waktu3.minute;

  //     if (totalMinutes2 > totalMinutes3) {
  //       startTime = AppData.informasiUser![0].endTime;
  //       endTime = AppData.informasiUser![0].startTime;

  //       startDate = DateFormat('yyyy-MM-dd')
  //           .format(DateTime.now().add(const Duration(days: -1)));

  //       endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  //     } else {
  //       startTime = AppData.informasiUser![0].endTime;
  //       endTime = AppData.informasiUser![0].startTime;

  //       endDate = DateFormat('yyyy-MM-dd')
  //           .format(DateTime.now().add(const Duration(days: 1)));

  //       startDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  //     }
  //   } else {
  //     startTime = AppData.informasiUser![0].startTime;
  //     endTime = AppData.informasiUser![0].endTime;

  //     startDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  //     endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  //     print("Waktu 1 sama dengan waktu 2");
  //   }
  //   // var connectivityResult = await Connectivity().checkConnectivity();
  //   // var offline =
  //   //     (connectivityResult[0].toString() == "${ConnectivityResult.none}");

  //   if (!isConnected.value) {
  //     isautoLogout.value = false;
  //     Get.offAll(InitScreen());
  //   } else {
  //     Map<String, dynamic> body = {
  //       'atten_date': DateFormat('yyyy-MM-dd')
  //           .format(DateTime.now().add(const Duration(days: -1))),
  //       'em_id': getEmid,
  //       'database': AppData.selectedDatabase,
  //       'start_date': startDate,
  //       'end_date': endDate,
  //       'start_time': startTime,
  //       'end_time': endTime,
  //       'pola': globalCtr.valuePolaPersetujuan.value.toString()
  //     };

  //     print("param view last absen ${body}");

  //     var connect = Api.connectionApi("post", body, "view_last_absen_user2");

  //     connect.then((dynamic res) async {
  //       if (res.statusCode == 200) {
  //         var valueBody = jsonDecode(res.body);
  //         print("data login ${valueBody}");
  //         var data = valueBody['data'];

  //         var date = AppData.informasiUser![0].startTime.toString().split(':');
  //         var date2 = AppData.informasiUser![0].startTime.toString().split(':');

  //         offiline.value = valueBody['offiline'];
  //         datas.value = valueBody['data'];
  //         //skema pertama
  //         if (data.isEmpty) {
  //           isautoLogout.value = false;
  //           signoutTime.value = '00:00:00';
  //           signinTime.value = '00:00:00';
  //           AppData.statusAbsen = false;
  //         } else {
  //           isautoLogout.value = false;
  //           AppData.statusAbsen =
  //               data[0]['signout_time'] == "00:00:00" ? true : false;

  //           signoutTime.value = data[0]['signout_time'].toString();
  //           signinTime.value = data[0]['signin_time'].toString();
  //           print("ini login: ${AppData.isLogin}");
  //         }
  //       }
  //     });
  //   }
  //   //sekema tidak menggunakan jam reset
  // }

  //   void checkAbsenUser(convert, getEmid) {
  //   messageNewPassword.value = "";
  //   print("view last absen user");
  //   print("tes ${AppData.informasiUser![0].startTime.toString()}");

  //   Map<String, dynamic> body = {
  //     'atten_date': DateFormat('yyyy-MM-dd')
  //         .format(DateTime.now().add(Duration(days: -1))),
  //     'em_id': getEmid,
  //     'database': AppData.selectedDatabase,

  //   };
  //   var connect = Api.connectionApi("post", body, "view_last_absen_user");

  //   connect.then((dynamic res) {
  //     if (res.statusCode == 200) {
  //       var valueBody = jsonDecode(res.body);
  //       print("data login ${valueBody}");
  //       var data = valueBody['data'];
  //       if (data.isEmpty) {
  //         isautoLogout.value = false;
  //         AppData.statusAbsen = false;
  //         Get.offAll(InitScreen());
  //       } else {

  //           var tanggalTerakhirAbsen = data[0]['atten_date'];
  //           if (tanggalTerakhirAbsen == convert) {
  //             isautoLogout.value = false;
  //             AppData.statusAbsen =
  //                 data[0]['signout_time'] == "00:00:00" ? true : false;
  //             Get.offAll(InitScreen());
  //           } else {
  //             isautoLogout.value = false;
  //             AppData.statusAbsen = false;
  //             Get.offAll(InitScreen());
  //           }
  //       }
  //     }
  //   });
  // }

  void hapusFoto() {
    UtilsAlert.showLoadingIndicator(Get.context!);
    print("view last absen user");
    Map<String, dynamic> body = {
      'em_id': AppData.informasiUser![0].em_id,
      'database': AppData.selectedDatabase
    };
    var connect = Api.connectionApi("post", body, "hapus_foto_user");

    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        print(valueBody);

        if (valueBody['status'] == true) {
          Get.back();
          Get.offAll(InitScreen());
          UtilsAlert.showToast("Foto berhasil dihapus");
        } else {
          Get.back();
          UtilsAlert.showToast(valueBody['status']);
        }
      }
    });
  }

  void validasiLogin() {
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
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Container(
                  // Bottom rectangular box
                  margin: const EdgeInsets.only(
                      top: 25), // to push the box half way below circle
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.only(
                      top: 30, left: 20, right: 20), // spacing inside the box
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const TextLabell(
                        text: "Oops! Anda telah login di perangkat lain.",
                        weight: FontWeight.bold,
                        size: 14,
                      ),
                      // Text(
                      //   "Oops! Anda telah login di perangkat lain.",
                      //   style: Theme.of(context).textTheme.headline6,
                      // ),
                      const SizedBox(
                        height: 8,
                      ),
                      const TextLabell(
                        text:
                            "Tetap masuk akan mengakibatkan akun Anda keluar dari perangkat lain.",
                        size: 14,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 50,
                            child: InkWell(
                              onTap: () => Get.back(),
                              child: Container(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        width: 1, color: Constanst.border)),
                                child: const Center(
                                    child: TextLabell(
                                  text: "Batal",
                                )),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            flex: 50,
                            child: InkWell(
                              onTap: () {
                                loginUser1();
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                decoration: BoxDecoration(
                                    color: Constanst.colorPrimary,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        width: 1, color: Constanst.border)),
                                child: const Center(
                                    child: TextLabell(
                                  text: "Tetap Masuk",
                                  color: Colors.white,
                                )),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      )
                      // Text(
                      //   "Tetap masuk akan mengakibatkan akun Anda keluar dari perangkat lain.",
                      //   style: Theme.of(context).textTheme.bodyText1,
                      //   textAlign: TextAlign.center,
                      // ),
                    ],
                  ),
                ),
              ],
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

  // Future<bool>? verifyPassword() async {
  //   final box = GetStorage();

  //   UtilsAlert.showLoadingIndicator(Get.context!);
  //   Map<String, dynamic> body = {
  //     'email': email.value.text,
  //     'password': password.value.text,
  //   };
  //   var connect = Api.connectionApi("post", body, "validasiLogin");
  //   connect.then((dynamic res) {
  //     var valueBody = jsonDecode(res.body);
  //     if (valueBody['status'] == false) {
  //       UtilsAlert.showToast(valueBody['message']);
  //       Navigator.pop(Get.context!);
  //       return false;
  //     } else {
  //       return true;
  //     }

  //   });
  //   return false;
  // }

  Future<bool> dataabse() async {
    tempEmail.value.text = "";
    try {
      UtilsAlert.showLoadingIndicator(Get.context!);
      var response =
          await Request(url: "login/check-database?email=${email.value.text}")
              .getCheckDatabase();
      var resp = jsonDecode(response.body);

      if (response.statusCode == 200) {
        tempEmail.value.text = email.value.text;
        databases.value = DatabaseModel.fromJsonToList(resp['data']);
        Get.back();
        return true;
      } else {
        Get.back();
        databases.value = [];
        UtilsAlert.showToast(resp['message']);
        return false;
      }
    } catch (e) {
      print(e);
      Get.back();
      UtilsAlert.showToast("Koneksi internet tidak tersedia.Silahkan periksa jaringan Anda dan coba kembali.");
      databases.value = [];
      return false;
    }
  }

  @override
  void onClose() {
    // Pastikan untuk membatalkan timer ketika controller dihancurkan
    // _cancelTimer();
    super.onClose();
  }
}
