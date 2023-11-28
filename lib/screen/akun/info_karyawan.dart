// ignore_for_file: deprecated_member_use
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_operasional/controller/setting_controller.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/appbar_widget.dart';
import 'package:siscom_operasional/utils/constans.dart';

class InfoKaryawan extends StatelessWidget {
  final controller = Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constanst.coloBackgroundScreen,
      // appBar: AppBar(
      //     backgroundColor: Constanst.colorPrimary,
      //     elevation: 2,
      //     flexibleSpace: AppbarMenu1(
      //       title: "Info Karyawan",
      //       colorTitle: Colors.white,
      //       colorIcon: Colors.transparent,
      //       icon: 1,
      //       onTap: () {
      //         controller.cari.value.text = "";
      //         Get.back();
      //       },
      //     )),
      appBar: AppBar(
        backgroundColor: Constanst.colorWhite,
        elevation: 0,
        leadingWidth: 50,
        titleSpacing: 0,
        centerTitle: true,
        title: Text(
          "Info Karyawan",
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
            controller.cari.value.text = "";
            Get.back();
          },
        ),
      ),
      body: WillPopScope(
          onWillPop: () async {
            controller.cari.value.text = "";
            Get.back();
            return true;
          },
          child: SafeArea(
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  formDepartemen(),
                  const SizedBox(height: 16),
                  pencarianData(),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          controller.namaDepartemenTerpilih.value,
                          style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Constanst.fgPrimary),
                        ),
                        Text("${controller.jumlahData.value} Karyawan",
                            style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Constanst.fgSecondary)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: controller.statusLoadingSubmitLaporan.value
                        ? Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Constanst.colorPrimary,
                            ),
                          )
                        : controller.infoEmployee.value.isEmpty
                            ? Center(
                                child: Text(controller.loading.value),
                              )
                            : infoEmployeeList(),
                  )
                ],
              ),
            ),
          )),
    );
  }

  Widget pencarianData() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: Constanst.borderStyle5,
            border: Border.all(color: Constanst.colorNonAktif)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Expanded(
              flex: 15,
              child: Padding(
                padding: EdgeInsets.only(top: 7, left: 10),
                child: Icon(Iconsax.search_normal_1),
              ),
            ),
            Expanded(
              flex: 85,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    controller: controller.cari.value,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Cari nama karyawan"),
                    style: GoogleFonts.inter(
                        fontSize: 14.0, height: 1.0, color: Colors.black),
                    onChanged: (value) {
                      controller.pencarianNamaKaryawan(value);
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget formDepartemen() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            onTap: () {
              controller.showDataDepartemenAkses('semua');
            },
            child: Container(
              decoration: BoxDecoration(
                // color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: Constanst.fgBorder, // Border color
                  width: 1, // Border width
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Row(
                  children: [
                    Text(
                      controller.departemen.value.text,
                      style: GoogleFonts.inter(
                          fontSize: 14.0,
                          color: Constanst.fgSecondary,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Iconsax.arrow_down_14,
                      size: 16,
                      color: Constanst.fgSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget infoEmployeeList() {
    return Obx(
      () => ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: controller.infoEmployee.value.length,
          itemBuilder: (context, index) {
            var full_name = controller.infoEmployee.value[index]['full_name'];
            var image = controller.infoEmployee.value[index]['em_image'];
            var title = controller.infoEmployee.value[index]['job_title'];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          image == ""
                              ? Image.asset(
                                  'assets/avatar_default.png',
                                  width: 50,
                                  height: 50,
                                )
                              : CircleAvatar(
                                  radius: 25,
                                  child: ClipOval(
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: "${Api.UrlfotoProfile}$image",
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                Container(
                                          alignment: Alignment.center,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.5,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          'assets/avatar_default.png',
                                          width: 50,
                                          height: 50,
                                        ),
                                        fit: BoxFit.cover,
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                  ),
                                ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "$full_name",
                                  style: GoogleFonts.inter(
                                      fontSize: 16,
                                      color: Constanst.fgPrimary,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "$title",
                                  style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: Constanst.fgSecondary,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
                      Divider(
                        height: 0,
                        thickness: 1,
                        color: Constanst.fgBorder,
                      )
                    ],
                  ),
                )
              ],
            );
          }),
    );
  }
}
