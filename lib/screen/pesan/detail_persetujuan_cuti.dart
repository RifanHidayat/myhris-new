import 'dart:math';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:siscom_operasional/controller/approval_controller.dart';
import 'package:siscom_operasional/controller/global_controller.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/appbar_widget.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/custom_dialog.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';
import 'package:siscom_operasional/utils/widget_textButton.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPersetujuanCuti extends StatefulWidget {
  String? title, idxDetail, emId, delegasi;

  DetailPersetujuanCuti(
      {Key? key, this.title, this.idxDetail, this.emId, this.delegasi})
      : super(key: key);
  @override
  _DetailPersetujuanCutiState createState() => _DetailPersetujuanCutiState();
}

class _DetailPersetujuanCutiState extends State<DetailPersetujuanCuti> {
  var controller = Get.find<ApprovalController>();
  var controllerGlobal = Get.find<GlobalController>();
  int hours = 0, minutes = 0, second = 0;

  void showBottomApproval(em_id) {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
            initialChildSize: 0.8, // 80% layar
            minChildSize: 0.5, // Bisa mengecil
            maxChildSize: 1.0, // Bisa full screen
            expand: false,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Iconsax.tick_circle,
                                color: Colors.green,
                                size: 24,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 8, top: 2),
                                child: Text(
                                  "Menyetujui",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Obx(() {
                            var sp = controller.searchSp;
                             return controller.searchSp.isNotEmpty
                              ? Container(
                                decoration: BoxDecoration(
                                  color: Constanst.infoLight1,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Iconsax.info_circle5,
                                      color: Constanst.colorPrimary,
                                      size: 26,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        sp[0]['status'] == 'Approve'
                                        ? "Karyawan ${sp[0]['nama']} mempunyai surat peringatan yang sedang aktif dengan nomor ${sp[0]['nomor']} berakhir pada tanggal ${sp[0]['exp']}"
                                        : 'Karyawan ${sp[0]['nama']} mempunyai surat peringatan dengan nomor ${sp[0]['nomor']}, status: ${sp[0]['status']}',
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w400,
                                            color: Constanst.fgSecondary,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              : SizedBox();
                            }
                          ),
                          SizedBox(height: 12),
                          Obx(() {
                            var tl = controller.searchTl;
                             return controller.searchTl.isNotEmpty
                              ? Container(
                                decoration: BoxDecoration(
                                  color: Constanst.infoLight1,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Iconsax.info_circle5,
                                      color: Constanst.colorPrimary,
                                      size: 26,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        tl[0]['status'] == 'Approve'
                                        ? "Karyawan ${tl[0]['nama']} mempunyai teguran lisan yang sedang aktif dengan nomor ${tl[0]['nomor']} berakhir pada tanggal ${tl[0]['exp']}"
                                        : 'Karyawan ${tl[0]['nama']} mempunyai teguran lisan dengan nomor ${tl[0]['nomor']}, status: ${tl[0]['status']}',
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w400,
                                            color: Constanst.fgSecondary,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              : SizedBox();
                            }
                          ),
                          const SizedBox(height: 12),
                          Obx(() {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: List.generate(
                                  controller.listStatusPengajuan.length,
                                  (index) {
                                var data =
                                    controller.listStatusPengajuan[index];
                                return controller.statusPemgajuanIzin.value ==
                                        data['value']
                                    ? Padding(
                                        padding: EdgeInsets.only(top: 12),
                                        child: InkWell(
                                          onTap: () {
                                            controller
                                                    .statusPemgajuanIzin.value =
                                                data['value'].toString();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Constanst.infoLight1,
                                              border: Border.all(
                                                  width: 1,
                                                  color: Constanst.infoLight),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 30,
                                                child: Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 5,
                                                        left: 5,
                                                        bottom: 5),
                                                    child: Row(
                                                      children: [
                                                        TextLabell(
                                                          text: data['name'],
                                                        ),
                                                      ],
                                                    ))),
                                          ),
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          controller.statusPemgajuanIzin.value =
                                              data['value'].toString();
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 12),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: Constanst.secondary),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 30,
                                                child: Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 5,
                                                        left: 5,
                                                        bottom: 5),
                                                    child: Row(
                                                      children: [
                                                        TextLabell(
                                                          text: data['name'],
                                                        ),
                                                      ],
                                                    ))),
                                          ),
                                        ),
                                      );
                              }),
                            );
                          }),
                          const SizedBox(
                            height: 16,
                          ),
                          Obx(() {
                            return controller.statusPemgajuanIzin.value ==
                                    'none'
                                ? SizedBox()
                                : Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                Constanst.borderStyle1,
                                            border: Border.all(
                                                width: 1.0,
                                                color: const Color.fromARGB(
                                                    255, 211, 205, 205))),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left: 8,
                                          ),
                                          child: TextField(
                                            cursorColor: Colors.black,
                                            controller:
                                                controller.alasanReject.value,
                                            maxLines: null,
                                            maxLength: 225,
                                            autofocus: true,
                                            decoration: new InputDecoration(
                                                border: InputBorder.none,
                                                hintText:
                                                    "Pelanggaran yang di lakukan"),
                                            keyboardType:
                                                TextInputType.multiline,
                                            textInputAction:
                                                TextInputAction.done,
                                            style: const TextStyle(
                                                fontSize: 12.0,
                                                height: 2.0,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      TextLabell(
                                        text: "Konsekuensi",
                                        size: 12,
                                        weight: FontWeight.bold,
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Obx(() {
                                        return controller
                                                    .konsekuemsiList.length ==
                                                0
                                            ? Text(
                                                'Buat konsekuensi dengan klik tombol dibawah',
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 11),
                                              )
                                            : Column(
                                                children: List.generate(
                                                    controller.konsekuemsiList
                                                        .length, (index) {
                                                  var data = controller
                                                      .konsekuemsiList[index];
                                                  return Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 90,
                                                          child: TextFormField(
                                                            onChanged: (value) {
                                                              data['konsekuensi'] =
                                                                  value;
                                                            },
                                                            controller:
                                                                TextEditingController(
                                                                    text: data[
                                                                        'konsekuensi']),
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12.0,
                                                                    height: 2.0,
                                                                    color: Colors
                                                                        .black),
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  'Masukan konsekuensi', // Menambahkan teks petunjuk saat field kosong
                                                              border:
                                                                  OutlineInputBorder(), // Menambahkan border di sekitar text field
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Constanst
                                                                        .Secondary), // Warna border saat aktif
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Constanst
                                                                        .Secondary), // Warna border saat field difokuskan
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                            flex: 10,
                                                            child: InkWell(
                                                                onTap: () {
                                                                  controller
                                                                      .konsekuemsiList
                                                                      .removeAt(
                                                                          index);
                                                                  controller
                                                                      .konsekuemsiList
                                                                      .refresh();
                                                                },
                                                                child: Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .red,
                                                                )))
                                                      ],
                                                    ),
                                                  );
                                                }),
                                              );
                                      }),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          controller.konsekuemsiList
                                              .add({"konsekuensi": ""});
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              top: 8, bottom: 8),
                                          decoration: BoxDecoration(
                                              color: Constanst.onPrimary,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                  width: 1,
                                                  color: Constanst.onPrimary)),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add,
                                                color: Colors.white,
                                              ),
                                              TextLabell(
                                                text: "Konsekuensi",
                                                color: Constanst.colorWhite,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                    ],
                                  );
                          }),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextButtonWidget(
                                  title: "Kembali",
                                  onTap: () => Navigator.pop(Get.context!),
                                  colorButton: Colors.red,
                                  colortext: Colors.white,
                                  border: BorderRadius.circular(8.0),
                                ),
                              )),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextButtonWidget(
                                  title: "Menyetujui",
                                  onTap: () {
                                    bool data = controller.konsekuemsiList.any(
                                        (konsekuensi) =>
                                            konsekuensi['konsekuensi']
                                                .trim()
                                                .isEmpty);
                                    if (controller.statusPemgajuanIzin.value !=
                                        'none') {
                                      if (controller.alasanReject.value.text !=
                                          "") {
                                        if (data) {
                                          UtilsAlert.showToast(
                                              "Harap hapus terlebih dahulu konsekuensi yang kosong");
                                          return;
                                        } else {
                                          Navigator.pop(Get.context!);
                                          validasiMenyetujui(true, em_id);
                                          print(controller.konsekuemsiList);
                                        }
                                      } else {
                                        UtilsAlert.showToast(
                                            "Harap isi alasan terlebih dahulu");
                                      }
                                    } else {
                                      Navigator.pop(Get.context!);
                                      print(controller.konsekuemsiList);
                                      validasiMenyetujui(true, em_id);
                                    }
                                  },
                                  colorButton: Constanst.colorPrimary,
                                  colortext: Colors.white,
                                  border: BorderRadius.circular(8.0),
                                ),
                              ))
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    )
                  ],
                ),
              );
            });
      },
    );
  }

  void showBottomAlasanReject(em_id) {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
            initialChildSize: 0.8, // 80% layar
            minChildSize: 0.5, // Bisa mengecil
            maxChildSize: 1.0, // Bisa full screen
            expand: false,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Iconsax.close_circle,
                                color: Colors.red,
                                size: 24,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 8, top: 2),
                                child: Text(
                                  "Tolak",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Obx(() {
                            var sp = controller.searchSp;
                            return controller.searchSp.isNotEmpty
                              ? Container(
                                decoration: BoxDecoration(
                                  color: Constanst.infoLight1,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Iconsax.info_circle5,
                                      color: Constanst.colorPrimary,
                                      size: 26,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        sp[0]['status'] == 'Approve'
                                        ? "Karyawan ${sp[0]['nama']} mempunyai surat peringatan yang sedang aktif dengan nomor ${sp[0]['nomor']} berakhir pada tanggal ${sp[0]['exp']}"
                                        : 'Karyawan ${sp[0]['nama']} mempunyai surat peringatan dengan nomor ${sp[0]['nomor']}, status: ${sp[0]['status']}',
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w400,
                                            color: Constanst.fgSecondary,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              : SizedBox();
                            }
                          ),
                          SizedBox(height: 12),
                          Obx(() {
                            var tl = controller.searchTl;
                             return controller.searchTl.isNotEmpty
                              ? Container(
                                decoration: BoxDecoration(
                                  color: Constanst.infoLight1,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Iconsax.info_circle5,
                                      color: Constanst.colorPrimary,
                                      size: 26,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        tl[0]['status'] == 'Approve'
                                        ? "Karyawan ${tl[0]['nama']} mempunyai teguran lisan yang sedang aktif dengan nomor ${tl[0]['nomor']} berakhir pada tanggal ${tl[0]['exp']}"
                                        : 'Karyawan ${tl[0]['nama']} mempunyai teguran lisan dengan nomor ${tl[0]['nomor']}, status: ${tl[0]['status']}',
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w400,
                                            color: Constanst.fgSecondary,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              : SizedBox();
                            }
                          ),
                          const SizedBox(height: 12),
                          Obx(() {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: List.generate(
                                  controller.listStatusPengajuan.length,
                                  (index) {
                                var data =
                                    controller.listStatusPengajuan[index];
                                return controller.statusPemgajuanIzin.value ==
                                        data['value']
                                    ? Padding(
                                        padding: EdgeInsets.only(top: 12),
                                        child: InkWell(
                                          onTap: () {
                                            controller
                                                    .statusPemgajuanIzin.value =
                                                data['value'].toString();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Constanst.infoLight1,
                                              border: Border.all(
                                                  width: 1,
                                                  color: Constanst.infoLight),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 30,
                                                child: Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 5,
                                                        left: 5,
                                                        bottom: 5),
                                                    child: Row(
                                                      children: [
                                                        TextLabell(
                                                          text: data['name'],
                                                        ),
                                                      ],
                                                    ))),
                                          ),
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          controller.statusPemgajuanIzin.value =
                                              data['value'].toString();
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 12),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: Constanst.secondary),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 30,
                                                child: Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 5,
                                                        left: 5,
                                                        bottom: 5),
                                                    child: Row(
                                                      children: [
                                                        TextLabell(
                                                          text: data['name'],
                                                        ),
                                                      ],
                                                    ))),
                                          ),
                                        ),
                                      );
                              }),
                            );
                          }),
                          const SizedBox(
                            height: 16,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: Constanst.borderStyle1,
                                border: Border.all(
                                    width: 1.0,
                                    color: const Color.fromARGB(
                                        255, 211, 205, 205))),
                            child: Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Obx(() {
                                return TextField(
                                  cursorColor: Colors.black,
                                  controller: controller.alasanReject.value,
                                  maxLines: null,
                                  maxLength: 225,
                                  autofocus: true,
                                  decoration: new InputDecoration(
                                      border: InputBorder.none,
                                      hintText: controller
                                                  .statusPemgajuanIzin.value ==
                                              'none'
                                          ? 'Alasan tolak pengajuan'
                                          : "Pelanggaran yang di lakukan"),
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.done,
                                  style: const TextStyle(
                                      fontSize: 12.0,
                                      height: 2.0,
                                      color: Colors.black),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Obx(() {
                            return controller.statusPemgajuanIzin.value ==
                                    'none'
                                ? SizedBox()
                                : Column(
                                    children: [
                                      TextLabell(
                                        text: "Konsekuensi",
                                        size: 12,
                                        weight: FontWeight.bold,
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Obx(() {
                                        return controller
                                                    .konsekuemsiList.length ==
                                                0
                                            ? Text(
                                                'Buat konsekuensi dengan klik tombol dibawah',
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 11),
                                              )
                                            : Column(
                                                children: List.generate(
                                                    controller.konsekuemsiList
                                                        .length, (index) {
                                                  var data = controller
                                                      .konsekuemsiList[index];
                                                  return Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 90,
                                                          child: TextFormField(
                                                            onChanged: (value) {
                                                              data['konsekuensi'] =
                                                                  value;
                                                            },
                                                            controller:
                                                                TextEditingController(
                                                                    text: data[
                                                                        'konsekuensi']),
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12.0,
                                                                    height: 2.0,
                                                                    color: Colors
                                                                        .black),
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  'Masukan konsekuensi', // Menambahkan teks petunjuk saat field kosong
                                                              border:
                                                                  OutlineInputBorder(), // Menambahkan border di sekitar text field
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Constanst
                                                                        .Secondary), // Warna border saat aktif
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Constanst
                                                                        .Secondary), // Warna border saat field difokuskan
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                            flex: 10,
                                                            child: InkWell(
                                                                onTap: () {
                                                                  controller
                                                                      .konsekuemsiList
                                                                      .removeAt(
                                                                          index);
                                                                  controller
                                                                      .konsekuemsiList
                                                                      .refresh();
                                                                },
                                                                child: Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .red,
                                                                )))
                                                      ],
                                                    ),
                                                  );
                                                }),
                                              );
                                      }),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          controller.konsekuemsiList
                                              .add({'konsekuensi': ''});
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              top: 8, bottom: 8),
                                          decoration: BoxDecoration(
                                              color: Constanst.onPrimary,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                  width: 1,
                                                  color: Constanst.onPrimary)),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add,
                                                color: Colors.white,
                                              ),
                                              TextLabell(
                                                text: "Konsekuensi",
                                                color: Constanst.colorWhite,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                    ],
                                  );
                          }),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextButtonWidget(
                                  title: "Kembali",
                                  onTap: () => Navigator.pop(Get.context!),
                                  colorButton: Colors.red,
                                  colortext: Colors.white,
                                  border: BorderRadius.circular(8.0),
                                ),
                              )),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextButtonWidget(
                                  title: "Tolak",
                                  onTap: () {
                                    bool data = controller.konsekuemsiList.any(
                                        (konsekuensi) =>
                                            konsekuensi['konsekuensi']
                                                .trim()
                                                .isEmpty);
                                    if (controller.alasanReject.value.text !=
                                        "") {
                                      if (controller
                                              .statusPemgajuanIzin.value !=
                                          'none') {
                                        if (data) {
                                          UtilsAlert.showToast(
                                              "Harap hapus terlebih dahulu konsekuensi yang kosong");
                                          return;
                                        } else {
                                          Navigator.pop(Get.context!);
                                          print(
                                              'ini list ${controller.konsekuemsiList}');
                                          validasiMenyetujui(false, em_id);

                                        }
                                      } else {
                                        Navigator.pop(Get.context!);
                                        validasiMenyetujui(false, em_id);
                                      }
                                    } else {
                                      UtilsAlert.showToast(
                                          "Harap isi alasan terlebih dahulu");
                                    }
                                  },
                                  colorButton: Constanst.colorPrimary,
                                  colortext: Colors.white,
                                  border: BorderRadius.circular(8.0),
                                ),
                              ))
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    )
                  ],
                ),
              );
            });
      },
    );
  }

  // void showBottomAlasanReject(em_id) {
  //   showModalBottomSheet(
  //     context: Get.context!,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(
  //         top: Radius.circular(20.0),
  //       ),
  //     ),
  //     builder: (context) {
  //       return Column(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           const SizedBox(
  //             height: 30,
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.only(left: 16, right: 16),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 const Row(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   children: [
  //                     Icon(
  //                       Iconsax.close_circle,
  //                       color: Colors.red,
  //                       size: 24,
  //                     ),
  //                     Padding(
  //                       padding: EdgeInsets.only(left: 8, top: 2),
  //                       child: Text(
  //                         "Alasan Tolak Pengajuan",
  //                         style: TextStyle(
  //                             fontWeight: FontWeight.bold, fontSize: 14),
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //                 const SizedBox(
  //                   height: 16,
  //                 ),
  //                 Container(
  //                   decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       borderRadius: Constanst.borderStyle1,
  //                       border: Border.all(
  //                           width: 1.0,
  //                           color: const Color.fromARGB(255, 211, 205, 205))),
  //                   child: Padding(
  //                     padding: EdgeInsets.only(
  //                         left: 8,
  //                         bottom: MediaQuery.of(context).viewInsets.bottom),
  //                     child: TextField(
  //                       cursorColor: Colors.black,
  //                       controller: controller.alasanReject.value,
  //                       maxLines: null,
  //                       maxLength: 225,
  //                       autofocus: true,
  //                       decoration: new InputDecoration(
  //                           border: InputBorder.none,
  //                           hintText: "Alasan Menolak"),
  //                       keyboardType: TextInputType.multiline,
  //                       textInputAction: TextInputAction.done,
  //                       style: const TextStyle(
  //                           fontSize: 12.0, height: 2.0, color: Colors.black),
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(
  //                   height: 16,
  //                 ),
  //                 Row(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Expanded(
  //                         child: Padding(
  //                       padding: const EdgeInsets.all(8.0),
  //                       child: TextButtonWidget(
  //                         title: "Kembali",
  //                         onTap: () => Navigator.pop(Get.context!),
  //                         colorButton: Colors.red,
  //                         colortext: Colors.white,
  //                         border: BorderRadius.circular(8.0),
  //                       ),
  //                     )),
  //                     Expanded(
  //                         child: Padding(
  //                       padding: const EdgeInsets.all(8.0),
  //                       child: TextButtonWidget(
  //                         title: "Tolak",
  //                         onTap: () {
  //                           if (controller.alasanReject.value.text != "") {
  //                             Navigator.pop(Get.context!);
  //                             validasiMenyetujui(false, em_id);
  //                           } else {
  //                             UtilsAlert.showToast(
  //                                 "Harap isi alasan terlebih dahulu");
  //                           }
  //                         },
  //                         colorButton: Constanst.colorPrimary,
  //                         colortext: Colors.white,
  //                         border: BorderRadius.circular(8.0),
  //                       ),
  //                     ))
  //                   ],
  //                 )
  //               ],
  //             ),
  //           ),
  //           const SizedBox(
  //             height: 30,
  //           )
  //         ],
  //       );
  //     },
  //   );
  // }

  void validasiMenyetujui(pilihan, em_id) {
    int styleChose = pilihan == false ? 1 : 2;
    var stringPilihan = pilihan == false ? 'Tolak' : 'Menyetujui';
    showGeneralDialog(
      barrierDismissible: false,
      context: Get.context!,
      barrierColor: Colors.black54, // space around dialog
      transitionDuration: const Duration(milliseconds: 200),
      transitionBuilder: (context, a1, a2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
              parent: a1,
              curve: Curves.elasticOut,
              reverseCurve: Curves.easeOutCubic),
          child: CustomDialog(
            // our custom dialog
            title: "Peringatan",
            content: "Yakin $stringPilihan Pengajuan ini ?",
            positiveBtnText: "Lanjutkan",
            negativeBtnText: "Kembali",
            style: styleChose,
            buttonStatus: 1,
            positiveBtnPressed: () {
              print(controller.detailData[0]);
              if (controller.detailData[0]['type'] == 'absensi') {
                print("masuk sini ${controller.detailData[0]['type']}");
                controller.approvalAbsensi(
                    pilihan: pilihan,
                    date:
                        controller.detailData[0]['waktu_pengajuan'].toString(),
                    status: styleChose.toString(),
                    checkin: controller.detailData[0]['dari_jam'].toString(),
                    checkout: controller.detailData[0]['sampai_jam'].toString(),
                    image: controller.detailData[0]['file'].toString(),
                    note: controller.detailData[0]['deskripsi'].toString(),
                    ajuanEmid: controller.detailData[0]['em_id'].toString(),
                    id: controller.detailData[0]['id'].toString());
              } else {
                UtilsAlert.loadingSimpanData(
                    Get.context!, "Proses $stringPilihan pengajuan");
                controller.aksiMenyetujui(pilihan);
              }
              controllerGlobal.kirimNotifikasi(
                  title: 'Cuti',
                  status: 'approve',
                  pola: controllerGlobal.valuePolaPersetujuan.value.toString(),
                  statusApproval: controller.valuePolaPersetujuan == 1 ||
                          controller.valuePolaPersetujuan == "1"
                      ? "1"
                      : controller.valuePolaPersetujuan == 2 ||
                              controller.valuePolaPersetujuan == "2"
                          ? controller.detailData[0]['nama_approve1'] == "" ||
                                  controller.detailData[0]['nama_approve1'] ==
                                      "null" ||
                                  controller.detailData[0]['nama_approve1'] ==
                                      null
                              ? "1"
                              : "2"
                          : "1",
                  emId: em_id,
                  nomor: controller.detailData[0]['nomor_ajuan'],
                  emIdApproval1: controller.detailData[0]['em_report_to'],
                  emIdApproval2: controller.detailData[0]['em_report2_to'] ==
                              "" ||
                          controller.detailData[0]['em_report2_to'] == "null" ||
                          controller.detailData[0]['em_report2_to'] == null
                      ? controller.detailData[0]['em_report_to']
                      : controller.detailData[0]['em_report2_to'],
                  delegasi: widget.delegasi,
                  id: widget.idxDetail);
            },
          ),
        );
      },
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return null!;
      },
    );
  }

  @override
  void initState() {
    print(controller.detailData);
    controller.statusPemgajuanIzin.value = "none";
    controller.konsekuemsiList.clear();
    controller.getDetailData(
        widget.idxDetail, widget.emId, widget.title, widget.delegasi);
    print('ini apa yak ${widget.emId}');
    print('ini apa yak ${controller.jumlahCuti}');
    print('ini apa yak ${widget.title}');

    super.initState();
    var emId = AppData.informasiUser![0].em_id;

    if (controllerGlobal.valuePolaPersetujuan.value.toString() == "1") {
      if (controller.detailData[0]['nama_approve1'] == "" ||
          controller.detailData[0]['nama_approve1'] == "null" ||
          controller.detailData[0]['nama_approve1'] == null) {
        if (controller.detailData[0]['em_report_to']
            .toString()
            .contains(emId)) {
          controller.showButton.value = true;
        } else {
          controller.showButton.value = false;
        }
      } else {}
    } else {
      if (controller.detailData[0]['nama_approve1'] == "" ||
          controller.detailData[0]['nama_approve1'] == "null" ||
          controller.detailData[0]['nama_approve1'] == null) {
        if (controller.detailData[0]['em_report_to']
            .toString()
            .contains(emId)) {
          controller.showButton.value = true;
        } else {
          controller.showButton.value = false;
        }
      } else {
        if (controller.detailData[0]['em_report2_to'] == "" ||
            controller.detailData[0]['em_report2_to'] == "null" ||
            controller.detailData[0]['em_report2_to'] == null) {
          if (controller.detailData[0]['em_report_to']
              .toString()
              .contains(emId)) {
            controller.showButton.value = true;
          } else {
            controller.showButton.value = false;
          }
        } else {
          if (controller.detailData[0]['em_report2_to']
              .toString()
              .contains(emId)) {
            controller.showButton.value = true;
          } else {
            controller.showButton.value = false;
          }
        }
      }
    }

    if (controller.detailData[0]['type'].toString().toLowerCase() ==
        "Lembur".toString().toLowerCase()) {
      DateTime start = DateTime.parse(
          "${controller.detailData[0]['waktu_pengajuan']} ${controller.detailData[0]['waktu_dari']}");
      DateTime end = DateTime.parse(
          "${controller.detailData[0]['waktu_pengajuan']} ${controller.detailData[0]['waktu_sampai']}");

      Duration difference = end.difference(start);

      hours = difference.inHours;
      minutes = (difference.inMinutes % 60);
      second = (difference.inSeconds % 60);
    }
  }

  @override
  Widget build(BuildContext context) {
    
    var cutLeave = controller.detailData[0]['cut_leave'];
    print('ini cut_leave ${cutLeave}');
    var totalKlaim = controller.detailData[0]['type'] == "Klaim"
        ? controller.detailData[0]['lainnya']['total_claim']
        : 0;
    var rupiah = controller.convertToIdr(totalKlaim, 0);
    var namaTipe = controller.detailData[0]['type'] == "Klaim"
        ? controller.detailData[0]['lainnya']['nama_tipe']
        : "";
    var image = controller.detailData[0]['image'];
    var typeAjuan = controller.detailData[0]['leave_status'];
    var em_id = controller.detailData[0]['emId_pengaju'];
    print('ini show button ${controller.showButton.value}');
    return Scaffold(
      backgroundColor: Constanst.coloBackgroundScreen,
      // appBar: AppBar(
      //   backgroundColor: Constanst.colorPrimary,
      //   automaticallyImplyLeading: false,
      //   elevation: 2,
      //   flexibleSpace: AppbarMenu1(
      //     title: "Detail Persetujuan Izin",
      //     colorTitle: Colors.white,
      //     colorIcon: Colors.white,
      //     iconShow: true,
      //     icon: 1,
      //     onTap: () {
      //       controller.alasanReject.value.text = "";
      //       Get.back();
      //     },
      //   ),
      // ),
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
              title: Text(
                "Detail Persetujuan Cuti",
                style: GoogleFonts.inter(
                    color: Constanst.fgPrimary,
                    fontWeight: FontWeight.w500,
                    fontSize: 20),
              ),
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
                        controller.alasanReject.value.text = "";
                        Get.back();
                      },
                    ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: typeAjuan == "Approve2"
          ? const SizedBox()
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(() => controller.showButton.value == true &&
                      (controller.detailData[0]['leave_status'] == "Pending" ||
                          controller.detailData[0]['apply_status'] ==
                              "Pending" ||
                          (controller.detailData[0]['apply2_status'] ==
                                  "Pending" &&
                              controller.detailData[0]['apply_status'] !=
                                  "Rejected"))
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            height: 40,
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Constanst
                                    .border, // Set the desired border color
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                print(AppData.informasiUser![0].em_id);
                                print(controller.detailData[0]['em_report_to']);
                                print(
                                    controller.detailData[0]['em_report2_to']);
                                // print("tes");
                                showBottomAlasanReject(em_id);
                              },
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: Constanst.color4,
                                  backgroundColor: Constanst.colorWhite,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 0,
                                  // padding: EdgeInsets.zero,
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0)),
                              child: Text(
                                'Tolak',
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    color: Constanst.color4,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {
                                // validasiMenyetujui(true, em_id);

                                if ((controller.valuePolaPersetujuan == 2 ||
                                        controller.valuePolaPersetujuan ==
                                            "2") &&
                                    typeAjuan == 'Approve 1') {
                                  showBottomApproval(em_id);

                                  return;
                                }
                                if ((controller.valuePolaPersetujuan == 1 ||
                                        controller.valuePolaPersetujuan ==
                                            "1") &&
                                    typeAjuan == 'Pending') {
                                  showBottomApproval(em_id);

                                  return;
                                }
                                validasiMenyetujui(true, em_id);
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Constanst.colorWhite,
                                backgroundColor: Constanst.colorPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                                // padding: const EdgeInsets.fromLTRB(20, 12, 20, 12)
                              ),
                              child: Text(
                                'Menyetujui',
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    color: Constanst.colorWhite,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox()),
            ),
      body: WillPopScope(
          onWillPop: () async {
            controller.alasanReject.value.text = "";
            Get.back();
            return true;
          },
          child: SafeArea(
            child: Obx(
              () => Padding(
                padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       cutLeave == 0
                          ? const SizedBox()
                          : informasiSisaCuti(),
                      cutLeave == 0
                          ? const SizedBox()
                          : const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            border: Border.all(
                                width: 0.5,
                                color:
                                    const Color.fromARGB(255, 211, 205, 205))),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  image == ""
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
                                                      "${Api.UrlfotoProfile}${image}",
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
                                                      width: 42,
                                                      height: 42,
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
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${controller.detailData[0]['nama_pengaju']}",
                                          style: GoogleFonts.inter(
                                              color: Constanst.fgPrimary,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          controller.detailData[0]
                                                  ['nama_divisi'] ??
                                              "",
                                          style: GoogleFonts.inter(
                                              color: Constanst.fgSecondary,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 12.0, bottom: 12.0),
                                child: Divider(
                                  height: 0,
                                  color: Constanst.fgBorder,
                                  thickness: 1,
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "No. Pengajuan",
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            color: Constanst.fgSecondary,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          controller.detailData[0]
                                                  ['nomor_ajuan']
                                              .toString(),
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: Constanst.fgPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Tanggal Pengajuan",
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            color: Constanst.fgSecondary,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          Constanst.convertDate6(
                                              "${controller.detailData[0]['waktu_pengajuan']}"),
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: Constanst.fgPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            border: Border.all(
                                width: 0.5,
                                color:
                                    const Color.fromARGB(255, 211, 205, 205))),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Nama Pengajuan",
                                style: GoogleFonts.inter(
                                    color: Constanst.fgSecondary,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              // controller.detailData[0]['type']
                              //                 .toString()
                              //                 .toLowerCase() ==
                              //             "Cuti".toString().toLowerCase() ||
                              //         controller.detailData[0]['type']
                              //                 .toString()
                              //                 .toLowerCase() ==
                              //             "Lembur".toString().toLowerCase()
                              //     ? Text(
                              //         "${controller.detailData[0]['nama_pengajuan']} ",
                              //         style: GoogleFonts.inter(
                              //             color: Constanst.fgPrimary,
                              //             fontWeight: FontWeight.w500,
                              //             fontSize: 16),
                              //       )
                              //     : Text(
                              //         "${controller.detailData[0]['type']} $namaTipe - ${controller.detailData[0]['category']}",
                              //         style: GoogleFonts.inter(
                              //             color: Constanst.fgPrimary,
                              //             fontWeight: FontWeight.w500,
                              //             fontSize: 16),
                              //       ),
                              Text(
                                "${controller.detailData[0]['nama_tipe']} - ${controller.detailData[0]['category']}",
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    color: Constanst.fgPrimary,
                                    fontSize: 16),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 12.0, bottom: 12.0),
                                child: Divider(
                                  thickness: 1,
                                  height: 0,
                                  color: Constanst.border,
                                ),
                              ),
                              Text(
                                "Tanggal Cuti",
                                style: GoogleFonts.inter(
                                    color: Constanst.fgSecondary,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              controller.detailData[0]['type'] == "Klaim"
                                  ? const SizedBox()
                                  : Text(
                                      "${"${controller.detailData[0]['waktu_dari']}"} - ${"${controller.detailData[0]['waktu_sampai']}"}",
                                      style: GoogleFonts.inter(
                                          color: Constanst.fgPrimary,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                    ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 12.0, bottom: 12.0),
                                child: Divider(
                                  thickness: 1,
                                  height: 0,
                                  color: Constanst.border,
                                ),
                              ),
                              controller.detailData[0]['durasi'] == "" ||
                                      controller.detailData[0]['durasi'] == null
                                  ? const SizedBox()
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Durasi",
                                          style: GoogleFonts.inter(
                                              color: Constanst.fgSecondary,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "${controller.detailData[0]['durasi']} Hari",
                                          style: GoogleFonts.inter(
                                              color: Constanst.fgPrimary,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 12.0, bottom: 12.0),
                                child: Divider(
                                  thickness: 1,
                                  height: 0,
                                  color: Constanst.border,
                                ),
                              ),
                              Text(
                                "Catatan",
                                style: GoogleFonts.inter(
                                    color: Constanst.fgSecondary,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                controller.detailData[0]['type'] == "absensi"
                                    ? "${controller.detailData[0]['deskripsi']}"
                                    : "${controller.detailData[0]['catatan']}",
                                style: GoogleFonts.inter(
                                    color: Constanst.fgPrimary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),

                              // controller.detailData[0]['type']
                              //             .toString()
                              //             .toLowerCase() ==
                              //         'absensi'.toLowerCase()
                              //     ? SizedBox()
                              //     : controller.detailData[0]['type'] ==
                              //                 "Lembur" ||
                              //             controller.detailData[0]['type'] ==
                              //                 "Tugas Luar" ||
                              //             controller.detailData[0]['type'] ==
                              //                 "Dinas Luar"
                              //         ? Text(
                              //             "Pemberi Tugas",
                              //             style: TextStyle(
                              //                 color: Constanst.colorText2),
                              //           )
                              //         : controller.detailData[0]['type'] ==
                              //                 "Klaim"
                              //             ? Text(
                              //                 "Total Klaim",
                              //                 style: TextStyle(
                              //                     color: Constanst.colorText2),
                              //               )
                              //             : Text(
                              //                 "Delegasi Kepada",
                              //                 style: TextStyle(
                              //                     color: Constanst.colorText2),
                              //               ),

                              controller.detailData[0]['file'] == "" ||
                                      controller.detailData[0]['file'] == null
                                  ? const SizedBox()
                                  : fileWidget(),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 12.0, bottom: 12.0),
                                child: Divider(
                                  thickness: 1,
                                  height: 0,
                                  color: Constanst.border,
                                ),
                              ),
                              controller.valuePolaPersetujuan == 1 ||
                                      controller.valuePolaPersetujuan == "1"
                                  ? singgleApproval(controller.detailData[0])
                                  : multipleApproval(controller.detailData[0])

                              // Padding(
                              //   padding: const EdgeInsets.only(
                              //       top: 12.0, bottom: 12.0),
                              //   child: Divider(
                              //     thickness: 1,
                              //     height: 0,
                              //     color: Constanst.border,
                              //   ),
                              // ),

                              // typeAjuan == 'Rejected'
                              //     ? Row(
                              //         crossAxisAlignment:
                              //             CrossAxisAlignment.start,
                              //         children: [
                              //           Icon(
                              //             Iconsax.close_circle,
                              //             color: Constanst.color4,
                              //             size: 22,
                              //           ),
                              //           const SizedBox(width: 8),
                              //           Column(
                              //             crossAxisAlignment:
                              //                 CrossAxisAlignment.start,
                              //             children: [
                              //               Text(
                              //                 "Status Pengajuan",
                              //                 style: GoogleFonts.inter(
                              //                   fontWeight: FontWeight.w400,
                              //                   fontSize: 14,
                              //                   color: Constanst.fgSecondary,
                              //                 ),
                              //               ),
                              //               const SizedBox(height: 4),
                              //               Text(
                              //                   "Rejected by ${controller.detailData[0]['nama_approve1']}",
                              //                   style: GoogleFonts.inter(
                              //                       fontWeight: FontWeight.w500,
                              //                       color: Constanst.fgPrimary,
                              //                       fontSize: 14)),
                              //               const SizedBox(height: 4),
                              //               Text(
                              //                 controller.detailData[0]['catatan'],
                              //                 style: GoogleFonts.inter(
                              //                     fontWeight: FontWeight.w400,
                              //                     color: Constanst.fgSecondary,
                              //                     fontSize: 14),
                              //               )
                              //             ],
                              //           ),
                              //         ],
                              //       )
                              //     : typeAjuan == "Approve" ||
                              //             typeAjuan == "Approve1"
                              //         ? Row(
                              //             crossAxisAlignment:
                              //                 CrossAxisAlignment.start,
                              //             children: [
                              //               const Icon(
                              //                 Iconsax.tick_circle,
                              //                 color: Colors.green,
                              //                 size: 22,
                              //               ),
                              //               const SizedBox(width: 8),
                              //               Column(
                              //                 crossAxisAlignment:
                              //                     CrossAxisAlignment.start,
                              //                 children: [
                              //                   Text(
                              //                     "Status Pengajuan",
                              //                     style: GoogleFonts.inter(
                              //                       fontWeight: FontWeight.w400,
                              //                       fontSize: 14,
                              //                       color: Constanst.fgSecondary,
                              //                     ),
                              //                   ),
                              //                   const SizedBox(height: 4),
                              //                   Text(
                              //                       "Approved 1 by ${controller.detailData[0]['nama_approve1']} ",
                              //                       style: GoogleFonts.inter(
                              //                           fontWeight:
                              //                               FontWeight.w500,
                              //                           color:
                              //                               Constanst.fgPrimary,
                              //                           fontSize: 14)),
                              //                 ],
                              //               ),
                              //             ],
                              //           )    : typeAjuan == "Approve2"
                              //         ? Row(
                              //             crossAxisAlignment:
                              //                 CrossAxisAlignment.start,
                              //             children: [
                              //               const Icon(
                              //                 Iconsax.tick_circle,
                              //                 color: Colors.green,
                              //                 size: 22,
                              //               ),
                              //               const SizedBox(width: 8),
                              //               Column(
                              //                 crossAxisAlignment:
                              //                     CrossAxisAlignment.start,
                              //                 children: [
                              //                   Text(
                              //                     "Status Pengajuan",
                              //                     style: GoogleFonts.inter(
                              //                       fontWeight: FontWeight.w400,
                              //                       fontSize: 14,
                              //                       color: Constanst.fgSecondary,
                              //                     ),
                              //                   ),
                              //                   const SizedBox(height: 4),
                              //                   Text(
                              //                       "Approved 2 by ${controller.detailData[0]['nama_approve2']??""} ",
                              //                       style: GoogleFonts.inter(
                              //                           fontWeight:
                              //                               FontWeight.w500,
                              //                           color:
                              //                               Constanst.fgPrimary,
                              //                           fontSize: 14)),
                              //                 ],
                              //               ),
                              //             ],
                              //           )
                              //         : Row(
                              //             crossAxisAlignment:
                              //                 CrossAxisAlignment.start,
                              //             children: [
                              //               Icon(
                              //                 Iconsax.timer,
                              //                 color: Constanst.color3,
                              //                 size: 22,
                              //               ),
                              //               const SizedBox(width: 8),
                              //               Column(
                              //                 crossAxisAlignment:
                              //                     CrossAxisAlignment.start,
                              //                 children: [
                              //                   Text(
                              //                     "Status Pengajuan",
                              //                     style: GoogleFonts.inter(
                              //                       fontWeight: FontWeight.w400,
                              //                       fontSize: 14,
                              //                       color: Constanst.fgSecondary,
                              //                     ),
                              //                   ),
                              //                   const SizedBox(height: 4),
                              //                   Text("Pending Approval",
                              //                       style: GoogleFonts.inter(
                              //                           fontWeight:
                              //                               FontWeight.w500,
                              //                           color:
                              //                               Constanst.fgPrimary,
                              //                           fontSize: 14)),
                              //                   const SizedBox(height: 4),
                              //                   // InkWell(
                              //                   //     onTap: () {
                              //                   //       var dataEmployee = {
                              //                   //         'nameType': '$namaTypeAjuan',
                              //                   //         'nomor_ajuan': '$nomorAjuan',
                              //                   //       };
                              //                   //       controllerGlobal
                              //                   //           .showDataPilihAtasan(dataEmployee);
                              //                   //     },
                              //                   //     child: Text("Konfirmasi via Whatsapp",
                              //                   //         style: GoogleFonts.inter(
                              //                   //             fontWeight: FontWeight.w400,
                              //                   //             color: Constanst.infoLight,
                              //                   //             fontSize: 14))),
                              //                 ],
                              //               ),
                              //             ],
                              //           ),
                              // controllerGlobal.valuePolaPersetujuan.value ==
                              //             "1" ||
                              //         controller.detailData[0]['nama_approve1'] ==
                              //             "" ||
                              //         controller.detailData[0]['nama_approve1'] ==
                              //             "null" ||
                              //         controller.detailData[0]['nama_approve1'] ==
                              //             null
                              //     ? const SizedBox()
                              //     : infoApprove1(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }

  Widget fileWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
          child: Divider(
            thickness: 1,
            height: 0,
            color: Constanst.border,
          ),
        ),
        Text(
          "File disematkan",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Constanst.fgSecondary,
          ),
        ),
        const SizedBox(height: 4),
        InkWell(
            onTap: () {
              if (controller.detailData[0]['title_ajuan'] ==
                  "Pengajuan Tidak Hadir") {
                controller.viewFile(
                    "tidak_hadir", controller.detailData[0]['file']);
              } else if (controller.detailData[0]['title_ajuan'] ==
                  "Pengajuan Cuti") {
                controller.viewFile("cuti", controller.detailData[0]['file']);
              } else if (controller.detailData[0]['title_ajuan'] ==
                  "Pengajuan Klaim") {
                controller.viewFile("klaim", controller.detailData[0]['file']);
              } else if (controller.detailData[0]['title_ajuan'] ==
                  "Pengajuan Absensi") {
                viewLampiranAjuan(controller.detailData[0]['file']);
              }
            },
            child: Text(
              "${controller.detailData[0]['file']}",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Constanst.infoLight,
              ),
            )),
        // const SizedBox(height: 12),
      ],
    );
  }

  Widget infoApprove1() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Iconsax.tick_circle,
          color: Colors.green,
          size: 22,
        ),
        const SizedBox(width: 8),
        Text(
          "Approve 1 by ${controller.detailData[0]['nama_approve1']}",
          style: TextStyle(color: Constanst.colorText2),
        ),
      ],
    );
  }

  Widget informasiSisaCuti() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          border: Border.all(
              width: 0.5, color: const Color.fromARGB(255, 211, 205, 205))),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 12, bottom: 12, left: 16, right: 16),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      "SISA CUTI ${controller.detailData[0]['nama_pengaju']}",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        color: Constanst.fgPrimary,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.visible, // Allow text to wrap
                      maxLines: 2, // Set max lines to 2 or more
                    ),
                  ),
                  Text(
                    "${controller.cutiTerpakai.value}/${controller.jumlahCuti.value}",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      color: Constanst.fgSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // SizedBox(
              //   width: MediaQuery.of(Get.context!).size.width,
              //   child: LinearPercentIndicator(
              //     barRadius: const Radius.circular(100.0),
              //     lineHeight: 8.0,
              //     padding: EdgeInsets.zero,
              //     percent: controller.persenCuti.value,
              //     progressColor: Constanst.colorPrimary,
              //   ),
              // ),

              // Text("Cuti Khusus"),
            ],
          ),
        ),
      ),
    );
  }

  Widget informasiIzinJam() {
    return SizedBox(
      child: controller.detailData[0]['category'] == "HALFDAY"
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Kategori",
                  style: TextStyle(color: Constanst.colorText2),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "${controller.detailData[0]['category']}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Jam",
                  style: TextStyle(color: Constanst.colorText2),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "${controller.detailData[0]['jamAjuan']} sd ${controller.detailData[0]['sampaiJamAjaun']}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            )
          : const SizedBox(),
    );
  }

  void viewLampiranAjuan(value) async {
    var urlViewGambar = Api.UrlfotoAbsen + value;

    final url = Uri.parse(urlViewGambar);
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      UtilsAlert.showToast('Tidak dapat membuka file');
    }
  }

  Widget singgleApproval(data) {
    var text = "";
    if (data['apply_status'] == "Pending" ||
        data['leave_status'] == "Pending") {
      text = "Pending Approval";
    }
    if (data['apply_status'] == "Rejected") {
      text = "Rejected by - ${data['nama_approve1']}";
    }
    if (data['apply_status'] == "Approve") {
      text = "Approved by - ${data['nama_approve1']}";
    }
    return Container(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Status Pengajuan",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Constanst.fgSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      data['apply_status'] == "Pending" ||
                              data['leave_status'] == "Pending"
                          ? Icon(
                              Iconsax.timer,
                              color: Constanst.warning,
                              size: 22,
                            )
                          : data['apply_status'] == "Rejected"
                              ? const Icon(
                                  Iconsax.tick_circle,
                                  color: Colors.green,
                                  size: 22,
                                )
                              : const Icon(
                                  Iconsax.tick_circle,
                                  color: Colors.green,
                                  size: 22,
                                ),
                      // Icon(
                      //   Iconsax.close_circle,
                      //   color: Constanst.color4,
                      //   size: 22,
                      // ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${text} ",
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  color: Constanst.fgPrimary,
                                  fontSize: 14)),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget multipleApproval(data) {
    var text = "";
    var text2 = "";
    if (data['apply_status'] == "Pending" ||
        data['leave_status'] == "Pending") {
      text = "Pending Approval 1";
    }
    if (data['apply_status'] == "Rejected") {
      text = "Rejected By - ${data['nama_approve1']}";
    }

    if (data['apply_status'] == "Approve") {
      text = "Approve 1 By - ${data['nama_approve1']}";

      if (data['apply2_status'] == "Pending") {
        text2 = "Pending Approval 2";
      }
      if (data['apply2_status'] == "Rejected") {
        text2 = "Rejected 2 By - ${data['nama_approve2']}";
      }

      if (data['apply2_status'] == "Approve") {
        text2 = "Approve 2 By - ${data['nama_approve2']} ";
      }
    }
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Status Pengajuan",
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Constanst.fgSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              data['apply_status'] == "Pending"
                  ? Icon(
                      Iconsax.timer,
                      color: Constanst.warning,
                      size: 22,
                    )
                  : data['apply_status'] == "Rejected"
                      ? const Icon(
                          Iconsax.close_circle,
                          color: Colors.red,
                          size: 22,
                        )
                      : const Icon(
                          Iconsax.tick_circle,
                          color: Colors.green,
                          size: 22,
                        ),
              // Icon(
              //   Iconsax.close_circle,
              //   color: Constanst.color4,
              //   size: 22,
              // ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${text} ",
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          color: Constanst.fgPrimary,
                          fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ],
          ),
          data['apply_status'] == "Approve"
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 2.5, top: 2, bottom: 2),
                      child: Container(
                        height: 30,
                        child: VerticalDivider(
                          color: Constanst.Secondary,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          data['apply2_status'] == "Pending"
                              ? Icon(
                                  Iconsax.timer,
                                  color: Constanst.warning,
                                  size: 22,
                                )
                              : data['apply2_status'] == "Rejected"
                                  ? const Icon(
                                      Iconsax.close_circle,
                                      color: Colors.red,
                                      size: 22,
                                    )
                                  : const Icon(
                                      Iconsax.tick_circle,
                                      color: Colors.green,
                                      size: 22,
                                    ),
                          // Icon(
                          //   Iconsax.close_circle,
                          //   color: Constanst.color4,
                          //   size: 22,
                          // ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "${text2} ",
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  color: Constanst.fgPrimary,
                                  fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                  ],
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
