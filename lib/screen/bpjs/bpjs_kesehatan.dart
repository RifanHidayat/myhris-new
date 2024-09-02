import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
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

class BpjsKesehatan extends StatelessWidget {
  BpjsKesehatan({super.key});

  var controller = Get.put(BpjsController());

  @override
  Widget build(BuildContext context) {
    controller.bulanKeseehatan.value = DateTime.now().month.toString();
    controller.tahunKesehatan.value = DateTime.now().year.toString();
    controller.fetchBpjsKesehatan();
    return Scaffold(
      backgroundColor: Constanst.colorWhite,
      appBar: AppBar(
        backgroundColor: Constanst.colorWhite,
        elevation: 0,
        leadingWidth: 50,
        titleSpacing: 0,
        centerTitle: true,
        title: Text(
          "BPJS Kesehatan",
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
                                  int.parse(controller.tahunKesehatan.value),
                                  int.parse(controller.bulanKeseehatan.value),
                                  1),
                            ),
                            onConfirm: (time) {
                              if (time != null) {
                                print("$time");
                                var filter = DateFormat('yyyy-MM').format(time);
                                var array = filter.split('-');
                                var bulan = array[1];
                                var tahun = array[0];
                                controller.bulanKeseehatan.value =
                                    bulan.toString();
                                controller.tahunKesehatan.value =
                                    tahun.toString();
                                controller.fetchBpjsKesehatan();
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
                                      "${controller.bulanKeseehatan.value}-${controller.tahunKesehatan.value}"),
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
                if (controller.bpjsKesehatan.isEmpty) {
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
                if (controller.isLoadingBpjsKesehatan.value == true) {
                  return const Center(
                    heightFactor: 17,
                    child: CircularProgressIndicator(),
                  );
                }

                return Expanded(
                  child: SizedBox(
                    height: double.maxFinite,
                    child: SingleChildScrollView(
                      child: Column(
                        // children: List.generate(controller.bpjsKesehatan.length,
                        children: List.generate(1, (index) {
                          return _list(index);
                        }),
                      ),
                    ),
                  ),
                );
              }),
            ],
          )),
    );
  }

  Widget _list(index) {
    var data = controller.bpjsKesehatan[index];
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
            color: Constanst.infoLight,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 7.0,
                spreadRadius: 3.5,
              ),
            ],
            borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
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
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextLabell(
                        text: "${AppData.informasiUser![0].full_name}",
                        size: 16,
                        weight: FontWeight.w500,
                        color: Constanst.colorWhite,
                      ),
                      const SizedBox(height: 4),
                      TextLabell(
                        text:
                            "No JKN. ${AppData.informasiUser![0].nomorBpjsKesehatan}",
                        // text: "No JKN. ",
                        size: 14,
                        weight: FontWeight.w400,
                        color: Constanst.colorNeutralBgTertiary,
                      )
                    ],
                  )
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Constanst.colorWhite,
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      flex: 30,
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 12.0, 0.0, 12.0),
                        child: TextGroupColumn(
                            title: "Premi ${data.premi_percent}%",
                            subtitle: toCurrency(data.premit.toString())),
                      )),
                  Container(
                    color: Constanst.fgBorder,
                    width: 1,
                    height: 64,
                  ),
                  Expanded(
                      flex: 30,
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 12.0, 0.0, 12.0),
                        child: TextGroupColumn(
                            title: "PT ${data.pt_percent}%",
                            subtitle: toCurrency(data.pt.toString())),
                      )),
                  Container(
                    color: Constanst.fgBorder,
                    width: 1,
                    height: 64,
                  ),
                  Expanded(
                      flex: 30,
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 12.0, 0.0, 12.0),
                        child: TextGroupColumn(
                            title: "TK ${data.tk_percent}%",
                            subtitle: toCurrency(data.tk.toString())),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
