// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_operasional/controller/setting_controller.dart';
import 'package:siscom_operasional/screen/init_screen.dart';
import 'package:siscom_operasional/utils/appbar_widget.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/custom_dialog.dart';
import 'package:siscom_operasional/utils/widget_textButton.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';

class EditPassword extends StatelessWidget {
  final controller = Get.find<SettingController>();

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
            centerTitle: false,
            title: Text(
              "Ubah Kata Sandi",
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
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Password Lama",
                      style: GoogleFonts.inter(
                          color: Constanst.fgPrimary,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8)),
                          border: Border.all(
                              width: 0.5, color: Constanst.fgBorder)),
                      child: Obx(
                        () => TextField(
                          obscureText: !this.controller.showpasswordLama.value,
                          controller: controller.passwordLama.value,
                          textAlignVertical: TextAlignVertical.center,
                          cursorColor: Constanst.fgPrimary,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIconColor: Constanst.fgSecondary,
                              prefixIcon: const Icon(Iconsax.lock_1),
                              // ignore: unnecessary_this
                              suffixIcon: IconButton(
                                icon: Icon(
                                  this.controller.showpasswordLama.value
                                      ? Iconsax.eye
                                      : Iconsax.eye_slash,
                                  color: Constanst.fgSecondary,
                                ),
                                onPressed: () {
                                  this.controller.showpasswordLama.value =
                                      !this.controller.showpasswordLama.value;
                                },
                              )),
                          style: GoogleFonts.inter(
                              color: Constanst.fgPrimary,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Password Baru",
                      style: GoogleFonts.inter(
                          color: Constanst.fgPrimary,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8)),
                          border: Border.all(
                              width: 0.5,
                              color: Color.fromARGB(255, 211, 205, 205))),
                      child: Obx(
                        () => TextField(
                          obscureText: !this.controller.showpasswordBaru.value,
                          controller: controller.passwordBaru.value,
                          textAlignVertical: TextAlignVertical.center,
                          cursorColor: Constanst.fgPrimary,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIconColor: Constanst.fgSecondary,
                              prefixIcon: const Icon(Iconsax.lock_1),
                              // ignore: unnecessary_this
                              suffixIcon: IconButton(
                                icon: Icon(
                                  this.controller.showpasswordBaru.value
                                      ? Iconsax.eye
                                      : Iconsax.eye_slash,
                                  color: Constanst.fgSecondary,
                                ),
                                onPressed: () {
                                  this.controller.showpasswordBaru.value =
                                      !this.controller.showpasswordBaru.value;
                                },
                              )),
                          style: GoogleFonts.inter(
                              color: Constanst.fgPrimary,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
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
                                  content: "Yakin ganti password ?",
                                  positiveBtnText: "Simpan",
                                  negativeBtnText: "Kembali",
                                  style: 1,
                                  buttonStatus: 1,
                                  positiveBtnPressed: () {
                                    controller.ubahPassword();
                                  },
                                ),
                              );
                            },
                            pageBuilder: (BuildContext context,
                                Animation animation,
                                Animation secondaryAnimation) {
                              return null!;
                            },
                          );
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
                            'Simpan',
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
            ),
          )),
    );
  }
}
