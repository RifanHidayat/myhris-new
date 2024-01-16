// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/global_controller.dart';
import 'package:siscom_operasional/controller/lembur_controller.dart';
import 'package:siscom_operasional/screen/absen/form/form_lembur.dart';
import 'package:siscom_operasional/screen/absen/laporan/laporan_lembur.dart';
import 'package:siscom_operasional/screen/init_screen.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/month_year_picker.dart';
import 'package:siscom_operasional/utils/widget_textButton.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';

class Lembur extends StatefulWidget {
  @override
  _LemburState createState() => _LemburState();
}

class _LemburState extends State<Lembur> {
  final controller = Get.put(LemburController());
  var controllerGlobal = Get.put(GlobalController());

  @override
  void initState() {
    Api().checkLogin();
    super.initState();
  }

  Future<void> refreshData() async {
    await Future.delayed(Duration(seconds: 2));
    controller.loadDataLembur();
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
                          if (controller.cari.value.text == "") {
                            UtilsAlert.showToast(
                                "Isi form cari terlebih dahulu");
                          } else {
                            // UtilsAlert.loadingSimpanData(
                            //     Get.context!, "Mencari Data...");
                            controller.cariData(value);
                          }
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
                                  controller.loadDataLembur();
                                },
                              ),
                            )),
                      ),
                    )
                  : Text(
                      "Riwayat Lembur",
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
                          SizedBox(
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
                          Obx(
                            () => controller.showButtonlaporan.value == false
                                ? const SizedBox()
                                : IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: Icon(
                                      Iconsax.document_text,
                                      color: Constanst.fgPrimary,
                                      size: 24,
                                    ),
                                    onPressed: () => Get.to(LaporanLembur(
                                      title: 'lembur',
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
          controller.onClose();
          Get.offAll(InitScreen());
          return true;
        },
        child: Obx(
          () => Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // controller.bulanDanTahunNow.value == ""
                //     ? SizedBox()
                //     : Row(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Expanded(
                //             flex: 60,
                //             child: Padding(
                //               padding: const EdgeInsets.only(right: 8),
                //               child: pencarianData(),
                //             ),
                //           ),
                //           Expanded(
                //             flex: 40,
                //             child: Padding(
                //               padding: const EdgeInsets.only(left: 8),
                //               child: pickDate(),
                //             ),
                //           )
                //         ],
                //       ),
                controller.bulanDanTahunNow.value == ""
                    ? const SizedBox()
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Expanded(
                          //   flex: 60,
                          //   child: Padding(
                          //     padding: const EdgeInsets.only(right: 8),
                          //     child: pencarianData(),
                          //   ),
                          // ),
                          pickDate(),
                          const SizedBox(width: 4),
                          status()
                        ],
                      ),

                // listStatusAjuan(),
                const SizedBox(height: 4),
                Flexible(
                    child: RefreshIndicator(
                        color: Constanst.colorPrimary,
                        onRefresh: refreshData,
                        child: controller.listLembur.value.isEmpty
                            ? Center(
                                child: SafeArea(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                    const SizedBox(height: 85),
                                  ],
                                ),
                              ))
                            : riwayatLembur()))
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
      //                 label: 'Laporan Lembur',
      //                 onTap: () {
      //                   Get.to(LaporanLembur(
      //                     title: 'lembur',
      //                   ));
      //                 }),
      //             SpeedDialChild(
      //                 child: Icon(Iconsax.add_square),
      //                 backgroundColor: Color(0xff14B156),
      //                 foregroundColor: Colors.white,
      //                 label: 'Buat Pengajuan Lembur',
      //                 onTap: () {
      //                   Get.to(FormLembur(
      //                     dataForm: [[], false],
      //                   ));
      //                 }),
      //           ],
      //         ),
      // ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Constanst.colorPrimary,
        onPressed: () {
          Get.to(FormLembur(
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
      //               title: "Buat Pengajuan Lembur",
      //               onTap: () {
      //                 Get.to(FormLembur(
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

  Widget pickDate() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          border: Border.all(color: Constanst.fgBorder)),
      child: InkWell(
        customBorder: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(100))),
        onTap: () {
          DatePicker.showPicker(
            Get.context!,
            pickerModel: CustomMonthPicker(
              minTime: DateTime(2020, 1, 1),
              maxTime: DateTime(2050, 1, 1),
              currentTime: DateTime(
                  int.parse(controller.tahunSelectedSearchHistory.value),
                  int.parse(controller.bulanSelectedSearchHistory.value),
                  1),
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
                controller.loadDataLembur();
              }
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${getMonthName(int.parse(controller.bulanSelectedSearchHistory.value))} ${controller.tahunSelectedSearchHistory.value}",
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
                                      const SizedBox(width: 20),
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

  Widget listStatusAjuan() {
    return SizedBox(
      height: 30,
      child: ListView.builder(
          itemCount: controller.dataTypeAjuan.value.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            var namaType = controller.dataTypeAjuan[index]['nama'];
            var status = controller.dataTypeAjuan[index]['status'];
            return InkWell(
              highlightColor: Constanst.colorPrimary,
              onTap: () => controller.changeTypeAjuan(
                  controller.dataTypeAjuan.value[index]['nama']),
              child: Container(
                padding: EdgeInsets.only(left: 8, right: 8),
                margin: EdgeInsets.only(left: 5, right: 5),
                decoration: BoxDecoration(
                  color: status == true
                      ? Constanst.colorPrimary
                      : Constanst.colorNonAktif,
                  borderRadius: Constanst.borderStyle1,
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      namaType == "Approve"
                          ? Icon(
                              Iconsax.tick_square,
                              size: 14,
                              color: status == true
                                  ? Colors.white
                                  : Constanst.colorText2,
                            )
                          : namaType == "Approve 1"
                              ? Icon(
                                  Iconsax.tick_square,
                                  size: 14,
                                  color: status == true
                                      ? Colors.white
                                      : Constanst.colorText2,
                                )
                              : namaType == "Approve 2"
                                  ? Icon(
                                      Iconsax.tick_square,
                                      size: 14,
                                      color: status == true
                                          ? Colors.white
                                          : Constanst.colorText2,
                                    )
                                  : namaType == "Rejected"
                                      ? Icon(
                                          Iconsax.close_square,
                                          size: 14,
                                          color: status == true
                                              ? Colors.white
                                              : Constanst.colorText2,
                                        )
                                      : namaType == "Pending"
                                          ? Icon(
                                              Iconsax.timer,
                                              size: 14,
                                              color: status == true
                                                  ? Colors.white
                                                  : Constanst.colorText2,
                                            )
                                          : SizedBox(),
                      Padding(
                        padding: const EdgeInsets.only(left: 6, right: 6),
                        child: Text(
                          namaType,
                          style: TextStyle(
                              fontSize: 12,
                              color: status == true
                                  ? Colors.white
                                  : Constanst.colorText2,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
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
                                controller.statusCari.value = false;
                                controller.cari.value.text = "";
                                controller.onReady();
                              },
                            ),
                          )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget riwayatLembur() {
    return ListView.builder(
        physics: controller.listLembur.value.length <= 8
            ? const AlwaysScrollableScrollPhysics()
            : const BouncingScrollPhysics(),
        itemCount: controller.listLembur.value.length,
        itemBuilder: (context, index) {
          var nomorAjuan = controller.listLembur.value[index]['nomor_ajuan'];
          var dariJam = controller.listLembur.value[index]['dari_jam'];
          var sampaiJam = controller.listLembur.value[index]['sampai_jam'];
          var tanggalPengajuan =
              controller.listLembur.value[index]['atten_date'];
          var status;
          if (controller.valuePolaPersetujuan.value == "1") {
            status = controller.listLembur.value[index]['status'];
          } else {
            status = controller.listLembur.value[index]['status'] == "Approve"
                ? "Approve 1"
                : controller.listLembur.value[index]['status'] == "Approve2"
                    ? "Approve 2"
                    : controller.listLembur.value[index]['status'];
          }
          var namaTypeAjuan = controller.listLembur.value[index]['type'];
          var alasanReject =
              controller.listLembur.value[index]['alasan_reject'];
          var approveDate = controller.listLembur.value[index]['approve_date'];
          var uraian = controller.listLembur.value[index]['uraian'];
          var approve;
          if (controller.listLembur.value[index]['approve2_by'] == "" ||
              controller.listLembur.value[index]['approve2_by'] == "null" ||
              controller.listLembur.value[index]['approve2_by'] == null) {
            approve = controller.listLembur.value[index]['approve_by'];
          } else {
            approve = controller.listLembur.value[index]['approve2_by'];
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
                  onTap: () => controller.showDetailLembur(
                      controller.listLemburAll.value[index],
                      approve,
                      alasanReject),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 12, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("$namaTypeAjuan",
                            style: GoogleFonts.inter(
                                color: Constanst.fgPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        Text("NO.$nomorAjuan",
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.inter(
                                color: Constanst.fgSecondary,
                                fontSize: 16,
                                fontWeight: FontWeight.w400)),
                        const SizedBox(height: 4),
                        Text(Constanst.convertDate5("$tanggalPengajuan"),
                            style: GoogleFonts.inter(
                                color: Constanst.fgSecondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w400)),
                        const SizedBox(height: 4),
                        // Text('$dariJam sd $sampaiJam',
                        //     textAlign: TextAlign.justify,
                        //     style: GoogleFonts.inter(
                        //         color: Constanst.fgSecondary,
                        //         fontSize: 14,
                        //         fontWeight: FontWeight.w400)),
                        // Text(
                        //   '$uraian',
                        //   textAlign: TextAlign.justify,
                        //   style: TextStyle(
                        //       fontSize: 14, color: Constanst.colorText2),
                        // ),
                        const SizedBox(height: 12),
                        Divider(
                            height: 0, thickness: 1, color: Constanst.border),
                        const SizedBox(height: 8),
                        // Container(
                        //   margin: EdgeInsets.only(right: 8),
                        //   decoration: BoxDecoration(
                        //     color: status == 'Approve'
                        //         ? Constanst.colorBGApprove
                        //         : status == 'Approve 1'
                        //             ? Constanst.colorBGApprove
                        //             : status == 'Approve 2'
                        //                 ? Constanst.colorBGApprove
                        //                 : status == 'Rejected'
                        //                     ? Constanst.colorBGRejected
                        //                     : status == 'Pending'
                        //                         ? Constanst.colorBGPending
                        //                         : Colors.grey,
                        //     borderRadius: Constanst.borderStyle1,
                        //   ),
                        //   child: Padding(
                        //     padding: EdgeInsets.only(
                        //         left: 3, right: 3, top: 5, bottom: 5),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       children: [
                        //         status == 'Approve'
                        //             ? Icon(
                        //                 Iconsax.tick_square,
                        //                 color: Constanst.color5,
                        //                 size: 14,
                        //               )
                        //             : status == 'Approve 1'
                        //                 ? Icon(
                        //                     Iconsax.tick_square,
                        //                     color: Constanst.color5,
                        //                     size: 14,
                        //                   )
                        //                 : status == 'Approve 2'
                        //                     ? Icon(
                        //                         Iconsax.tick_square,
                        //                         color: Constanst.color5,
                        //                         size: 14,
                        //                       )
                        //                     : status == 'Rejected'
                        //                         ? Icon(
                        //                             Iconsax.close_square,
                        //                             color: Constanst.color4,
                        //                             size: 14,
                        //                           )
                        //                         : status == 'Pending'
                        //                             ? Icon(
                        //                                 Iconsax.timer,
                        //                                 color: Constanst.color3,
                        //                                 size: 14,
                        //                               )
                        //                             : SizedBox(),
                        //         Padding(
                        //           padding: const EdgeInsets.only(left: 3),
                        //           child: Text(
                        //             '$status',
                        //             textAlign: TextAlign.center,
                        //             style: TextStyle(
                        //                 fontWeight: FontWeight.bold,
                        //                 color: status == 'Approve'
                        //                     ? Colors.green
                        //                     : status == 'Approve 1'
                        //                         ? Colors.green
                        //                         : status == 'Approve 2'
                        //                             ? Colors.green
                        //                             : status == 'Rejected'
                        //                                 ? Colors.red
                        //                                 : status == 'Pending'
                        //                                     ? Constanst.color3
                        //                                     : Colors.black),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        status == 'Rejected'
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                      Text("Rejected by $approve",
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
                            : status == "Approve" ||
                                    status == "Approve 1" ||
                                    status == "Approve 2"
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
                                      Text("Approved by $approve",
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              color: Constanst.fgPrimary,
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
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Pending Approval",
                                              style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w500,
                                                  color: Constanst.fgPrimary,
                                                  fontSize: 14)),
                                          const SizedBox(height: 4),
                                          InkWell(
                                              onTap: () {
                                                var dataEmployee = {
                                                  'nameType': '$namaTypeAjuan',
                                                  'nomor_ajuan': '$nomorAjuan',
                                                };
                                                controllerGlobal
                                                    .showDataPilihAtasan(
                                                        dataEmployee);
                                              },
                                              child: Text(
                                                  "Konfirmasi via Whatsapp",
                                                  style: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          Constanst.infoLight,
                                                      fontSize: 14))),
                                        ],
                                      ),
                                    ],
                                  ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }
}
