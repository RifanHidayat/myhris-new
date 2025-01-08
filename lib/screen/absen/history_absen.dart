import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/absen_controller.dart';
import 'package:siscom_operasional/controller/dashboard_controller.dart';
import 'package:siscom_operasional/controller/global_controller.dart';
import 'package:siscom_operasional/screen/absen/camera_view.dart';
import 'package:siscom_operasional/screen/absen/laporan/laporan_absen.dart';
import 'package:siscom_operasional/screen/absen/pengajuan%20absen.dart';
import 'package:siscom_operasional/screen/init_screen.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/month_year_picker.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/absen_model.dart';

class HistoryAbsen extends StatefulWidget {
  var dataForm;
  HistoryAbsen({Key? key, this.dataForm}) : super(key: key);
  @override
  _HistoryAbsenState createState() => _HistoryAbsenState();
}

class _HistoryAbsenState extends State<HistoryAbsen> {
  var controller = Get.put(AbsenController());
  var controllerGlobal = Get.put(GlobalController());
  final dashboardController = Get.put(DashboardController());

  @override
  void initState() {
    super.initState();
    Api().checkLogin();
    controller.getTimeNow();
    controller.loadHistoryAbsenUser();
    controller.dataPengajuanAbsensi();
  }

  Future<void> refreshData() async {
    await Future.delayed(const Duration(seconds: 2));
    controller.onReady();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
                "Riwayat Absensi",
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
                  controller.removeAll();
                  Get.back();
                },
              ),
              actions: [
                dashboardController.showLaporan.value == false
                    ? const SizedBox()
                    : Obx(
                        () => controller.showButtonlaporan.value == false
                            ? const SizedBox()
                            : IconButton(
                                icon: Icon(
                                  Iconsax.document_text,
                                  color: Constanst.fgPrimary,
                                  size: 24,
                                ),
                                onPressed: () {
                                  Get.to(LaporanAbsen(
                                    dataForm: "",
                                  ));
                                },
                              ),
                      ),
              ],
            ),
          ),
        ),
        body: WillPopScope(
          onWillPop: () async {
            controller.removeAll();
            Get.back();
            return true;
          },
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Obx(
                  () => Expanded(
                    child: SizedBox(
                      height: double.maxFinite,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          dashboardController.isVisibleFloating.value == false
                              ? Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text("Absensi",
                                          style: GoogleFonts.inter(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500)),
                              )
                              : TabBar(
                                  indicatorColor: Constanst.colorPrimary,
                                  labelColor: Constanst.colorPrimary,
                                  unselectedLabelColor: Constanst.fgSecondary,
                                  indicatorWeight: 4.0,
                                  labelPadding:
                                      const EdgeInsets.fromLTRB(0, 14, 0, 14),
                                  indicatorSize: TabBarIndicatorSize.label,
                                  physics: const BouncingScrollPhysics(),
                                  tabs: [
                                    Text("Absensi",
                                        style: GoogleFonts.inter(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500)),
                                    Text("Pengajuan",
                                        style: GoogleFonts.inter(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                          Divider(
                            thickness: 1,
                            height: 0,
                            color: Constanst.fgBorder,
                          ),
                          Expanded(
                              child: SizedBox(
                            height: double.maxFinite,
                            child: dashboardController
                                        .isVisibleFloating.value ==
                                    false
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 12),
                                        filterData(),
                                        const SizedBox(height: 8),
                                        UtilsAlert.infoContainer(
                                            "${AppData.informasiUser![0].beginPayroll} ${controller.beginPayroll.value} sd ${AppData.informasiUser![0].endPayroll} ${controller.endPayroll.value} ${controller.tahunSelectedSearchHistory.value}"),
                                        const SizedBox(height: 12),
                                        Flexible(
                                            child: RefreshIndicator(
                                          onRefresh: refreshData,
                                          child: controller
                                                  .historyAbsen.value.isEmpty
                                              ? Center(
                                                  child: Text(
                                                      controller.loading.value),
                                                )
                                              : listAbsen(),
                                        ))
                                      ],
                                    ),
                                  )
                                : TabBarView(
                                    physics: const BouncingScrollPhysics(),
                                    children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16, right: 16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 12),
                                              filterData(),
                                              const SizedBox(height: 8),
                                              UtilsAlert.infoContainer(
                                                  "${AppData.informasiUser![0].beginPayroll} ${controller.beginPayroll.value} sd ${AppData.informasiUser![0].endPayroll} ${controller.endPayroll.value} ${controller.tahunSelectedSearchHistory.value}"),
                                              const SizedBox(height: 12),
                                              // Row(
                                              //   children: [
                                              //     Expanded(
                                              //       flex: 9,
                                              //       child: Container(
                                              //         decoration: BoxDecoration(
                                              //           color: Constanst.infoLight1,
                                              //           border: Border.all(
                                              //             color: Constanst
                                              //                 .colorStateInfoBorder,
                                              //           ),
                                              //           borderRadius:
                                              //               const BorderRadius.all(
                                              //             Radius.circular(8.0),
                                              //           ),
                                              //         ),
                                              //         child: Padding(
                                              //           padding:
                                              //               const EdgeInsets.all(
                                              //                   8.0),
                                              //           child: Column(
                                              //             crossAxisAlignment:
                                              //                 CrossAxisAlignment
                                              //                     .start,
                                              //             children: [
                                              //               Text(
                                              //                 "15",
                                              //                 style: GoogleFonts.inter(
                                              //                     fontWeight:
                                              //                         FontWeight
                                              //                             .w500,
                                              //                     fontSize: 16,
                                              //                     color: Constanst
                                              //                         .fgPrimary),
                                              //               ),
                                              //               const SizedBox(
                                              //                   height: 4),
                                              //               Text(
                                              //                 "Masuk Kerja",
                                              //                 style: GoogleFonts.inter(
                                              //                     fontWeight:
                                              //                         FontWeight
                                              //                             .w400,
                                              //                     fontSize: 12,
                                              //                     color: Constanst
                                              //                         .fgSecondary),
                                              //               ),
                                              //             ],
                                              //           ),
                                              //         ),
                                              //       ),
                                              //     ),
                                              //     const SizedBox(width: 8),
                                              //     Expanded(
                                              //       flex: 9,
                                              //       child: Container(
                                              //         decoration: BoxDecoration(
                                              //           color: Constanst.infoLight1,
                                              //           border: Border.all(
                                              //             color: Constanst
                                              //                 .colorStateInfoBorder,
                                              //           ),
                                              //           borderRadius:
                                              //               const BorderRadius.all(
                                              //             Radius.circular(8.0),
                                              //           ),
                                              //         ),
                                              //         child: Padding(
                                              //           padding:
                                              //               const EdgeInsets.all(
                                              //                   8.0),
                                              //           child: Column(
                                              //             crossAxisAlignment:
                                              //                 CrossAxisAlignment
                                              //                     .start,
                                              //             children: [
                                              //               Text(
                                              //                 "0",
                                              //                 style: GoogleFonts.inter(
                                              //                     fontWeight:
                                              //                         FontWeight
                                              //                             .w500,
                                              //                     fontSize: 16,
                                              //                     color: Constanst
                                              //                         .fgPrimary),
                                              //               ),
                                              //               const SizedBox(
                                              //                   height: 4),
                                              //               Text(
                                              //                 "Terlambat",
                                              //                 style: GoogleFonts.inter(
                                              //                     fontWeight:
                                              //                         FontWeight
                                              //                             .w400,
                                              //                     fontSize: 12,
                                              //                     color: Constanst
                                              //                         .fgSecondary),
                                              //               ),
                                              //             ],
                                              //           ),
                                              //         ),
                                              //       ),
                                              //     ),
                                              //     const SizedBox(width: 8),
                                              //     Expanded(
                                              //       flex: 10,
                                              //       child: Container(
                                              //         decoration: BoxDecoration(
                                              //           color: Constanst.infoLight1,
                                              //           border: Border.all(
                                              //             color: Constanst
                                              //                 .colorStateInfoBorder,
                                              //           ),
                                              //           borderRadius:
                                              //               const BorderRadius.all(
                                              //             Radius.circular(8.0),
                                              //           ),
                                              //         ),
                                              //         child: Padding(
                                              //           padding:
                                              //               const EdgeInsets.all(
                                              //                   8.0),
                                              //           child: Column(
                                              //             crossAxisAlignment:
                                              //                 CrossAxisAlignment
                                              //                     .start,
                                              //             children: [
                                              //               Text(
                                              //                 "5",
                                              //                 style: GoogleFonts.inter(
                                              //                     fontWeight:
                                              //                         FontWeight
                                              //                             .w500,
                                              //                     fontSize: 16,
                                              //                     color: Constanst
                                              //                         .fgPrimary),
                                              //               ),
                                              //               const SizedBox(
                                              //                   height: 4),
                                              //               Text(
                                              //                 "Tidak Absen Keluar",
                                              //                 style: GoogleFonts.inter(
                                              //                     fontWeight:
                                              //                         FontWeight
                                              //                             .w400,
                                              //                     fontSize: 12,
                                              //                     color: Constanst
                                              //                         .fgSecondary),
                                              //               ),
                                              //             ],
                                              //           ),
                                              //         ),
                                              //       ),
                                              //     ),
                                              //   ],
                                              // ),
                                              // const SizedBox(height: 16),
                                              // controller.bulanDanTahunNow.value == ""
                                              //     ? const SizedBox()
                                              //     : pickDate(),
                                              // const SizedBox(height: 16),
                                              // Row(
                                              //   mainAxisAlignment:
                                              //       MainAxisAlignment.start,
                                              //   crossAxisAlignment:
                                              //       CrossAxisAlignment.start,
                                              //   children: [
                                              //     Expanded(
                                              //       flex: 85,
                                              //       child: Padding(
                                              //         padding: const EdgeInsets.only(
                                              //             top: 8),
                                              //         child: Text(
                                              //           "Riwayat Absensi",
                                              //           textAlign: TextAliginitn.left,
                                              //           style: GoogleFonts.inter(
                                              //               fontWeight:
                                              //                   FontWeight.bold,
                                              //               fontSize:
                                              //                   Constanst.sizeTitle),
                                              //         ),
                                              //       ),
                                              //     ),
                                              //   ],
                                              // ),
                                              // SizedBox(height: 8),
                                              Flexible(
                                                  child: RefreshIndicator(
                                                onRefresh: refreshData,
                                                child: controller.historyAbsen
                                                        .value.isEmpty
                                                    ? Center(
                                                        child: Text(controller
                                                            .loading.value),
                                                      )
                                                    : listAbsen(),
                                              ))
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16, right: 16),
                                          child: Column(
                                            children: [
                                              const SizedBox(height: 12),
                                              // controller.bulanDanTahunNowPengajuan
                                              //             .value ==
                                              //         ""
                                              //     ? const SizedBox()
                                              //     : pickDateBulanDanTahun(),
                                              const SizedBox(height: 16),
                                              Flexible(
                                                  child: Obx(
                                                () => RefreshIndicator(
                                                    onRefresh: refreshData,
                                                    color:
                                                        Constanst.colorPrimary,
                                                    child: controller
                                                            .pengajuanAbsensi
                                                            .isEmpty
                                                        ? Center(
                                                            child: Text(controller
                                                                .loadingPengajuan
                                                                .value
                                                                .toString()),
                                                          )
                                                        : listPengajuan()),
                                              ))
                                            ],
                                          ),
                                        )
                                      ]),
                          ))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        // floatingActionButton: Obx(
        //   () => controller.showButtonlaporan.value == false
        //       ? SizedBox()
        //       : SpeedDial(
        //           icon: Iconsax.more,
        //           activeIcon: Icons.close,
        //           backgroundColor: Constanst.colorPrimary,
        //           spacing: 3,
        //           childPadding: const EdgeInsets.all(5),
        //           spaceBetweenChildren: 4,
        //           elevation: 8.0,
        //           animationCurve: Curves.elasticInOut,
        //           animationDuration: const Duration(milliseconds: 200),
        //           children: [
        //             SpeedDialChild(
        //                 child: Icon(Iconsax.document_text),
        //                 backgroundColor: Color(0xff2F80ED),
        //                 foregroundColor: Colors.white,
        //                 label: 'Pengajuan Absen',
        //                 onTap: () {
        //                   Get.to(pengajuanAbsen());
        //                 }),
        //             SpeedDialChild(
        //                 child: Icon(Iconsax.document_text),
        //                 backgroundColor: Color(0xff2F80ED),
        //                 foregroundColor: Colors.white,
        //                 label: 'Laporan Absensi',
        //                 onTap: () {
        //                   Get.to(LaporanAbsen(
        //                     dataForm: "",
        //                   ));
        //                 }),
        //             SpeedDialChild(
        //                 child: Icon(Iconsax.minus_cirlce),
        //                 backgroundColor: Color(0xffFF463D),
        //                 foregroundColor: Colors.white,
        //                 label: 'Absen Terlambat',
        //                 onTap: () {
        //                   Get.to(LaporanAbsenTelat(
        //                     dataForm: "",
        //                   ));
        //                 }),
        //             SpeedDialChild(
        //                 child: Icon(Iconsax.watch),
        //                 backgroundColor: Color(0xffF2AA0D),
        //                 foregroundColor: Colors.white,
        //                 label: 'Belum Absen',
        //                 onTap: () {
        //                   Get.to(LaporanBelumAbsen(
        //                     dataForm: "",
        //                   ));
        //                 }),
        //           ],
        //         ),
        // )
        floatingActionButton:
            dashboardController.isVisibleFloating.value == false
                ? Container()
                : FloatingActionButton(
                    backgroundColor: Constanst.colorPrimary,
                    onPressed: () {
                      Get.to(const pengajuanAbsen());
                    },
                    child: const Icon(
                      Iconsax.add,
                      size: 34,
                    ),
                  ),
      ),
    );
  }

  // Widget pickDate() {
  //   String getDateRange(String dateString) {
  //     // Parsing string menjadi objek DateTime
  //     DateTime parsedDate = DateFormat("MM-yyyy").parseStrict(dateString);

  //     // Mendapatkan rentang tanggal dari 1 hingga hari terakhir bulan
  //     DateTime firstDayOfMonth = DateTime(parsedDate.year, parsedDate.month, 1);
  //     DateTime lastDayOfMonth =
  //         DateTime(parsedDate.year, parsedDate.month + 1, 0);

  //     // Memformat rentang tanggal
  //     String formattedDateRange =
  //         '${DateFormat('d MMMM', 'id').format(firstDayOfMonth)} sd ${DateFormat('d MMMM yyyy', 'id').format(lastDayOfMonth)}';

  //     return formattedDateRange;
  //   }

  //   String lastDayOfMonth = getDateRange(controller.bulanDanTahunNow.value);

  //   return InkWell(
  //     customBorder: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.all(Radius.circular(100))),
  //     onTap: () async {
  //       print("kesini");
  //       DatePicker.showPicker(
  //         context,
  //         pickerModel: CustomMonthPicker(
  //           minTime: DateTime(2020, 1, 1),
  //           maxTime: DateTime(2050, 1, 1),
  //           currentTime: DateTime(
  //               int.parse(controller.tahunSelectedSearchHistory.value),
  //               int.parse(controller.bulanSelectedSearchHistory.value),
  //               1),
  //         ),
  //         onConfirm: (time) {
  //           if (time != null) {
  //             print("$time");
  //             var filter = DateFormat('yyyy-MM').format(time);
  //             var array = filter.split('-');
  //             var bulan = array[1];
  //             var tahun = array[0];
  //             controller.bulanSelectedSearchHistory.value = bulan;
  //             controller.tahunSelectedSearchHistory.value = tahun;
  //             controller.bulanDanTahunNow.value = "$bulan-$tahun";
  //             this.controller.bulanSelectedSearchHistory.refresh();
  //             this.controller.tahunSelectedSearchHistory.refresh();
  //             this.controller.bulanDanTahunNow.refresh();
  //             controller.loadHistoryAbsenUser();
  //           }
  //         },
  //       );
  //     },
  //     child: Container(
  //       decoration: BoxDecoration(
  //           borderRadius: const BorderRadius.all(
  //             Radius.circular(100),
  //           ),
  //           border: Border.all(color: Constanst.fgBorder)),
  //       child: Padding(
  //         padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
  //         child: SingleChildScrollView(
  //           scrollDirection: Axis.horizontal,
  //           child: Row(
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.only(left: 10),
  //                 child: Text(
  //                   Constanst.convertDateBulanDanTahun(
  //                       controller.bulanDanTahunNow.value),
  //                   style: GoogleFonts.inter(
  //                       fontWeight: FontWeight.w500,
  //                       fontSize: 14,
  //                       color: Constanst.fgSecondary),
  //                 ),
  //               ),
  //               const SizedBox(width: 4),
  //               Icon(
  //                 Iconsax.arrow_down_1,
  //                 size: 18,
  //                 color: Constanst.fgPrimary,
  //               )
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //     // child: Container(
  //     //   decoration: BoxDecoration(
  //     //       borderRadius: const BorderRadius.all(Radius.circular(12)),
  //     //       border: Border.all(color: const Color(0xffD5DBE5))),
  //     //   child: Padding(
  //     //     padding: const EdgeInsets.fromLTRB(
  //     //       12.0,
  //     //       8.0,
  //     //       12.0,
  //     //       12.0,
  //     //     ),
  //     //     child: Row(
  //     //       crossAxisAlignment: CrossAxisAlignment.center,
  //     //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     //       children: [
  //     //         Column(
  //     //           crossAxisAlignment: CrossAxisAlignment.start,
  //     //           children: [
  //     //             Text(
  //     //               "Periode",
  //     //               style: GoogleFonts.inter(
  //     //                   fontSize: 16,
  //     //                   fontWeight: FontWeight.w500,
  //     //                   color: Constanst.fgPrimary),
  //     //             ),
  //     //             const SizedBox(height: 4),
  //     //             Text(
  //     //               lastDayOfMonth,
  //     //               style: GoogleFonts.inter(
  //     //                   fontSize: 14,
  //     //                   fontWeight: FontWeight.w400,
  //     //                   color: Constanst.fgSecondary),
  //     //             ),
  //     //           ],
  //     //         ),
  //     //         Container(
  //     //           alignment: Alignment.topRight,
  //     //           child: Padding(
  //     //             padding: const EdgeInsets.only(right: 10),
  //     //             child: Icon(
  //     //               Iconsax.arrow_down_1,
  //     //               size: 18,
  //     //               color: Constanst.fgSecondary,
  //     //             ),
  //     //           ),
  //     //         )
  //     //       ],
  //     //     ),
  //     //   ),
  //     // ),
  //   );
  // }

  // Widget pickDateBulanDanTahun() {
  //   return Row(
  //     children: [
  //       InkWell(
  //         customBorder: const RoundedRectangleBorder(
  //             borderRadius: BorderRadius.all(Radius.circular(100))),
  //         onTap: () async {
  //           print("kesini printnya");
  //           DatePicker.showPicker(
  //             context,
  //             pickerModel: CustomMonthPicker(
  //               minTime: DateTime(2020, 1, 1),
  //               maxTime: DateTime(2050, 1, 1),
  //               currentTime: DateTime(
  //                   int.parse(
  //                       controller.tahunSelectedSearchHistoryPengajuan.value),
  //                   int.parse(
  //                       controller.bulanSelectedSearchHistoryPengajuan.value),
  //                   1),
  //             ),
  //             onConfirm: (time) {
  //               if (time != null) {
  //                 print("$time");
  //                 var filter = DateFormat('yyyy-MM').format(time);
  //                 var array = filter.split('-');
  //                 var bulan = array[1];
  //                 var tahun = array[0];
  //                 controller.bulanSelectedSearchHistoryPengajuan.value = bulan;
  //                 controller.tahunSelectedSearchHistoryPengajuan.value = tahun;
  //                 controller.bulanDanTahunNowPengajuan.value = "$bulan-$tahun";
  //                 this.controller.bulanSelectedSearchHistoryPengajuan.refresh();
  //                 this.controller.tahunSelectedSearchHistoryPengajuan.refresh();
  //                 this.controller.bulanDanTahunNowPengajuan.refresh();
  //                 controller.dataPengajuanAbsensi();
  //               }
  //             },
  //           );
  //         },
  //         child: Container(
  //           decoration: BoxDecoration(
  //               borderRadius: const BorderRadius.all(
  //                 Radius.circular(100),
  //               ),
  //               border: Border.all(color: Constanst.fgBorder)),
  //           child: Padding(
  //             padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
  //             child: Row(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.only(left: 10),
  //                   child: Text(
  //                     Constanst.convertDateBulanDanTahun(
  //                         controller.bulanDanTahunNowPengajuan.value),
  //                     style: GoogleFonts.inter(
  //                         fontWeight: FontWeight.w500,
  //                         fontSize: 14,
  //                         color: Constanst.fgSecondary),
  //                   ),
  //                 ),
  //                 const SizedBox(width: 4),
  //                 Icon(
  //                   Iconsax.arrow_down_1,
  //                   size: 18,
  //                   color: Constanst.fgPrimary,
  //                 )
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //       const SizedBox(width: 4),
  //       // InkWell(
  //       //   customBorder: const RoundedRectangleBorder(
  //       //       borderRadius: BorderRadius.all(Radius.circular(100))),
  //       //   onTap: () async {
  //       //     print("kesini");
  //       //     DatePicker.showPicker(
  //       //       context,
  //       //       pickerModel: CustomMonthPicker(
  //       //         minTime: DateTime(2020, 1, 1),
  //       //         maxTime: DateTime(2050, 1, 1),
  //       //         currentTime: DateTime.now(),
  //       //       ),
  //       //       onConfirm: (time) {
  //       //         if (time != null) {
  //       //           print("$time");
  //       //           var filter = DateFormat('yyyy-MM').format(time);
  //       //           var array = filter.split('-');
  //       //           var bulan = array[1];
  //       //           var tahun = array[0];
  //       //           controller.bulanSelectedSearchHistoryPengajuan.value = bulan;
  //       //           controller.tahunSelectedSearchHistoryPengajuan.value = tahun;
  //       //           controller.bulanDanTahunNowPengajuan.value = "$bulan-$tahun";
  //       //           this.controller.bulanSelectedSearchHistoryPengajuan.refresh();
  //       //           this.controller.tahunSelectedSearchHistoryPengajuan.refresh();
  //       //           this.controller.bulanDanTahunNowPengajuan.refresh();
  //       //           controller.dataPengajuanAbsensi();
  //       //         }
  //       //       },
  //       //     );
  //       //   },
  //       //   child: Container(
  //       //     decoration: BoxDecoration(
  //       //         color: Colors.white,
  //       //         borderRadius: const BorderRadius.all(
  //       //           Radius.circular(100),
  //       //         ),
  //       //         border: Border.all(color: Constanst.fgBorder)),
  //       //     child: Padding(
  //       //       padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
  //       //       child: Row(
  //       //         crossAxisAlignment: CrossAxisAlignment.start,
  //       //         children: [
  //       //           Padding(
  //       //             padding: const EdgeInsets.only(left: 10),
  //       //             child: Text(
  //       //               Constanst.convertDateBulanDanTahun(
  //       //                   controller.bulanDanTahunNowPengajuan.value),
  //       //               style: GoogleFonts.inter(
  //       //                   fontWeight: FontWeight.w500,
  //       //                   fontSize: 14,
  //       //                   color: Constanst.fgSecondary),
  //       //             ),
  //       //           ),
  //       //           const SizedBox(width: 4),
  //       //           Icon(
  //       //             Iconsax.arrow_down_1,
  //       //             size: 18,
  //       //             color: Constanst.fgPrimary,
  //       //           )
  //       //         ],
  //       //       ),
  //       //     ),
  //       //   ),
  //       // ),
  //     ],
  //   );
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

  Widget filterData() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(right: 16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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

                        controller.date.value = time;
                        controller.loadHistoryAbsenUserFilter();
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
            ],
          ),
        ),
      ),
    );
  }

  Widget listPengajuan() {
    return ListView.builder(
        physics: controller.pengajuanAbsensi.value.length <= 10
            ? const AlwaysScrollableScrollPhysics()
            : const BouncingScrollPhysics(),
        itemCount: controller.pengajuanAbsensi.value.length,
        itemBuilder: (context, index) {
          var data = controller.pengajuanAbsensi[index];
          var nomorAjuan =
              controller.pengajuanAbsensi.value[index]['nomor_ajuan'];

          var namaTypeAjuan = controller.pengajuanAbsensi.value[index]['name'];
          // Parse the input date string
          DateTime atten_date =
              DateFormat('yyyy-MM-dd').parse(data['atten_date']);
          // Format the date using the Indonesian month format
          String formatAttenDate =
              DateFormat('dd MMM yyyy', 'id').format(atten_date);

          return Container(
            padding: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              customBorder: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              onTap: () {
                showBottomDetailPengajuan(context, index);
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(width: 1, color: Constanst.fgBorder)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextLabell(
                        text: formatAttenDate,
                        weight: FontWeight.w500,
                        size: 16.0,
                        color: Constanst.fgPrimary,
                      ),
                      const SizedBox(height: 4),
                      TextLabell(
                        text: data['nomor_ajuan'],
                        weight: FontWeight.w400,
                        size: 16.0,
                        color: Constanst.fgSecondary,
                      ),
                      const SizedBox(height: 4),
                      TextLabell(
                        text:
                            "Absen Masuk Tanggal $formatAttenDate, ${data['dari_jam']}",
                        color: Constanst.fgSecondary,
                        size: 13.0,
                        weight: FontWeight.w400,
                      ),
                      TextLabell(
                        text:
                            "Absen Keluar Tanggal $formatAttenDate, ${data['sampai_jam']}",
                        color: Constanst.fgSecondary,
                        size: 13.0,
                        weight: FontWeight.w400,
                      ),
                      const SizedBox(height: 12),
                      Divider(
                        height: 0,
                        thickness: 1,
                        color: Constanst.fgBorder,
                      ),
                      const SizedBox(height: 8),
                      controllerGlobal.valuePolaPersetujuan.value == "1" ||
                              controllerGlobal.valuePolaPersetujuan.value == 1
                          ? Container(
                              child: data['status'].toString().toLowerCase() ==
                                      "approve".toLowerCase()
                                  ? Row(
                                      children: [
                                        const Icon(
                                          Iconsax.tick_circle,
                                          size: 20,
                                          color: Colors.green,
                                        ),
                                        const SizedBox(width: 8),
                                        TextLabell(
                                          text:
                                              "Approved by ${data['approve_by']}",
                                          color: Constanst.fgPrimary,
                                          weight: FontWeight.w500,
                                          size: 14,
                                        )
                                      ],
                                    )
                                  : data['status'].toString().toLowerCase() ==
                                          "rejected".toLowerCase()
                                      ? Row(
                                          children: [
                                            const Icon(
                                              Iconsax.close_circle,
                                              size: 20,
                                              color: Colors.red,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    TextLabell(
                                                      text:
                                                          "Rejected by ${data['approve_by']}",
                                                      color:
                                                          Constanst.fgPrimary,
                                                      weight: FontWeight.w500,
                                                      size: 14,
                                                    ),
                                                    const SizedBox(height: 4),
                                                    TextLabell(
                                                      text:
                                                          "${data['alasan_reject']}",
                                                      color:
                                                          Constanst.fgSecondary,
                                                      weight: FontWeight.w400,
                                                      size: 14,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        )
                                      : Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Iconsax.timer,
                                              size: 20,
                                              color: Constanst.warning,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: TextLabell(
                                                    text: "Pending Approval",
                                                    color: Constanst.fgPrimary,
                                                    weight: FontWeight.w500,
                                                    size: 14,
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    print("${namaTypeAjuan}");
                                                    var dataEmployee = {
                                                      'nameType': 'Absensi',
                                                      'nomor_ajuan':
                                                          '$nomorAjuan',
                                                    };
                                                    controllerGlobal
                                                        .showDataPilihAtasan(
                                                            dataEmployee);
                                                  },
                                                  customBorder:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          100))),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(
                                                        8.0, 4.0, 8.0, 4.0),
                                                    child: TextLabell(
                                                      text:
                                                          "Konfirmasi via Whatsapp",
                                                      color:
                                                          Constanst.infoLight,
                                                      weight: FontWeight.w400,
                                                      size: 14,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                            )
                          : Container(
                              child: data['status'].toString().toLowerCase() ==
                                      "approve".toLowerCase()
                                  ? Row(
                                      children: [
                                        Icon(
                                          Iconsax.timer,
                                          size: 20,
                                          color: Constanst.warning,
                                        ),
                                        const SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextLabell(
                                              text: "Pending Approval 2",
                                              color: Constanst.fgPrimary,
                                              weight: FontWeight.w500,
                                              size: 14,
                                            ),
                                            TextLabell(
                                              text:
                                                  "Approved 1 by ${data['approve_by']}",
                                              color: Constanst.fgPrimary,
                                              weight: FontWeight.w500,
                                              size: 14,
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  : data['status'].toString().toLowerCase() ==
                                          "approve2".toLowerCase()
                                      ? Row(
                                          children: [
                                            const Icon(
                                              Iconsax.tick_circle,
                                              size: 20,
                                              color: Colors.green,
                                            ),
                                            const SizedBox(width: 8),
                                            Column(
                                              children: [
                                                TextLabell(
                                                  text:
                                                      "Approved 2 by ${data['approve_by']}",
                                                  color: Constanst.fgPrimary,
                                                  weight: FontWeight.w500,
                                                  size: 14,
                                                ),
                                              ],
                                            )
                                          ],
                                        )
                                      : data['status']
                                                  .toString()
                                                  .toLowerCase() ==
                                              "rejected".toLowerCase()
                                          ? Row(
                                              children: [
                                                const Icon(
                                                  Iconsax.close_circle,
                                                  size: 20,
                                                  color: Colors.red,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        TextLabell(
                                                          text:
                                                              "Rejected by ${data['approve_by']}",
                                                          color: Constanst
                                                              .fgPrimary,
                                                          weight:
                                                              FontWeight.w500,
                                                          size: 14,
                                                        ),
                                                        const SizedBox(
                                                            height: 4),
                                                        TextLabell(
                                                          text:
                                                              "${data['alasan_reject']}",
                                                          color: Constanst
                                                              .fgSecondary,
                                                          weight:
                                                              FontWeight.w400,
                                                          size: 14,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )
                                          : Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Iconsax.timer,
                                                  size: 20,
                                                  color: Constanst.warning,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0),
                                                      child: TextLabell(
                                                        text:
                                                            "Pending Approval",
                                                        color:
                                                            Constanst.fgPrimary,
                                                        weight: FontWeight.w500,
                                                        size: 14,
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        print(
                                                            "${namaTypeAjuan}");
                                                        var dataEmployee = {
                                                          'nameType': 'Absensi',
                                                          'nomor_ajuan':
                                                              '$nomorAjuan',
                                                        };
                                                        controllerGlobal
                                                            .showDataPilihAtasan(
                                                                dataEmployee);
                                                      },
                                                      customBorder:
                                                          const RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          100))),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(8.0,
                                                                4.0, 8.0, 4.0),
                                                        child: TextLabell(
                                                          text:
                                                              "Konfirmasi via Whatsapp",
                                                          color: Constanst
                                                              .infoLight,
                                                          weight:
                                                              FontWeight.w400,
                                                          size: 14,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                            )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget tampilan1(index, index2) {
    var placeOut = index['turunan'][0]['place_out'] ?? '';
    var placeIn = index['turunan'][0]['place_in'] ?? '';
    var statusView;
    if (placeIn != "") {
      statusView =
          placeIn == "pengajuan" && placeOut == "pengajuan" ? true : false;
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 1, color: Constanst.fgBorder)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            index['status_view'] == true
                ? Container()
                : Expanded(
                    flex: 15,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Constanst.colorNeutralBgSecondary,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                          ),
                        ),
                        height: 77,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  DateFormat('d').format(
                                      DateFormat('yyyy-MM-dd')
                                          .parse(index['atten_date'])),
                                  style: GoogleFonts.inter(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Constanst.fgPrimary,
                                  )),
                              Text(
                                  DateFormat('EEEE', 'id').format(
                                      DateFormat('yyyy-MM-dd')
                                          .parse(index['atten_date'])),
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Constanst.fgSecondary,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
            Expanded(
              flex: 85,
              child: Column(
                children: [
                  index['status_view'] == false
                      ? InkWell(
                          customBorder: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                            ),
                          ),
                          onTap: () {
                            if (statusView == false) {
                              controller.historySelected(
                                  index['turunan'][0]['id'], 'history');
                            }
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 38,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, top: 10.0, bottom: 12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Iconsax.login_1,
                                        color: Constanst.color5,
                                        size: 16,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 4),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              index['turunan'][0]
                                                  ['signin_time'],
                                              style: GoogleFonts.inter(
                                                  color: Constanst.fgPrimary,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              index['turunan'][0]['reg_type'] ==
                                                      0
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
                                  padding: const EdgeInsets.only(
                                      left: 4, top: 10.0, bottom: 12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Iconsax.logout_14,
                                        color: Constanst.color4,
                                        size: 16,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 4),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              index['turunan'][0]
                                                  ['signout_time'],
                                              style: GoogleFonts.inter(
                                                  color: Constanst.fgPrimary,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              index['turunan'][0]['reg_type'] ==
                                                      0
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
                              index['status_view'] == false
                                  ? Expanded(
                                      flex: 9,
                                      child: index['status_view'] == false
                                          ? InkWell(
                                              customBorder:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(12),
                                                ),
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  index['status_view'] == true
                                                      ? index['status_view'] =
                                                          false
                                                      : index['status_view'] =
                                                          true;
                                                });
                                              },
                                              child: SizedBox(
                                                height: 57,
                                                child: Transform.rotate(
                                                  angle: 90 *
                                                      (3.141592653589793 / 180),
                                                  child: Icon(
                                                    Icons
                                                        .arrow_forward_ios_rounded,
                                                    size: 18,
                                                    color: Constanst
                                                        .colorNeutralFgTertiary,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              size: 16,
                                              color: Constanst
                                                  .colorNeutralFgTertiary,
                                            ))
                                  : const SizedBox()
                            ],
                          ),
                        )
                      : Row(
                          children: [
                            Expanded(
                              flex: 15,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Constanst.colorNeutralBgSecondary,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(8.0),
                                      bottomLeft: Radius.circular(8.0),
                                    ),
                                  ),
                                  height: int.parse(index['turunan']
                                              .length
                                              .toString()) *
                                          55 +
                                      28,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0, bottom: 5.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                            DateFormat('d').format(
                                                DateFormat('yyyy-MM-dd').parse(
                                                    index['atten_date'])),
                                            style: GoogleFonts.inter(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: Constanst.fgPrimary,
                                            )),
                                        Text(
                                            DateFormat('EEEE', 'id').format(
                                                DateFormat('yyyy-MM-dd').parse(
                                                    index['atten_date'])),
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Constanst.fgSecondary,
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 85,
                              child: listTurunanHistoryAbsen(index['turunan'],
                                  index['atten_date'], index2),
                            ),
                          ],
                        ),
                  index['status_view'] == true
                      ? Container()
                      : Padding(
                          padding:
                              const EdgeInsets.only(left: 12.0, right: 12.0),
                          child: Divider(
                            height: 0,
                            thickness: 1,
                            color: Constanst.fgBorder,
                          ),
                        ),
                  index['status_view'] == true
                      ? Container()
                      : InkWell(
                          customBorder: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(12)),
                          ),
                          onTap: () {
                            setState(() {
                              controller.showTurunan(controller.historyAbsenShow
                                  .value[index2]['atten_date']);
                              if (controller.historyAbsenShow.value[index2]
                                      ['view_turunan'] ==
                                  false) {
                                controller.historySelected(
                                    controller.historyAbsen.value[index2].id,
                                    'history');
                              }
                            });
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Container(
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  "Lainnya",
                                  style: GoogleFonts.inter(
                                      color: Constanst.fgSecondary,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10),
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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

    if (index.turunan!.isNotEmpty) {
      waktuMasuk = "$attenDate ${index.turunan!.last.signin_time}";
    }
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
                                                              const EdgeInsets.only(
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
                                                                      "null" ||
                                                                  index.jamKerja
                                                                          .toString() !=
                                                                      "") &&
                                                              DateTime.parse(
                                                                      waktuMasuk)
                                                                  .isAfter(DateTime.parse(batasWaktu)
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
  //  index.atten_date=="" || index.atten_date==null?
  //    //tidak ada absen

  //    index.namaHariLibur!=null?
  //    TextLabell(text: index.namaHariLibur): TextLabell(text: "Tidak Masuk Kerja"):

  //    //ada asen

  Widget listTurunanHistoryAbsen(indexData, String atten_date, index) {
    return Column(
      children: [
        ListView.builder(
            itemCount: indexData.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              var jamMasuk = indexData[index]['signin_time'] ?? '';
              var jamKeluar = indexData[index]['signout_time'] ?? '';
              var placeIn = indexData[index]['place_in'] ?? '';
              var placeOut = indexData[index]['place_out'] ?? '';
              var note = indexData[index]['signin_note'] ?? '';
              var signInLongLat = indexData[index]['signin_longlat'] ?? '';
              var signOutLongLat = indexData[index]['signout_longlat'] ?? '';
              var regType = indexData[index]['reg_type'] ?? '';
              var statusView;
              if (placeIn != "") {
                statusView = placeIn == "pengajuan" && placeOut == "pengajuan"
                    ? true
                    : false;
              }
              var listJamMasuk = (jamMasuk!.split(':'));
              var listJamKeluar = (jamKeluar!.split(':'));
              var perhitunganJamMasuk1 =
                  830 - int.parse("${listJamMasuk[0]}${listJamMasuk[1]}");
              var perhitunganJamMasuk2 =
                  1800 - int.parse("${listJamKeluar[0]}${listJamKeluar[1]}");
              var getColorMasuk;
              var getColorKeluar;

              if (perhitunganJamMasuk1 < 0) {
                getColorMasuk = Colors.red;
              } else {
                getColorMasuk = Colors.black;
              }

              if (perhitunganJamMasuk2 == 0) {
                getColorKeluar = Colors.black;
              } else if (perhitunganJamMasuk2 > 0) {
                getColorKeluar = Colors.red;
              } else if (perhitunganJamMasuk2 < 0) {
                getColorKeluar = Constanst.colorPrimary;
              }
              return Column(
                children: [
                  InkWell(
                    customBorder: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    onTap: () {
                      if (statusView == false) {
                        controller.historySelected(
                            indexData[index]['id'], 'history');
                      }
                    },
                    child: statusView == false
                        ? Padding(
                            padding: const EdgeInsets.only(top: 12, bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // Expanded(
                                    //   flex: 15,
                                    //   child: Padding(
                                    //     padding: const EdgeInsets.all(4.0),
                                    //     child: Container(
                                    //       decoration: BoxDecoration(
                                    //         color: Constanst.colorNeutralBgSecondary,
                                    //         borderRadius: const BorderRadius.only(
                                    //           topLeft: Radius.circular(8.0),
                                    //           bottomLeft: Radius.circular(8.0),
                                    //         ),
                                    //       ),
                                    //       child: Padding(
                                    //         padding: const EdgeInsets.only(
                                    //             top: 5.0, bottom: 5.0),
                                    //         child: Column(
                                    //           children: [
                                    //             Text(
                                    //                 DateFormat('d').format(
                                    //                     DateFormat('yyyy-MM-dd')
                                    //                         .parse(atten_date)),
                                    //                 style: GoogleFonts.inter(
                                    //                   fontSize: 20,
                                    //                   fontWeight: FontWeight.w500,
                                    //                   color: Constanst.fgPrimary,
                                    //                 )),
                                    //             Text(
                                    //                 DateFormat('EEEE', 'id').format(
                                    //                     DateFormat('yyyy-MM-dd')
                                    //                         .parse(atten_date)),
                                    //                 style: GoogleFonts.inter(
                                    //                   fontSize: 12,
                                    //                   fontWeight: FontWeight.w400,
                                    //                   color: Constanst.fgSecondary,
                                    //                 )),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
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
                                                        color:
                                                            Constanst.fgPrimary,
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
                                      flex: 38,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 4),
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
                                              child: signInLongLat == ""
                                                  ? const Text("")
                                                  : Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "$jamKeluar",
                                                          style: GoogleFonts.inter(
                                                              color: Constanst
                                                                  .fgPrimary,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 16),
                                                        ),
                                                        const SizedBox(
                                                            height: 4),
                                                        Text(
                                                          regType == 0
                                                              ? "Face Recognition"
                                                              : "Photo",
                                                          style: GoogleFonts.inter(
                                                              color: Constanst
                                                                  .fgSecondary,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 10),
                                                        ),
                                                      ],
                                                    ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 9,
                                      child: Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 16,
                                        color: Constanst.colorNeutralFgTertiary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${note}".toLowerCase(),
                                      style: GoogleFonts.inter(
                                          color: Constanst.colorText3),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ),
                  // index == indexData.length - 1
                  //     ? Container()
                  //     :
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 12),
                    child: Divider(
                      height: 0,
                      thickness: 1,
                      color: Constanst.fgBorder,
                    ),
                  ),
                ],
              );
            }),
        InkWell(
          customBorder: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(12)),
          ),
          onTap: () {
            setState(() {
              controller.showTurunan(
                  controller.historyAbsenShow.value[index]['atten_date']);
              if (controller.historyAbsenShow.value[index]['view_turunan'] ==
                  false) {
                controller.historySelected(
                    controller.historyAbsen.value[index].id, 'history');
              }
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: SizedBox(
              width: double.infinity,
              child: Center(
                child: Text(
                  "Tutup",
                  style: GoogleFonts.inter(
                      color: Constanst.fgSecondary,
                      fontWeight: FontWeight.w400,
                      fontSize: 10),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void showBottomDetailPengajuan(BuildContext context, index) {
    var data = controller.pengajuanAbsensi[index];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Constanst.colorNeutralBgTertiary,
                          borderRadius: BorderRadius.circular(100)),
                      width: 32,
                      height: 6,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                width: 1, color: Constanst.fgBorder)),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextLabell(
                                    text: "No. Pengajuan",
                                    color: Constanst.fgSecondary,
                                    size: 14,
                                    weight: FontWeight.w400,
                                  ),
                                  const SizedBox(height: 4),
                                  TextLabell(
                                    text: data['nomor_ajuan'],
                                    color: Constanst.fgPrimary,
                                    size: 16,
                                    weight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextLabell(
                                    text: "Tanggal Pengajuan",
                                    color: Constanst.fgSecondary,
                                    size: 14,
                                    weight: FontWeight.w400,
                                  ),
                                  const SizedBox(height: 4),
                                  TextLabell(
                                    text: DateFormat('EEEE, dd MMM yyyy', 'id')
                                        .format(DateFormat('yyyy-MM-dd')
                                            .parse(data['tgl_ajuan'] ?? '')),
                                    color: Constanst.fgPrimary,
                                    size: 16,
                                    weight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                width: 1, color: Constanst.fgBorder)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextLabell(
                                  text: "Nama Pengajuan",
                                  color: Constanst.fgSecondary,
                                  size: 14,
                                  weight: FontWeight.w400,
                                ),
                                const SizedBox(height: 4),
                                TextLabell(
                                  text: "-",
                                  color: Constanst.fgPrimary,
                                  size: 16,
                                  weight: FontWeight.w500,
                                ),
                                const SizedBox(height: 12),
                                const Divider(
                                  thickness: 1,
                                  height: 0,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextLabell(
                                  text: "Tanggal",
                                  color: Constanst.fgSecondary,
                                  size: 14,
                                  weight: FontWeight.w400,
                                ),
                                const SizedBox(height: 4),
                                TextLabell(
                                  text: DateFormat('EEEE, dd MMM yyyy', 'id')
                                      .format(DateFormat('yyyy-MM-dd')
                                          .parse(data['atten_date'] ?? '')),
                                  color: Constanst.fgPrimary,
                                  size: 16,
                                  weight: FontWeight.w500,
                                ),
                                const SizedBox(height: 12),
                                const Divider(
                                  thickness: 1,
                                  height: 0,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextLabell(
                                        text: "Absen Masuk",
                                        color: Constanst.fgSecondary,
                                        size: 14,
                                        weight: FontWeight.w400,
                                      ),
                                      const SizedBox(height: 4),
                                      data['dari_jam'] == ""
                                          ? TextLabell(
                                              text: "_ _ : _ _",
                                              color: Constanst.fgPrimary,
                                              size: 16,
                                              weight: FontWeight.w500,
                                            )
                                          : TextLabell(
                                              text: data['dari_jam'],
                                              color: Constanst.fgPrimary,
                                              size: 16,
                                              weight: FontWeight.w500,
                                            )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextLabell(
                                        text: "Absen Keluar",
                                        color: Constanst.fgSecondary,
                                        size: 14,
                                        weight: FontWeight.w400,
                                      ),
                                      const SizedBox(height: 4),
                                      data['sampai_jam'] == ""
                                          ? TextLabell(
                                              text: "_ _ : _ _",
                                              color: Constanst.fgPrimary,
                                              size: 16,
                                              weight: FontWeight.w500,
                                            )
                                          : TextLabell(
                                              text: data['sampai_jam'],
                                              color: Constanst.fgPrimary,
                                              size: 16,
                                              weight: FontWeight.w500,
                                            )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Divider(
                              thickness: 1,
                              height: 0,
                            ),
                            const SizedBox(height: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextLabell(
                                  text: "Catatan",
                                  color: Constanst.fgSecondary,
                                  size: 14,
                                  weight: FontWeight.w400,
                                ),
                                const SizedBox(height: 4),
                                TextLabell(
                                  text: data['uraian'],
                                  color: Constanst.fgPrimary,
                                  size: 16,
                                  weight: FontWeight.w500,
                                ),
                                const SizedBox(height: 12),
                                const Divider(
                                  thickness: 1,
                                  height: 0,
                                ),
                                const SizedBox(height: 12),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextLabell(
                                  text: "File disematkan",
                                  color: Constanst.fgSecondary,
                                  size: 14,
                                  weight: FontWeight.w400,
                                ),
                                InkWell(
                                  onTap: () {
                                    viewLampiranAjuan(data['req_file']);
                                  },
                                  child: TextLabell(
                                    text: data['req_file'],
                                    color: Constanst.fgPrimary,
                                    size: 16,
                                    weight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Divider(
                                  thickness: 1,
                                  height: 0,
                                ),
                                const SizedBox(height: 12),
                              ],
                            ),
                            controllerGlobal.valuePolaPersetujuan == 1 ||
                                    controllerGlobal.valuePolaPersetujuan == "1"
                                ? singgleApproval(data)
                                : multipleApproval(data)
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  data['status'].toString().toLowerCase() ==
                          "Pending".toLowerCase()
                      ? Row(
                          children: [
                            Expanded(
                              child: Container(
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
                                    absenControllre.batalkanAjuan(
                                        date: data['atten_date']);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Constanst.color4,
                                    backgroundColor: Constanst.colorWhite,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    'Batalkan',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Constanst.color4,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox()
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget singgleApproval(data) {
    var text = "";
    if (data['approve_status'] == "Pending" || data['status'] == "Pending") {
      text = "Pending Approval";
    }
    if (data['approve_status'] == "Rejected") {
      text = "Rejected by - ${data['approve_by']}";
    }
    if (data['approve_status'] == "Approve") {
      text = "Approved by - ${data['approve_by']}";
    }
    return Container(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Status Pengajuan",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Constanst.fgSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      data['approve_status'] == "Pending" ||
                              data['status'] == "Pending"
                          ? Icon(
                              Iconsax.timer,
                              color: Constanst.warning,
                              size: 22,
                            )
                          : data['approve_status'] == "Rejected"
                              ? const Icon(
                                  Iconsax.tick_circle,
                                  color: Colors.green,
                                  size: 22,
                                )
                              : const Icon(
                                  Iconsax.tick_circle,
                                  color: Colors.green,
                                  size: 22,
                                ),
                      // Icon(
                      //   Iconsax.close_circle,
                      //   color: Constanst.color4,
                      //   size: 22,
                      // ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${text} ",
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  color: Constanst.fgPrimary,
                                  fontSize: 14)),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget multipleApproval(data) {
    var text = "";
    var text2 = "";
    if (data['approve_status'] == "Pending" || data['status'] == "Pending") {
      text = "Pending Approval 1";
    }
    if (data['approve_status'] == "Rejected") {
      text = "Rejected By - ${data['approve_by']}";
    }

    if (data['approve_status'] == "Approve") {
      text = "Approve 1 By - ${data['approve_by']}";

      if (data['approve2_status'] == "Pending" ||
          data['approve2_status'] == null) {
        text2 = "Pending Approval 2";
      }
      if (data['approve2_status'] == "Rejected") {
        text2 = "Rejected 2 By - ${data['approve2_by']}";
      }

      if (data['approve2_status'] == "Approve") {
        text2 = "Approved 2 By - ${data['approve2_by']} ";
      }
    }
    return Container(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Status Pengajuan",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Constanst.fgSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      data['approve_status'] == "Pending"
                          ? Icon(
                              Iconsax.timer,
                              color: Constanst.warning,
                              size: 22,
                            )
                          : data['approve_status'] == "Rejected"
                              ? const Icon(
                                  Iconsax.close_circle,
                                  color: Colors.red,
                                  size: 22,
                                )
                              : const Icon(
                                  Iconsax.tick_circle,
                                  color: Colors.green,
                                  size: 22,
                                ),
                      // Icon(
                      //   Iconsax.close_circle,
                      //   color: Constanst.color4,
                      //   size: 22,
                      // ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${text}",
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  color: Constanst.fgPrimary,
                                  fontSize: 14)),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ],
                  ),
                  data['approve_status'] == "Approve"
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 2.5, top: 2, bottom: 2),
                              child: Container(
                                height: 30,
                                child: VerticalDivider(
                                  color: Constanst.Secondary,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  data['approve2_status'] == "Pending" ||
                                          data['approve2_status'] == null
                                      ? Icon(
                                          Iconsax.timer,
                                          color: Constanst.warning,
                                          size: 22,
                                        )
                                      : data['approve2_status'] == "Rejected"
                                          ? const Icon(
                                              Iconsax.close_circle,
                                              color: Colors.red,
                                              size: 22,
                                            )
                                          : const Icon(
                                              Iconsax.tick_circle,
                                              color: Colors.green,
                                              size: 22,
                                            ),
                                  // Icon(
                                  //   Iconsax.close_circle,
                                  //   color: Constanst.color4,
                                  //   size: 22,
                                  // ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("${text2} ",
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              color: Constanst.fgPrimary,
                                              fontSize: 14)),
                                      const SizedBox(height: 4),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  void viewLampiranAjuan(value) async {
    var urlViewGambar = Api.UrlfotoAbsen + value;

    final url = Uri.parse(urlViewGambar);
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      UtilsAlert.showToast('Tidak dapat membuka file');
    }
  }
}
