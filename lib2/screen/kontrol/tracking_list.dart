import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_operasional/controller/dashboard_controller.dart';
import 'package:siscom_operasional/controller/tracking_controller.dart';
import 'package:siscom_operasional/screen/kontrol/riwayat_live_tracking.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class TrackingList extends StatefulWidget {
  final status;
  TrackingList({super.key, this.status});
  @override
  _TrackingListState createState() => _TrackingListState();
}

class _TrackingListState extends State<TrackingList> {
  final double _initFabHeight = 120.0;
  double _fabHeight = 0;
  double _panelHeightOpen = 0;
  double _panelHeightClosed = 314.0;
  final panelController = PanelController();
  // final controllerTracking = Get.find<AbsenController>();
  var controllerTracking = Get.put(TrackingController());
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
    controllerTracking.isMaps.value = true;
    controllerTracking.statusFormPencarian.value = false;
    controllerTracking.statusFormPencarian2.value = false;
    // Api().checkLogin();
    // // TODO: implement initState
    // super.initState();
    // controllerTracking.deskripsiAbsen.clear();
    // BitmapDescriptor.fromAssetImage(
    //   ImageConfiguration(size: Size(1, 1)),
    //   'assets/avatar_default.png',
    // ).then((onValue) {
    //   destinationIcon = onValue;
    // });

    // // controllerTracking.absenSelfie();

    // controllerTracking.getPlaceCoordinate();

    // _fabHeight = _initFabHeight;
    controllerTracking.trackingList();
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

