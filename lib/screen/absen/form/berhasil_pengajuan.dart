// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siscom_operasional/controller/global_controller.dart';
import 'package:siscom_operasional/screen/init_screen.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BerhasilPengajuan extends StatefulWidget {
  List dataBerhasil;
  BerhasilPengajuan({Key? key, required this.dataBerhasil}) : super(key: key);
  @override
  _BerhasilPengajuanState createState() => _BerhasilPengajuanState();
}

class _BerhasilPengajuanState extends State<BerhasilPengajuan> {
  var controllerGlobal = Get.put(GlobalController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constanst.coloBackgroundScreen,
      body: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/send.svg',
              width: 240,
              height: 240,
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text(
                "${widget.dataBerhasil[0]}",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Constanst.fgPrimary),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 32, right: 32),
              child: Text(
                "${widget.dataBerhasil[1]}",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Constanst.fgPrimary),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "${widget.dataBerhasil[2]}",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Constanst.fgPrimary),
            ),
          ],
        )),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(right: 16.0, left: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.offAll(InitScreen());
                  },
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Constanst.colorWhite,
                      backgroundColor: Constanst.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                      padding: const EdgeInsets.fromLTRB(0, 12, 0, 12)),
                  child: Text(
                    'Kembali ke beranda',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Constanst.colorWhite),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              widget.dataBerhasil[3] == false
                  ? const SizedBox()
                  : Container(
                      height: 42,
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Constanst.fgBorder,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          controllerGlobal
                              .showDataPilihAtasan(widget.dataBerhasil[3]);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Constanst.onPrimary,
                          backgroundColor: Constanst.colorWhite,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Konfirmasi via Whatsapp2',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Constanst.onPrimary,
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
