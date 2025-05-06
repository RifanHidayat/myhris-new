// ignore_for_file: deprecated_member_use
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_operasional/controller/dashboard_controller.dart';
import 'package:siscom_operasional/controller/global_controller.dart';
import 'package:siscom_operasional/screen/absen/absen_masuk_keluar.dart';
import 'package:siscom_operasional/screen/detail_informasi.dart';
import 'package:siscom_operasional/screen/init_screen.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';
import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart' as dom;

class Informasi extends StatelessWidget {
  final index;
  Informasi({this.index});
  final controller = Get.put(DashboardController());
  var controllerGlobal = Get.put(GlobalController());

  @override
  Widget build(BuildContext context) {
    print("index${index}");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.selectedInformasiView.value = index ?? 0;
      controller.informasiController.jumpToPage(index ?? 0);
      controller.selectedInformasiView.refresh();
    });

    return Scaffold(
      backgroundColor: Constanst.coloBackgroundScreen,
      // appBar: AppBar(
      //     backgroundColor: Constanst.colorPrimary,
      //     elevation: 2,
      //     flexibleSpace: AppbarMenu1(
      //       title: "Informasi",
      //       colorTitle: Colors.white,
      //       colorIcon: Colors.white,
      //       icon: 1,
      //       onTap: () {
      //         Get.offAll(InitScreen());
      //       },
      //     )),
      appBar: AppBar(
          backgroundColor: Constanst.colorWhite,
          elevation: 0,
          leadingWidth: 50,
          titleSpacing: 0,
          centerTitle: false,
          title: Obx(() {
            if (controller.isSearching.value) {
              return SizedBox(
                height: 40,
                child: TextFormField(
                  controller: controller.searchController,
                  onFieldSubmitted: (value) {
                    // controller.report();
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
                        padding: const EdgeInsets.only(left: 16.0, right: 8),
                        child: IconButton(
                          icon: Icon(
                            Iconsax.close_circle5,
                            color: Constanst.fgSecondary,
                            size: 24,
                          ),
                          padding: EdgeInsets.zero,
                          onPressed: controller.clearText,
                        ),
                      )),
                ),
              );
            } else {
              return Text(
                "Informasi",
                style: GoogleFonts.inter(
                    color: Constanst.fgPrimary,
                    fontWeight: FontWeight.w500,
                    fontSize: 20),
              );
            }
          }),
          actions: [
            Obx(
              () => controller.isSearching.value
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
                      onPressed: controller.toggleSearch,
                    ),
            ),
          ],
          leading: Obx(
            () => controller.isSearching.value
                ? IconButton(
                    icon: Icon(
                      Iconsax.arrow_left,
                      color: Constanst.fgPrimary,
                      size: 24,
                    ),
                    onPressed: () {
                      controller.toggleSearch();
                    },
                  )
                : IconButton(
                    icon: Icon(
                      Iconsax.arrow_left,
                      color: Constanst.fgPrimary,
                      size: 24,
                    ),
                    onPressed: () {
                      Get.back();
                    },
                  ),
          )),
      body: WillPopScope(
          onWillPop: () async {
            Get.offAll(InitScreen());
            return true;
          },
          child: SafeArea(
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  lineTitle(),
                  Flexible(
                    flex: 3,
                    child: pageViewPesan(),
                  )
                ],
              ),
            ),
          )),
    );
  }

  Widget lineTitle() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              controller.selectedInformasiView.value = 0;
              controller.informasiController.jumpToPage(0);
              controller.selectedInformasiView.refresh();
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: controller.selectedInformasiView.value == 0
                          ? Constanst.colorPrimary
                          : Constanst.color6,
                      width: 3.0,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    "Informasi",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        color: controller.selectedInformasiView.value == 0
                            ? Constanst.colorPrimary
                            : Constanst.colorText2,
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              controller.selectedInformasiView.value = 1;
              controller.informasiController.jumpToPage(1);
              controller.selectedInformasiView.refresh();
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: controller.selectedInformasiView.value == 1
                          ? Constanst.colorPrimary
                          : Constanst.color6,
                      width: 2.0,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    "Ulang Tahun",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        color: controller.selectedInformasiView.value == 1
                            ? Constanst.colorPrimary
                            : Constanst.colorText2,
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              controller.selectedInformasiView.value = 2;
              controller.informasiController.jumpToPage(2);
              controller.selectedInformasiView.refresh();
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: controller.selectedInformasiView.value == 2
                          ? Constanst.colorPrimary
                          : Constanst.color6,
                      width: 2.0,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    "Tidak Hadir",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        color: controller.selectedInformasiView.value == 2
                            ? Constanst.colorPrimary
                            : Constanst.colorText2,
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  ),
                ),
              ),
            ),
          ),
        ),
        // !controller.viewInformasiSisaKontrak.value
        //     ? SizedBox()
        //     :
        Expanded(
          child: InkWell(
            onTap: () {
              controller.selectedInformasiView.value = 3;
              controller.informasiController.jumpToPage(3);
              controller.selectedInformasiView.refresh();
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: controller.selectedInformasiView.value == 3
                          ? Constanst.colorPrimary
                          : Constanst.color6,
                      width: 2.0,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    "Sisa Kontrak",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        color: controller.selectedInformasiView.value == 3
                            ? Constanst.colorPrimary
                            : Constanst.colorText2,
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget pageViewPesan() {
    return PageView.builder(
        physics: const BouncingScrollPhysics(),
        controller: controller.informasiController,
        onPageChanged: (index) {
          controller.selectedInformasiView.value = index;
          controller.selectedInformasiView.refresh();
        },
        // itemCount: !controller.viewInformasiSisaKontrak.value ? 3 : 4,
        itemCount: 4,
        itemBuilder: (context, index) {
          return Padding(
              padding: const EdgeInsets.all(0),
              child: index == 0
                  ? screenInformasi()
                  : index == 1
                      ? screenUltah(context)
                      : index == 2
                          ? screenTidakHadir()
                          : index == 3
                              ? screenSisaKontrak()
                              : const SizedBox());
        });
  }

  String parseHtmlString(String htmlString) {
    dom.Document document = htmlParser.parse(htmlString);
    String parsedString = parseNode(document.body!);
    return parsedString;
  }

  String parseNode(dom.Node node) {
    if (node.nodeType == dom.Node.TEXT_NODE) {
      return node.text!;
    } else if (node.nodeType == dom.Node.ELEMENT_NODE) {
      dom.Element element = node as dom.Element;
      StringBuffer buffer = StringBuffer();
      for (var child in element.nodes) {
        buffer.write(parseNode(child));
      }
      return buffer.toString();
    } else {
      return '';
    }
  }

  Widget screenInformasi() {
    return controller.informasiDashboard.value.isEmpty
        ? const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Tidak ada Informasi"),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: ListView.builder(
                itemCount: controller.informasiDashboard.value.length,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  var title =
                      controller.informasiDashboard.value[index]['title'];
                  var desc =
                      controller.informasiDashboard.value[index]['description'];
                  var create =
                      controller.informasiDashboard.value[index]['created_on'];

                  return InkWell(
                    onTap: () => Get.to(DetailInformasi(
                      title: title,
                      create: create,
                      desc: desc,
                    )),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, top: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            Constanst.convertDate("$create"),
                            textAlign: TextAlign.right,
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Constanst.fgSecondary),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "$title",
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Constanst.fgPrimary),
                          ),
                          Text(
                            parseHtmlString(desc.toString()),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Constanst.fgSecondary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Divider(
                            height: 0,
                            thickness: 1,
                            color: Constanst.fgBorder,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          );
  }

   Widget screenUltah(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; // Ambil lebar layar
    const crossAxisCount = 2; // Jumlah kolom
    const crossAxisSpacing = 12.0; // Spasi antar kolom
    final itemWidth =
        (screenWidth - (crossAxisSpacing * (crossAxisCount - 1))) /
            crossAxisCount; // Lebar item
    final itemHeight =
        itemWidth * 1.4; // Misalnya tinggi 20% lebih besar dari lebar
    final childAspectRatio = itemWidth / itemHeight; // Hitung rasio aspek
    return controller.employeeUltah.value.isEmpty
        ? const Center(
            child: Padding(
              padding: EdgeInsets.only(left: 30, right: 30, top: 24),
              child: Text(
                "Tidak ada karyawan yang berulang tahun pada bulan ini",
                textAlign: TextAlign.center,
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 24.0, left: 16, right: 16),
            child: GridView.builder(
              itemCount: controller.employeeUltah.value.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: childAspectRatio,
              ),
              itemBuilder: (context, index) {
                var fullname =
                    controller.employeeUltah.value[index]['full_name'];
                var jobtitle =
                    controller.employeeUltah.value[index]['job_title'];
                var tanggalLahir =
                    controller.employeeUltah.value[index]['em_birthday'];
                var nowa = controller.employeeUltah.value[index]['em_mobile'];
                var image = controller.employeeUltah.value[index]['em_image'];
                var listTanggalLahir = tanggalLahir.split('-');

                return Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Constanst.colorNeutralBgTertiary,
                        width: 1.0,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12))),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Constanst.infoLight,
                                    width: 2.0,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(100))),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Center(
                                  child: CircleAvatar(
                                    radius: 28,
                                    child: ClipOval(
                                      child: ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "${Api.UrlfotoProfile}$image",
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              Container(
                                            alignment: Alignment.center,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.5,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                            color: Colors.white,
                                            child: SvgPicture.asset(
                                              'assets/avatar_default.svg',
                                              width: 56,
                                              height: 56,
                                            ),
                                          ),
                                          fit: BoxFit.cover,
                                          width: 56,
                                          height: 56,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Text(
                            "$fullname",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Constanst.fgPrimary),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "$jobtitle ",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Constanst.fgSecondary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          Constanst.convertDateBulanDanHari(
                              '${listTanggalLahir[1]}-${listTanggalLahir[2]}'),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Constanst.fgSecondary),
                        ),
                        const SizedBox(height: 8),
                        Material(
                          color: Constanst.infoLight1,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          child: InkWell(
                            customBorder: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            onTap: () {
                              var message = "Selamat Ulang Tahun $fullname, ";
                              var nomorUltah = "$nowa";
                              controllerGlobal.kirimUcapanWa(
                                  message, nomorUltah);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 8.0),
                                  child: Text(
                                    "Beri ucapan 🎉",
                                    style: GoogleFonts.inter(
                                        fontSize: 14,
                                        color: Constanst.infoLight,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
  }

  Widget screenTidakHadir() {
    return controller.employeeTidakHadir.value.isEmpty
        ? const Center(
            child: Text(
              "Semua karyawan hadir pada hari ini",
              textAlign: TextAlign.center,
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 24.0, left: 16, right: 16),
            child: ListView.builder(
                itemCount: controller.employeeTidakHadir.value.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  var fullname =
                      controller.employeeTidakHadir.value[index]['full_name'];
                  var jobtitle =
                      controller.employeeTidakHadir.value[index]['job_title'];
                  var ket = controller.employeeTidakHadir.value[index]
                              ['ket_izin'] ==
                          null
                      ? "Tidak hadir/Belum absen"
                      : controller.employeeTidakHadir.value[index]
                                  ['ket_izin'] ==
                              1
                          ? "Lembur"
                          : controller.employeeTidakHadir.value[index]
                                      ['ket_izin'] ==
                                  2
                              ? "Tugas Luar"
                              : controller.employeeTidakHadir.value[index]
                                  ['ket_izin'];
                  var image =
                      controller.employeeTidakHadir.value[index]['em_image'];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Constanst.colorNeutralBgTertiary,
                            width: 1.0,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Constanst.infoLight,
                                        width: 2.0,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(100))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: image == ""
                                        ? SvgPicture.asset(
                                            'assets/avatar_default.svg',
                                            width: 40,
                                            height: 40,
                                          )
                                        : Center(
                                            child: CircleAvatar(
                                              radius: 20,
                                              child: ClipOval(
                                                child: ClipOval(
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        "${Api.UrlfotoProfile}$image",
                                                    progressIndicatorBuilder:
                                                        (context, url,
                                                                downloadProgress) =>
                                                            Container(
                                                      alignment:
                                                          Alignment.center,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.5,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: CircularProgressIndicator(
                                                          value:
                                                              downloadProgress
                                                                  .progress),
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
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
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "$fullname",
                                      style: GoogleFonts.inter(
                                          fontSize: 16,
                                          color: Constanst.fgPrimary,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "$jobtitle",
                                      style: GoogleFonts.inter(
                                          fontSize: 14,
                                          color: Constanst.fgSecondary,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Constanst.colorNeutralBgSecondary,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8))),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    8.0, 12.0, 0.0, 12.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Iconsax.calendar_tick5,
                                            color: Constanst.infoLight,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '$ket',
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                                color: Constanst.fgPrimary),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
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

  Widget screenSisaKontrak() {
    return controllerGlobal.employeeSisaCuti.value.isEmpty
        ? const Center(
            child: Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Text(
                "Tidak ada data",
                textAlign: TextAlign.center,
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 24.0, left: 16, right: 16),
            child: ListView.builder(
                itemCount: controllerGlobal.employeeSisaCuti.value.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  var emId =
                      controllerGlobal.employeeSisaCuti.value[index]['em_id'];
                  var fullname = controllerGlobal.employeeSisaCuti.value[index]
                      ['full_name'];
                  var deskripsi = controllerGlobal.employeeSisaCuti.value[index]
                      ['description'];
                  var beginDate = controllerGlobal.employeeSisaCuti.value[index]
                      ['begin_date'];
                  var endDate = controllerGlobal.employeeSisaCuti.value[index]
                      ['end_date'];
                  var remark =
                      controllerGlobal.employeeSisaCuti.value[index]['remark'];
                  var sisaCuti = controllerGlobal.employeeSisaCuti.value[index]
                      ['sisa_kontrak'];
                  var image = controllerGlobal.employeeSisaCuti.value[index]
                      ['em_image'];
                  var jobtitle = controllerGlobal.employeeSisaCuti.value[index]
                      ['job_title'];

                  var lamaBekerja = controllerGlobal
                      .employeeSisaCuti.value[index]['lama_bekerja'];
                  int days = int.parse(lamaBekerja == "" ||
                          lamaBekerja == "null" ||
                          lamaBekerja == null ||
                          lamaBekerja == ""
                      ? "0"
                      : lamaBekerja.toString());

                  int years = days ~/ 365;
                  int months = (days % 365) ~/ 30;
                  int remainingDays = (days % 365) % 30;

                  var remainingText = "";
                  if (years > 0) {
                    remainingText = "${years} Tahun ";
                  }
                  if (months > 0) {
                    remainingText += "${months} Bulan";
                  }

                  if (months > 0) {
                    remainingText += " $remainingDays Hari";
                  }

                  var emJoiningDate = controllerGlobal
                      .employeeSisaCuti.value[index]['lama_bekerja'];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Constanst.colorNeutralBgTertiary,
                            width: 1.0,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: image == ""
                                      ? SvgPicture.asset(
                                          'assets/avatar_default.svg',
                                          width: 42,
                                          height: 42,
                                        )
                                      : Center(
                                          child: CircleAvatar(
                                            radius: 21,
                                            child: ClipOval(
                                              child: ClipOval(
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      "${Api.UrlfotoProfile}$image",
                                                  progressIndicatorBuilder:
                                                      (context, url,
                                                              downloadProgress) =>
                                                          Container(
                                                    alignment: Alignment.center,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.5,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child:
                                                        CircularProgressIndicator(
                                                            value:
                                                                downloadProgress
                                                                    .progress),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Container(
                                                    color: Colors.white,
                                                    child: SvgPicture.asset(
                                                      'assets/avatar_default.svg',
                                                      width: 40,
                                                      height: 40,
                                                    ),
                                                  ),
                                                  fit: BoxFit.cover,
                                                  width: 42,
                                                  height: 42,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "$fullname",
                                      style: GoogleFonts.inter(
                                          fontSize: 16,
                                          color: Constanst.fgPrimary,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "$deskripsi",
                                      style: GoogleFonts.inter(
                                          fontSize: 14,
                                          color: Constanst.fgSecondary,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // Text(
                            //   "$sisaCuti Hari",
                            //   style: GoogleFonts.inter(
                            //       fontSize: 12, color: Constanst.colorText2),
                            // ),
                            // Text(
                            //   "$deskripsi",
                            //   style:
                            //       GoogleFonts.inter(color: Constanst.colorText2),
                            // ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Constanst.colorNeutralBgSecondary,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8))),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    8.0, 4.0, 8.0, 4.0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/lama_bekerja.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Lama Bekerja",
                                                style: GoogleFonts.inter(
                                                    fontSize: 14,
                                                    color:
                                                        Constanst.fgSecondary,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),

                                              // TextLabell(
                                              //   text: "${remainingText} ",
                                              //   weight: FontWeight.bold,
                                              //   color:
                                              //       Constanst.fgPrimary,
                                              // ),
                                              RichText(
                                                overflow: TextOverflow
                                                    .ellipsis, // Menambahkan elipsis jika teks melebihi satu baris
                                                maxLines:
                                                    1, // Memastikan hanya satu baris yang ditampilkan
                                                text: TextSpan(
                                                  text: remainingText,
                                                  style: GoogleFonts.inter(
                                                      fontSize: 14,
                                                      color:
                                                          Constanst.fgPrimary,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  children: <TextSpan>[],
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 12.0, right: 12),
                                        child: Container(
                                          color:
                                              Constanst.colorNeutralBgTertiary,
                                          width: 1,
                                          height: 24,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/waktu_tersisa.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Waktu Tersisa",
                                                style: GoogleFonts.inter(
                                                    fontSize: 14,
                                                    color:
                                                        Constanst.fgSecondary,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Text(
                                                "$sisaCuti Hari",
                                                style: GoogleFonts.inter(
                                                    fontSize: 14,
                                                    color: Constanst.fgPrimary,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 12.0, right: 12),
                                        child: Container(
                                          color:
                                              Constanst.colorNeutralBgTertiary,
                                          width: 1,
                                          height: 24,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/tanggal_berakhir.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Tanggal berakhir",
                                                style: GoogleFonts.inter(
                                                    fontSize: 14,
                                                    color:
                                                        Constanst.fgSecondary,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Text(
                                                Constanst.convertDate5(
                                                    '$endDate'),
                                                style: GoogleFonts.inter(
                                                    fontSize: 14,
                                                    color: Constanst.fgPrimary,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )
                                            ],
                                          )
                                        ],
                                      )
                                      // Expanded(
                                      //   flex: 5,
                                      //   child: Row(
                                      //     children: [
                                      //       Icon(
                                      //         Iconsax.calendar_tick5,
                                      //         color: Constanst.infoLight,
                                      //         size: 16,
                                      //       ),
                                      //       const SizedBox(width: 4),
                                      //       Text(
                                      //         Constanst.convertDate5(
                                      //             '$beginDate'),
                                      //         style: GoogleFonts.inter(
                                      //             fontWeight: FontWeight.w400,
                                      //             fontSize: 14,
                                      //             color: Constanst.fgPrimary),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),

                                      // Expanded(
                                      //   flex: 5,
                                      //   child: Row(
                                      //     children: [
                                      //       Icon(
                                      //         Iconsax.calendar_tick5,
                                      //         color: Constanst.infoLight,
                                      //         size: 16,
                                      //       ),
                                      //       const SizedBox(width: 4),
                                      //       Text(
                                      //         Constanst.convertDate5(
                                      //             '$beginDate'),
                                      //         style: GoogleFonts.inter(
                                      //             fontWeight: FontWeight.w400,
                                      //             fontSize: 14,
                                      //             color: Constanst.fgPrimary),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
                                      // Icon(
                                      //   Iconsax.arrow_right_1,
                                      //   color: Constanst.colorNeutralFgTertiary,
                                      //   size: 14,
                                      // ),
                                      // Expanded(
                                      //   flex: 5,
                                      //   child: Padding(
                                      //     padding:
                                      //         const EdgeInsets.only(left: 16.0),
                                      //     child: Row(
                                      //       children: [
                                      //         Icon(
                                      //           Iconsax.calendar_remove5,
                                      //           color: Constanst.color4,
                                      //           size: 16,
                                      //         ),
                                      //         const SizedBox(width: 4),
                                      //         Text(
                                      //           Constanst.convertDate5(
                                      //               '$endDate'),
                                      //           style: GoogleFonts.inter(
                                      //               fontWeight: FontWeight.w400,
                                      //               fontSize: 14,
                                      //               color: Constanst.fgPrimary),
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
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

  void moveeToAbsen() {
    Get.off(AbsenMasukKeluar());
  }
}
