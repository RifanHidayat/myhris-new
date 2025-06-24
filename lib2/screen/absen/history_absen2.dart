// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:intl/intl.dart';
// import 'package:siscom_operasional/controller/absen_controller.dart';
// import 'package:flutter_speed_dial/flutter_speed_dial.dart';
// import 'package:siscom_operasional/screen/absen/camera_view.dart';
// import 'package:siscom_operasional/screen/absen/laporan/laporan_absen.dart';
// import 'package:siscom_operasional/screen/absen/laporan/laporan_absen_telat.dart';
// import 'package:siscom_operasional/screen/absen/laporan/laporan_belum_absen.dart';
// import 'package:siscom_operasional/screen/absen/pengajuan%20absen.dart';
// import 'package:siscom_operasional/screen/init_screen.dart';
// import 'package:siscom_operasional/utils/api.dart';
// import 'package:siscom_operasional/utils/appbar_widget.dart';
// import 'package:siscom_operasional/utils/constans.dart';
// import 'package:siscom_operasional/utils/month_year_picker.dart';

// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
// import 'package:siscom_operasional/utils/widget/text_labe.dart';
// import 'package:siscom_operasional/utils/widget_utils.dart';
// import 'package:url_launcher/url_launcher.dart';

// class HistoryAbsen extends StatefulWidget {
//   var dataForm;
//   HistoryAbsen({Key? key, this.dataForm}) : super(key: key);
//   @override
//   _HistoryAbsenState createState() => _HistoryAbsenState();
// }

// class _HistoryAbsenState extends State<HistoryAbsen> {
//   var controller = Get.find<AbsenController>();

//   @override
//   void initState() {
//     super.initState();
//     Api().checkLogin();
//     controller.loadHistoryAbsenUser();
//     controller.dataPengajuanAbsensi();
//   }

