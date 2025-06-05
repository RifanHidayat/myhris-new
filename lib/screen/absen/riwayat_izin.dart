import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/dashboard_controller.dart';
import 'package:siscom_operasional/controller/global_controller.dart';
import 'package:siscom_operasional/controller/izin_controller.dart';
import 'package:siscom_operasional/screen/absen/form/form_pengajuan_izin.dart';
import 'package:siscom_operasional/screen/absen/laporan/laporan_izin.dart';
import 'package:siscom_operasional/screen/init_screen.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/month_year_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RiwayatIzin extends StatefulWidget {
  @override
  _RiwayatIzinState createState() => _RiwayatIzinState();
}

class _RiwayatIzinState extends State<RiwayatIzin> {
  var controller = Get.put(IzinController());
  var controllerGlobal = Get.find<GlobalController>();
  final dashboardController = Get.put(DashboardController());
  var idx = 0;

  @override
  void initState() {
    super.initState();

    controller.tempNamaTipe1.value == "Semua Tipe";
    controller.loadDataAjuanIzin();
    controller.loadTypeSakit();
    // controller.changeTypeSelected(2);
    if (Get.arguments != null) {
      idx = Get.arguments;
      Future.delayed(const Duration(milliseconds: 500), () {
        if (controller.listHistoryAjuan.isNotEmpty) {
          for (var item in controller.listHistoryAjuan.value) {
            if (item['id'] == idx) {
              var alasanReject = item['alasan_reject'] ?? "";
              var approve_by;
              if (item['apply2_by'] == "" ||
                  item['apply2_by'] == "null" ||
                  item['apply2_by'] == null) {
                approve_by = item['apply_by'];
              } else {
                approve_by = item['apply2_by'];
              }
              controller.showDetailRiwayat(item, approve_by, alasanReject);
            }
          }
        }
      });
    }
  }

