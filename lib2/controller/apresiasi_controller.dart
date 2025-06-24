import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:pdf/widgets.dart' as pw;

class ApresiasiController extends GetxController {
  // Define your variables and observables here
  var isLoading = false.obs;
  var apresiasiList = [].obs;

  // Example method to fetch data
  Future<void> fetchApresiasi() async {
    apresiasiList.clear();
    var connect = Api.connectionApi("get", {}, "apresiasi/user");

    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        apresiasiList.value = valueBody['data'];
        print("data employee Apresiasi ${apresiasiList}");
        // this.employeeApresiasi.refresh();
      }
    });
  }

  Future<void> generateAndOpenPdf(
      nomor, hal, nama, divisi, reward, tanggal) async {
    final pdf = pw.Document();

    final imageData = await rootBundle.load('assets/icon.png');
    final font = pw.Font.times();
    final fontItalic = pw.Font.timesItalic();
    final fontBold = pw.Font.timesBold();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter,
        margin: const pw.EdgeInsets.symmetric(horizontal: 70, vertical: 30),
        header: (context) =>
            pw.Row(children: [
          pw.Image(pw.MemoryImage(imageData.buffer.asUint8List()), width: 70),
          pw.SizedBox(width: 10),
          pw.Column(
            children: [
              pw.Text(
                'PT . SHAN INFORMASI SISTEM',
                style: pw.TextStyle(
                  font: fontBold,
                  fontSize: 16,
                  letterSpacing: 1.5,
                  fontWeight: pw.FontWeight.bold,
                ),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'B E S T   S O L U T I O N   F O R   B U S I N E S S   C O N T R O L',
                style: pw.TextStyle(
                  font: font,
                  fontSize: 9.5,
                  letterSpacing: 2,
                ),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 6),
              pw.Text(
                'ERP Software   |   HRIS   |   Mobile Application',
                style: pw.TextStyle(
                  font: font,
                  fontSize: 9.5,
                ),
                textAlign: pw.TextAlign.center,
              ),
            ],
          ),
        ]),
        footer: (context) => pw.Align(
          alignment: pw.Alignment.bottomCenter,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                'Address: City Resort Residence Rukan Malibu Blok J No. 75-76 Cengkareng - Jakarta Barat 11730',
                style: pw.TextStyle(font: font, fontSize: 11),
                textAlign: pw.TextAlign.center,
              ),
              pw.Text(
                'Telp. : (+62 21) 5694 5002/03   Email : cs@siscom.co.id   Website : www.siscom.co.id',
                style: pw.TextStyle(font: font, fontSize: 11),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'AFTER SALES SERVICE IS MORE IMPORTANT THAN SALES',
                style: pw.TextStyle(
                    font: font, fontSize: 11, fontWeight: pw.FontWeight.bold),
                textAlign: pw.TextAlign.center,
              ),
            ],
          ),
        ),
        build: (context) => [
          pw.SizedBox(height: 25),

          // 3. TITLE
          pw.Center(
            child: pw.Column(
              children: [
                pw.Text(
                  'SURAT APRESIASI KARYAWAN',
                  style: pw.TextStyle(
                    font: font,
                    fontSize: 14,
                    decoration: pw.TextDecoration.underline,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  'NO : $nomor',
                  style: pw.TextStyle(
                      font: font, fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 20),
                _infoRow(font, 'Hal', hal),
              ],
            ),
          ),

          pw.SizedBox(height: 15),

          // 4. ISI PARAGRAF
          pw.Text(
            'Melalui surat ini, kami menyampaikan apresiasi kepada :',
            style: pw.TextStyle(font: font, fontSize: 12),
          ),
          pw.SizedBox(height: 6),
          _infoRow(font, 'Nama', nama),
          _infoRow(font, 'Divisi', divisi),
          pw.SizedBox(height: 10),
          pw.RichText(
            textAlign: pw.TextAlign.justify,
            text: pw.TextSpan(
              style: pw.TextStyle(
                font: font,
                fontSize: 12,
                lineSpacing: 4.0,
              ),
              children: [
                pw.TextSpan(
                  text:
                      'Atas dedikasi, kerja keras, kedisiplinan, dan kontribusi luar biasa yang telah diberikan kepada perusahaan dalam hal ',
                ),
                pw.TextSpan(
                  text: hal,
                  style: pw.TextStyle(
                      fontStyle: pw.FontStyle.italic, font: fontItalic),
                ),
                pw.TextSpan(
                  text:
                      ', kami mengapresiasi setinggi-tingginya dan mengucapkan terima kasih.',
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 15),

          pw.RichText(
            textAlign: pw.TextAlign.justify,
            text: pw.TextSpan(
              style: pw.TextStyle(
                font: font,
                fontSize: 12,
                lineSpacing: 4.0,
              ),
              children: [
                pw.TextSpan(
                  text:
                      'Sebagai bentuk penghargaan atas pencapaian ini, perusahaan memberikan ',
                ),
                pw.TextSpan(
                  text: reward,
                  style: pw.TextStyle(
                      fontStyle: pw.FontStyle.italic, font: fontItalic),
                ),
                pw.TextSpan(
                  text:
                      ' sebagai apresiasi atas kerja keras dan loyalitas yang saudara berikan. Profesionalisme saudara memberikan dampak positif terhadap produktivitas tim dan perusahaan.',
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 15),
          pw.Text(
            'Kami berharap saudara dapat dan terus mempertahankan semangat kerja. Sehingga menjadi '
            'contoh dan motivasi bagi karyawan lainnya.',
            style: pw.TextStyle(
              font: font,
              fontSize: 12,
              lineSpacing: 4.0,
            ),
            textAlign: pw.TextAlign.justify,
          ),
          pw.SizedBox(height: 15),
          pw.Text(
            'Demikian surat apresiasi ini kami sampaikan. Terima kasih atas dedikasi saudara.',
            style: pw.TextStyle(
              font: font,
              fontSize: 12,
              lineSpacing: 4.0,
            ),
            textAlign: pw.TextAlign.justify,
          ),

          pw.SizedBox(height: 15),

          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text('Jakarta, ${Constanst.convertDate1(tanggal)}',
                style: pw.TextStyle(font: font, fontSize: 12)),
          ),

          pw.Align(
            alignment: pw.Alignment.centerLeft,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.SizedBox(height: 15),
                pw.Text('Hormat Kami,',
                    style: pw.TextStyle(font: font, fontSize: 12)),
                pw.SizedBox(height: 35),
                pw.Text('(Rudy Haryanto, S.Kom.)',
                    style: pw.TextStyle(
                        font: font,
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 4),
                pw.Text('Direktur Utama',
                    style: pw.TextStyle(
                        font: font,
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold)),
              ],
            ),
          ),

          pw.SizedBox(height: 25),
        ],
      ),
    );

    // Simpan dan buka file PDF
    final outputDir = await getTemporaryDirectory();
    final filePath = '${outputDir.path}/surat_apresiasi_siscom_style.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());
    await OpenFile.open(filePath);
  }

  pw.Widget _infoRow(pw.Font font, String label, String value) {
    return pw.Container(
      padding: pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            flex: 12,
            child: pw.Text(label,
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 12.0,
                    font: font)),
          ),
          pw.Text(":"),
          pw.SizedBox(width: 4),
          pw.Expanded(
            flex: 68,
            child: pw.Text(value,
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.normal,
                    fontSize: 12.0,
                    font: font)),
          ),
        ],
      ),
    );
  }
}
