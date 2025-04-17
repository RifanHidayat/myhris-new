import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_operasional/controller/absen_controller.dart';
import 'package:siscom_operasional/controller/auth_controller.dart';
import 'package:siscom_operasional/utils/appbar_widget.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';

class FaceRegistrationVerifyPassword extends StatefulWidget {
  const FaceRegistrationVerifyPassword({super.key});

  @override
  State<FaceRegistrationVerifyPassword> createState() =>
      _FaceRegistrationVerifyPasswordState();
}

class _FaceRegistrationVerifyPasswordState
    extends State<FaceRegistrationVerifyPassword> {
  final controller = Get.put(AuthController());
  final TextEditingController passwordCtr = TextEditingController();

  var absensiController = Get.find<AbsenController>(tag: 'absen controller');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              "Konfirmasi Password",
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
      body: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
          child: Column(
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8)),
                    border: Border.all(width: 0.5, color: Constanst.fgBorder)),
                child: Obx(
                  () => TextField(
                    obscureText: !this.controller.showpassword.value,
                    controller: passwordCtr,
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: Constanst.fgPrimary,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIconColor: Constanst.fgSecondary,
                        prefixIcon: const Icon(Iconsax.lock_1),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.showpassword.value
                                ? Iconsax.eye
                                : Iconsax.eye_slash,
                            color: Constanst.fgSecondary,
                          ),
                          onPressed: () {
                            this.controller.showpassword.value =
                                !this.controller.showpassword.value;
                          },
                        )),
                    style: GoogleFonts.inter(
                        color: Constanst.fgPrimary,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    UtilsAlert.showLoadingIndicator(context);
                    Future.delayed(const Duration(milliseconds: 500), () {
                      Get.back();
                      print(controller.password.value.toString());

                      if (passwordCtr.text.toString() ==
                          controller.password.value.text) {
                        UtilsAlert.showToast("Konfirmasi password berhasil");
                        return absensiController
                            .widgetButtomSheetFaceRegistrattion();
                      }
                      return UtilsAlert.showToast("Konfirmasi password gagal");
                    });
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
                    padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                    child: Text(
                      'Selanjutnya',
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
    );
  }
}
