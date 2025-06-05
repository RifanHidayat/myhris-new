import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/pinjaman_controller.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';

class FormPinjaman extends StatefulWidget {
  var isEdit, keterangan, tgl, id;
  List details;
  FormPinjaman(
      {this.isEdit = false,
      this.keterangan,
      this.tgl,
      required this.details,
      this.id});
  @override
  _FormPinjamanState createState() => _FormPinjamanState();
}

class _FormPinjamanState extends State<FormPinjaman> {
  String selectedDate = DateFormat('yyyy-MM-dd')
      .format(DateTime.parse(DateTime.now().toString()));
  final TextEditingController alasanController = TextEditingController();
  final TextEditingController keteranganController = TextEditingController();
  final detailsList = Get.put(PinjamanController());

  @override
  void initState() {
    
    // TODO: implement initState
    super.initState();
    detailsList.detailDataList.value = [];
    if (widget.isEdit == false) {
      detailsList.getAssets('');
      detailsList.detailDataList.value = [];
      addNewEntry();
    } else {
      detailsList.getAssets(widget.details[0]['assets_id']);
      selectedDate = widget.tgl;
      keteranganController.text = widget.keterangan.toString();

      widget.details.forEach((item) {
        detailsList.detailDataList.add({
          "keterangan": item['remark'].toString(),
          'assets': item['nama_assets'].toString(),
          'stok': item['stok'].toString(),
          "qty": item['qty'].toString(),
          "qty_ctr": TextEditingController(
            text: item['qty'].toString(),
          ),
          'tanggal_pinjam': DateFormat('yyyy-MM-dd')
              .format(DateTime.parse(item['tgl_ajuan'].toString())),
          'tanggal_pengembalian': DateFormat('yyyy-MM-dd')
              .format(DateTime.parse(item['tanggal_pengembalian'].toString())),
        });
      });
    }
  }

  void updateDetail(int index, String field, dynamic value) {
    setState(() {
      detailsList.assetsBenda[index][field] = value;
    });
  }