  Future<void> refreshData() async {
    await Future.delayed(Duration(seconds: 2));
    controller.loadDataAjuanIzin();
    controller.selectedType.value = 0;
    this.controller.selectedType.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constanst.coloBackgroundScreen,
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
              centerTitle: false,
              title: controller.statusFormPencarian.value
                  ? SizedBox(
                      height: 40,
                      child: TextFormField(
                        // controller: controller.searchController,
                        controller: controller.cari.value,
                        onFieldSubmitted: (value) {
                          controller.cariData(value);
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
                            hintText: "Cari data...",
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
                              padding:
                                  const EdgeInsets.only(left: 16.0, right: 8),
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
                                  controller.loadDataAjuanIzin();
                                },
                              ),
                            )),
                      ),
                    )

                    
                  : Text(
                      "Riwayat Izin",
                      style: GoogleFonts.inter(
                          color: Constanst.fgPrimary,
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),
              actions: [
                controller.statusFormPencarian.value
                    ? Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Container(),
                      )
                    : Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                right: dashboardController.showLaporan.value ==
                                        false
                                    ? 16.0
                                    : 0),
                            child: SizedBox(
                              width: 25,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  Iconsax.search_normal_1,
                                  color: Constanst.fgPrimary,
                                  size: 24,
                                ),
                                onPressed: controller.showInputCari,
                                // controller.toggleSearch,
                              ),
                            ),
                          ),
                          dashboardController.showLaporan.value == false
                              ? const SizedBox()
                              : Obx(
                                  () => controller.showButtonlaporan.value ==
                                          false
                                      ? const SizedBox()
                                      : IconButton(
                                          padding: EdgeInsets.zero,
                                          icon: Icon(
                                            Iconsax.document_text,
                                            color: Constanst.fgPrimary,
                                            size: 24,
                                          ),
                                          onPressed: () => Get.to(LaporanIzin(
                                            title: 'tidak_hadir',
                                          )),
                                          // controller.toggleSearch,
                                        ),
                                ),
                        ],
                      ),
              ],
              leading: controller.statusFormPencarian.value
                  ? IconButton(
                      icon: Icon(
                        Iconsax.arrow_left,
                        color: Constanst.fgPrimary,
                        size: 24,
                      ),
                      onPressed: controller.showInputCari,
                      // onPressed: () {
                      //   controller.cari.value.text = "";
                      //   Get.back();
                      // },
                    )
                  : IconButton(
                      icon: Icon(
                        Iconsax.arrow_left,
                        color: Constanst.fgPrimary,
                        size: 24,
                      ),
                      onPressed: () {
                        controller.cari.value.clear();
                        controller.onClose();
                        // Get.offAll(InitScreen());
                        Get.back();
                      },
                      // onPressed: () {
                      //   controller.cari.value.text = "";
                      //   Get.back();
                      // },
                    ),
            ),
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          controller.cari.value.clear();
          controller.onClose();
          Get.back();
          return true;
        },
        child: Obx(
          () => controller.bulanDanTahunNow.value == ''
              ? Center(
                  child: Text(controller.loadingString.value),
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // controller.bulanDanTahunNow.value == ""
                      //     ? const SizedBox()
                      //     :
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // pickDate(),
                            const SizedBox(width: 4),
                            status(),
                            const SizedBox(width: 4),
                            tipe(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Flexible(
                        child: RefreshIndicator(
                            color: Constanst.colorPrimary,
                            onRefresh: refreshData,
                            child: controller.listHistoryAjuan.value.isEmpty
                                ? Center(
                                    child: SafeArea(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          controller.loadingString.value ==
                                                  "Memuat Data..."
                                              ? Container()
                                              : SvgPicture.asset(
                                                  'assets/empty_screen.svg',
                                                  height: 228,
                                                ),
                                          const SizedBox(height: 16),
                                          Text(
                                            controller.loadingString.value,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: Constanst.fgPrimary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : listAjuanIzin()),
                      )
                    ],
                  ),
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
      //                 child: Icon(Iconsax.minus_cirlce),
      //                 backgroundColor: Color(0xff2F80ED),
      //                 foregroundColor: Colors.white,
      //                 label: 'Laporan Tidak Hadir',
      //                 onTap: () {
      //                   Get.to(LaporanIzin(
      //                     title: 'tidak_hadir',
      //                   ));
      //                 }),
      //             SpeedDialChild(
      //                 child: Icon(Iconsax.add_square),
      //                 backgroundColor: Color(0xff14B156),
      //                 foregroundColor: Colors.white,
      //                 label: 'Buat Pengajuan Tidak Hadir',
      //                 onTap: () {
      //                   controller
      //                       .changeTypeSelected(controller.selectedType.value);
      //                   Get.to(FormPengajuanIzin(
      //                     dataForm: [[], false],
      //                   ));
      //                 }),
      //           ],
      //         ),
      // ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Constanst.colorPrimary,
        onPressed: () {
           controller.changeTypeSelected(controller.selectedType.value);
          Get.to(FormPengajuanIzin(
            dataForm: [[], false],
          ));
        },
        child: const Icon(
          Iconsax.add,
          size: 34,
        ),
      ),
      // bottomNavigationBar: Obx(
      //   () => Padding(
      //       padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 12),
      //       child: controller.showButtonlaporan.value == true
      //           ? SizedBox()
      //           : TextButtonWidget2(
      //               title: "Buat Pengajuan Tidak Hadir",
      //               onTap: () {
      //                 Get.to(FormPengajuanIzin(
      //                   dataForm: [[], false],
      //                 ));
      //               },
      //               colorButton: Constanst.colorPrimary,
      //               colortext: Constanst.colorWhite,
      //               border: BorderRadius.circular(20.0),
      //               icon: Icon(
      //                 Iconsax.add,
      //                 color: Constanst.colorWhite,
      //               ))),
      // ),
    );
  }

  String getMonthName(int monthNumber) {
    // Menggunakan pustaka intl untuk mengonversi angka bulan menjadi teks
    final monthFormat = DateFormat.MMMM('id');
    DateTime date = DateTime(2000, monthNumber,
        1); // Tahun dan hari bebas, yang penting bulan sesuai
    return monthFormat.format(date);
  }

  // Widget pickDate() {
  //   return Container(
  //     decoration: BoxDecoration(
  //         borderRadius: const BorderRadius.all(Radius.circular(100)),
  //         border: Border.all(color: Constanst.fgBorder)),
  //     child: InkWell(
  //       customBorder: const RoundedRectangleBorder(
  //           borderRadius: BorderRadius.all(Radius.circular(100))),
  //       onTap: () {
  //         DatePicker.showPicker(
  //           Get.context!,
  //           pickerModel: CustomMonthPicker(
  //             minTime: DateTime(2020, 1, 1),
  //             maxTime: DateTime(2050, 1, 1),
  //             currentTime: DateTime.parse(
  //                 "${controller.tahunSelectedSearchHistory.value}-${controller.bulanSelectedSearchHistory.value}-01"),
  //           ),
  //           onConfirm: (time) {
  //             if (time != null) {
  //               print("$time");
  //               var filter = DateFormat('yyyy-MM').format(time);
  //               var array = filter.split('-');
  //               var bulan = array[1];
  //               var tahun = array[0];
  //               controller.bulanSelectedSearchHistory.value = bulan;
  //               controller.tahunSelectedSearchHistory.value = tahun;
  //               controller.bulanDanTahunNow.value = "$bulan-$tahun";
  //               controller.loadDataAjuanIzin();
  //               this.controller.bulanSelectedSearchHistory.refresh();
  //               this.controller.tahunSelectedSearchHistory.refresh();
  //               this.controller.bulanDanTahunNow.refresh();
  //             }
  //           },
  //         );
  //       },
  //       child: Padding(
  //         padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
  //         child: Row(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               "${getMonthName(int.parse(controller.bulanSelectedSearchHistory.value))} ${controller.tahunSelectedSearchHistory.value}",
  //               style: GoogleFonts.inter(
  //                 fontWeight: FontWeight.w500,
  //                 fontSize: 14,
  //                 color: Constanst.fgSecondary,
  //               ),
  //             ),
  //             const SizedBox(width: 4),
  //             Icon(
  //               Iconsax.arrow_down_1,
  //               size: 18,
  //               color: Constanst.fgSecondary,
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget listTypeTidakMasuk() {
  //   return SizedBox(
  //     width: MediaQuery.of(Get.context!).size.width,
  //     height: 50,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Expanded(
  //           child: InkWell(
  //             onTap: () => controller.changeTypeSelected(0),
  //             child: Center(
  //                 child: Text(
  //               "SEHARI PENUH",
  //               style: TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 16,
  //                   color: controller.selectedType.value == 0
  //                       ? Constanst.colorPrimary
  //                       : Constanst.colorText2),
  //             )),
  //           ),
  //         ),
  //         Expanded(
  //           child: InkWell(
  //             onTap: () => controller.changeTypeSelected(1),
  //             child: Center(
  //                 child: Text(
  //               "SETENGAH HARI",
  //               style: TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 16,
  //                   color: controller.selectedType.value == 1
  //                       ? Constanst.colorPrimary
  //                       : Constanst.colorText2),
  //             )),
  //           ),
  //         ),
  //         Expanded(
  //           child: InkWell(
  //             onTap: () => controller.changeTypeSelected(2),
  //             child: Center(
  //                 child: Text(
  //               "HARI",
  //               style: TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 16,
  //                   color: controller.selectedType.value == 1
  //                       ? Constanst.colorPrimary
  //                       : Constanst.colorText2),
  //             )),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget status() {
    return Container(
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
              Text(
                controller.tempNamaStatus1.value,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Constanst.fgSecondary,
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
    );
  }

  void showBottomStatus(BuildContext context) {
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
                              controller.changeTypeAjuan(controller
                                  .dataTypeAjuan.value[index]['nama']);

                              controller.tempNamaStatus1.value = namaType;
                              Get.back();
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const SizedBox(width: 16),
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
                                  controller.tempNamaStatus1.value == namaType
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
    });
  }

  Widget tipe() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          border: Border.all(color: Constanst.fgBorder)),
      child: InkWell(
        customBorder: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(100))),
        onTap: () {
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
                              "Pilih Tipe Izin",
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
                      InkWell(
                        onTap: () {
                          controller.tempNamaTipe1.value = "Semua Tipe";
                          Get.back();
                          controller.changeTypeSelected(2);
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const SizedBox(width: 16),
                                  Text(
                                    "Semua Tipe",
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Constanst.fgPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              controller.tempNamaTipe1.value == "Semua Tipe"
                                  ? Container(
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
                                                  BorderRadius.circular(10)),
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        controller.tempNamaTipe1.value =
                                            "Semua Tipe";
                                        Get.back();
                                        controller.changeTypeSelected(2);
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
                                                    BorderRadius.circular(10)),
                                          ),
                                        ),
                                      ),
                                    )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          controller.tempNamaTipe1.value = "FULLDAY";
                          Get.back();
                          controller.changeTypeSelected(0);
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const SizedBox(width: 16),
                                  Text(
                                    "Sehari Penuh / Fullday",
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Constanst.fgPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              controller.tempNamaTipe1.value == "FULLDAY"
                                  ? Container(
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
                                                  BorderRadius.circular(10)),
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        controller.tempNamaTipe1.value =
                                            "FULLDAY";
                                        Get.back();
                                        controller.changeTypeSelected(0);
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
                                                    BorderRadius.circular(10)),
                                          ),
                                        ),
                                      ),
                                    )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          controller.tempNamaTipe1.value = "HALFDAY";
                          Get.back();
                          controller.changeTypeSelected(1);
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const SizedBox(width: 16),
                                  Text(
                                    "Setengah Hari / Halfday",
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Constanst.fgPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              controller.tempNamaTipe1.value == "HALFDAY"
                                  ? Container(
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
                                                  BorderRadius.circular(10)),
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        controller.tempNamaTipe1.value =
                                            "HALFDAY";
                                        Get.back();
                                        controller.changeTypeSelected(1);
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
                                                    BorderRadius.circular(10)),
                                          ),
                                        ),
                                      ),
                                    )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ).then((value) {
            print('Bottom sheet closed');
          });
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.tempNamaTipe1.value,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Constanst.fgSecondary,
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
    );
  }

  // Widget pencarianData() {
  //   return Container(
  //     decoration: BoxDecoration(
  //         borderRadius: Constanst.borderStyle5,
  //         border: Border.all(color: Constanst.colorNonAktif)),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       children: [
  //         const Expanded(
  //           flex: 15,
  //           child: Padding(
  //             padding: EdgeInsets.only(top: 7, left: 10),
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
  //                       decoration: const InputDecoration(
  //                           border: InputBorder.none, hintText: "Cari"),
  //                       style: const TextStyle(
  //                           fontSize: 14.0, height: 1.0, color: Colors.black),
  //                       onSubmitted: (value) {
  //                         controller.cariData(value);
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
  //                               controller.onReady();
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

  Widget listAjuanIzin() {
    return ListView.builder(
        physics: controller.listHistoryAjuan.value.length <= 5
            ? const AlwaysScrollableScrollPhysics()
            : const BouncingScrollPhysics(),
        itemCount: controller.listHistoryAjuan.value.length,
        itemBuilder: (context, index) {
          var nomorAjuan =
              controller.listHistoryAjuan.value[index]['nomor_ajuan'];
          var tanggalMasukAjuan =
              controller.listHistoryAjuan.value[index]['atten_date'];
          var namaTypeAjuan = controller.listHistoryAjuan.value[index]['name'];
          var categoryAjuan =
              controller.listHistoryAjuan.value[index]['category'];
          var alasanReject =
              controller.listHistoryAjuan.value[index]['alasan_reject'];
          var typeAjuan;
          if (controller.valuePolaPersetujuan.value == "1") {
            typeAjuan =
                controller.listHistoryAjuan.value[index]['leave_status'];
          } else {
            typeAjuan = controller.listHistoryAjuan.value[index]
                        ['leave_status'] ==
                    "Approve"
                ? "Approve 1"
                : controller.listHistoryAjuan.value[index]['leave_status'] ==
                        "Approve2"
                    ? "Approve 2"
                    : controller.listHistoryAjuan.value[index]['leave_status'];
          }
          var approve_by;
          if (controller.listHistoryAjuan.value[index]['apply2_by'] == "" ||
              controller.listHistoryAjuan.value[index]['apply2_by'] == "null" ||
              controller.listHistoryAjuan.value[index]['apply2_by'] == null) {
            approve_by = controller.listHistoryAjuan.value[index]['apply_by'];
          } else {
            approve_by = controller.listHistoryAjuan.value[index]['apply2_by'];
          }

          return Column(
            children: [
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Constanst.colorNonAktif)),
                child: InkWell(
                  customBorder: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  onTap: () => controller.showDetailRiwayat(
                      controller.listHistoryAjuan.value[index],
                      approve_by,
                      alasanReject),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 12, bottom: 8),
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
                        const SizedBox(height: 12),
                        Divider(
                            height: 0, thickness: 1, color: Constanst.border),
                        const SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Container(
                            //   margin: EdgeInsets.only(right: 6),
                            //   decoration: BoxDecoration(
                            //     color: typeAjuan == 'Approve'
                            //         ? Constanst.colorBGApprove
                            //         : typeAjuan == 'Approve 1'
                            //             ? Constanst.colorBGApprove
                            //             : typeAjuan == 'Approve 2'
                            //                 ? Constanst.colorBGApprove
                            //                 : typeAjuan == 'Rejected'
                            //                     ? Constanst
                            //                         .colorBGRejected
                            //                     : typeAjuan == 'Pending'
                            //                         ? Constanst
                            //                             .colorBGPending
                            //                         : Colors.grey,
                            //     borderRadius: Constanst.borderStyle1,
                            //   ),
                            //   child: Padding(
                            //     padding: EdgeInsets.only(
                            //         left: 3, right: 3, top: 5, bottom: 5),
                            //     child: Row(
                            //       mainAxisAlignment:
                            //           MainAxisAlignment.center,
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
                            //                         color:
                            //                             Constanst.color5,
                            //                         size: 14,
                            //                       )
                            //                     : typeAjuan == 'Rejected'
                            //                         ? Icon(
                            //                             Iconsax
                            //                                 .close_square,
                            //                             color: Constanst
                            //                                 .color4,
                            //                             size: 14,
                            //                           )
                            //                         : typeAjuan ==
                            //                                 'Pending'
                            //                             ? Icon(
                            //                                 Iconsax.timer,
                            //                                 color: Constanst
                            //                                     .color3,
                            //                                 size: 14,
                            //                               )
                            //                             : SizedBox(),
                            //         Padding(
                            //           padding:
                            //               const EdgeInsets.only(left: 3),
                            //           child: Text(
                            //             '$typeAjuan',
                            //             textAlign: TextAlign.center,
                            //             style: TextStyle(
                            //                 fontWeight: FontWeight.bold,
                            //                 color: typeAjuan == 'Approve'
                            //                     ? Colors.green
                            //                     : typeAjuan == 'Approve 1'
                            //                         ? Colors.green
                            //                         : typeAjuan ==
                            //                                 'Approve 2'
                            //                             ? Colors.green
                            //                             : typeAjuan ==
                            //                                     'Rejected'
                            //                                 ? Colors.red
                            //                                 : typeAjuan ==
                            //                                         'Pending'
                            //                                     ? Constanst
                            //                                         .color3
                            //                                     : Colors
                            //                                         .black),
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),

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
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: typeAjuan == "Approve 1" ||
                                                typeAjuan == "Approve" ||
                                                typeAjuan == "Approve 2"
                                            ? Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Iconsax.tick_circle,
                                                    color: Colors.green,
                                                    size: 22,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                      "Approved by $approve_by",
                                                      style: GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Constanst
                                                              .fgPrimary,
                                                          fontSize: 14)),
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text("Pending Approval",
                                                          style: GoogleFonts.inter(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Constanst
                                                                  .fgPrimary,
                                                              fontSize: 14)),
                                                      const SizedBox(height: 4),
                                                      InkWell(
                                                          onTap: () {
                                                            var dataEmployee = {
                                                              'nameType':
                                                                  '$namaTypeAjuan',
                                                              'nomor_ajuan':
                                                                  '$nomorAjuan',
                                                            };
                                                            controllerGlobal
                                                                .showDataPilihAtasan(
                                                                    dataEmployee);
                                                          },
                                                          child: Text(
                                                              "Konfirmasi via Whatsapp",
                                                              style: GoogleFonts.inter(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Constanst
                                                                      .infoLight,
                                                                  fontSize:
                                                                      14))),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                      ),
                                      // typeAjuan == "Approve 1" ||
                                      //         typeAjuan == "Approve" ||
                                      //         typeAjuan == "Approve 2"
                                      //     ? SizedBox()
                                      //     : Expanded(
                                      //         child: Row(
                                      //         crossAxisAlignment:
                                      //             CrossAxisAlignment.center,
                                      //         mainAxisAlignment:
                                      //             MainAxisAlignment.center,
                                      //         children: [
                                      //           Expanded(
                                      //               child: Padding(
                                      //             padding: EdgeInsets.only(
                                      //                 right: 10),
                                      //             child: InkWell(
                                      //               onTap: () {
                                      //                 controller
                                      //                     .showModalBatalPengajuan(
                                      //                         controller
                                      //                             .listHistoryAjuan
                                      //                             .value[index]);
                                      //               },
                                      //               child: Text(
                                      //                 "Batalkan",
                                      //                 textAlign:
                                      //                     TextAlign.center,
                                      //                 style: TextStyle(
                                      //                     color: Colors.red),
                                      //               ),
                                      //             ),
                                      //           )),
                                      //           Expanded(
                                      //               child: Padding(
                                      //             padding: EdgeInsets.only(
                                      //                 right: 10),
                                      //             child: Container(
                                      //               decoration: BoxDecoration(
                                      //                   borderRadius: Constanst
                                      //                       .borderStyle1,
                                      //                   border: Border.all(
                                      //                       color: Constanst
                                      //                           .colorPrimary)),
                                      //               child: InkWell(
                                      //                 onTap: () {
                                      //                   Get.to(
                                      //                       FormPengajuanIzin(
                                      //                     dataForm: [
                                      //                       controller
                                      //                           .listHistoryAjuan
                                      //                           .value[index],
                                      //                       true
                                      //                     ],
                                      //                   ));
                                      //                 },
                                      //                 child: Text(
                                      //                   "Edit",
                                      //                   textAlign:
                                      //                       TextAlign.center,
                                      //                   style: TextStyle(
                                      //                       color: Constanst
                                      //                           .colorPrimary),
                                      //                 ),
                                      //               ),
                                      //             ),
                                      //           )),
                                      //         ],
                                      //       )),
                                    ],
                                  )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
