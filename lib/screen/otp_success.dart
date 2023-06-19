import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:siscom_operasional/screen/buat_password_baru.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';

class OtpSuccessPage extends StatefulWidget {
  const OtpSuccessPage({super.key});

  @override
  State<OtpSuccessPage> createState() => _OtpSuccessPageState();
}

class _OtpSuccessPageState extends State<OtpSuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left:16,right: 16),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned(
                child: Align(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/art.png"),
                  SizedBox(
                    height: 16,
                  ),
                  TextLabell(
                    text: "Verifikasi berhasil",
                    size: 16,
                    weight: FontWeight.bold,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 24, right: 24),
                      child: TextLabell(
                        text:
                            "Silakan buat kata sandi yang baru untuk melanjutkan.",
                        size: 14,
                        weight: FontWeight.w400,
                        align: TextAlign.center,
                      )),
                ],
              ),
            )),
            Positioned(
              bottom: 20,
                child: InkWell(
              onTap: () {
                Get.off(BuatPasswordbaru());
              },
              child: Container(
                
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Constanst.colorPrimary),
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: TextLabell(
                  text: "Buat Password",
                  color: Colors.white,
                  align: TextAlign.center,
                  size: 14,
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
