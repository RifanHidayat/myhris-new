import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:siscom_operasional/controller/approval_controller.dart';
import 'package:siscom_operasional/controller/global_controller.dart';
import 'package:siscom_operasional/main.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/custom_dialog.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';
import 'package:siscom_operasional/utils/widget_textButton.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPersetujuanLembur extends StatefulWidget {
  String? title, idxDetail, emId, delegasi, emIds, emIdPengaju;

  DetailPersetujuanLembur(
      {Key? key,
      this.title,
      this.idxDetail,
      this.emId,
      this.delegasi,
      this.emIds})
      : super(key: key);
  @override
  _DetailPersetujuanLemburState createState() =>
      _DetailPersetujuanLemburState();
}

class _DetailPersetujuanLemburState extends State<DetailPersetujuanLembur> {
  var controller = Get.find<ApprovalController>();
  var controllerGlobal = Get.find<GlobalController>();
  int hours = 0, minutes = 0, second = 0;

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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                          "Alasan Tolak Pengajuan",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: Constanst.borderStyle1,
                        border: Border.all(
                            width: 1.0,
                            color: Color.fromARGB(255, 211, 205, 205))),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 8,
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: TextField(
                        cursorColor: Colors.black,
                        controller: controller.alasan1.value,
                        maxLines: null,
                        maxLength: 225,
                        autofocus: true,
                        decoration: new InputDecoration(
                            border: InputBorder.none,
                            hintText: "Alasan Menolak"),
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.done,
                        style: TextStyle(
                            fontSize: 12.0, height: 2.0, color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
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
                            if (controller.alasan1.value.text != "") {
                              Navigator.pop(Get.context!);
                              validasiMenyetujui(false, em_id);
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
            SizedBox(
              height: 30,
            )
          ],
        );
      },
    );
  }

  void showBottomHasilLembur(em_id) {
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 8, top: 2),
                            child: Text(
                              "Catatan",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: Constanst.borderStyle1,
                                border: Border.all(
                                    width: 1.0,
                                    color: Color.fromARGB(255, 211, 205, 205))),
                            child: Padding(
                              padding: EdgeInsets.only(left: 8, bottom: 8),
                              child: TextField(
                                cursorColor: Colors.black,
                                controller: controller.alasan2.value,
                                maxLines: null,
                                maxLength: 225,
                                autofocus: true,
                                decoration: new InputDecoration(
                                    border: InputBorder.none, hintText: ""),
                                keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.done,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    height: 2.0,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 24.0),
                      child: Row(
                        children: [
                          Text('List Task'),
                          Spacer(),
                          Text('Score'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...controller.listTask.asMap().entries.map((entry) {
                            int index = entry.key;
                            var task = entry.value;
                            String difficultyLabel = "";
                            int level =
                                int.tryParse(task["level"].toString()) ?? 0;
                            print('ini level kesulitan ${task['level']}');
                            switch (level) {
                              case 1:
                                difficultyLabel = "Sangat Mudah";
                                break;
                              case 2:
                                difficultyLabel = "Mudah";
                                break;
                              case 3:
                                difficultyLabel = "Normal";
                                break;
                              case 4:
                                difficultyLabel = "Sulit";
                                break;
                              case 5:
                                difficultyLabel = "Sangat Sulit";
                                break;
                              default:
                                difficultyLabel = "Tidak Diketahui";
                            }
                            return Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 16.0, top: 16.0, bottom: 16.0),
                                      child: TextLabell(
                                        text: "${index + 1}.",
                                        color: Constanst.fgPrimary,
                                        size: 16,
                                        weight: FontWeight.w500,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              task['task'],
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "Kesulitan: $difficultyLabel",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    controller.detailData[0]['dinilai'] == 'N'
                                        ? SizedBox()
                                        : SizedBox(
                                            width: 50,
                                            child: TextFormField(
                                              controller: controller
                                                  .taskControllers[index],
                                              decoration: InputDecoration(
                                                hintText: '0%',
                                                border: InputBorder.none,
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly, // Hanya angka
                                                LengthLimitingTextInputFormatter(
                                                    3),
                                              ],
                                              onChanged: (value) {
                                                if (value.isNotEmpty) {
                                                  int input = int.parse(value);

                                                  if (input > 100) {
                                                    controller
                                                        .taskControllers[index]
                                                        .text = '100';
                                                    controller
                                                            .taskControllers[index]
                                                            .selection =
                                                        TextSelection
                                                            .fromPosition(
                                                      TextPosition(
                                                          offset: controller
                                                              .taskControllers[
                                                                  index]
                                                              .text
                                                              .length),
                                                    );
                                                  }
                                                  controller
                                                      .updateTotalPercentage();
                                                }
                                              },
                                            ),
                                          ),
                                  ],
                                ),
                                if (index != controller.listTask.length - 1)
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Divider(
                                      height: 0,
                                      thickness: 1,
                                      color: Constanst.fgBorder,
                                    ),
                                  ),
                              ],
                            );
                          }).toList(),
                          Obx(() {
                            return Text(
                              "Total Persentase: ${controller.totalPercentage.value}%",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            );
                          }),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButtonWidget(
                        title: "Kirim Persentase task",
                        onTap: () {
                          if (controller.alasan2.value.text.isNotEmpty) {
                            if (controller.taskControllers.any(
                                (taskController) =>
                                    taskController.text.isEmpty)) {
                              UtilsAlert.showToast(
                                  "Harap isi semua nilai presentase terlebih dahulu");
                            } else {
                              for (int i = 0;
                                  i < controller.taskControllers.length;
                                  i++) {
                                controller.listTask[i]['persentase'] =
                                    controller.taskControllers[i].text;
                              }
                              print(
                                  "ini listTask setelah di edit ${controller.listTask}");

                              Navigator.pop(Get.context!);
                              validasiMenyetujui(true, em_id);
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
                    )
                  ],
                ),
              );
            });
      },
    );
  }

  void showBottomHasilLemburDisable(em_id) {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 15,
              ),
              Text(
                'List Task',
                style: GoogleFonts.inter(
                  color: Constanst.fgPrimary,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...controller.listTask.asMap().entries.map((entry) {
                      int index = entry.key;
                      var task = entry.value;
                      String difficultyLabel = "";
                      int level = int.tryParse(task["level"].toString()) ?? 0;
                      print('ini level kesulitan ${task['level']}');
                      switch (level) {
                        case 1:
                          difficultyLabel = "Sangat Mudah";
                          break;
                        case 2:
                          difficultyLabel = "Mudah";
                          break;
                        case 3:
                          difficultyLabel = "Normal";
                          break;
                        case 4:
                          difficultyLabel = "Sulit";
                          break;
                        case 5:
                          difficultyLabel = "Sangat Sulit";
                          break;
                        default:
                          difficultyLabel = "Tidak Diketahui";
                      }
                      return Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 16.0, bottom: 16.0, right: 16.0),
                                child: TextLabell(
                                  text: "${index + 1}.",
                                  color: Constanst.fgPrimary,
                                  size: 16,
                                  weight: FontWeight.w500,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        task['task'],
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Kesulitan: $difficultyLabel",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              controller.detailData[0]['dinilai'] == 'N'
                                  ? SizedBox()
                                  : SizedBox(
                                      width: 50,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              "${task['persentase'].toString()}%",
                                              style: GoogleFonts.inter(
                                                color: Constanst.fgPrimary,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                          if (index != controller.listTask.length - 1)
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Divider(
                                height: 0,
                                thickness: 1,
                                color: Constanst.fgBorder,
                              ),
                            ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 24.0, 16.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      'Total score',
                      style: GoogleFonts.inter(
                        color: Constanst.fgPrimary,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    )),
                    Spacer(),
                    Text(
                      '${controller.totalPercent}%',
                      style: GoogleFonts.inter(
                        color: controller.totalPercent.value <= 60
                            ? Colors.red
                            : Colors.green,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showBottomAlasanApprove(em_id) {
    var status = controller.detailData[0]['status'];
    var approveStatus = controller.detailData[0]['approve_status'];
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                          "Alasan Menyetujui Pengajuan",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: Constanst.borderStyle1,
                        border: Border.all(
                            width: 1.0,
                            color: Color.fromARGB(255, 211, 205, 205))),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 8,
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: TextField(
                        cursorColor: Colors.black,
                        controller:
                            status == "Pending" || approveStatus == "Pending"
                                ? controller.alasan1.value
                                : controller.alasan2.value,
                        maxLines: null,
                        maxLength: 225,
                        autofocus: true,
                        decoration: new InputDecoration(
                            border: InputBorder.none,
                            hintText: "Alasan Menyetujui"),
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.done,
                        style: TextStyle(
                            fontSize: 12.0, height: 2.0, color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
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
                            if (status == "Pending" ||
                                approveStatus == "Pending") {
                              if (controller.alasan1.value.text != "") {
                                Navigator.pop(Get.context!);
                                validasiMenyetujui(true, em_id);
                              } else {
                                UtilsAlert.showToast(
                                    "Harap isi alasan terlebih dahulu");
                              }
                            } else {
                              if (controller.alasan2.value.text != "") {
                                Navigator.pop(Get.context!);
                                validasiMenyetujui(true, em_id);
                              } else {
                                UtilsAlert.showToast(
                                    "Harap isi alasan terlebih dahulu");
                              }
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
            SizedBox(
              height: 30,
            )
          ],
        );
      },
    );
  }

  void validasiMenyetujui(pilihan, em_id) {
    int styleChose = pilihan == false ? 1 : 2;
    var stringPilihan = pilihan == false ? 'Tolak' : 'Menyetujui';
    showGeneralDialog(
      barrierDismissible: false,
      context: Get.context!,
      barrierColor: Colors.black54, // space around dialog
      transitionDuration: Duration(milliseconds: 200),
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
                  title: 'Klaim',
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
                  emIdApproval1: controller.detailData[0]['delegasi'],
                  emIdApproval2: controller.detailData[0]['em_ids'] == "" ||
                          controller.detailData[0]['em_ids'] == "null" ||
                          controller.detailData[0]['em_ids'] == null
                      ? controller.detailData[0]['delegasi']
                      : controller.detailData[0]['em_ids'],
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
    // controller.getDetailData(
  controller.getDetailData(
        widget.idxDetail, widget.emId, widget.title, widget.delegasi);
    print('ini emI dz user new id ${widget.emIds}');
    print('ini emIdz user ${controller.detailData}');
    // Future.delayed(Duration(seconds: 2));
    controller.infoIds(controller.detailData[0]['em_ids']); 
    controller.infoTask(widget.idxDetail);

    super.initState();
    var emId = AppData.informasiUser![0].em_id;
    print('ini emId user ${emId}');

    if (controllerGlobal.valuePolaPersetujuan.value.toString() == "1") {
      if (controller.detailData[0]['nama_approve1'] == "" ||
          controller.detailData[0]['nama_approve1'] == "null" ||
          controller.detailData[0]['nama_approve1'] == null) {
        if (controller.detailData[0]['delegasi'].contains(emId)) {
          print('kondisi 1 terpenuhi');
          controller.showButton.value = true;
        } else {
          print('kodisai 1 gagal');
          controller.showButton.value = false;
        }
      } else {
        print('kodisi 2 terpenuhi');
      }
    } else {
      if (controller.detailData[0]['nama_approve1'] == "" ||
          controller.detailData[0]['nama_approve1'] == "null" ||
          controller.detailData[0]['nama_approve1'] == null) {
        if (controller.detailData[0]['dinilai'] == 'Y') {
          if (controller.detailData[0]['delegasi'].toString().contains(emId)) {
            print('kodisi 3 terpenuhi');
            controller.showButton.value = true;
          } else {
            print('kodisi 3 gagal');
            controller.showButton.value = false;
          }
        } else {
          if (controller.detailData[0]['em_report_to']
              .toString()
              .contains(emId)) {
            print('kodisi 3 terpenuhi');
            controller.showButton.value = true;
          } else {
            print('kodisi 3 gagal');
            controller.showButton.value = false;
          }
        }
      } else {
        if (controller.detailData[0]['em_ids'] == "" ||
            controller.detailData[0]['em_ids'] == "null" ||
            controller.detailData[0]['em_ids'] == null) {
          if (controller.detailData[0]['dinilai'] == 'Y') {
            if (controller.detailData[0]['delegasi'].contains(emId)) {
              print('kodisi 4 terpnuhi');
              controller.showButton.value = true;
            } else {
              print('kondisi 4 gagal');
              controller.showButton.value = false;
            }
          } else {
            if (controller.detailData[0]['em_report_to'].contains(emId)) {
              print('kodisi 4 terpnuhi');
              controller.showButton.value = true;
            } else {
              print('kondisi 4 gagal');
              controller.showButton.value = false;
            }
          }
        } else {
          if (controller.detailData[0]['dinilai'] == 'Y') {
            if (controller.detailData[0]['em_ids'].contains(emId)) {
              print('kodisi 5 terpenuhi');
              controller.showButton.value = true;
            } else {
              print('kodisi 5 gqgal');
              controller.showButton.value = false;
            }
          } else {
            if (controller.detailData[0]['em_report2_to'].contains(emId)) {
              print('kodisi 4 terpnuhi');
              controller.showButton.value = true;
            } else {
              print('kondisi 4 gagal');
              controller.showButton.value = false;
            }
          }
        }
      }
    }
    print('ini emId ${widget.emId}');
    print('ini emIds ${widget.emIds}');
    print('ini delegasi ${widget.delegasi}');
    print('ini em_report_to ${controller.detailData[0]['em_report_to']}');
    print('ini em_ids ${controller.detailData[0]['em_ids']}');
    print('ini value showButton ${controller.showButton.value}');
    print('ini status ${controller.detailData[0]['status']}');

    if (controller.detailData[0]['type'].toString().toLowerCase() ==
        "Lembur".toString().toLowerCase()) {
      DateTime start = DateTime.parse(
          "${controller.detailData[0]['waktu_pengajuan']} ${controller.detailData[0]['waktu_dari']}");
      DateTime end = DateTime.parse(
          "${controller.detailData[0]['waktu_pengajuan']} ${controller.detailData[0]['waktu_sampai']}");

      Duration difference = end.difference(start);

      hours = (difference.inHours % 24);
      print('ini start $start');
      print('ini end $end');
      print('ini hours $hours');
      minutes = (difference.inMinutes % 60);
      second = (difference.inSeconds % 60);
    }
  }

  @override
  Widget build(BuildContext context) {
    var totalKlaim = controller.detailData[0]['type'] == "Klaim"
        ? controller.detailData[0]['lainnya']['total_claim']
        : 0;
    var rupiah = controller.convertToIdr(totalKlaim, 0);
    var namaTipe = controller.detailData[0]['type'] == "Klaim"
        ? controller.detailData[0]['lainnya']['nama_tipe']
        : "";
    var image = controller.detailData[0]['image'];
    var typeAjuan = controller.detailData[0]['leave_status'];
    print('ini typeAjuan $typeAjuan');
    var em_id = controller.detailData[0]['em_id_pengaju'];
    var em_id_user = AppData.informasiUser![0].em_id;
    var status = controller.detailData[0]['status'];
    var approveStatus = controller.detailData[0]['approve_status'];
    var approveStatus2 = controller.detailData[0]['approve2_status'];
    var diNilai = controller.detailData[0]['dinilai'];
    var delegasi = controller.detailData[0]['delegasi'];
    var emReport = controller.detailData[0]['em_report_to'];
    var emReport2 = controller.detailData[0]['em_report2_to'];
    print('ini em id apa yak $em_id');
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
              title: Text(
                "Detail Persetujuan Lembur",
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
      bottomNavigationBar: typeAjuan == "Approve2" && diNilai == "Y"
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    showBottomHasilLemburDisable(em_id);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                            color: Constanst.colorPrimary, width: 1.0)),
                    // padding: const EdgeInsets.fromLTRB(20, 12, 20, 12)
                  ),
                  child: Text(
                    'Hasil Lembur',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        color: Constanst.colorPrimary,
                        fontSize: 14),
                  ),
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(
                () => controller.showButton.value == true &&
                            (status == "Pending" ||
                                approveStatus == "Pending" &&
                                    delegasi.toString().contains(em_id_user)) ||
                        (approveStatus == "Approve" &&
                            diNilai == "N" &&
                            emReport2.toString().contains(em_id_user) &&
                            approveStatus2 == 'Pending') ||
                        (approveStatus == "Pending" &&
                            diNilai == "N" &&
                            emReport.toString().contains(em_id_user))
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
                                  controller.alasan2.value.clear();
                                  controller.alasan1.value.clear();
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
                                  controller.alasan2.value.clear();
                                  controller.alasan1.value.clear();
                                  showBottomAlasanApprove(em_id);
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
                    : Obx(() {
                        return controller.showButton.value == true &&
                                controller.detailData[0]['approve2_status'] ==
                                    "Pending" &&
                                controller.detailData[0]['approve_status'] ==
                                    'Approve' &&
                                controller.detailData[0]['em_ids']
                                    .toString()
                                    .contains(em_id_user) &&
                                controller.detailData[0]['dinilai'] == 'Y'
                            ? SizedBox(
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: () {
                                    controller.alasan2.value.clear();
                                    controller.alasan1.value.clear();
                                    showBottomHasilLembur(em_id);
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
                                    'Hasil Lembur',
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                        color: Constanst.colorWhite,
                                        fontSize: 14),
                                  ),
                                ),
                              )
                            : controller.detailData[0]['dinilai'] == 'N'
                                ? SizedBox()
                                : SizedBox(
                                    height: 40,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        showBottomHasilLemburDisable(em_id);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            side: BorderSide(
                                                color: Constanst.colorPrimary,
                                                width: 1.0)),
                                      ),
                                      child: Text(
                                        'Hasil Lembur',
                                        style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                            color: Constanst.colorPrimary,
                                            fontSize: 14),
                                      ),
                                    ),
                                  );
                      }),
              )),
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
                      controller.jumlahCuti.value == 0
                          ? const SizedBox()
                          : informasiSisaCuti(),
                      controller.jumlahCuti.value == 0
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
                                  Column(
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
                                            ''.toString(),
                                        style: GoogleFonts.inter(
                                            color: Constanst.fgSecondary,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14),
                                      ),
                                    ],
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
                                "Tipe Lembur",
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
                                "Pengajuan ${controller.detailData[0]['type']} - ${controller.detailData[0]['nama_pengajuan']}",
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
                                "Jam Lembur",
                                style: GoogleFonts.inter(
                                    color: Constanst.fgSecondary,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "${controller.detailData[0]['waktu_dari']} ",
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                        color: Constanst.fgPrimary,
                                        fontSize: 16),
                                  ),
                                  controller.detailData[0]['type'] == "Klaim"
                                      ? const SizedBox()
                                      : Text(
                                          "s.d",
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              color: Constanst.fgPrimary,
                                              fontSize: 16),
                                        ),
                                  controller.detailData[0]['type'] == "Klaim"
                                      ? const SizedBox()
                                      : Text(
                                          " ${controller.detailData[0]['waktu_sampai']}",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              color: Constanst.fgPrimary,
                                              fontSize: 16),
                                        ),
                                  // Text(
                                  //   Constanst.convertDate6(
                                  //       DateFormat("dd-MM-yyyy")
                                  //           .parse(controller.detailData[0]
                                  //               ['waktu_dari'])
                                  //           .toString()),
                                  //   style: GoogleFonts.inter(
                                  //       fontWeight: FontWeight.w500,
                                  //       color: Constanst.fgPrimary,
                                  //       fontSize: 16),
                                  // ),
                                  // controller.detailData[0]['type'] == "Klaim"
                                  //     ? SizedBox()
                                  //     : Expanded(
                                  //         flex: 10,
                                  //         child: Text("s.d",
                                  //             style: TextStyle(
                                  //                 fontWeight: FontWeight.bold)),
                                  //       ),
                                  // controller.detailData[0]['type'] == "Klaim"
                                  //     ? SizedBox()
                                  //     : Expanded(
                                  //         flex: 45,
                                  //         child: Text(
                                  //           "${controller.detailData[0]['waktu_sampai']}",
                                  //           textAlign: TextAlign.center,
                                  //           style: TextStyle(
                                  //               fontWeight: FontWeight.bold),
                                  //         ),
                                  //       ),
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
                              controller.detailData[0]['type'] == "Lembur"
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Durasi Lembur",
                                          style: GoogleFonts.inter(
                                              color: Constanst.fgSecondary,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "$hours Jam $minutes Menit $second Detik",
                                          style: GoogleFonts.inter(
                                              color: Constanst.fgPrimary,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16),
                                        )
                                      ],
                                    )
                                  : const SizedBox(),
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
                              // controller.detailData[0]['title_ajuan'] ==
                              //         "Pengajuan Tidak Hadir"
                              //     ? informasiIzinJam()
                              //     : const SizedBox(),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 12.0, bottom: 12.0),
                                child: Divider(
                                  thickness: 1,
                                  height: 0,
                                  color: Constanst.border,
                                ),
                              ),
                              controller.detailData[0]['type']
                                          .toString()
                                          .toLowerCase() ==
                                      'absensi'.toLowerCase()
                                  ? const SizedBox()
                                  : controller.detailData[0]['type'] ==
                                              "Lembur" ||
                                          controller.detailData[0]['type'] ==
                                              "Tugas Luar" ||
                                          controller.detailData[0]['type'] ==
                                              "Dinas Luar"
                                      ? Text(
                                          "Atas perintah",
                                          style: GoogleFonts.inter(
                                              color: Constanst.fgSecondary,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14),
                                        )
                                      : controller.detailData[0]['type'] ==
                                              "Klaim"
                                          ? Text(
                                              "Total Klaim",
                                              style: GoogleFonts.inter(
                                                  color: Constanst.fgSecondary,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14),
                                            )
                                          : Text(
                                              "Delegasi Kepada",
                                              style: TextStyle(
                                                  color: Constanst.colorText2),
                                            ),
                              const SizedBox(height: 4),
                              controller.detailData[0]['type'] == "Klaim"
                                  ? Text(
                                      "$rupiah",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Text(
                                      "${controller.detailData[0]['nama_delegasi']}",
                                      style: GoogleFonts.inter(
                                          color: Constanst.fgPrimary,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                    ),

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
                              diNilai == 'N'
                                  ? SizedBox()
                                  : Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Peminta lembur",
                                            style: GoogleFonts.inter(
                                                color: Constanst.fgSecondary,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            controller.fullNameApprove2
                                                .join(', '),
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
                                        ],
                                      ),
                                    ),

                              diNilai == "Y" &&
                                      controller.detailData[0]
                                              ['approve_status'] !=
                                          'Pending'
                                  ? SizedBox()
                                  : InkWell(
                                      onTap: () {
                                        showBottomHasilLemburDisable(em_id);
                                      },
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "List Task",
                                              style: GoogleFonts.inter(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.w400,
                                                  fontStyle: FontStyle.italic,
                                                  fontSize: 15),
                                            ),
                                            SizedBox(height: 4),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 12.0, bottom: 12.0),
                                              child: Divider(
                                                thickness: 1,
                                                height: 0,
                                                color: Constanst.border,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                              //singgle approval
                              controller.valuePolaPersetujuan == 1 ||
                                      controller.valuePolaPersetujuan == "1"
                                  ? singgleApproval(controller.detailData[0])
                                  : multipleApproval(controller.detailData[0])

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
                              //             typeAjuan == "Approve1" ||
                              //             typeAjuan == "Approve2"
                              //         ? Row(
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
                              //                   Padding(
                              //                     padding: const EdgeInsets.only(
                              //                         left: 3),
                              //                     child: Column(
                              //                       crossAxisAlignment:
                              //                           CrossAxisAlignment.start,
                              //                       children: [
                              //                         Text(
                              // controller.valuePolaPersetujuan ==
                              //             1 ||
                              //         controller
                              //                 .valuePolaPersetujuan ==
                              //             "1"
                              //                               ? controller
                              //                                       .detailData[0]
                              //                                   ['leave_status']
                              //                               : controller.detailData[
                              //                                               0][
                              //                                           'leave_status'] ==
                              //                                       "Pending"
                              //                                   ? "Pending Approval 1"
                              //                                   : "Pending Approval 2",
                              //                           textAlign:
                              //                               TextAlign.center,
                              //                           style: GoogleFonts.inter(
                              //                               fontWeight:
                              //                                   FontWeight.w500,
                              //                               color: Constanst
                              //                                   .fgPrimary,
                              //                               fontSize: 14),
                              //                         ),
                              //                         controller.detailData[0][
                              //                                         'nama_approve1'] ==
                              //                                     "" ||
                              //                                 controller.detailData[
                              //                                             0][
                              //                                         'leave_status'] ==
                              //                                     "Pending"
                              //                             ? const SizedBox()
                              //                             : Text(
                              //                                 "Approve 1 by - ${controller.detailData[0]['nama_approve1']}",
                              //                                 style: GoogleFonts.inter(
                              //                                     fontWeight:
                              //                                         FontWeight
                              //                                             .w500,
                              //                                     color: Constanst
                              //                                         .fgPrimary,
                              //                                     fontSize: 14),
                              //                               ),
                              //                       ],
                              //                     ),
                              //                   ),
                              //                   // const SizedBox(height: 4),
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
                              //                   Padding(
                              //                     padding: const EdgeInsets.only(
                              //                         left: 3),
                              //                     child: Column(
                              //                       crossAxisAlignment:
                              //                           CrossAxisAlignment.start,
                              //                       children: [
                              //                         Text(
                              //                           controller.valuePolaPersetujuan ==
                              //                                       1 ||
                              //                                   controller
                              //                                           .valuePolaPersetujuan ==
                              //                                       "1"
                              //                               ? controller
                              //                                       .detailData[0]
                              //                                   ['leave_status']
                              //                               : controller.detailData[
                              //                                               0][
                              //                                           'leave_status'] ==
                              //                                       "Pending"
                              //                                   ? "Pending Approval 1"
                              //                                   : "Pending Approval 2",
                              //                           textAlign:
                              //                               TextAlign.center,
                              //                           style: GoogleFonts.inter(
                              //                               fontWeight:
                              //                                   FontWeight.w500,
                              //                               color: Constanst
                              //                                   .fgPrimary,
                              //                               fontSize: 14),
                              //                         ),
                              //                         controller.detailData[0][
                              //                                         'nama_approve1'] ==
                              //                                     "" ||
                              //                                 controller.detailData[
                              //                                             0][
                              //                                         'leave_status'] ==
                              //                                     "Pending"
                              //                             ? const SizedBox()
                              //                             : Text(
                              //                                 "Approve 1 by - ${controller.detailData[0]['nama_approve1']}",
                              //                                 style: GoogleFonts.inter(
                              //                                     fontWeight:
                              //                                         FontWeight
                              //                                             .w500,
                              //                                     color: Constanst
                              //                                         .fgPrimary,
                              //                                     fontSize: 14),
                              //                               ),
                              //                       ],
                              //                     ),
                              //                   ),
                              //                   // const SizedBox(height: 4),
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
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }

  Widget singgleApproval(data) {
    var text = "";
    if (data['approve_status'] == "Pending" || data['status'] == "Pending") {
      text = "Pending Approval";
    }
    if (data['approve_status'] == "Rejected") {
      text = "Rejected by - ${data['nama_approve1']}";
    }
    if (data['approve_status'] == "Approve") {
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
                      data['approve_status'] == "Pending" ||
                              data['status'] == "Pending"
                          ? Icon(
                              Iconsax.timer,
                              color: Constanst.warning,
                              size: 22,
                            )
                          : data['approve_status'] == "Rejected"
                              ? Icon(
                                  Iconsax.tick_circle,
                                  color: Colors.green,
                                  size: 22,
                                )
                              : Icon(
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
                          Text("$text ",
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
    if (data['approve_status'] == "Pending" ||
        data['leave_status'] == "Pending") {
      text = "Pending Approval 1";
    }
    if (data['approve_status'] == "Rejected") {
      text = "Rejected By - ${data['nama_approve1']}";
    }

    if (data['approve_status'] == "Approve" ||
        data['leave_status'] == "Approve") {
      text = "Approve 1 By - ${data['nama_approve1']}";

      if (data['approve2_status'] == "Pending") {
        text2 = "Pending Approval 2";
      }
      if (data['approve2_status'] == "Rejected") {
        text2 = "Rejected 2 By - ${data['nama_approve2']}";
      }

      if (data['approve2_status'] == "Approve") {
        text2 = "Approved 2 By - ${data['nama_approve2']} ";
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
              data['approve_status'] == "Pending"
                  ? Icon(
                      Iconsax.timer,
                      color: Constanst.warning,
                      size: 22,
                    )
                  : data['approve_status'] == "Rejected"
                      ? Icon(
                          Iconsax.close_circle,
                          color: Colors.red,
                          size: 22,
                        )
                      : Icon(
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
          data['approve_status'] == "Approve"
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 2.5, top: 2, bottom: 2),
                      child: Container(
                        height: 30,
                        child: VerticalDivider(
                          color: Constanst.Secondary,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          data['approve2_status'] == "Pending"
                              ? Icon(
                                  Iconsax.timer,
                                  color: Constanst.warning,
                                  size: 22,
                                )
                              : data['approve2_status'] == "Rejected"
                                  ? Icon(
                                      Iconsax.close_circle,
                                      color: Colors.red,
                                      size: 22,
                                    )
                                  : Icon(
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
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : SizedBox(),
        ],
      ),
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
        const SizedBox(height: 12),
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
              SizedBox(
                width: MediaQuery.of(Get.context!).size.width,
                child: LinearPercentIndicator(
                  barRadius: const Radius.circular(100.0),
                  lineHeight: 8.0,
                  padding: EdgeInsets.zero,
                  percent: controller.persenCuti.value,
                  progressColor: Constanst.colorPrimary,
                ),
              ),

              // Text("Cuti Khusus"),
            ],
          ),
        ),
      ),
    );
  }

  // Widget informasiIzinJam() {
  //   return SizedBox(
  //     child: controller.detailData[0]['category'] == "HALFDAY"
  //         ? Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 "Kategori",
  //                 style: TextStyle(color: Constanst.colorText2),
  //               ),
  //               SizedBox(
  //                 height: 5,
  //               ),
  //               Text(
  //                 "${controller.detailData[0]['category']}",
  //                 style: TextStyle(fontWeight: FontWeight.bold),
  //               ),
  //               SizedBox(
  //                 height: 10,
  //               ),
  //               Text(
  //                 "Jam",
  //                 style: TextStyle(color: Constanst.colorText2),
  //               ),
  //               SizedBox(
  //                 height: 5,
  //               ),
  //               Text(
  //                 "${controller.detailData[0]['jamAjuan']} sd ${controller.detailData[0]['sampaiJamAjaun']}",
  //                 style: TextStyle(fontWeight: FontWeight.bold),
  //               ),
  //               SizedBox(
  //                 height: 10,
  //               ),
  //             ],
  //           )
  //         : SizedBox(),
  //   );
  // }

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
}
