import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:siscom_operasional/screen/otp_success.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';
import 'package:get/get.dart';
import 'package:siscom_operasional/controller/lupa_password.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';

class KodeVerifikasiPage extends StatefulWidget {
  const KodeVerifikasiPage({super.key});

  @override
  State<KodeVerifikasiPage> createState() => _KodeVerifikasiPageState();
}

class _KodeVerifikasiPageState extends State<KodeVerifikasiPage> {
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
      body: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(left: 12, right: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextLabell(
                text: "Konfirmasi Kode OTP?",
                size: 20,
                weight: FontWeight.bold,
              ),
              SizedBox(
                height: 8,
              ),
              TextLabell(
                text:
                    "masukan kode OTP yang berhasil dikirim ke email ${controller.email.value.text}.",
                size: 13,
                weight: FontWeight.w500,
              ),
              SizedBox(
                height: 24,
              ),
              OtpTextField(
                numberOfFields: 4,
                borderColor: Color(0xFF512DA8),
                //set to true to show as box or false to show as dash
                showFieldAsBox: true,
                //runs when a code is typed in
                onCodeChanged: (String code) {
                  controller.tempVerifikasiKode.value=code.toString();

                  //handle validation or checks here
                },
                //runs when every textfield is filled
                onSubmit: (String verificationCode) {
                    controller.tempVerifikasiKode.value=verificationCode.toString();
                
                }, // end onSubmit
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(
                      () => TextLabell(
                        text: controller.time.value,
                        size: 13,
                        weight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    TextLabell(
                      text: "Tidak menerima kode?",
                      size: 13,
                      weight: FontWeight.w400,
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    InkWell(
                        onTap: () {},
                        child: Obx(() => controller.time.value == "00:01"
                            ? InkWell(
                              onTap: (){
                              controller.sendEmailRepeat();
                              },
                              child: TextLabell(
                                  text: "Kirim Ulang",
                                  size: 13,
                                  color: Constanst.colorPrimary,
                                  weight: FontWeight.w400,
                                ),
                            )
                            : TextLabell(
                                text: "Kirim Ulang",
                                size: 13,
                                weight: FontWeight.w400,
                                color: HexColor('#A9B9CC'),
                              ))),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  height: double.maxFinite,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: (){
                        if (controller.time.value=="00:01" || controller.time.value=="00:00"){
                          return UtilsAlert.showToast(
                                      "Waktu telah hbis silahkan kirim ulang kode otp");


                        }else{
                                print(AppData.kodeVerifikasi);
                         print(controller.tempVerifikasiKode.value.toString());
                          UtilsAlert.showLoadingIndicator(context);
                                Future.delayed(
                                    const Duration(milliseconds: 500), () {
                              
                                  print(controller.password.value.toString());

                                  if (AppData.kodeVerifikasi.toString() ==
                                      controller.tempVerifikasiKode.value.toString()) {
                                         Get.back();
                                   
                                  Get.to(OtpSuccessPage());
                                  return;
                                  }
                                  Get.back();
                                  return UtilsAlert.showToast(
                                      "Kode OTP salah");
                                });

                        }
                  
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Constanst.colorPrimary),
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: TextLabell(
                          text: "Konfirmasi",
                          color: Colors.white,
                          align: TextAlign.center,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              )
            ],
          )),
    );
  }
}
