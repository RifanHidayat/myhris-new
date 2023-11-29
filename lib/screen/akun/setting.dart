// ignore_for_file: deprecated_member_use
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_operasional/controller/dashboard_controller.dart';
import 'package:siscom_operasional/controller/setting_controller.dart';
import 'package:siscom_operasional/screen/akun/edit_password.dart';
import 'package:siscom_operasional/screen/akun/face_recognigration.dart';
import 'package:siscom_operasional/screen/akun/info_karyawan.dart';
import 'package:siscom_operasional/screen/akun/personal_info.dart';
import 'package:siscom_operasional/screen/akun/pusat_bantuan.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';

import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final controller = Get.put(SettingController());
  final controllerDashboard = Get.put(DashboardController());
  var faceRecog = false;

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
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Obx(() => Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, top: 16, bottom: 16),
                          child: firstLine(),
                        )),
                  ),
                  lineInfoPengguna(),
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
          )),
    );
  }

  Widget firstLine() {
    return controller.refreshPageStatus.value
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UtilsAlert.shimmerInfoPersonal(Get.context!),
              const SizedBox(height: 50)
            ],
          )
        : Column(
            children: [
              InkWell(
                customBorder: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                onTap: () => Get.to(PersonalInfo()),
                child: Container(
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
                          Row(
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
                                          ? Image.asset(
                                              'assets/avatar_default.png',
                                              width: 56,
                                              height: 56,
                                            )
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
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.5,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: CircularProgressIndicator(
                                                          value:
                                                              downloadProgress
                                                                  .progress),
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Image.asset(
                                                      'assets/avatar_default.png',
                                                      width: 56,
                                                      height: 56,
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
                                              padding: const EdgeInsets.all(3),
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
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${AppData.informasiUser![0].full_name}",
                                      style: GoogleFonts.inter(
                                          color: Constanst.fgPrimary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${AppData.informasiUser![0].emp_jobTitle} • ",
                                          style: GoogleFonts.inter(
                                              color: Constanst.fgPrimary,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Text(
                                          "${AppData.informasiUser![0].posisi} • ",
                                          style: GoogleFonts.inter(
                                              color: Constanst.fgPrimary,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Text(
                                          "${AppData.informasiUser![0].em_status}",
                                          style: GoogleFonts.inter(
                                              color: Constanst.fgPrimary,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                            color: Constanst.fgSecondary,
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
              onTap: () => Get.to(InfoKaryawan()),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Constanst.fgBorder,
                      width: 1.0,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(12))),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/icon_info_keryawan.png",
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Info Karyawan",
                                  style: GoogleFonts.inter(
                                      color: Constanst.fgPrimary,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Cek rekan kerjamu!",
                                  style: GoogleFonts.inter(
                                      color: Constanst.fgSecondary,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
                              color: Constanst.fgSecondary,
                            ),
                          ],
                        ),
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
              // onTap: () => Get.to(InfoKaryawan()),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Constanst.fgBorder,
                      width: 1.0,
                    ),
                    color: Constanst.colorNonAktif,
                    borderRadius: const BorderRadius.all(Radius.circular(12))),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
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
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Kontrak 1",
                                  style: GoogleFonts.inter(
                                      color: const Color.fromARGB(
                                          168, 166, 167, 158),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      "12-12-2023",
                                      style: GoogleFonts.inter(
                                          color: const Color.fromARGB(
                                              168, 166, 167, 158),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12),
                                    ),
                                    Text(
                                      " • ",
                                      style: GoogleFonts.inter(
                                          color: const Color.fromARGB(
                                              168, 166, 167, 158),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 7),
                                    ),
                                    Text(
                                      "5hr",
                                      style: GoogleFonts.inter(
                                          color: const Color.fromARGB(
                                              168, 166, 167, 158),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
                              color: Color.fromARGB(168, 166, 167, 158),
                            ),
                          ],
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
    );
  }

  Widget linePengaturan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
          child: Text(
            "Pengaturan",
            style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Constanst.fgSecondary),
          ),
        ),
        InkWell(
          onTap: () => Get.to(EditPassword()),
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
          onTap: () => Get.to(FaceRecognition()),
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
