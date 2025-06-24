import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/custom_dialog.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';
import 'package:siscom_operasional/utils/widget_textButton.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class AuditController extends GetxController {
  var auditList = [].obs;
  var detailAudit = [].obs;
  var listEmployee = [].obs;
  var searchTl = [].obs;
  var searchSp = [].obs;
  var tahunSelectedSearchHistory = ''.obs;
  var bulanSelectedSearchHistory = ''.obs;
  var bulanDanTahunNow = ''.obs;
  var idTrx = ''.obs;
  var date = DateTime.now().obs;
  var tempNamaStatus1 = ''.obs;
  var emId = ''.obs;
  var filterStatus = ''.obs;
  var tempFilterStatus = 'Semua Status'.obs;
  var filterTipeForm = ''.obs;
  var tempFilterTipeForm = 'Semua Tipe Form'.obs;
  var filterStatusAudit = 'Draft'.obs;
  var tempfilterStatusAudit = 'Draft'.obs;
  var offset = 0.obs;
  var isLoadingMore = false.obs;
  var alasanReject = TextEditingController().obs;
  var branchList = <String>[
    'Semua Cabang',
    'PT. SHAN INFORMASI SISTEM',
    'PT. REFORMASI ANUGERAH JAVA JAYA',
  ].obs;
  var statusCondition = ''.obs;
  var listStatusPengajuan = <Map<String, String>>[
    {'name': "None", 'value': "none"},
    {'name': "Teguran Lisan", 'value': "teguran_lisan"},
    {'name': "Surat Peringatan", 'value': "surat_peringatan"}
  ].obs;
  var konsekuemsiList = [].obs;
  var statusPemgajuanIzin = 'none'.obs;

  var availableUsers = [].obs;

  var selectedUsersName = <String>[].obs;
  var selectedUsersEm_id = <String>[].obs;
  var selectedUsersData = <Map<String, dynamic>>[].obs;

  var statusLog = [].obs;

  void updateListStatus() {
    print('ini di update gak sih');
    print('ini di update gak sih${searchSp}');
    print('searchSp: ${searchSp.value}, searchTl: ${searchTl.value}');
    print(searchSp.isEmpty || searchTl.isEmpty);
    listStatusPengajuan.value = searchSp.isNotEmpty || searchTl.isNotEmpty
        ? [
            {'name': "None", 'value': "none"},
            {'name': "Teguran Lisan", 'value': "teguran_lisan"},
            {'name': "Surat Peringatan", 'value': "surat_peringatan"}
          ]
        : [
            {'name': "None", 'value': "none"},
            {'name': "Teguran Lisan", 'value': "teguran_lisan"},
            {'name': "Surat Peringatan", 'value': "surat_peringatan"}
          ];
    listStatusPengajuan.refresh();
    print(listStatusPengajuan);
  }

  String getBranchIdByName(String branchName) {
    Map<String, String> branchMapping = {
      'Semua Cabang': '',
      'PT. SHAN INFORMASI SISTEM': '1',
      'PT. REFORMASI ANUGERAH JAVA JAYA': '2',
    };

    return branchMapping[branchName] ?? '';
  }

  var selectedBranch = 'Semua Cabang'.obs;

  ScrollController scrollController = ScrollController();

  // @override
  // void onInit() {
  //   super.onInit();
  //   fetchAuditData();
  //   scrollController.addListener(() {
  //     if (scrollController.position.pixels >=
  //             scrollController.position.maxScrollExtent &&
  //         !isLoadingMore.value) {
  //       loadMoreData();
  //     }
  //   });
  // }

  Future<void> searchSuratPeringatan(em_id) async {
    searchSp.value.clear();
    Map<String, dynamic> body = {
      'em_id': em_id,
    };

    var connect = Api.connectionApi("post", body, 'surat_peringatan_search');
    await connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        for (var element in valueBody['data']) {
          var data = {
            'nomor': element['nomor'],
            'nama': element['nama'],
            'exp': element['exp_date'],
            'status': element['status']
          };
          searchSp.value.add(data);
        }
        updateListStatus();
      } else {
        UtilsAlert.showToast('yah error');
      }
    });
  }

  Future<void> searchTeguranLisan(em_id) async {
    searchTl.value.clear();
    Map<String, dynamic> body = {
      'em_id': em_id,
    };

    var connect = Api.connectionApi("post", body, 'teguran_lisan_search');
    await connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        print('ini tl $valueBody');
        for (var element in valueBody['data']) {
          var data = {
            'nomor': element['nomor'],
            'nama': element['nama'],
            'exp': element['exp_date'],
            'status': element['status']
          };
          searchTl.value.add(data);
        }
        print(valueBody);
        updateListStatus();
      } else {
        UtilsAlert.showToast('yah error');
      }
    });
  }

  void fetchAuditData({bool isLoadMore = false, bool allData = false}) {
    if (!isLoadMore) {
      // listEmployee.clear();
      auditList.clear();
      offset.value = 0; // Reset offset jika bukan load more
    }
    isLoadingMore.value = true;
    Map<String, dynamic> body = {
      'tahun': tahunSelectedSearchHistory.value,
      'bulan': bulanSelectedSearchHistory.value,
      'em_id': emId.value,
      'offset': offset.value,
      'limit': 5,
      'status': filterStatus.value,
      'status_audit': filterStatusAudit.value,
      'tipe_form': filterTipeForm.value,
      'all_data': allData,
      'branch_id': getBranchIdByName(selectedBranch.value)
    };
    var connect = Api.connectionApi("post", body, "audit");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        if (valueBody['data'] != null && valueBody['data'].isNotEmpty) {
          auditList.addAll(valueBody['data']);
          offset.value += 5;
        }
        print('ini audit list: $auditList');
        if (allData == true) {
          Get.back();
          generateAndOpenPdf();
        }
        isLoadingMore.value = false;
      } else {
        UtilsAlert.showToast(res.message);
      }
    });
  }

  void logAudit() {
    Map<String, dynamic> body = {
      'tahun': tahunSelectedSearchHistory.value,
      'bulan': bulanSelectedSearchHistory.value,
      'id_trx': idTrx.value
    };
    var connect = Api.connectionApi("post", body, "audit/log");
    connect.then((dynamic res) {
      statusLog.clear();
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        if (valueBody['data'] != null && valueBody['data'].isNotEmpty) {
          statusLog.add(valueBody['data']);
        }
      } else {
        UtilsAlert.showToast(res.message);
      }
    });
  }

  Future<void> getTimeNow() async {
    var dt = DateTime.parse(AppData.endPeriode);
    bulanSelectedSearchHistory.value = "${dt.month}";
    tahunSelectedSearchHistory.value = "${dt.year}";
    bulanDanTahunNow.value = "${dt.month}-${dt.year}";
    // tanggal.value = '${dt.year}-${dt.month}-${dt.hour}';
  }

  void getFilterEmployee() {
    listEmployee.clear();
    var dataUser = AppData.informasiUser;
    var getEmpid = dataUser![0].em_id;
    Map<String, dynamic> body = {
      'em_id': getEmpid,
    };
    var connect = Api.connectionApi("post", body, "audit/filter/employee");
    connect.then((dynamic res) {
      var valueBody = jsonDecode(res.body);
      // print('ini load employee $valueBody');
      listEmployee.add({'em_id': '', 'full_name': 'Semua Karyawan'});
      listEmployee.addAll(valueBody['data']);
      print('ini load employee $listEmployee');
      tempNamaStatus1.value = listEmployee[0]['full_name'];
      emId.value = listEmployee[0]['em_id'];
    });
  }

  void showDetailRiwayat(detailData) {
    var nomorAjuan = detailData['nomor'];
    var tanggalMasukAjuan = detailData['atten_date'];
    var categoryAjuan = detailData['tipe_pengajuan'];
    var namaPengaju = detailData['full_name'];
    var jabatanPengaju = detailData['jabatan'];
    var alasan = detailData['keterangan'];
    var typeAjuan = detailData['status'];
    var leave_files = detailData['leave_files'];
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Center(
                  child: Container(
                      height: 6,
                      width: 34,
                      decoration: BoxDecoration(
                          color: Constanst.colorNeutralBgTertiary,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20.0),
                          ))),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Constanst.colorNonAktif)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                nomorAjuan,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                Constanst.convertDate6("$tanggalMasukAjuan"),
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
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Constanst.colorNonAktif)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nama pengaju",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Constanst.fgSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "$namaPengaju - $jabatanPengaju",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Constanst.fgPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Divider(
                          height: 0,
                          thickness: 1,
                          color: Constanst.border,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Nama Pengajuan",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Constanst.fgSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "$categoryAjuan",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Constanst.fgPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Divider(
                          height: 0,
                          thickness: 1,
                          color: Constanst.border,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Catatan",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Constanst.fgSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "$alasan",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Constanst.fgPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        leave_files == "" ||
                                leave_files == "NULL" ||
                                leave_files == null
                            ? const SizedBox()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Divider(
                                    height: 0,
                                    thickness: 1,
                                    color: Constanst.border,
                                  ),
                                  const SizedBox(height: 12),
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
                                        // viewLampiranAjuan(leave_files);
                                      },
                                      child: Text(
                                        "$leave_files",
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Constanst.infoLight,
                                        ),
                                      )),
                                  const SizedBox(height: 12),
                                ],
                              ),
                        Divider(
                          height: 0,
                          thickness: 1,
                          color: Constanst.border,
                        ),
                        const SizedBox(height: 12),
                        typeAjuan == 'Rejected'
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Iconsax.close_circle,
                                    color: Constanst.color4,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Rejected",
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w500,
                                                color: Constanst.fgPrimary,
                                                fontSize: 14)),
                                        const SizedBox(height: 6),
                                        Text(
                                          '',
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w400,
                                              color: Constanst.fgSecondary,
                                              fontSize: 14),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : typeAjuan == "Approve" ||
                                    typeAjuan == "Approve1" ||
                                    typeAjuan == "Approve2"
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Iconsax.tick_circle,
                                        color: Colors.green,
                                        size: 22,
                                      ),
                                      const SizedBox(width: 8),
                                      Text("Approved",
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              color: Constanst.fgPrimary,
                                              fontSize: 14)),
                                    ],
                                  )
                                : Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Iconsax.timer,
                                        color: Constanst.color3,
                                        size: 22,
                                      ),
                                      const SizedBox(width: 8),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Pending Approval",
                                              style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w500,
                                                  color: Constanst.fgPrimary,
                                                  fontSize: 14)),
                                          const SizedBox(height: 4),
                                        ],
                                      ),
                                    ],
                                  ),
                        Obx(() {
                          return statusLog.isEmpty
                              ? const SizedBox()
                              : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 12),
                                    Divider(
                                      height: 0,
                                      thickness: 1,
                                      color: Constanst.border,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      "Riwayat Audit",
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: Constanst.fgSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: statusLog[0].length,
                                        itemBuilder: (context, index) {
                                          var log = statusLog[0][index];
                                          print('ini log $log');
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 12.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  log['status'] == 'Rejected'
                                                      ? Iconsax.close_circle
                                                      : log['status']
                                                              .toString()
                                                              .contains(
                                                                  "Approve")
                                                          ? Iconsax.tick_circle
                                                          : Iconsax.timer,
                                                  color: log['status'] ==
                                                          'Rejected'
                                                      ? Constanst.color4
                                                      : log['status']
                                                              .toString()
                                                              .contains(
                                                                  "Approve")
                                                          ? Colors.green
                                                          : Constanst.color3,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "${log['status']} oleh ${log['full_name']}",
                                                        style:
                                                            GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Constanst
                                                              .fgPrimary,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        Constanst.convertDateAndClock(log['created_on'])
                                                        ,
                                                        style:
                                                            GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Constanst
                                                              .fgSecondary,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                  ],
                                );
                        }),
                        //   statusLog.isEmpty
                        //       ? const SizedBox()
                        //       : const SizedBox(height: 12),
                        //   statusLog.isEmpty
                        //       ? const SizedBox()
                        //       : Divider(
                        //           height: 0,
                        //           thickness: 1,
                        //           color: Constanst.border,
                        //         ),
                        //   statusLog.isEmpty
                        //       ? const SizedBox()
                        //       : const SizedBox(height: 12),
                        //   statusLog.isEmpty
                        //       ? const SizedBox()
                        //       : Text(
                        //           "Riwayat Audit",
                        //           style: GoogleFonts.inter(
                        //             fontWeight: FontWeight.w400,
                        //             fontSize: 14,
                        //             color: Constanst.fgSecondary,
                        //           ),
                        //         ),
                        //   statusLog.isEmpty
                        //       ? const SizedBox()
                        //       : const SizedBox(height: 12),
                        //   statusLog.isEmpty
                        //       ? const SizedBox()
                        //       : ListView.builder(
                        //           itemCount: statusLog.length,
                        //           itemBuilder: (context, index) {
                        //             var log = statusLog[index];
                        //             return Padding(
                        //               padding:
                        //                   const EdgeInsets.only(bottom: 12.0),
                        //               child: Row(
                        //                 crossAxisAlignment:
                        //                     CrossAxisAlignment.start,
                        //                 children: [
                        //                   Icon(
                        //                     log['status'] == 'Rejected'
                        //                         ? Iconsax.close_circle
                        //                         : log['status']
                        //                                 .toString()
                        //                                 .contains("Approve")
                        //                             ? Iconsax.tick_circle
                        //                             : Iconsax.timer,
                        //                     color: log['status'] == 'Rejected'
                        //                         ? Constanst.color4
                        //                         : log['status']
                        //                                 .toString()
                        //                                 .contains("Approve")
                        //                             ? Colors.green
                        //                             : Constanst.color3,
                        //                     size: 20,
                        //                   ),
                        //                   const SizedBox(width: 8),
                        //                   Expanded(
                        //                     child: Column(
                        //                       crossAxisAlignment:
                        //                           CrossAxisAlignment.start,
                        //                       children: [
                        //                         Text(
                        //                           "${log['status']} oleh ${log['by']}",
                        //                           style: GoogleFonts.inter(
                        //                             fontWeight: FontWeight.w500,
                        //                             color: Constanst.fgPrimary,
                        //                             fontSize: 14,
                        //                           ),
                        //                         ),
                        //                         const SizedBox(height: 4),
                        //                         Text(
                        //                           log['date'],
                        //                           style: GoogleFonts.inter(
                        //                             fontWeight: FontWeight.w400,
                        //                             color: Constanst.fgSecondary,
                        //                             fontSize: 12,
                        //                           ),
                        //                         ),
                        //                       ],
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //             );
                        //           }),
                      ],
                    ),
                  ),
                ),
                typeAjuan == 'Approve2' && detailData['status_audit'] == ''
                    ? Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 16.0, top: 16.0),
                              child: Container(
                                height: 40,
                                width: double.infinity,
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
                                    statusCondition.value = 'Approve';
                                    Get.back();
                                    showGeneralDialog(
                                      barrierDismissible: false,
                                      context: Get.context!,
                                      barrierColor:
                                          Colors.black54, // space around dialog
                                      transitionDuration:
                                          Duration(milliseconds: 200),
                                      transitionBuilder:
                                          (context, a1, a2, child) {
                                        return ScaleTransition(
                                          scale: CurvedAnimation(
                                              parent: a1,
                                              curve: Curves.elasticOut,
                                              reverseCurve:
                                                  Curves.easeOutCubic),
                                          child: CustomDialog(
                                            // our custom dialog
                                            title: "Peringatan",
                                            content:
                                                "Apakah Anda yakin ingin Meng-Approve Pengajuan ini? ",
                                            positiveBtnText: "Approve",
                                            negativeBtnText: "Kembali",
                                            style: 1,
                                            buttonStatus: 1,
                                            positiveBtnPressed: () {
                                              Get.back();
                                              approvAudit(detailData);
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
                                  },
                                  style: ElevatedButton.styleFrom(
                                      foregroundColor: Constanst.color4,
                                      backgroundColor: Constanst.colorWhite,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      elevation: 0,
                                      // padding: EdgeInsets.zero,
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 0, 0)),
                                  child: Text(
                                    'Approve',
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                        color: Constanst.color5,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 16.0, top: 16.0),
                              child: Container(
                                height: 40,
                                width: double.infinity,
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
                                    statusCondition.value = 'Reject';
                                    Get.back();
                                    statusPemgajuanIzin.value = 'none';
                                      selectedUsersEm_id.clear();
                                      selectedUsersName.clear();
                                      selectedUsersData.clear();
                                      konsekuemsiList.clear();
                                      searchSuratPeringatan('');
                                      searchTeguranLisan('');
                                    showBottomApproval(detailData);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      foregroundColor: Constanst.color4,
                                      backgroundColor: Constanst.colorWhite,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      elevation: 0,
                                      // padding: EdgeInsets.zero,
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 0, 0)),
                                  child: Text(
                                    'Reject',
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                        color: Constanst.color4,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : detailData['status_audit'] == 'Rejected'
                        ? Padding(
                            padding:
                                const EdgeInsets.only(bottom: 16.0, top: 16.0),
                            child: Container(
                              height: 40,
                              width: double.infinity,
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
                                  statusCondition.value = 'Approve';
                                  Get.back();
                                  showGeneralDialog(
                                    barrierDismissible: false,
                                    context: Get.context!,
                                    barrierColor:
                                        Colors.black54, // space around dialog
                                    transitionDuration:
                                        Duration(milliseconds: 200),
                                    transitionBuilder:
                                        (context, a1, a2, child) {
                                      return ScaleTransition(
                                        scale: CurvedAnimation(
                                            parent: a1,
                                            curve: Curves.elasticOut,
                                            reverseCurve: Curves.easeOutCubic),
                                        child: CustomDialog(
                                          // our custom dialog
                                          title: "Peringatan",
                                          content:
                                              "Apakah Anda yakin ingin membatalkan penolakan? "
                                              "Surat Peringatan atau Teguran Lisan yang sudah diterbitkan "
                                              "akan ditarik kembali.",
                                          positiveBtnText: "Batalkan",
                                          negativeBtnText: "Kembali",
                                          style: 1,
                                          buttonStatus: 1,
                                          positiveBtnPressed: () {
                                            approvAudit(detailData);
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
                                  'Approve',
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      color: Constanst.color5,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                          )
                        : detailData['status_audit'] == 'Approve'
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 16.0, top: 16.0),
                                child: Container(
                                  height: 40,
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                                      statusCondition.value = 'Reject';
                                      Get.back();
                                      statusPemgajuanIzin.value = 'none';
                                      selectedUsersEm_id.clear();
                                      selectedUsersName.clear();
                                      selectedUsersData.clear();
                                      konsekuemsiList.clear();
                                      searchSuratPeringatan('');
                                      searchTeguranLisan('');
                                      showBottomApproval(detailData);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        foregroundColor: Constanst.color4,
                                        backgroundColor: Constanst.colorWhite,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        elevation: 0,
                                        // padding: EdgeInsets.zero,
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 0)),
                                    child: Text(
                                      'Reject',
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          color: Constanst.color4,
                                          fontSize: 14),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox()
              ],
            ),
          ),
        );
      },
    );
  }

  void showBottomApproval(detailData) {
    for (var user in availableUsers) {
      final fullName =
          (user['full_name'] != null) ? user['full_name'].toString() : 'N/A';
      print('Full name: $fullName');
    }
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
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
                                  "Menyetujui",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Obx(() {
                            var sp = searchSp;
                            return statusPemgajuanIzin.value == 'none'
                                ? SizedBox()
                                : searchSp.isNotEmpty
                                    ? Container(
                                        decoration: BoxDecoration(
                                          color: Constanst.infoLight1,
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                                                sp[0]['status'] == 'Approve'
                                                    ? "Karyawan ${sp[0]['nama']} mempunyai surat peringatan yang sedang aktif dengan nomor ${sp[0]['nomor']} berakhir pada tanggal ${sp[0]['exp']}"
                                                    : 'Karyawan ${sp[0]['nama']} mempunyai surat peringatan dengan nomor ${sp[0]['nomor']}, status: ${sp[0]['status']}',
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        Constanst.fgSecondary,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : SizedBox();
                          }),
                          SizedBox(height: 12),
                          Obx(() {
                            var tl = searchTl;
                            return statusPemgajuanIzin.value == 'none'
                                ? SizedBox()
                                : searchTl.isNotEmpty
                                    ? Container(
                                        decoration: BoxDecoration(
                                          color: Constanst.infoLight1,
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                                                tl[0]['status'] == 'Approve'
                                                    ? "Karyawan ${tl[0]['nama']} mempunyai teguran lisan yang sedang aktif dengan nomor ${tl[0]['nomor']} berakhir pada tanggal ${tl[0]['exp']}"
                                                    : 'Karyawan ${tl[0]['nama']} mempunyai teguran lisan dengan nomor ${tl[0]['nomor']}, status: ${tl[0]['status']}',
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        Constanst.fgSecondary,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : SizedBox();
                          }),
                          const SizedBox(height: 12),
                          Obx(() {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: List.generate(
                                  listStatusPengajuan.length, (index) {
                                var data = listStatusPengajuan[index];
                                return statusPemgajuanIzin.value ==
                                        data['value']
                                    ? Padding(
                                        padding: EdgeInsets.only(top: 12),
                                        child: InkWell(
                                          onTap: () {
                                            statusPemgajuanIzin.value =
                                                data['value'].toString();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Constanst.infoLight1,
                                              border: Border.all(
                                                  width: 1,
                                                  color: Constanst.infoLight),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 30,
                                                child: Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 5,
                                                        left: 5,
                                                        bottom: 5),
                                                    child: Row(
                                                      children: [
                                                        TextLabell(
                                                          text: data['name'],
                                                        ),
                                                      ],
                                                    ))),
                                          ),
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          statusPemgajuanIzin.value =
                                              data['value'].toString();
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 12),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: Constanst.secondary),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 30,
                                                child: Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 5,
                                                        left: 5,
                                                        bottom: 5),
                                                    child: Row(
                                                      children: [
                                                        TextLabell(
                                                          text: data['name'],
                                                        ),
                                                      ],
                                                    ))),
                                          ),
                                        ),
                                      );
                              }),
                            );
                          }),
                          const SizedBox(
                            height: 16,
                          ),
                          Obx(() {
                            return statusPemgajuanIzin.value == 'none'
                                ? SizedBox()
                                : Column(
                                    children: [
                                      Text(
                                        'Berikan Surat Peringatan Kepada : ',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 11),
                                      ),
                                      // Buatlah tampilkan untuk memilih user yang akan di berikan surat bisa multiple dan jumlah total ada 3
                                      Obx(() {
                                        if (availableUsers.isEmpty) {
                                          return CircularProgressIndicator(); // atau SizedBox.shrink();
                                        }
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            DropdownSearch<
                                                Map<String,
                                                    dynamic>>.multiSelection(
                                              items: availableUsers
                                                  .cast<Map<String, dynamic>>()
                                                  .where((user) =>
                                                      !selectedUsersData.any(
                                                          (sel) =>
                                                              sel['em_id'] ==
                                                              user['em_id']))
                                                  .toList(),
                                              selectedItems:
                                                  selectedUsersData.toList(),
                                              itemAsString: (item) =>
                                                  item?['full_name'] ?? '',
                                              compareFn: (item, selectedItem) =>
                                                  item['em_id'] ==
                                                  selectedItem['em_id'],
                                              popupProps:
                                                  PopupPropsMultiSelection
                                                      .dialog(
                                                showSelectedItems: true,
                                              ),
                                              dropdownDecoratorProps:
                                                  DropDownDecoratorProps(
                                                baseStyle: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 11),
                                                dropdownSearchDecoration:
                                                    InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        labelText:
                                                            "Pilih Pengguna",
                                                        labelStyle: TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            fontSize: 11)),
                                              ),
                                              onChanged:
                                                  (List<Map<String, dynamic>>
                                                      selected) {
                                                selectedUsersData.value =
                                                    selected;
                                                selectedUsersName.value =
                                                    selected
                                                        .map((e) =>
                                                            e['full_name']
                                                                ?.toString() ??
                                                            '')
                                                        .toList();
                                                selectedUsersEm_id.value =
                                                    selected
                                                        .map((e) =>
                                                            e['em_id']
                                                                ?.toString() ??
                                                            '')
                                                        .toList();
                                                searchSuratPeringatan(
                                                    selectedUsersEm_id);
                                                searchTeguranLisan(
                                                    selectedUsersEm_id);
                                              },
                                            ),
                                          ],
                                        );
                                      }),
                                      SizedBox(height: 4.0),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                Constanst.borderStyle1,
                                            border: Border.all(
                                                width: 1.0,
                                                color: const Color.fromARGB(
                                                    255, 211, 205, 205))),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left: 8,
                                          ),
                                          child: TextField(
                                            cursorColor: Colors.black,
                                            controller: alasanReject.value,
                                            maxLines: null,
                                            maxLength: 225,
                                            autofocus: true,
                                            decoration: new InputDecoration(
                                                border: InputBorder.none,
                                                hintText:
                                                    "Pelanggaran yang di lakukan"),
                                            keyboardType:
                                                TextInputType.multiline,
                                            textInputAction:
                                                TextInputAction.done,
                                            style: const TextStyle(
                                                fontSize: 12.0,
                                                height: 2.0,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      TextLabell(
                                        text: "Konsekuensi",
                                        size: 12,
                                        weight: FontWeight.bold,
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Obx(() {
                                        return konsekuemsiList.length == 0
                                            ? Text(
                                                'Buat konsekuensi dengan klik tombol dibawah',
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 11),
                                              )
                                            : Column(
                                                children: List.generate(
                                                    konsekuemsiList.length,
                                                    (index) {
                                                  var data =
                                                      konsekuemsiList[index];
                                                  return Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 90,
                                                          child: TextFormField(
                                                            onChanged: (value) {
                                                              data['konsekuensi'] =
                                                                  value;
                                                            },
                                                            controller:
                                                                TextEditingController(
                                                                    text: data[
                                                                        'konsekuensi']),
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12.0,
                                                                    height: 2.0,
                                                                    color: Colors
                                                                        .black),
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  'Masukan konsekuensi', // Menambahkan teks petunjuk saat field kosong
                                                              border:
                                                                  OutlineInputBorder(), // Menambahkan border di sekitar text field
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Constanst
                                                                        .Secondary), // Warna border saat aktif
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Constanst
                                                                        .Secondary), // Warna border saat field difokuskan
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                            flex: 10,
                                                            child: InkWell(
                                                                onTap: () {
                                                                  konsekuemsiList
                                                                      .removeAt(
                                                                          index);
                                                                  konsekuemsiList
                                                                      .refresh();
                                                                },
                                                                child: Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .red,
                                                                )))
                                                      ],
                                                    ),
                                                  );
                                                }),
                                              );
                                      }),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          konsekuemsiList
                                              .add({"konsekuensi": ""});
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              top: 8, bottom: 8),
                                          decoration: BoxDecoration(
                                              color: Constanst.onPrimary,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                  width: 1,
                                                  color: Constanst.onPrimary)),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add,
                                                color: Colors.white,
                                              ),
                                              TextLabell(
                                                text: "Konsekuensi",
                                                color: Constanst.colorWhite,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                    ],
                                  );
                          }),
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
                                    print(
                                        'ini selected user $selectedUsersData');
                                    bool data = konsekuemsiList.any(
                                        (konsekuensi) =>
                                            konsekuensi['konsekuensi']
                                                .trim()
                                                .isEmpty);
                                    if (statusPemgajuanIzin.value != 'none') {
                                      if (alasanReject.value.text != "") {
                                        if (data) {
                                          UtilsAlert.showToast(
                                              "Harap hapus terlebih dahulu konsekuensi yang kosong");
                                          return;
                                        } else {
                                          Navigator.pop(Get.context!);
                                          approvAudit(detailData);
                                          print(konsekuemsiList);
                                        }
                                      } else {
                                        UtilsAlert.showToast(
                                            "Harap isi alasan terlebih dahulu");
                                      }
                                    } else {
                                      Navigator.pop(Get.context!);
                                      print(konsekuemsiList);
                                      approvAudit(detailData);
                                      // validasiMenyetujui(true, em_id);
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
                    const SizedBox(
                      height: 30,
                    )
                  ],
                ),
              );
            });
      },
    );
  }

  void approvAudit(detailData) {
    Map<String, dynamic> body = {
      'em_id_surat': selectedUsersEm_id,
      'full_name_surat': selectedUsersName,
      'konsekuensi': statusPemgajuanIzin.value,
      'list_konsekuensi': konsekuemsiList,
      'alasan': alasanReject.value.text,
      'status': detailData['status_audit'] == 'Approve' ||
              statusCondition.value == 'Reject'
          ? 'Rejected'
          : '',
      'tipe_form': detailData['tipe_pengajuan'],
      'full_name': AppData.informasiUser![0].full_name
    };
    var connect =
        Api.connectionApi("post", body, "audit/${detailData['id']}/approval");
    connect.then((dynamic res) {
      var valueBody = jsonDecode(res.body);
      if (res.statusCode == 200) {
        // Get.back();
        statusPemgajuanIzin.value = 'none';
        selectedUsersEm_id.clear();
        selectedUsersName.clear();
        selectedUsersData.clear();
        alasanReject.value.clear();
        konsekuemsiList.clear();
        if (detailData['status_audit'] == 'Rejected') {
          Get.back();
          tempfilterStatusAudit.value = 'Approve';
          filterStatusAudit.value = 'Approve';
          fetchAuditData(isLoadMore: false);
        } else if (detailData['status_audit'] == 'Approve') {
          tempfilterStatusAudit.value = 'Reject';
          filterStatusAudit.value = 'Reject';
          fetchAuditData(isLoadMore: false);
        } else {
          if (statusCondition.value == 'Approve') {
            tempfilterStatusAudit.value = 'Approve';
            filterStatusAudit.value = 'Approve';
            fetchAuditData(isLoadMore: false);
          } else {
            tempfilterStatusAudit.value = 'Reject';
            filterStatusAudit.value = 'Reject';
            fetchAuditData(isLoadMore: false);
          }
        }
        statusPemgajuanIzin.value = 'none';
        UtilsAlert.showToast(valueBody['message']);
      } else {
        UtilsAlert.showToast(valueBody['message']);
      }
    });
  }

  void getDetailAudit(id, tipeForm) {
    detailAudit.clear();
    var dataUser = AppData.informasiUser;
    var getEmpid = dataUser![0].em_id;

    var connect = Api.connectionApi(
      "get",
      {},
      "audit/$id",
      params: '&tipe_form=${tipeForm}&id=${id}',
    );
    connect.then((dynamic res) {
      var valueBody = jsonDecode(res.body);
      print(valueBody);
      detailAudit.add(valueBody['data']);
      print('ini load employee $detailAudit');
      showDetailRiwayat(detailAudit[0]);
    });
  }

  // Example method to remove an audit entry
  void loadMoreData() {
    fetchAuditData(isLoadMore: true);
  }

  Future<void> generateAndOpenPdf() async {
    final pdf = pw.Document();
    final pdfColor = Colors.red;
    final int colorInt = pdfColor.value;
    final imageData = await rootBundle.load('assets/icon.png');
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            // Header
            pw.Center(
              child: pw.Column(
                children: [
                  pw.SizedBox(height: 30),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.SizedBox(
                        width: 70,
                        child: pw.Image(
                          pw.MemoryImage(imageData.buffer.asUint8List()),
                          width: 70,
                        ),
                      ),
                      pw.SizedBox(width: 25),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'PT . SHAN INFORMASI SISTEM',
                            style: pw.TextStyle(
                              fontSize: 24,
                              color: PdfColor.fromInt(colorInt),
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.SizedBox(height: 8),
                          pw.Text(
                            'BEST SOLUTION FOR BUSINESS CONTROL',
                            style: pw.TextStyle(
                              fontSize: 11.5,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 12),
                  pw.Divider(thickness: 1),
                ],
              ),
            ),

            pw.SizedBox(height: 20),

            // Title
            pw.Center(
              child: pw.Text(
                'AUDIT REPORT',
                style:
                    pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
            ),

            pw.SizedBox(height: 20),

            _buildInfoRow("Filter Cabang", selectedBranch.value),
            _buildInfoRow("Filter Karyawan", tempNamaStatus1.value),
            _buildInfoRow("Filter Tipe Form", tempFilterTipeForm.value),
            _buildInfoRow("Filter Status Pengajuan", tempFilterStatus.value),
            _buildInfoRow("Filter Status Audit", tempfilterStatusAudit.value),
            _buildInfoRow("FIlter Periode",
                Constanst.convertDateBulanDanTahun(bulanDanTahunNow.value)),

            pw.SizedBox(height: 20),

            // Tabel Task
            _buildTaskTable(auditList.cast<Map<String, dynamic>>()),
          ];
        },
      ),
    );

    // Simpan PDF
    final outputDir = await getTemporaryDirectory();
    final filePath = '${outputDir.path}/audit_report.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    // Buka PDF
    final result = await OpenFile.open(filePath);
    if (result.type != ResultType.done) {
      // Get.snackbar('Error', 'Failed to open PDF', snackPosition: SnackPosition.BOTTOM);
    }
  }

  pw.Widget _buildInfoRow(String title, String value) {
    return pw.Container(
      padding: pw.EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            flex: 24,
            child: pw.Text(title,
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold, fontSize: 10.0)),
          ),
          pw.Text(":"),
          pw.SizedBox(width: 4),
          pw.Expanded(
            flex: 68,
            child: pw.Text(value,
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.normal, fontSize: 10.0)),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildTaskTable(List<Map<String, dynamic>> auditList) {
    final headers = [
      "No",
      "Kode",
      "Nama Pengajuan",
      "Tipe",
      "Tgl Form",
      "Durasi Form",
      "Approve 1",
      "Approve 2",
      "Status Audit",
      "Konsesuensi",
      "Penerima Konsekuensi",
      "Pelanggaran Yang Dilakukan"
    ];

    final Map<String, int> tanggalRowSpan = {};
    final List<List> data = auditList.map((item) {
      String parseApprover(String? approverJson) {
        if (approverJson == null || approverJson.isEmpty) return '';
        try {
          final decoded = json.decode(approverJson);
          return decoded['full_name'] ?? '';
        } catch (e) {
          return '';
        }
      }

      return [
        (auditList.indexOf(item) + 1).toString(),
        item['nomor'] ?? '',
        item['full_name'] ?? '',
        item['tipe_pengajuan'] ?? '',
        item['atten_date'] ?? '',
        item['durasi_form'] ?? '',
        parseApprover(item['approve1']),
        parseApprover(item['approve2']),
        item['status_audit'] ?? '',
        item['konsekuensi'] ?? '',
        item['penerima_konsekuensi'] ?? '',
        item['pelanggaran'] ?? '',
      ];
    }).toList();

    return pw.Table(
      border: pw.TableBorder.all(width: 1),
      columnWidths: {
        0: pw.FixedColumnWidth(50), // No
        1: pw.FixedColumnWidth(95), // Kode
        2: pw.FixedColumnWidth(80), // Nama Pengaju
        3: pw.FixedColumnWidth(80), // Tipe
        4: pw.FixedColumnWidth(80), // Tgl Form
        5: pw.FixedColumnWidth(80), // Durasi Form
        6: pw.FixedColumnWidth(80), // Approve 1
        7: pw.FixedColumnWidth(80), // Approve 2
        8: pw.FixedColumnWidth(80), // Status Audit
        9: pw.FixedColumnWidth(80), // Konsekuensi
        10: pw.FixedColumnWidth(80), // Penerima Konsekuensi
        11: pw.FixedColumnWidth(80), // Pelanggaran yang dilakukan
      },
      children: [
        // Header Tabel
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.grey300),
          children: headers.map((header) {
            return pw.Padding(
              padding: pw.EdgeInsets.all(8),
              child: pw.Text(
                header,
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 4.0),
                textAlign: pw.TextAlign.center,
              ),
            );
          }).toList(),
        ),

        ..._buildMergedTableRows(data, tanggalRowSpan),
      ],
    );
  }

  List<pw.TableRow> _buildMergedTableRows(
      List<List<dynamic>> data, Map<String, int> tanggalRowSpan) {
    List<pw.TableRow> rows = [];

    for (var row in data) {
      // String currentDate = row[1];

      rows.add(
        pw.TableRow(
          verticalAlignment: pw.TableCellVerticalAlignment.middle,
          children: [
            for (int i = 0; i < row.length; i++)
              pw.Padding(
                padding: pw.EdgeInsets.all(6),
                child: pw.Text(
                  row[i],
                  textAlign:
                      (i == 3) ? pw.TextAlign.justify : pw.TextAlign.center,
                  style: pw.TextStyle(fontSize: 4.0),
                ),
              ),
          ],
        ),
      );
    }

    return rows;
  }
}
