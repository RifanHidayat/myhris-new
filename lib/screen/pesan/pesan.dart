import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/approval_controller.dart';
import 'package:siscom_operasional/controller/dashboard_controller.dart';
import 'package:siscom_operasional/controller/pesan_controller.dart';
import 'package:siscom_operasional/screen/pesan/persetujuan_lembur.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:siscom_operasional/utils/month_year_picker.dart';

class Pesan extends StatefulWidget {
  final bool status;
  const Pesan({Key? key, required this.status}) : super(key: key);
  @override
  _PesanState createState() => _PesanState();
}

class _PesanState extends State<Pesan> {
  final controller = Get.put(PesanController());
  @override
  Future<void> refreshData() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      var dashboardController = Get.find<DashboardController>();
      dashboardController.updateInformasiUser();
      controller.clearFilter();
      controller.onReady();
    });
  }

  @override
  Widget build(BuildContext context) {
    controller.selectedView.value = 0;
    return Scaffold(
      backgroundColor: Constanst.coloBackgroundScreen,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight) * 1,
        child: Container(
          // decoration: const BoxDecoration(boxShadow: [
          //   BoxShadow(
          //     color: Colors.black12,
          //     offset: Offset(0, 2.0),
          //     blurRadius: 4.0,
          //   )
          // ]),
          child: AppBar(
            backgroundColor: Constanst.colorWhite,
            elevation: 0,
            // leadingWidth: controller.statusFormPencarian.value ? 50 : 16,
            // titleSpacing: 0,
            centerTitle: false,
            title: Text(
              "Pesan",
              style: GoogleFonts.inter(
                  color: Constanst.fgPrimary,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
            ),
          ),
        ),
      ),
      body: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: SafeArea(
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // lineTitle(),
                  Flexible(
                    child: pageViewPesan(),
                  )
                ],
              ),
            ),
          )),
    );
  }

  // Widget lineTitle() {
  //   return Row(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Expanded(
  //         child: InkWell(
  //           onTap: () {
  //             if (widget.status == false) {
  //               controller.selectedView.value = 0;
  //               controller.menuController.jumpToPage(0);
  //             }
  //           },
  //           child: Container(
  //             decoration: BoxDecoration(
  //               border: Border(
  //                 bottom: BorderSide(
  //                   color: controller.selectedView.value == 0
  //                       ? Constanst.colorPrimary
  //                       : Constanst.color6,
  //                   width: 2.0,
  //                 ),
  //               ),
  //             ),
  //             child: Padding(
  //               padding: const EdgeInsets.only(bottom: 8),
  //               child: Row(
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Text(
  //                     "Notifikasi",
  //                     style: TextStyle(
  //                         color: controller.selectedView.value == 0
  //                             ? Constanst.colorPrimary
  //                             : Constanst.colorText2,
  //                         fontWeight: FontWeight.bold),
  //                   ),
  //                   controller.jumlahNotifikasiBelumDibaca.value == 0
  //                       ? SizedBox()
  //                       : Obx(
  //                           () => Container(
  //                               margin: EdgeInsets.only(left: 6),
  //                               decoration: BoxDecoration(
  //                                 color: Constanst.colorButton2,
  //                                 borderRadius: Constanst.borderStyle3,
  //                               ),
  //                               child: Padding(
  //                                 padding:
  //                                     const EdgeInsets.only(left: 8, right: 8),
  //                                 child: Text(
  //                                   "${controller.jumlahNotifikasiBelumDibaca.value}"
  //                                               .length >
  //                                           2
  //                                       ? "${controller.jumlahNotifikasiBelumDibaca.value}"
  //                                               .substring(0, 2) +
  //                                           '+'
  //                                       : "${controller.jumlahNotifikasiBelumDibaca.value}",
  //                                 ),
  //                               )),
  //                         ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //       Expanded(
  //         child: InkWell(
  //           onTap: () {
  //             if (widget.status == false) {
  //               controller.selectedView.value = 1;
  //               controller.menuController.jumpToPage(1);
  //             }
  //           },
  //           child: Container(
  //             decoration: BoxDecoration(
  //               border: Border(
  //                 bottom: BorderSide(
  //                   color: controller.selectedView.value == 1
  //                       ? Constanst.colorPrimary
  //                       : Constanst.color6,
  //                   width: 2.0,
  //                 ),
  //               ),
  //             ),
  //             child: Padding(
  //               padding: const EdgeInsets.only(bottom: 8),
  //               child: Row(
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Text(
  //                     "Persetujuan",
  //                     style: TextStyle(
  //                         color: controller.selectedView.value == 1
  //                             ? Constanst.colorPrimary
  //                             : Constanst.colorText2,
  //                         fontWeight: FontWeight.bold),
  //                   ),
  //                   controller.jumlahPersetujuan.value == 0
  //                       ? SizedBox()
  //                       : Obx(
  //                           () => Container(
  //                               margin: EdgeInsets.only(left: 6),
  //                               decoration: BoxDecoration(
  //                                 color: Constanst.colorButton2,
  //                                 borderRadius: Constanst.borderStyle3,
  //                               ),
  //                               child: Padding(
  //                                 padding:
  //                                     const EdgeInsets.only(left: 8, right: 8),
  //                                 child: Text(
  //                                   "${controller.jumlahPersetujuan.value}"
  //                                               .length >
  //                                           2
  //                                       ? "${controller.jumlahPersetujuan.value}"
  //                                               .substring(0, 2) +
  //                                           '+'
  //                                       : "${controller.jumlahPersetujuan.value}",
  //                                 ),
  //                               )),
  //                         ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //       Expanded(
  //         child: InkWell(
  //           onTap: () {
  //             if (widget.status == false) {
  //               controller.selectedView.value = 2;
  //               controller.menuController.jumpToPage(2);
  //             }
  //           },
  //           child: Container(
  //             decoration: BoxDecoration(
  //               border: Border(
  //                 bottom: BorderSide(
  //                   color: controller.selectedView.value == 2
  //                       ? Constanst.colorPrimary
  //                       : Constanst.color6,
  //                   width: 2.0,
  //                 ),
  //               ),
  //             ),
  //             child: Padding(
  //               padding: const EdgeInsets.only(bottom: 8),
  //               child: Row(
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Text(
  //                     "Riwayat",
  //                     style: TextStyle(
  //                         color: controller.selectedView.value == 2
  //                             ? Constanst.colorPrimary
  //                             : Constanst.colorText2,
  //                         fontWeight: FontWeight.bold),
  //                   ),
  //                   controller.jumlahRiwayat.value == 0
  //                       ? SizedBox()
  //                       : Obx(
  //                           () => Container(
  //                               margin: EdgeInsets.only(left: 6),
  //                               decoration: BoxDecoration(
  //                                 color: Constanst.colorButton2,
  //                                 borderRadius: Constanst.borderStyle3,
  //                               ),
  //                               child: Padding(
  //                                 padding:
  //                                     const EdgeInsets.only(left: 8, right: 8),
  //                                 child: Text(
  //                                   "${controller.jumlahRiwayat.value}".length >
  //                                           2
  //                                       ? "${controller.jumlahRiwayat.value}"
  //                                               .substring(0, 2) +
  //                                           '+'
  //                                       : "${controller.jumlahRiwayat.value}",
  //                                 ),
  //                               )),
  //                         ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       )
  //     ],
  //   );
  // }

  Widget pageViewPesan() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            indicatorColor: Constanst.onPrimary,
            indicatorWeight: 4.0,
            labelPadding: const EdgeInsets.fromLTRB(0, 0, 0, 14),
            indicatorSize: TabBarIndicatorSize.label,
            physics: const BouncingScrollPhysics(),
            labelColor: Constanst.onPrimary,
            unselectedLabelColor: Constanst.fgSecondary,
            tabs: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 22,
                    width: 22,
                    decoration: BoxDecoration(
                        color: Constanst.colorStateDangerBg,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(100.0),
                        ),
                        border: Border.all(
                          width: 1.0,
                          color: Constanst.colorStateDangerBorder,
                        )),
                    child: Center(
                      child: Obx(
                        () => Text(
                          "${controller.jumlahNotifikasiBelumDibaca.value}"
                                      .length >
                                  2
                              ? '${"${controller.jumlahNotifikasiBelumDibaca.value}".substring(0, 2)}+'
                              : "${controller.jumlahNotifikasiBelumDibaca.value}",
                          style: GoogleFonts.inter(
                              color: Constanst.colorStateOnDangerBg,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                    child: Text(
                      "Notifikasi",
                      style: GoogleFonts.inter(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 22,
                    width: 22,
                    decoration: BoxDecoration(
                        color: Constanst.colorStateDangerBg,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(100.0),
                        ),
                        border: Border.all(
                          width: 1.0,
                          color: Constanst.colorStateDangerBorder,
                        )),
                    child: Center(
                      child: Obx(
                        () => Text(
                          "${controller.jumlahPersetujuan.value}".length > 2
                              ? '${"${controller.jumlahPersetujuan.value}".substring(0, 2)}+'
                              : "${controller.jumlahPersetujuan.value}",
                          style: GoogleFonts.inter(
                              color: Constanst.colorStateOnDangerBg,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                    child: Text(
                      "Persetujuan",
                      style: GoogleFonts.inter(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.end,
              //   children: [
              //     Container(
              //       height: 22,
              //       width: 22,
              //       decoration: BoxDecoration(
              //           color: Constanst.colorStateDangerBg,
              //           borderRadius: const BorderRadius.all(
              //             Radius.circular(100.0),
              //           ),
              //           border: Border.all(
              //             width: 1.0,
              //             color: Constanst.colorStateDangerBorder,
              //           )),
              //       child: Center(
              //         child: Obx(
              //           () => Text(
              //             "${controller.jumlahRiwayat.value}".length > 2
              //                 ? '${"${controller.jumlahRiwayat.value}".substring(0, 2)}+'
              //                 : "${controller.jumlahRiwayat.value}",
              //             style: GoogleFonts.inter(
              //                 color: Constanst.colorStateOnDangerBg,
              //                 fontSize: 12,
              //                 fontWeight: FontWeight.w500),
              //           ),
              //         ),
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              //       child: Text(
              //         "Riwayat",
              //         style: GoogleFonts.inter(
              //             fontSize: 16, fontWeight: FontWeight.w500),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
          Divider(
            thickness: 1,
            height: 1,
            color: Constanst.fgBorder,
          ),
          Expanded(
            child: TabBarView(
              physics: const BouncingScrollPhysics(),
              children: [
                screenNotifikasi(),
                screenPersetujuan(),
                // screenRiwayat(),
              ],
            ),
          ),
          // PageView.builder(
          //     physics: BouncingScrollPhysics(),
          //     controller: controller.menuController,
          //     onPageChanged: (index) {
          //       controller.selectedView.value = index;
          //     },
          //     itemCount: 3,
          //     itemBuilder: (context, index) {
          //       return Padding(
          //           padding: EdgeInsets.all(0),
          //           child: index == 0
          //               ? screenNotifikasi()
          //               : index == 1
          //                   ? screenPersetujuan()
          //                   : index == 2
          //                       ? screenRiwayat()
          //                       : SizedBox());
          //     }),
        ],
      ),
    );
  }

  Widget screenNotifikasi() {
    return RefreshIndicator(
      onRefresh: refreshData,
      child: controller.listNotifikasi.value.isEmpty
          ? SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/amico.svg',
                      height: 250,
                      width: 250,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Anda tidak memiliki Notifikasi",
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          color: Constanst.fgPrimary,
                          fontSize: 16),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            )
          : ListView.builder(
              itemCount: controller.listNotifikasi.value.length,
              physics: controller.listNotifikasi.value.length <= 10
                  ? const AlwaysScrollableScrollPhysics()
                  : const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                var tanggalNotif =
                    controller.listNotifikasi.value[index]['tanggal'];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 24.0, 0.0, 4.0),
                      child: Text(
                        // Constanst.convertDate(tanggalNotif.toString()),
                        // tanggalNotif,
                        tanggalNotif == "Hari ini"
                            ? tanggalNotif
                            : Constanst.convertDate6(DateFormat('dd-MM-yyyy')
                                .parseStrict(tanggalNotif)
                                .toString()),
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            color: Constanst.fgSecondary,
                            fontSize: 14),
                      ),
                    ),
                    Obx(
                      () => ListView.builder(
                          itemCount: controller
                              .listNotifikasi.value[index]['notifikasi'].length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, idx) {
                            var idNotif = controller.listNotifikasi.value[index]
                                ['notifikasi'][idx]['id'];
                            var titleNotif = controller.listNotifikasi
                                .value[index]['notifikasi'][idx]['title'];
                            var deskripsiNotif = controller.listNotifikasi
                                .value[index]['notifikasi'][idx]['deskripsi'];
                            var urlRoute = controller.listNotifikasi
                                .value[index]['notifikasi'][idx]['url'];
                            var jam = controller.listNotifikasi.value[index]
                                ['notifikasi'][idx]['jam'];
                            var statusNotif = controller.listNotifikasi
                                .value[index]['notifikasi'][idx]['status'];
                            var view = controller.listNotifikasi.value[index]
                                ['notifikasi'][idx]['view'];
                            var emId = controller.listNotifikasi.value[index]
                                ['notifikasi'][idx]['em_id'];
                            var emIdPengaju =
                                controller.listNotifikasi.value[index]
                                    ['notifikasi'][idx]['em_id_pengajuan'];
                            var idDetail = controller.listNotifikasi
                                .value[index]['notifikasi'][idx]['idx'];
                            return Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: view == 0
                                        ? Constanst.colorButton2
                                        : Colors.transparent,
                                    borderRadius: Constanst.borderStyle1,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      print(
                                          "wkwkwk: ${controller.listNotifikasi.value[index]['notifikasi'][idx]}");
                                      if (emIdPengaju !=
                                              AppData.informasiUser![0].em_id &&
                                          idDetail != null) {
                                        if (view == 0) {
                                          controller.aksilihatNotif(idNotif);
                                        }
                                        controller.routeApprovalNotif(
                                          title: titleNotif,
                                          emIdPengaju: emIdPengaju.toString(),
                                          idx: idDetail.toString(),
                                          delegasi: emId.toString(),
                                          url: urlRoute,
                                        );
                                      } else if (emIdPengaju.toString() ==
                                          AppData.informasiUser![0].em_id) {
                                        if (view == 0) {
                                          controller.aksilihatNotif(idNotif);
                                        }
                                        controller.redirectToPage(
                                            urlRoute, idDetail);
                                      } else {
                                        if (view == 0) {
                                          controller.aksilihatNotif(idNotif);
                                        }
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16.0, 12.0, 16.0, 12.0),
                                      child: IntrinsicHeight(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            statusNotif == 1
                                                ? Icon(
                                                    Iconsax.tick_circle,
                                                    color: Constanst.color5,
                                                    size: 24,
                                                  )
                                                : statusNotif == 2
                                                    ? Icon(
                                                        Iconsax.sms5,
                                                        color: Constanst
                                                            .fgSecondary,
                                                        size: 24,
                                                      )
                                                    : statusNotif == 0
                                                        ? Icon(
                                                            Iconsax
                                                                .close_circle,
                                                            color: Constanst
                                                                .color4,
                                                            size: 24,
                                                          )
                                                        : const SizedBox(),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 5),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            titleNotif,
                                                            style: GoogleFonts.inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Constanst
                                                                    .fgPrimary,
                                                                fontSize: 16),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      deskripsiNotif,
                                                      style: GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Constanst
                                                              .fgSecondary,
                                                          fontSize: 14),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      "$jam WIB",
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Constanst
                                                              .fgSecondary,
                                                          fontSize: 14),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Divider(
                                  thickness: 1,
                                  height: 0,
                                  color: Constanst.fgBorder,
                                ),
                              ],
                            );
                          }),
                    ),
                  ],
                );
              }),
    );
  }

  Widget pickDate() {
    return Row(
      children: [
        // Container(
        //   decoration: BoxDecoration(
        //       borderRadius: const BorderRadius.all(
        //         Radius.circular(100.0),
        //       ),
        //       border: Border.all(
        //         width: 1.0,
        //         color: Constanst.border,
        //       )),
        //   margin: const EdgeInsets.only(left: 16, right: 16),
        //   child: InkWell(
        //     customBorder: const RoundedRectangleBorder(
        //         borderRadius: BorderRadius.all(Radius.circular(100))),
        //     onTap: () {
        //       DatePicker.showPicker(
        //         Get.context!,
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
        //             controller.loadApproveInfo();
        //             controller.loadApproveHistory();
        //           }
        //         },
        //       );
        //     },
        //     child: Obx(
        //       () => Padding(
        //         padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
        //         child: Row(
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           children: [
        //             const Icon(Iconsax.calendar_2),
        //             const SizedBox(width: 4),
        //             Text(
        //               Constanst.convertDateBulanDanTahun(
        //                   controller.bulanDanTahunNow.value),
        //               style: GoogleFonts.inter(
        //                   fontWeight: FontWeight.w500,
        //                   color: Constanst.fgPrimary,
        //                   fontSize: 14),
        //             ),
        //             const SizedBox(width: 4),
        //             Icon(
        //               Iconsax.arrow_down_14,
        //               size: 22,
        //               color: Constanst.fgSecondary,
        //             )
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget screenPersetujuan() {
    return RefreshIndicator(
      onRefresh: refreshData,
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            pickDate(),
            const SizedBox(height: 8),
            Expanded(
              child: controller.dataScreenPersetujuan.value.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          alignment: Alignment.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/amico.svg',
                                height: 250,
                                width: 250,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Tidak ada data persetujuan",
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    color: Constanst.fgPrimary,
                                    fontSize: 16),
                              ),
                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      itemCount: controller.dataScreenPersetujuan.value.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        var title = controller
                            .dataScreenPersetujuan.value[index]['title'];
                        var jumlah = controller.dataScreenPersetujuan
                            .value[index]['jumlah_approve'];
                        return InkWell(
                          onTap: () => controller.routeApproval(
                              controller.dataScreenPersetujuan.value[index]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    12.0, 12.0, 19.0, 12.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          title == 'Cuti'
                                              ? 'assets/5_cuti.svg'
                                              : title == 'Lembur'
                                                  ? 'assets/4_lembur.svg'
                                                  : title == 'Tidak Hadir'
                                                      ? 'assets/3_izin.svg'
                                                      : title == 'Tugas Luar'
                                                          ? 'assets/6_tugas_luar.svg'
                                                          : title ==
                                                                  'Dinas Luar'
                                                              ? 'assets/6_tugas_luar.svg'
                                                              : title == 'Klaim'
                                                                  ? 'assets/7_klaim.svg'
                                                                  : title ==
                                                                          'Payroll'
                                                                      ? 'assets/3_izin.svg'
                                                                      : title ==
                                                                              'Absensi'
                                                                          ? 'assets/2_absen.svg'
                                                                          : 'assets/3_izin.svg',
                                          height: 35,
                                          width: 35,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 12),
                                          child: Text(
                                            title == 'Cuti'
                                                ? 'Persetujuan Cuti'
                                                : title == 'Lembur'
                                                    ? 'Persetujuan Lembur'
                                                    : title == 'Tidak Hadir'
                                                        ? 'Persetujuan Izin'
                                                        : title == 'Tugas Luar'
                                                            ? 'Persetujuan Tugas Luar'
                                                            : title ==
                                                                    'Dinas Luar'
                                                                ? 'Persetujuan Dinas Luar'
                                                                : title ==
                                                                        'Klaim'
                                                                    ? 'Persetujuan Klaim'
                                                                    : title ==
                                                                            'Payroll'
                                                                        ? 'Persetujuan Payroll'
                                                                        : title ==
                                                                                'Absensi'
                                                                            ? 'Persetujuan Absensi'
                                                                            : title == 'WFH'
                                                                                ? 'Persetujuan WFH'
                                                                                : 'Persetujuan Kasbon',
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w500,
                                                color: Constanst.fgPrimary,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // title == 'Cuti'
                                    //     ? Icon(
                                    //         Iconsax.calendar_remove,
                                    //         color: Constanst.colorPrimary,
                                    //       )
                                    //     : title == 'Lembur'
                                    //         ? Icon(
                                    //             Iconsax.clock,
                                    //             color: Constanst.colorPrimary,
                                    //           )
                                    //         : title == 'Tidak Hadir'
                                    //             ? Icon(
                                    //                 Iconsax.clipboard_close,
                                    //                 color:
                                    //                     Constanst.colorPrimary,
                                    //               )
                                    //             : title == 'Tugas Luar'
                                    //                 ? Icon(
                                    //                     Iconsax.send_2,
                                    //                     color: Constanst
                                    //                         .colorPrimary,
                                    //                   )
                                    //                 : title == 'Dinas Luar'
                                    //                     ? Icon(
                                    //                         Iconsax.airplane,
                                    //                         color: Constanst
                                    //                             .colorPrimary,
                                    //                       )
                                    //                     : title == 'Klaim'
                                    //                         ? Icon(
                                    //                             Iconsax.receipt,
                                    //                             color: Constanst
                                    //                                 .colorPrimary,
                                    //                           )
                                    //                         : title == 'Payroll'
                                    //                             ? Icon(
                                    //                                 Iconsax
                                    //                                     .receipt,
                                    //                                 color: Constanst
                                    //                                     .colorPrimary,
                                    //                               )
                                    //                             : title ==
                                    //                                     'Absensi'
                                    //                                 ? Icon(
                                    //                                     Iconsax
                                    //                                         .receipt,
                                    //                                     color: Constanst
                                    //                                         .colorPrimary,
                                    //                                   )
                                    //                                 : const SizedBox(),
                                    Row(
                                      children: [
                                        Container(
                                          height: 22,
                                          width: 22,
                                          decoration: BoxDecoration(
                                              color:
                                                  Constanst.colorStateDangerBg,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(100.0),
                                              ),
                                              border: Border.all(
                                                width: 1.0,
                                                color: Constanst
                                                    .colorStateDangerBorder,
                                              )),
                                          child: Center(
                                            child: Text(
                                              jumlah,
                                              style: GoogleFonts.inter(
                                                  color: Constanst
                                                      .colorStateOnDangerBg,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            color: Constanst.colorText2,
                                            size: 18,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget screenRiwayat() {
    return controller.riwayatPersetujuan.value.isEmpty
        ? Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/amico.png",
                  height: 250,
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Kamu tidak memiliki Riwayat Persetujuan")
              ],
            ),
          )
        : Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 8,
                ),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 85,
                        child: controller.statusFilteriwayat.value == false
                            ? Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: pencarianData(),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: Text(
                                        "Filter ${controller.stringFilterSelected.value}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Constanst.colorText1),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        controller.clearFilter();
                                      },
                                      child: Padding(
                                          padding: EdgeInsets.only(left: 8),
                                          child: Icon(Iconsax.close_circle,
                                              color: Colors.red)),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                      Expanded(
                        flex: 15,
                        child: controller.statusCari.value == true
                            ? SizedBox()
                            : Container(
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: Constanst.borderStyle5,
                                    border: Border.all(
                                        color: Constanst.colorText3)),
                                child: PopupMenuButton(
                                  padding: EdgeInsets.all(0.0),
                                  icon: Icon(
                                    Iconsax.setting_4,
                                  ),
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                        value: "1",
                                        onTap: () =>
                                            controller.filterApproveHistory(
                                                'Pengajuan Tidak Hadir'),
                                        child: Text("Pengajuan Tidak Hadir")),
                                    PopupMenuItem(
                                        value: "2",
                                        onTap: () =>
                                            controller.filterApproveHistory(
                                                'Pengajuan Cuti'),
                                        child: Text("Pengajuan Cuti")),
                                    PopupMenuItem(
                                        value: "3",
                                        onTap: () =>
                                            controller.filterApproveHistory(
                                                'Pengajuan Lembur'),
                                        child: Text("Pengajuan Lembur")),
                                    PopupMenuItem(
                                        value: "4",
                                        onTap: () =>
                                            controller.filterApproveHistory(
                                                'Pengajuan Tugas Luar'),
                                        child: Text("Pengajuan Tugas Luar")),
                                    PopupMenuItem(
                                        value: "5",
                                        onTap: () =>
                                            controller.filterApproveHistory(
                                                'Pengajuan Dinas Luar'),
                                        child: Text("Pengajuan Dinas Luar")),
                                    PopupMenuItem(
                                        value: "6",
                                        onTap: () =>
                                            controller.filterApproveHistory(
                                                'Pengajuan Klaim'),
                                        child: Text("Pengajuan Klaim")),
                                  ],
                                )),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Obx(
                  () => Flexible(
                      flex: 3,
                      child: RefreshIndicator(
                        onRefresh: refreshData,
                        child: controller.riwayatPersetujuan.value.isEmpty
                            ? Center(
                                child:
                                    CircularProgressIndicator(strokeWidth: 3),
                              )
                            : controller.statusCari.value == true
                                ? listPencarian()
                                : controller.statusFilteriwayat.value == false
                                    ? listFilterRiwayatNonAktif()
                                    : listFilterRiwayatAktif(),
                      )),
                ),
              ],
            ),
          );
  }

  Widget pencarianData() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: Constanst.borderStyle5,
          border: Border.all(color: Constanst.colorNonAktif)),
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
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 85,
                        child: TextField(
                          controller: controller.cari.value,
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: "Cari"),
                          style: TextStyle(
                              fontSize: 14.0, height: 1.0, color: Colors.black),
                          onChanged: (value) {
                            controller.cariData(value);
                          },
                          onSubmitted: (value) {
                            print(value);
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
                                  controller.riwayatPersetujuan.value.clear();
                                  controller.statusCari.value = false;
                                  controller.cari.value.text = "";
                                  controller.onReady();
                                  ;
                                },
                              ),
                            )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget listPencarian() {
    return ListView.builder(
        shrinkWrap: true,
        physics: controller.riwayatPersetujuan.value.length <= 8
            ? AlwaysScrollableScrollPhysics()
            : BouncingScrollPhysics(),
        itemCount: controller.riwayatPersetujuan.value.length,
        itemBuilder: (context, ixx) {
          var idx = controller.riwayatPersetujuan.value[ixx]['id'];
          var status;
          if (controller.valuePolaPersetujuan.value == "1") {
            status = controller.riwayatPersetujuan.value[ixx]['status'];
          } else {
            status =
                controller.riwayatPersetujuan.value[ixx]['status'] == "Approve"
                    ? "Approve 1"
                    : controller.riwayatPersetujuan.value[ixx]['status'] ==
                            "Approve2"
                        ? "Approve 2"
                        : controller.riwayatPersetujuan.value[ixx]['status'];
          }
          var namaPengaju =
              controller.riwayatPersetujuan.value[ixx]['nama_pengaju'];
          var typeAjuan = controller.riwayatPersetujuan.value[ixx]['type'];
          var tanggalPengajuan =
              controller.riwayatPersetujuan.value[ixx]['waktu_pengajuan'];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 16,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: Constanst.borderStyle2,
                  boxShadow: [
                    BoxShadow(
                      color:
                          Color.fromARGB(255, 170, 170, 170).withOpacity(0.4),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(1, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, top: 8, bottom: 8, right: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 60,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                namaPengaju ?? "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 40,
                            child: Container(
                              margin: EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: status == 'Approve'
                                    ? Constanst.colorBGApprove
                                    : status == 'Approve 1'
                                        ? Constanst.colorBGApprove
                                        : status == 'Approve 2'
                                            ? Constanst.colorBGApprove
                                            : status == 'Rejected'
                                                ? Constanst.colorBGRejected
                                                : status == 'Pending'
                                                    ? Constanst.colorBGPending
                                                    : Colors.grey,
                                borderRadius: Constanst.borderStyle1,
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 3, right: 3, top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    status == 'Approve'
                                        ? Icon(
                                            Iconsax.tick_square,
                                            color: Constanst.color5,
                                            size: 14,
                                          )
                                        : status == 'Approve 1'
                                            ? Icon(
                                                Iconsax.tick_square,
                                                color: Constanst.color5,
                                                size: 14,
                                              )
                                            : status == 'Approve 2'
                                                ? Icon(
                                                    Iconsax.tick_square,
                                                    color: Constanst.color5,
                                                    size: 14,
                                                  )
                                                : status == 'Rejected'
                                                    ? Icon(
                                                        Iconsax.close_square,
                                                        color: Constanst.color4,
                                                        size: 14,
                                                      )
                                                    : status == 'Pending'
                                                        ? Icon(
                                                            Iconsax.timer,
                                                            color: Constanst
                                                                .color3,
                                                            size: 14,
                                                          )
                                                        : SizedBox(),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 3),
                                      child: Text(
                                        '$status',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: status == 'Approve'
                                                ? Colors.green
                                                : status == 'Approve 1'
                                                    ? Colors.green
                                                    : status == 'Approve 2'
                                                        ? Colors.green
                                                        : status == 'Rejected'
                                                            ? Colors.red
                                                            : status ==
                                                                    'Pending'
                                                                ? Constanst
                                                                    .color3
                                                                : Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        typeAjuan ?? "",
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "${Constanst.convertDate1("$tanggalPengajuan")}",
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          controller.filterDetailRiwayatApproval(
                              idx, typeAjuan);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Constanst.colorPrimary,
                              borderRadius: Constanst.borderStyle3),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: Center(
                              child: Text(
                                "Lihat Detail",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        });
  }

  Widget listFilterRiwayatAktif() {
    return ListView.builder(
        shrinkWrap: true,
        physics: controller.riwayatPersetujuan.value.length <= 8
            ? AlwaysScrollableScrollPhysics()
            : BouncingScrollPhysics(),
        itemCount: controller.riwayatPersetujuan.value.length,
        itemBuilder: (context, ixx) {
          var idx = controller.riwayatPersetujuan.value[ixx]['id'];
          var status;
          if (controller.valuePolaPersetujuan.value == "1") {
            status = controller.riwayatPersetujuan.value[ixx]['status'];
          } else {
            status =
                controller.riwayatPersetujuan.value[ixx]['status'] == "Approve"
                    ? "Approve 1"
                    : controller.riwayatPersetujuan.value[ixx]['status'] ==
                            "Approve2"
                        ? "Approve 2"
                        : controller.riwayatPersetujuan.value[ixx]['status'];
          }
          var namaPengaju =
              controller.riwayatPersetujuan.value[ixx]['nama_pengaju'];
          var typeAjuan = controller.riwayatPersetujuan.value[ixx]['type'];
          var tanggalPengajuan =
              controller.riwayatPersetujuan.value[ixx]['waktu_pengajuan'];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 16,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: Constanst.borderStyle2,
                  boxShadow: [
                    BoxShadow(
                      color:
                          Color.fromARGB(255, 170, 170, 170).withOpacity(0.4),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(1, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, top: 8, bottom: 8, right: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 60,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                namaPengaju ?? "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 40,
                            child: Container(
                              margin: EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: status == 'Approve'
                                    ? Constanst.colorBGApprove
                                    : status == 'Approve 1'
                                        ? Constanst.colorBGApprove
                                        : status == 'Approve 2'
                                            ? Constanst.colorBGApprove
                                            : status == 'Rejected'
                                                ? Constanst.colorBGRejected
                                                : status == 'Pending'
                                                    ? Constanst.colorBGPending
                                                    : Colors.grey,
                                borderRadius: Constanst.borderStyle1,
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 3, right: 3, top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    status == 'Approve'
                                        ? Icon(
                                            Iconsax.tick_square,
                                            color: Constanst.color5,
                                            size: 14,
                                          )
                                        : status == 'Approve 1'
                                            ? Icon(
                                                Iconsax.tick_square,
                                                color: Constanst.color5,
                                                size: 14,
                                              )
                                            : status == 'Approve 2'
                                                ? Icon(
                                                    Iconsax.tick_square,
                                                    color: Constanst.color5,
                                                    size: 14,
                                                  )
                                                : status == 'Rejected'
                                                    ? Icon(
                                                        Iconsax.close_square,
                                                        color: Constanst.color4,
                                                        size: 14,
                                                      )
                                                    : status == 'Pending'
                                                        ? Icon(
                                                            Iconsax.timer,
                                                            color: Constanst
                                                                .color3,
                                                            size: 14,
                                                          )
                                                        : SizedBox(),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 3),
                                      child: Text(
                                        '$status',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: status == 'Approve'
                                                ? Colors.green
                                                : status == 'Approve 1'
                                                    ? Colors.green
                                                    : status == 'Approve 2'
                                                        ? Colors.green
                                                        : status == 'Rejected'
                                                            ? Colors.red
                                                            : status ==
                                                                    'Pending'
                                                                ? Constanst
                                                                    .color3
                                                                : Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        typeAjuan ?? "",
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "${Constanst.convertDate1("$tanggalPengajuan")}",
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          controller.filterDetailRiwayatApproval(
                              idx, typeAjuan);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Constanst.colorPrimary,
                              borderRadius: Constanst.borderStyle3),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: Center(
                              child: Text(
                                "Lihat Detail",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        });
  }

  Widget listFilterRiwayatNonAktif() {
    return ListView.builder(
        itemCount: controller.riwayatPersetujuan.value.length,
        physics: controller.riwayatPersetujuan.value.length <= 4
            ? AlwaysScrollableScrollPhysics()
            : BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          var tanggalNotif =
              controller.riwayatPersetujuan.value[index]['waktu_pengajuan'];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                "${Constanst.convertDate1("$tanggalNotif")}",
                style: TextStyle(
                    color: Constanst.colorText1,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              Obx(
                () => Padding(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: controller
                            .riwayatPersetujuan.value[index]['turunan'].length,
                        itemBuilder: (context, ixx) {
                          var idx = controller.riwayatPersetujuan.value[index]
                              ['turunan'][ixx]['id'];
                          var status;
                          if (controller.valuePolaPersetujuan.value == "1") {
                            status = controller.riwayatPersetujuan.value[index]
                                ['turunan'][ixx]['status'];
                          } else {
                            status = controller.riwayatPersetujuan.value[index]
                                        ['turunan'][ixx]['status'] ==
                                    "Approve"
                                ? "Approve 1"
                                : controller.riwayatPersetujuan.value[index]
                                            ['turunan'][ixx]['status'] ==
                                        "Approve2"
                                    ? "Approve 2"
                                    : controller.riwayatPersetujuan.value[index]
                                        ['turunan'][ixx]['status'];
                          }

                          var namaPengaju = controller.riwayatPersetujuan
                              .value[index]['turunan'][ixx]['nama_pengaju'];
                          var typeAjuan = controller.riwayatPersetujuan
                              .value[index]['turunan'][ixx]['type'];
                          var tanggalPengajuan = controller.riwayatPersetujuan
                              .value[index]['turunan'][ixx]['waktu_pengajuan'];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 16,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: Constanst.borderStyle2,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromARGB(255, 170, 170, 170)
                                          .withOpacity(0.4),
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: Offset(
                                          1, 1), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, top: 8, bottom: 8, right: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 60,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 5),
                                              child: Text(
                                                namaPengaju,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 40,
                                            child: Container(
                                              margin: EdgeInsets.only(right: 8),
                                              decoration: BoxDecoration(
                                                color: status == 'Approve'
                                                    ? Constanst.colorBGApprove
                                                    : status == 'Approve 1'
                                                        ? Constanst
                                                            .colorBGApprove
                                                        : status == 'Approve 2'
                                                            ? Constanst
                                                                .colorBGApprove
                                                            : status ==
                                                                    'Rejected'
                                                                ? Constanst
                                                                    .colorBGRejected
                                                                : status ==
                                                                        'Pending'
                                                                    ? Constanst
                                                                        .colorBGPending
                                                                    : Colors
                                                                        .grey,
                                                borderRadius:
                                                    Constanst.borderStyle1,
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 3,
                                                    right: 3,
                                                    top: 5,
                                                    bottom: 5),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    status == 'Approve'
                                                        ? Icon(
                                                            Iconsax.tick_square,
                                                            color: Constanst
                                                                .color5,
                                                            size: 14,
                                                          )
                                                        : status == 'Approve 1'
                                                            ? Icon(
                                                                Iconsax
                                                                    .tick_square,
                                                                color: Constanst
                                                                    .color5,
                                                                size: 14,
                                                              )
                                                            : status ==
                                                                    'Approve 2'
                                                                ? Icon(
                                                                    Iconsax
                                                                        .tick_square,
                                                                    color: Constanst
                                                                        .color5,
                                                                    size: 14,
                                                                  )
                                                                : status ==
                                                                        'Rejected'
                                                                    ? Icon(
                                                                        Iconsax
                                                                            .close_square,
                                                                        color: Constanst
                                                                            .color4,
                                                                        size:
                                                                            14,
                                                                      )
                                                                    : status ==
                                                                            'Pending'
                                                                        ? Icon(
                                                                            Iconsax.timer,
                                                                            color:
                                                                                Constanst.color3,
                                                                            size:
                                                                                14,
                                                                          )
                                                                        : SizedBox(),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 3),
                                                      child: Text(
                                                        '$status',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: status ==
                                                                    'Approve'
                                                                ? Colors.green
                                                                : status ==
                                                                        'Approve 1'
                                                                    ? Colors
                                                                        .green
                                                                    : status ==
                                                                            'Approve 2'
                                                                        ? Colors
                                                                            .green
                                                                        : status ==
                                                                                'Rejected'
                                                                            ? Colors.red
                                                                            : status == 'Pending'
                                                                                ? Constanst.color3
                                                                                : Colors.black),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        typeAjuan,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          controller
                                              .filterDetailRiwayatApproval(
                                                  idx, typeAjuan);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Constanst.colorPrimary,
                                              borderRadius:
                                                  Constanst.borderStyle3),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5, bottom: 5),
                                            child: Center(
                                              child: Text(
                                                "Lihat Detail",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          );
                        })),
              ),
              SizedBox(
                height: 16,
              ),
            ],
          );
        });
  }
}
