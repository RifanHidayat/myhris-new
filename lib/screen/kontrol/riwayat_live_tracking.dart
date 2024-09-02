import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/tracking_controller.dart';
import 'package:siscom_operasional/screen/kontrol/detail_live_tracking.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/month_year_picker.dart';

class RiwayatLiveTracking extends StatefulWidget {
  RiwayatLiveTracking({
    Key? key,
  }) : super(key: key);
  @override
  _RiwayatLiveTrackingState createState() => _RiwayatLiveTrackingState();
}

class _RiwayatLiveTrackingState extends State<RiwayatLiveTracking> {
  final emIdEmployee = Get.arguments['em_id_employee'];
  final controllerTracking = Get.put(TrackingController());

  Future<void> refreshData() async {
    controllerTracking.riwayatLiveTracking(emIdEmployee: emIdEmployee);
  }

  @override
  void initState() {
    controllerTracking.riwayatLiveTracking(emIdEmployee: emIdEmployee);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Constanst.colorWhite,
        elevation: 0,
        centerTitle: false,
        title: Text(
          "Riwayat Live Tracking",
          style: GoogleFonts.inter(
              color: Constanst.fgPrimary,
              fontWeight: FontWeight.w500,
              fontSize: 20),
        ),
        leading: IconButton(
          icon: Icon(
            Iconsax.arrow_left,
            color: Constanst.fgPrimary,
            size: 24,
          ),
          onPressed: () {
            Navigator.pop(Get.context!);
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              refreshData();
            },
            icon: Icon(
              Iconsax.refresh,
              color: Constanst.fgPrimary,
              size: 24,
            ),
          ),
        ],
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
                Expanded(
                  child: body(),
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
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
            child: pickDate(),
          ),
          controllerTracking.isLoadingRiwayatLiveTracking.value
              ? const Padding(
                  padding: EdgeInsets.only(top: 300.0),
                  child: Center(
                    child: SizedBox(
                        width: 35,
                        height: 35,
                        child: CircularProgressIndicator(strokeWidth: 3)),
                  ),
                )
              :
              // controllerTracking.riwayatLiveTrackings.value.isEmpty
              //     ? Center(child: Text("${controllerTracking.loading.value}"))
              //     :
              listHistoryControl(),
        ],
      ),
    );
  }

  Widget listHistoryControl() {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: refreshData,
        child: ListView.builder(
            physics: controllerTracking.riwayatLiveTrackings.value.length <= 15
                ? const BouncingScrollPhysics()
                : const BouncingScrollPhysics(),
            itemCount: controllerTracking.riwayatLiveTrackings.value.length,
            itemBuilder: (context, index) {
              final data = controllerTracking.riwayatLiveTrackings[index];
              return Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, bottom: 16.0),
                child: InkWell(
                  onTap: () {
                    // Get.to(DetailLiveTracking(), arguments: {
                    //   'atten_date': data.atten_date,
                    //   'deskripsi': data.deskripsi,
                    //   'emIdEmployee': emIdEmployee,
                    // });
                    Get.to(() => DetailLiveTracking(), arguments: {
                      'atten_date': data.atten_date,
                      'deskripsi': data.deskripsi,
                      'emIdEmployee': emIdEmployee,
                    });
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => DetailLiveTracking()),
                    // );
                    //  Get.to(LiveTracking(
                    //   status: 'detail',
                    //   atten_date: data.atten_date,
                    //   emIdEmployee: 'SIS202305048',
                    //   deskripsi: '',
                    // )
                  },
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        Constanst.convertDate6(data.atten_date),
                                        style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: Constanst.fgPrimary),
                                      ),
                                      data.deskripsi == ""
                                          ? Container()
                                          : const SizedBox(height: 4),
                                      data.deskripsi == ""
                                          ? Container()
                                          : Text(
                                              data.deskripsi,
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
                                  // index == 0
                                  //     ? 'assets/tracking.png'
                                  //     :
                                  'assets/tracking_slash.png',
                                  width: 24,
                                  height: 24,
                                ),
                              ),
                              Text(
                                // index == 0
                                //     ? "Live tracking active"
                                //     :
                                "Live tracking berakhir",
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
      ),
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
              controllerTracking.riwayatLiveTracking(
                  emIdEmployee: emIdEmployee);
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
