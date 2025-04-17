import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_operasional/controller/absen_controller.dart';
import 'package:siscom_operasional/controller/auth_controller.dart';
import 'package:siscom_operasional/controller/dashboard_controller.dart';
import 'package:siscom_operasional/controller/pesan_controller.dart';
import 'package:siscom_operasional/controller/slip_gaji.controller.dart';
import 'package:siscom_operasional/utils/appbar_widget.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';
import 'package:get/get.dart';

class VerifyPasswordPayroll extends StatefulWidget {
  var page, titlepage;
  VerifyPasswordPayroll(
      {super.key, required this.page, required this.titlepage});

  @override
  State<VerifyPasswordPayroll> createState() => _VerifyPasswordPayrollState();
}

class _VerifyPasswordPayrollState extends State<VerifyPasswordPayroll> {
  final controller = Get.put(AuthController());
  var slipgajiController = Get.put(SlipGajiController());
  final TextEditingController passwordCtr = TextEditingController();

  var dashboarController = Get.find<DashboardController>();

  var absensiController = Get.find<AbsenController>(tag: 'absen controller');

  @override
  void initState() {
    slipgajiController.checkSlipGajiApproval();
    // TODO: implement initState
    super.initState();
    print(widget.titlepage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Constanst.colorWhite,
          automaticallyImplyLeading: false,
          elevation: 0,
          flexibleSpace: AppbarMenu1(
            title: "",
            colorTitle: Colors.black,
            colorIcon: Colors.black,
            icon: 1,
            onTap: () {
              Get.back();
            },
          )),
      body: Obx(() => slipgajiController.isLoading == true
          ? Center(child: Container(child: CircularProgressIndicator()))
          : Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        "Konfirmasi Password",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15)),
                          border: Border.all(
                              width: 0.5,
                              color: Color.fromARGB(255, 211, 205, 205))),
                      child: Obx(
                        () => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            obscureText: !this.controller.showpassword.value,
                            controller: passwordCtr,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: const Icon(Iconsax.lock),
                                // ignore: unnecessary_this
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.showpassword.value
                                        ? Iconsax.eye
                                        : Iconsax.eye_slash,
                                    color: this.controller.showpassword.value
                                        ? Constanst.colorPrimary
                                        : Colors.grey,
                                  ),
                                  onPressed: () {
                                    this.controller.showpassword.value =
                                        !this.controller.showpassword.value;
                                  },
                                )),
                            style: TextStyle(
                                fontSize: 14.0,
                                height: 2.0,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    // Expanded(
                    //   child: Container(
                    //     height: double.maxFinite,
                    //     width: MediaQuery.of(context).size.width - 40,
                    //     child: Row(
                    //         crossAxisAlignment: CrossAxisAlignment.end,
                    //         mainAxisAlignment: MainAxisAlignment.end,
                    //         children: [
                    //           Expanded(
                    //               flex: 50,
                    //               child: InkWell(
                    //                 onTap: () {
                    //                   Get.back();
                    //                 },
                    //                 child: Container(
                    //                   height: 30,
                    //                   decoration: BoxDecoration(
                    //                     border: Border.all(
                    //                         width: 1, color: Colors.black),
                    //                     borderRadius: BorderRadius.circular(5),
                    //                   ),
                    //                   alignment: Alignment.center,
                    //                   child: Text("Batal"),
                    //                 ),
                    //               )),
                    //           SizedBox(
                    //             width: 10,
                    //           ),
                    //           Expanded(
                    //               flex: 50,
                    //               child: InkWell(
                    //                 onTap: () {
                    //                   UtilsAlert.showLoadingIndicator(context);
                    //                   Future.delayed(
                    //                       const Duration(milliseconds: 500),
                    //                       () {
                    //                     Get.back();
                    //                     print(controller.password.value
                    //                         .toString());

                    //                     if (passwordCtr.text.toString() ==
                    //                         controller.password.value.text) {
                    //                       // print("type ${widget.titlepage}");

                    //                       if (widget.titlepage == "slip_gaji") {
                    //                         //    Get.back();
                    //                         //  Get.to(widget.page);

                    //                         dashboarController
                    //                             .checkValidasipayroll(
                    //                                 type: widget.titlepage,
                    //                                 page: widget.page);

                    //                         return;
                    //                       }

                    //                       if (widget.titlepage == "pph21") {
                    //                         Get.back();
                    //                         Get.to(widget.page);

                    //                         // dashboarController.checkValidasipayroll(type: widget.titlepage,page: widget.page);

                    //                         return;
                    //                       }

                    //                       return;
                    //                     }
                    //                     return UtilsAlert.showToast(
                    //                         "Konfirmasi password gagal");
                    //                   });
                    //                 },
                    //                 child: Container(
                    //                   height: 30,
                    //                   decoration: BoxDecoration(
                    //                     color: Constanst.colorPrimary,
                    //                     border: Border.all(
                    //                       width: 1,
                    //                     ),
                    //                     borderRadius: BorderRadius.circular(5),
                    //                   ),
                    //                   alignment: Alignment.center,
                    //                   child: Text(
                    //                     "Selanjutnya",
                    //                     style: TextStyle(
                    //                         color: Constanst.colorWhite),
                    //                   ),
                    //                 ),
                    //               )),
                    //         ]),
                    //   ),
                    // ),
                    Container(
                        child: SizedBox(
                      height: 16,
                    )),

                    slipgajiController.messageApproval.value == "not_yet"
                        ? Expanded(
                            child: Container(
                              height: double.maxFinite,
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: HexColor('#E9F5FE')),
                                    padding: EdgeInsets.only(
                                        top: 8, bottom: 8, left: 8, right: 8),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 10,
                                          child: Icon(
                                            Iconsax.info_circle,
                                            color: HexColor('#092371'),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 6,
                                        ),
                                        Expanded(
                                          flex: 90,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TextLabell(
                                                text: "Informasi!",
                                                weight: FontWeight.bold,
                                                size: 14.0,
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              TextLabell(
                                                  color: HexColor('#092371'),
                                                  text:
                                                      "Anda membutuhkan persetujuan Atasan untuk bisa melihat Slip Gaji. Setelah memasukan Password, permintaan untuk melihat Slip Gaji otomatis terkirim ke Atasan Anda.")
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: double.maxFinite,
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                print(widget.titlepage);
                                                 print(widget.page);
                                                if (passwordCtr.text
                                                        .toString() ==
                                                    controller
                                                        .password.value.text) {
                                                  dashboarController
                                                      .checkValidasipayroll(
                                                          type:
                                                              widget.titlepage,
                                                          page: widget.page)
                                                      .then((value) {
                                                    if (value == true) {
                                                      var pesanController =
                                                          Get.find<
                                                              PesanController>();
                                                      pesanController
                                                          .loadApproveInfo();
                                                      pesanController
                                                          .loadApproveHistory();
                                                    
                                                    }
                                                  });
                                                } else {
                                                  return UtilsAlert.showToast(
                                                      "Konfirmasi password gagal");
                                                }
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    color:
                                                        Constanst.colorPrimary),
                                                padding: EdgeInsets.only(
                                                    top: 8, bottom: 8),
                                                child: Center(
                                                    child: TextLabell(
                                                  text: "Kirim Permintaan",
                                                  color: Colors.white,
                                                  size: 16,
                                                )),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        : slipgajiController.messageApproval.value == "pending"
                            ? Expanded(
                                child: Container(
                                  height: double.maxFinite,
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: HexColor('#FEF9E6')),
                                        padding: EdgeInsets.only(
                                            top: 8,
                                            bottom: 8,
                                            left: 8,
                                            right: 8),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 10,
                                              child: Icon(
                                                Iconsax.info_circle,
                                                color: HexColor('#F2AA0D'),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 6,
                                            ),
                                            Expanded(
                                              flex: 90,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  TextLabell(
                                                    text:
                                                        "Menunggu persetujuan!",
                                                    weight: FontWeight.bold,
                                                    size: 14.0,
                                                  ),
                                                  SizedBox(
                                                    height: 4,
                                                  ),
                                                  TextLabell(
                                                      color:
                                                          HexColor('#092371'),
                                                      text:
                                                          "Silakan hubungi Atasan Anda untuk menyetujui.")
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          width: double.maxFinite,
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      color:
                                                          HexColor('#A9B9CC')),
                                                  padding: EdgeInsets.only(
                                                      top: 8, bottom: 8),
                                                  child: Center(
                                                      child: TextLabell(
                                                    text: "Lihat Slip gaji",
                                                    color: Colors.white,
                                                    size: 16,
                                                  )),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : slipgajiController.messageApproval.value ==
                                    "approved"
                                ? Expanded(
                                    child: Container(
                                      height: double.maxFinite,
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: HexColor('#E6FCE6')),
                                            padding: EdgeInsets.only(
                                                top: 8,
                                                bottom: 8,
                                                left: 8,
                                                right: 8),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 5,
                                                  child: Icon(
                                                    Iconsax.tick_circle5,
                                                    color: HexColor('#14B156'),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 22,
                                                ),
                                                Expanded(
                                                  flex: 90,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      TextLabell(
                                                        text: "Sudah disetujui!",
                                                        weight: FontWeight.bold,
                                                        size: 14.0,
                                                      ),
                                                      SizedBox(
                                                        height: 4,
                                                      ),
                                                      TextLabell(
                                                          color: HexColor(
                                                              '#092371'),
                                                          text:
                                                              "Anda bisa melihat Slip Gaji sekarang.")
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              width: double.maxFinite,
                                              child: Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                                    if (passwordCtr.text
                                                        .toString() ==
                                                    controller
                                                        .password.value.text) {
                                                  dashboarController
                                                      .checkValidasipayroll(
                                                          type:
                                                              widget.titlepage,
                                                          page: widget.page)
                                                      .then((value) {
                                                    if (value == true) {
                                                      var pesanController =
                                                          Get.find<
                                                              PesanController>();
                                                      pesanController
                                                          .loadApproveInfo();
                                                      pesanController
                                                          .loadApproveHistory();
                                                     
                                                    }
                                                  });
                                                } else {
                                                  return UtilsAlert.showToast(
                                                      "Konfirmasi password gagal");
                                                }
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            color: Constanst
                                                                .colorPrimary),
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 8,
                                                                bottom: 8),
                                                        child: Center(
                                                            child: TextLabell(
                                                          text:
                                                              "Lihat Slip gaji",
                                                          color: Colors.white,
                                                          size: 16,
                                                        )),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : Expanded(
                                    child: Container(
                                      height: double.maxFinite,
                                      child: Column(
                                        children: [
                                     
                                          Expanded(
                                            child: Container(
                                              width: double.maxFinite,
                                              child: Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                                    if (passwordCtr.text
                                                        .toString() ==
                                                    controller
                                                        .password.value.text) {
                                                  dashboarController
                                                      .checkValidasipayroll(
                                                          type:
                                                              widget.titlepage,
                                                          page: widget.page)
                                                      .then((value) {
                                                    if (value == true) {
                                                      var pesanController =
                                                          Get.find<
                                                              PesanController>();
                                                      pesanController
                                                          .loadApproveInfo();
                                                      pesanController
                                                          .loadApproveHistory();
                                                     
                                                    }
                                                  });
                                                } else {
                                                  return UtilsAlert.showToast(
                                                      "Konfirmasi password gagal");
                                                }
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            color: Constanst
                                                                .colorPrimary),
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 8,
                                                                bottom: 8),
                                                        child: Center(
                                                            child: TextLabell(
                                                          text:
                                                              "Lihat Slip gaji",
                                                          color: Colors.white,
                                                          size: 16,
                                                        )),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                  ],
                ),
              ),
            )),
    );
  }
}
