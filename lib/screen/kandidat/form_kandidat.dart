// ignore_for_file: deprecated_member_use
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_operasional/controller/kandidat_controller.dart';
import 'package:siscom_operasional/utils/appbar_widget.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/dashed_rect.dart';
import 'package:siscom_operasional/utils/widget_textButton.dart';

class FormKandidat extends StatefulWidget {
  List? dataForm;
  FormKandidat({Key? key, this.dataForm}) : super(key: key);
  @override
  _FormKandidatState createState() => _FormKandidatState();
}

class _FormKandidatState extends State<FormKandidat> {
  var controller = Get.put(KandidatController());

  @override
  void initState() {
    if (widget.dataForm![1] == true) {}

    controller.posisi.value = TextEditingController(text: '');
    controller.selectedKandidatUntuk.value = "BARU";
    controller.kebutuhan.value = TextEditingController(text: '');
    controller.spesifikasi.value = TextEditingController(text: '');
    controller.keterangan.value = TextEditingController(text: '');

    controller.namaFileUpload.value = "";
    controller.filePengajuan.value = File("");
    controller.uploadFile.value = false;
    this.controller.namaFileUpload.refresh();
    this.controller.filePengajuan.refresh();
    this.controller.uploadFile.refresh();

    super.initState();
  }

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
            backgroundColor: Constanst.colorWhite,
            elevation: 0,
            // leadingWidth: controller.statusFormPencarian.value ? 50 : 16,
            titleSpacing: 0,
            centerTitle: true,
            title: Text(
              "Pengajuan Kandidat",
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
                Get.back();
              },
            ),
          ),
        ),
      ),
      body: WillPopScope(
          onWillPop: () async {
            Get.back();
            return true;
          },
          child: SafeArea(
            child: Obx(
              () => Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          border: Border.all(color: Constanst.fgBorder)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          posisi(),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: Divider(
                              height: 0,
                              thickness: 1,
                              color: Constanst.fgBorder,
                            ),
                          ),
                          formTipe(),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: Divider(
                              height: 0,
                              thickness: 1,
                              color: Constanst.fgBorder,
                            ),
                          ),
                          kebutuhan(),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: Divider(
                              height: 0,
                              thickness: 1,
                              color: Constanst.fgBorder,
                            ),
                          ),
                          spesifikasi(),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: Divider(
                              height: 0,
                              thickness: 1,
                              color: Constanst.fgBorder,
                            ),
                          ),
                          formUnggahFile(),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: Divider(
                              height: 0,
                              thickness: 1,
                              color: Constanst.fgBorder,
                            ),
                          ),
                          keterangan(),
                        ],
                      ),
                    ),
                  )),
            ),
          )),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16.0),
            ),
            color: Constanst.colorWhite,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 2.0),
                blurRadius: 12.0,
              )
            ]),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
            child: ElevatedButton(
              onPressed: () {
                controller.validasiKirimPermintaan(widget.dataForm![1]);
              },
              style: ElevatedButton.styleFrom(
                  foregroundColor: Constanst.colorWhite,
                  backgroundColor: Constanst.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                  padding: const EdgeInsets.fromLTRB(0, 12, 0, 12)),
              child: Text(
                'Kirim',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Constanst.colorWhite),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget posisi() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Iconsax.briefcase, size: 24),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Nama Posisi",
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Constanst.fgPrimary),
                ),
                TextFormField(
                  controller: controller.posisi.value,
                  decoration: const InputDecoration(
                    hintText: 'Masukkan nama posisi',
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  style: GoogleFonts.inter(
                      color: Constanst.fgPrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget formTipe() {
    return InkWell(
      onTap: () async {
        await showMenu(
          context: context,
          position: const RelativeRect.fromLTRB(17, 213, 17, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          constraints: const BoxConstraints(
            minWidth: 395.0,
            // minHeight: 50.0,
            maxWidth: 395.0,
            // maxHeight: 100.0,
          ),
          // initialValue: controller.selectedTypeLembur.value,
          items: controller.permintaanKandidatUntuk.value
              .map<PopupMenuItem<String>>((String value) {
            return PopupMenuItem<String>(
              value: value,
              padding: EdgeInsets.zero,
              // onTap: () => controller.selectedTypeCuti.value = value,

              onTap: () {
                controller.selectedKandidatUntuk.value = value;
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
                child: Text(
                  value,
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Constanst.fgPrimary),
                ),
              ),
            );
          }).toList(),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Iconsax.tag_user,
                        size: 26,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Tujuan Permintaan*",
                              style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Constanst.fgPrimary),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              controller.selectedKandidatUntuk.value,
                              style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Constanst.fgPrimary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Iconsax.arrow_down_1,
                    size: 20, color: Constanst.fgPrimary),
              ],
            ),
          ),

          // Container(
          //   height: 50,
          //   decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: Constanst.borderStyle1,
          //       border: Border.all(
          //           width: 0.5, color: Color.fromARGB(255, 211, 205, 205))),
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: DropdownButtonHideUnderline(
          //       child: DropdownButton<String>(
          //         isDense: true,
          //         autofocus: true,
          //         focusColor: Colors.grey,
          //         items: controller.permintaanKandidatUntuk.value
          //             .map<DropdownMenuItem<String>>((String value) {
          //           return DropdownMenuItem<String>(
          //             value: value,
          //             child: Text(
          //               value,
          //               style: TextStyle(fontSize: 14),
          //             ),
          //           );
          //         }).toList(),
          //         value: controller.selectedKandidatUntuk.value,
          //         onChanged: (selectedValue) {
          //           controller.selectedKandidatUntuk.value = selectedValue!;
          //         },
          //         isExpanded: true,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget kebutuhan() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Iconsax.note_2, size: 24),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Jumlah Kebutuhan",
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Constanst.fgPrimary),
                ),
                TextFormField(
                  controller: controller.kebutuhan.value,
                  decoration: const InputDecoration(
                    hintText: 'Masukkan jumlah kebutuhan',
                    border: InputBorder.none,
                  ),
                  onFieldSubmitted: (value) {
                    controller.kebutuhan.value.text = value;
                    this.controller.kebutuhan.refresh();
                  },
                  // maxLines: null,
                  style: GoogleFonts.inter(
                      color: Constanst.fgPrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget spesifikasi() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Iconsax.note_text, size: 24),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Spesifikasi",
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Constanst.fgPrimary),
                ),
                TextFormField(
                  controller: controller.spesifikasi.value,
                  decoration: const InputDecoration(
                    hintText: 'Tulis Spesifikasi disni',
                    border: InputBorder.none,
                  ),
                  onFieldSubmitted: (value) {
                    controller.kebutuhan.value.text = value;
                    this.controller.kebutuhan.refresh();
                  },
                  maxLines: null,
                  style: GoogleFonts.inter(
                      color: Constanst.fgPrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget keterangan() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Iconsax.textalign_justifyleft, size: 24),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Catatan",
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Constanst.fgPrimary),
                ),
                TextFormField(
                  controller: controller.keterangan.value,
                  decoration: const InputDecoration(
                    hintText: 'Tulis catatan disini',
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  style: GoogleFonts.inter(
                      color: Constanst.fgPrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget formUnggahFile() {
    return InkWell(
      onTap: () async {
        controller.takeFile();
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Iconsax.document_upload,
                  size: 26,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Unggah File",
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Constanst.fgPrimary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Ukuran file max 5 MB",
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Constanst.fgSecondary),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            controller.takeFile();
                          },
                          customBorder: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    width: 1.0,
                                    color: const Color.fromARGB(
                                        255, 211, 205, 205))),
                            child: Icon(
                              Iconsax.add,
                              size: 26,
                              color: Constanst.fgSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          controller.namaFileUpload.value.length > 20
                              ? '${controller.namaFileUpload.value.substring(0, 15)}...'
                              : controller.namaFileUpload.value,
                          overflow: TextOverflow.ellipsis,
                        ),
                        controller.namaFileUpload.value == ""
                            ? Container()
                            : InkWell(
                                onTap: () async {
                                  controller.namaFileUpload.value = "";
                                  controller.filePengajuan.value = File("");
                                  controller.uploadFile.value = false;
                                  this.controller.namaFileUpload.refresh();
                                  this.controller.filePengajuan.refresh();
                                  this.controller.uploadFile.refresh();
                                },
                                customBorder: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100))),
                                child: const Icon(
                                  Iconsax.close_circle,
                                  size: 20,
                                  color: Colors.red,
                                ),
                              ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Divider(
              height: 0,
              thickness: 1,
              color: Constanst.fgBorder,
            ),
          ),
        ],
      ),
    );
  }
}
