import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:path_provider/path_provider.dart';
import 'package:siscom_operasional/controller/auth_controller.dart';
import 'package:siscom_operasional/controller/dashboard_controller.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';
import 'package:http/http.dart' as http;
import 'package:siscom_operasional/utils/widget_utils.dart';

class DetaillPeraturan extends StatefulWidget {
  var type;
  var gambar;
  var title;
  var keterangan;
  var emId;

  DetaillPeraturan(
      {super.key,
      this.type,
      this.gambar,
      this.keterangan,
      this.title,
      this.emId});

  @override
  State<DetaillPeraturan> createState() => _DetaillPeraturanState();
}

class _DetaillPeraturanState extends State<DetaillPeraturan> {
  var path = '';
  int totalPages = 0;
  int currentPage = 0;
  var isAgreed = false;
  var isChecked = false;
  var controller = Get.put(AuthController());
//  var dashboardController = Get.put(DashboardController());
  late PDFViewController _pdfViewController;

  void _scrollToTop() async {
  if (_pdfViewController != null) {
    int currentPage = await _pdfViewController.getCurrentPage() ?? 0;

    for (int i = currentPage; i >= 0; i--) {
      await Future.delayed(Duration(milliseconds: 10), () {
        _pdfViewController.setPage(i);
      });
    }
  }
}

void _scrollToEnd() async {
  if (_pdfViewController != null && totalPages > 0) {
    int currentPage = await _pdfViewController.getCurrentPage() ?? 0;

    for (int i = currentPage; i < totalPages; i++) {
      await Future.delayed(Duration(milliseconds: 10), () {
        _pdfViewController.setPage(i);
      });
    }
  }
}


  void downloadPDF() async {
    UtilsAlert.showToast('${Api.fileDoc}${widget.gambar}');
    print('${Api.fileDoc}${widget.gambar}');
    // Make a network request to download the PDF
    final response =
        await http.get(Uri.parse('${Api.fileDoc}${widget.gambar}'));
    final Directory dir = await getApplicationDocumentsDirectory();
    final File file = File('${dir.path}/downloaded_sample.pdf');

    // Write the bytes to a file
    await file.writeAsBytes(response.bodyBytes, flush: true);
    setState(() {
      path = file.path;
    });
  }

