// ignore_for_file: deprecated_member_use
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/lembur_controller.dart';
import 'package:siscom_operasional/controller/pesan_controller.dart';
import 'package:siscom_operasional/controller/tugas_luar_controller.dart';
import 'package:siscom_operasional/screen/absen/lembur.dart';
import 'package:siscom_operasional/screen/absen/tugas_luar.dart';
import 'package:siscom_operasional/screen/init_screen.dart';
import 'package:siscom_operasional/utils/appbar_widget.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/widget_textButton.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class FormTugasLuar extends StatefulWidget {
  List? dataForm, type;
  FormTugasLuar({Key? key, this.dataForm, type}) : super(key: key);
  @override
  _FormTugasLuarState createState() => _FormTugasLuarState();
}

class _FormTugasLuarState extends State<FormTugasLuar> {
  var controller = Get.put(TugasLuarController());

  @override
  void initState() {
    print(controller.viewTugasLuar.value);
    if (widget.dataForm![1] == true) {
      print("nomor ajuan ${widget.dataForm![0]['nomor_ajuan']}");
      controller.nomorAjuan.value.text =
          "${widget.dataForm![0]['nomor_ajuan']}";
      controller.idpengajuanTugasLuar.value = "${widget.dataForm![0]['id']}";
      controller.statusForm.value = true;
      controller.emDelegation.value = "${widget.dataForm![0]['em_delegation']}";
      controller.checkDelegation(widget.dataForm![0]['em_delegation']);
      controller.tanggalTugasLuar.value.text =
          Constanst.convertDate("${widget.dataForm![0]['atten_date']}");
      if (controller.viewTugasLuar.value) {
        controller.selectedDropdownFormTugasLuarTipe.value = "Tugas Luar";

        var convertDariJam = widget.dataForm![0]['dari_jam'].split(":");
        var convertSampaiJam = widget.dataForm![0]['sampai_jam'].split(":");
        var hasilDarijam = "${convertDariJam[0]}:${convertDariJam[1]}";
        var hasilSampaijam = "${convertSampaiJam[0]}:${convertSampaiJam[1]}";
        controller.dariJam.value.text = hasilDarijam;
        controller.sampaiJam.value.text = hasilSampaijam;
        controller.catatan.value.text = widget.dataForm![0]['uraian'];
      } else {
        controller.selectedDropdownFormTugasLuarTipe.value = "Dinas Luar";
        controller.screenTanggalSelected.value = false;
        controller.dariTanggal.value.text = widget.dataForm![0]['start_date'];
        controller.sampaiTanggal.value.text = widget.dataForm![0]['end_date'];
        controller.catatan.value.text = widget.dataForm![0]['reason'];
        var listDateTerpilih = widget.dataForm![0]['date_selected'].split(',');
        List<DateTime> getDummy = [];
        for (var element in listDateTerpilih) {
          var convertDate = DateTime.parse(element);
          getDummy.add(convertDate);
        }
        controller.tanggalSelectedEdit.value = getDummy;
      }
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
              controller.viewTugasLuar.value
                  ? "Form Tugas Luar"
                  : "Form Dinas Luar",
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
                        children: [
                          widget.dataForm![1] == true
                              ? const SizedBox()
                              : formTipe(),
                          !controller.viewTugasLuar.value
                              ? formPilihTanggal()
                              : formHariDanTanggal(),
                          !controller.viewTugasLuar.value
                              ? const SizedBox()
                              : formJam(),
                          formDelegasiKepada(),
                          formCatatan(),
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
                controller.validasiKirimPengajuan();
                //
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

      // Padding(
      //     padding: EdgeInsets.all(16.0),
      //     child: TextButtonWidget(
      //       title: "Simpan",
      //       onTap: () => controller.validasiKirimPengajuan(),
      //       colorButton: Constanst.colorPrimary,
      //       colortext: Constanst.colorWhite,
      //       border: BorderRadius.circular(20.0),
      //     )),
    );
  }

  Widget formPilihTanggal() {
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
          const SizedBox(height: 8),
          widget.dataForm![1] == true
              ? customTanggalDariSampaiDari()
              : const SizedBox(),
          controller.screenTanggalSelected.value == true
              ? Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      border: Border.all(color: Constanst.fgBorder)),
                  child: Card(
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 0,
                      child: SfDateRangePicker(
                        selectionMode: DateRangePickerSelectionMode.multiple,
                        initialSelectedDates:
                            controller.tanggalSelectedEdit.value,
                        monthCellStyle: const DateRangePickerMonthCellStyle(
                          weekendTextStyle: TextStyle(color: Colors.red),
                          blackoutDateTextStyle: TextStyle(
                              color: Colors.red,
                              decoration: TextDecoration.lineThrough),
                        ),
                        onSelectionChanged:
                            (DateRangePickerSelectionChangedArgs args) {
                          if (controller.idpengajuanTugasLuar.value != "") {
                            controller.tanggalSelectedEdit.value = args.value;
                            this.controller.tanggalSelectedEdit.refresh();
                          } else {
                            controller.tanggalSelected.value = args.value;
                            this.controller.tanggalSelected.refresh();
                          }
                        },
                      )),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget customTanggalDariSampaiDari() {
    return Container(
        height: 50,
        width: MediaQuery.of(Get.context!).size.width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: Constanst.borderStyle1,
            border: Border.all(
                width: 0.5, color: Color.fromARGB(255, 211, 205, 205))),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 90,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(Constanst.convertDate1(
                            "${controller.dariTanggal.value.text}")),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text("sd"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(Constanst.convertDate1(
                              "${controller.sampaiTanggal.value.text}")),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: IconButton(
                    onPressed: () {
                      controller.screenTanggalSelected.value =
                          !controller.screenTanggalSelected.value;
                    },
                    icon: Icon(
                      Iconsax.edit,
                      size: 18,
                    ),
                  ),
                )
              ],
            )));
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
          constraints: const BoxConstraints(
            minWidth: 395.0,
            // minHeight: 50.0,
            maxWidth: 395.0,
            // maxHeight: 100.0,
          ),
          // initialValue: controller.selectedTypeLembur.value,
          items: controller.allTipeFormTugasLuar.value
              .map<PopupMenuItem<String>>((String value) {
            return PopupMenuItem<String>(
              value: value,
              padding: EdgeInsets.zero,
              onTap: () {
                print(controller.selectedDropdownFormTugasLuarTipe.value);
                controller.gantiTypeAjuan(value);
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
      //     Container(
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
      //         items: controller.allTipeFormTugasLuar.value
      //             .map<DropdownMenuItem<String>>((String value) {
      //           return DropdownMenuItem<String>(
      //             value: value,
      //             child: Text(
      //               value,
      //               style: TextStyle(fontSize: 14),
      //             ),
      //           );
      //         }).toList(),
      //         value: controller.selectedDropdownFormTugasLuarTipe.value,
      //         onChanged: (selectedValue) {
      //           print(controller.selectedDropdownFormTugasLuarTipe.value);
      //           controller.gantiTypeAjuan(selectedValue);
      //         },
      //         isExpanded: true,
      //       ),
      //     ),
      //   ),
      // ),
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
                        Iconsax.note_2,
                        size: 26,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Tipe*",
                              style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Constanst.fgPrimary),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              controller
                                  .selectedDropdownFormTugasLuarTipe.value,
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

  Widget formHariDanTanggal() {
    return InkWell(
      onTap: () async {
        // DateTime now = DateTime.now();
        // DateTime firstDateOfMonth =
        //     DateTime(now.year, now.month + 0, 1);
        // DateTime lastDayOfMonth =
        //     DateTime(now.year, now.month + 1, 0);
        var dateSelect = await showDatePicker(
          context: Get.context!,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
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
          controller.tanggalTugasLuar.value.text =
              Constanst.convertDate("$dateSelect");
          this.controller.tanggalTugasLuar.refresh();
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
                          controller.tanggalTugasLuar.value.text,
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

  Widget formJam() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              showTimePicker(
                context: Get.context!,
                initialTime: TimeOfDay.now(),
                // initialEntryMode: TimePickerEntryMode.input,
                builder: (context, child) {
                  return MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(alwaysUse24HourFormat: true),
                    child: Theme(
                      data: ThemeData(
                        colorScheme: ColorScheme.light(
                          primary: Constanst.onPrimary,
                        ),
                        // useMaterial3: settings.useMaterial3,
                        dialogTheme: const DialogTheme(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)))),
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
                    ),
                  );
                },
              ).then((value) {
                if (value == null) {
                  UtilsAlert.showToast('gagal pilih jam');
                } else {
                  var convertJam =
                      value.hour <= 9 ? "0${value.hour}" : "${value.hour}";
                  var convertMenit = value.minute <= 9
                      ? "0${value.minute}"
                      : "${value.minute}";
                  controller.dariJam.value.text = "$convertJam:$convertMenit";
                  this.controller.dariJam.refresh();
                }
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Iconsax.clock,
                            size: 26,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Dari jam*",
                                style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Constanst.fgPrimary),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                controller.dariJam.value.text,
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
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Divider(
                    height: 0,
                    thickness: 1,
                    color: Constanst.fgBorder,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              showTimePicker(
                context: Get.context!,
                initialTime: TimeOfDay.now(),
                // initialEntryMode: TimePickerEntryMode.input,
                builder: (context, child) {
                  return MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(alwaysUse24HourFormat: true),
                    child: Theme(
                      data: ThemeData(
                        colorScheme: ColorScheme.light(
                          primary: Constanst.onPrimary,
                        ),
                        // useMaterial3: settings.useMaterial3,
                        dialogTheme: const DialogTheme(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)))),
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
                    ),
                  );
                },
              ).then((value) {
                if (value == null) {
                  UtilsAlert.showToast('gagal pilih jam');
                } else {
                  var convertJam =
                      value.hour <= 9 ? "0${value.hour}" : "${value.hour}";
                  var convertMenit = value.minute <= 9
                      ? "0${value.minute}"
                      : "${value.minute}";
                  controller.sampaiJam.value.text = "$convertJam:$convertMenit";
                  this.controller.sampaiJam.refresh();
                }
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Sampai jam*",
                            style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Constanst.fgPrimary),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            controller.sampaiJam.value.text,
                            style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Constanst.fgPrimary),
                          ),
                        ],
                      ),
                      Icon(Iconsax.arrow_down_1,
                          size: 20, color: Constanst.fgPrimary),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Divider(
                    height: 0,
                    thickness: 1,
                    color: Constanst.fgBorder,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget formDelegasiKepada() {
    print("data employee ${controller.allEmployeeDelegasi.value}");
    return InkWell(
      onTap: () async {
        await showMenu(
          context: context,
          position: !controller.viewTugasLuar.value
              ? const RelativeRect.fromLTRB(17, 575, 17, 0)
              : const RelativeRect.fromLTRB(17, 360, 17, 0),
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
          items: controller.allEmployeeDelegasi.value
              .map<PopupMenuItem<String>>((String value) {
            return PopupMenuItem<String>(
              value: value,
              padding: EdgeInsets.zero,
              onTap: () => controller.selectedDropdownDelegasi.value = value,
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Iconsax.profile_add,
                      size: 26,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pemberi Tugas*",
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Constanst.fgPrimary),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          controller.selectedDropdownDelegasi.value,
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
          //         items: controller.allEmployeeDelegasi.value
          //             .map<DropdownMenuItem<String>>((String value) {
          //           return DropdownMenuItem<String>(
          //             value: value,
          //             child: Text(
          //               value,
          //               style: TextStyle(fontSize: 14),
          //             ),
          //           );
          //         }).toList(),
          //         value: controller.selectedDropdownDelegasi.value,
          //         onChanged: (selectedValue) {
          //           controller.selectedDropdownDelegasi.value = selectedValue!;
          //         },
          //         isExpanded: true,
          //       ),
          //     ),
          //   ),
          // ),
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
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 4.0),
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
                  "Catatan *",
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Constanst.fgPrimary),
                ),
                TextFormField(
                  controller: controller.catatan.value,
                  decoration: const InputDecoration(
                    hintText: 'Tulis catatan disini',
                    border: InputBorder.none,
                  ),
                  style: GoogleFonts.inter(
                      color: Constanst.fgPrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