//   Future<void> refreshData() async {
//     await Future.delayed(const Duration(seconds: 2));
//     controller.onReady();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//           backgroundColor: Constanst.coloBackgroundScreen,
//           appBar: AppBar(
//             backgroundColor: Constanst.coloBackgroundScreen,
//             automaticallyImplyLeading: false,
//             elevation: 0,
//             title: Text(
//               "Absensi",
//               style: GoogleFonts.inter(
//                   color: Constanst.fgPrimary,
//                   fontWeight: FontWeight.w500,
//                   fontSize: 20),
//             ),
//             leading: IconButton(
//               icon: Icon(
//                 Iconsax.arrow_left,
//                 color: Constanst.fgPrimary,
//                 size: 24,
//               ),
//               onPressed: () {
//                 controller.removeAll();
//                 Get.offAll(InitScreen());
//               },
//             ),
//             actions: [
//               IconButton(
//                 icon: Icon(
//                   Iconsax.document_text,
//                   color: Constanst.fgPrimary,
//                   size: 24,
//                 ),
//                 onPressed: () {
//                   Get.to(LaporanAbsen(
//                     dataForm: "",
//                   ));
//                 },
//               ),
//             ],
//           ),
//           body: WillPopScope(
//             onWillPop: () async {
//               controller.removeAll();
//               Get.offAll(InitScreen());
//               return true;
//             },
//             child: SizedBox(
//               height: MediaQuery.of(context).size.height,
//               child: Column(
//                 children: [
//                   Obx(
//                     () => Expanded(
//                       child: SizedBox(
//                         height: double.maxFinite,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             TabBar(
//                               indicatorColor: Constanst.colorPrimary,
//                               labelColor: Constanst.colorPrimary,
//                               unselectedLabelColor: Constanst.fgSecondary,
//                               indicatorWeight: 4.0,
//                               labelPadding:
//                                   const EdgeInsets.fromLTRB(0, 14, 0, 14),
//                               indicatorSize: TabBarIndicatorSize.label,
//                               physics: const BouncingScrollPhysics(),
//                               tabs: [
//                                 Text("Absensi",
//                                     style: GoogleFonts.inter(
//                                         fontSize: 16.0,
//                                         fontWeight: FontWeight.w500)),
//                                 Text("Pengajuan",
//                                     style: GoogleFonts.inter(
//                                         fontSize: 16.0,
//                                         fontWeight: FontWeight.w500)),
//                               ],
//                             ),
//                             Divider(
//                               thickness: 1,
//                               height: 0,
//                               color: Constanst.fgBorder,
//                             ),
//                             Expanded(
//                                 child: Container(
//                               height: double.maxFinite,
//                               padding:
//                                   const EdgeInsets.only(left: 16, right: 16),
//                               child: TabBarView(
//                                   physics: const BouncingScrollPhysics(),
//                                   children: [
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         const SizedBox(height: 12.0),
//                                         Row(
//                                           children: [
//                                             Expanded(
//                                               flex: 9,
//                                               child: Container(
//                                                 decoration: BoxDecoration(
//                                                   color: Constanst.infoLight1,
//                                                   border: Border.all(
//                                                     color: Constanst
//                                                         .colorStateInfoBorder,
//                                                   ),
//                                                   borderRadius:
//                                                       const BorderRadius.all(
//                                                     Radius.circular(8.0),
//                                                   ),
//                                                 ),
//                                                 child: Padding(
//                                                   padding:
//                                                       const EdgeInsets.all(8.0),
//                                                   child: Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Text(
//                                                         "15",
//                                                         style:
//                                                             GoogleFonts.inter(
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w500,
//                                                                 fontSize: 16,
//                                                                 color: Constanst
//                                                                     .fgPrimary),
//                                                       ),
//                                                       const SizedBox(height: 4),
//                                                       Text(
//                                                         "Masuk Kerja",
//                                                         style: GoogleFonts.inter(
//                                                             fontWeight:
//                                                                 FontWeight.w400,
//                                                             fontSize: 12,
//                                                             color: Constanst
//                                                                 .fgSecondary),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             const SizedBox(width: 8),
//                                             Expanded(
//                                               flex: 9,
//                                               child: Container(
//                                                 decoration: BoxDecoration(
//                                                   color: Constanst.infoLight1,
//                                                   border: Border.all(
//                                                     color: Constanst
//                                                         .colorStateInfoBorder,
//                                                   ),
//                                                   borderRadius:
//                                                       const BorderRadius.all(
//                                                     Radius.circular(8.0),
//                                                   ),
//                                                 ),
//                                                 child: Padding(
//                                                   padding:
//                                                       const EdgeInsets.all(8.0),
//                                                   child: Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Text(
//                                                         "0",
//                                                         style:
//                                                             GoogleFonts.inter(
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w500,
//                                                                 fontSize: 16,
//                                                                 color: Constanst
//                                                                     .fgPrimary),
//                                                       ),
//                                                       const SizedBox(height: 4),
//                                                       Text(
//                                                         "Terlambat",
//                                                         style: GoogleFonts.inter(
//                                                             fontWeight:
//                                                                 FontWeight.w400,
//                                                             fontSize: 12,
//                                                             color: Constanst
//                                                                 .fgSecondary),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             const SizedBox(width: 8),
//                                             Expanded(
//                                               flex: 10,
//                                               child: Container(
//                                                 decoration: BoxDecoration(
//                                                   color: Constanst.infoLight1,
//                                                   border: Border.all(
//                                                     color: Constanst
//                                                         .colorStateInfoBorder,
//                                                   ),
//                                                   borderRadius:
//                                                       const BorderRadius.all(
//                                                     Radius.circular(8.0),
//                                                   ),
//                                                 ),
//                                                 child: Padding(
//                                                   padding:
//                                                       const EdgeInsets.all(8.0),
//                                                   child: Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Text(
//                                                         "5",
//                                                         style:
//                                                             GoogleFonts.inter(
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w500,
//                                                                 fontSize: 16,
//                                                                 color: Constanst
//                                                                     .fgPrimary),
//                                                       ),
//                                                       const SizedBox(height: 4),
//                                                       Text(
//                                                         "Tidak Absen Keluar",
//                                                         style: GoogleFonts.inter(
//                                                             fontWeight:
//                                                                 FontWeight.w400,
//                                                             fontSize: 12,
//                                                             color: Constanst
//                                                                 .fgSecondary),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         const SizedBox(height: 16),
//                                         controller.bulanDanTahunNow.value == ""
//                                             ? const SizedBox()
//                                             : pickDate(),
//                                         const SizedBox(height: 16),
//                                         // Row(
//                                         //   mainAxisAlignment:
//                                         //       MainAxisAlignment.start,
//                                         //   crossAxisAlignment:
//                                         //       CrossAxisAlignment.start,
//                                         //   children: [
//                                         //     Expanded(
//                                         //       flex: 85,
//                                         //       child: Padding(
//                                         //         padding: const EdgeInsets.only(
//                                         //             top: 8),
//                                         //         child: Text(
//                                         //           "Riwayat Absensi",
//                                         //           textAlign: TextAlign.left,
//                                         //           style: GoogleFonts.inter(
//                                         //               fontWeight:
//                                         //                   FontWeight.bold,
//                                         //               fontSize:
//                                         //                   Constanst.sizeTitle),
//                                         //         ),
//                                         //       ),
//                                         //     ),
//                                         //   ],
//                                         // ),
//                                         // SizedBox(height: 8),
//                                         Flexible(
//                                             child: RefreshIndicator(
//                                           onRefresh: refreshData,
//                                           child: controller
//                                                   .historyAbsen.value.isEmpty
//                                               ? Center(
//                                                   child: Text(
//                                                       controller.loading.value),
//                                                 )
//                                               : listAbsen(),
//                                         ))
//                                       ],
//                                     ),
//                                     Column(
//                                       children: [
//                                         const SizedBox(height: 16),
//                                         controller.bulanDanTahunNowPengajuan
//                                                     .value ==
//                                                 ""
//                                             ? const SizedBox()
//                                             : pickDateBulanDanTahun(),
//                                         const SizedBox(height: 16),
//                                         Flexible(
//                                             child: Obx(
//                                           () => RefreshIndicator(
//                                               onRefresh: refreshData,
//                                               color: Constanst.colorPrimary,
//                                               child: controller
//                                                       .pengajuanAbsensi.isEmpty
//                                                   ? Center(
//                                                       child: Text(controller
//                                                           .loadingPengajuan
//                                                           .value
//                                                           .toString()),
//                                                     )
//                                                   : listPengajuan()),
//                                         ))
//                                       ],
//                                     )
//                                   ]),
//                             ))
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//           floatingActionButton: Obx(
//             () => controller.showButtonlaporan.value == false
//                 ? SizedBox()
//                 : SpeedDial(
//                     icon: Iconsax.more,
//                     activeIcon: Icons.close,
//                     backgroundColor: Constanst.colorPrimary,
//                     spacing: 3,
//                     childPadding: const EdgeInsets.all(5),
//                     spaceBetweenChildren: 4,
//                     elevation: 8.0,
//                     animationCurve: Curves.elasticInOut,
//                     animationDuration: const Duration(milliseconds: 200),
//                     children: [
//                       SpeedDialChild(
//                           child: Icon(Iconsax.document_text),
//                           backgroundColor: Color(0xff2F80ED),
//                           foregroundColor: Colors.white,
//                           label: 'Pengajuan Absen',
//                           onTap: () {
//                             Get.to(pengajuanAbsen());
//                           }),
//                       SpeedDialChild(
//                           child: Icon(Iconsax.document_text),
//                           backgroundColor: Color(0xff2F80ED),
//                           foregroundColor: Colors.white,
//                           label: 'Laporan Absensi',
//                           onTap: () {
//                             Get.to(LaporanAbsen(
//                               dataForm: "",
//                             ));
//                           }),
//                       SpeedDialChild(
//                           child: Icon(Iconsax.minus_cirlce),
//                           backgroundColor: Color(0xffFF463D),
//                           foregroundColor: Colors.white,
//                           label: 'Absen Terlambat',
//                           onTap: () {
//                             Get.to(LaporanAbsenTelat(
//                               dataForm: "",
//                             ));
//                           }),
//                       SpeedDialChild(
//                           child: Icon(Iconsax.watch),
//                           backgroundColor: Color(0xffF2AA0D),
//                           foregroundColor: Colors.white,
//                           label: 'Belum Absen',
//                           onTap: () {
//                             Get.to(LaporanBelumAbsen(
//                               dataForm: "",
//                             ));
//                           }),
//                     ],
//                   ),
//           )),
//     );
//   }

