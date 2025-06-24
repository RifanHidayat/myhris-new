
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:siscom_operasional/model/surat_peringatan_model.dart';
import 'package:siscom_operasional/model/teguran_lisan_model.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';

class SuratPeringatanController extends GetxController {
  var peringatanlist = <Peringatan>[].obs;
  var teguranList = <TeguranLisanModel>[].obs;
  var isLoading = true.obs;
  var isLoadingAlasan = true.obs;
  var listAlasan = [].obs;
  var diterbitkan = ''.obs;
  var bulan = ''.obs;
  var notifSuratPeringatan = 0.obs;
  var notifTeguranLisan = 0.obs;
  // var jumlahNotifikasiBelumDibaca = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getPeringatan();
    getJumlahNotifikasi();
  }

  // void getBranch() {
  //   var connect = Api.connectionApi('get', {}, 'cabang');
  //   connect.then((dynamic res) {
  //     if (res.statusCode == 200) {
  //       var valueBody = jsonDecode(res.body);
  //       print('ini get barnch ${valueBody['data']}');
  //       for (var data in valueBody['data']) {
  //         branchList.add(data);
  //       }
  //       List data = valueBody['data'];
  //       if (data.isNotEmpty) {
  //         var listFirst = data.firstWhere((element) => element['name'] != null,
  //             orElse: () => null);
  //         if (listFirst != null) {
  //           var fullName = listFirst['name'] ?? "";
  //           String namaUserPertama = "$fullName";
  //           selectBranch.value = namaUserPertama;
  //         }
  //       }
  //       branchList.refresh;
  //       selectBranch.refresh;
  //       print(branchList);
  //     } else {
  //       print('error ${res.body}');
  //     }
  //   });
  // }

  
  void infoIds(emId) {
      Map<String, dynamic> body = {
        'val': 'em_id',
        'cari': emId,
      };
      var connect = Api.connectionApi("post", body, "whereOnce-employee");
      connect.then((dynamic res) {
        if (res.statusCode == 200) {
          var valueBody = jsonDecode(res.body);
          if (valueBody['data'] is List && valueBody['data'].isNotEmpty) {
            var fullName = valueBody['data'][0]['full_name'];
            print('Full name for $emId: $fullName');
            print('lah ini dong yang kepangggil');
            diterbitkan.value = fullName;
          } else if (valueBody['data'] is Map) {
            var fullName = valueBody['data']['full_name'];
            print('Full name for $emId: $fullName');
            print('ini kepanggil');
            diterbitkan.value = fullName;
          } else {
            print('Unexpected data format for $emId');
          }
        }
      }).catchError((e) {
        print('Error fetching data for $emId: $e');
      });
  }

  void getPeringatan() async {
    var connect = Api.connectionApi('get', {}, "surat_peringatan");
    await connect.then(
      (dynamic response) {
        if (response.statusCode == 200) {
          List data = jsonDecode(response.body)['data'];
          peringatanlist.value = Peringatan.fromJsonToList(data);
          isLoading.value = false;
          print('ini peringatanlist ${data}');
        } else {
          print('gagal dapet surat peringatan ${response.code}');
        }
      },
    );
  }

  void getDetail(id) async {
    isLoadingAlasan.value = true;
    listAlasan.clear();
    var connect = Api.connectionApi('get', {}, "surat-peringatan/$id");
    connect.then(
      (dynamic response) {
        if (response.statusCode == 200) {
          List data = jsonDecode(response.body)['data'];
          listAlasan.value = data;
          isLoadingAlasan.value = false;
          getJumlahNotifikasi();
          print('Succes : ${response.body}');
        } else {
          listAlasan.value = [];
          // Get.snackbar("gagal", "gagal");
          print('Gagal : ${response.body}');
        }
      },
    );
  }

  void getJumlahNotifikasi() async {
    try {
      var connect = Api.connectionApi('get', {}, "surat_peringatan/count");
      final response = await connect;
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        notifSuratPeringatan.value = data['unread_count'] ?? 0;
        notifSuratPeringatan.refresh();
        print("Jumlah Notifikasi: ${data}");
      } else {
        UtilsAlert.showToast(response.body['message']);
      }
    } catch (e) {
      print("Error Terjadi kesalahan: $e");
    }
  }

  void updateDataNotifSp(id_letter, em_id) {
    Map<String, dynamic> body = {
      "em_id": em_id,
      'letter_id': id_letter
    };

    print(body);

    var connect =
        Api.connectionApi("post", body, "surat_peringatan_status");
    connect.then((dynamic res) async {
      if (res.statusCode == 200) {
        notifSuratPeringatan.refresh();
        print("berhasil ganti status notif");
        UtilsAlert.showToast(res.body['message'].toString());
      } else{
        UtilsAlert.showToast(res.body['message'].toString());
      }
    });
  }

  void getTeguran() async {
    var connect = Api.connectionApi('get', {}, "teguran_lisan");
    await connect.then(
      (dynamic response) {
        if (response.statusCode == 200) {
          List data = jsonDecode(response.body)['data'];
          teguranList.value = TeguranLisanModel.fromJsonToList(data);
          isLoading.value = false;
          print('ini Teguran Lisan $data');
        } else {
          print('gagal dapet Teguran Lisan ${response.code}');
        }
      },
    );
  }

  
  void getDetailTeguran(id) async {
    isLoadingAlasan.value = true;
    listAlasan.clear();
    var connect = Api.connectionApi('get', {}, "teguran_lisan/$id");
    connect.then(
      (dynamic response) {
        if (response.statusCode == 200) {
          List data = jsonDecode(response.body)['data'];
          listAlasan.value = data;
          isLoadingAlasan.value = false;
          print('Succes : ${response.body}');
        } else {
          listAlasan.value = [];
          // Get.snackbar("gagal", "gagal");
          print('Gagal : ${response.body}');
        }
      },
    );
  }

  void updateDataNotifTl(id_letter, em_id) {
    Map<String, dynamic> body = {
      "em_id": em_id,
      'letter_id': id_letter
    };

    print(body);

    var connect =
        Api.connectionApi("post", body, "teguran_lisan_status");
    connect.then((dynamic res) async {
      if (res.statusCode == 200) {
        notifTeguranLisan.refresh();
        print("berhasil ganti status notif");
        UtilsAlert.showToast(res.body['message'].toString());
      } else{
        UtilsAlert.showToast(res.body['message'].toString());
      }
    });
  }

  void getJumlahNotifikasiTl() async {
    try {
      var connect = Api.connectionApi('get', {}, "teguran_lisan/count");
      final response = await connect;
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        notifTeguranLisan.value = data['unread_count'] ?? 0;
        notifTeguranLisan.refresh();
        print("Jumlah Notifikasi: ${data}");
      } else {
        UtilsAlert.showToast(response.body['message']);
      }
    } catch (e) {
      print("Error Terjadi kesalahan: $e");
    }
  }
  
  Future<void> generateAndOpenPdf(int selectedId) async {
    final pdf = pw.Document();
    final selectedKontrak = teguranList.firstWhere(
      (kontrak) => kontrak.id == selectedId,
    );
    if (selectedKontrak == null) {
      print(' id $selectedId gada');
      return;
    }

    print('ini apa an sih ${selectedKontrak}');
    Uint8List? esignBytes;
    if (selectedKontrak.file_esign != null &&
        selectedKontrak.file_esign.isNotEmpty) {
      try {
        var fullImage = Api.fileDoc + selectedKontrak.file_esign;
        final response = await http.get(Uri.parse(fullImage));
        if (response.statusCode == 200) {
          esignBytes = response.bodyBytes;
        } else {
          print('Gagal mengunduh tanda tangan: ${response.statusCode}');
        }
      } catch (e) {
        print('Kesalahan saat mengunduh tanda tangan: $e');
      }
    }
    var count = 3;
// Example: Get PdfColor
    final pdfColor = Colors.red;

    final int colorInt = pdfColor.value;
    final imageData = await rootBundle.load('assets/icon.png');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Center(
              child: pw.Column(
                children: [
                  pw.SizedBox(height: 30),
                  pw.Center(
                    child: pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment
                              .center, // Elemen berada di tengah horizontal
                          children: [
                            // Bagian gambar/logo
                            pw.SizedBox(
                              width: 70, // Ukuran logo
                              child: pw.Image(
                                pw.MemoryImage(imageData.buffer.asUint8List()),
                                width: 70, // Ukuran logo
                              ),
                            ),
                            pw.SizedBox(
                                width: 25), // Jarak antara logo dan teks
                            // Bagian teks
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment
                                  .start, // Teks tetap rata kiri
                              children: [
                                // Judul
                                pw.Text(
                                  'PT . SHAN INFORMASI SISTEM',
                                  style: pw.TextStyle(
                                    fontSize:
                                        34, // Ukuran font sedikit lebih kecil
                                    color: PdfColor.fromInt(colorInt),
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                                pw.SizedBox(
                                    height: 8), // Jarak antar elemen teks
                                // Sub-judul
                                pw.Text(
                                  'BEST SOLUTION FOR BUSINESS CONTROL',
                                  style: pw.TextStyle(
                                    fontSize:
                                        11.5, // Ukuran font sedikit lebih kecil untuk sub-judul
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColor.fromInt(
                                        Constanst.onPrimary.value),
                                  ),
                                ),
                                pw.SizedBox(height: 8),
                                // Alamat
                                // pw.Text(
                                //   'Sedayu City Boulevard Raya Blok E No. 90 (SCBRE/090), RT.8/RW.5 Rawa Terate, Cakung, DKI Jakarta 13920',
                                //   style: pw.TextStyle(
                                //     fontSize:
                                //         8, // Ukuran font sedikit lebih kecil untuk alamat
                                //     color: PdfColor.fromInt(
                                //         Constanst.onPrimary.value),
                                //   ),
                                // ),
                                // Informasi kontakkkk
                              ],
                            ),
                          ],
                        ),

//
                        pw.SizedBox(height: 12),
                        pw.Divider(
                          height: 0,
                          thickness: 1,
                          color: PdfColor.fromInt(Constanst.fgBorder.value),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 30),
            pw.Center(
              child: pw.Text(
                'PERJANJIAN KERJA',
                style:
                    pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
                textAlign: pw.TextAlign.center,
              ),
            ),
            pw.SizedBox(height: 30),
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(
                    'Pasal 1',
                    style: pw.TextStyle(
                        fontSize: 14, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(
                    'SUBJEK KERJA',
                    style: pw.TextStyle(
                        fontSize: 14, fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 15),
            pw.Text(
              'Perjanjian kerja ini mengikat 2 (dua) belah pihak,yaitu:',
              textAlign: pw.TextAlign.left,
            ),
            pw.SizedBox(height: 8),

            pw.Container(
              padding: pw.EdgeInsets.symmetric(horizontal: 16, vertical: 1),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    flex: 15,
                    child: pw.Text(
                      "Nama",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Text(":"),
                  pw.SizedBox(width: 4),
                  pw.Expanded(
                    flex: 68,
                    child: pw.Text(
                      'iini',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.normal),
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 1),
            pw.Container(
              padding: pw.EdgeInsets.symmetric(horizontal: 16, vertical: 1),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    flex: 15,
                    child: pw.Text(
                      "NIK",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Text(":"),
                  pw.SizedBox(width: 4),
                  pw.Expanded(
                    flex: 68,
                    child: pw.Text(
                      '${selectedKontrak}',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.normal),
                    ),
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 4),
            pw.Text('Yang selanjutnya disebut PIHAK PERTAMA;',
                textAlign: pw.TextAlign.left),
            pw.SizedBox(height: 10),
            pw.Text(
                'Dan PT. SINAR ARTA MULIA, yang selanjutnya disebut PIHAK KEDUA.',
                textAlign: pw.TextAlign.left),
            pw.SizedBox(height: 20),
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(
                    'Pasal 2',
                    style: pw.TextStyle(
                        fontSize: 14, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(
                    'POSISI, TEMPAT & WAKTU KERJA',
                    style: pw.TextStyle(
                        fontSize: 14, fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 15),
            pw.Text(
              'PIHAK PERTAMA menyetujui tempat & waktu kerja yang telah disepakati dengan PIHAK KEDUA, yaitu:',
              textAlign: pw.TextAlign.left,
            ),
            pw.SizedBox(height: 8),
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  flex: 15,
                  child: pw.Text(
                    "Posisi",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Text(":"),
                pw.SizedBox(width: 4),
                pw.Expanded(
                  flex: 68,
                  child: pw.Text(
                    selectedKontrak.posisi,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.normal),
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 4),
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  flex: 15,
                  child: pw.Text(
                    "Tempat Kerja",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Text(":"),
                pw.SizedBox(width: 4),
                pw.Expanded(
                  flex: 68,
                  child: pw.Text(
                    '${selectedKontrak.lokasi}',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.normal),
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 4),
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  flex: 15,
                  child: pw.Text(
                    "Catatan Lain",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Text(":"),
                pw.SizedBox(width: 4),
                pw.Expanded(
                  flex: 68, // Lebar nilai
                  child: pw.Text(
                    '${selectedKontrak}',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.normal),
                  ),
                ),
              ],
            ),

            pw.SizedBox(height: 20),
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(
                    'Pasal 3',
                    style: pw.TextStyle(
                        fontSize: 14, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(
                    'PERIODE KONTRAK KERJA',
                    style: pw.TextStyle(
                        fontSize: 14, fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 15),
            pw.Text(
              'PIHAK PERTAMA menyetujui periode kontrak kerja yang telah disepakati dengan PIHAK KEDUA, yaitu:',
              textAlign: pw.TextAlign.left,
            ),
            pw.SizedBox(height: 8),
           pw.SizedBox(height: 30),
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(
                    'Pasal 4',
                    style: pw.TextStyle(
                        fontSize: 14, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(
                    'PERATURAN KERJA',
                    style: pw.TextStyle(
                        fontSize: 14, fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 15),
            pw.Text(
              'PIHAK PERTAMA dan PIHAK KEDUA telah bersepakat untuk mematuhi seluruh peraturan yang tertulis pada Buku Peraturan Perusahaan Versi Terbaru dan semua peraturan lain yang diberlakukan oleh manajemen dan direksi sesuai dengan keberlakuannya.',
              textAlign: pw.TextAlign.left,
            ),
            pw.SizedBox(height: 30),
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(
                    'Pasal 5',
                    style: pw.TextStyle(
                        fontSize: 14, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(
                    'HAK & KEWAJIBAN, SERTA TIMBAL BALIK KERJA',
                    style: pw.TextStyle(
                        fontSize: 14, fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 15),
            pw.Text(
              'PIHAK PERTAMA dan PIHAK KEDUA telah bersepakat untuk mematuhi seluruh peraturan yang tertulis pada Buku Peraturan Perusahaan Versi Terbaru.',
              textAlign: pw.TextAlign.left,
            ),
            pw.SizedBox(height: 30),
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(
                    'Pasal 6',
                    style: pw.TextStyle(
                        fontSize: 14, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(
                    'HAL LAINNYA',
                    style: pw.TextStyle(
                        fontSize: 14, fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 15),
            pw.Text(
              'PIHAK PERTAMA dan PIHAK KEDUA telah bersepakat mengenai hal-hal lainnya di bawah ini:',
              textAlign: pw.TextAlign.left,
            ),
            pw.Container(
              padding: pw.EdgeInsets.only(left: 20),
              child: pw.Text(
                '1. Formulir identitas karyawan dan dokumen perjanjian kerja adalah satu kesatuan yang harus selalu di inventariskan bersamaan untuk mencegah hilangnya salah satu dokumen.',
                textAlign: pw.TextAlign.left,
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Container(
              padding: pw.EdgeInsets.only(left: 20),
              child: pw.Text(
                '2. Apabila terdapat pembaharuan atau update perjanjian kerja, maka perjanjian kerja terdahulu harus dijadikan satu file bersama dengan perjanjian yang baru untuk mencegah hilangnya salah satu dokumen.',
                textAlign: pw.TextAlign.left,
              ),
            ),
            pw.SizedBox(height: 8),
            pw.SizedBox(height: 8),

            pw.Text(
              'Jakarta',
              textAlign: pw.TextAlign.start,
            ),
            pw.Text(
              'yang bersepakat',
              textAlign: pw.TextAlign.start,
            ),

            pw.SizedBox(height: 30),
            pw.Row(children: [
              pw.Expanded(
                flex: 50,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.SizedBox(height: 8),
                    pw.Align(
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        mainAxisSize: pw.MainAxisSize.min,
                        children: [
                          esignBytes != null
                              ? pw.Image(
                                  pw.MemoryImage(esignBytes!),
                                  width: 110,
                                  height: 110,
                                )
                              : pw.Padding(
                                  padding: pw.EdgeInsets.only(
                                    bottom: 50,
                                  ),
                                  child: pw.Text(
                                    'valid tanpa tanda tangan',
                                    style: pw.TextStyle(
                                        fontSize: 10,
                                        fontStyle: pw.FontStyle.italic,
                                        color: PdfColor.fromInt(colorInt)),
                                  ),
                                ),
                          pw.Text(
                            'bhb',
                            style: pw.TextStyle(
                                fontSize: 12, fontWeight: pw.FontWeight.bold),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(
                            'Pihak Pertama',
                            style: pw.TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              pw.Expanded(
                  flex: 50,
                  child: pw.Align(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Center(
                          child: pw.Column(
                            mainAxisAlignment: pw.MainAxisAlignment.center,
                            children: [
                              pw.SizedBox(height: 20),
                              pw.Text(
                                'valid tanpa tanda tangan',
                                style: pw.TextStyle(
                                    fontSize: 10,
                                    fontStyle: pw.FontStyle.italic,
                                    color: PdfColor.fromInt(colorInt)),
                              ),
                              pw.SizedBox(
                                height: 50,
                              ),
                              pw.Text(
                                'PT. SINAR ARTA MULIA',
                                style: pw.TextStyle(
                                    fontSize: 12,
                                    fontWeight: pw.FontWeight.bold),
                              ),
                              pw.Text(
                                'Tanggal Validasi',
                                style: pw.TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ))
            ]),
            pw.SizedBox(height: 30),
          ];
        },
      ),
    );

    final outputDir = await getTemporaryDirectory();
    final filePath = '${outputDir.path}/example_with_getx.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    final result = await OpenFile.open(filePath);

    if (result.type != ResultType.done) {
      // Get.snackbar(
      //   'Error',
      //   'Failed to open PDF',
      //   snackPosition: SnackPosition.BOTTOM,
      // );
    }
  }

  String formatTanggal(String tanggalString) {
    DateTime tanggal = DateTime.parse(tanggalString);
    return DateFormat('d MMMM yyyy', 'id_ID').format(tanggal);
  }


}
