// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_operasional/screen/init_screen.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart' as dom;

class DetailInformasi extends StatelessWidget {
  final title;
  final create;
  final desc;
  DetailInformasi({this.title, this.create, this.desc});
  // final controller = Get.put(DashboardController());
  // var controllerGlobal = Get.put(GlobalController());

  String parseHtmlString(String htmlString) {
    dom.Document document = htmlParser.parse(htmlString);
    String parsedString = parseNode(document.body!);
    return parsedString;
  }

  String parseNode(dom.Node node) {
    if (node.nodeType == dom.Node.TEXT_NODE) {
      return node.text!;
    } else if (node.nodeType == dom.Node.ELEMENT_NODE) {
      dom.Element element = node as dom.Element;
      StringBuffer buffer = StringBuffer();
      for (var child in element.nodes) {
        buffer.write(parseNode(child));
      }
      return buffer.toString();
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constanst.coloBackgroundScreen,
      appBar: AppBar(
        backgroundColor: Constanst.colorWhite,
        elevation: 0,
        leadingWidth: 50,
        titleSpacing: 0,
        centerTitle: false,
        // title: Text(
        //   "Informasi",
        //   style: GoogleFonts.inter(
        //       color: Constanst.fgPrimary,
        //       fontWeight: FontWeight.w500,
        //       fontSize: 20),
        // ),
        leading: IconButton(
          icon: Icon(
            Iconsax.arrow_left,
            color: Constanst.fgPrimary,
            size: 24,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Constanst.fgPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  Constanst.convertDate(create),
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Constanst.fgSecondary),
                ),
                const SizedBox(height: 14),
                Text(
                  parseHtmlString(desc.toString()),
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Constanst.fgSecondary,
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