//   Widget pickDate() {
//     DateTime getLastDayOfMonth(String dateString) {
//       // Parsing string menjadi objek DateTime
//       DateTime parsedDate = DateFormat("MM-yyyy").parseStrict(dateString);

//       // Menggunakan objek DateTime untuk mendapatkan hari terakhir dari bulan
//       return DateTime(parsedDate.year, parsedDate.month + 1, 0);
//     }

//     DateTime lastDayOfMonth =
//         getLastDayOfMonth(controller.bulanDanTahunNow.value);

//     return InkWell(
//       customBorder: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(12))),
//       onTap: () async {
//         print("kesini");
//         DatePicker.showPicker(
//           context,
//           pickerModel: CustomMonthPicker(
//             minTime: DateTime(2020, 1, 1),
//             maxTime: DateTime(2050, 1, 1),
//             currentTime: DateTime.now(),
//           ),
//           onConfirm: (time) {
//             if (time != null) {
//               print("$time");
//               var filter = DateFormat('yyyy-MM').format(time);
//               var array = filter.split('-');
//               var bulan = array[1];
//               var tahun = array[0];
//               controller.bulanSelectedSearchHistory.value = bulan;
//               controller.tahunSelectedSearchHistory.value = tahun;
//               controller.bulanDanTahunNow.value = "$bulan-$tahun";
//               this.controller.bulanSelectedSearchHistory.refresh();
//               this.controller.tahunSelectedSearchHistory.refresh();
//               this.controller.bulanDanTahunNow.refresh();
//               controller.loadHistoryAbsenUser();
//             }
//           },
//         );
//       },
//       child: Container(
//         decoration: BoxDecoration(
//             borderRadius: const BorderRadius.all(Radius.circular(12)),
//             border: Border.all(color: const Color(0xffD5DBE5))),
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(
//             12.0,
//             8.0,
//             12.0,
//             12.0,
//           ),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Periode",
//                     style: GoogleFonts.inter(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                         color: Constanst.fgPrimary),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     '${lastDayOfMonth.toLocal()}',
//                     style: GoogleFonts.inter(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w400,
//                         color: Constanst.fgSecondary),
//                   ),
//                 ],
//               ),
//               Container(
//                 alignment: Alignment.topRight,
//                 child: Padding(
//                   padding: const EdgeInsets.only(right: 10),
//                   child: Icon(
//                     Iconsax.arrow_down_1,
//                     size: 18,
//                     color: Constanst.fgSecondary,
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget pickDateBulanDanTahun() {
//     return Row(
//       children: [
//         InkWell(
//           customBorder: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(100))),
//           onTap: () async {
//             print("kesini");
//             DatePicker.showPicker(
//               context,
//               pickerModel: CustomMonthPicker(
//                 minTime: DateTime(2020, 1, 1),
//                 maxTime: DateTime(2050, 1, 1),
//                 currentTime: DateTime.now(),
//               ),
//               onConfirm: (time) {
//                 if (time != null) {
//                   print("$time");
//                   var filter = DateFormat('yyyy-MM').format(time);
//                   var array = filter.split('-');
//                   var bulan = array[1];
//                   var tahun = array[0];
//                   controller.bulanSelectedSearchHistoryPengajuan.value = bulan;
//                   controller.tahunSelectedSearchHistoryPengajuan.value = tahun;
//                   controller.bulanDanTahunNowPengajuan.value = "$bulan-$tahun";
//                   this.controller.bulanSelectedSearchHistoryPengajuan.refresh();
//                   this.controller.tahunSelectedSearchHistoryPengajuan.refresh();
//                   this.controller.bulanDanTahunNowPengajuan.refresh();
//                   controller.dataPengajuanAbsensi();
//                 }
//               },
//             );
//           },
//           child: Container(
//             decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: const BorderRadius.all(
//                   Radius.circular(100),
//                 ),
//                 border: Border.all(color: Constanst.fgBorder)),
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left: 10),
//                     child: Text(
//                       Constanst.convertDateBulanDanTahun(
//                           controller.bulanDanTahunNowPengajuan.value),
//                       style: GoogleFonts.inter(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 14,
//                           color: Constanst.fgSecondary),
//                     ),
//                   ),
//                   const SizedBox(width: 4),
//                   Icon(
//                     Iconsax.arrow_down_1,
//                     size: 18,
//                     color: Constanst.fgPrimary,
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 4),
//         // InkWell(
//         //   customBorder: const RoundedRectangleBorder(
//         //       borderRadius: BorderRadius.all(Radius.circular(100))),
//         //   onTap: () async {
//         //     print("kesini");
//         //     DatePicker.showPicker(
//         //       context,
//         //       pickerModel: CustomMonthPicker(
//         //         minTime: DateTime(2020, 1, 1),
//         //         maxTime: DateTime(2050, 1, 1),
//         //         currentTime: DateTime.now(),
//         //       ),
//         //       onConfirm: (time) {
//         //         if (time != null) {
//         //           print("$time");
//         //           var filter = DateFormat('yyyy-MM').format(time);
//         //           var array = filter.split('-');
//         //           var bulan = array[1];
//         //           var tahun = array[0];
//         //           controller.bulanSelectedSearchHistoryPengajuan.value = bulan;
//         //           controller.tahunSelectedSearchHistoryPengajuan.value = tahun;
//         //           controller.bulanDanTahunNowPengajuan.value = "$bulan-$tahun";
//         //           this.controller.bulanSelectedSearchHistoryPengajuan.refresh();
//         //           this.controller.tahunSelectedSearchHistoryPengajuan.refresh();
//         //           this.controller.bulanDanTahunNowPengajuan.refresh();
//         //           controller.dataPengajuanAbsensi();
//         //         }
//         //       },
//         //     );
//         //   },
//         //   child: Container(
//         //     decoration: BoxDecoration(
//         //         color: Colors.white,
//         //         borderRadius: const BorderRadius.all(
//         //           Radius.circular(100),
//         //         ),
//         //         border: Border.all(color: Constanst.fgBorder)),
//         //     child: Padding(
//         //       padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
//         //       child: Row(
//         //         crossAxisAlignment: CrossAxisAlignment.start,
//         //         children: [
//         //           Padding(
//         //             padding: const EdgeInsets.only(left: 10),
//         //             child: Text(
//         //               Constanst.convertDateBulanDanTahun(
//         //                   controller.bulanDanTahunNowPengajuan.value),
//         //               style: GoogleFonts.inter(
//         //                   fontWeight: FontWeight.w500,
//         //                   fontSize: 14,
//         //                   color: Constanst.fgSecondary),
//         //             ),
//         //           ),
//         //           const SizedBox(width: 4),
//         //           Icon(
//         //             Iconsax.arrow_down_1,
//         //             size: 18,
//         //             color: Constanst.fgPrimary,
//         //           )
//         //         ],
//         //       ),
//         //     ),
//         //   ),
//         // ),
//       ],
//     );
//   }