  var panel = PanelState.OPEN;
  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .80;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: controllerTracking.statusFormPencarian2.value
            ? const Size.fromHeight(kToolbarHeight) * 0
            : const Size.fromHeight(kToolbarHeight) * 1.1,
        child: Obx(
          () => Container(
            decoration: controllerTracking.isMaps.value
                ? null
                : const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 2.0),
                        blurRadius: 4.0,
                      )
                    ],
                  ),
            child: AppBar(
              backgroundColor: Constanst.colorWhite,
              elevation: 0,
              leadingWidth:
                  controllerTracking.statusFormPencarian.value ? 50 : 16,
              titleSpacing: 0,
              centerTitle: false,
              title: controllerTracking.statusFormPencarian.value
                  ? SizedBox(
                      height: 40,
                      child: TextFormField(
                        // controller: controller.searchController,
                        controller: controllerTracking.cari.value,
                        onFieldSubmitted: (value) {
                          if (controllerTracking.cari.value.text == "") {
                            UtilsAlert.showToast(
                                "Isi form cari terlebih dahulu");
                          } else {
                            UtilsAlert.loadingSimpanData(
                                Get.context!, "Mencari Data...");
                            // controller.pencarianDataAktifitas();
                          }
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
                                  controllerTracking.cari.value.clear();
                                  controllerTracking.statusCari.value = false;
                                  controllerTracking.cari.value.text = "";

                                  controllerTracking.getDepartemen(1, "");
                                },
                              ),
                            )),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        Text(
                          "Tracking",
                          style: GoogleFonts.inter(
                              color: Constanst.fgPrimary,
                              fontWeight: FontWeight.w500,
                              fontSize: 20),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Iconsax.profile_2user5,
                              size: 18,
                              color: Constanst.color5,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${controllerTracking.trackingLists.value.where((data) => data.em_tracking.toString() != "0" && data.token_notif != null).length} sedang online",
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Constanst.fgSecondary),
                            ),
                          ],
                        ),
                      ],
                    ),
              actions: [
                controllerTracking.isMaps.value
                    ? controllerTracking.statusFormPencarian.value
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
                            onPressed: controllerTracking.showInputCari,
                            // controller.toggleSearch,
                          )
                    : IconButton(
                        icon: Icon(
                          Iconsax.refresh,
                          color: Constanst.fgPrimary,
                          size: 24,
                        ),
                        onPressed: () {},
                        // controller.toggleSearch,
                      ),
              ],
              leading: controllerTracking.statusFormPencarian.value
                  ? IconButton(
                      icon: Icon(
                        Iconsax.arrow_left,
                        color: Constanst.fgPrimary,
                        size: 24,
                      ),
                      onPressed: controllerTracking.showInputCari,
                      // onPressed: () {
                      //   controller.cari.value.text = "";
                      //   Get.back();
                      // },
                    )
                  : Container(),
            ),
          ),
        ),
      ),
      body: Obx(() {
        return controllerTracking.isLoadingTrackingList.value
            ? const Center(
                child: SizedBox(
                    width: 35,
                    height: 35,
                    child: CircularProgressIndicator(strokeWidth: 3)),
              )
            : Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  SlidingUpPanel(
                    maxHeight: _panelHeightOpen,
                    minHeight: _panelHeightClosed,
                    controller: panelController,
                    backdropTapClosesPanel: false,
                    parallaxEnabled: true,
                    backdropEnabled: false,
                    parallaxOffset: .5,
                    defaultPanelState: panel,
                    renderPanelSheet: true,
                    isDraggable: false,
                    // panelSnapping: false,
                    backdropOpacity: 0.0,
                    body: _body(),
                    panelBuilder: (sc) => _panel(sc),
                    // color: Colors.transparent,
                    onPanelOpened: () {
                      controllerTracking.isMaps.value = true;
                      _panelHeightClosed = 314.0;
                      controllerTracking.statusFormPencarian2.value = false;
                    },
                    onPanelClosed: () {
                      controllerTracking.isMaps.value = false;
                    },
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
        removeBottom: true,
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

  // Widget _button(String label, IconData icon, Color color) {
  //   return Column(
  //     children: <Widget>[
  //       Container(
  //         padding: const EdgeInsets.all(16.0),
  //         child: Icon(
  //           icon,
  //           color: Colors.white,
  //         ),
  //         decoration:
  //             BoxDecoration(color: color, shape: BoxShape.circle, boxShadow: [
  //           BoxShadow(
  //             color: Color.fromRGBO(0, 0, 0, 0.15),
  //             blurRadius: 8.0,
  //           )
  //         ]),
  //       ),
  //       SizedBox(
  //         height: 12.0,
  //       ),
  //       Text(label),
  //     ],
  //   );
  // }

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
                target: LatLng(controllerTracking.latUser.value,
                    controllerTracking.langUser.value),
                zoom: 20.0),
            onMapCreated: (GoogleMapController controllerTracking) {
              setState(() {
                mapController = controllerTracking;
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

  Widget _expandedWidget() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        backgroundColor: Colors.white,
        // floatingActionButton: SizedBox(
        //   height: MediaQuery.of(context).size.height * 0.045,
        //   child: Padding(
        //     padding: const EdgeInsets.only(left: 24.0),
        //     child: Center(
        //       child: FloatingActionButton.extended(
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(100),
        //         ),
        //         extendedPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        //         splashColor: Constanst.onPrimary,
        //         onPressed: () async {},
        //         label: Text(
        //           "Maps",
        //           style: GoogleFonts.inter(
        //               color: Constanst.colorWhite,
        //               fontSize: 14,
        //               fontWeight: FontWeight.w400),
        //         ),
        //         icon: const Icon(
        //           Iconsax.map_15,
        //           size: 22,
        //         ),
        //         backgroundColor: Constanst.infoLight,
        //       ),
        //     ),
        //   ),
        // ),
        body: Obx(
          () => !controllerTracking.showViewKontrol.value
              ? Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/noakses.png",
                        height: 250,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Kamu tidak punya akses ke menu ini.")
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //       left: 16.0, top: 16.0, right: 16.0),
                    //   child: SingleChildScrollView(
                    //     scrollDirection: Axis.horizontal,
                    //     child: Row(
                    //       children: [
                    //         formHariDanTanggal(),
                    //         const SizedBox(width: 8.0),
                    //         formDepartemen(),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, top: 8.0, right: 16.0),
                      child: Text(
                        "${controllerTracking.trackingLists.value.length} Karyawan",
                        style: GoogleFonts.inter(
                            color: Constanst.fgSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // ElevatedButton(
                    //   onPressed: () async {
                    //     _stopForegroundTask();
                    //     Location location = new Location();
                    //     location.enableBackgroundMode(enable: false);
                    //   },
                    //   child: const Text('berhenti'),
                    // ),
                    Expanded(
                      flex: 1,
                      child: controllerTracking.isLoadingTrackingList.value
                          ? const Padding(
                              padding: EdgeInsets.only(top: 200.0),
                              child: Center(
                                child: SizedBox(
                                    width: 35,
                                    height: 35,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 3)),
                              ),
                            )
                          : listEmployeeControl(),
                    ),
                    // Expanded(
                    //   flex: 1,
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(bottom: 32.0),
                    //     child: Center(
                    //       child: FloatingActionButton.extended(
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(100),
                    //         ),
                    //         extendedPadding:
                    //             const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    //         splashColor: Constanst.onPrimary,
                    //         onPressed: () async {
                    //           setState(() {
                    //             panelController.close();
                    //           });
                    //         },
                    //         label: Text(
                    //           "Maps",
                    //           style: GoogleFonts.inter(
                    //               color: Constanst.colorWhite,
                    //               fontSize: 14,
                    //               fontWeight: FontWeight.w400),
                    //         ),
                    //         icon: const Icon(
                    //           Iconsax.map_15,
                    //           size: 22,
                    //         ),
                    //         backgroundColor: Constanst.infoLight,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
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
                SizedBox(
                  height: 16,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
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
                          child: Icon(
                            Iconsax.close_circle,
                            color: Colors.red,
                          ),
                        ))
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Divider(),
                SizedBox(
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
                            controller: controllerTracking.deskripsiAbsen,
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
                            style: TextStyle(
                                fontSize: 12.0,
                                height: 2.0,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
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
    return Obx(
      () => !controllerTracking.showViewKontrol.value
          ? Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/noakses.png",
                    height: 250,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Kamu tidak punya akses ke menu ini.")
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // controllerTracking.statusFormPencarian2.value
                //     ? Container()
                //     : SizedBox(
                //         height: MediaQuery.of(context).size.height * 0.045,
                //         child: Center(
                //           child: FloatingActionButton.extended(
                //             shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(100),
                //             ),
                //             extendedPadding:
                //                 const EdgeInsets.fromLTRB(16, 0, 16, 0),
                //             splashColor: Constanst.onPrimary,
                //             onPressed: () async {
                //               setState(() {
                //                 controllerTracking.isMaps.value = true;
                //                 panelController.open();
                //               });
                //             },
                //             label: Text(
                //               "List",
                //               style: GoogleFonts.inter(
                //                   color: Constanst.colorWhite,
                //                   fontSize: 14,
                //                   fontWeight: FontWeight.w400),
                //             ),
                //             icon: const Icon(
                //               Iconsax.textalign_justifyleft,
                //               size: 22,
                //             ),
                //             backgroundColor: Constanst.infoLight,
                //           ),
                //         ),
                //       ),
                const SizedBox(height: 8.0),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                  // height: _panelHeightClosed,
                  height: 670,
                  // height: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, top: 8.0, right: 16.0),
                          child: Container(
                            width: 40,
                            height: 6,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(100)),
                                color: Constanst.colorNeutralBgTertiary),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0, right: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // formHariDanTanggal(),
                            // const SizedBox(width: 8.0),

                            controllerTracking.statusFormPencarian2.value
                                ? IconButton(
                                    icon: Icon(
                                      Iconsax.arrow_left,
                                      color: Constanst.fgPrimary,
                                      size: 24,
                                    ),
                                    onPressed: () {
                                      _panelHeightClosed = 314.0;
                                      controllerTracking.showInputCari2();
                                    },
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: formDepartemen(),
                                  ),
                            controllerTracking.statusFormPencarian2.value
                                ? Expanded(
                                    child: SizedBox(
                                      height: 40,
                                      child: TextFormField(
                                        // controller: controller.searchController,
                                        controller:
                                            controllerTracking.cari.value,
                                        onFieldSubmitted: (value) {
                                          if (controllerTracking
                                                  .cari.value.text ==
                                              "") {
                                            UtilsAlert.showToast(
                                                "Isi form cari terlebih dahulu");
                                          } else {
                                            UtilsAlert.loadingSimpanData(
                                                Get.context!,
                                                "Mencari Data...");
                                            // controller.pencarianDataAktifitas();
                                          }
                                        },
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        style: GoogleFonts.inter(
                                            height: 1.5,
                                            fontWeight: FontWeight.w400,
                                            color: Constanst.fgPrimary,
                                            fontSize: 15),
                                        cursorColor: Constanst.onPrimary,
                                        decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Constanst
                                                .colorNeutralBgSecondary,
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              borderSide: const BorderSide(
                                                color: Colors.transparent,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              borderSide: const BorderSide(
                                                color: Colors.transparent,
                                              ),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    left: 20, right: 20),
                                            hintText: "Cari data...",
                                            hintStyle: GoogleFonts.inter(
                                                height: 1.5,
                                                fontWeight: FontWeight.w400,
                                                color: Constanst.fgSecondary,
                                                fontSize: 14),
                                            prefixIconConstraints:
                                                BoxConstraints.tight(
                                                    const Size(46, 46)),
                                            suffixIconConstraints:
                                                BoxConstraints.tight(
                                                    const Size(46, 46)),
                                            suffixIcon: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0, right: 8),
                                              child: IconButton(
                                                icon: Icon(
                                                  Iconsax.close_circle5,
                                                  color: Constanst.fgSecondary,
                                                  size: 24,
                                                ),
                                                padding: EdgeInsets.zero,
                                                onPressed: () {
                                                  controllerTracking.cari.value
                                                      .clear();
                                                  controllerTracking
                                                      .statusCari.value = false;
                                                  controllerTracking
                                                      .cari.value.text = "";

                                                  controllerTracking
                                                      .getDepartemen(1, "");
                                                },
                                              ),
                                            )),
                                      ),
                                    ),
                                  )
                                : IconButton(
                                    icon: Icon(
                                      Iconsax.search_normal_1,
                                      color: Constanst.fgPrimary,
                                      size: 24,
                                    ),
                                    onPressed: () {
                                      _panelHeightClosed = 750;
                                      controllerTracking.showInputCari2();
                                    },
                                    // controller.toggleSearch,
                                  )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, top: 8.0, right: 16.0),
                        child: Text(
                          "${controller.jumlahData.value} Karyawan",
                          style: GoogleFonts.inter(
                              color: Constanst.fgSecondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      // ElevatedButton(
                      //   onPressed: () async {
                      //     _stopForegroundTask();
                      //     Location location = new Location();
                      //     location.enableBackgroundMode(enable: false);
                      //   },
                      //   child: const Text('berhenti'),
                      // ),
                      controllerTracking.isLoadingTrackingList.value
                          ? const Padding(
                              padding: EdgeInsets.only(top: 200.0),
                              child: Center(
                                child: SizedBox(
                                    width: 35,
                                    height: 35,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 3)),
                              ),
                            )
                          : controllerTracking.statusFormPencarian2.value
                              ? listEmployeeControlGridView()
                              : listEmployeeControlClose(),
                    ],
                  ),
                ),
                // controllerTracking.statusFormPencarian2.value
                //     ? Container()
                // :
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.045,
                  child: Center(
                    child: FloatingActionButton.extended(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      extendedPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      splashColor: Constanst.onPrimary,
                      onPressed: () async {
                        setState(() {
                          panelController.open();
                        });
                      },
                      label: Text(
                        "List",
                        style: GoogleFonts.inter(
                            color: Constanst.colorWhite,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                      icon: const Icon(
                        Iconsax.textalign_justifyleft,
                        size: 22,
                      ),
                      backgroundColor: Constanst.infoLight,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget formHariDanTanggal() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          border: Border.all(color: Constanst.fgBorder)),
      child: InkWell(
        customBorder: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(100))),
        onTap: () async {
          var dateSelect = await showDatePicker(
            context: Get.context!,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            initialDate: controllerTracking.initialDate.value,
          );
          if (dateSelect == null) {
            UtilsAlert.showToast("Tanggal tidak terpilih");
          } else {
            controllerTracking.initialDate.value = dateSelect;
            controllerTracking.tanggalPilihKontrol.value.text =
                Constanst.convertDate("$dateSelect");
            this.controllerTracking.tanggalPilihKontrol.refresh();
          }
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controllerTracking.tanggalPilihKontrol.value.text,
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
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget formDepartemen() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          border: Border.all(color: Constanst.fgBorder)),
      child: InkWell(
        customBorder: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(100))),
        onTap: () {
          controllerTracking.showDataDepartemenAkses('semua');
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controllerTracking.departemen.value.text,
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
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget listEmployeeControl() {
    return ListView.builder(
        physics: controllerTracking.trackingLists.value.length <= 15
            ? AlwaysScrollableScrollPhysics()
            : BouncingScrollPhysics(),
        itemCount: controllerTracking.trackingLists.value.length,
        itemBuilder: (context, index) {
          // var fullName = controllerTracking.employeeKontrol.value[index]
          //         ['full_name'] ??
          //     "";
          // var namaKaryawan = "$fullName";
          // var jobTitle =
          //     controllerTracking.employeeKontrol.value[index]['job_title'];
          // var emId = controllerTracking.employeeKontrol.value[index]['em_id'];
          // var image = controllerTracking.employeeKontrol.value[index]['image'];
          // var alamat =
          //     controllerTracking.employeeKontrol.value[index]['alamat'];
          final data = controllerTracking.trackingLists[index];
          return InkWell(
            onTap: () {
              Get.to(RiwayatLiveTracking(), arguments: {
                'em_id_employee': data.em_id,
              });
              // UtilsAlert.loadingSimpanData(context, "Sedang Memuat");
              // controllerTracking.getEmployeeTerpilih(emId);
              // controllerTracking.getHistoryControl(emId, image, jobTitle);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, top: 12.0, right: 16.0, bottom: 12.0),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                child: data.em_image == ""
                                    ? SvgPicture.asset(
                                        'assets/avatar_default.svg',
                                        width: 40,
                                        height: 40,
                                      )
                                    : CircleAvatar(
                                        radius: 20,
                                        child: ClipOval(
                                          child: ClipOval(
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "${Api.UrlfotoProfile}$data.em_image ",
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
                                                        value: downloadProgress
                                                            .progress),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Container(
                                                color: Colors.white,
                                                child: SvgPicture.asset(
                                                  'assets/avatar_default.svg',
                                                  width: 40,
                                                  height: 40,
                                                ),
                                              ),
                                              fit: BoxFit.cover,
                                              width: 40,
                                              height: 40,
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
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.full_name,
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Constanst.fgPrimary),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    data.em_role,
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: Constanst.fgSecondary),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    width: 3,
                                    height: 3,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(100)),
                                        color: Constanst.fgSecondary),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(100)),
                                        color: data.em_tracking.toString() ==
                                                    "0" ||
                                                data.token_notif == null
                                            ? Constanst.fgSecondary
                                            : Constanst.color5),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    data.em_tracking.toString() == "0" ||
                                            data.token_notif == null
                                        ? 'Offline'
                                        : 'Online',
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: Constanst.fgSecondary),
                                  ),
                                ],
                              ),
                              // const SizedBox(height: 4),
                              // Row(
                              //   children: [
                              //     Icon(
                              //       Iconsax.location_tick,
                              //       size: 18,
                              //       color: Constanst.fgSecondary,
                              //     ),
                              //     const SizedBox(width: 2),
                              //     Expanded(
                              //       child: Text(
                              //         data.em_address,
                              //         overflow: TextOverflow.ellipsis,
                              //         style: GoogleFonts.inter(
                              //             fontWeight: FontWeight.w400,
                              //             fontSize: 14,
                              //             color: Constanst.fgSecondary),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                        Center(
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                            color: Constanst.fgSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child:
                      Divider(height: 0, thickness: 1, color: Constanst.border),
                ),
              ],
            ),
          );
        });
  }

  Widget listEmployeeControlClose() {
    return SizedBox(
      height: 150,
      child: ListView.builder(
          physics: controllerTracking.employeeKontrol.value.length <= 15
              ? const AlwaysScrollableScrollPhysics()
              : const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: controllerTracking.employeeKontrol.value.length,
          itemBuilder: (context, index) {
            var fullName = controllerTracking.employeeKontrol.value[index]
                    ['full_name'] ??
                "";
            var namaKaryawan = "$fullName";
            var jobTitle =
                controllerTracking.employeeKontrol.value[index]['job_title'];
            var emId = controllerTracking.employeeKontrol.value[index]['em_id'];
            var image =
                controllerTracking.employeeKontrol.value[index]['image'];
            var alamat =
                controllerTracking.employeeKontrol.value[index]['alamat'];
            return Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 12.0),
              child: Container(
                width: 150,
                decoration: BoxDecoration(
                    color: controllerTracking.isChecked.value
                        ? Constanst.infoLight1
                        : Constanst.colorWhite,
                    border: Border.all(
                      color: controllerTracking.isChecked.value
                          ? Constanst.infoLight
                          : Constanst.border,
                      width: 1.0,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                child: InkWell(
                  onTap: () {
                    UtilsAlert.loadingSimpanData(context, "Sedang Memuat");
                    controllerTracking.getEmployeeTerpilih(emId);
                    controllerTracking.getHistoryControl(emId, image, jobTitle);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                    child: image == ""
                                        ? SvgPicture.asset(
                                            'assets/avatar_default.svg',
                                            width: 40,
                                            height: 40,
                                          )
                                        : CircleAvatar(
                                            radius: 20,
                                            child: ClipOval(
                                              child: ClipOval(
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      "${Api.UrlfotoProfile}$image",
                                                  progressIndicatorBuilder:
                                                      (context, url,
                                                              downloadProgress) =>
                                                          Container(
                                                    alignment: Alignment.center,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.5,
                                                    width:
                                                        MediaQuery.of(context)
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
                                                      width: 40,
                                                      height: 40,
                                                    ),
                                                  ),
                                                  fit: BoxFit.cover,
                                                  width: 40,
                                                  height: 40,
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
                            SizedBox(
                              height: 20.0,
                              width: 20.0,
                              child: Checkbox(
                                value: controllerTracking.isChecked.value,
                                checkColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                onChanged: (value) {
                                  setState(() {
                                    controllerTracking.toggleCheckboxChecked();
                                  });
                                },
                                activeColor: Constanst.infoLight,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                namaKaryawan.length > 10
                                    ? '${namaKaryawan.substring(0, 10)}...'
                                    : namaKaryawan,
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Constanst.fgPrimary),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                jobTitle.length > 11
                                    ? '${jobTitle.substring(0, 11)}...'
                                    : jobTitle,
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Constanst.fgSecondary),
                              ),
                            ],
                          ),
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

  Widget listEmployeeControlGridView() {
    return Expanded(
      child: GridView.count(
        // physics: controllerTracking.employeeKontrol.value.length <= 15
        //     ? const AlwaysScrollableScrollPhysics()
        //     : const BouncingScrollPhysics(),
        crossAxisCount: 3,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        padding: const EdgeInsets.all(16.0),
        // shrinkWrap: true,
        // scrollDirection: Axis.vertical,
        // reverse: false,
        // cacheExtent: 100.0,
        // primary: true,
        // addAutomaticKeepAlives: true,
        // addRepaintBoundaries: true,
        // addSemanticIndexes: true,
        // List of widgets to display in the grid
        children: List.generate(controllerTracking.employeeKontrol.value.length,
            (index) {
          var fullName = controllerTracking.employeeKontrol.value[index]
                  ['full_name'] ??
              "";
          var namaKaryawan = "$fullName";
          var jobTitle =
              controllerTracking.employeeKontrol.value[index]['job_title'];
          var emId = controllerTracking.employeeKontrol.value[index]['em_id'];
          var image = controllerTracking.employeeKontrol.value[index]['image'];
          var alamat =
              controllerTracking.employeeKontrol.value[index]['alamat'];
          return Container(
            width: 250,
            decoration: BoxDecoration(
                color: controllerTracking.isChecked.value
                    ? Constanst.infoLight1
                    : Constanst.colorWhite,
                border: Border.all(
                  color: controllerTracking.isChecked.value
                      ? Constanst.infoLight
                      : Constanst.border,
                  width: 1.0,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            child: InkWell(
              onTap: () {
                UtilsAlert.loadingSimpanData(context, "Sedang Memuat");
                controllerTracking.getEmployeeTerpilih(emId);
                controllerTracking.getHistoryControl(emId, image, jobTitle);
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                child: image == ""
                                    ? SvgPicture.asset(
                                        'assets/avatar_default.svg',
                                        width: 40,
                                        height: 40,
                                      )
                                    : CircleAvatar(
                                        radius: 20,
                                        child: ClipOval(
                                          child: ClipOval(
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "${Api.UrlfotoProfile}$image",
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
                                                        value: downloadProgress
                                                            .progress),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Container(
                                                color: Colors.white,
                                                child: SvgPicture.asset(
                                                  'assets/avatar_default.svg',
                                                  width: 40,
                                                  height: 40,
                                                ),
                                              ),
                                              fit: BoxFit.cover,
                                              width: 40,
                                              height: 40,
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
                        SizedBox(
                          height: 20.0,
                          width: 20.0,
                          child: Checkbox(
                            value: controllerTracking.isChecked.value,
                            checkColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            onChanged: (value) {
                              setState(() {
                                controllerTracking.toggleCheckboxChecked();
                              });
                            },
                            activeColor: Constanst.infoLight,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            namaKaryawan.length > 9
                                ? '${namaKaryawan.substring(0, 9)}...'
                                : namaKaryawan,
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Constanst.fgPrimary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            jobTitle.length > 10
                                ? '${jobTitle.substring(0, 10)}...'
                                : jobTitle,
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: Constanst.fgSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
