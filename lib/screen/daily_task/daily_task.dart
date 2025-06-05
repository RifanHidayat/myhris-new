import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/absen_controller.dart';
import 'package:siscom_operasional/controller/daily_task_controller.dart';
import 'package:siscom_operasional/model/absen_model.dart';
import 'package:siscom_operasional/model/daily_task_model.dart';
import 'package:siscom_operasional/screen/absen/loading_absen.dart';
import 'package:siscom_operasional/screen/daily_task/detail_daily_task.dart';
import 'package:siscom_operasional/screen/daily_task/form_daily_task.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/month_year_picker.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';

class DailyTask extends StatefulWidget {
  const DailyTask({super.key});

  @override
  State<DailyTask> createState() => _DailyTaskState();
}

class _DailyTaskState extends State<DailyTask> {
  final DailyTaskController controller = Get.put(DailyTaskController());
  final AbsenController controllerAbsensi = Get.find<AbsenController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      controller.getTimeNow();
    
    controller.atasanStatus.value = '';
    controller.loadAllTask(AppData.informasiUser![0].em_id);
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                "Daily Task",
                style: GoogleFonts.inter(
                    color: Constanst.fgPrimary,
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
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
              actions: [
                IconButton(
                  onPressed: () {
                    var em_id = AppData.informasiUser![0].em_id;
                    UtilsAlert.showLoadingIndicator(context);
                    controller.generateAndOpenPdf(em_id);
                  },
                  icon: Icon(
                    Iconsax.document_text,
                    color: Constanst.fgPrimary,
                    size: 24,
                  ),
                  padding: EdgeInsets.only(right: 16.0),
                )
              ]),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: filterData(),
          ),
          Expanded(
            child: Obx(() {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: controller.allTask.isEmpty
                    ? Center(
                        child: Text('Sedang memuat data, sabar ya'),
                      )
                    : listAbsen(),
              );
            }),
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
        child: Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 16.0, bottom: 12.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                controller.tanggalTaskOld.value = '';
                controller.tanggalTask.value.text =
                    Constanst.convertDate("${DateTime.now()}");
                controller.statusForm.value = false;
                Get.to(FormDailyTask());
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
                'Tambah Task',
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

  Widget listAbsen() {
    // return Obx(() {
    String filter = controller.filterStatus.value;

    // Saring daftar task berdasarkan filter yang dipilih
    List<DailyTaskModel> filteredTasks = controller.allTask.where((task) {
      if (filter == "Semua") {
        return true;
      } else if (filter == 'Ongoing') {
        return task.breakoutTime != 0 && task.breakinTime != 'draft';
        ;
      } else if (filter == 'Finished') {
        return task.breakoutNote == task.breakoutPict &&
            task.breakoutNote != 0 &&
            task.breakinTime != 'draft';
        ;
      } else if (filter == 'Draft') {
        return task.breakinTime == 'draft';
      }
      return false;
    }).toList();
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        DailyTaskModel task = filteredTasks[index];
        DateTime date = DateTime.parse(task.date);

        return tampilan2(task, date);
      },
    );
    // });
  }

  Widget tampilan2(DailyTaskModel index, date) {
    print('ini index date ${index.atten_date}');
    print('ini id index ${index.namaHariLibur}');
    var startTime;
    var endTime;
    var startDate;
    var endDate;
    var now = DateTime.now();

    TimeOfDay waktu1 = TimeOfDay(
        hour: int.parse(
            AppData.informasiUser![0].startTime.toString().split(':')[0]),
        minute: int.parse(
            AppData.informasiUser![0].startTime.toString().split(':')[1]));

    TimeOfDay waktu2 = TimeOfDay(
        hour: int.parse(
            AppData.informasiUser![0].endTime.toString().split(':')[0]),
        minute: int.parse(AppData.informasiUser![0].endTime
            .toString()
            .split(':')[1])); // Waktu kedua
    print('ini waktu 1${AppData.informasiUser![0].startTime}');
    int totalMinutes1 = waktu1.hour * 60 + waktu1.minute;
    int totalMinutes2 = waktu2.hour * 60 + waktu2.minute;
    var tipeAbsen = AppData.informasiUser![0].tipeAbsen;
    var tipeAlpha = AppData.informasiUser![0].tipeAlpha;
    var list = tipeAlpha.toString().split(',').map(int.parse).toList();
    print('ini tampilan 2 $tipeAbsen $tipeAlpha $list');
    var masuk = list[0];
    var keluar = list[1];
    var istirahatMasuk = list[2];
    var istirahatKeluar = list[3];
    var jamMasuk = index.signin_time ?? '';
    var jamKeluar = index.signout_time ?? '';
    print(jamKeluar.isEmpty);
    print(keluar);
    var jamIstirahatMasuk = index.breakinTime ?? '';
    var jamIstirahatKeluar = index.breakoutTime ?? '';
    if (tipeAbsen == '2') {
      if ((keluar == 1 && jamKeluar == '00:00:00') ||
          (masuk == 1 && jamMasuk == '00:00:00')) {
        controller.tipeAlphaAbsen.value = 1;
        if (jamMasuk == '00:00:00') {
          controller.catatanAlpha.value = '/ Gak Absen Masuk';
        } else {
          controller.catatanAlpha.value = '/ Gak Absen Keluar';
        }
      } else {
        controller.tipeAlphaAbsen.value = 0;
      }
    } else if (tipeAbsen == '3') {
      print('gak mungkin gak kemari');
      if ((keluar == 1 && jamKeluar == '00:00:00') ||
          (masuk == 1 && jamMasuk == '00:00:00') ||
          (jamIstirahatKeluar == '00:00:00' && istirahatKeluar == 1) ||
          (jamIstirahatMasuk == '00:00:00' && istirahatMasuk == 1)) {
        print('masa gak kesini');
        controller.tipeAlphaAbsen.value = 1;
        if (jamMasuk == '00:00:00') {
          controller.catatanAlpha.value = '/ Gak Absen Masuk';
        } else if (jamKeluar == '00:00:00') {
          controller.catatanAlpha.value = '/ Gak Absen Keluar';
        } else if (jamIstirahatKeluar == '00:00:00') {
          controller.catatanAlpha.value = '/ Gak Absen Istirahat Keluar';
        } else if (jamIstirahatMasuk == '00:00:00') {
          controller.catatanAlpha.value = '/ Gak Absen Istirahat Masuk';
        }
      } else {
        controller.tipeAlphaAbsen.value = 0;
      }
    }
    String statusString = index.breakinTime == 'draft'
        ? 'Draft'
        : index.breakoutNote == index.breakoutPict && index.breakoutNote != 0
            ? 'Finished'
            : (int.tryParse(index.breakoutTime.toString())! <=
                        int.tryParse(index.breakoutPict.toString())! &&
                    index.breakoutTime != 0)
                ? 'Ongoing'
                : '';
    Color statusColor = index.breakoutNote == index.breakoutPict &&
            index.breakoutNote != 0 &&
            index.breakinTime != 'draft'
        ? Colors.green
        : Colors.orange;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        customBorder: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
        onTap: () async {
          if (index.atten_date != null) {
            UtilsAlert.showLoadingIndicator(context);
            await controller.loadTask(index.id);
            if (index.date != null) {
              // print('ini date ${}')
              controller.tanggalTask.value.text =
                  Constanst.convertDate(index.date ?? "${DateTime.now()}");
            } else {
              controller.tanggalTask.value.text =
                  Constanst.convertDate("${DateTime.now()}");
            }
            controller.tanggalTaskOld.value = index.date.toString();
            print('ini tanggal lama ${controller.tanggalTaskOld.value}');
            controller.statusForm.value = true;
            Get.to(FormDailyTask());
          } else {
            print('ini date ${index.date}');
            if (index.date != null) {
              controller.tanggalTask.value.text =
                  Constanst.convertDate(index.date ?? "${DateTime.now()}");
            } else {
              controller.tanggalTask.value.text =
                  Constanst.convertDate("${DateTime.now()}");
            }
            controller.tanggalTaskOld.value = index.date.toString();
            print('ini tanggal lama ${controller.tanggalTaskOld.value}');
            controller.tanggalTask.refresh();
            controller.statusForm.value = false;
            Get.to(FormDailyTask());
          }
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: index.atten_date == null
                      ? Constanst.colorNeutralBgSecondary
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(width: 1, color: Constanst.fgBorder)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 15,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: index.atten_date != null
                              ? Constanst.colorNeutralBgSecondary
                              : Colors.white,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                          child: index.namaHariLibur != null ||
                                  index.offDay.toString() != '0'
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        DateFormat('d').format(
                                            DateFormat('yyyy-MM-dd').parse(
                                                index.date ?? date.toString())),
                                        style: GoogleFonts.inter(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Constanst.fgPrimary,
                                        )),
                                    Text(
                                        DateFormat('EEEE', 'id').format(
                                            DateFormat('yyyy-MM-dd').parse(
                                                index.date ?? date.toString())),
                                        style: GoogleFonts.inter(
                                          fontSize: 8,
                                          fontWeight: FontWeight.w400,
                                          color: Constanst.fgPrimary,
                                        )),
                                  ],
                                )
                              : Column(
                                  children: [
                                    Text(
                                        DateFormat('d').format(
                                            DateFormat('yyyy-MM-dd')
                                                .parse(index.date)),
                                        style: GoogleFonts.inter(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.red,
                                        )),
                                    Text(
                                        DateFormat('EEEE', 'id').format(
                                            DateFormat('yyyy-MM-dd')
                                                .parse(index.date)),
                                        style: GoogleFonts.inter(
                                          fontSize: 8,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.red,
                                        )),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 85,
                    child: index.atten_date == "" || index.atten_date == null
                        ?
                        //tidak ada absen
                        index.namaHariLibur != null
                            ? Padding(
                                padding: const EdgeInsets.only(left: 18),
                                child: TextLabell(
                                  text: index.namaHariLibur,
                                  weight: FontWeight.w500,
                                ))
                            : index.namaTugasLuar != null
                                ? const Padding(
                                    padding: EdgeInsets.only(left: 18),
                                    child: TextLabell(
                                      text: "Tugas Luar",
                                      weight: FontWeight.w500,
                                    ))
                                : index.namaDinasLuar != null
                                    ? const Padding(
                                        padding: EdgeInsets.only(left: 18),
                                        child: TextLabell(
                                          text: "Dinas Luar",
                                          weight: FontWeight.w500,
                                        ))
                                    : index.namaCuti != null
                                        ? const Padding(
                                            padding: EdgeInsets.only(left: 18),
                                            child: TextLabell(
                                              text: "Cuti",
                                              weight: FontWeight.w500,
                                            ))
                                        : index.namaSakit != null
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 18),
                                                child: TextLabell(
                                                  text:
                                                      "Sakit : ${index.namaSakit}",
                                                  weight: FontWeight.w500,
                                                ))
                                            : index.namaIzin != null
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 18),
                                                    child: TextLabell(
                                                      text:
                                                          "Izin : ${index.namaIzin}",
                                                      weight: FontWeight.w500,
                                                    ))
                                                : index.offDay.toString() == '0'
                                                    ? const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 18),
                                                        child: TextLabell(
                                                          text:
                                                              "Hari Libur Kerja",
                                                          weight:
                                                              FontWeight.w500,
                                                        ))
                                                    : const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 18),
                                                        child: TextLabell(
                                                          text:
                                                              "Belum ada task",
                                                          weight:
                                                              FontWeight.w500,
                                                        ))
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              index.atten_date != "" || index.atten_date != null
                                  ? controller.tipeAlphaAbsen.value == 1 &&
                                          (endTime.isBefore(now))
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(top: 12),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Iconsax.info_circle,
                                                size: 15,
                                                color: Constanst.infoLight,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              TextLabell(
                                                text:
                                                    "ALPHA ${controller.catatanAlpha.value}",
                                                weight: FontWeight.w400,
                                              ),
                                            ],
                                          ))
                                      : index.namaHariLibur != null
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 12),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Iconsax.info_circle,
                                                    size: 15,
                                                    color: Constanst.infoLight,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  TextLabell(
                                                    text: index.namaHariLibur,
                                                    weight: FontWeight.w400,
                                                  ),
                                                ],
                                              ))
                                          : index.namaTugasLuar != null
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 12),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Iconsax.info_circle,
                                                        size: 15,
                                                        color:
                                                            Constanst.infoLight,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      TextLabell(
                                                        text:
                                                            index.namaTugasLuar,
                                                        weight: FontWeight.w400,
                                                      ),
                                                    ],
                                                  ))
                                              : index.namaDinasLuar != null
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 12),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Iconsax.info_circle,
                                                            size: 15,
                                                            color: Constanst
                                                                .infoLight,
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          TextLabell(
                                                            text: index
                                                                .namaDinasLuar,
                                                            weight:
                                                                FontWeight.w400,
                                                            size: 11.0,
                                                          ),
                                                        ],
                                                      ))
                                                  : index.namaCuti != null
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 12),
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Iconsax
                                                                    .info_circle,
                                                                size: 15,
                                                                color: Constanst
                                                                    .infoLight,
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              TextLabell(
                                                                text: index
                                                                    .namaCuti,
                                                                weight:
                                                                    FontWeight
                                                                        .w400,
                                                                size: 11.0,
                                                              ),
                                                            ],
                                                          ))
                                                      : index.namaSakit != null
                                                          ? Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 12),
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                    Iconsax
                                                                        .info_circle,
                                                                    size: 15,
                                                                    color: Constanst
                                                                        .infoLight,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  TextLabell(
                                                                    text: index
                                                                        .namaSakit,
                                                                    weight:
                                                                        FontWeight
                                                                            .w400,
                                                                    size: 11.0,
                                                                  ),
                                                                ],
                                                              ))
                                                          : index.offDay
                                                                      .toString() ==
                                                                  '0'
                                                              ? Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          4.0),
                                                                  child: Row(
                                                                    children: [
                                                                      Icon(
                                                                        Iconsax
                                                                            .info_circle,
                                                                        size:
                                                                            15,
                                                                        color: Constanst
                                                                            .infoLight,
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            4,
                                                                      ),
                                                                      const TextLabell(
                                                                        text:
                                                                            "Hari Libur Kerja",
                                                                        weight:
                                                                            FontWeight.w300,
                                                                        size:
                                                                            11.0,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              : SizedBox()
                                  : const SizedBox(),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 18, top: 4.0),
                                child: Text(
                                  "Lihat task",
                                  style: GoogleFonts.inter(
                                      // color: statusColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 18.0,
                                    right: 8.0,
                                    top: 8.0,
                                    bottom: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Finish: ${index.breakoutNote.toString()}',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      'Ongoing: ${index.breakoutTime.toString()}',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      'Jumlah: ${index.breakoutPict.toString()}',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                  )
                ],
              ),
            ),
            index.atten_date == null
                ? SizedBox()
                : Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        statusString,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget filterData() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(right: 16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                customBorder: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(100))),
                onTap: () {
                  DatePicker.showPicker(
                    Get.context!,
                    pickerModel: CustomMonthPicker(
                      minTime: DateTime(2000, 1, 1),
                      maxTime: DateTime(2100, 1, 1),
                      currentTime: DateTime(
                          int.parse(
                              controller.tahunSelectedSearchHistory.value),
                          int.parse(
                              controller.bulanSelectedSearchHistory.value),
                          1),
                    ),
                    onConfirm: (time) {
                      if (time != null) {
                        print("$time");
                        var filter = DateFormat('yyyy-MM').format(time);
                        var array = filter.split('-');
                        var bulan = array[1];
                        var tahun = array[0];
                        var emId = AppData.informasiUser![0].em_id;
                        controller.bulanSelectedSearchHistory.value = bulan;
                        controller.tahunSelectedSearchHistory.value = tahun;
                        controller.bulanDanTahunNow.value = "$bulan-$tahun";
                        this.controller.bulanSelectedSearchHistory.refresh();
                        this.controller.tahunSelectedSearchHistory.refresh();
                        this.controller.bulanDanTahunNow.refresh();

                        controller.date.value = time;
                        controller.atasanStatus.value = '';
                        controller.loadAllTask(emId);
                      }
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Constanst.border)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, bottom: 8.0, left: 12.0, right: 12.0),
                    child: Row(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Constanst.convertDateBulanDanTahun(
                                  controller.bulanDanTahunNow.value),
                              style: GoogleFonts.inter(
                                  color: Constanst.fgSecondary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Icon(
                                Iconsax.arrow_down_1,
                                color: Constanst.fgSecondary,
                                size: 18,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.0),
              PopupMenuButton<String>(
                onSelected: (value) {
                  controller.filterStatus.value = value;
                  print('ini value $value');
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: "Semua",
                    child: Text("Semua"),
                  ),
                  PopupMenuItem(
                    value: "Ongoing",
                    child: Text("Ongoing"),
                  ),
                  PopupMenuItem(
                    value: "Finished",
                    child: Text("Finish"),
                  ),
                  PopupMenuItem(
                    value: "Draft",
                    child: Text("Draft"),
                  ),
                ],
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                        color: Constanst
                            .border), // Ganti dengan Constanst.border jika ada
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 12.0),
                  child: Row(
                    children: [
                      Text(
                        controller.filterStatus.value,
                        style: GoogleFonts.inter(
                            color: Constanst
                                .fgSecondary, // Ganti dengan Constanst.fgSecondary jika ada
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Iconsax.arrow_down_1,
                        color: Constanst.fgSecondary,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
