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
import 'package:siscom_operasional/utils/app_data.dart';
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
    controller.loadCutiUser();
    // controller.loadDataTypeCuti();
    // controller.loadAllEmployeeDelegasi();
    print("data biaya ${widget.dataForm![0]}");
    if (widget.dataForm![1] == true) {
      controller.dariTanggal.value.text = widget.dataForm![0]['start_date'];
      controller.sampaiTanggal.value.text = widget.dataForm![0]['end_date'];
      controller.startDate.value = widget.dataForm![0]['start_date'];
      controller.endDate.value = widget.dataForm![0]['end_date'];
      controller.alasan.value.text = widget.dataForm![0]['reason'];
      controller.atten_date_edit.value = widget.dataForm![0]['atten_date'];
      controller.typeIdEdit.value = widget.dataForm![0]['typeid'];
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
      var listDateTerpilih = widget.dataForm![0]['date_selected'].split(',');
      List<DateTime> getDummy = [];

      var data = controller.allTipe
          .where((p0) =>
              p0['id'].toString().toLowerCase() ==
              widget.dataForm![0]['typeid'].toString().toLowerCase())
          .toList();

      if (data.isNotEmpty) {
        // controller.jumlahCuti.value = data[0]['leave_day'];
        controller.selectedTypeCuti.value = data[0]['name'];
      }
      if (controller.dateSelected.value == "2" ||
          controller.dateSelected.value == "2") {
      } else {
        for (var element in listDateTerpilih) {
          var convertDate = DateTime.parse(element);
          getDummy.add(convertDate);
        }
      }

      setState(() {
        controller.tanggalSelectedEdit.value = getDummy;
      });
    } else {
      controller.startDate.value = "";
      controller.endDate.value = "";
      controller.alasan.value.text = "";
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
                      Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            border: Border.all(color: Constanst.fgBorder)),
                        child: controller.cutLeave.value == 0 ||
                                controller.cutLeave.value.toString() == "0"
                            ? informasiSisaCutiMelahirkan()
                            : informasiSisaCuti(),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            border: Border.all(color: Constanst.fgBorder)),
                        child: Column(
                          children: [
                            formTipe(),
                            controller.dateSelected.value == 2 ||
                                    controller.dateSelected.value.toString() ==
                                        '2'
                                ? formTanggalCutiMelahirkan()
                                : formTanggalCuti(),
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
                  if (controller.dateSelected.value == 2 ||
                      controller.dateSelected.value.toString() == "2") {
                    //--------------------menggunakan range---------------------------

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
                    DateTime startPriode = DateTime.parse(
                        DateFormat('yyyy-MM-dd')
                            .format(DateTime.parse(AppData.startPeriode))
                            .toString());
                    if (tempStartDate.isBefore(startPriode)) {
                      UtilsAlert.showToast(
                          "Tanggal mulai tidak boleh sebelum tanggal periode bulan ini");
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
                          UtilsAlert.showToast("Total hari melewati sisa cuti");
                          return;
                        }
                      }
                    } else {
                      if (difference.inDays + 1 > controller.limitCuti.value) {
                        UtilsAlert.showToast("Total hari melewati batas limit");
                        return;
                      }
                    }

                    controller.tanggalSelected.clear();
                    controller.tanggalSelected.value
                        .add(DateTime.parse(controller.startDate.value));
                    controller.tanggalSelected.value
                        .add(DateTime.parse(controller.endDate.value));

                    controller.validasiKirimPengajuan();

                    // Print the result
                  } else {
                    //mengugunakan multiple date

                    DateTime startPriode = DateTime.parse(
                        DateFormat('yyyy-MM-dd')
                            .format(DateTime.parse(AppData.startPeriode))
                            .toString());

                    if (controller.statusForm.value == true) {
                      DateTime tempStartDateEdit = DateTime.parse(DateFormat(
                              'yyyy-MM-dd')
                          .format(DateTime.parse(
                              controller.tanggalSelectedEdit.first.toString()))
                          .toString());
                      if (tempStartDateEdit.isBefore(startPriode)) {
                        UtilsAlert.showToast(
                            "Tanggal mulai tidak boleh sebelum tanggal periode bulan ini");
                        return;
                      }
                      if (controller.cutLeave.value == 1) {
                        if (controller.allowMinus.value == 0) {
                          if ((controller.jumlahCuti.value -
                                  controller.cutiTerpakai.value) <
                              controller.tanggalSelectedEdit.value.length) {
                            UtilsAlert.showToast(
                                "Tanggal yang dipilih melebihi sisa cuti ");
                          } else {
                            print('kemari');
                           controller.validasiKirimPengajuan();
                          }
                        } else {
                          // print('kemari');
                           controller.validasiKirimPengajuan();
                        }
                      } else {
                        if ((controller.limitCuti.value) <
                            controller.tanggalSelectedEdit.value.length) {
                          UtilsAlert.showToast(
                              "Tanggal yang dipilih melebihi sisa cuti");
                        } else {
                           controller.validasiKirimPengajuan();
                        }
                      }
                    } else {
                      DateTime tempStartDate = DateTime.parse(
                          DateFormat('yyyy-MM-dd')
                              .format(DateTime.parse(
                                  controller.tanggalSelected.first.toString()))
                              .toString());
                      if (tempStartDate.isBefore(startPriode)) {
                        UtilsAlert.showToast(
                            "Tanggal mulai tidak boleh sebelum tanggal periode bulan ini");
                        return;
                      }
                      if (controller.cutLeave.value == 1) {
                        if (controller.allowMinus.value == 0) {
                          if ((controller.jumlahCuti.value -
                                  controller.cutiTerpakai.value) <
                              controller.tanggalSelected.value.length) {
                            UtilsAlert.showToast(
                                "Tanggal yang dipilih melebihi sisa cuti");
                          } else {
                             controller.validasiKirimPengajuan();
                          }
                        } else {
                           controller.validasiKirimPengajuan();
                        }
                      } else {
                        if ((controller.limitCuti.value) <
                            controller.tanggalSelected.value.length) {
                          UtilsAlert.showToast(
                              "Tanggal yang dipilih melebihi sisa cuti");
                        } else {
                          controller.validasiKirimPengajuan();
                        }
                      }
                    }
                  }

                  // controller.validasiKirimPengajuan();
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

  Widget message() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
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
                "Tipe lembur belum disetting, silakan hubungi HRD.",
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

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 50,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: InkWell(
                  onTap: () {
                    DatePicker.showPicker(
                      context,
                      pickerModel: CustomDatePicker(
                        currentTime: DateTime.now(),
                        minTime: controller.isBackDate.value == "0"
                            ? DateTime(DateTime.now().year, DateTime.now().month, 1)
                            : DateTime.now(),
                      ),
                      onConfirm: (time) {
                        if (time != null) {
                          controller.startDate.value =
                              DateFormat('yyyy-MM-dd').format(time).toString();

                          controller.startDate.value =
                              DateFormat('yyyy-MM-dd').format(time).toString();
                          DateTime tempStartDate = DateTime.parse(
                              DateFormat('yyyy-MM-dd')
                                  .format(DateFormat('yyyy-MM-dd')
                                      .parse(controller.startDate.value))
                                  .toString());
                          DateTime tempEndDate = DateTime.parse(
                              DateFormat('yyyy-MM-dd')
                                  .format(DateTime.parse(
                                      controller.endDate.value.toString()))
                                  .toString());
                          // Define two DateTime objects representing the two dates
                          DateTime today = DateTime.now();
                          DateTime onlyDate =
                              DateTime(today.year, today.month, today.day);
                          DateTime date1 = DateTime(tempStartDate.year,
                              tempStartDate.month, tempStartDate.day);
                          DateTime date2 = DateTime(tempEndDate.year,
                              tempEndDate.month, tempEndDate.day);
                          print('ini now ${onlyDate}');
                          print('ini date1 $date1');

                          // Calculate the difference between the two dates
                          Duration difference = date1.difference(onlyDate);
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
                          
                          print(controller.tanggalSelected);
                          print(controller.tanggalSelectedEdit);
                        }
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            flex: 15, child: const Icon(Iconsax.calendar_2)),
                        Expanded(
                          flex: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                    text: controller.startDate.value == ""
                                        ? controller.startDate.value
                                        : DateFormat('dd MMM yyyy', 'id')
                                            .format(DateTime.parse(controller
                                                .startDate.value
                                                .toString())),
                                    color: Constanst.fgPrimary,
                                    weight: FontWeight.w500,
                                    size: 16,
                                  ),
                                  Icon(Iconsax.arrow_down_1,
                                      size: 20, color: Constanst.fgPrimary),
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
                      minTime: controller.isBackDate.value == "0"
                          ? DateTime(DateTime.now().year, DateTime.now().month, 1)
                          : DateTime.now(),
                    ),
                    onConfirm: (time) {
                      if (time != null) {
                        controller.endDate.value = DateFormat('yyyy-MM-dd')
                            .format(
                                DateFormat('yyyy-MM-dd').parse(time.toString()))
                            .toString();

                        DateTime tempStartDate = DateTime.parse(
                            DateFormat('yyyy-MM-dd')
                                .format(DateFormat('yyyy-MM-dd')
                                    .parse(controller.startDate.value))
                                .toString());
                        DateTime tempEndDate = DateTime.parse(
                            DateFormat('yyyy-MM-dd')
                                .format(DateTime.parse(
                                    controller.endDate.value.toString()))
                                .toString());
                        // Define two DateTime objects representing the two dates
                        DateTime today = DateTime.now();
                        DateTime onlyDate =
                            DateTime(today.year, today.month, today.day);
                        DateTime date1 = DateTime(tempStartDate.year,
                            tempStartDate.month, tempStartDate.day);
                        DateTime date2 = DateTime(tempEndDate.year,
                            tempEndDate.month, tempEndDate.day);
                        print('ini now ${onlyDate}');
                        print('ini date1 $date1');

                        // Calculate the difference between the two dates
                        Duration difference = date1.difference(onlyDate);
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
                        
                        print(controller.tanggalSelected);
                        print("Tanggal Selesai ${controller.tanggalSelectedEdit}");
                      }
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 15, child: Icon(Iconsax.calendar_2)),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: TextLabell(
                                    text: controller.endDate.value == ""
                                        ? controller.endDate.value
                                        : DateFormat('dd MMM yyyy', 'id')
                                            .format(DateTime.parse(controller
                                                .endDate.value
                                                .toString())),
                                    color: Constanst.fgPrimary,
                                    weight: FontWeight.w500,
                                    size: 16,
                                  ),
                                ),
                                Icon(Iconsax.arrow_down_1,
                                    size: 20, color: Constanst.fgPrimary),
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
                minDate: controller.isBackDate.value == "0"
                    ? DateTime(DateTime.now().year, DateTime.now().month, 1)
                    : DateTime.now(),
                selectionMode: DateRangePickerSelectionMode.multiple,
                initialSelectedDates: controller.tanggalSelectedEdit.value,
                monthCellStyle: const DateRangePickerMonthCellStyle(
                  weekendTextStyle: TextStyle(color: Colors.red),
                  blackoutDateTextStyle: TextStyle(
                      color: Colors.red,
                      decoration: TextDecoration.lineThrough),
                ),
                onSelectionChanged:
                      (DateRangePickerSelectionChangedArgs args) {
                    // args.value adalah List<DateTime> saat mode multiple
                    List<DateTime> dateList = args.value;

                    print('ini datelist $dateList');

                    if (controller.statusForm.value == true) {
                      controller.tanggalSelectedEdit.value = dateList;
                      controller.tanggalSelectedEdit.refresh();
                    } else {
                      controller.tanggalSelected.value = dateList;
                      controller.tanggalSelected.refresh();
                    }

                    // print(controller.tanggalSelected.value);
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
        print(controller.allEmployeeDelegasi.value);
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
