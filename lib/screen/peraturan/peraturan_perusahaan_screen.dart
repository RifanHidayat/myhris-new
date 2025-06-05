import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/peraturan_perusahaan_controller.dart';
import 'package:siscom_operasional/screen/peraturan/detail_peraturan.dart';
import 'package:siscom_operasional/screen/peraturan/detail_peraturan_perusahaan.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PeraturanPerusahaanScreen extends StatefulWidget {
  @override
  _PeraturanPerusahaanScreenState createState() =>
      _PeraturanPerusahaanScreenState();
}

class _PeraturanPerusahaanScreenState extends State<PeraturanPerusahaanScreen> {
  final PeraturanPerusahaanController controller =
      Get.put(PeraturanPerusahaanController());
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    controller.fetchPeraturan();
  }

  void _onRefresh() async {
    controller.fetchPeraturan();
    refreshController.refreshCompleted();
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
              "Info Peraturan",
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
                  "${controller.peraturanList.length} peraturan ditemukan",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                )),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (controller.peraturanList.isEmpty) {
                  return Center(
                    child: Text("Data belum tersedia"),
                  );
                }

                return SmartRefresher(
                  controller: refreshController,
                  onRefresh: _onRefresh,
                  child: ListView(
                    children: [
                      ...List.generate(controller.peraturanList.length,
                          (index) {
                        var peraturan = controller.peraturanList[index];
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                if (peraturan.gambar == null ||
                                    peraturan.gambar == '') {
                                  Get.to(DetailPeraturanPerusahaan(
                                    peraturan: peraturan,
                                  ));
                                  // controller.downloadFile(peraturan.gambar);
                                  controller.fetchPeraturan();
                                } else {
                                  Get.to(DetaillPeraturan(
                                    type: "detail",
                                    gambar: peraturan.gambar,
                                    title: peraturan.title,
                                    keterangan: peraturan.keterangan,
                                  ));
                                }
                              },
                              child: ListTile(
                                leading: const Icon(
                                  Icons.article,
                                  color: Colors.blue,
                                  size: 40.0,
                                ),
                                title: Text(peraturan.title),
                                subtitle:
                                    Text(formatDate(peraturan.tanggal_berlaku)),
                                trailing: const Icon(
                                  Icons.arrow_right,
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
                      }),
                    ],
                  ),
                );
              }),
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
