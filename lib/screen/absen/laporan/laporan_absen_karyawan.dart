import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/laporan_absen_karyawan_controller.dart';
import 'package:siscom_operasional/screen/absen/detail_absen.dart';
import 'package:siscom_operasional/utils/appbar_widget.dart';
import 'package:siscom_operasional/utils/constans.dart';

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
            child: Obx(
              () => Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          customBorder: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                          onTap: () async {
                            await showMenu(
                              context: context,
                              position:
                                  const RelativeRect.fromLTRB(17, 235, 17, 0),
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
                    Flexible(
                        child: controller.prosesLoad.value
                            ? Center(
                                child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Constanst.colorPrimary,
                              ))
                            : controller.detailRiwayat.value.isEmpty
                                ? Center(child: Text(controller.loading.value))
                                : listAbsen())
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget listAbsen() {
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: controller.detailRiwayat.value.length,
        itemBuilder: (context, index) {
          var idAbsen = controller.detailRiwayat.value[index]['id'];
          var jamMasuk = controller.detailRiwayat.value[index]['signin_time'];
          var jamKeluar = controller.detailRiwayat.value[index]['signout_time'];
          var tanggal = controller.detailRiwayat.value[index]['atten_date'];
          var longLatAbsenKeluar =
              controller.detailRiwayat.value[index]['signout_longlat'];

          var placeIn = controller.detailRiwayat.value[index]['place_in'];
          var placeOut = controller.detailRiwayat.value[index]['place_out'];
          var note = controller.detailRiwayat.value[index]['signin_note'];
          var signInLongLat =
              controller.detailRiwayat.value[index]['signin_longlat'];
          var signOutLongLat =
              controller.detailRiwayat.value[index]['signout_longlat'];
          var statusView = placeIn == "pengajuan" &&
                  placeOut == "pengajuan" &&
                  signInLongLat == "pengajuan" &&
                  signOutLongLat == "pengajuan"
              ? true
              : false;

          var regType = controller.detailRiwayat.value[index]['regtype'] ?? 0;
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
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: InkWell(
              customBorder: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              onTap: () {
                if (statusView == false) {
                  print(idAbsen);
                  controller.historySelected(idAbsen, "laporan");
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  statusView == false
                      ? Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  width: 1, color: Constanst.fgBorder)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
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
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5.0, bottom: 5.0),
                                      child: Column(
                                        children: [
                                          Text(
                                              DateFormat('d').format(
                                                  DateFormat('yyyy-MM-dd')
                                                      .parse(tanggal)),
                                              style: GoogleFonts.inter(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: Constanst.fgPrimary,
                                              )),
                                          Text(
                                              DateFormat('EEEE', 'id').format(
                                                  DateFormat('yyyy-MM-dd')
                                                      .parse(tanggal)),
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
                                flex: 38,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                              jamMasuk,
                                              style: GoogleFonts.inter(
                                                  color: Constanst.fgPrimary,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16),
                                            ),
                                            const SizedBox(height: 4),
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
                                  padding: const EdgeInsets.only(left: 4),
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
                                              longLatAbsenKeluar == ""
                                                  ? "00:00:00"
                                                  : jamKeluar,
                                              style: GoogleFonts.inter(
                                                  color: Constanst.fgPrimary,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16),
                                            ),
                                            const SizedBox(height: 4),
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
                                  Icons.arrow_forward_ios_rounded,
                                  size: 16,
                                  color: Constanst.colorNeutralFgTertiary,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 40,
                              child: Text(
                                "${Constanst.convertDate(tanggal ?? '')}",
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            Expanded(
                              flex: 60,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "$note",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          );
        });
  }
}
