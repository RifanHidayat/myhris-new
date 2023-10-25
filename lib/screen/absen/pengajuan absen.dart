import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/absen_controller.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/month_year_picker.dart';
import 'package:siscom_operasional/utils/date_picker.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';

class pengajuanAbsen extends StatefulWidget {
  const pengajuanAbsen({super.key});

  @override
  State<pengajuanAbsen> createState() => _pengajuanAbsenState();
}

class _pengajuanAbsenState extends State<pengajuanAbsen> {
  var absenController = Get.put(AbsenController());

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    absenController.resetData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        title: TextLabell(
          text: "Pengajuan Absen",
          color: Constanst.fgPrimary,
          size: 14.0,
        ),
      ),
      body:Obx(() {

      
          return Container(
            height: MediaQuery.of(context).size.height,
            child: Container(
              height: double.maxFinite,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                        height: double.maxFinite,
                        child: SingleChildScrollView(child: item())),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: (){
                            absenController.nextKirimPengajuan();

                          },
                          child: Container(
                            padding: EdgeInsets.all(16),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Constanst.onPrimary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                  child: Padding(
                                      padding: EdgeInsets.only(top: 8, bottom: 8),
                                      child: TextLabell(
                                        text: "Kirim",
                                        color: Colors.white,
                                        size: 14,
                                      ))),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  Widget item() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Constanst.fgBorder),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            //line 1
            InkWell(
              onTap: () {
                print("kesini");
                DatePicker.showPicker(
                  context,
                  pickerModel: CustomDatePicker(
                    minTime: DateTime(DateTime.now().year, DateTime.now().month-1, int.parse(AppData.informasiUser![0].beginPayroll.toString())),
                    maxTime:DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                    currentTime: DateTime.now(),
                  ),
                  onConfirm: (time) {
                    if (time != null) {
                      print("$time");
                        absenController.tglAjunan.value=DateFormat('yyyy-MM-dd').format(time).toString();
                      absenController.checkAbsensi();
                  
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 10, child: Icon(Iconsax.calendar)),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    flex: 90,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextLabell(
                          text: "Pilih Tanggal * ",
                          color: Constanst.fgPrimary,
                          size: 14,
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 90,
                                child: TextLabell(
                                  text:
                                      "${absenController.tglAjunan.value == "" ? "-" : absenController.tglAjunan.value}",
                                  color: Constanst.fgPrimary,
                                  weight: FontWeight.bold,
                                  size: 14,
                                )),
                            Expanded(
                                flex: 10,
                                child: Icon(Iconsax.arrow_down_1,
                                    color: Constanst.fgPrimary)),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),

            Divider(),
            SizedBox(
              height: 5,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 50,
                  child: Container(
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 10, child: Icon(Iconsax.login_1)),
                            SizedBox(
                              width: 14,
                            ),
                            Expanded(
                              flex: 50,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextLabell(
                                    text: "Absen Masuk",
                                    size: 14,
                                  ),
                                  TextLabell(
                                    text:
                                        "${absenController.checkinAjuan.value == "" ? "_ _ : _ _" : absenController.checkinAjuan.value}",
                                    size: 14,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Divider(),
                        SizedBox(
                          height: 5,
                        ),
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
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 10, child: Icon(Iconsax.logout_1)),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              flex: 50,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextLabell(
                                    text: "Absen Keluar",
                                    size: 14,
                                  ),
                                  TextLabell(
                                    text:
                                        "${absenController.checkoutAjuan.value == "" ? "_ _ : _ _" : absenController.checkoutAjuan.value}",
                                    size: 14,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        Divider()
                      ],
                    ),
                  ),
                )
              ],
            ),

            InkWell(
              onTap: () {
                showTimePicker(
                  context: Get.context!,
                  initialTime: TimeOfDay.now(),
                  initialEntryMode: TimePickerEntryMode.dial,
                ).then((value) {
                  if (value == null) {
                    UtilsAlert.showToast('gagal pilih jam');
                  } else {
                    var convertJam = value.hour <= 9
                        ? "0${value.hour}"
                        : "${value.hour}";
                    var convertMenit = value.minute <= 9
                        ? "0${value.minute}"
                        : "${value.minute}";
                    absenController.checkinAjuan2.value=
                        "$convertJam:$convertMenit";
                    // this.controller.dariJam.refresh();
                  }
                });
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 10, child: Icon(Iconsax.login_1)),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    flex: 90,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextLabell(
                          text: "Absen Masuk",
                          color: Constanst.fgPrimary,
                          size: 14,
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 90,
                                child: TextLabell(
                                  text:
                                      "${absenController.checkinAjuan2.value== "" ? "_ _ : _ _" : absenController.checkinAjuan2.value}",
                                  color: Constanst.fgPrimary,
                                  weight: FontWeight.bold,
                                  size: 14,
                                )),
                            Expanded(
                                flex: 10,
                                child: Icon(Iconsax.arrow_down_1,
                                    color: Constanst.fgPrimary)),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),

            Divider(),
            SizedBox(
              height: 5,
            ),

            InkWell(
              onTap: () {
                showTimePicker(
                  context: Get.context!,
                  initialTime: TimeOfDay.now(),
                  initialEntryMode: TimePickerEntryMode.dial,
                ).then((value) {
                  if (value == null) {
                    UtilsAlert.showToast('gagal pilih jam');
                  } else {
                          var convertJam = value.hour <= 9
                        ? "0${value.hour}"
                        : "${value.hour}";
                    var convertMenit = value.minute <= 9
                        ? "0${value.minute}"
                        : "${value.minute}";
                    absenController.checkoutAjuan2.value=
                        "$convertJam:$convertMenit";

                    // var convertJam = value.hour <= 9
                    //     ? "0${value.hour}"
                    //     : "${value.hour}";
                    // var convertMenit = value.minute <= 9
                    //     ? "0${value.minute}"
                    //     : "${value.minute}";
                    // controller.dariJam.value.text =
                    //     "$convertJam:$convertMenit";
                    // this.controller.dariJam.refresh();
                  }
                });
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 10, child: Icon(Iconsax.logout_1)),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    flex: 90,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextLabell(
                          text: "Absen Keluar",
                          color: Constanst.fgPrimary,
                          size: 14,
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 90,
                                child: TextLabell(
                                  text:
                                      "${absenController.checkoutAjuan2.value == "" ? "_ _ : _ _" : absenController.checkoutAjuan2.value}",
                                  color: Constanst.fgPrimary,
                                  weight: FontWeight.bold,
                                  size: 14,
                                )),
                            Expanded(
                                flex: 10,
                                child: Icon(Iconsax.arrow_down_1,
                                    color: Constanst.fgPrimary)),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),

            Divider(),
            SizedBox(
              height: 5,
            ),

            InkWell(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 10,
                    child: Icon(Iconsax.document_upload),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                      flex: 90,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextLabell(
                            text: "Unggah File",
                            size: 14,
                          ),
                          TextLabell(
                            text: "Ukuran File  5 MB",
                            size: 14,
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          InkWell(
                            onTap: () {
                               absenController.takeFile();
                            },
                            child: Obx(() => absenController.imageAjuan.value ==
                                    ""
                                ? Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                            width: 1,
                                            color: Constanst.fgBorder)),
                                    padding: EdgeInsets.all(1),
                                    child: Icon(Iconsax.add),
                                  )
                                : TextLabell(
                                    text: absenController.imageAjuan.value,color: Constanst.onPrimary,)),
                          )
                        ],
                      ))
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),

            Divider(),
            SizedBox(
              height: 5,
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 10,
                  child: Icon(Iconsax.textalign_justifyleft),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                    flex: 90,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextLabell(
                          text: "Catatan",
                          size: 14,
                        ),
                        TextFormField(
                          controller: absenController.catataanAjuan,
                          decoration: const InputDecoration(
                            hintText: 'Tulis catatan disini',
                            border: InputBorder.none,
                          ),
                        )
                      ],
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      absenController.imageAjuan.value=imageTemp.toString();
    
// setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      // print('Failed to pick image: $e');
    }
  }
}
