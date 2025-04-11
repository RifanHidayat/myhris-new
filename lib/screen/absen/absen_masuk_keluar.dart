import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:draggable_bottom_sheet/draggable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_operasional/controller/absen_controller.dart';
import 'package:siscom_operasional/controller/dashboard_controller.dart';
import 'package:siscom_operasional/screen/absen/camera_view_location.dart';
import 'package:siscom_operasional/screen/dashboard.dart';
import 'package:siscom_operasional/screen/init_screen.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/appbar_widget.dart';
import 'package:siscom_operasional/utils/constans.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AbsenMasukKeluar extends StatefulWidget {
  final status;
  AbsenMasukKeluar({super.key, this.status});
  @override
  _AbsenMasukKeluarState createState() => _AbsenMasukKeluarState();
}

class _AbsenMasukKeluarState extends State<AbsenMasukKeluar> {
  final double _initFabHeight = 120.0;
  double _fabHeight = 0;
  double _panelHeightOpen = 0;
  double _panelHeightClosed = 250.0;
  final panelController = PanelController();
  final controller = Get.put(AbsenController());
  final controllerDashboard = Get.put(DashboardController());
  FocusNode myfocus = FocusNode();

  Completer<GoogleMapController> _controller = Completer();

  final Set<Marker> markers = new Set();
  Set<Circle> circles = Set();
  GoogleMapController? mapController;
  BitmapDescriptor? destinationIcon;

  bool isCollapse = false;

  int minExtent = 150;
  int maxExtend = 250;

