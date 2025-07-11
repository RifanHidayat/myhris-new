// ignore_for_file: deprecated_member_use
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/cuti_controller.dart';
import 'package:siscom_operasional/screen/absen/riwayat_cuti.dart';
import 'package:siscom_operasional/screen/init_screen.dart';
import 'package:siscom_operasional/utils/appbar_widget.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:siscom_operasional/utils/date_picker.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';
import 'package:siscom_operasional/utils/widget_textButton.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FormPengajuanCuti extends StatefulWidget {
  List? dataForm;

  FormPengajuanCuti({Key? key, this.dataForm}) : super(key: key);

  @override
  _FormPengajuanCutiState createState() => _FormPengajuanCutiState();
}

class _FormPengajuanCutiState extends State<FormPengajuanCuti> {
  final controller = Get.put(CutiController());

  @override
  void initState() {
    super.initState();

    // controller.loadDataTypeCuti();

    // Jalankan kode setelah frame pertama selesai di-build
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        controller.loadCutiUser();

        print("data biaya ${widget.dataForm![0]}");

        if (widget.dataForm![1] == true) {
          var multiSelect = widget.dataForm![0]['multiselect'];
          print('Check uyy: $multiSelect');
          controller.isSelectType.value = (multiSelect == 1);

          controller.messageApi.value = '';
          controller.dariTanggal.value.text = widget.dataForm![0]['start_date'];
          controller.sampaiTanggal.value.text = widget.dataForm![0]['end_date'];
          controller.startDate.value = widget.dataForm![0]['start_date'];
          controller.endDate.value = widget.dataForm![0]['end_date'];
          controller.alasan.value.text = widget.dataForm![0]['reason'];
          controller.atten_date_edit.value = widget.dataForm![0]['atten_date'];
          controller.typeIdEdit.value = widget.dataForm![0]['typeid'];
          controller.namaFileUpload.value =
              widget.dataForm![0]['leave_files'] ?? '';
          controller.statusForm.value = true;
          controller.idEditFormCuti.value = "${widget.dataForm![0]['id']}";
          controller.emDelegationEdit.value =
              "${widget.dataForm![0]['em_delegation']}";
          controller.checkingDelegation(widget.dataForm![0]['em_delegation']);
          controller.durasiIzin.value =
              int.parse(widget.dataForm![0]['leave_duration']);
          controller.nomorAjuan.value.text =
              "${widget.dataForm![0]['nomor_ajuan']}";
          controller.screenTanggalSelected.value = false;
          print(widget.dataForm![0]['id']);
          var listDateTerpilih =
              widget.dataForm![0]['date_selected'].split(',');
          List<DateTime> getDummy = [];
          print('ini list date terpilih ${listDateTerpilih}');
          var data = controller.allTipe
              .where((p0) =>
                  p0['id'].toString().toLowerCase() ==
                  widget.dataForm![0]['typeid'].toString().toLowerCase())
              .toList();

          if (data.isNotEmpty) {
            // controller.jumlahCuti.value = data[0]['leave_day'];
            // controller.selectedTypeCuti.value = data[0]['name'];
          }
          if (controller.dateSelected.value == "2" ||
              controller.dateSelected.value == "2") {
          } else {
            for (var element in listDateTerpilih) {
              // var convertDate = DateTime.parse(element);
              // getDummy.add(convertDate);
            }
          }

          // controller.tanggalSelectedEdit.value = getDummy;
        } else {
          controller.messageApi.value = '';
          controller.startDate.value = "";
          controller.endDate.value = "";
          controller.alasan.value.text = "";
          controller.namaFileUpload.value = "";
          controller.statusForm.value = false;
          controller.selectedTypeCuti.value = "";

          // Memastikan tidak ada tanggal yang terpilih secara default
          controller.tanggalSelected.clear();
          controller.tanggalSelectedEdit.clear();
          controller.isSelectType.value = false;
          controller.isTipeIzinVisible.value = false;
        }
      },
    );
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
              "Pengajuan Cuti",
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
                      controller.messageApi.value == ''
                          ? SizedBox()
                          : Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Constanst.colorBGRejected,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Iconsax.info_circle,
                                        color: Constanst.colorStateDangerBorder,
                                        size: 26,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          controller.messageApi.value,
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w400,
                                              color: Constanst.fgSecondary,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 16.0)
                              ],
                            ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            border: Border.all(color: Constanst.fgBorder)),
                        child: controller.showStatus == true
                            ? controller.cutLeave.value == 0 ||
                                    controller.cutLeave.value.toString() == "0"
                                ? informasiSisaCutiMelahirkan()
                                : informasiSisaCuti()
                            : SizedBox(),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            border: Border.all(color: Constanst.fgBorder)),
                        child: Column(
                          children: [
                            formTanggalCutiMelahirkan(),

                            // Widget formTipe() hanya akan muncul jika isTipeIzinVisible bernilai true
                            Obx(() => controller.isTipeIzinVisible.value
                                ? formTipe()
                                : const SizedBox.shrink()),

                            // Obx(() => controller.showTipe.value == false
                            //     ? SizedBox()
                            //     : formTipe()),

                            // controller.dateSelected.value == 2 ||
                            //         controller.dateSelected.value.toString() ==
                            //             '2'
                            // ? formTanggalCutiMelahirkan()

                            // : formTanggalCuti(),

                            formDelegasiKepada(),
                            formUploadFile(),
                            formAlasan(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 12.0),
              child: TextButtonWidget(
                title: "Kirim",
                onTap: () {
                  controller.focus.unfocus();
                  print('ini cutLeave ${controller.cutLeave.value}');
                  print('ini limit ${controller.limitCuti.value}');
                  print('tanggal selected ${controller.tanggalSelected.value}');
                  print(
                      'tanggal selected edit ${controller.tanggalSelectedEdit.value}');
                  print('tanggal start ${controller.startDate.value}');
                  print('tanggal end ${controller.endDate.value}');
                  print(
                      'tanggal selected edit ${controller.tanggalSelectedEdit.value}');
                  print('date selected ${controller.dateSelected.value}');
                  controller.messageApi.value = '';
                  if (controller.dateSelected.value == 2 ||
                      controller.dateSelected.value.toString() == "2") {
                    //--------------------menggunakan range---------------------------
                    if (controller.startDate.value.isEmpty) {
                      controller.messageApi.value = "Tanggal mulai harus disi";
                      UtilsAlert.showToast("Tanggal mulai harus disi");
                      return;
                    } else if (controller.endDate.value.isEmpty) {
                      UtilsAlert.showToast("Tanggal selesai harus disi");
                      return;
                    }
                    DateTime tempStartDate = DateTime.parse(
                        DateFormat('yyyy-MM-dd')
                            .format(DateFormat('yyyy-MM-dd')
                                .parse(controller.startDate.value))
                            .toString());
                    DateTime tempEndDate = DateTime.parse(DateFormat(
                            'yyyy-MM-dd')
                        .format(
                            DateTime.parse(controller.endDate.value.toString()))
                        .toString());

                    if (tempEndDate.isBefore(tempStartDate)) {
                      UtilsAlert.showToast(
                          "Tanggal mulai lebih besar dari tanggal selesai");
                      return;
                    }
                    // Define two DateTime objects representing the two dates
                    DateTime date1 = DateTime(tempStartDate.year,
                        tempStartDate.month, tempStartDate.day);
                    DateTime date2 = DateTime(
                        tempEndDate.year, tempEndDate.month, tempEndDate.day);

                    // Calculate the difference between the two dates
                    Duration difference = date2.difference(date1);
                    controller.durasiIzin.value = difference.inDays + 1;
                    controller.durasiCutiMelahirkan.value =
                        difference.inDays + 1;

                    // if (difference.inDays + 1 >
                    //     controller.jumlahCuti.value) {
                    //   UtilsAlert.showToast(
                    //       "Total hari melewati batas limit");
                    //   return;
                    // }

                    if (controller.cutLeave.value == 1 ||
                        controller.cutLeave.value == 1) {
                      if (difference.inDays + 1 > controller.jumlahCuti.value) {
                        if (controller.allowMinus.value == 1) {
                        } else {
                          controller.messageApi.value =
                              "Total hari melewati sisa cuti";
                          UtilsAlert.showToast("Total hari melewati sisa cuti");
                          return;
                        }
                      }
                    } else {
                      if (difference.inDays + 1 > controller.limitCuti.value) {
                        controller.messageApi.value =
                            "Total hari melewati sisa cuti";
                        UtilsAlert.showToast("Total hari melewati batas limit");
                        return;
                      }
                    }

                    controller.tanggalSelected.clear();
                    controller.tanggalSelected.value
                        .add(DateTime.parse(controller.startDate.value));
                    controller.tanggalSelected.value
                        .add(DateTime.parse(controller.endDate.value));
                    print('kemari 1');
                    controller.validasiKirimPengajuan();
                    // Print the result
                  } else {
                    //mengugunakan multiple date

                    if (controller.startDate.value.isEmpty) {
                      controller.messageApi.value = "Tanggal mulai harus disi";
                      UtilsAlert.showToast("Tanggal mulai harus disi");
                      return;
                    } else if (controller.endDate.value.isEmpty) {
                      // controller.messageApi.value = "Tanggal mulai harus disi";
                      UtilsAlert.showToast("Tanggal selesai harus disi");
                      return;
                    }
                    DateTime tempStartDate = DateTime.parse(
                        DateFormat('yyyy-MM-dd')
                            .format(DateFormat('yyyy-MM-dd')
                                .parse(controller.startDate.value))
                            .toString());
                    DateTime tempEndDate = DateTime.parse(DateFormat(
                            'yyyy-MM-dd')
                        .format(
                            DateTime.parse(controller.endDate.value.toString()))
                        .toString());

                    if (tempEndDate.isBefore(tempStartDate)) {
                      UtilsAlert.showToast(
                          "Tanggal mulai lebih besar dari tanggal selesai");
                      return;
                    }

                    if (controller.statusForm.value == true) {
                      if (controller.cutLeave.value == 1) {
                        if (controller.allowMinus.value == 0) {
                          if ((controller.jumlahCuti.value -
                                  controller.cutiTerpakai.value) <
                              controller.tanggalSelectedEdit.value.length) {
                            controller.messageApi.value =
                                "Tanggal yang dipilih melebihi sisa cuti";
                            UtilsAlert.showToast(
                                "Tanggal yang dipilih melebihi sisa cuti ");
                            return;
                          } else {
                            print('kemari 2');
                            controller.validasiKirimPengajuan();
                          }
                        } else {
                          print('kemari 3');
                          controller.validasiKirimPengajuan();
                        }
                      } else {
                        if ((controller.limitCuti.value) <
                            controller.tanggalSelectedEdit.value.length) {
                          controller.messageApi.value =
                              "Tanggal yang dipilih melebihi sisa cuti";
                          UtilsAlert.showToast(
                              "Tanggal yang dipilih melebihi sisa cuti");
                          return;
                        } else {
                          print('kemari 4');
                          controller.validasiKirimPengajuan();
                        }
                      }
                    } else {
                      if (controller.cutLeave.value == 1) {
                        if (controller.allowMinus.value == 0) {
                          if ((controller.jumlahCuti.value -
                                  controller.cutiTerpakai.value) <
                              controller.tanggalSelected.value.length) {
                            controller.messageApi.value =
                                "Tanggal yang dipilih melebihi sisa cuti";
                            UtilsAlert.showToast(
                                "Tanggal yang dipilih melebihi sisa cuti");
                            return;
                          } else {
                            print('kemari 5');
                            controller.validasiKirimPengajuan();
                          }
                        } else {
                          print('kemari 6');
                          controller.validasiKirimPengajuan();
                        }
                      } else {
                        if ((controller.limitCuti.value) <
                            controller.tanggalSelected.value.length) {
                          controller.messageApi.value =
                              "Tanggal yang dipilih melebihi sisa cuti";
                          UtilsAlert.showToast(
                              "Tanggal yang dipilih melebihi sisa cuti");
                          return;
                        } else {
                          print('kemari 7');
                          controller.validasiKirimPengajuan();
                        }
                      }
                    }
                  }
                },
                colorButton: Constanst.colorPrimary,
                colortext: Constanst.colorWhite,
                border: BorderRadius.circular(8.0),
              )),
        ),
      ),
    );
  }

  Widget informasiSisaCuti() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/5_cuti.svg',
                      height: 22,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "CUTI PRIBADI ",
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          color: Constanst.fgPrimary,
                          fontSize: 16),
                    ),
                  ],
                ),
                Text(
                  "${controller.jumlahCuti.value} Total",
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      color: Constanst.fgSecondary,
                      fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: MediaQuery.of(Get.context!).size.width,
              child: Center(
                child: LinearPercentIndicator(
                  barRadius: const Radius.circular(100.0),
                  lineHeight: 8.0,
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  percent: controller.persenCuti.value,
                  progressColor: Constanst.infoLight,
                  backgroundColor: Constanst.colorNeutralBgTertiary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  " ${controller.jumlahCuti.value - controller.cutiTerpakai.value} Tersisa",
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      color: Constanst.infoLight,
                      fontSize: 12),
                ),
                Text(
                  "${controller.cutiTerpakai.value} Terpakai",
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      color: Constanst.color4,
                      fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget informasiSisaCutiMelahirkan() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 90,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 15,
                        child: SvgPicture.asset(
                          'assets/5_cuti.svg',
                          height: 22,
                        ),
                      ),
                      // const SizedBox(width: 4),
                      Expanded(
                        flex: 85,
                        child: Text(
                          "${controller.selectedTypeCuti.value} ",
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              color: Constanst.fgPrimary,
                              fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 20,
                  child: Text(
                    "${controller.limitCuti.value} Total",
                    textAlign: TextAlign.right,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        color: Constanst.fgSecondary,
                        fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: MediaQuery.of(Get.context!).size.width,
              child: Center(
                child: LinearPercentIndicator(
                  barRadius: const Radius.circular(100.0),
                  lineHeight: 8.0,
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  percent: 0.0,
                  progressColor: Constanst.infoLight,
                  backgroundColor: Constanst.colorNeutralBgTertiary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  // "${controller.jumlahCuti.value - controller.cutiTerpakai.value} Tersisa",
                  "",
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      color: Constanst.infoLight,
                      fontSize: 12),
                ),
                Text(
                  // "${controller.cutiTerpakai.value} Terpakai",
                  "",
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      color: Constanst.color4,
                      fontSize: 12),
                ),
              ],
            ),
            // Text("Cuti Khusus"),
          ],
        ),
      ),
    );
  }

  Widget formTipe() {
    return InkWell(
      onTap: () async {
        await showMenu(
          context: context,
          position: const RelativeRect.fromLTRB(17, 235, 17, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          // initialValue: controller.selectedTypeLembur.value,
          items: controller.allTipeFormCutiDropdown.value
              .map<PopupMenuItem<String>>((String value) {
            return PopupMenuItem<String>(
              value: value,
              padding: EdgeInsets.zero,
              // onTap: () => controller.selectedTypeCuti.value = value,

              onTap: () {
                var data = controller.allTipe
                    .where((p0) =>
                        p0['name'].toString().toLowerCase() ==
                        value.toString().toLowerCase())
                    .toList();
                controller.loadCutiUserMelahirkan();

                print(data.toString());

                if (data.isNotEmpty) {
                  controller.limitCuti.value = data[0]['leave_day'];
                  controller.dateSelected.value = data[0]['select_date'];
                  controller.allowMinus.value = data[0]['allow_minus'];
                  controller.isBackDate.value = data[0]['back_date'].toString();
                }

                print("Allow minu ${data[0]['allow_minus']}");
                print("upload file  ${data[0]['upload_file']}");
                controller.isRequiredFile.value =
                    data[0]['upload_file'].toString();

                // var data=controller.allTipe.value.whe
                controller.selectedTypeCuti.value = value!;
                controller.cutLeave.value = data[0]['cut_leave'];

                print("data cuti ${controller.selectedTypeCuti.value}");
                // controller.selectedTypeCuti.value = selectedValue!;
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 70,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 15,
                        child: const Icon(
                          Iconsax.note_2,
                          size: 26,
                        ),
                      ),
                      Expanded(
                        flex: 90,
                        child: Column(
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
                              controller.selectedTypeCuti.value,
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
                Expanded(
                  flex: 10,
                  child: Icon(Iconsax.arrow_down_1,
                      size: 20, color: Constanst.fgPrimary),
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
          //         items: controller.allTipeFormCutiDropdown.value
          //             .map<DropdownMenuItem<String>>((String value) {
          //           return DropdownMenuItem<String>(
          //             value: value,
          //             child: Text(
          //               value,
          //               style: TextStyle(fontSize: 14),
          //             ),
          //           );
          //         }).toList(),
          //         value: controller.selectedTypeCuti.value,
          //         onChanged: (selectedValue) {
          //           print(controller.allEmployeeDelegasi.value);
          //           var data = controller.allTipe
          //               .where((p0) =>
          //                   p0['name'].toString().toLowerCase() ==
          //                   selectedValue.toString().toLowerCase())
          //               .toList();
          //           controller.loadCutiUserMelahirkan();

          //           print(data.toString());

          //           if (data.isNotEmpty) {
          //             controller.jumlahCuti.value = data[0]['leave_day'];
          //           }

          //           // var data=controller.allTipe.value.whe
          //           controller.selectedTypeCuti.value = selectedValue!;
          //           // controller.selectedTypeCuti.value = selectedValue!;
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

  Widget formTanggalCutiMelahirkan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text("Tanggal*", style: TextStyle(fontWeight: FontWeight.bold)),
        // widget.dataForm![1] == true
        //     ? controller.selectedTypeCuti.value
        //             .toString()
        //             .toLowerCase()
        //             .toLowerCase()
        //             .contains("Cuti Melahirkan".toLowerCase())
        //         ? SizedBox()
        //         : customTanggalDariSampaiDari()
        //     : SizedBox(),

        // Checkbox MultiSelect or no
        Row(
          children: [
            Checkbox(
              value: controller.isSelectType.value,
              checkColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              onChanged: (bool? value) {
                setState(() {
                  // Reset status tombol fetch Hilang
                  controller.showFetchButton.value = false;

                  // Reset visibilitas formTipe Hilang
                  controller.isTipeIzinVisible.value = false;

                  // Ubah mode seperti biasa
                  controller.isSelectType.value = value ?? false;

                  if (value == true) {
                    // Logika MultiSelect Tanggal Centang
                    controller.isSelectType.value = true;
                  } else {
                    // Logika Uncentang
                    controller.isSelectType.value = false;
                  }
                  controller.startDate.value = '';
                  controller.endDate.value = '';
                  controller.tanggalSelected.clear();
                  controller.tanggalSelectedEdit.clear();
                });
              },
            ),
            Text('MultiSelect Tanggal'),
          ],
        ),

        Obx(
          () => controller.isSelectType.value
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                  child: Column(
                    children: [
                      // Pilih Tanggal
                      Row(
                        children: [
                          const Icon(
                            Iconsax.calendar_2,
                            size: 26,
                          ),
                          const SizedBox(width: 12),
                          Text("Pilih Tanggal*",
                              style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Constanst.fgPrimary)),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),

                      // Kalender MultiSelect
                      Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          border: Border.all(color: Constanst.fgBorder),
                        ),
                        child: Card(
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          elevation: 0,

                          // SfDateRangePicker
                          child: SfDateRangePicker(
                            minDate: DateTime(2000),
                            // minDate: controller.isBackDate.value == "0"
                            //     ? DateTime(2000)
                            //     : DateTime.now(),

                            selectionMode:
                                DateRangePickerSelectionMode.multiple,

                            // initialSelectedDates: controller.tanggalSelectedEdit.value,
                            initialSelectedDates: controller
                                .tanggalSelectedEdit.value
                                .map((e) => DateTime.parse(e.toString()))
                                .toList(),

                            monthCellStyle: const DateRangePickerMonthCellStyle(
                              weekendTextStyle: TextStyle(color: Colors.red),
                              blackoutDateTextStyle: TextStyle(
                                  color: Colors.red,
                                  decoration: TextDecoration.lineThrough),
                            ),

                            // OnSelectChange
                            onSelectionChanged:
                                (DateRangePickerSelectionChangedArgs args) {
                              // check args: [2025-07-09 00:00:00.000, 2025-07-10 00:00:00.000, 2025-07-11 00:00:00.000]
                              print('check args: ${args.value}');

                              // Untuk mode .multiple, args.value sudah berupa List<DateTime>
                              // Lakukan pemeriksaan tipe untuk keamanan
                              if (args.value is List<DateTime>) {
                                // Langsung gunakan args.value sebagai list tanggal
                                List<DateTime> dateList = args.value;
                                // Cetak hasil
                                print('Tanggal yang dipilih: $dateList');

                                // HITUNG DURASI BERDASARKAN JUMLAH HARI YANG DIPILIH
                                int durasi = dateList.length;
                                // controller.durasiIzin.value = durasi;
                                controller.durasiCutiMelahirkan.value = durasi;
                                print('Durasi Cuti Dihitung: $durasi hari');

                                // Tentukan tanggal mulai dan akhir untuk disimpan
                                if (dateList.isNotEmpty) {
                                  // Urutkan daftar tanggal dari yang paling awal ke paling akhir
                                  dateList.sort((a, b) => a.compareTo(b));

                                  // Ambil tanggal pertama (terkecil) dan terakhir (terbesar)
                                  DateTime tanggalTerkecil = dateList.first;
                                  DateTime tanggalTerbesar = dateList
                                      .last; // Jika hanya 1 tanggal, ini akan sama dengan yg terkecil

                                  // Format tanggal ke dalam string
                                  String formattedStartDate =
                                      DateFormat('yyyy-MM-dd')
                                          .format(tanggalTerkecil);
                                  String formattedEndDate =
                                      DateFormat('yyyy-MM-dd')
                                          .format(tanggalTerbesar);

                                  // Update controller dengan nilai baru
                                  controller.startDate.value =
                                      formattedStartDate;
                                  controller.endDate.value = formattedEndDate;

                                  // controller.tanggalSelected.value.clear();
                                  // controller.tanggalSelectedEdit.value.clear();

                                  // (Opsional) Print untuk debugging
                                  print(
                                      'Tanggal Terkecil (Start Date): $formattedStartDate');
                                  print(
                                      'Tanggal Terbesar (End Date): $formattedEndDate');
                                } else {
                                  // Jika tidak ada tanggal yang dipilih, kosongkan nilainya
                                  controller.startDate.value = '';
                                  controller.endDate.value = '';
                                }

                                // Tampilkan tombol jika ada tanggal yang dipilih
                                controller.showFetchButton.value =
                                    dateList.isNotEmpty;

                                // Jika tombol fetch muncul, sembunyikan dulu form tipe
                                if (controller.showFetchButton.value) {
                                  controller.isTipeIzinVisible.value = false;
                                }

                                // Update daftar tanggal yang dipilih di controller
                                if (widget.dataForm![1] == true) {
                                  controller.tanggalSelectedEdit.value =
                                      dateList;
                                } else {
                                  controller.tanggalSelected.value = dateList;
                                }
                              }
                            },
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 12,
                      ),

                      // PERUBAHAN 2
                      Obx(() {
                        // Hanya tampilkan tombol jika showFetchButton true
                        if (controller.showFetchButton.value) {
                          return SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              // menjadi OutlinedButton
                              onPressed: () {
                                // Tombol Fetch Ditekan dengan durasi: 2 hari
                                print(
                                    "Tombol Fetch Ditekan dengan durasi: ${controller.durasiCutiMelahirkan.value} hari");

                                DateTime tempStartDate = DateTime.parse(
                                    DateFormat('yyyy-MM-dd')
                                        .format(DateFormat('yyyy-MM-dd')
                                            .parse(controller.startDate.value))
                                        .toString());

                                DateTime tempEndDate = DateTime.parse(
                                    DateFormat('yyyy-MM-dd')
                                        .format(DateTime.parse(controller
                                            .endDate.value
                                            .toString()))
                                        .toString());

                                // Check tempStartDate: 2025-07-11 00:00:00.000
                                print('Check tempStartDate: $tempStartDate');

                                // Check tempEndDate: 2025-07-13 00:00:00.000
                                print('Check tempEndDate: $tempEndDate');

                                DateTime today = DateTime.now();
                                DateTime onlyDate = DateTime(
                                    today.year, today.month, today.day);

                                DateTime date1 = DateTime(tempStartDate.year,
                                    tempStartDate.month, tempStartDate.day);

                                // ini now 2025-07-11 00:00:00.000
                                print('ini now ${onlyDate}');

                                // ini date1 2025-07-11 00:00:00.000
                                print('ini date1 $date1');

                                // Calculate the difference between the two dates
                                Duration difference =
                                    date1.difference(onlyDate);
                                // date1.difference(onlyDate);

                                // ini diferent cuti: 0:00:00.000000
                                print('ini diferent cuti: $difference');

                                // controller.durasiIzin.value = difference.inDays;

                                controller.durasiCutiMelahirkan.value =
                                    difference.inDays;

                                controller.tanggalSelected.value.clear();
                                controller.tanggalSelectedEdit.value.clear();

                                for (var i = tempStartDate;
                                    i.isBefore(tempEndDate) ||
                                        i.isAtSameMomentAs(tempEndDate);
                                    i = i.add(Duration(days: 1))) {
                                  controller.tanggalSelected.value.add(i);
                                  controller.tanggalSelectedEdit.value.add(i);
                                }

                                // mendeteksi bahwa pengguna hanya memilih satu hari.
                                if (controller.startDate.value ==
                                    controller.endDate.value) {
                                  // Pastikan string tanggal tidak kosong sebelum di-parse
                                  // memastikan bahwa tanggalnya tidak kosong
                                  if (controller.startDate.value.isNotEmpty) {
                                    controller.tanggalSelected.clear();
                                    // Parse String menjadi DateTime
                                    // Menambahkan tanggalSelected
                                    controller.tanggalSelected.value.add(
                                        DateTime.parse(
                                            controller.startDate.value));

                                    controller.tanggalSelectedEdit.clear();
                                    // Parse String menjadi DateTime
                                    controller.tanggalSelectedEdit.value.add(
                                        DateTime.parse(
                                            controller.startDate.value));
                                  }

                                  // controller.tanggalSelected.clear();
                                  // controller.tanggalSelected.value
                                  //     .add(controller.startDate.value);
                                  // controller.tanggalSelectedEdit.clear();
                                  // controller.tanggalSelectedEdit.value
                                  //     .add(controller.startDate.value);
                                }

                                // Panggil API dengan durasi yang sudah benar
                                if (controller.startDate.value != '' &&
                                    controller.endDate.value != '') {
                                  controller.loadDataTypeCuti(
                                      durasi: controller
                                          .durasiCutiMelahirkan.value
                                          .toString());
                                } else {}

                                // print('durasiCutiMelahirkan: ${controller.durasiCutiMelahirkan.value}');

                                // controller.loadDataTypeCuti(
                                //     durasi: controller
                                //         .durasiCutiMelahirkan.value
                                //         .toString());

                                // Sembunyikan kembali tombol setelah ditekan
                                controller.showFetchButton.value = false;

                                // Untuk memunculkan form tipe
                                controller.isTipeIzinVisible.value = true;
                              },
                              // DIUBAH: Sesuaikan style untuk OutlinedButton
                              style: OutlinedButton.styleFrom(
                                  // Atur warna border dan teks
                                  foregroundColor: Constanst.colorPrimary,
                                  backgroundColor: Constanst.colorWhite,

                                  // Atur bentuk border
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),

                                  // Atur ketebalan border (opsional)
                                  side: BorderSide(
                                      color: Colors.blue, width: 1.5),
                                  // Ganti dengan warna biru Anda

                                  // Atur padding
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12)),
                              child: Text(
                                'Lihat Tipe Cuti',
                                // DIUBAH: Sesuaikan warna teks
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Colors
                                        .blue), // Ganti dengan warna biru Anda
                              ),
                            ),
                          );
                        } else {
                          // Jika false, tampilkan widget kosong
                          return const SizedBox.shrink();
                        }
                      }),

                      // PERUBAHAN 2
                      // Obx(() {
                      //   // Hanya tampilkan tombol jika showFetchButton true
                      //   if (controller.showFetchButton.value) {
                      //     return SizedBox(
                      //       width: double.infinity,
                      //       child: ElevatedButton(
                      //         onPressed: () {
                      //           print(
                      //               "Tombol Fetch Ditekan dengan durasi: ${controller.durasiCutiMelahirkan.value} hari");
                      //
                      //           DateTime tempStartDate = DateTime.parse(
                      //               DateFormat('yyyy-MM-dd')
                      //                   .format(DateFormat('yyyy-MM-dd')
                      //                       .parse(controller.startDate.value))
                      //                   .toString());
                      //
                      //           DateTime tempEndDate = DateTime.parse(
                      //               DateFormat('yyyy-MM-dd')
                      //                   .format(DateTime.parse(controller
                      //                       .endDate.value
                      //                       .toString()))
                      //                   .toString());
                      //
                      //           // Check tempStartDate: 2025-07-11 00:00:00.000
                      //           print('Check tempStartDate: $tempStartDate');
                      //
                      //           // Check tempEndDate: 2025-07-13 00:00:00.000
                      //           print('Check tempEndDate: $tempEndDate');
                      //
                      //           DateTime today = DateTime.now();
                      //           DateTime onlyDate = DateTime(
                      //               today.year, today.month, today.day);
                      //
                      //           DateTime date1 = DateTime(tempStartDate.year,
                      //               tempStartDate.month, tempStartDate.day);
                      //
                      //           // ini now 2025-07-11 00:00:00.000
                      //           print('ini now ${onlyDate}');
                      //
                      //           // ini date1 2025-07-11 00:00:00.000
                      //           print('ini date1 $date1');
                      //
                      //           // Calculate the difference between the two dates
                      //           Duration difference =
                      //               date1.difference(onlyDate);
                      //           // date1.difference(onlyDate);
                      //
                      //           // ini diferent cuti: 0:00:00.000000
                      //           print('ini diferent cuti: $difference');
                      //
                      //           // controller.durasiIzin.value = difference.inDays;
                      //
                      //           controller.durasiCutiMelahirkan.value =
                      //               difference.inDays;
                      //
                      //           controller.tanggalSelected.value.clear();
                      //           controller.tanggalSelectedEdit.value.clear();
                      //
                      //           for (var i = tempStartDate;
                      //               i.isBefore(tempEndDate) ||
                      //                   i.isAtSameMomentAs(tempEndDate);
                      //               i = i.add(Duration(days: 1))) {
                      //             controller.tanggalSelected.value.add(i);
                      //             controller.tanggalSelectedEdit.value.add(i);
                      //           }
                      //
                      //           // mendeteksi bahwa pengguna hanya memilih satu hari.
                      //           if (controller.startDate.value ==
                      //               controller.endDate.value) {
                      //             // Pastikan string tanggal tidak kosong sebelum di-parse
                      //             // memastikan bahwa tanggalnya tidak kosong
                      //             if (controller.startDate.value.isNotEmpty) {
                      //               controller.tanggalSelected.clear();
                      //               // Parse String menjadi DateTime
                      //               // Menambahkan tanggalSelected
                      //               controller.tanggalSelected.value.add(
                      //                   DateTime.parse(
                      //                       controller.startDate.value));
                      //
                      //               controller.tanggalSelectedEdit.clear();
                      //               // Parse String menjadi DateTime
                      //               controller.tanggalSelectedEdit.value.add(
                      //                   DateTime.parse(
                      //                       controller.startDate.value));
                      //             }
                      //
                      //             // controller.tanggalSelected.clear();
                      //             // controller.tanggalSelected.value
                      //             //     .add(controller.startDate.value);
                      //             // controller.tanggalSelectedEdit.clear();
                      //             // controller.tanggalSelectedEdit.value
                      //             //     .add(controller.startDate.value);
                      //           }
                      //
                      //           // Panggil API dengan durasi yang sudah benar
                      //           if (controller.startDate.value != '' &&
                      //               controller.endDate.value != '') {
                      //             controller.loadDataTypeCuti(
                      //                 durasi: controller
                      //                     .durasiCutiMelahirkan.value
                      //                     .toString());
                      //           } else {}
                      //
                      //           // if (controller.startDate.value != '' &&
                      //           //     controller.endDate.value != '') {
                      //           //   controller.loadDataTypeCuti(
                      //           //       durasi: controller.durasiCutiMelahirkan.value
                      //           //           .toString());
                      //           // } else {}
                      //
                      //           // controller.loadDataTypeCuti(
                      //           //     durasi: controller
                      //           //         .durasiCutiMelahirkan.value
                      //           //         .toString());
                      //
                      //           // Sembunyikan kembali tombol setelah ditekan
                      //           controller.showFetchButton.value = false;
                      //
                      //           // Untuk memunculkan form tipe
                      //           controller.isTipeIzinVisible.value = true;
                      //         },
                      //         style: ElevatedButton.styleFrom(
                      //             foregroundColor: Constanst.colorWhite,
                      //             backgroundColor: Constanst.colorPrimary,
                      //             shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(8),
                      //             ),
                      //             elevation: 0,
                      //             padding:
                      //                 const EdgeInsets.symmetric(vertical: 12)),
                      //         child: Text(
                      //           'Lihat Tipe Cuti',
                      //           style: GoogleFonts.inter(
                      //               fontWeight: FontWeight.w500,
                      //               fontSize: 16,
                      //               color: Constanst.colorWhite),
                      //         ),
                      //       ),
                      //     );
                      //   } else {
                      //     // Jika false, tampilkan widget kosong
                      //     return const SizedBox.shrink();
                      //   }
                      // }),

                      SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                )

              // Tanggal Mulai & Tanggal Selesai
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Tanggal Mulai
                    Expanded(
                      flex: 50,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: InkWell(
                          onTap: () {
                            // Hilangkan form tipe
                            controller.isTipeIzinVisible.value = false;

                            DatePicker.showPicker(
                              context,
                              pickerModel: CustomDatePicker(
                                currentTime: DateTime.now(),

                                // default isBackDate = 0
                                minTime: DateTime(2000),
                                // minTime: controller.isBackDate.value == "0"
                                //     ? DateTime(2000)
                                //     : DateTime.now(),
                              ),
                              onConfirm: (time) {
                                print('check time Tanggal Mulai: $time');

                                if (time != null) {
                                  // Format tanggal yang baru dipilih dengan benar
                                  controller.startDate.value =
                                      DateFormat('yyyy-MM-dd').format(time);
                                  controller.dariTanggal.value.text =
                                      controller.startDate.value;

                                  DateTime tempStartDate = time;
                                  // Lakukan pengecekan untuk endDate sebelum parsing
                                  if (controller.endDate.value.isNotEmpty) {
                                    try {
                                      DateTime tempEndDate = DateTime.parse(
                                          controller.endDate.value);

                                      // Lanjutkan logika Anda hanya jika endDate valid
                                      DateTime today = DateTime.now();
                                      DateTime onlyDate = DateTime(
                                          today.year, today.month, today.day);
                                      DateTime date1 = DateTime(
                                          tempStartDate.year,
                                          tempStartDate.month,
                                          tempStartDate.day);

                                      Duration difference =
                                          date1.difference(onlyDate);
                                      print('ini diferent cuti : $difference');

                                      controller.durasiCutiMelahirkan.value =
                                          difference.inDays;

                                      controller.tanggalSelected.clear();
                                      controller.tanggalSelectedEdit.clear();

                                      for (var i = tempStartDate;
                                          i.isBefore(tempEndDate) ||
                                              i.isAtSameMomentAs(tempEndDate);
                                          i = i.add(Duration(days: 1))) {
                                        controller.tanggalSelected.add(i);
                                        controller.tanggalSelectedEdit.add(i);
                                      }

                                      if (controller.startDate.value ==
                                          controller.endDate.value) {
                                        controller.tanggalSelected.clear();
                                        controller.tanggalSelected.value
                                            .add(controller.startDate.value);
                                        controller.tanggalSelectedEdit.clear();
                                        controller.tanggalSelectedEdit.value
                                            .add(controller.startDate.value);
                                      }

                                      controller.loadDataTypeCuti(
                                          durasi: controller
                                              .durasiCutiMelahirkan.value
                                              .toString());

                                      print("check time:$time");
                                    } catch (e) {
                                      print("Error parsing endDate: $e");
                                    }
                                  } else {
                                    // Jika endDate kosong, cukup perbarui tipe cuti berdasarkan durasi 1 hari
                                    controller.loadDataTypeCuti(durasi: "1");
                                  }

                                  // controller.startDate.value =
                                  //     DateFormat('yyyy-MM-dd')
                                  //         .format(time)
                                  //         .toString();
                                  //
                                  // controller.dariTanggal.value.text =
                                  //     DateFormat('yyyy-MM-dd')
                                  //         .format(time)
                                  //         .toString();
                                  //
                                  // DateTime tempStartDate = DateTime.parse(
                                  //     DateFormat('yyyy-MM-dd')
                                  //         .format(DateFormat('yyyy-MM-dd')
                                  //             .parse(
                                  //                 controller.startDate.value))
                                  //         .toString());
                                  //
                                  // DateTime tempEndDate = DateTime.parse(
                                  //     DateFormat('yyyy-MM-dd')
                                  //         .format(DateTime.parse(controller
                                  //             .endDate.value
                                  //             .toString()))
                                  //         .toString());
                                  //
                                  // // Define two DateTime objects representing the two dates
                                  // DateTime today = DateTime.now();
                                  // DateTime onlyDate = DateTime(
                                  //     today.year, today.month, today.day);
                                  //
                                  //
                                  // DateTime date1 = DateTime(tempStartDate.year,
                                  //     tempStartDate.month, tempStartDate.day);
                                  //
                                  // DateTime date2 = DateTime(tempEndDate.year,
                                  //     tempEndDate.month, tempEndDate.day);
                                  //
                                  // print('ini now ${onlyDate}');
                                  // print('ini date1 $date1');

                                  // // Calculate the difference between the two dates
                                  // Duration difference =
                                  //     date1.difference(onlyDate);
                                  // print(
                                  //     'ini durasi izin : ${controller.durasiIzin.value}');
                                  // print('ini diferent cuti : $difference');
                                  //
                                  //
                                  // controller.durasiCutiMelahirkan.value =
                                  //     difference.inDays;
                                  //
                                  // // controller.tanggalSelected.value = [];
                                  // controller.tanggalSelected.value.clear();
                                  // controller.tanggalSelectedEdit.value.clear();
                                  //
                                  // for (var i = tempStartDate;
                                  //     i.isBefore(tempEndDate) ||
                                  //         i.isAtSameMomentAs(tempEndDate);
                                  //     i = i.add(Duration(days: 1))) {
                                  //   controller.tanggalSelected.value.add(i);
                                  //   controller.tanggalSelectedEdit.value.add(i);
                                  // }

                                  // if (controller.startDate.value ==
                                  //     controller.endDate.value) {
                                  //   controller.tanggalSelected.clear();
                                  //   controller.tanggalSelected.value
                                  //       .add(controller.startDate.value);
                                  //   controller.tanggalSelectedEdit.clear();
                                  //   controller.tanggalSelectedEdit.value
                                  //       .add(controller.startDate.value);
                                  // }
                                  //
                                  // controller.loadDataTypeCuti(
                                  //     durasi: controller
                                  //         .durasiCutiMelahirkan.value
                                  //         .toString());
                                  //
                                  // print("check time:$time");
                                }
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                16.0, 16.0, 0.0, 16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    flex: 15,
                                    child: const Icon(Iconsax.calendar_2)),
                                Expanded(
                                  flex: 80,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextLabell(
                                        text: "Tanggal Mulai *",
                                        color: Constanst.fgPrimary,
                                        size: 14,
                                        weight: FontWeight.w400,
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextLabell(
                                            text:
                                                controller.startDate.value == ""
                                                    ? controller.startDate.value
                                                    : DateFormat(
                                                            'dd MMM yyyy', 'id')
                                                        .format(DateTime.parse(
                                                            controller
                                                                .startDate.value
                                                                .toString())),
                                            color: Constanst.fgPrimary,
                                            weight: FontWeight.w500,
                                            size: 15,
                                          ),
                                          Icon(Iconsax.arrow_down_1,
                                              size: 20,
                                              color: Constanst.fgPrimary),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    /// Tanggal Selesai
                    Expanded(
                      flex: 50,
                      child: InkWell(
                        onTap: () {
                          if (controller.startDate.value == "") {
                            UtilsAlert.showToast("Tanggal Mulai belum diisi");
                            return;
                          }
                          print("kesini");
                          DatePicker.showPicker(
                            context,
                            pickerModel: CustomDatePicker(
                              // minTime: DateTime(
                              //     DateTime.now().year,
                              //     DateTime.now().month - 1,
                              //     int.parse(
                              //         AppData.informasiUser![0].beginPayroll.toString())),
                              // maxTime: DateTime(DateTime.now().year, DateTime.now().month,
                              //     DateTime.now().day),
                              currentTime: DateTime.now(),
                              minTime: DateTime(2000),
                              // minTime: controller.isBackDate.value == "0"
                              //     ? DateTime(2000)
                              //     : DateTime.now(),
                            ),
                            onConfirm: (time) {
                              controller.isTipeIzinVisible.value = true;

                              if (time != null) {
                                controller.endDate.value =
                                    DateFormat('yyyy-MM-dd')
                                        .format(DateFormat('yyyy-MM-dd')
                                            .parse(time.toString()))
                                        .toString();

                                DateTime tempStartDate = DateTime.parse(
                                    DateFormat('yyyy-MM-dd')
                                        .format(DateFormat('yyyy-MM-dd')
                                            .parse(controller.startDate.value))
                                        .toString());
                                DateTime tempEndDate = DateTime.parse(
                                    DateFormat('yyyy-MM-dd')
                                        .format(DateTime.parse(controller
                                            .endDate.value
                                            .toString()))
                                        .toString());
                                // Define two DateTime objects representing the two dates
                                DateTime today = DateTime.now();
                                DateTime onlyDate = DateTime(
                                    today.year, today.month, today.day);
                                DateTime date1 = DateTime(tempStartDate.year,
                                    tempStartDate.month, tempStartDate.day);
                                DateTime date2 = DateTime(tempEndDate.year,
                                    tempEndDate.month, tempEndDate.day);
                                print('ini now ${onlyDate}');
                                print('ini date1 $date1');

                                // Calculate the difference between the two dates
                                Duration difference =
                                    date1.difference(onlyDate);
                                print(
                                    'ini durasi izin : ${controller.durasiIzin.value}');
                                print('ini diferent cuti : $difference');
                                controller.durasiCutiMelahirkan.value =
                                    difference.inDays;
                                // controller.tanggalSelected.value = [];
                                controller.tanggalSelectedEdit.value.clear();
                                controller.tanggalSelected.value.clear();
                                for (var i = tempStartDate;
                                    i.isBefore(tempEndDate) ||
                                        i.isAtSameMomentAs(tempEndDate);
                                    i = i.add(Duration(days: 1))) {
                                  controller.tanggalSelected.value.add(i);
                                  controller.tanggalSelectedEdit.value.add(i);
                                }
                                if (controller.startDate.value ==
                                    controller.endDate.value) {
                                  controller.tanggalSelected.clear();
                                  controller.tanggalSelected.value
                                      .add(controller.startDate.value);
                                  controller.tanggalSelectedEdit.clear();
                                  controller.tanggalSelectedEdit.value
                                      .add(controller.startDate.value);
                                }

                                controller.loadDataTypeCuti(
                                    durasi:
                                        controller.durasiIzin.value.toString());

                                // absenController.tglAjunan.value =
                                //     DateFormat('yyyy-MM-dd').format(time).toString();
                                // absenController.checkAbsensi();

                                // absenController.getPlaceCoordinateCheckin();
                                // absenController.getPlaceCoordinateCheckout();

                                // var filter = DateFormat('yyyy-MM').format(time);
                                // var array = filter.split('-');
                                // var bulan = array[1];
                                // var tahun = array[0];
                                // controller.bulanSelectedSearchHistory.value = bulan;
                                // controller.tahunSelectedSearchHistory.value = tahun;
                                // controller.bulanDanTahunNow.value = "$bulan-$tahun";
                                // this.controller.bulanSelectedSearchHistory.refresh();
                                // this.controller.tahunSelectedSearchHistory.refresh();
                                // this.controller.bulanDanTahunNow.refresh();
                                // controller.loadHistoryAbsenUser();
                              }
                            },
                          );
                        },
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  flex: 15, child: Icon(Iconsax.calendar_2)),
                              Expanded(
                                flex: 80,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextLabell(
                                      text: "Tanggal Selesai *",
                                      color: Constanst.fgPrimary,
                                      size: 14,
                                      weight: FontWeight.w400,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: TextLabell(
                                            text: controller.endDate.value == ""
                                                ? controller.endDate.value
                                                : DateFormat(
                                                        'dd MMM yyyy', 'id')
                                                    .format(DateTime.parse(
                                                        controller.endDate.value
                                                            .toString())),
                                            color: Constanst.fgPrimary,
                                            weight: FontWeight.w500,
                                            size: 15,
                                          ),
                                        ),
                                        Icon(Iconsax.arrow_down_1,
                                            size: 20,
                                            color: Constanst.fgPrimary),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),

        // SizedBox(
        //   height: 4,
        // ),
        // Padding(
        //   padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        //   child: TextLabell(
        //     text: " ${controller.durasiIzin.value} Hari",
        //     color: Constanst.fgSecondary,
        //   ),
        // ),
        // SizedBox(
        //   height: 4,
        // ),

        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Divider(
            height: 0,
            thickness: 1,
            color: Constanst.fgBorder,
          ),
        ),
        // Row(
        //   children: [
        //     Expanded(
        //       flex: 50,
        //       child: Container(
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Text("Tanggal Mulai *",
        //                 style: TextStyle(fontWeight: FontWeight.bold)),
        //             SizedBox(
        //               height: 12,
        //             ),
        //             InkWell(
        //               onTap: () {
        //                 DatePicker.showPicker(
        //                   context,
        //                   pickerModel: CustomDatePicker(
        //                     currentTime: DateTime.now(),
        //                   ),
        //                   onConfirm: (time) {
        //                     if (time != null) {
        //                       controller.startDate.value =
        //                           DateFormat('yyyy-MM-dd')
        //                               .format(time)
        //                               .toString();

        //                       print("$time");
        //                     }
        //                   },
        //                 );
        //               },
        //               child: Container(
        //                 padding: EdgeInsets.only(left: 8, right: 8),
        //                 width: MediaQuery.of(context).size.width,
        //                 height: 40,
        //                 decoration: BoxDecoration(
        //                   borderRadius: BorderRadius.circular(12),
        //                   border:
        //                       Border.all(width: 1, color: Constanst.Secondary),
        //                 ),
        //                 child: Align(
        //                     alignment: Alignment.centerLeft,
        //                     child: Obx(() => TextLabell(
        //                           text: controller.startDate.value,
        //                           size: 14,
        //                         ))),
        //               ),
        //             )
        //           ],
        //         ),
        //       ),
        //     ),
        //     SizedBox(
        //       width: 16,
        //     ),
        //     Expanded(
        //       flex: 50,
        //       child: Container(
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Text("Tanggal Selesai  *",
        //                 style: TextStyle(fontWeight: FontWeight.bold)),
        //             SizedBox(
        //               height: 12,
        //             ),
        //             InkWell(
        //               onTap: () {
        //                 if (controller.startDate.value == "") {
        //                   UtilsAlert.showToast("Tanggal Mulai belum diisi");
        //                   return;
        //                 }
        //                 print("kesini");
        //                 DatePicker.showPicker(
        //                   context,
        //                   pickerModel: CustomDatePicker(
        //                     // minTime: DateTime(
        //                     //     DateTime.now().year,
        //                     //     DateTime.now().month - 1,
        //                     //     int.parse(
        //                     //         AppData.informasiUser![0].beginPayroll.toString())),
        //                     // maxTime: DateTime(DateTime.now().year, DateTime.now().month,
        //                     //     DateTime.now().day),
        //                     currentTime: DateTime.now(),
        //                   ),
        //                   onConfirm: (time) {
        //                     if (time != null) {
        //                       controller.endDate.value =
        //                           DateFormat('yyyy-MM-dd')
        //                               .format(DateFormat('yyyy-MM-dd')
        //                                   .parse(time.toString()))
        //                               .toString();

        //                       // absenController.tglAjunan.value =
        //                       //     DateFormat('yyyy-MM-dd').format(time).toString();
        //                       // absenController.checkAbsensi();

        //                       // absenController.getPlaceCoordinateCheckin();
        //                       // absenController.getPlaceCoordinateCheckout();

        //                       // var filter = DateFormat('yyyy-MM').format(time);
        //                       // var array = filter.split('-');
        //                       // var bulan = array[1];
        //                       // var tahun = array[0];
        //                       // controller.bulanSelectedSearchHistory.value = bulan;
        //                       // controller.tahunSelectedSearchHistory.value = tahun;
        //                       // controller.bulanDanTahunNow.value = "$bulan-$tahun";
        //                       // this.controller.bulanSelectedSearchHistory.refresh();
        //                       // this.controller.tahunSelectedSearchHistory.refresh();
        //                       // this.controller.bulanDanTahunNow.refresh();
        //                       // controller.loadHistoryAbsenUser();
        //                     }
        //                   },
        //                 );
        //               },
        //               child: Container(
        //                 padding: EdgeInsets.only(left: 8, right: 8),
        //                 width: MediaQuery.of(context).size.width,
        //                 height: 40,
        //                 decoration: BoxDecoration(
        //                   borderRadius: BorderRadius.circular(12),
        //                   border:
        //                       Border.all(width: 1, color: Constanst.Secondary),
        //                 ),
        //                 child: Align(
        //                     alignment: Alignment.centerLeft,
        //                     child: Obx(() => TextLabell(
        //                           text: controller.endDate.value,
        //                           size: 14,
        //                         ))),
        //               ),
        //             )
        //           ],
        //         ),
        //       ),
        //     ),
        //   ],
        // )
        // controller.screenTanggalSelected.value == true
        //     ? Card(
        //         margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(20.0),
        //         ),
        //         child: SfDateRangePicker(
        //           selectionMode: DateRangePickerSelectionMode.range,
        //           initialSelectedDates: controller.tanggalSelectedEdit.value,
        //           monthCellStyle: DateRangePickerMonthCellStyle(
        //             weekendTextStyle: TextStyle(color: Colors.red),tang
        //             blackoutDateTextStyle: TextStyle(
        //                 color: Colors.red,
        //                 decoration: TextDecoration.lineThrough),
        //           ),
        //           onSelectionChanged:
        //               (DateRangePickerSelectionChangedArgs args) {
        //             if (controller.statusForm.value == true) {
        //               controller.tanggalSelectedEdit.value = args.value;
        //               this.controller.tanggalSelectedEdit.refresh();
        //             } else {
        //               controller.tanggalSelected.value = args.value;
        //               this.controller.tanggalSelected.refresh();
        //             }
        //           },
        //         ))
        //     : SizedBox(),
      ],
    );
  }

  Widget formTanggalCuti() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Iconsax.calendar_2,
                size: 26,
              ),
              const SizedBox(width: 12),
              Text("Pilih Tanggal*",
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Constanst.fgPrimary)),
            ],
          ),
          // SizedBox(
          //   height: 5,
          // ),
          // widget.dataForm![1] == true
          //     ? customTanggalDariSampaiDari()
          //     : SizedBox(),
          const SizedBox(height: 8),

          Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: SfDateRangePicker(
                minDate: DateTime(2000),
                // minDate: controller.isBackDate.value == "0"
                //     ? DateTime(2000)
                //     : DateTime.now(),
                selectionMode: DateRangePickerSelectionMode.range,
                // initialSelectedDates: controller.tanggalSelectedEdit.value,
                monthCellStyle: const DateRangePickerMonthCellStyle(
                  weekendTextStyle: TextStyle(color: Colors.red),
                  blackoutDateTextStyle: TextStyle(
                      color: Colors.red,
                      decoration: TextDecoration.lineThrough),
                ),
                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                  // print(args.value);

                  // Konversi menjadi List<DateTime>
                  List<DateTime> dateList = [];
                  DateTime startDate =
                      args.value.startDate ?? args.value.endDate;
                  DateTime endDate = args.value.endDate ?? args.value.startDate;

                  // Tambahkan rentang tanggal ke dalam daftar
                  for (DateTime date = startDate;
                      date.isBefore(endDate.add(Duration(days: 1)));
                      date = date.add(Duration(days: 1))) {
                    dateList.add(date);
                  }

                  // Cetak hasil
                  print(dateList);

                  if (controller.statusForm.value == true) {
                    controller.tanggalSelectedEdit.value = dateList;
                    this.controller.tanggalSelectedEdit.refresh();
                  } else {
                    controller.tanggalSelected.value = dateList;
                    this.controller.tanggalSelected.refresh();
                  }

                  print(controller.tanggalSelected.value);
                },
              )),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: TextLabell(
              text:
                  "${controller.statusForm.value == false ? controller.tanggalSelected.value.length : controller.tanggalSelectedEdit.value.length} Hari",
              color: Constanst.fgSecondary,
            ),
          ),
        ],
      ),
    );

    //  Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Row(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       children: [
    //         Expanded(
    //           child: Padding(
    //             padding: const EdgeInsets.only(right: 8),
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Text("Tanggal*",
    //                     style: TextStyle(fontWeight: FontWeight.bold)),
    //                 SizedBox(
    //                   height: 5,
    //                 ),
    //                 Positioned(
    //                   left: 0,
    //                   top: 80,
    //                   right: 0,
    //                   bottom: 0,
    //                   child: SfDateRangePicker(
    //                     selectionMode: DateRangePickerSelectionMode.range,
    //                     initialSelectedRange: PickerDateRange(
    //                         DateTime.now().subtract(const Duration(days: 4)),
    //                         DateTime.now().add(const Duration(days: 3))),
    //                   ),
    //                 )
    //                 // Container(
    //                 //   height: 50,
    //                 //   decoration: BoxDecoration(
    //                 //       color: Colors.white,
    //                 //       borderRadius: Constanst.borderStyle1,
    //                 //       border: Border.all(
    //                 //           width: 0.5,
    //                 //           color: Color.fromARGB(255, 211, 205, 205))),
    //                 //   child: Padding(
    //                 //       padding: const EdgeInsets.all(8.0),
    //                 //       child: SfDateRangePicker(
    //                 //         initialSelectedRange: PickerDateRange(
    //                 //             DateTime.now()
    //                 //                 .subtract(const Duration(days: 4)),
    //                 //             DateTime.now().add(const Duration(days: 3))),
    //                 //         selectionMode: DateRangePickerSelectionMode.range,
    //                 //       )
    //                 //       // DateTimeField(
    //                 //       //   format: DateFormat('dd-MM-yyyy'),
    //                 //       //   decoration: const InputDecoration(
    //                 //       //     border: InputBorder.none,
    //                 //       //   ),
    //                 //       //   controller: controller.dariTanggal.value,
    //                 //       //   onShowPicker: (context, currentValue) {
    //                 //       //     // DateTime now = DateTime.now();
    //                 //       //     // DateTime firstDateOfMonth =
    //                 //       //     //     DateTime(now.year, now.month + 0, 1);
    //                 //       //     // DateTime lastDayOfMonth =
    //                 //       //     //     DateTime(now.year, now.month + 1, 0);
    //                 //       //     return showDatePicker(
    //                 //       //       context: context,
    //                 //       //       firstDate: DateTime(2000),
    //                 //       //       lastDate: DateTime(2100),
    //                 //       //       initialDate: currentValue ?? DateTime.now(),
    //                 //       //     );
    //                 //       //   },
    //                 //       // ),
    //                 //       ),
    //                 // ),
    //               ],
    //             ),
    //           ),
    //         ),
    //         Expanded(
    //           child: Padding(
    //             padding: const EdgeInsets.only(left: 8),
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Text("Sampai Tanggal*",
    //                     style: TextStyle(fontWeight: FontWeight.bold)),
    //                 SizedBox(
    //                   height: 5,
    //                 ),
    //                 Container(
    //                   height: 50,
    //                   decoration: BoxDecoration(
    //                       color: Colors.white,
    //                       borderRadius: Constanst.borderStyle1,
    //                       border: Border.all(
    //                           width: 0.5,
    //                           color: Color.fromARGB(255, 211, 205, 205))),
    //                   child: Padding(
    //                     padding: const EdgeInsets.all(8.0),
    //                     child: DateTimeField(
    //                       format: DateFormat('dd-MM-yyyy'),
    //                       decoration: const InputDecoration(
    //                         border: InputBorder.none,
    //                       ),
    //                       controller: controller.sampaiTanggal.value,
    //                       onShowPicker: (context, currentValue) {
    //                         // DateTime now = DateTime.now();
    //                         // DateTime firstDateOfMonth =
    //                         //     DateTime(now.year, now.month + 0, 1);
    //                         // DateTime lastDayOfMonth =
    //                         //     DateTime(now.year, now.month + 1, 0);
    //                         return showDatePicker(
    //                           context: context,
    //                           firstDate: DateTime(2000),
    //                           lastDate: DateTime(2100),
    //                           initialDate: currentValue ?? DateTime.now(),
    //                         );
    //                       },
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         )
    //       ],
    //     )
    //   ],
    // );
  }

  // Widget customTanggalDariSampaiDari() {
  //   return Container(
  //       height: 50,
  //       width: MediaQuery.of(Get.context!).size.width,
  //       decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: Constanst.borderStyle1,
  //           border: Border.all(
  //               width: 0.5, color: Color.fromARGB(255, 211, 205, 205))),
  //       child: Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Row(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             children: [
  //               Expanded(
  //                 flex: 90,
  //                 child: Padding(
  //                   padding: const EdgeInsets.only(top: 6),
  //                   child: Row(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(Constanst.convertDate1(
  //                           "${controller.dariTanggal.value.text}")),
  //                       Padding(
  //                         padding: const EdgeInsets.only(left: 8),
  //                         child: Text("sd"),
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.only(left: 8),
  //                         child: Text(Constanst.convertDate1(
  //                             "${controller.sampaiTanggal.value.text}")),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               Expanded(
  //                 flex: 10,
  //                 child: IconButton(
  //                   onPressed: () {
  //                     controller.screenTanggalSelected.value =
  //                         !controller.screenTanggalSelected.value;
  //                   },
  //                   icon: Icon(
  //                     Iconsax.edit,
  //                     size: 18,
  //                   ),
  //                 ),
  //               )
  //             ],
  //           )));
  // }

  Widget formDelegasiKepada() {
    return InkWell(
      onTap: () async {
        print('test Delegasi Kepada: ${controller.allEmployeeDelegasi.value}');

        await showMenu(
          context: context,
          position: controller.selectedTypeCuti.value
                  .toString()
                  .toLowerCase()
                  .toLowerCase()
                  .contains("Cuti Melahirkan".toLowerCase())
              ? const RelativeRect.fromLTRB(17, 388, 17, 0)
              : const RelativeRect.fromLTRB(17, 665, 17, 0),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          // initialValue: controller.selectedTypeLembur.value,
          items: controller.allEmployeeDelegasi.value
              .map<PopupMenuItem<String>>((String value) {
            return PopupMenuItem<String>(
              value: value,
              padding: EdgeInsets.zero,
              onTap: () {
                controller.selectedDelegasi.value = value;
                print(controller.selectedDelegasi.value);
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
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 70,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 15,
                        child: const Icon(
                          Iconsax.profile_add,
                          size: 26,
                        ),
                      ),
                      Expanded(
                        flex: 90,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Delegasikan Tugas kepada*",
                              style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Constanst.fgPrimary),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              controller.selectedDelegasi.value,
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
                Expanded(
                  flex: 10,
                  child: Icon(Iconsax.arrow_down_1,
                      size: 20, color: Constanst.fgPrimary),
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
          //         items: controller.allTipeFormCutiDropdown.value
          //             .map<DropdownMenuItem<String>>((String value) {
          //           return DropdownMenuItem<String>(
          //             value: value,
          //             child: Text(
          //               value,
          //               style: TextStyle(fontSize: 14),
          //             ),
          //           );
          //         }).toList(),
          //         value: controller.selectedTypeCuti.value,
          //         onChanged: (selectedValue) {
          //           print(controller.allEmployeeDelegasi.value);
          //           var data = controller.allTipe
          //               .where((p0) =>
          //                   p0['name'].toString().toLowerCase() ==
          //                   selectedValue.toString().toLowerCase())
          //               .toList();
          //           controller.loadCutiUserMelahirkan();

          //           print(data.toString());

          //           if (data.isNotEmpty) {
          //             controller.jumlahCuti.value = data[0]['leave_day'];
          //           }

          //           // var data=controller.allTipe.value.whe
          //           controller.selectedTypeCuti.value = selectedValue!;
          //           // controller.selectedTypeCuti.value = selectedValue!;
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

  Widget formUploadFile() {
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
                Expanded(
                  flex: 15,
                  child: const Icon(
                    Iconsax.document_upload,
                    size: 26,
                  ),
                ),
                Expanded(
                  flex: 90,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => controller.isRequiredFile.value == "0"
                            ? Text(
                                "Unggah File",
                                style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Constanst.fgPrimary),
                              )
                            : Text(
                                "Unggah File *",
                                style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Constanst.fgPrimary),
                              ),
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
                                      color:
                                          Color.fromARGB(255, 211, 205, 205))),
                              child: Icon(
                                Iconsax.add,
                                size: 26,
                                color: Constanst.fgSecondary,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            controller.namaFileUpload.value.length > 20
                                ? '${controller.namaFileUpload.value.substring(0, 15)}...'
                                : controller.namaFileUpload.value,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      )
                    ],
                  ),
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

  Widget formAlasan() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 15,
              child: const Icon(Iconsax.textalign_justifyleft, size: 24)),
          const SizedBox(width: 8),
          Expanded(
              flex: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextLabell(
                    text: "Catatan *",
                    color: Constanst.fgPrimary,
                    size: 14,
                    weight: FontWeight.w400,
                  ),
                  TextFormField(
                    controller: controller.alasan.value,
                    focusNode: controller.focus,
                    decoration: const InputDecoration(
                      hintText: 'Tulis catatan disini',
                      border: InputBorder.none,
                    ),
                    style: GoogleFonts.inter(
                        color: Constanst.fgPrimary,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