  Future<void> _downloadAndSavePDF() async {
    final response =
        await http.get(Uri.parse('${Api.fileDoc}${widget.gambar}'));
    print('${Api.fileDoc}${widget.gambar}');

    if (response.statusCode == 200) {
      // Get the app's document directory
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String localPath = '${appDocDir.path}/downloaded_pdf.pdf';

      // Save the PDF file to the local path
      File localFile = File(localPath);
      await localFile.writeAsBytes(response.bodyBytes);

      // Update the file path
      setState(() {
        path = localPath;
      });
    } else {
      UtilsAlert.showToast("Failed to download PDF: ${response.statusCode}");
      // Handle the error (e.g., network issue)
      print("Failed to download PDF: ${response.body}");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // downloadPDF();
    _downloadAndSavePDF();
  }

  void _onPageChanged(int currentPage, int totalPages) {
    setState(() {
      this.currentPage = currentPage;
      this.totalPages = totalPages;
    });
    //UtilsAlert.showToast("halaman terakhir");
    // Check if the user reached the last page
    if (currentPage == totalPages - 1) {
      setState(() {
        isChecked = true;
      });
      // UtilsAlert.showToast("halaman terakhir");
      // Do something when the last page is reached (e.g., show a message)
      //  print('Reached the last page!');
      // You can also display a dialog, show a toast, or trigger any other action here.
    }
  }

  @override
  Widget build(BuildContext context) {
    print('ini currentPage $currentPage');
    return WillPopScope(
      onWillPop: () async {
        if (widget.type == 'login') {
          Get.back();
          Get..back();
        } else {}

        // Show a confirmation dialog before popping the screen
        // bool? shouldPop = await showDialog(
        //   context: context,
        //   builder: (BuildContext context) {
        //     return AlertDialog(
        //       title: Text("Are you sure?"),
        //       content: Text("Do you want to leave this page?"),
        //       actions: [
        //         TextButton(
        //           onPressed: () {
        //             Navigator.of(context).pop(false); // Don't pop
        //           },
        //           child: Text("No"),
        //         ),
        //         TextButton(
        //           onPressed: () {
        //             Navigator.of(context).pop(true); // Pop the page
        //           },
        //           child: Text("Yes"),
        //         ),
        //       ],
        //     );
        //   },
        // );

        return false; // Return the result from the dialog
      },
      child: Scaffold(
        floatingActionButton:
        Padding(
          padding: const EdgeInsets.only(bottom: 44.0, right: 16.0),
          child: FloatingActionButton(
            onPressed: (){
              currentPage == 0
              ? _scrollToEnd()
              : _scrollToTop();
            },
            child: Icon(
              currentPage == 0
              ? Icons.keyboard_arrow_down
              : Icons.keyboard_arrow_up
            ),
          ),
        ),
        body: path.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 50, bottom: 15, left: 16, right: 16),
                    child: Text(
                      widget.title.toString(), // Customize this title
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: PDFView(
                      filePath: path,
                      enableSwipe:
                          true, // Enable swipe gestures to navigate pages
                      swipeHorizontal: false, // Vertical scroll
                      autoSpacing: true, // Enable automatic spacing
                      pageSnap: true, // Enable snapping to the page
                      onPageChanged: (currentPage, totalPages) {
                        _onPageChanged(currentPage!, totalPages!);
                      },
                      onViewCreated: (PDFViewController pdfViewController) {
                        _pdfViewController = pdfViewController;
                      },
                    ),
                  ),
                  widget.type == "detail"
                      ? Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () {
                              Get.back();
                              // controller.loginUser();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Constanst.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: Text(
                              'Kembali',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Constanst.colorWhite,
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Untuk menggunakan SISRAJJ - HRIS Self Service, saya menyetujui pernyataan berikut:",
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Constanst.fgPrimary,
                                ),
                              ),
                              const SizedBox(height: 16),
                              isChecked == true
                                  ? Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Transform.translate(
                                          offset: const Offset(-15, -10),
                                          child: Checkbox(
                                            value: isAgreed,
                                            onChanged: (value) {
                                              if (isChecked == false) {
                                                UtilsAlert.showToast(
                                                    "Baca Peraturan Perusahaan terlebih dahulu");
                                                return;
                                              }
                                              setState(() {
                                                isAgreed = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: Transform.translate(
                                            offset: const Offset(-10, 0),
                                            child: Text(
                                              "Saya telah membaca, memahami, dan menyetujui informasi, peraturan dan ketentuan Perusahaan.",
                                              style: GoogleFonts.inter(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Constanst.fgPrimary,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 5,
                                          child: InkWell(
                                            onTap: () {
                                              if (isChecked == false) {
                                                UtilsAlert.showToast(
                                                    "Baca Peraturan Perusahaan terlebih dahulu");
                                                return;
                                              }
                                            },
                                            child: Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                  border: Border.all(
                                                    width: 2,
                                                    color: Constanst.secondary,
                                                  )),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 13,
                                        ),
                                        // Transform.translate(
                                        //   offset: const Offset(-15, -10),
                                        //   child: Checkbox(
                                        //     fillColor: MaterialStateProperty
                                        //         .resolveWith<Color>(
                                        //       (Set<MaterialState> states) {
                                        //         if (states.contains(
                                        //             MaterialState.selected)) {
                                        //           return Colors
                                        //               .green; // Color when checked
                                        //         }
                                        //         return Colors
                                        //             .transparent; // Color when unchecked
                                        //       },
                                        //     ),
                                        //     value: isAgreed,
                                        //     onChanged: (value) {
                                        //       if (isChecked == false) {
                                        //         UtilsAlert.showToast(
                                        //             "Baca Peraturan Perusahaan terlebih dahulu");
                                        //         return;
                                        //       }
                                        //       setState(() {
                                        //         isAgreed = value!;
                                        //       });
                                        //     },
                                        //   ),
                                        // ),
                                        Expanded(
                                          flex: 95,
                                          child: Text(
                                            "Saya telah membaca, memahami, dan menyetujui informasi, peraturan dan ketentuan Perusahaan.",
                                            style: GoogleFonts.inter(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Constanst.secondary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                              widget.type.toString() == "dashboard"
                                  ? ElevatedButton(
                                      onPressed: isAgreed
                                          ? () {
                                              // dashboardController
                                              //     .isCheckedPeraturanPerusahaan(
                                              //         widget.emId);
                                              // controller.loginUser();
                                            }
                                          : null,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Constanst.colorPrimary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text(
                                        'Lanjutkan',
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Constanst.colorWhite,
                                        ),
                                      ),
                                    )
                                  : widget.type.toString() == "login"
                                      ? ElevatedButton(
                                          onPressed: isAgreed
                                              ? () {
                                                print('ini login email${controller.email.value.text}');
                                                  controller.loginUser();
                                                  // dashboardController.checkperaturanPerusahaan(AppData.informasiUser![0].em_id);
                                                }
                                              : null,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Constanst.colorPrimary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: Text(
                                            'Lanjut Login',
                                            style: GoogleFonts.inter(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Constanst.colorWhite,
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                            ],
                          ),
                        ),
                ],
              ),
      ),
    );
  }
}
