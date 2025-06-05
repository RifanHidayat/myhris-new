import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/pengumuman_controller.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';

class DetailPolling extends StatelessWidget {
  final String title;
  final String create;
  final String desc;
  final String idPertanyaan;
  final String pertanyaaan;
  final String endDate;

  DetailPolling(
      {required this.title,
      required this.create,
      required this.desc,
      required this.idPertanyaan,
      required this.pertanyaaan,
      required this.endDate});

  var controller = Get.put(PengumumanController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constanst.colorWhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Iconsax.arrow_left, color: Constanst.fgPrimary, size: 24),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          "$title",
          style: GoogleFonts.inter(
            color: Constanst.fgPrimary,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: Container(
          padding: EdgeInsets.all(16),
          child: Obx(() {
            return controller.isLoadingPolling.value == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView(
                    children: [
                      SizedBox(height: 30),

                      Text(
                        Constanst.convertDate(create),
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Constanst.fgSecondary,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Constanst.infoLight1,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                width: 1, color: Constanst.infoLight)),
                        child: Padding(
                          padding: EdgeInsets.only(top: 12, bottom: 12),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 10,
                                  child: Icon(
                                    Iconsax.info_circle,
                                    color: Constanst.infoLight,
                                  )),
                              Expanded(
                                flex: 80,
                                child: TextLabell(
                                  text:
                                      "Polling ini akan berakhir  pada tanggal ${DateFormat('dd MMMM yyyy').format(DateTime.parse(endDate))} 23:59:00",
                                  color: Constanst.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 16,
                      ),
                      TextLabell(
                        text: pertanyaaan,
                        size: 18,
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: 12, right: 12, top: 12),
                        child: Column(
                            children: List.generate(
                          controller.pollingList.length,
                          (index) {
                            var data = controller.pollingList[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 14),
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1, color: Constanst.Secondary),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 70,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextLabell(
                                              text: data['name'],
                                              size: 14,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                controller
                                                    .getEmployee(data['id'])
                                                    .then((value) {
                                                  if (value == true) {
                                                    showBottomEmployee(context);
                                                  } else {
                                                    UtilsAlert.showToast(
                                                        "Data tidak tersedia");
                                                  }
                                                });
                                              },
                                              child: Row(
                                                children: [
                                                  TextLabell(
                                                    text:
                                                        "${data['total_karyawan']} Karyawan",
                                                    size: 11,
                                                    color: Constanst.Secondary,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 12,
                                                    color: Constanst.Secondary,
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        )),
                                    Expanded(
                                        flex: 30,
                                        child: Obx(() {
                                          return data['id'].toString() ==
                                                  controller.idPolling
                                                      .toString()
                                              ? Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Icon(
                                                    Icons.check,
                                                    color: Colors.green,
                                                  ))
                                              : InkWell(
                                                  onTap: () {
                                                    controller.savdPolling(
                                                        idPertanyaan:
                                                            idPertanyaan,
                                                        idPolling: data['id']);
                                                  },
                                                  child: Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: TextLabell(
                                                          text: "Pilih")),
                                                );
                                        }))
                                  ],
                                ),
                              ),
                            );
                          },
                        )),
                      )
                      // SizedBox(height: 6),
                      // HtmlWidget(
                      //   """
                      //   <p style='font-size: 16px; text-align: justify;'>
                      //     ${desc}
                      //   </p>
                      //   """,
                      // ),
                    ],
                  );
          })),
    );
  }

  void showBottomEmployee(BuildContext context) {
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
                        "Karyawan",
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
                SizedBox(
                  height: 12,
                ),
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Obx(() => Column(
                        children:
                            List.generate(controller.employees.length, (index) {
                          var nama = controller.employees[index]['full_name'];
                          var em_id = controller.employees[index]['em_id'];
                          return InkWell(
                            onTap: () {
                              // controller.changeTypeAjuan(controller
                              //     .dataTypeAjuan.value[index]['nama']);

                              // controller.tempNamaStatus1.value = namaType;
                              // Get.back();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                bottom: 12,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const SizedBox(width: 16),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            em_id,
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: Constanst.fgPrimary,
                                            ),
                                          ),
                                          Text(
                                            nama,
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: Constanst.fgPrimary,
                                            ),
                                          ),
                                          Divider(color: Constanst.radiusColor)
                                        ],
                                      ),
                                    ],
                                  ),
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
}
