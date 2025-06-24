import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/components/text.dart';
import 'package:siscom_operasional/controller/pph21.dart';
import 'package:siscom_operasional/screen/pph21/detail.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';
import 'package:siscom_operasional/utils/year_picker.dart';

class PPh21page extends StatefulWidget {
  const PPh21page({super.key});

  @override
  State<PPh21page> createState() => _PPh21pageState();
}

class _PPh21pageState extends State<PPh21page> {
  var controller = Get.put(Pph21Controller());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.fetchSlipGaji();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: TextApp.label(
            text: "PPh21", size: 16.0, color: Constanst.blackSurface),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: Material(
                    color: Colors.white,
                    elevation: 2,
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: 10,
                              child: Icon(
                                Iconsax.info_circle,
                                color: Constanst.colorPrimary,
                              )),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                              flex: 95,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextLabell(
                                    text: "Apa itu PPh21?",
                                    weight: FontWeight.bold,
                                    size: 14.0,
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  TextApp.label(
                                      text:
                                          "PPh Pasal 21 Adalah Pemotongan Atas Penghasilan Yang Dibayarkan Kepada Orang Pribadi Sehubungan Dengan Pekerjaan, Jabatan, Jasa,Dan Kegiatan.",
                                      size: 12.0,
                                      color: Constanst.Secondary)
                                ],
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 70,
                        child: TextLabell(
                          text: "Riwayat Potongan PPh21",
                          size: 14,
                          weight: FontWeight.w700,
                          color: Constanst.colorText3,
                        ),
                      ),
                      Expanded(
                          flex: 30,
                          child: InkWell(
                            onTap: () {
                              DatePicker.showPicker(
                                Get.context!,
                                pickerModel: CustomYearchPicker(
                                  minTime: DateTime(2020, 1, 1),
                                  maxTime: DateTime(2050, 1, 1),
                                  currentTime: DateTime(controller.tahun.value),
                                ),
                                onConfirm: (time) {
                                  if (time != null) {
                                    print("$time");
                                    var filter =
                                        DateFormat('yyyy-MM').format(time);
                                    var array = filter.split('-');
                                    var bulan = array[1];
                                    var tahun = array[0];

                                    controller.tahun.value = int.parse(tahun);

                                    controller.fetchSlipGaji();
                                  }
                                },
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: Constanst.borderStyle2,
                                  border:
                                      Border.all(color: Constanst.colorText2)),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Iconsax.calendar_1,
                                      size: 16,
                                    ),
                                    Flexible(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 8),
                                        child: Obx(() {
                                          return Text(
                                            controller.tahun.value.toString(),
                                            overflow: TextOverflow.ellipsis,
                                          );
                                        }),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: Container(
                    height: double.maxFinite,
                    child: Obx(() => controller.isLoading.value == true
                        ? Container(
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Constanst.colorPrimary,
                              ),
                            ),
                          )
                        : SingleChildScrollView(
                            child: Column(
                              children: List.generate(
                                  controller.slipGaji.length,
                                  (index) => list(index)),
                            ),
                          )),
                  ),
                )
              ],
            ),
          )),
    );
  }

  Widget list(index) {
    var data = controller.slipGaji[index];

    var date = DateTime(controller.tahun.value,
        int.parse(data.index.toString().replaceAll("fiscal", "")) + 1, 0);

    return InkWell(
      onTap: () {
        controller.bulan.value = data.month;
        controller.args.value = data;
        controller.detailGaji(index);
        Get.to(DetailPph21Page(
          month: data.monthNumber,
          year: controller.tahun,
        ));
      },
      child: Container(
        padding: EdgeInsets.only(bottom: 12, top: 12),
        child: Row(
          children: [
            Expanded(
                flex: 10,
                child: Icon(
                  Iconsax.receipt_2,
                  color: Constanst.Secondary,
                )),
            SizedBox(
              width: 4,
            ),
            Expanded(
                flex: 70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextApp.label(
                        text: data.month.toString(),
                        weigh: FontWeight.bold,
                        size: 14.0),
                    SizedBox(
                      height: 6,
                    ),
                    TextApp.label(
                        text:
                            "01 ${data.month.toString().substring(0, 3)} ${controller.tahun} - ${date.day}  ${data.month.toString().substring(0, 3)} ${controller.tahun}",
                        color: Constanst.Secondary,
                        size: 14.0)
                  ],
                )),
            Expanded(
                flex: 20,
                child: Align(
                    alignment: Alignment.centerRight,
                    child: TextApp.label(text: "")))
          ],
        ),
      ),
    );
  }
}
