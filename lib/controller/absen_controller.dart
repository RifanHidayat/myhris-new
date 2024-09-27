import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
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

import 'dart:io' show Platform;

import 'dart:math';
import 'package:image_picker/image_picker.dart';

import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';

import 'package:path_provider/path_provider.dart';
import 'package:siscom_operasional/controller/dashboard_controller.dart';
import 'package:siscom_operasional/controller/global_controller.dart';
import 'package:siscom_operasional/controller/tracking_controller.dart';
import 'package:siscom_operasional/database/sqlite/sqlite_database_helper.dart';
import 'package:siscom_operasional/model/absen_model.dart';

import 'package:siscom_operasional/model/shift_model.dart';
import 'package:siscom_operasional/screen/absen/berhasil_absen.dart';
import 'package:siscom_operasional/screen/absen/berhasil_registrasi.dart';
import 'package:siscom_operasional/screen/absen/camera_view_location.dart';
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

import 'package:flutter/services.dart';
import 'package:android_intent/android_intent.dart';
import 'package:android_intent/flag.dart';

class AbsenController extends GetxController {
  var globalCt = Get.put(GlobalController());
  final controllerTracking = Get.put(TrackingController());

  PageController? pageViewFilterAbsen;

  RxBool isChecked = false.obs;
  RxBool isChecked2 = false.obs;
  RxBool selengkapnyaMasuk = false.obs;
  RxBool selengkapnyaKeluar = false.obs;

  Rx<DateTime> selectedDate = DateTime.now().obs;

  var tglAjunan = "".obs;
  var checkinAjuan = "".obs;
  var checkoutAjuan = "".obs;
  var checkinAjuan2 = "".obs;
  var checkoutAjuan2 = "".obs;
  var catataanAjuan = TextEditingController();
  var imageAjuan = "".obs;
  var nomorAjuan = "".obs;

  var pengajuanAbsensi = [].obs;

  TextEditingController deskripsiAbsen = TextEditingController();
  var tanggalLaporan = TextEditingController().obs;
  var departemen = TextEditingController().obs;
  var cari = TextEditingController().obs;

  var fotoUser = File("").obs;

  var settingAppInfo = AppData.infoSettingApp.obs;

  Rx<List<String>> placeCoordinateDropdown = Rx<List<String>>([]);
  var placeCoordinateCheckin = [].obs;
  var placeCoordinateCheckout = [].obs;

  var absenLongLatMasuk = [].obs;
  var absenKeluarLongLat = [].obs;
  var addressMasuk = "".obs;
  var addressKeluar = "".obs;

  var selectedType = "".obs;

  var pauseCamera = false.obs;

  var tempKodeStatus1 = "".obs;
  var tempNamaStatus1 = "Semua".obs;
  var tempNamaLaporan1 = "Semua".obs;
  var tempNamaTipe1 = "".obs;

  var historyAbsen = <AbsenModel>[].obs;
  var tempHistoryAbsen = <AbsenModel>[].obs;
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
  var isCollapse = true.obs;
  var shift = OfficeShiftModel().obs;

  var isLoadingPengajuan = false.obs;

  var absenSelected;

  var loading = "Memuat data...".obs;
  var loadingPengajuan = "Memuat data...".obs;
  var base64fotoUser = "".obs;
  var timeString = "".obs;
  var dateNow = "".obs;
  var alamatUserFoto = "".obs;
  var titleAbsen = "".obs;
  var tanggalUserFoto = "".obs;

  var stringImageSelected = "".obs;

  var bulanSelectedSearchHistory = "".obs;
  var tahunSelectedSearchHistory = "".obs;
  var bulanDanTahunNow = "".obs;

  var bulanSelectedSearchHistoryPengajuan = "".obs;
  var tahunSelectedSearchHistoryPengajuan = "".obs;
  var bulanDanTahunNowPengajuan = "".obs;

  var namaDepartemenTerpilih = "".obs;
  var idDepartemenTerpilih = "".obs;
  var testingg = "".obs;
  var filterLokasiKoordinate = "Lokasi".obs;
  Rx<AbsenModel> absenModel = AbsenModel().obs;
  var jumlahData = 0.obs;
  var isTracking = 0.obs;
  var activeTracking = 0.obs;
  var selectedViewFilterAbsen = 0.obs;
  var regType = 0.obs;
  var namaFileUpload = "".obs;
  var filePengajuan = File("").obs;
  var uploadFile = false.obs;
  var isLoaingAbsensi = false.obs;

  Rx<DateTime> pilihTanggalTelatAbsen = DateTime.now().obs;

  var latUser = 0.0.obs;
  var langUser = 0.0.obs;

  var typeAbsen = 0.obs;
  var intervalControl = 60000.obs;

  var imageStatus = false.obs;
  var detailAlamat = false.obs;
  var mockLocation = false.obs;
  var showButtonlaporan = false.obs;
  var statusLoadingSubmitLaporan = false.obs;
  var statusCari = false.obs;
  var filterLaporanAbsenTanggal = false.obs;

  var absenStatus = false.obs;
  var gagalAbsen = 0.obs;
  var failured = "".obs;
  RxString absenSuccess = "0".obs;

  var coordinate = false.obs;

  @override
  void onReady() async {
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

  Future<void> getTimeNow() async {
    var dt = DateTime.parse(AppData.endPeriode);
    bulanSelectedSearchHistory.value = "${dt.month}";
    tahunSelectedSearchHistory.value = "${dt.year}";

    bulanSelectedSearchHistoryPengajuan.value = "${dt.month}";
    tahunSelectedSearchHistoryPengajuan.value = "${dt.year}";
    bulanDanTahunNow.value = "${dt.month}-${dt.year}";
    bulanDanTahunNowPengajuan.value = "${dt.month}-${dt.year}";
    var convert = Constanst.convertDate1("${dt.year}-${dt.month}-${dt.day}");
    tanggalLaporan.value.text = convert;
    absenStatus.value = AppData.statusAbsen;
    // this.absenStatus.refresh();
  }

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
            } else if (status == 2) {
              idDepartemenTerpilih.value = "${departementAkses[0]['id']}";
              namaDepartemenTerpilih.value = departementAkses[0]['name'];
              departemen.value.text = departementAkses[0]['name'];
              showButtonlaporan.value = true;
              aksiEmployeeTerlambatAbsen(tanggal);
            } else if (status == 3) {
              idDepartemenTerpilih.value = "${departementAkses[0]['id']}";
              namaDepartemenTerpilih.value = departementAkses[0]['name'];
              departemen.value.text = departementAkses[0]['name'];
              showButtonlaporan.value = true;
              aksiEmployeeBelumAbsen(tanggal);
            }
          }
        }
      }
    });
  }

  Future<void> getPlaceCoordinate() async {
    // placeCoordinate.clear();

    placeCoordinateDropdown.value.clear();
    var connect = Api.connectionApi("get", {}, "places_coordinate",
        params: "&id=${AppData.informasiUser![0].em_id}");
    connect.then((dynamic res) {
      if (res == false) {
        print("errror");
        coordinate.value = true;
        getPlaceCoordinateOffline();
        //UtilsAlert.koneksiBuruk();
      } else {
        if (res.statusCode == 200) {
          coordinate.value = false;
          print("Place cordinate 200" + res.body.toString());
          var valueBody = jsonDecode(res.body);

          var temporary = valueBody['data'];

          List<Map<String, dynamic>> tipeLokasi = [];
          for (var element in temporary) {
            tipeLokasi.add({
              'id': element['id'],
              'place': element['place'],
              'place_longlat': element['place_longlat'],
              'place_radius': element['place_radius'],
            });
          }
          SqliteDatabaseHelper().insertTipeLokasi(tipeLokasi);

          controller.checkAbsenUser(
              DateFormat('yyyy-MM-dd').format(DateTime.now()),
              AppData.informasiUser![0].em_id);
          // selectedType.value = valueBody['data'][0]['place'];

          print("controller.wfhlokasi ${controller.wfhlokasi.value}");

          if (typeAbsen.value == 1) {
            selectedType.value = valueBody['data'][0]['place'];
          } else {
            if (controller.wfhlokasi.value == true) {
              selectedType.value = 'WFH';
            } else {
              selectedType.value = valueBody['data'][0]['place'];
            }
          }

          for (var element in valueBody['data']) {
            // placeCoordinateDropdown.value.add(element['place']);
            if (typeAbsen.value == 1) {
              placeCoordinateDropdown.value.add(element['place']);
            } else {
              if (controller.wfhlokasi.value == true) {
                placeCoordinateDropdown.value.add('WFH');
              } else {
                placeCoordinateDropdown.value.add(element['place']);
              }
            }
          }
          List filter = [];
          for (var element in valueBody['data']) {
            if (element['isFilterView'] == 1) {
              filter.add(element);
            }
          }

          print("data ${placeCoordinate.value}");
          // placeCoordinate.clear();
          placeCoordinate.value = filter;
          placeCoordinate.refresh();
          placeCoordinate.refresh();
        } else {
          print("Place cordinate !=200" + res.body.toString());
          print(res.body.toString());
        }
      }
    }).catchError((error) {
      coordinate.value = true;
      getPlaceCoordinateOffline();
    });
  }

  void getPlaceCoordinateOffline() async {
    var body = await SqliteDatabaseHelper().getTipeLokasi();

    placeCoordinateDropdown.value.clear();
    if (typeAbsen.value == 1) {
      selectedType.value = body[0]['place'];
    } else {
      if (controller.wfhlokasi.value == true) {
        selectedType.value = 'WFH';
      } else {
        selectedType.value = body[0]['place'];
      }
    }

    for (var element in body) {
      // placeCoordinateDropdown.value.add(element['place']);
      if (typeAbsen.value == 1) {
        placeCoordinateDropdown.value.add(element['place']);
      } else {
        if (controller.wfhlokasi.value == true) {
          placeCoordinateDropdown.value.add('WFH');
        } else {
          placeCoordinateDropdown.value.add(element['place']);
        }
      }
    }
    List filter = [];
    for (var element in body) {
      filter.add(element);
    }

    // placeCoordinate.clear();
    placeCoordinate.value = filter;
    placeCoordinate.refresh();
    placeCoordinate.refresh();
  }

  Future<void> offlineToOnline() async {
    if (authController.isConnected.value) {
      coordinate.value = false;
    }
  }

  Future<void> getPlaceCoordinate1() async {
    var connect = Api.connectionApi("get", {}, "places_coordinate",
        params: "&id=${AppData.informasiUser![0].em_id}");

    connect.then((dynamic res) {
      if (res == false) {
        print("error");
        coordinate.value = true;
        // UtilsAlert.koneksiBuruk();
      } else {
        print("sukses");
        coordinate.value = false;
      }
    }).catchError((error) {
      coordinate.value = true;
    });
    ;
  }

  void getPlaceCoordinateCheckin() {
    print("place coordinates");
    placeCoordinate.clear();

    var connect = Api.connectionApi(
      "get",
      {},
      "places_coordinate_pengajuan",
      params: "&id=${AppData.informasiUser![0].em_id}&date=${tglAjunan.value}",
    );

    connect.then((dynamic res) {
      if (res == false) {
        print("error");
        //UtilsAlert.koneksiBuruk();
      } else {
        if (res.statusCode == 200) {
          print("Place coordinate 200" + res.body.toString());
          var valueBody = jsonDecode(res.body);
          selectedType.value = valueBody['data'][0]['place'];

          List filter = [];
          for (var element in valueBody['data']) {
            if (element['isFilterView'] == 1) {
              element['is_selected'] = false;
              filter.add(element);
            }
          }
          placeCoordinateCheckin.value = filter;
          placeCoordinateCheckin.refresh();
        } else {
          print("Place coordinate !=200" + res.body.toString());
        }
      }
    });
    placeCoordinateCheckin.refresh();
  }

  void getPlaceCoordinateCheckout() {
    print("place coordinates");
    placeCoordinate.clear();

    var connect = Api.connectionApi(
      "get",
      {},
      "places_coordinate_pengajuan",
      params: "&id=${AppData.informasiUser![0].em_id}&date=${tglAjunan.value}",
    );

    connect.then((dynamic res) {
      if (res == false) {
        print("error");
        //UtilsAlert.koneksiBuruk();
      } else {
        if (res.statusCode == 200) {
          print("Place coordinate 200" + res.body.toString());
          var valueBody = jsonDecode(res.body);
          selectedType.value = valueBody['data'][0]['place'];

          List filter = [];
          for (var element in valueBody['data']) {
            if (element['isFilterView'] == 1) {
              element['is_selected'] = false;
              filter.add(element);
            }
          }

          placeCoordinateCheckout.value = filter;
          placeCoordinateCheckout.refresh();
        } else {
          print("Place coordinate !=200" + res.body.toString());
        }
      }
    });
    placeCoordinateCheckout.refresh();
  }

  // latlong convert
  Future<void> convertLatLongListToAddresses(latLongList) async {
    // absenKeluarLongLat.clear();
    try {
      //  for (var coordinates in latLongList) {
      double latitude = double.parse(latLongList[0].toString());
      double longitude = double.parse(latLongList[1].toString());

      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        var place = placemarks.first;
        var addressData = {
          'name': place.name ?? '',
          'locality': place.locality ?? '',
          'postalCode': place.postalCode ?? '',
          'country': place.country ?? '',
          "street": place.street ?? '',
          'subLocality': place.subLocality ?? '',
          'subAdministrativeArea': place.subAdministrativeArea ?? '',
          'administrativeArea': place.administrativeArea ?? ''
        };
        String formattedAddress =
            "${place.street}, ${place.name}, ${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.postalCode}";
        addressKeluar.value = formattedAddress;
      } else {}
      //  }
    } catch (e) {}
  }

  Future<void> convertLatLongListToAddressesin(latLongList) async {
    // absenLongLatMasuk.clear();
    try {
      //  for (var coordinates in latLongList) {
      double latitude = double.parse(latLongList[0].toString());
      double longitude = double.parse(latLongList[1].toString());

      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        var place = placemarks.first;
        var addressData = {
          'name': place.name ?? '',
          'locality': place.locality ?? '',
          'postalCode': place.postalCode ?? '',
          'country': place.country ?? '',
          "street": place.street ?? '',
          'subLocality': place.subLocality ?? '',
          'subAdministrativeArea': place.subAdministrativeArea ?? '',
          'administrativeArea': place.administrativeArea ?? ''
        };
        String formattedAddress =
            "${place.street}, ${place.name}, ${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.postalCode}";
        addressMasuk.value = formattedAddress;
      } else {}
      //  }
    } catch (e) {}
  }

