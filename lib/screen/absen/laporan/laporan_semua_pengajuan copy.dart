import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/laporan_tidakHadir_controller.dart';
import 'package:siscom_operasional/controller/tidak_masuk_kerja_controller.dart';
import 'package:siscom_operasional/screen/absen/laporan/laporan_semua_pengajuan_detail.dart';
import 'package:siscom_operasional/utils/appbar_widget.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/month_year_picker.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';

class LaporanTidakMasuk extends StatefulWidget {
  String title;
  LaporanTidakMasuk({Key? key, required this.title}) : super(key: key);
  @override
  _LaporanTidakMasukState createState() => _LaporanTidakMasukState();
}

class _LaporanTidakMasukState extends State<LaporanTidakMasuk> {
  var controller = Get.put(LaporanTidakHadirController());

  @override
  void initState() {
    controller.getDepartemen(1, "");
    controller.title.value = widget.title;
    super.initState();
  }

  Future<void> refreshData() async {
    await Future.delayed(Duration(seconds: 2));
    controller.getDepartemen(1, "");
    controller.title.value = widget.title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constanst.coloBackgroundScreen,
        appBar: AppBar(
          backgroundColor: Constanst.colorWhite,
          elevation: 0,
          leadingWidth: 50,
          titleSpacing: 0,
          centerTitle: true,
          title: Obx(() {
            if (controller.isSearching.value) {
              return SizedBox(
                height: 40,
                child: TextFormField(
                  controller: controller.cari.value,
                  // onFieldSubmitted: (value) {
                  // controller.report();
                  // },
                  onChanged: (value) {
                    controller.pencarianNamaKaryawan(value);
                  },
                  textAlignVertical: TextAlignVertical.center,
                  style: GoogleFonts.inter(
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                      color: Constanst.fgPrimary,
                      fontSize: 15),
                  cursorColor: Constanst.onPrimary,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Constanst.colorNeutralBgSecondary,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      contentPadding:
                          const EdgeInsets.only(left: 20, right: 20),
                      hintText: "Cari nama karyawan...",
                      hintStyle: GoogleFonts.inter(
                          height: 1.5,
                          fontWeight: FontWeight.w400,
                          color: Constanst.fgSecondary,
                          fontSize: 14),
                      prefixIconConstraints:
                          BoxConstraints.tight(const Size(46, 46)),
                      suffixIconConstraints:
                          BoxConstraints.tight(const Size(46, 46)),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 8),
                        child: IconButton(
                          icon: Icon(
                            Iconsax.close_circle5,
                            color: Constanst.fgSecondary,
                            size: 24,
                          ),
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            controller.statusCari.value = false;
                            controller.cari.value.text = "";
                            controller.title.value = widget.title;
                            controller.getDepartemen(1, "");
                          },
                        ),
                      )),
                ),
              );
            } else {
              return Text(
                widget.title == "tidak_hadir"
                    ? "Laporan Tidak Hadir"
                    : widget.title == "cuti"
                        ? "Laporan Cuti"
                        : widget.title == "lembur"
                            ? "Laporan Lembur"
                            : widget.title == "tugas_luar"
                                ? "Laporan Tugas Luar"
                                : widget.title == "dinas_luar"
                                    ? "Laporan Dinas Luar"
                                    : widget.title == "klaim"
                                        ? "Laporan Klaim"
                                        : "",
                style: GoogleFonts.inter(
                    color: Constanst.fgPrimary,
                    fontWeight: FontWeight.w500,
                    fontSize: 20),
              );
            }
          }),
          actions: [
            Obx(
              () => controller.bulanDanTahunNow.value == ""
                  ? const SizedBox()
                  : controller.isSearching.value
                      ? Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Container(),
                        )
                      : IconButton(
                          icon: Icon(
                            Iconsax.search_normal_1,
                            color: Constanst.fgPrimary,
                            size: 24,
                          ),
                          onPressed: controller.toggleSearch,
                        ),
            ),
          ],
          leading: Obx(
            () => IconButton(
              icon: Icon(
                Iconsax.arrow_left,
                color: Constanst.fgPrimary,
                size: 24,
              ),
              onPressed: controller.isSearching.value
                  ? controller.toggleSearch
                  : Get.back,
              // onPressed: () {
              //   controller.cari.value.text = "";
              //   Get.back();
              // },
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
                  padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // controller.bulanDanTahunNow.value == ""
                      //     ? SizedBox()
                      //     : pencarianData(),
                      SizedBox(
                        height: 8,
                      ),
                      filterData(),
                      SizedBox(
                        height: 8,
                      ),
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 75,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    controller.selectedViewFilterPengajuan
                                                .value ==
                                            0
                                        ? Text(
                                            "${controller.namaDepartemenTerpilih.value}  (${Constanst.convertDateBulanDanTahun('${controller.bulanDanTahunNow}')})",
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          )
                                        : Text(
                                            "${controller.namaDepartemenTerpilih.value}  (${Constanst.convertDate('${DateFormat('yyyy-MM-dd').format(controller.pilihTanggalFilterAjuan.value)}')})",
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                    Text(
                                      "${controller.allNameLaporanTidakhadir.value.length} Data",
                                      style: GoogleFonts.inter(
                                          color: Constanst.colorText2,
                                          fontSize: 12),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 25,
                                child: InkWell(
                                  onTap: () {
                                    controller.pageViewFilterWaktu =
                                        PageController(
                                            initialPage: controller
                                                .selectedViewFilterPengajuan
                                                .value);
                                    controller.widgetButtomSheetFilterData();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: Constanst.borderStyle5,
                                        border: Border.all(
                                            color: Constanst.colorText2)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0,
                                          bottom: 8.0,
                                          left: 6.0,
                                          right: 6.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text("Filter"),
                                          Padding(
                                            padding: EdgeInsets.only(left: 6),
                                            child: Icon(Iconsax.setting_4),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Flexible(
                        child: RefreshIndicator(
                          onRefresh: refreshData,
                          child: controller.statusLoadingSubmitLaporan.value
                              ? Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    color: Constanst.colorPrimary,
                                  ),
                                )
                              : controller
                                      .allNameLaporanTidakhadir.value.isEmpty
                                  ? Center(
                                      child:
                                          Text(controller.loadingString.value),
                                    )
                                  : listPengajuanKaryawan(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )));
  }

  Widget filterData() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          filterWidget(
              text: controller.departemen.value.text,
              onTap: () {
                controller.showDataDepartemenAkses('semua');
              }),
          filterWidget(
              text: Constanst.convertDateBulanDanTahun(
                  controller.bulanDanTahunNow.value),
              onTap: () {
                controller.pageViewFilterWaktu = PageController(
                    initialPage: controller.selectedViewFilterPengajuan.value);

                controller.selectedViewFilterPengajuan.value = 0;
                // controller.pageViewFilterWaktu!.jumpToPage(0);
                this.controller.selectedViewFilterPengajuan.refresh();

                // controller.selectedViewFilterPengajuan.value = 1;
                // controller.pageViewFilterWaktu!.jumpToPage(1);
                // this.controller.selectedViewFilterPengajuan.refresh();

                DatePicker.showPicker(
                  Get.context!,
                  pickerModel: CustomMonthPicker(
                    minTime: DateTime(2000, 1, 1),
                    maxTime: DateTime(2100, 1, 1),
                    currentTime: DateTime.now(),
                  ),
                  onConfirm: (time) {
                    if (time != null) {
                      print("$time");
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
                      controller.statusFilterWaktu.value = 0;
                      // Navigator.pop(Get.context!);
                      controller.aksiCariLaporan();
                    }
                  },
                );

                // controller.widgetButtomSheetFilterData();
              }),
          filterWidget(
              text: Constanst.convertDate(
                  '${DateFormat('yyyy-MM-dd').format(controller.pilihTanggalFilterAjuan.value)}'),
              onTap: () {
                controller.pageViewFilterWaktu = PageController(
                    initialPage: controller.selectedViewFilterPengajuan.value);

                controller.selectedViewFilterPengajuan.value = 1;
                // controller.pageViewFilterWaktu!.jumpToPage(1);

                this.controller.selectedViewFilterPengajuan.refresh();
                DatePicker.showDatePicker(Get.context!,
                    showTitleActions: true,
                    minTime: DateTime(2000, 1, 1),
                    maxTime: DateTime(2100, 1, 1), onConfirm: (date) {
                  Navigator.pop(Get.context!);
                  controller.statusFilterWaktu.value = 1;
                  controller.pilihTanggalFilterAjuan.value = date;
                  this.controller.pilihTanggalFilterAjuan.refresh();
                  controller.cariLaporanPengajuanTanggal(
                      controller.pilihTanggalFilterAjuan.value);
                }, currentTime: DateTime.now(), locale: LocaleType.en);

                // controller.widgetButtomSheetFilterData();
              }),
          filterWidget(
              text: controller.departemen.value.text,
              onTap: () {
                controller.showDataDepartemenAkses('semua');
              }),
          filterWidget(
              text: controller.filterStatusAjuanTerpilih.value,
              onTap: () {
                if (controller.selectedViewFilterPengajuan.value == 1) {
                  controller.showDataStatusAjuan();
                }
              }),
        ],
      ),
    );
  }

  Widget filterWidget({text, onTap}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                // color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  color: Constanst.fgBorder, // Border color
                  width: 1, // Border width
                ),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
                    child: Row(
                      children: [
                        Text(
                          text,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: Constanst.fgPrimary),
                        ),
                        const SizedBox(width: 5),
                        Icon(
                          Iconsax.arrow_down_1,
                          size: 18,
                          color: Constanst.fgSecondary,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // void showBottomLimitPage(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(
  //         top: Radius.circular(16.0),
  //       ),
  //     ),
  //     builder: (BuildContext context) {
  //       return ClipRRect(
  //         borderRadius: BorderRadius.circular(16.0),
  //         child: SizedBox(
  //           height: MediaQuery.of(context).size.height * 0.47,
  //           child: Scaffold(
  //             backgroundColor: Constanst.colorWhite,
  //             appBar: PreferredSize(
  //               preferredSize: const Size.fromHeight(kToolbarHeight) * 1.35,
  //               child: Column(
  //                 children: [
  //                   const SizedBox(height: 12),
  //                   Center(
  //                     child: Container(
  //                       height: 6,
  //                       width: 120,
  //                       decoration: BoxDecoration(
  //                         color: Constanst.colorNeutralBgTertiary,
  //                         borderRadius: BorderRadius.circular(20),
  //                       ),
  //                     ),
  //                   ),
  //                   AppBar(
  //                     toolbarHeight: 48.0,
  //                     backgroundColor: Constanst.colorWhite,
  //                     title: Row(
  //                       children: [
  //                         Text(
  //                           "Pilih Tipe",
  //                           style: GoogleFonts.inter(
  //                               fontSize: 16,
  //                               color: Constanst.fgPrimary,
  //                               fontWeight: FontWeight.w500),
  //                         ),
  //                       ],
  //                     ),
  //                     leadingWidth: 0,
  //                     elevation: 0,
  //                   ),
  //                   Divider(
  //                     thickness: 1,
  //                     height: 1,
  //                     color: Constanst.fgBorder,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             body: Obx(
  //               () => SingleChildScrollView(
  //                 physics: const BouncingScrollPhysics(),
  //                 child: Column(
  //                   children: List.generate(
  //                       accountReceivableController.limitPages.length, (index) {
  //                     var data = accountReceivableController.limitPages[index];
  //                     return Column(
  //                       children: [
  //                         InkWell(
  //                           onTap: () {
  //                             accountReceivableController.tempKodeLimit1.value =
  //                                 data.kode;

  //                             accountReceivableController.tempNamaLimit1.value =
  //                                 data.nama;
  //                           },
  //                           child: Padding(
  //                             padding:
  //                                 const EdgeInsets.fromLTRB(16, 16, 16, 16),
  //                             child: Row(
  //                               mainAxisAlignment:
  //                                   MainAxisAlignment.spaceBetween,
  //                               children: [
  //                                 TextLabel(
  //                                     text: data.nama,
  //                                     color: ColorsApp.colorNeutralFgPrimary,
  //                                     size: 14.0,
  //                                     weight: FontWeight.w500),
  //                                 accountReceivableController
  //                                             .tempKodeLimit1.value ==
  //                                         data.kode
  //                                     ? InkWell(
  //                                         onTap: () {},
  //                                         child: Container(
  //                                           height: 20,
  //                                           width: 20,
  //                                           decoration: BoxDecoration(
  //                                               border: Border.all(
  //                                                   width: 2,
  //                                                   color: ColorsApp
  //                                                       .colorBrandPrimary),
  //                                               borderRadius:
  //                                                   BorderRadius.circular(10)),
  //                                           child: Padding(
  //                                             padding: const EdgeInsets.all(3),
  //                                             child: Container(
  //                                               decoration: BoxDecoration(
  //                                                   color: ColorsApp
  //                                                       .colorBrandPrimary,
  //                                                   borderRadius:
  //                                                       BorderRadius.circular(
  //                                                           10)),
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       )
  //                                     : InkWell(
  //                                         onTap: () {
  //                                           accountReceivableController
  //                                               .tempKodeLimit1
  //                                               .value = data.kode;

  //                                           accountReceivableController
  //                                               .tempNamaLimit1
  //                                               .value = data.nama;
  //                                         },
  //                                         child: Container(
  //                                           height: 20,
  //                                           width: 20,
  //                                           decoration: BoxDecoration(
  //                                               border: Border.all(
  //                                                   width: 1,
  //                                                   color: ColorsApp
  //                                                       .colorNeutralBorderSecondary),
  //                                               borderRadius:
  //                                                   BorderRadius.circular(10)),
  //                                           child: Padding(
  //                                             padding: const EdgeInsets.all(2),
  //                                             child: Container(
  //                                               decoration: BoxDecoration(
  //                                                   borderRadius:
  //                                                       BorderRadius.circular(
  //                                                           10)),
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       )
  //                               ],
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     );
  //                   }),
  //                 ),
  //               ),
  //             ),
  //             bottomNavigationBar: Padding(
  //               padding: const EdgeInsets.all(16.0),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Expanded(
  //                     child: Container(
  //                       height: 40,
  //                       padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
  //                       margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
  //                       decoration: BoxDecoration(
  //                         border: Border.all(
  //                           color: ColorsApp
  //                               .colorNeutralBorderPrimary, // Set the desired border color
  //                           width: 1.0,
  //                         ),
  //                         borderRadius: BorderRadius.circular(8.0),
  //                       ),
  //                       child: ElevatedButton(
  //                         onPressed: () {
  //                           Get.back();
  //                         },
  //                         style: ElevatedButton.styleFrom(
  //                             foregroundColor: ColorsApp.colorBrandPrimary,
  //                             backgroundColor: ColorsApp.colorBrandOnPrimary,
  //                             shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(8),
  //                             ),
  //                             elevation: 0,
  //                             // padding: EdgeInsets.zero,
  //                             padding: const EdgeInsets.fromLTRB(0, 0, 0, 0)),
  //                         child: const Text(
  //                           'Batal',
  //                           style: GoogleFonts.inter(
  //                               fontFamily: FontsApp.interMedium,
  //                               fontWeight: FontWeight.w500,
  //                               color: ColorsApp.colorBrandPrimary,
  //                               fontSize: 14),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(width: 8),
  //                   Expanded(
  //                     child: SizedBox(
  //                       height: 40,
  //                       child: ElevatedButton(
  //                         onPressed: () {
  //                           Get.back();

  //                           accountReceivableController.tempNamaLimit2.value =
  //                               accountReceivableController
  //                                   .tempNamaLimit1.value;
  //                           accountReceivableController.tempKodeLimit2.value =
  //                               accountReceivableController
  //                                   .tempKodeLimit1.value;

  //                           accountReceivableController.offset.value = 0;

  //                           accountReceivableController.report();
  //                         },
  //                         style: ElevatedButton.styleFrom(
  //                           foregroundColor: ColorsApp.colorBrandOnPrimary,
  //                           backgroundColor: ColorsApp.colorBrandPrimary,
  //                           shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(8),
  //                           ),
  //                           elevation: 0,
  //                           // padding: const EdgeInsets.fromLTRB(20, 12, 20, 12)
  //                         ),
  //                         child: const Text(
  //                           'Terapkan',
  //                           style: GoogleFonts.inter(
  //                               fontFamily: FontsApp.interMedium,
  //                               fontWeight: FontWeight.w500,
  //                               color: ColorsApp.colorBrandOnPrimary,
  //                               fontSize: 14),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   ).then((value) {
  //     accountReceivableController.tempKodeLimit1.value =
  //         accountReceivableController.tempKodeLimit2.value;
  //     accountReceivableController.tempNamaLimit1.value =
  //         accountReceivableController.tempNamaLimit2.value;
  //   });
  // }

  // Widget pencarianData() {
  //   return Container(
  //     decoration: BoxDecoration(
  //         borderRadius: Constanst.borderStyle5,
  //         border: Border.all(color: Constanst.colorText2)),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       children: [
  //         Expanded(
  //           flex: 15,
  //           child: Padding(
  //             padding: const EdgeInsets.only(top: 7, left: 10),
  //             child: Icon(Iconsax.search_normal_1),
  //           ),
  //         ),
  //         Expanded(
  //           flex: 85,
  //           child: Padding(
  //             padding: const EdgeInsets.only(left: 10),
  //             child: SizedBox(
  //               height: 40,
  //               child: Row(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Expanded(
  //                     flex: 85,
  //                     child: TextField(
  //                       controller: controller.cari.value,
  //                       decoration: InputDecoration(
  //                           border: InputBorder.none,
  //                           hintText: "Cari Nama Karyawan"),
  //                       style: GoogleFonts.inter(
  //                           fontSize: 14.0, height: 1.0, color: Colors.black),
  //                       onChanged: (value) {
  //                         controller.pencarianNamaKaryawan(value);
  //                       },
  //                     ),
  //                   ),
  //                   !controller.statusCari.value
  //                       ? SizedBox()
  //                       : Expanded(
  //                           flex: 15,
  //                           child: IconButton(
  //                             icon: Icon(
  //                               Iconsax.close_circle,
  //                               color: Colors.red,
  //                             ),
  //                             onPressed: () {
  //                               controller.statusCari.value = false;
  //                               controller.cari.value.text = "";
  //                               controller.title.value = widget.title;
  //                               controller.getDepartemen(1, "");
  //                             },
  //                           ),
  //                         )
  //                 ],
  //               ),
  //             ),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  Widget listPengajuanKaryawan() {
    return ListView.builder(
        physics: controller.allNameLaporanTidakhadir.value.length <= 15
            ? AlwaysScrollableScrollPhysics()
            : BouncingScrollPhysics(),
        itemCount: controller.allNameLaporanTidakhadir.value.length,
        itemBuilder: (context, index) {
          var fullName = controller.allNameLaporanTidakhadir.value[index]
                  ['full_name'] ??
              "";
          var namaKaryawan = "$fullName";
          var jobTitle =
              controller.allNameLaporanTidakhadir.value[index]['job_title'];
          var emId = controller.allNameLaporanTidakhadir.value[index]['em_id'];
          var statusAjuan;
          if (widget.title == "lembur" ||
              widget.title == "tugas_luar" ||
              widget.title == "klaim") {
            var tampung =
                controller.allNameLaporanTidakhadir.value[index]['status'];
            statusAjuan = tampung == "Approve"
                ? "Approve 1"
                : tampung == "Approve2"
                    ? "Approve 2"
                    : tampung;
          } else {
            var tampung = controller.allNameLaporanTidakhadir.value[index]
                ['leave_status'];
            statusAjuan = tampung == "Approve"
                ? "Approve 1"
                : tampung == "Approve2"
                    ? "Approve 2"
                    : tampung;
          }

          var jumlahPengajuan = controller.allNameLaporanTidakhadir.value[index]
              ['jumlah_pengajuan'];

          return InkWell(
            onTap: () {
              Get.to(LaporanDetailTidakHadir(
                emId: emId,
                bulan: controller.bulanSelectedSearchHistory.value,
                tahun: controller.tahunSelectedSearchHistory.value,
                full_name: namaKaryawan,
                title: widget.title,
              ));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              namaKaryawan,
                              style: GoogleFonts.inter(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              jobTitle,
                              style: GoogleFonts.inter(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 40,
                        child: Center(
                          child: controller.statusFilterWaktu.value == 0
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "$jumlahPengajuan Pengajuan",
                                      style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: Constanst.colorText2),
                                    ),
                                    Text(
                                      "${Constanst.convertDateBulanDanTahun('${controller.bulanDanTahunNow.value}')}",
                                      style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: Constanst.colorText2),
                                    ),
                                  ],
                                )
                              : Padding(
                                  padding: EdgeInsets.only(
                                      left: 3, right: 3, top: 5, bottom: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      statusAjuan == 'Approve'
                                          ? Icon(
                                              Iconsax.tick_square,
                                              color: Constanst.color5,
                                              size: 14,
                                            )
                                          : statusAjuan == 'Approve 1'
                                              ? Icon(
                                                  Iconsax.tick_square,
                                                  color: Constanst.color5,
                                                  size: 14,
                                                )
                                              : statusAjuan == 'Approve 2'
                                                  ? Icon(
                                                      Iconsax.tick_square,
                                                      color: Constanst.color5,
                                                      size: 14,
                                                    )
                                                  : statusAjuan == 'Rejected'
                                                      ? Icon(
                                                          Iconsax.close_square,
                                                          color:
                                                              Constanst.color4,
                                                          size: 14,
                                                        )
                                                      : statusAjuan == 'Pending'
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
                                          '$statusAjuan',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.bold,
                                              color: statusAjuan == 'Approve'
                                                  ? Colors.green
                                                  : statusAjuan == 'Approve 1'
                                                      ? Colors.green
                                                      : statusAjuan ==
                                                              'Approve 2'
                                                          ? Colors.green
                                                          : statusAjuan ==
                                                                  'Rejected'
                                                              ? Colors.red
                                                              : statusAjuan ==
                                                                      'Pending'
                                                                  ? Constanst
                                                                      .color3
                                                                  : Colors
                                                                      .black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        child: Center(
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Divider(
                  height: 3,
                  color: Colors.grey,
                ),
              ],
            ),
          );
        });
  }

  Widget textSubmit() {
    return controller.statusLoadingSubmitLaporan.value == false
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Iconsax.search_normal_1,
                size: 18,
                color: Constanst.colorWhite,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Submit Data",
                  style: GoogleFonts.inter(color: Constanst.colorWhite),
                ),
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Center(
                  child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.white,
                      )),
                ),
              )
            ],
          );
  }
}
