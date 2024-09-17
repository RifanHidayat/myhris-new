// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:siscom_operasional/controller/aktifitas_controller.dart';
import 'package:siscom_operasional/controller/auth_controller.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/month_year_picker.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Aktifitas extends StatelessWidget {
  final controller = Get.put(AktifitasController());
  final authController = Get.put(AuthController());

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constanst.coloBackgroundScreen,
      // appBar: AppBar(
      //     backgroundColor: Constanst.colorPrimary,
      //     elevation: 0,
      //     flexibleSpace: appbarSetting()),
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
              leadingWidth: controller.statusFormPencarian.value ? 50 : 16,
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
                            UtilsAlert.loadingSimpanData(
                                Get.context!, "Mencari Data...");
                            controller.pencarianDataAktifitas();
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
                                  controller.cari.value.clear();
                                  controller.statusPencarian.value = false;
                                  // controller.statusFormPencarian.value = false;
                                  controller.listAktifitas.value.clear();
                                  controller.loadAktifitas();
                                },
                              ),
                            )),
                      ),
                    )
                  : Text(
                      "Aktivitas",
                      style: GoogleFonts.inter(
                          color: Constanst.fgPrimary,
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: Obx(() {
                      return Container(
                        decoration: BoxDecoration(
                          color: authController.isConnected.value
                              ? Constanst.color5
                              : Constanst.color4,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      );
                    }),
                  ),
                ),
                controller.statusFormPencarian.value
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
                  : Container(),
            ),
          ),
        ),
      ),
      body: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: SafeArea(
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  controller.isVisible.value == false
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: AnimatedOpacity(
                              opacity:
                                  controller.visibleWidget.value ? 0.0 : 1.0,
                              duration: const Duration(milliseconds: 500),
                              child: controller.visibleWidget.value
                                  ? const SizedBox()
                                  : dashboardAktifitas()),
                        ),

                  controller.isVisible.value == false
                      ? const SizedBox(height: 0)
                      : const SizedBox(height: 16),
                  controller.isVisible.value == false
                      ? Container()
                      : Container(
                          height: 6,
                          width: double.infinity,
                          color: Constanst.colorNeutralBgSecondary),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 8.0, left: 16, right: 16),
                    child: Text(
                      "Aktivitas terakhir Saya",
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Constanst.fgPrimary),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // controller.statusPencarian.value == false
                  //     ? const SizedBox()
                  //     : Padding(
                  //         padding: const EdgeInsets.only(left: 16, right: 16),
                  //         child: Row(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Expanded(
                  //                 flex: 90,
                  //                 child: Text(
                  //                   "Pencarian data : #${controller.cari.value.text}",
                  //                   style: GoogleFonts.inter(
                  //                       fontWeight: FontWeight.w400,
                  //                       fontSize: 14,
                  //                       color: Constanst.fgPrimary),
                  //                 )),
                  //             Expanded(
                  //               flex: 10,
                  //               child: InkWell(
                  //                   onTap: () {
                  //                     controller.statusPencarian.value = false;
                  //                     controller.statusFormPencarian.value =
                  //                         false;
                  //                     controller.listAktifitas.value.clear();
                  //                     controller.loadAktifitas();
                  //                   },
                  //                   child: const Icon(
                  //                     Iconsax.close_circle,
                  //                     size: 20,
                  //                     color: Colors.red,
                  //                   )),
                  //             )
                  //           ],
                  //         ),
                  //       ),
                  Flexible(
                      flex: 3,
                      child: controller.listAktifitas.value.isEmpty
                          ? Center(
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/amico.png",
                                      height: 250,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Anda tidak memiliki Aktivitas terakhir",
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Constanst.fgPrimary),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : controller.statusPencarian.value == false
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16),
                                  child: SmartRefresher(
                                      enablePullDown: false,
                                      enablePullUp: true,
                                      header: const MaterialClassicHeader(),
                                      onRefresh: () async {
                                        await Future.delayed(
                                            const Duration(milliseconds: 1000));
                                        controller.listAktifitas.value.clear();
                                        controller.loadAktifitas();
                                        controller.refreshController
                                            .refreshCompleted();
                                      },
                                      onLoading: () async {
                                        await Future.delayed(
                                            const Duration(milliseconds: 1000));
                                        controller.loadAktifitas();
                                        controller.refreshController
                                            .loadComplete();
                                      },
                                      controller: controller.refreshController,
                                      child: ListView.builder(
                                          itemCount: controller
                                              .listAktifitas.value.length,
                                          controller:
                                              controller.controllerScroll,
                                          itemBuilder: (context, index) {
                                            var namaMenu = controller
                                                .listAktifitas
                                                .value[index]['menu_name'];
                                            var namaAktifitas = controller
                                                .listAktifitas
                                                .value[index]['activity_name'];
                                            var createdDate = controller
                                                .listAktifitas
                                                .value[index]['createdDate'];
                                            var jam = controller.listAktifitas
                                                .value[index]['jam'];
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 10),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      flex: 10,
                                                      child: Container(
                                                        height: 30,
                                                        width: 30,
                                                        decoration: BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: Constanst
                                                                .colorNeutralBgSecondary),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Container(
                                                            height: 30,
                                                            width: 30,
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Constanst
                                                                    .colorNeutralFgTertiary),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 90,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 8,
                                                                bottom: 4),
                                                        child: Text(
                                                          "$namaMenu",
                                                          style: GoogleFonts.inter(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 16,
                                                              color: Constanst
                                                                  .fgPrimary),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                IntrinsicHeight(
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Expanded(
                                                        flex: 10,
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Container(
                                                            width: 2,
                                                            color: const Color
                                                                .fromARGB(
                                                                24, 0, 22, 103),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 90,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 8,
                                                                  bottom: 4),
                                                          child: Text(
                                                            "${Constanst.convertDate4('$createdDate')} $jam",
                                                            style: GoogleFonts.inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 14,
                                                                color: Constanst
                                                                    .fgSecondary),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                IntrinsicHeight(
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Expanded(
                                                        flex: 10,
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Container(
                                                            width: 2,
                                                            color: const Color
                                                                .fromARGB(
                                                                24, 0, 22, 103),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 90,
                                                        child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 8),
                                                            child: Text(
                                                              "$namaAktifitas",
                                                              style: GoogleFonts.inter(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 14,
                                                                  color: Constanst
                                                                      .fgSecondary),
                                                            )),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          })),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16),
                                  child: ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      itemCount:
                                          controller.listAktifitas.value.length,
                                      itemBuilder: (context, index) {
                                        var namaMenu = controller.listAktifitas
                                            .value[index]['menu_name'];
                                        var namaAktifitas = controller
                                            .listAktifitas
                                            .value[index]['activity_name'];
                                        var createdDate = controller
                                            .listAktifitas
                                            .value[index]['createdDate'];
                                        var jam = controller
                                            .listAktifitas.value[index]['jam'];
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 10),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  flex: 10,
                                                  child: Container(
                                                    height: 30,
                                                    width: 30,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Constanst
                                                            .colorNeutralBgSecondary),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        height: 30,
                                                        width: 30,
                                                        decoration: BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: Constanst
                                                                .colorNeutralFgTertiary),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 90,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8, bottom: 4),
                                                    child: Text(
                                                      "$namaMenu",
                                                      style: GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16,
                                                          color: Constanst
                                                              .fgPrimary),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            IntrinsicHeight(
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    flex: 10,
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Container(
                                                        width: 2,
                                                        color: const Color
                                                            .fromARGB(
                                                            24, 0, 22, 103),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 90,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8,
                                                              bottom: 4),
                                                      child: Text(
                                                        "${Constanst.convertDate4('$createdDate')} $jam",
                                                        style: GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 14,
                                                            color: Constanst
                                                                .fgSecondary),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            IntrinsicHeight(
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    flex: 10,
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Container(
                                                        width: 2,
                                                        color: const Color
                                                            .fromARGB(
                                                            24, 0, 22, 103),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 90,
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 8),
                                                        child: Text(
                                                          "$namaAktifitas",
                                                          style: GoogleFonts.inter(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 14,
                                                              color: Constanst
                                                                  .fgSecondary),
                                                        )),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                ))
                ],
              ),
            ),
          )),
    );
  }

  Widget dashboardAktifitas() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Kehadiran Saya",
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Constanst.fgPrimary),
            ),
            InkWell(
              customBorder: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(100))),
              onTap: () {
                DatePicker.showPicker(
                  Get.context!,
                  pickerModel: CustomMonthPicker(
                    minTime: DateTime(2020, 1, 1),
                    maxTime: DateTime(2050, 1, 1),
                    currentTime: DateTime.now(),
                  ),
                  onConfirm: (time) {
                    if (time != null) {
                      print("$time");
                      var filter = DateFormat('yyyy-MM').format(time);
                      DateTime previousMonthDate =
                          DateTime(time.year, time.month - 1, time.day);

                      var array = filter.split('-');
                      var bulan = array[1];
                      var tahun = array[0];
                      controller.stringBulan.value =
                          DateFormat('MMMM').format(time);
                      controller.endPayroll.value =
                          DateFormat('MMMM').format(time);

                      controller.bulanEnd.value = DateFormat('MM').format(time);

                      if (AppData.informasiUser![0].beginPayroll == 1) {
                        controller.beginPayroll.value =
                            DateFormat('MMMM').format(time);
                        controller.bulanStart.value =
                            DateFormat('MM').format(time);
                      } else {
                        controller.beginPayroll.value =
                            DateFormat('MMMM').format(previousMonthDate);
                        controller.bulanStart.value =
                            DateFormat('MM').format(previousMonthDate);
                      }
                      controller.bulanSelectedSearchHistory.value = bulan;
                      controller.tahunSelectedSearchHistory.value = tahun;
                      controller.bulanDanTahunNow.value = "$bulan-$tahun";
                      this.controller.bulanSelectedSearchHistory.refresh();
                      this.controller.tahunSelectedSearchHistory.refresh();
                      this.controller.bulanDanTahunNow.refresh();
                      this.controller.stringBulan.refresh();
                      controller.getInformasiAktivitas();
                    }
                  },
                );
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Constanst.fgBorder)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Constanst.convertDateBulanDanTahun(
                            controller.bulanDanTahunNow.value),
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Constanst.fgPrimary),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Iconsax.arrow_down_1,
                        size: 18,
                        color: Constanst.fgPrimary,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            itemCount: controller.infoAktifitas.value.length,
            scrollDirection: Axis.vertical,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.7,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 12.0),
            itemBuilder: (context, index) {
              var id = controller.infoAktifitas.value[index]['id'];
              var title = controller.infoAktifitas.value[index]['nama'];
              var jumlah = controller.infoAktifitas.value[index]['jumlah'];
              return Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Constanst.infoLight1,
                  border: Border.all(
                    color: Constanst.colorStateInfoBorder,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "$jumlah",
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Constanst.fgPrimary),
                          ),
                          title == "WFH"
                              ? Image.asset(
                                  'assets/14_wfh.png',
                                  height: 30,
                                  width: 30,
                                )
                              : title == "Sakit"
                                  ? Image.asset(
                                      'assets/13_sakit.png',
                                      height: 30,
                                      width: 30,
                                    )
                                  : SvgPicture.asset(
                                      title == "Masuk Kerja"
                                          ? 'assets/2_absen.svg'
                                          : title == "Izin"
                                              ? 'assets/3_izin.svg'
                                              : title == "Cuti"
                                                  ? 'assets/5_cuti.svg'
                                                  : title == "Lembur"
                                                      ? 'assets/4_lembur.svg'
                                                      : 'assets/8_kandidat.svg',
                                      height: 30,
                                      width: 30,
                                    ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        title,
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Constanst.fgSecondary),
                      ),
                    ],
                  ),
                ),
              );
            }),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
              color: Constanst.infoLight1,
              borderRadius: const BorderRadius.all(
                Radius.circular(12.0),
              ),
              border: Border.all(
                color: Constanst.colorStateInfoBorder,
              )),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularPercentIndicator(
                  radius: 30.0,
                  lineWidth: 4.0,
                  percent: controller.persenAbsenTelat.value,
                  center: Text(controller.stringPersenAbsenTepatWaktu.value),
                  progressColor: Constanst.infoLight,
                ),
                Flexible(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18),
                    child: InkWell(
                      onTap: () {
                        print(
                            AppData.informasiUser![0].beginPayroll.toString());
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Absen tepat waktu",
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                color: Constanst.fgPrimary,
                                fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          // Text(
                          //   "Periode ${controller.stringBulan.value}",
                          //   style: GoogleFonts.inter(
                          //       fontWeight: FontWeight.w400,
                          //       color: Constanst.fgSecondary,
                          //       fontSize: 12),
                          // ),
                          Text(
                            "Dari ${AppData.informasiUser![0].beginPayroll} ${controller.beginPayroll.value} sd ${AppData.informasiUser![0].endPayroll} ${controller.endPayroll.value} ${controller.tahunSelectedSearchHistory.value}",
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                color: Constanst.fgSecondary,
                                fontSize: 12),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
