import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:siscom_operasional/controller/dashboard_controller.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/custom_dialog.dart';

final controller = Get.put(DashboardController());

class UtilsAlert {
  static showToast(message) {
    Fluttertoast.showToast(
        msg: message,
        timeInSecForIosWeb: 5,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        fontSize: 12);
  }

  static showLoadingIndicator(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Padding(
                          child: CircularProgressIndicator(strokeWidth: 3),
                          padding: EdgeInsets.all(8)),
                      Padding(
                          child: Text(
                            'Tunggu Sebentar …',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          padding: EdgeInsets.all(8))
                    ],
                  )
                ]));
      },
    );
  }

  static informasiDashboard(BuildContext context) {
    var informasiRadius = AppData.infoSettingApp;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            content: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 90,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Constanst.colorButton2),
                              child: Center(
                                  child: Icon(
                                Iconsax.message_question,
                                size: 20,
                                color: Constanst.colorPrimary,
                              )),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 8, top: 5),
                              child: Text(
                                "Info",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(Get.context!);
                            },
                            child: const Icon(
                              Iconsax.close_circle,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    "Jarak radius untuk melakukan absen masuk dan keluar adalah ${informasiRadius![0].radius} m",
                    style: TextStyle(color: Constanst.colorText2, fontSize: 14),
                  )
                ]));
      },
    );
  }

  static loadingSimpanData(BuildContext context, text) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            content: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        flex: 20,
                        child: Padding(
                            child: CircularProgressIndicator(strokeWidth: 3),
                            padding: EdgeInsets.all(8)),
                      ),
                      Expanded(
                        flex: 80,
                        child: Padding(
                            child: Text(
                              text,
                              style: const TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                            padding: const EdgeInsets.all(8)),
                      )
                    ],
                  )
                ]));
      },
    );
  }

  static berhasilSimpanData(BuildContext context, text) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            content: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 20,
                        child: Padding(
                            child: Icon(
                              Iconsax.tick_circle,
                              color: Constanst.colorPrimary,
                            ),
                            padding: const EdgeInsets.all(8)),
                      ),
                      Expanded(
                        flex: 80,
                        child: Padding(
                            child: Text(
                              text,
                              style: const TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                            padding: const EdgeInsets.all(8)),
                      )
                    ],
                  )
                ]));
      },
    );
  }

  static shimmerInfoPersonal(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: 20,
                            width: 100,
                            child: Card(child: ListTile(title: Text('')))),
                        SizedBox(
                            height: 20,
                            width: 100,
                            child: Card(child: ListTile(title: Text('')))),
                      ],
                    ),
                  )
                ],
              )
            ],
          )),
    );
  }

  static shimmerMenuDashboard(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: controller.heightPageView.value / 2,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              const SizedBox(width: 16),
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Stack(
                  children: [
                    Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                          color: Constanst.infoLight1,
                          borderRadius: BorderRadius.circular(100.0)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        top: 8,
                      ),
                      child: Container(
                        height: 42,
                        width: 42,
                        decoration: BoxDecoration(
                            color: Constanst.infoLight1,
                            borderRadius: BorderRadius.circular(12.0)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  height: 14,
                  width: 55,
                  decoration: BoxDecoration(
                      color: Constanst.infoLight1,
                      borderRadius: BorderRadius.circular(4.0)),
                ),
              ]),
              const SizedBox(width: 28),
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Stack(
                  children: [
                    Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                          color: Constanst.infoLight1,
                          borderRadius: BorderRadius.circular(100.0)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        top: 8,
                      ),
                      child: Container(
                        height: 42,
                        width: 42,
                        decoration: BoxDecoration(
                            color: Constanst.infoLight1,
                            borderRadius: BorderRadius.circular(12.0)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  height: 14,
                  width: 55,
                  decoration: BoxDecoration(
                      color: Constanst.infoLight1,
                      borderRadius: BorderRadius.circular(4.0)),
                ),
              ]),
              const SizedBox(width: 28),
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Stack(
                  children: [
                    Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                          color: Constanst.infoLight1,
                          borderRadius: BorderRadius.circular(100.0)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        top: 8,
                      ),
                      child: Container(
                        height: 42,
                        width: 42,
                        decoration: BoxDecoration(
                            color: Constanst.infoLight1,
                            borderRadius: BorderRadius.circular(12.0)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  height: 14,
                  width: 55,
                  decoration: BoxDecoration(
                      color: Constanst.infoLight1,
                      borderRadius: BorderRadius.circular(4.0)),
                ),
              ]),
              const SizedBox(width: 28),
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Stack(
                  children: [
                    Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                          color: Constanst.infoLight1,
                          borderRadius: BorderRadius.circular(100.0)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        top: 8,
                      ),
                      child: Container(
                        height: 42,
                        width: 42,
                        decoration: BoxDecoration(
                            color: Constanst.infoLight1,
                            borderRadius: BorderRadius.circular(12.0)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  height: 14,
                  width: 55,
                  decoration: BoxDecoration(
                      color: Constanst.infoLight1,
                      borderRadius: BorderRadius.circular(4.0)),
                ),
              ]),
              const SizedBox(width: 28),
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Stack(
                  children: [
                    Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                          color: Constanst.infoLight1,
                          borderRadius: BorderRadius.circular(100.0)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        top: 8,
                      ),
                      child: Container(
                        height: 42,
                        width: 42,
                        decoration: BoxDecoration(
                            color: Constanst.infoLight1,
                            borderRadius: BorderRadius.circular(12.0)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  height: 14,
                  width: 55,
                  decoration: BoxDecoration(
                      color: Constanst.infoLight1,
                      borderRadius: BorderRadius.circular(4.0)),
                ),
              ]),
              const SizedBox(width: 28),
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Stack(
                  children: [
                    Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                          color: Constanst.infoLight1,
                          borderRadius: BorderRadius.circular(100.0)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        top: 8,
                      ),
                      child: Container(
                        height: 42,
                        width: 42,
                        decoration: BoxDecoration(
                            color: Constanst.infoLight1,
                            borderRadius: BorderRadius.circular(12.0)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  height: 14,
                  width: 55,
                  decoration: BoxDecoration(
                      color: Constanst.infoLight1,
                      borderRadius: BorderRadius.circular(4.0)),
                ),
              ]),
              const SizedBox(width: 28),
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Stack(
                  children: [
                    Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                          color: Constanst.infoLight1,
                          borderRadius: BorderRadius.circular(100.0)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        top: 8,
                      ),
                      child: Container(
                        height: 42,
                        width: 42,
                        decoration: BoxDecoration(
                            color: Constanst.infoLight1,
                            borderRadius: BorderRadius.circular(12.0)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  height: 14,
                  width: 55,
                  decoration: BoxDecoration(
                      color: Constanst.infoLight1,
                      borderRadius: BorderRadius.circular(4.0)),
                ),
              ]),
              const SizedBox(width: 28),
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Stack(
                  children: [
                    Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                          color: Constanst.infoLight1,
                          borderRadius: BorderRadius.circular(100.0)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        top: 8,
                      ),
                      child: Container(
                        height: 42,
                        width: 42,
                        decoration: BoxDecoration(
                            color: Constanst.infoLight1,
                            borderRadius: BorderRadius.circular(12.0)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  height: 14,
                  width: 55,
                  decoration: BoxDecoration(
                      color: Constanst.infoLight1,
                      borderRadius: BorderRadius.circular(4.0)),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  static shimmerBannerDashboard(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: const SizedBox(
            height: 100,
            child: Card(child: ListTile(title: Text(''))),
          )),
    );
  }

  static shimmerNotifikasiInbox(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 20.0, left: 16, right: 16),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: 150,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
        // const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            itemCount: 8, // Sesuaikan jumlah shimmer
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon shimmer
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Baris shimmer untuk pengajuan
                                Container(
                                  width: 200,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Baris shimmer untuk deskripsi
                                Container(
                                  width: double.infinity,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Container(
                                  width: double.infinity,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Container(
                                  width: 150,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Baris shimmer untuk waktu
                                Container(
                                  width: 100,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                        height:
                            8.0), // Jarak antara persegi panjang dan divider
                    Divider(
                      color: Colors.grey[300], // Warna divider
                      thickness: 1.0,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  static Widget homeShimmer() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, right: 16, top: 35, bottom: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shimmer untuk waktu dan profil bagian atas
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Row(
                children: [
                  // Waktu shimmer
                  Container(
                    width: 80,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(2.0), // Sudut melengkung
                    ),
                  ),
                  const Spacer(),
                  // Profile image shimmer
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white,
                  ),
                ],
              ),
            ),
            // Nama dan jabatan shimmer
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 150,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(3.0), // Sudut melengkung
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 100,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(2.0), // Sudut melengkung
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Kotak besar untuk absensi
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0), // Sudut melengkung
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Menu cepat
            shimmerMenuDashboard(Get.context!),
            const SizedBox(height: 8),
            //pengajuan laporan
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: SizedBox(
                    width: MediaQuery.of(Get.context!).size.width * 0.45,
                    height: 80,
                    child: Card(child: ListTile(title: Text(''))),
                  ),
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: SizedBox(
                    width: MediaQuery.of(Get.context!).size.width * 0.45,
                    height: 80,
                    child: Card(child: ListTile(title: Text(''))),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            //banner
            shimmerBannerDashboard(Get.context!),
            const SizedBox(height: 24),
            // Informasi shimmer
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(2.0), // Sudut melengkung
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(18.0), // Sudut melengkung
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 120,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(52.0), // Sudut melengkung
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(18.0), // Sudut melengkung
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static koneksiBuruk() {
    UtilsAlert.showToast("Periksa koneksi internet anda");
    // showGeneralDialog(
    //   context: Get.context!,
    //   barrierColor: Colors.black54, // space around dialog
    //   transitionDuration: Duration(milliseconds: 200),
    //   transitionBuilder: (context, a1, a2, child) {
    //     return ScaleTransition(
    //         scale: CurvedAnimation(
    //             parent: a1,
    //             curve: Curves.elasticOut,
    //             reverseCurve: Curves.easeOutCubic),
    //         child: CustomDialog(
    //           title: "Peringatan",
    //           content: "Periksa koneksi internet anda",
    //           positiveBtnText: "",
    //           negativeBtnText: "",
    //           style: 1,
    //           buttonStatus: 1,
    //           positiveBtnPressed: () {
    //             Navigator.of(context).pop();
    //           },
    //         ));
    //   },
    //   pageBuilder: (BuildContext context, Animation animation,
    //       Animation secondaryAnimation) {
    //     return null!;
    //   },
    // );
  }

  static showDialogCheckServer() {
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
            // our custom dialog
            title: "Peringatan",
            content:
                "Mohon maaf terjadi kesalahan sistem bisa refresh secara berkala",
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

  static showDialogCheckInternet() {
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
            // our custom dialog
            title: "Peringatan Internet",
            content:
                "Menunggu indikator menjadi hijau untuk mengakses menu ini mohon periksa internet anda",
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

  static showCheckOfflineAbsensi(
      {required void Function()? positiveBtnPressed}) {
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
            // our custom dialog
            title: "Informasi",
            content:
                "Menunggu indikator hijau atau anda yakin ingin absensi secara offline? \n\nKeterangan: Absen offline membutuhkan approval",
            positiveBtnText: "Absensi Offline",
            negativeBtnText: "Kembali",
            style: 1,
            buttonStatus: 1,
            positiveBtnPressed: positiveBtnPressed,
          ),
        );
      },
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return null!;
      },
    );
  }

  static showCheckOfflineAbsensiKesalahanServer(
      {required void Function()? positiveBtnPressed}) {
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
            // our custom dialog
            title: "Informasi",
            content:
                "Terjadi kesalahan, Apakah ingin absensi secara offline? \n\nKeterangan: Absen offline membutuhkan approval",
            positiveBtnText: "Absensi Offline",
            negativeBtnText: "Kembali",
            style: 1,
            buttonStatus: 1,
            positiveBtnPressed: positiveBtnPressed,
          ),
        );
      },
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return null!;
      },
    );
  }
}
