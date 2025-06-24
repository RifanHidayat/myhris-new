import 'package:cached_network_image/cached_network_image.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/absen_controller.dart';
import 'package:siscom_operasional/screen/absen/history_absen.dart';
import 'package:siscom_operasional/screen/absen/laporan/laporan_absen_karyawan.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/appbar_widget.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/month_year_picker.dart';
import 'package:siscom_operasional/utils/widget_textButton.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'dart:math' as math;
import 'package:flutter_svg/flutter_svg.dart';

class LaporanAbsen extends StatefulWidget {
  var dataForm;
  LaporanAbsen({Key? key, this.dataForm}) : super(key: key);
  @override
  _LaporanAbsenState createState() => _LaporanAbsenState();
}

class _LaporanAbsenState extends State<LaporanAbsen> {
  var controller = Get.find<AbsenController>();

  @override
  void initState() {
    controller.onReady();
    controller.getPlaceCoordinate();
    controller.tempNamaLaporan1.value = "";
    controller.tempNamaTipe1.value = "Absensi";
    
    super.initState();
  }

  Future<void> refreshData() async {
    await Future.delayed(Duration(seconds: 2));
    controller.onReady();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constanst.coloBackgroundScreen,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight) * 1,
          child: Obx(
            () => Container(
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
                centerTitle: false,
                title: controller.statusCari.value
                    ? SizedBox(
                        height: 40,
                        child: TextFormField(
                          controller: controller.cari.value,
                          // onFieldSubmitted: (value) {
                          //   if (controller.cari.value.text == "") {
                          //     UtilsAlert.showToast(
                          //         "Isi form cari terlebih dahulu");
                          //   } else {
                          //     // UtilsAlert.loadingSimpanData(
                          //     //     Get.context!, "Mencari Data...");
                          //     controller.pencarianNamaKaryawan(value);
                          //   }
                          // },
                          onChanged: (value) {
                            controller.pencarianNamaKaryawan(value);
                            controller.pencarianNamaKaryawanTelat(value);
                            controller.pencarianNamaKaryawanBelumAbsen(value);
                          },
                          textAlignVertical: TextAlignVertical.center,
                          style: GoogleFonts.inter(
                              height: 1.5,
                              fontWeight: FontWeight.w400,
                              color: Constanst.fgPrimary,
                              fontSize: 15),
                          cursorColor: Constanst.onPrimary,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Constanst.colorNeutralBgSecondary,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              contentPadding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              hintText: "Cari data...",
                              hintStyle: GoogleFonts.inter(
                                  height: 1.5,
                                  fontWeight: FontWeight.w400,
                                  color: Constanst.fgSecondary,
                                  fontSize: 14),
                              prefixIconConstraints:
                                  BoxConstraints.tight(const Size(46, 46)),
                              suffixIconConstraints:
                                  BoxConstraints.tight(const Size(46, 46)),
                              suffixIcon: Padding(
                                padding:
                                    const EdgeInsets.only(left: 16.0, right: 8),
                                child: IconButton(
                                  icon: Icon(
                                    Iconsax.close_circle5,
                                    color: Constanst.fgSecondary,
                                    size: 24,
                                  ),
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    controller.clearPencarian();
                                    controller.groupData();
                                  },
                                ),
                              )),
                        ),
                      )
                    : InkWell(
                        onTap: () => controller.widgetButtomSheetFormLaporan(),
                        child: SizedBox(
                          height: 56,
                          child: Row(
                            children: [
                              Text(
                                "Laporan Absensi",
                                style: GoogleFonts.inter(
                                    color: Constanst.fgPrimary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Iconsax.arrow_down_1,
                                color: Constanst.fgPrimary,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                actions: [
                  controller.statusCari.value
                      ? Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Container(),
                        )
                      : IconButton(
                          icon: Icon(
                            Iconsax.search_normal_1,
                            color: Constanst.fgPrimary,
                            size: 24,
                          ),
                          onPressed: controller.showInputCari,
                          // controller.toggleSearch,
                        ),
                ],
                leading: controller.statusCari.value
                    ? IconButton(
                        icon: Icon(
                          Iconsax.arrow_left,
                          color: Constanst.fgPrimary,
                          size: 24,
                        ),
                        onPressed: controller.showInputCari,
                      )
                    : IconButton(
                        icon: Icon(
                          Iconsax.arrow_left,
                          color: Constanst.fgPrimary,
                          size: 24,
                        ),
                        onPressed: () {
                          controller.cari.value.clear();
                          controller.onClose();
                          Get.back();
                        },
                      ),
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
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    filterData(),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Container(
                            //   width: MediaQuery.of(Get.context!).size.width * 0.7,
                            //   margin: EdgeInsets.only(top: 6),
                            //   alignment: Alignment.centerLeft,
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.center,
                            //     children: [
                            //       controller.selectedViewFilterAbsen.value == 0
                            //           ? Text(
                            //               "${controller.namaDepartemenTerpilih.value}  (${Constanst.convertDateBulanDanTahun('${controller.bulanDanTahunNow}')})",
                            //               style: TextStyle(
                            //                   fontWeight: FontWeight.bold,
                            //                   fontSize: 14),
                            //             )
                            //           : Text(
                            //               "${controller.namaDepartemenTerpilih.value}  (${Constanst.convertDate('${DateFormat('yyyy-MM-dd').format(controller.pilihTanggalTelatAbsen.value)}')})",
                            //               style: TextStyle(
                            //                   fontWeight: FontWeight.bold,
                            //                   fontSize: 14),
                            //             ),
                            //     ],
                            //   ),
                            // ),
                            Text(
                              "${controller.tempNamaTipe1.value == "Belum Absen" ? controller.listLaporanBelumAbsen.value.length : controller.tempNamaTipe1.value == "Absen Terlambat" ? controller.listEmployeeTelat.value.length : controller.listLaporanFilter.value.length} Karyawan",
                              style: GoogleFonts.inter(
                                  color: Constanst.fgSecondary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Flexible(
                      child: RefreshIndicator(
                        onRefresh: refreshData,
                        child: controller.statusLoadingSubmitLaporan.value
                            ? Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: Constanst.colorPrimary,
                                ),
                              )
                            : controller.tempNamaTipe1.value == "Belum Absen"
                                ? listAbsensiKaryawanBelumAbsen()
                                : controller.tempNamaTipe1.value ==
                                        "Absen Terlambat"
                                    ? listAbsensiKaryawanTerlambat()
                                    : controller.tempNamaTipe1.value ==
                                            "Absensi"
                                        ? listAbsensiKaryawan()
                                        : Center(
                                            child:
                                                Text(controller.loading.value),
                                          ),
                      ),
                    )
                  ],
                ),
              ),
            )));
  }

  Widget filterData() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // controller.departemen.value.text != "SEMUA DIVISI"
              //     ? Padding(
              //         padding: EdgeInsets.only(right: 10),
              //         child: InkWell(
              //           onTap: () {
              //             controller.selectedViewFilterAbsen.value = 0;
              //             controller.refreshFilterKoordinate();
              //           },
              //           child: Container(
              //             decoration: BoxDecoration(
              //                 color: Colors.white,
              //                 borderRadius: Constanst.borderStyle5,
              //                 border: Border.all(color: Constanst.colorText2)),
              //             child: Padding(
              //               padding: EdgeInsets.all(5),
              //               child: InkWell(
              //                 onTap: () {
              //                   controller.selectedViewFilterAbsen.value = 0;
              //                   controller.refreshFilterKoordinate();
              //                 },
              //                 child: Row(
              //                   crossAxisAlignment: CrossAxisAlignment.center,
              //                   children: [
              //                     Icon(
              //                       Icons.close,
              //                       size: 15,
              //                     )
              //                   ],
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //       )
              //     : controller.filterLokasiKoordinate.value != "Lokasi"
              //         ? Padding(
              //             padding: EdgeInsets.only(right: 10),
              //             child: InkWell(
              //               onTap: () {
              //                 controller.refreshFilterKoordinate();
              //               },
              //               child: Container(
              //                 decoration: BoxDecoration(
              //                     color: Colors.white,
              //                     borderRadius: BorderRadius.circular(8),
              //                     border:
              //                         Border.all(color: Constanst.colorText2)),
              //                 child: Padding(
              //                   padding: EdgeInsets.all(5),
              //                   child: InkWell(
              //                     onTap: () {},
              //                     child: Row(
              //                       crossAxisAlignment: CrossAxisAlignment.center,
              //                       children: [
              //                         Icon(
              //                           Icons.close,
              //                           size: 15,
              //                         )
              //                       ],
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           )
              //         : controller.selectedViewFilterAbsen.value != 0
              //             ? Padding(
              //                 padding: EdgeInsets.only(right: 10),
              //                 child: InkWell(
              //                   onTap: () {
              //                     controller.refreshFilterKoordinate();
              //                   },
              //                   child: Container(
              //                     decoration: BoxDecoration(
              //                         color: Colors.white,
              //                         borderRadius: Constanst.borderStyle5,
              //                         border: Border.all(
              //                             color: Constanst.colorText2)),
              //                     child: Padding(
              //                       padding: EdgeInsets.all(5),
              //                       child: InkWell(
              //                         onTap: () {},
              //                         child: Row(
              //                           crossAxisAlignment:
              //                               CrossAxisAlignment.center,
              //                           children: [
              //                             Icon(
              //                               Icons.close,
              //                               size: 15,
              //                             )
              //                           ],
              //                         ),
              //                       ),
              //                     ),
              //                   ),
              //                 ),
              //               )
              //             : Container(),
              // InkWell(
              //   customBorder: const RoundedRectangleBorder(
              //       borderRadius: BorderRadius.all(Radius.circular(100))),
              //   onTap: () {
              //     showModalBottomSheet(
              //       context: context,
              //       shape: const RoundedRectangleBorder(
              //         borderRadius: BorderRadius.vertical(
              //           top: Radius.circular(16.0),
              //         ),
              //       ),
              //       builder: (BuildContext context) {
              //         return SafeArea(
              //           child: ClipRRect(
              //             borderRadius: BorderRadius.circular(16.0),
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               mainAxisSize: MainAxisSize.min,
              //               children: [
              //                 Padding(
              //                   padding:
              //                       const EdgeInsets.fromLTRB(16, 18, 16, 18),
              //                   child: Row(
              //                     crossAxisAlignment: CrossAxisAlignment.center,
              //                     mainAxisAlignment:
              //                         MainAxisAlignment.spaceBetween,
              //                     children: [
              //                       Text(
              //                         "Pilih Tipe Izin",
              //                         style: GoogleFonts.inter(
              //                           fontWeight: FontWeight.w500,
              //                           fontSize: 18,
              //                           color: Constanst.fgPrimary,
              //                         ),
              //                       ),
              //                       InkWell(
              //                           customBorder:
              //                               const RoundedRectangleBorder(
              //                                   borderRadius: BorderRadius.all(
              //                                       Radius.circular(8))),
              //                           onTap: () =>
              //                               Navigator.pop(Get.context!),
              //                           child: Icon(
              //                             Icons.close,
              //                             size: 26,
              //                             color: Constanst.fgSecondary,
              //                           ))
              //                     ],
              //                   ),
              //                 ),
              //                 Padding(
              //                   padding:
              //                       const EdgeInsets.fromLTRB(16, 0, 16, 0),
              //                   child: Divider(
              //                     thickness: 1,
              //                     height: 0,
              //                     color: Constanst.border,
              //                   ),
              //                 ),
              //                 InkWell(
              //                   onTap: () {
              //                     controller.clearPencarian();
              //                     controller.statusLoadingSubmitLaporan.value =
              //                         true;
              //                     controller.tempNamaTipe1.value = "Absensi";

              //                     controller.getPlaceCoordinate();
              //                     controller.tempNamaLaporan1.value = "";
              //                     controller.onReady();
              //                     Get.back();
              //                   },
              //                   child: Padding(
              //                     padding:
              //                         const EdgeInsets.fromLTRB(0, 16, 16, 16),
              //                     child: Row(
              //                       mainAxisAlignment:
              //                           MainAxisAlignment.spaceBetween,
              //                       children: [
              //                         Row(
              //                           children: [
              //                             const SizedBox(width: 16),
              //                             Text(
              //                               "Absensi",
              //                               style: GoogleFonts.inter(
              //                                 fontWeight: FontWeight.w500,
              //                                 fontSize: 16,
              //                                 color: Constanst.fgPrimary,
              //                               ),
              //                             ),
              //                           ],
              //                         ),
              //                         controller.tempNamaTipe1.value ==
              //                                 "Absensi"
              //                             ? Container(
              //                                 height: 20,
              //                                 width: 20,
              //                                 decoration: BoxDecoration(
              //                                     border: Border.all(
              //                                         width: 2,
              //                                         color:
              //                                             Constanst.onPrimary),
              //                                     borderRadius:
              //                                         BorderRadius.circular(
              //                                             10)),
              //                                 child: Padding(
              //                                   padding:
              //                                       const EdgeInsets.all(3),
              //                                   child: Container(
              //                                     decoration: BoxDecoration(
              //                                         color:
              //                                             Constanst.onPrimary,
              //                                         borderRadius:
              //                                             BorderRadius.circular(
              //                                                 10)),
              //                                   ),
              //                                 ),
              //                               )
              //                             : InkWell(
              //                                 onTap: () {
              //                                   controller.clearPencarian();
              //                                   controller
              //                                       .statusLoadingSubmitLaporan
              //                                       .value = true;
              //                                   controller.tempNamaTipe1.value =
              //                                       "Absensi";

              //                                   controller.getPlaceCoordinate();
              //                                   controller.tempNamaLaporan1
              //                                       .value = "";
              //                                   controller.onReady();
              //                                   Get.back();
              //                                 },
              //                                 child: Container(
              //                                   height: 20,
              //                                   width: 20,
              //                                   decoration: BoxDecoration(
              //                                       border: Border.all(
              //                                           width: 1,
              //                                           color: Constanst
              //                                               .onPrimary),
              //                                       borderRadius:
              //                                           BorderRadius.circular(
              //                                               10)),
              //                                   child: Padding(
              //                                     padding:
              //                                         const EdgeInsets.all(2),
              //                                     child: Container(
              //                                       decoration: BoxDecoration(
              //                                           borderRadius:
              //                                               BorderRadius
              //                                                   .circular(10)),
              //                                     ),
              //                                   ),
              //                                 ),
              //                               )
              //                       ],
              //                     ),
              //                   ),
              //                 ),
              //                 InkWell(
              //                   onTap: () {
              //                     controller.clearPencarian();
              //                     controller.statusLoadingSubmitLaporan.value =
              //                         true;
              //                     controller.tempNamaTipe1.value =
              //                         "Belum Absen";
              //                     controller.pilihTanggalTelatAbsen.value =
              //                         DateTime.now();
              //                     controller.filterBelumAbsen();
              //                     controller.aksiEmployeeBelumAbsen(
              //                         "${DateFormat('yyyy-MM-dd').format(controller.pilihTanggalTelatAbsen.value)}");
              //                     controller.onReady();
              //                     Get.back();
              //                   },
              //                   child: Padding(
              //                     padding:
              //                         const EdgeInsets.fromLTRB(0, 16, 16, 16),
              //                     child: Row(
              //                       mainAxisAlignment:
              //                           MainAxisAlignment.spaceBetween,
              //                       children: [
              //                         Row(
              //                           children: [
              //                             const SizedBox(width: 16),
              //                             Text(
              //                               "Tidak/Belum Absen",
              //                               style: GoogleFonts.inter(
              //                                 fontWeight: FontWeight.w500,
              //                                 fontSize: 16,
              //                                 color: Constanst.fgPrimary,
              //                               ),
              //                             ),
              //                           ],
              //                         ),
              //                         controller.tempNamaTipe1.value ==
              //                                 "Belum Absen"
              //                             ? Container(
              //                                 height: 20,
              //                                 width: 20,
              //                                 decoration: BoxDecoration(
              //                                     border: Border.all(
              //                                         width: 2,
              //                                         color:
              //                                             Constanst.onPrimary),
              //                                     borderRadius:
              //                                         BorderRadius.circular(
              //                                             10)),
              //                                 child: Padding(
              //                                   padding:
              //                                       const EdgeInsets.all(3),
              //                                   child: Container(
              //                                     decoration: BoxDecoration(
              //                                         color:
              //                                             Constanst.onPrimary,
              //                                         borderRadius:
              //                                             BorderRadius.circular(
              //                                                 10)),
              //                                   ),
              //                                 ),
              //                               )
              //                             : InkWell(
              //                                 onTap: () {
              //                                   controller.clearPencarian();
              //                                   controller
              //                                       .statusLoadingSubmitLaporan
              //                                       .value = true;
              //                                   controller.tempNamaTipe1.value =
              //                                       "Belum Absen";
              //                                   controller
              //                                       .pilihTanggalTelatAbsen
              //                                       .value = DateTime.now();
              //                                   controller.filterBelumAbsen();
              //                                   controller.aksiEmployeeBelumAbsen(
              //                                       "${DateFormat('yyyy-MM-dd').format(controller.pilihTanggalTelatAbsen.value)}");
              //                                   controller.onReady();
              //                                   Get.back();
              //                                 },
              //                                 child: Container(
              //                                   height: 20,
              //                                   width: 20,
              //                                   decoration: BoxDecoration(
              //                                       border: Border.all(
              //                                           width: 1,
              //                                           color: Constanst
              //                                               .onPrimary),
              //                                       borderRadius:
              //                                           BorderRadius.circular(
              //                                               10)),
              //                                   child: Padding(
              //                                     padding:
              //                                         const EdgeInsets.all(2),
              //                                     child: Container(
              //                                       decoration: BoxDecoration(
              //                                           borderRadius:
              //                                               BorderRadius
              //                                                   .circular(10)),
              //                                     ),
              //                                   ),
              //                                 ),
              //                               )
              //                       ],
              //                     ),
              //                   ),
              //                 ),
              //                 InkWell(
              //                   onTap: () {
              //                     controller.clearPencarian();
              //                     controller.statusLoadingSubmitLaporan.value =
              //                         true;
              //                     controller.tempNamaTipe1.value =
              //                         "Absen Terlambat";
              //                     controller.pilihTanggalTelatAbsen.value =
              //                         DateTime.now();
              //                     controller.filterAbsenTelat();
              //                     controller.aksiEmployeeTerlambatAbsen(
              //                         "${DateFormat('yyyy-MM-dd').format(controller.pilihTanggalTelatAbsen.value)}");
              //                     controller.onReady();
              //                     Get.back();
              //                   },
              //                   child: Padding(
              //                     padding:
              //                         const EdgeInsets.fromLTRB(0, 16, 16, 16),
              //                     child: Row(
              //                       mainAxisAlignment:
              //                           MainAxisAlignment.spaceBetween,
              //                       children: [
              //                         Row(
              //                           children: [
              //                             const SizedBox(width: 16),
              //                             Text(
              //                               "Absen Terlambat",
              //                               style: GoogleFonts.inter(
              //                                 fontWeight: FontWeight.w500,
              //                                 fontSize: 16,
              //                                 color: Constanst.fgPrimary,
              //                               ),
              //                             ),
              //                           ],
              //                         ),
              //                         controller.tempNamaTipe1.value ==
              //                                 "Absen Terlambat"
              //                             ? Container(
              //                                 height: 20,
              //                                 width: 20,
              //                                 decoration: BoxDecoration(
              //                                     border: Border.all(
              //                                         width: 2,
              //                                         color:
              //                                             Constanst.onPrimary),
              //                                     borderRadius:
              //                                         BorderRadius.circular(
              //                                             10)),
              //                                 child: Padding(
              //                                   padding:
              //                                       const EdgeInsets.all(3),
              //                                   child: Container(
              //                                     decoration: BoxDecoration(
              //                                         color:
              //                                             Constanst.onPrimary,
              //                                         borderRadius:
              //                                             BorderRadius.circular(
              //                                                 10)),
              //                                   ),
              //                                 ),
              //                               )
              //                             : InkWell(
              //                                 onTap: () {
              //                                   controller.clearPencarian();
              //                                   controller
              //                                       .statusLoadingSubmitLaporan
              //                                       .value = true;
              //                                   controller.tempNamaTipe1.value =
              //                                       "Absen Terlambat";
              //                                   controller
              //                                       .pilihTanggalTelatAbsen
              //                                       .value = DateTime.now();
              //                                   controller.filterAbsenTelat();
              //                                   controller
              //                                       .aksiEmployeeTerlambatAbsen(
              //                                           "${DateFormat('yyyy-MM-dd').format(controller.pilihTanggalTelatAbsen.value)}");
              //                                   controller.onReady();
              //                                   Get.back();
              //                                 },
              //                                 child: Container(
              //                                   height: 20,
              //                                   width: 20,
              //                                   decoration: BoxDecoration(
              //                                       border: Border.all(
              //                                           width: 1,
              //                                           color: Constanst
              //                                               .onPrimary),
              //                                       borderRadius:
              //                                           BorderRadius.circular(
              //                                               10)),
              //                                   child: Padding(
              //                                     padding:
              //                                         const EdgeInsets.all(2),
              //                                     child: Container(
              //                                       decoration: BoxDecoration(
              //                                           borderRadius:
              //                                               BorderRadius
              //                                                   .circular(10)),
              //                                     ),
              //                                   ),
              //                                 ),
              //                               )
              //                       ],
              //                     ),
              //                   ),
              //                 )
              //               ],
              //             ),
              //           ),
              //         );
              //       },
              //     ).then((value) {
              //       print('Bottom sheet closed');
              //     });
              //   },
              //   child: Container(
              //     decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(100),
              //         border: Border.all(color: Constanst.border)),
              //     child: Padding(
              //       padding: const EdgeInsets.only(
              //           top: 8.0, bottom: 8.0, left: 12.0, right: 12.0),
              //       child: Row(
              //         children: [
              //           Row(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text(
              //                 controller.tempNamaTipe1.value,
              //                 style: GoogleFonts.inter(
              //                     color: Constanst.fgSecondary,
              //                     fontSize: 14,
              //                     fontWeight: FontWeight.w500),
              //               ),
              //               Padding(
              //                 padding: const EdgeInsets.only(left: 4),
              //                 child: Icon(
              //                   Iconsax.arrow_down_1,
              //                   color: Constanst.fgSecondary,
              //                   size: 18,
              //                 ),
              //               )
              //             ],
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              // const SizedBox(width: 4),
              InkWell(
                customBorder: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(100))),
                onTap: () {
                  DatePicker.showPicker(
                    Get.context!,
                    pickerModel: CustomMonthPicker(
                      minTime: DateTime(2000, 1, 1),
                      maxTime: DateTime(2100, 1, 1),
                      currentTime: DateTime(
                          int.parse(
                              controller.tahunSelectedSearchHistory.value),
                          int.parse(
                              controller.bulanSelectedSearchHistory.value),
                          1),
                    ),
                    onConfirm: (time) {
                      if (time != null) {
                        print("$time");
                        controller.filterLokasiKoordinate.value = "Lokasi";
                        controller.selectedViewFilterAbsen.value = 0;
                        var filter = DateFormat('yyyy-MM').format(time);
                        var array = filter.split('-');
                        var bulan = array[1];
                        var tahun = array[0];
                        controller.bulanSelectedSearchHistory.value = bulan;
                        controller.tahunSelectedSearchHistory.value = tahun;
                        controller.bulanDanTahunNow.value = "$bulan-$tahun";
                        this.controller.bulanSelectedSearchHistory.refresh();
                        this.controller.tahunSelectedSearchHistory.refresh();
                        this.controller.bulanDanTahunNow.refresh();

                        controller.dateLaporan.value = time;
                        controller.aksiCariLaporan();
                      }
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Constanst.border)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, bottom: 8.0, left: 12.0, right: 12.0),
                    child: Row(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Constanst.convertDateBulanDanTahun(
                                  controller.bulanDanTahunNow.value),
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
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              // Filter Cabang

              InkWell(
                customBorder: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(100))),
                onTap: () {
                  // controller.getBranch();
                  controller.showBottomBranch();
                },
                child: Container(
                  width: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Constanst.border)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, bottom: 8.0, left: 12.0, right: 12.0),
                    child: Row(
                      children: [
                        Obx(
                          () => Expanded(
                            child: Text(
                              controller.filterBranch.value,
                              style: GoogleFonts.inter(
                                  color: Constanst.fgSecondary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Icon(
                            Iconsax.arrow_down_1,
                            color: Constanst.fgSecondary,
                            size: 18,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              InkWell(
                customBorder: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(100))),
                onTap: () {
                  controller.showDataDepartemenAkses('semua');
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Constanst.border)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, bottom: 8.0, left: 12.0, right: 12.0),
                    child: Row(children: [
                      Text(
                        controller.departemen.value.text,
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
                      )
                    ]),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              InkWell(
                customBorder: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(100))),
                onTap: () {
                  controller.showDataLokasiKoordinate();
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Constanst.border)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, bottom: 8.0, left: 12.0, right: 12.0),
                    child: Row(
                      children: [
                        Obx(
                          () => Text(
                            controller.filterLokasiKoordinate.value,
                            style: GoogleFonts.inter(
                                color: Constanst.fgSecondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Icon(
                            Iconsax.arrow_down_1,
                            color: Constanst.fgSecondary,
                            size: 18,
                          ),
                        )
                      ],
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

  Widget pencarianData() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: Constanst.borderStyle5,
          border: Border.all(color: Constanst.colorText2)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 15,
            child: Padding(
              padding: const EdgeInsets.only(top: 7, left: 10),
              child: Icon(Iconsax.search_normal_1),
            ),
          ),
          Expanded(
            flex: 85,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: SizedBox(
                height: 40,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 85,
                      child: TextField(
                        controller: controller.cari.value,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Cari Nama Karyawan"),
                        style: TextStyle(
                            fontSize: 14.0, height: 1.0, color: Colors.black),
                        onChanged: (value) {
                          controller.pencarianNamaKaryawan(value);
                        },
                      ),
                    ),
                    !controller.statusCari.value
                        ? SizedBox()
                        : Expanded(
                            flex: 15,
                            child: IconButton(
                              icon: Icon(
                                Iconsax.close_circle,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                controller.statusCari.value = false;
                                controller.cari.value.text = "";

                                controller.listLaporanFilter.value =
                                    controller.allListLaporanFilter.value;
                                this.controller.listLaporanFilter.refresh();

                                controller.listLaporanBelumAbsen.value =
                                    controller.allListLaporanBelumAbsen.value;
                                this.controller.listLaporanBelumAbsen.refresh();

                                controller.listEmployeeTelat.value =
                                    controller.alllistEmployeeTelat.value;
                                this.controller.listEmployeeTelat.refresh();

                                controller.groupData();
                              },
                            ),
                          )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget listAbsensiKaryawan() {
    // groupData();

    return ListView.builder(
        physics: controller.listLaporanFilter.length <= 15
            ? const AlwaysScrollableScrollPhysics()
            : const BouncingScrollPhysics(),
        itemCount: controller.listLaporanFilter.length,
        itemBuilder: (context, index) {
          var fullName = controller.listLaporanFilter[index]['full_name'] ?? "";
          var namaKaryawan = "$fullName";
          var jobTitle = controller.listLaporanFilter[index]['job_title'];
          var emId = controller.listLaporanFilter[index]['em_id'];
          var attenDate = controller.listLaporanFilter[index]['atten_date'];
          var signinTime = controller.listLaporanFilter[index]['signin_time'];
          var signoutTime = controller.listLaporanFilter[index]['signout_time'];
          var signNote = controller.listLaporanFilter[index]['signin_note'];
          var image = controller.listLaporanFilter.value[index]['image'];
          var regType = controller.listLaporanFilter.value[index]['regtype'];
          print(controller.listLaporanFilter[index]['data']);
          return
              // controller.listLaporanFilter[index]['data'].toList().length <=
              //         1
              //     ?
              Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: InkWell(
              customBorder: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              onTap: () {
                Get.to(LaporanAbsenKaryawan(
                  em_id: emId,
                  bulan: controller.bulanDanTahunNow.value,
                  full_name: namaKaryawan,
                ));
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Constanst.colorNonAktif)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 12, right: 12, top: 8, bottom: 4),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  image == ""
                                      ? SvgPicture.asset(
                                          'assets/avatar_default.svg',
                                          width: 48,
                                          height: 48,
                                        )
                                      : Center(
                                          child: CircleAvatar(
                                            radius: 24,
                                            child: ClipOval(
                                              child: ClipOval(
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      "${Api.UrlfotoProfile}$image",
                                                  progressIndicatorBuilder:
                                                      (context, url,
                                                              downloadProgress) =>
                                                          Container(
                                                    alignment: Alignment.center,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.5,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child:
                                                        CircularProgressIndicator(
                                                            value:
                                                                downloadProgress
                                                                    .progress),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Container(
                                                    color: Colors.white,
                                                    child: SvgPicture.asset(
                                                      'assets/avatar_default.svg',
                                                      width: 48,
                                                      height: 48,
                                                    ),
                                                  ),
                                                  fit: BoxFit.cover,
                                                  width: 48,
                                                  height: 48,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(namaKaryawan,
                                            style: GoogleFonts.inter(
                                                color: Constanst.fgPrimary,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500)),
                                        const SizedBox(height: 4),
                                        Text(
                                          '$jobTitle',
                                          style: GoogleFonts.inter(
                                              color: Constanst.fgSecondary,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 18,
                              color: Constanst.fgSecondary,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Constanst.colorNeutralBgSecondary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    Constanst.convertDate5("$attenDate"),
                                    style: GoogleFonts.inter(
                                        color: Constanst.fgPrimary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    // regType == 0
                                    //     ? "Face Recognition"
                                    //     : "Photo",
                                    "Face Recognition",
                                    style: GoogleFonts.inter(
                                        color: Constanst.fgSecondary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              Container(
                                width: 2,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Constanst.colorNeutralBgTertiary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Iconsax.login_1,
                                    color: Constanst.color5,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        signinTime == "00:00:00" ||
                                                signinTime == "null"
                                            ? '$signNote'
                                            : '$signinTime',
                                        style: GoogleFonts.inter(
                                            color: Constanst.fgPrimary,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        "Absen Masuk",
                                        style: GoogleFonts.inter(
                                            color: Constanst.fgSecondary,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                width: 2,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Constanst.colorNeutralBgTertiary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Iconsax.logout_14,
                                    color: Constanst.color4,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        // signoutTime == "00:00:00" ||
                                        //         signoutTime == "null"
                                        //     ? ""
                                        //     : '$signoutTime',
                                        '$signoutTime',
                                        style: GoogleFonts.inter(
                                            color: Constanst.fgPrimary,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        "Absen Keluar",
                                        style: GoogleFonts.inter(
                                            color: Constanst.fgSecondary,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
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
            ),
          );
          // : Padding(
          //     padding: EdgeInsets.only(top: 10),
          //     child: Column(
          //       children: [
          //         Padding(
          //           padding: EdgeInsets.only(top: 10),
          //           child: Container(
          //             decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.only(
          //                     bottomLeft:
          //                         controller.listLaporanFilter[index]
          //                                     ['is_open'] ==
          //                                 true
          //                             ? Radius.circular(0)
          //                             : Radius.circular(10),
          //                     bottomRight:
          //                         controller.listLaporanFilter[index]
          //                                     ['is_open'] ==
          //                                 true
          //                             ? Radius.circular(0)
          //                             : Radius.circular(10),
          //                     topLeft: Radius.circular(10),
          //                     topRight: Radius.circular(10)),
          //                 border:
          //                     Border.all(width: 1, color: Constanst.grey)),
          //             child: Padding(
          //               padding: EdgeInsets.all(5),
          //               child: InkWell(
          //                 onTap: () {
          //                   // groupData();
          //                   // setState(() {
          //                   controller.listLaporanFilter[index]['is_open'] =
          //                       !controller.listLaporanFilter[index]
          //                           ['is_open'];
          //                   //  });

          //                   // this.listLaporanFilter.refresh();
          //                   controller.listLaporanFilter.refresh();
          //                   controller.statusCari.refresh();
          //                 },
          //                 child: Column(
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     SizedBox(
          //                       height: 10,
          //                     ),
          //                     IntrinsicHeight(
          //                       child: Row(
          //                         mainAxisAlignment:
          //                             MainAxisAlignment.spaceBetween,
          //                         children: [
          //                           Container(
          //                             width: MediaQuery.of(Get.context!)
          //                                         .size
          //                                         .width /
          //                                     2 -
          //                                 60,
          //                             child: Column(
          //                               crossAxisAlignment:
          //                                   CrossAxisAlignment.start,
          //                               children: [
          //                                 Text(
          //                                   '$namaKaryawan',
          //                                   style: TextStyle(fontSize: 12),
          //                                 ),
          //                               ],
          //                             ),
          //                           ),
          //                           Container(
          //                             child: Row(
          //                               children: [
          //                                 Container(
          //                                   width:
          //                                       MediaQuery.of(Get.context!)
          //                                               .size
          //                                               .width /
          //                                           3,
          //                                   child: Text(
          //                                     '$jobTitle',
          //                                     style:
          //                                         TextStyle(fontSize: 12),
          //                                     textAlign: TextAlign.right,
          //                                   ),
          //                                 ),
          //                                 SizedBox(
          //                                   width: 20,
          //                                 ),
          //                                 controller.listLaporanFilter[
          //                                         index]['is_open']
          //                                     ? Center(
          //                                         child: Transform.rotate(
          //                                           angle: -math.pi / 2,
          //                                           child: Icon(
          //                                             Icons
          //                                                 .arrow_back_ios_new_rounded,
          //                                             size: 12,
          //                                           ),
          //                                         ),
          //                                         // child: Icon(
          //                                         //   Icons.arrow_forward_ios_rounded,
          //                                         //   size: 14,
          //                                         // ),
          //                                       )
          //                                     : Center(
          //                                         child: Transform.rotate(
          //                                           angle: -math.pi / 2,
          //                                           child: Icon(
          //                                             Icons
          //                                                 .arrow_forward_ios_rounded,
          //                                             size: 12,
          //                                           ),
          //                                         ),
          //                                         // child: Icon(
          //                                         //   Icons.arrow_forward_ios_rounded,
          //                                         //   size: 14,
          //                                         // ),
          //                                       ),
          //                               ],
          //                             ),
          //                           ),
          //                         ],
          //                       ),
          //                     ),
          //                     SizedBox(
          //                       height: 8,
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         controller.listLaporanFilter[index]['is_open'] == true
          //             ? Container(
          //                 decoration: BoxDecoration(
          //                     borderRadius: BorderRadius.only(
          //                         bottomLeft: Radius.circular(10),
          //                         bottomRight: Radius.circular(10)),
          //                     border: Border.all(
          //                         width: 1, color: Constanst.grey)),
          //                 child: Column(
          //                   children: List.generate(
          //                       controller
          //                           .listLaporanFilter.value[index]['data']
          //                           .toList()
          //                           .length, (index1) {
          //                     var idAbsen = controller.listLaporanFilter
          //                         .value[index]['data'][index1]['id'];
          //                     var jamMasuk =
          //                         controller.listLaporanFilter.value[index]
          //                             ['data'][index1]['signin_time'];
          //                     var jamKeluar =
          //                         controller.listLaporanFilter.value[index]
          //                             ['data'][index1]['signout_time'];
          //                     var tanggal =
          //                         controller.listLaporanFilter.value[index]
          //                             ['data'][index1]['atten_date'];
          //                     var longLatAbsenKeluar =
          //                         controller.listLaporanFilter.value[index]
          //                             ['data'][index1]['signout_longlat'];

          //                     var placeIn = controller.listLaporanFilter
          //                         .value[index]['data'][index1]['place_in'];
          //                     var placeOut =
          //                         controller.listLaporanFilter.value[index]
          //                             ['data'][index1]['place_out'];

          //                     var note =
          //                         controller.listLaporanFilter.value[index]
          //                             ['data'][index1]['signin_note'];

          //                     var signInLongLat =
          //                         controller.listLaporanFilter.value[index]
          //                             ['data'][index1]['signin_longlat'];

          //                     var signOutLongLat =
          //                         controller.listLaporanFilter.value[index]
          //                             ['data'][index1]['signout_longlat'];

          //                     var statusView = placeIn == "pengajuan" &&
          //                             placeOut == "pengajuan" &&
          //                             signInLongLat == "pengajuan" &&
          //                             signOutLongLat == "pengajuan"
          //                         ? true
          //                         : false;

          //                     var listJamMasuk = (jamMasuk!.split(':'));
          //                     var listJamKeluar = (jamKeluar!.split(':'));
          //                     var perhitunganJamMasuk1 = 830 -
          //                         int.parse(
          //                             "${listJamMasuk[0]}${listJamMasuk[1]}");
          //                     var perhitunganJamMasuk2 = 1800 -
          //                         int.parse(
          //                             "${listJamKeluar[0]}${listJamKeluar[1]}");

          //                     var getColorMasuk;
          //                     var getColorKeluar;

          //                     if (perhitunganJamMasuk1 < 0) {
          //                       getColorMasuk = Colors.red;
          //                     } else {
          //                       getColorMasuk = Colors.black;
          //                     }
          //                     if (perhitunganJamMasuk2 == 0) {
          //                       getColorKeluar = Colors.black;
          //                     } else if (perhitunganJamMasuk2 > 0) {
          //                       getColorKeluar = Colors.red;
          //                     } else if (perhitunganJamMasuk2 < 0) {
          //                       getColorKeluar = Constanst.colorPrimary;
          //                     }
          //                     return Container(
          //                       padding: EdgeInsets.all(5),
          //                       child: InkWell(
          //                         onTap: () {
          //                           controller.loadAbsenDetail(
          //                               idAbsen, attenDate, fullName);
          //                           print(idAbsen);
          //                           // controller.historySelected1(
          //                           //     idAbsen.toString(),
          //                           //     "laporan",
          //                           //     index,
          //                           //     index1);

          //                           // if (statusView == false) {
          //                           //   controller.historySelected(
          //                           //       idAbsen.toString(), "laporan");
          //                           // }
          //                         },
          //                         child: Column(
          //                           crossAxisAlignment:
          //                               CrossAxisAlignment.start,
          //                           children: [
          //                             SizedBox(
          //                               height: 10,
          //                             ),
          //                             statusView == false
          //                                 ? Row(
          //                                     crossAxisAlignment:
          //                                         CrossAxisAlignment.end,
          //                                     children: [
          //                                       Expanded(
          //                                         flex: 40,
          //                                         child: Text(
          //                                           "${Constanst.convertDate(tanggal)}",
          //                                           style: TextStyle(
          //                                               fontSize: 12),
          //                                         ),
          //                                       ),
          //                                       Expanded(
          //                                         flex: 25,
          //                                         child: Container(
          //                                           padding:
          //                                               EdgeInsets.all(5),
          //                                           decoration: BoxDecoration(
          //                                               borderRadius:
          //                                                   BorderRadius
          //                                                       .circular(
          //                                                           10),
          //                                               color:
          //                                                   Constanst.grey),
          //                                           child: Row(
          //                                             children: [
          //                                               Icon(
          //                                                 Icons
          //                                                     .login_rounded,
          //                                                 color:
          //                                                     Colors.black,
          //                                                 size: 14,
          //                                               ),
          //                                               Padding(
          //                                                 padding: EdgeInsets
          //                                                     .only(
          //                                                         left: 8),
          //                                                 child: Text(
          //                                                   jamMasuk,
          //                                                   style: TextStyle(
          //                                                       color: Colors
          //                                                           .black,
          //                                                       fontSize:
          //                                                           10),
          //                                                 ),
          //                                               )
          //                                             ],
          //                                           ),
          //                                         ),
          //                                       ),
          //                                       SizedBox(
          //                                         width: 5,
          //                                       ),
          //                                       longLatAbsenKeluar == ""
          //                                           ? Container(
          //                                               child: Expanded(
          //                                                   flex: 25,
          //                                                   child:
          //                                                       Container()),
          //                                             )
          //                                           : Expanded(
          //                                               flex: 25,
          //                                               child: Container(
          //                                                 padding:
          //                                                     EdgeInsets
          //                                                         .all(5),
          //                                                 decoration: BoxDecoration(
          //                                                     borderRadius:
          //                                                         BorderRadius
          //                                                             .circular(
          //                                                                 10),
          //                                                     color:
          //                                                         Constanst
          //                                                             .grey),
          //                                                 child: Row(
          //                                                   children: [
          //                                                     Icon(
          //                                                       Icons
          //                                                           .logout_rounded,
          //                                                       color: Colors
          //                                                           .black,
          //                                                       size: 14,
          //                                                     ),
          //                                                     Flexible(
          //                                                       child:
          //                                                           Padding(
          //                                                         padding: EdgeInsets.only(
          //                                                             left:
          //                                                                 8),
          //                                                         child: longLatAbsenKeluar ==
          //                                                                 ""
          //                                                             ? Text(
          //                                                                 "",
          //                                                                 style: TextStyle(
          //                                                                   color: Colors.black,
          //                                                                   fontSize: 10,
          //                                                                 ))
          //                                                             : Text(
          //                                                                 jamKeluar,
          //                                                                 style: TextStyle(
          //                                                                   color: Colors.black,
          //                                                                   fontSize: 10,
          //                                                                 ),
          //                                                               ),
          //                                                       ),
          //                                                     )
          //                                                   ],
          //                                                 ),
          //                                               ),
          //                                             ),
          //                                       // Expanded(
          //                                       //   flex: 10,
          //                                       //   child: Padding(
          //                                       //     padding:
          //                                       //         const EdgeInsets.only(
          //                                       //             top: 4),
          //                                       //     child: Icon(
          //                                       //       Icons
          //                                       //           .arrow_forward_ios_rounded,
          //                                       //       size: 14,
          //                                       //     ),
          //                                       //   ),
          //                                       // ),
          //                                     ],
          //                                   )
          //                                 : Row(
          //                                     crossAxisAlignment:
          //                                         CrossAxisAlignment.start,
          //                                     children: [
          //                                       Expanded(
          //                                         flex: 40,
          //                                         child: Text(
          //                                           "${Constanst.convertDate(tanggal ?? '')}",
          //                                           style: TextStyle(
          //                                               fontSize: 14),
          //                                         ),
          //                                       ),
          //                                       Expanded(
          //                                         flex: 60,
          //                                         child: Row(
          //                                           mainAxisAlignment:
          //                                               MainAxisAlignment
          //                                                   .center,
          //                                           crossAxisAlignment:
          //                                               CrossAxisAlignment
          //                                                   .center,
          //                                           children: [
          //                                             Text(
          //                                               "$note",
          //                                               style: TextStyle(
          //                                                   fontWeight:
          //                                                       FontWeight
          //                                                           .bold),
          //                                             )
          //                                           ],
          //                                         ),
          //                                       ),
          //                                     ],
          //                                   ),
          //                             SizedBox(
          //                               height: 8,
          //                             ),
          //                             index1 <=
          //                                     controller.listLaporanFilter
          //                                             .value[index]['data']
          //                                             .toList()
          //                                             .length -
          //                                         2
          //                                 ? Divider(
          //                                     height: 3,
          //                                     color: Constanst.grey,
          //                                   )
          //                                 : Container(),
          //                           ],
          //                         ),
          //                       ),
          //                     );
          //                   }),
          //                 ),
          //               )
          //             : Container(),
          //       ],
          //     ),
          //   );
        });
  }

  Widget listAbsensiKaryawanBelumAbsen() {
    // groupData();
    return ListView.builder(
        physics: controller.listLaporanBelumAbsen.length <= 15
            ? const AlwaysScrollableScrollPhysics()
            : const BouncingScrollPhysics(),
        itemCount: controller.listLaporanBelumAbsen.length,
        itemBuilder: (context, index) {
          var fullName =
              controller.listLaporanBelumAbsen[index]['full_name'] ?? "";
          var namaKaryawan = "$fullName";
          var jobTitle = controller.listLaporanBelumAbsen[index]['job_title'];
          var emId = controller.listLaporanBelumAbsen[index]['em_id'];
          var attenDate = controller.listLaporanBelumAbsen[index]['atten_date'];
          var signinTime =
              controller.listLaporanBelumAbsen[index]['signin_time'];
          var signoutTime =
              controller.listLaporanBelumAbsen[index]['signout_time'];
          var signNote = controller.listLaporanBelumAbsen[index]['signin_note'];
          var image = (index < controller.listLaporanFilter.length &&
                  controller.listLaporanFilter[index] != null &&
                  controller.listLaporanFilter[index]['image'] != null)
              ? controller.listLaporanFilter[index]['image']
              : '';
          // var image = controller.listLaporanFilter.value[index]['image'];
          print(controller.listLaporanBelumAbsen[index]['data']);
          return
              // controller.listLaporanBelumAbsen[index]['data']
              //             .toList()
              //             .length <=
              //         1
              //     ?
              Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: InkWell(
              customBorder: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              onTap: () {
                Get.to(LaporanAbsenKaryawan(
                  em_id: emId,
                  bulan: controller.bulanDanTahunNow.value,
                  full_name: namaKaryawan,
                ));
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Constanst.colorNonAktif)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 12, right: 12, top: 8, bottom: 4),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  image == ""
                                      ? SvgPicture.asset(
                                          'assets/avatar_default.svg',
                                          width: 48,
                                          height: 48,
                                        )
                                      : Center(
                                          child: CircleAvatar(
                                            radius: 24,
                                            child: ClipOval(
                                              child: ClipOval(
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      "${Api.UrlfotoProfile}$image",
                                                  progressIndicatorBuilder:
                                                      (context, url,
                                                              downloadProgress) =>
                                                          Container(
                                                    alignment: Alignment.center,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.5,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child:
                                                        CircularProgressIndicator(
                                                            value:
                                                                downloadProgress
                                                                    .progress),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Container(
                                                    color: Colors.white,
                                                    child: SvgPicture.asset(
                                                      'assets/avatar_default.svg',
                                                      width: 48,
                                                      height: 48,
                                                    ),
                                                  ),
                                                  fit: BoxFit.cover,
                                                  width: 48,
                                                  height: 48,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(namaKaryawan,
                                            style: GoogleFonts.inter(
                                                color: Constanst.fgPrimary,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500)),
                                        const SizedBox(height: 4),
                                        Text(
                                          '$jobTitle',
                                          style: GoogleFonts.inter(
                                              color: Constanst.fgSecondary,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 18,
                              color: Constanst.fgSecondary,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Constanst.colorNeutralBgSecondary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    attenDate == null
                                        ? "-"
                                        : Constanst.convertDate5("$attenDate"),
                                    style: GoogleFonts.inter(
                                        color: Constanst.fgPrimary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    // regType == 0
                                    //     ? "Face Recognition"
                                    //     : "Photo",
                                    "Face Recognition",
                                    style: GoogleFonts.inter(
                                        color: Constanst.fgSecondary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              Container(
                                width: 2,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Constanst.colorNeutralBgTertiary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Iconsax.login_1,
                                    color: Constanst.color5,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        signinTime == "00:00:00" ||
                                                signinTime == null ||
                                                signinTime == "null"
                                            ? "_ _:_ _:_ _"
                                            : signinTime,
                                        style: GoogleFonts.inter(
                                            color: Constanst.fgPrimary,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        "Absen Masuk",
                                        style: GoogleFonts.inter(
                                            color: Constanst.fgSecondary,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                width: 2,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Constanst.colorNeutralBgTertiary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Iconsax.logout_14,
                                    color: Constanst.color4,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        signoutTime == "00:00:00" ||
                                                signoutTime == null ||
                                                signoutTime == "null"
                                            ? "_ _:_ _:_ _"
                                            : signoutTime,
                                        style: GoogleFonts.inter(
                                            color: Constanst.fgPrimary,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        "Absen Keluar",
                                        style: GoogleFonts.inter(
                                            color: Constanst.fgSecondary,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
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
            ),
          );
          // : Padding(
          //     padding: EdgeInsets.only(top: 10),
          //     child: Column(
          //       children: [
          //         Padding(
          //           padding: EdgeInsets.only(top: 10),
          //           child: Container(
          //             decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.only(
          //                     bottomLeft:
          //                         controller.listLaporanBelumAbsen[index]
          //                                     ['is_open'] ==
          //                                 true
          //                             ? Radius.circular(0)
          //                             : Radius.circular(10),
          //                     bottomRight:
          //                         controller.listLaporanBelumAbsen[index]
          //                                     ['is_open'] ==
          //                                 true
          //                             ? Radius.circular(0)
          //                             : Radius.circular(10),
          //                     topLeft: Radius.circular(10),
          //                     topRight: Radius.circular(10)),
          //                 border:
          //                     Border.all(width: 1, color: Constanst.grey)),
          //             child: Padding(
          //               padding: EdgeInsets.all(5),
          //               child: InkWell(
          //                 onTap: () {
          //                   // groupData();
          //                   // setState(() {
          //                   controller.listLaporanBelumAbsen[index]
          //                           ['is_open'] =
          //                       !controller.listLaporanBelumAbsen[index]
          //                           ['is_open'];
          //                   //  });

          //                   // this.listLaporanBelumAbsen.refresh();
          //                   controller.listLaporanBelumAbsen.refresh();
          //                   controller.statusCari.refresh();
          //                 },
          //                 child: Column(
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     SizedBox(
          //                       height: 10,
          //                     ),
          //                     IntrinsicHeight(
          //                       child: Row(
          //                         mainAxisAlignment:
          //                             MainAxisAlignment.spaceBetween,
          //                         children: [
          //                           Container(
          //                             width: MediaQuery.of(Get.context!)
          //                                         .size
          //                                         .width /
          //                                     2 -
          //                                 60,
          //                             child: Column(
          //                               crossAxisAlignment:
          //                                   CrossAxisAlignment.start,
          //                               children: [
          //                                 Text(
          //                                   '$namaKaryawan',
          //                                   style: TextStyle(fontSize: 12),
          //                                 ),
          //                               ],
          //                             ),
          //                           ),
          //                           Container(
          //                             child: Row(
          //                               children: [
          //                                 Container(
          //                                   width:
          //                                       MediaQuery.of(Get.context!)
          //                                               .size
          //                                               .width /
          //                                           3,
          //                                   child: Text(
          //                                     '$jobTitle',
          //                                     style:
          //                                         TextStyle(fontSize: 12),
          //                                     textAlign: TextAlign.right,
          //                                   ),
          //                                 ),
          //                                 SizedBox(
          //                                   width: 20,
          //                                 ),
          //                                 controller.listLaporanBelumAbsen[
          //                                         index]['is_open']
          //                                     ? Center(
          //                                         child: Transform.rotate(
          //                                           angle: -math.pi / 2,
          //                                           child: Icon(
          //                                             Icons
          //                                                 .arrow_back_ios_new_rounded,
          //                                             size: 12,
          //                                           ),
          //                                         ),
          //                                         // child: Icon(
          //                                         //   Icons.arrow_forward_ios_rounded,
          //                                         //   size: 14,
          //                                         // ),
          //                                       )
          //                                     : Center(
          //                                         child: Transform.rotate(
          //                                           angle: -math.pi / 2,
          //                                           child: Icon(
          //                                             Icons
          //                                                 .arrow_forward_ios_rounded,
          //                                             size: 12,
          //                                           ),
          //                                         ),
          //                                         // child: Icon(
          //                                         //   Icons.arrow_forward_ios_rounded,
          //                                         //   size: 14,
          //                                         // ),
          //                                       ),
          //                               ],
          //                             ),
          //                           ),
          //                         ],
          //                       ),
          //                     ),
          //                     SizedBox(
          //                       height: 8,
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         controller.listLaporanBelumAbsen[index]['is_open'] == true
          //             ? Container(
          //                 decoration: BoxDecoration(
          //                     borderRadius: BorderRadius.only(
          //                         bottomLeft: Radius.circular(10),
          //                         bottomRight: Radius.circular(10)),
          //                     border: Border.all(
          //                         width: 1, color: Constanst.grey)),
          //                 child: Column(
          //                   children: List.generate(
          //                       controller.listLaporanBelumAbsen
          //                           .value[index]['data']
          //                           .toList()
          //                           .length, (index1) {
          //                     var idAbsen = controller.listLaporanBelumAbsen
          //                         .value[index]['data'][index1]['id'];
          //                     var jamMasuk = controller
          //                             .listLaporanBelumAbsen.value[index]
          //                         ['data'][index1]['signin_time'];
          //                     var jamKeluar = controller
          //                             .listLaporanBelumAbsen.value[index]
          //                         ['data'][index1]['signout_time'];
          //                     var tanggal = controller
          //                             .listLaporanBelumAbsen.value[index]
          //                         ['data'][index1]['atten_date'];
          //                     var longLatAbsenKeluar = controller
          //                             .listLaporanBelumAbsen.value[index]
          //                         ['data'][index1]['signout_longlat'];

          //                     var placeIn = controller.listLaporanBelumAbsen
          //                         .value[index]['data'][index1]['place_in'];
          //                     var placeOut = controller
          //                             .listLaporanBelumAbsen.value[index]
          //                         ['data'][index1]['place_out'];

          //                     var note = controller
          //                             .listLaporanBelumAbsen.value[index]
          //                         ['data'][index1]['signin_note'];

          //                     var signInLongLat = controller
          //                             .listLaporanBelumAbsen.value[index]
          //                         ['data'][index1]['signin_longlat'];

          //                     var signOutLongLat = controller
          //                             .listLaporanBelumAbsen.value[index]
          //                         ['data'][index1]['signout_longlat'];

          //                     var statusView = placeIn == "pengajuan" &&
          //                             placeOut == "pengajuan" &&
          //                             signInLongLat == "pengajuan" &&
          //                             signOutLongLat == "pengajuan"
          //                         ? true
          //                         : false;

          //                     var listJamMasuk = (jamMasuk!.split(':'));
          //                     var listJamKeluar = (jamKeluar!.split(':'));
          //                     var perhitunganJamMasuk1 = 830 -
          //                         int.parse(
          //                             "${listJamMasuk[0]}${listJamMasuk[1]}");
          //                     var perhitunganJamMasuk2 = 1800 -
          //                         int.parse(
          //                             "${listJamKeluar[0]}${listJamKeluar[1]}");

          //                     var getColorMasuk;
          //                     var getColorKeluar;

          //                     if (perhitunganJamMasuk1 < 0) {
          //                       getColorMasuk = Colors.red;
          //                     } else {
          //                       getColorMasuk = Colors.black;
          //                     }
          //                     if (perhitunganJamMasuk2 == 0) {
          //                       getColorKeluar = Colors.black;
          //                     } else if (perhitunganJamMasuk2 > 0) {
          //                       getColorKeluar = Colors.red;
          //                     } else if (perhitunganJamMasuk2 < 0) {
          //                       getColorKeluar = Constanst.colorPrimary;
          //                     }
          //                     return Container(
          //                       padding: EdgeInsets.all(5),
          //                       child: InkWell(
          //                         onTap: () {
          //                           controller.loadAbsenDetail(
          //                               idAbsen, attenDate, fullName);
          //                           print(idAbsen);
          //                           // controller.historySelected1(
          //                           //     idAbsen.toString(),
          //                           //     "laporan",
          //                           //     index,
          //                           //     index1);

          //                           // if (statusView == false) {
          //                           //   controller.historySelected(
          //                           //       idAbsen.toString(), "laporan");
          //                           // }
          //                         },
          //                         child: Column(
          //                           crossAxisAlignment:
          //                               CrossAxisAlignment.start,
          //                           children: [
          //                             SizedBox(
          //                               height: 10,
          //                             ),
          //                             statusView == false
          //                                 ? Row(
          //                                     crossAxisAlignment:
          //                                         CrossAxisAlignment.end,
          //                                     children: [
          //                                       Expanded(
          //                                         flex: 40,
          //                                         child: Text(
          //                                           "${Constanst.convertDate(tanggal)}",
          //                                           style: TextStyle(
          //                                               fontSize: 12),
          //                                         ),
          //                                       ),
          //                                       Expanded(
          //                                         flex: 25,
          //                                         child: Container(
          //                                           padding:
          //                                               EdgeInsets.all(5),
          //                                           decoration: BoxDecoration(
          //                                               borderRadius:
          //                                                   BorderRadius
          //                                                       .circular(
          //                                                           10),
          //                                               color:
          //                                                   Constanst.grey),
          //                                           child: Row(
          //                                             children: [
          //                                               Icon(
          //                                                 Icons
          //                                                     .login_rounded,
          //                                                 color:
          //                                                     Colors.black,
          //                                                 size: 14,
          //                                               ),
          //                                               Padding(
          //                                                 padding: EdgeInsets
          //                                                     .only(
          //                                                         left: 8),
          //                                                 child: Text(
          //                                                   jamMasuk,
          //                                                   style: TextStyle(
          //                                                       color: Colors
          //                                                           .black,
          //                                                       fontSize:
          //                                                           10),
          //                                                 ),
          //                                               )
          //                                             ],
          //                                           ),
          //                                         ),
          //                                       ),
          //                                       SizedBox(
          //                                         width: 5,
          //                                       ),
          //                                       longLatAbsenKeluar == ""
          //                                           ? Container(
          //                                               child: Expanded(
          //                                                   flex: 25,
          //                                                   child:
          //                                                       Container()),
          //                                             )
          //                                           : Expanded(
          //                                               flex: 25,
          //                                               child: Container(
          //                                                 padding:
          //                                                     EdgeInsets
          //                                                         .all(5),
          //                                                 decoration: BoxDecoration(
          //                                                     borderRadius:
          //                                                         BorderRadius
          //                                                             .circular(
          //                                                                 10),
          //                                                     color:
          //                                                         Constanst
          //                                                             .grey),
          //                                                 child: Row(
          //                                                   children: [
          //                                                     Icon(
          //                                                       Icons
          //                                                           .logout_rounded,
          //                                                       color: Colors
          //                                                           .black,
          //                                                       size: 14,
          //                                                     ),
          //                                                     Flexible(
          //                                                       child:
          //                                                           Padding(
          //                                                         padding: EdgeInsets.only(
          //                                                             left:
          //                                                                 8),
          //                                                         child: longLatAbsenKeluar ==
          //                                                                 ""
          //                                                             ? Text(
          //                                                                 "",
          //                                                                 style: TextStyle(
          //                                                                   color: Colors.black,
          //                                                                   fontSize: 10,
          //                                                                 ))
          //                                                             : Text(
          //                                                                 jamKeluar,
          //                                                                 style: TextStyle(
          //                                                                   color: Colors.black,
          //                                                                   fontSize: 10,
          //                                                                 ),
          //                                                               ),
          //                                                       ),
          //                                                     )
          //                                                   ],
          //                                                 ),
          //                                               ),
          //                                             ),
          //                                       // Expanded(
          //                                       //   flex: 10,
          //                                       //   child: Padding(
          //                                       //     padding:
          //                                       //         const EdgeInsets.only(
          //                                       //             top: 4),
          //                                       //     child: Icon(
          //                                       //       Icons
          //                                       //           .arrow_forward_ios_rounded,
          //                                       //       size: 14,
          //                                       //     ),
          //                                       //   ),
          //                                       // ),
          //                                     ],
          //                                   )
          //                                 : Row(
          //                                     crossAxisAlignment:
          //                                         CrossAxisAlignment.start,
          //                                     children: [
          //                                       Expanded(
          //                                         flex: 40,
          //                                         child: Text(
          //                                           "${Constanst.convertDate(tanggal ?? '')}",
          //                                           style: TextStyle(
          //                                               fontSize: 14),
          //                                         ),
          //                                       ),
          //                                       Expanded(
          //                                         flex: 60,
          //                                         child: Row(
          //                                           mainAxisAlignment:
          //                                               MainAxisAlignment
          //                                                   .center,
          //                                           crossAxisAlignment:
          //                                               CrossAxisAlignment
          //                                                   .center,
          //                                           children: [
          //                                             Text(
          //                                               "$note",
          //                                               style: TextStyle(
          //                                                   fontWeight:
          //                                                       FontWeight
          //                                                           .bold),
          //                                             )
          //                                           ],
          //                                         ),
          //                                       ),
          //                                     ],
          //                                   ),
          //                             SizedBox(
          //                               height: 8,
          //                             ),
          //                             index1 <=
          //                                     controller
          //                                             .listLaporanBelumAbsen
          //                                             .value[index]['data']
          //                                             .toList()
          //                                             .length -
          //                                         2
          //                                 ? Divider(
          //                                     height: 3,
          //                                     color: Constanst.grey,
          //                                   )
          //                                 : Container(),
          //                           ],
          //                         ),
          //                       ),
          //                     );
          //                   }),
          //                 ),
          //               )
          //             : Container(),
          //       ],
          //     ),
          //   );
        });
  }

  Widget listAbsensiKaryawanTerlambat() {
    // groupData();
    return ListView.builder(
        physics: controller.listEmployeeTelat.length <= 15
            ? AlwaysScrollableScrollPhysics()
            : BouncingScrollPhysics(),
        itemCount: controller.listEmployeeTelat.length,
        itemBuilder: (context, index) {
          var fullName = controller.listEmployeeTelat[index]['full_name'] ?? "";
          var namaKaryawan = "$fullName";
          var jobTitle = controller.listEmployeeTelat[index]['job_title'];
          var emId = controller.listEmployeeTelat[index]['em_id'];
          var attenDate = controller.listEmployeeTelat[index]['atten_date'];
          var signinTime = controller.listEmployeeTelat[index]['signin_time'];
          var signoutTime = controller.listEmployeeTelat[index]['signout_time'];
          var signNote = controller.listEmployeeTelat[index]['signin_note'];
          print(controller.listEmployeeTelat[index]['data']);
          return
              // controller.listEmployeeTelat[index]['data']
              //             .toList()
              //             .length <=
              //         1
              //     ?
              Padding(
            padding: EdgeInsets.only(top: 10),
            child: InkWell(
              onTap: () {
                Get.to(LaporanAbsenKaryawan(
                  em_id: emId,
                  bulan: controller.bulanDanTahunNow.value,
                  full_name: namaKaryawan,
                ));
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 1, color: Constanst.grey)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$namaKaryawan',
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                '$jobTitle',
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // Text(
                                  //   "${Constanst.convertDate("$attenDate")}",
                                  //   style: TextStyle(fontSize: 12),
                                  // ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  signinTime == "00:00:00" ||
                                          signinTime == "null"
                                      ? Text(
                                          '$signNote',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold),
                                        )
                                      : Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 3, right: 3),
                                              child: Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Constanst.grey),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.login_rounded,
                                                      color: Constanst.color2,
                                                      size: 14,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 3),
                                                      child: Text(
                                                        '$signinTime',
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color: Constanst
                                                                .color2),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            signoutTime == "00:00:00" ||
                                                    signoutTime == "null"
                                                ? SizedBox()
                                                : Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 3, right: 3),
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color:
                                                              Constanst.grey),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .logout_rounded,
                                                            color: Constanst
                                                                .color2,
                                                            size: 12,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 3),
                                                            child: Text(
                                                              '$signoutTime',
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  color: Constanst
                                                                      .color2),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                          ],
                                        ),
                                ],
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 14,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ),
          );
          // : Padding(
          //     padding: EdgeInsets.only(top: 10),
          //     child: Column(
          //       children: [
          //         Padding(
          //           padding: EdgeInsets.only(top: 10),
          //           child: Container(
          //             decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.only(
          //                     bottomLeft:
          //                         controller.listEmployeeTelat[index]
          //                                     ['is_open'] ==
          //                                 true
          //                             ? Radius.circular(0)
          //                             : Radius.circular(10),
          //                     bottomRight:
          //                         controller.listEmployeeTelat[index]
          //                                     ['is_open'] ==
          //                                 true
          //                             ? Radius.circular(0)
          //                             : Radius.circular(10),
          //                     topLeft: Radius.circular(10),
          //                     topRight: Radius.circular(10)),
          //                 border:
          //                     Border.all(width: 1, color: Constanst.grey)),
          //             child: Padding(
          //               padding: EdgeInsets.all(5),
          //               child: InkWell(
          //                 onTap: () {
          //                   // groupData();
          //                   // setState(() {
          //                   controller.listEmployeeTelat[index]
          //                           ['is_open'] =
          //                       !controller.listEmployeeTelat[index]
          //                           ['is_open'];
          //                   //  });

          //                   // this.listEmployeeTelat.refresh();
          //                   controller.listEmployeeTelat.refresh();
          //                   controller.statusCari.refresh();
          //                 },
          //                 child: Column(
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     SizedBox(
          //                       height: 10,
          //                     ),
          //                     IntrinsicHeight(
          //                       child: Row(
          //                         mainAxisAlignment:
          //                             MainAxisAlignment.spaceBetween,
          //                         children: [
          //                           Container(
          //                             width: MediaQuery.of(Get.context!)
          //                                         .size
          //                                         .width /
          //                                     2 -
          //                                 60,
          //                             child: Column(
          //                               crossAxisAlignment:
          //                                   CrossAxisAlignment.start,
          //                               children: [
          //                                 Text(
          //                                   '$namaKaryawan',
          //                                   style: TextStyle(fontSize: 12),
          //                                 ),
          //                               ],
          //                             ),
          //                           ),
          //                           Container(
          //                             child: Row(
          //                               children: [
          //                                 Container(
          //                                   width:
          //                                       MediaQuery.of(Get.context!)
          //                                               .size
          //                                               .width /
          //                                           3,
          //                                   child: Text(
          //                                     '$jobTitle',
          //                                     style:
          //                                         TextStyle(fontSize: 12),
          //                                     textAlign: TextAlign.right,
          //                                   ),
          //                                 ),
          //                                 SizedBox(
          //                                   width: 20,
          //                                 ),
          //                                 controller.listEmployeeTelat[
          //                                         index]['is_open']
          //                                     ? Center(
          //                                         child: Transform.rotate(
          //                                           angle: -math.pi / 2,
          //                                           child: Icon(
          //                                             Icons
          //                                                 .arrow_back_ios_new_rounded,
          //                                             size: 12,
          //                                           ),
          //                                         ),
          //                                         // child: Icon(
          //                                         //   Icons.arrow_forward_ios_rounded,
          //                                         //   size: 14,
          //                                         // ),
          //                                       )
          //                                     : Center(
          //                                         child: Transform.rotate(
          //                                           angle: -math.pi / 2,
          //                                           child: Icon(
          //                                             Icons
          //                                                 .arrow_forward_ios_rounded,
          //                                             size: 12,
          //                                           ),
          //                                         ),
          //                                         // child: Icon(
          //                                         //   Icons.arrow_forward_ios_rounded,
          //                                         //   size: 14,
          //                                         // ),
          //                                       ),
          //                               ],
          //                             ),
          //                           ),
          //                         ],
          //                       ),
          //                     ),
          //                     SizedBox(
          //                       height: 8,
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         controller.listEmployeeTelat[index]['is_open'] == true
          //             ? Container(
          //                 decoration: BoxDecoration(
          //                     borderRadius: BorderRadius.only(
          //                         bottomLeft: Radius.circular(10),
          //                         bottomRight: Radius.circular(10)),
          //                     border: Border.all(
          //                         width: 1, color: Constanst.grey)),
          //                 child: Column(
          //                   children: List.generate(
          //                       controller.listEmployeeTelat
          //                           .value[index]['data']
          //                           .toList()
          //                           .length, (index1) {
          //                     var idAbsen = controller.listEmployeeTelat
          //                         .value[index]['data'][index1]['id'];
          //                     var jamMasuk = controller
          //                             .listEmployeeTelat.value[index]
          //                         ['data'][index1]['signin_time'];
          //                     var jamKeluar = controller
          //                             .listEmployeeTelat.value[index]
          //                         ['data'][index1]['signout_time'];
          //                     var tanggal = controller
          //                             .listEmployeeTelat.value[index]
          //                         ['data'][index1]['atten_date'];
          //                     var longLatAbsenKeluar = controller
          //                             .listEmployeeTelat.value[index]
          //                         ['data'][index1]['signout_longlat'];

          //                     var placeIn = controller.listEmployeeTelat
          //                         .value[index]['data'][index1]['place_in'];
          //                     var placeOut = controller
          //                             .listEmployeeTelat.value[index]
          //                         ['data'][index1]['place_out'];

          //                     var note = controller
          //                             .listEmployeeTelat.value[index]
          //                         ['data'][index1]['signin_note'];

          //                     var signInLongLat = controller
          //                             .listEmployeeTelat.value[index]
          //                         ['data'][index1]['signin_longlat'];

          //                     var signOutLongLat = controller
          //                             .listEmployeeTelat.value[index]
          //                         ['data'][index1]['signout_longlat'];

          //                     var statusView = placeIn == "pengajuan" &&
          //                             placeOut == "pengajuan" &&
          //                             signInLongLat == "pengajuan" &&
          //                             signOutLongLat == "pengajuan"
          //                         ? true
          //                         : false;

          //                     var listJamMasuk = (jamMasuk!.split(':'));
          //                     var listJamKeluar = (jamKeluar!.split(':'));
          //                     var perhitunganJamMasuk1 = 830 -
          //                         int.parse(
          //                             "${listJamMasuk[0]}${listJamMasuk[1]}");
          //                     var perhitunganJamMasuk2 = 1800 -
          //                         int.parse(
          //                             "${listJamKeluar[0]}${listJamKeluar[1]}");

          //                     var getColorMasuk;
          //                     var getColorKeluar;

          //                     if (perhitunganJamMasuk1 < 0) {
          //                       getColorMasuk = Colors.red;
          //                     } else {
          //                       getColorMasuk = Colors.black;
          //                     }
          //                     if (perhitunganJamMasuk2 == 0) {
          //                       getColorKeluar = Colors.black;
          //                     } else if (perhitunganJamMasuk2 > 0) {
          //                       getColorKeluar = Colors.red;
          //                     } else if (perhitunganJamMasuk2 < 0) {
          //                       getColorKeluar = Constanst.colorPrimary;
          //                     }
          //                     return Container(
          //                       padding: EdgeInsets.all(5),
          //                       child: InkWell(
          //                         onTap: () {
          //                           controller.loadAbsenDetail(
          //                               idAbsen, attenDate, fullName);
          //                           print(idAbsen);
          //                           // controller.historySelected1(
          //                           //     idAbsen.toString(),
          //                           //     "laporan",
          //                           //     index,
          //                           //     index1);

          //                           // if (statusView == false) {
          //                           //   controller.historySelected(
          //                           //       idAbsen.toString(), "laporan");
          //                           // }
          //                         },
          //                         child: Column(
          //                           crossAxisAlignment:
          //                               CrossAxisAlignment.start,
          //                           children: [
          //                             SizedBox(
          //                               height: 10,
          //                             ),
          //                             statusView == false
          //                                 ? Row(
          //                                     crossAxisAlignment:
          //                                         CrossAxisAlignment.end,
          //                                     children: [
          //                                       Expanded(
          //                                         flex: 40,
          //                                         child: Text(
          //                                           "${Constanst.convertDate(tanggal)}",
          //                                           style: TextStyle(
          //                                               fontSize: 12),
          //                                         ),
          //                                       ),
          //                                       Expanded(
          //                                         flex: 25,
          //                                         child: Container(
          //                                           padding:
          //                                               EdgeInsets.all(5),
          //                                           decoration: BoxDecoration(
          //                                               borderRadius:
          //                                                   BorderRadius
          //                                                       .circular(
          //                                                           10),
          //                                               color:
          //                                                   Constanst.grey),
          //                                           child: Row(
          //                                             children: [
          //                                               Icon(
          //                                                 Icons
          //                                                     .login_rounded,
          //                                                 color:
          //                                                     Colors.black,
          //                                                 size: 14,
          //                                               ),
          //                                               Padding(
          //                                                 padding: EdgeInsets
          //                                                     .only(
          //                                                         left: 8),
          //                                                 child: Text(
          //                                                   jamMasuk,
          //                                                   style: TextStyle(
          //                                                       color: Colors
          //                                                           .black,
          //                                                       fontSize:
          //                                                           10),
          //                                                 ),
          //                                               )
          //                                             ],
          //                                           ),
          //                                         ),
          //                                       ),
          //                                       SizedBox(
          //                                         width: 5,
          //                                       ),
          //                                       longLatAbsenKeluar == ""
          //                                           ? Container(
          //                                               child: Expanded(
          //                                                   flex: 25,
          //                                                   child:
          //                                                       Container()),
          //                                             )
          //                                           : Expanded(
          //                                               flex: 25,
          //                                               child: Container(
          //                                                 padding:
          //                                                     EdgeInsets
          //                                                         .all(5),
          //                                                 decoration: BoxDecoration(
          //                                                     borderRadius:
          //                                                         BorderRadius
          //                                                             .circular(
          //                                                                 10),
          //                                                     color:
          //                                                         Constanst
          //                                                             .grey),
          //                                                 child: Row(
          //                                                   children: [
          //                                                     Icon(
          //                                                       Icons
          //                                                           .logout_rounded,
          //                                                       color: Colors
          //                                                           .black,
          //                                                       size: 14,
          //                                                     ),
          //                                                     Flexible(
          //                                                       child:
          //                                                           Padding(
          //                                                         padding: EdgeInsets.only(
          //                                                             left:
          //                                                                 8),
          //                                                         child: longLatAbsenKeluar ==
          //                                                                 ""
          //                                                             ? Text(
          //                                                                 "",
          //                                                                 style: TextStyle(
          //                                                                   color: Colors.black,
          //                                                                   fontSize: 10,
          //                                                                 ))
          //                                                             : Text(
          //                                                                 jamKeluar,
          //                                                                 style: TextStyle(
          //                                                                   color: Colors.black,
          //                                                                   fontSize: 10,
          //                                                                 ),
          //                                                               ),
          //                                                       ),
          //                                                     )
          //                                                   ],
          //                                                 ),
          //                                               ),
          //                                             ),
          //                                       // Expanded(
          //                                       //   flex: 10,
          //                                       //   child: Padding(
          //                                       //     padding:
          //                                       //         const EdgeInsets.only(
          //                                       //             top: 4),
          //                                       //     child: Icon(
          //                                       //       Icons
          //                                       //           .arrow_forward_ios_rounded,
          //                                       //       size: 14,
          //                                       //     ),
          //                                       //   ),
          //                                       // ),
          //                                     ],
          //                                   )
          //                                 : Row(
          //                                     crossAxisAlignment:
          //                                         CrossAxisAlignment.start,
          //                                     children: [
          //                                       Expanded(
          //                                         flex: 40,
          //                                         child: Text(
          //                                           "${Constanst.convertDate(tanggal ?? '')}",
          //                                           style: TextStyle(
          //                                               fontSize: 14),
          //                                         ),
          //                                       ),
          //                                       Expanded(
          //                                         flex: 60,
          //                                         child: Row(
          //                                           mainAxisAlignment:
          //                                               MainAxisAlignment
          //                                                   .center,
          //                                           crossAxisAlignment:
          //                                               CrossAxisAlignment
          //                                                   .center,
          //                                           children: [
          //                                             Text(
          //                                               "$note",
          //                                               style: TextStyle(
          //                                                   fontWeight:
          //                                                       FontWeight
          //                                                           .bold),
          //                                             )
          //                                           ],
          //                                         ),
          //                                       ),
          //                                     ],
          //                                   ),
          //                             SizedBox(
          //                               height: 8,
          //                             ),
          //                             index1 <=
          //                                     controller
          //                                             .listEmployeeTelat
          //                                             .value[index]['data']
          //                                             .toList()
          //                                             .length -
          //                                         2
          //                                 ? Divider(
          //                                     height: 3,
          //                                     color: Constanst.grey,
          //                                   )
          //                                 : Container(),
          //                           ],
          //                         ),
          //                       ),
          //                     );
          //                   }),
          //                 ),
          //               )
          //             : Container(),
          //       ],
          //     ),
          //   );
        });
  }

  Widget textSubmit() {
    return controller.statusLoadingSubmitLaporan.value == false
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Iconsax.search_normal_1,
                size: 18,
                color: Constanst.colorWhite,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Submit Data",
                  style: TextStyle(color: Constanst.colorWhite),
                ),
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Center(
                  child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.white,
                      )),
                ),
              )
            ],
          );
  }
}
