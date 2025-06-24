import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:siscom_operasional/controller/absen_controller.dart';
import 'package:siscom_operasional/controller/aktifitas_controller.dart';
import 'package:siscom_operasional/controller/dashboard_controller.dart';
import 'package:siscom_operasional/controller/pesan_controller.dart';
import 'package:siscom_operasional/controller/setting_controller.dart';
import 'package:siscom_operasional/model/user_model.dart';
import 'package:siscom_operasional/screen/absen/camera_view_register.dart';
import 'package:siscom_operasional/screen/aktifitas/aktifitas.dart';
import 'package:siscom_operasional/screen/akun/setting.dart';
import 'package:siscom_operasional/screen/dashboard.dart';
import 'package:siscom_operasional/screen/init_screen.dart';
import 'package:siscom_operasional/screen/pesan/pesan.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/custom_dialog.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';
import 'package:move_to_background/move_to_background.dart';

class TabbController extends GetxController {
  var currentPage = 0.obs;
  // Rx<PersistentTabController> tabPersistantController =
  //     PersistentTabController().obs;
  var currentIndex = 0.obs;
  DateTime? _currentBackPressTime;

  var kontrolAkses = false.obs;
  var kontrol = false.obs;
  final Absensicontroller = Get.find<AbsenController>();

  @override
  void onReady() {
    checkuserinfo();
    super.onReady();
  }

  Future<void> checkuserinfo() async {
    var dataUser = AppData.informasiUser;
    var getKontrolAkses = "${dataUser![0].em_control_acess}";
    var getKontrol = "${dataUser![0].em_control}";
    var isViewTracking = "${AppData.informasiUser![0].isViewTracking}";
    var isTracking = "${AppData.informasiUser![0].is_tracking}";
    // isViewTracking = int.parse('1').toString();
    // getKontrolAkses = int.parse('0').toString();
    // getKontrol = int.parse('1').toString();
    // isTracking = int.parse('0').toString();
    print("dapatttt isViewTracking $isViewTracking");
    print("dapatttt getKontrolAkses $getKontrolAkses");
    print("dapatttt getKontrol $getKontrol");
    print("dapatttt isTracking $isTracking");
    if (getKontrolAkses == "0" && getKontrol == "0") {
      kontrolAkses.value = false;
      kontrol.value = false;
    } else {
      if (getKontrolAkses == "1") {
        kontrolAkses.value = true;
        kontrol.value = false;
      } else {
        if (isViewTracking.toString() == '0') {
          kontrolAkses.value = false;
          kontrol.value = false;
        } else {
          kontrolAkses.value = false;
          kontrol.value = true;
        }
        kontrolAkses.value = false;
      }
    }

    this.kontrolAkses.refresh();
  }

  Future<bool> onWillPop() {
    // var _androidAppRetain = MethodChannel("android_app_retain");
    // if (Platform.isAndroid) {
    //   if (Navigator.of(Get.context!).canPop()) {
    //     return Future.value(true);
    //   } else {
    //     _androidAppRetain.invokeMethod("sendToBackground");
    //     return Future.value(false);
    //   }
    // } else {
    //   return Future.value(true);
    // }
    // DateTime now = DateTime.now();
    // if (_currentBackPressTime == null ||
    //     now.difference(_currentBackPressTime!) > const Duration(seconds: 2)) {
    //   _currentBackPressTime = now;
    //   UtilsAlert.showToast("Tekan sekali lagi untuk keluar");
    //   return Future.value(false);
    // }
    // return Future.value(true);
    print("${absenControllre.isTracking.value}");
    if (absenControllre.isTracking.value == 1) {
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
              content: "Lagi proses tracking ,yakin mau keluar aplikasi?",
              positiveBtnText: "Keluar",
              negativeBtnText: "Kembali",
              style: 1,
              buttonStatus: 1,
              positiveBtnPressed: () async {
                Get.back();
                MoveToBackground.moveTaskToBack();

                //   MinimizeApp .minimizeApp();
                // SystemNavigator.pop();

                // aksiEditLastLogin();
              },
            ),
          );
        },
        pageBuilder: (BuildContext context, Animation animation,
            Animation secondaryAnimation) {
          return null!;
        },
      );
      return Future.value(true);
    } else {
      DateTime now = DateTime.now();
      if (_currentBackPressTime == null ||
          now.difference(_currentBackPressTime!) > const Duration(seconds: 2)) {
        _currentBackPressTime = now;
        UtilsAlert.showToast("Tekan sekali lagi untuk keluar");
        return Future.value(false);
      }
      return Future.value(true);
    }
  }

  void onClickItem(s) async {
    print(s);
    if (s == 0) {
      // try {
      // var dashboardController = Get.find<DashboardController>();
      // // dashboardController.onClose();
      // dashboardController.onInit();
      // } catch (e) {}
    } else if (s == 1) {
      // try {
      //   // var aktifitasController = Get.find<AktifitasController>();
      //   // aktifitasController.onInit();
      // } catch (e) {}
    } else if (s == 2) {
      // try {
      //   // var pesanController = Get.find<PesanController>();
      //   // pesanController.onInit();
      // } catch (e) {}
    } else if (s == 3) {
      // try {
      //   // var settingController = Get.find<SettingController>();
      //   // settingController.onInit();
      // } catch (e) {}
    }
  }
}
