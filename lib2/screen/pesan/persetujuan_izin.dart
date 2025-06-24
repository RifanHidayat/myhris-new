import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_operasional/controller/approval_controller.dart';
import 'package:siscom_operasional/controller/global_controller.dart';
import 'package:siscom_operasional/controller/pesan_controller.dart';
import 'package:siscom_operasional/screen/pesan/detail_persetujuan_izin.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PersetujuanIzin extends StatefulWidget {
  String? title, bulan, tahun;
  PersetujuanIzin({Key? key, this.title, this.bulan, this.tahun})
      : super(key: key);
  @override
  _PersetujuanIzinState createState() => _PersetujuanIzinState();
}

class _PersetujuanIzinState extends State<PersetujuanIzin>
    with SingleTickerProviderStateMixin {
  var controller = Get.find<ApprovalController>();
  var controllerGlobal = Get.find<GlobalController>();

  TabController? _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    controller.startLoadData(
        widget.title, widget.bulan, widget.tahun, 'persetujuan');
    _tabController!.addListener(_handleTabChange);
    super.initState();
  }

  void _handleTabChange() {
    print("Tab changed: ${_tabController!.index}");

    _tabController!.index == 0
        ? controller.startLoadData(
            widget.title, widget.bulan, widget.tahun, 'persetujuan')
        : controller.startLoadData(
            widget.title, widget.bulan, widget.tahun, 'riwayat');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constanst.coloBackgroundScreen,
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
              centerTitle: true,
              title: controller.statusCari.value
                  ? SizedBox(
                      height: 40,
                      child: TextFormField(
                        controller: controller.cari.value,
                        // onFieldSubmitted: (value) {
                        //   if (controller.cari.value.text == "") {
                        //     UtilsAlert.showToast(
                        //         "Isi form cari terlebih dahulu");
                        //   } else {
                        //     // UtilsAlert.loadingSimpanData(
                        //     //     Get.context!, "Mencari Data...");
                        //     controller.pencarianNamaKaryawan(value);
                        //   }
                        // },
                        onChanged: (value) {
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
                                  // controller.statusCari.value = false;
                                  controller.cari.value.text = "";
                                  controller.startLoadData(
                                      widget.title,
                                      widget.bulan,
                                      widget.tahun,
                                      'persetujuan');
                                },
                              ),
                            )),
                      ),
                    )
                  : Text(
                      "Persetujuan Izin",
                      style: GoogleFonts.inter(
                          color: Constanst.fgPrimary,
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),
              actions: [
                controller.statusCari.value
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
                        onPressed: controller.showInputCari,
                        // controller.toggleSearch,
                      ),
              ],
              leading: controller.statusCari.value
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
                        print("tes tes");
                        var pesanController = Get.find<PesanController>();
                        pesanController.loadApproveInfo();
                        pesanController.loadApproveHistory();
                        Get.back();
                      },
                    ),
            ),
          ),
        ),
      ),
      body: WillPopScope(
          onWillPop: () async {
            var pesanController = Get.find<PesanController>();
            pesanController.loadApproveInfo();
            pesanController.loadApproveHistory();
            Get.back();
            return true;
          },
          child: SafeArea(
              child: Obx(() => DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        TabBar(
                          indicatorColor: Constanst.onPrimary,
                          indicatorWeight: 4.0,
                          labelPadding: const EdgeInsets.fromLTRB(0, 14, 0, 14),
                          indicatorSize: TabBarIndicatorSize.label,
                          physics: const BouncingScrollPhysics(),
                          labelColor: Constanst.onPrimary,
                          unselectedLabelColor: Constanst.fgSecondary,
                          controller: _tabController,
                          onTap: (value) {
                            // print(value);
                            // value == 0
                            //     ? controller.startLoadData(widget.title,
                            //         widget.bulan, widget.tahun, 'persetujuan')
                            //     : controller.startLoadData(widget.title,
                            //         widget.bulan, widget.tahun, 'riwayat');
                          },
                          tabs: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 12.0, right: 12.0),
                              child: Text(
                                "Perlu Persetujuan",
                                style: GoogleFonts.inter(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 12.0, right: 12.0),
                              child: Text(
                                "Riwayat",
                                style: GoogleFonts.inter(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                            child: TabBarView(
                          controller: _tabController,
                          physics: const BouncingScrollPhysics(),
                          children: [
                            controller.listData.value.isEmpty
                                ? Center(
                                    child: Text(controller.loadingString.value),
                                  )
                                : listDataApproval(),
                            controller.listData.value.isEmpty
                                ? Center(
                                    child: Text(controller.loadingString.value),
                                  )
                                : listDataApproval(),
                          ],
                        )),
                      ],
                    ),
                  )))),
    );
  }

  // Widget pencarianData() {
  //   return Container(
  //     decoration: BoxDecoration(
  //         borderRadius: Constanst.borderStyle2,
  //         border: Border.all(color: Constanst.colorNonAktif)),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       children: [
  //         Expanded(
  //           flex: 15,
  //           child: Padding(
  //             padding: const EdgeInsets.only(top: 7, left: 10),
  //             child: Icon(Iconsax.search_normal_1),
  //           ),
  //         ),
  //         Expanded(
  //           flex: 85,
  //           child: Padding(
  //             padding: const EdgeInsets.only(left: 10),
  //             child: SizedBox(
  //               height: 40,
  //               child: Row(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Expanded(
  //                     flex: 85,
  //                     child: TextField(
  //                       controller: controller.cari.value,
  //                       decoration: InputDecoration(
  //                           border: InputBorder.none, hintText: "Cari"),
  //                       style: TextStyle(
  //                           fontSize: 14.0, height: 1.0, color: Colors.black),
  //                       onChanged: (value) {
  //                         controller.cariData(value);
  //                       },
  //                     ),
  //                   ),
  //                   !controller.statusCari.value
  //                       ? SizedBox()
  //                       : Expanded(
  //                           flex: 15,
  //                           child: IconButton(
  //                             icon: Icon(
  //                               Iconsax.close_circle,
  //                               color: Colors.red,
  //                             ),
  //                             onPressed: () {
  //                               controller.statusCari.value = false;
  //                               controller.cari.value.text = "";
  //                               controller.startLoadData(
  //                                   widget.title, widget.bulan, widget.tahun);
  //                             },
  //                           ),
  //                         )
  //                 ],
  //               ),
  //             ),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  Widget listDataApproval() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: controller.listData.value.length,
          itemBuilder: (context, index) {
            var data = controller.listData[index];
            var idx = controller.listData.value[index]['id'];
            var namaPengaju = controller.listData.value[index]['nama_pengaju'];
            var emIdPengaju = controller.listData.value[index]['emId_pengaju'];
            var delegasi = controller.listData.value[index]['delegasi'];
            var typeAjuan = controller.listData.value[index]['type'];
            var namaApprove1 =
                controller.listData.value[index]['nama_approve1'];
            var leave_status = controller.listData.value[index]['leave_status'];
            var dariJam = controller.listData.value[index]['dari_jam'];
            var sampaiJam = controller.listData.value[index]['sampai_jam'];
            var nomor_ajuan = controller.listData.value[index]['nomor_ajuan'];
            var tanggalPengajuan =
                controller.listData.value[index]['waktu_pengajuan'];
            var categoryAjuan = controller.listData.value[index]['category'];
            var nama_divisi =
                controller.listData.value[index]['nama_divisi'] ?? "";
            var image = controller.listData.value[index]['em_image'];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  customBorder: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  onTap: () {
                    controller.searchSuratPeringatan(emIdPengaju);
                    controller.searchTeguranLisan(emIdPengaju);
                    // controller.updateListStatus();
                    Get.to(DetailPersetujuanIzin(
                      emId: emIdPengaju,
                      title: typeAjuan,
                      idxDetail: "$idx",
                      delegasi: delegasi,
                    ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        border: Border.all(
                            width: 0.5,
                            color: const Color.fromARGB(255, 211, 205, 205))),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16, top: 8, bottom: 8, right: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    image == ""
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
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            namaPengaju,
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w500,
                                                color: Constanst.fgPrimary,
                                                fontSize: 16),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "$nama_divisi",
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w400,
                                                color: Constanst.fgSecondary,
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                Constanst.convertDate5("$tanggalPengajuan"),
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w400,
                                    color: Constanst.fgSecondary,
                                    fontSize: 14),
                              ),
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 12.0, bottom: 12.0),
                            child: Divider(
                              thickness: 1,
                              height: 0,
                              color: Constanst.border,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "$typeAjuan - $categoryAjuan",
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          color: Constanst.fgPrimary,
                                          fontSize: 16),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "$nomor_ajuan",
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w400,
                                          color: Constanst.fgSecondary,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Constanst.fgSecondary,
                                size: 18,
                              ),
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 12.0, bottom: 12.0),
                            child: Divider(
                              thickness: 1,
                              height: 0,
                              color: Constanst.border,
                            ),
                          ),
                          // namaApprove1 == "" || leave_status == "Pending"
                          //     ? const SizedBox()
                          //     : Center(
                          //         child: Text(
                          //           "Approve 1 by - $namaApprove1",
                          //           style: GoogleFonts.inter(
                          //               fontWeight: FontWeight.w500,
                          //               color: Constanst.fgPrimary,
                          //               fontSize: 16),
                          //         ),
                          //       ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   children: [
                          //     Icon(
                          //       Iconsax.timer,
                          //       color: Constanst.color3,
                          //       size: 20,
                          //     ),
                          //     Padding(
                          //       padding: const EdgeInsets.only(left: 3),
                          //       child: Text(
                          //         controller.valuePolaPersetujuan == 1 ||
                          //                 controller.valuePolaPersetujuan == "1"
                          //             ? '$leave_status'
                          //             : leave_status == "Pending"
                          //                 ? "Pending Approval 1"
                          //                 : "Pending Approval 2",
                          //         textAlign: TextAlign.center,
                          //         style: GoogleFonts.inter(
                          //             fontWeight: FontWeight.w500,
                          //             color: Constanst.fgPrimary,
                          //             fontSize: 14),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          _approval(index)
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            );
          }),
    );
  }

  showDataDepartemenAkses({index}) {
    var data = controller.listData[index];
    showModalBottomSheet(
        context: Get.context!,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.0),
          ),
        ),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: HexColor('#CBD5E0')),
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextLabell(
                        text: "Tanggal Pengajuan",
                        weight: FontWeight.bold,
                      ),
                      TextLabell(
                        text:
                            "${Constanst.convertDate2(data['waktu_pengajuan'])}",
                        color: Constanst.secondary,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: HexColor('#CBD5E0')),
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextLabell(
                            text: "Nama pengajuan",
                            weight: FontWeight.bold,
                          ),
                          TextLabell(
                            text: data['full_name'],
                            color: Constanst.secondary,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Divider(),
                      SizedBox(
                        height: 4,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextLabell(
                            text: "Keterangan",
                            weight: FontWeight.bold,
                          ),
                          TextLabell(
                            text: data['catatan'],
                            color: Constanst.secondary,
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.only(),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 50,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: HexColor('#CBD5E0'),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Center(
                            child: TextLabell(
                              text: "Batalkan",
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        flex: 50,
                        child: InkWell(
                          onTap: () {
                            controller
                                .arppovalpayroll(id: data['id'])!
                                .then((value) {
                              if (value == true) {
                                print("tes tes");
                                var pesanController =
                                    Get.find<PesanController>();
                                pesanController.loadApproveInfo();
                                pesanController.loadApproveHistory();
                                Get.back();
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Constanst.colorPrimary,
                              border: Border.all(
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.only(top: 8, bottom: 8),
                            child: Center(
                              child: TextLabell(
                                text: "Approve",
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          );
        });
  }

  Widget _approval(index) {
    var data = controller.listData[index];
    var namaApprove1 = controller.listData.value[index]['nama_approve1'] ?? "";
    var namaApprove2 = controller.listData.value[index]['nama_approve2'] ?? "";
    var leave_status = controller.listData.value[index]['leave_status'] ?? "";

    if (leave_status == "Rejected") {
      return Container(
        child: Row(
                children: [
                  Icon(
                    Iconsax.close_circle,
                    color: Colors.red,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Text(
                      "Rejected by  - ${namaApprove2 == '' || namaApprove2 == null ? namaApprove1 : namaApprove2}",
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          color: Constanst.fgPrimary,
                          fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
      );
    }

    if (leave_status == "Pending") {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Iconsax.timer,
            color: Constanst.color3,
            size: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 3),
            child: Text(
              controller.valuePolaPersetujuan == 1 ||
                      controller.valuePolaPersetujuan == "1"
                  ? '$leave_status'
                  : leave_status == "Pending"
                      ? "Pending Approval 1"
                      : "Pending Approval 2",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  color: Constanst.fgPrimary,
                  fontSize: 14),
            ),
          ),
        ],
      );
    }

    if (controllerGlobal.valuePolaPersetujuan.value.toString() == "1") {
      return Container(
        child: namaApprove1 == ""
            ? const SizedBox()
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Iconsax.tick_circle,
                    color: Colors.green,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Approved by  - $namaApprove1",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        color: Constanst.fgPrimary,
                        fontSize: 16),
                  ),
                ],
              ),
      );
    }

    if (leave_status == "Approve2") {
      return Container(
        child: namaApprove1 == ""
            ? const SizedBox()
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Iconsax.tick_circle,
                    color: Colors.green,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Text(
                      "Approved 2 by  - $namaApprove2",
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          color: Constanst.fgPrimary,
                          fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          Iconsax.timer,
          color: Constanst.color3,
          size: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 3),
          child: Text(
            controller.valuePolaPersetujuan == 1 ||
                    controller.valuePolaPersetujuan == "1"
                ? '$leave_status'
                : leave_status == "Pending"
                    ? "Pending Approval 1"
                    : "Pending Approval 2",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                color: Constanst.fgPrimary,
                fontSize: 14),
          ),
        ),
      ],
    );
    // if (contr){

    // }else{

    // }
  }
}