  void initState() {
    Api().checkLogin();
    // controller.getPlaceCoordinate();
    // TODO: implement initState
    super.initState();
    controller.deskripsiAbsen.clear();
    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(1, 1)),
      'assets/avatar_default.png',
    ).then((onValue) {
      destinationIcon = onValue;
    });

    controller.absenSelfie();

    controller.getPlaceCoordinate();
    controller.getPlaceCoordinate1();

    _fabHeight = _initFabHeight;
  }

  void getMarker() {
    markers.add(Marker(
        //add first marker
        markerId: const MarkerId("1"),
        icon: destinationIcon ?? BitmapDescriptor.defaultMarker,
        // icon: ,
        position: LatLng(
          double.parse(controller.latUser.toString()),
          double.parse(controller.langUser.toString()),
        )));

    circles.add(Circle(
      circleId: const CircleId("1"),
      center: LatLng(
        double.parse(controller.latUser.toString()),
        double.parse(controller.langUser.toString()),
      ),
      radius: 10,
      strokeColor: Constanst.radiusColor.withOpacity(0.25),
      fillColor: Constanst.radiusColor.withOpacity(0.25),
      strokeWidth: 1,
    ));
  }

  var panel = PanelState.OPEN;
  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .80;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          onPressed: () {
            Get.back();
            Get.back();
            // controller.removeAll();
            // controllerDashboard.onInit();
            // Get.offAll(InitScreen());
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Constanst.colorText2,
          ),
        ),
        actions: [
          // Padding(
          //   padding: const EdgeInsets.only(right: 5),
          //   child: SizedBox(
          //     width: 20,
          //     height: 20,
          //     child: Obx(() {
          //       return Container(
          //         decoration: BoxDecoration(
          //           color: authController.isConnected.value
          //               ? Constanst.color5
          //               : Constanst.color4,
          //           borderRadius: BorderRadius.circular(20),
          //         ),
          //       );
          //     }),
          //   ),
          // ),
          Container(
            decoration: BoxDecoration(
                color: Constanst.grey, borderRadius: BorderRadius.circular(25)),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
              child: InkWell(
                onTap: () {
                  print(controller.placeCoordinateDropdown.value
                      .toSet()
                      .toList());
                  // controller.getPosisition();
                  // controller.getPlaceCoordinate1();
                  // mapController?.animateCamera(
                  //     CameraUpdate.newCameraPosition(
                  //         CameraPosition(
                  //             target: LatLng(controller.latUser.value,
                  //                 controller.langUser.value),
                  //             zoom: 20)
                  //         //17 is new zoom level
                  //         ));
                  controller.refreshPage();
                  // if (!authController.isConnected.value) {
                  //   controller.getPlaceCoordinate();
                  // }
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Refresh",
                      style: TextStyle(color: Constanst.colorText4),
                    ),
                    Icon(Icons.refresh, color: Constanst.colorText4)
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      body: Obx(() {
        return controller.latUser.value == 0.0 ||
                controller.langUser.value == 0.0 ||
                controller.alamatUserFoto.value == ""
            ? const SizedBox(
                height: 50,
                child: Center(
                  child: SizedBox(
                      child: CircularProgressIndicator(strokeWidth: 3),
                      width: 35,
                      height: 35),
                ),
              )
            : Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  SlidingUpPanel(
                    maxHeight: _panelHeightOpen,
                    minHeight: _panelHeightClosed,
                    controller: panelController,
                    backdropTapClosesPanel: true,
                    parallaxEnabled: true,
                    backdropEnabled: false,
                    parallaxOffset: .5,

                    defaultPanelState: panel,
                    renderPanelSheet: false,
                    backdropOpacity: 0.0,
                    body: _body(),
                    panelBuilder: (sc) => _panel(sc),
                    // color: Colors.transparent,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(18.0),
                        topRight: Radius.circular(18.0)),
                    onPanelSlide: (double pos) => setState(() {
                      _fabHeight =
                          pos * (_panelHeightOpen - _panelHeightClosed) +
                              _initFabHeight;
                    }),
                  ),

                  // the fab
                ],
              );
      }),
    );
  }

  Widget _panel(ScrollController sc) {
    print(panelController.panelPosition.toString());

    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Container(
          color: Colors.transparent,
          child: ListView(
            controller: sc,
            children: <Widget>[
              panelController.panelPosition > 0.2
                  ? _expandedWidget()
                  : _previewWidget()
            ],
          ),
        ));
  }

  Widget _button(String label, IconData icon, Color color) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Icon(
            icon,
            color: Colors.white,
          ),
          decoration:
              BoxDecoration(color: color, shape: BoxShape.circle, boxShadow: [
            const BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
              blurRadius: 8.0,
            )
          ]),
        ),
        const SizedBox(
          height: 12.0,
        ),
        Text(label),
      ],
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
            // initialCameraPosition: _kGooglePlex,
            markers: markers,
            circles: circles,
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
                target:
                    LatLng(controller.latUser.value, controller.langUser.value),
                zoom: 20.0),
            onMapCreated: (GoogleMapController controller) {
              setState(() {
                mapController = controller;
              });
            },
          ),
          const Positioned(
            bottom: 10,
            child: Column(
              children: [],
            ),
          )
        ],
      ),
    );
  }

  Widget _expandedWidget() {
    return Container(
      width: MediaQuery.of(Get.context!).size.width,
      height: MediaQuery.of(Get.context!).size.height * .8,
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.only(right: 10),
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      controller.getPosisition();
                      mapController?.animateCamera(
                          CameraUpdate.newCameraPosition(CameraPosition(
                                  target: LatLng(controller.latUser.value,
                                      controller.langUser.value),
                                  zoom: 20)
                              //17 is new zoom level
                              ));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Icon(
                            Iconsax.gps,
                            color: HexColor('#868FA0'),
                          )),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Container(
                width: MediaQuery.of(Get.context!).size.width,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            alignment: Alignment.topCenter,
                            child: Icon(
                              Iconsax.location_tick,
                              size: 24,
                              color: Constanst.colorPrimary,
                            )
                            // Image.asset(
                            //     "assets/ic_location.png"),
                            ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Lokasi kamu saat ini",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width:
                                  MediaQuery.of(Get.context!).size.width * 0.7,
                              child: Text(
                                controller.alamatUserFoto.value
                                        .toString()
                                        .substring(0, 50) +
                                    '...',
                                style: TextStyle(
                                    fontSize: 12, color: Constanst.colorText2),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Container(
                width: MediaQuery.of(Get.context!).size.width,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Obx(
                    () => Padding(
                      padding: const EdgeInsets.only(
                          bottom: 20, left: 20, right: 20, top: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                panelController.close();
                              });
                            },
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    panelController.close();
                                  });
                                },
                                child: const Icon(Icons.keyboard_arrow_down,
                                    size: 30, color: Colors.grey),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 10,
                                child: Container(
                                    alignment: Alignment.topCenter,
                                    child: Icon(
                                      Iconsax.clock,
                                      size: 24,
                                      color: Constanst.colorPrimary,
                                    )),
                              ),
                              Expanded(
                                flex: 90,
                                child: Padding(
                                    padding:
                                        const EdgeInsets.only(left: 8, top: 3),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                              controller.timeString.value,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Expanded(
                                            child: widget.status ==
                                                    "Absen Masuk"
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
                                                              156,
                                                              223,
                                                              253,
                                                              223),
                                                      borderRadius: Constanst
                                                          .borderStyle1,
                                                    ),
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 8),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              right: 10),
                                                      child: Text(
                                                        widget.status,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: Constanst
                                                            .colorGreenBold,
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
                                                              156,
                                                              241,
                                                              171,
                                                              171),
                                                      borderRadius: Constanst
                                                          .borderStyle1,
                                                    ),
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 8),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              right: 10),
                                                      child: Text(
                                                        widget.status,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: Constanst
                                                            .colorRedBold,
                                                      ),
                                                    ),
                                                  ))
                                      ],
                                    )),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 10,
                                child: Container(
                                    alignment: Alignment.topCenter,
                                    child: Icon(
                                      Iconsax.calendar_2,
                                      size: 24,
                                      color: Constanst.colorPrimary,
                                    )
                                    // Image.asset(
                                    //     "assets/ic_calender.png"),
                                    ),
                              ),
                              Expanded(
                                flex: 90,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, top: 3),
                                  child: Text(controller.dateNow.value,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 20,
                                child: Container(
                                    alignment: Alignment.topCenter,
                                    child: Icon(
                                      Iconsax.location_tick,
                                      size: 24,
                                      color: Constanst.colorPrimary,
                                    )
                                    // Image.asset(
                                    //     "assets/ic_location.png"),
                                    ),
                              ),
                              const Expanded(
                                  flex: 90,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 8, top: 3),
                                    child: Text("Tipe lokasi",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  )),
                              Expanded(
                                flex: 90,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: Constanst.borderStyle2,
                                        border: Border.all(
                                            color: Constanst.colorText1)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                          top: 8,
                                          bottom: 8),
                                      child: Obx(() {
                                        return DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            isDense: true,
                                            items: controller
                                                .placeCoordinateDropdown.value
                                                .toSet()
                                                .toList()
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                  value,
                                                  style: const TextStyle(
                                                      fontSize: 10),
                                                ),
                                              );
                                            }).toList(),
                                            value:
                                                controller.selectedType.value,
                                            onChanged: (selectedValue) {
                                              controller.selectedType.value =
                                                  selectedValue!;
                                            },
                                            isExpanded: true,
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color:Constanst.infoLight1
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info),
                                TextLabell(
                                    text:
                                        "Lokasi tidak tersedia! ,coba lakukan refresh pada bagian atas aplikasi "),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 25,
                                child: Container(
                                    alignment: Alignment.topCenter,
                                    child: Icon(
                                      Iconsax.note_1,
                                      size: 24,
                                      color: Constanst.colorPrimary,
                                    )
                                    // Image.asset("assets/ic_note.png"),
                                    ),
                              ),
                              const Expanded(
                                flex: 90,
                                child: Text("Catatan",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(
                                height: 90,
                              ),
                              Expanded(
                                flex: 90,
                                child: InkWell(
                                  onTap: () {
                                    validasiButtonSheet();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: Constanst.borderStyle2,
                                        border: Border.all(
                                            width: 1.0,
                                            color: const Color.fromARGB(
                                                255, 211, 205, 205))),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: TextField(
                                        enabled: false,
                                        cursorColor: Colors.black,
                                        controller: controller.deskripsiAbsen,
                                        maxLines: null,
                                        decoration: new InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Tambahkan Catatan"),
                                        keyboardType: TextInputType.multiline,
                                        textInputAction: TextInputAction.done,
                                        style: const TextStyle(
                                            fontSize: 10.0,
                                            height: 2.0,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Obx(
                            () => controller.isLoaingAbsensi.value == true
                                ? Container(
                                    width:
                                        MediaQuery.of(Get.context!).size.width,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Constanst.greyLight300),
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.white),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  side: const BorderSide(color: Colors.white)))),
                                      onPressed: () {
                                        // controllerDashboard
                                        //     .widgetButtomSheetAktifCamera(
                                        //         'checkTracking');
                                      },
                                      child: Container(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Constanst.fgPrimary,
                                          )),
                                    ),
                                  )
                                : Container(
                                    width:
                                        MediaQuery.of(Get.context!).size.width,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Constanst.colorPrimary),
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.white),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  side: const BorderSide(color: Colors.white)))),
                                      onPressed: () async {
                                        // await controller.offlineToOnline();
                                        // await controller.getPlaceCoordinate1();
                                        // if (controller.coordinate.value ==
                                        //     true) {
                                        //   UtilsAlert
                                        //       .showCheckOfflineAbsensiKesalahanServer(
                                        //           positiveBtnPressed: () {
                                        //     Get.back();
                                        //     controller.selectedType.value
                                        //                     .toString() ==
                                        //                 "WFH" &&
                                        //             widget.status ==
                                        //                 "Absen Masuk"
                                        //         ? controllerDashboard
                                        //             .widgetButtomSheetWfh()
                                        //         : controller
                                        //             .widgetButtomSheetLanjutkanOffline(
                                        //                 type: 'offlineAbsensi');
                                        //   });
                                        // } else if (!authController
                                        //     .isConnected.value) {
                                        //   UtilsAlert.showCheckOfflineAbsensi(
                                        //       positiveBtnPressed: () {
                                        //     Get.back();
                                        //     controller.selectedType.value
                                        //                     .toString() ==
                                        //                 "WFH" &&
                                        //             widget.status ==
                                        //                 "Absen Masuk"
                                        //         ? controllerDashboard
                                        //             .widgetButtomSheetWfh()
                                        //         : controller
                                        //             .widgetButtomSheetLanjutkanOffline(
                                        //                 type: 'offlineAbsensi');
                                        //   });
                                        // } else {
                                        final packageInfo =
                                            await PackageInfo.fromPlatform();
                                        //for (var package in packageInfo) {
                                        print('tes');

                                        print(controller.selectedType.value);
                                        // controller.selectedType.value = "WFH";
                                        controller.selectedType.value
                                                        .toString() ==
                                                    "WFH" &&
                                                widget.status == "Absen Masuk"
                                            ? controllerDashboard
                                                .widgetButtomSheetWfh()
                                            : controllerDashboard
                                                .widgetButtomSheetAktifCamera(
                                                    type: 'checkTracking');
                                        // }
                                        // Mendapatkan informasi paket aplikasi pihak ketiga
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.only(
                                            top: 12,
                                            bottom: 12,
                                            left: 20,
                                            right: 20),
                                        child: Text('OK, Absen sekarang Yak'),
                                      ),
                                    ),
                                  ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void validasiButtonSheet() {
    showModalBottomSheet(
      context: Get.context!,
      isDismissible: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 16,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      flex: 90,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tambahkan Catatan",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 10,
                        child: InkWell(
                          onTap: () => Navigator.pop(Get.context!),
                          child: const Icon(
                            Iconsax.close_circle,
                            color: Colors.red,
                          ),
                        ))
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                const Divider(),
                const SizedBox(
                  height: 14,
                ),
                InkWell(
                  onTap: () {},
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                          border: Border.all(
                              width: 1.0, color: Constanst.greyLight300)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: InkWell(
                          onTap: () {
                            print("tes");
                          },
                          child: TextField(
                            focusNode: myfocus,
                            autofocus: true,
                            controller: controller.deskripsiAbsen,
                            cursorColor: Colors.black,
                            maxLines: null,
                            onSubmitted: (value) {
                              Get.back();
                            },
                            decoration: new InputDecoration(
                                border: InputBorder.none,
                                hintText: "Tambahkan Catatan"),
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.done,
                            style: const TextStyle(
                                fontSize: 12.0,
                                height: 2.0,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          );
        });
      },
    );
  }

  Widget _previewWidget() {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.only(right: 10),
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                controller.getPosisition();
                mapController?.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(
                        target: LatLng(controller.latUser.value,
                            controller.langUser.value),
                        zoom: 20)
                    //17 is new zoom level
                    ));
              },
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Icon(
                        Iconsax.gps,
                        color: HexColor('#868FA0'),
                      ))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Container(
              width: MediaQuery.of(Get.context!).size.width,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          alignment: Alignment.topCenter,
                          child: Icon(
                            Iconsax.location_tick,
                            size: 24,
                            color: Constanst.colorPrimary,
                          )
                          // Image.asset(
                          //     "assets/ic_location.png"),
                          ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Lokasi kamu saat ini",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: MediaQuery.of(Get.context!).size.width * 0.7,
                            child: Text(
                              controller.alamatUserFoto.value
                                      .toString()
                                      .substring(0, 50) +
                                  '...',
                              style: TextStyle(
                                  fontSize: 12, color: Constanst.colorText2),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: [
                Card(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          panelController.open();
                        },
                        child: InkWell(
                          onTap: () {
                            panelController.open();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  panelController.open();
                                },
                                child: const Icon(Icons.keyboard_arrow_up,
                                    size: 30, color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      Obx(
                        () => controller.isLoaingAbsensi.value == true
                            ? Container(
                                width: MediaQuery.of(Get.context!).size.width,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Constanst.greyLight300),
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              side: const BorderSide(
                                                  color: Colors.white)))),
                                  onPressed: () {
                                    // controllerDashboard
                                    //     .widgetButtomSheetAktifCamera(
                                    //         'checkTracking');
                                  },
                                  child: Container(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Constanst.fgPrimary,
                                      )),
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10),
                                width: MediaQuery.of(Get.context!).size.width,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Constanst.colorPrimary),
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              side: const BorderSide(
                                                  color: Colors.white)))),
                                  onPressed: () async {
                                    // await controller.offlineToOnline();
                                    // await controller.getPlaceCoordinate1();
                                    // if (controller.coordinate.value == true) {
                                    //   UtilsAlert
                                    //       .showCheckOfflineAbsensiKesalahanServer(
                                    //           positiveBtnPressed: () {
                                    //     Get.back();
                                    //     controller
                                    //         .widgetButtomSheetLanjutkanOffline(
                                    //             type: 'offlineAbsensi');
                                    //   });
                                    // } else if (!authController
                                    //     .isConnected.value) {
                                    //   UtilsAlert.showCheckOfflineAbsensi(
                                    //       positiveBtnPressed: () {
                                    //     Get.back();
                                    //     controller
                                    //         .widgetButtomSheetLanjutkanOffline(
                                    //             type: 'offlineAbsensi');
                                    //   });
                                    // } else {
                                    controllerDashboard
                                        .widgetButtomSheetAktifCamera(
                                            type: 'checkTracking');
                                    // }
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.only(
                                        top: 12,
                                        bottom: 12,
                                        left: 20,
                                        right: 20),
                                    child: Text('OK, Absen sekarang'),
                                  ),
                                ),
                              ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
