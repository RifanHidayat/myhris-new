import 'package:flutter/material.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_operasional/controller/tracking_controller.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';

class BagikanLokasi extends StatefulWidget {
  final status;
  BagikanLokasi({super.key, this.status});
  @override
  _BagikanLokasiState createState() => _BagikanLokasiState();
}

class _BagikanLokasiState extends State<BagikanLokasi> {
  final Set<Marker> markers = new Set();
  Set<Circle> circles = Set();
  GoogleMapController? mapController;

  BitmapDescriptor? destinationIcon;
  final controllerTracking = Get.find<TrackingController>(tag: 'iniScreen');

  void initState() {
    Api().checkLogin();
    // TODO: implement initState
    super.initState();
    controllerTracking.deskripsiAbsen.clear();
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(1, 1)),
      'assets/avatar_default.png',
    ).then((onValue) {
      destinationIcon = onValue;
    });

    controllerTracking.absenSelfie();
    controllerTracking.getPlaceCoordinate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constanst.colorWhite,
      appBar: AppBar(
        backgroundColor: Constanst.colorWhite,
        elevation: 0,
        centerTitle: false,
        title: Text(
          "Bagikan Lokasi",
          style: GoogleFonts.inter(
              color: Constanst.fgPrimary,
              fontWeight: FontWeight.w500,
              fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Iconsax.refresh4,
              color: Constanst.fgPrimary,
              size: 24,
            ),
            onPressed: () {
              controllerTracking.getPosisition();
              mapController?.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                      target: LatLng(controllerTracking.latUser.value,
                          controllerTracking.langUser.value),
                      zoom: 20)
                  //17 is new zoom level
                  ));
            },
            // controller.toggleSearch,
          ),
        ],
        leading: IconButton(
          icon: Icon(
            Iconsax.arrow_left,
            color: Constanst.fgPrimary,
            size: 24,
          ),
          onPressed: () {
            Navigator.pop(Get.context!);
          },
          // onPressed: () {
          //   controller.cari.value.text = "";
          //   Get.back();
          // },
        ),
      ),
      body: Obx(() {
        return controllerTracking.latUser.value == 0.0 ||
                controllerTracking.langUser.value == 0.0 ||
                controllerTracking.alamatUserFoto.value == ""
            ? const Center(
                child: SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(strokeWidth: 3)),
              )
            : Stack(children: [
                _body(),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: Padding(
                      padding:
                          const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                      child: Container(
                        height: 316,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 155, 155, 155)
                                  .withOpacity(0.2),
                              spreadRadius: 5.0,
                              blurRadius: 10,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 12.0),
                            Center(
                              child: Container(
                                height: 6,
                                width: 32,
                                decoration: BoxDecoration(
                                    color: Constanst.border,
                                    borderRadius: BorderRadius.circular(12.0)),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Material(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(15.0),
                              ),
                              color: Constanst.colorWhite,
                              child: InkWell(
                                onTap: () async {
                                  showDataIntervalWaktu();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      16.0, 8.0, 16.0, 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Iconsax.timer_1,
                                            size: 24,
                                            color: Constanst.fgSecondary,
                                          ),
                                          const SizedBox(width: 12),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Atur Interval",
                                                style: GoogleFonts.inter(
                                                    color:
                                                        Constanst.fgSecondary,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                "30 Menit",
                                                style: GoogleFonts.inter(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: Constanst.fgPrimary),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        Iconsax.arrow_down_1,
                                        size: 24,
                                        color: Constanst.fgSecondary,
                                      ),

                                      // Container(
                                      //   width: 80,
                                      //   height: 35,
                                      //   decoration: BoxDecoration(
                                      //       borderRadius: Constanst.borderStyle2,
                                      //       border: Border.all(
                                      //           color: Constanst.colorText1)),
                                      //   child: Padding(
                                      //     padding: const EdgeInsets.only(
                                      //         left: 16,
                                      //         right: 16,
                                      //         top: 8,
                                      //         bottom: 8),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Material(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(15.0),
                              ),
                              color: Constanst.colorWhite,
                              child: InkWell(
                                onTap: () async {
                                  showTimePicker(
                                    context: Get.context!,
                                    initialTime: TimeOfDay.now(),
                                    initialEntryMode: TimePickerEntryMode.input,
                                    cancelText: 'Batal',
                                    confirmText: 'Simpan',
                                    builder: (context, child) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                            alwaysUse24HourFormat: true),
                                        child: Theme(
                                          data: ThemeData(
                                            colorScheme: ColorScheme.light(
                                              primary: Constanst.onPrimary,
                                            ),
                                            // useMaterial3: settings.useMaterial3,
                                            dialogTheme: const DialogTheme(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                16)))),
                                            primaryColor: Constanst.fgPrimary,
                                            textTheme: TextTheme(
                                              titleMedium: GoogleFonts.inter(
                                                color: Constanst.fgPrimary,
                                              ),
                                            ),
                                            dialogBackgroundColor:
                                                Constanst.colorWhite,
                                            canvasColor: Colors.white,
                                            hintColor: Constanst.onPrimary,
                                            textButtonTheme:
                                                TextButtonThemeData(
                                              style: TextButton.styleFrom(
                                                foregroundColor:
                                                    Constanst.onPrimary,
                                              ),
                                            ),
                                          ),
                                          child: child!,
                                        ),
                                      );
                                    },
                                  ).then((value) {
                                    if (value == null) {
                                      UtilsAlert.showToast('gagal pilih jam');
                                    } else {
                                      // var convertJam = value.hour <= 9
                                      //     ? "0${value.hour}"
                                      //     : "${value.hour}";
                                      // var convertMenit = value.minute <= 9
                                      //     ? "0${value.minute}"
                                      //     : "${value.minute}";
                                      // absenController.checkinAjuan2.value =
                                      //     "$convertJam:$convertMenit";
                                      // absenController.isChecked.value = true;
                                      // this.controller.dariJam.refresh();
                                    }
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      16.0, 8.0, 16.0, 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Iconsax.clock,
                                            size: 24,
                                            color: Constanst.fgSecondary,
                                          ),
                                          const SizedBox(width: 12),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Bagikan Sampai",
                                                style: GoogleFonts.inter(
                                                    color:
                                                        Constanst.fgSecondary,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                "11:00 WIB",
                                                style: GoogleFonts.inter(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: Constanst.fgPrimary),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        Iconsax.arrow_down_1,
                                        size: 24,
                                        color: Constanst.fgSecondary,
                                      ),

                                      // Container(
                                      //   width: 80,
                                      //   height: 35,
                                      //   decoration: BoxDecoration(
                                      //       borderRadius: Constanst.borderStyle2,
                                      //       border: Border.all(
                                      //           color: Constanst.colorText1)),
                                      //   child: Padding(
                                      //     padding: const EdgeInsets.only(
                                      //         left: 16,
                                      //         right: 16,
                                      //         top: 8,
                                      //         bottom: 8),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  16.0, 8.0, 16.0, 0.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Iconsax.note_1,
                                    size: 24,
                                    color: Constanst.fgSecondary,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Catatan",
                                        style: GoogleFonts.inter(
                                            color: Constanst.fgSecondary,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16),
                                      ),
                                      SizedBox(
                                        height: 45,
                                        child: TextFormField(
                                          controller:
                                              controllerTracking.deskripsiAbsen,
                                          decoration: const InputDecoration(
                                            hintText:
                                                'Tambahkan catatan disini',
                                            border: InputBorder.none,
                                          ),
                                          style: GoogleFonts.inter(
                                              color: Constanst.fgPrimary,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16),
                                        ),
                                      )
                                    ],
                                  )),
                                  Icon(
                                    Iconsax.edit,
                                    size: 18,
                                    color: Constanst.fgSecondary,
                                  ),

                                  // Expanded(
                                  //   flex: 90,
                                  //   child: InkWell(
                                  //     onTap: () {
                                  //       // validasiButtonSheet();
                                  //     },
                                  //     child: Container(
                                  //       decoration: BoxDecoration(
                                  //           color: Colors.white,
                                  //           borderRadius:
                                  //               Constanst.borderStyle2,
                                  //           border: Border.all(
                                  //               width: 1.0,
                                  //               color: Color.fromARGB(
                                  //                   255, 211, 205, 205))),
                                  //       child: Padding(
                                  //         padding:
                                  //             const EdgeInsets.only(left: 8),
                                  //         child: TextField(
                                  //           enabled: false,
                                  //           cursorColor: Colors.black,
                                  //           controller:
                                  //               controller.deskripsiAbsen,
                                  //           maxLines: null,
                                  //           decoration: new InputDecoration(
                                  //               border: InputBorder.none,
                                  //               hintText: "Tambahkan Catatan"),
                                  //           keyboardType:
                                  //               TextInputType.multiline,
                                  //           textInputAction:
                                  //               TextInputAction.done,
                                  //           style: TextStyle(
                                  //               fontSize: 10.0,
                                  //               height: 2.0,
                                  //               color: Colors.black),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  16.0, 0.0, 16.0, 16.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    Get.back();
                                    controllerTracking.bagikanlokasi.value =
                                        "aktif";
                                    // await BackgroundLocationTrackerManager
                                    //     .startTracking();
                                    // final service = FlutterBackgroundService();
                                    // FlutterBackgroundService()
                                    //     .invoke("setAsBackground");

                                    // service.startService();
                                    controllerTracking.updateStatus('1');

                                    setState(() => controllerTracking
                                        .isTrackingLokasi.value = true);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      foregroundColor: Constanst.colorWhite,
                                      backgroundColor: Constanst.colorPrimary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      elevation: 0,
                                      // padding: EdgeInsets.zero,
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 0, 0)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 12.0, bottom: 12.0),
                                    child: Text(
                                      'Bagikan Lokasi',
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          color: Constanst.colorWhite,
                                          fontSize: 15),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ]);
      }),
    );
  }

  Widget _body() {
    getMarker();
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            markers: markers,
            circles: circles,
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
                target: LatLng(controllerTracking.latUser.value,
                    controllerTracking.langUser.value),
                zoom: 20.0),
            onMapCreated: (GoogleMapController controller) {
              setState(() {
                mapController = controller;
              });
            },
          ),
          Positioned(
            bottom: 10,
            child: Column(
              children: [],
            ),
          )
        ],
      ),
    );
  }

  void getMarker() {
    markers.add(Marker(
        //add first marker
        markerId: MarkerId("1"),
        icon: destinationIcon ?? BitmapDescriptor.defaultMarker,
        // icon: ,
        position: LatLng(
          double.parse(controllerTracking.latUser.toString()),
          double.parse(controllerTracking.langUser.toString()),
        )));

    circles.add(Circle(
      circleId: CircleId("1"),
      center: LatLng(
        double.parse(controllerTracking.latUser.toString()),
        double.parse(controllerTracking.langUser.toString()),
      ),
      radius: 10,
      strokeColor: Constanst.radiusColor.withOpacity(0.25),
      fillColor: Constanst.radiusColor.withOpacity(0.25),
      strokeWidth: 1,
    ));
  }

  showDataIntervalWaktu() {
    Get.bottomSheet(SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Center(
                child: Container(
                  height: 6,
                  width: 32,
                  decoration: BoxDecoration(
                      color: Constanst.border,
                      borderRadius: BorderRadius.circular(12.0)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                        customBorder: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        onTap: () => Navigator.pop(Get.context!),
                        child: Icon(
                          Iconsax.arrow_left,
                          size: 26,
                          color: Constanst.fgSecondary,
                        )),
                    const SizedBox(width: 12.0),
                    Text(
                      "Pilih Interval Waktu",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Constanst.fgPrimary,
                      ),
                    ),
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
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: List.generate(3, (index) {
                    var waktu = "30 menit";
                    return InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              waktu,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Constanst.fgPrimary,
                              ),
                            ),
                            waktu == "30 menit"
                                ? InkWell(
                                    onTap: () {},
                                    child: Container(
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
                                                  BorderRadius.circular(10)),
                                        ),
                                      ),
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {},
                                    child: Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: Constanst.onPrimary),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        ),
                                      ),
                                    ),
                                  )
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
