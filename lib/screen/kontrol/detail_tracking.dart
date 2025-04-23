import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_operasional/controller/kontrol_controller.dart';
import 'package:siscom_operasional/controller/tracking_controller.dart';
import 'package:siscom_operasional/screen/kontrol/riwayat_tracking.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class DetailTracking extends StatefulWidget {
  String emId;
  String image;
  String jobTitle;
  DetailTracking(
      {Key? key,
      required this.emId,
      required this.image,
      required this.jobTitle})
      : super(key: key);
  @override
  _DetailTrackingState createState() => _DetailTrackingState();
}

class _DetailTrackingState extends State<DetailTracking> {
  // var controller = Get.put(KontrolController());
  final controllerTracking = Get.find<TrackingController>(tag: 'iniScreen');
  final panelController = PanelController();
  double _panelHeightOpen = 0;
  double _panelHeightClosed = 190.0;
  var panel = PanelState.OPEN;
  final double _initFabHeight = 120.0;
  double _fabHeight = 0;
  GoogleMapController? mapController;
  BitmapDescriptor? destinationIcon;

  final Set<Marker> markers = new Set();
  Set<Circle> circles = Set();

  void initState() {
    controllerTracking.isMapsDetail.value = true;
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

    _fabHeight = _initFabHeight;
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //     backgroundColor: Constanst.colorPrimary,
      //     automaticallyImplyLeading: false,
      //     elevation: 2,
      //     flexibleSpace: AppbarMenu1(
      //       title: "Tracking2",
      //       colorTitle: Colors.white,
      //       iconShow: false,
      //       icon: 2,
      //       onTap: () {
      //         Get.back();
      //       },
      //     )),
      // floatingActionButton: Padding(
      //   padding: EdgeInsets.only(bottom: controllerTracking.isMaps.value ? 0.0 : 110.0),
      //   child: SizedBox(
      //     height: MediaQuery.of(context).size.height * 0.045,
      //     child: Padding(
      //       padding: const EdgeInsets.only(left: 24.0),
      //       child: Center(
      //         child: FloatingActionButton.extended(
      //           shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(100),
      //           ),
      //           extendedPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      //           splashColor: Constanst.onPrimary,
      //           onPressed: () async {
      //             setState(() {
      //               controllerTracking.isMaps.value
      //                   ? panelController.close()
      //                   : panelController.open();
      //               controllerTracking.showMaps();
      //             });
      //           },
      //           label: Text(
      //             "Maps",
      //             style: GoogleFonts.inter(
      //                 color: Constanst.colorWhite,
      //                 fontSize: 14,
      //                 fontWeight: FontWeight.w400),
      //           ),
      //           icon: const Icon(
      //             Iconsax.map_15,
      //             size: 22,
      //           ),
      //           backgroundColor: Constanst.infoLight,
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      body: WillPopScope(
        onWillPop: () async {
          Get.back();
          return true;
        },
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeArea(
                bottom: false,
                child: Padding(
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
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Get.to(RiwayatTracking(
                                  emId: widget.emId,
                                  image: widget.image.toString(),
                                  jobTitle: widget.jobTitle,
                                ));
                              },
                              icon: const Icon(Iconsax.document_text),
                              visualDensity:
                                  controllerTracking.isMapsDetail.value
                                      ? VisualDensity.standard
                                      : VisualDensity.compact),
                          controllerTracking.isMapsDetail.value
                              ? Container()
                              : IconButton(
                                  onPressed: () => Get.back(),
                                  icon: const Icon(Iconsax.refresh),
                                ),
                        ],
                      ),
                    ],
                  ),
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
                              child: CircularProgressIndicator(strokeWidth: 3)),
                        ),
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
                            renderPanelSheet: false,
                            // panelSnapping: false,
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
                              _fabHeight = pos *
                                      (_panelHeightOpen - _panelHeightClosed) +
                                  _initFabHeight;
                            }),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
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

  Widget _expandedWidget() {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Riwayat Lokasi',
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Constanst.fgPrimary),
                ),
                formHariDanTanggal(),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: controllerTracking.statusLoadingSubmitLaporan.value
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
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: FloatingActionButton.extended(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                extendedPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                splashColor: Constanst.onPrimary,
                onPressed: () async {
                  setState(() {
                    panelController.close();
                    // controllerTracking.showMapsDetail();
                  });
                },
                label: Text(
                  "Maps",
                  style: GoogleFonts.inter(
                      color: Constanst.colorWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
                icon: const Icon(
                  Iconsax.map_15,
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
                child: FloatingActionButton.extended(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  extendedPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  splashColor: Constanst.onPrimary,
                  onPressed: () async {
                    setState(() {
                      panelController.open();
                      // controllerTracking.showMapsDetail();
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
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  color: Color.fromARGB(127, 0, 0, 0),
                ),
                child: IconButton(
                  onPressed: () {
                    controllerTracking.isMaximizeDetail.value
                        ? _panelHeightClosed = 70.0
                        : _panelHeightClosed = 190.0;
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
          height: 690,
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
                              '11 : 25 : 01',
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Constanst.fgPrimary),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Komplek City Resort Residence Rukan Malibu Blok J. 75-77',
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
    controllerTracking.kontrolHistory.value.length = 5;
    return ListView.builder(
        physics: controllerTracking.kontrolHistory.value.length <= 15
            ? const AlwaysScrollableScrollPhysics()
            : const BouncingScrollPhysics(),
        itemCount: controllerTracking.kontrolHistory.value.length,
        itemBuilder: (context, index) {
          var time = "11 : 25 : 01";
          var alamat =
              "Komplek City Resort Residence Rukan Malibu Blok J. 75-77";
          return InkWell(
            onTap: () {
              // Get.to(DetailTracking(
              //   emId: emId,
              // ));
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
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
                        child: index ==
                                controllerTracking.kontrolHistory.value.length -
                                    1
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
                        child: index ==
                                controllerTracking.kontrolHistory.value.length -
                                    1
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
                        child: index ==
                                controllerTracking.kontrolHistory.value.length -
                                    1
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
                        child: index ==
                                controllerTracking.kontrolHistory.value.length -
                                    1
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
                            time,
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Constanst.fgPrimary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            alamat,
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
}
