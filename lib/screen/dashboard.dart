import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siscom_operasional/controller/absen_controller.dart';
import 'package:siscom_operasional/controller/aktifitas_controller.dart';
import 'package:siscom_operasional/controller/auth_controller.dart';
import 'package:siscom_operasional/controller/bpjs.dart';
import 'package:siscom_operasional/controller/chat_controller.dart';
import 'package:siscom_operasional/controller/dashboard_controller.dart';
import 'package:siscom_operasional/controller/global_controller.dart';
import 'package:siscom_operasional/controller/pesan_controller.dart';
import 'package:siscom_operasional/controller/tab_controller.dart';
import 'package:siscom_operasional/controller/tracking_controller.dart';
import 'package:siscom_operasional/database/sqlite/sqlite_database_helper.dart';
import 'package:siscom_operasional/screen/absen/absen_masuk_keluar.dart';
import 'package:siscom_operasional/screen/absen/absesi_location.dart';
import 'package:siscom_operasional/screen/absen/berhasil_absen.dart';
import 'package:siscom_operasional/screen/absen/camera_view.dart';
import 'package:siscom_operasional/screen/absen/face_id_registration.dart';
import 'package:siscom_operasional/screen/absen/facee_id_detection.dart';
import 'package:siscom_operasional/screen/absen/loading_absen.dart';
import 'package:siscom_operasional/screen/absen_istirahat_masuk_keluar.dart';
import 'package:siscom_operasional/screen/akun/personal_info.dart';
import 'package:siscom_operasional/screen/chatting/history.dart';
import 'package:siscom_operasional/screen/detail_informasi.dart';
import 'package:siscom_operasional/screen/informasi.dart';
import 'package:siscom_operasional/screen/pesan/pesan.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/custom_dialog.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';
import 'package:siscom_operasional/utils/widget_textButton.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
// import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart' as dom;
// import 'package:upgrader/upgrader.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'chatting/history.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final controller = Get.put(DashboardController());
  final controllerAbsensi = Get.put(AbsenController());
  final controllerTracking = Get.put(TrackingController());
  final controllerPesan = Get.put(PesanController());
  var controllerGlobal = Get.put(GlobalController());
  var controllerBpj = Get.put(BpjsController());
  final tabbController = Get.put(TabbController());
  final authController = Get.put(AuthController());
  final chatController = Get.put(ChatController());

  var intervalTracking = "";
  final WebSocketChannel channel =
      WebSocketChannel.connect(Uri.parse(Api.webSocket));

  Future<void> refreshData() async {
    controller.isLoading.value = true;
    controller.refreshPagesStatus.value = true;
    controller.initData();
  
    // setState(() {
    Future.wait([
      // controller.updateInformasiUser(),
      // controllerBpj.employeDetaiBpjs(),
      // controllerAbsensi.employeDetail(),
      // controllerAbsensi.userShift(),

      Future.delayed(const Duration(milliseconds: 500), () {
        controllerAbsensi.absenStatus.value = AppData.statusAbsen;
        authController.signinTime.value = controller.signinTime.value;
        authController.signoutTime.value = controller.signoutTime.value;
        // controllerAbsensi.absenStatus.value =
        //     controller.dashboardStatusAbsen.value;
      }),
      tabbController.checkuserinfo(),
    ]);
        //  UtilsAlert.showToast(controllerAbsensi.absenStatus.value.toString());

    controllerPesan.getTimeNow();
    await Future.delayed(const Duration(seconds: 2));
    controller.onInit();
    controller.isLoading.value = false;

    // });
  }

  final ScrollController _scrollController = ScrollController();
  bool _isVisible = true;

  void _scrollListener() {
    // Hide/show the text based on the scroll direction
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      setState(() {
        _isVisible = false;
      });
    } else if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward &&
        (_scrollController.offset == 0.0 || _scrollController.offset <= 0.0)) {
      setState(() {
        _isVisible = true;
      });
    }
    print("Scrolled: ${_scrollController.offset}");
  }

  @override
  void dispose() {
    // Dispose the scroll controller to avoid memory leaks
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constanst.coloBackgroundScreen,
      floatingActionButton: controller.showAbsen.value
          ? _isVisible == true
              ? Container()
              : Container(
                  decoration: BoxDecoration(
                    // color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 155, 155, 155)
                            .withOpacity(0.5),
                        spreadRadius: 1.0,
                        blurRadius: 3,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: FloatingActionButton.extended(
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(10),
                      // ),
                      extendedPadding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                      // splashColor: Colors.black,
                      elevation: 0,
                      onPressed: !controllerAbsensi.absenStatus.value
                          ? () {
                              if (controllerAbsensi.absenStatus.value == true) {
                                if (controller.wfhstatus.value == true) {
                                  UtilsAlert.showToast(
                                      "Menunggu status wfh anda di approve");
                                  return;
                                }

                                UtilsAlert.showToast(
                                    "Anda harus absen keluar terlebih dahulu");
                              } else {
                                var dataUser = AppData.informasiUser;
                                var faceRecog = dataUser![0].face_recog;
                                print(
                                    "facee recog ${GetStorage().read('face_recog')}");
                                if (GetStorage().read('face_recog') == true) {
                                  print("masuk sini");
                                  var statusCamera = Permission.camera.status;
                                  statusCamera.then((value) {
                                    var statusLokasi =
                                        Permission.location.status;
                                    statusLokasi.then((value2) async {
                                      if (value != PermissionStatus.granted ||
                                          value2 != PermissionStatus.granted) {
                                        UtilsAlert.showToast(
                                            "Anda harus aktifkan kamera dan lokasi anda");
                                        controller.widgetButtomSheetAktifCamera(
                                            type: 'loadfirst');
                                      } else {
                                        print("masuk absen user");
                                        // if (controller.absenOfflineStatus.value ==
                                        //     true) {
                                        //   UtilsAlert.showToast(
                                        //       "Menunggu status absensi anda di approve");
                                        //   return;
                                        // }
                                        // Get.offAll(AbsenMasukKeluar(
                                        //   status: "Absen Masuk",
                                        //   type: 1,
                                        // ));
                                        //  controllerAbsensi.absenSelfie();

                                        var validasiAbsenMasukUser =
                                            controller.validasiAbsenMasukUser();
                                        if (!validasiAbsenMasukUser) {
                                          print("masuk sini");
                                        } else {
                                          // if (!authController.isConnected.value) {
                                          //   if (controller
                                          //           .absenOfflineStatus.value ==
                                          //       true) {
                                          //     UtilsAlert.showToast(
                                          //         "Menunggu status absensi anda di approve");
                                          //     return;
                                          //   } else {
                                          //     controllerAbsensi.titleAbsen.value =
                                          //         "Absen masuk";
                                          //     controllerAbsensi.typeAbsen.value =
                                          //         1;
                                          //     controller
                                          //         .widgetButtomSheetOfflineAbsen(
                                          //             title: "Absen masuk",
                                          //             status: "masuk");
                                          //   }
                                          // } else {
                                          controllerAbsensi.titleAbsen.value =
                                              "Absen masuk";

                                          controllerAbsensi.typeAbsen.value = 1;

                                          //begin image picker
                                          // final getFoto = await ImagePicker()
                                          //     .pickImage(
                                          //         source: ImageSource.camera,
                                          //         preferredCameraDevice:
                                          //             CameraDevice.front,
                                          //         imageQuality: 100,
                                          //         maxHeight: 350,
                                          //         maxWidth: 350);
                                          // if (getFoto == null) {
                                          //   UtilsAlert.showToast(
                                          //       "Gagal mengambil gambar");
                                          // } else {
                                          //   // controllerAbsensi.facedDetection(
                                          //   //     status: "registration",
                                          //   //     absenStatus: "Absen Masuk",
                                          //   //     img: getFoto.path,
                                          //   //     type: "1");
                                          //   Get.to(LoadingAbsen(
                                          //     file: getFoto.path,
                                          //     status: "detection",
                                          //     statusAbsen: 'masuk',
                                          //   ));
                                          //   // Get.to(FaceidRegistration(
                                          //   //   status: "registration",
                                          //   // ));
                                          // }
                                          //end image picker

                                          //begin face recognition
                                          // Get.to(FaceDetectorView(
                                          //   status: "masuk",
                                          // ));
                                          //end begin face recogniton

                                          if (controllerAbsensi.regType.value ==
                                              1) {
                                            Get.to(AbsensiLocation(
                                              status: "masuk",
                                            ));
                                          } else {
                                            Get.to(FaceDetectorView(
                                              status: "masuk",
                                            ));
                                          }

                                          // // controllerAbsensi.getPlaceCoordinate();
                                          // ;
                                          // controllerAbsensi.facedDetection(
                                          //     status: "detection",
                                          //     absenStatus: "masuk",
                                          //     type: "1");

                                          // var kalkulasiRadius =
                                          //     controller.radiusNotOpen();
                                          // Get.to(faceDetectionPage(
                                          //   status: "masuk",
                                          // ));
                                          // kalkulasiRadius.then((value) {
                                          //   print(value);
                                          //   // if (value) {
                                          //   //   controllerAbsensi.titleAbsen.value =
                                          //   //       "Absen Masuk";
                                          //   //   controllerAbsensi.typeAbsen.value = 1;
                                          //   //   Get.offAll(faceDetectionPage());
                                          //   //   // controllerAbsensi.absenSelfie();
                                          //   // }
                                          // });
                                          // }
                                        }
                                      }
                                    });
                                  });
                                } else {
                                  controllerAbsensi
                                      .widgetButtomSheetFaceRegistrattion();
                                }
                              }
                            }
                          : () async {
                              if (!controllerAbsensi.absenStatus.value) {
                                UtilsAlert.showToast(
                                    "Absen Masuk terlebih dahulu");
                              } else {
                                // if (!authController.isConnected.value) {
                                //   // if (controller.absenOfflineStatusDua.value ==
                                //   //     true) {
                                //   //   UtilsAlert.showToast(
                                //   //       "Menunggu status absensi anda di approve");
                                //   //   return;
                                //   // } else {
                                //   controllerAbsensi.getPlaceCoordinate();
                                //   controllerAbsensi.titleAbsen.value =
                                //       "Absen Keluar";
                                //   controllerAbsensi.typeAbsen.value = 2;
                                //   controller.widgetButtomSheetOfflineAbsen(
                                //       title: "Absen Keluar", status: "keluar");
                                //   // }
                                // } else {
                                // if (controller.absenOfflineStatus.value ==
                                //     true) {
                                //   UtilsAlert.showToast(
                                //       "Menunggu status absensi anda di approve");
                                //   return;
                                // }
                                var dataUser = AppData.informasiUser;
                                var faceRecog = dataUser![0].face_recog;

                                if (GetStorage().read('face_recog') == true) {
                                  controllerAbsensi.getPlaceCoordinate();
                                  controllerAbsensi.titleAbsen.value =
                                      "Absen Keluar";
                                  controllerAbsensi.typeAbsen.value = 2;

                                  //begin image picker
                                  // final getFoto = await ImagePicker()
                                  //     .pickImage(
                                  //         source: ImageSource.camera,
                                  //         preferredCameraDevice:
                                  //             CameraDevice.front,
                                  //         imageQuality: 100,
                                  //         maxHeight: 350,
                                  //         maxWidth: 350);
                                  // if (getFoto == null) {
                                  //   UtilsAlert.showToast(
                                  //       "Gagal mengambil gambar");
                                  // } else {
                                  //   // controllerAbsensi.facedDetection(
                                  //   //     status: "registration",
                                  //   //     absenStatus: "Absen Masuk",
                                  //   //     img: getFoto.path,
                                  //   //     type: "1");
                                  //   Get.to(LoadingAbsen(
                                  //     file: getFoto.path,
                                  //     status: "detection",
                                  //     statusAbsen: 'keluar',
                                  //   ));
                                  //   // Get.to(FaceidRegistration(
                                  //   //   status: "registration",
                                  //   // ));
                                  // }
                                  //end image picker

                                  if (controllerAbsensi.regType.value == 1) {
                                    Get.to(AbsensiLocation(
                                      status: "keluar",
                                    ));
                                  } else {
                                    Get.to(FaceDetectorView(
                                      status: "keluar",
                                    ));
                                  }

                                  // controllerAbsensi.facedDetection(
                                  //     status: "detection",
                                  //     type: "2",
                                  // //     absenStatus: "keluar");
                                  // Get.to(faceDetectionPage(
                                  //   status: "keluar",
                                  // ));
                                  // Get.offAll(AbsenMasukKeluar(
                                  //   status: "Absen Keluar",
                                  //   type: 2,
                                  // ));
                                  // controllerAbsensi.absenSelfie();
                                  // var validasiAbsenMasukUser =
                                  //     controller.validasiAbsenMasukUser();
                                  // print(validasiAbsenMasukUser);
                                  // if (validasiAbsenMasukUser == false) {

                                  // } else {
                                  //   var kalkulasiRadius =
                                  //       controller.radiusNotOpen();
                                  //   kalkulasiRadius.then((value) {
                                  //     if (value) {
                                  //       controllerAbsensi.titleAbsen.value =
                                  //           "Absen Keluar";
                                  //       controllerAbsensi.typeAbsen.value = 2;
                                  //       Get.offAll(AbsenMasukKeluar());
                                  //       controllerAbsensi.absenSelfie();
                                  //     }
                                  //   });
                                  // }
                                } else {
                                  controllerAbsensi
                                      .widgetButtomSheetFaceRegistrattion();
                                }
                                // }
                              }
                            },
                      label: Text(
                        !controllerAbsensi.absenStatus.value
                            ? "Masuk"
                            : "Keluar",
                        style: GoogleFonts.inter(
                            color: Constanst.fgPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                      icon: Icon(
                        !controllerAbsensi.absenStatus.value
                            ? Iconsax.login5
                            : Iconsax.logout_15,
                        size: 32,
                        color: !controllerAbsensi.absenStatus.value
                            ? Constanst.color5
                            : Constanst.color4,
                      ),
                      backgroundColor: Constanst.colorWhite),
                )
          : Container(),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          return true;
        },
        child: Obx(
          () => controller.isLoading.value
              ? UtilsAlert.homeShimmer()
              : Stack(
                  children: [
                    Positioned(
                      top: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        // height: MediaQuery.of(context).size.height * 0.4,
                        decoration: BoxDecoration(
                            color: Constanst.greyLight50,
                            image: const DecorationImage(
                                alignment: Alignment.topCenter,
                                image: AssetImage('assets/bg_vector.png'),
                                fit: BoxFit.cover)),
                        child: SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: Column(
                              children: [
                                informasiUser(),
                                // controller.refreshPagesStatus.value
                                //     ? UtilsAlert.shimmerInfoPersonal(Get.context!)
                                //     : Obx(() => informasiUser()),
                                const SizedBox(height: 16),
                                cardInfoAbsen(),
                                const SizedBox(height: 48),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: (controller.isVisibleAbsenIstirahat())
                                ? 350.0
                                : (controller.isVisibleAbsenIstirahat())
                                    ? 260.0
                                    :
                                    // _isVisible
                                    (controller.status.value == "[]" &&
                                            controller.wfhstatus.value) // ||
                                        // (controller.absenOfflineStatus.value)
                                        ? 300.0
                                        : 285.0
                            // : 190.0,
                            ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Constanst.colorWhite,
                            borderRadius: Constanst.borderStyle3,
                          ),
                          child: RefreshIndicator(
                            onRefresh: refreshData,
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              // physics: ClampingScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 12),
                                  Center(
                                    child: Container(
                                        height: 7,
                                        width: 48,
                                        decoration: BoxDecoration(
                                          color:
                                              Constanst.colorNeutralBgTertiary,
                                          borderRadius: Constanst.borderStyle3,
                                        )),
                                  ),
                                  // controller.menuShowInMain.value.isEmpty
                                  //     ? const SizedBox()
                                  //     : listModul(),
                                  const SizedBox(height: 16),
                                  controller.menuShowInMain.value.isEmpty
                                      ? UtilsAlert.shimmerMenuDashboard(
                                          Get.context!)
                                      : MenuDashboard(),
                                  // MenuDashboard(),
                                  // authController.isConnected.value
                                  // ?
                                  cardFormPengajuan(),
                                  // : Container(),
                                  const SizedBox(height: 16),
                                  controller.bannerDashboard.value.isEmpty
                                      ? const SizedBox()
                                      : sliderBanner(),
                                  // sliderBanner(),
                                  const SizedBox(height: 10),

                                  controller.showPengumuman.value == false
                                      ? const SizedBox()
                                      : controller
                                              .informasiDashboard.value.isEmpty
                                          ? const SizedBox()
                                          : Column(
                                              children: [
                                                Container(
                                                  width: double.infinity,
                                                  height: 6,
                                                  color: Constanst
                                                      .colorNeutralBgSecondary,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 16.0,
                                                          top: 16.0,
                                                          right: 8.0),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Informasi",
                                                        style:
                                                            GoogleFonts.inter(
                                                                color: Constanst
                                                                    .fgPrimary,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                      ),
                                                      Material(
                                                        color: Constanst
                                                            .colorWhite,
                                                        child: InkWell(
                                                          customBorder:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                Constanst
                                                                    .borderStyle5,
                                                          ),
                                                          onTap: () =>
                                                              Get.to(Informasi(
                                                            index: 0,
                                                          )),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    8.0,
                                                                    3.0,
                                                                    8.0,
                                                                    3.0),
                                                            child: Text(
                                                              "Lihat semua",
                                                              style: GoogleFonts.inter(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Constanst
                                                                      .infoLight),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),

                                  controller.showPengumuman.value == false
                                      ? const SizedBox()
                                      : controller
                                              .informasiDashboard.value.isEmpty
                                          ? const SizedBox()
                                          : listInformasi(),

                                  controller.showPkwt.value == false
                                      ? const SizedBox()
                                      : controllerGlobal
                                              .employeeSisaCuti.value.isEmpty
                                          ? const SizedBox()
                                          : Column(
                                              children: [
                                                Container(
                                                  width: double.infinity,
                                                  height: 6,
                                                  color: Constanst
                                                      .colorNeutralBgSecondary,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 16.0,
                                                          top: 16.0,
                                                          right: 8.0),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Reminder PKWT",
                                                        style:
                                                            GoogleFonts.inter(
                                                                color: Constanst
                                                                    .fgPrimary,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                      ),
                                                      Material(
                                                        color: Constanst
                                                            .colorWhite,
                                                        child: InkWell(
                                                          customBorder:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                Constanst
                                                                    .borderStyle5,
                                                          ),
                                                          onTap: () =>
                                                              Get.to(Informasi(
                                                            index: 3,
                                                          )),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    8.0,
                                                                    3.0,
                                                                    8.0,
                                                                    3.0),
                                                            child: Text(
                                                              "Lihat semua",
                                                              style: GoogleFonts.inter(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Constanst
                                                                      .infoLight),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                  controller.showPkwt.value == false
                                      ? const SizedBox()
                                      : controllerGlobal
                                              .employeeSisaCuti.isEmpty
                                          ? const SizedBox()
                                          : const SizedBox(height: 8),
                                  controller.showPkwt.value == false
                                      ? const SizedBox()
                                      : controllerGlobal
                                              .employeeSisaCuti.isEmpty
                                          ? const SizedBox()
                                          : listReminderPkwt(),
                                  const SizedBox(height: 16),

                                  controller.showUlangTahun.value
                                      ? controller.employeeUltah.isEmpty
                                          ? const SizedBox()
                                          : Column(
                                              children: [
                                                Container(
                                                  width: double.infinity,
                                                  height: 6,
                                                  color: Constanst
                                                      .colorNeutralBgSecondary,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 16.0,
                                                          top: 16.0,
                                                          right: 8.0),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Ulang tahun bulan ini",
                                                        style:
                                                            GoogleFonts.inter(
                                                                color: Constanst
                                                                    .fgPrimary,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                      ),
                                                      Material(
                                                        color: Constanst
                                                            .colorWhite,
                                                        child: InkWell(
                                                          customBorder:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                Constanst
                                                                    .borderStyle5,
                                                          ),
                                                          onTap: () => Get.to(
                                                            Informasi(index: 1),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    8.0,
                                                                    3.0,
                                                                    8.0,
                                                                    3.0),
                                                            child: Text(
                                                              "Lihat semua",
                                                              style: GoogleFonts.inter(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Constanst
                                                                      .infoLight),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                      : Container(),
                                  controller.employeeUltah.isEmpty
                                      ? const SizedBox()
                                      : const SizedBox(height: 8),
                                  controller.showUlangTahun.value == true
                                      ? controller.employeeUltah.isEmpty
                                          ? const SizedBox()
                                          : listEmployeeUltah()
                                      : const SizedBox(),
                                  controller.showUlangTahun.value == true
                                      ? controller.employeeUltah.isEmpty
                                          ? Container(height: 180)
                                          : const SizedBox(height: 20)
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )

                    // Padding(
                    //   padding: const EdgeInsets.only(left: 5, right: 5),
                    //   child: Row(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Expanded(
                    //         child: Text(
                    //           "Menu",
                    //           style: TextStyle(
                    //               fontWeight: FontWeight.bold, fontSize: 14),
                    //         ),
                    //       ),
                    //       Expanded(
                    //         child: Text(
                    //           "Lihat semua",
                    //           textAlign: TextAlign.right,
                    //           style: TextStyle(
                    //               fontWeight: FontWeight.bold,
                    //               color: Constanst.colorPrimary,
                    //               fontSize: 10),
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
        ),
      ),
    );
    // );
  }

  Widget informasiUser() {
    return IntrinsicHeight(
      child: InkWell(
        onTap: () {
          print("tes");
          print(intervalTracking.toString());
          //  FlutterBackgroundService().invoke("setAsBackground");
          // Get.to(PersonalInfo());
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
//  void _checkversion() async {
//     try {
//       final newVersion = NewVersionPlus(
//         androidId: 'com.siscom.siscomhris',
//       );

//       final status = await newVersion.getVersionStatus();

//       if (status != null) {
//         if (status.localVersion != status.storeVersion) {
//           if (context.mounted) {
//             newVersion.showUpdateDialog(
//                 context: context,
//                 versionStatus: status,
//                 dialogTitle: "Update SISCOM HRIS",
//                 dialogText:
//                     "Update versi SISCOM HRIS dari versi ${status.localVersion} ke versi ${status.storeVersion}",
//                 dismissAction: () {
//                   Get.back();
//                 },
//                 updateButtonText: "Update Sekarang",
//                 dismissButtonText: "Skip");
//             print("status yesy ${status.localVersion}");
//           }
//         }
//       } else {}
//     } catch (e) {}
//   }

                      Text(
                        "VERSI APLIKASI SAAT INI : ${controller.statuz.value}",
                        style: GoogleFonts.inter(
                            color: Constanst.fgSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                  _isVisible
                      ? Column(
                          children: [
                            Text(
                              AppData.informasiUser![0].branchName.toString(),
                              style: GoogleFonts.inter(
                                  color: Constanst.fgSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                              overflow: TextOverflow
                                  .ellipsis, // Untuk menghindari overflow
                            ),
                            const SizedBox(height: 8),
                          ],
                        )
                      : Container(),
                  Text(
                    "${AppData.informasiUser![0].full_name ?? ""}",
                    style: GoogleFonts.inter(
                        color: Constanst.fgPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                    overflow:
                        TextOverflow.ellipsis, // Untuk menghindari overflow
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${AppData.informasiUser![0].emp_jobTitle ?? ""} - ${AppData.informasiUser![0].posisi ?? ""}",
                    style: GoogleFonts.inter(
                        color: Constanst.fgPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                    overflow:
                        TextOverflow.ellipsis, // Untuk menghindari overflow
                  ),
                ],
              ),
            ),

            AppData.informasiUser![0].em_image == ""
                ? Row(
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.only(right: 5),
                      //   child: SizedBox(
                      //     width: 20,
                      //     height: 20,
                      //     child: Obx(() {
                      //       return Container(
                      //         decoration: BoxDecoration(
                      //           color: authController.isConnected.value
                      //               ? Constanst.color5
                      //               : Constanst.color4,
                      //           borderRadius: BorderRadius.circular(20),
                      //         ),
                      //       );
                      //     }),
                      //   ),
                      // ),
                      // InkWell(
                      //   onTap: () {
                      //     Get.to(HistoryChat());
                      //   },
                      //   child: Padding(
                      //       padding: EdgeInsets.only(right: 5),
                      //       child: Container(
                      //         width: 30,
                      //         height: 30,
                      //         child: Stack(
                      //           children: [
                      //             CircleAvatar(
                      //               radius: 7,
                      //               backgroundColor: Colors.red,
                      //               child: TextLabell(
                      //                 text: chatController.jumlahChat.value
                      //                     .toString(),
                      //                 color: Colors.black,
                      //               ),
                      //             ),
                      //             Image.asset(
                      //               'assets/chat.png',
                      //               width: 20,
                      //               height: 20,
                      //             ),
                      //           ],
                      //         ),
                      //       )),
                      // ),
                      SvgPicture.asset(
                        'assets/avatar_default.svg',
                        width: _isVisible ? 50 : 42,
                        height: _isVisible ? 50 : 42,
                      ),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Row(
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.only(right: 5),
                        //   child: SizedBox(
                        //     width: 18,
                        //     height: 18,
                        //     child: Obx(() {
                        //       return Container(
                        //         decoration: BoxDecoration(
                        //           color: authController.isConnected.value
                        //               ? Constanst.color5
                        //               : Constanst.color4,
                        //           borderRadius: BorderRadius.circular(20),
                        //         ),
                        //       );
                        //     }),
                        //   ),
                        // ),
                        // InkWell(
                        //   onTap: () {
                        //     Get.to(HistoryChat());
                        //   },
                        //   child: Padding(
                        //       padding: EdgeInsets.only(right: 5),
                        //       child: Container(
                        //         width: 30,
                        //         height: 30,
                        //         child: Stack(
                        //           children: [
                        //             Obx(
                        //               () => CircleAvatar(
                        //                 radius: 7,
                        //                 backgroundColor: Colors.red,
                        //                 child: TextLabell(
                        //                   text: chatController.jumlahChat.value
                        //                       .toString(),
                        //                   color: Colors.white,
                        //                   weight: FontWeight.bold,
                        //                 ),
                        //               ),
                        //             ),
                        //             Image.asset(
                        //               'assets/chat.png',
                        //               width: 20,
                        //               height: 20,
                        //             ),
                        //           ],
                        //         ),
                        //       )),
                        // ),
                        CircleAvatar(
                          radius: 25, // Image radius
                          child: ClipOval(
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl:
                                    "${Api.UrlfotoProfile}${AppData.informasiUser![0].em_image}",
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        Container(
                                  alignment: Alignment.center,
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  width: MediaQuery.of(context).size.width,
                                  child: CircularProgressIndicator(
                                      value: downloadProgress.progress),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.white,
                                  child: SvgPicture.asset(
                                    'assets/avatar_default.svg',
                                    width: 40,
                                    height: 40,
                                  ),
                                ),
                                fit: BoxFit.cover,
                                width: 50,
                                height: 50,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            // Expanded(
            //   flex: 15,
            //   child: SizedBox(),

            //         )
            //       ],
            //     ),
            //   ),
            // ),

            // child: Stack(
            //   children: [
            //     InkWell(
            //       onTap: () {
            //         var pesanCtrl = Get.find<PesanController>();
            //         pesanCtrl.routesIcon();
            //         pushNewScreen(
            //           Get.context!,
            //           screen: Pesan(
            //             status: false,
            //           ),
            //           withNavBar: false,
            //         );
            //       },
            //       child: Padding(
            //         padding: const EdgeInsets.only(bottom: 10),
            //         child: Center(
            //           child: CircleAvatar(
            //             backgroundColor: Constanst.colorWhite,
            //             child: Icon(
            //               Iconsax.notification,
            //               color: Colors.black,
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //     controllerPesan.jumlahNotifikasiBelumDibaca.value == 0
            //         ? SizedBox()
            //         : Padding(
            //             padding: const EdgeInsets.only(bottom: 24, left: 16),
            //             child: Center(
            //                 child: AnimatedTextKit(
            //               animatedTexts: [
            //                 FadeAnimatedText(
            //                   // "${controllerPesan.jumlahNotifikasiBelumDibaca.value}",
            //                   "🔴",
            //                   textStyle: const TextStyle(
            //                     fontSize: 10.0,
            //                     // color: Color.fromARGB(255, 255, 174, 0),
            //                     fontWeight: FontWeight.bold,
            //                   ),
            //                   duration: const Duration(milliseconds: 2000),
            //                 ),
            //               ],
            //               totalRepeatCount: 500,
            //               pause: const Duration(milliseconds: 100),
            //               displayFullTextOnTap: true,
            //               stopPauseOnTap: true,
            //             )),
            //           )
            //   ],
            // )

            // ),
          ],
        ),
      ),
    );
  }

  Widget cardInfoAbsen() {
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: Constanst.borderStyle1,
      ),
      onTap: () {
        // widgetButtomSheetFaceRegistrattion();
      },
      child: Container(
        width: MediaQuery.of(Get.context!).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: Constanst.borderStyle1,
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 155, 155, 155).withOpacity(0.5),
              spreadRadius: 0.1,
              blurRadius: 3,
              offset: const Offset(1, 1), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // InkWell(
            //     onTap: () {
            //       print(AppData.informasiUser![0].endTime);
            //     },
            //     // onTap: () => controller.getMenuTest(),
            //     child: Text(
            //       "Live Attendance",
            //       style: TextStyle(
            //           fontSize: 14,
            //           fontWeight: FontWeight.bold,
            //           color: Constanst.color2),
            //     )),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Column(
                children: [
                  Row(
// >>>>>>> main
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.timeString.value,
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  color: Constanst.fgPrimary),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              controller.dateNow.value,
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Constanst.fgPrimary),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Obx(
                                  () => Text(
                                    "Jadwal ${controller.timeIn.value}  - ${controller.timeOut.value}",
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Constanst.fgSecondary),
                                  ),
                                ),
                                // const SizedBox(width: 8),
                                // InkWell(
                                //   onTap: () => UtilsAlert.informasiDashboard(
                                //       Get.context!),
                                //   child: Icon(
                                //     Iconsax.info_circle,
                                //     size: 16,
                                //     color: Constanst.fgSecondary,
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: Constanst.borderStyle1,
                            child: Image.asset(
                              'assets/cardInfoImage.gif',
                              height: 101,
                            ),
                          ),
                          Positioned(
                            bottom: 2,
                            right: 2,
                            child: Container(
                              color: Colors.white,
                              width: 30,
                              height: 10,
                            ),
                          )
                        ],
                      ),
                      // Expanded(
                      //   flex: 30,
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.end,
                      //     mainAxisAlignment: MainAxisAlignment.end,
                      //     children: [
                      //       const SizedBox(height: 4),
                      //       Obx(() {
                      //         return controllerAbsensi.init.timeIn != ""
                      //             ? Text(
                      //                 "${controllerAbsensi.shift.value.timeIn ?? ""} - ${controllerAbsensi.shift.value.timeOut ?? ""}",
                      //                 style: TextStyle(
                      //                     fontSize: 10,
                      //                     color: Constanst.colorText2),
                      //               )
                      //             : const Text("");
                      //       })
                      //     ],
                      //   ),
                      // )
                    ],
                  ),
                ],
              ),
            ),

            // _isVisible
            //     ?
            controller.showAbsen.value == false
                ? SizedBox()
                : Column(
                    children: [
                      const Divider(
                        thickness: 1,
                        height: 0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 165,
                            child: Material(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(15.0),
                              ),
                              color:
                                  // (controller.signinTime.value !=
                                  //             "00:00:00" &&
                                  //         controller.trx.value.toUpperCase() !=
                                  //             "TLM")
                                  //     ? Constanst.colorNonAktif
                                  //     :
                                  !controllerAbsensi.absenStatus.value //&&
                                      // !controller.pendingSignoutApr.value
                                      ? Constanst.colorWhite
                                      : Constanst.colorNonAktif,
                              child: InkWell(
                                customBorder: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15.0),
                                  ),
                                ),
                                onTap: () {
                                  // if (AppData.informasiUser![0].sisaKontrak
                                  //             .toString() ==
                                  //         'null' ||
                                  //     AppData.informasiUser![0].sisaKontrak ==
                                  //         '') {
                                  // } else {
                                  //   if (double.tryParse(AppData
                                  //               .informasiUser![0].sisaKontrak
                                  //               .toString())! <=
                                  //           0 &&
                                  //       AppData.informasiUser![0].em_status! !=
                                  //           "PERMANENT") {
                                  //     showGeneralDialog(
                                  //       barrierDismissible: false,
                                  //       context: Get.context!,
                                  //       barrierColor: Colors
                                  //           .black54, // space around dialog
                                  //       transitionDuration:
                                  //           const Duration(milliseconds: 200),
                                  //       transitionBuilder:
                                  //           (context, a1, a2, child) {
                                  //         return ScaleTransition(
                                  //           scale: CurvedAnimation(
                                  //               parent: a1,
                                  //               curve: Curves.elasticOut,
                                  //               reverseCurve:
                                  //                   Curves.easeOutCubic),
                                  //           child: CustomDialog(
                                  //             title: "Informasi",
                                  //             content: controller
                                  //                 .informasiHabisKontrak,
                                  //             positiveBtnText: "Refresh",
                                  //             negativeBtnText: "Kembali",
                                  //             style: 1,
                                  //             buttonStatus: 1,
                                  //             positiveBtnPressed: () async {
                                  //               print("logout");
                                  //               UtilsAlert.loadingSimpanData(
                                  //                   context,
                                  //                   "Tunggu Sebentar...");

                                  //               AppData.isLogin = false;
                                  //               settingController
                                  //                   .aksiEditLastLogin();
                                  //               controllerTracking
                                  //                   .stopService();
                                  //               controllerTracking
                                  //                   .isTrackingLokasi
                                  //                   .value = false;
                                  //               // refreshData();
                                  //             },
                                  //           ),
                                  //         );
                                  //       },
                                  //       pageBuilder: (BuildContext context,
                                  //           Animation animation,
                                  //           Animation secondaryAnimation) {
                                  //         return null!;
                                  //       },
                                  //     );
                                  //     return;
                                  //   }
                                  // }
                                  // ;

                                  // else if (controller.signinTime.value !=
                                  //         "00:00:00" &&
                                  //     controller.trx.value.toUpperCase() !=
                                  //         "TLM") {
                                  //   UtilsAlert.showToast(
                                  //       "Absensi hanya bisa dilakukan satu kali saja");
                                  //   return;
                                  // }
                                  if (controllerAbsensi.absenStatus.value ==
                                      true) {
                                    if (controller.wfhstatus.value) {
                                      UtilsAlert.showToast(
                                          "Menunggu status wfh anda di approve");
                                      return;
                                    }
                                    UtilsAlert.showToast(
                                        "Anda harus absen keluar terlebih dahulu");
                                  } else {
                                    var dataUser = AppData.informasiUser;
                                    var faceRecog = dataUser![0].face_recog;
                                    print(
                                        "facee recokkk ${GetStorage().read('face_recog')}");
                                    if (GetStorage().read('face_recog') ==
                                            true ||
                                        controllerAbsensi.regType.value == 1 ||
                                        controllerAbsensi.regType.value == 2) {
                                      print("masuk sini");
                                      var statusCamera =
                                          Permission.camera.status;
                                      statusCamera.then((value) {
                                        var statusLokasi =
                                            Permission.location.status;
                                        statusLokasi.then((value2) async {
                                          if (value !=
                                                  PermissionStatus.granted ||
                                              value2 !=
                                                  PermissionStatus.granted) {
                                            UtilsAlert.showToast(
                                                "Anda harus aktifkan kamera dan lokasi anda");
                                            controller
                                                .widgetButtomSheetAktifCamera(
                                                    type: 'loadfirst');
                                          } else {
                                            print("masuk absen user");
                                            // if (controller
                                            //         .absenOfflineStatus.value ==
                                            //     true) {
                                            //   UtilsAlert.showToast(
                                            //       "Menunggu status absensi anda di approve");
                                            //   return;
                                            // }
                                            // Get.offAll(AbsenMasukKeluar(
                                            //   status: "Absen Masuk",
                                            //   type: 1,
                                            // ));
                                            //  controllerAbsensi.absenSelfie();

                                            var validasiAbsenMasukUser =
                                                controller
                                                    .validasiAbsenMasukUser();
                                            if (!validasiAbsenMasukUser) {
                                              print("masuk sini");
                                            } else {
                                              // if (!authController
                                              //     .isConnected.value) {
                                              //   if (controller
                                              //           .absenOfflineStatus
                                              //           .value ==
                                              //       true) {
                                              //     UtilsAlert.showToast(
                                              //         "Menunggu status absensi anda di approve");
                                              //     return;
                                              //   } else {
                                              //     controllerAbsensi.titleAbsen
                                              //         .value = "Absen masuk";
                                              //     controllerAbsensi
                                              //         .typeAbsen.value = 1;
                                              //     controller
                                              //         .widgetButtomSheetOfflineAbsen(
                                              //             title: "Absen masuk",
                                              //             status: "masuk");
                                              //   }
                                              // } else {
                                              controllerAbsensi.titleAbsen
                                                  .value = "Absen masuk";

                                              controllerAbsensi
                                                  .typeAbsen.value = 1;

                                              //begin image picker
                                              // final getFoto = await ImagePicker()
                                              //     .pickImage(
                                              //         source: ImageSource.camera,
                                              //         preferredCameraDevice:
                                              //             CameraDevice.front,
                                              //         imageQuality: 100,
                                              //         maxHeight: 350,
                                              //         maxWidth: 350);
                                              // if (getFoto == null) {
                                              //   UtilsAlert.showToast(
                                              //       "Gagal mengambil gambar");
                                              // } else {
                                              //   // controllerAbsensi.facedDetection(
                                              //   //     status: "registration",
                                              //   //     absenStatus: "Absen Masuk",
                                              //   //     img: getFoto.path,
                                              //   //     type: "1");
                                              //   Get.to(LoadingAbsen(
                                              //     file: getFoto.path,
                                              //     status: "detection",
                                              //     statusAbsen: 'masuk',
                                              //   ));
                                              //   // Get.to(FaceidRegistration(
                                              //   //   status: "registration",
                                              //   // ));
                                              // }
                                              //end image picker

                                              //begin face recognition
                                              // Get.to(FaceDetectorView(
                                              //   status: "masuk",
                                              // ));
                                              //end begin face recogniton
                                              controllerAbsensi.isAbsenIstirahat
                                                  .value = false;
                                              if (controllerAbsensi
                                                      .regType.value ==
                                                  1) {
                                                Get.to(AbsensiLocation(
                                                  status: "masuk",
                                                ));
                                              } else if (controllerAbsensi
                                                      .regType.value ==
                                                  0) {
                                                Get.to(FaceDetectorView(
                                                  status: "keluar",
                                                ));
                                                //  Get.to(AbsensiLocation(
                                                //     status: "masuk",
                                                //   ));
                                              } else {
                                                Get.to(AbsenMasukKeluar(
                                                  status: "Absen Masuk",
                                                ));
                                              }

                                              // // controllerAbsensi.getPlaceCoordinate();
                                              // ;
                                              // controllerAbsensi.facedDetection(
                                              //     status: "detection",
                                              //     absenStatus: "masuk",
                                              //     type: "1");

                                              // var kalkulasiRadius =
                                              //     controller.radiusNotOpen();
                                              // Get.to(faceDetectionPage(
                                              //   status: "masuk",
                                              // ));
                                              // kalkulasiRadius.then((value) {
                                              //   print(value);
                                              //   // if (value) {
                                              //   //   controllerAbsensi.titleAbsen.value =
                                              //   //       "Absen Masuk";
                                              //   //   controllerAbsensi.typeAbsen.value = 1;
                                              //   //   Get.offAll(faceDetectionPage());
                                              //   //   // controllerAbsensi.absenSelfie();
                                              //   // }
                                              // });
                                              // }
                                            }
                                          }
                                        });
                                      });
                                    } else {
                                      controllerAbsensi
                                          .widgetButtomSheetFaceRegistrattion();
                                    }
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 4, top: 12.0, bottom: 6),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(
                                            Iconsax.login5,
                                            color:
                                                // (controller
                                                //                 .signinTime.value !=
                                                //             "00:00:00" &&
                                                //         controller.trx.value
                                                //                 .toUpperCase() !=
                                                //             "TLM")
                                                //     ? const Color.fromARGB(
                                                //         168, 166, 167, 158)
                                                //     :
                                                !controllerAbsensi
                                                        .absenStatus.value // &&
                                                    // !controller
                                                    //     .pendingSignoutApr.value
                                                    ? Constanst.color5
                                                    : const Color.fromARGB(
                                                        168, 166, 167, 158),
                                            size: 26,
                                          ),
                                          const SizedBox(width: 4),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Masuk",
                                                style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                  color:
                                                      // (controller.signinTime
                                                      //                 .value !=
                                                      //             "00:00:00" &&
                                                      //         controller.trx.value
                                                      //                 .toUpperCase() !=
                                                      //             "TLM")
                                                      //     ? const Color.fromARGB(
                                                      //         168, 166, 167, 158)
                                                      //     :
                                                      !controllerAbsensi
                                                              .absenStatus
                                                              .value //&&
                                                          // !controller
                                                          //     .pendingSignoutApr
                                                          //     .value
                                                          ? Constanst.fgPrimary
                                                          : const Color
                                                              .fromARGB(168,
                                                              166, 167, 158),
                                                ),
                                              ),
                                              Obx(
                                                () => Text(
                                                  // !authController
                                                  //         .isConnected.value
                                                  //     ? controller.signinTime
                                                  //                 .value ==
                                                  //             "00:00:00"
                                                  //         ? "_ _:_ _:_ _"
                                                  //         : controller
                                                  //             .signinTime.value
                                                  // :
                                                  controller.signinTime.value ==
                                                          "00:00:00"
                                                      ? "_ _:_ _:_ _"
                                                      : controller
                                                          .signinTime.value,
                                                  style: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16,
                                                      color:
                                                          // (controller
                                                          //                 .signinTime
                                                          //                 .value !=
                                                          //             "00:00:00" &&
                                                          //         controller
                                                          //                 .trx.value
                                                          //                 .toUpperCase() !=
                                                          //             "TLM")
                                                          //     ? const Color
                                                          //         .fromARGB(168,
                                                          //         166, 167, 158)
                                                          //     :
                                                          !controllerAbsensi
                                                                  .absenStatus
                                                                  .value //&&
                                                              // !controller
                                                              //     .pendingSignoutApr
                                                              //     .value
                                                              ? Constanst
                                                                  .fgPrimary
                                                              : const Color
                                                                  .fromARGB(
                                                                  168,
                                                                  166,
                                                                  167,
                                                                  158)),
                                                ),
                                              ),
                                              controller.status.value == "[]" &&
                                                      controller.wfhstatus.value
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 4.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          // Icon(
                                                          //   Iconsax.timer,
                                                          //   color: Constanst
                                                          //       .color3,
                                                          //   size: 15,
                                                          // ),
                                                          // SizedBox(width: 2),
                                                          Obx(
                                                            () => Text(
                                                              // controller
                                                              //     .status.value,
                                                              "Pending WFH Approval",
                                                              style: GoogleFonts.inter(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 9,
                                                                  color: !controllerAbsensi
                                                                          .absenStatus
                                                                          .value
                                                                      ? Constanst
                                                                          .fgPrimary
                                                                      : Constanst
                                                                          .color4),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : Container(),
                                              // (controller.absenOfflineStatus
                                              //                 .value &&
                                              //             controllerAbsensi
                                              //                 .absenStatus
                                              //                 .value) ||
                                              //         controller
                                              //             .pendingSigninApr
                                              //             .value
                                              //     ? Padding(
                                              //         padding:
                                              //             const EdgeInsets.only(
                                              //                 top: 4.0),
                                              //         child: Row(
                                              //           mainAxisAlignment:
                                              //               MainAxisAlignment
                                              //                   .spaceBetween,
                                              //           crossAxisAlignment:
                                              //               CrossAxisAlignment
                                              //                   .center,
                                              //           children: [
                                              //             // Icon(
                                              //             //   Iconsax.timer,
                                              //             //   color: Constanst
                                              //             //       .color3,
                                              //             //   size: 15,
                                              //             // ),
                                              //             // SizedBox(width: 2),
                                              //             Obx(
                                              //               () => Row(
                                              //                 children: [
                                              //                   Text(
                                              //                     // controller
                                              //                     //     .status.value,
                                              //                     controller
                                              //                             .textPendingMasuk
                                              //                             .value
                                              //                         ? "Pending Absensi"
                                              //                         : "Pending Approval",
                                              //                     style:
                                              //                         GoogleFonts
                                              //                             .inter(
                                              //                       fontWeight:
                                              //                           FontWeight
                                              //                               .w500,
                                              //                       fontSize: 9,
                                              //                       color: Constanst
                                              //                           .color4,
                                              //                     ),
                                              //                   ),
                                              //                   Visibility(
                                              //                     visible: controller
                                              //                         .textPendingMasuk
                                              //                         .value,
                                              //                     child: Row(
                                              //                       children: [
                                              //                         const SizedBox(
                                              //                           width:
                                              //                               2,
                                              //                         ),
                                              //                         Icon(
                                              //                           Iconsax
                                              //                               .clock,
                                              //                           size: 8,
                                              //                           color: Constanst
                                              //                               .color4,
                                              //                         ),
                                              //                       ],
                                              //                     ),
                                              //                   ),
                                              //                 ],
                                              //               ),
                                              //             ),
                                              //           ],
                                              //         ),
                                              //       )
                                              //     : Container()
                                            ],
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Icon(
                                              Iconsax.arrow_right_3,
                                              color: Constanst
                                                  .colorNeutralFgTertiary,
                                              size: 18,
                                            ),
                                            const SizedBox(height: 22),
                                            controller.status.value == "[]" &&
                                                    controller.wfhstatus.value
                                                ? controller.approveStatus
                                                            .value ==
                                                        "Approve"
                                                    ? Container()
                                                    : GestureDetector(
                                                        onTap: () {
                                                          controller
                                                              .widgetButtomSheetWfhDelete();
                                                        },
                                                        child: Icon(
                                                          Iconsax.close_circle5,
                                                          color:
                                                              Constanst.color4,
                                                          size: 15,
                                                        ),
                                                      )
                                                : Container(),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 18),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              color: Constanst.fgBorder,
                              height: 36,
                              width: 1,
                            ),
                          ),
                          Expanded(
                            flex: 165,
                            child: Material(
                              color:
                                  // controller.signoutTime.value !=
                                  //             "00:00:00" &&
                                  //         controller.trx.value.toUpperCase() !=
                                  //             "TLM"
                                  //     ? Constanst.colorNonAktif
                                  //     :
                                  controller.status.value == "[]" &&
                                          controller.wfhstatus.value
                                      ? Constanst.colorWhite
                                      : controllerAbsensi.absenStatus.value //&&
                                          // !controller.pendingSignoutApr.value
                                          ? Constanst.colorWhite
                                          : Constanst.colorNonAktif,
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(15.0),
                              ),
                              child: InkWell(
                                customBorder: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(15.0),
                                  ),
                                ),
                                onTap: () {
                                  // if (controller.pendingSignoutApr.value) {
                                  //   UtilsAlert.showToast(
                                  //       "Menunggu status absensi anda di approve");
                                  //   return;
                                  // }
                                  // if (controller.signoutTime.value !=
                                  //         "00:00:00" &&
                                  //     controller.trx.value.toUpperCase() !=
                                  //         "TLM") {
                                  //   UtilsAlert.showToast(
                                  //       "Absensi hanya bisa dilakukan satu kali saja");
                                  //   return;
                                  // } else
                                  if (!controllerAbsensi.absenStatus.value) {
                                    UtilsAlert.showToast(
                                        "Absen Masuk terlebih dahulu");
                                  } else if (controller.status.value == "[]" &&
                                      controller.wfhstatus.value) {
                                    UtilsAlert.showToast(
                                        "Abeen WFH beluum di approve");
                                  } else {
                                    // if (!authController.isConnected.value) {
                                    //   // if (controller
                                    //   //         .absenOfflineStatusDua.value ==
                                    //   //     true) {
                                    //   //   UtilsAlert.showToast(
                                    //   //       "Menunggu status absensi anda di approve");
                                    //   //   return;
                                    //   // } else {
                                    //   controllerAbsensi.getPlaceCoordinate();
                                    //   controllerAbsensi.titleAbsen.value =
                                    //       "Absen Keluar";
                                    //   controllerAbsensi.typeAbsen.value = 2;
                                    //   controller.widgetButtomSheetOfflineAbsen(
                                    //       title: "Absen Keluar",
                                    //       status: "keluar");
                                    //   // }
                                    // } else {
                                    //   if (controller.absenOfflineStatus.value ==
                                    //       true) {
                                    //     UtilsAlert.showToast(
                                    //         "Menunggu status absensi anda di approve");
                                    //     return;
                                    //   }

                                    var dataUser = AppData.informasiUser;
                                    var faceRecog = dataUser![0].face_recog;

                                    if (GetStorage().read('face_recog') ==
                                            true ||
                                        controllerAbsensi.regType.value == 1 ||
                                        controllerAbsensi.regType.value == 2) {
                                      controllerAbsensi.getPlaceCoordinate();
                                      controllerAbsensi.titleAbsen.value =
                                          "Absen Keluar";
                                      controllerAbsensi.typeAbsen.value = 2;

                                      //begin image picker
                                      // final getFoto = await ImagePicker()
                                      //     .pickImage(
                                      //         source: ImageSource.camera,
                                      //         preferredCameraDevice:
                                      //             CameraDevice.front,
                                      //         imageQuality: 100,
                                      //         maxHeight: 350,
                                      //         maxWidth: 350);
                                      // if (getFoto == null) {
                                      //   UtilsAlert.showToast(
                                      //       "Gagal mengambil gambar");
                                      // } else {
                                      //   // controllerAbsensi.facedDetection(
                                      //   //     status: "registration",
                                      //   //     absenStatus: "Absen Masuk",
                                      //   //     img: getFoto.path,
                                      //   //     type: "1");
                                      //   Get.to(LoadingAbsen(
                                      //     file: getFoto.path,
                                      //     status: "detection",
                                      //     statusAbsen: 'keluar',
                                      //   ));
                                      //   // Get.to(FaceidRegistration(
                                      //   //   status: "registration",
                                      //   // ));
                                      // }
                                      //end image picker
                                      controllerAbsensi.isAbsenIstirahat.value =
                                          false;

                                      if (controllerAbsensi.regType.value ==
                                          1) {
                                        Get.to(AbsensiLocation(
                                          status: "keluar",
                                        ));
                                      } else if (controllerAbsensi
                                              .regType.value ==
                                          0) {
                                        Get.to(FaceDetectorView(
                                          status: "keluar",
                                        ));
                                      } else {
                                        Get.to(
                                            AbsenMasukKeluar(status: "keluar"));
                                      }

                                      // controllerAbsensi.facedDetection(
                                      //     status: "detection",
                                      //     type: "2",
                                      // //     absenStatus: "keluar");
                                      // Get.to(faceDetectionPage(
                                      //   status: "keluar",
                                      // ));
                                      // Get.offAll(AbsenMasukKeluar(
                                      //   status: "Absen Keluar",
                                      //   type: 2,
                                      // ));
                                      // controllerAbsensi.absenSelfie();
                                      // var validasiAbsenMasukUser =
                                      //     controller.validasiAbsenMasukUser();
                                      // print(validasiAbsenMasukUser);
                                      // if (validasiAbsenMasukUser == false) {

                                      // } else {
                                      //   var kalkulasiRadius =
                                      //       controller.radiusNotOpen();
                                      //   kalkulasiRadius.then((value) {
                                      //     if (value) {
                                      //       controllerAbsensi.titleAbsen.value =
                                      //           "Absen Keluar";
                                      //       controllerAbsensi.typeAbsen.value = 2;
                                      //       Get.offAll(AbsenMasukKeluar());
                                      //       controllerAbsensi.absenSelfie();
                                      //     }
                                      //   });
                                      // }
                                    } else {
                                      controllerAbsensi
                                          .widgetButtomSheetFaceRegistrattion();
                                    }
                                    // }
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 12.0, bottom: 12, right: 12.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 10,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(width: 18),
                                            Icon(
                                              Iconsax.logout_15,
                                              color: controller.status.value ==
                                                          "[]" &&
                                                      controller.wfhstatus.value
                                                  ? const Color.fromARGB(
                                                      168, 166, 167, 158)
                                                  : controllerAbsensi
                                                          .absenStatus.value
                                                      ? Constanst.color4
                                                      : const Color.fromARGB(
                                                          168, 166, 167, 158),
                                              size: 26,
                                            ),
                                            const SizedBox(width: 8),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Keluar",
                                                  style: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16,
                                                      color: controller.status
                                                                      .value ==
                                                                  "[]" &&
                                                              controller
                                                                  .wfhstatus
                                                                  .value
                                                          ? const Color
                                                              .fromARGB(168,
                                                              166, 167, 158)
                                                          : controllerAbsensi
                                                                  .absenStatus
                                                                  .value
                                                              ? Constanst
                                                                  .fgPrimary
                                                              : const Color
                                                                  .fromARGB(
                                                                  168,
                                                                  166,
                                                                  167,
                                                                  158)),
                                                ),
                                                Obx(
                                                  () => Text(
                                                    // !authController
                                                    //         .isConnected.value
                                                    //     ? controller.signoutTime
                                                    //                     .value ==
                                                    //                 "00:00:00" ||
                                                    //             controller
                                                    //                     .signoutTime
                                                    //                     .value ==
                                                    //                 "null"
                                                    //         ? "_ _:_ _:_ _"
                                                    //         : controller
                                                    //             .signoutTime
                                                    //             .value
                                                    //     :
                                                    controller.signoutTime
                                                                .value ==
                                                            "00:00:00"
                                                        ? "_ _:_ _:_ _"
                                                        : controller
                                                            .signoutTime.value,
                                                    style: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 16,
                                                        color: controller
                                                                        .status.value ==
                                                                    "[]" &&
                                                                controller
                                                                    .wfhstatus
                                                                    .value
                                                            ? const Color
                                                                .fromARGB(168,
                                                                166, 167, 158)
                                                            : controllerAbsensi
                                                                    .absenStatus
                                                                    .value
                                                                ? Constanst
                                                                    .fgPrimary
                                                                : const Color
                                                                    .fromARGB(
                                                                    168,
                                                                    166,
                                                                    167,
                                                                    158)),
                                                  ),
                                                ),
                                                controller.status.value ==
                                                            "[]" &&
                                                        controller
                                                            .wfhstatus.value
                                                    ? Container(
                                                        height: 20,
                                                      )
                                                    : Container(),
                                                // (controller.absenOfflineStatus
                                                //                 .value &&
                                                //             !controllerAbsensi
                                                //                 .absenStatus
                                                //                 .value) ||
                                                //         controller
                                                //             .pendingSignoutApr
                                                //             .value
                                                //     ? Padding(
                                                //         padding:
                                                //             const EdgeInsets
                                                //                 .only(top: 4.0),
                                                //         child: Row(
                                                //           mainAxisAlignment:
                                                //               MainAxisAlignment
                                                //                   .spaceBetween,
                                                //           crossAxisAlignment:
                                                //               CrossAxisAlignment
                                                //                   .center,
                                                //           children: [
                                                //             // Icon(
                                                //             //   Iconsax.timer,
                                                //             //   color: Constanst
                                                //             //       .color3,
                                                //             //   size: 15,
                                                //             // ),
                                                //             // SizedBox(width: 2),
                                                //             Obx(
                                                //               () => Row(
                                                //                 children: [
                                                //                   Text(
                                                //                     // controller
                                                //                     //     .status.value,
                                                //                     controller
                                                //                             .textPendingKeluar
                                                //                             .value
                                                //                         ? "Pending Absensi"
                                                //                         : "Pending Approval",
                                                //                     style: GoogleFonts
                                                //                         .inter(
                                                //                       fontWeight:
                                                //                           FontWeight
                                                //                               .w500,
                                                //                       fontSize:
                                                //                           9,
                                                //                       color: Constanst
                                                //                           .color4,
                                                //                     ),
                                                //                   ),
                                                //                   Visibility(
                                                //                     visible: controller
                                                //                         .textPendingKeluar
                                                //                         .value,
                                                //                     child: Row(
                                                //                       children: [
                                                //                         const SizedBox(
                                                //                           width:
                                                //                               2,
                                                //                         ),
                                                //                         Icon(
                                                //                           Iconsax
                                                //                               .clock,
                                                //                           size:
                                                //                               8,
                                                //                           color:
                                                //                               Constanst.color4,
                                                //                         ),
                                                //                       ],
                                                //                     ),
                                                //                   ),
                                                //                 ],
                                                //               ),
                                                //             ),
                                                //           ],
                                                //         ),
                                                //       )
                                                //     : Container()
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Icon(
                                          Iconsax.arrow_right_3,
                                          color:
                                              Constanst.colorNeutralFgTertiary,
                                          size: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
            // : Container(),

            // _isVisible
            //     ? Row(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Expanded(
            //             child: Padding(
            //                 padding: const EdgeInsets.only(right: 8),
            //                 child: TextButtonWidget2(
            //                     title: "Absen Masuk",
            //                     onTap: () async {
            //                       if (controllerAbsensi.absenStatus.value ==
            //                           true) {
            //                         UtilsAlert.showToast(
            //                             "Anda harus absen keluar terlebih dahulu");
            //                       } else {
            //                         var dataUser = AppData.informasiUser;
            //                         var faceRecog = dataUser![0].face_recog;
            //                         print(
            //                             "facee recog ${GetStorage().read('face_recog')}");
            //                         if (GetStorage().read('face_recog') ==
            //                             true) {
            //                           print("masuk sini");
            //                           var statusCamera =
            //                               Permission.camera.status;
            //                           statusCamera.then((value) {
            //                             var statusLokasi =
            //                                 Permission.location.status;
            //                             statusLokasi.then((value2) async {
            //                               if (value !=
            //                                       PermissionStatus.granted ||
            //                                   value2 !=
            //                                       PermissionStatus.granted) {
            //                                 UtilsAlert.showToast(
            //                                     "Anda harus aktifkan kamera dan lokasi anda");
            //                                 controller
            //                                     .widgetButtomSheetAktifCamera(
            //                                         'loadfirst');
            //                               } else {
            //                                 print("masuk absen user");
            //                                 // Get.offAll(AbsenMasukKeluar(
            //                                 //   status: "Absen Masuk",
            //                                 //   type: 1,
            //                                 // ));
            //                                 //  controllerAbsensi.absenSelfie();

            //                                 var validasiAbsenMasukUser =
            //                                     controller
            //                                         .validasiAbsenMasukUser();
            //                                 if (!validasiAbsenMasukUser) {
            //                                   print("masuk sini");
            //                                 } else {
            //                                   controllerAbsensi.titleAbsen
            //                                       .value = "Absen masuk";

            //                                   controllerAbsensi
            //                                       .typeAbsen.value = 1;

            //                                   //begin image picker
            //                                   // final getFoto = await ImagePicker()
            //                                   //     .pickImage(
            //                                   //         source: ImageSource.camera,
            //                                   //         preferredCameraDevice:
            //                                   //             CameraDevice.front,
            //                                   //         imageQuality: 100,
            //                                   //         maxHeight: 350,
            //                                   //         maxWidth: 350);
            //                                   // if (getFoto == null) {
            //                                   //   UtilsAlert.showToast(
            //                                   //       "Gagal mengambil gambar");
            //                                   // } else {
            //                                   //   // controllerAbsensi.facedDetection(
            //                                   //   //     status: "registration",
            //                                   //   //     absenStatus: "Absen Masuk",
            //                                   //   //     img: getFoto.path,
            //                                   //   //     type: "1");
            //                                   //   Get.to(LoadingAbsen(
            //                                   //     file: getFoto.path,
            //                                   //     status: "detection",
            //                                   //     statusAbsen: 'masuk',
            //                                   //   ));
            //                                   //   // Get.to(FaceidRegistration(
            //                                   //   //   status: "registration",
            //                                   //   // ));
            //                                   // }
            //                                   //end image picker

            //                                   //begin face recognition
            //                                   // Get.to(FaceDetectorView(
            //                                   //   status: "masuk",
            //                                   // ));
            //                                   //end begin face recogniton

            //                                   if (controllerAbsensi
            //                                           .regType.value ==
            //                                       1) {
            //                                     Get.to(AbsensiLocation(
            //                                       status: "masuk",
            //                                     ));
            //                                   } else {
            //                                     Get.to(FaceDetectorView(
            //                                       status: "masuk",
            //                                     ));
            //                                   }

            //                                   // // controllerAbsensi.getPlaceCoordinate();
            //                                   // ;
            //                                   // controllerAbsensi.facedDetection(
            //                                   //     status: "detection",
            //                                   //     absenStatus: "masuk",
            //                                   //     type: "1");

            //                                   // var kalkulasiRadius =
            //                                   //     controller.radiusNotOpen();
            //                                   // Get.to(faceDetectionPage(
            //                                   //   status: "masuk",
            //                                   // ));
            //                                   // kalkulasiRadius.then((value) {
            //                                   //   print(value);
            //                                   //   // if (value) {
            //                                   //   //   controllerAbsensi.titleAbsen.value =
            //                                   //   //       "Absen Masuk";
            //                                   //   //   controllerAbsensi.typeAbsen.value = 1;
            //                                   //   //   Get.offAll(faceDetectionPage());
            //                                   //   //   // controllerAbsensi.absenSelfie();
            //                                   //   // }
            //                                   // });
            //                                 }
            //                               }
            //                             });
            //                           });
            //                         } else {
            //                           controllerAbsensi
            //                               .widgetButtomSheetFaceRegistrattion();
            //                         }
            //                       }
            //                     },
            //                     colorButton:
            //                         !controllerAbsensi.absenStatus.value
            //                             ? Constanst.colorPrimary
            //                             : Constanst.colorNonAktif,
            //                     colortext: !controllerAbsensi.absenStatus.value
            //                         ? Constanst.colorWhite
            //                         : Color.fromARGB(168, 166, 167, 158),
            //                     border: BorderRadius.circular(5.0),
            //                     icon: Icon(
            //                       Iconsax.login,
            //                       size: 18,
            //                       color: !controllerAbsensi.absenStatus.value
            //                           ? Constanst.colorWhite
            //                           : Color.fromARGB(168, 166, 167, 158),
            //                     ))),
            //           ),
            //           Expanded(
            //             child: Padding(
            //                 padding: EdgeInsets.only(right: 8),
            //                 child: TextButtonWidget2(
            //                     title: "Absen Keluar",
            //                     onTap: () async {
            //                       if (!controllerAbsensi.absenStatus.value) {
            //                         UtilsAlert.showToast(
            //                             "Absen Masuk terlebih dahulu");
            //                       } else {
            //                         var dataUser = AppData.informasiUser;
            //                         var faceRecog = dataUser![0].face_recog;

            //                         if (GetStorage().read('face_recog') ==
            //                             true) {
            //                           controllerAbsensi.getPlaceCoordinate();
            //                           controllerAbsensi.titleAbsen.value =
            //                               "Absen Keluar";
            //                           controllerAbsensi.typeAbsen.value = 2;

            //                           //begin image picker
            //                           // final getFoto = await ImagePicker()
            //                           //     .pickImage(
            //                           //         source: ImageSource.camera,
            //                           //         preferredCameraDevice:
            //                           //             CameraDevice.front,
            //                           //         imageQuality: 100,
            //                           //         maxHeight: 350,
            //                           //         maxWidth: 350);
            //                           // if (getFoto == null) {
            //                           //   UtilsAlert.showToast(
            //                           //       "Gagal mengambil gambar");
            //                           // } else {
            //                           //   // controllerAbsensi.facedDetection(
            //                           //   //     status: "registration",
            //                           //   //     absenStatus: "Absen Masuk",
            //                           //   //     img: getFoto.path,
            //                           //   //     type: "1");
            //                           //   Get.to(LoadingAbsen(
            //                           //     file: getFoto.path,
            //                           //     status: "detection",
            //                           //     statusAbsen: 'keluar',
            //                           //   ));
            //                           //   // Get.to(FaceidRegistration(
            //                           //   //   status: "registration",
            //                           //   // ));
            //                           // }
            //                           //end image picker

            //                           if (controllerAbsensi.regType.value ==
            //                               1) {
            //                             Get.to(AbsensiLocation(
            //                               status: "keluar",
            //                             ));
            //                           } else {
            //                             Get.to(FaceDetectorView(
            //                               status: "keluar",
            //                             ));
            //                           }

            //                           // controllerAbsensi.facedDetection(
            //                           //     status: "detection",
            //                           //     type: "2",
            //                           // //     absenStatus: "keluar");
            //                           // Get.to(faceDetectionPage(
            //                           //   status: "keluar",
            //                           // ));
            //                           // Get.offAll(AbsenMasukKeluar(
            //                           //   status: "Absen Keluar",
            //                           //   type: 2,
            //                           // ));
            //                           // controllerAbsensi.absenSelfie();
            //                           // var validasiAbsenMasukUser =
            //                           //     controller.validasiAbsenMasukUser();
            //                           // print(validasiAbsenMasukUser);
            //                           // if (validasiAbsenMasukUser == false) {

            //                           // } else {
            //                           //   var kalkulasiRadius =
            //                           //       controller.radiusNotOpen();
            //                           //   kalkulasiRadius.then((value) {
            //                           //     if (value) {
            //                           //       controllerAbsensi.titleAbsen.value =
            //                           //           "Absen Keluar";
            //                           //       controllerAbsensi.typeAbsen.value = 2;
            //                           //       Get.offAll(AbsenMasukKeluar());
            //                           //       controllerAbsensi.absenSelfie();
            //                           //     }
            //                           //   });
            //                           // }
            //                         } else {
            //                           controllerAbsensi
            //                               .widgetButtomSheetFaceRegistrattion();
            //                         }
            //                       }
            //                     },
            //                     colorButton: controllerAbsensi.absenStatus.value
            //                         ? Constanst.colorPrimary
            //                         : Constanst.colorNonAktif,
            //                     colortext: controllerAbsensi.absenStatus.value
            //                         ? Constanst.colorWhite
            //                         : Color.fromARGB(168, 166, 167, 158),
            //                     border: BorderRadius.circular(5.0),
            //                     icon: Icon(
            //                       Iconsax.logout,
            //                       size: 18,
            //                       color: controllerAbsensi.absenStatus.value
            //                           ? Constanst.colorWhite
            //                           : Color.fromARGB(168, 166, 167, 158),
            //                     ))),
            //           ),
            //         ],
            //       )
            //     : Container(),

            Visibility(
              visible: controller.isVisibleAbsenIstirahat(),
              child: Column(
                children: [
                  const Divider(
                    height: 0,
                    thickness: 1,
                  ),
                  cardAbsenIstirahat(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //card info absen lama

//   Widget cardInfoAbsen() {
//     String formatDateTime(DateTime dateTime) {
//     return DateFormat('HH:mm:ss').format(dateTime);
//   }
//   DateTime startDate = DateTime.now();
//     return InkWell(
//       customBorder: RoundedRectangleBorder(
//         borderRadius: Constanst.borderStyle1,
//       ),
//       onTap: () {
//         // Get.to(BerhasilAbsensi(
//         //         dataBerhasil: [
//         //           'Absen Masuk',
//         //           formatDateTime(startDate),
//         //           1,
//         //           1,
//         //         ],
//         //       ));
//         // widgetButtomSheetFaceRegistrattion();
//       },
//       child: Container(
//         width: MediaQuery.of(Get.context!).size.width,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: Constanst.borderStyle1,
//           boxShadow: [
//             BoxShadow(
//               color: const Color.fromARGB(255, 155, 155, 155).withOpacity(0.5),
//               spreadRadius: 0.1,
//               blurRadius: 3,
//               offset: const Offset(1, 1), // changes position of shadow
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // InkWell(
//             //     onTap: () {
//             //       print(AppData.informasiUser![0].endTime);
//             //     },
//             //     // onTap: () => controller.getMenuTest(),
//             //     child: Text(
//             //       "Live Attendance",
//             //       style: TextStyle(
//             //           fontSize: 14,
//             //           fontWeight: FontWeight.bold,
//             //           color: Constanst.color2),
//             //     )),
//             Padding(
//               padding: const EdgeInsets.only(left: 12),
//               child: Column(
//                 children: [
//                   Row(
// // >>>>>>> main
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(top: 12),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               controller.timeString.value,
//                               style: GoogleFonts.inter(
//                                   fontWeight: FontWeight.w500,
//                                   fontSize: 18,
//                                   color: Constanst.fgPrimary),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               controller.dateNow.value,
//                               style: GoogleFonts.inter(
//                                   fontWeight: FontWeight.w400,
//                                   fontSize: 14,
//                                   color: Constanst.fgPrimary),
//                             ),
//                             const SizedBox(height: 4),
//                             Row(
//                               children: [
//                                 Obx(
//                                   () => Text(
//                                     "Jadwal ${controller.timeIn.value}  - ${controller.timeOut.value}",
//                                     style: GoogleFonts.inter(
//                                         fontWeight: FontWeight.w400,
//                                         fontSize: 12,
//                                         color: Constanst.fgSecondary),
//                                   ),
//                                 ),
//                                 // const SizedBox(width: 8),
//                                 // InkWell(
//                                 //   onTap: () => UtilsAlert.informasiDashboard(
//                                 //       Get.context!),
//                                 //   child: Icon(
//                                 //     Iconsax.info_circle,
//                                 //     size: 16,
//                                 //     color: Constanst.fgSecondary,
//                                 //   ),
//                                 // ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       Stack(
//                         children: [
//                           ClipRRect(
//                             borderRadius: Constanst.borderStyle1,
//                             child: Image.asset(
//                               'assets/cardInfoImage.gif',
//                               height: 101,
//                             ),
//                           ),
//                           Positioned(
//                             bottom: 2,
//                             right: 2,
//                             child: Container(
//                               color: Colors.white,
//                               width: 30,
//                               height: 10,
//                             ),
//                           )
//                         ],
//                       ),
//                       // Expanded(
//                       //   flex: 30,
//                       //   child: Column(
//                       //     crossAxisAlignment: CrossAxisAlignment.end,
//                       //     mainAxisAlignment: MainAxisAlignment.end,
//                       //     children: [
//                       //       const SizedBox(height: 4),
//                       //       Obx(() {
//                       //         return controllerAbsensi.shift.value.timeIn != ""
//                       //             ? Text(
//                       //                 "${controllerAbsensi.shift.value.timeIn ?? ""} - ${controllerAbsensi.shift.value.timeOut ?? ""}",
//                       //                 style: TextStyle(
//                       //                     fontSize: 10,
//                       //                     color: Constanst.colorText2),
//                       //               )
//                       //             : const Text("");
//                       //       })
//                       //     ],
//                       //   ),
//                       // )
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             controller.showAbsen.value
//             ? _isVisible
//                 ? Column(
//                     children: [
//                       const Divider(
//                         thickness: 1,
//                         height: 0,
//                       ),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             flex: 165,
//                             child: Material(
//                               borderRadius: const BorderRadius.only(
//                                 bottomLeft: Radius.circular(15.0),
//                               ),
//                               color: !controllerAbsensi.absenStatus.value &&
//                                       !controller.pendingSignoutApr.value
//                                   ? Constanst.colorWhite
//                                   : Constanst.colorNonAktif,
//                               child: InkWell(
//                                 customBorder: const RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.only(
//                                     bottomLeft: Radius.circular(15.0),
//                                   ),
//                                 ),
//                                 onTap: () {
//                                   if (controllerAbsensi.absenStatus.value ==
//                                       true) {
//                                     if (controller.wfhstatus.value) {
//                                       UtilsAlert.showToast(
//                                           "Menunggu status wfh anda di approve");
//                                       return;
//                                     }
//                                     UtilsAlert.showToast(
//                                         "Anda harus absen keluar terlebih dahulu");
//                                   } else {
//                                     var dataUser = AppData.informasiUser;
//                                     var faceRecog = dataUser![0].face_recog;
//                                     print(
//                                         "facee recog ${GetStorage().read('face_recog')}");
//                                     if (GetStorage().read('face_recog') ==
//                                         true) {
//                                       print("masuk sini");
//                                       var statusCamera =
//                                           Permission.camera.status;
//                                       statusCamera.then((value) {
//                                         var statusLokasi =
//                                             Permission.location.status;
//                                         statusLokasi.then((value2) async {
//                                           if (value !=
//                                                   PermissionStatus.granted ||
//                                               value2 !=
//                                                   PermissionStatus.granted) {
//                                             UtilsAlert.showToast(
//                                                 "Anda harus aktifkan kamera dan lokasi anda");
//                                             controller
//                                                 .widgetButtomSheetAktifCamera(
//                                                     type: 'loadfirst');
//                                           } else {
//                                             print("masuk absen user");
//                                             // if (controller
//                                             //         .absenOfflineStatus.value ==
//                                             //     true) {
//                                             //   UtilsAlert.showToast(
//                                             //       "Menunggu status absensi anda di approve");
//                                             //   return;
//                                             // }
//                                             // Get.offAll(AbsenMasukKeluar(
//                                             //   status: "Absen Masuk",
//                                             //   type: 1,
//                                             // ));
//                                             //  controllerAbsensi.absenSelfie();

//                                             var validasiAbsenMasukUser =
//                                                 controller
//                                                     .validasiAbsenMasukUser();
//                                             if (!validasiAbsenMasukUser) {
//                                               print("masuk sini");
//                                             } else {
//                                               // if (!authController
//                                               //     .isConnected.value) {
//                                               //   if (controller
//                                               //           .absenOfflineStatus
//                                               //           .value ==
//                                               //       true) {
//                                               //     UtilsAlert.showToast(
//                                               //         "Menunggu status absensi anda di approve");
//                                               //     return;
//                                               //   } else {
//                                               //     controllerAbsensi.titleAbsen
//                                               //         .value = "Absen masuk";
//                                               //     controllerAbsensi
//                                               //         .typeAbsen.value = 1;
//                                               //     controller
//                                               //         .widgetButtomSheetOfflineAbsen(
//                                               //             title: "Absen masuk",
//                                               //             status: "masuk");
//                                               //   }
//                                               // } else {
//                                               controllerAbsensi.titleAbsen
//                                                   .value = "Absen masuk";

//                                               controllerAbsensi
//                                                   .typeAbsen.value = 1;

//                                               //begin image picker
//                                               // final getFoto = await ImagePicker()
//                                               //     .pickImage(
//                                               //         source: ImageSource.camera,
//                                               //         preferredCameraDevice:
//                                               //             CameraDevice.front,
//                                               //         imageQuality: 100,
//                                               //         maxHeight: 350,
//                                               //         maxWidth: 350);
//                                               // if (getFoto == null) {
//                                               //   UtilsAlert.showToast(
//                                               //       "Gagal mengambil gambar");
//                                               // } else {
//                                               //   // controllerAbsensi.facedDetection(
//                                               //   //     status: "registration",
//                                               //   //     absenStatus: "Absen Masuk",
//                                               //   //     img: getFoto.path,
//                                               //   //     type: "1");
//                                               //   Get.to(LoadingAbsen(
//                                               //     file: getFoto.path,
//                                               //     status: "detection",
//                                               //     statusAbsen: 'masuk',
//                                               //   ));
//                                               //   // Get.to(FaceidRegistration(
//                                               //   //   status: "registration",
//                                               //   // ));
//                                               // }
//                                               //end image picker

//                                               //begin face recognition
//                                               // Get.to(FaceDetectorView(
//                                               //   status: "masuk",
//                                               // ));
//                                               //end begin face recogniton

//                                               if (controllerAbsensi
//                                                       .regType.value ==
//                                                   1) {
//                                                 Get.to(AbsensiLocation(
//                                                   status: "masuk",
//                                                 ));
//                                               } else {
//                                                 Get.to(FaceDetectorView(
//                                                   status: "masuk",
//                                                 ));
//                                               }

//                                               // // controllerAbsensi.getPlaceCoordinate();
//                                               // ;
//                                               // controllerAbsensi.facedDetection(
//                                               //     status: "detection",
//                                               //     absenStatus: "masuk",
//                                               //     type: "1");

//                                               // var kalkulasiRadius =
//                                               //     controller.radiusNotOpen();
//                                               // Get.to(faceDetectionPage(
//                                               //   status: "masuk",
//                                               // ));
//                                               // kalkulasiRadius.then((value) {
//                                               //   print(value);
//                                               //   // if (value) {
//                                               //   //   controllerAbsensi.titleAbsen.value =
//                                               //   //       "Absen Masuk";
//                                               //   //   controllerAbsensi.typeAbsen.value = 1;
//                                               //   //   Get.offAll(faceDetectionPage());
//                                               //   //   // controllerAbsensi.absenSelfie();
//                                               //   // }
//                                               // });
//                                               // }
//                                             }
//                                           }
//                                         });
//                                       });
//                                     } else {
//                                       controllerAbsensi
//                                           .widgetButtomSheetFaceRegistrattion();
//                                     }
//                                   }
//                                 },
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(
//                                       left: 4, top: 12.0, bottom: 6),
//                                   child: Row(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Row(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Icon(
//                                             Iconsax.login5,
//                                             color: !controllerAbsensi
//                                                         .absenStatus.value &&
//                                                     !controller
//                                                         .pendingSignoutApr.value
//                                                 ? Constanst.color5
//                                                 : const Color.fromARGB(
//                                                     168, 166, 167, 158),
//                                             size: 26,
//                                           ),
//                                           const SizedBox(width: 4),
//                                           Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 "Masuk",
//                                                 style: GoogleFonts.inter(
//                                                     fontWeight: FontWeight.w500,
//                                                     fontSize: 16,
//                                                     color: !controllerAbsensi
//                                                                 .absenStatus
//                                                                 .value &&
//                                                             !controller
//                                                                 .pendingSignoutApr
//                                                                 .value
//                                                         ? Constanst.fgPrimary
//                                                         : const Color.fromARGB(
//                                                             168,
//                                                             166,
//                                                             167,
//                                                             158)),
//                                               ),
//                                               Obx(
//                                                 () => Text(
//                                                   // !authController
//                                                   //         .isConnected.value
//                                                   //     ? controller.signinTime
//                                                   //                 .value ==
//                                                   //             "00:00:00"
//                                                   //         ? "_ _:_ _:_ _"
//                                                   //         : controller
//                                                   //             .signinTime.value
//                                                   //     :
//                                                   controller.signinTime.value ==
//                                                           "00:00:00"
//                                                       ? "_ _:_ _:_ _"
//                                                       : controller
//                                                           .signinTime.value,
//                                                   style: GoogleFonts.inter(
//                                                       fontWeight:
//                                                           FontWeight.w500,
//                                                       fontSize: 16,
//                                                       color: !controllerAbsensi
//                                                                   .absenStatus
//                                                                   .value &&
//                                                               !controller
//                                                                   .pendingSignoutApr
//                                                                   .value
//                                                           ? Constanst.fgPrimary
//                                                           : const Color
//                                                               .fromARGB(168,
//                                                               166, 167, 158)),
//                                                 ),
//                                               ),
//                                               controller.status.value == "[]" &&
//                                                       controller.wfhstatus.value
//                                                   ? Padding(
//                                                       padding:
//                                                           const EdgeInsets.only(
//                                                               top: 4.0),
//                                                       child: Row(
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .spaceBetween,
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .center,
//                                                         children: [
//                                                           // Icon(
//                                                           //   Iconsax.timer,
//                                                           //   color: Constanst
//                                                           //       .color3,
//                                                           //   size: 15,
//                                                           // ),
//                                                           // SizedBox(width: 2),
//                                                           Obx(
//                                                             () => Text(
//                                                               // controller
//                                                               //     .status.value,
//                                                               "Pending WFH Approval",
//                                                               style: GoogleFonts.inter(
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w500,
//                                                                   fontSize: 9,
//                                                                   color: !controllerAbsensi
//                                                                           .absenStatus
//                                                                           .value
//                                                                       ? Constanst
//                                                                           .fgPrimary
//                                                                       : Constanst
//                                                                           .color4),
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     )
//                                                   : Container(),
//                                               // (controller.absenOfflineStatus
//                                               //                 .value &&
//                                               //             controllerAbsensi
//                                               //                 .absenStatus
//                                               //                 .value) ||
//                                               //         controller
//                                               //             .pendingSigninApr
//                                               //             .value
//                                               //     ? Padding(
//                                               //         padding:
//                                               //             const EdgeInsets.only(
//                                               //                 top: 4.0),
//                                               //         child: Row(
//                                               //           mainAxisAlignment:
//                                               //               MainAxisAlignment
//                                               //                   .spaceBetween,
//                                               //           crossAxisAlignment:
//                                               //               CrossAxisAlignment
//                                               //                   .center,
//                                               //           children: [
//                                               //             // Icon(
//                                               //             //   Iconsax.timer,
//                                               //             //   color: Constanst
//                                               //             //       .color3,
//                                               //             //   size: 15,
//                                               //             // ),
//                                               //             // SizedBox(width: 2),
//                                               //             Obx(
//                                               //               () => Row(
//                                               //                 children: [
//                                               //                   Text(
//                                               //                     // controller
//                                               //                     //     .status.value,
//                                               //                     controller
//                                               //                             .textPendingMasuk
//                                               //                             .value
//                                               //                         ? "Pending Absensi"
//                                               //                         : "Pending Approval",
//                                               //                     style:
//                                               //                         GoogleFonts
//                                               //                             .inter(
//                                               //                       fontWeight:
//                                               //                           FontWeight
//                                               //                               .w500,
//                                               //                       fontSize: 9,
//                                               //                       color: Constanst
//                                               //                           .color4,
//                                               //                     ),
//                                               //                   ),
//                                               //                   Visibility(
//                                               //                     visible: controller
//                                               //                         .textPendingMasuk
//                                               //                         .value,
//                                               //                     child: Row(
//                                               //                       children: [
//                                               //                         const SizedBox(
//                                               //                           width:
//                                               //                               2,
//                                               //                         ),
//                                               //                         Icon(
//                                               //                           Iconsax
//                                               //                               .clock,
//                                               //                           size: 8,
//                                               //                           color: Constanst
//                                               //                               .color4,
//                                               //                         ),
//                                               //                       ],
//                                               //                     ),
//                                               //                   ),
//                                               //                 ],
//                                               //               ),
//                                               //             ),
//                                               //           ],
//                                               //         ),
//                                               //       )
//                                               //     : Container()
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                       Expanded(
//                                         flex: 1,
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.stretch,
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Icon(
//                                               Iconsax.arrow_right_3,
//                                               color: Constanst
//                                                   .colorNeutralFgTertiary,
//                                               size: 18,
//                                             ),
//                                             const SizedBox(height: 22),
//                                             controller.status.value == "[]" &&
//                                                     controller.wfhstatus.value
//                                                 ? controller.approveStatus
//                                                             .value ==
//                                                         "Approve"
//                                                     ? Container()
//                                                     : GestureDetector(
//                                                         onTap: () {
//                                                           controller
//                                                               .widgetButtomSheetWfhDelete();
//                                                         },
//                                                         child: Icon(
//                                                           Iconsax.close_circle5,
//                                                           color:
//                                                               Constanst.color4,
//                                                           size: 15,
//                                                         ),
//                                                       )
//                                                 : Container(),
//                                           ],
//                                         ),
//                                       ),
//                                       const SizedBox(width: 18),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             flex: 1,
//                             child: Container(
//                               color: Constanst.fgBorder,
//                               height: 36,
//                               width: 1,
//                             ),
//                           ),
//                           Expanded(
//                             flex: 165,
//                             child: Material(
//                               color: controller.status.value == "[]" &&
//                                       controller.wfhstatus.value
//                                   ? Constanst.colorWhite
//                                   : controllerAbsensi.absenStatus.value &&
//                                           !controller.pendingSignoutApr.value
//                                       ? Constanst.colorWhite
//                                       : Constanst.colorNonAktif,
//                               borderRadius: const BorderRadius.only(
//                                 bottomRight: Radius.circular(15.0),
//                               ),
//                               child: InkWell(
//                                 customBorder: const RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.only(
//                                     bottomRight: Radius.circular(15.0),
//                                   ),
//                                 ),
//                                 onTap: () {

//                                   if (controller.pendingSignoutApr.value) {
//                                     UtilsAlert.showToast(
//                                         "Menunggu status absensi anda di approve");
//                                     return;
//                                   }

//                                   if (!controllerAbsensi.absenStatus.value) {
//                                     UtilsAlert.showToast(
//                                         "Absen Masuk terlebih dahulu");

//                                   } else if (controller.status.value == "[]" &&

//                                       controller.wfhstatus.value) {
//                                     UtilsAlert.showToast(
//                                         "Abeen WFH beluum di approve");

//                                   } else {
//                                     // if (!authController.isConnected.value) {
//                                     //   // if (controller
//                                     //   //         .absenOfflineStatusDua.value ==
//                                     //   //     true) {
//                                     //   //   UtilsAlert.showToast(
//                                     //   //       "Menunggu status absensi anda di approve");
//                                     //   //   return;
//                                     //   // } else {
//                                     //   controllerAbsensi.getPlaceCoordinate();
//                                     //   controllerAbsensi.titleAbsen.value =
//                                     //       "Absen Keluar";
//                                     //   controllerAbsensi.typeAbsen.value = 2;
//                                     //   controller.widgetButtomSheetOfflineAbsen(
//                                     //       title: "Absen Keluar",
//                                     //       status: "keluar");
//                                     //   // }
//                                     // } else {
//                                     // if (controller.absenOfflineStatus.value ==
//                                     //     true) {
//                                     //   UtilsAlert.showToast(
//                                     //       "Menunggu status absensi anda di approve");
//                                     //   return;
//                                     // }

//                                     var dataUser = AppData.informasiUser;
//                                     var faceRecog = dataUser![0].face_recog;

//                                     if (GetStorage().read('face_recog') ==
//                                         true) {
//                                       controllerAbsensi.getPlaceCoordinate();
//                                       controllerAbsensi.titleAbsen.value =
//                                           "Absen Keluar";
//                                       controllerAbsensi.typeAbsen.value = 2;

//                                       //begin image picker
//                                       // final getFoto = await ImagePicker()
//                                       //     .pickImage(
//                                       //         source: ImageSource.camera,
//                                       //         preferredCameraDevice:
//                                       //             CameraDevice.front,
//                                       //         imageQuality: 100,
//                                       //         maxHeight: 350,
//                                       //         maxWidth: 350);
//                                       // if (getFoto == null) {
//                                       //   UtilsAlert.showToast(
//                                       //       "Gagal mengambil gambar");
//                                       // } else {
//                                       //   // controllerAbsensi.facedDetection(
//                                       //   //     status: "registration",
//                                       //   //     absenStatus: "Absen Masuk",
//                                       //   //     img: getFoto.path,
//                                       //   //     type: "1");
//                                       //   Get.to(LoadingAbsen(
//                                       //     file: getFoto.path,
//                                       //     status: "detection",
//                                       //     statusAbsen: 'keluar',
//                                       //   ));
//                                       //   // Get.to(FaceidRegistration(
//                                       //   //   status: "registration",
//                                       //   // ));
//                                       // }
//                                       //end image picker

//                                       if (controllerAbsensi.regType.value ==
//                                           1) {
//                                         Get.to(AbsensiLocation(
//                                           status: "keluar",
//                                         ));
//                                       } else {
//                                         Get.to(FaceDetectorView(
//                                           status: "keluar",
//                                         ));
//                                       }

//                                       // controllerAbsensi.facedDetection(
//                                       //     status: "detection",
//                                       //     type: "2",
//                                       // //     absenStatus: "keluar");
//                                       // Get.to(faceDetectionPage(
//                                       //   status: "keluar",
//                                       // ));
//                                       // Get.offAll(AbsenMasukKeluar(
//                                       //   status: "Absen Keluar",
//                                       //   type: 2,
//                                       // ));
//                                       // controllerAbsensi.absenSelfie();
//                                       // var validasiAbsenMasukUser =
//                                       //     controller.validasiAbsenMasukUser();
//                                       // print(validasiAbsenMasukUser);
//                                       // if (validasiAbsenMasukUser == false) {

//                                       // } else {
//                                       //   var kalkulasiRadius =
//                                       //       controller.radiusNotOpen();
//                                       //   kalkulasiRadius.then((value) {
//                                       //     if (value) {
//                                       //       controllerAbsensi.titleAbsen.value =
//                                       //           "Absen Keluar";
//                                       //       controllerAbsensi.typeAbsen.value = 2;
//                                       //       Get.offAll(AbsenMasukKeluar());
//                                       //       controllerAbsensi.absenSelfie();
//                                       //     }
//                                       //   });
//                                       // }
//                                     } else {
//                                       controllerAbsensi
//                                           .widgetButtomSheetFaceRegistrattion();
//                                     }
//                                     // }
//                                   }

//                                 },
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(
//                                       top: 12.0, bottom: 12, right: 12.0),
//                                   child: Row(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Expanded(
//                                         flex: 10,
//                                         child: Row(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             const SizedBox(width: 18),
//                                             Icon(
//                                               Iconsax.logout_15,
//                                               color: controller.status.value ==
//                                                           "[]" &&
//                                                       controller.wfhstatus.value
//                                                   ? const Color.fromARGB(
//                                                       168, 166, 167, 158)
//                                                   : controllerAbsensi
//                                                           .absenStatus.value
//                                                       ? Constanst.color4
//                                                       : const Color.fromARGB(
//                                                           168, 166, 167, 158),
//                                               size: 26,
//                                             ),
//                                             const SizedBox(width: 8),
//                                             Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Text(
//                                                   "Keluar",
//                                                   style: GoogleFonts.inter(
//                                                       fontWeight:
//                                                           FontWeight.w500,
//                                                       fontSize: 16,
//                                                       color: controller.status
//                                                                       .value ==
//                                                                   "[]" &&
//                                                               controller
//                                                                   .wfhstatus
//                                                                   .value
//                                                           ? const Color
//                                                               .fromARGB(168,
//                                                               166, 167, 158)
//                                                           : controllerAbsensi
//                                                                   .absenStatus
//                                                                   .value
//                                                               ? Constanst
//                                                                   .fgPrimary
//                                                               : const Color
//                                                                   .fromARGB(
//                                                                   168,
//                                                                   166,
//                                                                   167,
//                                                                   158)),
//                                                 ),
//                                                 Obx(
//                                                   () => Text(
//                                                     // !authController
//                                                     //         .isConnected.value
//                                                     //     ? controller.signoutTime
//                                                     //                     .value ==
//                                                     //                 "00:00:00" ||
//                                                     //             controller
//                                                     //                     .signoutTime
//                                                     //                     .value ==
//                                                     //                 "null"
//                                                     //         ? "_ _:_ _:_ _"
//                                                     //         : controller
//                                                     //             .signoutTime
//                                                     //             .value
//                                                     //     :
//                                                     controller.signoutTime
//                                                                 .value ==
//                                                             "00:00:00"
//                                                         ? "_ _:_ _:_ _"
//                                                         : controller
//                                                             .signoutTime.value,
//                                                     style: GoogleFonts.inter(
//                                                         fontWeight:
//                                                             FontWeight.w500,
//                                                         fontSize: 16,
//                                                         color: controller
//                                                                         .status.value ==
//                                                                     "[]" &&
//                                                                 controller
//                                                                     .wfhstatus
//                                                                     .value
//                                                             ? const Color
//                                                                 .fromARGB(168,
//                                                                 166, 167, 158)
//                                                             : controllerAbsensi
//                                                                     .absenStatus
//                                                                     .value
//                                                                 ? Constanst
//                                                                     .fgPrimary
//                                                                 : const Color
//                                                                     .fromARGB(
//                                                                     168,
//                                                                     166,
//                                                                     167,
//                                                                     158)),
//                                                   ),
//                                                 ),
//                                                 controller.status.value ==
//                                                             "[]" &&
//                                                         controller
//                                                             .wfhstatus.value
//                                                     ? Container(
//                                                         height: 20,
//                                                       )
//                                                     : Container(),
//                                                 // (controller.absenOfflineStatus
//                                                 //                 .value &&
//                                                 //             !controllerAbsensi
//                                                 //                 .absenStatus
//                                                 //                 .value) ||
//                                                 //         controller
//                                                 //             .pendingSignoutApr
//                                                 //             .value
//                                                 //     ? Padding(
//                                                 //         padding:
//                                                 //             const EdgeInsets
//                                                 //                 .only(top: 4.0),
//                                                 //         child: Row(
//                                                 //           mainAxisAlignment:
//                                                 //               MainAxisAlignment
//                                                 //                   .spaceBetween,
//                                                 //           crossAxisAlignment:
//                                                 //               CrossAxisAlignment
//                                                 //                   .center,
//                                                 //           children: [
//                                                 //             // Icon(
//                                                 //             //   Iconsax.timer,
//                                                 //             //   color: Constanst
//                                                 //             //       .color3,
//                                                 //             //   size: 15,
//                                                 //             // ),
//                                                 //             // SizedBox(width: 2),
//                                                 //             Obx(
//                                                 //               () => Row(
//                                                 //                 children: [
//                                                 //                   Text(
//                                                 //                     // controller
//                                                 //                     //     .status.value,
//                                                 //                     controller
//                                                 //                             .textPendingKeluar
//                                                 //                             .value
//                                                 //                         ? "Pending Absensi"
//                                                 //                         : "Pending Approval",
//                                                 //                     style: GoogleFonts
//                                                 //                         .inter(
//                                                 //                       fontWeight:
//                                                 //                           FontWeight
//                                                 //                               .w500,
//                                                 //                       fontSize:
//                                                 //                           9,
//                                                 //                       color: Constanst
//                                                 //                           .color4,
//                                                 //                     ),
//                                                 //                   ),
//                                                 //                   Visibility(
//                                                 //                     visible: controller
//                                                 //                         .textPendingKeluar
//                                                 //                         .value,
//                                                 //                     child: Row(
//                                                 //                       children: [
//                                                 //                         const SizedBox(
//                                                 //                           width:
//                                                 //                               2,
//                                                 //                         ),
//                                                 //                         Icon(
//                                                 //                           Iconsax
//                                                 //                               .clock,
//                                                 //                           size:
//                                                 //                               8,
//                                                 //                           color:
//                                                 //                               Constanst.color4,
//                                                 //                         ),
//                                                 //                       ],
//                                                 //                     ),
//                                                 //                   ),
//                                                 //                 ],
//                                                 //               ),
//                                                 //             ),
//                                                 //           ],
//                                                 //         ),
//                                                 //       )
//                                                 //     : Container()
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       Expanded(
//                                         flex: 1,
//                                         child: Icon(
//                                           Iconsax.arrow_right_3,
//                                           color:
//                                               Constanst.colorNeutralFgTertiary,
//                                           size: 18,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   )
//                 : Container()
//             : Container(),

//             // _isVisible
//             //     ? Row(
//             //         crossAxisAlignment: CrossAxisAlignment.start,
//             //         children: [
//             //           Expanded(
//             //             child: Padding(
//             //                 padding: const EdgeInsets.only(right: 8),
//             //                 child: TextButtonWidget2(
//             //                     title: "Absen Masuk",
//             //                     onTap: () async {
//             //                       if (controllerAbsensi.absenStatus.value ==
//             //                           true) {
//             //                         UtilsAlert.showToast(
//             //                             "Anda harus absen keluar terlebih dahulu");
//             //                       } else {
//             //                         var dataUser = AppData.informasiUser;
//             //                         var faceRecog = dataUser![0].face_recog;
//             //                         print(
//             //                             "facee recog ${GetStorage().read('face_recog')}");
//             //                         if (GetStorage().read('face_recog') ==
//             //                             true) {
//             //                           print("masuk sini");
//             //                           var statusCamera =
//             //                               Permission.camera.status;
//             //                           statusCamera.then((value) {
//             //                             var statusLokasi =
//             //                                 Permission.location.status;
//             //                             statusLokasi.then((value2) async {
//             //                               if (value !=
//             //                                       PermissionStatus.granted ||
//             //                                   value2 !=
//             //                                       PermissionStatus.granted) {
//             //                                 UtilsAlert.showToast(
//             //                                     "Anda harus aktifkan kamera dan lokasi anda");
//             //                                 controller
//             //                                     .widgetButtomSheetAktifCamera(
//             //                                         'loadfirst');
//             //                               } else {
//             //                                 print("masuk absen user");
//             //                                 // Get.offAll(AbsenMasukKeluar(
//             //                                 //   status: "Absen Masuk",
//             //                                 //   type: 1,
//             //                                 // ));
//             //                                 //  controllerAbsensi.absenSelfie();

//             //                                 var validasiAbsenMasukUser =
//             //                                     controller
//             //                                         .validasiAbsenMasukUser();
//             //                                 if (!validasiAbsenMasukUser) {
//             //                                   print("masuk sini");
//             //                                 } else {
//             //                                   controllerAbsensi.titleAbsen
//             //                                       .value = "Absen masuk";

//             //                                   controllerAbsensi
//             //                                       .typeAbsen.value = 1;

//             //                                   //begin image picker
//             //                                   // final getFoto = await ImagePicker()
//             //                                   //     .pickImage(
//             //                                   //         source: ImageSource.camera,
//             //                                   //         preferredCameraDevice:
//             //                                   //             CameraDevice.front,
//             //                                   //         imageQuality: 100,
//             //                                   //         maxHeight: 350,
//             //                                   //         maxWidth: 350);
//             //                                   // if (getFoto == null) {
//             //                                   //   UtilsAlert.showToast(
//             //                                   //       "Gagal mengambil gambar");
//             //                                   // } else {
//             //                                   //   // controllerAbsensi.facedDetection(
//             //                                   //   //     status: "registration",
//             //                                   //   //     absenStatus: "Absen Masuk",
//             //                                   //   //     img: getFoto.path,
//             //                                   //   //     type: "1");
//             //                                   //   Get.to(LoadingAbsen(
//             //                                   //     file: getFoto.path,
//             //                                   //     status: "detection",
//             //                                   //     statusAbsen: 'masuk',
//             //                                   //   ));
//             //                                   //   // Get.to(FaceidRegistration(
//             //                                   //   //   status: "registration",
//             //                                   //   // ));
//             //                                   // }
//             //                                   //end image picker

//             //                                   //begin face recognition
//             //                                   // Get.to(FaceDetectorView(
//             //                                   //   status: "masuk",
//             //                                   // ));
//             //                                   //end begin face recogniton

//             //                                   if (controllerAbsensi
//             //                                           .regType.value ==
//             //                                       1) {
//             //                                     Get.to(AbsensiLocation(
//             //                                       status: "masuk",
//             //                                     ));
//             //                                   } else {
//             //                                     Get.to(FaceDetectorView(
//             //                                       status: "masuk",
//             //                                     ));
//             //                                   }

//             //                                   // // controllerAbsensi.getPlaceCoordinate();
//             //                                   // ;
//             //                                   // controllerAbsensi.facedDetection(
//             //                                   //     status: "detection",
//             //                                   //     absenStatus: "masuk",
//             //                                   //     type: "1");

//             //                                   // var kalkulasiRadius =
//             //                                   //     controller.radiusNotOpen();
//             //                                   // Get.to(faceDetectionPage(
//             //                                   //   status: "masuk",
//             //                                   // ));
//             //                                   // kalkulasiRadius.then((value) {
//             //                                   //   print(value);
//             //                                   //   // if (value) {
//             //                                   //   //   controllerAbsensi.titleAbsen.value =
//             //                                   //   //       "Absen Masuk";
//             //                                   //   //   controllerAbsensi.typeAbsen.value = 1;
//             //                                   //   //   Get.offAll(faceDetectionPage());
//             //                                   //   //   // controllerAbsensi.absenSelfie();
//             //                                   //   // }
//             //                                   // });
//             //                                 }
//             //                               }
//             //                             });
//             //                           });
//             //                         } else {
//             //                           controllerAbsensi
//             //                               .widgetButtomSheetFaceRegistrattion();
//             //                         }
//             //                       }
//             //                     },
//             //                     colorButton:
//             //                         !controllerAbsensi.absenStatus.value
//             //                             ? Constanst.colorPrimary
//             //                             : Constanst.colorNonAktif,
//             //                     colortext: !controllerAbsensi.absenStatus.value
//             //                         ? Constanst.colorWhite
//             //                         : Color.fromARGB(168, 166, 167, 158),
//             //                     border: BorderRadius.circular(5.0),
//             //                     icon: Icon(
//             //                       Iconsax.login,
//             //                       size: 18,
//             //                       color: !controllerAbsensi.absenStatus.value
//             //                           ? Constanst.colorWhite
//             //                           : Color.fromARGB(168, 166, 167, 158),
//             //                     ))),
//             //           ),
//             //           Expanded(
//             //             child: Padding(
//             //                 padding: EdgeInsets.only(right: 8),
//             //                 child: TextButtonWidget2(
//             //                     title: "Absen Keluar",
//             //                     onTap: () async {
//             //                       if (!controllerAbsensi.absenStatus.value) {
//             //                         UtilsAlert.showToast(
//             //                             "Absen Masuk terlebih dahulu");
//             //                       } else {
//             //                         var dataUser = AppData.informasiUser;
//             //                         var faceRecog = dataUser![0].face_recog;

//             //                         if (GetStorage().read('face_recog') ==
//             //                             true) {
//             //                           controllerAbsensi.getPlaceCoordinate();
//             //                           controllerAbsensi.titleAbsen.value =
//             //                               "Absen Keluar";
//             //                           controllerAbsensi.typeAbsen.value = 2;

//             //                           //begin image picker
//             //                           // final getFoto = await ImagePicker()
//             //                           //     .pickImage(
//             //                           //         source: ImageSource.camera,
//             //                           //         preferredCameraDevice:
//             //                           //             CameraDevice.front,
//             //                           //         imageQuality: 100,
//             //                           //         maxHeight: 350,
//             //                           //         maxWidth: 350);
//             //                           // if (getFoto == null) {
//             //                           //   UtilsAlert.showToast(
//             //                           //       "Gagal mengambil gambar");
//             //                           // } else {
//             //                           //   // controllerAbsensi.facedDetection(
//             //                           //   //     status: "registration",
//             //                           //   //     absenStatus: "Absen Masuk",
//             //                           //   //     img: getFoto.path,
//             //                           //   //     type: "1");
//             //                           //   Get.to(LoadingAbsen(
//             //                           //     file: getFoto.path,
//             //                           //     status: "detection",
//             //                           //     statusAbsen: 'keluar',
//             //                           //   ));
//             //                           //   // Get.to(FaceidRegistration(
//             //                           //   //   status: "registration",
//             //                           //   // ));
//             //                           // }
//             //                           //end image picker

//             //                           if (controllerAbsensi.regType.value ==
//             //                               1) {
//             //                             Get.to(AbsensiLocation(
//             //                               status: "keluar",
//             //                             ));
//             //                           } else {
//             //                             Get.to(FaceDetectorView(
//             //                               status: "keluar",
//             //                             ));
//             //                           }

//             //                           // controllerAbsensi.facedDetection(
//             //                           //     status: "detection",
//             //                           //     type: "2",
//             //                           // //     absenStatus: "keluar");
//             //                           // Get.to(faceDetectionPage(
//             //                           //   status: "keluar",
//             //                           // ));
//             //                           // Get.offAll(AbsenMasukKeluar(
//             //                           //   status: "Absen Keluar",
//             //                           //   type: 2,
//             //                           // ));
//             //                           // controllerAbsensi.absenSelfie();
//             //                           // var validasiAbsenMasukUser =
//             //                           //     controller.validasiAbsenMasukUser();
//             //                           // print(validasiAbsenMasukUser);
//             //                           // if (validasiAbsenMasukUser == false) {

//             //                           // } else {
//             //                           //   var kalkulasiRadius =
//             //                           //       controller.radiusNotOpen();
//             //                           //   kalkulasiRadius.then((value) {
//             //                           //     if (value) {
//             //                           //       controllerAbsensi.titleAbsen.value =
//             //                           //           "Absen Keluar";
//             //                           //       controllerAbsensi.typeAbsen.value = 2;
//             //                           //       Get.offAll(AbsenMasukKeluar());
//             //                           //       controllerAbsensi.absenSelfie();
//             //                           //     }
//             //                           //   });
//             //                           // }
//             //                         } else {
//             //                           controllerAbsensi
//             //                               .widgetButtomSheetFaceRegistrattion();
//             //                         }
//             //                       }
//             //                     },
//             //                     colorButton: controllerAbsensi.absenStatus.value
//             //                         ? Constanst.colorPrimary
//             //                         : Constanst.colorNonAktif,
//             //                     colortext: controllerAbsensi.absenStatus.value
//             //                         ? Constanst.colorWhite
//             //                         : Color.fromARGB(168, 166, 167, 158),
//             //                     border: BorderRadius.circular(5.0),
//             //                     icon: Icon(
//             //                       Iconsax.logout,
//             //                       size: 18,
//             //                       color: controllerAbsensi.absenStatus.value
//             //                           ? Constanst.colorWhite
//             //                           : Color.fromARGB(168, 166, 167, 158),
//             //                     ))),
//             //           ),
//             //         ],
//             //       )
//             //     : Container(),
//           ],
//         ),
//       ),
//     );
//   }

  Widget cardAbsenIstirahat() {
    return Row(
      mainAxisSize: MainAxisSize.min, // Membuat tinggi card sesuai content
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              if (controller.signinTime.value == "00:00:00") {
                UtilsAlert.showToast("Anda harus absen masuk terlebih dahulu");
              } else if (controller.breakoutTime.value != "00:00:00") {
                UtilsAlert.showToast(
                    "Anda harus absen mulai kerja terlebih dahulu");
              } else if (controller.breakinTime.value != "00:00:00" &&
                  controller.breakoutTime.value != "00:00:00") {
                UtilsAlert.showToast("Absen Istirahat hanya sekali saja");
              } else if (controller.signoutTime.value != "00:00:00") {
                UtilsAlert.showToast("Anda sudah absen pulang");
              } else {
                var dataUser = AppData.informasiUser;
                var faceRecog = dataUser![0].face_recog;
                print("facee recog ${GetStorage().read('face_recog')}");

                if (GetStorage().read('face_recog') == true ||
                    controllerAbsensi.regType.value == 1 ||
                    controllerAbsensi.regType.value == 2) {
                  print("masuk sini");
                  var statusCamera = Permission.camera.status;
                  statusCamera.then((value) {
                    var statusLokasi = Permission.location.status;
                    statusLokasi.then((value2) async {
                      if (value != PermissionStatus.granted ||
                          value2 != PermissionStatus.granted) {
                        UtilsAlert.showToast(
                            "Anda harus aktifkan kamera dan lokasi anda");
                        controller.widgetButtomSheetAktifCameraIstirahat(
                            type: 'loadfirst');
                      } else {
                        controllerAbsensi.titleAbsen.value = "Absen Istirahat";
                        controllerAbsensi.typeAbsen.value = 2;
                        controllerAbsensi.isAbsenIstirahat.value = true;

                        if (controllerAbsensi.regType.value == 1) {
                          print("masuk 1");
                          Get.to(AbsensiLocation(
                            status: "masuk",
                          ));
                        } else if (controllerAbsensi.regType.value == 0) {
                          print("masuk masuk 2");
                          Get.to(FaceDetectorView(
                            status: "masuk",
                          ));
                        } else {
                          Get.to(AbsenIstirahatMasukKeluar(
                              status: "Absen Istirahat"));
                        }
                      }
                    });
                  });
                } else {
                  controllerAbsensi.widgetButtomSheetFaceRegistrattion();
                }
              }
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  // topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
                color: controller.breakoutTime.value != "00:00:00" ||
                        controller.signinTime.value == "00:00:00" ||
                        controller.signoutTime.value != "00:00:00"
                    ? Constanst.colorNonAktif
                    : Constanst.colorWhite,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.restaurant,
                    color: controller.breakoutTime.value != "00:00:00" ||
                            controller.signinTime.value == "00:00:00" ||
                            controller.signoutTime.value != "00:00:00"
                        ? const Color.fromARGB(168, 166, 167, 158)
                        : Constanst.color4,
                    // size: 26,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Istirahat',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: controller.breakoutTime.value !=
                                            "00:00:00" ||
                                        controller.signinTime.value ==
                                            "00:00:00" ||
                                        controller.signoutTime.value !=
                                            "00:00:00"
                                    ? const Color.fromARGB(168, 166, 167, 158)
                                    : Constanst.fgPrimary,
                              ),
                            ),
                            const SizedBox(width: 25),
                            // const Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: controller.breakoutTime.value !=
                                          "00:00:00" ||
                                      controller.signinTime.value ==
                                          "00:00:00" ||
                                      controller.signoutTime.value != "00:00:00"
                                  ? const Color.fromARGB(168, 166, 167, 158)
                                  : Constanst.fgPrimary,
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Obx(
                          () => Text(
                            controller.breakoutTime.value != "00:00:00"
                                ? controller.breakoutTime.value
                                : '_ _:_ _:_ _',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: controller.breakoutTime.value !=
                                          "00:00:00" ||
                                      controller.signinTime.value ==
                                          "00:00:00" ||
                                      controller.signoutTime.value != "00:00:00"
                                  ? const Color.fromARGB(168, 166, 167, 158)
                                  : Constanst.fgPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Bagian "Keluar"
        Expanded(
          child: InkWell(
            onTap: () {
              if (controller.breakoutTime.value == "00:00:00") {
                UtilsAlert.showToast(
                    "Anda harus absen istirahat terlebih dahulu");
              } else if (controller.breakinTime.value != "00:00:00" &&
                  controller.breakoutTime.value != "00:00:00") {
                UtilsAlert.showToast("Absen Istirahat hanya sekali saja");
              } else if (controller.signoutTime.value != "00:00:00") {
                UtilsAlert.showToast("Anda sudah absen pulang");
              } else {
                var dataUser = AppData.informasiUser;
                var faceRecog = dataUser![0].face_recog;

                if (GetStorage().read('face_recog') == true ||
                    controllerAbsensi.regType.value == 1 ||
                    controllerAbsensi.regType.value == 2) {
                  controllerAbsensi.titleAbsen.value = "Absen Mulai Kerja";
                  controllerAbsensi.typeAbsen.value = 1;
                  controllerAbsensi.isAbsenIstirahat.value = true;

                  if (controllerAbsensi.regType.value == 1) {
                    print("tes absen rrr");
                    Get.to(AbsensiLocation(
                      status: "keluar",
                    ));
                  } else if (controllerAbsensi.regType.value == 0) {
                    print("tes absen pppp");
                    Get.to(FaceDetectorView(
                      status: "keluar",
                    ));
                  } else {
                    Get.to(
                        AbsenIstirahatMasukKeluar(status: "Absen Mulai Kerja"));
                  }
                } else {
                  controllerAbsensi.widgetButtomSheetFaceRegistrattion();
                }
              }
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  // topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                color: controller.breakinTime.value != "00:00:00" ||
                        controller.breakoutTime.value == "00:00:00" ||
                        controller.signoutTime.value != "00:00:00"
                    ? Constanst.colorNonAktif
                    : Constanst.colorWhite,
              ),
              padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.work,
                    color: controller.breakinTime.value != "00:00:00" ||
                            controller.breakoutTime.value == "00:00:00" ||
                            controller.signoutTime.value != "00:00:00"
                        ? const Color.fromARGB(168, 166, 167, 158)
                        : Constanst.color5,
                    // size: 26,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Mulai Kerja",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: controller.breakinTime.value !=
                                            "00:00:00" ||
                                        controller.breakoutTime.value ==
                                            "00:00:00" ||
                                        controller.signoutTime.value !=
                                            "00:00:00"
                                    ? const Color.fromARGB(168, 166, 167, 158)
                                    : Constanst.fgPrimary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: controller.breakinTime.value !=
                                          "00:00:00" ||
                                      controller.breakoutTime.value ==
                                          "00:00:00" ||
                                      controller.signoutTime.value != "00:00:00"
                                  ? const Color.fromARGB(168, 166, 167, 158)
                                  : Constanst.fgPrimary,
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          controller.breakinTime.value != "00:00:00"
                              ? controller.breakinTime.value
                              : '_ _:_ _:_ _',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: controller.breakinTime.value != "00:00:00" ||
                                    controller.breakoutTime.value ==
                                        "00:00:00" ||
                                    controller.signoutTime.value != "00:00:00"
                                ? const Color.fromARGB(168, 166, 167, 158)
                                : Constanst.fgPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget cardFormPengajuan() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 12.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Constanst.colorStateInfoBorder,
                  width: 1.0,
                ),
                borderRadius: Constanst.borderStyle2,
              ),
              child: Material(
                borderRadius: Constanst.borderStyle2,
                color: Constanst.infoLight1,
                child: InkWell(
                  customBorder: RoundedRectangleBorder(
                    borderRadius: Constanst.borderStyle2,
                  ),
                  onTap: () => controller.widgetButtomSheetFormPengajuan(),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 10.0, 4.0, 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Iconsax.add_square5,
                                color: Constanst.infoLight,
                                size: 26,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Pengajuan",
                                      style: GoogleFonts.inter(
                                          color: Constanst.fgPrimary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "Buat dengan cepat!",
                                      style: GoogleFonts.inter(
                                          color: Constanst.fgPrimary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Constanst.fgSecondary,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          controller.showLaporan.value == false
              ? const SizedBox()
              : controllerAbsensi.showButtonlaporan.value == false &&
                      controllerAbsensi.showButtonlaporan.value == false
                  ? const SizedBox()
                  : Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Constanst.colorStateInfoBorder,
                            width: 1.0,
                          ),
                          borderRadius: Constanst.borderStyle2,
                        ),
                        child: Material(
                          borderRadius: Constanst.borderStyle2,
                          color: Constanst.infoLight1,
                          child: InkWell(
                            customBorder: RoundedRectangleBorder(
                              borderRadius: Constanst.borderStyle2,
                            ),
                            onTap: () {
                              controller.widgetButtomSheetFormLaporan();
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  8.0, 10.0, 4.0, 10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Iconsax.document_text5,
                                          color: Constanst.infoLight,
                                          size: 26,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Laporan",
                                                style: GoogleFonts.inter(
                                                    color: Constanst.fgPrimary,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                "Cek laporan disini!",
                                                style: GoogleFonts.inter(
                                                    color: Constanst.fgPrimary,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Constanst.fgSecondary,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
        ],
      ),
    );
  }

  Widget sliderBanner() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: SizedBox(
        width: MediaQuery.of(Get.context!).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CarouselSlider.builder(
                carouselController: controller.corouselDashboard,
                options: CarouselOptions(
                  onPageChanged: (index, reason) {
                    controller.indexBanner.value = index;
                  },
                  autoPlay: true,
                  // height: controller.heightbanner.value,
                  enlargeCenterPage: true,
                  viewportFraction: 1.0,
                  aspectRatio: 2.92 / 1,
                  initialPage: 1,
                ),
                itemCount: controller.bannerDashboard.value.length,
                itemBuilder:
                    (BuildContext context, int itemIndex, int pageViewIndex) {
                  return Obx(
                    () => InkWell(
                      onTap: () async {
                        var urlViewGambar =
                            controller.bannerDashboard.value[itemIndex]['url'];

                        final url = Uri.parse(urlViewGambar);
                        if (!await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        )) {
                          UtilsAlert.showToast('Tidak dapat membuka file');
                        }
                      },
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: Constanst.borderStyle2,
                            ),
                            child: //authController.isConnected.value
                                // ?
                                Image.network(
                              Api.urlGambarDariFinance +
                                  controller.bannerDashboard.value[itemIndex]
                                      ['img'],
                              fit: BoxFit.fill,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return UtilsAlert.shimmerBannerDashboard(
                                    Get.context!);
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/bnr1.png',
                                  fit: BoxFit.fill,
                                );
                              },
                            ),
                            // :
                            // Image.asset(
                            //     'assets/bnr1.png', // Gambar dari asset jika tidak ada koneksi
                            //     fit: BoxFit.fill,
                            //   ),
                          )),
                    ),
                  );
                }),
            DotsIndicator(
              dotsCount: controller.bannerDashboard.length,
              position: int.parse("${controller.indexBanner.value}"),
              decorator: DotsDecorator(
                size: const Size.square(6.0),
                activeColor: Constanst.infoLight,
                activeSize: const Size(16.0, 6.0),
                spacing: const EdgeInsets.fromLTRB(0.0, 8.0, 4.0, 0.0),
                activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget listModul() {
    var modul = controller.menuShowInMain.value
        .where((element) => element['menu'].length > 0)
        .toList();
    return SizedBox(
      height: 30,
      child: ListView.builder(
          itemCount: modul.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => controller.changePageModul(modul[index]['index']),
              child: Container(
                padding: const EdgeInsets.only(left: 8, right: 8),
                margin: const EdgeInsets.only(left: 8, right: 8),
                decoration: BoxDecoration(
                  color: modul[index]['status'] == false
                      ? Colors.transparent
                      : Constanst.colorButton3,
                  borderRadius: Constanst.borderStyle3,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Text(
                      modul[index]['nama_modul'],
                      style: TextStyle(
                          fontSize: 12,
                          color: modul[index]['status'] == false
                              ? Constanst.colorText1
                              : Constanst.colorPrimary,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget MenuDashboard() {
    return Obx(
      () => SizedBox(
        width: MediaQuery.of(Get.context!).size.width,
        height: controller.heightPageView.value / 2,
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: InkWell(
                  onTap: () async {
                    // authController.isConnected.value
                    //     ?
                    controller.widgetButtomSheetMenuLebihDetail();
                    // : UtilsAlert.showDialogCheckInternet();
                  },
                  highlightColor: Colors.white,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 42,
                              width: 42,
                              decoration: BoxDecoration(
                                  color: Constanst.infoLight1,
                                  borderRadius: BorderRadius.circular(100.0)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                                top: 8,
                              ),
                              child: SvgPicture.asset(
                                'assets/1_more.svg',
                                height: 42,
                                width: 42,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Semua",
                          style: GoogleFonts.inter(
                              color: Constanst.fgPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      ]),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: controller.menuShowInMain.value.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, idxMenu) {
                      var gambar = controller.menuShowInMain[idxMenu]['gambar'];

                      var namaMenu = controller.menuShowInMain[idxMenu]['nama'];

                      return Padding(
                        padding: EdgeInsets.only(
                            left: idxMenu == 0 ? 16.0 : 0.0,
                            right: idxMenu == 0
                                ? 28.0
                                : idxMenu == 1
                                    ? 28.0
                                    : idxMenu == 2
                                        ? 28.0
                                        : idxMenu == 3
                                            ? 18.0
                                            : idxMenu == 4
                                                ? 18.0
                                                : idxMenu == 5
                                                    ? 25.0
                                                    : idxMenu == 6
                                                        ? 30.0
                                                        : 30.0),
                        child: InkWell(
                          onTap: () => // authController.isConnected.value
                              // ?
                              controller.routePageDashboard(
                                  controller.menuShowInMain[idxMenu]['url'],
                                  null),
                          // : UtilsAlert.showDialogCheckInternet(),
                          highlightColor: Colors.white,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                gambar != ""
                                    ? Stack(
                                        children: [
                                          Container(
                                            height: 42,
                                            width: 42,
                                            decoration: BoxDecoration(
                                                color: Constanst.infoLight1,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.0)),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 8,
                                              top: 8,
                                            ),
                                            child: SvgPicture.asset(
                                              gambar == "watch.png"
                                                  ? 'assets/2_absen.svg'
                                                  : gambar == "tidak_masuk.png"
                                                      ? 'assets/3_izin.svg'
                                                      : gambar == "clock.png"
                                                          ? 'assets/4_lembur.svg'
                                                          : gambar ==
                                                                  "riwayat_cuti.png"
                                                              ? 'assets/5_cuti.svg'
                                                              : gambar ==
                                                                      "tugas_luar.png"
                                                                  ? 'assets/6_tugas_luar.svg'
                                                                  : gambar ==
                                                                          "limit_claim.png"
                                                                      ? 'assets/7_klaim.svg'
                                                                      : gambar ==
                                                                              "8_kandidat.png"
                                                                          ? 'assets/profile_kandidat.svg'
                                                                          : 'assets/8_kandidat.svg',
                                              height: 42,
                                              width: 42,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(
                                        color: Constanst.colorButton1,
                                        height: 32,
                                        width: 32,
                                      ),
                                const SizedBox(height: 4),
                                Text(
                                  namaMenu.length > 20
                                      ? namaMenu.substring(0, 20) + '...'
                                      : namaMenu,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                      color: Constanst.fgPrimary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ]),
                        ),
                      );
                    }),
              ),
            ],
          ),

          // Column(
          //   children: [

          //     SizedBox(height: 5,),
          //     Divider(height: 5, color: Constanst.colorNonAktif,),
          //     SizedBox(height: 20,
          //       child: Center(child: Text("Menu Lainnya", style: TextStyle(fontSize: 12),),),
          //     )
          //   ],
          // )
        ),
      ),
    );
  }

  Widget MenuDashboard2() {
    return SizedBox(
      width: MediaQuery.of(Get.context!).size.width,
      height: controller.heightPageView.value,
      child: PageView.builder(
          controller: controller.menuController,
          onPageChanged: (index) {
            controller.changePageModul(index);
          },
          itemCount: controller.menuShowInMain.value.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(0),
                  itemCount:
                      controller.menuShowInMain.value[index]['menu'].length,
                  scrollDirection: Axis.vertical,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height /
                            controller.ratioDevice.value),
                  ),
                  itemBuilder: (context, idxMenu) {
                    var gambar = controller.menuShowInMain[index]['menu']
                        [idxMenu]['gambar'];
                    var namaMenu = controller.menuShowInMain[index]['menu']
                        [idxMenu]['nama'];
                    return InkWell(
                      onTap: () => controller.routePageDashboard(
                          controller.menuShowInMain[index]['menu'][idxMenu]
                              ['url'],
                          null),
                      highlightColor: Colors.white,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            gambar != ""
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: Constanst.colorButton3,
                                        borderRadius: Constanst
                                            .styleBoxDecoration1.borderRadius),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 3, right: 3, top: 3, bottom: 3),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            Api.UrlgambarDashboard + gambar,
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                Container(
                                          alignment: Alignment.center,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.5,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const SizedBox(),
                                        fit: BoxFit.cover,
                                        width: 32,
                                        height: 32,
                                        color: Constanst.colorButton1,
                                      ),
                                    ),
                                  )
                                : Container(
                                    color: Constanst.colorButton1,
                                    height: 32,
                                    width: 32,
                                  ),
                            const SizedBox(
                              height: 3,
                            ),
                            Center(
                              child: Text(
                                namaMenu.length > 20
                                    ? namaMenu.substring(0, 20) + '...'
                                    : namaMenu,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 10, color: Constanst.colorText1),
                              ),
                            ),
                          ]),
                    );
                  }),

              // Column(
              //   children: [

              //     SizedBox(height: 5,),
              //     Divider(height: 5, color: Constanst.colorNonAktif,),
              //     SizedBox(height: 20,
              //       child: Center(child: Text("Menu Lainnya", style: TextStyle(fontSize: 12),),),
              //     )
              //   ],
              // )
            );
          }),
    );
  }

  String parseHtmlString(String htmlString) {
    dom.Document document = htmlParser.parse(htmlString);
    String parsedString = parseNode(document.body!);
    return parsedString;
  }

  String parseNode(dom.Node node) {
    if (node.nodeType == dom.Node.TEXT_NODE) {
      return node.text!;
    } else if (node.nodeType == dom.Node.ELEMENT_NODE) {
      dom.Element element = node as dom.Element;
      StringBuffer buffer = StringBuffer();
      for (var child in element.nodes) {
        buffer.write(parseNode(child));
      }
      return buffer.toString();
    } else {
      return '';
    }
  }

  Widget listInformasi() {
    return controller.informasiDashboard.value.isEmpty
        ? const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Tidak ada Informasi"),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 6),
            child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: controller.informasiDashboard.value.length > 3
                    ? 3
                    : controller.informasiDashboard.value.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var title =
                      controller.informasiDashboard.value[index]['title'];
                  var desc =
                      controller.informasiDashboard.value[index]['description'];
                  var create =
                      controller.informasiDashboard.value[index]['created_on'];
                  return InkWell(
                    onTap: () => Get.to(DetailInformasi(
                      title: title,
                      create: create,
                      desc: desc,
                    )),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        index == 0
                            ? Container()
                            : Divider(
                                height: 0,
                                thickness: 1,
                                color: Constanst.fgBorder,
                              ),
                        const SizedBox(height: 12),
                        Text(
                          "$title",
                          style: GoogleFonts.inter(
                              color: Constanst.fgPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          parseHtmlString(desc.toString()),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Constanst.fgPrimary,
                          ),
                        ),

                        // Html(
                        //   data: desc,
                        //   style: {
                        //     "body": Style(
                        //         fontSize: const FontSize(14),
                        //         maxLines: 2,
                        //         textOverflow: TextOverflow.ellipsis,
                        //         margin: const EdgeInsets.all(0.0),
                        //         color: Constanst.fgPrimary,
                        //         fontFamily: "GoogleFonts.inter",
                        //         fontWeight: FontWeight.w400),
                        //   },
                        // ),
                        Text(
                          Constanst.convertDate("$create"),
                          textAlign: TextAlign.right,
                          style: GoogleFonts.inter(
                              color: Constanst.fgSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(height: 14),
                      ],
                    ),
                  );
                }),
          );
  }

  Widget listEmployeeUltah() {
    return SizedBox(
        width: MediaQuery.of(Get.context!).size.width,
        height: 110,
        child: ListView.builder(
            itemCount: controller.employeeUltah.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              var fullname = controller.employeeUltah.value[index]['full_name'];
              var image = controller.employeeUltah.value[index]['em_image'];
              var jobtitle = controller.employeeUltah.value[index]['job_title'];
              var tanggalLahir =
                  controller.employeeUltah.value[index]['em_birthday'];
              var listTanggalLahir = tanggalLahir.split('-');
              return Padding(
                padding: EdgeInsets.only(left: index == 0 ? 16 : 8, right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    image == ""
                        ? SvgPicture.asset(
                            'assets/avatar_default.svg',
                            width: 66,
                            height: 66,
                          )
                        : Center(
                            child: CircleAvatar(
                              radius: 31,
                              child: ClipOval(
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: "${Api.UrlfotoProfile}$image",
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            Container(
                                      alignment: Alignment.center,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.5,
                                      width: MediaQuery.of(context).size.width,
                                      child: CircularProgressIndicator(
                                          value: downloadProgress.progress),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      color: Colors.white,
                                      child: SvgPicture.asset(
                                        'assets/avatar_default.svg',
                                        width: 66,
                                        height: 66,
                                      ),
                                    ),
                                    fit: BoxFit.cover,
                                    width: 66,
                                    height: 66,
                                  ),
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        fullname.length > 8
                            ? fullname.substring(0, 8) + '...'
                            : fullname,
                        style: GoogleFonts.inter(
                            color: Constanst.fgPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Center(
                      child: Text(
                        Constanst.convertDateBulanDanHari(
                            '${listTanggalLahir[1]}-${listTanggalLahir[2]}'),
                        style: GoogleFonts.inter(
                            color: Constanst.fgSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  ],
                ),
              );
            }));
  }

  Widget listReminderPkwt() {
    return SizedBox(
        width: MediaQuery.of(Get.context!).size.width,
        height: 120,
        child: ListView.builder(
            itemCount: controllerGlobal.employeeSisaCuti.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              var fullname =
                  controllerGlobal.employeeSisaCuti.value[index]['full_name'];
              var image =
                  controllerGlobal.employeeSisaCuti.value[index]['em_image'];
              var sisaKontrak = controllerGlobal.employeeSisaCuti.value[index]
                  ['sisa_kontrak'];
              var endDate =
                  controllerGlobal.employeeSisaCuti.value[index]['end_date'];
              return Padding(
                padding: EdgeInsets.only(left: index == 0 ? 16 : 8, right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    image == ""
                        ? SvgPicture.asset(
                            'assets/avatar_default.svg',
                            width: 66,
                            height: 66,
                          )
                        : Center(
                            child: CircleAvatar(
                              radius: 31,
                              child: ClipOval(
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: "${Api.UrlfotoProfile}$image",
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            Container(
                                      alignment: Alignment.center,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.5,
                                      width: MediaQuery.of(context).size.width,
                                      child: CircularProgressIndicator(
                                          value: downloadProgress.progress),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      color: Colors.white,
                                      child: SvgPicture.asset(
                                        'assets/avatar_default.svg',
                                        width: 66,
                                        height: 66,
                                      ),
                                    ),
                                    fit: BoxFit.cover,
                                    width: 66,
                                    height: 66,
                                  ),
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        fullname.length > 8
                            ? fullname.substring(0, 8) + '...'
                            : fullname,
                        style: GoogleFonts.inter(
                            color: Constanst.fgPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Sisa $sisaKontrak Hari",
                        style: GoogleFonts.inter(
                            color: Constanst.fgSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  ],
                ),
              );
            }));
  }

  void getSession() async {
    final prefs = await SharedPreferences.getInstance();
    var d = prefs.getString('interval_tracking');

    setState(() {
      intervalTracking = "${d}";
    });
  }

  @override
  void initState() {
    super.initState();
   
    // controller.updateInformasiUser();
    //controller.initData();
    // controllerAbsensi.getTimeNow();

    // controller.checkAbsenUser(DateFormat('yyyy-MM-dd').format(DateTime.now()),
    //     AppData.informasiUser![0].em_id);
    // controllerBpj.employeDetaiBpjs();

    // controller.initData();
    _setIsloading();
    // refreshData();

    // Api().checkLogin();
    // Add a listener to the scroll controller

    // controller.loadMenuShowInMain();
    // tabbController.checkuserinfo();
    // if (controllerTracking.bagikanlokasi.value == "aktif") {
    //   controllerTracking.absenSelfie();
    // }

    // chatController.getCount();

    // channel.sink.add(jsonEncode({
    //   'type': 'count',
    //   'database': AppData.selectedDatabase,
    //   'em_id': AppData.informasiUser![0].em_id
    // }));

    // channel.stream.listen((message) {
    //   print('ambil data websoket');
    //   final decodedMessage = jsonDecode(message);

    //   if (decodedMessage['type'] == 'count') {
    //     // print('total chat ${decodedMessage['data'][0]['total']}');
    //     chatController.jumlahChat.value = decodedMessage['data'][0]['total'];
    //   }

    //   if (decodedMessage['type'] == 'fetchHistory') {
    //     print('total chat ${decodedMessage['data']}');
    //     // print('total chat ${decodedMessage['data'][0]['total']}');
    //     // chatController.jumlahChat.value = decodedMessage['data'][0]['total'];
    //   }
    // });
    controller.versionCheck();
    _checkversion();
    // controllerAbsensi.getPosisition();
    // controllerAbsensi.getPlaceCoordinate();
    //print("intervallll ${AppData.informasiUser![0].interval.toString()}");
    // _setTime();
    // } else {
    //   final service = FlutterBackgroundService();
    //   service.invoke("stopService");
    //   controller.initData();
    // }


  }

  void _setTime() async {
    Future.delayed(const Duration(milliseconds: 500), () {
      controllerAbsensi.absenStatus.value = AppData.statusAbsen;
      authController.signinTime.value = controller.signinTime.value;
      authController.signoutTime.value = controller.signoutTime.value;
      // controllerAbsensi.absenStatus.value =
      //     controller.dashboardStatusAbsen.value;
    });
  }

  void _setIsloading() async {
    controller.isLoading.value = true;
    controller.refreshPagesStatus.value = true;
    

    // controllerAbsensi.getTimeNow();
    // controllerBpj.employeDetaiBpjs();
    // controllerAbsensi.employeDetail();
    // controllerAbsensi.userShift();
    // controllerAbsensi.getPosisition();
    // controllerAbsensi.getPlaceCoordinate();
    // controllerPesan.getTimeNow();

    controller.initData();
     Future.delayed(const Duration(milliseconds: 500), () {
        controllerAbsensi.absenStatus.value = AppData.statusAbsen;
        authController.signinTime.value = controller.signinTime.value;
        authController.signoutTime.value = controller.signoutTime.value;
        // controllerAbsensi.absenStatus.value =
        //     controller.dashboardStatusAbsen.value;
      });

    await Future.delayed(const Duration(seconds: 3));

    controller.isLoading.value = false;
    // AppData.firsLogin = false;
  }

  void _checkversion() async {
    try {
      final newVersion = NewVersionPlus(
        androidId: 'com.siscom.siscomhris',
      );

      final status = await newVersion.getVersionStatus();

      if (status != null) {
        if (status.localVersion != status.storeVersion) {
          if (context.mounted) {
            newVersion.showUpdateDialog(
                context: context,
                versionStatus: status,
                dialogTitle: "Update SISCOM HRIS",
                dialogText:
                    "Update versi SISCOM HRIS dari versi ${status.localVersion} ke versi ${status.storeVersion}",
                dismissAction: () {
                  Get.back();
                },
                updateButtonText: "Update Sekarang",
                dismissButtonText: "Skip");
            print("status yesy ${status.localVersion}");
          }
        }
      } else {}
    } catch (e) {}
  }
}
