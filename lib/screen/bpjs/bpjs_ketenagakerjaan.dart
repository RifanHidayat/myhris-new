import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/bpjs.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/helper.dart';
import 'package:siscom_operasional/utils/month_year_picker.dart';
import 'package:siscom_operasional/utils/widget/text_group_column.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BpjsKetenagakerjaan extends StatelessWidget {
  BpjsKetenagakerjaan({super.key});
  var controller = Get.put(BpjsController());

  @override
  Widget build(BuildContext context) {
    controller.bulanKetenagakerjaan.value = DateTime.now().month.toString();
    controller.tahunKetenagakerjaan.value = DateTime.now().year.toString();
    controller.fetchBpjsKetenagakerjaam();
    return Scaffold(
      backgroundColor: Constanst.colorWhite,
      appBar: AppBar(
        backgroundColor: Constanst.colorWhite,
        elevation: 0,
        leadingWidth: 50,
        titleSpacing: 0,
        centerTitle: true,
        title: Text(
          "BPJS Ketenaga Kerjaan",
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
      body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Row(
                children: [
                  Obx(() {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: InkWell(
                        customBorder: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        onTap: () {
                          DatePicker.showPicker(
                            Get.context!,
                            pickerModel: CustomMonthPicker(
                              minTime: DateTime(2020, 1, 1),
                              maxTime: DateTime(2050, 1, 1),
                              currentTime: DateTime(
                                  int.parse(
                                      controller.tahunKetenagakerjaan.value),
                                  int.parse(
                                      controller.bulanKetenagakerjaan.value),
                                  1),
                            ),
                            onConfirm: (time) {
                              if (time != null) {
                                print("$time");
                                var filter = DateFormat('yyyy-MM').format(time);
                                var array = filter.split('-');
                                var bulan = array[1];
                                var tahun = array[0];
                                controller.bulanKetenagakerjaan.value =
                                    bulan.toString();
                                controller.tahunKetenagakerjaan.value =
                                    tahun.toString();
                                controller.fetchBpjsKetenagakerjaam();
                              }
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: Constanst.border)),
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Constanst.convertDateBulanDanTahun(
                                      "${controller.bulanKetenagakerjaan.value}-${controller.tahunKetenagakerjaan.value}"),
                                  style: GoogleFonts.inter(
                                      color: Constanst.fgSecondary,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Iconsax.arrow_down_14,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
              Obx(() {
                 if (controller.isLoadingBpjsKetenagakerjaan.value == true) {
                  return const Center(
                    heightFactor: 17,
                    child: CircularProgressIndicator(),
                  );
                }
                if (controller.bpjsKetenagakerjaan.isEmpty) {
                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/empty_screen.svg',
                          height: 228,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Data tidak ditemukan",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Constanst.fgPrimary,
                          ),
                        ),
                        const SizedBox(height: 120),
                      ],
                    ),
                  );
                }
               
                return SingleChildScrollView(
                  child: Column(
                    children: List.generate(
                        controller.bpjsKetenagakerjaan.length, (index) {
                      // children: List.generate(1, (index) {
                      return _list(index);
                    }),
                  ),
                );
                // return controller.isLoadingBpjsKetenagakerjaan.value == true
                //     ? Container(
                //         child: Center(child: CircularProgressIndicator()),
                //       )
                //     : SingleChildScrollView(
                //         child: Column(
                //           children: List.generate(
                //               controller.bpjsKetenagakerjaan.length, (index) {
                //             return _list(index);
                //           }),
                //         ),
                //       );
              })
            ],
          )),
    );
  }

  Widget _list(index) {
    var data = controller.bpjsKetenagakerjaan[index];
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Container(
        decoration: BoxDecoration(
            color: Constanst.infoLight,
            borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                12,
                23,
                12,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Constanst.colorWhite,
                        borderRadius: BorderRadius.circular(100)),
                    child: AppData.informasiUser![0].em_image == null ||
                            AppData.informasiUser![0].em_image == ""
                        ? SvgPicture.asset(
                            'assets/avatar_default.svg',
                            width: 40,
                            height: 40,
                          )
                        : CircleAvatar(
                            radius: 20,
                            child: ClipOval(
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "${Api.UrlfotoProfile}${AppData.informasiUser![0].em_image}",
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          Container(
                                    alignment: Alignment.center,
                                    height: MediaQuery.of(context).size.height,
                                    width: MediaQuery.of(context).size.width,
                                    child: CircularProgressIndicator(
                                        value: downloadProgress.progress),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    color: Colors.white,
                                    child: SvgPicture.asset(
                                      'assets/avatar_default.svg',
                                      width: 40,
                                      height: 40,
                                    ),
                                  ),
                                  fit: BoxFit.cover,
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextLabell(
                          text: "${AppData.informasiUser![0].full_name}",
                          // text: "Nama Penggguna",
                          color: Constanst.colorWhite,
                          weight: FontWeight.w500,
                          size: 16),
                      const SizedBox(height: 4),
                      TextLabell(
                          text:
                              "No JKN. ${AppData.informasiUser![0].nomorBpjsTenagakerja}",
                          color: Constanst.colorWhite,
                          weight: FontWeight.w400,
                          size: 16)
                    ],
                  )
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 7.0,
                      spreadRadius: 3.5,
                    ),
                  ],
                  color: Constanst.colorWhite),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TextGroupColumn(
                  //     title: "Jaminan Kecelakaan kerja(JKK)",
                  //     // subtitle: toCurrency(data.jkk),
                  //     subtitle: toCurrency(100000)),
                  // Divider(),
                  // TextGroupColumn(
                  //     title: "Jaminan Kematian(JKM)",
                  //     subtitle: toCurrency(100000)),
                  // Divider(),
                  // TextGroupColumn(
                  //     title: "Jaminan Hari Tua(JHT)",
                  //     subtitle: toCurrency(100000)),
                  // Divider(),
                  // TextGroupColumn(
                  //     title: "Jaminan Pensiun(JP)",
                  //     subtitle: toCurrency(100000)),
                  // Divider(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 30,
                          child: TextLabell(
                              text: "JKK",
                              color: Constanst.fgPrimary,
                              weight: FontWeight.w500,
                              size: 16),
                        ),
                        Expanded(
                            flex: 35,
                            child: TextGroupColumn2(
                                title: toCurrency(data.jkkTk),
                                subtitle: "TK (${data.jkkTkPercent}%)")),
                        const Expanded(
                          flex: 35, child: SizedBox(),
                          // child: TextGroupColumn2(
                          //     title: "TK (1%)", subtitle: "Rp.2000m,00")
                        )
                      ],
                    ),
                  ),
                  Divider(
                    height: 0,
                    thickness: 1,
                    color: Constanst.fgBorder,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 30,
                          child: TextLabell(
                              text: "JKM",
                              color: Constanst.fgPrimary,
                              weight: FontWeight.w500,
                              size: 16),
                        ),
                        Expanded(
                            flex: 35,
                            child: TextGroupColumn2(
                                title: toCurrency(data.jkmTk),
                                subtitle: "TK (${data.jkmTkPercent}%)")),
                        Expanded(
                          flex: 35, child: Container(),
                          // child: TextGroupColumn2(
                          //     title: "Rp.2000m,00", subtitle: "TK (1%)")
                        )
                      ],
                    ),
                  ),
                  Divider(
                    height: 0,
                    thickness: 1,
                    color: Constanst.fgBorder,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 30,
                          child: TextLabell(
                              text: "JHT",
                              color: Constanst.fgPrimary,
                              weight: FontWeight.w500,
                              size: 16),
                        ),
                        Expanded(
                            flex: 35,
                            child: TextGroupColumn2(
                                title: toCurrency(data.jhtPt),
                                subtitle: "PT (${data.jhtPtPercent}%)")),
                        Expanded(
                            flex: 35,
                            child: TextGroupColumn2(
                                title: toCurrency(data.jhtTk),
                                subtitle: "TK (${data.jhtTkPercent}%)")),
                        // Expanded(
                        //     flex: 30,
                        //     child: TextGroupColumn2(
                        //         title: "TK (1%)", subtitle: "Rp.2000m,00"))
                      ],
                    ),
                  ),
                  Divider(
                    height: 0,
                    thickness: 1,
                    color: Constanst.fgBorder,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 30,
                          child: TextLabell(
                              text: "JP",
                              color: Constanst.fgPrimary,
                              weight: FontWeight.w500,
                              size: 16),
                        ),
                        Expanded(
                            flex: 35,
                            child: TextGroupColumn2(
                                title: toCurrency(data.jppPt),
                                subtitle: "PT (${data.jppPtPercent}%)")),
                        Expanded(
                            flex: 35,
                            child: TextGroupColumn2(
                                title: toCurrency(data.jppTk),
                                subtitle: "TK (${data.jppTkPercent}%)")),
                        // Expanded(
                        //     flex: 30,
                        //     child: TextGroupColumn2(
                        //         title: "TK (1%)", subtitle: "Rp.2000m,00"))
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
