// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_operasional/controller/absen_controller.dart';
import 'package:siscom_operasional/controller/setting_controller.dart';
import 'package:siscom_operasional/screen/akun/face_recognition_foto.dart';
import 'package:siscom_operasional/screen/akun/face_registration_verify_password.dart';
import 'package:siscom_operasional/screen/init_screen.dart';
import 'package:siscom_operasional/utils/appbar_widget.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/custom_dialog.dart';
import 'package:siscom_operasional/utils/widget_textButton.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';

class FaceRecognition extends StatelessWidget {
  final controller = Get.put(SettingController());

  final list = [
    {
      "icon": "0",
      "title": "Proses absensi yang lebih cepat",
      "subtitle":
          "Proses absensi dilakukan dengan lebih cepat sehingga dapat menghemat waktu."
    },
    {
      "icon": "1",
      "title": "Mencegah penyalahgunaan absensi",
      "subtitle":
          "Memastikan bahwa hanya orang yang terdaftar yang dapat melakukan absensi."
    },
    {
      "icon": "2",
      "title": "Hemat ruang penyimpanan",
      "subtitle":
          "Fitur ini melakukan scan untuk mengenali data wajah tersimpan, dan tidak ada  gambar yang disimpan dalam memori internal."
    },
  ];
  final AbsenController absenController = Get.put(AbsenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constanst.coloBackgroundScreen,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight) * 1,
          child: Container(
            decoration: const BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 2.0),
                blurRadius: 4.0,
              )
            ]),
            child: AppBar(
              backgroundColor: Constanst.colorWhite,
              elevation: 0,
              leadingWidth: 50,
              titleSpacing: 0,
              centerTitle: true,
              title: Text(
                "Data Wajah",
                style: GoogleFonts.inter(
                    color: Constanst.fgPrimary,
                    fontWeight: FontWeight.w500,
                    fontSize: 20),
              ),
              leading: IconButton(
                icon: Icon(
                  Iconsax.arrow_left,
                  color: Constanst.fgPrimary,
                  size: 24,
                ),
                onPressed: Get.back,
                // onPressed: () {
                //   controller.cari.value.text = "";
                //   Get.back();
                // },
              ),
            ),
          ),
        ),
        body: WillPopScope(
          onWillPop: () async {
            Get.back();
            return true;
          },
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(Get.context!).size.width,
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Column(
                children: [
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 1,
                              color: GetStorage().read('face_recog') == false
                                  ? Constanst.fgSecondary
                                  : Constanst.infoLight,
                            )),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 12,
                            bottom: 12,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                GetStorage().read('face_recog') == false
                                    ? "assets/emoji_sad_cross.png"
                                    : "assets/emoji_happy_tick.png",
                                width: 64,
                                height: 64,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                GetStorage().read('face_recog') == false
                                    ? "Data Wajah belum di registrasi"
                                    : "Data Wajah sudah di registrasi",
                                style: GoogleFonts.inter(
                                    color:
                                        GetStorage().read('face_recog') == false
                                            ? Constanst.fgPrimary
                                            : Constanst.infoLight,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                GetStorage().read('face_recog') == false
                                    ? "Anda belum registrasi data wajah. Registrasi sekarang untuk bisa melakukan Absen."
                                    : "Anda sudah registrasi data wajah. Registrasi ulang\ndapat menghapus data wajah sebelumnya.",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                    color: Constanst.fgSecondary,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                              ),
                              GetStorage().read('face_recog') == false
                                  ? Container()
                                  : InkWell(
                                      onTap: () {
                                        Get.to(FaceRecognitionPhotoPage());
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8.0, 4.0, 8.0, 4.0),
                                        child: Text(
                                          "Lihat Foto",
                                          style: GoogleFonts.inter(
                                              color: Constanst.infoLight,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      GetStorage().read('face_recog') == false
                          ? SizedBox(
                              width: double.infinity,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () {
                                  absenController
                                      .widgetButtomSheetFaceRegistrattion();
                                },
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Constanst.colorWhite,
                                    backgroundColor: Constanst.colorPrimary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 0,
                                    // padding: EdgeInsets.zero,
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 0)),
                                child: Text(
                                  'Registrasi Sekarang',
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      color: Constanst.colorWhite,
                                      fontSize: 15),
                                ),
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    width: 1,
                                    color: Constanst.border,
                                  )),
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.to(FaceRegistrationVerifyPassword());
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
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 8.0),
                                  child: Text(
                                    'Hapus dan Registrasi ulang',
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                        color: Constanst.color4,
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Text(
                    "Untuk apa fitur ini?",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        color: Constanst.fgPrimary,
                        fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(width: 1, color: HexColor('#D5DBE5'))),
                    child: Padding(
                      padding:
                          const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 20.0),
                      child: Column(
                        children: List.generate(list.length, (index) {
                          var data = list[index];
                          return Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    data['icon'] == "0"
                                        ? Iconsax.flash
                                        : data['icon'] == "1"
                                            ? Iconsax.security_user
                                            : data['icon'] == "2"
                                                ? Iconsax.gallery_remove
                                                : Iconsax.security_user,
                                    size: 26,
                                    color: Constanst.fgPrimary,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          data['title'].toString(),
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              color: Constanst.fgPrimary,
                                              fontSize: 16),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          data['subtitle'].toString(),
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w400,
                                              color: Constanst.fgSecondary,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              index == list.length - 1
                                  ? Container()
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                          top: 12.0, bottom: 12.0),
                                      child: Divider(
                                        color: Constanst.border,
                                        thickness: 1,
                                        height: 0,
                                      ),
                                    )
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
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
                            "Data wajah ini akan digunakan setiap kali Kamu melakukan Absen Masuk dan Keluar.",
                            textAlign: TextAlign.left,
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                color: Constanst.fgSecondary,
                                fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
