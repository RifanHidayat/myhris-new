// ignore_for_file: deprecated_member_use
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:siscom_operasional/controller/aktifitas_controller.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:siscom_operasional/controller/auth_controller.dart';
import 'package:siscom_operasional/controller/dashboard_controller.dart';
import 'package:siscom_operasional/controller/setting_controller.dart';
import 'package:siscom_operasional/screen/absen/camera_view_location.dart';
import 'package:siscom_operasional/screen/akun/change_log.dart';
import 'package:siscom_operasional/screen/akun/edit_password.dart';
import 'package:siscom_operasional/screen/akun/face_recognigration.dart';
import 'package:siscom_operasional/screen/akun/info_karyawan.dart';
import 'package:siscom_operasional/screen/akun/personal_info.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/month_year_picker.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final controller = Get.put(SettingController());
  final controllerDashboard = Get.put(DashboardController());
  final authController = Get.put(AuthController());
  var faceRecog = false;
  var namaVersi = "...".obs;

  Future<void> refreshData() async {
    controller.refreshPageStatus.value = true;
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      var dashboardController = Get.find<DashboardController>();
      dashboardController.updateInformasiUser();
      controller.onReady();
      controller.refreshPageStatus.value = false;
    });
  }

  @override
  void initState() {
    super.initState();

    getFace();
    _checkversion();
  }

  void _checkversion() async {
    final newVersion = NewVersionPlus(
      androidId: 'com.siscom.siscomhris',
    );

    final status = await newVersion.getVersionStatus();
    print("ini status valuenya $status");
    namaVersi.value = status!.localVersion;
  }

  @override
  Widget build(BuildContext context) {
    getFace();
    return Scaffold(
      backgroundColor: Constanst.colorWhite,
      body: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: SafeArea(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Obx(() => Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                              top: 16,
                            ),
                            child: firstLine(),
                          )),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16),
                      child: infoPeriode(),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    lineInfoPengguna(),
                    Visibility(
                      visible:
                          int.parse(AppData.informasiUser![0].sisaKontrak) <=
                                  60 &&
                              AppData.informasiUser![0].tanggalBerakhirKontrak
                                      .toString() != "" ,
                      child: InkWell(
                        onTap: () => //authController.isConnected.value
                            // ?
                            controller.lineInfoPenggunaKontrak(),
                        // : UtilsAlert.showDialogCheckInternet(),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, right: 16),
                              child: UtilsAlert.infoContainer(
                                  "Kontrak kerja Anda akan segera berakhir dalam ${AppData.informasiUser![0].sisaKontrak.toString()} hari lagi"),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                        height: 6,
                        width: double.infinity,
                        color: Constanst.colorNeutralBgSecondary),
                    linePengaturan(),
                    Container(
                        height: 6,
                        width: double.infinity,
                        color: Constanst.colorNeutralBgSecondary),
                    lineLainnya(),
                    Container(
                        height: 6,
                        width: double.infinity,
                        color: Constanst.colorNeutralBgSecondary),
                    const SizedBox(height: 16),
                    Text(
                      "© Copyright 2022 PT. Shan Informasi Sistem",
                      style: GoogleFonts.inter(
                          color: Constanst.colorNeutralFgTertiary,
                          fontWeight: FontWeight.w400,
                          fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Build Version 2023.12.20",
                      style: GoogleFonts.inter(
                          color: Constanst.colorNeutralFgTertiary,
                          fontWeight: FontWeight.w400,
                          fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget firstLine() {
    // var span = TextSpan(
    //   text: AppData.informasiUser![0].em_status,
    //   style: const TextStyle(fontSize: 12),
    // );

    // // Use a textpainter to determine if it will exceed max lines
    // var tp = TextPainter(
    //   maxLines: 1,
    //   textAlign: TextAlign.left,
    //   textDirection: TextDirection.ltr,
    //   text: span,
    // );

    // // trigger it to layout
    // tp.layout(maxWidth: size.maxWidth);

    // // whether the text overflowed or not
    // var exceeded = tp.didExceedMaxLines;

    return controller.refreshPageStatus.value
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UtilsAlert.shimmerInfoPersonal(Get.context!),
              const SizedBox(height: 50)
            ],
          )
        : Stack(
            children: [
              // Positioned(
              //   top: 10,
              //   right: 10,
              //   child: Padding(
              //     padding: const EdgeInsets.only(right: 16),
              //     child: SizedBox(
              //       width: 20,
              //       height: 20,
              //       child: Obx(() {
              //         return Container(
              //           decoration: BoxDecoration(
              //             color: authController.isConnected.value
              //                 ? Constanst.color5
              //                 : Constanst.color4,
              //             borderRadius: BorderRadius.circular(20),
              //           ),
              //         );
              //       }),
              //     ),
              //   ),
              // ),
              InkWell(
                customBorder: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                onTap: () => Get.to(PersonalInfo()),
                child: Container(
                    width: 380,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Constanst.fgBorder,
                          width: 1.0,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12))),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 12.0, 0.0, 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 90,
                            child: Row(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Constanst.color5,
                                            width: 2.0,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(100))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: AppData.informasiUser![0]
                                                        .em_image ==
                                                    null ||
                                                AppData.informasiUser![0]
                                                        .em_image ==
                                                    ""
                                            ? CircleAvatar(
                                                radius: 28,
                                                child: ClipOval(
                                                  child: ClipOval(
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          "${Api.urlImage}/${AppData.selectedDatabase}/face_recog/${GetStorage().read('file_face')}",
                                                      progressIndicatorBuilder:
                                                          (context, url,
                                                                  downloadProgress) =>
                                                              Container(
                                                        alignment:
                                                            Alignment.center,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.5,
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: CircularProgressIndicator(
                                                            value:
                                                                downloadProgress
                                                                    .progress),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Container(
                                                        color: Colors.white,
                                                        child: SvgPicture.asset(
                                                          'assets/avatar_default.svg',
                                                          width: 56,
                                                          height: 56,
                                                        ),
                                                      ),
                                                      fit: BoxFit.cover,
                                                      width: 56,
                                                      height: 56,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            // ? CachedNetworkImage(
                                            //     imageUrl:
                                            //         "${Api.urlImage}/${AppData.selectedDatabase}/face_recog/${GetStorage().read('file_face')}",
                                            //     progressIndicatorBuilder:
                                            //         (context, url,
                                            //                 downloadProgress) =>
                                            //             Container(
                                            //       alignment: Alignment.center,
                                            //       height: MediaQuery.of(context)
                                            //               .size
                                            //               .height *
                                            //           0.5,
                                            //       width: MediaQuery.of(context)
                                            //           .size
                                            //           .width,
                                            //       child:
                                            //           CircularProgressIndicator(
                                            //               value:
                                            //                   downloadProgress
                                            //                       .progress),
                                            //     ),
                                            //     errorWidget:
                                            //         (context, url, error) =>
                                            //             Container(
                                            //       color: Colors.white,
                                            //       child: SvgPicture.asset(
                                            //     'assets/avatar_default.svg',
                                            //     width: 56,
                                            //     height: 56,
                                            //   )
                                            //     ),
                                            //     fit: BoxFit.cover,
                                            //   )
                                            // ? SvgPicture.asset(
                                            //     'assets/avatar_default.svg',
                                            //     width: 56,
                                            //     height: 56,
                                            //   )
                                            : CircleAvatar(
                                                radius: 28,
                                                child: ClipOval(
                                                  child: ClipOval(
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          "${Api.UrlfotoProfile}${AppData.informasiUser![0].em_image}",
                                                      progressIndicatorBuilder:
                                                          (context, url,
                                                                  downloadProgress) =>
                                                              Container(
                                                        alignment:
                                                            Alignment.center,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.5,
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: CircularProgressIndicator(
                                                            value:
                                                                downloadProgress
                                                                    .progress),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Container(
                                                        color: Colors.white,
                                                        child: SvgPicture.asset(
                                                          'assets/avatar_default.svg',
                                                          width: 56,
                                                          height: 56,
                                                        ),
                                                      ),
                                                      fit: BoxFit.cover,
                                                      width: 56,
                                                      height: 56,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ),
                                    Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: ClipOval(
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            color: Colors.white,
                                            child: ClipOval(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(3),
                                                color: Constanst.color5,
                                                child: const Icon(
                                                  Icons.check,
                                                  size: 12,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ))
                                  ],
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${AppData.informasiUser![0].full_name}",
                                          style: GoogleFonts.inter(
                                              color: Constanst.fgPrimary,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "${AppData.informasiUser![0].emp_jobTitle} • ${AppData.informasiUser![0].posisi} • ${AppData.informasiUser![0].em_status}",
                                                style: GoogleFonts.inter(
                                                    color: Constanst.fgPrimary,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                            // Text(
                                            //   "",
                                            //   style: GoogleFonts.inter(
                                            //       color: Constanst.fgPrimary,
                                            //       fontSize: 12,
                                            //       fontWeight: FontWeight.w400),
                                            // ),
                                            // Expanded(
                                            //   child: Text(
                                            //     "",
                                            //     style: GoogleFonts.inter(
                                            //         color: Constanst.fgPrimary,
                                            //         fontSize: 12,
                                            //         fontWeight:
                                            //             FontWeight.w400),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 10,
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
                              color: Constanst.fgSecondary,
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
            ],
          );
  }

  Widget lineInfoPengguna() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              customBorder: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              onTap: () => //authController.isConnected.value
                  // ?
                  Get.to(InfoKaryawan()),
              // : UtilsAlert.showDialogCheckInternet(),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Constanst.fgBorder,
                    width: 1.0,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "assets/icon_info_keryawan.png",
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Info Karyawan",
                              style: GoogleFonts.inter(
                                  color: Constanst.fgPrimary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Cek rekan kerjamu!",
                              style: GoogleFonts.inter(
                                  color: Constanst.fgSecondary,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: Constanst.fgSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: InkWell(
              customBorder: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              onTap: () => //authController.isConnected.value
                  // ?
                  controller.lineInfoPenggunaKontrak(),
              // : UtilsAlert.showDialogCheckInternet(),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Constanst.fgBorder,
                    width: 1.0,
                  ),
                  // color: Constanst.colorNonAktif,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/icon_kontrak.png",
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppData.informasiUser![0].em_status
                                      .toString()[0]
                                      .toUpperCase() +
                                  AppData.informasiUser![0].em_status
                                      .toString()
                                      .substring(1)
                                      .toLowerCase(),
                              style: GoogleFonts.inter(
                                  color: Constanst.fgPrimary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            const SizedBox(height: 4),
                            AppData.informasiUser![0].tanggalBerakhirKontrak !=
                                    ""
                                ? Row(
                                    children: [
                                      Text(
                                        AppData.informasiUser![0]
                                            .tanggalBerakhirKontrak
                                            .toString(),
                                        style: GoogleFonts.inter(
                                            color: Constanst.fgSecondary,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      Text(
                                        " • ",
                                        style: GoogleFonts.inter(
                                            color: Constanst.fgSecondary,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 7),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      Text(
                                        AppData.informasiUser![0].sisaKontrak,
                                        style: GoogleFonts.inter(
                                            color: Constanst.fgSecondary,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 7),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ],
                                  )
                                : Text(
                                    "-",
                                    style: GoogleFonts.inter(
                                        color: Constanst.fgSecondary,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: Constanst.fgSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget infoPeriode() {
    return GestureDetector(
      onTap: () {
        var dt = DateTime.parse(AppData.endPeriode);
        var outputFormat1 = DateFormat('MM');
        var outputFormat2 = DateFormat('yyyy');
        controller.bulanEnd.value = outputFormat1.format(dt);
        controller.tahunSelectedSearchHistory.value = outputFormat2.format(dt);
        var selectedDate =
            "${controller.tahunSelectedSearchHistory.value}-${controller.bulanEnd.value}-01";
        DateTime parsedDate;
        try {
          parsedDate = DateTime.parse(selectedDate);
        } catch (e) {
          parsedDate = DateTime.now();
        }

        var formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
        print("Formatted date: $formattedDate");

        DatePicker.showPicker(
          Get.context!,
          pickerModel: CustomMonthPicker(
            minTime: DateTime(2020, 1, 1),
            maxTime: DateTime(2050, 1, 1),
            currentTime: parsedDate,
            locale: LocaleType.id
          ),
          onConfirm: (time) {
            // if (time != null) {
            //   print("$time");
            //   var filter = DateFormat('yyyy-MM').format(time);
            //   DateTime previousMonthDate =
            //       DateTime(time.year, time.month - 1, time.day);

            //   var array = filter.split('-');
            //   var bulan = array[1];
            //   var tahun = array[0];
            //   controller.stringBulan.value =
            //       DateFormat('MMMM').format(time);
            //   controller.endPayroll.value =
            //       DateFormat('MMMM').format(time);

            //   controller.bulanEnd.value = DateFormat('MM').format(time);

            //   if (AppData.informasiUser![0].beginPayroll == 1) {
            //     controller.beginPayroll.value =
            //         DateFormat('MMMM').format(time);
            //     controller.bulanStart.value =
            //         DateFormat('MM').format(time);
            //   } else {
            //     controller.beginPayroll.value =
            //         DateFormat('MMMM').format(previousMonthDate);
            //     controller.bulanStart.value =
            //         DateFormat('MM').format(previousMonthDate);
            //   }
            //   // AppData.startPeriode =
            //   //     "${AppData.informasiUser![0].beginPayroll.toString().padLeft(2, '0')}-$bulan-$tahun";
            //   // AppData.endPeriode =
            //   //     "${AppData.informasiUser![0].endPayroll.toString().padLeft(2, '0')}-$bulan-$tahun";
            //   controller.bulanSelectedSearchHistory.value = bulan;
            //   controller.tahunSelectedSearchHistory.value = tahun;
            //   controller.bulanDanTahunNow.value = "$bulan-$tahun";
            //   controller.bulanSelectedSearchHistory.refresh();
            //   controller.tahunSelectedSearchHistory.refresh();
            //   controller.bulanDanTahunNow.refresh();
            //   controller.stringBulan.refresh();
            // }
            controller.setDate(DateTime.parse(time.toString()));
          },
        );
      },
      child: Container(
        width: 380,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Constanst.fgBorder,
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.blue),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Periode",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    Obx(() => Text(
                          "${controller.endPayroll.value} ${controller.tahunSelectedSearchHistory.value}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        )),
                    Obx(() => Text(
                          "Dari ${AppData.informasiUser![0].beginPayroll} ${controller.beginPayroll.value} sd ${AppData.informasiUser![0].endPayroll} ${controller.endPayroll.value} ${controller.tahunSelectedSearchHistory.value}",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        )),
                  ],
                ),
              ],
            ),
            const Expanded(
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

// Widget showReminderr(){
//   return Center(
//         child: ElevatedButton(
//           onPressed: () {
//             showDialog(
//               context: context,
//               builder: (BuildContext context) {
//                 return Dialog(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15.0),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "Reminder",
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             IconButton(
//                               icon: Icon(Icons.close),
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                               },
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           "Pastikan Anda tidak melewatkan batas waktu penting! Kontrak kerja Anda akan segera berakhir",
//                           style: TextStyle(fontSize: 14),
//                         ),
//                         SizedBox(height: 16),
//                         Row(
//                           children: [
//                             Icon(Icons.hourglass_bottom, color: Colors.blue),
//                             SizedBox(width: 8),
//                             Text(
//                               "Waktu tersisa",
//                               style: TextStyle(fontSize: 16),
//                             ),
//                             Spacer(),
//                             Obx(() => Text(
//                               "${controller.waktuTersisa.value} hari",
//                               style: TextStyle(fontSize: 16),
//                             )),
//                           ],
//                         ),
//                         Divider(),
//                         Row(
//                           children: [
//                             Icon(Icons.work, color: Colors.blue),
//                             SizedBox(width: 8),
//                             Text(
//                               "Lama Bekerja",
//                               style: TextStyle(fontSize: 16),
//                             ),
//                             Spacer(),
//                             Obx(() => Text(
//                               "${controller.lamaBekerja.value} Bulan",
//                               style: TextStyle(fontSize: 16),
//                             )),
//                           ],
//                         ),
//                         Divider(),
//                         Row(
//                           children: [
//                             Icon(Icons.calendar_today, color: Colors.blue),
//                             SizedBox(width: 8),
//                             Text(
//                               "Tanggal berakhir",
//                               style: TextStyle(fontSize: 16),
//                             ),
//                             Spacer(),
//                             Obx(() {
//                               var formattedDate = DateFormat('dd MMM yyyy').format(controller.tanggalBerakhir.value);
//                               return Text(
//                                 formattedDate,
//                                 style: TextStyle(fontSize: 16),
//                               );
//                             }),
//                           ],
//                         ),
//                         SizedBox(height: 16),
//                         Center(
//                           child: ElevatedButton(
//                             onPressed: () {
//                               // Aksi ketika tombol "Lihat Data" ditekan
//                               Navigator.of(context).pop();
//                             },
//                             child: Text("Lihat Data"),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//           child: Text("Tampilkan Reminder"),
//         ),
//       ),
//   }
// }

  Widget linePengaturan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
          child: Text(
            "Pengaturan",
            style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Constanst.fgSecondary),
          ),
        ),
        InkWell(
          onTap: () => //authController.isConnected.value
              // ?
              Get.to(EditPassword()),
          // : UtilsAlert.showDialogCheckInternet(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 12.0, 20.0, 12.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Iconsax.lock_1,
                          color: Constanst.fgSecondary,
                          size: 24,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(
                            "Ubah Kata Sandi",
                            style: GoogleFonts.inter(
                                color: Constanst.fgPrimary,
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
                          ),
                        )
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios_rounded,
                        size: 18, color: Constanst.fgSecondary)
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Divider(
            height: 0,
            thickness: 1,
            color: Constanst.colorNeutralBgTertiary,
          ),
        ),
        InkWell(
          onTap: () => //authController.isConnected.value
              // ?
              Get.to(FaceRecognition()),
          // : UtilsAlert.showDialogCheckInternet(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 12.0, 20.0, 12.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Iconsax.emoji_happy,
                          color: Constanst.fgSecondary,
                          size: 24,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Data Pengenal Wajah",
                                style: GoogleFonts.inter(
                                    color: Constanst.fgPrimary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              GetStorage().read("face_recog") == false
                                  ? Text(
                                      "Belum Registrasi",
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: Constanst.color4),
                                    )
                                  : Text(
                                      "Sudah Registrasi",
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: Constanst.infoLight),
                                    ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios_rounded,
                        size: 18, color: Constanst.fgSecondary)
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Divider(
            height: 0,
            thickness: 1,
            color: Constanst.colorNeutralBgTertiary,
          ),
        ),
        InkWell(
          onTap: () => //authController.isConnected.value
              // ?
              Get.to(ChangeLogPage()),
          // : UtilsAlert.showDialogCheckInternet(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 12.0, 20.0, 12.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Iconsax.info_circle,
                          color: Constanst.fgSecondary,
                          size: 24,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Change Log",
                                style: GoogleFonts.inter(
                                    color: Constanst.fgPrimary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              Obx(
                                () => Text(
                                  "Versi App: ${namaVersi.value}",
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Constanst.infoLight),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios_rounded,
                        size: 18, color: Constanst.fgSecondary)
                  ],
                ),
              ],
            ),
          ),
        ),
        // InkWell(
        //   onTap: () => null,
        //   child: Padding(
        //     padding: const EdgeInsets.fromLTRB(16.0, 12.0, 20.0, 12.0),
        //     child: Column(
        //       children: [
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             Row(
        //               children: [
        //                 Icon(
        //                   Iconsax.password_check,
        //                   color: Constanst.fgSecondary,
        //                   size: 24,
        //                 ),
        //                 Padding(
        //                   padding: const EdgeInsets.only(left: 12),
        //                   child: Text(
        //                     "PIN Slip Gaji",
        //                     style: GoogleFonts.inter(
        //                         color: Constanst.fgPrimary,
        //                         fontWeight: FontWeight.w500,
        //                         fontSize: 14),
        //                   ),
        //                 )
        //               ],
        //             ),
        //             Icon(Icons.arrow_forward_ios_rounded,
        //                 size: 18, color: Constanst.fgSecondary)
        //           ],
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        const SizedBox(height: 8),
      ],
    );
  }

  void getFace() {
    setState(() {
      print("tees");
      faceRecog = GetStorage().read('face_recog');
    });
  }

  Widget lineLainnya() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
          child: Text(
            "Lainnya",
            style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Constanst.fgSecondary),
          ),
        ),
        // InkWell(
        //   onTap: () => Get.to(PusatBantuan()),
        //   child: Padding(
        //     padding: const EdgeInsets.fromLTRB(16.0, 12.0, 20.0, 12.0),
        //     child: Column(
        //       children: [
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             Row(
        //               children: [
        //                 Icon(
        //                   Iconsax.message_question,
        //                   color: Constanst.fgSecondary,
        //                   size: 24,
        //                 ),
        //                 Padding(
        //                   padding: const EdgeInsets.only(left: 12),
        //                   child: Text(
        //                     "Pusat Bantuan",
        //                     style: GoogleFonts.inter(
        //                         color: Constanst.fgPrimary,
        //                         fontWeight: FontWeight.w500,
        //                         fontSize: 14),
        //                   ),
        //                 )
        //               ],
        //             ),
        //             Icon(Icons.arrow_forward_ios_rounded,
        //                 size: 18, color: Constanst.fgSecondary)
        //           ],
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        // Padding(
        //   padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        //   child: Divider(
        //     height: 0,
        //     thickness: 1,
        //     color: Constanst.colorNeutralBgTertiary,
        //   ),
        // ),
        // InkWell(
        //   onTap: () => null,
        //   child: Padding(
        //     padding: const EdgeInsets.fromLTRB(16.0, 12.0, 20.0, 12.0),
        //     child: Column(
        //       children: [
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             Row(
        //               children: [
        //                 Icon(
        //                   Iconsax.info_circle,
        //                   color: Constanst.fgSecondary,
        //                   size: 24,
        //                 ),
        //                 Padding(
        //                   padding: const EdgeInsets.only(left: 12),
        //                   child: Text(
        //                     "Tentang Aplikasi",
        //                     style: GoogleFonts.inter(
        //                         color: Constanst.fgPrimary,
        //                         fontWeight: FontWeight.w500,
        //                         fontSize: 14),
        //                   ),
        //                 )
        //               ],
        //             ),
        //             Icon(Icons.arrow_forward_ios_rounded,
        //                 size: 18, color: Constanst.fgSecondary)
        //           ],
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        // Padding(
        //   padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        //   child: Divider(
        //     height: 0,
        //     thickness: 1,
        //     color: Constanst.colorNeutralBgTertiary,
        //   ),
        // ),
        InkWell(
          onTap: () => controller.logout(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 12.0, 20.0, 12.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Iconsax.logout,
                          color: Constanst.color4,
                          size: 24,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(
                            "Logout",
                            style: GoogleFonts.inter(
                                color: Constanst.color4,
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
                          ),
                        )
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios_rounded,
                        size: 18, color: Constanst.fgSecondary)
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
