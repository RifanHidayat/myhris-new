import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/constans.dart';

class GlobalController extends GetxController {
  var valuePolaPersetujuan = "".obs;
  var konfirmasiAtasan = [].obs;
  var sysData = [].obs;
  var employeeSisaCuti = [].obs;

  @override
  void onReady() async {
    getLoadsysData();
    super.onReady();
  }

  void getLoadsysData() {
    var connect = Api.connectionApi("get", "", "sysdata");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        sysData.value = valueBody['data'];
        this.sysData.refresh();
        loadAllReportTo();
        loadAllSisaCuti();
      }
    });
  }

  void loadAllReportTo() async {
    // validasi multi persetujuan
    var statusPersetujuan = "";
    for (var element in sysData.value) {
      if (element['kode'] == "013") {
        statusPersetujuan = "${element['name']}";
      }
    }
    print("status persetujuan ${statusPersetujuan}");
    valuePolaPersetujuan.value = statusPersetujuan;
    this.valuePolaPersetujuan.refresh();
    print("di kontroller global ${valuePolaPersetujuan.value}");
    // em id user
    var dataUser = AppData.informasiUser;
    var getEmid = dataUser![0].em_id;
    Map<String, dynamic> body = {'em_id': getEmid, 'kode': statusPersetujuan};
    var connect = Api.connectionApi("post", body, "informasi_wa_atasan");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        var data = valueBody['data'];
        print("data atasan ${data}");
        var seen = Set<String>();
        List filter =
            data.where((atasan) => seen.add(atasan['full_name'])).toList();
        konfirmasiAtasan.value = filter;
        this.konfirmasiAtasan.refresh();
      }
    });
  }

  // void loadAllSisaCuti() {
  //   print("sisa PKWT`");
  //   var statusReminder = "";
  //   var emids = [];
  //   var status = false;
  //   for (var element in sysData.value) {
  //     if (element['kode'] == "015") {
  //       statusReminder = "${element['name']}";
  //     }
  //     if (element['kode'] == '016') {
  //       emids = element['name'].toString().split(',');
  //     }
  //   }

  //   print("data ${emids.toString()}");
  //   Map<String, dynamic> body = {'reminder': statusReminder};
  //   var connect = Api.connectionApi("post", body, "info_sisa_kontrak");
  //   connect.then((dynamic res) {
  //     if (res.statusCode == 200) {
  //       var valueBody = jsonDecode(res.body);
  //       employeeSisaCuti.value = valueBody['data'];
  //       var tempData = [];
  //       emids.forEach((element) {
  //         if (element.toString() ==
  //             AppData.informasiUser![0].em_id.toString()) {
  //           status = true;
  //           tempData.add(element);
  //         }

  //         // status
  //         // if (element.toString()==AppData.informasiUser![0].em_id.toString())
  //         // {
  //         //   employeeSisaCuti.where((p0) =>p0['em_id']==)

  //         // }else{

  //         // }
  //       });

  //       print("status ${AppData.informasiUser![0].em_id.toString()} ${status}");
  //       if (status == false) {
  //         employeeSisaCuti.value = tempData;
  //       }
  //       this.employeeSisaCuti.refresh();
  //     }
  //   });
  // }

  void loadAllSisaCuti() {
    var emId = AppData.informasiUser![0].em_id;
    print("sisa PKWT`");
    var statusReminder = "";
    var emids = [];
    var status = false;
    for (var element in sysData.value) {
      if (element['kode'] == "015") {
        statusReminder = "${element['name']}";
      }
      if (element['kode'] == '016') {
        emids = element['name'].toString().split(',');
      }
    }

    print("data ${emids.toString()}");
    Map<String, dynamic> body = {
      'reminder': statusReminder,
      "em_id": emId.toString()
    };
    var connect = Api.connectionApi("post", body, "info_sisa_kontrak");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        employeeSisaCuti.value = valueBody['data'];
        //  var tempData = [];
        // emids.forEach((element) {
        //   if (element.toString() ==
        //       AppData.informasiUser![0].em_id.toString()) {
        //     status = true;
        //     tempData.add(element);
        //   }

        //   // status
        //   // if (element.toString()==AppData.informasiUser![0].em_id.toString())
        //   // {
        //   //   employeeSisaCuti.where((p0) =>p0['em_id']==)

        //   // }else{

        //   // }
        // });

        print("status ${AppData.informasiUser![0].em_id.toString()} ${status}");
        // if (status == false) {
        //   employeeSisaCuti.value = tempData;
        // }
        this.employeeSisaCuti.refresh();
      }
    });
  }

  showDataPilihAtasan(dataEmployee) {
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 18.0, 16.0, 18.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Konfirmasi via Whatsapp",
                        style: GoogleFonts.inter(
                            color: Constanst.fgPrimary,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      ),
                      InkWell(
                          customBorder: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          onTap: () => Navigator.pop(Get.context!),
                          child: Icon(
                            Icons.close,
                            size: 24.0,
                            color: Constanst.fgSecondary,
                          ))
                    ],
                  ),
                ),
                Divider(
                  height: 0,
                  thickness: 1,
                  color: Constanst.fgBorder,
                ),
                const SizedBox(height: 44),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Constanst.colorNeutralBgSecondary,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16.0),
                          topLeft: Radius.circular(16.0),
                        ),
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16.0),
                            ),
                            child: SvgPicture.asset(
                              'assets/character1.svg',
                              width: 120,
                              height: 110,
                            ),
                          ),
                          const SizedBox(height: 19),
                        ],
                      ),
                    ),
                    Container(
                        color: Constanst.colorNeutralBgSecondary,
                        child: const SizedBox(width: 33, height: 129)),
                    Container(
                      decoration: BoxDecoration(
                        color: Constanst.colorNeutralBgSecondary,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(16.0),
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 25),
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(16.0),
                            ),
                            child: SvgPicture.asset(
                              'assets/character2.svg',
                              width: 127,
                              height: 104,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  "Beri tahu Atasanmu tentang pengajuan yang telah\nKamu buat melalui Whatsapp",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      color: Constanst.fgPrimary,
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                ),
                const SizedBox(height: 28),
                ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    itemCount: konfirmasiAtasan.value.length,
                    itemBuilder: (context, index) {
                      var full_name =
                          konfirmasiAtasan.value[index]['full_name'];
                      var job_title =
                          konfirmasiAtasan.value[index]['job_title'];
                      var gambar = konfirmasiAtasan.value[index]['em_image'];
                      var nohp = konfirmasiAtasan.value[index]['em_mobile'];
                      var jeniKelamin =
                          konfirmasiAtasan.value[index]['em_gender'];
                      return InkWell(
                        onTap: () {
                          kirimKonfirmasiWa(
                              dataEmployee, full_name, nohp, jeniKelamin);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 12, bottom: 12, left: 16, right: 16),
                          child: IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    gambar == ""
                                        ? SvgPicture.asset(
                                            'assets/avatar_default.svg',
                                            width: 40,
                                            height: 40,
                                          )
                                        : CircleAvatar(
                                            radius: 25, // Image radius
                                            child: ClipOval(
                                              child: ClipOval(
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      "${Api.UrlfotoProfile}$gambar",
                                                  progressIndicatorBuilder:
                                                      (context, url,
                                                              downloadProgress) =>
                                                          Container(
                                                    alignment: Alignment.center,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.5,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child:
                                                        CircularProgressIndicator(
                                                            value:
                                                                downloadProgress
                                                                    .progress),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Container(
                                                    color: Colors.white,
                                                    child: SvgPicture.asset(
                                                      'assets/avatar_default.svg',
                                                      width: 40,
                                                      height: 40,
                                                    ),
                                                  ),
                                                  fit: BoxFit.cover,
                                                  width: 40,
                                                  height: 40,
                                                ),
                                              ),
                                            ),
                                          ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "$full_name",
                                            style: GoogleFonts.inter(
                                                color: Constanst.fgPrimary,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "$job_title",
                                            style: GoogleFonts.inter(
                                                color: Constanst.fgSecondary,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Center(
                                  child: Image.asset(
                                    'assets/whatsapp.png',
                                    width: 25,
                                    height: 25,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ],
            ),
          );
        });
  }

  void kirimKonfirmasiWa(
      dataEmployee, namaAtasan, nomorAtasan, jeniKelamin) async {
    print('jenis kelamin $jeniKelamin');
    print('nomor atasan $nomorAtasan');
    if (nomorAtasan == "" || nomorAtasan == null || nomorAtasan == "null") {
      UtilsAlert.showToast("Nomor wa atasan tidak valid");
    } else {
      var dataUser = AppData.informasiUser;
      var getEmid = dataUser![0].em_id;
      var getFullName = dataUser[0].full_name;
      var pesan;
      if (jeniKelamin == "PRIA") {
        pesan =
            "Hallo pak ${namaAtasan}, saya ${getFullName} mengajukan ${dataEmployee['nameType']} dengan nomor ajuan ${dataEmployee['nomor_ajuan']}";
      } else {
        pesan =
            "Hallo bu ${namaAtasan}, saya ${getFullName} mengajukan ${dataEmployee['nameType']} dengan nomor ajuan ${dataEmployee['nomor_ajuan']}";
      }
      var gabunganPesan = pesan;
      var notujuan = nomorAtasan;
      var filternohp = notujuan.substring(1);
      var kodeNegara = 62;
      var gabungNohp = "$kodeNegara$filternohp";

      var whatsappURl_android =
          "whatsapp://send?phone=$gabungNohp&text=${Uri.parse(gabunganPesan)}";
      var whatappURL_ios =
          "https://wa.me/$gabungNohp?text=${Uri.parse(gabunganPesan)}";

      if (Platform.isIOS) {
        // for iOS phone only
        final url = Uri.parse(whatappURL_ios);
        if (!await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        )) {
          UtilsAlert.showToast('Terjadi kesalahan $whatappURL_ios');
        }
      } else {
        // android , web
        final url = Uri.parse(whatsappURl_android);
        if (!await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        )) {
          UtilsAlert.showToast('Terjadi kesalahan $whatsappURl_android');
        }
      }
    }
  }

  void kirimUcapanWa(message, nomorUltah) async {
    if (nomorUltah == "" || nomorUltah == null || nomorUltah == "null") {
      UtilsAlert.showToast("Nomor WA tidak tersedia");
    } else {
      var dataUser = AppData.informasiUser;
      var getEmid = dataUser![0].em_id;
      var getFullName = dataUser[0].full_name;
      var gabunganPesan = message;
      var notujuan = nomorUltah;
      var filternohp = notujuan.substring(1);
      var kodeNegara = 62;
      var gabungNohp = "$kodeNegara$filternohp";

      var whatsappURl_android =
          "whatsapp://send?phone=" + gabungNohp + "&text=" + gabunganPesan;
      var whatappURL_ios =
          "https://wa.me/$gabungNohp?text=${Uri.parse(gabunganPesan)}";

      if (Platform.isIOS) {
        // for iOS phone only
        await launchUrl(Uri.parse(whatappURL_ios));
      } else {
        await launchUrl(Uri.parse(whatsappURl_android));
        // android , web
        /*  if (await launchUrl(whatsappURl_android)) {
          await launch(whatsappURl_android);
        } else {
          UtilsAlert.showToast("Whatsapp tidak terinstall");
        } */
      }
    }
  }

  void kirimNotifikasiFcm({title, message, tokens, bulan, tahun}) {
    // print()
    Map<String, dynamic> body = {
      'title': title,
      'message': message,
      'token_notif': tokens.toString(),
    };
    try {
      var connect = Api.connectionApi("post", body, "push_notification");
      connect.then((dynamic res) {
        if (res.statusCode == 200) {
          // print()
          var valueBody = jsonDecode(res.body);
          print("response notif ${valueBody.toString()}");
        }
      });
    } catch (e) {
      print("errpr ${e}");
    }
  }

  void kirimNotifikasi(
      {title,
      status,
      pola,
      statusApproval,
      emId,
      nomor,
      emIdApproval1,
      emIdApproval2}) {
    // print()
    Map<String, dynamic> body = {
      'title': title,
      'status': status,
      'pola': pola,
      'status_approval': statusApproval,
      'em_id': emId,
      'nomor': nomor,
      'nama_user': AppData.informasiUser![0].full_name,
      'em_id_user': AppData.informasiUser![0].em_id,
      'em_id_approval1': emIdApproval1,
      'em_id_approval2': emIdApproval2
    };
    print(body);
    try {
      var connect =
          Api.connectionApi("post", body, "push_notification_approval");
      connect.then((dynamic res) {
        if (res.statusCode == 200) {
          // print()
          var valueBody = jsonDecode(res.body);
          print("response notif ${valueBody.toString()}");
        }
      });
    } catch (e) {
      print("errpr ${e}");
    }
  }
}
