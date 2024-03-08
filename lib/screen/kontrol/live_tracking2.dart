import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:background_location_tracker/background_location_tracker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:siscom_operasional/controller/tracking_controller.dart';
import 'package:siscom_operasional/main.dart';
import 'package:siscom_operasional/screen/kontrol/riwayat_live_tracking.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:image/image.dart' as img;

class LiveTracking extends StatefulWidget {
  final atten_date;
  final deskripsi;
  final emIdEmployee;
  final status;
  LiveTracking(
      {super.key,
      this.atten_date,
      this.deskripsi,
      this.emIdEmployee,
      this.status});
  @override
  _LiveTrackingState createState() => _LiveTrackingState();
}

class _LiveTrackingState extends State<LiveTracking> {
  // final attenDate = Get.arguments['atten_date'];
  // final deskripsi = Get.arguments['deskripsi'];
  // final emIdEmployee = Get.arguments['emIdEmployee'];
  // final status = Get.arguments['status'];
  final controllerTracking = Get.put(TrackingController());

  Timer? _timer;
  List<String> _locations = [];

  final panelController = PanelController();
  double _panelHeightOpen = 0;
  double _panelHeightClosed = 210.0;
  var panel = PanelState.OPEN;
  final double _initFabHeight = 120.0;
  double _fabHeight = 0;
  BitmapDescriptor? destinationIcon;

  GoogleMapController? mapController;
  // final Set<Marker> markers = new Set();
  Set<Marker> markers = {};
  Set<Circle> circles = Set();
  Set<Polyline> polylines = {};

  final List<LatLng> locations = [
    // const LatLng(-6.142492997069779, 106.73685778167766), // Lokasi awal
    // const LatLng(-6.142549098470421, 106.7356610004584),
    // const LatLng(-6.142271312337554, 106.73567894572908),
    // const LatLng(-6.141886577092146, 106.73568310655186),
    // const LatLng(-6.141121242712904, 106.73570807148857),
    // const LatLng(-6.140174709880735, 106.73571301458774),
    // const LatLng(-6.13707495189963, 106.73576728423541),
    // const LatLng(-6.136851555095482, 106.73559252967858),
    // const LatLng(-6.136636432158509, 106.73562581626084),
    // const LatLng(-6.1366612540258805, 106.73576728424145),
    // const LatLng(-6.135581501098166, 106.73582553576081),
    // const LatLng(-6.135548405188498, 106.73565910284955),
    // const LatLng(-6.134586502844211, 106.73563972002698),
  ];

  Future<void> _getTrackingStatus() async {
    controllerTracking.isTrackingLokasi.value =
        await BackgroundLocationTrackerManager.isTracking();
    setState(() {});
  }

  Future<void> _requestLocationPermission() async {
    // final result = await Permission.locationAlways.request();
    PermissionStatus permissionStatus = await Permission.location.request();

    if (permissionStatus.isGranted) {
      print('GRANTED'); // ignore: avoid_print
    } else {
      print('NOT GRANTED'); // ignore: avoid_print
    }
  }

  Future<void> _requestNotificationPermission() async {
    // final result = await Permission.notification.request();
    PermissionStatus permissionStatus = await Permission.notification.request();

    if (permissionStatus.isGranted) {
      print('GRANTED'); // ignore: avoid_print
    } else {
      print('NOT GRANTED'); // ignore: avoid_print
    }
  }

  Future<void> _getLocations() async {
    final locations = await LocationDao().getLocations();
    setState(() {
      _locations = locations;
    });
  }

  void _startLocationsUpdatesStream() {
    _timer?.cancel();
    _timer = Timer.periodic(
        const Duration(milliseconds: 250), (timer) => _getLocations());
  }

