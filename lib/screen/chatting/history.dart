// ignore_for_file: deprecated_member_use
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_operasional/controller/setting_controller.dart';
import 'package:siscom_operasional/screen/chatting/chat.dart';
import 'package:siscom_operasional/screen/chatting/chat_page.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/appbar_widget.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../controller/chat_controller.dart';

class HistoryChat extends StatefulWidget {
  const HistoryChat({super.key});

  @override
  State<HistoryChat> createState() => _HistoryChatState();
}

class _HistoryChatState extends State<HistoryChat> {
  //final controller = Get.put(SettingController());

  final controller = Get.put(ChatController());
  final WebSocketChannel channel =
      WebSocketChannel.connect(Uri.parse(Api.webSocket));

  void _search() {}

  @override
  void initState() {
    // TODO: implement initState
    // super.initState();
    //          channel.sink.add(jsonEncode({
    //   'type': 'fetchHistory',
    //   'database': AppData.selectedDatabase,
    //   'em_id': AppData.informasiUser![0].em_id,
    //   'search':controller.searchController.text
    // }));
    controller.searchController.clear();
    controller.searchControllerEmployee.clear();
    controller.getEmployee();
    controller.getAllEmployee();
    // channel.stream.listen((message) {
    //   print('ambil data websoket');
    //   final decodedMessage = jsonDecode(message);

    //   // if (decodedMessage['type'] == 'count') {
    //   //  // print('total chat ${decodedMessage['data'][0]['total']}');
    //   //   chatController.jumlahChat.value = decodedMessage['data'][0]['total'];
    //   // }

    //   if (decodedMessage['type'] == 'fetchHistory') {
    //     controller.infoEmployee.value=decodedMessage['data'];
    //     print(' data chat ${decodedMessage['data']}');
    //     // print('total chat ${decodedMessage['data'][0]['total']}');
    //     // chatController.jumlahChat.value = decodedMessage['data'][0]['total'];
    //   }

    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showBottomCustomer(context);
            // Aksi saat tombol ditekan
            print('FAB pressed');
          },
          child: Icon(Icons.add), // Ikon di dalam FAB
          tooltip: 'Add', // Teks tooltip saat FAB di-hover
        ),
        backgroundColor: Constanst.coloBackgroundScreen,
        // appBar: AppBar(
        //     backgroundColor: Constanst.colorPrimary,
        //     elevation: 2,
        //     flexibleSpace: AppbarMenu1(
        //       title: "Info Karyawan",
        //       colorTitle: Colors.white,
        //       colorIcon: Colors.transparent,
        //       icon: 1,
        //       onTap: () {
        //         controller.cari.value.text = "";
        //         Get.back();
        //       },
        //     )),
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
                  // onFieldSubmitted: (value) {
                  // controller.report();
                  // },
                  onChanged: (value) {
                    controller.isLoading.value=true;
                    controller.getEmployee();

                    // print(controller.searchController.text);
                    //controller.pencarianNamaKaryawan(value);
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
                      )),
                ),
              );
            } else {
              return Text(
                "Chat",
                style: GoogleFonts.inter(
                    color: Constanst.fgPrimary,
                    fontWeight: FontWeight.w500,
                    fontSize: 20),
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
                  ? (){
                      controller.toggleSearch();
                      controller.searchController.clear();
                    controller.isLoading.value=true;
                    controller.getEmployee();
                  
                  }
                  : Get.back,
              // onPressed: () {
              //   controller.cari.value.text = "";
              //   Get.back();
              // },
            ),
          ),
        ),
        body: WillPopScope(
          onWillPop: () async {
            controller.cari.value.text = "";
            Get.back();
            return true;
          },
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                // formDepartemen(),
                // const SizedBox(height: 16),
                // pencarianData(),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Text(
                      //   controller.namaDepartemenTerpilih.value,
                      //   style: GoogleFonts.inter(
                      //       fontSize: 16,
                      //       fontWeight: FontWeight.w500,
                      //       color: Constanst.fgPrimary),
                      // ),
                      // Text("${controller.jumlahData.value} Karyawan",
                      //     style: GoogleFonts.inter(
                      //         fontSize: 14,
                      //         fontWeight: FontWeight.w400,
                      //         color: Constanst.fgSecondary)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child:
                      // : infoEmployeeList(),
                      Container(
                    child: Obx(() =>controller.isLoading.value==true?Center(
                              child:
                                  CircularProgressIndicator()): StreamBuilder<List<dynamic>>(
                      stream: getApiDataStream(), // Stream dari API
                      builder: (context, snapshot) {

                        
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || controller.isLoading.value==true) {
                          return Center(
                              child:
                                  CircularProgressIndicator()); // Menunggu data
                        } else {
                          final data = snapshot.data!;
                          return infoEmployeeList(data);
                          // return ListView.builder(
                          //   itemCount: data.length,
                          //   itemBuilder: (context, index) {
                          //     final item = data[index];
                          //     return ListTile(
                          //       title: Text(item
                          //           .toString()), // Sesuaikan dengan struktur data
                          //     );
                          //   },
                          // );
                        }
                      },
                    )),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget pencarianData() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: Constanst.borderStyle5,
            border: Border.all(color: Constanst.colorNonAktif)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Expanded(
              flex: 15,
              child: Padding(
                padding: EdgeInsets.only(top: 7, left: 10),
                child: Icon(Iconsax.search_normal_1),
              ),
            ),
            Expanded(
              flex: 85,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    controller: controller.cari.value,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Cari nama karyawan"),
                    style: GoogleFonts.inter(
                        fontSize: 14.0, height: 1.0, color: Colors.black),
                    onChanged: (value) {
                      // controller.pencarianNamaKaryawan(value);
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget formDepartemen() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            onTap: () {
              //  controller.showDataDepartemenAkses('semua');
            },
            child: Container(
              decoration: BoxDecoration(
                // color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: Constanst.fgBorder, // Border color
                  width: 1, // Border width
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Row(
                  children: [
                    // Text(
                    //   controller.departemen.value.text,
                    //   style: GoogleFonts.inter(
                    //       fontSize: 12.0,
                    //       color: Constanst.fgSecondary,
                    //       fontWeight: FontWeight.w500),
                    // ),
                    const SizedBox(width: 4),
                    Icon(
                      Iconsax.arrow_down_14,
                      size: 16,
                      color: Constanst.fgSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Stream<List<dynamic>> getApiDataStream() async* {
    print("tes stream");
    try {
      final data = await controller.getEmployee();

      yield data; // Kirim data melalui stream
      // Jika ingin melakukan polling secara periodik:
      while (true) {
        await Future.delayed(Duration(seconds: 1)); // Poll setiap 10 detik
        final data = await controller.getEmployee();
        yield data;
      }
    } catch (e) {
      yield []; // Kirimkan daftar kosong atau tangani error dengan cara lain
    }
  }

  Widget infoEmployeeList(data) {
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (context, index) {
          var full_name = data[index]['full_name'];
          var image = data[index]['em_image'];
          var title = data[index]['job_title'];
          var emId = data[index]['em_id'];
          var pesan = data[index]['pesan'];
          var emIdPengirim = data[index]['em_id_pengirim'];
          var emIdPenerima = data[index]['em_id_penerima'];
          var jumlah = data[index]['jumlah'];
          var waktu = data[index]['waktu'];

          return InkWell(
            onTap: () {
              Get.to(
                ChatPage(
                  webSocketChannel:
                      IOWebSocketChannel.connect(Uri.parse(Api.webSocket)),
                  fullNamePenerima: full_name,
                  emIdPengirim: AppData.informasiUser![0].em_id,
                  emIdPenerima: emId,
                  imageProfil: image,
                  title: title,
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          image == ""
                              ? Expanded(
                                  flex: 15,
                                  child: SvgPicture.asset(
                                    'assets/avatar_default.svg',
                                    width: 50,
                                    height: 50,
                                  ),
                                )
                              : Expanded(
                                  flex: 15,
                                  child: CircleAvatar(
                                    radius: 25,
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: "${Api.UrlfotoProfile}$image",
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                Container(
                                          alignment: Alignment.center,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
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
                                            width: 50,
                                            height: 50,
                                          ),
                                        ),
                                        fit: BoxFit.cover,
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                  ),
                                ),
                          Expanded(
                            flex: 60,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "$full_name",
                                        style: GoogleFonts.inter(
                                            fontSize: 16,
                                            color: Constanst.fgPrimary,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        "$waktu",
                                        style: GoogleFonts.inter(
                                            fontSize: 12,
                                            color: Constanst.fgPrimary,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  // Text(
                                  //   "$title",
                                  //   style: GoogleFonts.inter(
                                  //       fontSize: 12,
                                  //       color: Constanst.fgSecondary,
                                  //       fontWeight: FontWeight.w400),
                                  // ),
                                  //  const SizedBox(height: 4),
                                  emId == emIdPengirim
                                      ? Row(
                                          children: [
                                            Icon(Icons.check),
                                            Text(
                                              "$pesan",
                                              style: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  color: Constanst.fgSecondary,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "$pesan",
                                              style: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  color: Constanst.fgSecondary,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            jumlah.toString().trim() == '0'
                                                ? SizedBox()
                                                : CircleAvatar(
                                                    backgroundColor:
                                                        Constanst.colorPrimary,
                                                    radius: 10,
                                                    child: TextLabell(
                                                      text: jumlah.toString(),
                                                      color: Colors.white,
                                                    ),
                                                  )
                                          ],
                                        )
                                ],
                              ),
                            ),
                          ),
                          // Expanded(
                          //     flex: 15,
                          //     child: InkWell(
                          //       onTap: () {
                          //         // chattingCtr.emIdUser.value=emId.toString();
                          //         // Get.to(ChattingPage(title: title,fullName: full_name,image: image,em_id:emId ,));
                          //         // Get.to(
                          //         //   ChatPage(
                          //         //     webSocketChannel:
                          //         //         IOWebSocketChannel.connect(
                          //         //             Uri.parse(Api.webSocket)),
                          //         //     fullNamePenerima: full_name,
                          //         //     emIdPengirim:
                          //         //         AppData.informasiUser![0].em_id,
                          //         //     emIdPenerima: emId,
                          //         //     imageProfil: image,
                          //         //     title: title,
                          //         //   ),
                          //         // );
                          //         print(AppData.informasiUser![0].em_id);
                          //         print(full_name);
                          //         print(emId);
                          //       },
                          //       // child: const Align(
                          //       //     alignment: Alignment.centerRight,
                          //       //     child: Icon(Iconsax.message)),
                          //     ))
                        ],
                      ),
                      const SizedBox(height: 12),
                      Divider(
                        height: 0,
                        thickness: 1,
                        color: Constanst.fgBorder,
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  void showBottomCustomer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight) * 1.35,
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Center(
                      child: Container(
                        height: 6,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          // color: ColorsApp.colorNeutralBorderPrimary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    Obx(
                      () => AppBar(
                        backgroundColor: Colors.white,
                        elevation: 0,
                        leadingWidth: controller.isSearchingEmployee.value ? 50 : 0,
                        titleSpacing: 0,
                        centerTitle:
                            controller.isSearchingEmployee.value ? true : false,
                        title: Obx(() {
                          if (controller.isSearchingEmployee.value) {
                            return SizedBox(
                              height: 40,
                              child: TextFormField(
                                controller: controller.searchControllerEmployee,
                                // onFieldSubmitted: (value) {
                                // controller.report();
                                // },
                                onChanged: (value) {
                                  //controller.pencarianNamaKaryawan(value);
                                  controller.getAllEmployee();
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
                                    fillColor:
                                        Constanst.colorNeutralBgSecondary,
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
                                    contentPadding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    hintText: "Cari data...",
                                    hintStyle: GoogleFonts.inter(
                                        height: 1.5,
                                        fontWeight: FontWeight.w400,
                                        color: Constanst.fgSecondary,
                                        fontSize: 14),
                                    prefixIconConstraints: BoxConstraints.tight(
                                        const Size(46, 46)),
                                    suffixIconConstraints: BoxConstraints.tight(
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
                                        onPressed: controller.clearText,
                                      ),
                                    )),
                              ),
                            );
                          } else {
                            return Padding(
                              padding: EdgeInsets.only(left: 12),
                              child: Text(
                                "Karyawan",
                                style: GoogleFonts.inter(
                                    color: Constanst.fgPrimary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14),
                              ),
                            );
                          }
                        }),
                        actions: [
                          Obx(
                            () => controller.isSearchingEmployee.value
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 16.0),
                                    child: Container(),
                                  )
                                : IconButton(
                                    icon: Icon(Iconsax.search_normal,color: Colors.black,),
                                    onPressed: controller.toggleSearchEmployee,
                                  ),
                          ),
                        ],
                        leading: Obx(
                          () => IconButton(
                            icon: controller.isSearchingEmployee.value
                                ? Icon(Iconsax.arrow_left,color: Colors.black,)
                                : Container(),
                            onPressed: (){
                                controller.toggleSearchEmployee();
                                controller.searchControllerEmployee.clear();
                                controller.getAllEmployee();
                            },
                          
                          ),
                        ),
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                      height: 1,
                      // color: ColorsApp.colorNeutralBorderSecondary,
                    ),
                  ],
                ),
              ),
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Obx(() => controller.isLoadingEnployee.value
                    ? SizedBox(
                      
                        child: SizedBox(
                          height: double.maxFinite,
                          child: Align(
                            alignment: Alignment.center,
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    color: Constanst.onPrimary,
                                   
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  // TextLabel(
                                  //   text: "Memuat data",
                                  //   size: 12.0,
                                  //   font: FontsApp.interMedium,
                                  //   color: ColorsApp.colorBrandPrimary,
                                  // )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: List.generate(
                              controller.infoAllEmployee.length, (index) {
                            var data = controller.infoAllEmployee[index];
                            return Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    // salesOrderController
                                    //     .tempKodeCustomer1.value = data.kode;
                                    // salesOrderController
                                    //     .tempNamaCustomer1.value = data.nama;

                                    // salesOrderController.selectedTermCustomer
                                    //     .value.text = data.term.toString();
                                    // // salesOrderController
                                    // //     .selectedTermCustomer
                                    // //     .refresh();
                                    // salesOrderController
                                    //         .selectedKodeKelompokPelanggan
                                    //         .value =
                                    //     data.kode_kelompok_pelanggan.toString();

                                    // term = data.term;
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 16, right: 16, top: 8),
                                    child: InkWell(
                                      onTap: () {
                                        print('tes');
                                        Get.back();
                                    Get.to(    ChatPage(
                                          webSocketChannel:
                                              IOWebSocketChannel.connect(
                                                  Uri.parse(Api.webSocket)),
                                          fullNamePenerima: data['full_name'],
                                          emIdPengirim:
                                              AppData.informasiUser![0].em_id,
                                          emIdPenerima: data['em_id'],
                                          imageProfil: data['em_image'],
                                          title: data['job_title'],
                                        ));
                                      },
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                data['em_image'] == ""
                                                    ? SvgPicture.asset(
                                                        'assets/avatar_default.svg',
                                                        width: 50,
                                                        height: 50,
                                                      )
                                                    : CircleAvatar(
                                                        radius: 25,
                                                        child: ClipOval(
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl:
                                                                "${Api.UrlfotoProfile}$data['em_image']",
                                                            progressIndicatorBuilder:
                                                                (context, url,
                                                                        downloadProgress) =>
                                                                    Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.5,
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              child: CircularProgressIndicator(
                                                                  value: downloadProgress
                                                                      .progress),
                                                            ),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Container(
                                                              color:
                                                                  Colors.white,
                                                              child: SvgPicture
                                                                  .asset(
                                                                'assets/avatar_default.svg',
                                                                width: 50,
                                                                height: 50,
                                                              ),
                                                            ),
                                                            fit: BoxFit.cover,
                                                            width: 50,
                                                            height: 50,
                                                          ),
                                                        ),
                                                      ),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 16),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      TextLabell(
                                                          text:
                                                              data['full_name']
                                                                  .toString(),
                                                          color: Constanst
                                                              .blackSurface,
                                                          size: 14.0,
                                                          weight:
                                                              FontWeight.w500),
                                                      TextLabell(
                                                          text:
                                                              data['job_title']
                                                                  .toString(),
                                                          color: Constanst
                                                              .secondary,
                                                          size: 12.0,
                                                          weight:
                                                              FontWeight.w500),
                                                      Divider(
                                                        color:
                                                            Constanst.Secondary,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      )),
              ),
            ),
          ),
        );
      },
    ).then((value) {
      print('tidak ada');
    });
  }
}
