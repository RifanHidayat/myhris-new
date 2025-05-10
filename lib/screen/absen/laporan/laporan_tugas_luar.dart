import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/laporan_tugas_luar_controller.dart';
import 'package:siscom_operasional/screen/absen/laporan/laporan_tugas_luar_detail.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/month_year_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LaporanTugasLuar extends StatefulWidget {
  String title;
  LaporanTugasLuar({Key? key, required this.title}) : super(key: key);
  @override
  _LaporanTugasLuarState createState() => _LaporanTugasLuarState();
}

class _LaporanTugasLuarState extends State<LaporanTugasLuar> {
  var controller = Get.put(LaporanTugasLuarController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getDepartemen(1, "");
    });
    controller.title.value = widget.title;
    controller.tempNamaLaporan1.value = "tugas_luar";
    super.initState();
  }

  Future<void> refreshData() async {
    await Future.delayed(Duration(seconds: 2));
    controller.getDepartemen(1, "");
    controller.title.value = widget.title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constanst.coloBackgroundScreen,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight) * 1,
          child: Obx(
            () => Container(
              decoration: const BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 2.0),
                  blurRadius: 4.0,
                )
              ]),
              child: AppBar(
                backgroundColor: Constanst.colorWhite,
                elevation: 0,
                // leadingWidth: controller.statusFormPencarian.value ? 50 : 16,
                titleSpacing: 0,
                centerTitle: false,
                title: controller.statusCari.value
                    ? SizedBox(
                        height: 40,
                        child: TextFormField(
                          controller: controller.cari.value,
                          onChanged: (value) {
                            controller.pencarianNamaKaryawan(value);
                          },
                          textAlignVertical: TextAlignVertical.center,
                          style: GoogleFonts.inter(
                              height: 1.5,
                              fontWeight: FontWeight.w400,
                              color: Constanst.fgPrimary,
                              fontSize: 15),
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
                              contentPadding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              hintText: "Cari data...",
                              hintStyle: GoogleFonts.inter(
                                  height: 1.5,
                                  fontWeight: FontWeight.w400,
                                  color: Constanst.fgSecondary,
                                  fontSize: 14),
                              prefixIconConstraints:
                                  BoxConstraints.tight(const Size(46, 46)),
                              suffixIconConstraints:
                                  BoxConstraints.tight(const Size(46, 46)),
                              suffixIcon: Padding(
                                padding:
                                    const EdgeInsets.only(left: 16.0, right: 8),
                                child: IconButton(
                                  icon: Icon(
                                    Iconsax.close_circle5,
                                    color: Constanst.fgSecondary,
                                    size: 24,
                                  ),
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    // controller.statusCari.value = false;
                                    controller.cari.value.text = "";
                                    controller.title.value = widget.title;
                                    controller.getDepartemen(1, "");
                                  },
                                ),
                              )),
                        ),
                      )
                    : InkWell(
                        onTap: () => controller.widgetButtomSheetFormLaporan(),
                        child: SizedBox(
                          height: 56,
                          child: Row(
                            children: [
                              Text(
                                "Laporan Tugas Luar",
                                style: GoogleFonts.inter(
                                    color: Constanst.fgPrimary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Iconsax.arrow_down_1,
                                color: Constanst.fgPrimary,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                actions: [
                  controller.statusCari.value
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
                          onPressed: controller.showInputCari,
                          // controller.toggleSearch,
                        ),
                ],
                leading: controller.statusCari.value
                    ? IconButton(
                        icon: Icon(
                          Iconsax.arrow_left,
                          color: Constanst.fgPrimary,
                          size: 24,
                        ),
                        onPressed: controller.showInputCari,
                      )
                    : IconButton(
                        icon: Icon(
                          Iconsax.arrow_left,
                          color: Constanst.fgPrimary,
                          size: 24,
                        ),
                        onPressed: () {
                          // controller.cari.value.clear();
                          // controller.onClose();
                          Get.back();
                        },
                      ),
              ),
            ),
          ),
        ),
        body: WillPopScope(
            onWillPop: () async {
              Get.back();
              return true;
            },
            child: SafeArea(
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    filterData(),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Text(
                        "${controller.allNameLaporanTidakhadir.value.length} Data",
                        style: GoogleFonts.inter(
                            color: Constanst.fgSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Flexible(
                      child: RefreshIndicator(
                        onRefresh: refreshData,
                        child: controller.statusLoadingSubmitLaporan.value
                            ? Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: Constanst.colorPrimary,
                                ),
                              )
                            : controller.allNameLaporanTidakhadir.value.isEmpty
                                ? Center(
                                    child: Obx(() => SafeArea(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              controller.loadingString.value ==
                                                      "Memuat Data..."
                                                  ? Container()
                                                  : SvgPicture.asset(
                                                      'assets/empty_screen.svg',
                                                      height: 228,
                                                    ),
                                              const SizedBox(height: 100),
                                            ],
                                          ),
                                        )),
                                  )
                                : listPengajuanKaryawan(),
                      ),
                    )
                  ],
                ),
              ),
            )));
  }

  String getMonthName(int monthNumber) {
    // Menggunakan pustaka intl untuk mengonversi angka bulan menjadi teks
    final monthFormat = DateFormat.MMMM('id');
    DateTime date = DateTime(2000, monthNumber,
        1); // Tahun dan hari bebas, yang penting bulan sesuai
    return monthFormat.format(date);
  }

  Widget filterData() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              customBorder: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(100))),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16.0),
                    ),
                  ),
                  builder: (BuildContext context) {
                    return SafeArea(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 18, 16, 18),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Pilih Tipe",
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                      color: Constanst.fgPrimary,
                                    ),
                                  ),
                                  InkWell(
                                      customBorder:
                                          const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8))),
                                      onTap: () => Navigator.pop(Get.context!),
                                      child: Icon(
                                        Icons.close,
                                        size: 26,
                                        color: Constanst.fgSecondary,
                                      ))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                              child: Divider(
                                thickness: 1,
                                height: 0,
                                color: Constanst.border,
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                Get.back();
                                controller.getDepartemen(1, "");
                                controller.title.value = 'tugas_luar';
                                controller.tempNamaTipe1.value = "Tugas Luar";
                                controller.tempNamaLaporan1.value =
                                    "tugas_luar";
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 16, 16, 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const SizedBox(width: 16),
                                        Text(
                                          "Tugas Luar",
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: Constanst.fgPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    controller.tempNamaTipe1.value ==
                                            "Tugas Luar"
                                        ? Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 2,
                                                    color: Constanst.onPrimary),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(3),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Constanst.onPrimary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                              ),
                                            ),
                                          )
                                        : InkWell(
                                            onTap: () async {
                                              Get.back();
                                              controller.getDepartemen(1, "");
                                              controller.title.value =
                                                  'tugas_luar';
                                              controller.tempNamaTipe1.value =
                                                  "Tugas Luar";
                                              controller.tempNamaLaporan1
                                                  .value = "tugas_luar";
                                            },
                                            child: Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 1,
                                                      color:
                                                          Constanst.onPrimary),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(2),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                ),
                                              ),
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                Get.back();
                                controller.getDepartemen(1, "");
                                controller.title.value = 'dinas_luar';
                                controller.tempNamaTipe1.value = "Dinas Luar";
                                controller.tempNamaLaporan1.value =
                                    "dinas_luar";
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 16, 16, 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const SizedBox(width: 16),
                                        Text(
                                          "Dinas Luar",
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: Constanst.fgPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    controller.tempNamaTipe1.value ==
                                            "Dinas Luar"
                                        ? Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 2,
                                                    color: Constanst.onPrimary),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(3),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Constanst.onPrimary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                              ),
                                            ),
                                          )
                                        : InkWell(
                                            onTap: () async {
                                              Get.back();
                                              controller.getDepartemen(1, "");
                                              controller.title.value =
                                                  'dinas_luar';
                                              controller.tempNamaTipe1.value =
                                                  "Dinas Luar";
                                              controller.tempNamaLaporan1
                                                  .value = "dinas_luar";
                                            },
                                            child: Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 1,
                                                      color:
                                                          Constanst.onPrimary),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(2),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
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
                    );
                  },
                ).then((value) {
                  print('Bottom sheet closed');
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Constanst.border)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.tempNamaTipe1.value,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Constanst.fgSecondary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Iconsax.arrow_down_1,
                        size: 18,
                        color: Constanst.fgSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            InkWell(
              customBorder: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(100))),
              onTap: () {
                print(controller.bulanDanTahunNow.value);
                // controller.pageViewFilterWaktu = PageController(
                //     initialPage: controller.selectedViewFilterPengajuan.value);
                // controller.widgetButtomSheetFilterData();
                DatePicker.showPicker(
                  Get.context!,
                  pickerModel: CustomMonthPicker(
                    minTime: DateTime(2000, 1, 1),
                    maxTime: DateTime(2100, 1, 1),
                    currentTime: DateTime.parse(
                        "${controller.tahunSelectedSearchHistory.value}-${controller.bulanSelectedSearchHistory.value}-01"),
                  ),
                  onConfirm: (time) {
                    if (time != null) {
                      print("$time");
                      var filter = DateFormat('yyyy-MM').format(time);
                      var array = filter.split('-');
                      var bulan = array[1];
                      var tahun = array[0];
                      controller.bulanSelectedSearchHistory.value = bulan;
                      controller.tahunSelectedSearchHistory.value = tahun;
                      controller.bulanDanTahunNow.value = "$bulan-$tahun";
                      this.controller.bulanSelectedSearchHistory.refresh();
                      this.controller.tahunSelectedSearchHistory.refresh();
                      this.controller.bulanDanTahunNow.refresh();
                      controller.statusFilterWaktu.value = 0;
                      // Navigator.pop(Get.context!);
                      controller.date.value = time;
                      controller.aksiCariLaporan();
                    }
                  },
                );
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Constanst.border)),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, bottom: 8.0, left: 12.0, right: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "${getMonthName(int.parse(controller.bulanSelectedSearchHistory.value))} ${controller.tahunSelectedSearchHistory.value}",
                        style: GoogleFonts.inter(
                            color: Constanst.fgSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Icon(
                          Iconsax.arrow_down_1,
                          color: Constanst.fgSecondary,
                          size: 18,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            InkWell(
              customBorder: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(100))),
              onTap: () {
                controller.showDataDepartemenAkses('semua');
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Constanst.border)),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, bottom: 8.0, left: 12.0, right: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        controller.departemen.value.text,
                        style: GoogleFonts.inter(
                            color: Constanst.fgSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Icon(
                          Iconsax.arrow_down_1,
                          color: Constanst.fgSecondary,
                          size: 18,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            InkWell(
              customBorder: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(100))),
              onTap: () {
                // if (controller.selectedViewFilterPengajuan.value == 1) {
                controller.showDataStatusAjuan();
                // }
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Constanst.border)),
                child: Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, bottom: 8.0, left: 12.0, right: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          controller.filterStatusAjuanTerpilih.value,
                          style: GoogleFonts.inter(
                              color: Constanst.fgSecondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Icon(
                            Iconsax.arrow_down_1,
                            color: Constanst.fgSecondary,
                            size: 18,
                          ),
                        )
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget listPengajuanKaryawan() {
    return ListView.builder(
        physics: controller.allNameLaporanTidakhadir.value.length <= 15
            ? const AlwaysScrollableScrollPhysics()
            : const BouncingScrollPhysics(),
        itemCount: controller.allNameLaporanTidakhadir.value.length,
        itemBuilder: (context, index) {
          var fullName = controller.allNameLaporanTidakhadir.value[index]
                  ['full_name'] ??
              "";
          var namaKaryawan = "$fullName";
          var jobTitle =
              controller.allNameLaporanTidakhadir.value[index]['job_title'];
          var emId = controller.allNameLaporanTidakhadir.value[index]['em_id'];
          var statusAjuan;
          var tampung =
              controller.allNameLaporanTidakhadir.value[index]['status'];
          statusAjuan = tampung == "Approve"
              ? "Approve 1"
              : tampung == "Approve2"
                  ? "Approve 2"
                  : tampung;

          var jumlahPengajuan = controller.allNameLaporanTidakhadir.value[index]
              ['jumlah_pengajuan'];
          var image = controller.allNameLaporanTidakhadir.value[index]['image'];

          return InkWell(
            onTap: () {
              print(image);
              Get.to(LaporanTugasLuarDetail(
                  emId: emId,
                  bulan: controller.bulanSelectedSearchHistory.value,
                  tahun: controller.tahunSelectedSearchHistory.value,
                  full_name: namaKaryawan,
                  title: controller.title.value,
                  jobTitle: jobTitle,
                  image: image.toString()));
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      image == ""
                          ? SvgPicture.asset(
                              'assets/avatar_default.svg',
                              width: 48,
                              height: 48,
                            )
                          : Center(
                              child: CircleAvatar(
                                radius: 24,
                                child: ClipOval(
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: "${Api.UrlfotoProfile}$image",
                                      progressIndicatorBuilder:
                                          (context, url, downloadProgress) =>
                                              Container(
                                        alignment: Alignment.center,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.5,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        color: Colors.white,
                                        child: SvgPicture.asset(
                                          'assets/avatar_default.svg',
                                          width: 48,
                                          height: 48,
                                        ),
                                      ),
                                      fit: BoxFit.cover,
                                      width: 48,
                                      height: 48,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 60,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              namaKaryawan,
                              style: GoogleFonts.inter(
                                  color: Constanst.fgPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              jobTitle,
                              style: GoogleFonts.inter(
                                  color: Constanst.fgSecondary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 35,
                        child: Center(
                            child:
                                // controller.statusFilterWaktu.value == 0
                                //     ?
                                Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "$jumlahPengajuan Pengajuan",
                              style: GoogleFonts.inter(
                                  color: Constanst.fgPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              Constanst.convertDateBulanDanTahun(
                                  controller.bulanDanTahunNow.value),
                              style: GoogleFonts.inter(
                                  color: Constanst.fgSecondary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        )
                            // : Padding(
                            //     padding: EdgeInsets.only(
                            //         left: 3, right: 3, top: 5, bottom: 5),
                            //     child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.center,
                            //       children: [
                            //         statusAjuan == 'Approve'
                            //             ? Icon(
                            //                 Iconsax.tick_square,
                            //                 color: Constanst.color5,
                            //                 size: 14,
                            //               )
                            //             : statusAjuan == 'Approve 1'
                            //                 ? Icon(
                            //                     Iconsax.tick_square,
                            //                     color: Constanst.color5,
                            //                     size: 14,
                            //                   )
                            //                 : statusAjuan == 'Approve 2'
                            //                     ? Icon(
                            //                         Iconsax.tick_square,
                            //                         color: Constanst.color5,
                            //                         size: 14,
                            //                       )
                            //                     : statusAjuan == 'Rejected'
                            //                         ? Icon(
                            //                             Iconsax.close_square,
                            //                             color:
                            //                                 Constanst.color4,
                            //                             size: 14,
                            //                           )
                            //                         : statusAjuan == 'Pending'
                            //                             ? Icon(
                            //                                 Iconsax.timer,
                            //                                 color: Constanst
                            //                                     .color3,
                            //                                 size: 14,
                            //                               )
                            //                             : SizedBox(),
                            //         Padding(
                            //           padding: const EdgeInsets.only(left: 3),
                            //           child: Text(
                            //             '$statusAjuan',
                            //             textAlign: TextAlign.center,
                            //             style: TextStyle(
                            //                 fontWeight: FontWeight.bold,
                            //                 color: statusAjuan == 'Approve'
                            //                     ? Colors.green
                            //                     : statusAjuan == 'Approve 1'
                            //                         ? Colors.green
                            //                         : statusAjuan ==
                            //                                 'Approve 2'
                            //                             ? Colors.green
                            //                             : statusAjuan ==
                            //                                     'Rejected'
                            //                                 ? Colors.red
                            //                                 : statusAjuan ==
                            //                                         'Pending'
                            //                                     ? Constanst
                            //                                         .color3
                            //                                     : Colors
                            //                                         .black),
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            ),
                      ),
                      const Expanded(
                        flex: 5,
                        child: Center(
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Divider(
                    height: 0,
                    thickness: 1,
                    color: Constanst.border,
                  ),
                ],
              ),
            ),
          );
        });
  }

  // Widget textSubmit() {
  //   return controller.statusLoadingSubmitLaporan.value == false
  //       ? Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Icon(
  //               Iconsax.search_normal_1,
  //               size: 18,
  //               color: Constanst.colorWhite,
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Text(
  //                 "Submit Data",
  //                 style: TextStyle(color: Constanst.colorWhite),
  //               ),
  //             ),
  //           ],
  //         )
  //       : Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.only(top: 5, bottom: 5),
  //               child: Center(
  //                 child: SizedBox(
  //                     width: 30,
  //                     height: 30,
  //                     child: CircularProgressIndicator(
  //                       strokeWidth: 3,
  //                       color: Colors.white,
  //                     )),
  //               ),
  //             )
  //           ],
  //         );
  // }
}