  @override
  void initState() {
    controllerTracking.isLoadingDetailTracking.value = true;
    controllerTracking.isMapsDetail.value = true;
    super.initState();
    controllerTracking.isTrackingLokasi.value = false;
    _getTrackingStatus();
    _startLocationsUpdatesStream();

    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(1, 1)),
      'assets/avatar_default.png',
    ).then((onValue) {
      destinationIcon = onValue;
    });

    // controllerTracking.absenSelfie();

    controllerTracking.getPlaceCoordinate();

    _fabHeight = _initFabHeight;

    controllerTracking.alamatUserFoto.value = "";

    print('status widget ${widget.status}');
    print('status widget ${widget.atten_date}');
    print('status widget ${widget.emIdEmployee}');
    widget.status == "detail"
        ? controllerTracking.detailTracking(
            tanggal: widget.atten_date, emIdEmployee: widget.emIdEmployee)
        : controllerTracking.detailTracking(emIdEmployee: '');

    controllerTracking.detailTrackings.value.forEach((element) {
      var long = element.longlat.split(",")[0];
      var lat = element.longlat.split(",")[1];
      locations.add(LatLng(lat, long));
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Constanst.colorWhite,
      appBar: AppBar(
        backgroundColor: Constanst.colorWhite,
        elevation: 0,
        centerTitle: false,
        title: Text(
          widget.status == "detail" ? 'Detail Live Tracking' : 'Tracking',
          style: GoogleFonts.inter(
              color: Constanst.fgPrimary,
              fontWeight: FontWeight.w500,
              fontSize: 20),
        ),
        leadingWidth: widget.status == "detail" ? 50 : 0,
        leading: widget.status == "detail"
            ? IconButton(
                icon: Icon(
                  Iconsax.arrow_left,
                  color: Constanst.fgPrimary,
                  size: 24,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : Container(),
        actions: [
          widget.status == "detail"
              ? Container()
              : IconButton(
                  icon: Icon(
                    Iconsax.document_text,
                    color: Constanst.fgPrimary,
                    size: 24,
                  ),
                  onPressed: () {
                    Get.to(RiwayatLiveTracking(), arguments: {
                      'em_id_employee': '',
                    });
                  },
                  // controller.toggleSearch,
                ),
          Obx(
            () => controllerTracking.isMapsDetail.value
                ? Container()
                : IconButton(
                    onPressed: () {
                      controllerTracking.getPosisition();
                      mapController?.animateCamera(
                          CameraUpdate.newCameraPosition(CameraPosition(
                                  target: LatLng(
                                      controllerTracking.latUser.value,
                                      controllerTracking.langUser.value),
                                  zoom: 20)
                              //17 is new zoom level
                              ));
                    },
                    icon: Icon(
                      Iconsax.refresh,
                      color: Constanst.fgPrimary,
                      size: 24,
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: controllerTracking.isMapsDetail.value
          ? controllerTracking.bagikanlokasi.value != "tidak aktif" ||
                  widget.status == "detail"
              ? controllerTracking.isLoadingDetailTracking.value
                  ? Container()
                  : SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 24.0),
                        child: Center(
                          child: FloatingActionButton.extended(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            extendedPadding:
                                const EdgeInsets.fromLTRB(16, 0, 16, 0),
                            splashColor: Constanst.onPrimary,
                            onPressed: () async {
                              // Get.to(BagikanLokasi());
                              panelController.close();
                              print(
                                  "panelController ${panelController.close()}");
                            },
                            label: Text(
                              "Maps",
                              style: GoogleFonts.inter(
                                  color: Constanst.colorWhite,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                            icon: const Icon(
                              Iconsax.map_15,
                              size: 22,
                            ),
                            backgroundColor: Constanst.infoLight,
                          ),
                        ),
                      ),
                    )
              : Container()
          : Container(),
      body: Column(
        children: [
          Expanded(
            child:
                //  controllerTracking.latUser.value == 0.0 ||
                //         controllerTracking.langUser.value == 0.0 ||
                //         controllerTracking.alamatUserFoto.value == ""
                //     ? const SizedBox(
                //         height: 50,
                //         child: Center(
                //           child: SizedBox(
                //               width: 35,
                //               height: 35,
                //               child: CircularProgressIndicator(strokeWidth: 3)),
                //         ),
                //       )
                //     :
                Stack(
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
                  renderPanelSheet: false,
                  // panelSnapping: false,
                  // isDraggable: controllerTracking.bagikanlokasi.value ==
                  //         "tidak aktif"
                  //     ? false
                  //     : true,
                  isDraggable: false,
                  backdropOpacity: 0.0,
                  body: _body(),
                  panelBuilder: (sc) => _panel(sc),
                  onPanelOpened: () {
                    controllerTracking.isMapsDetail.value = true;
                    print('object');
                  },
                  onPanelClosed: () {
                    controllerTracking.isMapsDetail.value = false;
                    print('object');
                  },
                  // color: Colors.transparent,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18.0),
                      topRight: Radius.circular(18.0)),
                  onPanelSlide: (double pos) => setState(() {
                    _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                        _initFabHeight;
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _body() {
    return controllerTracking.isLoadingDetailTracking.value
        ? Center(
            child: SizedBox(
                width: 35,
                height: 35,
                child: CircularProgressIndicator(strokeWidth: 3)),
          )
        : SizedBox(
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
                      // target: LatLng(controllerTracking.latUser.value,
                      //     controllerTracking.langUser.value),
                      target: locations.first,
                      zoom: 16.3),
                  // onMapCreated: (GoogleMapController controller) {
                  //   setState(() {
                  //     mapController = controller;
                  //   });
                  // },
                  onMapCreated: onMapCreated,
                  polylines: polylines,
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

  Future<Uint8List> getBytesFromNetwork(
      String url, int width, int height) async {
    http.Response response = await http.get(Uri.parse(url));
    img.Image? image = img.decodeImage(response.bodyBytes);
    img.Image resizedImage =
        img.copyResize(image!, width: width, height: height);
    return Uint8List.fromList(img.encodePng(resizedImage));
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    rootBundle.load("assets/dot.png").then((ByteData data) {
      Uint8List bytes = data.buffer.asUint8List();
      // getBytesFromNetwork(
      //         "https://upload.wikimedia.org/wikipedia/commons/4/43/Paul_Circle.png",
      //         120,
      //         120)
      //     .then((Uint8List bytes2) {
      setState(() {
        markers.add(
          Marker(
            markerId: MarkerId("source"),
            position: locations.first,
            infoWindow: InfoWindow(title: "Source"),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen), // Ikon titik awal
          ),
        );
        for (int i = 0; i < locations.length; i++) {
          markers.add(
            Marker(
              markerId: MarkerId(i.toString()),
              position: locations[i],
              infoWindow: InfoWindow(title: "Location $i"),
              icon: BitmapDescriptor.fromBytes(bytes),
            ),
          );
        }

        // markers.add(
        //   Marker(
        //     markerId: MarkerId("destination"),
        //     position: locations.last,
        //     infoWindow: InfoWindow(title: "Destination"),
        //     icon: BitmapDescriptor.fromBytes(bytes2), // Ikon titik akhir
        //   ),
        // );
        polylines.add(Polyline(
          polylineId: PolylineId('route1'),
          visible: true,
          points: locations,
          color: Colors.blue,
          width: 3,
        ));

        getMarker();
      });
      // });
    });
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
                  ? widget.status == "detail"
                      ? Container(
                          color: Colors.white,
                          height: MediaQuery.of(context).size.height,
                          child: controllerTracking
                                  .isLoadingDetailTracking.value
                              ? Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.4),
                                      child: const SizedBox(
                                          width: 35,
                                          height: 35,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 3)),
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16.0, 0.0, 16.0, 0.0),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(12.0),
                                            ),
                                            border: Border.all(
                                                color: Constanst.fgBorder)),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0.0, 12.0, 16.0, 12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "09:00 - 18:00 WIB | ${Constanst.convertDate6(widget.atten_date)}",
                                                            style: GoogleFonts.inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 16,
                                                                color: Constanst
                                                                    .fgPrimary),
                                                          ),
                                                          const SizedBox(
                                                              height: 4),
                                                          widget.deskripsi == ""
                                                              ? Container()
                                                              : Text(
                                                                  widget
                                                                      .deskripsi,
                                                                  style: GoogleFonts.inter(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize:
                                                                          14,
                                                                      color: Constanst
                                                                          .fgSecondary),
                                                                ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16.0,
                                                    top: 12.0,
                                                    bottom: 8.0),
                                                child: Divider(
                                                  thickness: 1,
                                                  height: 0,
                                                  color: Constanst.border,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 12.0,
                                                            right: 12.0),
                                                    child: Image.asset(
                                                      'assets/tracking_slash.png',
                                                      width: 24,
                                                      height: 24,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Live tracking berakhir",
                                                    style: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 16,
                                                        color: Constanst
                                                            .fgPrimary),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0,
                                          right: 16.0,
                                          top: 16.0,
                                          bottom: 8.0),
                                      child: Text(
                                        "Riwayat Lokasi",
                                        style: GoogleFonts.inter(
                                            color: Constanst.fgPrimary,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18),
                                      ),
                                    ),
                                    Expanded(child: listHistoryControl()),
                                  ],
                                ),
                        )
                      : _expandedWidget()
                  : _previewWidget()
            ],
          ),
        ));
  }

  Widget _expandedWidget() {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.white,
                  border: Border.all(
                      width: 1.0,
                      color: controllerTracking.bagikanlokasi.value !=
                                  "tidak aktif" &&
                              controllerTracking.bagikanlokasi.value !=
                                  "terputus"
                          ? Constanst.infoLight
                          : Constanst.greyLight300)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: InkWell(
                        onTap: () {
                          controllerTracking.bagikanlokasi.value = "terputus";
                        },
                        child: Image.asset(
                          controllerTracking.bagikanlokasi.value == "terputus"
                              ? "assets/no_connection.png"
                              : controllerTracking.bagikanlokasi.value !=
                                      "tidak aktif"
                                  ? "assets/tracking.png"
                                  : 'assets/tracking_slash.png',
                          width: 64,
                          height: 64,
                        ),
                      ),
                    ),
                    Text(
                      controllerTracking.bagikanlokasi.value == "terputus"
                          ? "Live Tracking terputus."
                          : controllerTracking.bagikanlokasi.value !=
                                  "tidak aktif"
                              ? "Live Tracking aktif."
                              : "Live Tracking tidak aktif.",
                      style: GoogleFonts.inter(
                          color: Constanst.fgPrimary,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      controllerTracking.bagikanlokasi.value == "terputus"
                          ? "Klik Aktifkan ulang untuk membagikan lokasi."
                          : controllerTracking.bagikanlokasi.value !=
                                  "tidak aktif"
                              ? "Live Tracking sedang aktif. Lokasi Anda dibagikan secara real-time."
                              : "Anda belum mengaktifkan live tracking. Aktifkan sekarang untuk membagikan lokasi Anda secara real-time.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                          color: Constanst.fgSecondary,
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          controllerTracking.bagikanlokasi.value == "terputus"
              ? Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        controllerTracking.bagikanlokasi.value = "aktif";
                      },
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Constanst.colorWhite,
                          backgroundColor: Constanst.colorPrimary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(color: Constanst.border)),
                          elevation: 0,
                          // padding: EdgeInsets.zero,
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0)),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                        child: Text(
                          'Aktifkan ulang',
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              color: Constanst.colorWhite,
                              fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
          // MaterialButton(
          //   child: const Text('Request location permission'),
          //   onPressed: _requestLocationPermission,
          // ),
          // if (Platform.isAndroid) ...[
          //   const Text(
          //       'Permission on android is only needed starting from sdk 33.'),
          // ],
          // MaterialButton(
          //   child: const Text('Request Notification permission'),
          //   onPressed: _requestNotificationPermission,
          // ),
          // MaterialButton(
          //   child: const Text('Send notification'),
          //   onPressed: () => sendNotification('Hello from another world'),
          // ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: SizedBox(
              width: double.infinity,
              child: Obx(
                () => ElevatedButton(
                  onPressed: () async {
                    if (controllerTracking.bagikanlokasi.value ==
                        "tidak aktif") {
                      print(controllerTracking.latUser.value);
                      print(controllerTracking.langUser.value);
                      // controllerTracking.bagikanlokasi.value = "tidak aktif";
                      // Get.to(BagikanLokasi());
                      // controllerTracking.absenSelfie();
                      controllerTracking.bagikanlokasi.value = "aktif";
                      await BackgroundLocationTrackerManager.startTracking();
                      controllerTracking.updateStatus('1');

                      setState(() =>
                          controllerTracking.isTrackingLokasi.value = true);

                      controllerTracking.detailTracking(emIdEmployee: '');
                    } else {
                      controllerTracking.bagikanlokasi.value = "tidak aktif";
                      // await LocationDao().clear();
                      await _getLocations();
                      await BackgroundLocationTrackerManager.stopTracking();
                      controllerTracking.updateStatus('2');
                      setState(() =>
                          controllerTracking.isTrackingLokasi.value = false);

                      // controllerTracking.latUser.value = 0.0;
                      // controllerTracking.langUser.value = 0.0;
                      // controllerTracking.alamatUserFoto.value = "";
                    }

                    // if (  controllerTracking.isTrackingLokasi.value) {
                    //   controllerTracking.getPosisition();
                    // } else {
                    //   await BackgroundLocationTrackerManager
                    //       .startTracking();
                    //   setState(() =>   controllerTracking.isTrackingLokasi.value = true);
                    // }
                  },
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Constanst.colorWhite,
                      backgroundColor: controllerTracking.bagikanlokasi.value !=
                              "tidak aktif"
                          ? Constanst.colorWhite
                          : Constanst.colorPrimary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(color: Constanst.border)),
                      elevation: 0,
                      // padding: EdgeInsets.zero,
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0)),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                    child: Text(
                      controllerTracking.bagikanlokasi.value != "tidak aktif"
                          ? 'Hentikan Live Tracking'
                          : 'Mulai Live Tracking',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          color: controllerTracking.bagikanlokasi.value !=
                                  "tidak aktif"
                              ? Constanst.color4
                              : Constanst.colorWhite,
                          fontSize: 15),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // MaterialButton(
          //   child: const Text('Stop Tracking'),
          //   onPressed: controllerTracking.isTrackingLokasi.value
          //       ? () async {
          //           await LocationDao().clear();
          //           await _getLocations();
          //           await BackgroundLocationTrackerManager.stopTracking();
          //           setState(() =>
          //               controllerTracking.isTrackingLokasi.value = false);
          //         }
          //       : null,
          // ),
          // const SizedBox(height: 8),
          // Container(
          //   color: Colors.black12,
          //   height: 2,
          // ),
          // const Text('Locations'),
          // MaterialButton(
          //   child: const Text('Refresh locations'),
          //   onPressed: _getLocations,
          // ),
          // Container(
          //   height: 500,
          //   child: Builder(
          //     builder: (context) {
          //       if (_locations.isEmpty) {
          //         return const Text('No locations saved');
          //       }
          //       return ListView.builder(
          //         itemCount: _locations.length,
          //         itemBuilder: (context, index) => Padding(
          //           padding: const EdgeInsets.symmetric(
          //             horizontal: 16,
          //             vertical: 12,
          //           ),
          //           child: Text(
          //             _locations[index],
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // ),

          controllerTracking.bagikanlokasi.value != "tidak aktif"
              ? Obx(
                  () => controllerTracking.isLoadingDetailTracking.value
                      ? const Padding(
                          padding: EdgeInsets.only(top: 200.0),
                          child: Center(
                            child: SizedBox(
                                width: 35,
                                height: 35,
                                child:
                                    CircularProgressIndicator(strokeWidth: 3)),
                          ),
                        )
                      : Expanded(child: listHistoryControl()),
                )
              : Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Constanst.infoLight1,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Iconsax.info_circle5,
                            size: 24,
                            color: Constanst.colotStateInfoBg,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Informasi",
                                    style: GoogleFonts.inter(
                                        color: Constanst.fgPrimary,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "SISCOM HRIS mengumpulkan data aktivitas lokasi perangkat Anda selama fitur Tracking aktif.",
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.inter(
                                        color: Constanst.fgSecondary,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _previewWidget() {
    return Column(
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
        Padding(
          padding: const EdgeInsets.only(right: 16.0, left: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  color: Color.fromARGB(0, 0, 0, 0),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Iconsax.maximize_4,
                    size: 24,
                    color: Color.fromARGB(0, 0, 0, 0),
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: FloatingActionButton.extended(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    extendedPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    splashColor: Constanst.onPrimary,
                    onPressed: () async {
                      setState(() {
                        panelController.open();
                        // controller.showMapsDetail();
                      });
                    },
                    label: Text(
                      "List",
                      style: GoogleFonts.inter(
                          color: Constanst.colorWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    icon: const Icon(
                      Iconsax.textalign_justifyleft,
                      size: 22,
                    ),
                    backgroundColor: Constanst.infoLight,
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  color: Color.fromARGB(127, 0, 0, 0),
                ),
                child: IconButton(
                  onPressed: () {
                    controllerTracking.isMaximizeDetail.value
                        ? _panelHeightClosed = 70.0
                        : _panelHeightClosed = 210.0;
                    controllerTracking.showMaximizeDetail();
                  },
                  icon: Icon(
                    controllerTracking.isMaximizeDetail.value
                        ? Iconsax.maximize_4
                        : Iconsax.maximize_3,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 26.0),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
          // height: _panelHeightClosed,
          // height: 1090,
          // height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 6,
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100)),
                        color: Constanst.colorNeutralBgTertiary),
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(100)),
                              color: Constanst.infoLight1),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(100)),
                                  color: Constanst.infoLight),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 1.0, bottom: 1.0),
                          child: Container(
                            color: Constanst.fgBorder,
                            width: 2,
                            height: 4,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 1.0, bottom: 1.0),
                          child: Container(
                            color: Constanst.fgBorder,
                            width: 2,
                            height: 4,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 1.0, bottom: 1.0),
                          child: Container(
                            color: Constanst.fgBorder,
                            width: 2,
                            height: 4,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 1.0, bottom: 1.0),
                          child: Container(
                            color: Constanst.fgBorder,
                            width: 2,
                            height: 4,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, bottom: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controllerTracking.detailTrackings.first.time
                                  .replaceFirst(':', ' : '),
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Constanst.fgPrimary),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              controllerTracking.detailTrackings.first.address,
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Constanst.fgSecondary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget listHistoryControl() {
    return ListView.builder(
        // physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: controllerTracking.detailTrackings.length,
        itemBuilder: (context, index) {
          // var alamat =
          //     "Komplek City Resort Residence Rukan Malibu Blok J. 75-77";
          // var lokasi = _locations[index];
          // List<String> splitData = lokasi.split("*");
          // var tanggal_waktu = splitData[0];
          // var latitude = splitData[1];
          // var longitude = splitData[2];

          // String time =
          //     DateFormat('HH : mm : ss').format(DateTime.parse(tanggal_waktu));

          final data = controllerTracking.detailTrackings[index];
          // print("long ${data.longlat.split(",")[0]}");
          // print("lat ${data.longlat.split(",")[1]}");
          locations.add(LatLng(double.parse(data.longlat.split(",")[1]),
              double.parse(data.longlat.split(",")[0])));

          // print('Address1: $address1');
          // final lat = 37.7749; // Contoh latitude
          // final lng = -122.4194; // Contoh longitude

          // final address = controllerTracking.getAddressFromLatLng(
          //     double.parse(latitude), double.parse(longitude));
          // print('Address: $address');

          return InkWell(
            onTap: () {
              // Get.to(DetailTracking(
              //   emId: emId,
              // ));
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 0.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 1.0, bottom: 1.0),
                        child: index == 0
                            ? Container(
                                height: 4,
                              )
                            : Container(
                                color: Constanst.fgBorder,
                                width: 2,
                                height: 4,
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 1.0, bottom: 1.0),
                        child: index == 0
                            ? Container(
                                height: 4,
                              )
                            : Container(
                                color: Constanst.fgBorder,
                                width: 2,
                                height: 4,
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 1.0, bottom: 1.0),
                        child: index == 0
                            ? Container(
                                height: 4,
                              )
                            : Container(
                                color: Constanst.fgBorder,
                                width: 2,
                                height: 4,
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 1.0, bottom: 1.0),
                        child: index == 0
                            ? Container(
                                height: 4,
                              )
                            : Container(
                                color: Constanst.fgBorder,
                                width: 2,
                                height: 4,
                              ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(100)),
                            color: index == 0
                                ? Constanst.infoLight1
                                : Constanst.colorNeutralBgSecondary),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(100)),
                                color: index == 0
                                    ? Constanst.infoLight
                                    : Constanst.colorNeutralFgTertiary),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 1.0, bottom: 1.0),
                        child: index == 11 - 1
                            ? Container(
                                height: 4,
                              )
                            : Container(
                                color: Constanst.fgBorder,
                                width: 2,
                                height: 4,
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 1.0, bottom: 1.0),
                        child: index == 11 - 1
                            ? Container(
                                height: 4,
                              )
                            : Container(
                                color: Constanst.fgBorder,
                                width: 2,
                                height: 4,
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 1.0, bottom: 1.0),
                        child: index == 11 - 1
                            ? Container(
                                height: 4,
                              )
                            : Container(
                                color: Constanst.fgBorder,
                                width: 2,
                                height: 4,
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 1.0, bottom: 1.0),
                        child: index == 11 - 1
                            ? Container(
                                height: 4,
                              )
                            : Container(
                                color: Constanst.fgBorder,
                                width: 2,
                                height: 4,
                              ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, bottom: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.time.replaceFirst(':', ' : '),
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Constanst.fgPrimary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            data.address,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Constanst.fgSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Icon(Iconsax.arrow_right_3,
                      color: Constanst.fgSecondary, size: 20),
                ],
              ),
            ),
          );
        });
  }
}
