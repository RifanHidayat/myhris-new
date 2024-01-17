import 'dart:math';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:siscom_operasional/controller/approval_controller.dart';
import 'package:siscom_operasional/controller/global_controller.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/appbar_widget.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/custom_dialog.dart';
import 'package:siscom_operasional/utils/widget_textButton.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPersetujuanCuti extends StatefulWidget {
  String? title, idxDetail, emId, delegasi;

  DetailPersetujuanCuti(
      {Key? key, this.title, this.idxDetail, this.emId, this.delegasi})
      : super(key: key);
  @override
  _DetailPersetujuanCutiState createState() => _DetailPersetujuanCutiState();
}

class _DetailPersetujuanCutiState extends State<DetailPersetujuanCuti> {
  var controller = Get.put(ApprovalController());
  var controllerGlobal = Get.put(GlobalController());
  int hours = 0, minutes = 0, second = 0;

  void showBottomAlasanReject(em_id) {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Iconsax.close_circle,
                        color: Colors.red,
                        size: 24,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8, top: 2),
                        child: Text(
                          "Alasan Tolak Pengajuan",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: Constanst.borderStyle1,
                        border: Border.all(
                            width: 1.0,
                            color: Color.fromARGB(255, 211, 205, 205))),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 8,
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: TextField(
                        cursorColor: Colors.black,
                        controller: controller.alasanReject.value,
                        maxLines: null,
                        maxLength: 225,
                        autofocus: true,
                        decoration: new InputDecoration(
                            border: InputBorder.none,
                            hintText: "Alasan Menolak"),
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.done,
                        style: TextStyle(
                            fontSize: 12.0, height: 2.0, color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButtonWidget(
                          title: "Kembali",
                          onTap: () => Navigator.pop(Get.context!),
                          colorButton: Colors.red,
                          colortext: Colors.white,
                          border: BorderRadius.circular(8.0),
                        ),
                      )),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButtonWidget(
                          title: "Tolak",
                          onTap: () {
                            if (controller.alasanReject.value.text != "") {
                              Navigator.pop(Get.context!);
                              validasiMenyetujui(false, em_id);
                            } else {
                              UtilsAlert.showToast(
                                  "Harap isi alasan terlebih dahulu");
                            }
                          },
                          colorButton: Constanst.colorPrimary,
                          colortext: Colors.white,
                          border: BorderRadius.circular(8.0),
                        ),
                      ))
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30,
            )
          ],
        );
      },
    );
  }

  void validasiMenyetujui(pilihan, em_id) {
    int styleChose = pilihan == false ? 1 : 2;
    var stringPilihan = pilihan == false ? 'Tolak' : 'Menyetujui';
    showGeneralDialog(
      barrierDismissible: false,
      context: Get.context!,
      barrierColor: Colors.black54, // space around dialog
      transitionDuration: Duration(milliseconds: 200),
      transitionBuilder: (context, a1, a2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
              parent: a1,
              curve: Curves.elasticOut,
              reverseCurve: Curves.easeOutCubic),
          child: CustomDialog(
            // our custom dialog
            title: "Peringatan",
            content: "Yakin $stringPilihan Pengajuan ini ?",
            positiveBtnText: "Lanjutkan",
            negativeBtnText: "Kembali",
            style: styleChose,
            buttonStatus: 1,
            positiveBtnPressed: () {
              print(controller.detailData[0]);
              if (controller.detailData[0]['type'] == 'absensi') {
                print("masuk sini ${controller.detailData[0]['type']}");
                controller.approvalAbsensi(
                    pilihan: pilihan,
                    date:
                        controller.detailData[0]['waktu_pengajuan'].toString(),
                    status: styleChose.toString(),
                    checkin: controller.detailData[0]['dari_jam'].toString(),
                    checkout: controller.detailData[0]['sampai_jam'].toString(),
                    image: controller.detailData[0]['file'].toString(),
                    note: controller.detailData[0]['deskripsi'].toString(),
                    ajuanEmid: controller.detailData[0]['em_id'].toString(),
                    id: controller.detailData[0]['id'].toString());
              } else {
                UtilsAlert.loadingSimpanData(
                    Get.context!, "Proses $stringPilihan pengajuan");
                controller.aksiMenyetujui(pilihan);
              }
              controllerGlobal.kirimNotifikasi(
                  title: 'Cuti',
                  status: 'approve',
                  pola: controllerGlobal.valuePolaPersetujuan.value.toString(),
                  statusApproval: controller.valuePolaPersetujuan == 1 ||
                          controller.valuePolaPersetujuan == "1"
                      ? "1"
                      : controller.valuePolaPersetujuan == 2 ||
                              controller.valuePolaPersetujuan == "2"
                          ? controller.detailData[0]['nama_approve1'] == "" ||
                                  controller.detailData[0]['nama_approve1'] ==
                                      "null" ||
                                  controller.detailData[0]['nama_approve1'] ==
                                      null
                              ? "1"
                              : "2"
                          : "1",
                  emId: em_id,
                  nomor: controller.detailData[0]['nomor_ajuan'],
                  emIdApproval1: controller.detailData[0]['em_report_to'],
                  emIdApproval2: controller.detailData[0]['em_report2_to'] ==
                              "" ||
                          controller.detailData[0]['em_report2_to'] == "null" ||
                          controller.detailData[0]['em_report2_to'] == null
                      ? controller.detailData[0]['em_report_to']
                      : controller.detailData[0]['em_report2_to']);
            },
          ),
        );
      },
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return null!;
      },
    );
  }

  @override
  void initState() {
    controller.getDetailData(
        widget.idxDetail, widget.emId, widget.title, widget.delegasi);
    super.initState();
    var emId = AppData.informasiUser![0].em_id;

    if (controllerGlobal.valuePolaPersetujuan.value.toString() == "1") {
      if (controller.detailData[0]['nama_approve1'] == "" ||
          controller.detailData[0]['nama_approve1'] == "null" ||
          controller.detailData[0]['nama_approve1'] == null) {
        if (controller.detailData[0]['em_report_to']
            .toString()
            .contains(emId)) {
          controller.showButton.value = true;
        } else {
          controller.showButton.value = false;
        }
      } else {}
    } else {
      if (controller.detailData[0]['nama_approve1'] == "" ||
          controller.detailData[0]['nama_approve1'] == "null" ||
          controller.detailData[0]['nama_approve1'] == null) {
        if (controller.detailData[0]['em_report_to']
            .toString()
            .contains(emId)) {
          controller.showButton.value = true;
        } else {
          controller.showButton.value = false;
        }
      } else {
        if (controller.detailData[0]['em_report2_to'] == "" ||
            controller.detailData[0]['em_report2_to'] == "null" ||
            controller.detailData[0]['em_report2_to'] == null) {
          if (controller.detailData[0]['em_report_to']
              .toString()
              .contains(emId)) {
            controller.showButton.value = true;
          } else {
            controller.showButton.value = false;
          }
        } else {
          if (controller.detailData[0]['em_report2_to']
              .toString()
              .contains(emId)) {
            controller.showButton.value = true;
          } else {
            controller.showButton.value = false;
          }
        }
      }
    }

    if (controller.detailData[0]['type'].toString().toLowerCase() ==
        "Lembur".toString().toLowerCase()) {
      DateTime start = DateTime.parse(
          "${controller.detailData[0]['waktu_pengajuan']} ${controller.detailData[0]['waktu_dari']}");
      DateTime end = DateTime.parse(
          "${controller.detailData[0]['waktu_pengajuan']} ${controller.detailData[0]['waktu_sampai']}");

      Duration difference = end.difference(start);

      hours = difference.inHours;
      minutes = (difference.inMinutes % 60);
      second = (difference.inSeconds % 60);
    }
  }

  @override
  Widget build(BuildContext context) {
    var totalKlaim = controller.detailData[0]['type'] == "Klaim"
        ? controller.detailData[0]['lainnya']['total_claim']
        : 0;
    var rupiah = controller.convertToIdr(totalKlaim, 0);
    var namaTipe = controller.detailData[0]['type'] == "Klaim"
        ? controller.detailData[0]['lainnya']['nama_tipe']
        : "";
    var image = controller.detailData[0]['image'];
    var typeAjuan = controller.detailData[0]['leave_status'];
    var em_id = controller.detailData[0]['emId_pengaju'];
    return Scaffold(
      backgroundColor: Constanst.coloBackgroundScreen,
      // appBar: AppBar(
      //   backgroundColor: Constanst.colorPrimary,
      //   automaticallyImplyLeading: false,
      //   elevation: 2,
      //   flexibleSpace: AppbarMenu1(
      //     title: "Detail Persetujuan Izin",
      //     colorTitle: Colors.white,
      //     colorIcon: Colors.white,
      //     iconShow: true,
      //     icon: 1,
      //     onTap: () {
      //       controller.alasanReject.value.text = "";
      //       Get.back();
      //     },
      //   ),
      // ),
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
              centerTitle: true,
              title: Text(
                "Detail Persetujuan Cuti",
                style: GoogleFonts.inter(
                    color: Constanst.fgPrimary,
                    fontWeight: FontWeight.w500,
                    fontSize: 20),
              ),
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
                        controller.alasanReject.value.text = "";
                        Get.back();
                      },
                    ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
          ),
          child: Obx(() => controller.showButton.value == true
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Constanst
                                .border, // Set the desired border color
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            print(AppData.informasiUser![0].em_id);
                            print(controller.detailData[0]['em_report_to']);
                            print(controller.detailData[0]['em_report2_to']);
                            // print("tes");
                            showBottomAlasanReject(em_id);
                          },
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Constanst.color4,
                              backgroundColor: Constanst.colorWhite,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                              // padding: EdgeInsets.zero,
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0)),
                          child: Text(
                            'Tolak',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                color: Constanst.color4,
                                fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            validasiMenyetujui(true, em_id);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Constanst.colorWhite,
                            backgroundColor: Constanst.colorPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                            // padding: const EdgeInsets.fromLTRB(20, 12, 20, 12)
                          ),
                          child: Text(
                            'Menyetujui',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                color: Constanst.colorWhite,
                                fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : const SizedBox()),
        ),
      ),
      body: WillPopScope(
          onWillPop: () async {
            controller.alasanReject.value.text = "";
            Get.back();
            return true;
          },
          child: SafeArea(
            child: Obx(
              () => Padding(
                padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    controller.jumlahCuti.value == 0
                        ? const SizedBox()
                        : informasiSisaCuti(),
                    controller.jumlahCuti.value == 0
                        ? const SizedBox()
                        : const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          border: Border.all(
                              width: 0.5,
                              color: const Color.fromARGB(255, 211, 205, 205))),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                image == ""
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
                                                    "${Api.UrlfotoProfile}${image}",
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
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${controller.detailData[0]['nama_pengaju']}",
                                      style: GoogleFonts.inter(
                                          color: Constanst.fgPrimary,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      controller.detailData[0]['nama_divisi'],
                                      style: GoogleFonts.inter(
                                          color: Constanst.fgSecondary,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 12.0, bottom: 12.0),
                              child: Divider(
                                height: 0,
                                color: Constanst.fgBorder,
                                thickness: 1,
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        controller.detailData[0]['nomor_ajuan']
                                            .toString(),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        Constanst.convertDate6(
                                            "${controller.detailData[0]['waktu_pengajuan']}"),
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
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          border: Border.all(
                              width: 0.5,
                              color: const Color.fromARGB(255, 211, 205, 205))),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Nama Pengajuan",
                              style: GoogleFonts.inter(
                                  color: Constanst.fgSecondary,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            // controller.detailData[0]['type']
                            //                 .toString()
                            //                 .toLowerCase() ==
                            //             "Cuti".toString().toLowerCase() ||
                            //         controller.detailData[0]['type']
                            //                 .toString()
                            //                 .toLowerCase() ==
                            //             "Lembur".toString().toLowerCase()
                            //     ? Text(
                            //         "${controller.detailData[0]['nama_pengajuan']} ",
                            //         style: GoogleFonts.inter(
                            //             color: Constanst.fgPrimary,
                            //             fontWeight: FontWeight.w500,
                            //             fontSize: 16),
                            //       )
                            //     : Text(
                            //         "${controller.detailData[0]['type']} $namaTipe - ${controller.detailData[0]['category']}",
                            //         style: GoogleFonts.inter(
                            //             color: Constanst.fgPrimary,
                            //             fontWeight: FontWeight.w500,
                            //             fontSize: 16),
                            //       ),
                            Text(
                              "${controller.detailData[0]['type']} - ${controller.detailData[0]['category']}",
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  color: Constanst.fgPrimary,
                                  fontSize: 16),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 12.0, bottom: 12.0),
                              child: Divider(
                                thickness: 1,
                                height: 0,
                                color: Constanst.border,
                              ),
                            ),
                            Text(
                              "Tanggal Cuti",
                              style: GoogleFonts.inter(
                                  color: Constanst.fgSecondary,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            controller.detailData[0]['type'] == "Klaim"
                                ? const SizedBox()
                                : Text(
                                    "${"${controller.detailData[0]['waktu_dari']}"} - ${"${controller.detailData[0]['waktu_sampai']}"}",
                                    style: GoogleFonts.inter(
                                        color: Constanst.fgPrimary,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 12.0, bottom: 12.0),
                              child: Divider(
                                thickness: 1,
                                height: 0,
                                color: Constanst.border,
                              ),
                            ),
                            controller.detailData[0]['durasi'] == "" ||
                                    controller.detailData[0]['durasi'] == null
                                ? const SizedBox()
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Durasi",
                                        style: GoogleFonts.inter(
                                            color: Constanst.fgSecondary,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${controller.detailData[0]['durasi']} Hari",
                                        style: GoogleFonts.inter(
                                            color: Constanst.fgPrimary,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 12.0, bottom: 12.0),
                              child: Divider(
                                thickness: 1,
                                height: 0,
                                color: Constanst.border,
                              ),
                            ),
                            Text(
                              "Catatan",
                              style: GoogleFonts.inter(
                                  color: Constanst.fgSecondary,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              controller.detailData[0]['type'] == "absensi"
                                  ? "${controller.detailData[0]['deskripsi']}"
                                  : "${controller.detailData[0]['catatan']}",
                              style: GoogleFonts.inter(
                                  color: Constanst.fgPrimary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),

                            // controller.detailData[0]['type']
                            //             .toString()
                            //             .toLowerCase() ==
                            //         'absensi'.toLowerCase()
                            //     ? SizedBox()
                            //     : controller.detailData[0]['type'] ==
                            //                 "Lembur" ||
                            //             controller.detailData[0]['type'] ==
                            //                 "Tugas Luar" ||
                            //             controller.detailData[0]['type'] ==
                            //                 "Dinas Luar"
                            //         ? Text(
                            //             "Pemberi Tugas",
                            //             style: TextStyle(
                            //                 color: Constanst.colorText2),
                            //           )
                            //         : controller.detailData[0]['type'] ==
                            //                 "Klaim"
                            //             ? Text(
                            //                 "Total Klaim",
                            //                 style: TextStyle(
                            //                     color: Constanst.colorText2),
                            //               )
                            //             : Text(
                            //                 "Delegasi Kepada",
                            //                 style: TextStyle(
                            //                     color: Constanst.colorText2),
                            //               ),

                            controller.detailData[0]['file'] == "" ||
                                    controller.detailData[0]['file'] == null
                                ? const SizedBox()
                                : fileWidget(),

                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 12.0, bottom: 12.0),
                              child: Divider(
                                thickness: 1,
                                height: 0,
                                color: Constanst.border,
                              ),
                            ),

                            typeAjuan == 'Rejected'
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Iconsax.close_circle,
                                        color: Constanst.color4,
                                        size: 22,
                                      ),
                                      const SizedBox(width: 8),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Status Pengajuan",
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color: Constanst.fgSecondary,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                              "Rejected by ${controller.detailData[0]['nama_approve1']}",
                                              style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w500,
                                                  color: Constanst.fgPrimary,
                                                  fontSize: 14)),
                                          const SizedBox(height: 4),
                                          Text(
                                            controller.detailData[0]['catatan'],
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Iconsax.tick_circle,
                                            color: Colors.green,
                                            size: 22,
                                          ),
                                          const SizedBox(width: 8),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Status Pengajuan",
                                                style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                  color: Constanst.fgSecondary,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                  "Approved by ${controller.detailData[0]['nama_approve1']} ",
                                                  style: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          Constanst.fgPrimary,
                                                      fontSize: 14)),
                                            ],
                                          ),
                                        ],
                                      )
                                    : Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Iconsax.timer,
                                            color: Constanst.color3,
                                            size: 22,
                                          ),
                                          const SizedBox(width: 8),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Status Pengajuan",
                                                style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                  color: Constanst.fgSecondary,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text("Pending Approval",
                                                  style: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          Constanst.fgPrimary,
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
                                      ),
                            // controllerGlobal.valuePolaPersetujuan.value ==
                            //             "1" ||
                            //         controller.detailData[0]['nama_approve1'] ==
                            //             "" ||
                            //         controller.detailData[0]['nama_approve1'] ==
                            //             "null" ||
                            //         controller.detailData[0]['nama_approve1'] ==
                            //             null
                            //     ? const SizedBox()
                            //     : infoApprove1(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget fileWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
          child: Divider(
            thickness: 1,
            height: 0,
            color: Constanst.border,
          ),
        ),
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
              if (controller.detailData[0]['title_ajuan'] ==
                  "Pengajuan Tidak Hadir") {
                controller.viewFile(
                    "tidak_hadir", controller.detailData[0]['file']);
              } else if (controller.detailData[0]['title_ajuan'] ==
                  "Pengajuan Cuti") {
                controller.viewFile("cuti", controller.detailData[0]['file']);
              } else if (controller.detailData[0]['title_ajuan'] ==
                  "Pengajuan Klaim") {
                controller.viewFile("klaim", controller.detailData[0]['file']);
              } else if (controller.detailData[0]['title_ajuan'] ==
                  "Pengajuan Absensi") {
                viewLampiranAjuan(controller.detailData[0]['file']);
              }
            },
            child: Text(
              "${controller.detailData[0]['file']}",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Constanst.infoLight,
              ),
            )),
        // const SizedBox(height: 12),
      ],
    );
  }

  Widget infoApprove1() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Iconsax.tick_circle,
          color: Colors.green,
          size: 22,
        ),
        const SizedBox(width: 8),
        Text(
          "Approve 1 by ${controller.detailData[0]['nama_approve1']}",
          style: TextStyle(color: Constanst.colorText2),
        ),
      ],
    );
  }

  Widget informasiSisaCuti() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          border: Border.all(
              width: 0.5, color: const Color.fromARGB(255, 211, 205, 205))),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 12, bottom: 12, left: 16, right: 16),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "SISA CUTI ${controller.detailData[0]['nama_pengaju']}",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        color: Constanst.fgPrimary,
                        fontSize: 16),
                  ),
                  Text(
                    "${controller.cutiTerpakai.value}/${controller.jumlahCuti.value}",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        color: Constanst.fgSecondary,
                        fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: MediaQuery.of(Get.context!).size.width,
                child: LinearPercentIndicator(
                  barRadius: const Radius.circular(100.0),
                  lineHeight: 8.0,
                  padding: EdgeInsets.zero,
                  percent: controller.persenCuti.value,
                  progressColor: Constanst.colorPrimary,
                ),
              ),

              // Text("Cuti Khusus"),
            ],
          ),
        ),
      ),
    );
  }

  Widget informasiIzinJam() {
    return SizedBox(
      child: controller.detailData[0]['category'] == "HALFDAY"
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Kategori",
                  style: TextStyle(color: Constanst.colorText2),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "${controller.detailData[0]['category']}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Jam",
                  style: TextStyle(color: Constanst.colorText2),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "${controller.detailData[0]['jamAjuan']} sd ${controller.detailData[0]['sampaiJamAjaun']}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            )
          : SizedBox(),
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
