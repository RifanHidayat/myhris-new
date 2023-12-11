import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:siscom_operasional/controller/absen_controller.dart';
import 'package:siscom_operasional/controller/auth_controller.dart';
import 'package:siscom_operasional/controller/bpjs.dart';
import 'package:siscom_operasional/controller/dashboard_controller.dart';
import 'package:siscom_operasional/controller/global_controller.dart';
import 'package:siscom_operasional/controller/pesan_controller.dart';
import 'package:siscom_operasional/controller/tab_controller.dart';
import 'package:siscom_operasional/screen/absen/absen_masuk_keluar.dart';
import 'package:siscom_operasional/screen/absen/absesi_location.dart';
import 'package:siscom_operasional/screen/absen/camera_view.dart';
import 'package:siscom_operasional/screen/absen/face_id_registration.dart';
import 'package:siscom_operasional/screen/absen/facee_id_detection.dart';
import 'package:siscom_operasional/screen/absen/loading_absen.dart';
import 'package:siscom_operasional/screen/akun/personal_info.dart';
import 'package:siscom_operasional/screen/detail_informasi.dart';
import 'package:siscom_operasional/screen/informasi.dart';
import 'package:siscom_operasional/screen/pesan/pesan.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/widget_textButton.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final controller = Get.put(DashboardController());
  final controllerAbsensi = Get.put(AbsenController());
  final controllerPesan = Get.put(PesanController());
  var controllerGlobal = Get.put(GlobalController());
  var controllerBpj = Get.put(BpjsController());
  final tabbController = Get.put(TabbController());
  final authController = Get.put(AuthController());

  Future<void> refreshData() async {
    controller.refreshPagesStatus.value = true;
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      controller.updateInformasiUser();
      controllerBpj.employeDetaiBpjs();
      controllerAbsensi.employeDetail();

      controller.onInit();

      controllerAbsensi.userShift();
 controller.initData();
      Future.delayed(const Duration(milliseconds: 500), () {
       

        absenControllre.absenStatus.value = AppData.statusAbsen;
        authController.signinTime.value=controller.signinTime.value;
            authController.signoutTime.value=controller.signoutTime.value;
        // absenControllre.absenStatus.value =
        //     controller.dashboardStatusAbsen.value;
      });
    });
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
      floatingActionButton: _isVisible == true
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
                                var statusLokasi = Permission.location.status;
                                statusLokasi.then((value2) async {
                                  if (value != PermissionStatus.granted ||
                                      value2 != PermissionStatus.granted) {
                                    UtilsAlert.showToast(
                                        "Anda harus aktifkan kamera dan lokasi anda");
                                    controller.widgetButtomSheetAktifCamera(
                                        'loadfirst');
                                  } else {
                                    print("masuk absen user");
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
                            UtilsAlert.showToast("Absen Masuk terlebih dahulu");
                          } else {
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
                          }
                        },
                  label: Text(
                    !controllerAbsensi.absenStatus.value ? "Masuk" : "Keluar",
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
            ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          return true;
        },
        child: Obx(
          () => Stack(
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
                  padding: EdgeInsets.only(top: _isVisible ? 252.0 : 175.0),
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
                                    color: Constanst.colorNeutralBgTertiary,
                                    borderRadius: Constanst.borderStyle3,
                                  )),
                            ),
                            // controller.menuShowInMain.value.isEmpty
                            //     ? const SizedBox()
                            //     : listModul(),
                            const SizedBox(height: 16),
                            controller.menuShowInMain.value.isEmpty
                                ? UtilsAlert.shimmerMenuDashboard(Get.context!)
                                : MenuDashboard(),
                            cardFormPengajuan(),
                            const SizedBox(height: 16),
                            controller.bannerDashboard.value.isEmpty
                                ? const SizedBox()
                                : sliderBanner(),
                            const SizedBox(height: 10),

                            controller.showPengumuman.value == false
                                ? const SizedBox()
                                : controller.informasiDashboard.value.isEmpty
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
                                            padding: const EdgeInsets.only(
                                                left: 16.0,
                                                top: 16.0,
                                                right: 8.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Informasi",
                                                  style: GoogleFonts.inter(
                                                      color:
                                                          Constanst.fgPrimary,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Material(
                                                  color: Constanst.colorWhite,
                                                  child: InkWell(
                                                    customBorder:
                                                        RoundedRectangleBorder(
                                                      borderRadius: Constanst
                                                          .borderStyle5,
                                                    ),
                                                    onTap: () =>
                                                        Get.offAll(Informasi(
                                                      index: 0,
                                                    )),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          8.0, 3.0, 8.0, 3.0),
                                                      child: Text(
                                                        "Lihat semua",
                                                        style:
                                                            GoogleFonts.inter(
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
                                : controller.informasiDashboard.value.isEmpty
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
                                            padding: const EdgeInsets.only(
                                                left: 16.0,
                                                top: 16.0,
                                                right: 8.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Reminder PKWT",
                                                  style: GoogleFonts.inter(
                                                      color:
                                                          Constanst.fgPrimary,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Material(
                                                  color: Constanst.colorWhite,
                                                  child: InkWell(
                                                    customBorder:
                                                        RoundedRectangleBorder(
                                                      borderRadius: Constanst
                                                          .borderStyle5,
                                                    ),
                                                    onTap: () =>
                                                        Get.offAll(Informasi(
                                                      index: 3,
                                                    )),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          8.0, 3.0, 8.0, 3.0),
                                                      child: Text(
                                                        "Lihat semua",
                                                        style:
                                                            GoogleFonts.inter(
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
                                : controllerGlobal.employeeSisaCuti.isEmpty
                                    ? const SizedBox()
                                    : const SizedBox(height: 8),
                            controller.showPkwt.value == false
                                ? const SizedBox()
                                : controllerGlobal.employeeSisaCuti.isEmpty
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
                                            padding: const EdgeInsets.only(
                                                left: 16.0,
                                                top: 16.0,
                                                right: 8.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Ulang tahun bulan ini",
                                                  style: GoogleFonts.inter(
                                                      color:
                                                          Constanst.fgPrimary,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Material(
                                                  color: Constanst.colorWhite,
                                                  child: InkWell(
                                                    customBorder:
                                                        RoundedRectangleBorder(
                                                      borderRadius: Constanst
                                                          .borderStyle5,
                                                    ),
                                                    onTap: () => Get.offAll(
                                                      Informasi(index: 1),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          8.0, 3.0, 8.0, 3.0),
                                                      child: Text(
                                                        "Lihat semua",
                                                        style:
                                                            GoogleFonts.inter(
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
  }

  Widget informasiUser() {
    return IntrinsicHeight(
      child: InkWell(
        onTap: () => Get.to(PersonalInfo()),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _isVisible
                    ? Column(
                        children: [
                          Text(
                            AppData.informasiUser![0].branchName.toString(),
                            style: GoogleFonts.inter(
                                color: Constanst.fgSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
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
                ),
                const SizedBox(height: 4),
                Text(
                  "${AppData.informasiUser![0].emp_jobTitle ?? ""} - ${AppData.informasiUser![0].posisi ?? ""}",
                  style: GoogleFonts.inter(
                      color: Constanst.fgPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            AppData.informasiUser![0].em_image == ""
                ? SvgPicture.asset(
                    'assets/avatar_default.svg',
                    width: _isVisible ? 50 : 42,
                    height: _isVisible ? 50 : 42,
                  )
                : CircleAvatar(
                    radius: 25, // Image radius
                    child: ClipOval(
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl:
                              "${Api.UrlfotoProfile}${AppData.informasiUser![0].em_image}",
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Container(
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.height * 0.5,
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
                                Text(
                                  "Jadwal 08:30 - 18:00",
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Constanst.fgSecondary),
                                ),
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap: () => UtilsAlert.informasiDashboard(
                                      Get.context!),
                                  child: Icon(
                                    Iconsax.info_circle,
                                    size: 16,
                                    color: Constanst.fgSecondary,
                                  ),
                                ),
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
                      //         return controllerAbsensi.shift.value.timeIn != ""
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

            _isVisible
                ? Column(
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
                              color: !controllerAbsensi.absenStatus.value
                                  ? Constanst.colorWhite
                                  : Constanst.colorNonAktif,
                              child: InkWell(
                                customBorder: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15.0),
                                  ),
                                ),
                                onTap: () {
                                  if (controllerAbsensi.absenStatus.value ==
                                      true) {
                                    UtilsAlert.showToast(
                                        "Anda harus absen keluar terlebih dahulu");
                                  } else {
                                    var dataUser = AppData.informasiUser;
                                    var faceRecog = dataUser![0].face_recog;
                                    print(
                                        "facee recog ${GetStorage().read('face_recog')}");
                                    if (GetStorage().read('face_recog') ==
                                        true) {
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
                                                    'loadfirst');
                                          } else {
                                            print("masuk absen user");
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

                                              if (controllerAbsensi
                                                      .regType.value ==
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
                                      left: 12, top: 12.0, bottom: 12),
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
                                            Icon(
                                              Iconsax.login5,
                                              color: !controllerAbsensi
                                                      .absenStatus.value
                                                  ? Constanst.color5
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
                                                  "Masuk",
                                                  style: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16,
                                                      color: !controllerAbsensi
                                                              .absenStatus.value
                                                          ? Constanst.fgPrimary
                                                          : const Color
                                                                  .fromARGB(168,
                                                              166, 167, 158)),
                                                ),
                                                Obx(() => Text(
                                                  controller.signinTime.value ==
                                                          "00:00:00"
                                                      ? "_ _:_ _:_ _"
                                                         
                                                      : controller
                                                          .signinTime.value,
                                                  style: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16,
                                                      color: !controllerAbsensi
                                                              .absenStatus.value
                                                          ? Constanst.fgPrimary
                                                          : const Color
                                                                  .fromARGB(168,
                                                              166, 167, 158)),
                                                ),)
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
                              color: controllerAbsensi.absenStatus.value
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
                                  if (!controllerAbsensi.absenStatus.value) {
                                    UtilsAlert.showToast(
                                        "Absen Masuk terlebih dahulu");
                                  } else {
                                    var dataUser = AppData.informasiUser;
                                    var faceRecog = dataUser![0].face_recog;

                                    if (GetStorage().read('face_recog') ==
                                        true) {
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

                                      if (controllerAbsensi.regType.value ==
                                          1) {
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
                                              color: controllerAbsensi
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
                                                      color: controllerAbsensi
                                                              .absenStatus.value
                                                          ? Constanst.fgPrimary
                                                          : const Color
                                                                  .fromARGB(168,
                                                              166, 167, 158)),
                                                ),
                                           Obx(() =>      Text(
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
                                                      color: controllerAbsensi
                                                              .absenStatus.value
                                                          ? Constanst.fgPrimary
                                                          : const Color
                                                                  .fromARGB(168,
                                                              166, 167, 158)),
                                                ),)
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
                  )
                : Container(),

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
          ],
        ),
      ),
    );
  }

  Widget cardFormPengajuan() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Constanst.colorStateInfoBorder,
                    width: 1.0,
                  ),
                  // color: Constanst.colorButton3,
                  borderRadius: Constanst.borderStyle2),
              child: Material(
                borderRadius: Constanst.borderStyle2,
                color: Constanst.infoLight1,
                child: InkWell(
                  customBorder: RoundedRectangleBorder(
                    borderRadius: Constanst.borderStyle2,
                  ),
                  onTap: () => controller.widgetButtomSheetFormPengajuan(),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Iconsax.add_square5,
                              color: Constanst.infoLight,
                              size: 26,
                            ),
                            const SizedBox(width: 10),
                            Column(
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
                                ),
                              ],
                            ),
                          ],
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
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Constanst.colorStateInfoBorder,
                    width: 1.0,
                  ),
                  // color: Constanst.colorButton3,
                  borderRadius: Constanst.borderStyle2),
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
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Iconsax.document_text5,
                              color: Constanst.infoLight,
                              size: 26,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Laporan",
                                  style: GoogleFonts.inter(
                                      color: Constanst.fgPrimary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Cek laporan disini!",
                                  style: GoogleFonts.inter(
                                      color: Constanst.fgPrimary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ],
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
                            child: Image.network(
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
                            ),
                          )),
                    ),
                  );
                }),
            DotsIndicator(
              dotsCount: controller.bannerDashboard.value.length,
              position: double.parse("${controller.indexBanner.value}"),
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
                padding: EdgeInsets.only(left: 8, right: 8),
                margin: EdgeInsets.only(left: 8, right: 8),
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
    return SizedBox(
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
                onTap: () => controller.widgetButtomSheetMenuLebihDetail(),
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
                  itemCount:
                      controller.menuShowInMain.value[0]['menu'].length - 1,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, idxMenu) {
                    var gambar =
                        controller.menuShowInMain[0]['menu'][idxMenu]['gambar'];
                    var namaMenu =
                        controller.menuShowInMain[0]['menu'][idxMenu]['nama'];
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
                        onTap: () => controller.routePageDashboard(controller
                            .menuShowInMain[0]['menu'][idxMenu]['url']),
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
                                                  BorderRadius.circular(100.0)),
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
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(0),
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
                      onTap: () => controller.routePageDashboard(controller
                          .menuShowInMain[index]['menu'][idxMenu]['url']),
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
                                            SizedBox(),
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
                            SizedBox(
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
                        Html(
                          data: desc,
                          style: {
                            "body": Style(
                                fontSize: const FontSize(14),
                                maxLines: 2,
                                textOverflow: TextOverflow.ellipsis,
                                margin: const EdgeInsets.all(0.0),
                                color: Constanst.fgPrimary,
                                fontFamily: "GoogleFonts.inter",
                                fontWeight: FontWeight.w400),
                          },
                        ),
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

  @override
  void initState() {
    super.initState();
    controller.updateInformasiUser();

    controller.initData();
    absenControllre.getTimeNow();

    controller.checkAbsenUser(DateFormat('yyyy-MM-dd').format(DateTime.now()),
        AppData.informasiUser![0].em_id);
    controllerBpj.employeDetaiBpjs();

    controllerAbsensi.employeDetail();

    absenControllre.absenStatus.value = AppData.statusAbsen;
 authController.signinTime.value=controller.signinTime.value;
            authController.signoutTime.value=controller.signoutTime.value;
    Future.delayed(const Duration(milliseconds: 500), () {
      controller.initData();
      absenControllre.absenStatus.value = AppData.statusAbsen;
              authController.signinTime.value=controller.signinTime.value;
            authController.signoutTime.value=controller.signoutTime.value;
      // absenControllre.absenStatus.value =
      //     controller.dashboardStatusAbsen.value;
    });

    // Api().checkLogin();
    // Add a listener to the scroll controller
    _scrollController.addListener(_scrollListener);
  }

  void _checkversion() async {
    final newVersion = NewVersionPlus(
      androidId: 'com.siscom.siscomhris',
    );

    final status = await newVersion.getVersionStatus();
    newVersion.showUpdateDialog(
        context: context,
        versionStatus: status!,
        dialogTitle: "Update SISCOM HRIS",
        dialogText: "Update versi SISCOM HRIS dari versi" +
            status.localVersion +
            " ke versi " +
            status.storeVersion,
        dismissAction: () {
          Get.back();
        },
        updateButtonText: "Update Sekarang",
        dismissButtonText: "Skip");
    print("status ${status.localVersion}");
  }
}
