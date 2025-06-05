import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siscom_operasional/controller/pesan_controller.dart';
// import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:siscom_operasional/controller/tab_controller.dart';
import 'package:siscom_operasional/controller/tracking_controller.dart';
import 'package:siscom_operasional/screen/aktifitas/aktifitas.dart';
import 'package:siscom_operasional/screen/akun/setting.dart';
import 'package:siscom_operasional/screen/dashboard.dart';
import 'package:siscom_operasional/screen/kontrol/kontrol_list.dart';
import 'package:siscom_operasional/screen/kontrol/live_tracking.dart';
import 'package:siscom_operasional/screen/kontrol/tracking_list.dart';
import 'package:siscom_operasional/screen/pesan/pesan.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InitScreen extends StatefulWidget {
  @override
  _InitScreenState createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  final controller = Get.put(TabbController());
  final controllerTracking = Get.put(TrackingController());
  final controllerPesan = Get.find<PesanController>();
  // int _currentIndex = 0;

  late final List<Widget> _buildScreens = [
    const Dashboard(),
    // KontrolList(),
    controller.kontrolAkses.value == true
        ? TrackingList()
        : LiveTracking(status: ''),
    Aktifitas(),
    const Pesan(
      status: false,
    ),
    const Setting(),
  ];

  late final List<Widget> _buildScreens1 = [
    const Dashboard(),
    Aktifitas(),
    const Pesan(
      status: false,
    ),
    const Setting(),
  ];

  List<CustomNavigationBarItem> _navBarsItems() {
    return [
      CustomNavigationBarItem(
        selectedIcon: SvgPicture.asset(
          'assets/home_fill.svg',
          height: 23,
          width: 23,
          // color: Constanst.onPrimary,
        ),
        icon: SvgPicture.asset(
          'assets/home.svg',
          // color: Constanst.colorNeutralFgTertiary,
          height: 23,
          width: 23,
        ),
        selectedTitle: Text(
          "Home",
          style: GoogleFonts.inter(
            fontSize: 12,
            height: 1.8,
            color: Constanst.onPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        title: Text(
          "Home",
          style: GoogleFonts.inter(
            fontSize: 12,
            height: 1.8,
            color: Constanst.colorNeutralFgTertiary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      CustomNavigationBarItem(
        selectedIcon: SvgPicture.asset(
          'assets/tracking_fill.svg',
          // color: Constanst.onPrimary,
          height: 23,
          width: 23,
        ),
        icon: SvgPicture.asset(
          'assets/tracking.svg',
          // color: Constanst.colorNeutralFgTertiary,
          height: 23,
          width: 23,
        ),
        selectedTitle: Text(
          "Tracking",
          style: GoogleFonts.inter(
            fontSize: 12,
            height: 1.8,
            color: Constanst.onPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        title: Text(
          "Tracking",
          style: GoogleFonts.inter(
            fontSize: 12,
            height: 1.8,
            color: Constanst.colorNeutralFgTertiary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      CustomNavigationBarItem(
        selectedIcon: SvgPicture.asset(
          'assets/aktivitas_fill.svg',
          // color: Constanst.onPrimary,
          height: 23,
          width: 23,
        ),
        icon: SvgPicture.asset(
          'assets/aktivitas.svg',
          // color: Constanst.colorNeutralFgTertiary,
          height: 23,
          width: 23,
        ),
        selectedTitle: Text(
          "Aktivitas",
          style: GoogleFonts.inter(
            fontSize: 12,
            height: 1.8,
            color: Constanst.onPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        title: Text(
          "Aktivitas",
          style: GoogleFonts.inter(
            fontSize: 12,
            height: 1.8,
            color: Constanst.colorNeutralFgTertiary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      CustomNavigationBarItem(
        selectedIcon: Stack(
          children: [
            SvgPicture.asset(
              'assets/inbox_fill.svg',
              height: 23,
              width: 23,
            ),
            Visibility(
              visible:
                  controllerPesan.jumlahPersetujuan.value.toString() != "0",
              child: Positioned(
                top: 0,
                right: 0,
                child: Container(
                  height: 18,
                  width: 18,
                  decoration: BoxDecoration(
                    color: Constanst.colorStateDangerBg,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(100.0),
                    ),
                    border: Border.all(
                      width: 1.0,
                      color: Constanst.colorStateDangerBorder,
                    ),
                  ),
                  child: Center(
                    child: Obx(
                      () => Text(
                        "${controllerPesan.jumlahPersetujuan.value}".length > 2
                            ? '${"${controllerPesan.jumlahPersetujuan.value}".substring(0, 2)}+'
                            : "${controllerPesan.jumlahPersetujuan.value}",
                        style: GoogleFonts.inter(
                          color: Constanst.colorStateOnDangerBg,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        icon: Stack(
          children: [
            SvgPicture.asset(
              'assets/inbox.svg',
              height: 23,
              width: 23,
            ),
            Visibility(
              visible:
                  controllerPesan.jumlahPersetujuan.value.toString() != "0",
              child: Positioned(
                top: 0,
                right: 0,
                child: Container(
                  height: 18,
                  width: 18,
                  decoration: BoxDecoration(
                    color: Constanst.colorStateDangerBg,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(100.0),
                    ),
                    border: Border.all(
                      width: 1.0,
                      color: Constanst.colorStateDangerBorder,
                    ),
                  ),
                  child: Center(
                    child: Obx(
                      () => Text(
                        "${controllerPesan.jumlahPersetujuan.value}".length > 2
                            ? '${"${controllerPesan.jumlahPersetujuan.value}".substring(0, 2)}+'
                            : "${controllerPesan.jumlahPersetujuan.value}",
                        style: GoogleFonts.inter(
                          color: Constanst.colorStateOnDangerBg,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        selectedTitle: Text(
          "Inbox",
          style: GoogleFonts.inter(
            fontSize: 12,
            height: 1.8,
            color: Constanst.onPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        title: Text(
          "Inbox",
          style: GoogleFonts.inter(
            fontSize: 12,
            height: 1.8,
            color: Constanst.colorNeutralFgTertiary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      CustomNavigationBarItem(
        selectedIcon: SvgPicture.asset(
          'assets/akun_fill.svg',
          // color: Constanst.onPrimary,
          height: 23,
          width: 23,
        ),
        icon: SvgPicture.asset(
          'assets/akun.svg',
          // color: Constanst.colorNeutralFgTertiary,
          height: 23,
          width: 23,
        ),
        selectedTitle: Text(
          "Akun",
          style: GoogleFonts.inter(
            fontSize: 12,
            height: 1.8,
            color: Constanst.onPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        title: Text(
          "Akun",
          style: GoogleFonts.inter(
            fontSize: 12,
            height: 1.8,
            color: Constanst.colorNeutralFgTertiary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    ];
  }

  List<CustomNavigationBarItem> _navBarsItems1() {
    return [
      CustomNavigationBarItem(
        selectedIcon: SvgPicture.asset(
          'assets/home_fill.svg',
          height: 23,
          width: 23,
          // color: Constanst.onPrimary,
        ),
        icon: SvgPicture.asset(
          'assets/home.svg',
          // color: Constanst.colorNeutralFgTertiary,
          height: 23,
          width: 23,
        ),
        selectedTitle: Text(
          "Home",
          style: GoogleFonts.inter(
            fontSize: 12,
            height: 1.8,
            color: Constanst.onPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        title: Text(
          "Home",
          style: GoogleFonts.inter(
            fontSize: 12,
            height: 1.8,
            color: Constanst.colorNeutralFgTertiary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      CustomNavigationBarItem(
        selectedIcon: SvgPicture.asset(
          'assets/aktivitas_fill.svg',
          // color: Constanst.onPrimary,
          height: 23,
          width: 23,
        ),
        icon: SvgPicture.asset(
          'assets/aktivitas.svg',
          // color: Constanst.colorNeutralFgTertiary,
          height: 23,
          width: 23,
        ),
        selectedTitle: Text(
          "Aktivitas",
          style: GoogleFonts.inter(
            fontSize: 12,
            height: 1.8,
            color: Constanst.onPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        title: Text(
          "Aktivitas",
          style: GoogleFonts.inter(
            fontSize: 12,
            height: 1.8,
            color: Constanst.colorNeutralFgTertiary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      CustomNavigationBarItem(
        selectedIcon: Stack(
          children: [
            SvgPicture.asset(
              'assets/inbox_fill.svg',
              height: 23,
              width: 23,
            ),
            Visibility(
              visible:
                  controllerPesan.jumlahPersetujuan.value.toString() != "0",
              child: Positioned(
                top: 0,
                right: 0,
                child: Container(
                  height: 18,
                  width: 18,
                  decoration: BoxDecoration(
                    color: Constanst.colorStateDangerBg,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(100.0),
                    ),
                    border: Border.all(
                      width: 1.0,
                      color: Constanst.colorStateDangerBorder,
                    ),
                  ),
                  child: Center(
                    child: Obx(
                      () => Text(
                        "${controllerPesan.jumlahPersetujuan.value}".length > 2
                            ? '${"${controllerPesan.jumlahPersetujuan.value}".substring(0, 2)}+'
                            : "${controllerPesan.jumlahPersetujuan.value}",
                        style: GoogleFonts.inter(
                          color: Constanst.colorStateOnDangerBg,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        icon: Stack(
          children: [
            SvgPicture.asset(
              'assets/inbox.svg',
              height: 23,
              width: 23,
            ),
            Visibility(
              visible:
                  controllerPesan.jumlahPersetujuan.value.toString() != "0",
              child: Positioned(
                top: 0,
                right: 0,
                child: Container(
                  height: 18,
                  width: 18,
                  decoration: BoxDecoration(
                    color: Constanst.colorStateDangerBg,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(100.0),
                    ),
                    border: Border.all(
                      width: 1.0,
                      color: Constanst.colorStateDangerBorder,
                    ),
                  ),
                  child: Center(
                    child: Obx(
                      () => Text(
                        "${controllerPesan.jumlahPersetujuan.value}".length > 2
                            ? '${"${controllerPesan.jumlahPersetujuan.value}".substring(0, 2)}+'
                            : "${controllerPesan.jumlahPersetujuan.value}",
                        style: GoogleFonts.inter(
                          color: Constanst.colorStateOnDangerBg,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        selectedTitle: Text(
          "Inbox",
          style: GoogleFonts.inter(
            fontSize: 12,
            height: 1.8,
            color: Constanst.onPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        title: Text(
          "Inbox",
          style: GoogleFonts.inter(
            fontSize: 12,
            height: 1.8,
            color: Constanst.colorNeutralFgTertiary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      CustomNavigationBarItem(
        selectedIcon: SvgPicture.asset(
          'assets/akun_fill.svg',
          // color: Constanst.onPrimary,
          height: 23,
          width: 23,
        ),
        icon: SvgPicture.asset(
          'assets/akun.svg',
          // color: Constanst.colorNeutralFgTertiary,
          height: 23,
          width: 23,
        ),
        selectedTitle: Text(
          "Akun",
          style: GoogleFonts.inter(
            fontSize: 12,
            height: 1.8,
            color: Constanst.onPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        title: Text(
          "Akun",
          style: GoogleFonts.inter(
            fontSize: 12,
            height: 1.8,
            color: Constanst.colorNeutralFgTertiary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    controller.currentIndex.value = 0;
    controller.checkuserinfo();
    // controller.Absensicontroller.absenStatus.refresh();
    // controllerTracking.isTracking();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: controller.onWillPop,
      child: DefaultTabController(
        length: controller.kontrolAkses.value == true ||
                controller.kontrol.value == true
            ? 5
            : 4,
        initialIndex: controller.currentIndex.value,
        child: Scaffold(
          body: Center(
            child: Obx(
              () => controller.kontrolAkses.value == true ||
                      controller.kontrol.value == true
                  ? _buildScreens.elementAt(controller.currentIndex.value)
                  : _buildScreens1.elementAt(controller.currentIndex.value),
            ),
          ),
          bottomNavigationBar: Obx(
            () => SizedBox(
              height: 80,
              child: CustomNavigationBar(
                currentIndex: controller.currentIndex.value,
                onTap: (index) {
                  controller.currentIndex.value = index;
                  controller.onClickItem(index);
                  controller.update();
                },
                bubbleCurve: Curves.linear,
                scaleCurve: Curves.linear,
                elevation: 20.0,
                // iconSize: 30.0,
                strokeColor: Constanst.onPrimary,
                // controller: controller.tabPersistantController.value,
                // screens: controller.kontrolAkses.value == true
                //     ? _buildScreens()
                //     : _buildScreens1(),
                items: controller.kontrolAkses.value == true ||
                        controller.kontrol.value == true
                    ? _navBarsItems()
                    : _navBarsItems1(),
                // onWillPop: (s) async => await controller.onWillPop(),
                // onItemSelected: (s) => controller.onClickItem(s),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
