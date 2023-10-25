import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:siscom_operasional/model/compent_slip_gaji.dart';
import 'package:siscom_operasional/model/slip_gaji.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';

class Pph21Controller extends GetxController {
  var isPemotong = false.obs;
  var isPendapatan = false.obs;
  var isLoading = true.obs;
  var tahun = DateTime.now().year.obs;
  var index = 0;
  var dataPph21 = [];

  var month = [
    'fiscal01',
    'fiscal02',
    'fiscal03',
    'fiscal04',
    'fiscal05',
    'fiscal06',
    'fiscal07',
    'fiscal08',
    'fiscal09',
    'fiscal10',
    'fiscal11',
    'fiscal12'
  ];
  var args = SlipGajiModel().obs;

  var gaji = 0.0.obs;
  var tunjanganPph21 = 0.0.obs;
  var tunjanganLainhya = 0.0.obs;
  var honarium = 0.0.obs;
  var penerimaan = 0.0.obs;
  var tantium = 0.0.obs;
  var totalBuroto = 0.0.obs;
  var biayaJabatan = 0.0.obs;
  var biayaPensium = 0.0.obs;
  var jumlahPengurang = 0.0.obs;
  var jumlahPenghasilNetto = 0.0.obs;
  var penghasilanNettoMasaSebelumnya = 0.0.obs;
  var jumlahPenghasilNettoUntukPerhitunganPph = 0.0.obs;
  var ptkp = 0.0.obs;
  var penghasilanKenapajaksetahun = 0.0.obs;
  var pphpasal21 = 0.0.obs;
  var pphPasal21yangtelahdipotong = 0.0.obs;
  var pph21telahdipotongMasaSebelumnya = 0.0.obs;
  var pasal21Terutang = 0.0.obs;
  var pphpasal21DanPasal26 = 0.0.obs;
  var premiasuransi = 0.0.obs;
  var pph21ataspenghasilankenaPajak = 0.0.obs;
  var bulan = "".obs;
  var slipGaji = <SlipGajiModel>[].obs;
  var slipGajiCurrent = <SlipGajiModel>[].obs;
  var tempData = <ComponentSlipGajiModel>[].obs;
  var bruto = 0.0.obs;
  var iuranPensiun = 0.0.obs;

  Future<void> fetchSlipGaji() async {
    var dataUser = AppData.informasiUser;

    var id = dataUser![0].em_id;
    isLoading.value = true;
    slipGaji.value = [];
    Map<String, dynamic> body = {
      'tahun': tahun.value,
      'em_id': id.toString(),
    };

    var connect = Api.connectionApi("post", body, "pph21");
    try {
      connect.then((dynamic res) {
        if (res.statusCode == 200) {
          var valueBody = jsonDecode(res.body);
          print(valueBody);
          if (valueBody['status'] == true) {
            List pendapatanList = valueBody['data'];
            print("data gaji ${valueBody['data']}");

            index = 0;
            month.forEach((element) {
              var pendapatan = pendapatanList
                  .where((item) => item[element.toString()].toString() != "0")
                  .toList();

              // var jumlahPemotong =
              //     pemotong.reduce((a, b) => a[element.toString()] + b);

                 double pendapatanSum = pendapatanList.fold(
                  0, (a, b) => a + double.parse(b[element.toString()].toString() ));


              slipGaji.add(SlipGajiModel(
                  index: element,
                  monthNumber:
                      int.parse(element.toString().replaceAll("fiscal", "")),
                  month: element == "fiscal01"
                      ? "January"
                      : element == "fiscal02"
                          ? "February"
                          : element == "fiscal03"
                              ? "Maret"
                              : element == "fiscal04"
                                  ? "April"
                                  : element == "fiscal05"
                                      ? "Mei"
                                      : element == "fiscal06"
                                          ? "juni"
                                          : element == "fiscal07"
                                              ? "Juli"
                                              : element == "fiscal08"
                                                  ? "Agustus"
                                                  : element == "fiscal09"
                                                      ? "september"
                                                      : element == "fiscal10"
                                                          ? "Oktober"
                                                          : element ==
                                                                  "fiscal11"
                                                              ? "November"
                                                              : "Deseember",
                  amount: pendapatanSum,
                  jumlahPemotong: 0,
                  jumllahPendapatan: 0,
                  pendapatan:
                      ComponentSlipGajiModel.fromJsonToList(pendapatanList)));
            });

            slipGaji.value =
                slipGaji.value.where((element) => element.amount != 0).toList();
            isLoading.value = false;
          } else {
            isLoading.value = false;
          }
        }
        isLoading.value = false;
      });
    } catch (e) {
      isLoading.value = false;
    }
  }

