// ignore_for_file: deprecated_member_use
import 'dart:io';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/klaim_controller.dart';
import 'package:siscom_operasional/controller/lembur_controller.dart';
import 'package:siscom_operasional/controller/pesan_controller.dart';
import 'package:siscom_operasional/screen/absen/lembur.dart';
import 'package:siscom_operasional/screen/init_screen.dart';
import 'package:siscom_operasional/utils/appbar_widget.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/dashed_rect.dart';
import 'package:siscom_operasional/utils/widget_textButton.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class FormKlaim extends StatefulWidget {
  List? dataForm;
  FormKlaim({Key? key, this.dataForm}) : super(key: key);
  @override
  _FormKlaimState createState() => _FormKlaimState();
}

class _FormKlaimState extends State<FormKlaim> {
  var controller = Get.put(KlaimController());

  @override
  void initState() {
    print(widget.dataForm![0]);
    if (widget.dataForm![1] == true) {
      // check id dan nomor ajuan
      controller.idpengajuanKlaim.value = "${widget.dataForm![0]['id']}";
      controller.nomorAjuan.value.text =
          "${widget.dataForm![0]['nomor_ajuan']}";
      controller.statusForm.value = true;
      // check type
      controller.checkTypeEdit(widget.dataForm![0]['cost_id']);
      // check tanggal klaim
      DateTime fltr1 = DateTime.parse("${widget.dataForm![0]['tgl_ajuan']}");
      controller.tanggalTerpilih.value =
          "${DateFormat('yyyy-MM-dd').format(fltr1)}";
      controller.tanggalShow.value =
          "${DateFormat('dd MMMM yyyy').format(fltr1)}";
      // check total klaim
      var totalKlaim = widget.dataForm![0]['total_claim'];
      var convertTotal = controller.convertToIdr(totalKlaim, 0);
      controller.totalKlaim.value.text = convertTotal;
      // check file
      var namaFile = widget.dataForm![0]['nama_file'];
      controller.namaFileUpload.value = namaFile == "" ? "" : namaFile;
      // check catatan
      controller.catatan.value.text = widget.dataForm![0]['description'];
      // check tanggal klaim / created on
      DateTime ftr1 = DateTime.parse(widget.dataForm![0]['created_on']);
      var filterTanggal = "${DateFormat('yyyy-MM-dd').format(ftr1)}";
      controller.tanggalKlaim.value.text = filterTanggal;
    }
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
              "Pengajuan Klaim",
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
              // onPressed: () {
              //   controller.cari.value.text = "";
              //   Get.back();
              // },
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
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              border: Border.all(color: Constanst.fgBorder)),
                          child: Column(
                            children: [
                              formTipe(),
                              formTanggalKlaim(),
                              formTotalKlaim(),
                              formUnggahFile(),
                              formCatatan(),
                            ],
                          ),
                        ),
                      ],
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
                controller.validasiKirimPengajuan();
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

  Widget formTipe() {
    return InkWell(
      onTap: () async {
        await showMenu(
          context: context,
          position: const RelativeRect.fromLTRB(17, 132, 17, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          // initialValue: controller.selectedTypeLembur.value,
          items: controller.allTypeKlaim.value
              .map<PopupMenuItem<String>>((String value) {
            return PopupMenuItem<String>(
              value: value,
              padding: EdgeInsets.zero,
              // onTap: () => controller.selectedTypeCuti.value = value,

              onTap: () {
                controller.selectedDropdownType.value = value;
                this.controller.selectedDropdownType.refresh();
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
      customBorder: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12.0),
          topLeft: Radius.circular(12.0),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Iconsax.note_2,
                      size: 26,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tipe Cuti *",
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Constanst.fgPrimary),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          controller.selectedDropdownType.value,
                          style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Constanst.fgPrimary),
                        ),
                      ],
                    ),
                  ],
                ),
                Icon(Iconsax.arrow_down_1,
                    size: 20, color: Constanst.fgPrimary),
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

  Widget formTanggalKlaim() {
    return InkWell(
      onTap: () async {
        var dateSelect = await showDatePicker(
          context: Get.context!,
          firstDate: DateTime(2000, 1, 1),
          lastDate: DateTime(2100, 1, 1),
          initialDate: controller.initialDate.value,
          cancelText: 'Batal',
          confirmText: 'Simpan',
          builder: (context, child) {
            return Theme(
              data: ThemeData(
                colorScheme: ColorScheme.dark(
                  primary: Constanst.onPrimary,
                  onPrimary: Constanst.colorWhite,
                  onSurface: Constanst.fgPrimary,
                  surface: Constanst.colorWhite,
                ),
                // useMaterial3: settings.useMaterial3,
                visualDensity: VisualDensity.standard,
                dialogTheme: const DialogTheme(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)))),
                primaryColor: Constanst.fgPrimary,
                textTheme: TextTheme(
                  titleMedium: GoogleFonts.inter(
                    color: Constanst.fgPrimary,
                  ),
                ),
                dialogBackgroundColor: Constanst.colorWhite,
                canvasColor: Colors.white,
                hintColor: Constanst.onPrimary,
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: Constanst.onPrimary,
                  ),
                ),
              ),
              child: child!,
            );
          },
        );
        if (dateSelect == null) {
          UtilsAlert.showToast("Tanggal tidak terpilih");
        } else {
          controller.initialDate.value = dateSelect;
          controller.tanggalTerpilih.value =
              DateFormat('yyyy-MM-dd').format(dateSelect);
          controller.tanggalShow.value =
              DateFormat('dd MMMM yyyy').format(dateSelect);
          this.controller.tanggalTerpilih.refresh();
          this.controller.tanggalShow.refresh();

          // controller.tanggalLembur.value.text =
          //     Constanst.convertDate("$dateSelect");
          // this.controller.tanggalLembur.refresh();
        }
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Iconsax.calendar_2,
                      size: 26,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hari & Tanggal*",
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Constanst.fgPrimary),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          Constanst.convertDate6(
                              controller.tanggalTerpilih.value),
                          style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Constanst.fgPrimary),
                        ),
                      ],
                    ),
                  ],
                ),
                Icon(Iconsax.arrow_down_1,
                    size: 20, color: Constanst.fgPrimary),
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

  Widget formTotalKlaim() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Divider(
            height: 0,
            thickness: 1,
            color: Constanst.fgBorder,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Iconsax.money_tick, size: 24),
                const SizedBox(width: 12),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Nominal Klaim *",
                      style: GoogleFonts.inter(
                          color: Constanst.fgPrimary,
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
                    ),
                    TextField(
                      inputFormatters: [
                        CurrencyTextInputFormatter(
                          locale: 'id',
                          symbol: 'Rp ',
                          decimalDigits: 0,
                        )
                      ],
                      controller: controller.totalKlaim.value,
                      keyboardType:
                          const TextInputType.numberWithOptions(signed: true),
                      textInputAction: TextInputAction.done,
                      onSubmitted: (value) {
                        controller.totalKlaim.value.text = value;
                        this.controller.totalKlaim.refresh();
                      },
                      decoration: InputDecoration(
                        hintText: 'Rp ',
                        border: InputBorder.none,
                        hintStyle: GoogleFonts.inter(
                            color: Constanst.fgSecondary,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                      maxLines: null,
                      style: GoogleFonts.inter(
                          color: Constanst.fgPrimary,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    )
                  ],
                ))
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
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
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
                      "Unggah File*",
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
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Constanst.fgPrimary),
                        ),
                        const SizedBox(width: 8),
                        controller.namaFileUpload.value == ""
                            ? Container()
                            : InkWell(
                                onTap: () {
                                  controller.namaFileUpload.value = "";
                                  controller.filePengajuan.value = File("");
                                  controller.uploadFile.value = false;
                                  this.controller.namaFileUpload.refresh();
                                  this.controller.filePengajuan.refresh();
                                  this.controller.uploadFile.refresh();
                                },
                                child: const Icon(
                                  Icons.close,
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

  Widget formCatatan() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Divider(
            height: 0,
            thickness: 1,
            color: Constanst.fgBorder,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Iconsax.textalign_justifyleft, size: 24),
                const SizedBox(width: 12),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Catatan *",
                      style: GoogleFonts.inter(
                          color: Constanst.fgPrimary,
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
                    ),
                    TextFormField(
                      controller: controller.catatan.value,
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
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
