import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_operasional/controller/dashboard_controller.dart';
import 'package:siscom_operasional/controller/setting_controller.dart';
import 'package:siscom_operasional/screen/akun/edit_personal_data.dart';
import 'package:siscom_operasional/screen/akun/setting.dart';
import 'package:siscom_operasional/screen/init_screen.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/appbar_widget.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/widget_textButton.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PersonalInfo extends StatelessWidget {
  final controller = Get.put(SettingController());
  final controllerDashboard = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Constanst.coloBackgroundScreen,
        // appBar: AppBar(
        //     backgroundColor: Colors.white,
        //     automaticallyImplyLeading: false,
        //     elevation: 2,
        //     flexibleSpace: AppbarMenu1(
        //       title: "Personal Info",
        //       icon: 1,
        //       colorTitle: Colors.black,
        //       onTap: () {
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
                "Personal Info",
                style: GoogleFonts.inter(
                    color: Constanst.fgPrimary,
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
              );
            }
          }),
          // actions: [
          //   Obx(
          //     () => controller.isSearching.value
          //         ? Padding(
          //             padding: const EdgeInsets.only(right: 16.0),
          //             child: Container(),
          //           )
          //         : IconButton(
          //             icon: Icon(
          //               Iconsax.search_normal_1,
          //               color: Constanst.fgPrimary,
          //               size: 24,
          //             ),
          //             onPressed: controller.toggleSearch,
          //           ),
          //   ),
          // ],
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
            ),
          ),
        ),
        body: WillPopScope(
          onWillPop: () async {
            Get.back();
            return true;
          },
          child: SizedBox(
            width: MediaQuery.of(Get.context!).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Constanst.fgBorder,
                          width: 1.0,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12))),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6.0, bottom: 12.0),
                      child: Center(
                        child: Column(
                          children: [
                            InkWell(
                              customBorder: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100))),
                              onTap: () {
                                controller.validasigantiFoto();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Stack(
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
                                        child: AppData.informasiUser![0]
                                                        .em_image ==
                                                    null ||
                                                AppData.informasiUser![0]
                                                        .em_image ==
                                                    ""
                                            ? SvgPicture.asset(
                                                'assets/avatar_default.svg',
                                                width: 56,
                                                height: 56,
                                              )
                                            : CircleAvatar(
                                                radius: 28,
                                                child: ClipOval(
                                                  child: ClipOval(
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          "${Api.UrlfotoProfile}${AppData.informasiUser![0].em_image}",
                                                      progressIndicatorBuilder:
                                                          (context, url,
                                                                  downloadProgress) =>
                                                              Container(
                                                        alignment:
                                                            Alignment.center,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.5,
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: CircularProgressIndicator(
                                                            value:
                                                                downloadProgress
                                                                    .progress),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
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
                                    Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: ClipOval(
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            color: Colors.white,
                                            child: ClipOval(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(3),
                                                color: Constanst.infoLight,
                                                child: const Icon(
                                                  Iconsax.edit_25,
                                                  size: 12,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "${AppData.informasiUser![0].full_name}",
                              style: GoogleFonts.inter(
                                  fontSize: 17,
                                  color: Constanst.fgPrimary,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${AppData.informasiUser![0].emp_jobTitle} • ${AppData.informasiUser![0].posisi} • ${AppData.informasiUser![0].em_status}",
                              style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Constanst.fgPrimary,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                TabBar(
                  indicatorColor: Constanst.onPrimary,
                  indicatorWeight: 4.0,
                  labelPadding: const EdgeInsets.fromLTRB(0, 14, 0, 14),
                  indicatorSize: TabBarIndicatorSize.label,
                  physics: const BouncingScrollPhysics(),
                  labelColor: Constanst.onPrimary,
                  unselectedLabelColor: Constanst.fgSecondary,
                  tabs: [
                    Text(
                      "Data Pribadi",
                      style: GoogleFonts.inter(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "Data Perusahaan",
                      style: GoogleFonts.inter(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Divider(
                  thickness: 1,
                  height: 1,
                  color: Constanst.fgBorder,
                ),
                Expanded(
                  child: TabBarView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 12.0, bottom: 12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Iconsax.personalcard,
                                    size: 24,
                                    color: Constanst.fgPrimary,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Nomor Identitas",
                                          style: GoogleFonts.inter(
                                              fontSize: 14,
                                              color: Constanst.fgSecondary,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "${AppData.informasiUser![0].em_id}",
                                          style: GoogleFonts.inter(
                                              fontSize: 16,
                                              color: Constanst.fgPrimary,
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
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
                              padding: const EdgeInsets.only(
                                  top: 12.0, bottom: 12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Iconsax.user,
                                    size: 24,
                                    color: Constanst.fgPrimary,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Nama Lengkap",
                                          style: GoogleFonts.inter(
                                              fontSize: 14,
                                              color: Constanst.fgSecondary,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "${AppData.informasiUser![0].full_name}",
                                          style: GoogleFonts.inter(
                                              fontSize: 16,
                                              color: Constanst.fgPrimary,
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
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
                              padding: const EdgeInsets.only(
                                  top: 12.0, bottom: 12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Iconsax.calendar_1,
                                    size: 24,
                                    color: Constanst.fgPrimary,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Tanggal Lahir",
                                          style: GoogleFonts.inter(
                                              fontSize: 14,
                                              color: Constanst.fgSecondary,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          Constanst.convertDate(
                                              "${AppData.informasiUser![0].em_birthday}"),
                                          style: GoogleFonts.inter(
                                              fontSize: 16,
                                              color: Constanst.fgPrimary,
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
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
                              padding: const EdgeInsets.only(
                                  top: 12.0, bottom: 12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Iconsax.sms,
                                    size: 24,
                                    color: Constanst.fgPrimary,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Email",
                                          style: GoogleFonts.inter(
                                              fontSize: 14,
                                              color: Constanst.fgSecondary,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "${AppData.informasiUser![0].em_email}",
                                          style: GoogleFonts.inter(
                                              fontSize: 16,
                                              color: Constanst.fgPrimary,
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
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
                              padding: const EdgeInsets.only(
                                  top: 12.0, bottom: 12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Iconsax.call,
                                    size: 24,
                                    color: Constanst.fgPrimary,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Telepon",
                                          style: GoogleFonts.inter(
                                              fontSize: 14,
                                              color: Constanst.fgSecondary,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "${AppData.informasiUser![0].em_phone}",
                                          style: GoogleFonts.inter(
                                              fontSize: 16,
                                              color: Constanst.fgPrimary,
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
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
                              padding: const EdgeInsets.only(
                                  top: 12.0, bottom: 12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    AppData.informasiUser![0].em_gender ==
                                            "PRIA"
                                        ? Iconsax.man
                                        : Iconsax.woman,
                                    size: 24,
                                    color: Constanst.fgPrimary,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Jenis Kelamin",
                                          style: GoogleFonts.inter(
                                              fontSize: 14,
                                              color: Constanst.fgSecondary,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "${AppData.informasiUser![0].em_gender}",
                                          style: GoogleFonts.inter(
                                              fontSize: 16,
                                              color: Constanst.fgPrimary,
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
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
                              padding: const EdgeInsets.only(
                                  top: 12.0, bottom: 12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Iconsax.command,
                                    size: 24,
                                    color: Constanst.fgPrimary,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Golongan Darah",
                                          style: GoogleFonts.inter(
                                              fontSize: 14,
                                              color: Constanst.fgSecondary,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "${AppData.informasiUser![0].em_blood_group}",
                                          style: GoogleFonts.inter(
                                              fontSize: 16,
                                              color: Constanst.fgPrimary,
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Divider(
                              height: 0,
                              thickness: 1,
                              color: Constanst.fgBorder,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 12.0, bottom: 12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Iconsax.buildings,
                                    size: 24,
                                    color: Constanst.fgPrimary,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Nama Perusahaan",
                                          style: GoogleFonts.inter(
                                              fontSize: 14,
                                              color: Constanst.fgSecondary,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "${AppData.selectedPerusahan}",
                                          style: GoogleFonts.inter(
                                              fontSize: 16,
                                              color: Constanst.fgPrimary,
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
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
                              padding: const EdgeInsets.only(
                                  top: 12.0, bottom: 12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Iconsax.buildings_2,
                                    size: 24,
                                    color: Constanst.fgPrimary,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Cabang",
                                          style: GoogleFonts.inter(
                                              fontSize: 14,
                                              color: Constanst.fgSecondary,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          AppData.informasiUser![0].branchName
                                              .toString(),
                                          style: GoogleFonts.inter(
                                              fontSize: 16,
                                              color: Constanst.fgPrimary,
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
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
                              padding: const EdgeInsets.only(
                                  top: 12.0, bottom: 12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Iconsax.briefcase,
                                    size: 24,
                                    color: Constanst.fgPrimary,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Divisi",
                                          style: GoogleFonts.inter(
                                              fontSize: 14,
                                              color: Constanst.fgSecondary,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "${AppData.informasiUser![0].emp_departmen}",
                                          style: GoogleFonts.inter(
                                              fontSize: 16,
                                              color: Constanst.fgPrimary,
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
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
                              padding: const EdgeInsets.only(
                                  top: 12.0, bottom: 12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Iconsax.profile_circle,
                                    size: 24,
                                    color: Constanst.fgPrimary,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Jabatan",
                                          style: GoogleFonts.inter(
                                              fontSize: 14,
                                              color: Constanst.fgSecondary,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "${AppData.informasiUser![0].emp_jobTitle}",
                                          style: GoogleFonts.inter(
                                              fontSize: 16,
                                              color: Constanst.fgPrimary,
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
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
                              padding: const EdgeInsets.only(
                                  top: 12.0, bottom: 12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Iconsax.user_tag,
                                    size: 24,
                                    color: Constanst.fgPrimary,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Posisi",
                                          style: GoogleFonts.inter(
                                              fontSize: 14,
                                              color: Constanst.fgSecondary,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "${AppData.informasiUser![0].posisi}",
                                          style: GoogleFonts.inter(
                                              fontSize: 16,
                                              color: Constanst.fgPrimary,
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
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
                              padding: const EdgeInsets.only(
                                  top: 12.0, bottom: 12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Iconsax.login,
                                    size: 24,
                                    color: Constanst.fgPrimary,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Bergabung",
                                          style: GoogleFonts.inter(
                                              fontSize: 14,
                                              color: Constanst.fgSecondary,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          Constanst.convertDate(
                                              "${AppData.informasiUser![0].em_joining_date}"),
                                          style: GoogleFonts.inter(
                                              fontSize: 16,
                                              color: Constanst.fgPrimary,
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Divider(
                              height: 0,
                              thickness: 1,
                              color: Constanst.fgBorder,
                            ),
                            controller.tanggalAkhirKontrak.value == ""
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        top: 12.0, bottom: 12.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Iconsax.logout,
                                          size: 24,
                                          color: Constanst.fgPrimary,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Berakhir",
                                                style: GoogleFonts.inter(
                                                    fontSize: 14,
                                                    color:
                                                        Constanst.fgSecondary,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                Constanst.convertDate(controller
                                                    .tanggalAkhirKontrak.value),
                                                // "${controller.user.value?[0].em_joining_date}",
                                                style: GoogleFonts.inter(
                                                    fontSize: 16,
                                                    color: Constanst.fgPrimary,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                            controller.tanggalAkhirKontrak.value == ""
                                ? const SizedBox()
                                : Divider(
                                    height: 0,
                                    thickness: 1,
                                    color: Constanst.fgBorder,
                                  ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 12.0, bottom: 12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Iconsax.notification_1,
                                    size: 24,
                                    color: Constanst.fgPrimary,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Status",
                                          style: GoogleFonts.inter(
                                              fontSize: 14,
                                              color: Constanst.fgSecondary,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "${AppData.informasiUser![0].em_status}",
                                          style: GoogleFonts.inter(
                                              fontSize: 16,
                                              color: Constanst.fgPrimary,
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Divider(
                              height: 0,
                              thickness: 1,
                              color: Constanst.fgBorder,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // bottomNavigationBar: Padding(
        //     padding: EdgeInsets.all(16.0),
        //     child: TextButtonWidget2(
        //         title: "Ubah Data",
        //         onTap: () {
        //           Get.offAll(EditPersonalInfo());
        //         },
        //         colorButton: Constanst.colorPrimary,
        //         colortext: Constanst.colorWhite,
        //         border: BorderRadius.circular(10.0),
        //         icon: Icon(
        //           Iconsax.edit_2,
        //           color: Constanst.colorWhite,
        //           size: 18,
        //         ))),
      ),
    );
  }
}
