import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/tracking_controller.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/month_year_picker.dart';

class RiwayatTracking extends StatefulWidget {
  String emId;
  String image;
  String jobTitle;
  RiwayatTracking(
      {Key? key,
      required this.emId,
      required this.image,
      required this.jobTitle})
      : super(key: key);
  @override
  _RiwayatTrackingState createState() => _RiwayatTrackingState();
}

class _RiwayatTrackingState extends State<RiwayatTracking> {
  final controllerTracking = Get.put(TrackingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                Padding(
                  padding: EdgeInsets.only(
                      bottom:
                          controllerTracking.isMapsDetail.value ? 0.0 : 12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Get.back(),
                            icon: const Icon(Iconsax.arrow_left),
                          ),
                          Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Constanst.infoLight,
                                      width: 2.0,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(100))),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: widget.image == ""
                                      ? SvgPicture.asset(
                                          'assets/avatar_default.svg',
                                          width: 38,
                                          height: 38,
                                        )
                                      : CircleAvatar(
                                          radius: 19,
                                          child: ClipOval(
                                            child: ClipOval(
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    "${Api.UrlfotoProfile}$widget.image",
                                                progressIndicatorBuilder:
                                                    (context, url,
                                                            downloadProgress) =>
                                                        Container(
                                                  alignment: Alignment.center,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.5,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child:
                                                      CircularProgressIndicator(
                                                          value:
                                                              downloadProgress
                                                                  .progress),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Container(
                                                  color: Colors.white,
                                                  child: SvgPicture.asset(
                                                    'assets/avatar_default.svg',
                                                    width: 38,
                                                    height: 38,
                                                  ),
                                                ),
                                                fit: BoxFit.cover,
                                                width: 38,
                                                height: 38,
                                              ),
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                              Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: ClipOval(
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      color: Colors.white,
                                      child: ClipOval(
                                        child: Container(
                                          padding: const EdgeInsets.all(3),
                                          color: Constanst.infoLight,
                                          child: const Icon(
                                            Iconsax.location5,
                                            size: 8,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${controllerTracking.userTerpilih.value[0]['full_name'] ?? ''}",
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                      color: Constanst.fgPrimary),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      widget.jobTitle,
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13,
                                          color: controllerTracking
                                                  .isMapsDetail.value
                                              ? Constanst.fgSecondary
                                              : Constanst.fgPrimary),
                                    ),
                                    Text(
                                      '  |  ',
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: controllerTracking
                                                  .isMapsDetail.value
                                              ? Constanst.fgBorder
                                              : Constanst.fgPrimary),
                                    ),
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(100)),
                                          color: Constanst.color5),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      'Online',
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: controllerTracking
                                                  .isMapsDetail.value
                                              ? Constanst.fgSecondary
                                              : Constanst.fgPrimary),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: controllerTracking.latUser.value == 0.0 ||
                          controllerTracking.langUser.value == 0.0 ||
                          controllerTracking.alamatUserFoto.value == ""
                      ? const SizedBox(
                          height: 50,
                          child: Center(
                            child: SizedBox(
                                width: 35,
                                height: 35,
                                child:
                                    CircularProgressIndicator(strokeWidth: 3)),
                          ),
                        )
                      : body(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget body() {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 16.0),
            child: pickDate(),
          ),
          controllerTracking.statusLoadingSubmitLaporan.value
              ? Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Constanst.colorPrimary,
                  ),
                )
              :
              // controllerTracking.kontrolHistory.value.isEmpty
              //     ? Center(child: Text("${controllerTracking.loading.value}"))
              //     :
              listHistoryControl(),
        ],
      ),
    );
  }

  Widget listHistoryControl() {
    controllerTracking.kontrolHistory.value.length = 5;
    return Expanded(
      child: ListView.builder(
          physics: controllerTracking.kontrolHistory.value.length <= 15
              ? const AlwaysScrollableScrollPhysics()
              : const BouncingScrollPhysics(),
          itemCount: controllerTracking.kontrolHistory.value.length,
          itemBuilder: (context, index) {
            var time = "09:00 - 18:00 WIB | 9 Okt 2023";
            var deskripsi =
                "Deskripsi Keterangan akan ditampilkan disini. Lorem ipsum dolor sit amet consectetur...";
            return InkWell(
              onTap: () {
                // Get.to(RiwayatTracking(
                //   emId: emId,
                // ));
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, bottom: 16.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                      border: Border.all(color: Constanst.fgBorder)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 12.0, 16.0, 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      time,
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Constanst.fgPrimary),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      deskripsi,
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: Constanst.fgSecondary),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Iconsax.arrow_right_3,
                                  color: Constanst.fgSecondary, size: 20),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, top: 12.0, bottom: 8.0),
                          child: Divider(
                            thickness: 1,
                            height: 0,
                            color: Constanst.border,
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 12.0, right: 12.0),
                              child: Image.asset(
                                index == 0
                                    ? 'assets/tracking.png'
                                    : 'assets/tracking_slash.png',
                                width: 24,
                                height: 24,
                              ),
                            ),
                            Text(
                              index == 0
                                  ? "Live tracking active"
                                  : "Live tracking berakhir",
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Constanst.fgPrimary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget pickDate() {
    String getDateRange(String dateString) {
      // Parsing string menjadi objek DateTime
      DateTime parsedDate = DateFormat("MM-yyyy").parseStrict(dateString);

      // Mendapatkan rentang tanggal dari 1 hingga hari terakhir bulan
      DateTime firstDayOfMonth = DateTime(parsedDate.year, parsedDate.month, 1);
      DateTime lastDayOfMonth =
          DateTime(parsedDate.year, parsedDate.month + 1, 0);

      // Memformat rentang tanggal
      String formattedDateRange =
          '${DateFormat('d MMMM', 'id').format(firstDayOfMonth)} sd ${DateFormat('d MMMM yyyy', 'id').format(lastDayOfMonth)}';

      return formattedDateRange;
    }

    String lastDayOfMonth =
        getDateRange(controllerTracking.bulanDanTahunNow.value);

    return InkWell(
      customBorder: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(100))),
      onTap: () async {
        print("kesini");
        DatePicker.showPicker(
          context,
          pickerModel: CustomMonthPicker(
            minTime: DateTime(2020, 1, 1),
            maxTime: DateTime(2050, 1, 1),
            currentTime: DateTime(
                int.parse(controllerTracking.tahunSelectedSearchHistory.value),
                int.parse(controllerTracking.bulanSelectedSearchHistory.value),
                1),
          ),
          onConfirm: (time) {
            if (time != null) {
              print("$time");
              var filter = DateFormat('yyyy-MM').format(time);
              var array = filter.split('-');
              var bulan = array[1];
              var tahun = array[0];
              controllerTracking.bulanSelectedSearchHistory.value = bulan;
              controllerTracking.tahunSelectedSearchHistory.value = tahun;
              controllerTracking.bulanDanTahunNow.value = "$bulan-$tahun";
              this.controllerTracking.bulanSelectedSearchHistory.refresh();
              this.controllerTracking.tahunSelectedSearchHistory.refresh();
              this.controllerTracking.bulanDanTahunNow.refresh();
            }
          },
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
            border: Border.all(color: Constanst.fgBorder)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Iconsax.calendar_1,
                    size: 24,
                    color: Constanst.fgPrimary,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      Constanst.convertDateBulanDanTahun(
                          controllerTracking.bulanDanTahunNow.value),
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Constanst.fgPrimary),
                    ),
                  ),
                ],
              ),
              Icon(
                Iconsax.arrow_down_1,
                size: 18,
                color: Constanst.fgPrimary,
              )
            ],
          ),
        ),
      ),
    );
  }
}
