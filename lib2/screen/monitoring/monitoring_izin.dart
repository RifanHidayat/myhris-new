import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/laporan_absen_karyawan_controller.dart';
import 'package:siscom_operasional/controller/monitoring_controller.dart';
import 'package:siscom_operasional/model/absen_model.dart';
import 'package:siscom_operasional/model/monitoring_data_model.dart';
import 'package:siscom_operasional/screen/absen/detail_absen.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/appbar_widget.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/month_year_picker.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class monitoringIzin extends StatefulWidget {
  String? em_id, full_name;
  monitoringIzin({Key? key, this.em_id, this.full_name}) : super(key: key);
  @override
  _monitoringIzinState createState() => _monitoringIzinState();
}

class _monitoringIzinState extends State<monitoringIzin> {
  var controller = Get.put(MonitoringController());

  @override
  void initState() {
    controller.getTimeNow();
    controller.loadMonitoringIzin();
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
                "Monitoring Izin",
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
                  filterData(),
                  const SizedBox(height: 8),
                  Obx(
                    () => UtilsAlert.infoContainer(
                        "Dari ${AppData.informasiUser![0].beginPayroll} ${Constanst.bulanIndo(controller.bulanSelectedStartPeriod.value)} sampai ${AppData.informasiUser![0].endPayroll} ${Constanst.bulanIndo(controller.bulanSelectedEndPeriod.value)} ${controller.tahunSelectedEndPeriod.value}"),
                  ),
                  const SizedBox(height: 12),
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
                        child: controller
                                .listDetailLaporanEmployee.value.isEmpty
                            ? Center(child: Text("${controller.loading.value}"))
                            : listAjuanTidakMasukEmployee()),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget filterData() {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: InkWell(
        customBorder: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(100))),
        onTap: () {
          Get.bottomSheet(
            BottomSheet(
              onClosing: () {},
              builder: (context) {
                return IntrinsicHeight(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 32,
                      horizontal: 16,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Constanst.colorWhite,
                              border: Border.all(
                                color: Constanst.fgPrimary,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                DatePicker.showPicker(
                                  Get.context!,
                                  pickerModel: CustomMonthPicker(
                                    minTime: DateTime(2000, 1, 1),
                                    maxTime: DateTime(2100, 1, 1),
                                    currentTime: DateTime(
                                      int.parse(controller
                                          .tahunSelectedStartPeriod.value),
                                      int.parse(controller
                                          .bulanSelectedStartPeriod.value),
                                      1,
                                    ),
                                  ),
                                  onConfirm: (time) {
                                    if (time != null) {
                                      var filter =
                                          DateFormat('yyyy-MM').format(time);
                                      var array = filter.split('-');
                                      var startBulan = array[1];
                                      var startTahun = array[0];

                                      // Validasi apakah bulan dan tahun periode awal valid
                                      bool isValid =
                                          controller.validateStartPeriod(
                                        startBulan,
                                        startTahun,
                                        controller.bulanSelectedEndPeriod.value,
                                        controller.tahunSelectedEndPeriod.value
                                      );

                                      if (isValid) {
                                        controller.bulanSelectedStartPeriod
                                            .value = startBulan;
                                        controller.tahunSelectedStartPeriod
                                            .value = startTahun;
                                        controller.startPeriode.value =
                                            "$startTahun-$startBulan-${AppData.informasiUser![0].beginPayroll}";

                                        // Refresh observables
                                        controller.bulanSelectedStartPeriod
                                            .refresh();
                                        controller.tahunSelectedStartPeriod
                                            .refresh();
                                        controller.startPeriode.refresh();
                                        controller.loadMonitoringIzin();
                                      }
                                    }
                                  },
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text("Pilih Tanggal Mulai"),
                                  Obx(() => Text(
                                        "${Constanst.bulanIndo(controller.bulanSelectedStartPeriod.value)} ${controller.tahunSelectedStartPeriod.value}",
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const VerticalDivider(),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Constanst.colorWhite,
                              border: Border.all(
                                color: Constanst.fgPrimary,
                                width: 1.0,
                              ),
                              borderRadius:
                                  BorderRadius.circular(10), // Sudut melengkung
                            ),
                            child: GestureDetector(
                              onTap: () {
                                DatePicker.showPicker(
                                  Get.context!,
                                  pickerModel: CustomMonthPicker(
                                    minTime: DateTime(2000, 1, 1),
                                    maxTime: DateTime(2100, 1, 1),
                                    currentTime: DateTime(
                                      int.parse(controller
                                          .tahunSelectedEndPeriod.value),
                                      int.parse(controller
                                          .bulanSelectedEndPeriod.value),
                                      1,
                                    ),
                                  ),
                                  onConfirm: (time) {
                                    if (time != null) {
                                      var filter =
                                          DateFormat('yyyy-MM').format(time);
                                      var array = filter.split('-');
                                      var bulan = array[1];
                                      var tahun = array[0];

                                      // Validasi apakah bulan dan tahun periode akhir valid
                                      bool isValid =
                                          controller.validateEndPeriod(
                                        controller
                                            .bulanSelectedStartPeriod.value,
                                        controller
                                            .tahunSelectedStartPeriod.value,
                                        bulan,
                                        tahun,
                                      );

                                      if (isValid) {
                                        controller.bulanSelectedEndPeriod
                                            .value = bulan;
                                        controller.tahunSelectedEndPeriod
                                            .value = tahun;
                                        controller.endPeriode.value =
                                            "$tahun-$bulan-${AppData.informasiUser![0].endPayroll}";

                                        // Refresh observables
                                        controller.bulanSelectedEndPeriod
                                            .refresh();
                                        controller.tahunSelectedEndPeriod
                                            .refresh();
                                        controller.endPeriode.refresh();
                                        controller.loadMonitoringIzin();
                                      }
                                    }
                                  },
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text("Pilih Tanggal Akhir"),
                                  Obx(
                                    () => Text(
                                      "${Constanst.bulanIndo(controller.bulanSelectedEndPeriod.value)} ${controller.tahunSelectedEndPeriod.value}",
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: Constanst.border),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                top: 8.0, bottom: 8.0, left: 12.0, right: 12.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(
                  () => Text(
                    "Dari ${Constanst.bulanIndo(controller.bulanSelectedStartPeriod.value)} sampai ${Constanst.bulanIndo(controller.bulanSelectedEndPeriod.value)} ${controller.tahunSelectedEndPeriod.value}",
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
    );
  }

  Widget listAjuanTidakMasukEmployee() {
    return Obx(
      () => ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: controller.listDetailLaporanEmployee.value.length,
          itemBuilder: (context, index) {
            return viewTidakHadir(
                controller.listDetailLaporanEmployee.value[index]);
          }),
    );
  }

  Widget viewTidakHadir(index) {
    var nomorAjuan = index['nomor_ajuan'] ?? "";
    var get2StringNomor = '${nomorAjuan[0]}${nomorAjuan[1]}';
    var tanggalMasukAjuan = index['atten_date'] ?? "";
    var namaTypeAjuan = index['name'] ?? "";
    var categoryAjuan = index['category'] ?? "";
    var alasanReject = index['alasan_reject'] ?? "";
    var typeAjuan;
    if (controller.valuePolaPersetujuan.value == "1") {
      typeAjuan = index['leave_status'];
    } else {
      typeAjuan = index['leave_status'] == "Approve"
          ? "Approve 1"
          : index['leave_status'] == "Approve2"
              ? "Approve 2"
              : index['leave_status'];
    }
    var approve_by;
    if (index['apply2_by'] == "" ||
        index['apply2_by'] == "null" ||
        index['apply2_by'] == null) {
      approve_by = index['apply_by'];
    } else {
      approve_by = index['apply_by'];
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Constanst.border)),
        child: InkWell(
          customBorder: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))),
          onTap: () => showDetailRiwayat(index, approve_by, alasanReject),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("$categoryAjuan - $namaTypeAjuan",
                              style: GoogleFonts.inter(
                                  color: Constanst.fgPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(height: 4),
                          Text("$nomorAjuan",
                              textAlign: TextAlign.justify,
                              style: GoogleFonts.inter(
                                  color: Constanst.fgSecondary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400)),
                          const SizedBox(height: 4),
                          Text(Constanst.convertDate5("$tanggalMasukAjuan"),
                              style: GoogleFonts.inter(
                                  color: Constanst.fgSecondary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ),
                    Icon(
                      Iconsax.arrow_right_34,
                      color: Constanst.fgSecondary,
                      size: 18,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Divider(height: 0, thickness: 1, color: Constanst.border),
                const SizedBox(height: 8),
                // Container(
                //   margin: const EdgeInsets.all(3),
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: Constanst.borderStyle1,
                //     boxShadow: [
                //       BoxShadow(
                //         color:
                //             Color.fromARGB(255, 170, 170, 170).withOpacity(0.4),
                //         spreadRadius: 1,
                //         blurRadius: 1,
                //         offset: Offset(1, 1), // changes position of shadow
                //       ),
                //     ],
                //   ),
                //   child: Padding(
                //     padding: const EdgeInsets.only(
                //         left: 16, top: 8, bottom: 8, right: 8),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Row(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           mainAxisAlignment: MainAxisAlignment.start,
                //           children: [
                //             Expanded(
                //               flex: 40,
                //               child: Container(
                //                 margin: EdgeInsets.only(right: 8),
                //                 decoration: BoxDecoration(
                //                   color: typeAjuan == 'Approve'
                //                       ? Constanst.colorBGApprove
                //                       : typeAjuan == 'Approve 1'
                //                           ? Constanst.colorBGApprove
                //                           : typeAjuan == 'Approve 2'
                //                               ? Constanst.colorBGApprove
                //                               : typeAjuan == 'Rejected'
                //                                   ? Constanst.colorBGRejected
                //                                   : typeAjuan == 'Pending'
                //                                       ? Constanst.colorBGPending
                //                                       : Colors.grey,
                //                   borderRadius: Constanst.borderStyle1,
                //                 ),
                //                 child: Padding(
                //                   padding: EdgeInsets.only(
                //                       left: 3, right: 3, top: 5, bottom: 5),
                //                   child: Row(
                //                     mainAxisAlignment: MainAxisAlignment.center,
                //                     children: [
                //                       typeAjuan == 'Approve'
                //                           ? Icon(
                //                               Iconsax.tick_square,
                //                               color: Constanst.color5,
                //                               size: 14,
                //                             )
                //                           : typeAjuan == 'Approve 1'
                //                               ? Icon(
                //                                   Iconsax.tick_square,
                //                                   color: Constanst.color5,
                //                                   size: 14,
                //                                 )
                //                               : typeAjuan == 'Approve 2'
                //                                   ? Icon(
                //                                       Iconsax.tick_square,
                //                                       color: Constanst.color5,
                //                                       size: 14,
                //                                     )
                //                                   : typeAjuan == 'Rejected'
                //                                       ? Icon(
                //                                           Iconsax.close_square,
                //                                           color:
                //                                               Constanst.color4,
                //                                           size: 14,
                //                                         )
                //                                       : typeAjuan == 'Pending'
                //                                           ? Icon(
                //                                               Iconsax.timer,
                //                                               color: Constanst
                //                                                   .color3,
                //                                               size: 14,
                //                                             )
                //                                           : SizedBox(),
                //                       Padding(
                //                         padding: const EdgeInsets.only(left: 3),
                //                         child: Text(
                //                           '$typeAjuan',
                //                           textAlign: TextAlign.center,
                //                           style: TextStyle(
                //                               fontWeight: FontWeight.bold,
                //                               color: typeAjuan == 'Approve'
                //                                   ? Colors.green
                //                                   : typeAjuan == 'Approve 1'
                //                                       ? Colors.green
                //                                       : typeAjuan == 'Approve 2'
                //                                           ? Colors.green
                //                                           : typeAjuan ==
                //                                                   'Rejected'
                //                                               ? Colors.red
                //                                               : typeAjuan ==
                //                                                       'Pending'
                //                                                   ? Constanst
                //                                                       .color3
                //                                                   : Colors
                //                                                       .black),
                //                         ),
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //               ),
                //             )
                //           ],
                //         ),
                //         categoryAjuan == ""
                //             ? SizedBox()
                //             : Text(
                //                 "$categoryAjuan",
                //                 style: TextStyle(
                //                     fontWeight: FontWeight.bold, fontSize: 16),
                //               ),
                //       ],
                //     ),
                //   ),
                // )
                // typeAjuan == 'Rejected'
                //     ? Row(
                //         crossAxisAlignment: CrossAxisAlignment.center,
                //         children: [
                //           Icon(
                //             Iconsax.close_circle,
                //             color: Constanst.color4,
                //             size: 22,
                //           ),
                //           const SizedBox(width: 8),
                //           Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Text("Rejected by $approve_by",
                //                   style: GoogleFonts.inter(
                //                       fontWeight: FontWeight.w500,
                //                       color: Constanst.fgPrimary,
                //                       fontSize: 14)),
                //               const SizedBox(height: 6),
                //               Text(
                //                 alasanReject,
                //                 style: GoogleFonts.inter(
                //                     fontWeight: FontWeight.w400,
                //                     color: Constanst.fgSecondary,
                //                     fontSize: 14),
                //               )
                //             ],
                //           ),
                //         ],
                //       )
                //     : typeAjuan == "Approve" ||
                //             typeAjuan == "Approve 1" ||
                //             typeAjuan == "Approve 2"
                //         ? Row(
                //             crossAxisAlignment: CrossAxisAlignment.center,
                //             children: [
                //               const Icon(
                //                 Iconsax.tick_circle,
                //                 color: Colors.green,
                //                 size: 22,
                //               ),
                //               const SizedBox(width: 8),
                //               Text("Approved by $approve_by",
                //                   style: GoogleFonts.inter(
                //                       fontWeight: FontWeight.w500,
                //                       color: Constanst.fgPrimary,
                //                       fontSize: 14)),
                //             ],
                //           )
                //         : Row(
                //             crossAxisAlignment: CrossAxisAlignment.center,
                //             children: [
                //               Icon(
                //                 Iconsax.timer,
                //                 color: Constanst.color3,
                //                 size: 22,
                //               ),
                //               const SizedBox(width: 8),
                //               Column(
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 children: [
                //                   Text("Pending Approval",
                //                       style: GoogleFonts.inter(
                //                           fontWeight: FontWeight.w500,
                //                           color: Constanst.fgPrimary,
                //                           fontSize: 14)),
                //                   // const SizedBox(height: 4),
                //                   // InkWell(
                //                   //     onTap: () {
                //                   //       var dataEmployee = {
                //                   //         'nameType': '$namaTypeAjuan',
                //                   //         'nomor_ajuan': '$nomorAjuan',
                //                   //       };
                //                   //       controllerGlobal
                //                   //           .showDataPilihAtasan(dataEmployee);
                //                   //     },
                //                   //     child: Text("Konfirmasi via Whatsapp",
                //                   //         style: GoogleFonts.inter(
                //                   //             fontWeight: FontWeight.w400,
                //                   //             color: Constanst.infoLight,
                //                   //             fontSize: 14))),
                //                 ],
                //               ),
                //             ],
                //           )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget viewLemburTugasLuar(index) {
    var nomorAjuan = index['nomor_ajuan'];
    var dariJam = index['dari_jam'];
    var sampaiJam = index['sampai_jam'];
    var tanggalPengajuan = index['atten_date'];
    var status;
    if (controller.valuePolaPersetujuan.value == "1") {
      status = index['status'];
    } else {
      status = index['status'] == "Approve"
          ? "Approve 1"
          : index['status'] == "Approve2"
              ? "Approve 2"
              : index['status'];
    }
    var alasanReject = index['alasan_reject'];
    var approveDate = index['approve_date'];
    var uraian = index['uraian'];
    var approve;
    if (index['approve2_by'] == "" ||
        index['approve2_by'] == "null" ||
        index['approve2_by'] == null) {
      approve = index['approve_by'];
    } else {
      approve = index['approve2_by'];
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Container(
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: Constanst.borderStyle1,
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 190, 190, 190).withOpacity(0.4),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(1, 1), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, top: 8, bottom: 8, right: 10),
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
                          Constanst.convertDate('$tanggalPengajuan'),
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
                                                      color: Constanst.color3,
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
                  height: 5,
                ),
                Text(
                  "NO.$nomorAjuan",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: 14,
                      color: Constanst.colorText1,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  '${dariJam} sd ${sampaiJam}',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 14, color: Constanst.colorText2),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  '$uraian',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 14, color: Constanst.colorText2),
                ),
                SizedBox(
                  height: 5,
                ),
                Divider(
                  height: 5,
                  color: Constanst.colorText2,
                ),
                SizedBox(
                  height: 5,
                ),
                status == "Rejected"
                    ? SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Alasan Reject",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              alasanReject,
                              style: TextStyle(
                                  fontSize: 14, color: Constanst.colorText2),
                            )
                          ],
                        ),
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: status == "Approve" ||
                                    status == "Approve 1" ||
                                    status == "Approve 2"
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Iconsax.tick_circle,
                                        color: Colors.green,
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(left: 5, top: 3),
                                        child: Text("Approved by $approve"),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(left: 5, top: 3),
                                        child: Text(""),
                                      )
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Pending Approval",
                                        style: TextStyle(
                                            color: Constanst.colorText2),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text("")
                                    ],
                                  ),
                          ),
                        ],
                      )
              ],
            ),
          ),
        )
      ],
    );
  }

  void showDetailRiwayat(detailData, apply_by, alasanReject) {
    var nomorAjuan = detailData['nomor_ajuan'];
    var get2StringNomor = '${nomorAjuan[0]}${nomorAjuan[1]}';
    var tanggalMasukAjuan = detailData['atten_date'];
    var namaTypeAjuan = detailData['name'];
    var tanggalAjuanDari = detailData['start_date'];
    var tanggalAjuanSampai = detailData['end_date'];
    var alasan = detailData['reason'];
    var durasi = detailData['leave_duration'];
    var typeAjuan;
    if (controller.valuePolaPersetujuan.value == "1") {
      typeAjuan = detailData['leave_status'];
    } else {
      typeAjuan = detailData['leave_status'] == "Approve"
          ? "Approve 1"
          : detailData['leave_status'] == "Approve2"
              ? "Approve 2"
              : detailData['leave_status'];
    }
    var jamAjuan =
        detailData['time_plan'] == null || detailData['time_plan'] == ""
            ? "00:00:00"
            : detailData['time_plan'];
    var sampaiJamAjuan =
        detailData['time_plan_to'] == null || detailData['time_plan_to'] == ""
            ? "00:00:00"
            : detailData['time_plan_to'];
    var leave_files = detailData['leave_files'];
    var categoryIzin = detailData['category'];

    var listTanggalTerpilih = detailData['date_selected'].split(',');
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Center(
                  child: Container(
                      height: 6,
                      width: 34,
                      decoration: BoxDecoration(
                          color: Constanst.colorNeutralBgTertiary,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20.0),
                          ))),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Constanst.colorNonAktif)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Tanggal Pengajuan",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Constanst.fgSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                Constanst.convertDate6("$tanggalMasukAjuan"),
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Constanst.fgPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "No. Pengajuan",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Constanst.fgSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                nomorAjuan,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Constanst.fgPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Constanst.colorNonAktif)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nama Pengajuan",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Constanst.fgSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "categoryIzin - $namaTypeAjuan",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Constanst.fgPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Divider(
                          height: 0,
                          thickness: 1,
                          color: Constanst.border,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Tanggal Izin",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Constanst.fgSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        detailData['date_selected'] == null ||
                                detailData['date_selected'] == "" ||
                                detailData['date_selected'] == "null"
                            ? Text(
                                "${Constanst.convertDate6(tanggalAjuanDari)} - ${Constanst.convertDate6(tanggalAjuanSampai)}",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Constanst.fgPrimary,
                                ),
                              )
                            : Container(),
                        detailData['date_selected'] == null ||
                                detailData['date_selected'] == "" ||
                                detailData['date_selected'] == "null"
                            ? Container()
                            : Row(
                                children: List.generate(
                                    listTanggalTerpilih.length, (index) {
                                  var nomor = index + 1;
                                  var tanggalConvert = Constanst.convertDate7(
                                      listTanggalTerpilih[index]);
                                  var tanggalConvert2 = Constanst.convertDate5(
                                      listTanggalTerpilih[index]);
                                  return Row(
                                    children: [
                                      Text(
                                        index == listTanggalTerpilih.length - 1
                                            ? tanggalConvert2
                                            : '$tanggalConvert, ',
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Constanst.fgPrimary,
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                        const SizedBox(height: 12),
                        Divider(
                          height: 0,
                          thickness: 1,
                          color: Constanst.border,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Durasi Izin",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Constanst.fgSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "$durasi Hari",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Constanst.fgPrimary,
                          ),
                        ),
                        categoryIzin == "HALFDAY"
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 12),
                                  Divider(
                                    height: 0,
                                    thickness: 1,
                                    color: Constanst.border,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    "Jam Izin",
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Constanst.fgSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  detailData['input_time'].toString() == "2"
                                      ? Text(
                                          "$jamAjuan sd $sampaiJamAjuan",
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: Constanst.fgPrimary,
                                          ),
                                        )
                                      : Text(
                                          " $sampaiJamAjuan",
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: Constanst.fgPrimary,
                                          ),
                                        ),
                                ],
                              )
                            : const SizedBox(),
                        const SizedBox(height: 12),
                        Divider(
                          height: 0,
                          thickness: 1,
                          color: Constanst.border,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Catatan",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Constanst.fgSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "$alasan",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Constanst.fgPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        leave_files == "" ||
                                leave_files == "NULL" ||
                                leave_files == null
                            ? const SizedBox()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Divider(
                                    height: 0,
                                    thickness: 1,
                                    color: Constanst.border,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    "File disematkan",
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Constanst.fgSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  InkWell(
                                      onTap: () {
                                        viewLampiranAjuanKlaim(leave_files);
                                      },
                                      child: Text(
                                        "$leave_files",
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Constanst.infoLight,
                                        ),
                                      )),
                                  const SizedBox(height: 12),
                                ],
                              ),
                        // Divider(
                        //   height: 0,
                        //   thickness: 1,
                        //   color: Constanst.border,
                        // ),
                        // const SizedBox(height: 12),
                        // typeAjuan == 'Rejected'
                        //     ? Row(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           Icon(
                        //             Iconsax.close_circle,
                        //             color: Constanst.color4,
                        //             size: 22,
                        //           ),
                        //           const SizedBox(width: 8),
                        //           Column(
                        //             crossAxisAlignment:
                        //                 CrossAxisAlignment.start,
                        //             children: [
                        //               Text("Rejected by $apply_by",
                        //                   style: GoogleFonts.inter(
                        //                       fontWeight: FontWeight.w500,
                        //                       color: Constanst.fgPrimary,
                        //                       fontSize: 14)),
                        //               const SizedBox(height: 6),
                        //               Text(
                        //                 alasanReject,
                        //                 style: GoogleFonts.inter(
                        //                     fontWeight: FontWeight.w400,
                        //                     color: Constanst.fgSecondary,
                        //                     fontSize: 14),
                        //               )
                        //             ],
                        //           ),
                        //         ],
                        //       )
                        //     : typeAjuan == "Approve" ||
                        //             typeAjuan == "Approve 1" ||
                        //             typeAjuan == "Approve 2"
                        //         ? Row(
                        //             crossAxisAlignment:
                        //                 CrossAxisAlignment.center,
                        //             children: [
                        //               const Icon(
                        //                 Iconsax.tick_circle,
                        //                 color: Colors.green,
                        //                 size: 22,
                        //               ),
                        //               const SizedBox(width: 8),
                        //               Text("Approved by $apply_by",
                        //                   style: GoogleFonts.inter(
                        //                       fontWeight: FontWeight.w500,
                        //                       color: Constanst.fgPrimary,
                        //                       fontSize: 14)),
                        //             ],
                        //           )
                        //         : Row(
                        //             crossAxisAlignment:
                        //                 CrossAxisAlignment.start,
                        //             children: [
                        //               Icon(
                        //                 Iconsax.timer,
                        //                 color: Constanst.color3,
                        //                 size: 22,
                        //               ),
                        //               const SizedBox(width: 8),
                        //               Column(
                        //                 crossAxisAlignment:
                        //                     CrossAxisAlignment.start,
                        //                 children: [
                        //                   Text("Pending Approval",
                        //                       style: GoogleFonts.inter(
                        //                           fontWeight: FontWeight.w500,
                        //                           color: Constanst.fgPrimary,
                        //                           fontSize: 14)),
                        //                 ],
                        //               ),
                        //             ],
                        //           ),
                      ],
                    ),
                  ),
                ),
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Expanded(
                //       flex: 30,
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text("Tanggal izin"),
                //         ],
                //       ),
                //     ),
                //     Expanded(
                //       flex: 2,
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(":"),
                //         ],
                //       ),
                //     ),
                //     Expanded(
                //       flex: 68,
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(
                //               "${Constanst.convertDate("$tanggalAjuanDari")}  SD  ${Constanst.convertDate("$tanggalAjuanSampai")}"),
                //         ],
                //       ),
                //     )
                //   ],
                // ),

                SizedBox(
                  height: 12,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void viewLampiranAjuanKlaim(value) async {
    var urlViewGambar = Api.UrlfileTidakhadir + value;

    final url = Uri.parse(urlViewGambar);
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      UtilsAlert.showToast('Tidak dapat membuka file');
    }
  }
}