  Future<void> detailGaji(index) async {
    var month = args.value.index;
    var result = 0.0;

    print("data bulan ${args.value.index}");
    var data = slipGaji[index];
    print(data.pendapatan![0].emId);

    //gaji
    tempData.value =
        data.pendapatan!.where((element) => element.initial == "A02").toList();
    if (tempData.length > 0) {
      gaji.value = fiscalAmount(month: month, data: tempData[0]);
    }

    // tunjangan  pph21
    tempData.value =
        data.pendapatan!.where((element) => element.initial == "A03").toList();
    if (tempData.length > 0) {
      tunjanganPph21.value = fiscalAmount(month: month, data: tempData[0]);
    }

    //tunjangan lainya;
    tempData.value = data.pendapatan!
        .where((element) =>
            element.initial != "A03" ||
            element.initial != "A02" ||
            element.initial.toString().substring(1) != "8" ||
            element.initial.toString().substring(1) != "9")
        .toList();
    result = tempData!.fold<double>(
        0.0,
        (previousValue, element) =>
            previousValue + fiscalAmount(month: month, data: element));
    tunjanganLainhya.value = result;

    //honarium
    tempData.value =
        data.pendapatan!.where((element) => element.initial == "B03").toList();
    if (tempData.isNotEmpty) {
      honarium.value = fiscalAmount(month: month, data: tempData[0]);
    }
    //premi asuransi A91+A82+A93+D52+D53
    tempData.value = data.pendapatan!
        .where((element) =>
            element.initial == "B91" ||
            element.initial == "B82" ||
            element.initial == "B93" ||
            element.initial == "B52" ||
            element.initial == "B53")
        .toList();
    result = tempData!.fold<double>(
        0.0,
        (previousValue, element) =>
            previousValue + fiscalAmount(month: month, data: element));
    premiasuransi.value = result;
    //natura dan kenikmatan lainnya
    tempData.value =
        data.pendapatan!.where((element) => element.initial == "B06").toList();
    penerimaan.value = fiscalAmount(month: month, data: tempData[0]);
    //tantium
    tempData.value = data.pendapatan!
        .where((element) =>
            element.initial == "B03" ||
            element.initial == "B02" ||
            element.initial == "B07")
        .toList();
    result = tempData!.fold<double>(
        0.0,
        (previousValue, element) =>
            previousValue + fiscalAmount(month: month, data: element));
    tantium.value = result;

    bruto.value = gaji.value +
        tunjanganLainhya.value +
        tunjanganPph21.value +
        honarium.value +
        tantium.value +
        premiasuransi.value;
        totalBuroto.value = gaji.value +
        tunjanganLainhya.value +
        tunjanganPph21.value +
        honarium.value +
        tantium.value +
        premiasuransi.value;

    tempData.value =
        data.pendapatan!.where((element) => element.initial == "C02").toList();
    //biaya jabatan
    tempData.value =
        data.pendapatan!.where((element) => element.initial == "C02").toList();
    if (tempData.isNotEmpty) {
      biayaJabatan.value = fiscalAmount(month: month, data: tempData[0]);
    }

    tempData.value =
        data.pendapatan!.where((element) => element.initial == "C03").toList();
    if (tempData.isNotEmpty) {
      iuranPensiun.value = fiscalAmount(month: month, data: tempData[0]);
    }
    jumlahPengurang.value = iuranPensiun.value + biayaJabatan.value;

    jumlahPenghasilNetto.value = bruto.value - jumlahPengurang.value;

    //penghasilan neeto masa sebelumnya selalu 0
    penghasilanNettoMasaSebelumnya.value = 0;
    //jumlah penghasil netto
    jumlahPenghasilNettoUntukPerhitunganPph.value = jumlahPenghasilNetto *
        (DateTime.now().year.toString() == tahun.value.toString()
            ? (12 - fiscalMonth(month: month))
            : 12);
    
    //ptkp
    tempData.value =
        data.pendapatan!.where((element) => element.initial == "G01").toList();

    if (tempData.isNotEmpty) {
      ptkp.value = fiscalAmount(month: month, data: tempData[0]);
    }
    penghasilanKenapajaksetahun.value =
        jumlahPenghasilNettoUntukPerhitunganPph.value - ptkp.value;

    //penghasilan atas kena pajak
    //ptkp
    tempData.value =
        data.pendapatan!.where((element) => element.initial == "G80").toList();
    if (tempData.isNotEmpty) {
      penghasilanKenapajaksetahun.value =
          fiscalAmount(month: month, data: tempData[0]);
    }

    tempData.value =
        data.pendapatan!.where((element) => element.initial == "G84").toList();
    if (tempData.isNotEmpty) {
      pasal21Terutang.value =
          fiscalAmount(month: month, data: tempData[0]);
    }


    tempData.value =
        data.pendapatan!.where((element) => element.initial == "G85").toList();
    if (tempData.isNotEmpty) {
     pphpasal21DanPasal26.value =
          fiscalAmount(month: month, data: tempData[0]);
    }

  }

