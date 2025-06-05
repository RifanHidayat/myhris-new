import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:siscom_operasional/controller/apresiasi_controller.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';

class Apresiasi extends StatefulWidget {
  @override
  _ApresiasiState createState() => _ApresiasiState();
}

class _ApresiasiState extends State<Apresiasi> {
  final ApresiasiController controller = Get.put(ApresiasiController());
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    controller.fetchApresiasi();
    refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    controller.fetchApresiasi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text('Penghargaan'),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Expanded(
              child: Obx(
                () => SmartRefresher(
                  controller: refreshController,
                  onRefresh: _onRefresh,
                  child: ListView.builder(
                    itemCount: controller.apresiasiList.length,
                    itemBuilder: (context, index) {
                      var list = controller.apresiasiList[index];
                      return ListTile(
                        leading: Icon(
                          Iconsax.sms_notification,
                          color: Colors.red,
                        ),
                        title: Text(list['type'].toString()),
                        trailing: Icon(Icons.arrow_forward_ios),
                        subtitle: Text(formatDate(list['tgl_mulai'])),
                        onTap: () {
                          Get.to(ApresiasiDetail(
                              nomor: list['nomor'].toString(),
                              hal: list['perihal_apresiasi'].toString(),
                              tglSrt: list['tgl_mulai'].toString(),
                              reward: list['reward'].toString(),
                              divisi: list['divisi'].toString(),
                              nama: list['full_name'].toString()));
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    String formattedDate = DateFormat('dd MMMM yyyy').format(dateTime);
    return formattedDate;
  }
}

class ApresiasiDetail extends StatelessWidget {
  final String reward;
  final String nama;
  final String divisi;
  final String nomor;
  final String hal;
  final String tglSrt;

  ApresiasiDetail({
    required this.nomor,
    required this.hal,
    required this.tglSrt,
    required this.reward,
    required this.divisi,
    required this.nama,
  });
  final ApresiasiController controller = Get.put(ApresiasiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            },
          ),
          title: Text('Surat Apresiasi'),
          actions: [
            IconButton(
              onPressed: () {
                // var em_id = AppData.informasiUser![0].em_id;
                UtilsAlert.showLoadingIndicator(context);
                controller.generateAndOpenPdf(nomor, hal, nama, divisi, reward, tglSrt);
              },
              icon: Icon(
                Iconsax.document_text,
                color: Constanst.fgPrimary,
                size: 24,
              ),
              padding: EdgeInsets.only(right: 16.0),
            )
          ]),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            return controller.isLoading.value == true
                ? Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'SURAT APRESIASI KARYAWAN',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline),
                            ),
                            Text(
                              'NO : ${nomor == 'null' ? '-' : nomor}',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        'Hal: ${hal}',
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Melalui surat ini, kami menyampaikan apresiasi kepada : ',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      SizedBox(height: 8),
                      Text('Nama  : $nama'),
                      Text('Divisi    : $divisi'),
                      SizedBox(height: 20),
                      Text.rich(
                        TextSpan(
                          text:
                              'Atas dedikasi, kerja keras, kedisiplinan, dan kontribusi luar biasa yang telah diberikan kepada perusahaan dalam hal ',
                          children: [
                            TextSpan(
                              text: hal,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  ' Kami mengapresiasi setinggi-tingginya dan mengucapkan terima kasih.',
                            ),
                          ],
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text.rich(
                        TextSpan(
                          text:
                              'Sebagai bentuk penghargaan atas pencapaian ini, perusahaan memberikan ',
                          children: [
                            TextSpan(
                              text: reward,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  ' sebagai apresiasi atas kerja keras dan loyalitas yang saudara berikan. Profesionalisme saudara memberikan dampak positif terhadap produktivitas tim dan perusahaan.',
                            ),
                          ],
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Kami berharap saudara dapat dan terus mempertahakan semangat kerja. Sehingga menjadi contoh dan motivasi bagi karyawan lainnya.',
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Demikian surat apresiasi ini kami sampaikan. Terima kasih atas dedikasi saudara. ',
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            children: [
                              SizedBox(height: 20),
                              Text(
                                "Hormat Kami,",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 47,
                              ),
                              Text(
                                '(Rudy Haryanto, S.Kom.)',
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                'Direktur Utama',
                                // style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              SizedBox(height: 20),
                              Text(
                                'Jakarta, ${formatDate(tglSrt.toString())}',
                                style: TextStyle(fontSize: 12.0),
                              ),
                              Text(
                                'Yang Bersangkutan',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0),
                              ),
                              SizedBox(height: 50),
                              Text('$nama'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  );
          })),
    );
  }

  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    String formattedDate = DateFormat('dd MMMM yyyy', 'id_ID').format(dateTime);
    return formattedDate;
  }
}
