import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/pinjaman_controller.dart';
import 'package:siscom_operasional/screen/pinjaman/form_pinjaman.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Pinjaman extends StatefulWidget {
  @override
  _PinjamanState createState() => _PinjamanState();
}

class _PinjamanState extends State<Pinjaman> {
  final controllerPinjaman = Get.put(PinjamanController());
  @override
  void initState() {
    super.initState();
    controllerPinjaman.statusSelected.value = "Semua Status";
    controllerPinjaman.listBenda();
  }

  void showDetailBottomSheet(BuildContext context, Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.7, // Tinggi BottomSheet tetap
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(height: 16),
                  ShowInfo(item: item),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pinjaman Aset'),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () {
                    showBottomStatus(Get.context!);
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    side: BorderSide(color: Constanst.fgBorder),
                  ),
                  child: Row(
                    children: [
                      Obx(() {
                        return Text(
                          controllerPinjaman.statusSelected.value,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Constanst.fgSecondary,
                          ),
                        );
                      }),
                      Icon(
                        Icons.arrow_drop_down,
                        color: Constanst.fgSecondary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controllerPinjaman.pinjamanList.isEmpty) {
                return Center(
                  child: SvgPicture.asset(
                    'assets/empty_screen.svg',
                    height: 228,
                  ),
                );
              }

              return ListView.builder(
                itemCount: controllerPinjaman.pinjamanList.length,
                itemBuilder: (context, index) {
                  var item = controllerPinjaman.pinjamanList[index];
                  return Padding(
                    padding: EdgeInsets.only(left: 12, right: 12, bottom: 12),
                    child: GestureDetector(
                      onTap: () {
                        controllerPinjaman
                            .detailBenda(item['id'].toString())
                            .then((value) {
                          if (value == true) {
                            showDetailBottomSheet(context, item);
                          } else {
                            UtilsAlert.showToast("Data tidak tersedia");
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              width: 1, color: Constanst.greyLight300),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['nomor_ajuan'] ?? 'Unknown Item',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                formatDate(item['tanggal'] ??
                                    'Tanggal tidak tersedia'),
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.note_alt, size: 20),
                                  SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      "Keterangan : ${item['remark'] ?? "catatan tidak ada"}",
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Divider(color: Constanst.greyLight300),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    item['status'] == 'Approve'
                                        ? Iconsax.tick_circle
                                        : item['status'] == 'Rejected'
                                            ? Iconsax.close_circle
                                            : Iconsax.timer,
                                    color: item['status'] == 'Pending'
                                        ? Constanst.color3
                                        : item['status'] == 'Approve'
                                            ? Colors.green
                                            : Colors.red,
                                    size: 20,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    "Status : ${item['status'] ?? "Pending"}",
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      color: Constanst.fgPrimary,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Get.to(FormPinjaman(
            details: [],
          ));
        },
        backgroundColor: Constanst.colorPrimary,
        child: Icon(Icons.add),
      ),
    );
  }

  String formatDate(String date) {
    try {
      final parsedDate = DateTime.parse(date);
      final formattedDate = DateFormat('dd MMM yyyy').format(parsedDate);
      return formattedDate;
    } catch (e) {
      return 'Tanggal tidak tersedia';
    }
  }

  void showBottomStatus(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Pilih Status",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Constanst.fgPrimary,
                        ),
                      ),
                      InkWell(
                          customBorder: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          onTap: () => Navigator.pop(Get.context!),
                          child: Icon(
                            Icons.close,
                            size: 26,
                            color: Constanst.fgSecondary,
                          ))
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
                  child: Obx(() => Column(
                        children: List.generate(
                            controllerPinjaman.dataTypeAjuan.length, (index) {
                          var status = controllerPinjaman.dataTypeAjuan[index];

                          return InkWell(
                            onTap: () {
                              controllerPinjaman.statusSelected.value = status;
                              controllerPinjaman.filter();
                              // controller.changeTypeAjuan(controller
                              //     .dataTypeAjuan.value[index]['nama']);

                              // controller.tempNamaStatus1.value = namaType;
                              Get.back();
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const SizedBox(width: 16),
                                      Text(
                                        status,
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Constanst.fgPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  controllerPinjaman.statusSelected.value == status
                                      ? InkWell(
                                          onTap: () {
                                            controllerPinjaman.statusSelected.value =
                                                status;
                                            controllerPinjaman.filter();
                                            // controller.changeTypeAjuan(controller
                                            //     .dataTypeAjuan.value[index]['nama']);

                                            // controller.tempNamaStatus1.value = namaType;
                                            Get.back();
                                          },
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
                                                        BorderRadius.circular(
                                                            10)),
                                              ),
                                            ),
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            controllerPinjaman.statusSelected.value =
                                                status;
                                            controllerPinjaman.filter();
                                            // controller.changeTypeAjuan(controller
                                            //     .dataTypeAjuan.value[index]['nama']);

                                            // controller.tempNamaStatus1.value = namaType;
                                            Get.back();
                                          },
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
                                                        BorderRadius.circular(
                                                            10)),
                                              ),
                                            ),
                                          ),
                                        )
                                ],
                              ),
                            ),
                          );
                        }),
                      )),
                ),
              ],
            ),
          ),
        );
      },
    ).then((value) {
      print('Bottom sheet closed');
    });
  }
}