//   Widget listAbsen() {
//     return ListView.builder(
//         physics: controller.historyAbsenShow.value.length <= 10
//             ? const AlwaysScrollableScrollPhysics()
//             : const BouncingScrollPhysics(),
//         itemCount: controller.historyAbsenShow.value.length,
//         itemBuilder: (context, index) {
//           var jamMasuk =
//               controller.historyAbsenShow.value[index]['signin_time'] ?? '';
//           var jamKeluar =
//               controller.historyAbsenShow.value[index]['signout_time'] ?? '';
//           var placeIn =
//               controller.historyAbsenShow.value[index]['place_in'] ?? '';
//           var placeOut =
//               controller.historyAbsenShow.value[index]['place_out'] ?? '';
//           var note =
//               controller.historyAbsenShow.value[index]['signin_note'] ?? '';
//           var signInLongLat =
//               controller.historyAbsenShow.value[index]['signin_longlat'] ?? '';
//           var signOutLongLat =
//               controller.historyAbsenShow.value[index]['signout_longlat'] ?? '';
//           var reqType =
//               controller.historyAbsenShow.value[index]['reg_type'] ?? '';

//           var statusView;
//           var listJamMasuk;
//           var listJamKeluar;
//           var perhitunganJamMasuk1;
//           var perhitunganJamMasuk2;
//           var getColorMasuk;
//           var getColorKeluar;

//           if (placeIn != "") {
//             statusView = placeIn == "pengajuan" &&
//                     placeOut == "pengajuan" &&
//                     signInLongLat == "pengajuan" &&
//                     signOutLongLat == "pengajuan"
//                 ? true
//                 : false;
//           }
//           if (controller.historyAbsenShow.value[index]['view_turunan'] ==
//               false) {
//             listJamMasuk = (jamMasuk!.split(':'));
//             listJamKeluar = (jamKeluar!.split(':'));
//             perhitunganJamMasuk1 =
//                 830 - int.parse("${listJamMasuk[0]}${listJamMasuk[1]}");
//             perhitunganJamMasuk2 =
//                 1800 - int.parse("${listJamKeluar[0]}${listJamKeluar[1]}");

//             if (perhitunganJamMasuk1 < 0) {
//               getColorMasuk = Colors.red;
//             } else {
//               getColorMasuk = Colors.black;
//             }

//             if (perhitunganJamMasuk2 == 0) {
//               getColorKeluar = Colors.black;
//             } else if (perhitunganJamMasuk2 > 0) {
//               getColorKeluar = Colors.red;
//             } else if (perhitunganJamMasuk2 < 0) {
//               getColorKeluar = Constanst.colorPrimary;
//             }
//           } else {}

//           return InkWell(
//               onTap: () {
//                 controller.showTurunan(
//                     controller.historyAbsenShow.value[index]['atten_date']);
//                 if (controller.historyAbsenShow.value[index]['view_turunan'] ==
//                     false) {
//                   controller.historySelected(
//                       controller.historyAbsen.value[index].id, 'history');
//                 }
//               },
//               child: controller.historyAbsenShow.value[index]['view_turunan'] ==
//                       true
//                   ? tampilan1(controller.historyAbsenShow.value[index])
//                   : tampilan2(controller.historyAbsenShow.value[index]));
//         });
//   }

//   Widget listPengajuan() {
//     return ListView.builder(
//         physics: controller.pengajuanAbsensi.value.length <= 10
//             ? const AlwaysScrollableScrollPhysics()
//             : const BouncingScrollPhysics(),
//         itemCount: controller.pengajuanAbsensi.value.length,
//         itemBuilder: (context, index) {
//           var data = controller.pengajuanAbsensi[index];

//           // Parse the input date string
//           DateTime atten_date =
//               DateFormat('yyyy-MM-dd').parse(data['atten_date']);
//           // Format the date using the Indonesian month format
//           String formatAttenDate =
//               DateFormat('dd MMM yyyy', 'id').format(atten_date);

