// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/kandidat_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:siscom_operasional/screen/init_screen.dart';
import 'package:siscom_operasional/screen/kandidat/form_kandidat.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/month_year_picker.dart';

class Kandidat extends StatefulWidget {
  @override
  _KandidatState createState() => _KandidatState();
}

class _KandidatState extends State<Kandidat> {
  final controller = Get.put(KandidatController());

  @override
  void initState() {
    controller.startData();
    super.initState();
  }

  Future<void> refreshData() async {
    await Future.delayed(Duration(seconds: 2));
    controller.startData();
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
                        controller: controller.cari.value,
                        // onFieldSubmitted: (value) {
                        //   controller.cariData(value);
                        // },
                        onChanged: (value) {
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
                                  controller.startData();
                                },
                              ),
                            )),
                      ),
                    )
                  : Text(
                      "Permintaan Kandidat",
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
                    : IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Iconsax.search_normal_1,
                          color: Constanst.fgPrimary,
                          size: 24,
                        ),
                        onPressed: controller.showInputCari,
                        // controller.toggleSearch,
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
          Get.back();
          return true;
        },
        child: SafeArea(
          child: Obx(
            () => Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      filterBulan(),
                      const SizedBox(width: 4),
                      !controller.viewWidgetPilihDepartement.value
                          ? const SizedBox()
                          : cariDepartement(),
                      const SizedBox(width: 4),
                      // typeStatus(),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // controller.selectedViewFilterPengajuan
                      //             .value ==
                      //         0
                      //     ? Text(
                      //         "${controller.namaDepartemenTerpilih.value}  (${Constanst.convertDateBulanDanTahun('${controller.bulanDanTahunNow}')})",
                      //         style: TextStyle(
                      //             fontWeight: FontWeight.bold,
                      //             fontSize: 14),
                      //       )
                      //     : Text(
                      //         "${controller.namaDepartemenTerpilih.value}  (${Constanst.convertDate('${DateFormat('yyyy-MM-dd').format(controller.pilihTanggalFilterAjuan.value)}')})",
                      //         style: TextStyle(
                      //             fontWeight: FontWeight.bold,
                      //             fontSize: 14),
                      //       ),
                      Text(
                        "${controller.listPermintaanKandidat.value.length} Permintaan",
                        style: GoogleFonts.inter(
                            color: Constanst.fgSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                      child: RefreshIndicator(
                    color: Constanst.colorPrimary,
                    onRefresh: refreshData,
                    child: controller.loadingUpdateData.value
                        ? Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Constanst.colorPrimary,
                            ),
                          )
                        : controller.listPermintaanKandidat.value.isEmpty
                            ? Center(
                                child: SafeArea(
                                  child: controller.loadingString.value ==
                                          "Memuat Data..."
                                      ? Container()
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
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
                                            const SizedBox(height: 80),
                                          ],
                                        ),
                                ),
                              )
                            : riwayatPermintaanKandidat(),
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Constanst.colorPrimary,
        onPressed: () {
          Get.to(FormKandidat(
            dataForm: [[], false],
          ));
        },
        child: const Icon(
          Iconsax.add,
          size: 34,
        ),
      ),
    );
  }

  Widget cariDepartement() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          border: Border.all(color: Constanst.fgBorder)),
      child: InkWell(
        customBorder: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(100))),
        onTap: () {
          controller.showDataDepartemenAkses();
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.departemen.value,
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

  Widget filterBulan() {
    return InkWell(
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
              print("get load permintan kandidat");
              controller.loadPermintaanKandidat();
            }
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(100)),
            border: Border.all(color: Constanst.fgBorder)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Constanst.convertDateBulanDanTahun(
                    controller.bulanDanTahunNow.value),
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
  //   return Row(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Expanded(
  //         flex: 60,
  //         child: Container(
  //           margin: EdgeInsets.only(right: 3.0),
  //           decoration: BoxDecoration(
  //               borderRadius: Constanst.borderStyle5,
  //               border: Border.all(color: Constanst.colorNonAktif)),
  //           child: Row(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             children: [
  //               Expanded(
  //                 flex: 15,
  //                 child: Padding(
  //                   padding: const EdgeInsets.only(top: 7, left: 10),
  //                   child: Icon(Iconsax.search_normal_1),
  //                 ),
  //               ),
  //               Expanded(
  //                 flex: 85,
  //                 child: Padding(
  //                   padding: const EdgeInsets.only(left: 10),
  //                   child: SizedBox(
  //                     height: 40,
  //                     child: Row(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Expanded(
  //                           flex: 80,
  //                           child: TextField(
  //                             controller: controller.cari.value,
  //                             decoration: InputDecoration(
  //                                 border: InputBorder.none, hintText: "Cari"),
  //                             style: TextStyle(
  //                                 fontSize: 14.0,
  //                                 height: 1.0,
  //                                 color: Colors.black),
  //                             onChanged: (value) {
  //                               controller.cariData(value);
  //                             },
  //                           ),
  //                         ),
  //                         !controller.statusCari.value
  //                             ? SizedBox()
  //                             : Expanded(
  //                                 flex: 20,
  //                                 child: Padding(
  //                                   padding: const EdgeInsets.only(right: 8),
  //                                   child: IconButton(
  //                                     icon: Icon(
  //                                       Iconsax.close_circle,
  //                                       color: Colors.red,
  //                                     ),
  //                                     onPressed: () {
  //                                       controller.statusCari.value = false;
  //                                       controller.cari.value.text = "";
  //                                       controller.startData();
  //                                     },
  //                                   ),
  //                                 ),
  //                               )
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //       ),

  //     ],
  //   );
  // }

  Widget typeStatus() {
    return SizedBox(
      height: 30,
      child: ListView.builder(
          itemCount: controller.listTypeStatus.value.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            var id = controller.listTypeStatus[index]['id'];
            var namaType = controller.listTypeStatus[index]['name'];
            var status = controller.listTypeStatus[index]['status'];
            return InkWell(
              highlightColor: Constanst.colorPrimary,
              onTap: () => controller.changeTypeStatus(id, namaType),
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
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Text(
                          '$namaType',
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

  Widget riwayatPermintaanKandidat() {
    return ListView.builder(
        physics: controller.listPermintaanKandidat.value.length <= 10
            ? const AlwaysScrollableScrollPhysics()
            : const BouncingScrollPhysics(),
        itemCount: controller.listPermintaanKandidat.value.length,
        itemBuilder: (context, index) {
          var id = controller.listPermintaanKandidat.value[index]['id'];
          var nomorAjuan =
              controller.listPermintaanKandidat.value[index]['nomor_ajuan'];
          var tanggalAjuan =
              controller.listPermintaanKandidat.value[index]['tgl_ajuan'];
          var posisi =
              controller.listPermintaanKandidat.value[index]['position'];
          var pengaju =
              controller.listPermintaanKandidat.value[index]['full_name'];
          var namaDepartement = controller.listPermintaanKandidat.value[index]
              ['nama_departement'];
          var status = controller.listPermintaanKandidat.value[index]
              ['status_transaksi'];

          return Column(
            children: [
              InkWell(
                customBorder: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                onTap: () {
                  controller.getDetail(id);
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Constanst.colorNonAktif)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("$namaDepartement",
                                    style: GoogleFonts.inter(
                                        color: Constanst.fgPrimary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(height: 4),
                                Text(nomorAjuan,
                                    style: GoogleFonts.inter(
                                        color: Constanst.fgSecondary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400)),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: 18,
                                      color: Constanst.fgSecondary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(Constanst.convertDate('$tanggalAjuan'),
                                        style: GoogleFonts.inter(
                                            color: Constanst.fgSecondary,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      size: 18,
                                      color: Constanst.fgSecondary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(posisi + ' Applied',
                                        style: GoogleFonts.inter(
                                            color: Constanst.fgSecondary,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400)),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: status == 1
                                    ? Constanst.colorButton3
                                    : Constanst.colorNeutralBgSecondary,
                                borderRadius: Constanst.borderStyle1,
                              ),
                              child: Center(
                                  child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    8.0, 4.0, 8.0, 4.0),
                                child: Text(
                                  status == 1 ? "Aktif" : "Nonaktif",
                                  style: GoogleFonts.inter(
                                      color: status == 1
                                          ? Constanst.colotStateInfoBg
                                          : Constanst.fgPrimary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                              )),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12, bottom: 12),
                          child: Divider(
                            thickness: 1,
                            height: 0,
                            color: Constanst.border,
                          ),
                        ),
                        Text(
                          "Requested by $pengaju",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Constanst.fgPrimary),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          );
        });
  }
}
