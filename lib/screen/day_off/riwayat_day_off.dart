import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../controller/dashboard_controller.dart';
import '../../controller/day_off_controller.dart';
import '../../utils/constans.dart';

class RiwayatDayOff extends StatefulWidget {
  const RiwayatDayOff({super.key});

  @override
  State<RiwayatDayOff> createState() => _RiwayatDayOffState();
}

class _RiwayatDayOffState extends State<RiwayatDayOff> {
  var controller = Get.put(DayOffController());
  final dashboardController = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                  controller.loadDataAjuanDayOff();
                                },
                              ),
                            )),
                      ),
                    )
                  : Text(
                      "Riwayat Day Off",
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
                          // Search Icon
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

                          // Laporan DayOff
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
                                          onPressed: () {
                                            // Get.to(
                                            //   LaporanIzin(
                                            //     title: 'tidak_hadir',
                                            //   ),
                                            // );
                                          }
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
    );
  }
}