//           return Container(
//             padding: const EdgeInsets.only(bottom: 16),
//             child: InkWell(
//               customBorder: const RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(12))),
//               onTap: () {
//                 showBottomDetailPengajuan(context, index);
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(width: 1, color: Constanst.fgBorder)),
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       TextLabell(
//                         text: formatAttenDate,
//                         weight: FontWeight.w500,
//                         size: 16.0,
//                         color: Constanst.fgPrimary,
//                       ),
//                       const SizedBox(height: 4),
//                       TextLabell(
//                         text: data['nomor_ajuan'],
//                         weight: FontWeight.w400,
//                         size: 16.0,
//                         color: Constanst.fgSecondary,
//                       ),
//                       const SizedBox(height: 4),
//                       TextLabell(
//                         text:
//                             "Absen Masuk Tanggal $formatAttenDate, ${data['dari_jam']}",
//                         color: Constanst.fgSecondary,
//                         size: 13.0,
//                         weight: FontWeight.w400,
//                       ),
//                       TextLabell(
//                         text:
//                             "Absen Keluar Tanggal $formatAttenDate, ${data['sampai_jam']}",
//                         color: Constanst.fgSecondary,
//                         size: 13.0,
//                         weight: FontWeight.w400,
//                       ),
//                       const SizedBox(height: 12),
//                       Divider(
//                         height: 0,
//                         thickness: 1,
//                         color: Constanst.fgBorder,
//                       ),
//                       const SizedBox(height: 8),
//                       data['status'].toString().toLowerCase() ==
//                               "approve".toLowerCase()
//                           ? Row(
//                               children: [
//                                 const Icon(
//                                   Iconsax.tick_circle,
//                                   size: 20,
//                                   color: Colors.green,
//                                 ),
//                                 const SizedBox(width: 8),
//                                 TextLabell(
//                                   text: "Approved by ${data['approve_by']}",
//                                   color: Constanst.fgPrimary,
//                                   weight: FontWeight.w500,
//                                   size: 14,
//                                 )
//                               ],
//                             )
//                           : data['status'].toString().toLowerCase() ==
//                                   "rejected".toLowerCase()
//                               ? Row(
//                                   children: [
//                                     const Icon(
//                                       Iconsax.close_circle,
//                                       size: 20,
//                                       color: Colors.red,
//                                     ),
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             TextLabell(
//                                               text:
//                                                   "Rejected by ${data['approve_by']}",
//                                               color: Constanst.fgPrimary,
//                                               weight: FontWeight.w500,
//                                               size: 14,
//                                             ),
//                                             const SizedBox(height: 4),
//                                             TextLabell(
//                                               text: "${data['alasan_reject']}",
//                                               color: Constanst.fgSecondary,
//                                               weight: FontWeight.w400,
//                                               size: 14,
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     )
//                                   ],
//                                 )
//                               : Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Icon(
//                                       Iconsax.timer,
//                                       size: 20,
//                                       color: Constanst.warning,
//                                     ),
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Padding(
//                                           padding:
//                                               const EdgeInsets.only(left: 8.0),
//                                           child: TextLabell(
//                                             text: "Pending Approval",
//                                             color: Constanst.fgPrimary,
//                                             weight: FontWeight.w500,
//                                             size: 14,
//                                           ),
//                                         ),
//                                         InkWell(
//                                           onTap: () => print('object'),
//                                           customBorder:
//                                               const RoundedRectangleBorder(
//                                                   borderRadius:
//                                                       BorderRadius.all(
//                                                           Radius.circular(
//                                                               100))),
//                                           child: Padding(
//                                             padding: const EdgeInsets.fromLTRB(
//                                                 8.0, 4.0, 8.0, 4.0),
//                                             child: TextLabell(
//                                               text: "Konfirmasi via Whatsapp",
//                                               color: Constanst.infoLight,
//                                               weight: FontWeight.w400,
//                                               size: 14,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     )
//                                   ],
//                                 )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         });
//   }

//   Widget tampilan1(index) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(
//           height: 10,
//         ),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               flex: 90,
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 6),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("${Constanst.convertDate('${index['atten_date']}')}",
//                         style: GoogleFonts.inter(
//                             fontSize: 14, fontWeight: FontWeight.bold)),
//                     // index['status_view'] == true
//                     //     ? Text(
//                     //         "${index['turunan'][0]['reg_type'] == 0 ? "Face Recognition" : "Photo"}",
//                     //         style: GoogleFonts.inter(
//                     //           fontSize: 9,
//                     //         ))
//                     //     : Text(
//                     //         " ${index['reg_type'] == 0 ? "Face Recognition" : ""}",
//                     //         style: GoogleFonts.inter(
//                     //           fontSize: 9,
//                     //         )),
//                   ],
//                 ),
//               ),
//             ),
//             Expanded(
//                 flex: 10,
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 6.0),
//                   child: index['status_view'] == false
//                       ? Icon(
//                           Icons.arrow_forward_ios_rounded,
//                           size: 14,
//                         )
//                       : Icon(
//                           Iconsax.arrow_down,
//                           size: 14,
//                         ),
//                 ))
//           ],
//         ),
//         SizedBox(
//           height: 16,
//         ),
//         Divider(
//           height: 3,
//           color: Colors.grey,
//         ),
//         index['status_view'] == false
//             ? SizedBox()
//             : listTurunanHistoryAbsen(index['turunan']),
//       ],
//     );
//   }

//   Widget tampilan2(index) {
//     var jamMasuk = index['signin_time'] ?? '';
//     var jamKeluar = index['signout_time'] ?? '';
//     var placeIn = index['place_in'] ?? '';
//     var placeOut = index['place_out'] ?? '';
//     var note = index['signin_note'] ?? '';
//     var signInLongLat = index['signin_longlat'] ?? '';
//     var signOutLongLat = index['signout_longlat'] ?? '';
//     var regType = index['regtype'] ?? 0;
//     var statusView;
//     if (placeIn != "") {
//       statusView =
//           placeIn == "pengajuan" && placeOut == "pengajuan" ? true : false;
//     }
//     var listJamMasuk = (jamMasuk!.split(':'));
//     var listJamKeluar = (jamKeluar!.split(':'));
//     var perhitunganJamMasuk1 =
//         830 - int.parse("${listJamMasuk[0]}${listJamMasuk[1]}");
//     var perhitunganJamMasuk2 =
//         1800 - int.parse("${listJamKeluar[0]}${listJamKeluar[1]}");
//     var getColorMasuk;
//     var getColorKeluar;

//     if (perhitunganJamMasuk1 < 0) {
//       getColorMasuk = Colors.red;
//     } else {
//       getColorMasuk = Colors.black;
//     }

//     if (perhitunganJamMasuk2 == 0) {
//       getColorKeluar = Colors.black;
//     } else if (perhitunganJamMasuk2 > 0) {
//       getColorKeluar = Colors.red;
//     } else if (perhitunganJamMasuk2 < 0) {
//       getColorKeluar = Constanst.colorPrimary;
//     }
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8.0),
//       child: InkWell(
//         customBorder: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(12))),
//         onTap: () {
//           if (statusView == false) {
//             controller.historySelected(index['id'], 'history');
//           }
//         },
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             statusView == false
//                 ? Container(
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         border:
//                             Border.all(width: 1, color: Constanst.fgBorder)),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           flex: 15,
//                           child: Padding(
//                             padding: const EdgeInsets.all(4.0),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: Constanst.colorNeutralBgSecondary,
//                                 borderRadius: const BorderRadius.only(
//                                   topLeft: Radius.circular(8.0),
//                                   bottomLeft: Radius.circular(8.0),
//                                 ),
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.only(
//                                     top: 5.0, bottom: 5.0),
//                                 child: Column(
//                                   children: [
//                                     Text(
//                                         DateFormat('d').format(
//                                             DateFormat('yyyy-MM-dd')
//                                                 .parse(index['atten_date'])),
//                                         style: GoogleFonts.inter(
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.w500,
//                                           color: Constanst.fgPrimary,
//                                         )),
//                                     Text(
//                                         DateFormat('EEEE', 'id').format(
//                                             DateFormat('yyyy-MM-dd')
//                                                 .parse(index['atten_date'])),
//                                         style: GoogleFonts.inter(
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.w400,
//                                           color: Constanst.fgSecondary,
//                                         )),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 38,
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 8.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 Icon(
//                                   Iconsax.login_1,
//                                   color: Constanst.color5,
//                                   size: 16,
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 4),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         "$jamMasuk",
//                                         style: GoogleFonts.inter(
//                                             color: Constanst.fgPrimary,
//                                             fontWeight: FontWeight.w500,
//                                             fontSize: 16),
//                                       ),
//                                       const SizedBox(height: 4),
//                                       Text(
//                                         regType == 0
//                                             ? "Face Recognition"
//                                             : "Photo",
//                                         style: GoogleFonts.inter(
//                                             color: Constanst.fgSecondary,
//                                             fontWeight: FontWeight.w400,
//                                             fontSize: 10),
//                                       ),
//                                     ],
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 38,
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 4),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 Icon(
//                                   Iconsax.logout_14,
//                                   color: Constanst.color4,
//                                   size: 16,
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 4),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         "$jamKeluar",
//                                         style: GoogleFonts.inter(
//                                             color: Constanst.fgPrimary,
//                                             fontWeight: FontWeight.w500,
//                                             fontSize: 16),
//                                       ),
//                                       const SizedBox(height: 4),
//                                       Text(
//                                         regType == 0
//                                             ? "Face Recognition"
//                                             : "Photo",
//                                         style: GoogleFonts.inter(
//                                             color: Constanst.fgSecondary,
//                                             fontWeight: FontWeight.w400,
//                                             fontSize: 10),
//                                       ),
//                                     ],
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 9,
//                           child: Icon(
//                             Icons.arrow_forward_ios_rounded,
//                             size: 16,
//                             color: Constanst.colorNeutralFgTertiary,
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                 : Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Expanded(
//                               flex: 50,
//                               child: Text(
//                                   "${Constanst.convertDate('${index['atten_date']}')}",
//                                   style: GoogleFonts.inter(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.bold)),
//                             ),
//                             Expanded(
//                               flex: 50,
//                               child: Text(
//                                 "${note}".toLowerCase(),
//                                 style: GoogleFonts.inter(
//                                     color: Constanst.colorText3),
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget listTurunanHistoryAbsen(indexData) {
//     return ListView.builder(
//         itemCount: indexData.length,
//         shrinkWrap: true,
//         physics: NeverScrollableScrollPhysics(),
//         scrollDirection: Axis.vertical,
//         itemBuilder: (context, index) {
//           var jamMasuk = indexData[index]['signin_time'] ?? '';
//           var jamKeluar = indexData[index]['signout_time'] ?? '';
//           var placeIn = indexData[index]['place_in'] ?? '';
//           var placeOut = indexData[index]['place_out'] ?? '';
//           var note = indexData[index]['signin_note'] ?? '';
//           var signInLongLat = indexData[index]['signin_longlat'] ?? '';
//           var signOutLongLat = indexData[index]['signout_longlat'] ?? '';
//           var regType = indexData[index]['reg_type'] ?? '';
//           var statusView;
//           if (placeIn != "") {
//             statusView = placeIn == "pengajuan" && placeOut == "pengajuan"
//                 ? true
//                 : false;
//           }
//           var listJamMasuk = (jamMasuk!.split(':'));
//           var listJamKeluar = (jamKeluar!.split(':'));
//           var perhitunganJamMasuk1 =
//               830 - int.parse("${listJamMasuk[0]}${listJamMasuk[1]}");
//           var perhitunganJamMasuk2 =
//               1800 - int.parse("${listJamKeluar[0]}${listJamKeluar[1]}");
//           var getColorMasuk;
//           var getColorKeluar;

//           if (perhitunganJamMasuk1 < 0) {
//             getColorMasuk = Colors.red;
//           } else {
//             getColorMasuk = Colors.black;
//           }

//           if (perhitunganJamMasuk2 == 0) {
//             getColorKeluar = Colors.black;
//           } else if (perhitunganJamMasuk2 > 0) {
//             getColorKeluar = Colors.red;
//           } else if (perhitunganJamMasuk2 < 0) {
//             getColorKeluar = Constanst.colorPrimary;
//           }
//           return InkWell(
//             onTap: () {
//               if (statusView == false) {
//                 controller.historySelected(indexData[index]['id'], 'history');
//               }
//             },
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 SizedBox(
//                   height: 16,
//                 ),
//                 statusView == false
//                     ? Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Expanded(
//                                 flex: 45,
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(left: 20),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         children: [
//                                           Icon(
//                                             Icons.login_rounded,
//                                             color: getColorMasuk,
//                                             size: 14,
//                                           ),
//                                           Padding(
//                                             padding: EdgeInsets.only(left: 8),
//                                             child: Text(
//                                               "${jamMasuk}",
//                                               style: GoogleFonts.inter(
//                                                   color: getColorMasuk,
//                                                   fontSize: 14),
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                       Text(
//                                           " ${regType == 0 ? "Face Recognition" : "Photo"}",
//                                           style: GoogleFonts.inter(
//                                             fontSize: 9,
//                                           )),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 flex: 45,
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Icon(
//                                       Icons.logout_rounded,
//                                       color: getColorKeluar,
//                                       size: 14,
//                                     ),
//                                     Flexible(
//                                       child: Padding(
//                                         padding: EdgeInsets.only(left: 8),
//                                         child: signInLongLat == ""
//                                             ? Text("")
//                                             : Text(
//                                                 "${jamKeluar}",
//                                                 style: GoogleFonts.inter(
//                                                     color: getColorKeluar,
//                                                     fontSize: 14),
//                                               ),
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                               Expanded(
//                                 flex: 10,
//                                 child: Icon(
//                                   Icons.arrow_forward_ios_rounded,
//                                   size: 14,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       )
//                     : Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Expanded(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   "${note}".toLowerCase(),
//                                   style: GoogleFonts.inter(
//                                       color: Constanst.colorText3),
//                                 )
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                 SizedBox(
//                   height: 16,
//                 ),
//                 Divider(
//                   height: 3,
//                   color: Colors.grey,
//                 ),
//               ],
//             ),
//           );
//         });
//   }

//   void showBottomDetailPengajuan(BuildContext context, index) {
//     var data = controller.pengajuanAbsensi[index];
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(16.0),
//         ),
//       ),
//       isScrollControlled: true,
//       builder: (BuildContext context) {
//         return SafeArea(
//           child: SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                     child: Container(
//                       decoration: BoxDecoration(
//                           color: Constanst.colorNeutralBgTertiary,
//                           borderRadius: BorderRadius.circular(100)),
//                       width: 32,
//                       height: 6,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   Column(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(
//                                 width: 1, color: Constanst.fgBorder)),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               flex: 1,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   TextLabell(
//                                     text: "No. Pengajuan",
//                                     color: Constanst.fgSecondary,
//                                     size: 14,
//                                     weight: FontWeight.w400,
//                                   ),
//                                   const SizedBox(height: 4),
//                                   TextLabell(
//                                     text: data['nomor_ajuan'],
//                                     color: Constanst.fgPrimary,
//                                     size: 16,
//                                     weight: FontWeight.w500,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Expanded(
//                               flex: 1,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   TextLabell(
//                                     text: "Tanggal Pengajuan",
//                                     color: Constanst.fgSecondary,
//                                     size: 14,
//                                     weight: FontWeight.w400,
//                                   ),
//                                   const SizedBox(height: 4),
//                                   TextLabell(
//                                     text: DateFormat('EEEE, dd MMM yyyy', 'id')
//                                         .format(DateFormat('yyyy-MM-dd')
//                                             .parse(data['tgl_ajuan'] ?? '')),
//                                     color: Constanst.fgPrimary,
//                                     size: 16,
//                                     weight: FontWeight.w500,
//                                   ),
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   Column(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(
//                                 width: 1, color: Constanst.fgBorder)),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 TextLabell(
//                                   text: "Nama Pengajuan",
//                                   color: Constanst.fgSecondary,
//                                   size: 14,
//                                   weight: FontWeight.w400,
//                                 ),
//                                 const SizedBox(height: 4),
//                                 TextLabell(
//                                   text: "Pengajuan Absensi",
//                                   color: Constanst.fgPrimary,
//                                   size: 16,
//                                   weight: FontWeight.w500,
//                                 ),
//                                 const SizedBox(height: 12),
//                                 const Divider(
//                                   thickness: 1,
//                                   height: 0,
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 12),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 TextLabell(
//                                   text: "Tanggal",
//                                   color: Constanst.fgSecondary,
//                                   size: 14,
//                                   weight: FontWeight.w400,
//                                 ),
//                                 const SizedBox(height: 4),
//                                 TextLabell(
//                                   text: DateFormat('EEEE, dd MMM yyyy', 'id')
//                                       .format(DateFormat('yyyy-MM-dd')
//                                           .parse(data['atten_date'] ?? '')),
//                                   color: Constanst.fgPrimary,
//                                   size: 16,
//                                   weight: FontWeight.w500,
//                                 ),
//                                 const SizedBox(height: 12),
//                                 const Divider(
//                                   thickness: 1,
//                                   height: 0,
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 12),
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       TextLabell(
//                                         text: "Absen Masuk",
//                                         color: Constanst.fgSecondary,
//                                         size: 14,
//                                         weight: FontWeight.w400,
//                                       ),
//                                       const SizedBox(height: 4),
//                                       data['dari_jam'] == ""
//                                           ? TextLabell(
//                                               text: "_ _ : _ _",
//                                               color: Constanst.fgPrimary,
//                                               size: 16,
//                                               weight: FontWeight.w500,
//                                             )
//                                           : TextLabell(
//                                               text: data['dari_jam'],
//                                               color: Constanst.fgPrimary,
//                                               size: 16,
//                                               weight: FontWeight.w500,
//                                             )
//                                     ],
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       TextLabell(
//                                         text: "Absen Keluar",
//                                         color: Constanst.fgSecondary,
//                                         size: 14,
//                                         weight: FontWeight.w400,
//                                       ),
//                                       const SizedBox(height: 4),
//                                       data['sampai_jam'] == ""
//                                           ? TextLabell(
//                                               text: "_ _ : _ _",
//                                               color: Constanst.fgPrimary,
//                                               size: 16,
//                                               weight: FontWeight.w500,
//                                             )
//                                           : TextLabell(
//                                               text: data['sampai_jam'],
//                                               color: Constanst.fgPrimary,
//                                               size: 16,
//                                               weight: FontWeight.w500,
//                                             )
//                                     ],
//                                   ),
//                                 )
//                               ],
//                             ),
//                             const SizedBox(height: 12),
//                             const Divider(
//                               thickness: 1,
//                               height: 0,
//                             ),
//                             const SizedBox(height: 12),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 TextLabell(
//                                   text: "Catatan",
//                                   color: Constanst.fgSecondary,
//                                   size: 14,
//                                   weight: FontWeight.w400,
//                                 ),
//                                 const SizedBox(height: 4),
//                                 TextLabell(
//                                   text: data['uraian'],
//                                   color: Constanst.fgPrimary,
//                                   size: 16,
//                                   weight: FontWeight.w500,
//                                 ),
//                                 const SizedBox(height: 12),
//                                 const Divider(
//                                   thickness: 1,
//                                   height: 0,
//                                 ),
//                                 const SizedBox(height: 12),
//                               ],
//                             ),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 TextLabell(
//                                   text: "File disematkan",
//                                   color: Constanst.fgSecondary,
//                                   size: 14,
//                                   weight: FontWeight.w400,
//                                 ),
//                                 InkWell(
//                                   onTap: () {
//                                     viewLampiranAjuan(data['req_file']);
//                                   },
//                                   child: TextLabell(
//                                     text: data['req_file'],
//                                     color: Constanst.fgPrimary,
//                                     size: 16,
//                                     weight: FontWeight.w500,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 12),
//                                 const Divider(
//                                   thickness: 1,
//                                   height: 0,
//                                 ),
//                                 const SizedBox(height: 12),
//                               ],
//                             ),
//                             data['status'].toString().toLowerCase() ==
//                                     "approve".toLowerCase()
//                                 ? Row(
//                                     children: [
//                                       const Icon(
//                                         Iconsax.tick_circle,
//                                         size: 20,
//                                         color: Colors.green,
//                                       ),
//                                       const SizedBox(width: 8),
//                                       TextLabell(
//                                         text:
//                                             "Approved by ${data['approve_by']}",
//                                         color: Constanst.fgPrimary,
//                                         weight: FontWeight.w500,
//                                         size: 14,
//                                       )
//                                     ],
//                                   )
//                                 : data['status'].toString().toLowerCase() ==
//                                         "rejected".toLowerCase()
//                                     ? Row(
//                                         children: [
//                                           const Icon(
//                                             Iconsax.close_circle,
//                                             size: 20,
//                                             color: Colors.red,
//                                           ),
//                                           Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   TextLabell(
//                                                     text:
//                                                         "Rejected by ${data['approve_by']}",
//                                                     color: Constanst.fgPrimary,
//                                                     weight: FontWeight.bold,
//                                                   ),
//                                                   TextLabell(
//                                                     text:
//                                                         "${data['alasan_reject']}",
//                                                     color: Constanst.fgPrimary,
//                                                   ),
//                                                 ],
//                                               ),
//                                               // TextLabell(
//                                               //   text: "Absen Keluar Tanggal",
//                                               //   color: Constanst.fgSecondary,
//                                               // ),
//                                             ],
//                                           )
//                                         ],
//                                       )
//                                     : Row(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Icon(
//                                             Iconsax.timer,
//                                             size: 20,
//                                             color: Constanst.warning,
//                                           ),
//                                           Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Padding(
//                                                 padding: const EdgeInsets.only(
//                                                     left: 8.0),
//                                                 child: TextLabell(
//                                                   text: "Pending Approval",
//                                                   color: Constanst.fgPrimary,
//                                                   weight: FontWeight.w500,
//                                                   size: 14,
//                                                 ),
//                                               ),
//                                               InkWell(
//                                                 onTap: () => print('object'),
//                                                 customBorder:
//                                                     const RoundedRectangleBorder(
//                                                         borderRadius:
//                                                             BorderRadius.all(
//                                                                 Radius.circular(
//                                                                     100))),
//                                                 child: Padding(
//                                                   padding:
//                                                       const EdgeInsets.fromLTRB(
//                                                           8.0, 4.0, 8.0, 4.0),
//                                                   child: TextLabell(
//                                                     text:
//                                                         "Konfirmasi via Whatsapp",
//                                                     color: Constanst.infoLight,
//                                                     weight: FontWeight.w400,
//                                                     size: 14,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           )
//                                         ],
//                                       )
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   data['status'].toString().toLowerCase() ==
//                           "Pending".toLowerCase()
//                       ? Row(
//                           children: [
//                             Expanded(
//                               child: Container(
//                                 height: 42,
//                                 width: double.infinity,
//                                 padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
//                                 margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
//                                 decoration: BoxDecoration(
//                                   border: Border.all(
//                                     color: Constanst.fgBorder,
//                                     width: 1.0,
//                                   ),
//                                   borderRadius: BorderRadius.circular(8.0),
//                                 ),
//                                 child: ElevatedButton(
//                                   onPressed: () {
//                                     absenControllre.batalkanAjuan(
//                                         date: data['atten_date']);
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     foregroundColor: Constanst.color4,
//                                     backgroundColor: Constanst.colorWhite,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     elevation: 0,
//                                   ),
//                                   child: Text(
//                                     'Batalkan',
//                                     style: GoogleFonts.inter(
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: 16,
//                                       color: Constanst.color4,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         )
//                       : const SizedBox()
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void viewLampiranAjuan(value) async {
//     var urlViewGambar = Api.UrlfotoAbsen + value;

//     final url = Uri.parse(urlViewGambar);
//     if (!await launchUrl(
//       url,
//       mode: LaunchMode.externalApplication,
//     )) {
//       UtilsAlert.showToast('Tidak dapat membuka file');
//     }
//   }
// }
