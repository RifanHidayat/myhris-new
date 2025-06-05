import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/global_controller.dart';
import 'package:siscom_operasional/screen/absen/laporan/laporan_absen.dart';
import 'package:siscom_operasional/screen/absen/laporan/laporan_cuti.dart';
import 'package:siscom_operasional/screen/absen/laporan/laporan_dinas_luar.dart';
import 'package:siscom_operasional/screen/absen/laporan/laporan_izin.dart';
import 'package:siscom_operasional/screen/absen/laporan/laporan_klaim.dart';
import 'package:siscom_operasional/screen/absen/laporan/laporan_lembur.dart';
import 'package:siscom_operasional/screen/absen/laporan/laporan_shift.dart';
import 'package:siscom_operasional/screen/absen/laporan/laporan_tugas_luar.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/month_year_picker.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class LaporanCutiController extends GetxController {
  PageController? pageViewFilterWaktu;

  var departemen = TextEditingController().obs;
  var cari = TextEditingController().obs;

  // var limitPages = <LimitPageModel>[].obs;
  // var statusFormPencarian = false.obs;

  var loadingString = "Memuat Data...".obs;
  var idDepartemenTerpilih = "".obs;
  var namaDepartemenTerpilih = "".obs;
  var bulanSelectedSearchHistory = "".obs;
  var tahunSelectedSearchHistory = "".obs;
  var bulanDanTahunNow = "".obs;
  var title = "".obs;
  var valuePolaPersetujuan = "".obs;
  var filterStatusAjuanTerpilih = "Semua".obs;
  var filterBranch = ''.obs;
  var branchId = ''.obs;
  var branchList = [].obs;

  var showButtonlaporan = false.obs;
  var statusLoadingSubmitLaporan = false.obs;
  var statusCari = false.obs;
  var statusFilterWaktu = 0.obs;

  var jumlahData = 0.obs;
  var selectedType = 0.obs;
  var selectedViewFilterPengajuan = 0.obs;

  var tempKodeStatus1 = "".obs;
  var tempNamaStatus1 = "Semua".obs;
  var tempNamaLaporan1 = "Semua".obs;

  var listDetailLaporanEmployee = [].obs;
  var alllistDetailLaporanEmployee = [].obs;
  var dataTypeAjuan = [].obs;
  var departementAkses = [].obs;
  var allNameLaporanTidakhadir = [].obs;
  var allNameLaporanTidakhadirCopy = [].obs;

  Rx<DateTime> pilihTanggalFilterAjuan = DateTime.now().obs;

  var dataTypeAjuanDummy1 = ["Semua", "Approve", "Rejected", "Pending"];
  var dataTypeAjuanDummy2 = [
    "Semua",
    "Approve 1",
    "Approve 2",
    "Rejected",
    "Pending"
  ];

  RxBool isSearching = false.obs;

  // void toggleSearch() {
  //   isSearching.value = !isSearching.value;
  // }
  var controllerGlobal = Get.find<GlobalController>();

  @override
  void onReady() async {
    super.onReady();
    getTimeNow();
    getLoadsysData();
    getBranch();
    getDepartemen(1, "");
    filterStatusAjuanTerpilih.value = "Semua";
    selectedViewFilterPengajuan.value = 0;
    pilihTanggalFilterAjuan.value = DateTime.now();
  }

  void getTimeNow() {
    var dt = DateTime.parse(AppData.endPeriode);
    var outputFormat1 = DateFormat('MM');
    var outputFormat2 = DateFormat('yyyy');
    bulanSelectedSearchHistory.value = outputFormat1.format(dt);
    tahunSelectedSearchHistory.value = outputFormat2.format(dt);
    bulanDanTahunNow.value =
        "${bulanSelectedSearchHistory.value}-${tahunSelectedSearchHistory.value}";
  }

  // void toggleSearch() {
  //   statusCari.value = false;
  //   this.statusCari.refresh();
  // }

  void showInputCari() {
    statusCari.value = !statusCari.value;
  }

  void getDepartemen(status, tanggal) {
    jumlahData.value = 0;
    var connect = Api.connectionApi("get", {}, "all_department");
    connect.then((dynamic res) {
      if (res == false) {
        //UtilsAlert.koneksiBuruk();
      } else {
        if (res.statusCode == 200) {
          var valueBody = jsonDecode(res.body);
          var dataDepartemen = valueBody['data'];

          var dataUser = AppData.informasiUser;
          var hakAkses = dataUser![0].em_hak_akses;
          print(hakAkses);
          if (hakAkses != "" || hakAkses != null) {
            if (hakAkses == '0') {
              var data = {
                'id': 0,
                'name': 'SEMUA DIVISI',
                'inisial': 'AD',
                'parent_id': '',
                'aktif': '',
                'pakai': '',
                'ip': '',
                'created_by': '',
                'created_on': '',
                'modified_by': '',
                'modified_on': ''
              };
              departementAkses.add(data);
            }
            var convert = hakAkses!.split(',');
            for (var element in dataDepartemen) {
              if (hakAkses == '0') {
                departementAkses.add(element);
              }
              for (var element1 in convert) {
                if ("${element['id']}" == element1) {
                  print('sampe sini');
                  departementAkses.add(element);
                }
              }
            }
          }
          this.departementAkses.refresh();
          if (departementAkses.value.isNotEmpty) {
            if (status == 1) {
              idDepartemenTerpilih.value = "${departementAkses[0]['id']}";
              namaDepartemenTerpilih.value = departementAkses[0]['name'];
              departemen.value.text = departementAkses[0]['name'];
              showButtonlaporan.value = true;
              aksiCariLaporan();
            }
          }
        }
      }
    });
  }

  var date = DateTime.parse(AppData.endPeriode).obs;
  var startPeriode = "".obs;
  var endPeriode = "".obs;
  var tempStartPeriode = "".obs;
  var tempEndPeriode = "".obs;

  void aksiCariLaporan() async {
    var defaultDate = date.value;

    DateTime tanggalAkhirBulan =
        DateTime(defaultDate.year, defaultDate.month + 1, 0);
    DateTime sp = DateTime(defaultDate.year, defaultDate.month, 1);
    DateTime ep =
        DateTime(defaultDate.year, defaultDate.month, tanggalAkhirBulan.day);
    startPeriode.value = DateFormat('yyyy-MM-dd').format(sp);
    endPeriode.value = DateFormat('yyyy-MM-dd').format(ep);

    tempStartPeriode.value = AppData.startPeriode;
    tempEndPeriode.value = AppData.endPeriode;

    if (AppData.informasiUser![0].beginPayroll >
        AppData.informasiUser![0].endPayroll) {
      startPeriode.value = DateFormat('yyyy-MM-dd').format(DateTime(
          defaultDate.year,
          defaultDate.month - 1,
          AppData.informasiUser![0].beginPayroll));
      endPeriode.value = DateFormat('yyyy-MM-dd').format(DateTime(
          defaultDate.year,
          defaultDate.month,
          AppData.informasiUser![0].endPayroll));
    } else if (AppData.informasiUser![0].beginPayroll == 1) {
      startPeriode.value = DateFormat('yyyy-MM-dd').format(DateTime(
          defaultDate.year,
          defaultDate.month,
          AppData.informasiUser![0].beginPayroll));
    }

    AppData.startPeriode = startPeriode.value;
    AppData.endPeriode = endPeriode.value;

    statusLoadingSubmitLaporan.value = true;
    allNameLaporanTidakhadir.value.clear();
    Map<String, dynamic> body = {
      'bulan': bulanSelectedSearchHistory.value,
      'tahun': tahunSelectedSearchHistory.value,
      'status': idDepartemenTerpilih.value,
      'type': title.value,
      'branch_id': branchId.value,
      'leave_status': filterStatusAjuanTerpilih.value
    };
    var connect = Api.connectionApi("post", body, "load_laporan_pengajuan");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        if (valueBody['status'] == false) {
          statusLoadingSubmitLaporan.value = false;
          UtilsAlert.showToast(
              "Data periode $bulanSelectedSearchHistory belum tersedia, harap hubungi HRD");
        } else {
          var data = valueBody['data'];
          print('ini data : ${data}');
          loadingString.value =
              data.length == 0 ? "Data tidak tersedia" : "Memuat Data...";
          allNameLaporanTidakhadir.value = data;
          allNameLaporanTidakhadirCopy.value = data;
          this.allNameLaporanTidakhadir.refresh();
          this.allNameLaporanTidakhadirCopy.refresh();
          statusLoadingSubmitLaporan.value = false;
          this.statusLoadingSubmitLaporan.refresh();
        }
      }
    });

    AppData.startPeriode = tempStartPeriode.value;
    AppData.endPeriode = tempEndPeriode.value;
  }

  void cariLaporanPengajuanTanggal(tanggalTerpilih) async {
    var tanggalSubmit = "${DateFormat('yyyy-MM-dd').format(tanggalTerpilih)}";

    statusLoadingSubmitLaporan.value = true;
    allNameLaporanTidakhadir.value.clear();
    Map<String, dynamic> body = {
      'atten_date': tanggalSubmit,
      'status': idDepartemenTerpilih.value,
      'type': title.value
    };
    var connect =
        Api.connectionApi("post", body, "load_laporan_pengajuan_harian");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        if (valueBody['status'] == false) {
          statusLoadingSubmitLaporan.value = false;
          UtilsAlert.showToast(
              "Data periode $bulanSelectedSearchHistory belum tersedia, harap hubungi HRD");
        } else {
          var data = valueBody['data'];
          loadingString.value = data.length == 0
              ? "Anda tidak memiliki\nLaporan Cuti"
              : "Memuat Data...";
          allNameLaporanTidakhadir.value = data;
          allNameLaporanTidakhadirCopy.value = data;
          this.allNameLaporanTidakhadir.refresh();
          this.allNameLaporanTidakhadirCopy.refresh();
          statusLoadingSubmitLaporan.value = false;
          this.statusLoadingSubmitLaporan.refresh();
        }
      }
    });
  }

  void showBottomBranch() {
    showModalBottomSheet(
      context: Get.context!,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pilih Cabang",
                    style: GoogleFonts.inter(
                        color: Constanst.fgPrimary,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                  InkWell(
                      customBorder: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      onTap: () => Navigator.pop(Get.context!),
                      child: Icon(
                        Icons.close,
                        size: 26,
                        color: Constanst.fgSecondary,
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Divider(
                thickness: 1,
                height: 0,
                color: Constanst.border,
              ),
            ),
            Expanded(
              child: Obx(() {
                return SingleChildScrollView(
                  child: ListView.builder(
                    itemCount: branchList.length,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      var name = branchList[index]['name'];
                      var idBrach = branchList[index]['id'];
                      var isSelected = filterBranch.value == name;
                      print('ini brachid $idBrach');
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              filterBranch.value = name;
                              branchId.value = idBrach.toString();
                              Navigator.pop(context);
                              aksiCariLaporan();
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 16, 16, 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      name,
                                      style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Constanst.fgPrimary),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  isSelected
                                      ? Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 2,
                                                  color: Constanst.onPrimary),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(3),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Constanst.onPrimary,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: Constanst.onPrimary),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(2),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                            ),
                                          ),
                                        )
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }

  void getBranch() {
    var connect = Api.connectionApi('get', {}, 'cabang');
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        branchList.clear();
        var valueBody = jsonDecode(res.body);
        print('ini get barnch ${valueBody['data']}');
        for (var data in valueBody['data']) {
          branchList.add(data);
        }
        List data = valueBody['data'];
        if (data.isNotEmpty) {
          var listFirst = data.firstWhere((element) => element['name'] != null,
              orElse: () => null);
          if (listFirst != null) {
            var fullName = listFirst['name'] ?? "";
            String namaUserPertama = "$fullName";
            filterBranch.value = namaUserPertama;
          }
        }
        branchList.refresh;
        filterBranch.refresh;
        print(branchList);
      } else {
        print('error ${res.body}');
      }
    });
  }

  void getLoadsysData() {
    var connect = Api.connectionApi("get", "", "sysdata");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        for (var element in valueBody['data']) {
          if (element['kode'] == "013") {
            valuePolaPersetujuan.value = "${element['name']}";
            this.valuePolaPersetujuan.refresh();
            getTypeAjuan();
          }
        }
      }
    });
  }

  void getTypeAjuan() {
    if (valuePolaPersetujuan.value == "1") {
      dataTypeAjuan.value.clear();
      for (var element in dataTypeAjuanDummy1) {
        var data = {'nama': element, 'status': false};
        dataTypeAjuan.value.add(data);
      }
      dataTypeAjuan.value
          .firstWhere((element) => element['nama'] == 'Semua')['status'] = true;
      this.dataTypeAjuan.refresh();
    } else {
      dataTypeAjuan.value.clear();
      for (var element in dataTypeAjuanDummy2) {
        var data = {'nama': element, 'status': false};
        dataTypeAjuan.value.add(data);
      }
      dataTypeAjuan.value
          .firstWhere((element) => element['nama'] == 'Semua')['status'] = true;
      this.dataTypeAjuan.refresh();
    }
  }

  void loadDataTidakHadirEmployee(emId, bulan, tahun, title) {
    listDetailLaporanEmployee.value.clear();
    AppData.startPeriode = startPeriode.value;
    AppData.endPeriode = endPeriode.value;
    Map<String, dynamic> body = {
      'em_id': emId,
      'bulan': bulan,
      'tahun': tahun,
      'type': title,
    };
    var connect =
        Api.connectionApi("post", body, "load_detail_laporan_pengajuan");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        var data = valueBody['data'];
        for (var ya in data) {
          print('ini tampil laporan  ${ya['leave_status']}');
        }
        listDetailLaporanEmployee.value = data;
        alllistDetailLaporanEmployee.value = data;
        this.listDetailLaporanEmployee.refresh();
        this.alllistDetailLaporanEmployee.refresh();
        loadingString.value = listDetailLaporanEmployee.isEmpty
            ? "Data pengajuan tidak ada"
            : "Memuat Data...";
        this.loadingString.refresh();
        typeAjuanRefresh("Semua");
      }
    });
    AppData.startPeriode = tempStartPeriode.value;
    AppData.endPeriode = tempEndPeriode.value;
  }

  void typeAjuanRefresh(name) {
    for (var element in dataTypeAjuan.value) {
      if (element['nama'] == name) {
        element['status'] = true;
      } else {
        element['status'] = false;
      }
    }
    this.dataTypeAjuan.refresh();
  }

  void changeTypeAjuanLaporan(name, title) {
    var statusFilter = name == "Approve 1"
        ? "Approve"
        : name == "Approve 2"
            ? "Approve2"
            : name == "Rejected"
                ? "Rejected"
                : name == "Pending"
                    ? "Pending"
                    : "Approve";
    for (var element in dataTypeAjuan.value) {
      if (element['nama'] == name) {
        element['status'] = true;
      } else {
        element['status'] = false;
      }
    }
    if (name == "Semua") {
      List data = [];
      for (var element in alllistDetailLaporanEmployee.value) {
        data.add(element);
      }
      listDetailLaporanEmployee.value = data;
      this.listDetailLaporanEmployee.refresh();
      this.selectedType.refresh();
      loadingString.value = listDetailLaporanEmployee.value.length != 0
          ? "Memuat Data..."
          : "Tidak ada pengajuan";
      this.loadingString.refresh();
    } else {
      List data = [];
      for (var element in alllistDetailLaporanEmployee.value) {
        if (title == "tidak_hadir" ||
            title == "cuti" ||
            title == "dinas_luar") {
          if (element['leave_status'] == statusFilter) {
            data.add(element);
            print('${element['leave_status']}');
          }
        } else {
          if (element['status'] == statusFilter) {
            data.add(element);
          }
        }
      }
      listDetailLaporanEmployee.value = data;
      this.listDetailLaporanEmployee.refresh();
      this.selectedType.refresh();
      loadingString.value = listDetailLaporanEmployee.value.length != 0
          ? "Memuat Data..."
          : "Tidak ada pengajuan";
      this.loadingString.refresh();
    }
  }

  void pencarianNamaKaryawan(value) {
    var textCari = value.toLowerCase();
    var filter = allNameLaporanTidakhadirCopy.where((laporan) {
      var namaEmployee = laporan['full_name'].toLowerCase();
      return namaEmployee.contains(textCari);
    }).toList();
    allNameLaporanTidakhadir.value = filter;
    statusCari.value = true;
    this.allNameLaporanTidakhadir.refresh();
    this.statusCari.refresh();
  }

  void filterDataArray() {
    var data = departementAkses.value;
    var seen = Set<String>();
    List filter = data.where((divisi) => seen.add(divisi['name'])).toList();
    departementAkses.value = filter;
    this.departementAkses.refresh();
  }

  showDataDepartemenAkses(status) {
    filterDataArray();
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Pilih Divisi",
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Constanst.fgPrimary,
                            ),
                          ),
                          InkWell(
                              customBorder: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              onTap: () => Navigator.pop(Get.context!),
                              child: Icon(
                                Icons.close,
                                size: 26,
                                color: Constanst.fgSecondary,
                              ))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Divider(
                        thickness: 1,
                        height: 0,
                        color: Constanst.border,
                      ),
                    ),
                    SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: List.generate(departementAkses.value.length,
                              (index) {
                            var id = departementAkses.value[index]['id'];
                            var dep_name =
                                departementAkses.value[index]['name'];
                            return InkWell(
                              onTap: () {
                                idDepartemenTerpilih.value = "$id";
                                namaDepartemenTerpilih.value = dep_name;
                                departemen.value.text =
                                    departementAkses.value[index]['name'];
                                this.departemen.refresh();
                                Navigator.pop(context);
                                if (selectedViewFilterPengajuan.value == 0) {
                                  aksiCariLaporan();
                                } else {
                                  cariLaporanPengajuanTanggal(
                                      pilihTanggalFilterAjuan.value);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      dep_name,
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Constanst.fgPrimary,
                                      ),
                                    ),
                                    "$id" == idDepartemenTerpilih.value
                                        ? InkWell(
                                            onTap: () {},
                                            child: Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 2,
                                                      color:
                                                          Constanst.onPrimary),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(3),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color:
                                                          Constanst.onPrimary,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                ),
                                              ),
                                            ),
                                          )
                                        : InkWell(
                                            onTap: () {
                                              idDepartemenTerpilih.value =
                                                  "$id";
                                              namaDepartemenTerpilih.value =
                                                  dep_name;
                                              departemen.value.text =
                                                  departementAkses.value[index]
                                                      ['name'];
                                              this.departemen.refresh();
                                              Navigator.pop(context);
                                              if (selectedViewFilterPengajuan
                                                      .value ==
                                                  0) {
                                                aksiCariLaporan();
                                              } else {
                                                cariLaporanPengajuanTanggal(
                                                    pilihTanggalFilterAjuan
                                                        .value);
                                              }
                                            },
                                            child: Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 1,
                                                      color:
                                                          Constanst.onPrimary),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(2),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                ),
                                              ),
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            );
                          }),
                        )),
                  ],
                ),
              ),
            ),
          );
        });
  }

  showDataStatusAjuan() {
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Pilih Status Ajuan",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Constanst.fgPrimary,
                          ),
                        ),
                        InkWell(
                            customBorder: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            onTap: () => Navigator.pop(Get.context!),
                            child: Icon(
                              Icons.close,
                              size: 26,
                              color: Constanst.fgSecondary,
                            ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Divider(
                      thickness: 1,
                      height: 0,
                      color: Constanst.border,
                    ),
                  ),
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Obx(
                      () => Column(
                        children: List.generate(
                            valuePolaPersetujuan.value == "1"
                                ? dataTypeAjuanDummy1.length
                                : dataTypeAjuanDummy2.length, (index) {
                          var name = valuePolaPersetujuan.value == "1"
                              ? dataTypeAjuanDummy1[index]
                              : dataTypeAjuanDummy2[index];
                          return InkWell(
                            onTap: () {
                              // if (selectedViewFilterPengajuan.value == 1) {
                              filterStatusPengajuan(name);
                              // }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    name,
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Constanst.fgPrimary,
                                    ),
                                  ),
                                  name == filterStatusAjuanTerpilih.value
                                      ? InkWell(
                                          onTap: () {},
                                          child: Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 2,
                                                    color: Constanst.onPrimary),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(3),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Constanst.onPrimary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                              ),
                                            ),
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            // if (selectedViewFilterPengajuan.value == 1) {
                                            // aksiCariLaporan();
                                            filterStatusPengajuan(name);
                                            // }
                                          },
                                          child: Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 1,
                                                    color: Constanst.onPrimary),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(2),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                              ),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void filterStatusPengajuan(name) {
    List listFilterLokasi = [];
    print('ini name: $name');
    // for (var element in allNameLaporanTidakhadirCopy.value) {
    //   if (name == "Semua") {
    //     listFilterLokasi.add(element);
    //   } else {
    //     print(element['leave_status']);
    //     if (element['leave_status'] == name) {
    //       listFilterLokasi.add(element);
    //     }
    //   }
    // }
    allNameLaporanTidakhadir.value = listFilterLokasi;
    filterStatusAjuanTerpilih.value = name;
    this.allNameLaporanTidakhadir.refresh();
    this.filterStatusAjuanTerpilih.refresh();
    loadingString.value = allNameLaporanTidakhadir.value.length != 0
        ? "Memuat Data..."
        : "Tidak ada pengajuan";
    aksiCariLaporan();
    Navigator.pop(Get.context!);
  }

  void widgetButtomSheetFilterData() {
    showModalBottomSheet(
      context: Get.context!,
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
              height: 8,
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 90,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            "Filter",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        child: IconButton(
                          onPressed: () => Navigator.pop(Get.context!),
                          icon: Icon(Iconsax.close_circle),
                        ),
                      )
                    ],
                  ),
                  Divider(
                    height: 5,
                    color: Constanst.colorText2,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  lineTitleKategori(),
                  SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: pageViewKategoriFilter(),
                      )),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget lineTitleKategori() {
    return Obx(
      () => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                selectedViewFilterPengajuan.value = 0;
                pageViewFilterWaktu!.jumpToPage(0);
                this.selectedViewFilterPengajuan.refresh();
              },
              child: Container(
                margin: EdgeInsets.only(left: 6, right: 6),
                decoration: BoxDecoration(
                    color: selectedViewFilterPengajuan.value == 0
                        ? Constanst.colorPrimary
                        : Colors.transparent,
                    borderRadius: Constanst.borderStyle1),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Bulan',
                      style: TextStyle(
                        color: selectedViewFilterPengajuan.value == 0
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                selectedViewFilterPengajuan.value = 1;
                pageViewFilterWaktu!.jumpToPage(1);
                this.selectedViewFilterPengajuan.refresh();
              },
              child: Container(
                margin: EdgeInsets.only(left: 6, right: 6),
                decoration: BoxDecoration(
                    color: selectedViewFilterPengajuan.value == 1
                        ? Constanst.colorPrimary
                        : Colors.transparent,
                    borderRadius: Constanst.borderStyle1),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Tanggal',
                      style: TextStyle(
                        color: selectedViewFilterPengajuan.value == 1
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget pageViewKategoriFilter() {
    return PageView.builder(
        physics: BouncingScrollPhysics(),
        controller: pageViewFilterWaktu,
        onPageChanged: (index) {
          selectedViewFilterPengajuan.value = index;
        },
        itemCount: 2,
        itemBuilder: (context, index) {
          return Padding(
              padding: EdgeInsets.all(0),
              child: index == 0
                  ? filterBulan()
                  : index == 1
                      ? filterTanggal()
                      : SizedBox());
        });
  }

  Widget filterBulan() {
    return Padding(
        padding: const EdgeInsets.only(right: 5),
        child: InkWell(
          onTap: () {
            DatePicker.showPicker(
              Get.context!,
              pickerModel: CustomMonthPicker(
                minTime: DateTime(2000, 1, 1),
                maxTime: DateTime(2100, 1, 1),
                currentTime: DateTime.now(),
              ),
              onConfirm: (time) {
                if (time != null) {
                  print("$time");
                  var filter = DateFormat('yyyy-MM').format(time);
                  var array = filter.split('-');
                  var bulan = array[1];
                  var tahun = array[0];
                  bulanSelectedSearchHistory.value = bulan;
                  tahunSelectedSearchHistory.value = tahun;
                  bulanDanTahunNow.value = "$bulan-$tahun";
                  this.bulanSelectedSearchHistory.refresh();
                  this.tahunSelectedSearchHistory.refresh();
                  this.bulanDanTahunNow.refresh();
                  statusFilterWaktu.value = 0;
                  Navigator.pop(Get.context!);
                  aksiCariLaporan();
                }
              },
            );
          },
          child: Container(
            height: 40,
            decoration: BoxDecoration(
                borderRadius: Constanst.borderStyle1,
                border: Border.all(color: Constanst.colorText2)),
            child: Padding(
              padding: EdgeInsets.only(top: 10, bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Icon(Iconsax.calendar_2),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 3),
                            child: Text(
                              "${Constanst.convertDateBulanDanTahun(bulanDanTahunNow.value)}",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget filterTanggal() {
    return Padding(
        padding: const EdgeInsets.only(right: 5),
        child: InkWell(
          onTap: () {
            DatePicker.showDatePicker(Get.context!,
                showTitleActions: true,
                minTime: DateTime(2000, 1, 1),
                maxTime: DateTime(2100, 1, 1), onConfirm: (date) {
              Navigator.pop(Get.context!);
              statusFilterWaktu.value = 1;
              pilihTanggalFilterAjuan.value = date;
              this.pilihTanggalFilterAjuan.refresh();
              cariLaporanPengajuanTanggal(pilihTanggalFilterAjuan.value);
            }, currentTime: DateTime.now(), locale: LocaleType.en);
          },
          child: Container(
            height: 40,
            decoration: BoxDecoration(
                borderRadius: Constanst.borderStyle1,
                border: Border.all(color: Constanst.colorText2)),
            child: Padding(
              padding: EdgeInsets.only(top: 10, bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Icon(Iconsax.calendar_2),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Text(
                              "${Constanst.convertDate('${DateFormat('yyyy-MM-dd').format(pilihTanggalFilterAjuan.value)}')}",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void showDetailRiwayat(detailData, apply_by, alasanReject) {
    var nomorAjuan = detailData['nomor_ajuan'];
    var get2StringNomor = '${nomorAjuan[0]}${nomorAjuan[1]}';
    var tanggalMasukAjuan = detailData['atten_date'];
    var namaTypeAjuan = detailData['name'];
    var tanggalAjuanDari = detailData['start_date'];
    var tanggalAjuanSampai = detailData['end_date'];
    var alasan = detailData['reason'];
    var durasi = detailData['leave_duration'];
    var typeAjuan;
    if (valuePolaPersetujuan.value == "1") {
      typeAjuan = detailData['leave_status'];
    } else {
      typeAjuan = detailData['leave_status'] == "Approve"
          ? "Approve 1"
          : detailData['leave_status'] == "Approve2"
              ? "Approve 2"
              : detailData['leave_status'];
    }
    var jamAjuan =
        detailData['time_plan'] == null || detailData['time_plan'] == ""
            ? "00:00:00"
            : detailData['time_plan'];
    var sampaiJamAjuan =
        detailData['time_plan_to'] == null || detailData['time_plan_to'] == ""
            ? "00:00:00"
            : detailData['time_plan_to'];
    var leave_files = detailData['leave_files'];
    var categoryIzin = detailData['category'];

    var listTanggalTerpilih = detailData['date_selected'].split(',');
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
                          "Nama Pengajuan",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Constanst.fgSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          get2StringNomor == "DL"
                              ? "DINAS LUAR"
                              : "$namaTypeAjuan",
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
                          "Tanggal Cuti",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Constanst.fgSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        detailData['date_selected'] == null ||
                                detailData['date_selected'] == "" ||
                                detailData['date_selected'] == "null"
                            ? Text(
                                "${Constanst.convertDate6(tanggalAjuanDari)} - ${Constanst.convertDate6(tanggalAjuanSampai)}",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Constanst.fgPrimary,
                                ),
                              )
                            : Container(),
                        detailData['date_selected'] == null ||
                                detailData['date_selected'] == "" ||
                                detailData['date_selected'] == "null"
                            ? Container()
                            : Row(
                                children: List.generate(
                                    listTanggalTerpilih.length, (index) {
                                  var nomor = index + 1;
                                  var tanggalConvert = Constanst.convertDate7(
                                      listTanggalTerpilih[index]);
                                  var tanggalConvert2 = Constanst.convertDate5(
                                      listTanggalTerpilih[index]);
                                  return Row(
                                    children: [
                                      Text(
                                        index == listTanggalTerpilih.length - 1
                                            ? tanggalConvert2
                                            : '$tanggalConvert, ',
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Constanst.fgPrimary,
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                        const SizedBox(height: 12),
                        Divider(
                          height: 0,
                          thickness: 1,
                          color: Constanst.border,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Durasi Cuti",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Constanst.fgSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "$durasi Hari",
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
                                        viewLampiranAjuan(leave_files);
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
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Rejected by $apply_by",
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              color: Constanst.fgPrimary,
                                              fontSize: 14)),
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
                                ],
                              )
                            : typeAjuan == "Approve" ||
                                    typeAjuan == "Approve 1" ||
                                    typeAjuan == "Approve 2"
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
                                      Text("Approved by $apply_by",
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
                                          // const SizedBox(height: 4),
                                          // InkWell(
                                          //     onTap: () {
                                          //       var dataEmployee = {
                                          //         'nameType': '$namaTypeAjuan',
                                          //         'nomor_ajuan': '$nomorAjuan',
                                          //       };
                                          //       controllerGlobal
                                          //           .showDataPilihAtasan(
                                          //               dataEmployee);
                                          //     },
                                          //     child: Text(
                                          //         "Konfirmasi via Whatsapp",
                                          //         style: GoogleFonts.inter(
                                          //             fontWeight:
                                          //                 FontWeight.w400,
                                          //             color:
                                          //                 Constanst.infoLight,
                                          //             fontSize: 14))),
                                        ],
                                      ),
                                    ],
                                  ),
                      ],
                    ),
                  ),
                ),
                // typeAjuan == "Approve" ||
                //         typeAjuan == "Approve 1" ||
                //         typeAjuan == "Approve 2"
                //     ? Container()
                //     : const SizedBox(height: 16),
                // typeAjuan == "Approve" ||
                //         typeAjuan == "Approve 1" ||
                //         typeAjuan == "Approve 2"
                //     ? Container()
                //     : Row(
                //         children: [
                //           Expanded(
                //             child: Container(
                //               height: 40,
                //               padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                //               margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                //               decoration: BoxDecoration(
                //                 border: Border.all(
                //                   color: Constanst
                //                       .border, // Set the desired border color
                //                   width: 1.0,
                //                 ),
                //                 borderRadius: BorderRadius.circular(8.0),
                //               ),
                //               child: ElevatedButton(
                //                 onPressed: () {
                //                   // Get.back();Get.back();
                //                   batalkanPengajuanCuti(detailData);
                //                 },
                //                 style: ElevatedButton.styleFrom(
                //                     foregroundColor: Constanst.color4,
                //                     backgroundColor: Constanst.colorWhite,
                //                     shape: RoundedRectangleBorder(
                //                       borderRadius: BorderRadius.circular(8),
                //                     ),
                //                     elevation: 0,
                //                     // padding: EdgeInsets.zero,
                //                     padding:
                //                         const EdgeInsets.fromLTRB(0, 0, 0, 0)),
                //                 child: Text(
                //                   'Batalkan',
                //                   style: GoogleFonts.inter(
                //                       fontWeight: FontWeight.w500,
                //                       color: Constanst.color4,
                //                       fontSize: 14),
                //                 ),
                //               ),
                //             ),
                //           ),
                //           const SizedBox(width: 8),
                //           Expanded(
                //             child: SizedBox(
                //               height: 40,
                //               child: ElevatedButton(
                //                 onPressed: () {
                //                   print(detailData.toString());
                //                   Get.to(FormPengajuanCuti(
                //                     dataForm: [detailData, true],
                //                   ));
                //                 },
                //                 style: ElevatedButton.styleFrom(
                //                   foregroundColor: Constanst.colorWhite,
                //                   backgroundColor: Constanst.colorPrimary,
                //                   shape: RoundedRectangleBorder(
                //                     borderRadius: BorderRadius.circular(8),
                //                   ),
                //                   elevation: 0,
                //                   // padding: const EdgeInsets.fromLTRB(20, 12, 20, 12)
                //                 ),
                //                 child: Text(
                //                   'Edit',
                //                   style: GoogleFonts.inter(
                //                       fontWeight: FontWeight.w500,
                //                       color: Constanst.colorWhite,
                //                       fontSize: 14),
                //                 ),
                //               ),
                //             ),
                //           ),
                //         ],
                //       )
              ],
            ),
          ),
        );
      },
    );
  }

  void viewLampiranAjuan(value) async {
    var urlViewGambar = Api.UrlfileCuti + value;

    final url = Uri.parse(urlViewGambar);
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      UtilsAlert.showToast('Tidak dapat membuka file');
    }
  }
  // void viewLampiranAjuanKlaim(value) async {
  //   var urlViewGambar = Api.UrlfileKlaim + value;

  //   final url = Uri.parse(urlViewGambar);
  //   if (!await launchUrl(
  //     url,
  //     mode: LaunchMode.externalApplication,
  //   )) {
  //     UtilsAlert.showToast('Tidak dapat membuka file');
  //   }
  // }

  String convertToIdr(dynamic number, int decimalDigit) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: decimalDigit,
    );
    return currencyFormatter.format(number);
  }

  void widgetButtomSheetFormLaporan() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      backgroundColor: Constanst.colorWhite,
      builder: (context) {
        return SafeArea(
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Iconsax.document_text5,
                            color: Constanst.infoLight,
                            size: 26,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Text(
                              "Cek Laporan",
                              style: GoogleFonts.inter(
                                  color: Constanst.fgPrimary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.pop(Get.context!);
                          },
                          child: Icon(
                            Icons.close,
                            size: 24,
                            color: Constanst.fgSecondary,
                          ))
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Divider(
                    height: 0,
                    thickness: 1,
                    color: Constanst.fgBorder,
                  ),
                ),
                InkWell(
                  // highlightColor: Colors.white,
                  onTap: () {
                    Get.back();
                    Get.back();
                    Get.to(LaporanAbsen(
                      dataForm: "",
                    ));
                    tempNamaLaporan1.value = "";
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 12, bottom: 12, left: 16, right: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/2_absen.svg',
                              height: 35,
                              width: 35,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Text(
                                'Laporan Absensi',
                                style: GoogleFonts.inter(
                                    color: Constanst.fgPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            Get.back();
                            Get.back();
                            Get.to(LaporanAbsen(
                              dataForm: "",
                            ));
                            tempNamaLaporan1.value = "";
                          },
                          child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: tempNamaLaporan1.value == "" ? 2 : 1,
                                    color: Constanst.onPrimary),
                                borderRadius: BorderRadius.circular(10)),
                            child: tempNamaLaporan1.value == ""
                                ? Padding(
                                    padding: const EdgeInsets.all(3),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Constanst.onPrimary,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  )
                                : Container(),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  // highlightColor: Colors.white,
                  onTap: () {
                    Get.back();
                    Get.back();
                    Get.to(LaporanIzin(
                      title: 'tidak_hadir',
                    ));
                    tempNamaLaporan1.value = "tidak_hadir";
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 12, bottom: 12, left: 16, right: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/3_izin.svg',
                              height: 35,
                              width: 35,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Text(
                                'Laporan Izin',
                                style: GoogleFonts.inter(
                                    color: Constanst.fgPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            Get.back();
                            Get.back();
                            Get.to(LaporanIzin(
                              title: 'tidak_hadir',
                            ));
                            tempNamaLaporan1.value = "tidak_hadir";
                          },
                          child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width:
                                        tempNamaLaporan1.value == "tidak_hadir"
                                            ? 2
                                            : 1,
                                    color: Constanst.onPrimary),
                                borderRadius: BorderRadius.circular(10)),
                            child: tempNamaLaporan1.value == "tidak_hadir"
                                ? Padding(
                                    padding: const EdgeInsets.all(3),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Constanst.onPrimary,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  )
                                : Container(),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  // highlightColor: Colors.white,
                  onTap: () {
                    Get.back();
                    Get.back();
                    Get.to(LaporanLembur(
                      title: 'lembur',
                    ));
                    tempNamaLaporan1.value = "lembur";
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 12, bottom: 12, left: 16, right: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/4_lembur.svg',
                              height: 35,
                              width: 35,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Text(
                                'Laporan Lembur',
                                style: GoogleFonts.inter(
                                    color: Constanst.fgPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            Get.back();
                            Get.back();
                            Get.to(LaporanLembur(
                              title: 'lembur',
                            ));
                            tempNamaLaporan1.value = "lembur";
                          },
                          child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: tempNamaLaporan1.value == "lembur"
                                        ? 2
                                        : 1,
                                    color: Constanst.onPrimary),
                                borderRadius: BorderRadius.circular(10)),
                            child: tempNamaLaporan1.value == "lembur"
                                ? Padding(
                                    padding: const EdgeInsets.all(3),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Constanst.onPrimary,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  )
                                : Container(),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  // highlightColor: Colors.white,
                  onTap: () {
                    Get.back();
                    Get.back();
                    Get.to(LaporanCuti(
                      title: 'cuti',
                    ));
                    tempNamaLaporan1.value = "cuti";
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 12, bottom: 12, left: 16, right: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/5_cuti.svg',
                              height: 35,
                              width: 35,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Text(
                                'Laporan Cuti',
                                style: GoogleFonts.inter(
                                    color: Constanst.fgPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            Get.back();
                            Get.back();
                            Get.to(LaporanCuti(
                              title: 'cuti',
                            ));
                            tempNamaLaporan1.value = "cuti";
                          },
                          child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: tempNamaLaporan1.value == "cuti"
                                        ? 2
                                        : 1,
                                    color: Constanst.onPrimary),
                                borderRadius: BorderRadius.circular(10)),
                            child: tempNamaLaporan1.value == "cuti"
                                ? Padding(
                                    padding: const EdgeInsets.all(3),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Constanst.onPrimary,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  )
                                : Container(),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  // highlightColor: Colors.white,
                  onTap: () {
                    Get.back();
                    Get.back();
                    Get.to(LaporanTugasLuar(
                      title: 'tugas_luar',
                    ));
                    tempNamaLaporan1.value = "tugas_luar";
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 12, bottom: 12, left: 16, right: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/6_tugas_luar.svg',
                              height: 35,
                              width: 35,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Text(
                                'Laporan Tugas Luar',
                                style: GoogleFonts.inter(
                                    color: Constanst.fgPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            Get.back();
                            Get.back();
                            Get.to(LaporanTugasLuar(
                              title: 'tugas_luar',
                            ));
                            tempNamaLaporan1.value = "tugas_luar";
                          },
                          child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width:
                                        tempNamaLaporan1.value == "tugas_luar"
                                            ? 2
                                            : 1,
                                    color: Constanst.onPrimary),
                                borderRadius: BorderRadius.circular(10)),
                            child: tempNamaLaporan1.value == "tugas_luar"
                                ? Padding(
                                    padding: const EdgeInsets.all(3),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Constanst.onPrimary,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  )
                                : Container(),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  // highlightColor: Colors.white,
                  onTap: () {
                    Get.back();
                    Get.back();
                    Get.to(LaporanKlaim(
                      title: 'klaim',
                    ));
                    tempNamaLaporan1.value = "klaim";
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 12, bottom: 12, left: 16, right: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/7_klaim.svg',
                              height: 35,
                              width: 35,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Text(
                                'Laporan Klaim',
                                style: GoogleFonts.inter(
                                    color: Constanst.fgPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            Get.back();
                            Get.back();
                            Get.to(LaporanKlaim(
                              title: 'klaim',
                            ));
                            tempNamaLaporan1.value = "klaim";
                          },
                          child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: tempNamaLaporan1.value == "klaim"
                                        ? 2
                                        : 1,
                                    color: Constanst.onPrimary),
                                borderRadius: BorderRadius.circular(10)),
                            child: tempNamaLaporan1.value == "klaim"
                                ? Padding(
                                    padding: const EdgeInsets.all(3),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Constanst.onPrimary,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  )
                                : Container(),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  // highlightColor: Colors.white,
                  onTap: () {
                    Get.back();
                    Get.back();
                    Get.to(LaporanShift(
                      title: 'shift',
                    ));
                    tempNamaLaporan1.value = "shift";
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 12, bottom: 12, left: 16, right: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/4_lembur.svg',
                              height: 35,
                              width: 35,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Text(
                                'Laporan Shift',
                                style: GoogleFonts.inter(
                                    color: Constanst.fgPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            Get.back();
                            Get.back();
                            Get.to(LaporanShift(
                              title: 'shift',
                            ));
                            tempNamaLaporan1.value = "shift";
                          },
                          child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: tempNamaLaporan1.value == "shift"
                                        ? 2
                                        : 1,
                                    color: Constanst.onPrimary),
                                borderRadius: BorderRadius.circular(10)),
                            child: tempNamaLaporan1.value == "shift"
                                ? Padding(
                                    padding: const EdgeInsets.all(3),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Constanst.onPrimary,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  )
                                : Container(),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
