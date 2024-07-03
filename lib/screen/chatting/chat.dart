import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';

import '../../utils/api.dart';

class ChattingPage extends StatefulWidget {
  var image, fullName, title;
  ChattingPage({super.key, this.image, this.fullName, this.title});

  @override
  State<ChattingPage> createState() => _ChattingPageState();


}

var messages=[
  {
    "message":"Hello",
    "images":"",
    "tanggal":"03/07/2024",
    "Waktu":"03:01:01",
    "is_read":"1",
    "em_id_sender":"SIS20220040",
    "terkirim":""

  },
  {
    "message":"Hello",
    "images":"",
    "tanggal":"03/07/2024",
    "Waktu":"03:01:01",
    "is_read":"1",
    "em_id_sender":"SIS20220039",
    "terkirim":""

  }
];

class _ChattingPageState extends State<ChattingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
   
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        
        child: Container(
       
          child: Column(
            children: [_appBar(),
            Expanded(
              child: Container(
                height: double.maxFinite,
                child: bodyChat(),
              ),
            ),
            _bottomNavigationBar()
            ],
          ),
        ),
      ),
    );
  }



Widget bodyChat(){
  return Container(
    padding: EdgeInsets.all(12 ),
    child: Column(
      children: List.generate(messages.length, (index) {
        var data=messages[index];
        return Container(
          padding: EdgeInsets.only(bottom: 4),
          width: MediaQuery.of(context).size.width,
          child: AppData.informasiUser![0].em_id.toString()==data['em_id_sender']? Align(
            alignment: Alignment.centerRight,
            child: Container(
              child: TextLabell(text: ""+data['message'].toString(),),
            ),
          ): Align(
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: Colors.amber),
              padding: EdgeInsets.all(8),
              child: TextLabell(text: data['message'].toString(),),
            ),
          ),
        );
      }),
    ),
  );
}



Widget _bottomNavigationBar(){
  return Container(
    padding: EdgeInsets.only(left: 12,right: 12),
        child: Row(
          children: [
            Expanded(
              flex: 90,
              child: TextField(
                decoration: InputDecoration(
                 border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
                  
                  hintText: 'Message....',
                ),
                
              ),
            ),
            Expanded(
              flex: 10,
              child: Icon(Iconsax.send_1,color: Colors.amber,))
          ],
        ),
      );
}
  Widget _appBar() {
    return Material(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.only(top: 38, left: 12, bottom: 12, right: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
                onTap: () {
                  Get.back();
                },
                child: Icon(Iconsax.arrow_left, size: 24, weight: 40)),
            SizedBox(
              width: 4,
            ),
            widget.image == ""
                ? Expanded(
                    flex: 15,
                    child: SvgPicture.asset(
                      'assets/avatar_default.svg',
                      width: 50,
                      height: 50,
                    ),
                  )
                : CircleAvatar(
                    radius: 25,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: "${Api.UrlfotoProfile}${widget.image}",
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: MediaQuery.of(context).size.width,
                          child: CircularProgressIndicator(
                              value: downloadProgress.progress),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.white,
                          child: SvgPicture.asset(
                            'assets/avatar_default.svg',
                            width: 50,
                            height: 50,
                          ),
                        ),
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      ),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.fullName}",
                    style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Constanst.fgPrimary,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${widget.title}",
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Constanst.fgSecondary,
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
