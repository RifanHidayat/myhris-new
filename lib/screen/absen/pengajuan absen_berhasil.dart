import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siscom_operasional/utils/constans.dart';

class pengajuanAbsenBerhasil extends StatefulWidget {
  const pengajuanAbsenBerhasil({super.key});

  @override
  State<pengajuanAbsenBerhasil> createState() => _pengajuanAbsenBerhasilState();
}

class _pengajuanAbsenBerhasilState extends State<pengajuanAbsenBerhasil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constanst.coloBackgroundScreen,
      // bottomNavigationBar: SafeArea(
      //   child: Padding(
      //     padding: const EdgeInsets.only(
      //       left: 16.0,
      //       right: 16.0,
      //     ),
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.end,
      //       children: [
      //         SizedBox(
      //           width: double.infinity,
      //           child: ElevatedButton(
      //             onPressed: () {},
      //             style: ElevatedButton.styleFrom(
      //                 foregroundColor: Constanst.colorWhite,
      //                 backgroundColor: Constanst.onPrimary,
      //                 shape: RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.circular(8),
      //                 ),
      //                 elevation: 0,
      //                 padding: const EdgeInsets.fromLTRB(0, 12, 0, 12)),
      //             child: Text(
      //               'Selesai',
      //               style: GoogleFonts.inter(
      //                   fontWeight: FontWeight.w500,
      //                   fontSize: 16,
      //                   color: Constanst.colorWhite),
      //             ),
      //           ),
      //         ),
      //         const SizedBox(height: 8),
      //         Container(
      //           height: 42,
      //           width: double.infinity,
      //           padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      //           margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      //           decoration: BoxDecoration(
      //             border: Border.all(
      //               color: Constanst.fgBorder,
      //               width: 1.0,
      //             ),
      //             borderRadius: BorderRadius.circular(8.0),
      //           ),
      //           child: ElevatedButton(
      //             onPressed: () {},
      //             style: ElevatedButton.styleFrom(
      //               foregroundColor: Constanst.onPrimary,
      //               backgroundColor: Constanst.colorWhite,
      //               shape: RoundedRectangleBorder(
      //                 borderRadius: BorderRadius.circular(8),
      //               ),
      //               elevation: 0,
      //             ),
      //             child: Text(
      //               'Konfirmasi via Whatsapp',
      //               style: GoogleFonts.inter(
      //                 fontWeight: FontWeight.w500,
      //                 fontSize: 16,
      //                 color: Constanst.onPrimary,
      //               ),
      //             ),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 14,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/send.svg',
                    width: 240,
                    height: 240,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Pengajuan Absensi berhasil dibuat',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Constanst.fgPrimary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Selanjutnya silakan menunggu Atasan kamu\nuntuk menyetujui pengajuan yang telah dibuat\natau langsung',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Constanst.fgPrimary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Konfirmasi via Whatsapp',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Constanst.fgPrimary),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          Get.back();
                          Get.back();
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
                          'Selesai',
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Constanst.colorWhite),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
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
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Constanst.onPrimary,
                          backgroundColor: Constanst.colorWhite,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Konfirmasi via Whatsapp',
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
          ],
        ),
      ),
    );
  }
}