class ShowInfo extends StatelessWidget {
  final Map<String, dynamic> item;

  const ShowInfo({required this.item});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PinjamanController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Center(
            child: Text(
              "Detail Pinjaman",
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Constanst.fgPrimary,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 350,
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(
                controller.detailData.value.length,
                (index) {
                  var inites = controller.detailData[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(
                          'Tanggal Pengajuan',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            color: Constanst.fgPrimary,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(
                          formatDate(inites['tgl_ajuan']?.toString() ?? '-'),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'Barang Yang Dipinjam',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            color: Constanst.fgPrimary,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(
                          inites['nama_assets']?.toString() ?? '-',
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'Quantity',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            color: Constanst.fgPrimary,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(
                          inites['qty']?.toString() ?? '-',
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'Catatan',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            color: Constanst.fgPrimary,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(
                          inites['remark']?.toString() ?? '-',
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'Tanggal Pengembalian',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            color: Constanst.fgPrimary,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: inites['tanggal_pengembalian'] == ""
                            ? SizedBox()
                            : Text(
                                formatDate(inites['tanggal_pengembalian']
                                        ?.toString() ??
                                    '-'),
                              ),
                      ),
                      Divider(color: Colors.grey, thickness: 1),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        SizedBox(height: 35),
        item['status'] == "Pending" || item['status'] == null
            ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    print('ini item $item');
                    Get.to(FormPinjaman(
                      isEdit: true,
                      keterangan: item['remark'],
                      tgl: DateFormat('yyyy-MM-dd').format(
                          DateTime.parse(item['tanggal'].toString())),
                      id: item['id'],
                      details: controller.detailData,
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constanst.colorPrimary,
                    padding:
                        EdgeInsets.symmetric(vertical: 14, horizontal: 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Edit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    controller
                        .deleteData(item['id'].toString())
                        .then((value) {
                      if (value == true) {
                        controller.listBenda();
                      } else {
                        UtilsAlert.showToast("Terjadi Kesalahan");
                      }
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.red),
                    padding:
                        EdgeInsets.symmetric(vertical: 14, horizontal: 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Batalkan',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            )
            : SizedBox(),
      ],
    );
  }

  String formatDate(String date) {
    try {
      final parsedDate = DateTime.parse(date);
      final formattedDate = DateFormat('dd MMM yyyy').format(parsedDate);
      return formattedDate;
    } catch (e) {
      return 'Tanggal tidak tersedia';
    }
  }
}
