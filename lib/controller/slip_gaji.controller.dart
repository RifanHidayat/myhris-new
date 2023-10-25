import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:siscom_operasional/model/compent_slip_gaji.dart';
import 'package:siscom_operasional/model/slip_gaji.dart';
import 'package:siscom_operasional/screen/pesan/approval.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:get/get.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/helper.dart';
 import 'package:open_file_safe/open_file_safe.dart';
import 'package:http/http.dart' as http;
import 'package:siscom_operasional/utils/widget_utils.dart';

class SlipGajiController extends GetxController {
  var slipGaji = <SlipGajiModel>[].obs;
  var slipGajiCurrent = <SlipGajiModel>[].obs;

  var isLoading = true.obs;
  var tahun = DateTime.now().year.obs;
  var gajibulananini = 0.obs;
  var isPemotong = false.obs;
  var isPendapatan = false.obs;
  var isHide = false.obs;
  var bulan = "".obs;
  var args = SlipGajiModel().obs;
  var progress=0.0.obs;
  var hideAmount =
      "*********".obs;
      var messageApproval="".obs;
       // var dataPendapatan = <ComponentSlipGajiModel>[].obs;
  // var dataPemotong = <ComponentSlipGajiModel>[].obs;

  var month = [
    'value01',
    'value02',
    'value03',
    'value04',
    'value05',
    'value06',
    'value07',
    'value08',
    'value09',
    'value10',
    'value11',
    'value12'
  ];

var isSlipgGajiApprove=true.obs;

  var index = 0;

  @override
  void oninit() {
    super.onInit();
  }

