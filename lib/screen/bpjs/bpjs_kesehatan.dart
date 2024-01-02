import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/bpjs.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/helper.dart';
import 'package:siscom_operasional/utils/month_year_picker.dart';
import 'package:siscom_operasional/utils/widget/appbar.dart';
import 'package:siscom_operasional/utils/widget/text_group_column.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BpjsKesehatan extends StatelessWidget {
  BpjsKesehatan({super.key});

  var controller = Get.put(BpjsController());

  @override
  Widget build(BuildContext context) {
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
      body: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              // Obx(() {
              // return
              // Padding(
              //   padding: const EdgeInsets.only(
              //       left: 16, right: 16, top: 10, bottom: 10),
              //   child: InkWell(
              //     onTap: () {
              //       DatePicker.showPicker(
              //         Get.context!,
              //         pickerModel: CustomMonthPicker(
              //           minTime: DateTime(2020, 1, 1),
              //           maxTime: DateTime(2050, 1, 1),
              //           currentTime: DateTime.now(),
              //         ),
              //         onConfirm: (time) {
              //           if (time != null) {
              //             print("$time");
              //             var filter = DateFormat('yyyy-MM').format(time);
              //             var array = filter.split('-');
              //             var bulan = array[1];
              //             var tahun = array[0];
              //             // controller.bulanKeseehatan.value = bulan.toString();
              //             // controller.tahunKesehatan.value = tahun.toString();
              //             // controller.fetchBpjsKesehatan();
              //             ;
              //           }
              //         },
              //       );
              //     },
              //     child: Container(
              //       decoration: BoxDecoration(
              //           borderRadius: Constanst.borderStyle2,
              //           border: Border.all(color: Constanst.colorText2)),
              //       child: Padding(
              //         padding: EdgeInsets.all(8.0),
              //         child: Row(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             const Icon(
              //               Iconsax.calendar_1,
              //               size: 16,
              //             ),
              //             Flexible(
              //               child: Padding(
              //                 padding: EdgeInsets.only(left: 8),
              //                 // child: Text(
              //                 //   "${Constanst.convertDateBulanDanTahun("${controller.bulanKeseehatan.value}-${controller.tahunKesehatan.value}")}",
              //                 //   overflow: TextOverflow.ellipsis,
              //                 // ),
              //               ),
              //             )
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // }),
              Obx(() {
                if (controller.isLoadingBpjsKesehatan.value == true) {
                  return Container(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                // if (controller.bpjsKesehatan.isEmpty) {
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
                return Expanded(
                  child: SizedBox(
                    height: double.maxFinite,
                    child: SingleChildScrollView(
                      child: Column(
                        // children: List.generate(controller.bpjsKesehatan.length,
                        children: List.generate(1,
                            (index) {
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
    //var data = controller.bpjsKesehatan[index];
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
                        size: 24,
                      ),
                    ),
                    // : Center(
                    //     child: CircleAvatar(
                    //       radius: 20,
                    //       child: ClipOval(
                    //         child: ClipOval(
                    //           child: CachedNetworkImage(
                    //             imageUrl: "${Api.UrlfotoProfile}$image",
                    //             progressIndicatorBuilder:
                    //                 (context, url, downloadProgress) =>
                    //                     Container(
                    //               alignment: Alignment.center,
                    //               height:
                    //                   MediaQuery.of(context).size.height *
                    //                       0.5,
                    //               width: MediaQuery.of(context).size.width,
                    //               child: CircularProgressIndicator(
                    //                   value: downloadProgress.progress),
                    //             ),
                    //             errorWidget: (context, url, error) =>
                    //                 Container(
                    //               color: Colors.white,
                    //               child: SvgPicture.asset(
                    //                 'assets/avatar_default.svg',
                    //                 width: 40,
                    //                 height: 40,
                    //               ),
                    //             ),
                    //             fit: BoxFit.cover,
                    //             width: 40,
                    //             height: 40,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextLabell(
                        // text: data.fullName,
                         text: AppData.informasiUser![0].full_name,
                        // text: "Nama Pengguna",
                        size: 16,
                        weight: FontWeight.w500,
                        color: Constanst.colorWhite,
                      ),
                      const SizedBox(height: 4),
                      TextLabell(
                        text: "No JKN. 123123123",
                         // text: "No JKN. ${data.emBpjsKesehatan}",
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
                  const Expanded(
                      flex: 30,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16.0, 12.0, 0.0, 12.0),
                        child: TextGroupColumn(
                            title: "premi 5%", subtitle: "Rp.2000m,00"),
                      )),
                  Container(
                    color: Constanst.fgBorder,
                    width: 1,
                    height: 64,
                  ),
                  const Expanded(
                      flex: 30,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16.0, 12.0, 0.0, 12.0),
                        child: TextGroupColumn(
                            title: "PT  (4%)", subtitle: "Rp.2000m,00"),
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
                            title: "TK(1%)",
                            subtitle: toCurrency(1)),
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
