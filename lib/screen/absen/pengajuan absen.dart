import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/absen_controller.dart';
import 'package:siscom_operasional/screen/absen/pengajuan%20absen_berhasil.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/month_year_picker.dart';
import 'package:siscom_operasional/utils/date_picker.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';

class pengajuanAbsen extends StatefulWidget {
  const pengajuanAbsen({super.key});

  @override
  State<pengajuanAbsen> createState() => _pengajuanAbsenState();
}

class _pengajuanAbsenState extends State<pengajuanAbsen> {
  var absenController = Get.put(AbsenController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    absenController.resetData();
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
            leadingWidth: 50,
            titleSpacing: 0,
            centerTitle: true,
            title: Text(
              "Pengajuan Absensi",
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
                absenController.clearData();
                Get.back();
              },
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(child: item()),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16.0),
                    ),
                    color: Constanst.colorWhite,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 2.0),
                        blurRadius: 12.0,
                      )
                    ]),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, top: 16.0, bottom: 12.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (absenController.checkinAjuan.value == "" &&
                            absenController.checkinAjuan.value == "") {
                          if (absenController.checkinAjuan2.value != "") {
                            if (absenController.placeCoordinateCheckin
                                .where((p0) => p0['is_selected'] == true)
                                .isEmpty) {
                              UtilsAlert.showToast(
                                  "Lokasi absen masuk belum diisi");
                              return;
                            }
                          } else {
                            UtilsAlert.showToast("Absensi masuk harus diisi");
                            return;
                          }
                        }

                        if (absenController.checkinAjuan2.value == "" &&
                            absenController.checkoutAjuan.value == "") {
                          UtilsAlert.showToast(
                              "Absen masuk atau Absen Keluar harus diisi");
                          return;
                        }

                        if (absenController.checkinAjuan2.value != "") {
                          if (absenController.placeCoordinateCheckin
                              .where((p0) => p0['is_selected'] == true)
                              .isEmpty) {
                            UtilsAlert.showToast(
                                "Lokasi absen masuk belum diisi");
                            return;
                          }
                        }

                        if (absenController.checkoutAjuan2.value != "") {
                          if (absenController.placeCoordinateCheckout
                              .where((p0) => p0['is_selected'] == true)
                              .isEmpty) {
                            UtilsAlert.showToast(
                                "Lokasi absen keluar belum diisi");
                            return;
                          }
                        }
                        absenController.nextKirimPengajuan('Status');
                      },
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Constanst.colorWhite,
                          backgroundColor: Constanst.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                          padding: const EdgeInsets.fromLTRB(0, 12, 0, 12)),
                      child: Text(
                        'Kirim',
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Constanst.colorWhite),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget item() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Constanst.fgBorder),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                //line 1
                InkWell(
                  customBorder: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16))),
                  onTap: () {
                    Future<void> _selectDate(BuildContext context) async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        cancelText: 'Batal',
                        confirmText: 'Simpan',
                        initialDate: absenController.selectedDate.value,
                        firstDate: DateTime(
                            DateTime.now().year,
                            DateTime.now().month - 1,
                            int.parse(AppData.informasiUser![0].beginPayroll
                                .toString())),
                        lastDate: DateTime(DateTime.now().year,
                            DateTime.now().month, DateTime.now().day),
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData(
                              colorScheme: ColorScheme.dark(
                                primary: Constanst.onPrimary,
                                onPrimary: Constanst.colorWhite,
                                onSurface: Constanst.fgPrimary,
                                surface: Constanst.colorWhite,
                              ),
                              // useMaterial3: settings.useMaterial3,
                              visualDensity: VisualDensity.standard,
                              dialogTheme: const DialogTheme(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16)))),
                              primaryColor: Constanst.fgPrimary,
                              textTheme: TextTheme(
                                titleMedium: GoogleFonts.inter(
                                  color: Constanst.fgPrimary,
                                ),
                              ),
                              dialogBackgroundColor: Constanst.colorWhite,
                              canvasColor: Colors.white,
                              hintColor: Constanst.onPrimary,
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: Constanst.onPrimary,
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );

                      if (picked != null) {
                        print("$picked");
                        absenController.selectedDate.value = picked;
                        absenController.tglAjunan.value =
                            DateFormat('yyyy-MM-dd').format(picked).toString();
                        absenController.checkAbsensi();

                        absenController.getPlaceCoordinateCheckin();
                        absenController.getPlaceCoordinateCheckout();

                        // var filter = DateFormat('yyyy-MM').format(time);
                        // var array = filter.split('-');
                        // var bulan = array[1];
                        // var tahun = array[0];
                        // controller.bulanSelectedSearchHistory.value = bulan;
                        // controller.tahunSelectedSearchHistory.value = tahun;
                        // controller.bulanDanTahunNow.value = "$bulan-$tahun";
                        // this.controller.bulanSelectedSearchHistory.refresh();
                        // this.controller.tahunSelectedSearchHistory.refresh();
                        // this.controller.bulanDanTahunNow.refresh();
                        // controller.loadHistoryAbsenUser();
                      }
                    }

                    _selectDate(context);
                    // DatePicker.showPicker(
                    //   context,
                    //   pickerModel: CustomDatePicker(
                    //     minTime: DateTime(
                    //         DateTime.now().year,
                    //         DateTime.now().month - 1,
                    //         int.parse(AppData.informasiUser![0].beginPayroll
                    //             .toString())),
                    //     maxTime: DateTime(DateTime.now().year,
                    //         DateTime.now().month, DateTime.now().day),
                    //     currentTime: DateTime.now(),
                    //   ),
                    //   onConfirm: (time) {
                    //     if (time != null) {
                    //       print("$time");
                    //       absenController.tglAjunan.value =
                    //           DateFormat('yyyy-MM-dd').format(time).toString();
                    //       absenController.checkAbsensi();

                    //       absenController.getPlaceCoordinateCheckin();
                    //       absenController.getPlaceCoordinateCheckout();

                    //       // var filter = DateFormat('yyyy-MM').format(time);
                    //       // var array = filter.split('-');
                    //       // var bulan = array[1];
                    //       // var tahun = array[0];
                    //       // controller.bulanSelectedSearchHistory.value = bulan;
                    //       // controller.tahunSelectedSearchHistory.value = tahun;
                    //       // controller.bulanDanTahunNow.value = "$bulan-$tahun";
                    //       // this.controller.bulanSelectedSearchHistory.refresh();
                    //       // this.controller.tahunSelectedSearchHistory.refresh();
                    //       // this.controller.bulanDanTahunNow.refresh();
                    //       // controller.loadHistoryAbsenUser();
                    //     }
                    //   },
                    // );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Iconsax.calendar_1,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextLabell(
                                text: "Pilih Tanggal * ",
                                color: Constanst.fgPrimary,
                                size: 14,
                                weight: FontWeight.w400,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextLabell(
                                    text: absenController.tglAjunan.value == ""
                                        ? "-"
                                        : absenController.tglAjunan.value,
                                    color: Constanst.fgPrimary,
                                    weight: FontWeight.w500,
                                    size: 16,
                                  ),
                                  Icon(Iconsax.arrow_down_1,
                                      size: 20, color: Constanst.fgPrimary),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Divider(
                    height: 0,
                    thickness: 1,
                    color: Constanst.fgBorder,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Iconsax.login_1,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextLabell(
                                      text: "Absen Masuk",
                                      color: Constanst.fgPrimary,
                                      size: 14,
                                      weight: FontWeight.w400,
                                    ),
                                    const SizedBox(height: 8),
                                    TextLabell(
                                      text: absenController
                                                  .checkinAjuan.value ==
                                              ""
                                          ? "_ _ : _ _"
                                          : absenController.checkinAjuan.value,
                                      color: Constanst.fgSecondary,
                                      weight: FontWeight.w500,
                                      size: 16,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Iconsax.logout_1,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextLabell(
                                      text: "Absen Keluar",
                                      color: Constanst.fgPrimary,
                                      size: 14,
                                      weight: FontWeight.w400,
                                    ),
                                    const SizedBox(height: 8),
                                    TextLabell(
                                      text: absenController
                                                  .checkoutAjuan.value ==
                                              ""
                                          ? "_ _ : _ _"
                                          : absenController.checkoutAjuan.value,
                                      color: Constanst.fgSecondary,
                                      weight: FontWeight.w500,
                                      size: 16,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Constanst.fgBorder),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: InkWell(
                          customBorder: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16))),
                          onTap: () {
                            showTimePicker(
                              context: Get.context!,
                              initialTime: TimeOfDay.now(),
                              // initialEntryMode: TimePickerEntryMode.input,
                              cancelText: 'Batal',
                              confirmText: 'Simpan',
                              builder: (context, child) {
                                return MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(alwaysUse24HourFormat: true),
                                  child: Theme(
                                    data: ThemeData(
                                      colorScheme: ColorScheme.light(
                                        primary: Constanst.onPrimary,
                                      ),
                                      // useMaterial3: settings.useMaterial3,
                                      dialogTheme: const DialogTheme(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(16)))),
                                      primaryColor: Constanst.fgPrimary,
                                      textTheme: TextTheme(
                                        titleMedium: GoogleFonts.inter(
                                          color: Constanst.fgPrimary,
                                        ),
                                      ),
                                      dialogBackgroundColor:
                                          Constanst.colorWhite,
                                      canvasColor: Colors.white,
                                      hintColor: Constanst.onPrimary,
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          foregroundColor: Constanst.onPrimary,
                                        ),
                                      ),
                                    ),
                                    child: child!,
                                  ),
                                );
                              },
                            ).then((value) {
                              if (value == null) {
                                UtilsAlert.showToast('gagal pilih jam');
                              } else {
                                var convertJam = value.hour <= 9
                                    ? "0${value.hour}"
                                    : "${value.hour}";
                                var convertMenit = value.minute <= 9
                                    ? "0${value.minute}"
                                    : "${value.minute}";
                                absenController.checkinAjuan2.value =
                                    "$convertJam:$convertMenit";
                                absenController.isChecked.value = true;
                                // this.controller.dariJam.refresh();
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                16.0, 16.0, 0.0, 16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 16.0,
                                  width: 16.0,
                                  child: Checkbox(
                                    value: absenController.isChecked.value,
                                    checkColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    onChanged: (value) {
                                      setState(() {
                                        absenController.checkinAjuan2.value =
                                            "";
                                        absenController.placeCoordinateCheckin
                                            .clear();
                                        absenController
                                            .getPlaceCoordinateCheckin();
                                        absenController.isChecked.value = false;
                                      });
                                    },
                                    activeColor: Constanst.onPrimary,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextLabell(
                                        text: "Absen Masuk *",
                                        color: Constanst.fgPrimary,
                                        size: 14,
                                        weight: FontWeight.w400,
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextLabell(
                                            text: absenController
                                                        .checkinAjuan2.value ==
                                                    ""
                                                ? "_ _ : _ _"
                                                : absenController
                                                    .checkinAjuan2.value,
                                            color: Constanst.fgPrimary,
                                            weight: FontWeight.w500,
                                            size: 16,
                                          ),
                                          Icon(Iconsax.arrow_down_1,
                                              size: 20,
                                              color: Constanst.fgPrimary),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        customBorder: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(16))),
                        onTap: () {
                          if (absenController.tglAjunan.value != "") {
                            bottomSheetPengajuanAbsen();
                            return;
                          }
                          UtilsAlert.showToast(
                              "Pilih terlebih dahulu tanggal absensi");
                        },
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Iconsax.location_tick),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextLabell(
                                      text: "Lokasi*",
                                      color: Constanst.fgPrimary,
                                      size: 14,
                                      weight: FontWeight.w400,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: TextLabell(
                                            text: absenController
                                                    .placeCoordinateCheckin
                                                    .where((p0) =>
                                                        p0['is_selected'] ==
                                                        true)
                                                    .toList()
                                                    .isNotEmpty
                                                ? absenController
                                                    .placeCoordinateCheckin
                                                    .where((p0) =>
                                                        p0['is_selected'] ==
                                                        true)
                                                    .toList()[0]['place']
                                                : "-",
                                            color: Constanst.fgPrimary,
                                            weight: FontWeight.w500,
                                            size: 16,
                                          ),
                                        ),
                                        Icon(Iconsax.arrow_down_1,
                                            size: 20,
                                            color: Constanst.fgPrimary),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Divider(
                            height: 0,
                            thickness: 1,
                            color: Constanst.fgBorder,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          height: 0,
                          thickness: 1,
                          color: Constanst.fgBorder,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: InkWell(
                          onTap: () {
                            showTimePicker(
                              context: Get.context!,
                              initialTime: TimeOfDay.now(),
                              // initialEntryMode: TimePickerEntryMode.input,
                              cancelText: 'Batal',
                              confirmText: 'Simpan',
                              builder: (context, child) {
                                return MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(alwaysUse24HourFormat: true),
                                  child: Theme(
                                    data: ThemeData(
                                      colorScheme: ColorScheme.light(
                                        primary: Constanst.onPrimary,
                                      ),
                                      // useMaterial3: settings.useMaterial3,
                                      dialogTheme: const DialogTheme(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(16)))),
                                      primaryColor: Constanst.fgPrimary,
                                      textTheme: TextTheme(
                                        titleMedium: GoogleFonts.inter(
                                          color: Constanst.fgPrimary,
                                        ),
                                      ),
                                      dialogBackgroundColor:
                                          Constanst.colorWhite,
                                      canvasColor: Colors.white,
                                      hintColor: Constanst.onPrimary,
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          foregroundColor: Constanst.onPrimary,
                                        ),
                                      ),
                                    ),
                                    child: child!,
                                  ),
                                );
                              },
                            ).then((value) {
                              if (value == null) {
                                UtilsAlert.showToast('gagal pilih jam');
                              } else {
                                var convertJam = value.hour <= 9
                                    ? "0${value.hour}"
                                    : "${value.hour}";
                                var convertMenit = value.minute <= 9
                                    ? "0${value.minute}"
                                    : "${value.minute}";
                                absenController.checkoutAjuan2.value =
                                    "$convertJam:$convertMenit";
                                absenController.isChecked2.value = true;
                                // var convertJam = value.hour <= 9
                                //     ? "0${value.hour}"
                                //     : "${value.hour}";
                                // var convertMenit = value.minute <= 9
                                //     ? "0${value.minute}"
                                //     : "${value.minute}";
                                // controller.dariJam.value.text =
                                //     "$convertJam:$convertMenit";
                                // this.controller.dariJam.refresh();
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                16.0, 16.0, 0.0, 16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 16.0,
                                  width: 16.0,
                                  child: Checkbox(
                                    value: absenController.isChecked2.value,
                                    checkColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    onChanged: (value) {
                                      setState(() {
                                        absenController.checkoutAjuan2.value =
                                            "";
                                        absenController.placeCoordinateCheckout
                                            .clear();
                                        absenController
                                            .getPlaceCoordinateCheckout();
                                        absenController.isChecked2.value =
                                            false;
                                      });
                                    },
                                    activeColor: Constanst.onPrimary,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextLabell(
                                        text: "Absen Keluar",
                                        color: Constanst.fgPrimary,
                                        size: 14,
                                        weight: FontWeight.w400,
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextLabell(
                                            text: absenController
                                                        .checkoutAjuan2.value ==
                                                    ""
                                                ? "_ _ : _ _"
                                                : absenController
                                                    .checkoutAjuan2.value,
                                            color: Constanst.fgPrimary,
                                            weight: FontWeight.w500,
                                            size: 16,
                                          ),
                                          Icon(Iconsax.arrow_down_1,
                                              size: 20,
                                              color: Constanst.fgPrimary),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (absenController.tglAjunan.value != "") {
                            bottomSheetLokasiCheckout();
                            return;
                          }
                          UtilsAlert.showToast(
                              "Pilih terlebih dahulu tanggal absensi");
                        },
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Iconsax.location_tick),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextLabell(
                                      text: "Lokasi",
                                      color: Constanst.fgPrimary,
                                      size: 14,
                                      weight: FontWeight.w400,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: TextLabell(
                                            text: absenController
                                                    .placeCoordinateCheckout
                                                    .where((p0) =>
                                                        p0['is_selected'] ==
                                                        true)
                                                    .toList()
                                                    .isNotEmpty
                                                ? absenController
                                                    .placeCoordinateCheckout
                                                    .where((p0) =>
                                                        p0['is_selected'] ==
                                                        true)
                                                    .toList()[0]['place']
                                                : "-",
                                            color: Constanst.fgPrimary,
                                            weight: FontWeight.w500,
                                            size: 16,
                                          ),
                                        ),
                                        Icon(Iconsax.arrow_down_1,
                                            size: 20,
                                            color: Constanst.fgPrimary),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Divider(
                            height: 0,
                            thickness: 1,
                            color: Constanst.fgBorder,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          height: 0,
                          thickness: 1,
                          color: Constanst.fgBorder,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    absenController.takeFile();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Iconsax.document_upload,
                          size: 24,
                          color: Constanst.fgPrimary,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextLabell(
                              text: "Unggah File",
                              color: Constanst.fgPrimary,
                              weight: FontWeight.w400,
                              size: 14,
                            ),
                            const SizedBox(height: 4),
                            TextLabell(
                              text: "Ukuran File  5 MB",
                              color: Constanst.fgSecondary,
                              weight: FontWeight.w500,
                              size: 16,
                            ),
                            const SizedBox(height: 16),
                            InkWell(
                              customBorder: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              onTap: () {
                                absenController.takeFile();
                              },
                              child: Obx(
                                  () => absenController.imageAjuan.value == ""
                                      ? Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  width: 1,
                                                  color: Constanst.fgBorder)),
                                          padding: const EdgeInsets.all(2),
                                          child: Icon(
                                            Iconsax.add,
                                            color: Constanst.fgSecondary,
                                          ),
                                        )
                                      : TextLabell(
                                          text:
                                              absenController.imageAjuan.value,
                                          color: Constanst.onPrimary,
                                        )),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Divider(
                    height: 0,
                    thickness: 1,
                    color: Constanst.fgBorder,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Iconsax.textalign_justifyleft, size: 24),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextLabell(
                            text: "Catatan *",
                            color: Constanst.fgPrimary,
                            size: 14,
                            weight: FontWeight.w400,
                          ),
                          TextFormField(
                            controller: absenController.catataanAjuan,
                            decoration: const InputDecoration(
                              hintText: 'Tulis catatan disini',
                              border: InputBorder.none,
                            ),
                            style: GoogleFonts.inter(
                                color: Constanst.fgPrimary,
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                          )
                        ],
                      ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      absenController.imageAjuan.value = imageTemp.toString();

// setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      // print('Failed to pick image: $e');
    }
  }

  void bottomSheetPengajuanAbsen() {
    showModalBottomSheet(
      context: Get.context!,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Lokasi Absen Checkin",
                    style: GoogleFonts.inter(
                        color: Constanst.fgPrimary,
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                  ),
                  InkWell(
                      customBorder: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      onTap: () {
                        Navigator.pop(Get.context!);
                      },
                      child: Icon(
                        Icons.close,
                        opticalSize: 24,
                        color: Constanst.fgSecondary,
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Divider(
                thickness: 1,
                height: 0,
                color: Constanst.border,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Obx(() => ListView.builder(
                    itemCount: absenController.placeCoordinateCheckin.length,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      var data = absenController.placeCoordinateCheckin[index];
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              absenController.placeCoordinateCheckin
                                  .forEach((element) {
                                element['is_selected'] = false;
                              });

                              data['is_selected'] = true;
                              absenController.placeCoordinateCheckin.refresh();
                              Get.back();
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 16, 16, 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      absenController
                                          .placeCoordinateCheckin[index]
                                              ['place']
                                          .toString(),
                                      style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Constanst.fgPrimary)),
                                  data['is_selected'] == true
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
                                            absenController
                                                .placeCoordinateCheckin
                                                .forEach((element) {
                                              element['is_selected'] = false;
                                            });

                                            data['is_selected'] = true;
                                            absenController
                                                .placeCoordinateCheckin
                                                .refresh();
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
                          ),
                        ],
                      );
                    })),
              ),
            ),
          ],
        );
      },
    );
  }

  void bottomSheetLokasiCheckout() {
    showModalBottomSheet(
      context: Get.context!,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Lokasi Absen Checkout",
                    style: GoogleFonts.inter(
                        color: Constanst.fgPrimary,
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                  ),
                  InkWell(
                      customBorder: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      onTap: () {
                        Navigator.pop(Get.context!);
                      },
                      child: Icon(
                        Icons.close,
                        opticalSize: 24,
                        color: Constanst.fgSecondary,
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Divider(
                thickness: 1,
                height: 0,
                color: Constanst.border,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Obx(() => ListView.builder(
                    itemCount: absenController.placeCoordinateCheckout.length,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      var data = absenController.placeCoordinateCheckout[index];
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              absenController.placeCoordinateCheckout
                                  .forEach((element) {
                                element['is_selected'] = false;
                              });

                              data['is_selected'] = true;
                              absenController.placeCoordinateCheckout.refresh();
                              Get.back();
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 16, 16, 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      absenController
                                          .placeCoordinateCheckout[index]
                                              ['place']
                                          .toString(),
                                      style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Constanst.fgPrimary)),
                                  data['is_selected'] == true
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
                                            absenController
                                                .placeCoordinateCheckout
                                                .forEach((element) {
                                              element['is_selected'] = false;
                                            });

                                            data['is_selected'] = true;
                                            absenController
                                                .placeCoordinateCheckout
                                                .refresh();
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
                          ),
                        ],
                      );
                    })),
              ),
            ),
          ],
        );
      },
    );
  }
}
