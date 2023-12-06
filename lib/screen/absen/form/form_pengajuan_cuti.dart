// ignore_for_file: deprecated_member_use
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
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
    print(widget.dataForm![0]);
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

      print("data cuti new ${controller.allTipe}");
      print("data cuti new ${data}");

      if (data.isNotEmpty) {
        controller.jumlahCuti.value = data[0]['leave_day'];
        controller.selectedTypeCuti.value = data[0]['name'];
      }
      if (controller.selectedTypeCuti.value
          .toString()
          .toLowerCase()
          .toLowerCase()
          .contains("Cuti Melahirkan".toLowerCase())) {
      } else {
        for (var element in listDateTerpilih) {
          var convertDate = DateTime.parse(element);
          getDummy.add(convertDate);
        }
      }

      setState(() {
        controller.tanggalSelectedEdit.value = getDummy;
      });
    }else{
      controller.startDate.value="";
      controller.endDate.value="";
      controller.alasan.value.text="";
  
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constanst.coloBackgroundScreen,
      appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          elevation: 2,
          flexibleSpace: AppbarMenu1(
            title: "Pengajuan Cuti",
            colorTitle: Colors.black,
            colorIcon: Colors.black,
            icon: 1,
            onTap: () {
              Get.back();
            },
          )),
      body: WillPopScope(
          onWillPop: () async {
            Get.back();
            return true;
          },
          child: SafeArea(
            child: Obx(
              () => Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: !controller.statusHitungCuti.value
                      ? Container(
                          width: MediaQuery.of(Get.context!).size.width,
                          height: MediaQuery.of(Get.context!).size.height,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/amico.png",
                                height: 250,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text("Anda belum memiliki hak cuti"),
                            ],
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 16,
                            ),
                            controller.selectedTypeCuti.value
                                    .toString()
                                    .toLowerCase()
                                    .toLowerCase()
                                    .contains("Cuti Melahirkan".toLowerCase())
                                ? informasiSisaCutiMelahirkan()
                                : informasiSisaCuti(),
                            SizedBox(
                              height: 16,
                            ),
                            Text("Tipe *",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 5),
                            formTipe(),
                            SizedBox(
                              height: 16,
                            ),
                            controller.selectedTypeCuti.value
                                    .toString()
                                    .toLowerCase()
                                    .toLowerCase()
                                    .contains("Cuti Melahirkan".toLowerCase())
                                ? formTanggalCutiMelahirkan()
                                : formTanggalCuti(),
                            SizedBox(
                              height: 16,
                            ),
                            formDelegasiKepada(),
                            SizedBox(
                              height: 30,
                            ),
                            formUploadFile(),
                            SizedBox(
                              height: 30,
                            ),
                            formAlasan(),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                ),
              ),
            ),
          )),
      bottomNavigationBar: Obx(
        () => Padding(
            padding: EdgeInsets.all(16.0),
            child: !controller.statusHitungCuti.value
                ? SizedBox()
                : TextButtonWidget(
                    title: "Simpan",
                    onTap: () {
                      if (controller.selectedTypeCuti.value
                          .toString()
                          .toLowerCase()
                          .toLowerCase()
                          .contains("Cuti Melahirkan".toLowerCase())) {
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
                        DateTime date1 = DateTime(tempStartDate.year,
                            tempStartDate.month, tempStartDate.day);
                        DateTime date2 = DateTime(tempEndDate.year,
                            tempEndDate.month, tempEndDate.day);

                        // Calculate the difference between the two dates
                        Duration difference = date2.difference(date1);
                        controller.durasiIzin.value = difference.inDays + 1;
                        controller.durasiCutiMelahirkan.value =
                            difference.inDays + 1;

                        if (difference.inDays + 1 >
                            controller.jumlahCuti.value) {
                          UtilsAlert.showToast(
                              "Total hari melewati batas limit");
                          return;
                        }
                        controller.tanggalSelected.clear();
                        controller.tanggalSelected.value
                            .add(DateTime.parse(controller.startDate.value));
                        controller.tanggalSelected.value
                            .add(DateTime.parse(controller.endDate.value));

                        controller.validasiKirimPengajuan();

                        // Print the result
                      } else {
                        if (controller.statusForm.value == true) {
                          if ((controller.jumlahCuti.value -
                                  controller.cutiTerpakai.value) <
                              controller.tanggalSelectedEdit.value.length) {
                            UtilsAlert.showToast(
                                "Tanggal yang dipilih melebihi sisa cuti");
                          } else {
                            controller.validasiKirimPengajuan();
                          }
                        } else {
                          if ((controller.jumlahCuti.value -
                                  controller.cutiTerpakai.value) <
                              controller.tanggalSelected.value.length) {
                            UtilsAlert.showToast(
                                "Tanggal yang dipilih melebihi sisa cuti");
                          } else {
                            controller.validasiKirimPengajuan();
                          }
                        }
                      }

                      // controller.validasiKirimPengajuan();
                    },
                    colorButton: Constanst.colorPrimary,
                    colortext: Constanst.colorWhite,
                    border: BorderRadius.circular(20.0),
                  )),
      ),
    );
  }

  Widget informasiSisaCuti() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: Constanst.styleBoxDecoration1.borderRadius),
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Text(
                    "Cuti Pribadi",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  Expanded(
                      child: Text(
                    "${controller.cutiTerpakai.value}/${controller.jumlahCuti.value}",
                    textAlign: TextAlign.right,
                  )),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(Get.context!).size.width,
                child: Center(
                  child: LinearPercentIndicator(
                    barRadius: Radius.circular(15.0),
                    lineHeight: 8.0,
                    percent: controller.persenCuti.value,
                    progressColor: Constanst.colorPrimary,
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              // Text("Cuti Khusus"),
            ],
          ),
        ),
      ),
    );
  }

  Widget informasiSisaCutiMelahirkan() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: Constanst.styleBoxDecoration1.borderRadius),
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Text(
                    "Limit Cuti",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  Expanded(
                      child: Text(
                    "${controller.jumlahCuti.value}",
                    textAlign: TextAlign.right,
                  )),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(Get.context!).size.width,
                child: Center(
                  child: LinearPercentIndicator(
                    barRadius: Radius.circular(15.0),
                    lineHeight: 8.0,
                    percent: controller.persenCuti.value,
                    progressColor: Constanst.colorPrimary,
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              // Text("Cuti Khusus"),
            ],
          ),
        ),
      ),
    );
  }

  Widget formTipe() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: Constanst.borderStyle1,
          border: Border.all(
              width: 0.5, color: Color.fromARGB(255, 211, 205, 205))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isDense: true,
            items: controller.allTipeFormCutiDropdown.value
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(fontSize: 14),
                ),
              );
            }).toList(),
            value: controller.selectedTypeCuti.value,
            onChanged: (selectedValue) {
              var data = controller.allTipe
                  .where((p0) =>
                      p0['name'].toString().toLowerCase() ==
                      selectedValue.toString().toLowerCase())
                  .toList();
              controller.loadCutiUserMelahirkan();

              print(data.toString());

              if (data.isNotEmpty) {
                controller.jumlahCuti.value = data[0]['leave_day'];
              }

              // var data=controller.allTipe.value.whe
              controller.selectedTypeCuti.value = selectedValue!;
              // controller.selectedTypeCuti.value = selectedValue!;
            },
            isExpanded: true,
          ),
        ),
      ),
    );
  }

  Widget formTanggalCutiMelahirkan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text("Tanggal*", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(
          height: 5,
        ),
        widget.dataForm![1] == true
            ? controller.selectedTypeCuti.value
                    .toString()
                    .toLowerCase()
                    .toLowerCase()
                    .contains("Cuti Melahirkan".toLowerCase())
                ? SizedBox()
                : customTanggalDariSampaiDari()
            : SizedBox(),

        Row(
          children: [
            Expanded(
              flex: 50,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Tanggal Mulai *",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 12,
                    ),
                    InkWell(
                      onTap: () {
                        DatePicker.showPicker(
                          context,
                          pickerModel: CustomDatePicker(
                            currentTime: DateTime.now(),
                          ),
                          onConfirm: (time) {
                            if (time != null) {
                              controller.startDate.value =
                                  DateFormat('yyyy-MM-dd')
                                      .format(time)
                                      .toString();

                              print("$time");
                            }
                          },
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(width: 1, color: Constanst.Secondary),
                        ),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Obx(() => TextLabell(
                                  text: controller.startDate.value,
                                  size: 14,
                                ))),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              flex: 50,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Tanggal Selesai  *",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 12,
                    ),
                    InkWell(
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
                          ),
                          onConfirm: (time) {
                            if (time != null) {
                              controller.endDate.value =
                                  DateFormat('yyyy-MM-dd')
                                      .format(DateFormat('yyyy-MM-dd')
                                          .parse(time.toString()))
                                      .toString();

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
                      child: Container(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(width: 1, color: Constanst.Secondary),
                        ),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Obx(() => TextLabell(
                                  text: controller.endDate.value,
                                  size: 14,
                                ))),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        )
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
        //             weekendTextStyle: TextStyle(color: Colors.red),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Tanggal*", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(
          height: 5,
        ),
        widget.dataForm![1] == true
            ? customTanggalDariSampaiDari()
            : SizedBox(),
        Card(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: SfDateRangePicker(
              selectionMode: DateRangePickerSelectionMode.multiple,
              initialSelectedDates: controller.tanggalSelectedEdit.value,
              monthCellStyle: DateRangePickerMonthCellStyle(
                weekendTextStyle: TextStyle(color: Colors.red),
                blackoutDateTextStyle: TextStyle(
                    color: Colors.red, decoration: TextDecoration.lineThrough),
              ),
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                if (controller.statusForm.value == true) {
                  controller.tanggalSelectedEdit.value = args.value;
                  this.controller.tanggalSelectedEdit.refresh();
                } else {
                  controller.tanggalSelected.value = args.value;
                  this.controller.tanggalSelected.refresh();
                }
              },
            ))
      ],
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

  Widget formDelegasiKepada() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("Tugas Didelegasikan Kepada",
            style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(
          height: 5,
        ),
        Container(
          height: 50,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: Constanst.borderStyle1,
              border: Border.all(
                  width: 0.5, color: Color.fromARGB(255, 211, 205, 205))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isDense: true,
                items: controller.allEmployeeDelegasi.value
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(fontSize: 14),
                    ),
                  );
                }).toList(),
                value: controller.selectedDelegasi.value,
                onChanged: (selectedValue) {
                  controller.selectedDelegasi.value = selectedValue!;
                },
                isExpanded: true,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget formUploadFile() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Text("Upload File (Max 5MB)",
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(right: 10),
              child: controller.namaFileUpload.value == ""
                  ? InkWell(
                      onTap: () {
                        controller.takeFile();
                      },
                      child: Icon(
                        Iconsax.document_upload,
                        color: Constanst.colorPrimary,
                      ))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          flex: 85,
                          child: Text(
                            controller.namaFileUpload.value.length > 20
                                ? controller.namaFileUpload.value
                                        .substring(0, 15) +
                                    '...'
                                : controller.namaFileUpload.value,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Expanded(
                          flex: 15,
                          child: Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: InkWell(
                              onTap: () {
                                // controller.namaFileUpload.value == "";
                                // controller.base64FilePengajuan.value == "";
                                // controller.takeFile();
                              },
                              child: Icon(
                                Iconsax.close_circle,
                                color: Colors.red,
                                size: 18,
                              ),
                            ),
                          ),
                        )
                      ],
                    )),
        )
      ],
    );
  }

  Widget formAlasan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("Alasan*", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(
          height: 5,
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: Constanst.borderStyle1,
              border: Border.all(
                  width: 1.0, color: Color.fromARGB(255, 211, 205, 205))),
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: TextField(
              cursorColor: Colors.black,
              controller: controller.alasan.value,
              maxLines: null,
              decoration: new InputDecoration(
                  border: InputBorder.none, hintText: "Tambahkan Alasan"),
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.done,
              style:
                  TextStyle(fontSize: 12.0, height: 2.0, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
