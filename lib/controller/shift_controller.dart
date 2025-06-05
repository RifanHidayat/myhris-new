import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/global_controller.dart';
import 'package:siscom_operasional/screen/absen/form/berhasil_pengajuan.dart';
import 'package:siscom_operasional/screen/shift/form_pengajuan_shift.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';

class ShiftController extends GetxController {
  final globalCt = Get.find<GlobalController>();
  var statusFormPencarian = false.obs;
  var cari = TextEditingController().obs;
  var dariJam = TextEditingController().obs;
  var sampaiJam = TextEditingController().obs;
  var catatan = TextEditingController().obs;
  var statusJam = "".obs;
  var showButtonlaporan = true.obs;
  var statusFormPencarianBerhubungan = false.obs;
  var cariBerhubungan = TextEditingController().obs;
  var bulanSelectedSearchHistory = "".obs;
  var tahunSelectedSearchHistory = "".obs;
  var stringCari = ''.obs;
  var bulanDanTahunNow = "".obs;
  var idpengajuanShift = "".obs;
  var requestShiftDate = TextEditingController().obs;
  var replaceShiftDate = TextEditingController().obs;
  var loadingString = "Memuat Data...".obs;
  var listShift = [].obs;
  var valuePolaPersetujuan = "".obs;
  var listWorkSchedule = [].obs;
  var shiftShedule = ''.obs;
  var currentListWorkSchedule = [].obs;
  var currentshiftShedule = ''.obs;
  var swap = false.obs;
  var employeeListWorkSchedule = [].obs;
  var employeeShiftShedule = ''.obs;
  var emIdSwap = ''.obs;
  var statusForm = false.obs;
  var infoEmployeeAll = [].obs;
  var selectedEmployee = ''.obs;
  Rx<DateTime> initialDate = DateTime.now().obs;
  Rx<DateTime> reInitialDate = DateTime.now().obs;

  void getTimeNow() {
    var dt = DateTime.now();
    bulanSelectedSearchHistory.value = "${dt.month}";
    tahunSelectedSearchHistory.value = "${dt.year}";
    bulanDanTahunNow.value = "${dt.month}-${dt.year}";

    if (idpengajuanShift.value == "") {
      requestShiftDate.value.text =
          Constanst.convertDate("${initialDate.value}");
    }

    this.requestShiftDate.refresh();
    this.bulanSelectedSearchHistory.refresh();
    this.tahunSelectedSearchHistory.refresh();
    this.bulanDanTahunNow.refresh();
  }

  void showInputCari() {
    statusFormPencarian.value = !statusFormPencarian.value;
  }

  void showInputCariBerhubungan() {
    statusFormPencarianBerhubungan.value =
        !statusFormPencarianBerhubungan.value;
  }

