import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/laporan_absen_karyawan_controller.dart';
import 'package:siscom_operasional/model/absen_model.dart';
import 'package:siscom_operasional/screen/absen/detail_absen.dart';
import 'package:siscom_operasional/utils/appbar_widget.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';

class LaporanAbsenKaryawan extends StatefulWidget {
  String? em_id, bulan, full_name;
  LaporanAbsenKaryawan({Key? key, this.em_id, this.bulan, this.full_name})
      : super(key: key);
  @override
  _LaporanAbsenKaryawanState createState() => _LaporanAbsenKaryawanState();
}

class _LaporanAbsenKaryawanState extends State<LaporanAbsenKaryawan> {
  var controller = Get.put(LaporanAbsenKaryawanController());

  @override
  void initState() {
    controller.loadData(widget.em_id, widget.bulan, widget.full_name);
    super.initState();
  }

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
              // leadingWidth: controller.statusFormPencarian.value ? 50 : 16,
              titleSpacing: 0,
              centerTitle: true,
              title: Text(
                "Laporan Absensi Karyawan",
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
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => Row(
                      children: [
                        InkWell(
                          customBorder: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                          onTap: () async {
                            await showMenu(
                              context: context,
                              position:
                                  const RelativeRect.fromLTRB(17, 150, 17, 0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              // initialValue: controller.selectedTypeLembur.value,
                              items: [
                                PopupMenuItem(
                                    value: "0",
                                    onTap: () {
                                      controller.tempNamaStatus1.value =
                                          "Semua Riwayat";
                                      controller.filterData('0');
                                    },
                                    child: Text(
                                      "Semua Riwayat",
                                      style: GoogleFonts.inter(
                                          fontSize: 16.0,
                                          color: Constanst.fgPrimary,
                                          fontWeight: FontWeight.w500),
                                    )),
                                PopupMenuItem(
                                    value: "1",
                                    onTap: () {
                                      controller.tempNamaStatus1.value =
                                          "Terlambat absen masuk";
                                      controller.filterData('1');
                                    },
                                    child: Text(
                                      "Terlambat absen masuk",
                                      style: GoogleFonts.inter(
                                          fontSize: 16.0,
                                          color: Constanst.fgPrimary,
                                          fontWeight: FontWeight.w500),
                                    )),
                                PopupMenuItem(
                                    value: "2",
                                    onTap: () {
                                      controller.tempNamaStatus1.value =
                                          "Pulang lebih lama";
                                      controller.filterData('2');
                                    },
                                    child: Text(
                                      "Pulang lebih lama",
                                      style: GoogleFonts.inter(
                                          fontSize: 16.0,
                                          color: Constanst.fgPrimary,
                                          fontWeight: FontWeight.w500),
                                    )),
                                PopupMenuItem(
                                    value: "3",
                                    onTap: () {
                                      controller.tempNamaStatus1.value =
                                          "Tidak absen keluar";
                                      controller.filterData('3');
                                    },
                                    child: Text(
                                      "Tidak absen keluar",
                                      style: GoogleFonts.inter(
                                          fontSize: 16.0,
                                          color: Constanst.fgPrimary,
                                          fontWeight: FontWeight.w500),
                                    ))
                              ],
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(color: Constanst.border)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0,
                                  bottom: 8.0,
                                  left: 12.0,
                                  right: 12.0),
                              child: Row(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.tempNamaStatus1.value,
                                        style: GoogleFonts.inter(
                                            color: Constanst.fgSecondary,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 4),
                                        child: Icon(
                                          Iconsax.arrow_down_1,
                                          color: Constanst.fgSecondary,
                                          size: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 57,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Riwayat Karyawan",
                              style: GoogleFonts.inter(
                                  fontSize: 14.0,
                                  color: Constanst.fgSecondary,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${widget.full_name}",
                              style: GoogleFonts.inter(
                                  fontSize: 16.0,
                                  color: Constanst.fgPrimary,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                      // Expanded(
                      //   flex: 30,
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //         borderRadius: Constanst.borderStyle5,
                      //         border: Border.all(color: Constanst.colorText2)),
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: Row(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           Icon(Iconsax.calendar_1),
                      //           Padding(
                      //             padding: EdgeInsets.only(left: 3, top: 3),
                      //             child: Text("${widget.bulan}"),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => Flexible(
                        child: controller.prosesLoad.value
                            ? Center(
                                child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Constanst.colorPrimary,
                              ))
                            : controller.historyAbsen.isEmpty
                                ? Center(child: Text(controller.loading.value))
                                : listAbsen()),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  // Widget listAbsen() {
  //   return ListView.builder(
  //       physics: const BouncingScrollPhysics(),
  //       itemCount: controller.detailRiwayat.value.length,
  //       itemBuilder: (context, index) {
  //         var idAbsen = controller.detailRiwayat.value[index].id;
  //         var jamMasuk = controller.detailRiwayat.value[index].signin_time;
  //         var jamKeluar = controller.detailRiwayat.value[index].signout_time;
  //         var tanggal = controller.detailRiwayat.value[index].atten_date;
  //         var date = controller.detailRiwayat.value[index].date;
  //         var longLatAbsenKeluar =
  //             controller.detailRiwayat.value[index].signout_longlat;

  //         var placeIn = controller.detailRiwayat.value[index].place_in;
  //         var placeOut = controller.detailRiwayat.value[index].place_out;
  //         var note = controller.detailRiwayat.value[index].signin_note;
  //         var signInLongLat =
  //             controller.detailRiwayat.value[index].signin_longlat;
  //         var signOutLongLat =
  //             controller.detailRiwayat.value[index].signout_longlat;
  //         var statusView = placeIn == "pengajuan" &&
  //                 placeOut == "pengajuan" &&
  //                 signInLongLat == "pengajuan" &&
  //                 signOutLongLat == "pengajuan"
  //             ? true
  //             : false;

  //         var regType = controller.detailRiwayat.value[index].reqType ?? 0;
  //         var namaHariLibur =
  //             controller.detailRiwayat.value[index].namaHariLibur;
  //         var namaTugasLuar =
  //             controller.detailRiwayat.value[index].namaTugasLuar;
  //         var namaDinasLuar =
  //             controller.detailRiwayat.value[index].namaDinasLuar;
  //         var namaCuti = controller.detailRiwayat.value[index].namaCuti;
  //         var namaIzin = controller.detailRiwayat.value[index].namaIzin;
  //         var offDay = controller.detailRiwayat.value[index].offDay ?? 1;
  //         var namaSakit = controller.detailRiwayat.value[index].namaSakit;

  //         // var batasJam = "08:30:00";
  //         // var waktuMasuk = "$tanggal $jamMasuk";
  //         // var batasWaktu = "$tanggal $batasJam";
  //         // var listJamMasuk = (jamMasuk!.split(':'));
  //         // var listJamKeluar = (jamKeluar!.split(':'));
  //         // var perhitunganJamMasuk1 =
  //         //     830 - int.parse("${listJamMasuk[0]}${listJamMasuk[1]}");
  //         // var perhitunganJamMasuk2 =
  //         //     1800 - int.parse("${listJamKeluar[0]}${listJamKeluar[1]}");

  //         // var getColorMasuk;
  //         // var getColorKeluar;

  //         // if (perhitunganJamMasuk1 < 0) {
  //         //   getColorMasuk = Colors.red;
  //         // } else {
  //         //   getColorMasuk = Colors.black;
  //         // }
  //         // if (perhitunganJamMasuk2 == 0) {
  //         //   getColorKeluar = Colors.black;
  //         // } else if (perhitunganJamMasuk2 > 0) {
  //         //   getColorKeluar = Colors.red;
  //         // } else if (perhitunganJamMasuk2 < 0) {
  //         //   getColorKeluar = Constanst.colorPrimary;
  //         // }
  //         return Padding(
  //           padding: const EdgeInsets.only(bottom: 8.0),
  //           child: InkWell(
  //             customBorder: const RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.all(Radius.circular(12))),
  //             onTap: () {
  //               if (statusView == false) {
  //                 print(idAbsen);
  //                 controller.historySelected(idAbsen, "laporan");
  //               }
  //             },
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 statusView == false
  //                     ? Container(
  //                         decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.circular(12),
  //                             border: Border.all(
  //                                 width: 1, color: Constanst.fgBorder)),
  //                         child: Row(
  //                           crossAxisAlignment: CrossAxisAlignment.center,
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           children: [
  //                             Expanded(
  //                               flex: 15,
  //                               child: Padding(
  //                                 padding: const EdgeInsets.all(4.0),
  //                                 child: Container(
  //                                   height: controller.detailRiwayat[index]
  //                                               .turunan!.isNotEmpty &&
  //                                           controller.detailRiwayat[index]
  //                                                   .statusView ==
  //                                               true
  //                                       ? int.parse(controller
  //                                                   .detailRiwayat[index]
  //                                                   .turunan!
  //                                                   .length
  //                                                   .toString()) *
  //                                               55 +
  //                                           28
  //                                       : 50,
  //                                   decoration: BoxDecoration(
  //                                     color: Constanst.colorNeutralBgSecondary,
  //                                     borderRadius: const BorderRadius.only(
  //                                       topLeft: Radius.circular(8.0),
  //                                       bottomLeft: Radius.circular(8.0),
  //                                     ),
  //                                   ),
  //                                   child: Padding(
  //                                     padding: const EdgeInsets.only(
  //                                         top: 5.0, bottom: 5.0),
  //                                     child: namaHariLibur == null ||
  //                                             namaHariLibur == ""
  //                                         ? Column(
  //                                             crossAxisAlignment:
  //                                                 CrossAxisAlignment.center,
  //                                             mainAxisAlignment:
  //                                                 MainAxisAlignment.center,
  //                                             children: [
  //                                               Text(
  //                                                   DateFormat('d').format(
  //                                                       DateFormat('yyyy-MM-dd')
  //                                                           .parse(date)),
  //                                                   style: GoogleFonts.inter(
  //                                                     fontSize: 20,
  //                                                     fontWeight:
  //                                                         FontWeight.w500,
  //                                                     color:
  //                                                         Constanst.fgPrimary,
  //                                                   )),
  //                                               Text(
  //                                                   DateFormat('EEEE', 'id')
  //                                                       .format(DateFormat(
  //                                                               'yyyy-MM-dd')
  //                                                           .parse(date)),
  //                                                   style: GoogleFonts.inter(
  //                                                     fontSize: 10,
  //                                                     fontWeight:
  //                                                         FontWeight.w400,
  //                                                     color:
  //                                                         Constanst.fgPrimary,
  //                                                   )),
  //                                             ],
  //                                           )
  //                                         : Column(
  //                                             children: [
  //                                               Text(
  //                                                   DateFormat('d').format(
  //                                                       DateFormat('yyyy-MM-dd')
  //                                                           .parse(date)),
  //                                                   style: GoogleFonts.inter(
  //                                                     fontSize: 20,
  //                                                     fontWeight:
  //                                                         FontWeight.w500,
  //                                                     color: Colors.red,
  //                                                   )),
  //                                               Text(
  //                                                   DateFormat('EEEE', 'id')
  //                                                       .format(DateFormat(
  //                                                               'yyyy-MM-dd')
  //                                                           .parse(date)),
  //                                                   style: GoogleFonts.inter(
  //                                                     fontSize: 10,
  //                                                     fontWeight:
  //                                                         FontWeight.w400,
  //                                                     color: Colors.red,
  //                                                   )),
  //                                             ],
  //                                           ),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                             Expanded(
  //                               flex: 85,
  //                               child: tanggal == "" || tanggal == null
  //                                   ?
  //                                   //tidak ada absen
  //                                   namaHariLibur != null
  //                                       ? Padding(
  //                                           padding:
  //                                               const EdgeInsets.only(left: 18),
  //                                           child: TextLabell(
  //                                             text: namaHariLibur,
  //                                             size: 14.0,
  //                                             weight: FontWeight.w500,
  //                                           ))
  //                                       : namaTugasLuar != null
  //                                           ? const Padding(
  //                                               padding:
  //                                                   EdgeInsets.only(left: 18),
  //                                               child: TextLabell(
  //                                                 text: "Tugas Luar",
  //                                                 size: 14.0,
  //                                                 weight: FontWeight.w500,
  //                                               ))
  //                                           : namaDinasLuar != null
  //                                               ? const Padding(
  //                                                   padding: EdgeInsets.only(
  //                                                       left: 18),
  //                                                   child: TextLabell(
  //                                                     text: "Dinas Luar",
  //                                                     size: 14.0,
  //                                                     weight: FontWeight.w500,
  //                                                   ))
  //                                               : namaCuti != null
  //                                                   ? const Padding(
  //                                                       padding: EdgeInsets.only(
  //                                                           left: 18),
  //                                                       child: TextLabell(
  //                                                         text: "Cuti",
  //                                                         size: 14.0,
  //                                                         weight:
  //                                                             FontWeight.w500,
  //                                                       ))
  //                                                   : namaSakit != null
  //                                                       ? Padding(
  //                                                           padding:
  //                                                               const EdgeInsets
  //                                                                   .only(
  //                                                                   left: 18),
  //                                                           child: TextLabell(
  //                                                             text:
  //                                                                 "Sakit : ${namaSakit}",
  //                                                             size: 14.0,
  //                                                             weight: FontWeight
  //                                                                 .w500,
  //                                                           ))
  //                                                       : namaIzin != null
  //                                                           ? Padding(
  //                                                               padding:
  //                                                                   const EdgeInsets
  //                                                                       .only(
  //                                                                       left:
  //                                                                           18),
  //                                                               child:
  //                                                                   TextLabell(
  //                                                                 text:
  //                                                                     "Izin : ${namaIzin}",
  //                                                                 size: 14.0,
  //                                                                 weight:
  //                                                                     FontWeight
  //                                                                         .w500,
  //                                                               ))
  //                                                           : offDay.toString() ==
  //                                                                   '0'
  //                                                               ? const Padding(
  //                                                                   padding: EdgeInsets.only(
  //                                                                       left:
  //                                                                           18),
  //                                                                   child:
  //                                                                       TextLabell(
  //                                                                     text:
  //                                                                         "Hari Libur Kerja",
  //                                                                     size:
  //                                                                         14.0,
  //                                                                     weight: FontWeight
  //                                                                         .w500,
  //                                                                   ))
  //                                                               : const Padding(
  //                                                                   padding: EdgeInsets.only(
  //                                                                       left:
  //                                                                           18),
  //                                                                   child: TextLabell(
  //                                                                     text:
  //                                                                         "ALPHA / Belum Absen",
  //                                                                     weight: FontWeight
  //                                                                         .w500,
  //                                                                   ))
  //                                   :

  //                                   //     ada asen
  //                                   Column(
  //                                       children: [
  //                                         tanggal == "" || tanggal == null
  //                                             ?
  //                                             //tidak ada absen
  //                                             namaHariLibur != null
  //                                                 ? Padding(
  //                                                     padding:
  //                                                         const EdgeInsets.only(
  //                                                             top: 12),
  //                                                     child: Row(
  //                                                       children: [
  //                                                         Icon(
  //                                                           Iconsax.info_circle,
  //                                                           size: 15,
  //                                                           color: Constanst
  //                                                               .infoLight,
  //                                                         ),
  //                                                         const SizedBox(
  //                                                           width: 10,
  //                                                         ),
  //                                                         TextLabell(
  //                                                           text: namaHariLibur,
  //                                                           weight:
  //                                                               FontWeight.w400,
  //                                                           size: 11.0,
  //                                                         ),
  //                                                       ],
  //                                                     ))
  //                                                 : namaTugasLuar != null
  //                                                     ? Padding(
  //                                                         padding: const EdgeInsets
  //                                                             .only(top: 12),
  //                                                         child: Row(
  //                                                           children: [
  //                                                             Icon(
  //                                                               Iconsax
  //                                                                   .info_circle,
  //                                                               size: 15,
  //                                                               color: Constanst
  //                                                                   .infoLight,
  //                                                             ),
  //                                                             const SizedBox(
  //                                                               width: 10,
  //                                                             ),
  //                                                             TextLabell(
  //                                                               text:
  //                                                                   namaTugasLuar,
  //                                                               weight:
  //                                                                   FontWeight
  //                                                                       .w400,
  //                                                               size: 11.0,
  //                                                             ),
  //                                                           ],
  //                                                         ))
  //                                                     : namaDinasLuar != null
  //                                                         ? Padding(
  //                                                             padding:
  //                                                                 const EdgeInsets
  //                                                                     .only(
  //                                                                     top: 12),
  //                                                             child: Row(
  //                                                               children: [
  //                                                                 Icon(
  //                                                                   Iconsax
  //                                                                       .info_circle,
  //                                                                   size: 15,
  //                                                                   color: Constanst
  //                                                                       .infoLight,
  //                                                                 ),
  //                                                                 const SizedBox(
  //                                                                   width: 10,
  //                                                                 ),
  //                                                                 TextLabell(
  //                                                                   text:
  //                                                                       namaDinasLuar,
  //                                                                   weight:
  //                                                                       FontWeight
  //                                                                           .w400,
  //                                                                   size: 11.0,
  //                                                                 ),
  //                                                               ],
  //                                                             ))
  //                                                         : namaCuti != null
  //                                                             ? Padding(
  //                                                                 padding:
  //                                                                     const EdgeInsets
  //                                                                         .only(
  //                                                                         top:
  //                                                                             12),
  //                                                                 child: Row(
  //                                                                   children: [
  //                                                                     Icon(
  //                                                                       Iconsax
  //                                                                           .info_circle,
  //                                                                       size:
  //                                                                           15,
  //                                                                       color: Constanst
  //                                                                           .infoLight,
  //                                                                     ),
  //                                                                     const SizedBox(
  //                                                                       width:
  //                                                                           10,
  //                                                                     ),
  //                                                                     TextLabell(
  //                                                                       text:
  //                                                                           namaCuti,
  //                                                                       weight:
  //                                                                           FontWeight.w400,
  //                                                                       size:
  //                                                                           11.0,
  //                                                                     ),
  //                                                                   ],
  //                                                                 ))
  //                                                             : namaSakit !=
  //                                                                     null
  //                                                                 ? Padding(
  //                                                                     padding: const EdgeInsets
  //                                                                         .only(
  //                                                                         top:
  //                                                                             12),
  //                                                                     child:
  //                                                                         Row(
  //                                                                       children: [
  //                                                                         Icon(
  //                                                                           Iconsax.info_circle,
  //                                                                           size:
  //                                                                               15,
  //                                                                           color:
  //                                                                               Constanst.infoLight,
  //                                                                         ),
  //                                                                         const SizedBox(
  //                                                                           width:
  //                                                                               10,
  //                                                                         ),
  //                                                                         TextLabell(
  //                                                                           text:
  //                                                                               namaSakit,
  //                                                                           weight:
  //                                                                               FontWeight.w400,
  //                                                                           size:
  //                                                                               11.0,
  //                                                                         ),
  //                                                                       ],
  //                                                                     ))
  //                                                                 : offDay.toString() ==
  //                                                                         '0'
  //                                                                     ? Padding(
  //                                                                         padding: const EdgeInsets
  //                                                                             .only(
  //                                                                             top:
  //                                                                                 12),
  //                                                                         child:
  //                                                                             Row(
  //                                                                           children: [
  //                                                                             Icon(
  //                                                                               Iconsax.info_circle,
  //                                                                               size: 15,
  //                                                                               color: Constanst.infoLight,
  //                                                                             ),
  //                                                                             const SizedBox(
  //                                                                               width: 10,
  //                                                                             ),
  //                                                                             const TextLabell(
  //                                                                               text: "Hari Libur Kerja",
  //                                                                               weight: FontWeight.w400,
  //                                                                               size: 11.0,
  //                                                                             ),
  //                                                                           ],
  //                                                                         ))
  //                                                                     : const SizedBox()
  //                                             : const SizedBox(),
  //                                         Padding(
  //                                           padding: const EdgeInsets.only(
  //                                               top: 12, bottom: 1),
  //                                           child: InkWell(
  //                                             onTap: () {
  //                                               controller.historySelected(
  //                                                   idAbsen, 'history');
  //                                             },
  //                                             child: Column(
  //                                               crossAxisAlignment:
  //                                                   CrossAxisAlignment.start,
  //                                               children: [
  //                                                 // (DateTime.parse(waktuMasuk)
  //                                                 //         .isAfter(
  //                                                 //             DateTime.parse(
  //                                                 //                 batasWaktu)))
  //                                                 //     ? Padding(
  //                                                 //         padding:
  //                                                 //             const EdgeInsets
  //                                                 //                 .only(
  //                                                 //                 left: 12.0,
  //                                                 //                 bottom: 4.0),
  //                                                 //         child: Row(
  //                                                 //           children: [
  //                                                 //             Icon(
  //                                                 //               Iconsax
  //                                                 //                   .info_circle,
  //                                                 //               size: 15,
  //                                                 //               color: Constanst
  //                                                 //                   .infoLight,
  //                                                 //             ),
  //                                                 //             const SizedBox(
  //                                                 //               width: 8,
  //                                                 //             ),
  //                                                 //             const TextLabell(
  //                                                 //               text:
  //                                                 //                   "Terlambat",
  //                                                 //               weight:
  //                                                 //                   FontWeight
  //                                                 //                       .w400,
  //                                                 //               size: 11.0,
  //                                                 //             ),
  //                                                 //           ],
  //                                                 //         ))
  //                                                 //     : Container(),
  //                                                 Row(
  //                                                   children: [
  //                                                     Expanded(
  //                                                       flex: 38,
  //                                                       child: Padding(
  //                                                         padding:
  //                                                             const EdgeInsets
  //                                                                 .only(
  //                                                                 left: 8.0),
  //                                                         child: Row(
  //                                                           mainAxisAlignment:
  //                                                               MainAxisAlignment
  //                                                                   .start,
  //                                                           children: [
  //                                                             Icon(
  //                                                               Iconsax.login_1,
  //                                                               color: Constanst
  //                                                                   .color5,
  //                                                               size: 16,
  //                                                             ),
  //                                                             Padding(
  //                                                               padding:
  //                                                                   const EdgeInsets
  //                                                                       .only(
  //                                                                       left:
  //                                                                           4),
  //                                                               child: Column(
  //                                                                 crossAxisAlignment:
  //                                                                     CrossAxisAlignment
  //                                                                         .start,
  //                                                                 children: [
  //                                                                   Text(
  //                                                                     "$jamMasuk",
  //                                                                     style: GoogleFonts.inter(
  //                                                                         color: Constanst
  //                                                                             .fgPrimary,
  //                                                                         fontWeight: FontWeight
  //                                                                             .w500,
  //                                                                         fontSize:
  //                                                                             16),
  //                                                                   ),
  //                                                                   const SizedBox(
  //                                                                       height:
  //                                                                           4),
  //                                                                   Text(
  //                                                                     regType ==
  //                                                                             0
  //                                                                         ? "Face Recognition"
  //                                                                         : "Photo",
  //                                                                     style: GoogleFonts.inter(
  //                                                                         color: Constanst
  //                                                                             .fgSecondary,
  //                                                                         fontWeight: FontWeight
  //                                                                             .w400,
  //                                                                         fontSize:
  //                                                                             10),
  //                                                                   ),
  //                                                                 ],
  //                                                               ),
  //                                                             )
  //                                                           ],
  //                                                         ),
  //                                                       ),
  //                                                     ),
  //                                                     const SizedBox(height: 4),
  //                                                     Expanded(
  //                                                       flex: 38,
  //                                                       child: Padding(
  //                                                         padding:
  //                                                             const EdgeInsets
  //                                                                 .only(
  //                                                                 left: 4),
  //                                                         child: Row(
  //                                                           mainAxisAlignment:
  //                                                               MainAxisAlignment
  //                                                                   .start,
  //                                                           children: [
  //                                                             Icon(
  //                                                               Iconsax
  //                                                                   .logout_14,
  //                                                               color: Constanst
  //                                                                   .color4,
  //                                                               size: 16,
  //                                                             ),
  //                                                             Padding(
  //                                                               padding:
  //                                                                   const EdgeInsets
  //                                                                       .only(
  //                                                                       left:
  //                                                                           4),
  //                                                               child: Column(
  //                                                                 crossAxisAlignment:
  //                                                                     CrossAxisAlignment
  //                                                                         .start,
  //                                                                 children: [
  //                                                                   Text(
  //                                                                     "$jamKeluar",
  //                                                                     style: GoogleFonts.inter(
  //                                                                         color: Constanst
  //                                                                             .fgPrimary,
  //                                                                         fontWeight: FontWeight
  //                                                                             .w500,
  //                                                                         fontSize:
  //                                                                             16),
  //                                                                   ),
  //                                                                   const SizedBox(
  //                                                                       height:
  //                                                                           4),
  //                                                                   Text(
  //                                                                     regType ==
  //                                                                             0
  //                                                                         ? "Face Recognition"
  //                                                                         : "Photo",
  //                                                                     style: GoogleFonts.inter(
  //                                                                         color: Constanst
  //                                                                             .fgSecondary,
  //                                                                         fontWeight: FontWeight
  //                                                                             .w400,
  //                                                                         fontSize:
  //                                                                             10),
  //                                                                   ),
  //                                                                 ],
  //                                                               ),
  //                                                             )
  //                                                           ],
  //                                                         ),
  //                                                       ),
  //                                                     ),
  //                                                     Expanded(
  //                                                       flex: 9,
  //                                                       child: Icon(
  //                                                         Icons
  //                                                             .arrow_forward_ios_rounded,
  //                                                         size: 16,
  //                                                         color: Constanst
  //                                                             .colorNeutralFgTertiary,
  //                                                       ),
  //                                                     ),
  //                                                   ],
  //                                                 ),
  //                                               ],
  //                                             ),
  //                                           ),
  //                                         ),
  //                                         controller.detailRiwayat.value[index]
  //                                                 .turunan!.isNotEmpty
  //                                             ? Container(
  //                                                 padding:
  //                                                     const EdgeInsets.only(
  //                                                         top: 4),
  //                                                 child: Column(
  //                                                   children: [
  //                                                     controller
  //                                                                 .detailRiwayat
  //                                                                 .value[index]
  //                                                                 .statusView ==
  //                                                             false
  //                                                         ? const SizedBox()
  //                                                         : Column(
  //                                                             children: List.generate(
  //                                                                 controller
  //                                                                     .detailRiwayat
  //                                                                     .value[
  //                                                                         index]
  //                                                                     .turunan!
  //                                                                     .length,
  //                                                                 (i) {
  //                                                               var datum = controller
  //                                                                   .detailRiwayat
  //                                                                   .value[
  //                                                                       index]
  //                                                                   .turunan![i];
  //                                                               var jamMasuk =
  //                                                                   datum.signin_time ??
  //                                                                       '';
  //                                                               var jamKeluar =
  //                                                                   datum.signout_time ??
  //                                                                       '';
  //                                                               var placeIn =
  //                                                                   datum.place_in ??
  //                                                                       '';
  //                                                               var placeOut =
  //                                                                   datum.place_out ??
  //                                                                       '';
  //                                                               var note = datum
  //                                                                       .signin_note ??
  //                                                                   '';
  //                                                               var signInLongLat =
  //                                                                   datum.signin_longlat ??
  //                                                                       '';
  //                                                               var signOutLongLat =
  //                                                                   datum.signout_longlat ??
  //                                                                       '';
  //                                                               var regType =
  //                                                                   datum.reqType ??
  //                                                                       0;
  //                                                               var statusView;
  //                                                               if (placeIn !=
  //                                                                   "") {
  //                                                                 statusView = placeIn ==
  //                                                                             "pengajuan" &&
  //                                                                         placeOut ==
  //                                                                             "pengajuan"
  //                                                                     ? true
  //                                                                     : false;
  //                                                               }
  //                                                               var listJamMasuk =
  //                                                                   (jamMasuk!
  //                                                                       .split(
  //                                                                           ':'));
  //                                                               var listJamKeluar =
  //                                                                   (jamKeluar!
  //                                                                       .split(
  //                                                                           ':'));
  //                                                               return Column(
  //                                                                 children: [
  //                                                                   const Divider(),
  //                                                                   Padding(
  //                                                                     padding: const EdgeInsets
  //                                                                         .only(
  //                                                                         top:
  //                                                                             6),
  //                                                                     child:
  //                                                                         InkWell(
  //                                                                       onTap:
  //                                                                           () {
  //                                                                         controller.historySelected(
  //                                                                             datum.id,
  //                                                                             'history');
  //                                                                       },
  //                                                                       child:
  //                                                                           Row(
  //                                                                         children: [
  //                                                                           Expanded(
  //                                                                             flex: 38,
  //                                                                             child: Padding(
  //                                                                               padding: const EdgeInsets.only(left: 8.0),
  //                                                                               child: Row(
  //                                                                                 mainAxisAlignment: MainAxisAlignment.start,
  //                                                                                 children: [
  //                                                                                   Icon(
  //                                                                                     Iconsax.login_1,
  //                                                                                     color: Constanst.color5,
  //                                                                                     size: 16,
  //                                                                                   ),
  //                                                                                   Padding(
  //                                                                                     padding: const EdgeInsets.only(left: 4),
  //                                                                                     child: Column(
  //                                                                                       crossAxisAlignment: CrossAxisAlignment.start,
  //                                                                                       children: [
  //                                                                                         Text(
  //                                                                                           "$jamMasuk",
  //                                                                                           style: GoogleFonts.inter(color: Constanst.fgPrimary, fontWeight: FontWeight.w500, fontSize: 16),
  //                                                                                         ),
  //                                                                                         const SizedBox(height: 4),
  //                                                                                         Text(
  //                                                                                           regType == 0 ? "Face Recognition" : "Photo",
  //                                                                                           style: GoogleFonts.inter(color: Constanst.fgSecondary, fontWeight: FontWeight.w400, fontSize: 10),
  //                                                                                         ),
  //                                                                                       ],
  //                                                                                     ),
  //                                                                                   )
  //                                                                                 ],
  //                                                                               ),
  //                                                                             ),
  //                                                                           ),
  //                                                                           Expanded(
  //                                                                             flex: 38,
  //                                                                             child: Padding(
  //                                                                               padding: const EdgeInsets.only(left: 4),
  //                                                                               child: Row(
  //                                                                                 mainAxisAlignment: MainAxisAlignment.start,
  //                                                                                 children: [
  //                                                                                   Icon(
  //                                                                                     Iconsax.logout_14,
  //                                                                                     color: Constanst.color4,
  //                                                                                     size: 16,
  //                                                                                   ),
  //                                                                                   Padding(
  //                                                                                     padding: const EdgeInsets.only(left: 4),
  //                                                                                     child: Column(
  //                                                                                       crossAxisAlignment: CrossAxisAlignment.start,
  //                                                                                       children: [
  //                                                                                         Text(
  //                                                                                           "$jamKeluar",
  //                                                                                           style: GoogleFonts.inter(color: Constanst.fgPrimary, fontWeight: FontWeight.w500, fontSize: 16),
  //                                                                                         ),
  //                                                                                         const SizedBox(height: 4),
  //                                                                                         Text(
  //                                                                                           regType == 0 ? "Face Recognition" : "Photo",
  //                                                                                           style: GoogleFonts.inter(color: Constanst.fgSecondary, fontWeight: FontWeight.w400, fontSize: 10),
  //                                                                                         ),
  //                                                                                       ],
  //                                                                                     ),
  //                                                                                   )
  //                                                                                 ],
  //                                                                               ),
  //                                                                             ),
  //                                                                           ),
  //                                                                           Expanded(
  //                                                                             flex: 9,
  //                                                                             child: Icon(
  //                                                                               Icons.arrow_forward_ios_rounded,
  //                                                                               size: 16,
  //                                                                               color: Constanst.colorNeutralFgTertiary,
  //                                                                             ),
  //                                                                           ),
  //                                                                         ],
  //                                                                       ),
  //                                                                     ),
  //                                                                   ),
  //                                                                 ],
  //                                                               );
  //                                                             }),
  //                                                           ),
  //                                                     const Divider(),
  //                                                     InkWell(
  //                                                       onTap: () {
  //                                                         print(controller
  //                                                             .detailRiwayat
  //                                                             .value[index]
  //                                                             .statusView);
  //                                                         //  controller.detailRiwayat.value[index].statusView=!controller.detailRiwayat.value[index].statusView;
  //                                                         controller
  //                                                             .detailRiwayat
  //                                                             .forEach(
  //                                                                 (element) {
  //                                                           if (element.id
  //                                                                   .toString() ==
  //                                                               controller
  //                                                                   .detailRiwayat
  //                                                                   .value[
  //                                                                       index]
  //                                                                   .id
  //                                                                   .toString()) {
  //                                                             element.statusView =
  //                                                                 !controller
  //                                                                     .detailRiwayat
  //                                                                     .value[
  //                                                                         index]
  //                                                                     .statusView;
  //                                                           } else {}
  //                                                         });
  //                                                         controller
  //                                                             .detailRiwayat
  //                                                             .refresh();
  //                                                       },
  //                                                       child: Container(
  //                                                         padding:
  //                                                             const EdgeInsets
  //                                                                 .only(
  //                                                                 bottom: 12),
  //                                                         width: MediaQuery.of(
  //                                                                 context)
  //                                                             .size
  //                                                             .width,
  //                                                         child: controller
  //                                                                     .detailRiwayat
  //                                                                     .value[
  //                                                                         index]
  //                                                                     .statusView ==
  //                                                                 true
  //                                                             ? Center(
  //                                                                 child:
  //                                                                     Container(
  //                                                                         child:
  //                                                                             const TextLabell(
  //                                                                 text: "Tutup",
  //                                                                 size: 14,
  //                                                               )))
  //                                                             : Center(
  //                                                                 child: Container(
  //                                                                     child: const TextLabell(
  //                                                                         text:
  //                                                                             "lainnya",
  //                                                                         size:
  //                                                                             14))),
  //                                                       ),
  //                                                     )
  //                                                   ],
  //                                                 ),
  //                                               )
  //                                             : const SizedBox(
  //                                                 height: 8,
  //                                               )
  //                                       ],
  //                                     ),
  //                             )
  //                           ],
  //                         ),
  //                       )
  //                     : Row(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Expanded(
  //                             flex: 40,
  //                             child: Text(
  //                               "${Constanst.convertDate(tanggal ?? '')}",
  //                               style: TextStyle(fontSize: 14),
  //                             ),
  //                           ),
  //                           Expanded(
  //                             flex: 60,
  //                             child: Row(
  //                               mainAxisAlignment: MainAxisAlignment.center,
  //                               crossAxisAlignment: CrossAxisAlignment.center,
  //                               children: [
  //                                 Text(
  //                                   "$note",
  //                                   style:
  //                                       TextStyle(fontWeight: FontWeight.bold),
  //                                 )
  //                               ],
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }
  Widget listAbsen() {
    return ListView.builder(
        physics: controller.historyAbsen.length <= 10
            ? const AlwaysScrollableScrollPhysics()
            : const BouncingScrollPhysics(),
        itemCount: controller.historyAbsen.value.length,
        itemBuilder: (context, index) {
          var jamMasuk = controller.historyAbsen.value[index].signin_time ?? '';
          var jamKeluar =
              controller.historyAbsen.value[index].signout_time ?? '';
          var placeIn = controller.historyAbsen.value[index].place_in ?? '';
          var placeOut = controller.historyAbsen.value[index].place_out ?? '';
          var note = controller.historyAbsen.value[index].signout_note ?? '';
          var signInLongLat =
              controller.historyAbsen.value[index].signin_longlat ?? '';
          var signOutLongLat =
              controller.historyAbsen.value[index].signout_longlat ?? '';
          var reqType = controller.historyAbsen.value[index].reqType ?? '';

          var statusView;
          var listJamMasuk;
          var listJamKeluar;
          var perhitunganJamMasuk1;
          var perhitunganJamMasuk2;
          var getColorMasuk;
          var getColorKeluar;

          if (placeIn != "") {
            statusView = placeIn == "pengajuan" &&
                    placeOut == "pengajuan" &&
                    signInLongLat == "pengajuan" &&
                    signOutLongLat == "pengajuan"
                ? true
                : false;
          }
          if (controller.historyAbsen.value[index].viewTurunan == false) {
            listJamMasuk = (jamMasuk!.split(':'));
            listJamKeluar = (jamKeluar!.split(':'));
            // perhitunganJamMasuk1 =
            //     830 - int.parse("${listJamMasuk[0]}${listJamMasuk[1]}");
            // perhitunganJamMasuk2 =
            //     1800 - int.parse("${listJamKeluar[0]}${listJamKeluar[1]}");

            // if (perhitunganJamMasuk1 < 0) {
            //   getColorMasuk = Colors.red;
            // } else {
            //   getColorMasuk = Colors.black;
            // }

            // if (perhitunganJamMasuk2 == 0) {
            //   getColorKeluar = Colors.black;
            // } else if (perhitunganJamMasuk2 > 0) {
            //   getColorKeluar = Colors.red;
            // } else if (perhitunganJamMasuk2 < 0) {
            //   getColorKeluar = Constanst.colorPrimary;
            // }
          } else {}

          print("id ${controller.historyAbsen.value[index].id}");

          // return controller.historyAbsen.value[index].id=="" || controller.historyAbsen.value[index].id==null|| controller.historyAbsen.value[index].id==0?SizedBox():  controller.historyAbsen.value[index].viewTurunan ==
          //         true
          //     ? tampilan1(controller.historyAbsen.value[index], index)
          //     : tampilan2(controller.historyAbsen.value[index]);

          return tampilan2(controller.historyAbsen.value[index]);
        });
  }

  Widget tampilan2(AbsenModel index) {
    var jamMasuk = index.signin_time ?? '';
    var jamKeluar = index.signout_time ?? '';
    var placeIn = index.place_in ?? '';
    var placeOut = index.place_out ?? '';
    var note = index.signin_note ?? '';
    var signInLongLat = index.signin_longlat ?? '';
    var signOutLongLat = index.signout_longlat ?? '';
    var regType = index.reqType ?? 0;
    var attenDate = index.atten_date ?? "";
    var batasJam = index.jamKerja.toString();
    var statusView;
    if (placeIn != "") {
      statusView =
          placeIn == "pengajuan" && placeOut == "pengajuan" ? true : false;
    }
    var listJamMasuk = (jamMasuk!.split(':'));
    var listJamKeluar = (jamKeluar!.split(':'));

    var waktuMasuk = "$attenDate $jamMasuk";
    var batasWaktu = "$attenDate $batasJam";
// Pastikan formatnya benar sebelum parsing
    // var perhitunganJamMasuk1 =
    //     830 - int.parse("${listJamMasuk[0]}${listJamMasuk[1]}");
    // var perhitunganJamMasuk2 =
    //     1800 - int.parse("${listJamKeluar[0]}${listJamKeluar[1]}");
    // var getColorMasuk;
    // var getColorKeluar;

    // if (perhitunganJamMasuk1 < 0) {
    //   getColorMasuk = Colors.red;
    // } else {
    //   getColorMasuk = Colors.black;
    // }

    // if (perhitunganJamMasuk2 == 0) {
    //   getColorKeluar = Colors.black;
    // } else if (perhitunganJamMasuk2 > 0) {
    //   getColorKeluar = Colors.red;
    // } else if (perhitunganJamMasuk2 < 0) {
    //   getColorKeluar = Constanst.colorPrimary;
    // }
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        customBorder: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
        onTap: () {
          // if (statusView == false) {
          //   controller.historySelected(index.id, 'history');
          // }
        },
        child:
            //  statusView == false
            //     ? Container(
            //         decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(12),
            //             border: Border.all(width: 1, color: Constanst.fgBorder)),
            //         child: Row(
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           mainAxisAlignment: MainAxisAlignment.start,
            //           children: [
            //             Expanded(
            //               flex: 15,
            //               child: Padding(
            //                 padding: const EdgeInsets.all(4.0),
            //                 child: Container(
            //                   decoration: BoxDecoration(
            //                     color: Constanst.colorNeutralBgSecondary,
            //                     borderRadius: const BorderRadius.only(
            //                       topLeft: Radius.circular(8.0),
            //                       bottomLeft: Radius.circular(8.0),
            //                     ),
            //                   ),
            //                   child: Padding(
            //                     padding:
            //                         const EdgeInsets.only(top: 5.0, bottom: 5.0),
            //                     child:  index.namaHariLibur==null || index.namaHariLibur==""? Column(
            //                       children: [
            //                         Text(
            //                             DateFormat('d').format(
            //                                 DateFormat('yyyy-MM-dd')
            //                                     .parse(index.date)),
            //                             style: GoogleFonts.inter(
            //                               fontSize: 20,
            //                               fontWeight: FontWeight.w500,
            //                               color: Constanst.fgPrimary,
            //                             )),
            //                         Text(
            //                             DateFormat('EEEE', 'id').format(
            //                                 DateFormat('yyyy-MM-dd')
            //                                     .parse(index.date)),
            //                             style: GoogleFonts.inter(
            //                               fontSize: 12,
            //                               fontWeight: FontWeight.w400,
            //                               color: Constanst.fgSecondary,
            //                             )),
            //                       ],
            //                     ):Column(
            //                       children: [
            //                         Text(
            //                             DateFormat('d').format(
            //                                 DateFormat('yyyy-MM-dd')
            //                                     .parse(index.date)),
            //                             style: GoogleFonts.inter(
            //                               fontSize: 20,
            //                               fontWeight: FontWeight.w500,
            //                               color: Constanst.fgPrimary,
            //                             )),
            //                         Text(
            //                             DateFormat('EEEE', 'id').format(
            //                                 DateFormat('yyyy-MM-dd')
            //                                     .parse(index.date)),
            //                             style: GoogleFonts.inter(
            //                               fontSize: 12,
            //                               fontWeight: FontWeight.w400,
            //                               color: Constanst.color4,
            //                             )),
            //                       ],
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             ),
            //             Expanded(
            //               flex: 38,
            //               child: Padding(
            //                 padding: const EdgeInsets.only(left: 8.0),
            //                 child: Row(
            //                   mainAxisAlignment: MainAxisAlignment.start,
            //                   children: [
            //                     Icon(
            //                       Iconsax.login_1,
            //                       color: Constanst.color5,
            //                       size: 16,
            //                     ),
            //                     Padding(
            //                       padding: const EdgeInsets.only(left: 4),
            //                       child: Column(
            //                         crossAxisAlignment: CrossAxisAlignment.start,
            //                         children: [
            //                           Text(
            //                             "$jamMasuk",
            //                             style: GoogleFonts.inter(
            //                                 color: Constanst.fgPrimary,
            //                                 fontWeight: FontWeight.w500,
            //                                 fontSize: 16),
            //                           ),
            //                           const SizedBox(height: 4),
            //                           Text(
            //                             regType == 0 ? "Face Recognition" : "Photo",
            //                             style: GoogleFonts.inter(
            //                                 color: Constanst.fgSecondary,
            //                                 fontWeight: FontWeight.w400,
            //                                 fontSize: 10),
            //                           ),
            //                         ],
            //                       ),
            //                     )
            //                   ],
            //                 ),
            //               ),
            //             ),
            //             Expanded(
            //               flex: 38,
            //               child: Padding(
            //                 padding: const EdgeInsets.only(left: 4),
            //                 child: Row(
            //                   mainAxisAlignment: MainAxisAlignment.start,
            //                   children: [
            //                     Icon(
            //                       Iconsax.logout_14,
            //                       color: Constanst.color4,
            //                       size: 16,
            //                     ),
            //                     Padding(
            //                       padding: const EdgeInsets.only(left: 4),
            //                       child: Column(
            //                         crossAxisAlignment: CrossAxisAlignment.start,
            //                         children: [
            //                           Text(
            //                             "$jamKeluar",
            //                             style: GoogleFonts.inter(
            //                                 color: Constanst.fgPrimary,
            //                                 fontWeight: FontWeight.w500,
            //                                 fontSize: 16),
            //                           ),
            //                           const SizedBox(height: 4),
            //                           Text(
            //                             regType == 0 ? "Face Recognition" : "Photo",
            //                             style: GoogleFonts.inter(
            //                                 color: Constanst.fgSecondary,
            //                                 fontWeight: FontWeight.w400,
            //                                 fontSize: 10),
            //                           ),
            //                         ],
            //                       ),
            //                     )
            //                   ],
            //                 ),
            //               ),
            //             ),
            //             Expanded(
            //               flex: 9,
            //               child: Icon(
            //                 Icons.arrow_forward_ios_rounded,
            //                 size: 16,
            //                 color: Constanst.colorNeutralFgTertiary,
            //               ),
            //             ),
            //           ],
            //         ),
            //       )
            //     :

            Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(width: 1, color: Constanst.fgBorder)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 15,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    height: index.turunan!.isNotEmpty &&
                            index.statusView == true
                        ? int.parse(index.turunan!.length.toString()) * 55 + 28
                        : 50,
                    decoration: BoxDecoration(
                      color: Constanst.colorNeutralBgSecondary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: index.namaHariLibur == null ||
                              index.namaHariLibur == ""
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    DateFormat('d').format(
                                        DateFormat('yyyy-MM-dd')
                                            .parse(index.date)),
                                    style: GoogleFonts.inter(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Constanst.fgPrimary,
                                    )),
                                Text(
                                    DateFormat('EEEE', 'id').format(
                                        DateFormat('yyyy-MM-dd')
                                            .parse(index.date)),
                                    style: GoogleFonts.inter(
                                      fontSize: 8,
                                      fontWeight: FontWeight.w400,
                                      color: Constanst.fgPrimary,
                                    )),
                              ],
                            )
                          : Column(
                              children: [
                                Text(
                                    DateFormat('d').format(
                                        DateFormat('yyyy-MM-dd')
                                            .parse(index.date)),
                                    style: GoogleFonts.inter(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.red,
                                    )),
                                Text(
                                    DateFormat('EEEE', 'id').format(
                                        DateFormat('yyyy-MM-dd')
                                            .parse(index.date)),
                                    style: GoogleFonts.inter(
                                      fontSize: 8,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.red,
                                    )),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 85,
                child: index.atten_date == "" || index.atten_date == null
                    ?
                    //tidak ada absen
                    index.namaHariLibur != null
                        ? Padding(
                            padding: const EdgeInsets.only(left: 18),
                            child: TextLabell(
                              text: index.namaHariLibur,
                              size: 14.0,
                              weight: FontWeight.w500,
                            ))
                        : index.namaTugasLuar != null
                            ? const Padding(
                                padding: EdgeInsets.only(left: 18),
                                child: TextLabell(
                                  text: "Tugas Luar",
                                  size: 14.0,
                                  weight: FontWeight.w500,
                                ))
                            : index.namaDinasLuar != null
                                ? const Padding(
                                    padding: EdgeInsets.only(left: 18),
                                    child: TextLabell(
                                      text: "Dinas Luar",
                                      size: 14.0,
                                      weight: FontWeight.w500,
                                    ))
                                : index.namaCuti != null
                                    ? const Padding(
                                        padding: EdgeInsets.only(left: 18),
                                        child: TextLabell(
                                          text: "Cuti",
                                          size: 14.0,
                                          weight: FontWeight.w500,
                                        ))
                                    : index.namaSakit != null
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(left: 18),
                                            child: TextLabell(
                                              text:
                                                  "Sakit : ${index.namaSakit}",
                                              size: 14.0,
                                              weight: FontWeight.w500,
                                            ))
                                        : index.namaIzin != null
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 18),
                                                child: TextLabell(
                                                  text:
                                                      "Izin : ${index.namaIzin}",
                                                  size: 14.0,
                                                  weight: FontWeight.w500,
                                                ))
                                            : index.offDay.toString() == '0'
                                                ? const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 18),
                                                    child: TextLabell(
                                                      text: "Hari Libur Kerja",
                                                      size: 14.0,
                                                      weight: FontWeight.w500,
                                                    ))
                                                : const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 18),
                                                    child: TextLabell(
                                                      text:
                                                          "ALPHA / Belum Absen",
                                                      weight: FontWeight.w500,
                                                    ))
                    :

                    //     ada asen
                    Column(
                        children: [
                          index.atten_date != "" || index.atten_date != null
                              ?
                              //tidak ada absen
                              index.namaHariLibur != null
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Iconsax.info_circle,
                                            size: 15,
                                            color: Constanst.infoLight,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          TextLabell(
                                            text: index.namaHariLibur,
                                            weight: FontWeight.w400,
                                            size: 11.0,
                                          ),
                                        ],
                                      ))
                                  : index.namaTugasLuar != null
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(top: 12),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Iconsax.info_circle,
                                                size: 15,
                                                color: Constanst.infoLight,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              TextLabell(
                                                text: index.namaTugasLuar,
                                                weight: FontWeight.w400,
                                                size: 11.0,
                                              ),
                                            ],
                                          ))
                                      : index.namaDinasLuar != null
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 12),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Iconsax.info_circle,
                                                    size: 15,
                                                    color: Constanst.infoLight,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  TextLabell(
                                                    text: index.namaDinasLuar,
                                                    weight: FontWeight.w400,
                                                    size: 11.0,
                                                  ),
                                                ],
                                              ))
                                          : index.namaCuti != null
                                              ? Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 12),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Iconsax.info_circle,
                                                        size: 15,
                                                        color:
                                                            Constanst.infoLight,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      TextLabell(
                                                        text: index.namaCuti,
                                                        weight: FontWeight.w400,
                                                        size: 11.0,
                                                      ),
                                                    ],
                                                  ))
                                              : index.namaSakit != null
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 12),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Iconsax.info_circle,
                                                            size: 15,
                                                            color: Constanst
                                                                .infoLight,
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          TextLabell(
                                                            text:
                                                                index.namaSakit,
                                                            weight:
                                                                FontWeight.w400,
                                                            size: 11.0,
                                                          ),
                                                        ],
                                                      ))
                                                  : index.offDay.toString() ==
                                                          '0'
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 12),
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Iconsax
                                                                    .info_circle,
                                                                size: 15,
                                                                color: Constanst
                                                                    .infoLight,
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              const TextLabell(
                                                                text:
                                                                    "Hari Libur Kerja",
                                                                weight:
                                                                    FontWeight
                                                                        .w400,
                                                                size: 11.0,
                                                              ),
                                                            ],
                                                          ))
                                                      : (index.jamKerja.toString() !=
                                                                  "null") &&
                                                              DateTime.parse(
                                                                      waktuMasuk)
                                                                  .isAfter(DateTime.parse(
                                                                          batasWaktu)
                                                                      .add(const Duration(minutes: 1)))
                                                          ? Padding(
                                                              padding: const EdgeInsets.only(top: 12),
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                    Iconsax
                                                                        .info_circle,
                                                                    size: 15,
                                                                    color: Constanst
                                                                        .infoLight,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  const TextLabell(
                                                                    text:
                                                                        "Terlambat",
                                                                    weight:
                                                                        FontWeight
                                                                            .w400,
                                                                    size: 11.0,
                                                                  ),
                                                                ],
                                                              ))
                                                          : const SizedBox()
                              : const SizedBox(),
                          Padding(
                            padding: const EdgeInsets.only(top: 12, bottom: 1),
                            child: InkWell(
                              onTap: () {
                                controller.historySelected(index.id, 'history');
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 38,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Iconsax.login_1,
                                                color: Constanst.color5,
                                                size: 16,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 4),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "$jamMasuk",
                                                      style: GoogleFonts.inter(
                                                          color: Constanst
                                                              .fgPrimary,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      regType == 0
                                                          ? "Face Recognition"
                                                          : "Photo",
                                                      style: GoogleFonts.inter(
                                                          color: Constanst
                                                              .fgSecondary,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 10),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Expanded(
                                        flex: 38,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Iconsax.logout_14,
                                                color: Constanst.color4,
                                                size: 16,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 4),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "$jamKeluar",
                                                      style: GoogleFonts.inter(
                                                          color: Constanst
                                                              .fgPrimary,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      regType == 0
                                                          ? "Face Recognition"
                                                          : "Photo",
                                                      style: GoogleFonts.inter(
                                                          color: Constanst
                                                              .fgSecondary,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 10),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 9,
                                        child: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 16,
                                          color:
                                              Constanst.colorNeutralFgTertiary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          index.turunan!.isNotEmpty
                              ? Container(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Column(
                                    children: [
                                      index.statusView == false
                                          ? const SizedBox()
                                          : Column(
                                              children: List.generate(
                                                  index.turunan!.length, (i) {
                                                var datum = index.turunan![i];
                                                var jamMasuk =
                                                    datum.signin_time ?? '';
                                                var jamKeluar =
                                                    datum.signout_time ?? '';
                                                var placeIn =
                                                    datum.place_in ?? '';
                                                var placeOut =
                                                    datum.place_out ?? '';
                                                var note =
                                                    datum.signin_note ?? '';
                                                var signInLongLat =
                                                    datum.signin_longlat ?? '';
                                                var signOutLongLat =
                                                    datum.signout_longlat ?? '';
                                                var regType =
                                                    datum.reqType ?? 0;
                                                var statusView;
                                                if (placeIn != "") {
                                                  statusView =
                                                      placeIn == "pengajuan" &&
                                                              placeOut ==
                                                                  "pengajuan"
                                                          ? true
                                                          : false;
                                                }
                                                var listJamMasuk =
                                                    (jamMasuk!.split(':'));
                                                var listJamKeluar =
                                                    (jamKeluar!.split(':'));
                                                return Column(
                                                  children: [
                                                    const Divider(),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 6),
                                                      child: InkWell(
                                                        onTap: () {
                                                          controller
                                                              .historySelected(
                                                                  datum.id,
                                                                  'history');
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 38,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            8.0),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Icon(
                                                                      Iconsax
                                                                          .login_1,
                                                                      color: Constanst
                                                                          .color5,
                                                                      size: 16,
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              4),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            "$jamMasuk",
                                                                            style: GoogleFonts.inter(
                                                                                color: Constanst.fgPrimary,
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 16),
                                                                          ),
                                                                          const SizedBox(
                                                                              height: 4),
                                                                          Text(
                                                                            regType == 0
                                                                                ? "Face Recognition"
                                                                                : "Photo",
                                                                            style: GoogleFonts.inter(
                                                                                color: Constanst.fgSecondary,
                                                                                fontWeight: FontWeight.w400,
                                                                                fontSize: 10),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 38,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            4),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Icon(
                                                                      Iconsax
                                                                          .logout_14,
                                                                      color: Constanst
                                                                          .color4,
                                                                      size: 16,
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              4),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            "$jamKeluar",
                                                                            style: GoogleFonts.inter(
                                                                                color: Constanst.fgPrimary,
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 16),
                                                                          ),
                                                                          const SizedBox(
                                                                              height: 4),
                                                                          Text(
                                                                            regType == 0
                                                                                ? "Face Recognition"
                                                                                : "Photo",
                                                                            style: GoogleFonts.inter(
                                                                                color: Constanst.fgSecondary,
                                                                                fontWeight: FontWeight.w400,
                                                                                fontSize: 10),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 9,
                                                              child: Icon(
                                                                Icons
                                                                    .arrow_forward_ios_rounded,
                                                                size: 16,
                                                                color: Constanst
                                                                    .colorNeutralFgTertiary,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }),
                                            ),
                                      const Divider(),
                                      InkWell(
                                        onTap: () {
                                          print(index.statusView);
                                          //  index.statusView=!index.statusView;
                                          controller.historyAbsen
                                              .forEach((element) {
                                            if (element.id.toString() ==
                                                index.id.toString()) {
                                              element.statusView =
                                                  !index.statusView;
                                            } else {}
                                          });
                                          controller.historyAbsen.refresh();
                                        },
                                        child: Container(
                                          padding:
                                              const EdgeInsets.only(bottom: 12),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: index.statusView == true
                                              ? Center(
                                                  child: Container(
                                                      child: const TextLabell(
                                                  text: "Tutup",
                                                  size: 14,
                                                )))
                                              : Center(
                                                  child: Container(
                                                      child: const TextLabell(
                                                          text: "lainnya",
                                                          size: 14))),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : const SizedBox(
                                  height: 8,
                                )
                        ],
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