// latlong convert
  void filterAbsenTelat() {
    var tanggal = DateFormat('yyyy-MM-dd').format(pilihTanggalTelatAbsen.value);
    getDepartemen(2, tanggal);
  }

  void filterBelumAbsen() {
    var tanggal = DateFormat('yyyy-MM-dd').format(pilihTanggalTelatAbsen.value);
    getDepartemen(3, tanggal);
  }

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

  Future<void> refreshPage() async {
    getPosisition();
    getPlaceCoordinate1();
    mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(latUser.value, langUser.value), zoom: 20)
        //17 is new zoom level
        ));
    print("cuy: ${latUser.value} , ${langUser.value}");
  }

  Future<void> refreshPageOffline() async {
    getPosisition();
    getPlaceCoordinateOffline();
    print("data woy ${placeCoordinate.value}");
    mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(latUser.value, langUser.value), zoom: 20)
        //17 is new zoom level
        ));
  }

  void removeAll() {
    fotoUser.value = File("");
    base64fotoUser.value = "";
    timeString.value = "";
    dateNow.value = "";
    alamatUserFoto.value = "";
    alamatUserFoto.value = "";

    latUser.value = 0.0;
    langUser.value = 0.0;

    imageStatus.value = false;

    deskripsiAbsen.clear();
    //rhistoryAbsen.value.clear();
  }

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

  void facedDetection({required status, absenStatus, type, img}) async {
    if (status == "registration") {
      saveFaceregistration(img);
    } else {
      detection(file: img, status: absenStatus, type: type);
    }
  }

  void saveFaceregistration(file) async {
    UtilsAlert.showLoadingIndicator(Get.context!);

    final box = GetStorage();
    File image = new File(file); // Or any other way to get a File instance.
    var decodedImage = await decodeImageFromList(image.readAsBytesSync());
    Map<String, String> headers = {
      'Authorization': Api.basicAuth,
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'token': Api.token,
      // 'em_id':AppData.informasiUser==null || AppData.informasiUser=="null" || AppData.informasiUser=="" || AppData.informasiUser!.isEmpty ?"":AppData.informasiUser![0].em_id
    };

    var request = http.MultipartRequest(
      "POST",
      Uri.parse(Api.luxand),
    );
    request.headers.addAll(headers);
    File file1 = await urlToFile(
        "${Api.urlImage}/${AppData.selectedDatabase}/face_recog/${GetStorage().read('file_face')}");

    var picture = await http.MultipartFile.fromPath('face1', file.toString(),
        contentType: MediaType('image', 'png'));
    var picture1 = await http.MultipartFile.fromPath('face2', file.toString(),
        contentType: MediaType('image', 'png'));
    request.files.add(picture);
    request.files.add(picture1);

    var response = await request.send();
    final respStr = await response.stream.bytesToString();
    final res = jsonDecode(respStr.toString());
    print(res);

    if (res['similar'] == true) {
      try {
        var dataUser = AppData.informasiUser;
        var getEmpId = dataUser![0].em_id;
        Map<String, String> headers = {
          'Authorization': Api.basicAuth,
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'token': AppData.setFcmToken,
          'em_id': AppData.informasiUser == null ||
                  AppData.informasiUser == "null" ||
                  AppData.informasiUser == "" ||
                  AppData.informasiUser!.isEmpty
              ? ""
              : AppData.informasiUser![0].em_id
        };
        Map<String, String> body = {
          'em_id': getEmpId.toString(),
          'width': decodedImage.width.toString(),
          'height': decodedImage.height.toString()
        };
        var request = http.MultipartRequest(
          "POST",
          Uri.parse(Api.basicUrl +
              "edit_face?database=${AppData.selectedDatabase.toString()}"),
        );
        request.fields.addAll(body);
        request.headers.addAll(headers);
        // if (fotoUser.value != null) {
        var picture = await http.MultipartFile.fromPath('file', file.toString(),
            contentType: MediaType('image', 'png'));
        request.files.add(picture);
        // }
        var response = await request.send();
        final respStr = await response.stream.bytesToString();
        final res = jsonDecode(respStr.toString());

        if (res['status'] == true) {
          Get.back();
          employeDetail();
          box.write("face_recog", true);
          gagalAbsen.value = gagalAbsen.value;

          // Get.back();
          Navigator.push(
            Get.context!,
            MaterialPageRoute(
                builder: (context) => const BerhasilRegistration()),
          );
        } else {
          // Get.back();
          UtilsAlert.showToast(res['message']);
        }
      } on Exception catch (e) {
        print(e.toString());
        Get.back();
        UtilsAlert.showToast(e.toString());
        throw e;
      }
    } else {
      Get.back();
      UtilsAlert.showToast(res['message']);
    }
  }

  void detection({file, type, status}) async {
    employeDetail();
    var bytes = File(file).readAsBytesSync();
    base64fotoUser.value = base64Encode(bytes);
    Future.delayed(const Duration(milliseconds: 500), () {});
    File image = new File(file); // Or any other way to get a File instance.
    var decodedImage = await decodeImageFromList(image.readAsBytesSync());

    try {
      var dataUser = AppData.informasiUser;
      var getEmpId = dataUser![0].em_id;

      Map<String, String> body = {
        'em_id': getEmpId.toString(),
        'width': decodedImage.width.toString(),
        'height': decodedImage.height.toString(),

        // 'image': file.toString()
      };
      Map<String, String> headers = {
        'Authorization': Api.basicAuth,
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'token': Api.token,
        //    'token': AppData.setFcmToken,
        // 'em_id':AppData.informasiUser==null || AppData.informasiUser=="null" || AppData.informasiUser=="" || AppData.informasiUser!.isEmpty ?"":AppData.informasiUser![0].em_id
      };
      var request = http.MultipartRequest(
        "POST",
        Uri.parse(Api.luxand),
      );

      request.headers.addAll(headers);
      File file1 = await urlToFile(
          "${Api.urlImage}/${AppData.selectedDatabase}/face_recog/${GetStorage().read('file_face')}");

      // if (fotoUser.value != null) {
      var picture = await http.MultipartFile.fromPath('face1', file,
          contentType: MediaType('image', 'png'));
      var picture1 = await http.MultipartFile.fromPath('face2', file1.path,
          contentType: MediaType('image', 'png'));
      request.files.add(picture);
      request.files.add(picture1);
      //  }
      var response = await request.send();
      final respStr = await response.stream.bytesToString();
      final res = jsonDecode(respStr.toString());

      if (response.statusCode == 200) {
        if (res['similar'] == true) {
          absenSuccess.value = "1";

          // DateTime startDate = await NTP.now();
          DateTime startDate = DateTime.now();

          // // absenSelfie();
          timeString.value = formatDateTime(startDate);
          dateNow.value = dateNoww(startDate);
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

          // Navigator.push(
          //   Get.context!,
          //   MaterialPageRoute(
          //       builder: (context) => AbsenMasukKeluar(
          //             status: status,
          //             // type: type.toString(),
          //           )),
          // );

          // UtilsAlert.showToast(res['message']);
        } else {
          absenSuccess.value = "0";

          gagalAbsen.value = gagalAbsen.value + 1;

          // UtilsAlert.showToast(res['message']);
          // print("status ${titleAbsen.value}");
          // if (gagalAbsen.value >= 3) {
          //   Get.back();
          //   Get.to(AbsenVrifyPassword(
          //     status: status,
          //     type: type.toString(),
          //   ));
          // } else {
          //   Get.back();
          //   Get.back();
          //   print("titleAbsen.value");

          //   // facedDetection(
          //   //   absenStatus: status,
          //   //   status: "detection",
          //   //   type: type.toString(),
          //   // );
          //   // Get.to(FaceDetectorView(
          //   //   status: status == "masuk" ? "masuk" : "keluar",
          //   // ));
          // }
        }
      } else {}
    } on Exception catch (e) {
      print(e.toString());
      Get.back();
      UtilsAlert.showToast(e.toString());
      throw e;
    }
  }

  Future<File> urlToFile(String imageUrl) async {
// generate random number.
    var rng = new Random();
// get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
// get temporary path from temporary directory.
    String tempPath = tempDir.path;
// create a new file in temporary path with random file name.
    File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
// call http.get method and pass imageUrl into it to get response.
    http.Response response = await http.get(Uri.parse(imageUrl));
// write bodyBytes received in response to file.
    await file.writeAsBytes(response.bodyBytes);
// now return the file which is created with random name in
// temporary directory and image bytes from response is written to // that file.
    return file;
  }

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

  Future<void> getPosisition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      print(place);
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

  void ulangiFoto() {
    imageStatus.value = false;
    fotoUser.value = File("");
    base64fotoUser.value = "";
    alamatUserFoto.value = "";
    absenSelfie();
  }

  Future<void> bukaOpsiPengembangSettings() async {
    const intent = AndroidIntent(
      action: 'android.settings.APPLICATION_DEVELOPMENT_SETTINGS',
      package: 'com.android.settings',
      // componentName: 'com.android.settings/.DevelopmentSettings',
      // packageName: 'com.android.settings',
      flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
    );

    try {
      await intent.launch();
    } on PlatformException catch (e) {
      print('Failed to open developer options settings: ${e.message}');
    }
  }

  static const platform = MethodChannel('com.example.mocklocation/detect');
  var statusDeteksi = false.obs;
  var statusDeteksi2 = false.obs;
  GoogleMapController? mapController;
  var loadingButton = false.obs;

  Future<void> deteksiFakeGps(BuildContext context) async {
    if (Platform.isAndroid) {
      statusDeteksi.value = await platform.invokeMethod('checkMockLocation');
    } else if (Platform.isIOS) {
      statusDeteksi.value = await platform.invokeMethod('checkMockLocationIOS');
    }

    if (statusDeteksi.value == true) {
      statusDeteksi2.value = true;

      final maxWidth = MediaQuery.of(context).size.width;
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
              title: "Fake GPS Tedeteksi",
              content:
                  "Silahkan menonaktifkan fake gps sebelum melakukan absen",
              positiveBtnText: "Kembali",
              style: 1,
              buttonStatus: 1,
              positiveBtnPressed: () async {
                Get.back();
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
    update();
  }

  void kirimDataAbsensi({typewfh}) async {
//// untuk cek absensi
    print("view last absen user 3");
    print("tes ${AppData.informasiUser![0].startTime.toString()}");
    var startTime = "";
    var endTime = "";
    var startDate = "";
    var endDate = "";
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

    int totalMinutes1 = waktu1.hour * 60 + waktu1.minute;
    int totalMinutes2 = waktu2.hour * 60 + waktu2.minute;

    //alur normal
    if (totalMinutes1 < totalMinutes2) {
      startTime = AppData.informasiUser![0].startTime;
      endTime = AppData.informasiUser![0].endTime;

      startDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      //alur beda hari
    } else if (totalMinutes1 > totalMinutes2) {
      var waktu3 =
          TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
      int totalMinutes3 = waktu3.hour * 60 + waktu3.minute;

      if (totalMinutes2 > totalMinutes3) {
        startTime = AppData.informasiUser![0].endTime;
        endTime = AppData.informasiUser![0].startTime;

        startDate = DateFormat('yyyy-MM-dd')
            .format(DateTime.now().add(const Duration(days: -1)));

        endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      } else {
        startTime = AppData.informasiUser![0].endTime;
        endTime = AppData.informasiUser![0].startTime;

        endDate = DateFormat('yyyy-MM-dd')
            .format(DateTime.now().add(const Duration(days: 1)));

        startDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      }
    } else {
      startTime = AppData.informasiUser![0].startTime;
      endTime = AppData.informasiUser![0].endTime;

      startDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      print("Waktu 1 sama dengan waktu 2");
    }

    ////////

    print("typewfh ${typewfh}");
    employeDetail();
    // if (base64fotoUser.value == "") {
    //   UtilsAlert.showToast("Silahkan Absen");
    // } else {

    if (Platform.isAndroid) {
      // TrustLocation.start(1);
      getCheckMock();
      if (!mockLocation.value) {
        var statusPosisi = await validasiRadius();
        if (statusPosisi == true) {
          var latLangAbsen = "${latUser.value},${langUser.value}";
          var dataUser = AppData.informasiUser;
          var getEmpId = dataUser![0].em_id;
          var getSettingAppSaveImageAbsen = "1";
          var validasiGambar =
              getSettingAppSaveImageAbsen == "NO" ? "" : base64fotoUser.value;

          var getFullName = "${dataUser![0].full_name}";
          var convertTanggalBikinPengajuan =
              // status == false
              //     ? Constanst.convertDateSimpan(
              //         pilihTanggalTelatAbsen.value.toString())
              //     :
              pilihTanggalTelatAbsen.value.toString();
          var getEmid = "${dataUser![0].em_id}";
          var stringTanggal = "${tglAjunan.value} sd ${tglAjunan.value}";
          var typeNotifFcm = "Pengajuan WFH";
          var now = DateTime.now();
          var convertBulan = now.month <= 9 ? "0${now.month}" : now.month;
          var getNomorAjuanTerakhir = nomorAjuan;

          if (typeAbsen.value == 1 && typewfh == "wfh") {
            for (var item in globalCt.konfirmasiAtasan) {
              print("Token notif ${item['token_notif']}");
              var pesan;
              if (item['em_gender'] == "PRIA") {
                pesan =
                    "Hallo pak ${item['full_name']}, saya ${getFullName} mengajukan Absen WFH dengan nomor ajuan ${getNomorAjuanTerakhir}";
              } else {
                pesan =
                    "Hallo bu ${item['full_name']}, saya ${getFullName} mengajukan Absen WFH dengan nomor ajuan ${getNomorAjuanTerakhir}";
              }

              kirimNotifikasiToDelegasi1(
                  getFullName,
                  convertTanggalBikinPengajuan,
                  item['em_id'],
                  '',
                  stringTanggal,
                  typeNotifFcm,
                  pesan,
                  'Approval WFH');

              if (item['token_notif'] != null) {
                globalCt.kirimNotifikasiFcm(
                  title: typeNotifFcm,
                  message: pesan,
                  tokens: item['token_notif'],
                );
              }
            }
          }
          if (typeAbsen.value == 1) {
            absenStatus.value = true;
            AppData.statusAbsen = true;
            AppData.dateLastAbsen = tanggalUserFoto.value;
          } else {
            absenStatus.value = false;
            AppData.statusAbsen = false;
            AppData.dateLastAbsen = tanggalUserFoto.value;
          }
          Map<String, dynamic> body = typewfh == "wfh"
              ? {
                  'em_id': getEmpId,
                  'date': tanggalUserFoto.value,
                  'uraian': deskripsiAbsen.value.text,
                  'place': selectedType.value,
                  'lokasi': alamatUserFoto.value,
                  'latLang': latLangAbsen,

                  // 'waktu': timeString.value,
                  // // 'gambar': validasiGambar,
                  // 'reg_type': regType.value,
                  // 'gambar': base64fotoUser.value,
                  // 'lokasi': alamatUserFoto.value,
                  // 'latLang': latLangAbsen,
                  // 'typeAbsen': typeAbsen.value,
                  // 'kategori': "1"

                  'start_date': startDate,
                  'end_date': endDate,
                  'start_time': startTime,
                  'end_time': endTime,
                }
              : {
                  'em_id': getEmpId,
                  'tanggal_absen': tanggalUserFoto.value,
                  'waktu': timeString.value,
                  // 'gambar': validasiGambar,
                  'reg_type': regType.value,

                  'lokasi': alamatUserFoto.value,
                  'latLang': latLangAbsen,
                  'catatan': deskripsiAbsen.value.text,
                  'typeAbsen': typeAbsen.value,
                  'place': selectedType.value,
                  'kategori': "1",
                  'gambar': base64fotoUser.value,

                  'start_date': startDate,
                  'end_date': endDate,
                  'start_time': startTime,
                  'end_time': endTime,
                };
          print("parameter wfh ${body}");
          isLoaingAbsensi.value = true;
          var connect = Api.connectionApi(
              "post", body, typewfh == "wfh" ? "wfh" : "kirimAbsen");
          connect.then((dynamic res) async {
            print("respon wfh ${res.statusCode}");
            if (res.statusCode == 200) {
              var valueBody = jsonDecode(res.body);
              print("respon wfh ${valueBody}");
              // for (var element in sysData.value) {
              //   if (element['kode'] == '006') {
              //     intervalControl.value = int.parse(element['name'].toString());
              //   }
              // }
              isLoaingAbsensi.value = false;
              this.intervalControl.refresh();

              print("dapat interval ${intervalControl.value}");
              // Navigator.pop(Get.context!);
              ;

              print(
                  "isViewTracking ${AppData.informasiUser![0].isViewTracking.toString()}");
              print("isViewTracking ${typeAbsen.value}");
              if (AppData.informasiUser![0].isViewTracking.toString() == '0') {
                controllerTracking.bagikanlokasi.value = "aktif";

                // final service = FlutterBackgroundService();
                // FlutterBackgroundService().invoke("setAsBackground");

                // service.startService();
                controllerTracking.updateStatus('1');
                controllerTracking.isTrackingLokasi.value = true;
                // controllerTracking.detailTracking(emIdEmployee: '');
                print(
                    "startTracking ${AppData.informasiUser![0].isViewTracking.toString()}");
              }

              if (typeAbsen.value == 2) {
                controllerTracking.bagikanlokasi.value = "tidak aktif";
                // await LocationDao().clear();
                // await _getLocations();
                // await BackgroundLocationTrackerManager.stopTracking();
                // final service = FlutterBackgroundService();
                // FlutterBackgroundService().invoke("setAsBackground");

                // service.invoke("stopService");
                controllerTracking.updateStatus('0');
                controllerTracking.isTrackingLokasi.value = false;
                print(
                    "stopTracking ${AppData.informasiUser![0].isViewTracking.toString()}");
              }

              Get.to(BerhasilAbsensi(
                dataBerhasil: [
                  titleAbsen.value,
                  timeString.value,
                  typeAbsen.value,
                  intervalControl.value
                ],
              ));
            } else {
              UtilsAlert.showCheckOfflineAbsensiKesalahanServer(
                  positiveBtnPressed: () {
                kirimDataAbsensiOffline(typewfh: typewfh);
              });
              isLoaingAbsensi.value = false;
              Get.back();
              //error
            }
          }).catchError((error) {
            isLoaingAbsensi.value = false;
            Get.back();
            UtilsAlert.showCheckOfflineAbsensiKesalahanServer(
                positiveBtnPressed: () {
              kirimDataAbsensiOffline(typewfh: typewfh);
            });
          });
        }
      } else {
        isLoaingAbsensi.value = false;
        UtilsAlert.showToast("Periksa GPS anda");
      }
    } else if (Platform.isIOS) {
      var statusPosisi = await validasiRadius();
      if (statusPosisi == true) {
        var latLangAbsen = "${latUser.value},${langUser.value}";
        var dataUser = AppData.informasiUser;
        var getEmpId = dataUser![0].em_id;
        // var getSettingAppSaveImageAbsen =
        //     settingAppInfo.value![0].saveimage_attend;
        var getSettingAppSaveImageAbsen = "1";
        var validasiGambar =
            getSettingAppSaveImageAbsen == "NO" ? "" : base64fotoUser.value;
        if (typeAbsen.value == 1) {
          absenStatus.value = true;
          AppData.statusAbsen = true;
          AppData.dateLastAbsen = tanggalUserFoto.value;
        } else {
          absenStatus.value = false;
          AppData.statusAbsen = false;
          AppData.dateLastAbsen = tanggalUserFoto.value;
        }
        Map<String, dynamic> body = {
          'em_id': getEmpId,
          'tanggal_absen': tanggalUserFoto.value,
          'waktu': timeString.value,
          // 'gambar': validasiGambar,
          'reg_type': regType.value.toString(),
          'gambar': base64fotoUser.value,
          'lokasi': alamatUserFoto.value,
          'latLang': latLangAbsen,
          'catatan': deskripsiAbsen.value.text,
          'typeAbsen': typeAbsen.value,
          'place': selectedType.value,
          'kategori': "1",

          'start_date': startDate,
          'end_date': endDate,
          'start_time': startTime,
          'end_time': endTime,
        };
        isLoaingAbsensi.value = true;

        var connect = Api.connectionApi("post", body, "kirimAbsen");
        connect.then((dynamic res) {
          if (res.statusCode == 200) {
            var valueBody = jsonDecode(res.body);
            print(res.body);
            for (var element in sysData.value) {
              if (element['kode'] == '006') {
                intervalControl.value = int.parse(element['name']);
              }
            }
            isLoaingAbsensi.value = false;
            this.intervalControl.refresh();

            print("dapat interval ${intervalControl.value}");
            Get.back();
            Get.offAll(BerhasilAbsensi(
              dataBerhasil: [
                titleAbsen.value,
                timeString.value,
                typeAbsen.value,
                intervalControl.value
              ],
            ));
          } else {
            isLoaingAbsensi.value = false;
            Get.back();
            UtilsAlert.showCheckOfflineAbsensiKesalahanServer(
                positiveBtnPressed: () {
              kirimDataAbsensiOffline(typewfh: typewfh);
            });
          }
        }).catchError((error) {
          isLoaingAbsensi.value = false;
          Get.back();
          UtilsAlert.showCheckOfflineAbsensiKesalahanServer(
              positiveBtnPressed: () {
            kirimDataAbsensiOffline(typewfh: typewfh);
          });
        });
      }
    }

    //  }
  }

  void kirimDataAbsensiOffline({typewfh}) async {
    var latLangAbsen = "${latUser.value},${langUser.value}";

    //     absenStatus.value = false;
    // AppData.statusAbsen = false;
    // AppData.dateLastAbsen = tanggalUserFoto.value;
    var statusPosisi = await validasiRadius();
    if (statusPosisi == true) {
      if (typeAbsen.value == 1) {
        absenStatus.value = true;
        AppData.statusAbsen = true;
        AppData.dateLastAbsen = tanggalUserFoto.value;

        Map<String, dynamic> absensi = {
          'em_id': AppData.informasiUser![0].em_id,
          'atten_date': tanggalUserFoto.value,
          'signing_time': timeString.value,
          'place_in': selectedType.value,
          'signin_longlat': latLangAbsen,
          'signin_note': deskripsiAbsen.value.text,
          'signin_addr': alamatUserFoto.value,
          'signout_time': "",
          'place_out': "",
          'signout_longlat': "",
          'signout_note': "",
          'signout_addr': "",
          'signout_pict': "",
          'signin_pict': base64fotoUser.value,
        };

        AppData.signingTime = timeString.value;
        AppData.statusAbsenOffline = true;
        AppData.signoutTime = "";
        AppData.textPendingMasuk = true;

        SqliteDatabaseHelper().deleteAbsensi().then((_) {
          SqliteDatabaseHelper().insertAbsensi(absensi, () {
            authController.kirims.value = false;
            Get.to(BerhasilAbsensi(
              dataBerhasil: [
                titleAbsen.value,
                timeString.value,
                typeAbsen.value,
                intervalControl.value,
              ],
            ));
          }, (error) {
            // Tampilkan error jika insertAbsensi gagal
            Get.snackbar("Error", error);
          });
        }).catchError((error) {
          // Jika terjadi kesalahan pada penghapusan absensi
          Get.snackbar("Error", "Gagal menghapus absensi: $error");
        });
      } else {
        absenStatus.value = false;
        AppData.statusAbsen = false;
        AppData.dateLastAbsen = tanggalUserFoto.value;

        AppData.signoutTime = timeString.value;
        AppData.statusAbsenOffline = true;
        AppData.textPendingKeluar = true;

        var absenMasukKeluarOffline = await SqliteDatabaseHelper().getAbsensi();

        if (absenMasukKeluarOffline != null) {
          SqliteDatabaseHelper().updateAbsensi({
            'signout_time': timeString.value,
            'place_out': selectedType.value,
            'signout_longlat': latLangAbsen,
            'signout_pict': base64fotoUser.value,
            'signout_note': deskripsiAbsen.value.text,
            'signout_addr': alamatUserFoto.value,
          }).then((rowsUpdated) {
            authController.kirims.value == false;
            Get.to(BerhasilAbsensi(
              dataBerhasil: [
                titleAbsen.value,
                timeString.value,
                typeAbsen.value,
                intervalControl.value
              ],
            ));
          });
        } else {
          Map<String, dynamic> absensi = {
            'em_id': AppData.informasiUser![0].em_id,
            'atten_date': tanggalUserFoto.value,
            'signing_time': "",
            'place_in': "",
            'signin_longlat': "",
            'signin_note': "",
            'signin_addr': "",
            'signout_time': timeString.value,
            'place_out': selectedType.value,
            'signout_longlat': latLangAbsen,
            'signout_pict': base64fotoUser.value,
            'signout_note': deskripsiAbsen.value.text,
            'signout_addr': alamatUserFoto.value,
            'signin_pict': "",
          };

          SqliteDatabaseHelper().insertAbsensi(absensi, () {
            authController.kirims.value = false;
            Get.to(BerhasilAbsensi(
              dataBerhasil: [
                titleAbsen.value,
                timeString.value,
                typeAbsen.value,
                intervalControl.value,
              ],
            ));
          }, (error) {
            // Tampilkan error jika insertAbsensi gagal
            Get.snackbar("Error", error);
          });
        }
      }
    }
  }

  void getCheckMock() async {
    try {
      // TrustLocation.onChange.listen((values) => getValMock(values));
    } on PlatformException catch (e) {
      print('PlatformException $e');
    }
  }

  void getValMock(values) {
    print(values);
    String _latitude = values.latitude;
    String _longitude = values.longitude;
    bool _isMockLocation = values.isMockLocation;
    // TrustLocation.stop();
    mockLocation.value = _isMockLocation;
    this.mockLocation.refresh();
  }

  Future<bool> validasiRadius() async {
    UtilsAlert.showLoadingIndicator(Get.context!);
    var from = Point(latUser.value, langUser.value);
    print("lat validasi" + latUser.value.toString());
    print("long validasi" + langUser.value.toString());
    // var from = Point(-6.1716917, 106.7305503);
    print("place cordinate value ${placeCoordinate.value}");
    var getPlaceTerpilih = placeCoordinate.value
        .firstWhere((element) => element['place'] == selectedType.value);

    var stringLatLang = "${getPlaceTerpilih['place_longlat']}";
    var defaultRadius = "${getPlaceTerpilih['place_radius']}";
    if (stringLatLang == "" ||
        stringLatLang == null ||
        stringLatLang == "null") {
      return true;
    } else {
      var listLatLang = (stringLatLang.split(','));
      var latDefault = listLatLang[0];
      var langDefault = listLatLang[1];
      var to = Point(double.parse(latDefault), double.parse(langDefault));
      num distance = SphericalUtils.computeDistanceBetween(from, to);
      print('Distance: $distance meters');
      var filter = double.parse((distance).toStringAsFixed(0));
      if (filter <= double.parse(defaultRadius)) {
        return true;
      } else {
        Navigator.pop(Get.context!);
        showGeneralDialog(
          barrierDismissible: false,
          context: Get.context!,
          barrierColor: Colors.black54, // space around dialog
          transitionDuration: const Duration(milliseconds: 200),
          transitionBuilder: (context, a1, a2, child) {
            return ScaleTransition(
              scale: CurvedAnimation(
                  parent: a1,
                  curve: Curves.elasticOut,
                  reverseCurve: Curves.easeOutCubic),
              child: CustomDialog(
                title: "Info",
                content:
                    "Jarak radius untuk melakukan absen adalah $defaultRadius m",
                positiveBtnText: "Ok",
                // negativeBtnText: "OK",
                style: 2,
                buttonStatus: 2,
                positiveBtnPressed: () {
                  Get.back();
                },
              ),
            );
          },
          pageBuilder: (BuildContext context, Animation animation,
              Animation secondaryAnimation) {
            return null!;
          },
        );
        return false;
      }
    }
  }

  var date = DateTime.now().obs;
  var beginPayroll = DateFormat('MMMM').format(DateTime.now()).obs;
  var endPayroll = DateFormat('MMMM').format(DateTime.now()).obs;

  void loadHistoryAbsenUser() {
    print("masuk sini terbaru new");
    historyAbsen.value.clear();
    historyAbsenShow.value.clear();

    var dataUser = AppData.informasiUser;

    var getEmpId = dataUser![0].em_id;
    print(getEmpId);
    var defaultDate = DateTime.parse(AppData.endPeriode);

    if (AppData.informasiUser![0].beginPayroll != 1 &&
        defaultDate.day > AppData.informasiUser![0].endPayroll) {
      defaultDate =
          DateTime(defaultDate.year, defaultDate.month + 1, defaultDate.day);
    }

    DateTime tanggalAkhirBulan =
        DateTime(defaultDate.year, defaultDate.month + 1, 0);
    beginPayroll.value = DateFormat('MMMM').format(defaultDate);
    endPayroll.value = DateFormat('MMMM').format(defaultDate);

    DateTime previousMonthDate =
        DateTime(defaultDate.year, defaultDate.month - 1, defaultDate.day);

    if (AppData.informasiUser![0].beginPayroll >
        AppData.informasiUser![0].endPayroll) {
      beginPayroll.value = DateFormat('MMMM').format(previousMonthDate);
    } else if (AppData.informasiUser![0].beginPayroll == 1) {
      beginPayroll.value = DateFormat('MMMM').format(defaultDate);
    }

    var body = {
      'em_id': getEmpId,
      'bulan': bulanSelectedSearchHistory.value,
      'tahun': tahunSelectedSearchHistory.value,
    };
    print(body);
    var connect = Api.connectionApi("post", body, "attendance");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        print('data body ${valueBody}');
        if (valueBody['status'] == true) {
          List data = valueBody['data'];
          loading.value =
              data.length == 0 ? "Data tidak ditemukan" : "Memuat data...";
          for (var el in data) {
            historyAbsen.value.add(AbsenModel(
                date: el['date'],
                id: el['id'] ?? 0,
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
                atttype: el['atttype'] ?? 0,
                namaLembur: el['lembur'],
                namaTugasLuar: el['tugas_luar'],
                namaCuti: el['cuti'],
                namaSakit: el['sakit'],
                namaIzin: el['izin'],
                namaDinasLuar: el['dinas_luar'],
                offDay: el['off_date'],
                namaHariLibur: el['hari_libur'],
                jamKerja: el['jam_kerja'],
                statusView: el['status_view'] ?? false));
            tempHistoryAbsen.value = historyAbsen.value;
            // historyAbsen.value.add(AbsenModel(
            //     id: el['id'] ?? "",
            //     em_id: el['em_id'] ?? "",
            //     atten_date: el['atten_date'] ?? "",
            //     signin_time: el['signin_time'] ?? "",
            //     signout_time: el['signout_time'] ?? "",
            //     working_hour: el['working_hour'] ?? "",
            //     place_in: el['place_in'] ?? "",
            //     place_out: el['place_out'] ?? "",
            //     absence: el['absence'] ?? "",
            //     overtime: el['overtime'] ?? "",
            //     earnleave: el['earnleave'] ?? "",
            //     status: el['status'] ?? "",
            //     signin_longlat: el['signin_longlat'] ?? "",
            //     signout_longlat: el['signout_longlat'] ?? "",
            //     att_type: el['att_type'] ?? "",
            //     signin_pict: el['signin_pict'] ?? "",
            //     signout_pict: el['signout_pict'] ?? "",
            //     signin_note: el['signin_note'] ?? "",
            //     signout_note: el['signout_note'] ?? "",
            //     signin_addr: el['signin_addr'] ?? "",
            //     signout_addr: el['signout_addr'] ?? "",
            //     reqType: el['reg_type'] ?? 0,
            //     atttype: el['atttype'] ?? 0));
          }

          for (var element in tempHistoryAbsen) {
            print("nah: ${element.atten_date} dan ${element.jamKerja}");
          }
          //historyAbsenShow.value = historyAbsen;
          // Set<String> seenDates = {};
          // historyAbsen.value = historyAbsen.where((event) {
          //   if (seenDates.contains(event.date)) {
          //     return false;
          //   } else {
          //     seenDates.add(event.date);
          //     return true;
          //   }
          // }).toList();

          Map<String, AbsenModel> highestIdPerDate = {};

          for (var event in historyAbsen) {
            if (!highestIdPerDate.containsKey(event.date) ||
                event.id! > highestIdPerDate[event.date]!.id!) {
              highestIdPerDate[event.date] = event;
            }
          }

          historyAbsen.value = highestIdPerDate.values.toList();

          for (var element in historyAbsen) {
            print("masuk sini: $tempHistoryAbsen");

            var data = tempHistoryAbsen
                .where((p0) => p0.date == element.date)
                .where((p0) => p0.id != element.id)
                .toList()
              ..sort((a, b) => b.id!.compareTo(a.id as num));

            print("data turunan: $data");
            if (data.isNotEmpty) {
              element.turunan = data;
            } else {
              element.turunan = [];
            }

            print('data list ${element} tes');
          }

          //  historyAbsenShow.toSet().toList();
          //  historyAbsenShow.forEach((element) {
          //   var data=historyAbsenShow.where((p0) => p0['date']=element['date']).toList();
          //   if (data.length>)

          //  });

          // if (historyAbsen.value.length != 0) {
          //   var listTanggal = [];
          //   var finalData = [];
          //   for (var element in historyAbsen.value) {
          //     listTanggal.add(element.date);
          //   }
          //   print("date new  ${listTanggal}");
          //   listTanggal = listTanggal.toSet().toList();
          //   for (var element in listTanggal) {
          //     var valueTurunan = [];
          //     var stringDateAdaTurunan = "";
          //     for (var element1 in historyAbsen.value) {
          //       if (element == element1.atten_date) {
          //         print("ada turunan");
          //         var dataTurunan = {
          //           'id': element1.id,
          //           'signin_time': element1.signin_time,
          //           'signout_time': element1.signout_time,
          //           'atten_date': element1.atten_date,
          //           'place_in': element1.place_in,
          //           'place_out': element1.place_out,
          //           'signin_note': element1.signin_note,
          //           'signin_longlat': element1.signin_longlat,
          //           'signout_longlat': element1.signout_longlat,
          //           'reg_type': element1.reqType
          //         };
          //         stringDateAdaTurunan = "${element1.atten_date}";
          //         valueTurunan.add(dataTurunan);
          //       }
          //     }
          //     List hasilFilter = [];
          //     List hasilFilterPengajuan = [];
          //     for (var element1 in valueTurunan) {
          //       if (element1['place_in'] == 'pengajuan') {
          //         hasilFilterPengajuan.add(element1);
          //       } else {
          //         hasilFilter.add(element1);
          //       }
          //     }
          //     List hasilFinalPengajuan = [];
          //     if (hasilFilterPengajuan.isNotEmpty) {
          //       var data = hasilFilterPengajuan;
          //       var seen = Set<String>();
          //       List filter = data
          //           .where((pengajuan) => seen.add(pengajuan['signin_note']))
          //           .toList();
          //       hasilFinalPengajuan = filter;
          //     }
          //     List finalAllData = new List.from(hasilFilter)
          //       ..addAll(hasilFinalPengajuan);

          //     var lengthTurunan = finalAllData.length == 1 ? false : true;

          //     if (lengthTurunan == false) {
          //       var data = {
          //         'id': finalAllData[0]['id'],
          //         'signin_time': finalAllData[0]['signin_time'],
          //         'signout_time': finalAllData[0]['signout_time'],
          //         'atten_date': finalAllData[0]['atten_date'],
          //         'place_in': finalAllData[0]['place_in'],
          //         'place_out': finalAllData[0]['place_out'],
          //         'signin_note': finalAllData[0]['signin_note'],
          //         'signin_longlat': finalAllData[0]['signin_longlat'],
          //         'signout_longlat': finalAllData[0]['signout_longlat'],
          //         'reg_type': finalAllData[0]['reg_type'],
          //         'date':finalAllData[0]['date'],
          //         'view_turunan': lengthTurunan,

          //         'turunan': [],
          //       };
          //       finalData.add(data);
          //     } else {
          //       var data = {
          //         'id': "",
          //         'signout_time': "",
          //         'atten_date': stringDateAdaTurunan,
          //            'date':   stringDateAdaTurunan,
          //         'place_in': "",
          //         'place_out': "",
          //         'signin_note': "",
          //         'signin_longlat': "",
          //         'signout_longlat': "",
          //         'view_turunan': lengthTurunan,
          //         'status_view': false,
          //         'turunan': finalAllData,
          //       };
          //       stringDateAdaTurunan = "";
          //       finalData.add(data);
          //     }
          //   }
          //   // finalData.sort((a, b) {
          //   //   return DateTime.parse(b['date'])
          //   //       .compareTo(DateTime.parse(a['date']));
          //   // });
          //   historyAbsenShow.value = finalData;
          //   print("data now now ${finalData}");
          //    print("data now now now ${finalData.length}");
          //   this.historyAbsenShow.refresh();

          // // }
          // this.historyAbsen.refresh();
        } else {
          loading.value = "Data tidak ditemukan";
        }
      }
    });
  }

  void loadHistoryAbsenUserFilter() {
    print("masuk sini terbaru new");
    historyAbsen.value.clear();
    historyAbsenShow.value.clear();

    var dataUser = AppData.informasiUser;

    var getEmpId = dataUser![0].em_id;
    print(getEmpId);

    var defaultDate = date.value;

    if (AppData.informasiUser![0].beginPayroll != 1 &&
        defaultDate.day > AppData.informasiUser![0].endPayroll) {
      defaultDate =
          DateTime(defaultDate.year, defaultDate.month + 1, defaultDate.day);
    }

    DateTime tanggalAkhirBulan =
        DateTime(defaultDate.year, defaultDate.month + 1, 0);
    beginPayroll.value = DateFormat('MMMM').format(defaultDate);
    endPayroll.value = DateFormat('MMMM').format(defaultDate);

    DateTime sp = DateTime(defaultDate.year, defaultDate.month, 1);
    DateTime ep =
        DateTime(defaultDate.year, defaultDate.month, tanggalAkhirBulan.day);

    var startPeriode = DateFormat('yyyy-MM-dd').format(sp);
    var endPeriode = DateFormat('yyyy-MM-dd').format(ep);

    DateTime previousMonthDate =
        DateTime(defaultDate.year, defaultDate.month - 1, defaultDate.day);

    var tempStartPeriode = AppData.startPeriode;
    var tempEndPeriode = AppData.endPeriode;

    if (AppData.informasiUser![0].beginPayroll >
        AppData.informasiUser![0].endPayroll) {
      beginPayroll.value = DateFormat('MMMM').format(previousMonthDate);

      startPeriode = DateFormat('yyyy-MM-dd').format(DateTime(defaultDate.year,
          defaultDate.month - 1, AppData.informasiUser![0].beginPayroll));
      endPeriode = DateFormat('yyyy-MM-dd').format(DateTime(defaultDate.year,
          defaultDate.month, AppData.informasiUser![0].endPayroll));
    } else if (AppData.informasiUser![0].beginPayroll == 1) {
      beginPayroll.value = DateFormat('MMMM').format(defaultDate);
      startPeriode = DateFormat('yyyy-MM-dd').format(DateTime(defaultDate.year,
          defaultDate.month, AppData.informasiUser![0].beginPayroll));
    }

    AppData.startPeriode = startPeriode;
    AppData.endPeriode = endPeriode;

    var body = {
      'em_id': getEmpId,
      'bulan': bulanSelectedSearchHistory.value,
      'tahun': tahunSelectedSearchHistory.value,
    };
    print(body);
    var connect = Api.connectionApi("post", body, "attendance");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        print('data body ${valueBody}');
        if (valueBody['status'] == true) {
          List data = valueBody['data'];
          loading.value =
              data.length == 0 ? "Data tidak ditemukan" : "Memuat data...";
          for (var el in data) {
            historyAbsen.value.add(AbsenModel(
                date: el['date'],
                id: el['id'] ?? 0,
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
                atttype: el['atttype'] ?? 0,
                namaLembur: el['lembur'],
                namaTugasLuar: el['tugas_luar'],
                namaCuti: el['cuti'],
                namaSakit: el['sakit'],
                namaIzin: el['izin'],
                namaDinasLuar: el['dinas_luar'],
                offDay: el['off_date'],
                namaHariLibur: el['hari_libur'],
                jamKerja: el['jam_kerja'],
                statusView: el['status_view'] ?? false));
            tempHistoryAbsen.value = historyAbsen.value;
            // historyAbsen.value.add(AbsenModel(
            //     id: el['id'] ?? "",
            //     em_id: el['em_id'] ?? "",
            //     atten_date: el['atten_date'] ?? "",
            //     signin_time: el['signin_time'] ?? "",
            //     signout_time: el['signout_time'] ?? "",
            //     working_hour: el['working_hour'] ?? "",
            //     place_in: el['place_in'] ?? "",
            //     place_out: el['place_out'] ?? "",
            //     absence: el['absence'] ?? "",
            //     overtime: el['overtime'] ?? "",
            //     earnleave: el['earnleave'] ?? "",
            //     status: el['status'] ?? "",
            //     signin_longlat: el['signin_longlat'] ?? "",
            //     signout_longlat: el['signout_longlat'] ?? "",
            //     att_type: el['att_type'] ?? "",
            //     signin_pict: el['signin_pict'] ?? "",
            //     signout_pict: el['signout_pict'] ?? "",
            //     signin_note: el['signin_note'] ?? "",
            //     signout_note: el['signout_note'] ?? "",
            //     signin_addr: el['signin_addr'] ?? "",
            //     signout_addr: el['signout_addr'] ?? "",
            //     reqType: el['reg_type'] ?? 0,
            //     atttype: el['atttype'] ?? 0));
          }

          //historyAbsenShow.value = historyAbsen;
          // Set<String> seenDates = {};
          // historyAbsen.value = historyAbsen.where((event) {
          //   if (seenDates.contains(event.date)) {
          //     return false;
          //   } else {
          //     seenDates.add(event.date);
          //     return true;
          //   }
          // }).toList();

          Map<String, AbsenModel> highestIdPerDate = {};

          for (var event in historyAbsen) {
            if (!highestIdPerDate.containsKey(event.date) ||
                event.id! > highestIdPerDate[event.date]!.id!) {
              highestIdPerDate[event.date] = event;
            }
          }

          historyAbsen.value = highestIdPerDate.values.toList();

          for (var element in historyAbsen) {
            print("masuk sini: $tempHistoryAbsen");

            var data = tempHistoryAbsen
                .where((p0) => p0.date == element.date)
                .where((p0) => p0.id != element.id)
                .toList()
              ..sort((a, b) => b.id!.compareTo(a.id as num));

            print("data turunan: $data");
            if (data.isNotEmpty) {
              element.turunan = data;
            } else {
              element.turunan = [];
            }

            print('data list ${element} tes');
          }

          //  historyAbsenShow.toSet().toList();
          //  historyAbsenShow.forEach((element) {
          //   var data=historyAbsenShow.where((p0) => p0['date']=element['date']).toList();
          //   if (data.length>)

          //  });

          // if (historyAbsen.value.length != 0) {
          //   var listTanggal = [];
          //   var finalData = [];
          //   for (var element in historyAbsen.value) {
          //     listTanggal.add(element.date);
          //   }
          //   print("date new  ${listTanggal}");
          //   listTanggal = listTanggal.toSet().toList();
          //   for (var element in listTanggal) {
          //     var valueTurunan = [];
          //     var stringDateAdaTurunan = "";
          //     for (var element1 in historyAbsen.value) {
          //       if (element == element1.atten_date) {
          //         print("ada turunan");
          //         var dataTurunan = {
          //           'id': element1.id,
          //           'signin_time': element1.signin_time,
          //           'signout_time': element1.signout_time,
          //           'atten_date': element1.atten_date,
          //           'place_in': element1.place_in,
          //           'place_out': element1.place_out,
          //           'signin_note': element1.signin_note,
          //           'signin_longlat': element1.signin_longlat,
          //           'signout_longlat': element1.signout_longlat,
          //           'reg_type': element1.reqType
          //         };
          //         stringDateAdaTurunan = "${element1.atten_date}";
          //         valueTurunan.add(dataTurunan);
          //       }
          //     }
          //     List hasilFilter = [];
          //     List hasilFilterPengajuan = [];
          //     for (var element1 in valueTurunan) {
          //       if (element1['place_in'] == 'pengajuan') {
          //         hasilFilterPengajuan.add(element1);
          //       } else {
          //         hasilFilter.add(element1);
          //       }
          //     }
          //     List hasilFinalPengajuan = [];
          //     if (hasilFilterPengajuan.isNotEmpty) {
          //       var data = hasilFilterPengajuan;
          //       var seen = Set<String>();
          //       List filter = data
          //           .where((pengajuan) => seen.add(pengajuan['signin_note']))
          //           .toList();
          //       hasilFinalPengajuan = filter;
          //     }
          //     List finalAllData = new List.from(hasilFilter)
          //       ..addAll(hasilFinalPengajuan);

          //     var lengthTurunan = finalAllData.length == 1 ? false : true;

          //     if (lengthTurunan == false) {
          //       var data = {
          //         'id': finalAllData[0]['id'],
          //         'signin_time': finalAllData[0]['signin_time'],
          //         'signout_time': finalAllData[0]['signout_time'],
          //         'atten_date': finalAllData[0]['atten_date'],
          //         'place_in': finalAllData[0]['place_in'],
          //         'place_out': finalAllData[0]['place_out'],
          //         'signin_note': finalAllData[0]['signin_note'],
          //         'signin_longlat': finalAllData[0]['signin_longlat'],
          //         'signout_longlat': finalAllData[0]['signout_longlat'],
          //         'reg_type': finalAllData[0]['reg_type'],
          //         'date':finalAllData[0]['date'],
          //         'view_turunan': lengthTurunan,

          //         'turunan': [],
          //       };
          //       finalData.add(data);
          //     } else {
          //       var data = {
          //         'id': "",
          //         'signout_time': "",
          //         'atten_date': stringDateAdaTurunan,
          //            'date':   stringDateAdaTurunan,
          //         'place_in': "",
          //         'place_out': "",
          //         'signin_note': "",
          //         'signin_longlat': "",
          //         'signout_longlat': "",
          //         'view_turunan': lengthTurunan,
          //         'status_view': false,
          //         'turunan': finalAllData,
          //       };
          //       stringDateAdaTurunan = "";
          //       finalData.add(data);
          //     }
          //   }
          //   // finalData.sort((a, b) {
          //   //   return DateTime.parse(b['date'])
          //   //       .compareTo(DateTime.parse(a['date']));
          //   // });
          //   historyAbsenShow.value = finalData;
          //   print("data now now ${finalData}");
          //    print("data now now now ${finalData.length}");
          //   this.historyAbsenShow.refresh();

          // // }
          // this.historyAbsen.refresh();
        } else {
          loading.value = "Data tidak ditemukan";
        }
      }
    });
    AppData.startPeriode = tempStartPeriode;
    AppData.endPeriode = tempEndPeriode;
  }

  void showTurunan(tanggal) {
    for (var element in historyAbsenShow) {
      if (element['atten_date'] == tanggal) {
        if (element['status_view'] == false) {
          element['status_view'] = true;
        } else {
          element['status_view'] = false;
        }
      }
    }
    this.historyAbsenShow.refresh();
  }

  void historySelected(id_absen, status) {
    if (status == 'history') {
      var getSelected = tempHistoryAbsen.value
          .firstWhere((element) => element.id == id_absen);
      // print(getSelected);
      Get.to(DetailAbsen(
        absenSelected: [getSelected],
        status: false,
      ));
    } else if (status == 'laporan') {
      var getSelected = listLaporanFilter.value
          .firstWhere((element) => element['id'] == id_absen);
      if (getSelected['signin_longlat'] == null ||
          getSelected['signin_longlat'] == "") {
        UtilsAlert.showToast("Terjadi kesalahan terhadap data absen ini");
      } else {
        Get.to(DetailAbsen(
          absenSelected: [getSelected],
          status: true,
        ));
      }
    }
  }

  void historySelected1(id_absen, status, index, index1) {
    //  print(listLaporanFilter[index]['data'].toList());
    var getSelected = listLaporanFilter[index]['data'][index1];
    // print(getSelected);

    // print(getSelected);
    if (getSelected['signin_longlat'] == null ||
        getSelected['signin_longlat'] == "") {
      UtilsAlert.showToast("Terjadi kesalahan terhadap data absen ini");
    } else {
      Get.to(DetailAbsen(
        absenSelected: [getSelected],
        status: true,
      ));
    }
  }

  void loadAbsenDetail(emId, attenDate, fullName) {
    print("load detal employee");
    Map<String, dynamic> body = {'id_absen': emId, 'atten_date': attenDate};
    var connect = Api.connectionApi("post", body, "whereOnce-attendance");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        if (valueBody['data'].isNotEmpty) {
          //  print(listLaporanFilter[index]['data'].toList());
          var getSelected = valueBody['data'][0];

          // print(getSelected);
          if (getSelected['signin_longlat'] == null ||
              getSelected['signin_longlat'] == "") {
            UtilsAlert.showToast("Terjadi kesalahan terhadap data absen ini");
          } else {
            Get.to(DetailAbsen(
              absenSelected: [getSelected],
              status: true,
              fullName: fullName,
            ));
          }
          // absenModel.value = AbsenModel.fromMap(valueBody);
        } else {}
      }
    });
  }

  showDetailImage() {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 15),
                  Image.network(
                    Api.UrlfotoAbsen + stringImageSelected.value,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 15)
                ]));
      },
    );
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
                              carilaporanAbsenkaryawan(status);
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
                                            carilaporanAbsenkaryawan(status);
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
            ),
          );
        });
  }

  showDataLokasiKoordinate() {
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
                          "Pilih Lokasi",
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
                        children: List.generate(placeCoordinate.value.length,
                            (index) {
                          var id = placeCoordinate.value[index]['id'];
                          var place = placeCoordinate.value[index]['place'];
                          return InkWell(
                            onTap: () {
                              if (selectedViewFilterAbsen.value == 0) {
                                filterLokasiAbsenBulan(place);
                              } else {
                                filterLokasiAbsen(place);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    place,
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
                                            if (selectedViewFilterAbsen.value ==
                                                0) {
                                              filterLokasiAbsenBulan(place);
                                            } else {
                                              filterLokasiAbsen(place);
                                            }
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

  void filterLokasiAbsenBulan(place) {
    print("tes");
    Navigator.pop(Get.context!);
    statusLoadingSubmitLaporan.value = true;
    listLaporanFilter.value.clear();
    Map<String, dynamic> body = {
      'bulan': bulanSelectedSearchHistory.value,
      'tahun': tahunSelectedSearchHistory.value,
      'status': idDepartemenTerpilih.value
    };
    var connect =
        Api.connectionApi("post", body, "load_laporan_absensi_filter_lokasi");
    connect.then((dynamic res) {
      var valueBody = jsonDecode(res.body);
      if (valueBody['status'] == false) {
        statusLoadingSubmitLaporan.value = false;
        UtilsAlert.showToast(
            "Data periode $bulanSelectedSearchHistory belum tersedia, harap hubungi HRD");
      } else {
        var data = valueBody['data'];
        List listFilterLokasi = [];
        for (var element in data) {
          if (element['place_in'] == place) {
            listFilterLokasi.add(element);
          }
        }
        listLaporanFilter.value = listFilterLokasi;
        allListLaporanFilter.value = listFilterLokasi;
        filterLokasiKoordinate.value = place;

        this.listLaporanFilter.refresh();
        this.filterLokasiKoordinate.refresh();
        loading.value = listLaporanFilter.value.length == 0
            ? "Data tidak tersedia"
            : "Memuat data...";

        statusLoadingSubmitLaporan.value = false;
        this.statusLoadingSubmitLaporan.refresh();
        groupData();
      }
    });
  }

  void filterLokasiAbsen(place) {
    List listFilterLokasi = [];
    for (var element in allListLaporanFilter.value) {
      if (element['place_in'] == place) {
        listFilterLokasi.add(element);
      }
    }
    listLaporanFilter.value = listFilterLokasi;
    filterLokasiKoordinate.value = place;
    this.listLaporanFilter.refresh();
    this.filterLokasiKoordinate.refresh();
    loading.value = listLaporanFilter.value.length == 0
        ? "Data tidak tersedia"
        : "Memuat data...";
    Navigator.pop(Get.context!);
    groupData();
  }

  void refreshFilterKoordinate() {
    if (selectedViewFilterAbsen.value == 0) {
      onReady();
    } else {
      listLaporanFilter.value = allListLaporanFilter.value;
      filterLokasiKoordinate.value = "Lokasi";
      this.listLaporanFilter.refresh();
      this.filterLokasiKoordinate.refresh();
      loading.value = listLaporanFilter.value.length == 0
          ? "Data tidak tersedia"
          : "Memuat data...";
    }
  }

  void takeFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png']);

    if (result != null) {
      PlatformFile file = result.files.first;
      if (file.size > 5000000) {
        UtilsAlert.showToast("Maaf file terlalu besar...Max 5MB");
      } else {
        namaFileUpload.value = "${file.name}";
        imageAjuan.value = file.name.toString();
        filePengajuan.value = await saveFilePermanently(file);
        uploadFile.value = true;
        // print(file.name);
        // print(file.bytes);
        // print(file.size);
        // print(file.extension);
        // print(file.path);
      }
    } else {
      UtilsAlert.showToast("Gagal mengambil file");
    }
  }

  Future<File> saveFilePermanently(PlatformFile file) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final newFile = File('${appStorage.path}/${file.name}');
    return File(file.path!).copy(newFile.path);
  }

  void carilaporanAbsenkaryawan(status) {
    if (departemen.value.text == "") {
      UtilsAlert.showToast("Lengkapi form");
    } else {
      if (status == 'semua') {
        if (selectedViewFilterAbsen.value == 0) {
          // filter bulan
          aksiCariLaporan();
        } else if (selectedViewFilterAbsen.value == 1) {
          // filter tanggal
          cariLaporanAbsenTanggal(pilihTanggalTelatAbsen.value);
        }
      } else if (status == 'telat') {
        aksiEmployeeTerlambatAbsen(
            "${DateFormat('yyyy-MM-dd').format(pilihTanggalTelatAbsen.value)}");
      } else if (status == 'belum') {
        aksiEmployeeBelumAbsen(
            "${DateFormat('yyyy-MM-dd').format(pilihTanggalTelatAbsen.value)}");
      }
    }
  }

  var dateLaporan = DateTime.now().obs;
  var startPeriode = "".obs;
  var endPeriode = "".obs;
  var tempStartPeriode = "".obs;
  var tempEndPeriode = "".obs;

  void aksiCariLaporan() async {
    var defaultDate = dateLaporan.value;

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

    AppData.startPeriode = tempStartPeriode.value;
    AppData.endPeriode = tempEndPeriode.value;
  }

  void cariLaporanAbsenTanggal(tanggal) {
    var tanggalSubmit = "${DateFormat('yyyy-MM-dd').format(tanggal)}";
    statusLoadingSubmitLaporan.value = true;
    listLaporanFilter.value.clear();
    Map<String, dynamic> body = {
      'atten_date': tanggalSubmit,
      'status': idDepartemenTerpilih.value
    };
    var connect =
        Api.connectionApi("post", body, "load_laporan_absensi_tanggal");
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
          filterLaporanAbsenTanggal.value = true;
          this.filterLaporanAbsenTanggal.refresh();
          this.statusLoadingSubmitLaporan.refresh();
          groupData();
        }
      }
    });
  }

  void pencarianNamaKaryawan(value) {
    var textCari = value.toLowerCase();
    var filter = allListLaporanFilter.where((laporan) {
      var namaEmployee = laporan['full_name'].toLowerCase();
      return namaEmployee.contains(textCari);
    }).toList();
    listLaporanFilter.value = filter;
    statusCari.value = true;
    this.listLaporanFilter.refresh();
    this.statusCari.refresh();
    groupData();
  }

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

  void pencarianNamaKaryawanTelat(value) {
    var textCari = value.toLowerCase();
    var filter = alllistEmployeeTelat.where((laporan) {
      var namaEmployee = laporan['full_name'].toLowerCase();
      return namaEmployee.contains(textCari);
    }).toList();
    listEmployeeTelat.value = filter;
    statusCari.value = true;
    this.listLaporanFilter.refresh();
    this.statusCari.refresh();
    groupData();
  }

  void pencarianNamaKaryawanBelumAbsen(value) {
    var textCari = value.toLowerCase();
    var filter = allListLaporanBelumAbsen.where((laporan) {
      var namaEmployee = laporan['full_name'].toLowerCase();
      return namaEmployee.contains(textCari);
    }).toList();
    listLaporanBelumAbsen.value = filter;
    statusCari.value = true;
    this.listLaporanFilter.refresh();
    this.statusCari.refresh();
  }

  void clearPencarian() {
    statusCari.value = false;
    cari.value.text = "";

    listLaporanFilter.value = allListLaporanFilter.value;
    this.listLaporanFilter.refresh();

    listLaporanBelumAbsen.value = allListLaporanBelumAbsen.value;
    this.listLaporanBelumAbsen.refresh();

    listEmployeeTelat.value = alllistEmployeeTelat.value;
    this.listEmployeeTelat.refresh();
  }

  void widgetButtomSheetFilterData() {
    showModalBottomSheet(
      context: Get.context!,
      isDismissible: false,
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
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        flex: 90,
                        child: Padding(
                          padding: EdgeInsets.only(top: 16),
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
                          icon: const Icon(Iconsax.close_circle),
                        ),
                      )
                    ],
                  ),
                  Divider(
                    height: 5,
                    color: Constanst.colorText2,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  lineTitleKategori(),
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: pageViewKategoriFilter(),
                      )),
                  const SizedBox(
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
                selectedViewFilterAbsen.value = 0;
                pageViewFilterAbsen!.jumpToPage(0);
                this.selectedViewFilterAbsen.refresh();
              },
              child: Container(
                margin: const EdgeInsets.only(left: 6, right: 6),
                decoration: BoxDecoration(
                    color: selectedViewFilterAbsen.value == 0
                        ? Constanst.colorPrimary
                        : Colors.transparent,
                    borderRadius: Constanst.borderStyle1),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Bulan',
                      style: TextStyle(
                        color: selectedViewFilterAbsen.value == 0
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
                selectedViewFilterAbsen.value = 1;
                pageViewFilterAbsen!.jumpToPage(1);
                this.selectedViewFilterAbsen.refresh();
              },
              child: Container(
                margin: const EdgeInsets.only(left: 6, right: 6),
                decoration: BoxDecoration(
                    color: selectedViewFilterAbsen.value == 1
                        ? Constanst.colorPrimary
                        : Colors.transparent,
                    borderRadius: Constanst.borderStyle1),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Tanggal',
                      style: TextStyle(
                        color: selectedViewFilterAbsen.value == 1
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
        physics: const BouncingScrollPhysics(),
        controller: pageViewFilterAbsen,
        onPageChanged: (index) {
          selectedViewFilterAbsen.value = index;
        },
        itemCount: 2,
        itemBuilder: (context, index) {
          return Padding(
              padding: const EdgeInsets.all(0),
              child: index == 0
                  ? filterBulan()
                  : index == 1
                      ? filterTanggal()
                      : const SizedBox());
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
                  filterLokasiKoordinate.value = "Lokasi";
                  selectedViewFilterAbsen.value = 0;
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
              padding: const EdgeInsets.only(top: 10, bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 6),
                        child: Icon(Iconsax.calendar_2),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 3),
                        child: Text(
                          "${Constanst.convertDateBulanDanTahun(bulanDanTahunNow.value)}",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
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
            filterLokasiKoordinate.value = "Lokasi";
            selectedViewFilterAbsen.value = 0;
            DatePicker.showDatePicker(Get.context!,
                showTitleActions: true,
                minTime: DateTime(2000, 1, 1),
                maxTime: DateTime(2100, 1, 1), onConfirm: (date) {
              Navigator.pop(Get.context!);
              pilihTanggalTelatAbsen.value = date;
              this.pilihTanggalTelatAbsen.refresh();
              cariLaporanAbsenTanggal(pilihTanggalTelatAbsen.value);
            }, currentTime: DateTime.now(), locale: LocaleType.en);
          },
          child: Container(
            height: 40,
            decoration: BoxDecoration(
                borderRadius: Constanst.borderStyle1,
                border: Border.all(color: Constanst.colorText2)),
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 6),
                          child: Icon(Iconsax.calendar_2),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Text(
                              "${Constanst.convertDate('${DateFormat('yyyy-MM-dd').format(pilihTanggalTelatAbsen.value)}')}",
                              style: const TextStyle(fontSize: 16),
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

  void faceIdRegistration({faceId, emId}) async {
    try {
      final box = GetStorage();
      box.write("face_recog", true);
      UtilsAlert.showLoadingIndicator(Get.context!);

      Map<String, dynamic> body = {"em_id": emId, "": faceId};
      Map<String, String> headers = {
        'Authorization': Api.basicAuth,
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'token': AppData.setFcmToken,
        'em_id': AppData.informasiUser == null ||
                AppData.informasiUser == "null" ||
                AppData.informasiUser == "" ||
                AppData.informasiUser!.isEmpty
            ? ""
            : AppData.informasiUser![0].em_id
      };
      print("body" + body.toString());

      final response = await http.post(Uri.parse('${Api.basicUrl}edit_face'),
          body: jsonEncode(body), headers: headers);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data.toString());
        Get.back();

        // print("body " + jsonDecode(response.body.toString()).toString());
        Get.to(const BerhasilRegistration());
      }

      // var data = jsonDecode(response.body);

      // if (response.statusCode == 200) {
      //   UtilsAlert.showToast(data['message']);
      //   Navigator.pop(Get.context!);
      // } else {
      //   Navigator.pop(Get.context!);
      //   UtilsAlert.showToast(data['message']);
      // }
    } catch (e) {
      Navigator.pop(Get.context!);
      UtilsAlert.showToast(e.toString());
    }
    // UtilsAlert.showLoadingIndicator(Get.context!);
    // Map<String, dynamic> body = {'face': faceId, 'em_id': emId};

    // var connect = Api.connectionApi("post", body, "edit_face");
    // connect.then((dynamic res) {
    //   if (res.statusCode == 200) {
    //     var valueBody = jsonDecode(res.body);
    //     if (valueBody['status'] == false) {
    //       Navigator.pop(Get.context!);
    //       UtilsAlert.showToast("Data has been saved");
    //     } else {
    //       UtilsAlert.showToast("Eerror");
    //       Navigator.pop(Get.context!);
    //       sysData.value = valueBody['data'];
    //       this.sysData.refresh();
    //     }
    //   }
    // }).catchError((e) {
    //   UtilsAlert.showToast('${e}');
    // });
  }

  Future<void> employeDetail() async {
    print("load detail employee");
    // UtilsAlert.showLoadingIndicator(Get.context!);
    var dataUser = AppData.informasiUser;
    final box = GetStorage();

    var id = dataUser![0].em_id;
    print("em id ${id}");
    Map<String, dynamic> body = {'val': 'em_id', 'cari': id};
    var connect = Api.connectionApi("post", body, "whereOnce-employee");
    connect.then((dynamic res) {
      if (res == false) {
        //UtilsAlert.koneksiBuruk();
      } else {
        bool lastAbsen = AppData.statusAbsen;
        print("ASEE ABSEN ${lastAbsen}");

        if (res.statusCode == 200) {
          var valueBody = jsonDecode(res.body);
          var data = valueBody['data'];
          // isTracking.value = data[0]['em_control'];
          if (lastAbsen == true) {
            if (data[0]['em_control'] == 1) {
              isTracking.value = 1;
            } else {
              isTracking.value = 0;
            }
          } else {
            isTracking.value = 0;
          }
          print("data wajah ${data[0]['file_face']}");
          regType.value = data[0]['reg_type'];
          print("Req tye ${regType.value}");
          box.write("file_face", data[0]['file_face']);

          print("data wajah ${GetStorage().read('file_face')}");

          if (data[0]['file_face'] == "" || data[0]['file_face'] == null) {
            box.write("face_recog", false);
          } else {
            box.write("face_recog", true);
          }
        }
        // Get.back();
      }
    });
  }

  void employeDetaiBpjs() {
    // UtilsAlert.showLoadingIndicator(Get.context!);
    var dataUser = AppData.informasiUser;
    final box = GetStorage();

    var id = dataUser![0].em_id;
    print("em id ${id}");
    Map<String, dynamic> body = {'val': 'em_id', 'cari': id};
    var connect = Api.connectionApi("post", body, "whereOnce-employee");
    connect.then((dynamic res) {
      if (res == false) {
        //UtilsAlert.koneksiBuruk();
      } else {
        if (res.statusCode == 200) {
          var valueBody = jsonDecode(res.body);
          var data = valueBody['data'];
          isTracking.value = data[0]['em_control'];
          regType.value = data[0]['reg_type'];
          print("Req tye ${regType.value}");
          box.write("file_face", data[0]['file_face']);

          if (data[0]['file_face'] == "" || data[0]['file_face'] == null) {
            box.write("face_recog", false);
          } else {
            box.write("face_recog", true);
          }
        }
        // Get.back();
      }
    });
  }

  Future<void> userShift() async {
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

  void widgetButtomSheetFaceRegistrattion() {
    showModalBottomSheet(
      context: Get.context!,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12.0),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Tambahkan Data Wajah",
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              color: Constanst.fgPrimary,
                              fontSize: 16),
                        ),
                        InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: const Icon(Icons.close))
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Pastikan wajah Kamu tidak tertutup dan terlihat jelas. Kamu juga harus berada di ruangan dengan penerangan yang cukup.",
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          color: Constanst.fgSecondary,
                          fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Image.asset(
                      "assets/emoji_happy_tick.png",
                      width: 64,
                      height: 64,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Constanst.infoLight1,
                        borderRadius: BorderRadius.circular(8),
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
                              "Data wajah ini akan digunakan setiap kali Kamu melakukan Absen Masuk dan Keluar.",
                              textAlign: TextAlign.left,
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  color: Constanst.fgSecondary,
                                  fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(FaceidRegistration(
                            status: "registration",
                          ));
                        },
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Constanst.colorWhite,
                            backgroundColor: Constanst.colorPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                            // padding: EdgeInsets.zero,
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0)),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 12.0, bottom: 12.0),
                          child: Text(
                            'Selanjutnya',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                color: Constanst.colorWhite,
                                fontSize: 15),
                          ),
                        ),
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

  void addPengajuan() {}

  void checkAbsensi() {
    var emId = AppData.informasiUser![0].em_id;
    Map<String, dynamic> body = {
      "em_id": emId,
      'date': tglAjunan.value,
      'bulan':
          DateFormat('MM').format(DateTime.parse(tglAjunan.value.toString())),
      'tahun':
          DateFormat('yyyy').format(DateTime.parse(tglAjunan.value.toString()))
    };
    print(body);
    var connect = Api.connectionApi("post", body, "employee-attendance");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        List data = valueBody['data'];
        if (data.isNotEmpty) {
          checkinAjuan.value = data[0]['signin_time'];
          checkoutAjuan.value = data[0]['signout_time'];
        } else {}
      }
    });
  }

  void batalkanAjuan({date}) {
    UtilsAlert.showLoadingIndicator(Get.context!);
    var emId = AppData.informasiUser![0].em_id;
    Map<String, dynamic> body = {
      "em_id": emId,
      'date': date,
      'bulan': DateFormat('MM').format(DateTime.parse(date.toString())),
      'tahun': DateFormat('yyyy').format(DateTime.parse(date.toString()))
    };

    var connect = Api.connectionApi("post", body, "delete-employee-attendance");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        dataPengajuanAbsensi();
        Get.back();
        Get.back();
      } else {
        Get.back();
      }
    });
  }

  void dataPengajuanAbsensi() {
    isLoadingPengajuan.value = true;
    var emId = AppData.informasiUser![0].em_id;
    Map<String, dynamic> body = {
      "em_id": emId,
      'date': tglAjunan.value,
      'bulan': bulanSelectedSearchHistoryPengajuan.value,
      'tahun': tahunSelectedSearchHistoryPengajuan.value,
    };
    print(body);
    var connect = Api.connectionApi("post", body, "get-employee-attendance");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        isLoadingPengajuan.value = false;
        var valueBody = jsonDecode(res.body);
        List data = valueBody['data'];
        print("data pengajuan ${data}");
        if (data.isEmpty) {
          loadingPengajuan.value = "Data tidak tersedia";
        } else {
          loadingPengajuan.value = "Memuat Data...";
        }
        ;
        pengajuanAbsensi.value = data;
      } else {
        isLoadingPengajuan.value = false;
      }
    });
  }

  void resetData() {
    // placeCoordinateCheckin.clear();
    // placeCoordinateCheckout.clear();
    absenLongLatMasuk.clear();
    absenKeluarLongLat.clear();
    // isChecked.value = false;
    // isChecked2.value = false;
    // tglAjunan.value = "";
    // checkinAjuan.value = "";
    // checkoutAjuan.value = "";
    // checkinAjuan2.value = "";
    // checkoutAjuan2.value = "";
    // catataanAjuan.clear();
    // imageAjuan = "".obs;
  }

  void kirimPengajuan(getNomorAjuanTerakhir, status) {
    var emId = AppData.informasiUser![0].em_id;
    Map<String, dynamic> body = {
      "address_masuk": addressMasuk.value.toString(),
      "address_keluar": addressKeluar.value.toString(),
      "absen_LongLat_Masuk": absenLongLatMasuk.value.toString(),
      "absenKeluarLongLat": absenKeluarLongLat.value.toString(),
      "em_id": emId,
      'date': tglAjunan.value,
      'bulan':
          DateFormat('MM').format(DateTime.parse(tglAjunan.value.toString())),
      'tahun':
          DateFormat('yyyy').format(DateTime.parse(tglAjunan.value.toString())),
      'status': "pending",
      'catatan': catataanAjuan.text,
      'checkin': checkinAjuan2.value.toString() == ""
          ? "00:00:00"
          : checkinAjuan2.value.toString(),
      'checkout': checkoutAjuan2.value.toString() == ""
          ? "00:00:00"
          : checkoutAjuan2.value.toString(),
      'lokasi_masuk_id': placeCoordinateCheckin
              .where((p0) => p0['is_selected'] == true)
              .toList()
              .isNotEmpty
          ? placeCoordinateCheckin
              .where((p0) => p0['is_selected'] == true)
              .toList()[0]['id']
          : "",
      'lokasi_keluar_id': placeCoordinateCheckout
              .where((p0) => p0['is_selected'] == true)
              .toList()
              .isNotEmpty
          ? placeCoordinateCheckout
              .where((p0) => p0['is_selected'] == true)
              .toList()[0]['id']
          : "",
      'file': imageAjuan.value,
      'tgl_ajuan': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    };
    print('body data ajuan ${body}');
    var connect = Api.connectionApi("post", body, "save-employee-attendance");

    connect.then((dynamic res) {
      var valueBody = jsonDecode(res.body);

      if (res.statusCode == 200) {
        Get.to(const pengajuanAbsenBerhasil());

        dataPengajuanAbsensi();

        var dataUser = AppData.informasiUser;
        var getFullName = "${dataUser![0].full_name}";
        var convertTanggalBikinPengajuan = status == false
            ? Constanst.convertDateSimpan(
                pilihTanggalTelatAbsen.value.toString())
            : pilihTanggalTelatAbsen.value.toString();
        var getEmid = "${dataUser![0].em_id}";
        var stringTanggal = "${tglAjunan.value} sd ${tglAjunan.value}";
        var typeNotifFcm = "Pengajuan Absensi";
        // kirimNotifikasiToDelegasi(getFullName, convertTanggalBikinPengajuan,
        //     getEmid, '', stringTanggal, typeNotifFcm);

        // kirimNotifikasiToReportTo(
        //     getFullName, convertTanggalBikinPengajuan, getEmid, stringTanggal);

        for (var item in globalCt.konfirmasiAtasan) {
          print("Token notif ${item['token_notif']}");
          var pesan;
          if (item['em_gender'] == "PRIA") {
            pesan =
                "Hallo pak ${item['full_name']}, saya ${getFullName} mengajukan Absensi dengan nomor ajuan ${getNomorAjuanTerakhir}";
          } else {
            pesan =
                "Hallo bu ${item['full_name']}, saya ${getFullName} mengajukan Absensi dengan nomor ajuan ${getNomorAjuanTerakhir}";
          }

          // kirimNotifikasiToDelegasi1(
          //     getFullName,
          //     convertTanggalBikinPengajuan,
          //     item['em_id'],
          //     '',
          //     stringTanggal,
          //     typeNotifFcm,
          //     pesan,
          //     'Approval Absensi');

          // if (item['token_notif'] != null) {
          //   globalCt.kirimNotifikasiFcm(
          //     title: typeNotifFcm,
          //     message: pesan,
          //     tokens: item['token_notif'],
          //   );
          // }
        }
        UtilsAlert.showToast("${valueBody['message']}");
      } else {
        UtilsAlert.showToast("${valueBody['message']}");
      }
    });
    clearData();
  }

  void clearData() {
    tglAjunan.value = "";
    catataanAjuan.clear();
    checkinAjuan2.value = "";
    checkoutAjuan2.value = "";
    placeCoordinateCheckin.clear();
    placeCoordinateCheckout.clear();
    imageAjuan.value = "";
  }

  void kirimNotifikasiToReportTo(
      getFullName, convertTanggalBikinPengajuan, getEmid, stringTanggal) {
    var dt = DateTime.now();
    var jamSekarang = DateFormat('HH:mm:ss').format(dt);
    Map<String, dynamic> body = {
      'emId_pengaju': getEmid,
      'title': 'Pengajuan Absensi',
      'deskripsi':
          'Anda mendapatkan pengajuan Absensi dari $getFullName , tanggal pengajuan $stringTanggal',
      'url': '',
      'atten_date': convertTanggalBikinPengajuan,
      'jam': jamSekarang,
      'status': '2',
      'view': '0',
    };

    var connect = Api.connectionApi("post", body, "notifikasi_reportTo");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        UtilsAlert.showToast("Pengajuan berhasil di kirim");
      }
    });
  }

  void kirimNotifikasiToDelegasi(
      getFullName,
      convertTanggalBikinPengajuan,
      validasiDelegasiSelected,
      fcmTokenDelegasi,
      stringWaktu,
      typeNotifFcm,
      nomorAjuan) {
    var dt = DateTime.now();
    var jamSekarang = DateFormat('HH:mm:ss').format(dt);
    // var description =
    //     'Anda mendapatkan delegasi pekerjaan dari $getFullName untuk Pengajuan Lembur, waktu pengajuan $stringWaktu';

    var description =
        'Anda mendapatkan pengajuan lembur dari $getFullName dengan pemberi tugas anda, waktu pengajuan $stringWaktu';
    Map<String, dynamic> body = {
      'em_id': validasiDelegasiSelected,
      'title': 'Pemberi Tugas Pengajuan Lembur',
      'deskripsi': description,
      'url': '',
      'atten_date': convertTanggalBikinPengajuan,
      'jam': jamSekarang,
      'status': '2',
      'view': '0',
    };
    var connect = Api.connectionApi("post", body, "insert-notifikasi");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        globalCt.kirimNotifikasiFcm(
            title: typeNotifFcm,
            message: description,
            tokens: fcmTokenDelegasi);
        UtilsAlert.showToast("Berhasil kirim delegasi");
      }
    });
  }

  void kirimNotifikasiToDelegasi1(
      getFullName,
      convertTanggalBikinPengajuan,
      fcmTokenDelegasi,
      validasiDelegasiSelected,
      stringTanggal,
      typeNotifFcm,
      pesan,
      type) {
    var dt = DateTime.now();
    var jamSekarang = DateFormat('HH:mm:ss').format(dt);
    // var description =
    //     'Anda mendapatkan delegasi pekerjaan dari $getFullName untuk pengajuan $selectedDropdownFormTidakMasukKerjaTipe, tanggal pengajuan $stringTanggal';
    Map<String, dynamic> body = {
      'em_id': fcmTokenDelegasi,
      'title': type,
      'deskripsi': pesan,
      'url': '',
      'atten_date': convertTanggalBikinPengajuan,
      'jam': jamSekarang,
      'status': '2',
      'view': '0',
    };
    var connect = Api.connectionApi("post", body, "insert-notifikasi");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        // globalCt.kirimNotifikasiFcm(
        //     title: typeNotifFcm,
        //     message: description,
        //     tokens: fcmTokenDelegasi);
        // UtilsAlert.showToast("Berhasil kirim delegasi");
      }
    });
  }

  void nextKirimPengajuan(status) async {
    // absenMasukKeluar.value = placeCoordinateCheckout.value;
    // if (tglAjunan.value == "") {
    //   UtilsAlert.showToast("Tanggal belum dipilih");
    //   return;
    // }

    // if (checkinAjuan2.value == "") {
    //   UtilsAlert.showToast("Waktu Checkin belum dipilih");
    //   return;
    // }

    // if (checkoutAjuan2.value == "") {
    //   UtilsAlert.showToast("Waktu Checkout belum dipilih");
    //   return;
    // }

    if (catataanAjuan.text == "") {
      UtilsAlert.showToast("catatan belum diisi");
      return;
    }

    if (uploadFile.value == true) {
      UtilsAlert.loadingSimpanData(Get.context!, "Sedang Menyimpan File");
      var connectUpload = await Api.connectionApiUploadFile(
          "upload_form_pengajuan_absensi", filePengajuan.value);
      var valueBody = jsonDecode(connectUpload);
      if (valueBody['status'] == true) {
        Navigator.pop(Get.context!);
        // checkNomorAjuan(status);
        var now = DateTime.now();
        var convertBulan = now.month <= 9 ? "0${now.month}" : now.month;
        var finalNomor = "RQ${now.year}${convertBulan}0001";
        kirimPengajuan(finalNomor, status);
      } else {
        UtilsAlert.showToast("Gagal kirim file");
      }
    } else {
      var now = DateTime.now();
      var convertBulan = now.month <= 9 ? "0${now.month}" : now.month;
      var finalNomor = "RQ${now.year}${convertBulan}0001";
      kirimPengajuan(finalNomor, status);
    }
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
              ],
            ),
          ),
        );
      },
    );
  }
}
