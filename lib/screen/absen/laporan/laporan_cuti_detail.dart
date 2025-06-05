import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/global_controller.dart';
import 'package:siscom_operasional/controller/laporan_cuti_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/constans.dart';

class LaporanCutiDetail extends StatefulWidget {
  String emId, bulan, tahun, full_name, title, jobTitle, image;
  LaporanCutiDetail(
      {Key? key,
      required this.emId,
      required this.bulan,
      required this.tahun,
      required this.title,
      required this.full_name,
      required this.jobTitle,
      required this.image})
      : super(key: key);
  @override
  _LaporanCutiDetailState createState() => _LaporanCutiDetailState();
}

class _LaporanCutiDetailState extends State<LaporanCutiDetail> {
  var controller = Get.put(LaporanCutiController());
  var controllerGlobal = Get.find<GlobalController>();

  @override
  void initState() {
    controller.tempNamaStatus1.value = "Semua";
    controller.tempKodeStatus1.value = "Semua";
    controller.loadDataTidakHadirEmployee(
        widget.emId, widget.bulan, widget.tahun, widget.title);
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
              centerTitle: false,
              title: Text(
                "Detail Laporan Cuti",
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
              child: Obx(
                () => Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Constanst.border)),
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
                          child: Row(
                            children: [
                              widget.image == ""
                                  ? SvgPicture.asset(
                                      'assets/avatar_default.svg',
                                      width: 42,
                                      height: 42,
                                    )
                                  : Center(
                                      child: CircleAvatar(
                                        radius: 21,
                                        child: ClipOval(
                                          child: ClipOval(
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "${Api.UrlfotoProfile}${widget.image}",
                                              progressIndicatorBuilder:
                                                  (context, url,
                                                          downloadProgress) =>
                                                      Container(
                                                alignment: Alignment.center,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.5,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child:
                                                    CircularProgressIndicator(
                                                        value: downloadProgress
                                                            .progress),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Container(
                                                color: Colors.white,
                                                child: SvgPicture.asset(
                                                  'assets/avatar_default.svg',
                                                  width: 42,
                                                  height: 42,
                                                ),
                                              ),
                                              fit: BoxFit.cover,
                                              width: 42,
                                              height: 42,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      // "${widget.full_name} - ${Constanst.convertDateBulanDanTahun('${widget.bulan}-${widget.tahun}')}",
                                      widget.full_name,
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Constanst.fgPrimary),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.jobTitle,
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: Constanst.fgSecondary),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      status(),
                      const SizedBox(height: 16),
                      Text("Riwayat Pengajuan Cuti",
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              color: Constanst.fgPrimary,
                              fontSize: 18)),
                      const SizedBox(height: 16),
                      Flexible(
                          child: controller
                                  .listDetailLaporanEmployee.value.isEmpty
                              ? Center(
                                  child:
                                      Text("${controller.loadingString.value}"))
                              : listAjuanTidakMasukEmployee())
                    ],
                  ),
                ),
              ),
            )));
  }

  Widget status() {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              border: Border.all(color: Constanst.fgBorder)),
          child: InkWell(
            customBorder: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(100))),
            onTap: () {
              showBottomStatus(Get.context!);
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => Text(
                      controller.tempNamaStatus1.value,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Constanst.fgSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Iconsax.arrow_down_1,
                    size: 18,
                    color: Constanst.fgSecondary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  showBottomStatus(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Pilih Status",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Constanst.fgPrimary,
                        ),
                      ),
                      InkWell(
                          customBorder: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          onTap: () => Navigator.pop(Get.context!),
                          child: Icon(
                            Icons.close,
                            size: 26,
                            color: Constanst.fgSecondary,
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Divider(
                    thickness: 1,
                    height: 0,
                    color: Constanst.border,
                  ),
                ),
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Obx(() => Column(
                        children: List.generate(
                            controller.dataTypeAjuan.value.length, (index) {
                          var namaType =
                              controller.dataTypeAjuan[index]['nama'];
                          var status =
                              controller.dataTypeAjuan[index]['status'];
                          return InkWell(
                            onTap: () {
                              controller.changeTypeAjuanLaporan(
                                  controller.dataTypeAjuan.value[index]['nama'],
                                  widget.title);
                              controller.tempKodeStatus1.value = namaType;
                              controller.tempNamaStatus1.value = namaType;
                              print(namaType);
                              Get.back();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      // namaType == "Approve"
                                      // ? Icon(
                                      //     Iconsax.tick_circle5,
                                      //     size: 24,
                                      //     color: Constanst.color5,
                                      //   )
                                      // : namaType == "Pending"
                                      //     ? Icon(
                                      //         Iconsax.timer5,
                                      //         size: 24,
                                      //         color: Constanst.color3,
                                      //       )
                                      //     : namaType == "Rejected"
                                      //         ? Padding(
                                      //             padding:
                                      //                 const EdgeInsets
                                      //                         .only(
                                      //                     left: 12.0),
                                      //             child: Icon(
                                      //               Iconsax
                                      //                   .close_circle5,
                                      //               size: 24,
                                      //               color: Constanst
                                      //                   .color4,
                                      //             ),
                                      //           )
                                      //         : Container(),
                                      // const SizedBox(width: 20),
                                      Text(
                                        namaType,
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Constanst.fgPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  controller.tempKodeStatus1.value == namaType
                                      ? InkWell(
                                          onTap: () {},
                                          child: Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 2,
                                                    color: Constanst.onPrimary),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(3),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Constanst.onPrimary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                              ),
                                            ),
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            controller.tempKodeStatus1.value =
                                                namaType;
                                            controller.tempNamaStatus1.value =
                                                namaType;
                                            Get.back();
                                          },
                                          child: Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 1,
                                                    color: Constanst.onPrimary),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(2),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                              ),
                                            ),
                                          ),
                                        )
                                ],
                              ),
                            ),
                          );
                        }),
                      )),
                ),
              ],
            ),
          ),
        );
      },
    ).then((value) {
      print('Bottom sheet closed');
      // salesOrderReportController.tempKodeCustomer2.value =
      //     salesOrderReportController.tempKodeCustomer3.value;

      // if (value != "terapkan") {
      //   salesOrderReportController.tempKodeStatus1.value =
      //       salesOrderReportController.tempKodeStatus2.value == ""
      //           ? salesOrderReportController.tempKodeStatus3.value
      //           : salesOrderReportController.tempKodeStatus2.value;

      //   salesOrderReportController.tempNamaStatus1.value =
      //       salesOrderReportController.tempNamaStatus2.value == ""
      //           ? salesOrderReportController.tempNamaStatus3.value
      //           : salesOrderReportController.tempNamaStatus2.value;
      // }
    });
  }
  // Widget listStatusAjuan() {
  //   return SizedBox(
  //     height: 30,
  //     child: ListView.builder(
  //         itemCount: controller.dataTypeAjuan.value.length,
  //         scrollDirection: Axis.horizontal,
  //         itemBuilder: (context, index) {
  //           var namaType = controller.dataTypeAjuan[index]['nama'];
  //           var status = controller.dataTypeAjuan[index]['status'];
  //           return InkWell(
  //             highlightColor: Constanst.colorPrimary,
  //             onTap: () => controller.changeTypeAjuanLaporan(
  //                 controller.dataTypeAjuan.value[index]['nama'], widget.title),
  //             child: Container(
  //               padding: EdgeInsets.only(left: 5, right: 5),
  //               margin: EdgeInsets.only(left: 5, right: 5),
  //               decoration: BoxDecoration(
  //                 color: status == true
  //                     ? Constanst.colorPrimary
  //                     : Constanst.colorNonAktif,
  //                 borderRadius: Constanst.borderStyle1,
  //               ),
  //               child: Center(
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     namaType == "Approve"
  //                         ? Icon(
  //                             Iconsax.tick_square,
  //                             size: 14,
  //                             color: status == true
  //                                 ? Colors.white
  //                                 : Constanst.colorText2,
  //                           )
  //                         : namaType == "Approve 1"
  //                             ? Icon(
  //                                 Iconsax.tick_square,
  //                                 size: 14,
  //                                 color: status == true
  //                                     ? Colors.white
  //                                     : Constanst.colorText2,
  //                               )
  //                             : namaType == "Approve 2"
  //                                 ? Icon(
  //                                     Iconsax.tick_square,
  //                                     size: 14,
  //                                     color: status == true
  //                                         ? Colors.white
  //                                         : Constanst.colorText2,
  //                                   )
  //                                 : namaType == "Rejected"
  //                                     ? Icon(
  //                                         Iconsax.close_square,
  //                                         size: 14,
  //                                         color: status == true
  //                                             ? Colors.white
  //                                             : Constanst.colorText2,
  //                                       )
  //                                     : namaType == "Pending"
  //                                         ? Icon(
  //                                             Iconsax.timer,
  //                                             size: 14,
  //                                             color: status == true
  //                                                 ? Colors.white
  //                                                 : Constanst.colorText2,
  //                                           )
  //                                         : SizedBox(),
  //                     Padding(
  //                       padding: const EdgeInsets.only(left: 6, right: 6),
  //                       child: Text(
  //                         namaType,
  //                         style: GoogleFonts.inter(
  //                             fontSize: 12,
  //                             color: status == true
  //                                 ? Colors.white
  //                                 : Constanst.colorText2,
  //                             fontWeight: FontWeight.bold),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           );
  //         }),
  //   );
  // }

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
          onTap: () =>
              controller.showDetailRiwayat(index, approve_by, alasanReject),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        get2StringNomor == "DL"
                            ? Text("DINAS LUAR",
                                style: GoogleFonts.inter(
                                    color: Constanst.fgPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500))
                            : Text("$namaTypeAjuan",
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
                //   margin: EdgeInsets.only(right: 8),
                //   decoration: BoxDecoration(
                //     color: typeAjuan == 'Approve'
                //         ? Constanst.colorBGApprove
                //         : typeAjuan == 'Approve 1'
                //             ? Constanst.colorBGApprove
                //             : typeAjuan == 'Approve 2'
                //                 ? Constanst.colorBGApprove
                //                 : typeAjuan == 'Rejected'
                //                     ? Constanst.colorBGRejected
                //                     : typeAjuan == 'Pending'
                //                         ? Constanst.colorBGPending
                //                         : Colors.grey,
                //     borderRadius: Constanst.borderStyle1,
                //   ),
                //   child: Padding(
                //     padding:
                //         EdgeInsets.only(left: 3, right: 3, top: 5, bottom: 5),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         typeAjuan == 'Approve'
                //             ? Icon(
                //                 Iconsax.tick_square,
                //                 color: Constanst.color5,
                //                 size: 14,
                //               )
                //             : typeAjuan == 'Approve 1'
                //                 ? Icon(
                //                     Iconsax.tick_square,
                //                     color: Constanst.color5,
                //                     size: 14,
                //                   )
                //                 : typeAjuan == 'Approve 2'
                //                     ? Icon(
                //                         Iconsax.tick_square,
                //                         color: Constanst.color5,
                //                         size: 14,
                //                       )
                //                     : typeAjuan == 'Rejected'
                //                         ? Icon(
                //                             Iconsax.close_square,
                //                             color: Constanst.color4,
                //                             size: 14,
                //                           )
                //                         : typeAjuan == 'Pending'
                //                             ? Icon(
                //                                 Iconsax.timer,
                //                                 color: Constanst.color3,
                //                                 size: 14,
                //                               )
                //                             : SizedBox(),
                //         Padding(
                //           padding: const EdgeInsets.only(left: 3),
                //           child: Text(
                //             '$typeAjuan',
                //             textAlign: TextAlign.center,
                //             style: GoogleFonts.inter(
                //                 fontWeight: FontWeight.bold,
                //                 color: typeAjuan == 'Approve'
                //                     ? Colors.green
                //                     : typeAjuan == 'Approve 1'
                //                         ? Colors.green
                //                         : typeAjuan == 'Approve 2'
                //                             ? Colors.green
                //                             : typeAjuan == 'Rejected'
                //                                 ? Colors.red
                //                                 : typeAjuan == 'Pending'
                //                                     ? Constanst.color3
                //                                     : Colors.black),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // categoryAjuan == ""
                //     ? SizedBox()
                //     : Text(
                //         "$categoryAjuan",
                //         style: GoogleFonts.inter(
                //             fontWeight: FontWeight.bold, fontSize: 16),
                //       ),
                typeAjuan == 'Rejected'
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Iconsax.close_circle,
                            color: Constanst.color4,
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Rejected by $approve_by",
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      color: Constanst.fgPrimary,
                                      fontSize: 14)),
                              const SizedBox(height: 6),
                              Text(
                                alasanReject,
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w400,
                                    color: Constanst.fgSecondary,
                                    fontSize: 14),
                              )
                            ],
                          ),
                        ],
                      )
                    : typeAjuan == "Approve" ||
                            typeAjuan == "Approve 1" ||
                            typeAjuan == "Approve 2"
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Iconsax.tick_circle,
                                color: Colors.green,
                                size: 22,
                              ),
                              const SizedBox(width: 8),
                              Text("Approved by $approve_by",
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      color: Constanst.fgPrimary,
                                      fontSize: 14)),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Iconsax.timer,
                                color: Constanst.color3,
                                size: 22,
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Pending Approval",
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          color: Constanst.fgPrimary,
                                          fontSize: 14)),
                                  // const SizedBox(height: 4),
                                  // InkWell(
                                  //     onTap: () {
                                  //       var dataEmployee = {
                                  //         'nameType': '$namaTypeAjuan',
                                  //         'nomor_ajuan': '$nomorAjuan',
                                  //       };
                                  //       controllerGlobal
                                  //           .showDataPilihAtasan(dataEmployee);
                                  //     },
                                  //     child: Text("Konfirmasi via Whatsapp",
                                  //         style: GoogleFonts.inter(
                                  //             fontWeight: FontWeight.w400,
                                  //             color: Constanst.infoLight,
                                  //             fontSize: 14))),
                                ],
                              ),
                            ],
                          )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget viewLemburTugasLuar(index) {
  //   var nomorAjuan = index['nomor_ajuan'];
  //   var dariJam = index['dari_jam'];
  //   var sampaiJam = index['sampai_jam'];
  //   var tanggalPengajuan = index['atten_date'];
  //   var status;
  //   if (controller.valuePolaPersetujuan.value == "1") {
  //     status = index['status'];
  //   } else {
  //     status = index['status'] == "Approve"
  //         ? "Approve 1"
  //         : index['status'] == "Approve2"
  //             ? "Approve 2"
  //             : index['status'];
  //   }
  //   var alasanReject = index['alasan_reject'];
  //   var approveDate = index['approve_date'];
  //   var uraian = index['uraian'];
  //   var approve;
  //   if (index['approve2_by'] == "" ||
  //       index['approve2_by'] == "null" ||
  //       index['approve2_by'] == null) {
  //     approve = index['approve_by'];
  //   } else {
  //     approve = index['approve2_by'];
  //   }
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     children: [
  //       SizedBox(
  //         height: 10,
  //       ),
  //       Container(
  //         margin: const EdgeInsets.all(3),
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: Constanst.borderStyle1,
  //           boxShadow: [
  //             BoxShadow(
  //               color: Color.fromARGB(255, 190, 190, 190).withOpacity(0.4),
  //               spreadRadius: 1,
  //               blurRadius: 1,
  //               offset: Offset(1, 1), // changes position of shadow
  //             ),
  //           ],
  //         ),
  //         child: Padding(
  //           padding:
  //               const EdgeInsets.only(left: 16, top: 8, bottom: 8, right: 10),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Row(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: [
  //                   Expanded(
  //                     flex: 60,
  //                     child: Padding(
  //                       padding: const EdgeInsets.only(top: 5),
  //                       child: Text(
  //                         Constanst.convertDate('$tanggalPengajuan'),
  //                         style: GoogleFonts.inter(
  //                             fontWeight: FontWeight.bold, fontSize: 16),
  //                       ),
  //                     ),
  //                   ),
  //                   Expanded(
  //                     flex: 40,
  //                     child: Container(
  //                       margin: EdgeInsets.only(right: 8),
  //                       decoration: BoxDecoration(
  //                         color: status == 'Approve'
  //                             ? Constanst.colorBGApprove
  //                             : status == 'Approve 1'
  //                                 ? Constanst.colorBGApprove
  //                                 : status == 'Approve 2'
  //                                     ? Constanst.colorBGApprove
  //                                     : status == 'Rejected'
  //                                         ? Constanst.colorBGRejected
  //                                         : status == 'Pending'
  //                                             ? Constanst.colorBGPending
  //                                             : Colors.grey,
  //                         borderRadius: Constanst.borderStyle1,
  //                       ),
  //                       child: Padding(
  //                         padding: EdgeInsets.only(
  //                             left: 3, right: 3, top: 5, bottom: 5),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [
  //                             status == 'Approve'
  //                                 ? Icon(
  //                                     Iconsax.tick_square,
  //                                     color: Constanst.color5,
  //                                     size: 14,
  //                                   )
  //                                 : status == 'Approve 1'
  //                                     ? Icon(
  //                                         Iconsax.tick_square,
  //                                         color: Constanst.color5,
  //                                         size: 14,
  //                                       )
  //                                     : status == 'Approve 2'
  //                                         ? Icon(
  //                                             Iconsax.tick_square,
  //                                             color: Constanst.color5,
  //                                             size: 14,
  //                                           )
  //                                         : status == 'Rejected'
  //                                             ? Icon(
  //                                                 Iconsax.close_square,
  //                                                 color: Constanst.color4,
  //                                                 size: 14,
  //                                               )
  //                                             : status == 'Pending'
  //                                                 ? Icon(
  //                                                     Iconsax.timer,
  //                                                     color: Constanst.color3,
  //                                                     size: 14,
  //                                                   )
  //                                                 : SizedBox(),
  //                             Padding(
  //                               padding: const EdgeInsets.only(left: 3),
  //                               child: Text(
  //                                 '$status',
  //                                 textAlign: TextAlign.center,
  //                                 style: GoogleFonts.inter(
  //                                     fontWeight: FontWeight.bold,
  //                                     color: status == 'Approve'
  //                                         ? Colors.green
  //                                         : status == 'Approve 1'
  //                                             ? Colors.green
  //                                             : status == 'Approve 2'
  //                                                 ? Colors.green
  //                                                 : status == 'Rejected'
  //                                                     ? Colors.red
  //                                                     : status == 'Pending'
  //                                                         ? Constanst.color3
  //                                                         : Colors.black),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   )
  //                 ],
  //               ),
  //               SizedBox(
  //                 height: 5,
  //               ),
  //               Text(
  //                 "NO.$nomorAjuan",
  //                 textAlign: TextAlign.justify,
  //                 style: GoogleFonts.inter(
  //                     fontSize: 14,
  //                     color: Constanst.colorText1,
  //                     fontWeight: FontWeight.bold),
  //               ),
  //               SizedBox(
  //                 height: 5,
  //               ),
  //               Text(
  //                 '${dariJam} sd ${sampaiJam}',
  //                 textAlign: TextAlign.justify,
  //                 style: GoogleFonts.inter(
  //                     fontSize: 14, color: Constanst.colorText2),
  //               ),
  //               SizedBox(
  //                 height: 5,
  //               ),
  //               Text(
  //                 '$uraian',
  //                 textAlign: TextAlign.justify,
  //                 style: GoogleFonts.inter(
  //                     fontSize: 14, color: Constanst.colorText2),
  //               ),
  //               SizedBox(
  //                 height: 5,
  //               ),
  //               Divider(
  //                 height: 5,
  //                 color: Constanst.colorText2,
  //               ),
  //               SizedBox(
  //                 height: 5,
  //               ),
  //               status == "Rejected"
  //                   ? SizedBox(
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text(
  //                             "Alasan Reject",
  //                             style: GoogleFonts.inter(
  //                                 fontWeight: FontWeight.bold),
  //                           ),
  //                           SizedBox(
  //                             height: 6,
  //                           ),
  //                           Text(
  //                             alasanReject,
  //                             style: GoogleFonts.inter(
  //                                 fontSize: 14, color: Constanst.colorText2),
  //                           )
  //                         ],
  //                       ),
  //                     )
  //                   : Row(
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: [
  //                         Expanded(
  //                           child: status == "Approve" ||
  //                                   status == "Approve 1" ||
  //                                   status == "Approve 2"
  //                               ? Row(
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.start,
  //                                   children: [
  //                                     Icon(
  //                                       Iconsax.tick_circle,
  //                                       color: Colors.green,
  //                                     ),
  //                                     Padding(
  //                                       padding:
  //                                           EdgeInsets.only(left: 5, top: 3),
  //                                       child: Text("Approved by $approve"),
  //                                     ),
  //                                     Padding(
  //                                       padding:
  //                                           EdgeInsets.only(left: 5, top: 3),
  //                                       child: Text(""),
  //                                     )
  //                                   ],
  //                                 )
  //                               : Column(
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.start,
  //                                   children: [
  //                                     Text(
  //                                       "Pending Approval",
  //                                       style: GoogleFonts.inter(
  //                                           color: Constanst.colorText2),
  //                                     ),
  //                                     SizedBox(
  //                                       height: 5,
  //                                     ),
  //                                     Text("")
  //                                   ],
  //                                 ),
  //                         ),
  //                       ],
  //                     )
  //             ],
  //           ),
  //         ),
  //       )
  //     ],
  //   );
  // }

  // Widget viewKlaim(valueList) {
  //   var nomorAjuan = valueList['nomor_ajuan'];
  //   var tanggalPengajuan = valueList['created_on'];
  //   var status;
  //   if (controller.valuePolaPersetujuan.value == "1") {
  //     status = valueList['status'];
  //   } else {
  //     status = valueList['status'] == "Approve"
  //         ? "Approve 1"
  //         : valueList['status'] == "Approve2"
  //             ? "Approve 2"
  //             : valueList['status'];
  //   }
  //   DateTime fltr1 = DateTime.parse("${valueList['tgl_ajuan']}");
  //   var tanggalAjuan = "${DateFormat('dd MMMM yyyy').format(fltr1)}";
  //   var totalKlaim = valueList['total_claim'];
  //   var rupiah = controller.convertToIdr(totalKlaim, 0);
  //   var alasanReject = valueList['alasan_reject'];
  //   var approveDate = valueList['approve_date'];
  //   var uraian = valueList['description'];
  //   var approve;
  //   if (valueList['approve2_by'] == "" ||
  //       valueList['approve2_by'] == "null" ||
  //       valueList['approve2_by'] == null) {
  //     approve = valueList['approve_by'];
  //   } else {
  //     approve = valueList['approve2_by'];
  //   }
  //   var namaFile = valueList['nama_file'];
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     children: [
  //       SizedBox(
  //         height: 10,
  //       ),
  //       Container(
  //         margin: const EdgeInsets.all(3.0),
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: Constanst.borderStyle1,
  //           boxShadow: [
  //             BoxShadow(
  //               color: Color.fromARGB(255, 190, 190, 190).withOpacity(0.4),
  //               spreadRadius: 1,
  //               blurRadius: 1,
  //               offset: Offset(1, 1), // changes position of shadow
  //             ),
  //           ],
  //         ),
  //         child: Padding(
  //           padding:
  //               const EdgeInsets.only(left: 16, top: 8, bottom: 8, right: 10),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Row(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: [
  //                   Expanded(
  //                     flex: 60,
  //                     child: Padding(
  //                       padding: const EdgeInsets.only(top: 5),
  //                       child: Text(
  //                         Constanst.convertDate('$tanggalPengajuan'),
  //                         style: GoogleFonts.inter(
  //                             fontWeight: FontWeight.bold, fontSize: 16),
  //                       ),
  //                     ),
  //                   ),
  //                   Expanded(
  //                     flex: 40,
  //                     child: Container(
  //                       margin: EdgeInsets.only(right: 8),
  //                       decoration: BoxDecoration(
  //                         color: status == 'Approve'
  //                             ? Constanst.colorBGApprove
  //                             : status == 'Approve 1'
  //                                 ? Constanst.colorBGApprove
  //                                 : status == 'Approve 2'
  //                                     ? Constanst.colorBGApprove
  //                                     : status == 'Rejected'
  //                                         ? Constanst.colorBGRejected
  //                                         : status == 'Pending'
  //                                             ? Constanst.colorBGPending
  //                                             : Colors.grey,
  //                         borderRadius: Constanst.borderStyle1,
  //                       ),
  //                       child: Padding(
  //                         padding: EdgeInsets.only(
  //                             left: 3, right: 3, top: 5, bottom: 5),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [
  //                             status == 'Approve'
  //                                 ? Icon(
  //                                     Iconsax.tick_square,
  //                                     color: Constanst.color5,
  //                                     size: 14,
  //                                   )
  //                                 : status == 'Approve 1'
  //                                     ? Icon(
  //                                         Iconsax.tick_square,
  //                                         color: Constanst.color5,
  //                                         size: 14,
  //                                       )
  //                                     : status == 'Approve 2'
  //                                         ? Icon(
  //                                             Iconsax.tick_square,
  //                                             color: Constanst.color5,
  //                                             size: 14,
  //                                           )
  //                                         : status == 'Rejected'
  //                                             ? Icon(
  //                                                 Iconsax.close_square,
  //                                                 color: Constanst.color4,
  //                                                 size: 14,
  //                                               )
  //                                             : status == 'Pending'
  //                                                 ? Icon(
  //                                                     Iconsax.timer,
  //                                                     color: Constanst.color3,
  //                                                     size: 14,
  //                                                   )
  //                                                 : SizedBox(),
  //                             Padding(
  //                               padding: const EdgeInsets.only(left: 3),
  //                               child: Text(
  //                                 '$status',
  //                                 textAlign: TextAlign.center,
  //                                 style: GoogleFonts.inter(
  //                                     fontWeight: FontWeight.bold,
  //                                     color: status == 'Approve'
  //                                         ? Colors.green
  //                                         : status == 'Approve 1'
  //                                             ? Colors.green
  //                                             : status == 'Approve 2'
  //                                                 ? Colors.green
  //                                                 : status == 'Rejected'
  //                                                     ? Colors.red
  //                                                     : status == 'Pending'
  //                                                         ? Constanst.color3
  //                                                         : Colors.black),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   )
  //                 ],
  //               ),
  //               SizedBox(
  //                 height: 5,
  //               ),
  //               Text(
  //                 "NO.$nomorAjuan",
  //                 textAlign: TextAlign.justify,
  //                 style: GoogleFonts.inter(
  //                     fontSize: 14,
  //                     color: Constanst.colorText1,
  //                     fontWeight: FontWeight.bold),
  //               ),
  //               SizedBox(
  //                 height: 5,
  //               ),
  //               Text(
  //                 'Pengajuan : $tanggalAjuan',
  //                 textAlign: TextAlign.justify,
  //                 style: GoogleFonts.inter(
  //                     fontSize: 14, color: Constanst.colorText2),
  //               ),
  //               SizedBox(
  //                 height: 5,
  //               ),
  //               Text(
  //                 'Total Klaim : $rupiah',
  //                 textAlign: TextAlign.justify,
  //                 style: GoogleFonts.inter(
  //                     fontSize: 14, color: Constanst.colorText2),
  //               ),
  //               SizedBox(
  //                 height: 5,
  //               ),
  //               Text(
  //                 '$uraian',
  //                 textAlign: TextAlign.justify,
  //                 style: GoogleFonts.inter(
  //                     fontSize: 14, color: Constanst.colorText2),
  //               ),
  //               SizedBox(
  //                 height: 5,
  //               ),
  //               namaFile == "" || namaFile == "NULL" || namaFile == null
  //                   ? SizedBox()
  //                   : Row(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Expanded(
  //                           flex: 60,
  //                           child: Text(
  //                             "$namaFile",
  //                             style: GoogleFonts.inter(
  //                                 fontSize: 14, color: Constanst.colorText2),
  //                           ),
  //                         ),
  //                         Expanded(
  //                           flex: 40,
  //                           child: InkWell(
  //                               onTap: () {
  //                                 controller.viewLampiranAjuan(namaFile);
  //                               },
  //                               child: Row(
  //                                 crossAxisAlignment: CrossAxisAlignment.end,
  //                                 mainAxisAlignment: MainAxisAlignment.end,
  //                                 children: [
  //                                   Text(
  //                                     "Lihat File",
  //                                     style: GoogleFonts.inter(
  //                                       color: Constanst.colorPrimary,
  //                                       decoration: TextDecoration.underline,
  //                                     ),
  //                                   ),
  //                                   Padding(
  //                                     padding: EdgeInsets.only(left: 3),
  //                                     child: Icon(
  //                                       Iconsax.arrow_right_1,
  //                                       size: 20,
  //                                     ),
  //                                   )
  //                                 ],
  //                               )),
  //                         )
  //                       ],
  //                     ),
  //               SizedBox(
  //                 height: 5,
  //               ),
  //               Divider(
  //                 height: 5,
  //                 color: Constanst.colorText2,
  //               ),
  //               SizedBox(
  //                 height: 5,
  //               ),
  //               status == "Rejected"
  //                   ? SizedBox(
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Row(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Icon(
  //                                 Iconsax.close_circle,
  //                                 color: Colors.red,
  //                               ),
  //                               Padding(
  //                                 padding: EdgeInsets.only(left: 5, top: 3),
  //                                 child: Text("Rejected by $approve"),
  //                               ),
  //                               Padding(
  //                                 padding: EdgeInsets.only(left: 5, top: 3),
  //                                 child: Text(""),
  //                               )
  //                             ],
  //                           ),
  //                           SizedBox(
  //                             height: 6,
  //                           ),
  //                           Text(
  //                             "$alasanReject",
  //                             style: GoogleFonts.inter(
  //                                 fontSize: 14, color: Constanst.colorText2),
  //                           ),
  //                           SizedBox(
  //                             height: 6,
  //                           ),
  //                         ],
  //                       ),
  //                     )
  //                   : Row(
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: [
  //                         Expanded(
  //                           child: status == "Approve" ||
  //                                   status == "Approve 1" ||
  //                                   status == "Approve 2"
  //                               ? Row(
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.start,
  //                                   children: [
  //                                     Icon(
  //                                       Iconsax.tick_circle,
  //                                       color: Colors.green,
  //                                     ),
  //                                     Padding(
  //                                       padding:
  //                                           EdgeInsets.only(left: 5, top: 3),
  //                                       child: Text("Approved by $approve"),
  //                                     ),
  //                                     Padding(
  //                                       padding:
  //                                           EdgeInsets.only(left: 5, top: 3),
  //                                       child: Text(""),
  //                                     )
  //                                   ],
  //                                 )
  //                               : Column(
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.start,
  //                                   children: [
  //                                     Text(
  //                                       "Pending Approval",
  //                                       style: GoogleFonts.inter(
  //                                           color: Constanst.colorText2),
  //                                     ),
  //                                     SizedBox(
  //                                       height: 5,
  //                                     ),
  //                                   ],
  //                                 ),
  //                         ),
  //                       ],
  //                     )
  //             ],
  //           ),
  //         ),
  //       )
  //     ],
  //   );
  // }
}
