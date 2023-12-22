import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/bpjs.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/helper.dart';
import 'package:siscom_operasional/utils/month_year_picker.dart';
import 'package:siscom_operasional/utils/widget/appbar.dart';
import 'package:siscom_operasional/utils/widget/text_group_column.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';

class BpjsKetenagakerjaan extends StatelessWidget {
  BpjsKetenagakerjaan({super.key});
  var controller = Get.put(BpjsController());

  @override
  Widget build(BuildContext context) {
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
      body: Container(
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
                              currentTime: DateTime.now(),
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
                                ;
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
                                  "${Constanst.convertDateBulanDanTahun("${controller.bulanKetenagakerjaan.value}-${controller.tahunKetenagakerjaan.value}")}",
                                  style: GoogleFonts.inter(
                                      color: Constanst.fgSecondary,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                                SizedBox(width: 4),
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
              // Obx(() {
              // if (controller.isLoadingBpjsKetenagakerjaan.value == true) {
              //   return Expanded(
              //     child: Container(
              //       height: double.maxFinite,
              //       child: Center(child: CircularProgressIndicator()),
              //     ),
              //   );
              // }
              // if (controller.bpjsKetenagakerjaan.isEmpty) {
              //   return Expanded(
              //     child: Container(
              //       height: double.maxFinite,
              //       child: const Center(
              //         child: TextLabell(
              //           text: "Data tidak ditemukan",
              //         ),
              //       ),
              //     ),
              //   );
              // }
              // return
              SingleChildScrollView(
                child: Column(
                  // children: List.generate(   controller.bpjsKetenagakerjaan.length, (index) {
                  children: List.generate(1, (index) {
                    return _list(index);
                  }),
                ),
              )
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
              // }),
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
                    child:
                        // image == ""
                        //     ?
                        //     SvgPicture.asset(
                        //   'assets/avatar_default.svg',
                        //   width: 40,
                        //   height: 40,
                        // )
                        Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Iconsax.user,
                        color: Constanst.fgSecondary,
                        size: 26,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextLabell(
                          text: data.fullName,
                          // text: "Nama Penggguna",
                          color: Constanst.colorWhite,
                          weight: FontWeight.w500,
                          size: 16),
                      const SizedBox(height: 4),
                      TextLabell(
                          text: "No JKN. ${data.emBpjsTenagakerja}",
                          // text: "No JKN.  ",
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
                                title: toCurrency(data.jkk),
                                subtitle: "TK (1%)")),
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
                                title: toCurrency(data.jkm),
                                subtitle: "TK (4%)")),
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
                                title: toCurrency(data.jhtTk),
                                subtitle: "PT(4%)")),
                        const Expanded(
                            flex: 35,
                            child: TextGroupColumn2(
                                title: "Rp.2000m,00", subtitle: "TK(4%)")),
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
                                title: toCurrency(data.jpTk),
                                subtitle: "PT(2%)")),
                        const Expanded(
                            flex: 35,
                            child: TextGroupColumn2(
                                title: "Rp.2000m,00", subtitle: "TK(4%)")),
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
