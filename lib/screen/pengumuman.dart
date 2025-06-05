import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/pengumuman_controller.dart';
import 'package:siscom_operasional/screen/detail_informasi.dart';
import 'package:siscom_operasional/screen/detail_polling.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class PengumumanScreen extends StatefulWidget {
  const PengumumanScreen({super.key});

  @override
  State<PengumumanScreen> createState() => _PengumumanScreenState();
}

class _PengumumanScreenState extends State<PengumumanScreen> {
  var controller = Get.put(PengumumanController());

  @override
  void initState(){
    super.initState();
    controller.getPengumuman();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constanst.colorWhite,
        elevation: 0,
        leadingWidth: 50,
        titleSpacing: 0,
        centerTitle: true,
        title: Obx(() {
          if (controller.isSearching.value) {
            return SizedBox(
              height: 40,
              child: TextFormField(
                controller: controller.searchController,
                onChanged: (value) {
                  controller.pencarianNamaPeraturan(value);
                },
                textAlignVertical: TextAlignVertical.center,
                style: GoogleFonts.inter(
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                  color: Constanst.fgPrimary,
                  fontSize: 15,
                ),
                cursorColor: Constanst.onPrimary,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Constanst.colorNeutralBgSecondary,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  contentPadding: const EdgeInsets.only(left: 20, right: 20),
                  hintText: "Cari data...",
                  hintStyle: GoogleFonts.inter(
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                    color: Constanst.fgSecondary,
                    fontSize: 14,
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 8),
                    child: IconButton(
                      icon: Icon(
                        Iconsax.close_circle5,
                        color: Constanst.fgSecondary,
                        size: 24,
                      ),
                      padding: EdgeInsets.zero,
                      onPressed: controller.clearText,
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Text(
              "Pengumuman",
              style: GoogleFonts.inter(
                color: Constanst.fgPrimary,
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            );
          }
        }),
        actions: [
          Obx(
            () => controller.isSearching.value
                ? Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Container(),
                  )
                : IconButton(
                    icon: Icon(
                      Iconsax.search_normal_1,
                      color: Constanst.fgPrimary,
                      size: 24,
                    ),
                    onPressed: controller.toggleSearch,
                  ),
          ),
        ],
        leading: Obx(
          () => IconButton(
            icon: Icon(
              Iconsax.arrow_left,
              color: Constanst.fgPrimary,
              size: 24,
            ),
            onPressed: controller.isSearching.value
                ? controller.toggleSearch
                : Get.back,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Text(
                  "${controller.pengumumanList.length} pengumuman ditemukan",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                )),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: controller.pengumumanList.length,
                    itemBuilder: (context, index) {
                      var peraturan = controller.pengumumanList.value[index];
                      var id = peraturan['id'];
                      var title = peraturan['title'];
                      var desc = peraturan['description'];
                      var create = peraturan['begin_date'];
                      var beginDate = peraturan['begin_date'];
                      var type = peraturan['type'];
                      var idPertanyaan = peraturan['id_pertanyaan'].toString();
                      var pertanyaaan = peraturan['pertanyaan'].toString();
                      var endDate = peraturan['end_date'];
                      var view = peraturan['is_view'];
                      //  UtilsAlert.showToast(peraturan['pertanyaan']);
                      // var  idPertanyaan= peraturan['id_pertanyaan'];
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              if (view == 0){
                                controller.updateDataNotif(id);
                                // controller.getPengumuman();
                              }
                              // UtilsAlert.showToast(peraturan['type']);
                              if (type == "polling") {
                                controller.getPolling(id: idPertanyaan);
                                Get.to(DetailPolling(
                                  title: title,
                                  create: create,
                                  desc: desc,
                                  idPertanyaan: idPertanyaan,
                                  pertanyaaan: pertanyaaan,
                                  endDate: endDate.toString(),
                                ));
                              } else {
                                Get.to(DetailInformasi(
                                    title: title, create: create, desc: desc));
                              }
                            },
                            child: ListTile(
                              tileColor: view == 0 ? Constanst.colorButton2 : Colors.transparent,
                              leading: const Icon(
                                Icons.article,
                                color: Colors.blue,
                                size: 40.0,
                              ),
                              title: Text(title),
                              subtitle: Text(formatDate(beginDate)),
                              trailing: const Icon(
                                Icons.expand_more,
                                color: Colors.grey,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 16.0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Divider(
                            height: 0,
                            thickness: 1,
                            color: Constanst.fgBorder,
                          ),
                        ],
                      );
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }

  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    return formattedDate;
  }
}
