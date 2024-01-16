import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_operasional/controller/approval_controller.dart';
import 'package:siscom_operasional/controller/pesan_controller.dart';
import 'package:siscom_operasional/screen/pesan/detail_persetujuan_tugas_luar.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PersetujuanTugasLuar extends StatefulWidget {
  String? title, bulan, tahun;
  PersetujuanTugasLuar({Key? key, this.title, this.bulan, this.tahun})
      : super(key: key);
  @override
  _PersetujuanTugasLuarState createState() => _PersetujuanTugasLuarState();
}

class _PersetujuanTugasLuarState extends State<PersetujuanTugasLuar> {
  var controller = Get.put(ApprovalController());

  @override
  void initState() {
    controller.startLoadData(widget.title, widget.bulan, widget.tahun);
    // controller.startLoadData("Dinas Luar", widget.bulan, widget.tahun);
    super.initState();
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
                                      widget.title, widget.bulan, widget.tahun);
                                },
                              ),
                            )),
                      ),
                    )
                  : Text(
                      "Persetujuan ${controller.titleAppbar.value}",
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
            child: Obx(
              () => Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: controller.listData.value.isEmpty
                    ? Center(
                        child: Text(controller.loadingString.value),
                      )
                    : Column(
                        children: [
                          Row(
                            children: [
                              tipe(),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Expanded(child: listDataApproval()),
                        ],
                      ),
              ),
            ),
          )),
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

  Widget tipe() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          border: Border.all(color: Constanst.fgBorder)),
      child: InkWell(
        customBorder: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(100))),
        onTap: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16.0),
              ),
            ),
            builder: (BuildContext context) {
              return SafeArea(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Pilih Tipe Izin",
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
                                onTap: () => Navigator.pop(Get.context!),
                                child: Icon(
                                  Icons.close,
                                  size: 26,
                                  color: Constanst.fgSecondary,
                                ))
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
                      InkWell(
                        onTap: () {
                          controller.tempNamaTipe1.value = "Tugas Luar";
                          widget.title = "Tugas Luar";
                          controller.startLoadData(
                              widget.title, widget.bulan, widget.tahun);
                          Get.back();
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const SizedBox(width: 16),
                                  Text(
                                    "Tugas Luar",
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Constanst.fgPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              controller.tempNamaTipe1.value == "Tugas Luar"
                                  ? Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2,
                                              color: Constanst.onPrimary),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Constanst.onPrimary,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        controller.tempNamaTipe1.value =
                                            "Tugas Luar";
                                        widget.title = "Tugas Luar";
                                        controller.startLoadData(widget.title,
                                            widget.bulan, widget.tahun);
                                        Get.back();
                                      },
                                      child: Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1,
                                                color: Constanst.onPrimary),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(2),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                        ),
                                      ),
                                    )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          controller.tempNamaTipe1.value = "Dinas Luar";
                          widget.title = "Dinas Luar";
                          controller.startLoadData(
                              widget.title, widget.bulan, widget.tahun);
                          Get.back();
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const SizedBox(width: 16),
                                  Text(
                                    "Dinas Luar",
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Constanst.fgPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              controller.tempNamaTipe1.value == "Dinas Luar"
                                  ? Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2,
                                              color: Constanst.onPrimary),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Constanst.onPrimary,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        controller.tempNamaTipe1.value =
                                            "Dinas Luar";
                                        widget.title = "Dinas Luar";
                                        controller.startLoadData(widget.title,
                                            widget.bulan, widget.tahun);
                                        Get.back();
                                      },
                                      child: Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1,
                                                color: Constanst.onPrimary),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(2),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                        ),
                                      ),
                                    )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ).then((value) {
            print('Bottom sheet closed');
          });
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.tempNamaTipe1.value,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Constanst.fgSecondary,
                ),
              ),
              const SizedBox(width: 4),
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

  Widget listDataApproval() {
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: controller.listData.value.length,
        itemBuilder: (context, index) {
          var data = controller.listData[index];
          var idx = controller.listData.value[index]['id'];
          var namaPengaju = controller.listData.value[index]['nama_pengaju'];
          var emIdPengaju = controller.listData.value[index]['emId_pengaju'];
          var delegasi = controller.listData.value[index]['delegasi'];
          var typeAjuan = controller.listData.value[index]['type'];
          var namaApprove1 = controller.listData.value[index]['nama_approve1'];
          var leave_status = controller.listData.value[index]['leave_status'];
          var dariJam = controller.listData.value[index]['dari_jam'];
          var sampaiJam = controller.listData.value[index]['sampai_jam'];
          var nomor_ajuan = controller.listData.value[index]['nomor_ajuan'];
          var tanggalPengajuan =
              controller.listData.value[index]['waktu_pengajuan'];
          var titleAjuan = controller.listData.value[index]['title_ajuan'];
          var namaTypeAjuan = controller.listData.value[index]['name'];
          var categoryAjuan = controller.listData.value[index]['category'];
          var nama_divisi = controller.listData.value[index]['nama_divisi'];
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
                  Get.to(DetailPersetujuanTugasLuar(
                    emId: emIdPengaju,
                    title: typeAjuan,
                    idxDetail: "$idx",
                    delegasi: delegasi,
                  ));
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
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
                            Column(
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
                        namaApprove1 == "" || leave_status == "Pending"
                            ? const SizedBox()
                            : Center(
                                child: Text(
                                  "Approve 1 by - $namaApprove1",
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      color: Constanst.fgPrimary,
                                      fontSize: 16),
                                ),
                              ),
                        Row(
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
                                        ? "Pending Approve1"
                                        : "Pending Approve2",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    color: Constanst.fgPrimary,
                                    fontSize: 14),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          );
        });
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
}