  double fiscalAmount({required month, required ComponentSlipGajiModel? data}) {
    return double.parse(month == "fiscal01"
        ? data?.fiscal01.toString()
        : month == "fiscal02"
            ? data?.fiscal02.toString()
            : month == "fiscal03"
                ? data?.fiscal03.toString()
                : month == "fiscal04"
                    ? data?.fiscal04.toString()
                    : month == "fiscal05"
                        ? data?.fiscal05.toString()
                        : month == "fiscal06"
                            ? data?.fiscal06.toString()
                            : month == "fiscal07"
                                ? data?.fiscal07.toString()
                                : month == "fiscal08"
                                    ? data?.fiscal08.toString()
                                    : month == "fiscal09"
                                        ? data?.fiscal09.toString()
                                        : month == "fiscal0"
                                            ? data?.fiscal10.toString()
                                            : month == "fiscal11"
                                                ? data?.fiscal11.toString()
                                                : month == "fiscal12"
                                                    ? data?.fiscal12.toString()
                                                    : data?.fiscal12);
  }

  double fiscalMonth({required month}) {
    return double.parse(month == "fiscal01"
        ? "1"
        : month == "fiscal02"
            ? "2"
            : month == "fiscal03"
                ? "3"
                : month == "fiscal04"
                    ? "4"
                    : month == "fiscal05"
                        ? "5"
                        : month == "fiscal06"
                            ? "6"
                            : month == "fiscal07"
                                ? "7"
                                : month == "fiscal08"
                                    ? "8"
                                    : month == "fiscal09"
                                        ? "9"
                                        : month == "fiscal0"
                                            ? "10"
                                            : month == "fiscal11"
                                                ? "11"
                                                : month == "fiscal12"
                                                    ? "12"
                                                    : "12");
  }

  
Future<void> downloadFile(String fileUrl, String savePath) async {
  print(fileUrl);
  final dio = Dio();
  try {
    final response = await dio.download(
      fileUrl,
      savePath,
      onReceiveProgress: (received, total) {
        print("Downloaded: $total");

          // Calculate the download percentage.
          final percentage = (received / total * 100).toStringAsFixed(2);
          print("Downloaded: $percentage%");
        
      },
    );
      await OpenFile.open(savePath);
    print("Download complete. File saved to: $savePath");
  } catch (e) {
    print("Error downloading file: $e");
  }
}
}
