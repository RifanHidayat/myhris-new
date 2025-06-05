import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siscom_operasional/controller/monitoring_controller.dart';
import 'package:siscom_operasional/screen/monitoring/monitoring_absen_terlambat.dart';
import 'package:siscom_operasional/screen/monitoring/monitoring_cuti.dart';
import 'package:siscom_operasional/screen/monitoring/monitoring_izin.dart';
import 'package:siscom_operasional/screen/monitoring/monitoring_pulang_cepat.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Monitoring extends StatefulWidget {
  @override
  State<Monitoring> createState() => _MonitoringState();
}

class _MonitoringState extends State<Monitoring> {
  var controller = Get.put(MonitoringController());

  @override
  void initState() {
    controller.getTimeNow();
    controller.getMonitor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constanst.colorWhite,
        elevation: 0,
        leadingWidth: 50,
        titleSpacing: 0,
        centerTitle: true,
        title: const Text("Monitoring"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                status(),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => Get.to(monitoringIzin(
                    em_id: controller.emId.value.toString(),
                    // bulan: controller.bulanDanTahunNow.value,
                    full_name: controller.tempNamaStatus1.value.toString(),
                  )),
                  child: _buildMonitoringCardWithImage(
                      "assets/3_izin.svg", 'Izin', Colors.white, Colors.black),
                ),
                const SizedBox(width: 20),
                InkWell(
                  onTap: () => Get.to(monitoringPulangCepat(
                    em_id: controller.emId.value.toString(),
                    // bulan: controller.bulanDanTahunNow.value,
                    full_name: controller.tempNamaStatus1.value.toString(),
                  )),
                  child: _buildMonitoringCardWithImage('assets/2_absen.svg',
                      'Pulang cepat', Colors.white, Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => Get.to(monitoringAbsenTerlambat(
                    em_id: controller.emId.value.toString(),
                    // bulan: controller.bulanDanTahunNow.value,
                    full_name: controller.tempNamaStatus1.value.toString(),
                  )),
                  child: _buildMonitoringCardWithImage('assets/2_absen.svg',
                      'Absen telat', Colors.white, Colors.black),
                ),
                const SizedBox(width: 20),
                InkWell(
                  onTap: () => Get.to(monitoringCuti(
                    em_id: controller.emId.value.toString(),
                    full_name: controller.tempNamaStatus1.value.toString(),
                  ),),
                  child: _buildMonitoringCardWithImage(
                      'assets/5_cuti.svg', 'Cuti', Colors.white, Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMonitoringCardWithImage(
      String assetPath, String title, Color backgroundColor, Color textColor) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        border: Border.all(
          color: Constanst.fgBorder,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(15),
        color: backgroundColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            assetPath,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
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
      isScrollControlled: true, // Ini memastikan modal bisa di-scroll
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6, // Ukuran awal modal sheet
          minChildSize: 0.4, // Ukuran minimum modal sheet
          maxChildSize: 0.9, // Ukuran maksimal modal sheet
          expand: false,
          builder: (context, scrollController) {
            return SafeArea(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            onTap: () => Navigator.pop(context),
                            child: Icon(
                              Icons.close,
                              size: 26,
                              color: Constanst.fgSecondary,
                            ),
                          ),
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
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController, // Controller untuk scroll
                        // physics: const BouncingScrollPhysics(),
                        child: Obx(() {
                          return Column(
                            children: List.generate(
                                controller.monitoringList.length, (index) {
                              var full_name =
                                  controller.monitoringList[index].full_name;
                              var isSelected =
                                  controller.tempNamaStatus1.value == full_name;
                              return InkWell(
                                onTap: () {
                                  controller.tempNamaStatus1.value = full_name;
                                  controller.emId.value =
                                      controller.monitoringList[index].em_id;
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 16, 16, 16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const SizedBox(width: 20),
                                          Text(
                                            full_name.toString(),
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: Constanst.fgPrimary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: isSelected ? 2 : 1,
                                            color: isSelected
                                                ? Constanst.onPrimary
                                                : Constanst.onPrimary
                                                    .withOpacity(0.5),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: isSelected
                                            ? Container(
                                                decoration: BoxDecoration(
                                                  color: Constanst.onPrimary,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              )
                                            : null,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((value) {
      // print('Bottom sheet closed');
    });
  }

  Widget status() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(100)),
        border: Border.all(color: Constanst.fgBorder),
      ),
      child: InkWell(
        customBorder: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(100))),
        onTap: () {
          if (controller.monitoringList.isEmpty) {
            // Get.snackbar("Error", "Data tidak tersedia.");
          } else {
            showBottomStatus(Get.context!);
            // Get.snackbar("${controller.monitoringList.length}", "ddd");
            const CircularProgressIndicator();
          }
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Text(
                  "${controller.tempNamaStatus1}",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Constanst.fgSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 16),
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
}