  Future<void> fetchSlipGaji() async {
    var dataUser = AppData.informasiUser;

    var id = dataUser![0].em_id;
    isLoading.value = true;
    slipGaji.value = [];
    Map<String, dynamic> body = {
      'tahun': tahun.value,
      'em_id': id.toString(),
   
    };

    var connect = Api.connectionApi("post", body, "slip_gaji");
    try {
      connect.then((dynamic res) {
       
        if (res.statusCode == 200) {
          var valueBody = jsonDecode(res.body);
          print(valueBody);
          if (valueBody['status'] == true) {
            List pendapatanList = valueBody['data_pendapatan'];
            List pemotongList =
                valueBody['data_pemotongan']; // dataPendapatan.value =
            index = 0;
            month.forEach((element) {
              var pendapatan =
                  pendapatanList.where((item) => item[element.toString()].toString() != "0").toList();

              var pemotong = pemotongList
                  .where((item) => item[element.toString()] != "0")
                  .toList();

              // var jumlahPemotong =
              //     pemotong.reduce((a, b) => a[element.toString()] + b);

              double pendapatanSum = pendapatanList.fold(
                  0, (a, b) => a + double.parse(b[element.toString()].toString() ));

              double pemotongsum = pemotongList.fold(
                  0, (a, b) => a + double.parse(b[element.toString()].toString() ));

              print("pendapatan ${pemotongsum}");

              slipGaji.add(SlipGajiModel(
                  index: element,
                  monthNumber:
                      int.parse(element.toString().replaceAll("value", "")),
                  month: element == "value01"
                      ? "January"
                      : element == "value02"
                          ? "February"
                          : element == "value03"
                              ? "Maret"
                              : element == "value04"
                                  ? "April"
                                  : element == "value05"
                                      ? "Mei"
                                      : element == "value06"
                                          ? "juni"
                                          : element == "value07"
                                              ? "Juli"
                                              : element == "value08"
                                                  ? "Agustus"
                                                  : element == "value09"
                                                      ? "september"
                                                      : element == "value10"
                                                          ? "Oktober"
                                                          : element == "value11"
                                                              ? "November"
                                                              : "Deseember",
                  amount: pendapatanSum - pemotongsum,
                  pemotong: ComponentSlipGajiModel.fromJsonToList(pemotong),
                  jumlahPemotong: pemotongsum,
                  jumllahPendapatan: pendapatanSum,
                  pendapatan:
                      ComponentSlipGajiModel.fromJsonToList(pendapatan)));
            });
            slipGaji.value =
                slipGaji.where((element) => element.amount != 0).toList();
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

  Future<void> fetchSlipGajiCurrent() async {
    var dataUser = AppData.informasiUser;

    var id = dataUser![0].em_id;
    slipGajiCurrent.value = [];
    Map<String, dynamic> body = {
      'tahun': DateTime.now().year,
      'em_id': id.toString(),
    };

    var connect =await Api.connectionApi("post", body, "slip_gaji");
    try {
      connect.then((dynamic res) {
        if (res.statusCode == 200) {
        print("status ${res}");
          if (res['status']==true){
          
          
          var valueBody = jsonDecode(res.body);
          List pendapatanList = valueBody['data_pendapatan'];
          List pemotongList =
              valueBody['data_pemotongan']; // dataPendapatan.value =
          index = 0;

  
          month.forEach((element) {
            var pendapatan =
                pendapatanList.where((item) => item[element] != "0").toList();

            var pemotong = pemotongList
                .where((item) => item[element.toString()] != "0")
                .toList();

            // var jumlahPemotong =
            //     pemotong.reduce((a, b) => a[element.toString()] + b);

            int pendapatanSum = pendapatanList.fold(
                0, (a, b) => a + int.parse(b[element.toString()] ?? "0.0"));

            int pemotongsum = pemotongList.fold(
                0, (a, b) => a + int.parse(b[element.toString()] ?? "0.0"));

            slipGajiCurrent.add(SlipGajiModel(
                index: element,
                month: element == "value01"
                    ? "January"
                    : element == "value02"
                        ? "February"
                        : element == "value03"
                            ? "Maret"
                            : element == "value04"
                                ? "April"
                                : element == "value05"
                                    ? "Mei"
                                    : element == "value06"
                                        ? "juni"
                                        : element == "value07"
                                            ? "Juli"
                                            : element == "value08"
                                                ? "Agustus"
                                                : element == "value09"
                                                    ? "september"
                                                    : element == "value10"
                                                        ? "Oktober"
                                                        : element == "value11"
                                                            ? "November"
                                                            : "Deseember",
                amount: pendapatanSum - pemotongsum,
                pemotong: ComponentSlipGajiModel.fromJsonToList(pemotong),
                jumlahPemotong: pemotongsum,
                jumllahPendapatan: pendapatanSum,
                pendapatan: ComponentSlipGajiModel.fromJsonToList(pendapatan)));
          });
          slipGajiCurrent.value = slipGajiCurrent.value
              .where((element) => element.amount != 0)
              .toList();
          isLoading.value = false;

          }else{
               isLoading.value = false;


          }

        }
      });
    } catch (e) {
      isLoading.value = false;
    }
  }

    Future<void> checkSlipGajiApproval() async {
    var dataUser = AppData.informasiUser;
     isLoading.value = true;

    var id = dataUser![0].em_id;
    var desId=dataUser[0].des_id;
    slipGajiCurrent.value = [];
    Map<String, dynamic> body = {
      'tahun': DateTime.now().year,
      'em_id': id.toString(),
      'des_id':desId.toString(),
      'date':DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'bulan':DateFormat('MM').format(DateTime.now()).toString().padLeft(2,'0')
    };

    var connect = Api.connectionApi("post", body, "validasi-payroll-check");
    try {
      connect.then((dynamic res) {
        var valueBody = jsonDecode(res.body);
        print("status code ${valueBody}");
        if (res.statusCode == 200) {
          isSlipgGajiApprove=true.obs;
           isLoading.value = false;
           messageApproval.value=valueBody['approved'];
          
          return ;
      
          

        };
          Get.back();
      UtilsAlert.showToast("Terjadi kesalahan");
      return;
        if (res.statusCode==400){
          isLoading.value = false;
           isSlipgGajiApprove=false.obs;
           return;

        }
        isLoading.value = false;
      Get.back();
      UtilsAlert.showToast("Terjadi kesalahan");
           
      });
    } catch (e) {
      print("error ${e}");
      isLoading.value = false;
      Get.back();
    }
  }

  Future<void> downloadPDF(String pdfUrl) async {
  try {
    print("mulai download");
    // Send an HTTP GET request to fetch the PDF file.
    final response = await http.get(Uri.parse(pdfUrl));

    // Check if the request was successful (status code 200).
    if (response.statusCode == 200) {
      // Get the app's documents directory.
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/my_pdf.pdf';

      // Create a File object to write the PDF data to.
      final File file = File(filePath);

      // Write the PDF data to the file.
      await file.writeAsBytes(response.bodyBytes);
print('success download: ${response.statusCode}');
      // Display a success message or navigate to the PDF viewer.
      // For example, you can use the 'flutter_pdfview' package to view the PDF.
    } else {
      // Handle the error if the request was not successful.
      print('Failed to download PDF: ${response.statusCode}');
    }
  } catch (e) {
    // Handle any exceptions that occur during the download.
    print('Error downloading PDF: $e');
  }
}
// Future<void> startDownload(String url, String fileName) async {
//      final directory = await getApplicationDocumentsDirectory();
//               final localPath = directory.path;
//   final taskId = await FlutterDownloader.enqueue(
//     url: url,
//     savedDir: localPath, // Replace with the directory where you want to save the file
//     fileName: fileName,
//     showNotification: true,
//     openFileFromNotification: true,
//   );

//   FlutterDownloader.registerCallback((id, status, progress) {
//     // Handle download progress and status updates here
//     print('Download task ($id) is in status ($status) and $progress% complete.');
//   });
// }

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
