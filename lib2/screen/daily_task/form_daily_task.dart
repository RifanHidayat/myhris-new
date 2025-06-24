import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/daily_task_controller.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/custom_dialog.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';

class FormDailyTask extends StatefulWidget {
  const FormDailyTask({super.key});

  @override
  State<FormDailyTask> createState() => _FormDailyTaskState();
}

class _FormDailyTaskState extends State<FormDailyTask> {
  final controller = Get.put(DailyTaskController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('ini list task init state ${controller.listTask} ');
      if (controller.statusForm.value == true) {
      } else {
        controller.listTask.clear();
      }
      controller.tanggalTask.refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (controller.listTask.isEmpty) {
          return true;
        } else {
          if (controller.isFormChanged.value == false) {
            bool? confirmExit = await _showExitConfirmationDialog(context);
            return confirmExit ?? false;
          }
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: Constanst.coloBackgroundScreen,
        appBar: AppBar(
            backgroundColor: Constanst.colorWhite,
            elevation: 0,
            leadingWidth: 50,
            titleSpacing: 0,
            centerTitle: true,
            title: Text(
              "Form Daily Task",
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
              onPressed: () async {
                if (controller.listTask.isEmpty) {
                  Navigator.of(context).pop();
                } else {
                  if (controller.isFormChanged.value == false) {
                    bool? confirmExit =
                        await _showExitConfirmationDialog(context);
                    if (confirmExit ?? false) {
                      Navigator.of(context).pop();
                    }
                  } else {
                    Navigator.of(context).pop();
                  }
                }
              },
            )),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                formHariDanTanggal(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(
                    height: 0,
                    thickness: 1,
                    color: Constanst.fgBorder,
                  ),
                ),
                buttonTambahTask(),
                formTugas(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Obx(() {
          return controller.listTask.isEmpty
              ? SizedBox()
              : Container(
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
                      padding:
                          const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 12.0),
                      child: ElevatedButton(
                        onPressed: () {
                          controller.statusDraft.value = 'post';
                          UtilsAlert.showLoadingIndicator(context);
                          controller.kirimDailyTask();
                          print('ini data per index ${controller.listTask}');
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
                );
        }),
      ),
    );
  }

  Future<bool?> _showExitConfirmationDialog(BuildContext context) async {
    return await showGeneralDialog(
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
            icon: 0,
            title: "Konfirmasi",
            content:
                "Apakah Anda yakin ingin keluar? Semua perubahan akan di simpan di draft.",
            positiveBtnText: "Ya",
            negativeBtnText: "Tidak",
            style: 1,
            buttonStatus: 1,
            negativeBtnPressed: () {
              controller.loadAllTask(AppData.informasiUser![0].em_id);
              Get.back();
              Get.back();
            },
            positiveBtnPressed: () {
              Get.back();
              controller.statusDraft.value = 'draft';
              controller.kirimDailyTask();
              Get.back(result: true);
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

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showGeneralDialog(
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
            icon: 0,
            title: "Peringatan",
            content: "Apakah Anda yakin ingin menghapus task ini?",
            positiveBtnText: "Ya",
            negativeBtnText: "Tidak",
            style: 1,
            buttonStatus: 1,
            positiveBtnPressed: () {
              if (controller.listTask.length == 1) {
                UtilsAlert.showToast("Pastikan anda mengisi minimal 1 tugas");
              } else {
                // controller.listTask.removeAt(index);
              }
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

  Widget buttonTambahTask() {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        children: [
          Text(
            'List Task',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Spacer(),
          InkWell(
              child: Icon(Icons.add),
              onTap: () {
                if (controller.tanggalTask.value.text == '') {
                  UtilsAlert.showToast('Pilih tanggal Task terlebih dahulu');
                } else {
                  bottomSheetTask(context);
                }
              })
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    // if (picked != null && picked != _selectedDate)
    setState(() {
      //_selectedDate = picked;
    });
  }

  Widget formHariDanTanggal() {
    return InkWell(
      onTap: () async {
        var dateSelect = await showDatePicker(
          context: Get.context!,
          firstDate:
              AppData.informasiUser![0].isBackDateLembur.toString() == "0"
                  ? DateTime(2000)
                  : DateTime.now(),
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
          controller.tanggalTask.value.text =
              Constanst.convertDate("$dateSelect");
          controller.tanggalTask.refresh();
        }
      },
      child: Padding(
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
                    Obx(() {
                      return Text(
                        controller.tanggalTask.value.text,
                        style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Constanst.fgPrimary),
                      );
                    }),
                  ],
                ),
              ],
            ),
            Icon(Iconsax.arrow_down_1, size: 20, color: Constanst.fgPrimary),
          ],
        ),
      ),
    );
  }

  void bottomSheetTask(BuildContext context, {int? editIndex}) {
    if (editIndex != null) {
      print(editIndex);
      controller.tempTask.value = controller.listTask[editIndex]["task"];
      controller.tempStatus.value =
          int.tryParse(controller.listTask[editIndex]["status"].toString()) ??
              0;
      controller.tempTitle.value = controller.listTask[editIndex]["judul"];
      controller.tempDifficulty.value =
          int.tryParse(controller.listTask[editIndex]["level"].toString()) ?? 0;
      controller.tempTanggalSelesai.value =
          controller.listTask[editIndex]['tgl_finish'];
    } else {
      controller.tempTask.value = "";
      controller.tempDifficulty.value = 1;
      controller.tempStatus.value = 0;
      controller.tempTitle.value = '';
      controller.tempTanggalSelesai.value = '';
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Menjadikan full screen
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 1, // Full screen
          minChildSize: 1, // Tidak bisa dikecilkan
          maxChildSize: 1,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 36.0),
                child: Scaffold(
                  appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(kToolbarHeight) * 1,
                    child: AppBar(
                      backgroundColor: Constanst.colorWhite,
                      elevation: 0,
                      titleSpacing: 0,
                      centerTitle: true,
                      title: Text(
                        editIndex == null ? "Add your task" : "Edit your task",
                        style: GoogleFonts.inter(
                            color: Constanst.fgPrimary,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      ),
                      leading: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Constanst.fgPrimary,
                          size: 24,
                        ),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ),
                  ),
                  body: Column(
                    children: [
                      // Konten utama
                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextLabell(
                                  text: "Judul *",
                                  color: Constanst.fgPrimary,
                                  size: 14,
                                  weight: FontWeight.w400,
                                ),
                                TextFormField(
                                  minLines: 1,
                                  maxLines: 1000,
                                  controller: TextEditingController(
                                    text: controller.tempTitle.value,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: 'Tulis Judul anda disini',
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    controller.tempTitle.value = value;
                                  },
                                  style: GoogleFonts.inter(
                                      color: Constanst.fgPrimary,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                                Divider(
                                  height: 0,
                                  thickness: 1,
                                  color: Constanst.fgBorder,
                                ),
                                const SizedBox(height: 16),
                                TextLabell(
                                  text: "Tugas *",
                                  color: Constanst.fgPrimary,
                                  size: 14,
                                  weight: FontWeight.w400,
                                ),
                                TextFormField(
                                  minLines: 1,
                                  maxLines: 1000,
                                  controller: TextEditingController(
                                    text: controller.tempTask.value,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: 'Tulis tugas anda disini',
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    controller.tempTask.value = value;
                                  },
                                  style: GoogleFonts.inter(
                                      color: Constanst.fgPrimary,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                                Divider(
                                  height: 0,
                                  thickness: 1,
                                  color: Constanst.fgBorder,
                                ),
                                const SizedBox(height: 16),
                                TextLabell(
                                  text: "Status task *",
                                  color: Constanst.fgPrimary,
                                  size: 14,
                                  weight: FontWeight.w400,
                                ),
                                Obx(() => DropdownButton<int>(
                                      value: controller.tempStatus.value,
                                      isExpanded: true,
                                      items: [
                                        {"label": "Ongoing", "value": 0},
                                        {"label": "Finished", "value": 1}
                                      ].map((item) {
                                        return DropdownMenuItem(
                                          value: item["value"] as int,
                                          child: Text(
                                            "${item["label"]}",
                                            style: GoogleFonts.inter(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        if (value != null) {
                                          try {
                                            // Ubah format tanggal dari "Jumat, 14-03-2025" menjadi DateTime
                                            DateTime taskDate = DateFormat(
                                                    "EEEE, dd-MM-yyyy", "id_ID")
                                                .parse(controller
                                                    .tanggalTask.value.text);

                                            if (value == 1 &&
                                                taskDate
                                                    .isAfter(DateTime.now())) {
                                              UtilsAlert.showToast(
                                                  'Task belum bisa diselesaikan karena tanggalnya belum tiba.');
                                            } else {
                                              controller.tempStatus.value =
                                                  value;
                                              controller.tempStatus.refresh();
                                            }
                                          } catch (e) {
                                            UtilsAlert.showToast(
                                                'Pilih tanggal Task terlebih dahulu');
                                          }
                                        }
                                      },
                                    )),
                                const SizedBox(height: 16),
                                TextLabell(
                                  text: "Tingkat Kesulitan *",
                                  color: Constanst.fgPrimary,
                                  size: 14,
                                  weight: FontWeight.w400,
                                ),
                                Obx(() => DropdownButton<int>(
                                      value: controller.tempDifficulty.value,
                                      isExpanded: true,
                                      items: [
                                        {"label": "Sangat Mudah", "value": 1},
                                        {"label": "Mudah", "value": 2},
                                        {"label": "Normal", "value": 3},
                                        {"label": "Sulit", "value": 4},
                                        {"label": "Sangat Sulit", "value": 5},
                                      ].map((item) {
                                        return DropdownMenuItem(
                                          value: item["value"] as int,
                                          child: Text(
                                            "${item["label"]} (${item["value"]})",
                                            style: GoogleFonts.inter(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        if (value != null) {
                                          controller.tempDifficulty.value =
                                              value;
                                        }
                                      },
                                    )),
                                const SizedBox(height: 16),
                                Obx(() => controller.tempStatus.value == 1
                                    ? InkWell(
                                        onTap: () async {
                                          var dateSelect = await showDatePicker(
                                            context: Get.context!,
                                            firstDate: AppData.informasiUser![0]
                                                        .isBackDateLembur
                                                        .toString() ==
                                                    "0"
                                                ? DateTime(2000)
                                                : DateTime.now(),
                                            lastDate: DateTime(2100),
                                            initialDate:
                                                controller.initialDate.value,
                                            cancelText: 'Batal',
                                            confirmText: 'Simpan',
                                            builder: (context, child) {
                                              return Theme(
                                                data: ThemeData(
                                                  colorScheme: ColorScheme.dark(
                                                    primary:
                                                        Constanst.onPrimary,
                                                    onPrimary:
                                                        Constanst.colorWhite,
                                                    onSurface:
                                                        Constanst.fgPrimary,
                                                    surface:
                                                        Constanst.colorWhite,
                                                  ),
                                                  // useMaterial3: settings.useMaterial3,
                                                  visualDensity:
                                                      VisualDensity.standard,
                                                  dialogTheme: const DialogTheme(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          16)))),
                                                  primaryColor:
                                                      Constanst.fgPrimary,
                                                  textTheme: TextTheme(
                                                    titleMedium:
                                                        GoogleFonts.inter(
                                                      color:
                                                          Constanst.fgPrimary,
                                                    ),
                                                  ),
                                                  dialogBackgroundColor:
                                                      Constanst.colorWhite,
                                                  canvasColor: Colors.white,
                                                  hintColor:
                                                      Constanst.onPrimary,
                                                  textButtonTheme:
                                                      TextButtonThemeData(
                                                    style: TextButton.styleFrom(
                                                      foregroundColor:
                                                          Constanst.onPrimary,
                                                    ),
                                                  ),
                                                ),
                                                child: child!,
                                              );
                                            },
                                          );
                                          if (dateSelect == null) {
                                            UtilsAlert.showToast(
                                                "Tanggal tidak terpilih");
                                          } else {
                                            try {
                                              // Ubah format tanggal dari "Jumat, 14-03-2025" menjadi DateTime
                                              DateTime taskDate = DateFormat(
                                                      "EEEE, dd-MM-yyyy",
                                                      "id_ID")
                                                  .parse(controller
                                                      .tanggalTask.value.text);

                                              print(
                                                  'ini taskDate : ${taskDate}');
                                              print(
                                                  'ini dateSelect : ${dateSelect}');
                                              print(
                                                  'ini datetime now : ${DateTime.now()}');
                                              if (taskDate
                                                  .isAfter(dateSelect)) {
                                                UtilsAlert.showToast(
                                                    'Task tidak bisa selesai di tanggal sebelum pengajuan');
                                              } else if (dateSelect
                                                  .isAfter(DateTime.now())) {
                                                UtilsAlert.showToast(
                                                    'Task tidak bisa selesai di tanggal masa depan');
                                              } else {
                                                controller.tempTanggalSelesai
                                                        .value =
                                                    Constanst.convertDate(
                                                        "$dateSelect");
                                                print(controller
                                                    .tempTanggalSelesai.value);
                                                controller.tempTanggalSelesai
                                                    .refresh();
                                              }
                                            } catch (e) {
                                              UtilsAlert.showToast(
                                                  'Pilih tanggal Task terlebih dahulu');
                                            }
                                          }
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Tanggal Selesai",
                                                          style: GoogleFonts.inter(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: Constanst
                                                                  .fgPrimary),
                                                        ),
                                                        const SizedBox(
                                                            height: 8),
                                                        Obx(() => Text(
                                                              controller
                                                                  .tempTanggalSelesai
                                                                  .value,
                                                              style: GoogleFonts.inter(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Constanst
                                                                      .fgPrimary),
                                                            )),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Icon(Iconsax.arrow_down_1,
                                                    size: 20,
                                                    color: Constanst.fgPrimary),
                                              ],
                                            ),
                                            Divider(
                                              height: 0,
                                              thickness: 1,
                                              color: Constanst.fgBorder,
                                            ),
                                          ],
                                        ),
                                      )
                                    : SizedBox())
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 12.0),
                        child: ElevatedButton(
                          onPressed: () {
                            print('ini tanggal selesai ${controller.tempTanggalSelesai.value}');
                            if(controller.tempStatus.value == 1 && controller.tempTanggalSelesai.value == ''){
                              UtilsAlert.showToast('Pastikan Anda mengisi tanggal selesai');
                              return;
                            }
                            if (controller.tempTask.value.isNotEmpty) {
                              if (editIndex == null) {
                                controller.listTask.add({
                                  'judul': controller.tempTitle.value,
                                  "task": controller.tempTask.value,
                                  "level": controller.tempDifficulty.value,
                                  'tgl_finish':
                                      controller.tempTanggalSelesai.value,
                                  'status': controller.tempStatus.value,
                                });
                              } else {
                                controller.listTask[editIndex]["task"] =
                                    controller.tempTask.value;
                                controller.listTask[editIndex]["level"] =
                                    controller.tempDifficulty.value;
                                controller.listTask[editIndex]['judul'] =
                                    controller.tempTitle.value;
                                controller.listTask[editIndex]['status'] =
                                    controller.tempStatus.value;
                                controller.listTask[editIndex]['tgl_finish'] =
                                    controller.tempTanggalSelesai.value;
                              }
                            }
                            controller.listTask.refresh();
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Constanst.colorWhite,
                              backgroundColor: Constanst.onPrimary,
                              elevation: 0,
                              padding: const EdgeInsets.fromLTRB(0, 12, 0, 12)),
                          child: Text(
                            'Simpan',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Constanst.colorWhite),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget formTugas() {
    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.listTask.length,
        itemBuilder: (context, index) {
          var data = controller.listTask[index];
          String difficultyLabel = "";
          String statusLabel = '';
          int level = int.tryParse(data["level"].toString()) ?? 0;
          int status = int.tryParse(data['status'].toString()) ?? 0;
          print('ini level kesulitan ${data['level']}');
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
          switch (status) {
            case 0:
              statusLabel = "Ongoing";
              break;
            case 1:
              statusLabel = "Finished";
              break;
            default:
              statusLabel = "Tidak Diketahui";
          }

          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextLabell(
                      text: "${index + 1}.",
                      color: Constanst.fgPrimary,
                      size: 16,
                      weight: FontWeight.w500,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['judul'],
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          data['task'],
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
                        Text(
                          "Status: $statusLabel",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          ),
                        ),
                        statusLabel == 'Ongoing'
                            ? SizedBox()
                            : Text(
                                'Selesai Pada: ${data['tgl_finish']}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                      ],
                    ),
                  ),
                  PopupMenuButton<int>(
                    icon: Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == 1) {
                        print(controller.listTask);
                        bottomSheetTask(Get.context!, editIndex: index);
                      } else if (value == 2) {
                        if (controller.listTask.length == 1) {
                          UtilsAlert.showToast(
                              "Pastikan anda mengisi minimal 1 tugas");
                          // Get.back();
                        } else {
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
                                  // icon: 0,
                                  title: "Peringatan",
                                  content:
                                      "Apakah Anda yakin ingin menghapus task ini?",
                                  positiveBtnText: "Ya",
                                  negativeBtnText: "Tidak",
                                  style: 1,
                                  buttonStatus: 1,
                                  positiveBtnPressed: () {
                                    controller.listTask.removeAt(index);
                                    Get.back();
                                  },
                                ),
                              );
                            },
                            pageBuilder: (BuildContext context,
                                Animation animation,
                                Animation secondaryAnimation) {
                              return null!;
                            },
                          );
                        }
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined, color: Colors.black),
                            SizedBox(width: 8),
                            Text("Edit"),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, color: Colors.red),
                            SizedBox(width: 8),
                            Text("Hapus"),
                          ],
                        ),
                      ),
                    ],
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
        },
      ),
    );
  }
}