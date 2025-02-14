import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_operasional/controller/absen_controller.dart';
import 'package:siscom_operasional/screen/absen/photo_absent.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';

class DetailAbsen extends StatelessWidget {
  List<dynamic>? absenSelected;
  bool? status;
  String? fullName;
  DetailAbsen({
    Key? key,
    this.absenSelected,
    this.status,
    this.fullName,
  }) : super(key: key);
  final controller = Get.put(AbsenController());
  @override
  Widget build(BuildContext context) {
    var tanggal = status == false
        ? absenSelected![0].atten_date ?? ""
        : absenSelected![0]['atten_date'] ?? "";
    var longlatMasuk = status == false
        ? absenSelected![0].signin_longlat
        : absenSelected![0]['signin_longlat'];
    var longlatKeluar = status == false
        ? absenSelected![0].signout_longlat
        : absenSelected![0]['signout_longlat'];
    var getFullName =
        status == false ? "" : absenSelected![0]['full_name'] ?? "";
    var namaKaryawan = fullName != "" ? fullName : "$getFullName";

    print('apanih ${absenSelected}');

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
              backgroundColor: Constanst.coloBackgroundScreen,
              automaticallyImplyLeading: false,
              elevation: 0,
              title: Text(
                "Detail Riwayat Absensi",
                style: GoogleFonts.inter(
                    color: Constanst.fgPrimary,
                    fontWeight: FontWeight.w500,
                    fontSize: 20),
              ),
              centerTitle: false,
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
          ),
        ),
        body: WillPopScope(
          onWillPop: () async {
            Get.back();
            return true;
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // status == true
                  //     ? Center(
                  //         child: Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: Text(
                  //           "$namaKaryawan",
                  //           style: GoogleFonts.inter(
                  //               fontSize: 16,
                  //               fontWeight: FontWeight.bold,
                  //               color: Constanst.colorPrimary),
                  //         ),
                  //       ))
                  //     : SizedBox(),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Constanst.border)),
                    child: Padding(
                      padding:
                          const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
                      child: Row(
                        children: [
                          Text(
                            Constanst.convertDate6("$tanggal"),
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Constanst.fgPrimary),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // longlatMasuk == "" ? const SizedBox() : 
                  descMasuk(),
                  const SizedBox(height: 16),
                  // longlatKeluar == "" ? const SizedBox() : 
                  descKeluar(),
                  const SizedBox(height: 16),
                  AppData.informasiUser![0].tipeAbsen.toString()=="3"? descKeluarRest():SizedBox(),
                  const SizedBox(height: 16),
                 AppData.informasiUser![0].tipeAbsen.toString()=="3"? descMasukRest():SizedBox(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ));
  }

  // Widget descMasuk() {
  //   var jamMasuk = status == false
  //       ? absenSelected![0].signin_time ?? ""
  //       : absenSelected![0]['signin_time'] ?? "";
  //   var gambarMasuk = status == false
  //       ? absenSelected![0].signin_pict ?? ""
  //       : absenSelected![0]['signin_pict'] ?? "";
  //   var alamatMasuk = status == false
  //       ? absenSelected![0].signin_addr ?? ""
  //       : absenSelected![0]['signin_addr'] ?? "";
  //   var catatanMasuk = status == false
  //       ? absenSelected![0].signin_note ?? ""
  //       : absenSelected![0]['signin_note'] ?? "";
  //   var placeIn = status == false
  //       ? absenSelected![0].place_in ?? ""
  //       : absenSelected![0]['place_in'] ?? "";
  //   return Container(
  //     decoration: Constanst.styleBoxDecoration1,
  //     child: Padding(
  //       padding: EdgeInsets.only(left: 10, right: 10),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           SizedBox(
  //             height: 10,
  //           ),
  //           Row(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Expanded(
  //                 child: Row(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Icon(
  //                       Iconsax.login,
  //                       color: Colors.green,
  //                       size: 24,
  //                     ),
  //                     Padding(
  //                       padding: EdgeInsets.only(left: 8),
  //                       child: Text(
  //                         jamMasuk ?? '',
  //                         style: GoogleFonts.inter(fontSize: 16),
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //               ),
  //               Expanded(
  //                   child: Container(
  //                 decoration: Constanst.styleBoxDecoration2(
  //                     Color.fromARGB(156, 223, 253, 223)),
  //                 margin: EdgeInsets.only(left: 10, right: 10),
  //                 child: Padding(
  //                   padding: EdgeInsets.only(left: 10, right: 10),
  //                   child: Text(
  //                     "Absen Masuk",
  //                     textAlign: TextAlign.center,
  //                     style: Constanst.colorGreenBold,
  //                   ),
  //                 ),
  //               ))
  //             ],
  //           ),
  //           SizedBox(
  //             height: 16,
  //           ),
  //           Padding(
  //             padding: EdgeInsets.only(left: 18),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 gambarMasuk == ''
  //                     ? SizedBox()
  //                     : Row(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Expanded(
  //                               flex: 10,
  //                               child: Icon(
  //                                 Iconsax.gallery,
  //                                 size: 24,
  //                                 color: Constanst.colorPrimary,
  //                               )
  //                               // Image.asset("assets/ic_galery.png")
  //                               ),
  //                           Expanded(
  //                             flex: 90,
  //                             child: Padding(
  //                               padding: const EdgeInsets.only(top: 2, left: 3),
  //                               child: Text(gambarMasuk ?? ''),
  //                             ),
  //                           )
  //                         ],
  //                       ),
  //                 gambarMasuk == ''
  //                     ? SizedBox()
  //                     : Row(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Expanded(flex: 10, child: SizedBox()),
  //                           Expanded(
  //                             flex: 90,
  //                             child: Padding(
  //                               padding: const EdgeInsets.only(top: 3, left: 3),
  //                               child: Row(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: [
  //                                   InkWell(
  //                                     onTap: () {
  //                                       controller.stringImageSelected.value =
  //                                           "";
  //                                       controller.stringImageSelected.value =
  //                                           gambarMasuk ?? '';
  //                                       controller.showDetailImage();
  //                                     },
  //                                     child: Text(
  //                                       "Lihat Foto",
  //                                       style: GoogleFonts.inter(
  //                                         color: Constanst.colorPrimary,
  //                                         decoration: TextDecoration.underline,
  //                                       ),
  //                                     ),
  //                                   ),
  //                                   Padding(
  //                                       padding:
  //                                           EdgeInsets.only(left: 8, top: 3),
  //                                       child: Icon(
  //                                         Iconsax.export_3,
  //                                         size: 16,
  //                                         color: Constanst.color1,
  //                                       )
  //                                       // Image.asset("assets/ic_lihat_foto.png"),
  //                                       )
  //                                 ],
  //                               ),
  //                             ),
  //                           )
  //                         ],
  //                       ),
  //                 SizedBox(
  //                   height: 10,
  //                 ),
  //                 Row(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Expanded(
  //                         flex: 10,
  //                         child: Icon(
  //                           Iconsax.location_tick,
  //                           size: 24,
  //                           color: Constanst.colorPrimary,
  //                         )
  //                         // Image.asset("assets/ic_location_black.png")
  //                         ),
  //                     Expanded(
  //                       flex: 90,
  //                       child: Padding(
  //                           padding: const EdgeInsets.only(top: 3, left: 3),
  //                           child: Text(
  //                             "${alamatMasuk ?? ''}  (${placeIn ?? ''})",
  //                           )),
  //                     )
  //                   ],
  //                 ),
  //                 SizedBox(
  //                   height: 10,
  //                 ),
  //                 Row(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Expanded(
  //                         flex: 10,
  //                         child: Icon(
  //                           Iconsax.note_text,
  //                           size: 24,
  //                           color: Constanst.colorPrimary,
  //                         )
  //                         // Image.asset("assets/ic_note_black.png")
  //                         ),
  //                     Expanded(
  //                       flex: 90,
  //                       child: Padding(
  //                         padding: const EdgeInsets.only(top: 3, left: 3),
  //                         child: Text(catatanMasuk ?? ''),
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //           SizedBox(
  //             height: 18,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget descMasuk() {
    var jamMasuk = status == false
        ? absenSelected![0].signin_time ?? ""
        : absenSelected![0]['signin_time'] ?? "";
    var gambarMasuk = status == false
        ? absenSelected![0].signin_pict ?? ""
        : absenSelected![0]['signin_pict'] ?? "";
    var alamatMasuk = status == false
        ? absenSelected![0].signin_addr ?? ""
        : absenSelected![0]['signin_addr'] ?? "";
    var catatanMasuk = status == false
        ? absenSelected![0].signin_note ?? ""
        : absenSelected![0]['signin_note'] ?? "";
    var placeIn = status == false
        ? absenSelected![0].place_in ?? ""
        : absenSelected![0]['place_in'] ?? "";
    // var alamat = (alamatMasuk + placeIn).toString().substring(0, 50) + "...";
    return Obx(
      () => Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Constanst.border)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Iconsax.login_1,
                        color: Constanst.color5,
                        size: 26,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          jamMasuk ?? '',
                          style: GoogleFonts.inter(
                              color: Constanst.fgPrimary,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                      )
                    ],
                  ),
                  Text(
                    "Absen Masuk",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        color: Constanst.color5,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(
                thickness: 1,
                height: 0,
                color: Constanst.fgBorder,
              ),
              const SizedBox(height: 16),
              //gambarMasuk != ''
              // ? Expanded(
              //     flex: 30,
              //     child: Center(
              //       child: InkWell(
              //         onTap: () {
              //           Get.to(PhotoAbsen(
              //             image: Api.UrlfotoAbsen + gambarMasuk,
              //             type: "masuk",
              //             time: jamMasuk,
              //             alamat: alamatMasuk + placeIn,
              //             note: catatanMasuk,
              //           ));
              //         },
              //         child: gambarMasuk != ''
              //             ? ClipRRect(
              //                 borderRadius: BorderRadius.circular(6.0),
              //                 child: SizedBox(
              //                     width: MediaQuery.of(Get.context!)
              //                             .size
              //                             .width /
              //                         3,
              //                     child: Image.network(
              //                       Api.UrlfotoAbsen + gambarMasuk,
              //                       errorBuilder:
              //                           (context, exception, stackTrace) {
              //                         return ClipRRect(
              //                           child: SizedBox(
              //                               child: Image.asset(
              //                             'assets/Foto.png',
              //                             fit: BoxFit.fill,
              //                           )),
              //                         );
              //                       },
              //                       fit: BoxFit.fill,
              //                     )),
              //               )
              //             : ClipRRect(
              //                 child: SizedBox(
              //                     width: MediaQuery.of(Get.context!)
              //                             .size
              //                             .width /
              //                         3,
              //                     child: Image.asset(
              //                       'assets/Foto.png',
              //                     )),
              //               ),
              //       ),
              //     ),
              //   )
              // : Expanded(
              //     flex: 00,
              //     child: Container(),
              //   ),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //           "Tipe Absen",
              //           style: GoogleFonts.inter(
              //               color: Constanst.fgPrimary,
              //               fontWeight: FontWeight.w500,
              //               fontSize: 16),
              //         ),
              //         SizedBox(
              //           child: Padding(
              //             padding: const EdgeInsets.only(top: 4),
              //             child: Text(
              //               'Foto',
              //               style: GoogleFonts.inter(
              //                   color: Constanst.fgSecondary,
              //                   fontWeight: FontWeight.w400,
              //                   fontSize: 14),
              //             ),
              //           ),
              //         )
              //       ],
              //     ),
              //     InkWell(
              //       onTap: () {
              //         Get.to(PhotoAbsen(
              //           image: Api.UrlfotoAbsen + gambarMasuk,
              //           type: "masuk",
              //           time: jamMasuk,
              //           alamat: alamatMasuk + "({$placeIn})",
              //           note: catatanMasuk,
              //         ));
              //       },
              //       child: Text(
              //         "Lihat Foto",
              //         style: GoogleFonts.inter(
              //             color: Constanst.infoLight,
              //             fontWeight: FontWeight.w400,
              //             fontSize: 14),
              //       ),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 16),
              gambarMasuk != ''
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6.0),
                          child: SizedBox(
                            width: MediaQuery.of(Get.context!).size.width / 3,
                            child: Image.network(
                              Api.UrlfotoAbsen + gambarMasuk,
                              errorBuilder: (context, exception, stackTrace) {
                                return Image.asset(
                                  'assets/Foto.png',
                                  fit: BoxFit.fill,
                                );
                              },
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Lokasi",
                                style: GoogleFonts.inter(
                                  color: Constanst.fgPrimary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "$alamatMasuk ($placeIn)",
                                textAlign: TextAlign.justify,
                                overflow: TextOverflow.ellipsis,
                                maxLines: controller.selengkapnyaMasuk.value
                                    ? 100
                                    : 2,
                                style: GoogleFonts.inter(
                                  color: Constanst.fgSecondary,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: InkWell(
                                  onTap: () =>
                                      controller.selengkapnyaMasuk.value =
                                          !controller.selengkapnyaMasuk.value,
                                  child: Text(
                                    controller.selengkapnyaMasuk.value
                                        ? "Tutup"
                                        : "Selengkapnya",
                                    style: GoogleFonts.inter(
                                      color: Constanst.fgPrimary,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                "Tipe Lokasi",
                                style: GoogleFonts.inter(
                                  color: Constanst.fgPrimary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                " $placeIn",
                                textAlign: TextAlign.justify,
                                overflow: TextOverflow.ellipsis,
                                maxLines: controller.selengkapnyaMasuk.value
                                    ? 100
                                    : 2,
                                style: GoogleFonts.inter(
                                  color: Constanst.fgSecondary,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Catatan",
                                style: GoogleFonts.inter(
                                  color: Constanst.fgPrimary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                catatanMasuk.isEmpty ? '-' : catatanMasuk,
                                style: GoogleFonts.inter(
                                  color: Constanst.fgSecondary,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Lokasi",
                              style: GoogleFonts.inter(
                                  color: Constanst.fgPrimary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                            SizedBox(
                              // width: gambarKeluar != ''
                              //     ? MediaQuery.of(Get.context!).size.width / 2
                              //     : MediaQuery.of(Get.context!).size.width - 80,
                              child: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    "$alamatMasuk ($placeIn)",
                                    textAlign: TextAlign.justify,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: controller.selengkapnyaMasuk.value
                                        ? 100
                                        : 2,
                                    style: GoogleFonts.inter(
                                        color: Constanst.fgSecondary,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: InkWell(
                                onTap: () => controller.selengkapnyaMasuk.value
                                    ? controller.selengkapnyaMasuk.value = false
                                    : controller.selengkapnyaMasuk.value = true,
                                child: Text(
                                  controller.selengkapnyaMasuk.value
                                      ? "Tutup"
                                      : "Selengkapnya",
                                  style: GoogleFonts.inter(
                                      color: Constanst.fgPrimary,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Tipe Lokasi",
                              style: GoogleFonts.inter(
                                  color: Constanst.fgPrimary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                            SizedBox(
                              // width: gambarKeluar != ''
                              //     ? MediaQuery.of(Get.context!).size.width / 2
                              //     : MediaQuery.of(Get.context!).size.width - 80,
                              child: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    " $placeIn",
                                    textAlign: TextAlign.justify,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: controller.selengkapnyaMasuk.value
                                        ? 100
                                        : 2,
                                    style: GoogleFonts.inter(
                                        color: Constanst.fgSecondary,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14),
                                  )),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Catatan",
                              style: GoogleFonts.inter(
                                  color: Constanst.fgPrimary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                            SizedBox(
                              // width: gambarMasuk != ''
                              //     ? MediaQuery.of(Get.context!).size.width / 2
                              //     : MediaQuery.of(Get.context!).size.width - 80,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  catatanMasuk == "" ? '-' : catatanMasuk,
                                  style: GoogleFonts.inter(
                                      color: Constanst.fgSecondary,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget descKeluar() {
    var jamKeluar = status == false
        ? absenSelected![0].signout_time
        : absenSelected![0]['signout_time'];
    var gambarKeluar = status == false
        ? absenSelected![0].signout_pict
        : absenSelected![0]['signout_pict'];
    var alamatKeluar = status == false
        ? absenSelected![0].signout_addr
        : absenSelected![0]['signout_addr'];
    var catatanKeluar = status == false
        ? absenSelected![0].signout_note
        : absenSelected![0]['signout_note'];
    var placeOut = status == false
        ? absenSelected![0].place_out ?? ""
        : absenSelected![0]['place_out'] ?? "";
    // var alamat = (alamatKeluar + placeOut).toString().substring(0, 50) + "...";
    return Obx(
      () => Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Constanst.border)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Iconsax.logout_1,
                        color: Constanst.color4,
                        size: 26,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          jamKeluar ?? '',
                          style: GoogleFonts.inter(
                              color: Constanst.fgPrimary,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                      )
                    ],
                  ),
                  Text(
                    "Absen Keluar",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        color: Constanst.color4,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(
                thickness: 1,
                height: 0,
                color: Constanst.fgBorder,
              ),
              const SizedBox(height: 16),
              // gambarKeluar != ''
              //     ? Expanded(
              //         flex: 30,
              //         child: Center(
              //           child: InkWell(
              //             onTap: () {
              //               Get.to(PhotoAbsen(
              //                 image: Api.UrlfotoAbsen + gambarKeluar,
              //                 type: "keluar",
              //                 time: jamKeluar,
              //                 alamat: alamatKeluar + placeOut,
              //                 note: catatanKeluar,
              //               ));
              //             },
              //             child: gambarKeluar != ''
              //                 ? ClipRRect(
              //                     borderRadius: BorderRadius.circular(6.0),
              //                     child: SizedBox(
              //                         // width: MediaQuery.of(Get.context!).size.width / 3,
              //                         child: Image.network(
              //                       Api.UrlfotoAbsen + gambarKeluar,
              //                       errorBuilder:
              //                           (context, exception, stackTrace) {
              //                         return ClipRRect(
              //                           child: SizedBox(
              //                               child: Image.asset(
              //                             'assets/Foto.png',
              //                             fit: BoxFit.fitHeight,
              //                           )),
              //                         );
              //                       },
              //                       fit: BoxFit.fitHeight,
              //                     )),
              //                   )
              //                 : ClipRRect(
              //                     child: SizedBox(
              //                         // width: MediaQuery.of(Get.context!).size.width / 3,
              //                         child: Image.asset(
              //                       'assets/Foto.png',
              //                     )),
              //                   ),
              //           ),
              //         ),
              //       )
              //     : Expanded(flex: 0, child: Container()),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //           "Tipe Absen",
              //           style: GoogleFonts.inter(
              //               color: Constanst.fgPrimary,
              //               fontWeight: FontWeight.w500,
              //               fontSize: 16),
              //         ),
              //         SizedBox(
              //           child: Padding(
              //             padding: const EdgeInsets.only(top: 4),
              //             child: Text(
              //               'Foto',
              //               style: GoogleFonts.inter(
              //                   color: Constanst.fgSecondary,
              //                   fontWeight: FontWeight.w400,
              //                   fontSize: 14),
              //             ),
              //           ),
              //         )
              //       ],
              //     ),
              //     InkWell(
              //       onTap: () {
              //         Get.to(PhotoAbsen(
              //           image: Api.UrlfotoAbsen + gambarKeluar,
              //           type: "keluar",
              //           time: jamKeluar,
              //           alamat: alamatKeluar + placeOut,
              //           note: catatanKeluar,
              //         ));
              //       },
              //       child: Text(
              //         "Lihat Foto",
              //         style: GoogleFonts.inter(
              //             color: Constanst.infoLight,
              //             fontWeight: FontWeight.w400,
              //             fontSize: 14),
              //       ),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 16),
              gambarKeluar != ''
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6.0),
                          child: SizedBox(
                            width: MediaQuery.of(Get.context!).size.width / 3,
                            child: Image.network(
                              Api.UrlfotoAbsen + gambarKeluar,
                              errorBuilder: (context, exception, stackTrace) {
                                return Image.asset(
                                  'assets/Foto.png',
                                  fit: BoxFit.fill,
                                );
                              },
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Lokasi",
                                style: GoogleFonts.inter(
                                  color: Constanst.fgPrimary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "$alamatKeluar ($placeOut)",
                                textAlign: TextAlign.justify,
                                overflow: TextOverflow.ellipsis,
                                maxLines: controller.selengkapnyaKeluar.value
                                    ? 100
                                    : 2,
                                style: GoogleFonts.inter(
                                  color: Constanst.fgSecondary,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: InkWell(
                                  onTap: () =>
                                      controller.selengkapnyaKeluar.value =
                                          !controller.selengkapnyaKeluar.value,
                                  child: Text(
                                    controller.selengkapnyaKeluar.value
                                        ? "Tutup"
                                        : "Selengkapnya",
                                    style: GoogleFonts.inter(
                                      color: Constanst.fgPrimary,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                "Tipe Lokasi",
                                style: GoogleFonts.inter(
                                  color: Constanst.fgPrimary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                " $placeOut",
                                textAlign: TextAlign.justify,
                                overflow: TextOverflow.ellipsis,
                                maxLines: controller.selengkapnyaKeluar.value
                                    ? 100
                                    : 2,
                                style: GoogleFonts.inter(
                                  color: Constanst.fgSecondary,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Catatan",
                                style: GoogleFonts.inter(
                                  color: Constanst.fgPrimary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                catatanKeluar.isEmpty ? '-' : catatanKeluar,
                                style: GoogleFonts.inter(
                                  color: Constanst.fgSecondary,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Lokasi",
                              style: GoogleFonts.inter(
                                  color: Constanst.fgPrimary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                            SizedBox(
                              // width: gambarKeluar != ''
                              //     ? MediaQuery.of(Get.context!).size.width / 2
                              //     : MediaQuery.of(Get.context!).size.width - 80,
                              child: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    "$alamatKeluar ($placeOut)",
                                    textAlign: TextAlign.justify,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines:
                                        controller.selengkapnyaKeluar.value
                                            ? 100
                                            : 2,
                                    style: GoogleFonts.inter(
                                        color: Constanst.fgSecondary,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: InkWell(
                                onTap: () => controller.selengkapnyaKeluar.value
                                    ? controller.selengkapnyaKeluar.value =
                                        false
                                    : controller.selengkapnyaKeluar.value =
                                        true,
                                child: Text(
                                  controller.selengkapnyaKeluar.value
                                      ? "Tutup"
                                      : "Selengkapnya",
                                  style: GoogleFonts.inter(
                                      color: Constanst.fgPrimary,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Tipe Lokasi",
                              style: GoogleFonts.inter(
                                  color: Constanst.fgPrimary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                            SizedBox(
                              // width: gambarKeluar != ''
                              //     ? MediaQuery.of(Get.context!).size.width / 2
                              //     : MediaQuery.of(Get.context!).size.width - 80,
                              child: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    " $placeOut",
                                    textAlign: TextAlign.justify,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: controller.selengkapnyaMasuk.value
                                        ? 100
                                        : 2,
                                    style: GoogleFonts.inter(
                                        color: Constanst.fgSecondary,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14),
                                  )),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Catatan",
                              style: GoogleFonts.inter(
                                  color: Constanst.fgPrimary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                            SizedBox(
                              // width: gambarKeluar != ''
                              //     ? MediaQuery.of(Get.context!).size.width / 2
                              //     : MediaQuery.of(Get.context!).size.width - 80,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  catatanKeluar == "" ? '-' : catatanKeluar,
                                  style: GoogleFonts.inter(
                                      color: Constanst.fgSecondary,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
    // return Container(
    //   decoration: Constanst.styleBoxDecoration1,
    //   child: Padding(
    //     padding: EdgeInsets.only(left: 10, right: 10),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         SizedBox(
    //           height: 10,
    //         ),
    //         Row(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Expanded(
    //               child: Row(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Icon(
    //                     Iconsax.logout,
    //                     color: Colors.red,
    //                     size: 24,
    //                   ),
    //                   Padding(
    //                     padding: EdgeInsets.only(left: 8),
    //                     child: Text(
    //                       jamKeluar ?? '',
    //                       style: GoogleFonts.inter(fontSize: 16),
    //                     ),
    //                   )
    //                 ],
    //               ),
    //             ),
    //             Expanded(
    //                 child: Container(
    //               decoration: Constanst.styleBoxDecoration2(
    //                   Color.fromARGB(156, 241, 171, 171)),
    //               margin: EdgeInsets.only(left: 10, right: 10),
    //               child: Padding(
    //                 padding: EdgeInsets.only(left: 10, right: 10),
    //                 child: Text(
    //                   "Absen Keluar",
    //                   textAlign: TextAlign.center,
    //                   style: Constanst.colorRedBold,
    //                 ),
    //               ),
    //             ))
    //           ],
    //         ),
    //         SizedBox(
    //           height: 16,
    //         ),
    //         Padding(
    //           padding: EdgeInsets.only(left: 18),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               gambarKeluar == ''
    //                   ? SizedBox()
    //                   : Row(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         Expanded(
    //                             flex: 10,
    //                             child: Icon(
    //                               Iconsax.gallery,
    //                               size: 24,
    //                               color: Constanst.colorPrimary,
    //                             )
    //                             // Image.asset("assets/ic_galery.png")
    //                             ),
    //                         Expanded(
    //                           flex: 90,
    //                           child: Padding(
    //                             padding: const EdgeInsets.only(top: 3, left: 3),
    //                             child: Text(gambarKeluar ?? ''),
    //                           ),
    //                         )
    //                       ],
    //                     ),
    //               gambarKeluar == ''
    //                   ? SizedBox()
    //                   : Row(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         Expanded(flex: 10, child: SizedBox()),
    //                         Expanded(
    //                           flex: 90,
    //                           child: Padding(
    //                             padding: const EdgeInsets.only(top: 3, left: 3),
    //                             child: Row(
    //                               crossAxisAlignment: CrossAxisAlignment.start,
    //                               children: [
    //                                 InkWell(
    //                                   onTap: () {
    //                                     controller.stringImageSelected.value =
    //                                         "";
    //                                     controller.stringImageSelected.value =
    //                                         gambarKeluar ?? '';
    //                                     controller.showDetailImage();
    //                                   },
    //                                   child: Text(
    //                                     "Lihat Foto",
    //                                     style: GoogleFonts.inter(
    //                                       color: Constanst.colorPrimary,
    //                                       decoration: TextDecoration.underline,
    //                                     ),
    //                                   ),
    //                                 ),
    //                                 Padding(
    //                                     padding:
    //                                         EdgeInsets.only(left: 8, top: 3),
    //                                     child: Icon(
    //                                       Iconsax.export_3,
    //                                       size: 16,
    //                                       color: Constanst.color1,
    //                                     )
    //                                     // Image.asset("assets/ic_lihat_foto.png"),
    //                                     )
    //                               ],
    //                             ),
    //                           ),
    //                         )
    //                       ],
    //                     ),
    //               SizedBox(
    //                 height: 10,
    //               ),
    //               Row(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Expanded(
    //                       flex: 10,
    //                       child: Icon(
    //                         Iconsax.location_tick,
    //                         size: 24,
    //                         color: Constanst.colorPrimary,
    //                       )
    //                       // Image.asset("assets/ic_location_black.png")
    //                       ),
    //                   Expanded(
    //                     flex: 90,
    //                     child: Padding(
    //                       padding: const EdgeInsets.only(top: 3, left: 3),
    //                       child: Text(
    //                           "${alamatKeluar ?? ''}  (${placeOut ?? ''})"),
    //                     ),
    //                   )
    //                 ],
    //               ),
    //               SizedBox(
    //                 height: 10,
    //               ),
    //               Row(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Expanded(
    //                       flex: 10,
    //                       child: Icon(
    //                         Iconsax.note_text,
    //                         size: 24,
    //                         color: Constanst.colorPrimary,
    //                       )
    //                       // Image.asset("assets/ic_note_black.png")
    //                       ),
    //                   Expanded(
    //                     flex: 90,
    //                     child: Padding(
    //                       padding: const EdgeInsets.only(top: 3, left: 3),
    //                       child: Text(catatanKeluar ?? ''),
    //                     ),
    //                   )
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),
    //         SizedBox(
    //           height: 18,
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

   Widget descMasukRest() {
    var jamMasuk = status == false
        ? absenSelected![0].breakinTime ?? ""
        : absenSelected![0]['breakin_time'] ?? "";
    var gambarMasuk = status == false
        ? absenSelected![0].breakinPict ?? ""
        : absenSelected![0]['breakin_pict'] ?? "";
    var alamatMasuk = status == false
        ? absenSelected![0].breakinAddr ?? ""
        : absenSelected![0]['breakin_addr'] ?? "";
    var catatanMasuk = status == false
        ? absenSelected![0].breakinNote ?? ""
        : absenSelected![0]['breakin_note'] ?? "";
    var placeIn = status == false
        ? absenSelected![0].breakinPlace ?? ""
        : absenSelected![0]['place_break_in'] ?? "";
    // var alamat = (alamatMasuk + placeIn).toString().substring(0, 50) + "...";
    return Obx(
      () => Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Constanst.border)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Iconsax.login_1,
                        color: Constanst.color5,
                        size: 26,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          jamMasuk ?? '',
                          style: GoogleFonts.inter(
                              color: Constanst.fgPrimary,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                      )
                    ],
                  ),
                  Text(
                    "Istirahat Masuk",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        color: Constanst.color5,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(
                thickness: 1,
                height: 0,
                color: Constanst.fgBorder,
              ),
              const SizedBox(height: 16),
              //gambarMasuk != ''
              // ? Expanded(
              //     flex: 30,
              //     child: Center(
              //       child: InkWell(
              //         onTap: () {
              //           Get.to(PhotoAbsen(
              //             image: Api.UrlfotoAbsen + gambarMasuk,
              //             type: "masuk",
              //             time: jamMasuk,
              //             alamat: alamatMasuk + placeIn,
              //             note: catatanMasuk,
              //           ));
              //         },
              //         child: gambarMasuk != ''
              //             ? ClipRRect(
              //                 borderRadius: BorderRadius.circular(6.0),
              //                 child: SizedBox(
              //                     width: MediaQuery.of(Get.context!)
              //                             .size
              //                             .width /
              //                         3,
              //                     child: Image.network(
              //                       Api.UrlfotoAbsen + gambarMasuk,
              //                       errorBuilder:
              //                           (context, exception, stackTrace) {
              //                         return ClipRRect(
              //                           child: SizedBox(
              //                               child: Image.asset(
              //                             'assets/Foto.png',
              //                             fit: BoxFit.fill,
              //                           )),
              //                         );
              //                       },
              //                       fit: BoxFit.fill,
              //                     )),
              //               )
              //             : ClipRRect(
              //                 child: SizedBox(
              //                     width: MediaQuery.of(Get.context!)
              //                             .size
              //                             .width /
              //                         3,
              //                     child: Image.asset(
              //                       'assets/Foto.png',
              //                     )),
              //               ),
              //       ),
              //     ),
              //   )
              // : Expanded(
              //     flex: 00,
              //     child: Container(),
              //   ),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //           "Tipe Absen",
              //           style: GoogleFonts.inter(
              //               color: Constanst.fgPrimary,
              //               fontWeight: FontWeight.w500,
              //               fontSize: 16),
              //         ),
              //         SizedBox(
              //           child: Padding(
              //             padding: const EdgeInsets.only(top: 4),
              //             child: Text(
              //               'Foto',
              //               style: GoogleFonts.inter(
              //                   color: Constanst.fgSecondary,
              //                   fontWeight: FontWeight.w400,
              //                   fontSize: 14),
              //             ),
              //           ),
              //         )
              //       ],
              //     ),
              //     InkWell(
              //       onTap: () {
              //         Get.to(PhotoAbsen(
              //           image: Api.UrlfotoAbsen + gambarMasuk,
              //           type: "masuk",
              //           time: jamMasuk,
              //           alamat: alamatMasuk + "({$placeIn})",
              //           note: catatanMasuk,
              //         ));
              //       },
              //       child: Text(
              //         "Lihat Foto",
              //         style: GoogleFonts.inter(
              //             color: Constanst.infoLight,
              //             fontWeight: FontWeight.w400,
              //             fontSize: 14),
              //       ),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 16),
              gambarMasuk != ''
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6.0),
                          child: SizedBox(
                            width: MediaQuery.of(Get.context!).size.width / 3,
                            child: Image.network(
                              Api.UrlfotoAbsen + gambarMasuk,
                              errorBuilder: (context, exception, stackTrace) {
                                return Image.asset(
                                  'assets/Foto.png',
                                  fit: BoxFit.fill,
                                );
                              },
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Lokasi",
                                style: GoogleFonts.inter(
                                  color: Constanst.fgPrimary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "$alamatMasuk ($placeIn)",
                                textAlign: TextAlign.justify,
                                overflow: TextOverflow.ellipsis,
                                maxLines: controller.selengkapnyaMasuk.value
                                    ? 100
                                    : 2,
                                style: GoogleFonts.inter(
                                  color: Constanst.fgSecondary,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: InkWell(
                                  onTap: () =>
                                      controller.selengkapnyaMasuk.value =
                                          !controller.selengkapnyaMasuk.value,
                                  child: Text(
                                    controller.selengkapnyaMasuk.value
                                        ? "Tutup"
                                        : "Selengkapnya",
                                    style: GoogleFonts.inter(
                                      color: Constanst.fgPrimary,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                "Tipe Lokasi",
                                style: GoogleFonts.inter(
                                  color: Constanst.fgPrimary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                " $placeIn",
                                textAlign: TextAlign.justify,
                                overflow: TextOverflow.ellipsis,
                                maxLines: controller.selengkapnyaMasuk.value
                                    ? 100
                                    : 2,
                                style: GoogleFonts.inter(
                                  color: Constanst.fgSecondary,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Catatan",
                                style: GoogleFonts.inter(
                                  color: Constanst.fgPrimary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                catatanMasuk.isEmpty ? '-' : catatanMasuk,
                                style: GoogleFonts.inter(
                                  color: Constanst.fgSecondary,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Lokasi",
                              style: GoogleFonts.inter(
                                  color: Constanst.fgPrimary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                            SizedBox(
                              // width: gambarKeluar != ''
                              //     ? MediaQuery.of(Get.context!).size.width / 2
                              //     : MediaQuery.of(Get.context!).size.width - 80,
                              child: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    "$alamatMasuk ($placeIn)",
                                    textAlign: TextAlign.justify,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: controller.selengkapnyaMasuk.value
                                        ? 100
                                        : 2,
                                    style: GoogleFonts.inter(
                                        color: Constanst.fgSecondary,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: InkWell(
                                onTap: () => controller.selengkapnyaMasuk.value
                                    ? controller.selengkapnyaMasuk.value = false
                                    : controller.selengkapnyaMasuk.value = true,
                                child: Text(
                                  controller.selengkapnyaMasuk.value
                                      ? "Tutup"
                                      : "Selengkapnya",
                                  style: GoogleFonts.inter(
                                      color: Constanst.fgPrimary,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Tipe Lokasi",
                              style: GoogleFonts.inter(
                                  color: Constanst.fgPrimary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                            SizedBox(
                              // width: gambarKeluar != ''
                              //     ? MediaQuery.of(Get.context!).size.width / 2
                              //     : MediaQuery.of(Get.context!).size.width - 80,
                              child: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    " $placeIn",
                                    textAlign: TextAlign.justify,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: controller.selengkapnyaMasuk.value
                                        ? 100
                                        : 2,
                                    style: GoogleFonts.inter(
                                        color: Constanst.fgSecondary,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14),
                                  )),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Catatan",
                              style: GoogleFonts.inter(
                                  color: Constanst.fgPrimary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                            SizedBox(
                              // width: gambarMasuk != ''
                              //     ? MediaQuery.of(Get.context!).size.width / 2
                              //     : MediaQuery.of(Get.context!).size.width - 80,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  catatanMasuk == "" ? '-' : catatanMasuk,
                                  style: GoogleFonts.inter(
                                      color: Constanst.fgSecondary,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget descKeluarRest() {
    var jamKeluar = status == false
        ? absenSelected![0].breakoutTime ?? ''
        : absenSelected![0]['breakout_time'];
    var gambarKeluar = status == false
        ? absenSelected![0].breakoutPict ?? ''
        : absenSelected![0]['breakout_pict'];
    var alamatKeluar = status == false
        ? absenSelected![0].breakoutAddr ?? ''
        : absenSelected![0]['breakout_addr'];
    var catatanKeluar = status == false
        ? absenSelected![0].breakoutNote ?? ''
        : absenSelected![0]['breakout_note'];
    var placeOut = status == false
        ? absenSelected![0].breakoutPlace ?? ""
        : absenSelected![0]['place_break_out'] ?? "";
    // var alamat = (alamatKeluar + placeOut).toString().substring(0, 50) + "...";
    return Obx(
      () => Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Constanst.border)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Iconsax.logout_1,
                        color: Constanst.color4,
                        size: 26,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          jamKeluar ?? '',
                          style: GoogleFonts.inter(
                              color: Constanst.fgPrimary,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                      )
                    ],
                  ),
                  Text(
                    "Istirahat Keluar",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        color: Constanst.color4,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(
                thickness: 1,
                height: 0,
                color: Constanst.fgBorder,
              ),
              const SizedBox(height: 16),
              // gambarKeluar != ''
              //     ? Expanded(
              //         flex: 30,
              //         child: Center(
              //           child: InkWell(
              //             onTap: () {
              //               Get.to(PhotoAbsen(
              //                 image: Api.UrlfotoAbsen + gambarKeluar,
              //                 type: "keluar",
              //                 time: jamKeluar,
              //                 alamat: alamatKeluar + placeOut,
              //                 note: catatanKeluar,
              //               ));
              //             },
              //             child: gambarKeluar != ''
              //                 ? ClipRRect(
              //                     borderRadius: BorderRadius.circular(6.0),
              //                     child: SizedBox(
              //                         // width: MediaQuery.of(Get.context!).size.width / 3,
              //                         child: Image.network(
              //                       Api.UrlfotoAbsen + gambarKeluar,
              //                       errorBuilder:
              //                           (context, exception, stackTrace) {
              //                         return ClipRRect(
              //                           child: SizedBox(
              //                               child: Image.asset(
              //                             'assets/Foto.png',
              //                             fit: BoxFit.fitHeight,
              //                           )),
              //                         );
              //                       },
              //                       fit: BoxFit.fitHeight,
              //                     )),
              //                   )
              //                 : ClipRRect(
              //                     child: SizedBox(
              //                         // width: MediaQuery.of(Get.context!).size.width / 3,
              //                         child: Image.asset(
              //                       'assets/Foto.png',
              //                     )),
              //                   ),
              //           ),
              //         ),
              //       )
              //     : Expanded(flex: 0, child: Container()),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //           "Tipe Absen",
              //           style: GoogleFonts.inter(
              //               color: Constanst.fgPrimary,
              //               fontWeight: FontWeight.w500,
              //               fontSize: 16),
              //         ),
              //         SizedBox(
              //           child: Padding(
              //             padding: const EdgeInsets.only(top: 4),
              //             child: Text(
              //               'Foto',
              //               style: GoogleFonts.inter(
              //                   color: Constanst.fgSecondary,
              //                   fontWeight: FontWeight.w400,
              //                   fontSize: 14),
              //             ),
              //           ),
              //         )
              //       ],
              //     ),
              //     InkWell(
              //       onTap: () {
              //         Get.to(PhotoAbsen(
              //           image: Api.UrlfotoAbsen + gambarKeluar,
              //           type: "keluar",
              //           time: jamKeluar,
              //           alamat: alamatKeluar + placeOut,
              //           note: catatanKeluar,
              //         ));
              //       },
              //       child: Text(
              //         "Lihat Foto",
              //         style: GoogleFonts.inter(
              //             color: Constanst.infoLight,
              //             fontWeight: FontWeight.w400,
              //             fontSize: 14),
              //       ),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 16),
              gambarKeluar != ''
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6.0),
                          child: SizedBox(
                            width: MediaQuery.of(Get.context!).size.width / 3,
                            child: Image.network(
                              Api.UrlfotoAbsen + gambarKeluar,
                              errorBuilder: (context, exception, stackTrace) {
                                return Image.asset(
                                  'assets/Foto.png',
                                  fit: BoxFit.fill,
                                );
                              },
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Lokasi",
                                style: GoogleFonts.inter(
                                  color: Constanst.fgPrimary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "$alamatKeluar ($placeOut)",
                                textAlign: TextAlign.justify,
                                overflow: TextOverflow.ellipsis,
                                maxLines: controller.selengkapnyaKeluar.value
                                    ? 100
                                    : 2,
                                style: GoogleFonts.inter(
                                  color: Constanst.fgSecondary,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: InkWell(
                                  onTap: () =>
                                      controller.selengkapnyaKeluar.value =
                                          !controller.selengkapnyaKeluar.value,
                                  child: Text(
                                    controller.selengkapnyaKeluar.value
                                        ? "Tutup"
                                        : "Selengkapnya",
                                    style: GoogleFonts.inter(
                                      color: Constanst.fgPrimary,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                "Tipe Lokasi",
                                style: GoogleFonts.inter(
                                  color: Constanst.fgPrimary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                " $placeOut",
                                textAlign: TextAlign.justify,
                                overflow: TextOverflow.ellipsis,
                                maxLines: controller.selengkapnyaKeluar.value
                                    ? 100
                                    : 2,
                                style: GoogleFonts.inter(
                                  color: Constanst.fgSecondary,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Catatan",
                                style: GoogleFonts.inter(
                                  color: Constanst.fgPrimary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                catatanKeluar.isEmpty ? '-' : catatanKeluar,
                                style: GoogleFonts.inter(
                                  color: Constanst.fgSecondary,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Lokasi",
                              style: GoogleFonts.inter(
                                  color: Constanst.fgPrimary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                            SizedBox(
                              // width: gambarKeluar != ''
                              //     ? MediaQuery.of(Get.context!).size.width / 2
                              //     : MediaQuery.of(Get.context!).size.width - 80,
                              child: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    "$alamatKeluar ($placeOut)",
                                    textAlign: TextAlign.justify,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines:
                                        controller.selengkapnyaKeluar.value
                                            ? 100
                                            : 2,
                                    style: GoogleFonts.inter(
                                        color: Constanst.fgSecondary,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: InkWell(
                                onTap: () => controller.selengkapnyaKeluar.value
                                    ? controller.selengkapnyaKeluar.value =
                                        false
                                    : controller.selengkapnyaKeluar.value =
                                        true,
                                child: Text(
                                  controller.selengkapnyaKeluar.value
                                      ? "Tutup"
                                      : "Selengkapnya",
                                  style: GoogleFonts.inter(
                                      color: Constanst.fgPrimary,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Tipe Lokasi",
                              style: GoogleFonts.inter(
                                  color: Constanst.fgPrimary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                            SizedBox(
                              // width: gambarKeluar != ''
                              //     ? MediaQuery.of(Get.context!).size.width / 2
                              //     : MediaQuery.of(Get.context!).size.width - 80,
                              child: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    " $placeOut",
                                    textAlign: TextAlign.justify,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: controller.selengkapnyaMasuk.value
                                        ? 100
                                        : 2,
                                    style: GoogleFonts.inter(
                                        color: Constanst.fgSecondary,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14),
                                  )),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Catatan",
                              style: GoogleFonts.inter(
                                  color: Constanst.fgPrimary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                            SizedBox(
                              // width: gambarKeluar != ''
                              //     ? MediaQuery.of(Get.context!).size.width / 2
                              //     : MediaQuery.of(Get.context!).size.width - 80,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  catatanKeluar == "" ? '-' : catatanKeluar,
                                  style: GoogleFonts.inter(
                                      color: Constanst.fgSecondary,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
    // return Container(
    //   decoration: Constanst.styleBoxDecoration1,
    //   child: Padding(
    //     padding: EdgeInsets.only(left: 10, right: 10),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         SizedBox(
    //           height: 10,
    //         ),
    //         Row(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Expanded(
    //               child: Row(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Icon(
    //                     Iconsax.logout,
    //                     color: Colors.red,
    //                     size: 24,
    //                   ),
    //                   Padding(
    //                     padding: EdgeInsets.only(left: 8),
    //                     child: Text(
    //                       jamKeluar ?? '',
    //                       style: GoogleFonts.inter(fontSize: 16),
    //                     ),
    //                   )
    //                 ],
    //               ),
    //             ),
    //             Expanded(
    //                 child: Container(
    //               decoration: Constanst.styleBoxDecoration2(
    //                   Color.fromARGB(156, 241, 171, 171)),
    //               margin: EdgeInsets.only(left: 10, right: 10),
    //               child: Padding(
    //                 padding: EdgeInsets.only(left: 10, right: 10),
    //                 child: Text(
    //                   "Absen Keluar",
    //                   textAlign: TextAlign.center,
    //                   style: Constanst.colorRedBold,
    //                 ),
    //               ),
    //             ))
    //           ],
    //         ),
    //         SizedBox(
    //           height: 16,
    //         ),
    //         Padding(
    //           padding: EdgeInsets.only(left: 18),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               gambarKeluar == ''
    //                   ? SizedBox()
    //                   : Row(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         Expanded(
    //                             flex: 10,
    //                             child: Icon(
    //                               Iconsax.gallery,
    //                               size: 24,
    //                               color: Constanst.colorPrimary,
    //                             )
    //                             // Image.asset("assets/ic_galery.png")
    //                             ),
    //                         Expanded(
    //                           flex: 90,
    //                           child: Padding(
    //                             padding: const EdgeInsets.only(top: 3, left: 3),
    //                             child: Text(gambarKeluar ?? ''),
    //                           ),
    //                         )
    //                       ],
    //                     ),
    //               gambarKeluar == ''
    //                   ? SizedBox()
    //                   : Row(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         Expanded(flex: 10, child: SizedBox()),
    //                         Expanded(
    //                           flex: 90,
    //                           child: Padding(
    //                             padding: const EdgeInsets.only(top: 3, left: 3),
    //                             child: Row(
    //                               crossAxisAlignment: CrossAxisAlignment.start,
    //                               children: [
    //                                 InkWell(
    //                                   onTap: () {
    //                                     controller.stringImageSelected.value =
    //                                         "";
    //                                     controller.stringImageSelected.value =
    //                                         gambarKeluar ?? '';
    //                                     controller.showDetailImage();
    //                                   },
    //                                   child: Text(
    //                                     "Lihat Foto",
    //                                     style: GoogleFonts.inter(
    //                                       color: Constanst.colorPrimary,
    //                                       decoration: TextDecoration.underline,
    //                                     ),
    //                                   ),
    //                                 ),
    //                                 Padding(
    //                                     padding:
    //                                         EdgeInsets.only(left: 8, top: 3),
    //                                     child: Icon(
    //                                       Iconsax.export_3,
    //                                       size: 16,
    //                                       color: Constanst.color1,
    //                                     )
    //                                     // Image.asset("assets/ic_lihat_foto.png"),
    //                                     )
    //                               ],
    //                             ),
    //                           ),
    //                         )
    //                       ],
    //                     ),
    //               SizedBox(
    //                 height: 10,
    //               ),
    //               Row(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Expanded(
    //                       flex: 10,
    //                       child: Icon(
    //                         Iconsax.location_tick,
    //                         size: 24,
    //                         color: Constanst.colorPrimary,
    //                       )
    //                       // Image.asset("assets/ic_location_black.png")
    //                       ),
    //                   Expanded(
    //                     flex: 90,
    //                     child: Padding(
    //                       padding: const EdgeInsets.only(top: 3, left: 3),
    //                       child: Text(
    //                           "${alamatKeluar ?? ''}  (${placeOut ?? ''})"),
    //                     ),
    //                   )
    //                 ],
    //               ),
    //               SizedBox(
    //                 height: 10,
    //               ),
    //               Row(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Expanded(
    //                       flex: 10,
    //                       child: Icon(
    //                         Iconsax.note_text,
    //                         size: 24,
    //                         color: Constanst.colorPrimary,
    //                       )
    //                       // Image.asset("assets/ic_note_black.png")
    //                       ),
    //                   Expanded(
    //                     flex: 90,
    //                     child: Padding(
    //                       padding: const EdgeInsets.only(top: 3, left: 3),
    //                       child: Text(catatanKeluar ?? ''),
    //                     ),
    //                   )
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),
    //         SizedBox(
    //           height: 18,
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

}
