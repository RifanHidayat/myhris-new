import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
// import 'dart:io' show Platform;
import 'dart:math';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:siscom_operasional/controller/dashboard_controller.dart';
import 'package:siscom_operasional/model/absen_model.dart';
import 'package:siscom_operasional/model/detail_tracking.dart';
import 'package:siscom_operasional/model/riwayat_live_tracking.dart';
import 'package:siscom_operasional/model/shift_model.dart';
import 'package:siscom_operasional/model/tracking_list.dart';
import 'package:siscom_operasional/model/user_model.dart';
import 'package:siscom_operasional/screen/absen/berhasil_absen.dart';
import 'package:siscom_operasional/screen/absen/berhasil_registrasi.dart';
import 'package:siscom_operasional/screen/absen/detail_absen.dart';
import 'package:siscom_operasional/screen/absen/face_id_registration.dart';
import 'package:siscom_operasional/screen/absen/laporan/laporan_absen.dart';
import 'package:siscom_operasional/screen/absen/laporan/laporan_cuti.dart';
import 'package:siscom_operasional/screen/absen/laporan/laporan_dinas_luar.dart';
import 'package:siscom_operasional/screen/absen/laporan/laporan_izin.dart';
import 'package:siscom_operasional/screen/absen/laporan/laporan_klaim.dart';
import 'package:siscom_operasional/screen/absen/laporan/laporan_lembur.dart';
import 'package:siscom_operasional/screen/absen/laporan/laporan_tugas_luar.dart';
import 'package:siscom_operasional/screen/absen/loading_absen.dart';
import 'package:siscom_operasional/screen/absen/pengajuan%20absen_berhasil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:siscom_operasional/screen/kontrol/detail_tracking.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/custom_dialog.dart';
import 'package:siscom_operasional/utils/month_year_picker.dart';
import 'package:siscom_operasional/utils/widget_textButton.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';
import 'package:google_maps_utils/google_maps_utils.dart';
// import 'package:trust_location/trust_location.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:siscom_operasional/screen/absen/absen_masuk_keluar.dart';

import '../main.dart';

class TrackingController extends GetxController {
  var location = 'Unknown'.obs;
  var isServiceStarted = false.obs;
  static const platform = MethodChannel('com.example/backgroundservice');
  static const locationChannel =
      MethodChannel('com.example/backgroundservice/location_channel');
  @override
  void onInit() async {
    // checkIsLogin();
    print("Init");
    super.onInit();
    // initializeService();
  }

  // final controllerDashboard = Get.put(DashboardController());
  // PageController? pageViewFilterAbsen;
  var em_id = "".obs;

  //  var em_id = AppData.informasiUser![0].em_id.toString().obs;
  var detailTrackings = <DetailTrackingModel>[].obs;
  var detailTrackings2 = <DetailTrackingModel>[].obs;
  var riwayatLiveTrackings = <RiwayatLiveTrackingModel>[].obs;
  var trackingLists = <TrackingListModel>[].obs;

  var isLoadingDetailTracking = true.obs;
  var isLoadingDetailTracking2 = true.obs;
  var isLoadingDetailTracking3 = true.obs;
  var isLoadingRiwayatLiveTracking = true.obs;
  var isLoadingTrackingList = true.obs;

  var bagikanlokasi = "tidak aktif".obs;
  var isTrackingLokasi = false.obs;

  var isMaps = true.obs;
  var isMapsDetail = true.obs;
  var isMaximizeDetail = true.obs;

  var userTerpilih = [].obs;
  var kontrolHistory = [].obs;

  var offset = 0.obs;
  var limit = 10.obs;
  var hasMore = true.obs;
  final RefreshController refreshController =
      RefreshController(initialRefresh: true);

  List<LatLng> locations = [
    // const LatLng(-6.142492997069779, 106.73685778167766), // Lokasi awal
    // const LatLng(-6.142549098470421, 106.7356610004584),
    // const LatLng(-6.142271312337554, 106.73567894572908),
    // const LatLng(-6.141886577092146, 106.73568310655186),
    // const LatLng(-6.141121242712904, 106.73570807148857),
    // const LatLng(-6.140174709880735, 106.73571301458774),
    // const LatLng(-6.13707495189963, 106.73576728423541),
    // const LatLng(-6.136851555095482, 106.73559252967858),
    // const LatLng(-6.136636432158509, 106.73562581626084),
    // const LatLng(-6.1366612540258805, 106.73576728424145),
    // const LatLng(-6.135581501098166, 106.73582553576081),
    // const LatLng(-6.135548405188498, 106.73565910284955),
    // const LatLng(-6.134586502844211, 106.73563972002698),
  ];

  Rx<DateTime> initialDate = DateTime.now().obs;
  var tanggalPilihKontrol = TextEditingController().obs;

  var statusFormPencarian = false.obs;
  var statusFormPencarian2 = false.obs;

  // void toggleSearch() {
  //   statusFormPencarian.value = false;
  //   this.statusFormPencarian.refresh();
  // }

  // void toggleSearch2() {
  //   statusFormPencarian2.value = false;
  //   this.statusFormPencarian2.refresh();
  // }

  void showInputCari() {
    statusFormPencarian.value = !statusFormPencarian.value;
  }

  void showInputCari2() {
    statusFormPencarian2.value = !statusFormPencarian2.value;
  }

  var statusCari = false.obs;
  var cari = TextEditingController().obs;
  var showViewKontrol = false.obs;
  var employeeKontrol = [].obs;
  RxBool isChecked = false.obs;

  void toggleCheckboxChecked() {
    isChecked.value = !isChecked.value;
  }
  // RxBool isChecked2 = false.obs;
  // RxBool selengkapnyaMasuk = false.obs;
  // RxBool selengkapnyaKeluar = false.obs;

  // Rx<DateTime> selectedDate = DateTime.now().obs;

  // var tglAjunan = "".obs;
  // var checkinAjuan = "".obs;
  // var checkoutAjuan = "".obs;
  // var checkinAjuan2 = "".obs;
  // var checkoutAjuan2 = "".obs;
  // var catataanAjuan = TextEditingController();
  // var imageAjuan = "".obs;

  // var isTrackingMap = false.obs;

  // var pengajuanAbsensi = [].obs;

  TextEditingController deskripsiAbsen = TextEditingController();
  var tanggalLaporan = TextEditingController().obs;
  var departemen = TextEditingController().obs;

  // var fotoUser = File("").obs;

  // var settingAppInfo = AppData.infoSettingApp.obs;

  Rx<List<String>> placeCoordinateDropdown = Rx<List<String>>([]);
  // var placeCoordinateCheckin = [].obs;
  // var placeCoordinateCheckout = [].obs;

  var selectedType = "".obs;

  // var pauseCamera = false.obs;

  // var tempKodeStatus1 = "".obs;
  // var tempNamaStatus1 = "Semua".obs;
  // var tempNamaLaporan1 = "Semua".obs;
  // var tempNamaTipe1 = "".obs;

  var historyAbsen = <AbsenModel>[].obs;
  var historyAbsenShow = [].obs;
  var placeCoordinate = [].obs;
  var departementAkses = [].obs;
  var listLaporanFilter = [].obs;
  var allListLaporanFilter = [].obs;
  var listLaporanBelumAbsen = [].obs;
  var allListLaporanBelumAbsen = [].obs;
  var listEmployeeTelat = [].obs;
  var alllistEmployeeTelat = [].obs;
  var sysData = [].obs;
  // var isCollapse = true.obs;
  var shift = OfficeShiftModel().obs;

  // var isLoadingPengajuan = false.obs;

  // var absenSelected;

  var loading = "Memuat data...".obs;
  // var loadingPengajuan = "Memuat data...".obs;
  // var base64fotoUser = "".obs;
  var timeString = "".obs;
  var dateNow = "".obs;
  var alamatUserFoto = "".obs;
  var titleAbsen = "".obs;
  var tanggalUserFoto = "".obs;

  // var stringImageSelected = "".obs;

  var bulanSelectedSearchHistory = "".obs;
  var tahunSelectedSearchHistory = "".obs;
  var bulanDanTahunNow = "".obs;

  var bulanSelectedSearchHistoryPengajuan = "".obs;
  var tahunSelectedSearchHistoryPengajuan = "".obs;
  var bulanDanTahunNowPengajuan = "".obs;

  var namaDepartemenTerpilih = "".obs;
  var idDepartemenTerpilih = "".obs;
  // var testingg = "".obs;
  var filterLokasiKoordinate = "Lokasi".obs;
  // Rx<AbsenModel> absenModel = AbsenModel().obs;
  var jumlahData = 0.obs;
  // var isTracking = 0.obs;
  // var activeTracking = 0.obs;
  var selectedViewFilterAbsen = 0.obs;
  // var regType = 0.obs;
  // var namaFileUpload = "".obs;
  // var filePengajuan = File("").obs;
  // var uploadFile = false.obs;

  Rx<DateTime> pilihTanggalTelatAbsen = DateTime.now().obs;

  var latUser = 0.0.obs;
  var langUser = 0.0.obs;

  // var typeAbsen = 0.obs;
  // var intervalControl = 60000.obs;

  var imageStatus = false.obs;
  // var detailAlamat = false.obs;
  // var mockLocation = false.obs;
  var showButtonlaporan = false.obs;
  var statusLoadingSubmitLaporan = false.obs;

  // var filterLaporanAbsenTanggal = false.obs;

  var absenStatus = false.obs;
  var gagalAbsen = 0.obs;
  // var failured = "".obs;
  // RxString absenSuccess = "0".obs;

  void showMaximizeDetail() {
    isMaximizeDetail.value = !isMaximizeDetail.value;
  }

  @override
  void onReady() async {
    print("Masulk ke controller absen");
    getTimeNow();
    getLoadsysData();
    loadHistoryAbsenUser();
    getDepartemen(1, "");
    filterLokasiKoordinate.value = "Lokasi";
    selectedViewFilterAbsen.value = 0;
    pilihTanggalTelatAbsen.value = DateTime.now();
    super.onReady();
    userShift();
  }

