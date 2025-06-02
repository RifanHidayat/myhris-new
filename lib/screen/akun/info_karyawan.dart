// ignore_for_file: deprecated_member_use
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_operasional/controller/setting_controller.dart';
import 'package:siscom_operasional/screen/chatting/chat.dart';
import 'package:siscom_operasional/screen/chatting/chat_page.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/appbar_widget.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:web_socket_channel/io.dart';



class InfoKaryawan extends StatefulWidget {
  const InfoKaryawan({super.key});

  @override
  State<InfoKaryawan> createState() => _InfoKaryawanState();
}

class _InfoKaryawanState extends State<InfoKaryawan> {
  @override
   final controller = Get.put(SettingController());

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller. getUserInfo();
  }  

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
        title: Obx(() {
          if (controller.isSearching.value) {
            return SizedBox(
              height: 40,
              child: TextFormField(
                controller: controller.searchController,
                // onFieldSubmitted: (value) {
                // controller.report();
                // },
                onChanged: (value) {
                  controller.pencarianNamaKaryawan(value);
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
                    contentPadding: const EdgeInsets.only(left: 20, right: 20),
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
              "Info Karyawan",
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
          () => IconButton(
            icon: Icon(
              Iconsax.arrow_left,
              color: Constanst.fgPrimary,
              size: 24,
            ),
            onPressed: controller.isSearching.value
                ? controller.toggleSearch
                : Get.back,
            // onPressed: () {
            //   controller.cari.value.text = "";
            //   Get.back();
            // },
          ),
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
                  // const SizedBox(height: 16),
                  // pencarianData(),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Text(
                        //   controller.namaDepartemenTerpilih.value,
                        //   style: GoogleFonts.inter(
                        //       fontSize: 16,
                        //       fontWeight: FontWeight.w500,
                        //       color: Constanst.fgPrimary),
                        // ),
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
                                child: Text(controller.loading.value+'2'),
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
                          fontSize: 12.0,
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
            var emId = controller.infoEmployee.value[index]['em_id'];

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
                              ? Expanded(
                                  flex: 15,
                                  child: SvgPicture.asset(
                                    'assets/avatar_default.svg',
                                    width: 50,
                                    height: 50,
                                  ),
                                )
                              : Expanded(
                                  flex: 15,
                                  child: CircleAvatar(
                                    radius: 25,
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
                                            Container(
                                          color: Colors.white,
                                          child: SvgPicture.asset(
                                            'assets/avatar_default.svg',
                                            width: 50,
                                            height: 50,
                                          ),
                                        ),
                                        fit: BoxFit.cover,
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                  ),
                                ),
                          Expanded(
                            flex: 60,
                            child: Padding(
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
                                        fontSize: 12,
                                        color: Constanst.fgSecondary,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                            ),
                          ),
                          // Expanded(
                          //     flex: 15,
                          //     child: InkWell(
                          //       onTap: () {
                          //         // chattingCtr.emIdUser.value=emId.toString();
                          //         // Get.to(ChattingPage(title: title,fullName: full_name,image: image,em_id:emId ,));
                          //         Get.to(
                          //           ChatPage(
                          //             webSocketChannel:
                          //                 IOWebSocketChannel.connect(
                          //                     Uri.parse(Api.webSocket)),
                          //             fullNamePenerima: full_name,
                          //             emIdPengirim:
                          //                 AppData.informasiUser![0].em_id,
                          //             emIdPenerima: emId,
                          //             imageProfil: image,
                          //             title: title,
                          //           ),
                          //         );
                          //         print(AppData.informasiUser![0].em_id);
                          //         print(full_name);
                          //         print(emId);
                          //         print(image);
                          //       },
                          //       child: const Align(
                          //           alignment: Alignment.centerRight,
                          //           child: Icon(Iconsax.message)),
                          //     ))
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
