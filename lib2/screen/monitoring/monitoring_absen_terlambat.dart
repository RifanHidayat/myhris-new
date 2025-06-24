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
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/appbar_widget.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/month_year_picker.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';

class monitoringAbsenTerlambat extends StatefulWidget {
  String? em_id, full_name;
  monitoringAbsenTerlambat({Key? key, this.em_id, this.full_name})
      : super(key: key);
  @override
  _monitoringAbsenTerlambatState createState() =>
      _monitoringAbsenTerlambatState();
}

class _monitoringAbsenTerlambatState extends State<monitoringAbsenTerlambat> {
  var controller = Get.put(MonitoringController());

  @override
  void initState() {
    controller.getTimeNow();
    controller.loadMonitoringAbsenTerlambat();
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
                "Monitoring Absen Terlambat",
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
                      child: controller.historyAbsen.value.isEmpty
                          ? Center(child: Text(controller.loading.value))
                          : listAbsen(),
                    ),
                  ),
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
                                      var bulan = array[1];
                                      var tahun = array[0];

                                      // Validasi apakah bulan dan tahun periode awal valid
                                      bool isValid =
                                          controller.validateStartPeriod(
                                        bulan,
                                        tahun,
                                        controller.bulanSelectedEndPeriod.value,
                                        controller.tahunSelectedEndPeriod.value
                                      );

                                      if (isValid) {
                                        controller.bulanSelectedStartPeriod
                                            .value = bulan;
                                        controller.tahunSelectedStartPeriod
                                            .value = tahun;
                                        controller.startPeriode.value =
                                            "$tahun-$bulan-${AppData.informasiUser![0].beginPayroll}";

                                        // Refresh observables
                                        controller.bulanSelectedStartPeriod
                                            .refresh();
                                        controller.tahunSelectedStartPeriod
                                            .refresh();
                                        controller.startPeriode.refresh();
                                        controller
                                            .loadMonitoringAbsenTerlambat();
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
                                        controller
                                            .loadMonitoringAbsenTerlambat();
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

  Widget listAbsen() {
    return Obx(
      () => ListView.builder(
          physics: controller.historyAbsen.length <= 10
              ? const AlwaysScrollableScrollPhysics()
              : const BouncingScrollPhysics(),
          itemCount: controller.historyAbsen.value.length,
          itemBuilder: (context, index) {
            var jamMasuk =
                controller.historyAbsen.value[index].signinTime ?? '';
            var jamKeluar =
                controller.historyAbsen.value[index].signoutTime ?? '';
            var placeIn = controller.historyAbsen.value[index].placeIn ?? '';
            var placeOut = controller.historyAbsen.value[index].placeOut ?? '';
            var note = controller.historyAbsen.value[index].signoutNote ?? '';
            var signInLongLat =
                controller.historyAbsen.value[index].signinLonglat ?? '';
            var signOutLongLat =
                controller.historyAbsen.value[index].signoutLonglat ?? '';
            var reqType = controller.historyAbsen.value[index].regType ?? '';

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

            print("id ${controller.historyAbsen.value[index].id}");

            // return controller.historyAbsen.value[index].id=="" || controller.historyAbsen.value[index].id==null|| controller.historyAbsen.value[index].id==0?SizedBox():  controller.historyAbsen.value[index].viewTurunan ==
            //         true
            //     ? tampilan1(controller.historyAbsen.value[index], index)
            //     : tampilan2(controller.historyAbsen.value[index]);

            return tampilan2(controller.historyAbsen.value[index]);
          }),
    );
  }

  Widget tampilan2(MonitoringDataModel index) {
    var jamMasuk = index.signinTime ?? '00:00:00';
    var jamKeluar = index.signoutTime ?? '00:00:00';
    var jamKerja = index.jamKerja ?? '00:00:00';
    var placeIn = index.placeIn ?? '';
    var placeOut = index.placeOut ?? '';
    var note = index.signinNote ?? '';
    var signInLongLat = index.signinLonglat ?? '';
    var signOutLongLat = index.signoutLonglat ?? '';
    var regType = index.regType ?? 0;
    var attenDate = index.attenDate ?? "";
    var statusView;
    if (placeIn != "") {
      statusView =
          placeIn == "pengajuan" && placeOut == "pengajuan" ? true : false;
      statusView = true;
    }

    // Membuat dua objek DateTime
    DateTime waktuAwal = DateTime.parse("${index.attenDate} ${jamKerja}");
    DateTime waktuAkhir = DateTime.parse("${index.attenDate} ${jamMasuk}");

    print('$waktuAwal');
    print('$jamKerja');

    // Menghitung selisih waktu
    Duration selisih = waktuAkhir.difference(waktuAwal);

    // Mengonversi selisih menjadi menit
    int totalMenit = selisih.inMinutes;
    int totalDetik = selisih.inSeconds % 60;
    var text = '';

    if (totalMenit > 0 && totalDetik > 0) {
      text =
          "Terlambat ${totalMenit} Menit ${totalDetik} Detik sebelum waktu masuk";
    } else {
      if (totalMenit > 0) {
        text = "Terlambat ${totalMenit} Menit sebelum waktu masuk";
      }
      if (totalDetik > 0) {
        text = "Terlambat ${totalDetik} Detik sebelum waktu masuk";
      }
    }

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
        child: statusView == false
            ? Container(
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
                          decoration: BoxDecoration(
                            color: Constanst.colorNeutralBgSecondary,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              bottomLeft: Radius.circular(8.0),
                            ),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 5.0, bottom: 5.0),
                            child: Column(
                              children: [
                                Text(
                                    DateFormat('d').format(
                                        DateFormat('yyyy-MM-dd')
                                            .parse(index.attenDate)),
                                    style: GoogleFonts.inter(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Constanst.fgPrimary,
                                    )),
                                Text(
                                    DateFormat('EEEE', 'id').format(
                                        DateFormat('yyyy-MM-dd')
                                            .parse(index.attenDate)),
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Constanst.fgPrimary,
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
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(top: 8, left: 6, right: 6),
                              child: TextLabell(
                                text: text,
                                color: Colors.black.withOpacity(0.5),
                                size: 11.0,
                              ),
                            ),
                            Row(
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
                                        "$jamMasuk",
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "$jamKeluar",
                                    style: GoogleFonts.inter(
                                        color: Constanst.fgPrimary,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    regType == 0 ? "Face Recognition" : "Photo",
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
                    // Expanded(
                    //   flex: 9,
                    //   child: Icon(
                    //     Icons.arrow_forward_ios_rounded,
                    //     size: 16,
                    //     color: Constanst.colorNeutralFgTertiary,
                    //   ),
                    // ),
                  ],
                ),
              )
            : Container(
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
                          height: 50,
                          decoration: BoxDecoration(
                            color: Constanst.colorNeutralBgSecondary,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              bottomLeft: Radius.circular(8.0),
                            ),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 5.0, bottom: 5.0),
                            child: Column(
                              children: [
                                Text(
                                    DateFormat('d').format(
                                        DateFormat('yyyy-MM-dd')
                                            .parse(index.attenDate)),
                                    style: GoogleFonts.inter(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Constanst.fgPrimary,
                                    )),
                                Text(
                                    DateFormat('EEEE', 'id').format(
                                        DateFormat('yyyy-MM-dd')
                                            .parse(index.attenDate)),
                                    style: GoogleFonts.inter(
                                      fontSize: 8,
                                      fontWeight: FontWeight.w400,
                                      color: Constanst.fgPrimary,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 85,
                      child:
                          //     ada asen
                          Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 8, left: 6, right: 6),
                            child: TextLabell(
                              text: text,
                              color: Colors.black.withOpacity(0.5),
                              size: 11.0,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12, bottom: 1),
                            child: InkWell(
                              onTap: () {
                                // controller.historySelected(index.id, 'history');
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
                                      // Expanded(
                                      //   flex: 9,
                                      //   child: Icon(
                                      //     Icons.arrow_forward_ios_rounded,
                                      //     size: 16,
                                      //     color: Constanst.colorNeutralFgTertiary,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
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
