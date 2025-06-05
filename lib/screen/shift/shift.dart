import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_operasional/controller/dashboard_controller.dart';
import 'package:siscom_operasional/controller/global_controller.dart';
import 'package:siscom_operasional/controller/shift_controller.dart';
import 'package:siscom_operasional/screen/absen/laporan/laporan_shift.dart';
import 'package:siscom_operasional/screen/shift/form_pengajuan_shift.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';

class ShiftScreen extends StatefulWidget {
  const ShiftScreen({Key? key}) : super(key: key);

  @override
  State<ShiftScreen> createState() => _ShiftScreenState();
}

class _ShiftScreenState extends State<ShiftScreen> {
  final controller = Get.put(ShiftController());
  var controllerGlobal = Get.find<GlobalController>();
  final dashboardController = Get.put(DashboardController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadDataShift();
    });
  }

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
                        controller: controller.cari.value,
                        onFieldSubmitted: (value) {
                          if (controller.cari.value.text == "") {
                            UtilsAlert.showToast(
                                "Isi form cari terlebih dahulu");
                          } else {
                            // UtilsAlert.loadingSimpanData(
                            //     Get.context!, "Mencari Data...");
                            // controller.cariData(value);
                          }
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
                                onPressed: () {},
                              ),
                            )),
                      ),
                    )
                  : Text(
                      "Riwayat Shift",
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
                          Obx(
                            () => controller.showButtonlaporan.value == false
                                ? const SizedBox()
                                : dashboardController.showLaporan.value == false
                                    ? const SizedBox()
                                    : IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: Icon(
                                          Iconsax.document_text,
                                          color: Constanst.fgPrimary,
                                          size: 24,
                                        ),
                                        onPressed: () => Get.to(LaporanShift(
                                          title: 'lembur'))
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
                        Get.back();
                      },
                    ),
            ),
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        backgroundColor: Constanst.colorPrimary,
        icon: Iconsax.add,
        activeIcon: Icons.close,
        spacing: 10,
        spaceBetweenChildren: 8,
        children: [
          SpeedDialChild(
              child: const Icon(Iconsax.add),
              label: 'Ajukan Shift baru',
              onTap: () {
                controller.swap.value = false;
                Get.to(FormPengajuanShift(dataForm: const [[], false, false]));
              }),
          SpeedDialChild(
              child: const Icon(Iconsax.arrow_swap),
              label: 'Tukar Shift',
              onTap: () {
                controller.swap.value = true;
                Get.to(FormPengajuanShift(dataForm: const [[], false, true]));
              }),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          controller.onClose();
          Get.back();
          return true;
        },
        child: Obx(
          () => Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                controller.bulanDanTahunNow.value == ""
                    ? const SizedBox()
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 4),
                          // status()
                        ],
                      ),
                const SizedBox(height: 4),
                Flexible(
                    child: RefreshIndicator(
                        color: Constanst.colorPrimary,
                        onRefresh: refreshData,
                        child: controller.listShift.value.isEmpty
                            ? Center(
                                child: SafeArea(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    controller.loadingString.value ==
                                            "Memuat Data..."
                                        ? Container()
                                        : SvgPicture.asset(
                                            'assets/empty_screen.svg',
                                            height: 228,
                                          ),
                                    const SizedBox(height: 16),
                                    Text(
                                      controller.loadingString.value,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Constanst.fgPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 85),
                                  ],
                                ),
                              ))
                            : riwayatShift()))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> refreshData() async {
    await Future.delayed(Duration(seconds: 2));
  }

  Widget riwayatShift() {
    return ListView.builder(
        physics: controller.listShift.value.length <= 8
            ? const AlwaysScrollableScrollPhysics()
            : const BouncingScrollPhysics(),
        itemCount: controller.listShift.value.length,
        itemBuilder: (context, index) {
          var statusDraft =
              controller.listShift.value[index]['status_pengajuan'];
          var nomorAjuan = controller.listShift.value[index]['nomor_ajuan'];
          var tanggalPengajuan = controller.listShift.value[index]['tgl_ajuan'];
          var status;
          if (controller.valuePolaPersetujuan.value == "1") {
            status = controller.listShift.value[index]['status'];
          } else {
            status = controller.listShift.value[index]['status'] == "Approve"
                ? "Approve 1"
                : controller.listShift.value[index]['status'] == "Approve2"
                    ? "Approve 2"
                    : controller.listShift.value[index]['status'];
          }
          var namaTypeAjuan = controller.listShift.value[index]['type'];
          var alasan;
          if (controller.listShift.value[index]['alasan2'] == "" ||
              controller.listShift.value[index]['alasan2'] == "null" ||
              controller.listShift.value[index]['alasan2'] == null) {
            alasan = controller.listShift.value[index]['alasan1'];
          } else {
            alasan = controller.listShift.value[index]['alasan2'];
          }
          var approve;
          print(
              'ini approve2 by oke${controller.listShift.value[index]['approve2_by']}');
          if (controller.listShift.value[index]['approve2_by'] == "" ||
              controller.listShift.value[index]['approve2_by'] == "null" ||
              controller.listShift.value[index]['approve2_by'] == null) {
            approve = controller.listShift.value[index]['approve_by'];
          } else {
            approve = controller.listShift.value[index]['approve2_by'];
          }

          return Column(
            children: [
              const SizedBox(height: 16),
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Constanst.colorNonAktif)),
                    child: InkWell(
                      customBorder: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      onTap: () {
                        controller.showDetailShift(
                            controller.listShift[index], approve, alasan);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 12, bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Shift",
                                style: GoogleFonts.inter(
                                    color: Constanst.fgPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500)),
                            const SizedBox(height: 4),
                            Text("NO.$nomorAjuan",
                                textAlign: TextAlign.justify,
                                style: GoogleFonts.inter(
                                    color: Constanst.fgSecondary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400)),
                            const SizedBox(height: 4),
                            Text(Constanst.convertDate5("$tanggalPengajuan"),
                                style: GoogleFonts.inter(
                                    color: Constanst.fgSecondary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400)),
                            const SizedBox(height: 4),
                            const SizedBox(height: 12),
                            Divider(
                                height: 0,
                                thickness: 1,
                                color: Constanst.border),
                            const SizedBox(height: 8),
                            if (status == 'Rejected')
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Iconsax.close_circle,
                                    color: Constanst.color4,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Rejected by $approve",
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              color: Constanst.fgPrimary,
                                              fontSize: 14),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          alasan.toString(),
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w400,
                                              color: Constanst.fgSecondary,
                                              fontSize: 14),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            else
                              status == "Approve" ||
                                      status == "Approve 1" ||
                                      status == "Approve 2"
                                  ? Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Iconsax.tick_circle,
                                          color: Colors.green,
                                          size: 22,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Approved by $approve",
                                                style: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w500,
                                                    color: Constanst.fgPrimary,
                                                    fontSize: 14),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                alasan.toString(),
                                                style: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        Constanst.fgSecondary,
                                                    fontSize: 14),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Iconsax.timer,
                                          color: Constanst.color3,
                                          size: 22,
                                        ),
                                        const SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Pending Approval",
                                                style: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w500,
                                                    color: Constanst.fgPrimary,
                                                    fontSize: 14)),
                                            const SizedBox(height: 4),
                                            InkWell(
                                                onTap: () {
                                                  var dataEmployee = {
                                                    'nameType':
                                                        '$namaTypeAjuan',
                                                    'nomor_ajuan':
                                                        '$nomorAjuan',
                                                  };
                                                  controllerGlobal
                                                      .showDataPilihAtasan(
                                                          dataEmployee);
                                                },
                                                child: Text(
                                                    "Konfirmasi via Whatsapp",
                                                    style: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            Constanst.infoLight,
                                                        fontSize: 14))),
                                          ],
                                        ),
                                      ],
                                    ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  statusDraft == 'draft'
                      ? Positioned(
                          right: 0,
                          top: 0,
                          child: Transform.rotate(
                            angle: -0.3,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.red
                                    .withOpacity(0.8), // Warna latar belakang
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                ),
                              ),
                              child: Text(
                                "DRAFT",
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white, // Warna teks
                                ),
                              ),
                            ),
                          ),
                        )
                      : SizedBox()
                ],
              )
            ],
          );
        });
  }
}
