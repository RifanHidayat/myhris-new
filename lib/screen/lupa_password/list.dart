import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 16),
              child: Image.asset(
                "assets/logo_login.png",
                width: 60,
                height: 40,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height-70,
          child: Container(
            
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextLabell(
                        text: "Lupa kata Sandi?",
                        size: 20,
                        weight: FontWeight.bold,
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      TextLabell(
                        text:
                            "Jangan Khawatir, silakan ikuti langkah-langkah berikut untuk mengembalikan password Anda kembali.",
                        size: 13,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextLabell(
                        text: "Pilih salah satu untuk mengirim kode OTP.",
                        size: 13,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                // Obx(() => Row(
                //       children: List.generate(controller.menus.length, (index) {
                //         var data = controller.menus[index];
                //         return Expanded(
                //           flex: 50,
                //           child: data['is_active'] == 0
                //               ? InkWell(
                //                   onTap: () {
                //                     controller.menus.forEach((element) {
                //                       element['is_active'] = 0;
                //                     });
                //                     data['is_active'] = 1;
                //                     controller.menus.refresh();
                //                   },
                //                   child: Container(
                //                     child: Column(
                //                       children: [
                //                         TextLabell(
                //                           text: "${data['name']}",
                //                           size: 14,
                //                         ),
                //                         SizedBox(
                //                           height: 5,
                //                         ),
                //                         Container(
                //                           height: 5,
                //                           child: Stack(
                //                             children: [
                //                               data['is_active'] == 1
                //                                   ? Align(
                //                                       alignment: Alignment.center,
                //                                       child: Container(
                //                                         width: 50,
                //                                         height: 4,
                //                                         decoration: BoxDecoration(
                //                                             color: Constanst
                //                                                 .colorPrimary,
                //                                             borderRadius:
                //                                                 BorderRadius.only(
                //                                                     topLeft: Radius
                //                                                         .circular(
                //                                                             8),
                //                                                     topRight: Radius
                //                                                         .circular(
                //                                                             8))),
                //                                       ),
                //                                     )
                //                                   : Container(),
                //                               Divider(
                //                                 thickness: 2,
                //                                 color: Constanst.border,
                //                               )
                //                             ],
                //                           ),
                //                         )
                //                       ],
                //                     ),
                //                   ),
                //                 )
                //               : InkWell(
                //                   onTap: () {
                //                     controller.menus.forEach((element) {
                //                       element['is_active'] = 0;
                //                     });
                //                     data['is_active'] = 1;
                //                     controller.menus.refresh();
                //                   },
                //                   child: Container(
                //                     child: Column(
                //                       children: [
                //                         TextLabell(
                //                           text: "${data['name']}",
                //                           size: 14,
                //                         ),
                //                         SizedBox(
                //                           height: 5,
                //                         ),
                //                         Container(
                //                           height: 5,
                //                           child: Stack(
                //                             children: [
                //                               data['is_active'] == 1
                //                                   ? Align(
                //                                       alignment: Alignment.center,
                //                                       child: Container(
                //                                         width: 50,
                //                                         height: 4,
                //                                         decoration: BoxDecoration(
                //                                             color: Constanst
                //                                                 .colorPrimary,
                //                                             borderRadius:
                //                                                 BorderRadius.only(
                //                                                     topLeft: Radius
                //                                                         .circular(
                //                                                             8),
                //                                                     topRight: Radius
                //                                                         .circular(
                //                                                             8))),
                //                                       ),
                //                                     )
                //                                   : Container(),
                //                               Divider(
                //                                 thickness: 2,
                //                                 color: Constanst.border,
                //                               )
                //                             ],
                //                           ),
                //                         )
                //                       ],
                //                     ),
                //                   ),
                //                 ),
                //         );
                //       }),
                //     )),
                SizedBox(
                  height: 10,
                ),
                
                Container(
                 
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Obx(() => controller.menus
                              .where((p0) =>
                                  p0['is_active'] == 1 && p0['name'] == "Email")
                              .toList()
                              .isNotEmpty
                          ? Column(
                              children: [
                                Container(
                                  child: TextFieldApp.groupColumn(
                                    onChange: (value){
                                      controller.perusahaan.text ="";
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
                                      print("tes");
                                      if (controller.email.value.text != "") {
                                        if (controller.tempEmail.value.text ==
                                            controller.email.value.text) {
                                          if (controller.databases.isNotEmpty) {
                                            controller.dataabse().then((value) {
                                              if (value == true) {
                                                showModalBottomSheet(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  isScrollControlled: true,
                                                  context: context,
                                                  builder: (context) {
                                                    return FractionallySizedBox(
                                                        heightFactor: 0.6,
                                                        child:
                                                            _bottomSheetBpjsDetail(
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
                                                backgroundColor:
                                                    Colors.transparent,
                                                isScrollControlled: true,
                                                context: context,
                                                builder: (context) {
                                                  return FractionallySizedBox(
                                                      heightFactor: 0.6,
                                                      child:
                                                          _bottomSheetBpjsDetail(
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
                          : Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFieldApp.groupColumn(
                                      title: "Nomor HP",
                                      icon: Iconsax.mobile,
                                      hintText: "Masukan Nomor Hp",
                                      subtitle:
                                          "* Kode akan dikirim via whatsapp"),
                                ],
                              ),
                            )),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: double.maxFinite,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          controller.menus
                                  .where((p0) =>
                                      p0['is_active'] == 1 && p0['name'] == "Email")
                                  .toList()
                                  .isNotEmpty
                              ? InkWell(
                                onTap: (){
                                  print(controller.email.value);
                                  if (controller.email.value.text=="" || controller.perusahaan.value.text==""){
                                    UtilsAlert.showToast("Lengkapi formmu terlebih dahulu");

                                  }else{
                                      controller.sendEmail();

                                  }
                                    
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Constanst.colorPrimary,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    padding: EdgeInsets.only(top: 10, bottom: 10),
                                    child: Center(
                                        child: InkWell(
                                      onTap: () {
                                       
                                      },
                                      child: TextLabell(
                                        text: "Kirim Kode",
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    )),
                                  ),
                              )
                              : Container(
                                  decoration: BoxDecoration(
                                    color: Constanst.colorPrimary,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  child: Center(
                                      child: TextLabell(
                                    text: "Kirim Tautan",
                                    color: Colors.white,
                                    size: 16,
                                  )),
                                ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () => Get.back(),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Constanst.colorWhite,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      width: 1, color: Constanst.colorPrimary)),
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Center(
                                  child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Iconsax.arrow_left,
                                    color: Constanst.colorPrimary,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  TextLabell(
                                    text: "Kembali ke Login",
                                    color: Constanst.colorPrimary,
                                    size: 16,
                                  ),
                                ],
                              )),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
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
