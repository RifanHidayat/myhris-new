import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_operasional/components/text.dart';
import 'package:siscom_operasional/components/text_field.dart';
import 'package:siscom_operasional/controller/lupa_password.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';

class LupaPassword extends StatefulWidget {
  const LupaPassword({super.key});

  @override
  State<LupaPassword> createState() => _LupaPasswordState();
}

class _LupaPasswordState extends State<LupaPassword> {
  var controller = Get.put(LupaPasswordController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Image.asset(
                "assets/logo_login.png",
                width: 68,
                height: 31,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height - 70,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    TextLabell(
                      text: "Lupa kata Sandi?",
                      size: 26,
                      weight: FontWeight.w600,
                    ),
                    SizedBox(height: 8),
                    TextLabell(
                      text:
                          "Jangan Khawatir, silakan ikuti langkah-langkah berikut untuk mengembalikan password Anda kembali.",
                      size: 14,
                    ),
                    SizedBox(height: 8),
                    TextLabell(
                      text: "Pilih salah satu untuk mengirim kode OTP.",
                      size: 14,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 38),
              Obx(() => Row(
                    children: List.generate(controller.menus.length, (index) {
                      var data = controller.menus[index];
                      return Expanded(
                        flex: 50,
                        child: data['is_active'] == 0
                            ? InkWell(
                                onTap: () {
                                  controller.menus.forEach((element) {
                                    element['is_active'] = 0;
                                  });
                                  data['is_active'] = 1;
                                  controller.menus.refresh();
                                },
                                child: Column(
                                  children: [
                                    TextLabell(
                                      text: "${data['name']}",
                                      size: 14,
                                    ),
                                    const SizedBox(height: 12),
                                    data['is_active'] == 1
                                        ? Align(
                                            alignment: Alignment.center,
                                            child: Container(
                                              width: 59,
                                              height: 3,
                                              decoration: BoxDecoration(
                                                  color: Constanst.colorPrimary,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  8),
                                                          topRight:
                                                              Radius.circular(
                                                                  8))),
                                            ),
                                          )
                                        : Container(height: 3),
                                    Divider(
                                      thickness: 2,
                                      height: 2,
                                      color: Constanst.border,
                                    )
                                  ],
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  controller.menus.forEach((element) {
                                    element['is_active'] = 0;
                                  });
                                  data['is_active'] = 1;
                                  controller.menus.refresh();
                                },
                                child: Column(
                                  children: [
                                    TextLabell(
                                      text: "${data['name']}",
                                      size: 14,
                                    ),
                                    const SizedBox(height: 12),
                                    data['is_active'] == 1
                                        ? Align(
                                            alignment: Alignment.center,
                                            child: Container(
                                              width: 59,
                                              height: 3,
                                              decoration: BoxDecoration(
                                                  color: Constanst.colorPrimary,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  8),
                                                          topRight:
                                                              Radius.circular(
                                                                  8))),
                                            ),
                                          )
                                        : Container(height: 3),
                                    Divider(
                                      thickness: 2,
                                      height: 2,
                                      color: Constanst.border,
                                    )
                                  ],
                                ),
                              ),
                      );
                    }),
                  )),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Obx(() => controller.menus
                        .where((p0) =>
                            p0['is_active'] == 1 && p0['name'] == "Email")
                        .toList()
                        .isNotEmpty
                    ? Column(
                        children: [
                          Container(
                            child: TextFieldApp.groupColumn(
                                onChange: (value) {
                                  controller.perusahaan.text = "";
                                },
                                title: "Email",
                                icon: Iconsax.sms,
                                controller: controller.email.value,
                                hintText: "Masukan Email"),
                          ),
                          TextFieldApp.groupColumnSelected(
                              title: "Pilih Perusahaan",
                              icon: Iconsax.arrow_down_1,
                              hintText: "PT. Shan Informasi Sistem",
                              enabled: false,
                              controller: controller.perusahaan,
                              onTap: () {
                                if (controller.email.value.text != "") {
                                  if (controller.tempEmail.value.text ==
                                      controller.email.value.text) {
                                    if (controller.databases.isNotEmpty) {
                                      controller.dataabse().then((value) {
                                        if (value == true) {
                                          showModalBottomSheet(
                                            backgroundColor: Colors.transparent,
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (context) {
                                              return FractionallySizedBox(
                                                  heightFactor: 0.6,
                                                  child: _bottomSheetBpjsDetail(
                                                      context));
                                            },
                                          );
                                        } else {
                                          UtilsAlert.showToast(
                                              "Database tidak tersedia");
                                        }
                                      });
                                      // showModalBottomSheet(
                                      //   backgroundColor: Colors.transparent,
                                      //   isScrollControlled: true,
                                      //   context: context,
                                      //   builder: (context) {
                                      //     return FractionallySizedBox(
                                      //         heightFactor: 0.6,
                                      //         child: _bottomSheetBpjsDetail(
                                      //             context));
                                      //   },
                                      // );
                                      // showModalBottomSheet(
                                      //   backgroundColor: Colors.transparent,
                                      //   isScrollControlled: true,
                                      //   context: context,
                                      //   builder: (context) {
                                      //     return FractionallySizedBox(
                                      //         heightFactor: 0.6,
                                      //         child: _bottomSheetBpjsDetail(
                                      //             context));
                                      //   },
                                      // );
                                    } else {
                                      UtilsAlert.showToast(
                                          "Database tidak tersedia");
                                    }
                                  } else {
                                    controller.dataabse().then((value) {
                                      if (value == true) {
                                        showModalBottomSheet(
                                          backgroundColor: Colors.transparent,
                                          isScrollControlled: true,
                                          context: context,
                                          builder: (context) {
                                            return FractionallySizedBox(
                                                heightFactor: 0.6,
                                                child: _bottomSheetBpjsDetail(
                                                    context));
                                          },
                                        );
                                      } else {
                                        UtilsAlert.showToast(
                                            "Database tidak tersedia");
                                      }
                                    });
                                  }
                                } else {
                                  UtilsAlert.showToast(
                                      "isi terlebi dahulu email mu");
                                }
                              }),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: TextFieldApp.groupColumn(
                                onChange: (value) {
                                  controller.perusahaan.text = "";
                                },
                                title: "Email",
                                icon: Iconsax.sms,
                                controller: controller.email.value,
                                hintText: "Masukan Email"),
                          ),
                          TextFieldApp.groupColumnSelected(
                              title: "Pilih Perusahaan",
                              icon: Iconsax.arrow_down_1,
                              hintText: "PT. Shan Informasi Sistem",
                              enabled: false,
                              controller: controller.perusahaan,
                              onTap: () {
                                if (controller.email.value.text != "") {
                                  if (controller.tempEmail.value.text ==
                                      controller.email.value.text) {
                                    if (controller.databases.isNotEmpty) {
                                      controller.dataabse().then((value) {
                                        if (value == true) {
                                          showModalBottomSheet(
                                            backgroundColor: Colors.transparent,
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (context) {
                                              return FractionallySizedBox(
                                                  heightFactor: 0.6,
                                                  child: _bottomSheetBpjsDetail(
                                                      context));
                                            },
                                          );
                                        } else {
                                          UtilsAlert.showToast(
                                              "Database tidak tersedia");
                                        }
                                      });
                                      // showModalBottomSheet(
                                      //   backgroundColor: Colors.transparent,
                                      //   isScrollControlled: true,
                                      //   context: context,
                                      //   builder: (context) {
                                      //     return FractionallySizedBox(
                                      //         heightFactor: 0.6,
                                      //         child: _bottomSheetBpjsDetail(
                                      //             context));
                                      //   },
                                      // );
                                      // showModalBottomSheet(
                                      //   backgroundColor: Colors.transparent,
                                      //   isScrollControlled: true,
                                      //   context: context,
                                      //   builder: (context) {
                                      //     return FractionallySizedBox(
                                      //         heightFactor: 0.6,
                                      //         child: _bottomSheetBpjsDetail(
                                      //             context));
                                      //   },
                                      // );
                                    } else {
                                      UtilsAlert.showToast(
                                          "Database tidak tersedia");
                                    }
                                  } else {
                                    controller.dataabse().then((value) {
                                      if (value == true) {
                                        showModalBottomSheet(
                                          backgroundColor: Colors.transparent,
                                          isScrollControlled: true,
                                          context: context,
                                          builder: (context) {
                                            return FractionallySizedBox(
                                                heightFactor: 0.6,
                                                child: _bottomSheetBpjsDetail(
                                                    context));
                                          },
                                        );
                                      } else {
                                        UtilsAlert.showToast(
                                            "Database tidak tersedia");
                                      }
                                    });
                                  }
                                } else {
                                  UtilsAlert.showToast(
                                      "isi terlebi dahulu email mu");
                                }
                              }),
                          TextFieldApp.groupColumn(
                              title: "Nomor HP",
                              icon: Iconsax.mobile,
                              controller: controller.mobileCtr.value,
                              keyBoardType: TextInputType.number,
                              hintText: "Masukan Nomor Hp",
                              subtitle: "* Kode akan dikirim via whatsapp"),
                        ],
                      )),
              ),
              Expanded(
                child: SizedBox(
                  height: double.maxFinite,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Obx(
                          () => controller.menus
                                  .where((p0) =>
                                      p0['is_active'] == 1 &&
                                      p0['name'] == "Email")
                                  .toList()
                                  .isNotEmpty
                              ? SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      print(controller.email.value);
                                      if (controller.email.value.text == "" ||
                                          controller.perusahaan.value.text ==
                                              "") {
                                        UtilsAlert.showToast(
                                            "Lengkapi formmu terlebih dahulu");
                                      } else {
                                        controller.sendEmail();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Constanst.colorPrimary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 12, 20, 12)),
                                    child: Text(
                                      "Kirim Kode",
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      print(controller.email.value);
                                      if (controller.email.value.text == "" ||
                                          controller.perusahaan.value.text ==
                                              "") {
                                        UtilsAlert.showToast(
                                            "Lengkapi formmu terlebih dahulu");
                                      } else {
                                        controller.sendEmail();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Constanst.colorPrimary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 12, 20, 12)),
                                    child: Text(
                                      "Kirim Kode",
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 40,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Constanst.colorPrimary,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Get.back();
                            },
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Constanst.colorPrimary,
                                backgroundColor: Constanst.colorWhite,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                                // padding: EdgeInsets.zero,
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0)),
                            icon: Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Icon(
                                Iconsax.arrow_left,
                                color: Constanst.colorPrimary,
                              ),
                            ),
                            label: Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: TextLabell(
                                text: "Kembali ke Login",
                                color: Constanst.colorPrimary,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomSheetBpjsDetail(context) {
    return DraggableScrollableSheet(
        initialChildSize: 1,
        maxChildSize: 1,
        minChildSize: 1,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextApp.label(
                          text: "Pilih Perusahaan",
                          weigh: FontWeight.bold,
                          size: 14.0),
                      InkWell(onTap: () => Get.back(), child: Icon(Icons.close))
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  Expanded(
                    child: Container(
                      height: double.maxFinite,
                      child: SingleChildScrollView(
                        child: Obx(() => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                  controller.databases.length, (index) {
                                var data = controller.databases[index];
                                return InkWell(
                                  onTap: () {
                                    AppData.selectedDatabase = data.dbname;
                                    print("tes");
                                    controller.databases.forEach((element) {
                                      element.isSelected = false;
                                    });
                                    data.isSelected = true;
                                    controller.databases.refresh();
                                    controller.selectedPerusahaan.value =
                                        data.name;
                                    controller.selectedDb.value = data.dbname;
                                    controller.perusahaan.text = data.name;

                                    ;
                                    Get.back();
                                  },
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                                flex: 80,
                                                child: Container(
                                                  child: TextApp.label(
                                                      text:
                                                          data.name.toString(),
                                                      size: 14.0,
                                                      color: Constanst
                                                          .blackSurface),
                                                )),
                                            Expanded(
                                              flex: 20,
                                              child: data.isSelected
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Container(
                                                          width: 20,
                                                          height: 20,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              border: Border.all(
                                                                  width: 2,
                                                                  color: Constanst
                                                                      .colorPrimary)),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    3),
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                color: Constanst
                                                                    .colorPrimary,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Container(
                                                          width: 20,
                                                          height: 20,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              border: Border.all(
                                                                  width: 2,
                                                                  color: Constanst
                                                                      .blackSurface)),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    3),
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                color: Constanst
                                                                    .grey,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Divider()
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            )),
                      ),
                    ),
                  ),

                  // Padding(
                  //   padding: EdgeInsets.only(top: 10, bottom: 10),
                  //   child: ButtonApp(
                  //     title: "Bayar",
                  //     ontap: () {
                  //       Get.back();
                  //       Get.toNamed(AppPages.PINVALIDATION,
                  //           arguments: "pascabayar");
                  //       return;
                  //     },
                  //   ),
                  // )
                ],
              ),
            ),
          );
        });
  }
}
