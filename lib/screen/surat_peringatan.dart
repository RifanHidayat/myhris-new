import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:siscom_operasional/controller/surat_peringatan_controller.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';

class SuratPeringatan extends StatefulWidget {
  @override
  _SuratPeringatanState createState() => _SuratPeringatanState();
}

class _SuratPeringatanState extends State<SuratPeringatan> {
  final SuratPeringatanController controller =
      Get.put(SuratPeringatanController());
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    controller.getPeringatan();
    controller.getJumlahNotifikasi();
  }

  void _onRefresh() async {
    controller.getPeringatan();
    controller.getJumlahNotifikasi();
    refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    print(
        'ini surat peringatan lenght : ${controller.peringatanlist.value.length}');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text('Surat Peringatan Pegawai'),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => Text(
                "${controller.peringatanlist.value.length} surat peringatan",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Obx(
                () => SmartRefresher(
                  controller: refreshController,
                  onRefresh: _onRefresh,
                  child: ListView.builder(
                    itemCount: controller.peringatanlist.length,
                    itemBuilder: (context, index) {
                      var list = controller.peringatanlist[index];
                      return ListTile(
                        tileColor: list.isView == 0
                            ? Constanst.colorButton2
                            : Colors.transparent,
                        leading: Icon(
                          Iconsax.sms_notification,
                          color: Colors.red,
                        ),
                        title: Text(list.sp),
                        trailing: Icon(Icons.arrow_forward_ios),
                        subtitle: Text(formatDate(list.approve_date)),
                        onTap: () {
                          if (list.isView == 0) {
                            controller.updateDataNotifSp(list.id, list.em_id);
                            controller.getPeringatan();
                          }
                          controller.getDetail(list.id);
                          var bulanIndo =
                              Constanst.convertGetMonth(list.tgl_surat);
                          controller.bulan.value = bulanIndo;
                          // UtilsAlert.showToast(list.id);
                          Get.to(() => SuratPeringatanDetail(
                                sp: list.sp,
                                nama: list.nama,
                                posisi: list.posisi.toString(),
                                nomor: list.nomor_surat.toString(),
                                hal: list.hal.toString(),
                                tglSrt: list.eff_date.toString(),
                                pelanggaran: list.alasan.toString(),
                                alasan: list.alasan.toString(),
                                diterbitkan: list.diterbitkan_oleh.toString(),
                              ));
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

class SuratPeringatanDetail extends StatelessWidget {
  final String sp;
  final String nama;
  final String posisi;
  final String nomor;
  final String hal;
  final String tglSrt;
  final String diterbitkan;
  final String alasan;
  final String pelanggaran;

  SuratPeringatanDetail({
    required this.nomor,
    required this.hal,
    required this.tglSrt,
    required this.sp,
    required this.posisi,
    required this.nama,
    required this.diterbitkan,
    required this.alasan,
    required this.pelanggaran,
  });
  final SuratPeringatanController controller =
      Get.put(SuratPeringatanController());

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
        title: Text('Detail Surat Peringatan'),
      ),
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
                              'SURAT PERINGATAN',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
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
                        'Melalui surat ini, kami memberitahukan kepada :',
                      ),
                      SizedBox(height: 8),
                      Text('Nama  : $nama'),
                      Text('Divisi    : $posisi'),
                      SizedBox(height: 20),
                      Text(
                        'Telah melakukan Pelanggaran yaitu ${pelanggaran} pada bulan ${controller.bulan.value}, dimana hal tersebut sudah menjadi Peraturan Perusahaan yang harus di taati bersama. Oleh karena itu kami memberikan $sp kepada saudara $nama, dengan ketentuan sebagai berikut : ',
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        sp == 'Surat Peringatan 3'
                            ? '1. Surat ini sekaligus sebagai surat Pemutusan Hubungan Kerja (PHK)'
                            : '1. $sp  ini berlaku 3 (Tiga) bulan sejak surat ini di keluarkan.',
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        sp == 'Surat Peringatan 3'
                            ? '2. Hak-hak Saudara akan diberikan sesuai dengan proporsi, dihitung sampai dengan tanggal surat ini dikeluarkan. Serta Perusahaan tidak akan memberikan referensi kerja sesuai dengan ketentuan perusahaan yang berlaku.'
                            : sp == 'Surat Peringatan 1'
                                ? '2. Jika dalam kurun waktu 3 (Tiga) bulan kedepan sejak surat peringatan pertama di terbitkan saudara didapati kembali melakukan tindakan pelanggaran, maka perusahaan akan memberikan Surat Peringatan ke 2 (Dua) untuk saudara. '
                                : '2. Jika dalam kurun waktu 3 (Tiga) bulan kedepan sejak surat peringatan pertama di terbitkan saudara didapati kembali melakukan tindakan pelanggaran, maka perusahaan akan memberikan Surat Peringatan ke 3 (Dua) untuk saudara.',
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        sp == 'Surat Peringatan 3'
                            ? '3. Saudara wajib mengembalikan seluruh barang-barang milik perusahaan yang Saudara gunakan selama bekerja di perusahaan.  '
                            : sp == 'Surat Peringatan 2'
                                ? '3. Dengan dikeluarkan $sp ini maka saudara akan menerima sanksi yaitu pemotongan hak cuti selama 3 (Tiga) hari.'
                                : '3. Dengan dikeluarkan $sp ini maka saudara akan menerima sanksi yaitu pemotongan hak cuti selama 1 (Satu) hari.',
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      controller.listAlasan.isEmpty || controller.listAlasan.every((e) => e['name'].toString().isEmpty)
                          ? SizedBox()
                          : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                controller.listAlasan.length,
                                (index) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    '${index + 4}. ${controller.listAlasan[index]['name']}',
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                            ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Demikian surat peringatan ini dibuat agar dapat diperhatikan dan ditaati sebaik mungkin oleh yang bersangkutan.',
                        textAlign: TextAlign.start,
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
                                "HRD,",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              SizedBox(
                                height: 47,
                              ),
                              Text(
                                diterbitkan == 'null' ? '': diterbitkan,
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