  void getLoadsysData() {
    var connect = Api.connectionApi("get", "", "sysdata");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        if (valueBody['status'] == false) {
          statusLoadingSubmitLaporan.value = false;
          UtilsAlert.showToast(
              "Data periode $bulanSelectedSearchHistory belum tersedia, harap hubungi HRD");
        } else {
          sysData.value = valueBody['data'];
          this.sysData.refresh();
        }
      }
    });
  }

  void getTimeNow() {
    var dt = DateTime.now();
    bulanSelectedSearchHistory.value = "${dt.month}";
    tahunSelectedSearchHistory.value = "${dt.year}";

    bulanSelectedSearchHistoryPengajuan.value = "${dt.month}";
    tahunSelectedSearchHistoryPengajuan.value = "${dt.year}";
    bulanDanTahunNow.value = "${dt.month}-${dt.year}";
    bulanDanTahunNowPengajuan.value = "${dt.month}-${dt.year}";
    var convert = Constanst.convertDate1("${dt.year}-${dt.month}-${dt.day}");
    tanggalLaporan.value.text = convert;
    absenStatus.value = AppData.statusAbsen;

    tanggalPilihKontrol.value.text = Constanst.convertDate("$dt");
    tanggalPilihKontrol.refresh();
    // this.absenStatus.refresh();
  }

  // void showInputCari() {
  //   statusCari.value = !statusCari.value;
  // }

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
              showViewKontrol.value = true;
              aksiCariLaporan();
            } else if (status == 2) {
              idDepartemenTerpilih.value = "${departementAkses[0]['id']}";
              namaDepartemenTerpilih.value = departementAkses[0]['name'];
              departemen.value.text = departementAkses[0]['name'];
              showButtonlaporan.value = true;
              showViewKontrol.value = true;
              aksiEmployeeTerlambatAbsen(tanggal);
            } else if (status == 3) {
              idDepartemenTerpilih.value = "${departementAkses[0]['id']}";
              namaDepartemenTerpilih.value = departementAkses[0]['name'];
              departemen.value.text = departementAkses[0]['name'];
              showButtonlaporan.value = true;
              showViewKontrol.value = true;
              aksiEmployeeBelumAbsen(tanggal);
            }
          }
        }
      }
    });
  }

  void getEmployeeKontrol() {
    statusLoadingSubmitLaporan.value = true;
    employeeKontrol.value.clear();
    Map<String, dynamic> body = {'val': 'em_control', 'cari': '1'};
    var connect = Api.connectionApi("post", body, "whereOnce-employee");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        if (valueBody['status'] == false) {
          statusLoadingSubmitLaporan.value = false;
          UtilsAlert.showToast(
              "Data periode $bulanSelectedSearchHistory belum tersedia, harap hubungi HRD");
        } else {
          List data = valueBody['data'];
          if (idDepartemenTerpilih.value != '0') {
            List filterData = [];
            for (var element in data) {
              if ("${element['dep_id']}" == idDepartemenTerpilih.value) {
                filterData.add(element);
              }
            }
            List removeDuplicate = filterData.toSet().toList();
            employeeKontrol.value = removeDuplicate;
          } else {
            employeeKontrol.value = data;
          }
          this.employeeKontrol.refresh();
          employeeKontrol.value.sort((a, b) => a['full_name']
              .toUpperCase()
              .compareTo(b['full_name'].toUpperCase()));
          loading.value = employeeKontrol.value.length == 0
              ? "Data tidak tersedia"
              : "Memuat data...";
          jumlahData.value = employeeKontrol.value.length;
          statusLoadingSubmitLaporan.value = false;
          this.jumlahData.refresh();
          this.statusLoadingSubmitLaporan.refresh();
        }
      }
    });
  }

  void getPlaceCoordinate() {
    print("place coodinates");
    // placeCoordinate.clear();
    var connect = Api.connectionApi("get", {}, "places_coordinate",
        params: "&id=${AppData.informasiUser![0].em_id}");
    connect.then((dynamic res) {
      if (res == false) {
        print("errror");
        //UtilsAlert.koneksiBuruk();
      } else {
        if (res.statusCode == 200) {
          print("Place cordinate 200" + res.body.toString());
          var valueBody = jsonDecode(res.body);
          selectedType.value = valueBody['data'][0]['place'];
          for (var element in valueBody['data']) {
            placeCoordinateDropdown.value.add(element['place']);
          }
          List filter = [];
          for (var element in valueBody['data']) {
            if (element['isFilterView'] == 1) {
              filter.add(element);
            }
          }

          print("data ${placeCoordinate.value}");
          placeCoordinate.clear();
          placeCoordinate.value = filter;
          placeCoordinate.refresh();
          placeCoordinate.refresh();
        } else {
          print("Place cordinate !=200" + res.body.toString());
          print(res.body.toString());
        }
      }
    });
  }

  // void getPlaceCoordinateCheckin() {
  //   print("place coodinates");
  //   placeCoordinateCheckin.clear();
  //   var connect = Api.connectionApi("get", {}, "places_coordinate_pengajuan",
  //       params:
  //           "&id=${AppData.informasiUser![0].em_id}&date=${tglAjunan.value}");
  //   connect.then((dynamic res) {
  //     if (res == false) {
  //       print("errror");
  //       UtilsAlert.koneksiBuruk();
  //     } else {
  //       if (res.statusCode == 200) {
  //         print("Place cordinate 200" + res.body.toString());
  //         var valueBody = jsonDecode(res.body);
  //         selectedType.value = valueBody['data'][0]['place'];
  //         // for (var element in valueBody['data']) {
  //         //  placeCoordinateCheckin.value.add(element['place']);
  //         // }
  //         List filter = [];
  //         for (var element in valueBody['data']) {
  //           if (element['isFilterView'] == 1) {
  //             element['is_selected'] = false;
  //             filter.add(element);
  //           }
  //         }

  //         placeCoordinateCheckin.value = filter;
  //         placeCoordinate.refresh();
  //         placeCoordinate.refresh();
  //       } else {
  //         print("Place cordinate !=200" + res.body.toString());
  //         print(res.body.toString());
  //       }
  //     }
  //   });
  // }

  // void getPlaceCoordinateCheckout() {
  //   print("place coodinates");
  //   placeCoordinate.clear();
  //   var connect = Api.connectionApi("get", {}, "places_coordinate_pengajuan",
  //       params:
  //           "&id=${AppData.informasiUser![0].em_id}&date=${tglAjunan.value}");
  //   connect.then((dynamic res) {
  //     if (res == false) {
  //       print("errror");
  //       UtilsAlert.koneksiBuruk();
  //     } else {
  //       if (res.statusCode == 200) {
  //         print("Place cordinate 200" + res.body.toString());
  //         var valueBody = jsonDecode(res.body);
  //         selectedType.value = valueBody['data'][0]['place'];

  //         List filter = [];
  //         for (var element in valueBody['data']) {
  //           if (element['isFilterView'] == 1) {
  //             element['is_selected'] = false;
  //             filter.add(element);
  //           }
  //         }

  //         print("data ${placeCoordinate.value}");

  //         placeCoordinateCheckout.value = filter;
  //         placeCoordinateCheckout.refresh();
  //         placeCoordinateCheckout.refresh();
  //       } else {
  //         print("Place cordinate !=200" + res.body.toString());
  //         print(res.body.toString());
  //       }
  //     }
  //   });
  // }

  // void filterAbsenTelat() {
  //   var tanggal = DateFormat('yyyy-MM-dd').format(pilihTanggalTelatAbsen.value);
  //   getDepartemen(2, tanggal);
  // }

  // void filterBelumAbsen() {
  //   var tanggal = DateFormat('yyyy-MM-dd').format(pilihTanggalTelatAbsen.value);
  //   getDepartemen(3, tanggal);
  // }

  void aksiEmployeeTerlambatAbsen(tanggal) {
    statusLoadingSubmitLaporan.value = true;
    print(idDepartemenTerpilih.value);
    listLaporanFilter.value.clear();
    Map<String, dynamic> body = {
      'atten_date': tanggal,
      'status': idDepartemenTerpilih.value
    };
    var connect =
        Api.connectionApi("post", body, "load_laporan_absensi_harian_telat");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        if (valueBody['status'] == false) {
          statusLoadingSubmitLaporan.value = false;
          UtilsAlert.showToast(
              "Data periode $bulanSelectedSearchHistory belum tersedia, harap hubungi HRD");
        } else {
          var data = valueBody['data'];
          print("data ${data}");
          loading.value =
              data.length == 0 ? "Data tidak tersedia" : "Memuat data...";
          var seen = Set<String>();
          List filter =
              data.where((country) => seen.add(country['full_name'])).toList();

          print(filter);
          List filterTelat = [];
          for (var element in filter) {
            if (!element['selisih'].toString().contains('-')) {
              var tempData = element['selisih'].toString().substring(0);
              var listJam = element['selisih'].split(':');
              var getJamMenit = "${listJam[0]}${listJam[1]}";
              var jamMasukEmployee = int.parse(getJamMenit);
              print("${element['batas_toleransi']} ${jamMasukEmployee}");
              if (jamMasukEmployee >
                  int.parse(element['batas_toleransi'] == null ||
                          element['batas_toleransi'] == "" ||
                          element['batas_toleransi'] == "null"
                      ? "0"
                      : element['batas_toleransi'].toString())) {
                element['status'] = 1;
              } else {
                element['status'] = 0;
              }
              filterTelat.add(element);
            }

            // if (hitung > 0) {
            //   filterTelat.add(element);
            // }
          }
          // filterTelat.sort((a, b) => a['full_name']
          //     .toUpperCase()
          //     .compareTo(b['full_name'].toUpperCase()));
          jumlahData.value = filterTelat.length;
          listEmployeeTelat.value = filterTelat;
          alllistEmployeeTelat.value = filterTelat;
          this.jumlahData.refresh();
          this.listEmployeeTelat.refresh();
          this.alllistEmployeeTelat.refresh();
          statusLoadingSubmitLaporan.value = false;
          this.statusLoadingSubmitLaporan.refresh();
          if (listEmployeeTelat.isEmpty) {
            loading.value = "Data tidak tersedia";
          } else {
            loading.value = "Memuat Data...";
          }
          this.loading.refresh();
        }
      }
    });
  }

  void aksiEmployeeBelumAbsen(tanggal) {
    print(idDepartemenTerpilih);
    statusLoadingSubmitLaporan.value = true;
    listLaporanBelumAbsen.value.clear();
    Map<String, dynamic> body = {
      // 'atten_date': '2022-12-05',
      'atten_date': tanggal,
      // 'status': "0"
      'status': idDepartemenTerpilih.value
    };
    var connect = Api.connectionApi("post", body, "load_laporan_belum_absen");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        if (valueBody['status'] == false) {
          statusLoadingSubmitLaporan.value = false;
          UtilsAlert.showToast(
              "Data periode $bulanSelectedSearchHistory belum tersedia, harap hubungi HRD");
        } else {
          List data = valueBody['data'];

          data.sort((a, b) => a['full_name']
              .toUpperCase()
              .compareTo(b['full_name'].toUpperCase()));

          print("data belum absen ${data}");

          jumlahData.value = valueBody['jumlah'];
          listLaporanBelumAbsen.value = data;
          allListLaporanBelumAbsen.value = data;
          this.jumlahData.refresh();
          this.listLaporanBelumAbsen.refresh();
          this.allListLaporanBelumAbsen.refresh();

          if (listLaporanBelumAbsen.isEmpty) {
            loading.value = "Data tidak tersedia";
          } else {
            loading.value = "Memuat Data...";
          }
          statusLoadingSubmitLaporan.value = false;
          this.statusLoadingSubmitLaporan.refresh();
          this.loading.refresh();
        }
      }
    });
  }

  // void removeAll() {
  //   fotoUser.value = File("");
  //   base64fotoUser.value = "";
  //   timeString.value = "";
  //   dateNow.value = "";
  //   alamatUserFoto.value = "";
  //   alamatUserFoto.value = "";

  //   latUser.value = 0.0;
  //   langUser.value = 0.0;

  //   imageStatus.value = false;

  //   deskripsiAbsen.clear();
  //   rhistoryAbsen.value.clear();
  // }

  void absenSelfie() async {
    // DateTime startDate = await NTP.now();
    DateTime startDate = DateTime.now();
    // // absenSelfie();
    timeString.value = formatDateTime(startDate);
    dateNow.value = dateNoww(DateTime.now());
    tanggalUserFoto.value = dateNoww2(startDate);
    imageStatus.refresh();
    timeString.refresh();
    dateNow.refresh();
    getPosisition();

    // Get.to(AbsenMasukKeluar(
    //   status: status,
    //   type: type.toString(),
    // ));
    gagalAbsen.value = 0;
    // // final getFoto = await ImagePicker().pickImage(
    // //     source: ImageSource.camera,
    // //     preferredCameraDevice: CameraDevice.front,
    // //     imageQuality: 100,
    // //     maxHeight: 350,
    // //     maxWidth: 350);
    // // if (getFoto == null) {
    // //   UtilsAlert.showToast("Gagal mengambil gambar");
    // // } else {
    // // fotoUser.value = File(getFoto.path);
    // // var bytes = File(getFoto.path).readAsBytesSync();
    // // base64fotoUser.value = base64Encode(bytes);
    // timeString.value = formatDateTime(DateTime.now());
    // dateNow.value = dateNoww(DateTime.now());
    // imageStatus.value = true;
    // tanggalUserFoto.value = dateNoww2(DateTime.now());
    // this.imageStatus.refresh();
    // this.timeString.refresh();
    // this.dateNow.refresh();
    // // this.base64fotoUser.refresh();
    // // this.fotoUser.refresh();
    // getPosisition();
    // // }
    // Get.to(AbsenMasukKeluar());
  }

  // void facedDetection({
  //   required status,
  //   absenStatus,
  //   type,
  // }) async {
  //   // if (takePicturer == "0") {
  //   //   if (status == "registration") {
  //   //     print("registration");
  //   //     saveFaceregistration(img);
  //   //   } else {
  //   //     detection(file: img, status: absenStatus, type: type);
  //   //   }
  //   // } else {
  //   //  Get.back();
  //   final getFoto = await ImagePicker().pickImage(
  //     source: ImageSource.camera,
  //     preferredCameraDevice: CameraDevice.front,
  //   );
  //   // var bytes = File(getFoto.path).readAsBytesSync();
  //   // base64fotoUser.value = base64Encode(bytes);
  //   if (getFoto == null) {
  //     UtilsAlert.showToast("Gagal mengambil gambar");
  //   } else {
  //     print(getFoto.path);
  //     // fotoUser.value = File(getFoto.toString());
  //     if (status == "registration") {
  //       print("registration");

  //       saveFaceregistration(getFoto.path);
  //     } else {
  //       detection(file: getFoto.path, status: absenStatus, type: type);
  //     }
  //   }
  //   // }
  // }

  //  void facedDetection({
  //   required status,
  //   absenStatus,
  //   type,
  // }) async {
  //   // if (takePicturer == "0") {
  //   //   if (status == "registration") {
  //   //     print("registration");
  //   //     saveFaceregistration(img);
  //   //   } else {
  //   //     detection(file: img, status: absenStatus, type: type);
  //   //   }
  //   // } else {
  //   //  Get.back();
  //   final getFoto = await ImagePicker().pickImage(
  //     source: ImageSource.camera,
  //     preferredCameraDevice: CameraDevice.front,
  //   );
  //   // var bytes = File(getFoto.path).readAsBytesSync();
  //   // base64fotoUser.value = base64Encode(bytes);
  //   if (getFoto == null) {
  //     UtilsAlert.showToast("Gagal mengambil gambar");
  //   } else {
  //     print(getFoto.path);
  //     // fotoUser.value = File(getFoto.toString());
  //     if (status == "registration") {
  //       print("registration");

  //       saveFaceregistration(getFoto.path);
  //     } else {
  //       detection(file: getFoto.path, status: absenStatus, type: type);
  //     }
  //   }
  //   // }
  // }

  // void facedDetection({required status, absenStatus, type, img}) async {
  //   if (status == "registration") {
  //     saveFaceregistration(img);
  //   } else {
  //     detection(file: img, status: absenStatus, type: type);
  //   }
  // }

  // void saveFaceregistration(file) async {
  //   UtilsAlert.showLoadingIndicator(Get.context!);

  //   final box = GetStorage();
  //   File image = new File(file); // Or any other way to get a File instance.
  //   var decodedImage = await decodeImageFromList(image.readAsBytesSync());
  //   Map<String, String> headers = {
  //     'Authorization': Api.basicAuth,
  //     'Content-type': 'application/json',
  //     'Accept': 'application/json',
  //     'token': Api.token,
  //     // 'em_id':AppData.informasiUser==null || AppData.informasiUser=="null" || AppData.informasiUser=="" || AppData.informasiUser!.isEmpty ?"":AppData.informasiUser![0].em_id
  //   };

  //   var request = http.MultipartRequest(
  //     "POST",
  //     Uri.parse(Api.luxand),
  //   );
  //   request.headers.addAll(headers);
  //   File file1 = await urlToFile(
  //       "${Api.urlImage}/${AppData.selectedDatabase}/face_recog/${GetStorage().read('file_face')}");

  //   var picture = await http.MultipartFile.fromPath('face1', file.toString(),
  //       contentType: MediaType('image', 'png'));
  //   var picture1 = await http.MultipartFile.fromPath('face2', file.toString(),
  //       contentType: MediaType('image', 'png'));
  //   request.files.add(picture);
  //   request.files.add(picture1);

  //   var response = await request.send();
  //   final respStr = await response.stream.bytesToString();
  //   final res = jsonDecode(respStr.toString());
  //   print(res);

  //   if (res['similar'] == true) {
  //     try {
  //       var dataUser = AppData.informasiUser;
  //       var getEmpId = dataUser![0].em_id;
  //       Map<String, String> headers = {
  //         'Authorization': Api.basicAuth,
  //         'Content-type': 'application/json',
  //         'Accept': 'application/json',
  //         'token': AppData.setFcmToken,
  //         'em_id': AppData.informasiUser == null ||
  //                 AppData.informasiUser == "null" ||
  //                 AppData.informasiUser == "" ||
  //                 AppData.informasiUser!.isEmpty
  //             ? ""
  //             : AppData.informasiUser![0].em_id
  //       };
  //       Map<String, String> body = {
  //         'em_id': getEmpId.toString(),
  //         'width': decodedImage.width.toString(),
  //         'height': decodedImage.height.toString()
  //       };
  //       var request = http.MultipartRequest(
  //         "POST",
  //         Uri.parse(Api.basicUrl +
  //             "edit_face?database=${AppData.selectedDatabase.toString()}"),
  //       );
  //       request.fields.addAll(body);
  //       request.headers.addAll(headers);
  //       // if (fotoUser.value != null) {
  //       var picture = await http.MultipartFile.fromPath('file', file.toString(),
  //           contentType: MediaType('image', 'png'));
  //       request.files.add(picture);
  //       // }
  //       var response = await request.send();
  //       final respStr = await response.stream.bytesToString();
  //       final res = jsonDecode(respStr.toString());

  //       if (res['status'] == true) {
  //         Get.back();
  //         employeDetail();
  //         box.write("face_recog", true);
  //         gagalAbsen.value = gagalAbsen.value;

  //         // Get.back();
  //         Navigator.push(
  //           Get.context!,
  //           MaterialPageRoute(builder: (context) => BerhasilRegistration()),
  //         );
  //       } else {
  //         // Get.back();
  //         UtilsAlert.showToast(res['message']);
  //       }
  //     } on Exception catch (e) {
  //       print(e.toString());
  //       Get.back();
  //       UtilsAlert.showToast(e.toString());
  //       throw e;
  //     }
  //   } else {
  //     Get.back();
  //     UtilsAlert.showToast(res['message']);
  //   }
  // }

  // void detection({file, type, status}) async {
  //   employeDetail();
  //   var bytes = File(file).readAsBytesSync();
  //   base64fotoUser.value = base64Encode(bytes);
  //   Future.delayed(const Duration(milliseconds: 500), () {});
  //   File image = new File(file); // Or any other way to get a File instance.
  //   var decodedImage = await decodeImageFromList(image.readAsBytesSync());

  //   try {
  //     var dataUser = AppData.informasiUser;
  //     var getEmpId = dataUser![0].em_id;

  //     Map<String, String> body = {
  //       'em_id': getEmpId.toString(),
  //       'width': decodedImage.width.toString(),
  //       'height': decodedImage.height.toString(),

  //       // 'image': file.toString()
  //     };
  //     Map<String, String> headers = {
  //       'Authorization': Api.basicAuth,
  //       'Content-type': 'application/json',
  //       'Accept': 'application/json',
  //       'token': Api.token,
  //       //    'token': AppData.setFcmToken,
  //       // 'em_id':AppData.informasiUser==null || AppData.informasiUser=="null" || AppData.informasiUser=="" || AppData.informasiUser!.isEmpty ?"":AppData.informasiUser![0].em_id
  //     };
  //     var request = http.MultipartRequest(
  //       "POST",
  //       Uri.parse(Api.luxand),
  //     );

  //     request.headers.addAll(headers);
  //     File file1 = await urlToFile(
  //         "${Api.urlImage}/${AppData.selectedDatabase}/face_recog/${GetStorage().read('file_face')}");

  //     // if (fotoUser.value != null) {
  //     var picture = await http.MultipartFile.fromPath('face1', file,
  //         contentType: MediaType('image', 'png'));
  //     var picture1 = await http.MultipartFile.fromPath('face2', file1.path,
  //         contentType: MediaType('image', 'png'));
  //     request.files.add(picture);
  //     request.files.add(picture1);
  //     //  }
  //     var response = await request.send();
  //     final respStr = await response.stream.bytesToString();
  //     final res = jsonDecode(respStr.toString());

  //     if (response.statusCode == 200) {
  //       if (res['similar'] == true) {
  //         absenSuccess.value = "1";

  //         // DateTime startDate = await NTP.now();
  //         DateTime startDate = DateTime.now();

  //         // // absenSelfie();
  //         timeString.value = formatDateTime(startDate);
  //         dateNow.value = dateNoww(startDate);
  //         tanggalUserFoto.value = dateNoww2(startDate);
  //         imageStatus.refresh();
  //         timeString.refresh();
  //         dateNow.refresh();
  //         getPosisition();

  //         // Get.to(AbsenMasukKeluar(
  //         //   status: status,
  //         //   type: type.toString(),
  //         // ));

  //         gagalAbsen.value = 0;

  //         // Navigator.push(
  //         //   Get.context!,
  //         //   MaterialPageRoute(
  //         //       builder: (context) => AbsenMasukKeluar(
  //         //             status: status,
  //         //             // type: type.toString(),
  //         //           )),
  //         // );

  //         // UtilsAlert.showToast(res['message']);
  //       } else {
  //         absenSuccess.value = "2";

  //         gagalAbsen.value = gagalAbsen.value + 1;

  //         // UtilsAlert.showToast(res['message']);
  //         // print("status ${titleAbsen.value}");
  //         // if (gagalAbsen.value >= 3) {
  //         //   Get.back();
  //         //   Get.to(AbsenVrifyPassword(
  //         //     status: status,
  //         //     type: type.toString(),
  //         //   ));
  //         // } else {
  //         //   Get.back();
  //         //   Get.back();
  //         //   print("titleAbsen.value");

  //         //   // facedDetection(
  //         //   //   absenStatus: status,
  //         //   //   status: "detection",
  //         //   //   type: type.toString(),
  //         //   // );
  //         //   // Get.to(FaceDetectorView(
  //         //   //   status: status == "masuk" ? "masuk" : "keluar",
  //         //   // ));
  //         // }
  //       }
  //     } else {}
  //   } on Exception catch (e) {
  //     print(e.toString());
  //     Get.back();
  //     UtilsAlert.showToast(e.toString());
  //     throw e;
  //   }
  // }