  Widget peminjaman(int index) {
    var data = detailsList.detailDataList[index];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Iconsax.textalign_left,
                  size: 24, color: Constanst.fgPrimary),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Keterangan Peminjaman *",
                      style: TextStyle(
                        color: Constanst.fgPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextFormField(
                      controller:
                          TextEditingController(text: data['keterangan']),
                      decoration: const InputDecoration(
                        hintText: 'Tulis disini',
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        data['keterangan'] = value;
                      },
                      style: GoogleFonts.inter(
                        color: Constanst.fgPrimary,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      maxLines: null,
                      minLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget jumlah(int index) {
    var data = detailsList.detailDataList[index];
    var itemName = detailsList.assetsBenda[index]['name'].toString();
    var availableStock = detailsList.assetsBenda[index]['qty'] ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pilih Barang Yang Ingin Dipinjam *",
              style: TextStyle(
                color: Constanst.fgPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 8),
            Obx(() {
              return Container(
                width: MediaQuery.of(context).size.width,
                child: DropdownButton<String>(
                  value: data['assets'],
                  onChanged: (String? newValue) {
                    // setState(() {
                      var filterBenda = detailsList.detailDataList
                          .where(
                            (p0) => p0['assets'] == newValue,
                          )
                          .toList();

                      if (filterBenda.isNotEmpty) {
                        UtilsAlert.showToast("Asset ini sudah dipilih");
                        return;
                      }
                      data['qty_ctr'].text = '1';
                      data['qty'] = '1';

                      data['assets'] = newValue;

                      var filterStok = detailsList.assetsBenda
                          .where(
                            (p0) => p0['name'] == newValue,
                          )
                          .toList();
                      data['stok'] = filterStok[0]['qty'].toString();
                      detailsList.assetsBendaTemp.refresh();
                    // });
                  },
                  items: detailsList.assetsBendaTemp.value
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              );
            })
          ],
        ),
        Divider(color: Colors.grey, thickness: 1),
        Text(
          "Stok Tersedia: ${data['stok']}",
          style: TextStyle(
            color: Constanst.fgPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.add_box,
              size: 26,
              color: Constanst.fgPrimary,
            ),
            const SizedBox(width: 12),
            Text(
              "Jumlah Item Yang Dipinjam *",
              style: TextStyle(
                color: Constanst.fgPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: data['qty_ctr'] as TextEditingController,
          decoration: const InputDecoration(
            hintText: 'Jumlah ',
            border: InputBorder.none,
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          onChanged: (value) {
            int? quantity = int.tryParse(value);
            int? stok = int.tryParse(
                data['stok'].toString() == "" ? "0" : data['stok'].toString());

            if (quantity! <= stok!) {
              data['qty_ctr'].text = value;
              data['qty'] = value;
            } else {
              data['qty_ctr'].text = stok.toString();
              data['qty'] = stok.toString();
              detailsList.detailDataList.refresh();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Jumlah melebihi stok yang tersedia!')),
              );
            }
          },
          style: GoogleFonts.inter(
            color: Constanst.fgPrimary,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          maxLines: 1,
        )
      ],
    );
  }

  void addNewEntry() {
    print('ini assestBenda ${detailsList.assetsBenda.length}');
    print('ini detailList ${detailsList.detailDataList.value.length + 1}');
      detailsList.detailDataList.add({
      "tanggal_pengembalian":
          DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
      "keterangan": "",
      'assets': "",
      'stok': "",
      "qty": "1",
      "qty_ctr": TextEditingController(text: "1"),
      'tanggal_pinjam':
          DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
    });
  }

  @override
  Widget build(BuildContext context) {
    if (detailsList.assetsBenda.isEmpty) {
      detailsList.assetsBenda.add({
        'name': '',
        'qty': 1,
        'model': "",
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Pengajuan Pinjam Aset'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Tanggal *',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.event_note_rounded),
                ),
                controller: TextEditingController(text: selectedDate),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  }
                },
              ),
              Divider(color: Colors.grey, thickness: 1),
              SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Iconsax.textalign_left,
                          size: 24, color: Constanst.fgPrimary),
                      SizedBox(width: 8),
                      Text(
                        "Berikan Keterangan",
                        style: TextStyle(
                          color: Constanst.fgPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    controller: keteranganController,
                    decoration: const InputDecoration(
                      hintText: 'Tulis disini',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      updateDetail(0, 'keterangan_peminjaman', value);
                    },
                    style: GoogleFonts.inter(
                      color: Constanst.fgPrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    maxLines: null,
                    minLines: 3,
                  ),
                  Divider(color: Colors.grey, thickness: 1),
                ],
              ),
              SizedBox(height: 16.0),
              Obx(() {
                return detailsList.assetsBendaTemp.value.isEmpty
                    ? SizedBox()
                    : Column(
                        children: List.generate(
                          detailsList.detailDataList.length,
                          (index) {
                            var data = detailsList.detailDataList[index];
                            return Column(
                              children: [
                                detailsList.detailDataList.length > 1
                                    ? Align(
                                        alignment: Alignment.centerRight,
                                        child: InkWell(
                                          onTap: () {
                                            detailsList.detailDataList.removeAt(
                                                index); // Removes the item at the specific index
                                          },
                                          child: TextLabell(
                                            text: "Hapus",
                                            color: Colors.red,
                                            size: 14,
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                                SizedBox(
                                  height: 12,
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 16.0),
                                  padding: EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    children: [
                                      TextField(
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          labelText: 'Tanggal Pinjam',
                                          border: InputBorder.none,
                                          prefixIcon:
                                              Icon(Icons.event_note_rounded),
                                        ),
                                        controller: TextEditingController(
                                            text: data['tanggal_pinjam']),
                                        onTap: () async {
                                          DateTime? pickedDate =
                                              await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2101),
                                          );
                                          if (pickedDate != null) {
                                            setState(() {
                                              data['tanggal_pinjam'] =
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(pickedDate);
                                              detailsList.detailDataList
                                                  .refresh();
                                            });
                                          }
                                        },
                                      ),
                                      Divider(color: Colors.grey, thickness: 1),
                                      jumlah(index),
                                      SizedBox(height: 8),
                                      Divider(color: Colors.grey, thickness: 1),
                                      peminjaman(index),
                                      // SizedBox(height:8),
                                      Divider(color: Colors.grey, thickness: 1),
                                      TextField(
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          labelText: 'Tanggal Pengembalian',
                                          border: InputBorder.none,
                                          prefixIcon:
                                              Icon(Icons.event_note_rounded),
                                        ),
                                        controller: TextEditingController(
                                            text: data['tanggal_pengembalian']),
                                        onTap: () async {
                                          DateTime? pickedDate =
                                              await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: data['tanggal_pinjam'] !=
                                                    null
                                                ? DateFormat('yyyy-MM-dd')
                                                    .parse(
                                                        data['tanggal_pinjam'])
                                                : DateTime(2000),
                                            lastDate: DateTime(2101),
                                          );
                                          if (pickedDate != null) {
                                            setState(() {
                                              data['tanggal_pengembalian'] =
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(pickedDate);
                                              detailsList.detailDataList
                                                  .refresh();
                                            });
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      );
              }),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (){
                    if (detailsList.assetsBenda.length == detailsList.detailDataList.value.length) {
                     UtilsAlert.showToast('Sudah tidak ada jenis barang yang bisa di pinjam lagi');
                    }else{
                      addNewEntry();
                    }
                  },
                  child: Text(
                    '+  Tambah Peminjaman Barang',
                    style: TextStyle(color: Constanst.colorPrimary),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    backgroundColor: Constanst.colorWhite,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Constanst.colorPrimary),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(16.0),
          ),
          color: Constanst.colorWhite,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2.0),
              blurRadius: 12.0,
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 12.0),
            child: ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Konfirmasi Pengajuan"),
                    content: Text(
                      "Apakah Anda yakin ingin mengirimkan pengajuan ini?",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () {
                          detailsList.detailDataListSimpan.clear();

                          detailsList.detailDataList.forEach((item) {
                            detailsList.detailDataListSimpan.add({
                              "keterangan": item['keterangan'],
                              'assets': item['assets'],
                              'stok': item['stok'],
                              "qty": item['qty_ctr'].text,
                              'tanggal_pinjam': item['tanggal_pinjam'],
                              'tanggal_pengembalian':
                                  item['tanggal_pengembalian'],
                            });
                            // if (item['assets'] == "" ||
                            //     item['qty_ctr'].text == "" ||
                            //     item['qty_ctr'].text == '0' ||
                            //     item['keterangan'] == '') {
                            //   UtilsAlert.showToast("Form * tidak boleh kosong");
                            //   return;
                            // }
                          });
                          if (widget.isEdit == false) {
                            detailsList
                                .simpanData(selectedDate.toString(),
                                    keteranganController.text)
                                .then((value) {
                              if (value == true) {
                                Get.back();
                                UtilsAlert.showToast("succesfuly saved data");
                                // Get.offAll(BerhasilPengajuan(
                                //   dataBerhasil: [],
                                // ));
                              } else {
                                //  UtilsAlert.showToast("Terjadi kesalahan");
                              }
                            });
                          } else {
                            detailsList
                                .updateData(selectedDate.toString(),
                                    keteranganController.text, widget.id)
                                .then((value) {
                              if (value == true) {
                                Get.back();
                                UtilsAlert.showToast("succesfuly saved data");
                                // Get.offAll(BerhasilPengajuan(
                                //   dataBerhasil: [],
                                // ));
                              } else {
                                UtilsAlert.showToast("Terjadi kesalahan");
                              }
                            });
                          }
                          //    Get.to(PinjamanAlatPage());

                          // Navigator.pop(context);
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(content: Text('Pengajuan Dikirim')),
                          // );
                        },
                        child: Text('Kirim'),
                      ),
                    ],
                  ),
                );
              },
              label: Text(
                'Kirim',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Constanst.colorWhite,
                ),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Constanst.colorWhite,
                backgroundColor: Constanst.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
