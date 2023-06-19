import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_operasional/components/text_field.dart';
import 'package:siscom_operasional/controller/lupa_password.dart';
import 'package:siscom_operasional/screen/lupa_password/list.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';

class BuatPasswordbaru extends StatefulWidget {
  const BuatPasswordbaru({super.key});

  @override
  State<BuatPasswordbaru> createState() => _BuatPasswordbaruState();
}

class _BuatPasswordbaruState extends State<BuatPasswordbaru> {
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
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 16,
            ),
            TextLabell(
              text: "Buat Password Baru",
              weight: FontWeight.w600,
              size: 18,
            ),
            SizedBox(
              height: 4,
            ),
            TextLabell(text: "Buat Password baru"),
            SizedBox(height: 24,),
            Obx(
              () => TextFieldApp.groupColumnPassword(
                  title: "Buat Password",
                  icon: Iconsax.lock,
                  hintText: "Masukan password",
                  controller: controller.password.value,
                  visble: !controller.showpassword.value,
                  onTap: () {
                    this.controller.showpassword.value =
                        !this.controller.showpassword.value;
                  }),
            ),
            SizedBox(height: 8,),
             Obx(
              () => TextFieldApp.groupColumnPassword(
                  title: "Konfirmasi Password",
                  icon: Iconsax.lock,
                  hintText: "Masukan password",
                  controller: controller.password1.value,
                  visble: !controller.showpassword1.value,
                  onTap: () {
                    this.controller.showpassword1.value =
                        !this.controller.showpassword1.value;
                  }),
            ),
            Expanded(
              child: Container(
                height: double.maxFinite,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    onTap: (){
                   
                      if (controller.password1.value.text==controller.password.value.text){
                        controller.changeNewPassword();

                      }else{
                        UtilsAlert.showToast("Password tidak sesuai");
                        
                      }
                    },
                    child: Container(
                      
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Constanst.colorPrimary),
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: TextLabell(
                        text: "Login",
                        color: Colors.white,
                        align: TextAlign.center,
                        size: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}