//   Future<File> urlToFile(String imageUrl) async {
// // generate random number.
//     var rng = new Random();
// // get temporary directory of device.
//     Directory tempDir = await getTemporaryDirectory();
// // get temporary path from temporary directory.
//     String tempPath = tempDir.path;
// // create a new file in temporary path with random file name.
//     File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
// // call http.get method and pass imageUrl into it to get response.
//     http.Response response = await http.get(Uri.parse(imageUrl));
// // write bodyBytes received in response to file.
//     await file.writeAsBytes(response.bodyBytes);
// // now return the file which is created with random name in
// // temporary directory and image bytes from response is written to // that file.
//     return file;
//   }

  String formatDateTime(DateTime dateTime) {
    return DateFormat('HH:mm:ss').format(dateTime);
  }

  String dateNoww(DateTime dateTime) {
    var hari = DateFormat('EEEE').format(dateTime);
    var convertHari = Constanst.hariIndo(hari);
    var tanggal = DateFormat('dd MMMM yyyy').format(dateTime);
    return "$convertHari, $tanggal";
  }

  String dateNoww2(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  void getPosisition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      print("lokasi ${place}");
      latUser.value = position.latitude;
      langUser.value = position.longitude;
      alamatUserFoto.value =
          "${placemarks[0].street} ${placemarks[0].name}, ${placemarks[0].subLocality}, ${placemarks[0].locality}, ${placemarks[0].subAdministrativeArea}, ${placemarks[0].administrativeArea}, ${placemarks[0].postalCode}";
      this.latUser.refresh();
      this.langUser.refresh();
      this.alamatUserFoto.refresh();
    } on Exception catch (e) {
      print(e);
    }
  }

  // void alamat(String latitude, String longitude) async {
  //   List<Placemark> placemarks = await placemarkFromCoordinates(
  //       double.parse(latitude),
  //       double.parse(longitude)); // Placemark place = placemarks[0];
  //   // print(place);
  //   // latUser.value = position.latitude;
  //   // langUser.value = position.longitude;
  //   var address1 =
  //       "${placemarks[0].street} ${placemarks[0].name}, ${placemarks[0].subLocality}, ${placemarks[0].locality}, ${placemarks[0].subAdministrativeArea}, ${placemarks[0].administrativeArea}, ${placemarks[0].postalCode}";
  //   print("Alamat kirim ${address1}");
  // }

  // void alamat(String latitude, String longitude) async {
  //   List<Placemark> placemarks = await placemarkFromCoordinates(
  //       double.parse(latitude), double.parse(longitude));

  //   var address =
  //       "${placemarks[0].street} ${placemarks[0].name}, ${placemarks[0].subLocality}, ${placemarks[0].locality}, ${placemarks[0].subAdministrativeArea}, ${placemarks[0].administrativeArea}, ${placemarks[0].postalCode}";
  //   print("Alamat kirim ${address}");

  //   Map<String, dynamic> parameter = {
  //     'tanggal': DateFormat('yyyy-MM-dd').format(DateTime.now()),
  //     // 'em_id': AppData.informasiUser == null || AppData.informasiUser!.isEmpty
  //     //     ? ''
  //     //     : AppData.informasiUser![0].em_id,

  //     'em_id': 'SIS202307054',
  //     'waktu': DateFormat('HH:mm').format(DateTime.now()),
  //     'longitude': longitude,
  //     "latitude": latitude,
  //     'alamat': address
  //   };
  //   print('parameter ${parameter}');

  //   final response = await http.post(
  //     Uri.parse('${Api.basicUrl}employee-tracking-insert'),
  //     body: jsonEncode(parameter),
  //     // headers: headers
  //   );
  //   print('parameter ${response}');
  //   if (response.statusCode == 200) {
  //     var data = jsonDecode(response.body);

  //     // Get.back();

  //     // print("body " + jsonDecode(response.body.toString()).toString());
  //     // Get.to(BerhasilRegistration());
  //   }
  //   print('parameter ${jsonDecode(response.body).toString()}');
  //   // var connect =
  //   //     Api.connectionApi("post", parameter, "employee-tracking-insert");
  //   // connect.then((dynamic res) {
  //   //   if (res.statusCode == 200) {
  //   //     var valueBody = jsonDecode(res.body);
  //   //     List data = valueBody['data'];
  //   //     print('data kirim ${data}');
  //   //     // if (data.isNotEmpty) {
  //   //     //   checkinAjuan.value = data[0]['signin_time'];
  //   //     //   checkoutAjuan.value = data[0]['signout_time'];
  //   //     // } else {}
  //   //   }
  //   // });
  // }

  Future<void> tracking(String latitude, String longitude) async {
    print("Masuk Sini tracking");
    final prefs = await SharedPreferences.getInstance();
    var emId = prefs.getString('em_id');
    var database = prefs.getString('dbname');

    List<String>? listData = prefs.getStringList('informasiUser') ?? [];
    List<UserModel> userModel =
        listData.map((e) => UserModel.fromMap(jsonDecode(e))).toList();

    //List<String> listData = LocalStorage.getFromDisk('informasiUser');

    //  static List<UserModel>? get informasiUser {
    //   if (LocalStorage.getFromDisk('informasiUser') != null) {
    //     List<String> listData = LocalStorage.getFromDisk('informasiUser');
    //     return listData.map((e) => UserModel.fromMap(jsonDecode(e))).toList();
    //   }
    //   return null;
    // }

    print("dbname new ${prefs.getString('selectedDatabase')}");

    print(
        "emId App Data ${AppData.informasiUser == null || AppData.informasiUser!.isEmpty ? '' : AppData.informasiUser![0].em_id}");

    print("dbname AppData ${AppData.selectedDatabase}");

    // print("informasiUser  ");
    // print("informasiUser ${AppData.informasiUser![0].em_id}");
    List<Placemark> placemarks = await placemarkFromCoordinates(
        double.parse(latitude), double.parse(longitude));

    var address =
        "${placemarks[0].street} ${placemarks[0].name}, ${placemarks[0].subLocality}, ${placemarks[0].locality}, ${placemarks[0].subAdministrativeArea}, ${placemarks[0].administrativeArea}, ${placemarks[0].postalCode}";
    print("Alamat kirim ${address}");

    Map<String, dynamic> body = {
      'tanggal': DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
      'em_id': "${userModel.isNotEmpty ? userModel[0].em_id : "tidak dapat"}",

      // 'em_id':
      //     AppData.informasiUser!.isEmpty ? '' : AppData.informasiUser![0].em_id,
      'waktu': DateFormat('HH:mm').format(DateTime.now()).toString(),
      'longitude': longitude.toString(),
      "latitude": latitude.toString(),
      'alamat': address.toString(),
      'database': prefs.getString('selectedDatabase'),
    };
    print('parameter 1111 ${body}');

    try {
      var response =
          await ApiRequest(url: "employee-tracking-insert", body: body).post();
      print('parameter ${response}');
      var resp = jsonDecode(response.body);

      print('parameter ${resp}');

      if (response.statusCode == 200) {
      } else {}
      // Get.back();
    } catch (e) {
      print(e);
      // Get.back();
    }
  }

  Future<void> startService(int interval) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? listData = prefs.getStringList('informasiUser') ?? [];
    List<UserModel> userModel =
        listData.map((e) => UserModel.fromMap(jsonDecode(e))).toList();

    var apiUrl =
        await ApiRequest(url: "employee-tracking-insert").sringApiPost();
    print("apiUrl: $apiUrl");
    try {
      await platform.invokeMethod('startService', {
        'interval': interval,
        'apiUrl': apiUrl.toString(),
        'emId': userModel.isNotEmpty
            ? userModel[0].em_id.toString()
            : "tidak dapat",
        'database': prefs.getString('selectedDatabase').toString(),
        'basicAuth': ApiRequest.basicAuth.toString(),
      });
    } on PlatformException catch (e) {
      print("Failed to start service: '${e.message}'.");
    }
  }

  Future<void> stopService() async {
    try {
      await platform.invokeMethod('stopService');
    } on PlatformException catch (e) {
      print("Failed to stop service: '${e.message}'.");
    }
  }

  // Future<void> handleLocationUpdates(MethodCall call) async {
  //   print("dapat disini");
  //   if (call.method == "sendLocation") {
  //     print("dapat disini");
  //     var latitude = call.arguments['latitude'].toString();
  //     var longitude = call.arguments['longitude'].toString();
  //     tracking(latitude, longitude);
  //   }
  // }

  Future<void> refreshPage() async {
    detailTrackings.clear();
    refreshController.resetNoData();
    offset.value = 0;
    limit.value = 10;
    hasMore.value = true;
    detailTracking(emIdEmployee: '');
    refreshController.refreshCompleted();
  }

  Future<void> loadNextPage() async {
    if (hasMore.value == true) {
      offset.value += limit.value;
      detailTracking(emIdEmployee: '');
      refreshController.loadComplete();
    } else {
      refreshController.loadNoData();
    }
  }

  void detailTracking({tanggal, emIdEmployee}) async {
    // if (isLoadingDetailTracking.value || !hasMore.value) return;

    // isLoadingDetailTracking.value = true;
    // print("haha: offset=${offset.value}&limit=${limit.value}");

    Map<String, dynamic> body = {
      'tanggal':
          tanggal ?? DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
      'em_id_employee': emIdEmployee == ''
          ? AppData.informasiUser == null || AppData.informasiUser!.isEmpty
              ? ''
              : AppData.informasiUser![0].em_id
          : emIdEmployee,
      'database': AppData.selectedDatabase,
    };

    try {
      var connect = Api.connectionApi("post", body, "employee-tracking-detail",
          params: "&offset=${offset.value}&limit=${limit.value}");
      connect.then((dynamic res) {
        if (res.statusCode == 200) {
          var resp = jsonDecode(res.body);
          var newItems = DetailTrackingModel.fromJsonToList(resp['data']);
          if (newItems.isEmpty) {
            print("yo kesini");
            hasMore.value = false;
          }
          print("pajang: ${newItems.length}");
          detailTrackings.addAll(newItems);
          // detailTrackings.value = detailTrackings.reversed.toList();

          // isLoadingDetailTracking.value = false;
          isMapsDetail.value = true;
        } else {
          hasMore.value = false;
          // isLoadingDetailTracking.value = false;
        }
      });
    } catch (e) {
      print(e);
      isLoadingDetailTracking.value = false;
    }
  }

  void detailTracking2({tanggal, emIdEmployee}) async {
    // detailTrackings.value = DetailTrackingModel.fromJsonToList([]);
    // isLoadingDetailTracking.value = true;

    isLoadingDetailTracking2.value = true;
    isLoadingDetailTracking3.value = true;

    Map<String, dynamic> body = {
      'tanggal':
          tanggal ?? DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
      'em_id_employee': emIdEmployee == ''
          ? AppData.informasiUser == null || AppData.informasiUser!.isEmpty
              ? ''
              : AppData.informasiUser![0].em_id
          : emIdEmployee,
      // 'em_id_employee': 'SIS202305048',
      'database': AppData.selectedDatabase,
    };
    print('parameter 24 ${body}');
    try {
      var response =
          await ApiRequest(url: "employee-tracking-detail", body: body).post();
      print('parameter ${response}');
      var resp = jsonDecode(response.body);

      print('parameter 25 ${resp}');

      if (response.statusCode == 200) {
        print('parameter 26 ${resp}');

        detailTrackings2.value =
            DetailTrackingModel.fromJsonToList(resp['data']);
        detailTrackings2.value = detailTrackings2.reversed.toList();
        isLoadingDetailTracking2.value = false;
        isLoadingDetailTracking3.value = false;
        isMapsDetail.value = true;
      } else {
        detailTrackings2.value = [];
        isLoadingDetailTracking2.value = false;
        isLoadingDetailTracking3.value = false;
      }
      // Get.back();
    } catch (e) {
      print(e);
      detailTrackings2.value = [];
      isLoadingDetailTracking2.value = false;
      isLoadingDetailTracking3.value = false;
    }
  }

  void lokasi({tanggal, emIdEmployee}) async {
    // detailTrackings.value = DetailTrackingModel.fromJsonToList([]);
    // isLoadingDetailTracking.value = true;

    isLoadingDetailTracking2.value = true;
    // isLoadingDetailTracking3.value = true;

    Map<String, dynamic> body = {
      'tanggal':
          tanggal ?? DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
      'em_id_employee': emIdEmployee == ''
          ? AppData.informasiUser == null || AppData.informasiUser!.isEmpty
              ? ''
              : AppData.informasiUser![0].em_id
          : emIdEmployee,
      // 'em_id_employee': 'SIS202305048',
      'database': AppData.selectedDatabase,
    };
    print('parameter 27 ${body}');
    try {
      var response =
          await ApiRequest(url: "employee-tracking-detail", body: body).post();
      print('parameter ${response}');
      var resp = jsonDecode(response.body);

      print('parameter 28 ${resp}');

      if (response.statusCode == 200) {
        print('parameter 29 ${resp}');

        detailTrackings2.value =
            DetailTrackingModel.fromJsonToList(resp['data']);
        detailTrackings2.value = detailTrackings2.reversed.toList();
        isLoadingDetailTracking2.value = false;
        // isLoadingDetailTracking3.value = false;
        isMapsDetail.value = true;
      } else {
        detailTrackings2.value = [];
        isLoadingDetailTracking2.value = false;
        // isLoadingDetailTracking3.value = false;
      }
      // Get.back();
    } catch (e) {
      print(e);
      detailTrackings2.value = [];
      isLoadingDetailTracking2.value = false;
      // isLoadingDetailTracking3.value = false;
    }
  }

  void riwayatLiveTracking({emIdEmployee}) async {
    isLoadingRiwayatLiveTracking.value = true;
    print(
        "em_id_employee new ${tahunSelectedSearchHistory.value + "-" + bulanSelectedSearchHistory.value.toString().padLeft(2, '0') + "-" + "01"}");
    Map<String, dynamic> body = {
      'tanggal': DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(
              "${tahunSelectedSearchHistory.value + "-" + bulanSelectedSearchHistory.value.toString().padLeft(2, '0') + "-" + "01"}"))
          .toString(),
      'em_id_employee': emIdEmployee,
      // 'em_id_employee': 'SIS202305048',
      'database': AppData.selectedDatabase,
    };
    print('body  ${body}');

    try {
      var response =
          await ApiRequest(url: "employee-tracking-history", body: body).post();
      print('parameter ${response}');
      var resp = jsonDecode(response.body);

      print('parameter 30 ${resp}');

      if (response.statusCode == 200) {
        print('parameter 2${resp}');

        riwayatLiveTrackings.value =
            RiwayatLiveTrackingModel.fromJsonToList(resp['data']);
        riwayatLiveTrackings.value = riwayatLiveTrackings.reversed.toList();
        isLoadingRiwayatLiveTracking.value = false;
      } else {
        riwayatLiveTrackings.value = [];
        isLoadingRiwayatLiveTracking.value = false;
      }
      // Get.back();
    } catch (e) {
      print(e);
      riwayatLiveTrackings.value = [];
      isLoadingRiwayatLiveTracking.value = false;
    }
  }

  void trackingList({tanggal}) async {
    isLoadingTrackingList.value = true;
    // trackingLists.value = [];
    Map<String, dynamic> body = {
      'date':
          tanggal ?? DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
      // 'date': '2024-01-01',
      'em_id': AppData.informasiUser == null || AppData.informasiUser!.isEmpty
          ? ''
          : AppData.informasiUser![0].em_id,
      // 'em_id': 'SIS202305048',

      // 'database': 'demohr',
    };
    print('parameter 4 new ${body}');

    try {
      var response =
          await ApiRequest(url: "employee-tracking", body: body).post();
      print('parameter ${response}');
      var resp = jsonDecode(response.body);

      print('parameter 234  ${resp}');

      if (response.statusCode == 200) {
        print('parameter 23${resp}');

        trackingLists.value = TrackingListModel.fromJsonToList(resp['data']);
        trackingLists.value = trackingLists.reversed.toList();
        isLoadingTrackingList.value = false;
      } else {
        trackingLists.value = [];
        isLoadingTrackingList.value = false;
      }
      // Get.back();
    } catch (e) {
      print(e);
      trackingLists.value = [];
      isLoadingTrackingList.value = false;
    }
  }

  Future<void> updateStatus(String status) async {
    Map<String, dynamic> body = {
      // 'tanggal': DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
      // 'em_id': AppData.informasiUser == null || AppData.informasiUser!.isEmpty
      //     ? ''
      //     : AppData.informasiUser![0].em_id,

      'em_id': AppData.informasiUser![0].em_id,
      'status': status,
      // 'waktu': DateFormat('HH:mm').format(DateTime.now()).toString(),
      // 'longitude': longitude.toString(),
      // "latitude": latitude.toString(),
      // 'alamat': address.toString(),
      // 'database': AppData.selectedDatabase,
    };
    print('parameter updateStatus ${body}');

    try {
      var response =
          await ApiRequest(url: "employee-tracking-update", body: body).post();
      print('parameter ${response}');
      var resp = jsonDecode(response.body);

      print('parameter updateStatus ${resp}');

      if (response.statusCode == 200) {
      } else {}
      // Get.back();
    } catch (e) {
      print(e);
      // Get.back();
    }
  }

  Future<void> isTracking() async {
    // final service = FlutterBackgroundService();
    final prefs = await SharedPreferences.getInstance();
    print("isTracking new new new ${AppData.informasiUser![0].is_tracking}");
    if (AppData.informasiUser![0].is_tracking.toString() == "1") {
      bagikanlokasi.value = "aktif";

      isTrackingLokasi.value = true;

      updateStatus('1');

      // detailTracking(emIdEmployee: '');

      // AppData.informasiUser![0].is_tracking = "1";
      // controllerDashboard.updateInformasiUser();

      // var isRunning = await service.isRunning();

      // Timer.periodic(const Duration(seconds: 1), (timer) async {
      // service.startService();
      var interval = prefs.getString('interval_tracking');
      var intervalMilliseconds = int.parse(interval!) * 60000;
      // startService(intervalMilliseconds);

      print("dapatttt is_tracking ${AppData.informasiUser![0].is_tracking}");
      print('hidup');
      print(interval);
      print(
          "startTracking ${AppData.informasiUser![0].isViewTracking.toString()}");
    } else {
      bagikanlokasi.value = "tidak aktif";

      isTrackingLokasi.value = false;
      // await LocationDao().clear();R
      // await _getLocations();
      // await BackgroundLocationTrackerManager.stopTracking();
      // updateStatus('0');

      updateStatus('0');

      // AppData.informasiUser![0].is_tracking = "0";
      // controllerDashboard.updateInformasiUser();

      //   final service = FlutterBackgroundService();
      //  // var isRunning = await service.isRunning();

      // service.invoke("stopService");
      // stopService();

      print("dapatttt is_tracking ${AppData.informasiUser![0].is_tracking}");
      print(
          "stopTracking ${AppData.informasiUser![0].isViewTracking.toString()}");
    }
  }
  // Future<String> getAddressFromLatLng(double lat, double lng) async {
  //   final apiKey = 'AIzaSyCjde4QH5ewSM01qSkvkobtmoFoFFuu1XA';
  //   final apiUrl =
  //       'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey';

  //   final response = await http.get(Uri.parse(apiUrl));

  //   if (response.statusCode == 200) {
  //     final decoded = json.decode(response.body);
  //     final results = decoded['results'];

  //     if (results != null && results.isNotEmpty) {
  //       return results[0]['formatted_address'];
  //     } else {
  //       return 'No address found';
  //     }
  //   } else {
  //     throw Exception('Failed to load address');
  //   }
  // }

  // void ulangiFoto() {
  //   imageStatus.value = false;
  //   fotoUser.value = File("");
  //   base64fotoUser.value = "";
  //   alamatUserFoto.value = "";
  //   absenSelfie();
  // }

  // void kirimDataAbsensi() async {
  //   employeDetail();
  //   // if (base64fotoUser.value == "") {
  //   //   UtilsAlert.showToast("Silahkan Absen");
  //   // } else {
  //   if (Platform.isAndroid) {
  //     // TrustLocation.start(1);
  //     getCheckMock();
  //     if (!mockLocation.value) {
  //       var statusPosisi = await validasiRadius();
  //       if (statusPosisi == true) {
  //         var latLangAbsen = "${latUser.value},${langUser.value}";
  //         var dataUser = AppData.informasiUser;
  //         var getEmpId = dataUser![0].em_id;
  //         var getSettingAppSaveImageAbsen = "1";
  //         var validasiGambar =
  //             getSettingAppSaveImageAbsen == "NO" ? "" : base64fotoUser.value;
  //         if (typeAbsen.value == 1) {
  //           absenStatus.value = true;
  //           AppData.statusAbsen = true;
  //           AppData.dateLastAbsen = tanggalUserFoto.value;
  //         } else {
  //           absenStatus.value = false;
  //           AppData.statusAbsen = false;
  //           AppData.dateLastAbsen = tanggalUserFoto.value;
  //         }
  //         Map<String, dynamic> body = {
  //           'em_id': getEmpId,
  //           'tanggal_absen': tanggalUserFoto.value,
  //           'waktu': timeString.value,
  //           // 'gambar': validasiGambar,
  //           'reg_type': regType.value,
  //           'gambar': base64fotoUser.value,
  //           'lokasi': alamatUserFoto.value,
  //           'latLang': latLangAbsen,
  //           'catatan': deskripsiAbsen.value.text,
  //           'typeAbsen': typeAbsen.value,
  //           'place': selectedType.value,
  //           'kategori': "1"
  //         };

  //         var connect = Api.connectionApi("post", body, "kirimAbsen");
  //         connect.then((dynamic res) {
  //           if (res.statusCode == 200) {
  //             var valueBody = jsonDecode(res.body);
  //             print(res.body);
  //             for (var element in sysData.value) {
  //               if (element['kode'] == '006') {
  //                 intervalControl.value = int.parse(element['name']);
  //               }
  //             }
  //             this.intervalControl.refresh();
  //             print("dapat interval ${intervalControl.value}");
  //             // Navigator.pop(Get.context!);
  //             Get.to(BerhasilAbsensi(
  //               dataBerhasil: [
  //                 titleAbsen.value,
  //                 timeString.value,
  //                 typeAbsen.value,
  //                 intervalControl.value
  //               ],
  //             ));
  //           }
  //         });
  //       }
  //     } else {
  //       UtilsAlert.showToast("Periksa GPS anda");
  //     }
  //   } else if (Platform.isIOS) {
  //     var statusPosisi = await validasiRadius();
  //     if (statusPosisi == true) {
  //       var latLangAbsen = "${latUser.value},${langUser.value}";
  //       var dataUser = AppData.informasiUser;
  //       var getEmpId = dataUser![0].em_id;
  //       // var getSettingAppSaveImageAbsen =
  //       //     settingAppInfo.value![0].saveimage_attend;
  //       var getSettingAppSaveImageAbsen = "1";
  //       var validasiGambar =
  //           getSettingAppSaveImageAbsen == "NO" ? "" : base64fotoUser.value;
  //       if (typeAbsen.value == 1) {
  //         absenStatus.value = true;
  //         AppData.statusAbsen = true;
  //         AppData.dateLastAbsen = tanggalUserFoto.value;
  //       } else {
  //         absenStatus.value = false;
  //         AppData.statusAbsen = false;
  //         AppData.dateLastAbsen = tanggalUserFoto.value;
  //       }
  //       Map<String, dynamic> body = {
  //         'em_id': getEmpId,
  //         'tanggal_absen': tanggalUserFoto.value,
  //         'waktu': timeString.value,
  //         // 'gambar': validasiGambar,
  //         'reg_type': regType.value.toString(),
  //         'gambar': base64fotoUser.value,
  //         'lokasi': alamatUserFoto.value,
  //         'latLang': latLangAbsen,
  //         'catatan': deskripsiAbsen.value.text,
  //         'typeAbsen': typeAbsen.value,
  //         'place': selectedType.value,
  //         'kategori': "1"
  //       };

  //       var connect = Api.connectionApi("post", body, "kirimAbsen");
  //       connect.then((dynamic res) {
  //         if (res.statusCode == 200) {
  //           var valueBody = jsonDecode(res.body);
  //           print(res.body);
  //           for (var element in sysData.value) {
  //             if (element['kode'] == '006') {
  //               intervalControl.value = int.parse(element['name']);
  //             }
  //           }
  //           this.intervalControl.refresh();
  //           print("dapat interval ${intervalControl.value}");
  //           Get.back();
  //           Get.offAll(BerhasilAbsensi(
  //             dataBerhasil: [
  //               titleAbsen.value,
  //               timeString.value,
  //               typeAbsen.value,
  //               intervalControl.value
  //             ],
  //           ));
  //         }
  //       });
  //     }
  //   }

  //   //  }
  // }

  // void getCheckMock() async {
  //   try {
  //     // TrustLocation.onChange.listen((values) => getValMock(values));
  //   } on PlatformException catch (e) {
  //     print('PlatformException $e');
  //   }
  // }

  // void getValMock(values) {
  //   print(values);
  //   String _latitude = values.latitude;
  //   String _longitude = values.longitude;
  //   bool _isMockLocation = values.isMockLocation;
  //   // TrustLocation.stop();
  //   mockLocation.value = _isMockLocation;
  //   this.mockLocation.refresh();
  // }

  // Future<bool> validasiRadius() async {
  //   UtilsAlert.showLoadingIndicator(Get.context!);
  //   var from = Point(latUser.value, langUser.value);
  //   print("lat validasi" + latUser.value.toString());
  //   print("long validasi" + langUser.value.toString());
  //   // var from = Point(-6.1716917, 106.7305503);
  //   print("place cordinate value ${placeCoordinate.value}");
  //   var getPlaceTerpilih = placeCoordinate.value
  //       .firstWhere((element) => element['place'] == selectedType.value);

  //   var stringLatLang = "${getPlaceTerpilih['place_longlat']}";
  //   var defaultRadius = "${getPlaceTerpilih['place_radius']}";
  //   if (stringLatLang == "" ||
  //       stringLatLang == null ||
  //       stringLatLang == "null") {
  //     return true;
  //   } else {
  //     var listLatLang = (stringLatLang.split(','));
  //     var latDefault = listLatLang[0];
  //     var langDefault = listLatLang[1];
  //     var to = Point(double.parse(latDefault), double.parse(langDefault));
  //     double distance = SphericalUtils.computeDistanceBetween(from, to);
  //     print('Distance: $distance meters');
  //     var filter = double.parse((distance).toStringAsFixed(0));
  //     if (filter <= double.parse(defaultRadius)) {
  //       return true;
  //     } else {
  //       Navigator.pop(Get.context!);
  //       showGeneralDialog(
  //         barrierDismissible: false,
  //         context: Get.context!,
  //         barrierColor: Colors.black54, // space around dialog
  //         transitionDuration: Duration(milliseconds: 200),
  //         transitionBuilder: (context, a1, a2, child) {
  //           return ScaleTransition(
  //             scale: CurvedAnimation(
  //                 parent: a1,
  //                 curve: Curves.elasticOut,
  //                 reverseCurve: Curves.easeOutCubic),
  //             child: CustomDialog(
  //               title: "Info",
  //               content:
  //                   "Jarak radius untuk melakukan absen adalah $defaultRadius m",
  //               positiveBtnText: "",
  //               negativeBtnText: "OK",
  //               style: 2,
  //               buttonStatus: 2,
  //               positiveBtnPressed: () {},
  //             ),
  //           );
  //         },
  //         pageBuilder: (BuildContext context, Animation animation,
  //             Animation secondaryAnimation) {
  //           return null!;
  //         },
  //       );
  //       return false;
  //     }
  //   }
  // }

  void loadHistoryAbsenUser() {
    historyAbsen.value.clear();

    var dataUser = AppData.informasiUser;

    var getEmpId = dataUser![0].em_id;
    print(getEmpId);
    Map<String, dynamic> body = {
      'em_id': getEmpId,
      'bulan': bulanSelectedSearchHistory.value,
      'tahun': tahunSelectedSearchHistory.value,
    };
    var connect = Api.connectionApi("post", body, "history-attendance");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        if (valueBody['status'] == true) {
          List data = valueBody['data'];
          loading.value =
              data.length == 0 ? "Data tidak ditemukan" : "Memuat data...";
          for (var el in data) {
            historyAbsen.value.add(AbsenModel(
                id: el['id'] ?? "",
                em_id: el['em_id'] ?? "",
                atten_date: el['atten_date'] ?? "",
                signin_time: el['signin_time'] ?? "",
                signout_time: el['signout_time'] ?? "",
                working_hour: el['working_hour'] ?? "",
                place_in: el['place_in'] ?? "",
                place_out: el['place_out'] ?? "",
                absence: el['absence'] ?? "",
                overtime: el['overtime'] ?? "",
                earnleave: el['earnleave'] ?? "",
                status: el['status'] ?? "",
                signin_longlat: el['signin_longlat'] ?? "",
                signout_longlat: el['signout_longlat'] ?? "",
                att_type: el['att_type'] ?? "",
                signin_pict: el['signin_pict'] ?? "",
                signout_pict: el['signout_pict'] ?? "",
                signin_note: el['signin_note'] ?? "",
                signout_note: el['signout_note'] ?? "",
                signin_addr: el['signin_addr'] ?? "",
                signout_addr: el['signout_addr'] ?? "",
                reqType: el['reg_type'] ?? 0,
                atttype: el['atttype'] ?? 0));
          }
          if (historyAbsen.value.length != 0) {
            var listTanggal = [];
            var finalData = [];
            for (var element in historyAbsen.value) {
              listTanggal.add(element.atten_date);
            }
            listTanggal = listTanggal.toSet().toList();
            for (var element in listTanggal) {
              var valueTurunan = [];
              var stringDateAdaTurunan = "";
              for (var element1 in historyAbsen.value) {
                if (element == element1.atten_date) {
                  var dataTurunan = {
                    'id': element1.id,
                    'signin_time': element1.signin_time,
                    'signout_time': element1.signout_time,
                    'atten_date': element1.atten_date,
                    'place_in': element1.place_in,
                    'place_out': element1.place_out,
                    'signin_note': element1.signin_note,
                    'signin_longlat': element1.signin_longlat,
                    'signout_longlat': element1.signout_longlat,
                    'reg_type': element1.reqType
                  };
                  stringDateAdaTurunan = "${element1.atten_date}";
                  valueTurunan.add(dataTurunan);
                }
              }
              List hasilFilter = [];
              List hasilFilterPengajuan = [];
              for (var element1 in valueTurunan) {
                if (element1['place_in'] == 'pengajuan') {
                  hasilFilterPengajuan.add(element1);
                } else {
                  hasilFilter.add(element1);
                }
              }
              List hasilFinalPengajuan = [];
              if (hasilFilterPengajuan.isNotEmpty) {
                var data = hasilFilterPengajuan;
                var seen = Set<String>();
                List filter = data
                    .where((pengajuan) => seen.add(pengajuan['signin_note']))
                    .toList();
                hasilFinalPengajuan = filter;
              }
              List finalAllData = new List.from(hasilFilter)
                ..addAll(hasilFinalPengajuan);

              var lengthTurunan = finalAllData.length == 1 ? false : true;

              if (lengthTurunan == false) {
                var data = {
                  'id': finalAllData[0]['id'],
                  'signin_time': finalAllData[0]['signin_time'],
                  'signout_time': finalAllData[0]['signout_time'],
                  'atten_date': finalAllData[0]['atten_date'],
                  'place_in': finalAllData[0]['place_in'],
                  'place_out': finalAllData[0]['place_out'],
                  'signin_note': finalAllData[0]['signin_note'],
                  'signin_longlat': finalAllData[0]['signin_longlat'],
                  'signout_longlat': finalAllData[0]['signout_longlat'],
                  'reg_type': finalAllData[0]['reg_type'],
                  'view_turunan': lengthTurunan,
                  'turunan': [],
                };
                finalData.add(data);
              } else {
                var data = {
                  'id': "",
                  'signout_time': "",
                  'atten_date': stringDateAdaTurunan,
                  'place_in': "",
                  'place_out': "",
                  'signin_note': "",
                  'signin_longlat': "",
                  'signout_longlat': "",
                  'view_turunan': lengthTurunan,
                  'status_view': false,
                  'turunan': finalAllData,
                };
                stringDateAdaTurunan = "";
                finalData.add(data);
              }
            }
            finalData.sort((a, b) {
              return DateTime.parse(b['atten_date'])
                  .compareTo(DateTime.parse(a['atten_date']));
            });
            historyAbsenShow.value = finalData;
            this.historyAbsenShow.refresh();
          }
          this.historyAbsen.refresh();
        } else {
          loading.value = "Data tidak ditemukan";
        }
      }
    });
  }

  // void showTurunan(tanggal) {
  //   for (var element in historyAbsenShow.value) {
  //     if (element['atten_date'] == tanggal) {
  //       if (element['status_view'] == false) {
  //         element['status_view'] = true;
  //       } else {
  //         element['status_view'] = false;
  //       }
  //     }
  //   }
  //   this.historyAbsenShow.refresh();
  // }

  // void historySelected(id_absen, status) {
  //   if (status == 'history') {
  //     var getSelected =
  //         historyAbsen.value.firstWhere((element) => element.id == id_absen);
  //     // print(getSelected);
  //     Get.to(DetailAbsen(
  //       absenSelected: [getSelected],
  //       status: false,
  //     ));
  //   } else if (status == 'laporan') {
  //     var getSelected = listLaporanFilter.value
  //         .firstWhere((element) => element['id'] == id_absen);
  //     if (getSelected['signin_longlat'] == null ||
  //         getSelected['signin_longlat'] == "") {
  //       UtilsAlert.showToast("Terjadi kesalahan terhadap data absen ini");
  //     } else {
  //       Get.to(DetailAbsen(
  //         absenSelected: [getSelected],
  //         status: true,
  //       ));
  //     }
  //   }
  // }

  // void historySelected1(id_absen, status, index, index1) {
  //   //  print(listLaporanFilter[index]['data'].toList());
  //   var getSelected = listLaporanFilter[index]['data'][index1];
  //   // print(getSelected);

  //   // print(getSelected);
  //   if (getSelected['signin_longlat'] == null ||
  //       getSelected['signin_longlat'] == "") {
  //     UtilsAlert.showToast("Terjadi kesalahan terhadap data absen ini");
  //   } else {
  //     Get.to(DetailAbsen(
  //       absenSelected: [getSelected],
  //       status: true,
  //     ));
  //   }
  // }

  // void loadAbsenDetail(emId, attenDate, fullName) {
  //   print("load detal employee");
  //   Map<String, dynamic> body = {'id_absen': emId, 'atten_date': attenDate};
  //   var connect = Api.connectionApi("post", body, "whereOnce-attendance");
  //   connect.then((dynamic res) {
  //     if (res.statusCode == 200) {
  //       var valueBody = jsonDecode(res.body);
  //       if (valueBody['data'].isNotEmpty) {
  //         //  print(listLaporanFilter[index]['data'].toList());
  //         var getSelected = valueBody['data'][0];

  //         // print(getSelected);
  //         if (getSelected['signin_longlat'] == null ||
  //             getSelected['signin_longlat'] == "") {
  //           UtilsAlert.showToast("Terjadi kesalahan terhadap data absen ini");
  //         } else {
  //           Get.to(DetailAbsen(
  //             absenSelected: [getSelected],
  //             status: true,
  //             fullName: fullName,
  //           ));
  //         }
  //         // absenModel.value = AbsenModel.fromMap(valueBody);
  //       } else {}
  //     }
  //   });
  // }

  // showDetailImage() {
  //   showDialog(
  //     context: Get.context!,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.all(Radius.circular(15.0))),
  //           content: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 SizedBox(height: 15),
  //                 Image.network(
  //                   Api.UrlfotoAbsen + stringImageSelected.value,
  //                   loadingBuilder: (context, child, loadingProgress) {
  //                     if (loadingProgress == null) return child;
  //                     return Center(
  //                       child: CircularProgressIndicator(
  //                         value: loadingProgress.expectedTotalBytes != null
  //                             ? loadingProgress.cumulativeBytesLoaded /
  //                                 loadingProgress.expectedTotalBytes!
  //                             : null,
  //                       ),
  //                     );
  //                   },
  //                 ),
  //                 SizedBox(height: 15)
  //               ]));
  //     },
  //   );
  // }

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
                      children:
                          List.generate(departementAkses.value.length, (index) {
                        var id = departementAkses.value[index]['id'];
                        var dep_name = departementAkses.value[index]['name'];
                        return InkWell(
                          onTap: () {
                            print("tes");
                            filterLokasiKoordinate.value = "Lokasi";
                            selectedViewFilterAbsen.value = 0;
                            Rx<AbsenModel> absenModel = AbsenModel().obs;
                            var jumlahData = 0.obs;

                            idDepartemenTerpilih.value = "$id";
                            namaDepartemenTerpilih.value = dep_name;
                            departemen.value.text =
                                departementAkses.value[index]['name'];
                            this.departemen.refresh();
                            print(
                                "id departement ${idDepartemenTerpilih.value}");
                            Navigator.pop(context);
                            // carilaporanAbsenkaryawan(status);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          print("tes");
                                          filterLokasiKoordinate.value =
                                              "Lokasi";
                                          selectedViewFilterAbsen.value = 0;
                                          Rx<AbsenModel> absenModel =
                                              AbsenModel().obs;
                                          var jumlahData = 0.obs;

                                          idDepartemenTerpilih.value = "$id";
                                          namaDepartemenTerpilih.value =
                                              dep_name;
                                          departemen.value.text =
                                              departementAkses.value[index]
                                                  ['name'];
                                          this.departemen.refresh();
                                          print(
                                              "id departement ${idDepartemenTerpilih.value}");
                                          Navigator.pop(context);
                                          // carilaporanAbsenkaryawan(status);
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
                                      )
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  // showDataLokasiKoordinate() {
  //   showModalBottomSheet(
  //       context: Get.context!,
  //       isScrollControlled: true,
  //       shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.vertical(
  //           top: Radius.circular(16.0),
  //         ),
  //       ),
  //       builder: (context) {
  //         return SafeArea(
  //           child: ClipRRect(
  //             borderRadius: BorderRadius.circular(16.0),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
  //                   child: Row(
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Text(
  //                         "Pilih Lokasi",
  //                         style: GoogleFonts.inter(
  //                           fontWeight: FontWeight.w500,
  //                           fontSize: 18,
  //                           color: Constanst.fgPrimary,
  //                         ),
  //                       ),
  //                       InkWell(
  //                           customBorder: const RoundedRectangleBorder(
  //                               borderRadius:
  //                                   BorderRadius.all(Radius.circular(8))),
  //                           onTap: () => Navigator.pop(Get.context!),
  //                           child: Icon(
  //                             Icons.close,
  //                             size: 26,
  //                             color: Constanst.fgSecondary,
  //                           ))
  //                     ],
  //                   ),
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
  //                   child: Divider(
  //                     thickness: 1,
  //                     height: 0,
  //                     color: Constanst.border,
  //                   ),
  //                 ),
  //                 SingleChildScrollView(
  //                   physics: const BouncingScrollPhysics(),
  //                   child: Obx(
  //                     () => Column(
  //                       children: List.generate(placeCoordinate.value.length,
  //                           (index) {
  //                         var id = placeCoordinate.value[index]['id'];
  //                         var place = placeCoordinate.value[index]['place'];
  //                         return InkWell(
  //                           onTap: () {
  //                             if (selectedViewFilterAbsen.value == 0) {
  //                               filterLokasiAbsenBulan(place);
  //                             } else {
  //                               filterLokasiAbsen(place);
  //                             }
  //                           },
  //                           child: Padding(
  //                             padding: const EdgeInsets.all(16.0),
  //                             child: Row(
  //                               mainAxisAlignment:
  //                                   MainAxisAlignment.spaceBetween,
  //                               children: [
  //                                 Text(
  //                                   place,
  //                                   style: GoogleFonts.inter(
  //                                     fontWeight: FontWeight.w500,
  //                                     fontSize: 16,
  //                                     color: Constanst.fgPrimary,
  //                                   ),
  //                                 ),
  //                                 "$id" == idDepartemenTerpilih.value
  //                                     ? InkWell(
  //                                         onTap: () {},
  //                                         child: Container(
  //                                           height: 20,
  //                                           width: 20,
  //                                           decoration: BoxDecoration(
  //                                               border: Border.all(
  //                                                   width: 2,
  //                                                   color: Constanst.onPrimary),
  //                                               borderRadius:
  //                                                   BorderRadius.circular(10)),
  //                                           child: Padding(
  //                                             padding: const EdgeInsets.all(3),
  //                                             child: Container(
  //                                               decoration: BoxDecoration(
  //                                                   color: Constanst.onPrimary,
  //                                                   borderRadius:
  //                                                       BorderRadius.circular(
  //                                                           10)),
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       )
  //                                     : InkWell(
  //                                         onTap: () {
  //                                           if (selectedViewFilterAbsen.value ==
  //                                               0) {
  //                                             filterLokasiAbsenBulan(place);
  //                                           } else {
  //                                             filterLokasiAbsen(place);
  //                                           }
  //                                         },
  //                                         child: Container(
  //                                           height: 20,
  //                                           width: 20,
  //                                           decoration: BoxDecoration(
  //                                               border: Border.all(
  //                                                   width: 1,
  //                                                   color: Constanst.onPrimary),
  //                                               borderRadius:
  //                                                   BorderRadius.circular(10)),
  //                                           child: Padding(
  //                                             padding: const EdgeInsets.all(2),
  //                                             child: Container(
  //                                               decoration: BoxDecoration(
  //                                                   borderRadius:
  //                                                       BorderRadius.circular(
  //                                                           10)),
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       ),
  //                               ],
  //                             ),
  //                           ),
  //                         );
  //                       }),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }

  // void filterLokasiAbsenBulan(place) {
  //   print("tes");
  //   Navigator.pop(Get.context!);
  //   statusLoadingSubmitLaporan.value = true;
  //   listLaporanFilter.value.clear();
  //   Map<String, dynamic> body = {
  //     'bulan': bulanSelectedSearchHistory.value,
  //     'tahun': tahunSelectedSearchHistory.value,
  //     'status': idDepartemenTerpilih.value
  //   };
  //   var connect =
  //       Api.connectionApi("post", body, "load_laporan_absensi_filter_lokasi");
  //   connect.then((dynamic res) {
  //     var valueBody = jsonDecode(res.body);
  //     if (valueBody['status'] == false) {
  //       statusLoadingSubmitLaporan.value = false;
  //       UtilsAlert.showToast(
  //           "Data periode $bulanSelectedSearchHistory belum tersedia, harap hubungi HRD");
  //     } else {
  //       var data = valueBody['data'];
  //       List listFilterLokasi = [];
  //       for (var element in data) {
  //         if (element['place_in'] == place) {
  //           listFilterLokasi.add(element);
  //         }
  //       }
  //       listLaporanFilter.value = listFilterLokasi;
  //       allListLaporanFilter.value = listFilterLokasi;
  //       filterLokasiKoordinate.value = place;

  //       this.listLaporanFilter.refresh();
  //       this.filterLokasiKoordinate.refresh();
  //       loading.value = listLaporanFilter.value.length == 0
  //           ? "Data tidak tersedia"
  //           : "Memuat data...";

  //       statusLoadingSubmitLaporan.value = false;
  //       this.statusLoadingSubmitLaporan.refresh();
  //       groupData();
  //     }
  //   });
  // }

  // void filterLokasiAbsen(place) {
  //   List listFilterLokasi = [];
  //   for (var element in allListLaporanFilter.value) {
  //     if (element['place_in'] == place) {
  //       listFilterLokasi.add(element);
  //     }
  //   }
  //   listLaporanFilter.value = listFilterLokasi;
  //   filterLokasiKoordinate.value = place;
  //   this.listLaporanFilter.refresh();
  //   this.filterLokasiKoordinate.refresh();
  //   loading.value = listLaporanFilter.value.length == 0
  //       ? "Data tidak tersedia"
  //       : "Memuat data...";
  //   Navigator.pop(Get.context!);
  //   groupData();
  // }

  // void refreshFilterKoordinate() {
  //   if (selectedViewFilterAbsen.value == 0) {
  //     onReady();
  //   } else {
  //     listLaporanFilter.value = allListLaporanFilter.value;
  //     filterLokasiKoordinate.value = "Lokasi";
  //     this.listLaporanFilter.refresh();
  //     this.filterLokasiKoordinate.refresh();
  //     loading.value = listLaporanFilter.value.length == 0
  //         ? "Data tidak tersedia"
  //         : "Memuat data...";
  //   }
  // }

  // void takeFile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles();

  //   if (result != null) {
  //     PlatformFile file = result.files.first;
  //     if (file.size > 5000000) {
  //       UtilsAlert.showToast("Maaf file terlalu besar...Max 5MB");
  //     } else {
  //       namaFileUpload.value = "${file.name}";
  //       imageAjuan.value = file.name.toString();
  //       filePengajuan.value = await saveFilePermanently(file);
  //       uploadFile.value = true;
  //       // print(file.name);
  //       // print(file.bytes);
  //       // print(file.size);
  //       // print(file.extension);
  //       // print(file.path);
  //     }
  //   } else {
  //     UtilsAlert.showToast("Gagal mengambil file");
  //   }
  // }

  // Future<File> saveFilePermanently(PlatformFile file) async {
  //   final appStorage = await getApplicationDocumentsDirectory();
  //   final newFile = File('${appStorage.path}/${file.name}');
  //   return File(file.path!).copy(newFile.path);
  // }

  // void carilaporanAbsenkaryawan(status) {
  //   if (departemen.value.text == "") {
  //     UtilsAlert.showToast("Lengkapi form");
  //   } else {
  //     if (status == 'semua') {
  //       if (selectedViewFilterAbsen.value == 0) {
  //         // filter bulan
  //         aksiCariLaporan();
  //       } else if (selectedViewFilterAbsen.value == 1) {
  //         // filter tanggal
  //         cariLaporanAbsenTanggal(pilihTanggalTelatAbsen.value);
  //       }
  //     } else if (status == 'telat') {
  //       aksiEmployeeTerlambatAbsen(
  //           "${DateFormat('yyyy-MM-dd').format(pilihTanggalTelatAbsen.value)}");
  //     } else if (status == 'belum') {
  //       aksiEmployeeBelumAbsen(
  //           "${DateFormat('yyyy-MM-dd').format(pilihTanggalTelatAbsen.value)}");
  //     }
  //   }
  // }

  void aksiCariLaporan() async {
    statusLoadingSubmitLaporan.value = true;
    listLaporanFilter.value.clear();
    Map<String, dynamic> body = {
      'bulan': bulanSelectedSearchHistory.value,
      'tahun': tahunSelectedSearchHistory.value,
      'status': idDepartemenTerpilih.value
    };
    var connect = Api.connectionApi("post", body, "load_laporan_absensi");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        if (valueBody['status'] == false) {
          statusLoadingSubmitLaporan.value = false;
          UtilsAlert.showToast(
              "Data periode $bulanSelectedSearchHistory belum tersedia, harap hubungi HRD");
        } else {
          var data = valueBody['data'];
          loading.value =
              data.length == 0 ? "Data tidak tersedia" : "Memuat data...";
          listLaporanFilter.value = data;
          allListLaporanFilter.value = data;
          this.listLaporanFilter.refresh();
          this.allListLaporanFilter.refresh();
          statusLoadingSubmitLaporan.value = false;
          this.statusLoadingSubmitLaporan.refresh();
          groupData();
        }
      }
    });
  }

  // void cariLaporanAbsenTanggal(tanggal) {
  //   var tanggalSubmit = "${DateFormat('yyyy-MM-dd').format(tanggal)}";
  //   statusLoadingSubmitLaporan.value = true;
  //   listLaporanFilter.value.clear();
  //   Map<String, dynamic> body = {
  //     'atten_date': tanggalSubmit,
  //     'status': idDepartemenTerpilih.value
  //   };
  //   var connect =
  //       Api.connectionApi("post", body, "load_laporan_absensi_tanggal");
  //   connect.then((dynamic res) {
  //     if (res.statusCode == 200) {
  //       var valueBody = jsonDecode(res.body);
  //       if (valueBody['status'] == false) {
  //         statusLoadingSubmitLaporan.value = false;
  //         UtilsAlert.showToast(
  //             "Data periode $bulanSelectedSearchHistory belum tersedia, harap hubungi HRD");
  //       } else {
  //         var data = valueBody['data'];
  //         loading.value =
  //             data.length == 0 ? "Data tidak tersedia" : "Memuat data...";
  //         listLaporanFilter.value = data;
  //         allListLaporanFilter.value = data;
  //         this.listLaporanFilter.refresh();
  //         this.allListLaporanFilter.refresh();
  //         statusLoadingSubmitLaporan.value = false;
  //         filterLaporanAbsenTanggal.value = true;
  //         this.filterLaporanAbsenTanggal.refresh();
  //         this.statusLoadingSubmitLaporan.refresh();
  //         groupData();
  //       }
  //     }
  //   });
  // }

  // void pencarianNamaKaryawan(value) {
  //   var textCari = value.toLowerCase();
  //   var filter = allListLaporanFilter.where((laporan) {
  //     var namaEmployee = laporan['full_name'].toLowerCase();
  //     return namaEmployee.contains(textCari);
  //   }).toList();
  //   listLaporanFilter.value = filter;
  //   statusCari.value = true;
  //   this.listLaporanFilter.refresh();
  //   this.statusCari.refresh();
  //   groupData();
  // }

  void groupData() async {
    listLaporanFilter.value = listLaporanFilter
        .fold(Map<String, List<dynamic>>(), (Map<String, List<dynamic>> a, b) {
          a.putIfAbsent(b['em_id'], () => []).add(b);
          return a;
        })
        .values
        .where((l) => l.isNotEmpty)
        .map((l) => {
              'full_name': l.first['full_name'],
              'job_title': l.first['job_title'],
              'em_id': l.first['em_id'],
              'atten_date': l.first['atten_date'],
              'signin_time': l.first['signin_time'],
              'signout_time': l.first['signout_time'],
              'signin_note': l.first['signin_note'],
              'place_in': l.first['place_in'],
              'place_out': l.first['place_out'],
              'signin_longlat': l.first['signin_longlat'],
              'id': l.first['id_absen'],
              'signout_longlat': l.first['signout_longlat'],
              'is_open': false,
              'data': l
                  .map((e) => {
                        'full_name': e['full_name'],
                        'id': e['id_absen'],
                        'job_title': e['job_title'],
                        'em_id': e['em_id'],
                        'atten_date': e['atten_date'],
                        'signin_time': e['signin_time'],
                        'signout_time': e['signout_time'],
                        'signin_note': e['signin_note'],
                        'place_in': l.first['place_in'],
                        'place_out': l.first['place_out'],
                        'signin_longlat': l.first['signin_longlat'],
                        'signout_longlat': l.first['signout_longlat'],
                      })
                  .toList()
                ..sort((a, b) => b['atten_date'].compareTo(a['atten_date']))
            })
        .toList();
  }

  // void pencarianNamaKaryawanTelat(value) {
  //   var textCari = value.toLowerCase();
  //   var filter = alllistEmployeeTelat.where((laporan) {
  //     var namaEmployee = laporan['full_name'].toLowerCase();
  //     return namaEmployee.contains(textCari);
  //   }).toList();
  //   listEmployeeTelat.value = filter;
  //   statusCari.value = true;
  //   this.listLaporanFilter.refresh();
  //   this.statusCari.refresh();
  //   groupData();
  // }

  // void pencarianNamaKaryawanBelumAbsen(value) {
  //   var textCari = value.toLowerCase();
  //   var filter = allListLaporanBelumAbsen.where((laporan) {
  //     var namaEmployee = laporan['full_name'].toLowerCase();
  //     return namaEmployee.contains(textCari);
  //   }).toList();
  //   listLaporanBelumAbsen.value = filter;
  //   statusCari.value = true;
  //   this.listLaporanFilter.refresh();
  //   this.statusCari.refresh();
  // }

  // void clearPencarian() {
  //   statusCari.value = false;
  //   cari.value.text = "";

  //   listLaporanFilter.value = allListLaporanFilter.value;
  //   this.listLaporanFilter.refresh();

  //   listLaporanBelumAbsen.value = allListLaporanBelumAbsen.value;
  //   this.listLaporanBelumAbsen.refresh();

  //   listEmployeeTelat.value = alllistEmployeeTelat.value;
  //   this.listEmployeeTelat.refresh();
  // }

  // void widgetButtomSheetFilterData() {
  //   showModalBottomSheet(
  //     context: Get.context!,
  //     isDismissible: false,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(
  //         top: Radius.circular(20.0),
  //       ),
  //     ),
  //     builder: (context) {
  //       return Column(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           SizedBox(
  //             height: 8,
  //           ),
  //           Padding(
  //             padding: EdgeInsets.only(left: 16.0, right: 16.0),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Row(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Expanded(
  //                       flex: 90,
  //                       child: Padding(
  //                         padding: const EdgeInsets.only(top: 16),
  //                         child: Text(
  //                           "Filter",
  //                           style: TextStyle(fontWeight: FontWeight.bold),
  //                         ),
  //                       ),
  //                     ),
  //                     Expanded(
  //                       flex: 10,
  //                       child: IconButton(
  //                         onPressed: () => Navigator.pop(Get.context!),
  //                         icon: Icon(Iconsax.close_circle),
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //                 Divider(
  //                   height: 5,
  //                   color: Constanst.colorText2,
  //                 ),
  //                 SizedBox(
  //                   height: 16,
  //                 ),
  //                 lineTitleKategori(),
  //                 SizedBox(
  //                   height: 25,
  //                 ),
  //                 SizedBox(
  //                     height: 50,
  //                     child: Padding(
  //                       padding: const EdgeInsets.only(left: 8.0, right: 8.0),
  //                       child: pageViewKategoriFilter(),
  //                     )),
  //                 SizedBox(
  //                   height: 30,
  //                 )
  //               ],
  //             ),
  //           )
  //         ],
  //       );
  //     },
  //   );
  // }

  // Widget lineTitleKategori() {
  //   return Obx(
  //     () => Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Expanded(
  //           child: InkWell(
  //             onTap: () {
  //               selectedViewFilterAbsen.value = 0;
  //               pageViewFilterAbsen!.jumpToPage(0);
  //               this.selectedViewFilterAbsen.refresh();
  //             },
  //             child: Container(
  //               margin: EdgeInsets.only(left: 6, right: 6),
  //               decoration: BoxDecoration(
  //                   color: selectedViewFilterAbsen.value == 0
  //                       ? Constanst.colorPrimary
  //                       : Colors.transparent,
  //                   borderRadius: Constanst.borderStyle1),
  //               child: Center(
  //                 child: Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: Text(
  //                     'Bulan',
  //                     style: TextStyle(
  //                       color: selectedViewFilterAbsen.value == 0
  //                           ? Colors.white
  //                           : Colors.black,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //         Expanded(
  //           child: InkWell(
  //             onTap: () {
  //               selectedViewFilterAbsen.value = 1;
  //               pageViewFilterAbsen!.jumpToPage(1);
  //               this.selectedViewFilterAbsen.refresh();
  //             },
  //             child: Container(
  //               margin: EdgeInsets.only(left: 6, right: 6),
  //               decoration: BoxDecoration(
  //                   color: selectedViewFilterAbsen.value == 1
  //                       ? Constanst.colorPrimary
  //                       : Colors.transparent,
  //                   borderRadius: Constanst.borderStyle1),
  //               child: Center(
  //                 child: Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: Text(
  //                     'Tanggal',
  //                     style: TextStyle(
  //                       color: selectedViewFilterAbsen.value == 1
  //                           ? Colors.white
  //                           : Colors.black,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget pageViewKategoriFilter() {
  //   return PageView.builder(
  //       physics: BouncingScrollPhysics(),
  //       controller: pageViewFilterAbsen,
  //       onPageChanged: (index) {
  //         selectedViewFilterAbsen.value = index;
  //       },
  //       itemCount: 2,
  //       itemBuilder: (context, index) {
  //         return Padding(
  //             padding: EdgeInsets.all(0),
  //             child: index == 0
  //                 ? filterBulan()
  //                 : index == 1
  //                     ? filterTanggal()
  //                     : SizedBox());
  //       });
  // }

  // Widget filterBulan() {
  //   return Padding(
  //       padding: const EdgeInsets.only(right: 5),
  //       child: InkWell(
  //         onTap: () {
  //           DatePicker.showPicker(
  //             Get.context!,
  //             pickerModel: CustomMonthPicker(
  //               minTime: DateTime(2000, 1, 1),
  //               maxTime: DateTime(2100, 1, 1),
  //               currentTime: DateTime.now(),
  //             ),
  //             onConfirm: (time) {
  //               if (time != null) {
  //                 print("$time");
  //                 filterLokasiKoordinate.value = "Lokasi";
  //                 selectedViewFilterAbsen.value = 0;
  //                 var filter = DateFormat('yyyy-MM').format(time);
  //                 var array = filter.split('-');
  //                 var bulan = array[1];
  //                 var tahun = array[0];
  //                 bulanSelectedSearchHistory.value = bulan;
  //                 tahunSelectedSearchHistory.value = tahun;
  //                 bulanDanTahunNow.value = "$bulan-$tahun";
  //                 this.bulanSelectedSearchHistory.refresh();
  //                 this.tahunSelectedSearchHistory.refresh();
  //                 this.bulanDanTahunNow.refresh();
  //                 Navigator.pop(Get.context!);
  //                 aksiCariLaporan();
  //               }
  //             },
  //           );
  //         },
  //         child: Container(
  //           height: 40,
  //           decoration: BoxDecoration(
  //               borderRadius: Constanst.borderStyle1,
  //               border: Border.all(color: Constanst.colorText2)),
  //           child: Padding(
  //             padding: EdgeInsets.only(top: 10, bottom: 8),
  //             child: Row(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Row(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Padding(
  //                       padding: const EdgeInsets.only(left: 6),
  //                       child: Icon(Iconsax.calendar_2),
  //                     ),
  //                     Padding(
  //                       padding: const EdgeInsets.only(left: 3),
  //                       child: Text(
  //                         "${Constanst.convertDateBulanDanTahun(bulanDanTahunNow.value)}",
  //                         style: TextStyle(fontSize: 16),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ));
  // }

  // Widget filterTanggal() {
  //   return Padding(
  //       padding: const EdgeInsets.only(right: 5),
  //       child: InkWell(
  //         onTap: () {
  //           filterLokasiKoordinate.value = "Lokasi";
  //           selectedViewFilterAbsen.value = 0;
  //           DatePicker.showDatePicker(Get.context!,
  //               showTitleActions: true,
  //               minTime: DateTime(2000, 1, 1),
  //               maxTime: DateTime(2100, 1, 1), onConfirm: (date) {
  //             Navigator.pop(Get.context!);
  //             pilihTanggalTelatAbsen.value = date;
  //             this.pilihTanggalTelatAbsen.refresh();
  //             cariLaporanAbsenTanggal(pilihTanggalTelatAbsen.value);
  //           }, currentTime: DateTime.now(), locale: LocaleType.en);
  //         },
  //         child: Container(
  //           height: 40,
  //           decoration: BoxDecoration(
  //               borderRadius: Constanst.borderStyle1,
  //               border: Border.all(color: Constanst.colorText2)),
  //           child: Padding(
  //             padding: EdgeInsets.only(top: 10, bottom: 8),
  //             child: Row(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Expanded(
  //                   child: Row(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Padding(
  //                         padding: const EdgeInsets.only(left: 6),
  //                         child: Icon(Iconsax.calendar_2),
  //                       ),
  //                       Flexible(
  //                         child: Padding(
  //                           padding: const EdgeInsets.only(left: 6),
  //                           child: Text(
  //                             "${Constanst.convertDate('${DateFormat('yyyy-MM-dd').format(pilihTanggalTelatAbsen.value)}')}",
  //                             style: TextStyle(fontSize: 16),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ));
  // }

  // void faceIdRegistration({faceId, emId}) async {
  //   try {
  //     final box = GetStorage();
  //     box.write("face_recog", true);
  //     UtilsAlert.showLoadingIndicator(Get.context!);

  //     Map<String, dynamic> body = {"em_id": emId, "": faceId};
  //     Map<String, String> headers = {
  //       'Authorization': Api.basicAuth,
  //       'Content-type': 'application/json',
  //       'Accept': 'application/json',
  //       'token': AppData.setFcmToken,
  //       'em_id': AppData.informasiUser == null ||
  //               AppData.informasiUser == "null" ||
  //               AppData.informasiUser == "" ||
  //               AppData.informasiUser!.isEmpty
  //           ? ""
  //           : AppData.informasiUser![0].em_id
  //     };
  //     print("body" + body.toString());

  //     final response = await http.post(Uri.parse('${Api.basicUrl}edit_face'),
  //         body: jsonEncode(body), headers: headers);
  //     if (response.statusCode == 200) {
  //       var data = jsonDecode(response.body);
  //       print(data.toString());
  //       Get.back();

  //       // print("body " + jsonDecode(response.body.toString()).toString());
  //       Get.to(BerhasilRegistration());
  //     }

  //     // var data = jsonDecode(response.body);

  //     // if (response.statusCode == 200) {
  //     //   UtilsAlert.showToast(data['message']);
  //     //   Navigator.pop(Get.context!);
  //     // } else {
  //     //   Navigator.pop(Get.context!);
  //     //   UtilsAlert.showToast(data['message']);
  //     // }
  //   } catch (e) {
  //     Navigator.pop(Get.context!);
  //     UtilsAlert.showToast(e.toString());
  //   }
  //   // UtilsAlert.showLoadingIndicator(Get.context!);
  //   // Map<String, dynamic> body = {'face': faceId, 'em_id': emId};

  //   // var connect = Api.connectionApi("post", body, "edit_face");
  //   // connect.then((dynamic res) {
  //   //   if (res.statusCode == 200) {
  //   //     var valueBody = jsonDecode(res.body);
  //   //     if (valueBody['status'] == false) {
  //   //       Navigator.pop(Get.context!);
  //   //       UtilsAlert.showToast("Data has been saved");
  //   //     } else {
  //   //       UtilsAlert.showToast("Eerror");
  //   //       Navigator.pop(Get.context!);
  //   //       sysData.value = valueBody['data'];
  //   //       this.sysData.refresh();
  //   //     }
  //   //   }
  //   // }).catchError((e) {
  //   //   UtilsAlert.showToast('${e}');
  //   // });
  // }

  // void employeDetail() {
  //   print("load detail employee");
  //   // UtilsAlert.showLoadingIndicator(Get.context!);
  //   var dataUser = AppData.informasiUser;
  //   final box = GetStorage();

  //   var id = dataUser![0].em_id;
  //   print("em id ${id}");
  //   Map<String, dynamic> body = {'val': 'em_id', 'cari': id};
  //   var connect = Api.connectionApi("post", body, "whereOnce-employee");
  //   connect.then((dynamic res) {
  //     if (res == false) {
  //       UtilsAlert.koneksiBuruk();
  //     } else {
  //       bool lastAbsen = AppData.statusAbsen;
  //       print("ASEE ABSEN ${lastAbsen}");

  //       if (res.statusCode == 200) {
  //         var valueBody = jsonDecode(res.body);
  //         var data = valueBody['data'];
  //         // isTracking.value = data[0]['em_control'];
  //         if (lastAbsen == true) {
  //           if (data[0]['em_control'] == 1) {
  //             isTracking.value = 1;
  //           } else {
  //             isTracking.value = 0;
  //           }
  //         } else {
  //           isTracking.value = 0;
  //         }
  //         print("data wajah ${data[0]['file_face']}");
  //         regType.value = data[0]['reg_type'];
  //         print("Req tye ${regType.value}");
  //         box.write("file_face", data[0]['file_face']);

  //         print("data wajah ${GetStorage().read('file_face')}");

  //         if (data[0]['file_face'] == "" || data[0]['file_face'] == null) {
  //           box.write("face_recog", false);
  //         } else {
  //           box.write("face_recog", true);
  //         }
  //       }
  //       // Get.back();
  //     }
  //   });
  // }

  // void employeDetaiBpjs() {
  //   // UtilsAlert.showLoadingIndicator(Get.context!);
  //   var dataUser = AppData.informasiUser;
  //   final box = GetStorage();

  //   var id = dataUser![0].em_id;
  //   print("em id ${id}");
  //   Map<String, dynamic> body = {'val': 'em_id', 'cari': id};
  //   var connect = Api.connectionApi("post", body, "whereOnce-employee");
  //   connect.then((dynamic res) {
  //     if (res == false) {
  //       UtilsAlert.koneksiBuruk();
  //     } else {
  //       if (res.statusCode == 200) {
  //         var valueBody = jsonDecode(res.body);
  //         var data = valueBody['data'];
  //         isTracking.value = data[0]['em_control'];
  //         regType.value = data[0]['reg_type'];
  //         print("Req tye ${regType.value}");
  //         box.write("file_face", data[0]['file_face']);

  //         if (data[0]['file_face'] == "" || data[0]['file_face'] == null) {
  //           box.write("face_recog", false);
  //         } else {
  //           box.write("face_recog", true);
  //         }
  //       }
  //       // Get.back();
  //     }
  //   });
  // }

  void userShift() {
    // UtilsAlert.showLoadingIndicator(Get.context!);
    var dataUser = AppData.informasiUser;
    final box = GetStorage();

    var id = dataUser![0].em_id;

    var connect = Api.connectionApi("get", "", "setting_shift");
    connect.then((dynamic res) {
      if (res == false) {
        //UtilsAlert.koneksiBuruk();
      } else {
        if (res.statusCode == 200) {
          var valueBody = jsonDecode(res.body);
          List data = valueBody['data'];
          print("data setting ${data}");
          if (data.isNotEmpty) {
            shift.value = OfficeShiftModel.fromJson(data[0]);
          }
        }
        // Get.back();
      }
    });
  }

  // void widgetButtomSheetFaceRegistrattion() {
  //   showModalBottomSheet(
  //     context: Get.context!,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(
  //         top: Radius.circular(12.0),
  //       ),
  //     ),
  //     builder: (context) {
  //       return SafeArea(
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     children: [
  //                       Text(
  //                         "Tambahkan Data Wajah",
  //                         style: GoogleFonts.inter(
  //                             fontWeight: FontWeight.w500,
  //                             color: Constanst.fgPrimary,
  //                             fontSize: 16),
  //                       ),
  //                       InkWell(
  //                           onTap: () {
  //                             Get.back();
  //                           },
  //                           child: Icon(Icons.close))
  //                     ],
  //                   ),
  //                   const SizedBox(height: 16),
  //                   Text(
  //                     "Pastikan wajah Kamu tidak tertutup dan terlihat jelas. Kamu juga harus berada di ruangan dengan penerangan yang cukup.",
  //                     style: GoogleFonts.inter(
  //                         fontWeight: FontWeight.w400,
  //                         color: Constanst.fgSecondary,
  //                         fontSize: 14),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                   const SizedBox(height: 16),
  //                   Image.asset(
  //                     "assets/emoji_happy_tick.png",
  //                     width: 64,
  //                     height: 64,
  //                   ),
  //                   const SizedBox(height: 16),
  //                   Container(
  //                     decoration: BoxDecoration(
  //                       color: Constanst.infoLight1,
  //                       borderRadius: BorderRadius.circular(8),
  //                     ),
  //                     padding: const EdgeInsets.all(12.0),
  //                     child: Row(
  //                       children: [
  //                         Icon(
  //                           Iconsax.info_circle5,
  //                           color: Constanst.colorPrimary,
  //                           size: 26,
  //                         ),
  //                         const SizedBox(width: 12),
  //                         Expanded(
  //                           child: Text(
  //                             "Data wajah ini akan digunakan setiap kali Kamu melakukan Absen Masuk dan Keluar.",
  //                             textAlign: TextAlign.left,
  //                             style: GoogleFonts.inter(
  //                                 fontWeight: FontWeight.w400,
  //                                 color: Constanst.fgSecondary,
  //                                 fontSize: 14),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   const SizedBox(height: 16),
  //                   SizedBox(
  //                     width: double.infinity,
  //                     child: ElevatedButton(
  //                       onPressed: () {
  //                         Get.to(FaceidRegistration(
  //                           status: "registration",
  //                         ));
  //                       },
  //                       style: ElevatedButton.styleFrom(
  //                           foregroundColor: Constanst.colorWhite,
  //                           backgroundColor: Constanst.colorPrimary,
  //                           shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(8),
  //                           ),
  //                           elevation: 0,
  //                           // padding: EdgeInsets.zero,
  //                           padding: const EdgeInsets.fromLTRB(0, 0, 0, 0)),
  //                       child: Padding(
  //                         padding:
  //                             const EdgeInsets.only(top: 12.0, bottom: 12.0),
  //                         child: Text(
  //                           'Selanjutnya',
  //                           style: GoogleFonts.inter(
  //                               fontWeight: FontWeight.w500,
  //                               color: Constanst.colorWhite,
  //                               fontSize: 15),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  // void addPengajuan() {}

  // void checkAbsensi() {
  //   var emId = AppData.informasiUser![0].em_id;
  //   Map<String, dynamic> body = {
  //     "em_id": emId,
  //     'date': tglAjunan.value,
  //     'bulan':
  //         DateFormat('MM').format(DateTime.parse(tglAjunan.value.toString())),
  //     'tahun':
  //         DateFormat('yyyy').format(DateTime.parse(tglAjunan.value.toString()))
  //   };
  //   print(body);
  //   var connect = Api.connectionApi("post", body, "employee-attendance");
  //   connect.then((dynamic res) {
  //     if (res.statusCode == 200) {
  //       var valueBody = jsonDecode(res.body);
  //       List data = valueBody['data'];
  //       if (data.isNotEmpty) {
  //         checkinAjuan.value = data[0]['signin_time'];
  //         checkoutAjuan.value = data[0]['signout_time'];
  //       } else {}
  //     }
  //   });
  // }

  // void batalkanAjuan({date}) {
  //   UtilsAlert.showLoadingIndicator(Get.context!);
  //   var emId = AppData.informasiUser![0].em_id;
  //   Map<String, dynamic> body = {
  //     "em_id": emId,
  //     'date': date,
  //     'bulan': DateFormat('MM').format(DateTime.parse(date.toString())),
  //     'tahun': DateFormat('yyyy').format(DateTime.parse(date.toString()))
  //   };

  //   var connect = Api.connectionApi("post", body, "delete-employee-attendance");
  //   connect.then((dynamic res) {
  //     if (res.statusCode == 200) {
  //       dataPengajuanAbsensi();
  //       Get.back();
  //       Get.back();
  //     } else {
  //       Get.back();
  //     }
  //   });
  // }

  // void dataPengajuanAbsensi() {
  //   isLoadingPengajuan.value = true;
  //   var emId = AppData.informasiUser![0].em_id;
  //   Map<String, dynamic> body = {
  //     "em_id": emId,
  //     'date': tglAjunan.value,
  //     'bulan': bulanSelectedSearchHistoryPengajuan.value,
  //     'tahun': tahunSelectedSearchHistoryPengajuan.value,
  //   };
  //   print(body);
  //   var connect = Api.connectionApi("post", body, "get-employee-attendance");
  //   connect.then((dynamic res) {
  //     if (res.statusCode == 200) {
  //       isLoadingPengajuan.value = false;
  //       var valueBody = jsonDecode(res.body);
  //       List data = valueBody['data'];
  //       print("data pengajuan ${data}");
  //       if (data.isEmpty) {
  //         loadingPengajuan.value = "Data tidak tersedia";
  //       } else {
  //         loadingPengajuan.value = "Memuat Data...";
  //       }
  //       ;
  //       pengajuanAbsensi.value = data;
  //     } else {
  //       isLoadingPengajuan.value = false;
  //     }
  //   });
  // }

  // void resetData() {
  //   placeCoordinateCheckin.clear();
  //   placeCoordinateCheckout.clear();
  //   isChecked.value = false;
  //   isChecked2.value = false;
  //   tglAjunan.value = "";
  //   checkinAjuan.value = "";
  //   checkoutAjuan.value = "";
  //   checkinAjuan2.value = "";
  //   checkoutAjuan2.value = "";
  //   catataanAjuan.clear();
  //   imageAjuan = "".obs;
  // }

  // void kirimPengajuan() {
  //   var emId = AppData.informasiUser![0].em_id;
  //   Map<String, dynamic> body = {
  //     "em_id": emId,
  //     'date': tglAjunan.value,
  //     'bulan':
  //         DateFormat('MM').format(DateTime.parse(tglAjunan.value.toString())),
  //     'tahun':
  //         DateFormat('yyyy').format(DateTime.parse(tglAjunan.value.toString())),
  //     'status': "pending",
  //     'catatan': catataanAjuan.text,
  //     'checkin': checkinAjuan2.value.toString(),
  //     'checkout': checkoutAjuan2.value == ""
  //         ? "00:00"
  //         : checkoutAjuan2.value.toString(),
  //     'lokasi_masuk_id': placeCoordinateCheckin
  //             .where((p0) => p0['is_selected'] == true)
  //             .toList()
  //             .isNotEmpty
  //         ? placeCoordinateCheckin
  //             .where((p0) => p0['is_selected'] == true)
  //             .toList()[0]['id']
  //         : "",
  //     'lokasi_keluar_id': placeCoordinateCheckout
  //             .where((p0) => p0['is_selected'] == true)
  //             .toList()
  //             .isNotEmpty
  //         ? placeCoordinateCheckout
  //             .where((p0) => p0['is_selected'] == true)
  //             .toList()[0]['id']
  //         : "",
  //     'file': imageAjuan.value,
  //     'tgl_ajuan': DateFormat('yyyy-MM-dd').format(DateTime.now()),
  //   };
  //   print('body data ajuan ${body}');
  //   var connect = Api.connectionApi("post", body, "save-employee-attendance");
  //   connect.then((dynamic res) {
  //     var valueBody = jsonDecode(res.body);
  //     print("data berhasil absensi ${valueBody}");

  //     if (res.statusCode == 200) {
  //       Get.to(pengajuanAbsenBerhasil());

  //       dataPengajuanAbsensi();
  //       UtilsAlert.showToast("${valueBody['message']}");
  //     } else {
  //       UtilsAlert.showToast("${valueBody['message']}");
  //     }
  //   });
  // }

  // void nextKirimPengajuan() async {
  //   if (tglAjunan.value == "") {
  //     UtilsAlert.showToast("Tanggal belum dipilih");
  //     return;
  //   }

  //   if (checkinAjuan2.value == "") {
  //     UtilsAlert.showToast("Waktu Checkin belum dipilih");
  //     return;
  //   }

  //   // if (checkoutAjuan2.value == "") {
  //   //   UtilsAlert.showToast("Waktu Checkout belum dipilih");
  //   //   return;
  //   // }

  //   if (catataanAjuan.text == "") {
  //     UtilsAlert.showToast("catatan belum diisi");
  //     return;
  //   }

  //   if (uploadFile.value == true) {
  //     UtilsAlert.loadingSimpanData(Get.context!, "Sedang Menyimpan File");
  //     var connectUpload = await Api.connectionApiUploadFile(
  //         "upload_form_pengajuan_absensi", filePengajuan.value);
  //     var valueBody = jsonDecode(connectUpload);
  //     if (valueBody['status'] == true) {
  //       Navigator.pop(Get.context!);
  //       // checkNomorAjuan(status);
  //       kirimPengajuan();
  //     } else {
  //       UtilsAlert.showToast("Gagal kirim file");
  //     }
  //   } else {
  //     kirimPengajuan();
  //   }
  // }

  // void widgetButtomSheetFormLaporan() {
  //   showModalBottomSheet(
  //     context: Get.context!,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(
  //         top: Radius.circular(16.0),
  //       ),
  //     ),
  //     backgroundColor: Constanst.colorWhite,
  //     builder: (context) {
  //       return SafeArea(
  //         child: Obx(
  //           () => Column(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
  //                 child: Row(
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: [
  //                         Icon(
  //                           Iconsax.document_text5,
  //                           color: Constanst.infoLight,
  //                           size: 26,
  //                         ),
  //                         Padding(
  //                           padding: const EdgeInsets.only(left: 12),
  //                           child: Text(
  //                             "Cek Laporan",
  //                             style: GoogleFonts.inter(
  //                                 color: Constanst.fgPrimary,
  //                                 fontSize: 18,
  //                                 fontWeight: FontWeight.w500),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     InkWell(
  //                         onTap: () {
  //                           Navigator.pop(Get.context!);
  //                         },
  //                         child: Icon(
  //                           Icons.close,
  //                           size: 24,
  //                           color: Constanst.fgSecondary,
  //                         ))
  //                   ],
  //                 ),
  //               ),
  //               const SizedBox(height: 16),
  //               Padding(
  //                 padding: const EdgeInsets.only(left: 16, right: 16),
  //                 child: Divider(
  //                   height: 0,
  //                   thickness: 1,
  //                   color: Constanst.fgBorder,
  //                 ),
  //               ),
  //               InkWell(
  //                 // highlightColor: Colors.white,
  //                 onTap: () {
  //                   Get.back();
  //                   Get.back();
  //                   Get.to(LaporanAbsen(
  //                     dataForm: "",
  //                   ));
  //                   tempNamaLaporan1.value = "";
  //                 },
  //                 child: Padding(
  //                   padding: const EdgeInsets.only(
  //                       top: 12, bottom: 12, left: 16, right: 16),
  //                   child: Row(
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Row(
  //                         children: [
  //                           SvgPicture.asset(
  //                             'assets/2_absen.svg',
  //                             height: 35,
  //                             width: 35,
  //                           ),
  //                           Padding(
  //                             padding: const EdgeInsets.only(left: 12.0),
  //                             child: Text(
  //                               'Laporan Absensi',
  //                               style: GoogleFonts.inter(
  //                                   color: Constanst.fgPrimary,
  //                                   fontSize: 16,
  //                                   fontWeight: FontWeight.w500),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                       InkWell(
  //                         onTap: () {
  //                           Get.back();
  //                           Get.back();
  //                           Get.to(LaporanAbsen(
  //                             dataForm: "",
  //                           ));
  //                           tempNamaLaporan1.value = "";
  //                         },
  //                         child: Container(
  //                           height: 20,
  //                           width: 20,
  //                           decoration: BoxDecoration(
  //                               border: Border.all(
  //                                   width: tempNamaLaporan1.value == "" ? 2 : 1,
  //                                   color: Constanst.onPrimary),
  //                               borderRadius: BorderRadius.circular(10)),
  //                           child: tempNamaLaporan1.value == ""
  //                               ? Padding(
  //                                   padding: const EdgeInsets.all(3),
  //                                   child: Container(
  //                                     decoration: BoxDecoration(
  //                                         color: Constanst.onPrimary,
  //                                         borderRadius:
  //                                             BorderRadius.circular(10)),
  //                                   ),
  //                                 )
  //                               : Container(),
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               InkWell(
  //                 // highlightColor: Colors.white,
  //                 onTap: () {
  //                   Get.back();
  //                   Get.back();
  //                   Get.to(LaporanIzin(
  //                     title: 'tidak_hadir',
  //                   ));
  //                   tempNamaLaporan1.value = "tidak_hadir";
  //                 },
  //                 child: Padding(
  //                   padding: const EdgeInsets.only(
  //                       top: 12, bottom: 12, left: 16, right: 16),
  //                   child: Row(
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Row(
  //                         children: [
  //                           SvgPicture.asset(
  //                             'assets/3_izin.svg',
  //                             height: 35,
  //                             width: 35,
  //                           ),
  //                           Padding(
  //                             padding: const EdgeInsets.only(left: 12.0),
  //                             child: Text(
  //                               'Laporan Izin',
  //                               style: GoogleFonts.inter(
  //                                   color: Constanst.fgPrimary,
  //                                   fontSize: 16,
  //                                   fontWeight: FontWeight.w500),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                       InkWell(
  //                         onTap: () {
  //                           Get.back();
  //                           Get.back();
  //                           Get.to(LaporanIzin(
  //                             title: 'tidak_hadir',
  //                           ));
  //                           tempNamaLaporan1.value = "tidak_hadir";
  //                         },
  //                         child: Container(
  //                           height: 20,
  //                           width: 20,
  //                           decoration: BoxDecoration(
  //                               border: Border.all(
  //                                   width:
  //                                       tempNamaLaporan1.value == "tidak_hadir"
  //                                           ? 2
  //                                           : 1,
  //                                   color: Constanst.onPrimary),
  //                               borderRadius: BorderRadius.circular(10)),
  //                           child: tempNamaLaporan1.value == "tidak_hadir"
  //                               ? Padding(
  //                                   padding: const EdgeInsets.all(3),
  //                                   child: Container(
  //                                     decoration: BoxDecoration(
  //                                         color: Constanst.onPrimary,
  //                                         borderRadius:
  //                                             BorderRadius.circular(10)),
  //                                   ),
  //                                 )
  //                               : Container(),
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               InkWell(
  //                 // highlightColor: Colors.white,
  //                 onTap: () {
  //                   Get.back();
  //                   Get.back();
  //                   Get.to(LaporanLembur(
  //                     title: 'lembur',
  //                   ));
  //                   tempNamaLaporan1.value = "lembur";
  //                 },
  //                 child: Padding(
  //                   padding: const EdgeInsets.only(
  //                       top: 12, bottom: 12, left: 16, right: 16),
  //                   child: Row(
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Row(
  //                         children: [
  //                           SvgPicture.asset(
  //                             'assets/4_lembur.svg',
  //                             height: 35,
  //                             width: 35,
  //                           ),
  //                           Padding(
  //                             padding: const EdgeInsets.only(left: 12.0),
  //                             child: Text(
  //                               'Laporan Lembur',
  //                               style: GoogleFonts.inter(
  //                                   color: Constanst.fgPrimary,
  //                                   fontSize: 16,
  //                                   fontWeight: FontWeight.w500),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                       InkWell(
  //                         onTap: () {
  //                           Get.back();
  //                           Get.back();
  //                           Get.to(LaporanLembur(
  //                             title: 'lembur',
  //                           ));
  //                           tempNamaLaporan1.value = "lembur";
  //                         },
  //                         child: Container(
  //                           height: 20,
  //                           width: 20,
  //                           decoration: BoxDecoration(
  //                               border: Border.all(
  //                                   width: tempNamaLaporan1.value == "lembur"
  //                                       ? 2
  //                                       : 1,
  //                                   color: Constanst.onPrimary),
  //                               borderRadius: BorderRadius.circular(10)),
  //                           child: tempNamaLaporan1.value == "lembur"
  //                               ? Padding(
  //                                   padding: const EdgeInsets.all(3),
  //                                   child: Container(
  //                                     decoration: BoxDecoration(
  //                                         color: Constanst.onPrimary,
  //                                         borderRadius:
  //                                             BorderRadius.circular(10)),
  //                                   ),
  //                                 )
  //                               : Container(),
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               InkWell(
  //                 // highlightColor: Colors.white,
  //                 onTap: () {
  //                   Get.back();
  //                   Get.back();
  //                   Get.to(LaporanCuti(
  //                     title: 'cuti',
  //                   ));
  //                   tempNamaLaporan1.value = "cuti";
  //                 },
  //                 child: Padding(
  //                   padding: const EdgeInsets.only(
  //                       top: 12, bottom: 12, left: 16, right: 16),
  //                   child: Row(
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Row(
  //                         children: [
  //                           SvgPicture.asset(
  //                             'assets/5_cuti.svg',
  //                             height: 35,
  //                             width: 35,
  //                           ),
  //                           Padding(
  //                             padding: const EdgeInsets.only(left: 12.0),
  //                             child: Text(
  //                               'Laporan Cuti',
  //                               style: GoogleFonts.inter(
  //                                   color: Constanst.fgPrimary,
  //                                   fontSize: 16,
  //                                   fontWeight: FontWeight.w500),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                       InkWell(
  //                         onTap: () {
  //                           Get.back();
  //                           Get.back();
  //                           Get.to(LaporanCuti(
  //                             title: 'cuti',
  //                           ));
  //                           tempNamaLaporan1.value = "cuti";
  //                         },
  //                         child: Container(
  //                           height: 20,
  //                           width: 20,
  //                           decoration: BoxDecoration(
  //                               border: Border.all(
  //                                   width: tempNamaLaporan1.value == "cuti"
  //                                       ? 2
  //                                       : 1,
  //                                   color: Constanst.onPrimary),
  //                               borderRadius: BorderRadius.circular(10)),
  //                           child: tempNamaLaporan1.value == "cuti"
  //                               ? Padding(
  //                                   padding: const EdgeInsets.all(3),
  //                                   child: Container(
  //                                     decoration: BoxDecoration(
  //                                         color: Constanst.onPrimary,
  //                                         borderRadius:
  //                                             BorderRadius.circular(10)),
  //                                   ),
  //                                 )
  //                               : Container(),
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               InkWell(
  //                 // highlightColor: Colors.white,
  //                 onTap: () {
  //                   Get.back();
  //                   Get.back();
  //                   Get.to(LaporanTugasLuar(
  //                     title: 'tugas_luar',
  //                   ));
  //                   tempNamaLaporan1.value = "tugas_luar";
  //                 },
  //                 child: Padding(
  //                   padding: const EdgeInsets.only(
  //                       top: 12, bottom: 12, left: 16, right: 16),
  //                   child: Row(
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Row(
  //                         children: [
  //                           SvgPicture.asset(
  //                             'assets/6_tugas_luar.svg',
  //                             height: 35,
  //                             width: 35,
  //                           ),
  //                           Padding(
  //                             padding: const EdgeInsets.only(left: 12.0),
  //                             child: Text(
  //                               'Laporan Tugas Luar',
  //                               style: GoogleFonts.inter(
  //                                   color: Constanst.fgPrimary,
  //                                   fontSize: 16,
  //                                   fontWeight: FontWeight.w500),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                       InkWell(
  //                         onTap: () {
  //                           Get.back();
  //                           Get.back();
  //                           Get.to(LaporanTugasLuar(
  //                             title: 'tugas_luar',
  //                           ));
  //                           tempNamaLaporan1.value = "tugas_luar";
  //                         },
  //                         child: Container(
  //                           height: 20,
  //                           width: 20,
  //                           decoration: BoxDecoration(
  //                               border: Border.all(
  //                                   width:
  //                                       tempNamaLaporan1.value == "tugas_luar"
  //                                           ? 2
  //                                           : 1,
  //                                   color: Constanst.onPrimary),
  //                               borderRadius: BorderRadius.circular(10)),
  //                           child: tempNamaLaporan1.value == "tugas_luar"
  //                               ? Padding(
  //                                   padding: const EdgeInsets.all(3),
  //                                   child: Container(
  //                                     decoration: BoxDecoration(
  //                                         color: Constanst.onPrimary,
  //                                         borderRadius:
  //                                             BorderRadius.circular(10)),
  //                                   ),
  //                                 )
  //                               : Container(),
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               InkWell(
  //                 // highlightColor: Colors.white,
  //                 onTap: () {
  //                   Get.back();
  //                   Get.back();
  //                   Get.to(LaporanKlaim(
  //                     title: 'klaim',
  //                   ));
  //                   tempNamaLaporan1.value = "klaim";
  //                 },
  //                 child: Padding(
  //                   padding: const EdgeInsets.only(
  //                       top: 12, bottom: 12, left: 16, right: 16),
  //                   child: Row(
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Row(
  //                         children: [
  //                           SvgPicture.asset(
  //                             'assets/7_klaim.svg',
  //                             height: 35,
  //                             width: 35,
  //                           ),
  //                           Padding(
  //                             padding: const EdgeInsets.only(left: 12.0),
  //                             child: Text(
  //                               'Laporan Klaim',
  //                               style: GoogleFonts.inter(
  //                                   color: Constanst.fgPrimary,
  //                                   fontSize: 16,
  //                                   fontWeight: FontWeight.w500),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                       InkWell(
  //                         onTap: () {
  //                           Get.back();
  //                           Get.back();
  //                           Get.to(LaporanKlaim(
  //                             title: 'klaim',
  //                           ));
  //                           tempNamaLaporan1.value = "klaim";
  //                         },
  //                         child: Container(
  //                           height: 20,
  //                           width: 20,
  //                           decoration: BoxDecoration(
  //                               border: Border.all(
  //                                   width: tempNamaLaporan1.value == "klaim"
  //                                       ? 2
  //                                       : 1,
  //                                   color: Constanst.onPrimary),
  //                               borderRadius: BorderRadius.circular(10)),
  //                           child: tempNamaLaporan1.value == "klaim"
  //                               ? Padding(
  //                                   padding: const EdgeInsets.all(3),
  //                                   child: Container(
  //                                     decoration: BoxDecoration(
  //                                         color: Constanst.onPrimary,
  //                                         borderRadius:
  //                                             BorderRadius.circular(10)),
  //                                   ),
  //                                 )
  //                               : Container(),
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  void getEmployeeTerpilih(emId) {
    Map<String, dynamic> body = {'val': 'em_id', 'cari': emId};
    var connect = Api.connectionApi("post", body, "whereOnce-employee");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        if (valueBody['status'] == false) {
          statusLoadingSubmitLaporan.value = false;
          UtilsAlert.showToast(
              "Data periode $bulanSelectedSearchHistory belum tersedia, harap hubungi HRD");
        } else {
          List data = valueBody['data'];
          userTerpilih.value = data;
          this.userTerpilih.refresh();
        }
      }
    });
  }

  void getHistoryControl(emId, image, jobTitle) {
    var tanggalTerpilih = DateFormat('yyyy-MM-dd').format(initialDate.value);
    Map<String, dynamic> body = {'em_id': emId, 'atten_date': tanggalTerpilih};
    var connect = Api.connectionApi("post", body, "load_history_kontrol");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        if (valueBody['status'] == false) {
          UtilsAlert.showToast(
              "Data periode $bulanSelectedSearchHistory belum tersedia, harap hubungi HRD");
        } else {
          List data = valueBody['data'];
          kontrolHistory.value = data;

          loading.value = kontrolHistory.value.length == 0
              ? "Data tidak tersedia"
              : "Memuat data...";
          this.kontrolHistory.refresh();
          this.loading.refresh();
          Navigator.pop(Get.context!);
          Get.to(DetailTracking(
            emId: emId,
            image: image.toString(),
            jobTitle: jobTitle,
          ));
        }
      }
    });
  }

//   void onStartTracking(ServiceInstance service) async {
//     DartPluginRegistrant.ensureInitialized();

//     if (service is AndroidServiceInstance) {
//       service.on('setAsForeground').listen((event) {
//         service.setAsForegroundService();
//       });

//       service.on('setAsBackground').listen((event) {
//         service.setAsBackgroundService();
//       });
//     }

//     service.on('stopService').listen((event) {
//       service.stopSelf();
//     });

//     Timer.periodic(const Duration(seconds: 1), (timer) async {
//       if (service is AndroidServiceInstance) {
//         print("tes");
//         service.setForegroundNotificationInfo(
//           title: "Background Service",
//           content: "Updated at ${DateTime.now()}",
//         );
//       }
//       // Update the notification content
//       flutterLocalNotificationsPlugin.show(
//         888,
//         'Background Service',
//         'Service updated at ${DateTime.now()}',
//         const NotificationDetails(
//           android: AndroidNotificationDetails(
//             'my_foreground',
//             'MY FOREGROUND SERVICE',
//             channelDescription:
//                 'This channel is used for important notifications.',
//             importance: Importance.low,
//             priority: Priority.low,
//             ongoing: true,
//           ),
//         ),
//       );

//       print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

//       service.invoke(
//         'update',
//         {
//           "current_date": DateTime.now().toIso8601String(),
//         },
//       );
//     });
//   }

//   Future<void> initializeService() async {
//     final service = FlutterBackgroundService();

//     // OPTIONAL, using custom notification channel id
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'my_foreground', // id
//       'MY FOREGROUND SERVICE', // title
//       description:
//           'This channel is used for important notifications.', // description
//       importance: Importance.low, // default is low, other value is high
//     );

//     await service.configure(
//       androidConfiguration: AndroidConfiguration(
//         // this will be executed when app is in foreground or background in separated isolate
//         onStart: onStartTracking,

//         // auto start service
//         autoStart: true,
//         isForegroundMode: true,

//         notificationChannelId: channel.id,
//         initialNotificationTitle: 'Background Service',
//         initialNotificationContent: 'Service is running',
//         foregroundServiceNotificationId: 888,
//       ),
//       iosConfiguration: IosConfiguration(
//         // auto start service
//         autoStart: true,

//         // this will be executed when app is in foreground in separated isolate
//         onForeground: onStartTracking,

//         // you have to enable background fetch capability on xcode project
//         onBackground: onIosBackground,
//       ),
//     );

//     print("masuk sini init");

//     service.startService();
//   }

// // to ensure this executed
// // run app from xcode, then from xcode menu, select Simulate Background Fetch
//   bool onIosBackground(ServiceInstance service) {
//     WidgetsFlutterBinding.ensureInitialized();
//     print('FLUTTER BACKGROUND FETCH');
//     return true;
//   }
}
