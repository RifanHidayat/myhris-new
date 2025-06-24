import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/absen_controller.dart';
import 'package:siscom_operasional/controller/laporan_absen_karyawan_controller.dart';
import 'package:siscom_operasional/model/absen_model.dart';
import 'package:siscom_operasional/screen/absen/detail_absen.dart';
import 'package:siscom_operasional/utils/app_data.dart';
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
  var controllerAbsen = Get.find<AbsenController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadData(widget.em_id, widget.bulan, widget.full_name);
    });
    
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
    var startTime;
    var endTime;
    var startDate;
    var endDate;
    var now = DateTime.now();

    TimeOfDay waktu1 = TimeOfDay(
        hour: int.parse(
            AppData.informasiUser![0].startTime.toString().split(':')[0]),
        minute: int.parse(
            AppData.informasiUser![0].startTime.toString().split(':')[1]));

    TimeOfDay waktu2 = TimeOfDay(
        hour: int.parse(
            AppData.informasiUser![0].endTime.toString().split(':')[0]),
        minute: int.parse(AppData.informasiUser![0].endTime
            .toString()
            .split(':')[1])); // Waktu kedua
    print('ini waktu 1${AppData.informasiUser![0].startTime}');
    int totalMinutes1 = waktu1.hour * 60 + waktu1.minute;
    int totalMinutes2 = waktu2.hour * 60 + waktu2.minute;

    if (totalMinutes1 < totalMinutes2) {
// Menggabungkan tanggal hari ini dengan waktu dari string
      startTime = DateTime.parse(
          '${index.atten_date == '' || index.atten_date == null ? DateFormat('yyyy-mm-dd').format(DateTime.now()) : index.atten_date} ${AppData.informasiUser![0].startTime}:00');
      endTime = DateTime.parse(
          '${index.atten_date == '' || index.atten_date == null ? DateFormat('yyyy-mm-dd').format(DateTime.now()) : index.atten_date} ${AppData.informasiUser![0].endTime}:00');

      //alur beda hari
    } else if (totalMinutes1 > totalMinutes2) {
      var waktu3 =
          TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
      int totalMinutes3 = waktu3.hour * 60 + waktu3.minute;

      if (totalMinutes2 > totalMinutes3) {
        print("masuk sini view las user");
        var today;
        if (index.atten_date!.isNotEmpty) {
          today = DateTime.parse(index.atten_date!);
        }
        var yesterday = today.add(const Duration(days: 1));
        startDate = DateFormat('yyyy-MM-dd').format(yesterday);
        endDate = DateFormat('yyyy-MM-dd').format(today);
        startTime = DateTime.parse(
            '$startDate ${AppData.informasiUser![0].startTime}:00');
        endTime =
            DateTime.parse('$endDate ${AppData.informasiUser![0].endTime}:00');
        print('ini  bener gakl lu${startTime.isAfter(today)}');
      } else {
        var today;
        print('masa lu kosong sih ${index.atten_date}');
        if (index.atten_date!.isNotEmpty) {
          today = DateTime.parse(index.atten_date!);
        } else {
          today = DateTime.now();
        }
        var yesterday = today.add(const Duration(days: 1));

        startDate = DateFormat('yyyy-MM-dd').format(today);
        endDate = DateFormat('yyyy-MM-dd').format(yesterday);

        startTime = DateTime.parse(
            '$startDate ${AppData.informasiUser![0].startTime}:00'); // Waktu kemarin
        endTime =
            DateTime.parse('$endDate ${AppData.informasiUser![0].endTime}:00');
        print(
            'ini  bener gakl lu${startTime.isBefore(today)}'); // Waktu hari ini
        print('ini  bener gakl lu${startTime}'); // Waktu hari ini
        print('ini  bener gakl lu${endTime}'); // Waktu hari ini
      }
    } else {
      startTime = AppData.informasiUser![0].startTime;
      endTime = AppData.informasiUser![0].endTime;

      startDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      print(
          "Waktu 1 sama dengan waktu 2 new ${totalMinutes1}  ${totalMinutes2}");
    }

    var tipeAbsen = AppData.informasiUser![0].tipeAbsen;
    var tipeAlpha = AppData.informasiUser![0].tipeAlpha;
    var list = tipeAlpha.toString().split(',').map(int.parse).toList();
    print('ini tampilan 2 $tipeAbsen $tipeAlpha $list');
    var masuk = list[0];
    var keluar = list[1];
    var istirahatMasuk = list[2];
    var istirahatKeluar = list[3];
    var jamMasuk = index.signin_time ?? '';
    var jamKeluar = index.signout_time ?? '';
    print(jamKeluar.isEmpty);
    print(keluar);
    var jamIstirahatMasuk = index.breakinTime ?? '';
    var jamIstirahatKeluar = index.breakoutTime ?? '';
    if (tipeAbsen == '2') {
      if ((keluar == 1 && jamKeluar == '00:00:00') ||
          (masuk == 1 && jamMasuk == '00:00:00')) {
        controllerAbsen.tipeAlphaAbsen.value = 1;
        if (jamMasuk == '00:00:00') {
          controllerAbsen.catatanAlpha.value = '/ Gak Absen Masuk';
        } else {
          controllerAbsen.catatanAlpha.value = '/ Gak Absen Keluar';
        }
      } else {
        controllerAbsen.tipeAlphaAbsen.value = 0;
      }
    } else if (tipeAbsen == '3') {
      print('gak mungkin gak kemari');
      if ((keluar == 1 && jamKeluar == '00:00:00') ||
          (masuk == 1 && jamMasuk == '00:00:00') ||
          (jamIstirahatKeluar == '00:00:00' && istirahatKeluar == 1) ||
          (jamIstirahatMasuk == '00:00:00' && istirahatMasuk == 1)) {
        print('masa gak kesini');
        controllerAbsen.tipeAlphaAbsen.value = 1;
        if (jamMasuk == '00:00:00') {
          controllerAbsen.catatanAlpha.value = '/ Gak Absen Masuk';
        } else if (jamKeluar == '00:00:00') {
          controllerAbsen.catatanAlpha.value = '/ Gak Absen Keluar';
        } else if (jamIstirahatKeluar == '00:00:00') {
          controllerAbsen.catatanAlpha.value = '/ Gak Absen Istirahat Keluar';
        } else if (jamIstirahatMasuk == '00:00:00') {
          controllerAbsen.catatanAlpha.value = '/ Gak Absen Istirahat Masuk';
        }
      } else {
        controllerAbsen.tipeAlphaAbsen.value = 0;
      }
    }
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
                              controllerAbsen.tipeAlphaAbsen.value == 1 &&
                                      (endTime.isBefore(now))
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
                                            text:
                                                "ALPHA ${controllerAbsen.catatanAlpha.value}",
                                            weight: FontWeight.w400,
                                            size: 11.0,
                                          ),
                                        ],
                                      ))
                                  : index.namaHariLibur != null
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
                                                text: index.namaHariLibur,
                                                weight: FontWeight.w400,
                                                size: 11.0,
                                              ),
                                            ],
                                          ))
                                      : index.namaTugasLuar != null
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
                                                    text: index.namaTugasLuar,
                                                    weight: FontWeight.w400,
                                                    size: 11.0,
                                                  ),
                                                ],
                                              ))
                                          : index.namaDinasLuar != null
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
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
                                                        text:
                                                            index.namaDinasLuar,
                                                        weight: FontWeight.w400,
                                                        size: 11.0,
                                                      ),
                                                    ],
                                                  ))
                                              : index.namaCuti != null
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
                                                                index.namaCuti,
                                                            weight:
                                                                FontWeight.w400,
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
                                                                Iconsax
                                                                    .info_circle,
                                                                size: 15,
                                                                color: Constanst
                                                                    .infoLight,
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              TextLabell(
                                                                text: index
                                                                    .namaSakit,
                                                                weight:
                                                                    FontWeight
                                                                        .w400,
                                                                size: 11.0,
                                                              ),
                                                            ],
                                                          ))
                                                      : index.offDay
                                                                  .toString() ==
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
                                                          : (index.jamKerja
                                                                          .toString() !=
                                                                      "null") &&
                                                                  DateTime.parse(
                                                                          waktuMasuk)
                                                                      .isAfter(
                                                                          DateTime.parse(batasWaktu).add(const Duration(minutes: 1)))
                                                              ? Padding(
                                                                  padding: const EdgeInsets.only(top: 12),
                                                                  child: Row(
                                                                    children: [
                                                                      Icon(
                                                                        Iconsax
                                                                            .info_circle,
                                                                        size:
                                                                            15,
                                                                        color: Constanst
                                                                            .infoLight,
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      const TextLabell(
                                                                        text:
                                                                            "Terlambat",
                                                                        weight:
                                                                            FontWeight.w400,
                                                                        size:
                                                                            11.0,
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
