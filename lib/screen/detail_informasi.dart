// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_operasional/screen/init_screen.dart';
import 'package:siscom_operasional/utils/constans.dart';

class DetailInformasi extends StatelessWidget {
  final title;
  final create;
  final desc;
  DetailInformasi({this.title, this.create, this.desc});
  // final controller = Get.put(DashboardController());
  // var controllerGlobal = Get.put(GlobalController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constanst.coloBackgroundScreen,
      appBar: AppBar(
        backgroundColor: Constanst.colorWhite,
        elevation: 0,
        leadingWidth: 50,
        titleSpacing: 0,
        centerTitle: false,
        // title: Text(
        //   "Informasi",
        //   style: GoogleFonts.inter(
        //       color: Constanst.fgPrimary,
        //       fontWeight: FontWeight.w500,
        //       fontSize: 20),
        // ),
        leading: IconButton(
          icon: Icon(
            Iconsax.arrow_left,
            color: Constanst.fgPrimary,
            size: 24,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Constanst.fgPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  Constanst.convertDate(create),
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Constanst.fgSecondary),
                ),
                const SizedBox(height: 14),
                Html(
                  data: desc,
                  style: {
                    "body": Style(
                      fontSize: const FontSize(16),
                      margin: const EdgeInsets.all(0.0),
                      fontWeight: FontWeight.w400,
                      fontFamily: "GoogleFonts.inter",
                      color: Constanst.fgSecondary,
                    ),
                  },
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
