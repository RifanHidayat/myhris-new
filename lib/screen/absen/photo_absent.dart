import 'package:draggable_bottom_sheet/draggable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_operasional/controller/absen_controller.dart';
import 'package:siscom_operasional/utils/constans.dart';

class PhotoAbsen extends StatelessWidget {
  var image, time, alamat, type, note;
  PhotoAbsen(
      {super.key, this.image, this.time, this.alamat, this.type, this.note});

  final controller = Get.put(AbsenController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constanst.coloBackgroundScreen,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight) * 1,
        child: Container(
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2.0),
              blurRadius: 4.0,
            )
          ]),
          child: AppBar(
            backgroundColor: Constanst.coloBackgroundScreen,
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Text(
              "Foto",
              style: GoogleFonts.inter(
                  color: Constanst.fgPrimary,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
            ),
            centerTitle: false,
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
        ),
      ),
      body: DraggableBottomSheet(
        useSafeArea: true,
        curve: Curves.easeIn,
        // minExtent: 50.0,
        collapsed: true,
        previewWidget: _previewWidget(),
        expandedWidget: _expandedWidget(),
        backgroundWidget: _backgroundWidget(),
        duration: const Duration(milliseconds: 10),
        // expansionExtent: 50.0,
        maxExtent: MediaQuery.of(context).size.height * 0.4,
        barrierColor: Colors.transparent,
        onDragging: (pos) {},
      ),
    );
  }

  Widget _backgroundWidget() {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: HexColor('#035446'),
            width: MediaQuery.of(Get.context!).size.width,
            height: double.maxFinite,
            child: image != ''
                ? Image.network(
                    image,
                    fit: BoxFit.fill,
                    errorBuilder: (context, exception, stackTrace) {
                      return ClipRRect(
                        child: Image.asset(
                          'assets/Foto.png',
                          fit: BoxFit.fitHeight,
                        ),
                      );
                    },
                  )
                : Image.asset(
                    'assets/Foto.png',
                    fit: BoxFit.fill,
                  ),
          ),
        )
      ],
    );
  }

  Widget _expandedWidget() {
    return MediaQuery.removePadding(
        context: Get.context!,
        removeTop: true,
        child: Obx(
          () => Container(
            width: MediaQuery.of(Get.context!).size.width,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16.0),
              ),
              color: Constanst.colorWhite,
            ),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Icon(
                          Iconsax.arrow_down_1,
                          size: 26,
                          color: Constanst.fgSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Constanst.border)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    time ?? '',
                                    style: GoogleFonts.inter(
                                        color: Constanst.fgPrimary,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    type == 'keluar'
                                        ? "Absen Keluar"
                                        : "Absen Masuk",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                        color: type == "keluar"
                                            ? Constanst.color4
                                            : Constanst.color5,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Divider(
                                thickness: 1,
                                height: 0,
                                color: Constanst.fgBorder,
                              ),
                              const SizedBox(height: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Tipe Absen",
                                    style: GoogleFonts.inter(
                                        color: Constanst.fgPrimary,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                  SizedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        'Foto',
                                        style: GoogleFonts.inter(
                                            color: Constanst.fgSecondary,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Lokasi",
                                    style: GoogleFonts.inter(
                                        color: Constanst.fgPrimary,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                  SizedBox(
                                    // width: gambarKeluar != ''
                                    //     ? MediaQuery.of(Get.context!).size.width / 2
                                    //     : MediaQuery.of(Get.context!).size.width - 80,
                                    child: Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          "$alamat",
                                          textAlign: TextAlign.justify,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines:
                                              controller.selengkapnyaMasuk.value
                                                  ? 100
                                                  : 2,
                                          style: GoogleFonts.inter(
                                              color: Constanst.fgSecondary,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14),
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: InkWell(
                                      onTap: () => controller
                                              .selengkapnyaMasuk.value
                                          ? controller.selengkapnyaMasuk.value =
                                              false
                                          : controller.selengkapnyaMasuk.value =
                                              true,
                                      child: Text(
                                        controller.selengkapnyaMasuk.value
                                            ? "Tutup"
                                            : "Selengkapnya",
                                        style: GoogleFonts.inter(
                                            color: Constanst.fgPrimary,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Catatan",
                                    style: GoogleFonts.inter(
                                        color: Constanst.fgPrimary,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                  SizedBox(
                                    // width: gambarMasuk != ''
                                    //     ? MediaQuery.of(Get.context!).size.width / 2
                                    //     : MediaQuery.of(Get.context!).size.width - 80,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        note == "" ? '-' : note,
                                        style: GoogleFonts.inter(
                                            color: Constanst.fgSecondary,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget _previewWidget() {
    return InkWell(
      onTap: () {
        print('object');
        _expandedWidget();
      },
      child: Container(
        width: MediaQuery.of(Get.context!).size.width,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color.fromARGB(127, 0, 0, 0),
        ),
        child: const Center(
          child: Icon(
            Iconsax.arrow_up_2,
            size: 26,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
