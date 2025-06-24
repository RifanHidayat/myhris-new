import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/audit_controller.dart';
import 'package:siscom_operasional/screen/audit/detail_audit_screen.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/month_year_picker.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';
import 'package:siscom_operasional/utils/widget_textButton.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';

class AuditScreen extends StatefulWidget {
  const AuditScreen({super.key});

  @override
  State<AuditScreen> createState() => _AuditScreenState();
}

class _AuditScreenState extends State<AuditScreen> {
  final controller = Get.find<AuditController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getTimeNow();
    controller.fetchAuditData(isLoadMore: false);
    controller.getFilterEmployee();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constanst.colorWhite,
        elevation: 0,
        leadingWidth: 50,
        titleSpacing: 0,
        centerTitle: true,
        title: const Text("Audit"),
        actions: [
              IconButton(
                onPressed: () {
                  controller.fetchAuditData(allData: true);
                  UtilsAlert.showLoadingIndicator(context);
                  // controller.generateAndOpenPdf();
                },
                icon: Icon(
                  Iconsax.document_text,
                  color: Constanst.fgPrimary,
                  size: 24,
                ),
                padding: EdgeInsets.only(right: 16.0),
              )
            ]
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: filterData(),
          ),
          Expanded(
            child: Obx(() {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: controller.auditList.isEmpty
                    ? Center(
                        child: Text('Data tidak ada'),
                      )
                    : listAjuanAudit(),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget listAjuanAudit() {
    return ListView.builder(
        controller: controller.scrollController,
        physics: controller.auditList.length <= 8
            ? const AlwaysScrollableScrollPhysics()
            : const BouncingScrollPhysics(),
        itemCount: controller.auditList.length + 1,
        itemBuilder: (context, index) {
          if (index == controller.auditList.length) {
            return controller.isLoadingMore.value
                ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : const SizedBox(); // Jangan tampilkan apa-apa jika tidak loading
          }
          var audit = controller.auditList[index];
          var full_name = audit['full_name'];
          var em_id = audit['em_id'];
          var nomor_ajuan = audit['nomor'];
          var branch = audit['branch_id'];
          var jabatan = audit['jabatan'];
          var formStatus = audit['form_status'];
          var tipeForm = audit['tipe_pengajuan'];
          var status = audit['status'];
          var tipePengajuan = audit['tipe_pengajuan'];
          return Column(
            children: [
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Constanst.colorNonAktif)),
                child: InkWell(
                  customBorder: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  onTap: () {
                    // controller.getDetailAudit(audit['id'], tipeForm);
                    controller.idTrx.value = audit['id'].toString();
                    controller.logAudit();

                    print('ini audit yang nerima surat ${audit['approve1']}');
                    final approve1 = audit['approve1'];
                    final approve2 = audit['approve2'];
                    final users = audit['users'];

                    controller.availableUsers.value = [];

                    if (approve1 != null) {
                      final data =
                          approve1 is String ? json.decode(approve1) : approve1;
                      controller.availableUsers
                          .add(Map<String, dynamic>.from(data));
                    }

                    if (approve2 != null) {
                      final data =
                          approve2 is String ? json.decode(approve2) : approve2;
                      controller.availableUsers
                          .add(Map<String, dynamic>.from(data));
                    }

                    if (users != null) {
                      final data = users is String ? json.decode(users) : users;
                      controller.availableUsers
                          .add(Map<String, dynamic>.from(data));
                    }

                    print('availableUsers: ${controller.availableUsers}');
                    print(
                        'type of first item: ${controller.availableUsers.isNotEmpty ? controller.availableUsers.first.runtimeType : 'empty'}');
                    controller.showDetailRiwayat(audit);
                    print(audit);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 12, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("$full_name - $jabatan",
                            style: GoogleFonts.inter(
                                color: Constanst.fgPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        Text("$tipeForm",
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.inter(
                                color: Constanst.fgSecondary,
                                fontSize: 16,
                                fontWeight: FontWeight.w400)),
                        const SizedBox(height: 4),
                        Text('$nomor_ajuan',
                            style: GoogleFonts.inter(
                                color: Constanst.fgSecondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w400)),
                        const SizedBox(height: 12),
                        Divider(
                            height: 0, thickness: 1, color: Constanst.border),
                        const SizedBox(height: 8),
                        status == "Approve2" || status == "Approve"
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Iconsax.tick_circle,
                                    color: Colors.green,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "$status",
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          color: Constanst.fgPrimary,
                                          fontSize: 14),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              )
                            : status == "Rejected"
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Iconsax.close_circle,
                                        color: Colors.red,
                                        size: 22,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          "$status",
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              color: Constanst.fgPrimary,
                                              fontSize: 14),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Iconsax.timer,
                                        color: Colors.yellow,
                                        size: 22,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          "$status",
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              color: Constanst.fgPrimary,
                                              fontSize: 14),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  Widget filterData() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(right: 16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              tanggal(),
              SizedBox(width: 8.0),
              status(),
              SizedBox(width: 8.0),
              cabang(),
              SizedBox(width: 8.0),
              statusPengajuan(),
              SizedBox(width: 8.0),
              tipeForm(),
              SizedBox(width: 8.0),
              statusAudit(),
              // status()
            ],
          ),
        ),
      ),
    );
  }

  InkWell tanggal() {
    return InkWell(
      customBorder: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(100))),
      onTap: () {
        DatePicker.showPicker(
          Get.context!,
          pickerModel: CustomMonthPicker(
            minTime: DateTime(2000, 1, 1),
            maxTime: DateTime(2100, 1, 1),
            currentTime: DateTime(
                int.parse(controller.tahunSelectedSearchHistory.value),
                int.parse(controller.bulanSelectedSearchHistory.value),
                1),
          ),
          onConfirm: (time) {
            if (time != null) {
              print("$time");
              var filter = DateFormat('yyyy-MM').format(time);
              var array = filter.split('-');
              var bulan = array[1];
              var tahun = array[0];
              controller.bulanSelectedSearchHistory.value = bulan;
              controller.tahunSelectedSearchHistory.value = tahun;
              controller.bulanDanTahunNow.value = "$bulan-$tahun";
              this.controller.bulanSelectedSearchHistory.refresh();
              this.controller.tahunSelectedSearchHistory.refresh();
              this.controller.bulanDanTahunNow.refresh();
              controller.date.value = time;
              controller.fetchAuditData();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
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
        ),
      ),
    );
  }

  PopupMenuButton<String> cabang() {
    return PopupMenuButton<String>(
      onSelected: (newValue) {
        controller.selectedBranch.value = newValue;
        controller.fetchAuditData();
      },
      itemBuilder: (context) => controller.branchList.map((branch) {
        return PopupMenuItem<String>(
          value: branch,
          child: Text(
            branch,
          ),
        );
      }).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: Constanst.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              controller.selectedBranch.value.isEmpty
                  ? "Pilih Cabang" // Placeholder jika belum ada yang dipilih
                  : controller.selectedBranch.value,
              style: GoogleFonts.inter(
                color: Constanst.fgSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
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
    );
  }

  PopupMenuButton<String> statusPengajuan() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        controller.filterStatus.value = value == 'Semua Status' ? '' : value;
        controller.tempFilterStatus.value = value;
        controller.fetchAuditData();
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: "Semua Status",
          child: Text("Semua Status"),
        ),
        PopupMenuItem(
          value: "Pending",
          child: Text("Pending"),
        ),
        PopupMenuItem(
          value: "Approve",
          child: Text("Approve"),
        ),
        PopupMenuItem(
          value: "Approve2",
          child: Text("Approve2"),
        ),
        PopupMenuItem(
          value: "Rejected",
          child: Text("Rejected"),
        ),
      ],
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
              color:
                  Constanst.border), // Ganti dengan Constanst.border jika ada
        ),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.tempFilterStatus.value,
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
    );
  }

  PopupMenuButton<String> tipeForm() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        controller.filterTipeForm.value =
            value == 'Semua Tipe Form' ? '' : value;
        controller.tempFilterTipeForm.value = value;
        controller.fetchAuditData();
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: "Semua Tipe Form",
          child: Text("Semua Tipe Form"),
        ),
        PopupMenuItem(
          value: "Izin",
          child: Text("Izin"),
        ),
        PopupMenuItem(
          value: "Sakit",
          child: Text("Sakit"),
        ),
        PopupMenuItem(
          value: "Tugas Luar",
          child: Text("Tugas Luar"),
        ),
        PopupMenuItem(
          value: "Dinas Luar",
          child: Text("Dinas Luar"),
        ),
        PopupMenuItem(
          value: "Cuti",
          child: Text("Cuti"),
        ),
        PopupMenuItem(
          value: "Pengajuan Absen",
          child: Text("Pengajuan Absen"),
        ),
        PopupMenuItem(
          value: "Absen Offline",
          child: Text("Absen Offline"),
        ),
        PopupMenuItem(
          value: "WFH",
          child: Text("WFH"),
        ),
        PopupMenuItem(
          value: "Lembur",
          child: Text("Lembur"),
        ),
      ],
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
              color:
                  Constanst.border), // Ganti dengan Constanst.border jika ada
        ),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.tempFilterTipeForm.value,
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
    );
  }

  PopupMenuButton<String> statusAudit() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        controller.filterStatusAudit.value =
            value == "Semua Status Audit" ? '' : value;
        controller.tempfilterStatusAudit.value = value;
        controller.fetchAuditData();
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: "Semua Status Audit",
          child: Text("Semua Status Audit"),
        ),
        PopupMenuItem(
          value: "Draft",
          child: Text("Draft"),
        ),
        PopupMenuItem(
          value: "Reject",
          child: Text("Reject"),
        ),
        PopupMenuItem(
          value: "Approve",
          child: Text("Approve"),
        ),
      ],
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
              color:
                  Constanst.border), // Ganti dengan Constanst.border jika ada
        ),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.tempfilterStatusAudit.value,
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
    );
  }

  void showBottomStatus(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return SafeArea(
              child: Column(
                children: [
                  // Header dengan Dropdown Filter Cabang
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Dropdown Filter Cabang
                        // Expanded(
                        //   child: Obx(() {
                        //     return DropdownButtonHideUnderline(
                        //       child: DropdownButton<String>(
                        //         isExpanded: true,
                        //         value: controller.selectedBranch.value,
                        //         onChanged: (newValue) {
                        //           controller.selectedBranch.value = newValue!;
                        //         },
                        //         items: controller.branchList.toSet().map((branch) {
                        //           return DropdownMenuItem<String>(
                        //             value: branch,
                        //             child: Text(branch, style: GoogleFonts.inter(fontSize: 16)),
                        //           );
                        //         }).toList(),
                        //       ),
                        //     );
                        //   }),
                        // ),

                        Text(
                          'Karyawan',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        // Tombol Tutup
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close,
                              size: 26, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),

                  // Divider
                  const Divider(thickness: 1, height: 0, color: Colors.grey),

                  // List Karyawan
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Obx(() {
                        // int selectedBranchId = controller.getBranchIdByName(controller.selectedBranch.value);
                        var monitorings = controller.listEmployee;
                        print(monitorings);

                        // var filteredList = monitorings.where((item) {
                        //   return selectedBranchId == -1 || item['branch_id'] == selectedBranchId;
                        // }).toList();

                        return Column(
                          children: List.generate(monitorings.length, (index) {
                            var monitoring = monitorings;
                            var full_name = monitoring[index]['full_name'];
                            var em_id = monitoring[index]['em_id'];

                            var isSelected =
                                controller.tempNamaStatus1.value == full_name;

                            return InkWell(
                              onTap: () {
                                controller.tempNamaStatus1.value = full_name;
                                controller.emId.value = em_id;
                                controller.fetchAuditData();
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      full_name,
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: isSelected
                                            ? Constanst.onPrimary
                                            : Colors.black87,
                                      ),
                                    ),
                                    Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: isSelected ? 2 : 1,
                                          color: isSelected
                                              ? Constanst.onPrimary
                                              : Colors.grey,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: isSelected
                                          ? Container(
                                              decoration: BoxDecoration(
                                                color: Constanst.onPrimary,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            )
                                          : null,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget status() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(100)),
        border: Border.all(color: Constanst.fgBorder),
      ),
      child: InkWell(
        customBorder: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(100))),
        onTap: () {
          // if (controller.allTask.isEmpty) {
          //   // Get.snackbar("Error", "Data tidak tersedia.");
          // } else {

          showBottomStatus(Get.context!);
          // Get.snackbar("${controller.monitoringList.length}", "ddd");
          const CircularProgressIndicator();
          // }
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Text(
                  controller.tempNamaStatus1.value,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Constanst.fgSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Iconsax.arrow_down_1,
                size: 18,
                color: Constanst.fgSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