  void getUserInfo() async {
    var dataUser = AppData.informasiUser;
    var getDepGroup = dataUser![0].dep_group;
    var full_name = dataUser[0].full_name;
    var emid = dataUser[0].em_id;
    Map<String, dynamic> body = {'dep_id': 0};
    var connect = Api.connectionApi(
      "post",
      body,
      "berhubungan-dengan",
    );
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        var data = valueBody['data'];
        infoEmployeeAll.clear();
        for (var element in data) {
          if (element['status'] == 'ACTIVE' &&
              element['em_id'] != AppData.informasiUser![0].em_id) {
            var fullName = element['full_name'] ?? "";
            infoEmployeeAll.value.add(element);
            print(fullName);
          }
        }
        if (idpengajuanShift.value == "") {
          List data = valueBody['data'];
          var listFirst = data
              .where((element) => element['full_name'] != full_name)
              .toList()
              .first;
          var fullName = listFirst['full_name'] ?? "";
          print(fullName);
          String namaUserPertama = "$fullName";
          selectedEmployee.value = namaUserPertama;
          emIdSwap.value = listFirst['em_id'];
        }
        this.infoEmployeeAll.refresh();
      }
    }).catchError((e) {
      print('error get employee $e');
    });
  }

  Future<void> getWorkSchedule() async {
    var connect = Api.connectionApi("get", {}, "shift/work_schedule");
    connect.then((dynamic res) {
      var valueBody = jsonDecode(res.body);
      print(valueBody);
      if (res.statusCode == 200) {
        listWorkSchedule.value = valueBody['data'];
        shiftShedule.value = valueBody['data'][0]['id'].toString();
        print('this is data work schedule');
        print(listWorkSchedule);
      } else {
        print('Vailed to load data work schedule');
      }
    });
  }

  Future<void> searchWorkSchedule(emId, attenDate, swap) async {
    if (swap == true) {
      employeeShiftShedule.value = '';
      employeeListWorkSchedule.clear();
      var body = {'em_id': emId, 'atten_date': attenDate};
      var connect =
          Api.connectionApi("post", body, "shift/search_work_schedule");
      connect.then((dynamic res) {
        var valueBody = jsonDecode(res.body);
        print(valueBody);
        if (res.statusCode == 200) {
          employeeListWorkSchedule.value = valueBody['data'];
          employeeShiftShedule.value = valueBody['data'][0]['id'].toString();
          print('this is data work schedule');
        } else {
          print('Vailed to load data work schedule');
        }
      });
    } else {
      currentshiftShedule.value = '';
      currentListWorkSchedule.clear();
      var body = {'em_id': emId, 'atten_date': attenDate};
      var connect =
          Api.connectionApi("post", body, "shift/search_work_schedule");
      connect.then((dynamic res) {
        var valueBody = jsonDecode(res.body);
        print(valueBody);
        if (res.statusCode == 200) {
          currentListWorkSchedule.value = valueBody['data'];
          currentshiftShedule.value = valueBody['data'][0]['id'].toString();
          print('this is data work schedule');
          print(listWorkSchedule);
        } else {
          print('Vailed to load data work schedule');
        }
      });
    }
  }

  
  void batalkanPengajuan(index) {
    UtilsAlert.loadingSimpanData(Get.context!, "Batalkan Pengajuan");
    var dataUser = AppData.informasiUser;
    Map<String, dynamic> body = {
      'id': index['id'],
      'status_transaksi': 0,
      'tgl_ajuan': '${index["tgl_ajuan"]}',
    };
    var connect = Api.connectionApi("post", body, "shift/edit");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        Navigator.pop(Get.context!);
        Navigator.pop(Get.context!);
        UtilsAlert.showToast("Berhasil batalkan pengajuan");
        onReady();
      }
    });
  }


  void showDetailShift(detailData, approve, alasanReject) {
    print('ini showDetailDataLembur $detailData');
    var nomorAjuan = detailData['nomor_ajuan'];
    var dariTanggal = detailData['dari_tgl'];
    var sampaiTanggal = detailData['sampai_tgl'];
    var nameDelegasi = detailData['name_delegasi'];
    var currentSchedule;
    var replaceSchedule;
    if (detailData['work_id_old'] == 0) {
      currentSchedule = 'Dayoff (00:00 - 00:00)';
    } else {
      currentSchedule =
          '${detailData['name_old']} (${Constanst.convertTime(detailData['time_in_old'])} - ${Constanst.convertTime(detailData['time_out_old'])})';
    }
    if (detailData['work_id_new'] == 0) {
      replaceSchedule = 'Dayoff (00:00 - 00:00)';
    } else {
      replaceSchedule =
          '${detailData['name_new']} (${Constanst.convertTime(detailData['time_in_new'])} - ${Constanst.convertTime(detailData['time_out_new'])})';
    }
    var tanggalAjuan = detailData['tgl_ajuan'];
    var namaTypeAjuan = 'Shift';
    var uraian = detailData['uraian'];
    var status;
    if (valuePolaPersetujuan.value == "1") {
      status = detailData['status'];
    } else {
      status = detailData['status'] == "Approve"
          ? "Approve 1"
          : detailData['status'] == "Approve2"
              ? "Approve 2"
              : detailData['status'];
    }
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      builder: (context) {
        return Container(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
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
                  headersDetail(tanggalAjuan, nomorAjuan),
                  const SizedBox(height: 16),
                  bodyDetail(
                      namaTypeAjuan,
                      dariTanggal,
                      sampaiTanggal,
                      uraian,
                      status,
                      approve,
                      alasanReject,
                      nomorAjuan,
                      currentSchedule,
                      replaceSchedule,
                      nameDelegasi),
                  status == "Approve" ||
                          status == "Approve 1" ||
                          status == "Approve 2"
                      ? Container()
                      : status == "Rejected"
                          ? Container()
                          : Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 40,
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      margin:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Constanst
                                              .border, // Set the desired border color
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Get.back();
                                          batalkanPengajuan(detailData);
                                        },
                                        style: ElevatedButton.styleFrom(
                                            foregroundColor: Constanst.color4,
                                            backgroundColor:
                                                Constanst.colorWhite,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            elevation: 0,
                                            // padding: EdgeInsets.zero,
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 0)),
                                        child: Text(
                                          'Batalkan',
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
                                          swap.value = detailData['name_delegasi'] == null ? false : true;
                                          Get.to(FormPengajuanShift(
                                            dataForm: [detailData, true, detailData['name_delegasi'] == null ? false : true],
                                          ));
                                        }, 
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Constanst.colorWhite,
                                          backgroundColor:
                                              Constanst.colorPrimary,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          elevation: 0,
                                          // padding: const EdgeInsets.fromLTRB(20, 12, 20, 12)
                                        ),
                                        child: Text(
                                          'Edit',
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              color: Constanst.colorWhite,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Container bodyDetail(
      String namaTypeAjuan,
      dariTanggal,
      sampaiTanggal,
      uraian,
      status,
      approve,
      alasanReject,
      nomorAjuan,
      currentSchedule,
      replaceSchedule,
      nameDelegasi) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Constanst.colorNonAktif)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tipe Shift",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Constanst.fgSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "$namaTypeAjuan",
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
            dateDetail(dariTanggal, 'Request Date'),
            const SizedBox(height: 12),
            Divider(
              height: 0,
              thickness: 1,
              color: Constanst.border,
            ),
            const SizedBox(height: 12),
            schedule(currentSchedule, 'Request Schedule'),
            const SizedBox(height: 12),
            Divider(
              height: 0,
              thickness: 1,
              color: Constanst.border,
            ),
            const SizedBox(height: 12),
            dateDetail(sampaiTanggal, 'Replace Date'),
            const SizedBox(height: 12),
            Divider(
              height: 0,
              thickness: 1,
              color: Constanst.border,
            ),
            const SizedBox(height: 12),
            nameDelegasi == null
                                  ? SizedBox()
                                  : schedule(nameDelegasi, 'Replace User'),
                              nameDelegasi == null
                                  ? SizedBox()
                                  : const SizedBox(height: 4),
                              nameDelegasi == null
                                  ? SizedBox()
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                          top: 12.0, bottom: 12.0),
                                      child: Divider(
                                        thickness: 1,
                                        height: 0,
                                        color: Constanst.border,
                                      ),
                                    ),
            schedule(replaceSchedule, 'Replace Schedule'),
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
              "$uraian",
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
            status == 'Rejected'
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Rejected by $approve",
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  color: Constanst.fgPrimary,
                                  fontSize: 14),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              alasanReject,
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
                : status == "Approve" ||
                        status == "Approve 1" ||
                        status == "Approve 2"
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Iconsax.tick_circle,
                            color: Colors.green,
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Text("Approved by $approve",
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  color: Constanst.fgPrimary,
                                  fontSize: 14)),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Iconsax.timer,
                            color: Constanst.color3,
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Pending Approval",
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      color: Constanst.fgPrimary,
                                      fontSize: 14)),
                              const SizedBox(height: 4),
                              InkWell(
                                  onTap: () {
                                    var dataEmployee = {
                                      'nameType': '$namaTypeAjuan',
                                      'nomor_ajuan': '$nomorAjuan',
                                    };
                                    globalCt.showDataPilihAtasan(dataEmployee);
                                  },
                                  child: Text("Konfirmasi via Whatsapp",
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w400,
                                          color: Constanst.infoLight,
                                          fontSize: 14))),
                            ],
                          ),
                        ],
                      ),
          ],
        ),
      ),
    );
  }

  Column schedule(currentSchedule, label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Constanst.fgSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$currentSchedule',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Constanst.fgPrimary,
          ),
        ),
      ],
    );
  }

  Column dateDetail(dariTanggal, label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Constanst.fgSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          Constanst.convertDate1(dariTanggal),
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Constanst.fgPrimary,
          ),
        ),
      ],
    );
  }

  Container headersDetail(tanggalAjuan, nomorAjuan) {
    return Container(
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
                    "Tanggal Pengajuan",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Constanst.fgSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Constanst.convertDate6(tanggalAjuan),
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Constanst.fgPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
          ],
        ),
      ),
    );
  }

  void loadDataShift() {
    listShift.clear();
    var connect = Api.connectionApi("get", {}, "shift");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        debugPrint("ini history shift ${jsonEncode(valueBody['data'])}",
            wrapWidth: 1000);
        if (valueBody['status'] == false) {
          loadingString.value = "Anda tidak memiliki\nRiwayat Pengajuan Shift";
          this.loadingString.refresh();
        } else {
          listShift.value = valueBody['data'];
          if (listShift.length == 0) {
            loadingString.value =
                "Anda tidak memiliki\nRiwayat Pengajuan Shift";
          } else {
            loadingString.value = "Memuat Data...";
          }

          this.listShift.refresh();
          this.loadingString.refresh();
        }
      }
    });
  }

  void kirimPengajuan(swap) {
    var tanggal_shift;
    var polaFormat = DateFormat('yyyy-MM-dd');
    var tanggal_ajuan;
    var replace_tanggal;
    try {
      tanggal_shift = requestShiftDate.value.text;
      replace_tanggal = replaceShiftDate.value.text;
      tanggal_ajuan = polaFormat.format(DateTime.now());
      print('Tanggal berhasil dikonversi: $tanggal_shift');
      print('Tanggal berhasil dikonversi: $tanggal_ajuan');
    } catch (e) {
      print('Error saat mengonversi tanggal: $e');
      tanggal_shift = polaFormat.format(DateTime.now());
      tanggal_ajuan = polaFormat.format(DateTime.now());
      replace_tanggal = polaFormat.format(DateTime.now());
    }
    var dataUser = AppData.informasiUser;
    var getEmid = dataUser![0].em_id;
    var getFullName = dataUser[0].full_name;
    var body = {
      'em_id': getEmid,
      'em_delegation': swap == true ? emIdSwap.value : '',
      'atten_date': tanggal_shift,
      'dari_tgl': tanggal_shift,
      'sampai_tgl': replace_tanggal,
      'tgl_ajuan': tanggal_ajuan,
      'status': 'PENDING',
      'work_id_old': currentshiftShedule.value,
      'work_id_new': employeeShiftShedule.value,
      'approve_date': '',
      'uraian': catatan.value.text,
      'ajuan': '4',
      'approve_status': "pending",
    };
    print(body);
    if (statusForm.value == false) {
      print("sampe sini input");
      var connect = Api.connectionApi("post", body, "shift");
      connect.then((dynamic res) {
        var valueBody = jsonDecode(res.body);
        if (res.statusCode == 200) {
          var stringWaktu = "${dariJam.value.text} sd ${sampaiJam.value.text}";
          Navigator.pop(Get.context!);
          var pesan1 = "Pengajuan Shift berhasil dibuat";
          var pesan2 =
              "Selanjutnya silahkan menunggu atasan kamu untuk menyetujui pengajuan yang telah dibuat atau langsung";
          var pesan3 = "konfirmasi via WhatsApp";
          var dataPengajuan = {
            'nameType': 'SHIFT',
          };
          // for (var item in globalCt.konfirmasiAtasan) {
          //   print(item['token_notif']);
          //   var pesan;
          //   if (item['em_gender'] == "PRIA") {
          //     pesan =
          //         "Hallo pak ${item['full_name']}, saya ${getFullName} mengajukan LEMBUR dengan nomor ajuan ${getNomorAjuanTerakhir}";
          //   } else {
          //     pesan =
          //         "Hallo bu ${item['full_name']}, saya ${getFullName} mengajukan LEMBUR dengan nomor ajuan ${getNomorAjuanTerakhir}";
          //   }
          // }

          Get.offAll(BerhasilPengajuan(
            dataBerhasil: [pesan1, pesan2, pesan3, dataPengajuan],
          ));
        } else {
          Get.back();
          print(valueBody['message']);
          UtilsAlert.showToast(valueBody['message'].toString());
        }
      });
    } else {
      print('ini id pengajuan lembur : ${idpengajuanShift.value}');
      body['id'] = idpengajuanShift.value;
      var connect = Api.connectionApi("post", body, "shift/edit");
      connect.then((dynamic res) {
        var valueBody = jsonDecode(res.body);
        if (res.statusCode == 200) {
          Navigator.pop(Get.context!);
          var pesan1 = "Pengajuan Shift berhasil di edit";
          var pesan2 =
              "Selanjutnya silahkan menunggu atasan kamu untuk menyetujui pengajuan yang telah dibuat atau langsung";
          var pesan3 = "konfirmasi via WhatsApp";
          var dataPengajuan = {
            'nameType': 'SHIFT',
          };
          Get.offAll(BerhasilPengajuan(
            dataBerhasil: [pesan1, pesan2, pesan3, dataPengajuan],
          ));
        } else {
          Get.back();
          print(body);
          print('error edit lembur ${res.statusCode} ${res.body}');
          UtilsAlert.showToast(valueBody['message']);
        }
      });
    }
  }
}
