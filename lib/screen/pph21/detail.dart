import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax/iconsax.dart';
import 'package:path_provider/path_provider.dart';
import 'package:siscom_operasional/components/text.dart';
import 'package:siscom_operasional/controller/pph21.dart';
import 'package:siscom_operasional/controller/slip_gaji.controller.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/helper.dart';
import 'dart:convert';
import 'dart:io';

class DetailPph21Page extends StatefulWidget {
    var month, year;
   DetailPph21Page({super.key,this.month,this.year});

  @override
  State<DetailPph21Page> createState() => _DetailPph21PageState();
}

class _DetailPph21PageState extends State<DetailPph21Page> {
  var controller=Get.put(Pph21Controller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: TextApp.label(
            text: "PPh21", size: 16.0, color: Constanst.blackSurface),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () async{
                     AppData.selectedDatabase.toString();
             
              final directory = await getApplicationDocumentsDirectory();
              final localPath = directory.path;
              controller.downloadFile(
                'https://myhris.siscom.id/custom/${AppData.selectedDatabase.toString()}/sptApi?uid=${base64.encode(utf8.encode(AppData.emailUser))}=&pid=${base64.encode(utf8.encode(AppData.passwordUser))}&eid=${base64.encode(utf8.encode(AppData.informasiUser![0].em_id))}&mid=${base64.encode(utf8.encode(widget.month.toString().padLeft(2, '0')))}&yid=${base64.encode(utf8.encode(widget.year.toString()))}',
                "${localPath}/slip_gaji_${widget.month.toString().padLeft(2, '0')}_${widget.year.toString()}.pdf",
              );
              },
              child: Icon(
              Iconsax.document_download,
                  color: Colors.black,
                ),
              ))
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              bruto(),
              SizedBox(height: 4,),
              potongan(),
               SizedBox(height: 4,),
               perhitunganPphPasal21()
            ],
          ),
        ),
      ),
    );
  }

  Widget bruto() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 8),
            child: Container(
              color: HexColor('#F1F4F9'),
              padding: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
              child: TextApp.label(
                  text: "PENHASILAN BRUTO:",
                  weigh: FontWeight.bold,
                  size: 14.0),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 4, top: 4),
                  child: Column(
                    children: [
                      Row(
                        children: [
                           Expanded(
                              flex: 5,
                              child: Container(
                                child: TextApp.label(text: "1",color: HexColor('#68778D')),
                              )),
                          Expanded(
                              flex: 70,
                              child:
                                  TextApp.label(text: "Gaji Pensiun THT/JHT",color: HexColor('#68778D'))),
                          Expanded(
                              flex: 30,
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: TextApp.label(text: toCurrency(controller.gaji.value.toString()),weigh: FontWeight.bold))),
                                  
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Divider()
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 4, top: 4),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              flex: 5,
                              child: Container(
                                child: TextApp.label(text: "2",color: HexColor('#68778D')),
                              )),
                          Expanded(
                              flex: 70,
                              child: TextApp.label(text: "Tunjangan PPh21",color: HexColor('#68778D'))),
                          Expanded(
                              flex: 30,
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: TextApp.label(
                                      text: toCurrency(controller.tunjanganPph21.value.toString()),
                                      weigh: FontWeight.bold))),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Divider()
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 4, top: 4),
                  child: Column(
                    children: [
                      
                      Row(
                        children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                child: TextApp.label(text: "3",color: HexColor('#68778D')),
                              )),
                          Expanded(
                              flex: 70,
                              child: TextApp.label(text: "TUNJANGAN LAINNYA,UANG LEMBUR DAN SEBAGAINYA",color: HexColor('#68778D'))),
                          Expanded(
                              flex: 30,
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: TextApp.label(text: toCurrency(controller.tunjanganLainhya.value.toString()),weigh: FontWeight.bold))),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Divider()
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 4, top: 4),
                  child: Column(
                    children: [
                      Row(
                        children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                child: TextApp.label(text: "4",color: HexColor('#68778D')),
                              )),
                          Expanded(
                              flex: 70,
                              child: TextApp.label(
                                  text:
                                      "Honarium dan imbalan lain sejenisnya",color: HexColor('#68778D'))),
                          Expanded(
                              flex: 30,
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: TextApp.label(text: toCurrency(controller.honarium.value.toString()),weigh: FontWeight.bold))),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Divider()
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 4, top: 4),
                  child: Column(
                    children: [
                      Row(
                        children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                child: TextApp.label(text: "5",color: HexColor('#68778D')),
                              )),
                          Expanded(
                              flex: 70,
                              child: TextApp.label(
                                  text:
                                      "Premi asuransi  yang dibayar pemberi kerja",color: HexColor('#68778D'))),
                          Expanded(
                              flex: 30,
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: TextApp.label(text: toCurrency(controller.premiasuransi.value.toString()),weigh: FontWeight.bold))),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Divider()
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 4, top: 4),
                  child: Column(
                    children: [
                      Row(
                      
                        children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: TextApp.label(text: "6",color: HexColor('#68778D'))),
                              )),
                          Expanded(
                              flex: 70,
                              child: TextApp.label(
                                  text:
                                      "Penerimaan dalam bentuk natura dan kenikmatan lainnya yang dikenakan pemotongan PPh PASAL 21",color: HexColor('#68778D'))),
                          Expanded(
                              flex: 30,
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: TextApp.label(text: toCurrency(controller.penerimaan.value.toString()),weigh: FontWeight.bold))),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Divider()
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 4, top: 4),
                  child: Column(
                    children: [
                      Row(
                        children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                child: TextApp.label(text: "7",color: HexColor('#68778D')),
                              )),
                          Expanded(
                              flex: 70,
                              child: TextApp.label(
                                  text:
                                      "TANTIUM, BONUS,GRATIFIKASI,JASA,PRODUKSI DAN THR",color: HexColor('#68778D'))),
                          Expanded(
                              flex: 30,
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: TextApp.label(text: toCurrency(controller.tantium.value.toString()),weigh: FontWeight.bold))),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Divider()
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 4, top: 4),
                  child: Column(
                    children: [
                      Row(
                        children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                child: TextApp.label(text: "8",color: HexColor('#68778D')),
                              )),
                          Expanded(
                              flex: 70,
                              child: TextApp.label(
                                  text: "Jumlah Penghasilan bruto",color: HexColor('#68778D'))),
                          Expanded(
                              flex: 30,
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: TextApp.label(text: toCurrency(controller.totalBuroto.value.toString()),weigh: FontWeight.bold))),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Divider()
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

   Widget potongan() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 8),
            child: Container(
              color: HexColor('#F1F4F9'),
              padding: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
              child: TextApp.label(
                  text: "PENHASILAN BRUTO:",
                  weigh: FontWeight.bold,
                  size: 14.0),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Column(
              children: [


                Container(
                  padding: EdgeInsets.only(bottom: 4, top: 4),
                  child: Column(
                    children: [
                      Row(
                        children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                child: TextApp.label(text: "9",color: HexColor('#68778D')),
                              )),
                          Expanded(
                              flex: 70,
                              child: TextApp.label(
                                  text:
                                      "Biaya Jabatan",color: HexColor('#68778D'))),
                          Expanded(
                              flex: 30,
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: TextApp.label(text:toCurrency(controller.biayaJabatan.value.toString()) ,weigh: FontWeight.bold))),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Divider()
                    ],
                  ),
                ),
         
 
                Container(
                  padding: EdgeInsets.only(bottom: 4, top: 4),
                  child: Column(
                    children: [
                      Row(
                        children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                child: TextApp.label(text: "10",color: HexColor('#68778D')),
                              )),
                          Expanded(
                              flex: 70,
                              child: TextApp.label(
                                  text: "Biaya Pensiun",color: HexColor('#68778D'))),
                          Expanded(
                              flex: 30,
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: TextApp.label(text: toCurrency(controller.biayaPensium.value.toString()),weigh: FontWeight.bold))),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Divider()
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 4, top: 4),
                  child: Column(
                    children: [
                      Row(
                        children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                child: TextApp.label(text: "11",color: HexColor('#68778D')),
                              )),
                          Expanded(
                              flex: 70,
                              child: TextApp.label(
                                  text: "Jumlah Pengurang",color: HexColor('#68778D'))),
                          Expanded(
                              flex: 30,
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: TextApp.label(text:toCurrency( controller.jumlahPengurang.value),weigh: FontWeight.bold))),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Divider()
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

     Widget  perhitunganPphPasal21() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 8),
            child: Container(
              color: HexColor('#F1F4F9'),
              padding: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
              child: TextApp.label(
                  text: "Perhitungan PPh Pasal 21:",
                  weigh: FontWeight.bold,
                  size: 14.0),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Column(
              children: [


                Container(
                  padding: EdgeInsets.only(bottom: 4, top: 4),
                  child: Column(
                    children: [
                      Row(
                        children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                child: TextApp.label(text: "12",color: HexColor('#68778D')),
                              )),
                          Expanded(
                              flex: 70,
                              child: TextApp.label(
                                  text:
                                      "Jumlah penghasil netto (8-11)",color: HexColor('#68778D'))),
                          Expanded(
                              flex: 30,
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: TextApp.label(text: toCurrency(controller.jumlahPenghasilNetto.value.toString()),weigh: FontWeight.bold))),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Divider()
                    ],
                  ),
                ),
         
 
                Container(
                  padding: EdgeInsets.only(bottom: 4, top: 4),
                  child: Column(
                    children: [
                      Row(
                        children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                child: TextApp.label(text: "13",color: HexColor('#68778D')),
                              )),
                          Expanded(
                              flex: 70,
                              child: TextApp.label(
                                  text: "Penghasil netto masa sebelumnnya",color: HexColor('#68778D'))),
                          Expanded(
                              flex: 30,
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: TextApp.label(text: toCurrency(controller.penghasilanNettoMasaSebelumnya.value.toString()),weigh: FontWeight.bold))),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Divider()
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 4, top: 4),
                  child: Column(
                    children: [
                      Row(
                        children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                child: TextApp.label(text: "14",color: HexColor('#68778D')),
                              )),
                          Expanded(
                              flex: 70,
                              child: TextApp.label(
                                  text: "Jumlah penghasil netto untuk perhitungan pph pasal 21 (Setahun/disetahunkan)",color: HexColor('#68778D'))),
                          Expanded(
                              flex: 30,
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: TextApp.label(text:toCurrency( controller.jumlahPenghasilNettoUntukPerhitunganPph.value.toString()),weigh: FontWeight.bold))),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Divider()
                    ],
                  ),
                ),
                
                   Container(
                  padding: EdgeInsets.only(bottom: 4, top: 4),
                  child: Column(
                    children: [
                      Row(
                        children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                child: TextApp.label(text: "15",color: HexColor('#68778D')),
                              )),
                          Expanded(
                              flex: 70,
                              child: TextApp.label(
                                  text: "PENGHASILAN TIDAK KENA PAJAK (PTKP)",color: HexColor('#68778D'))),
                          Expanded(
                              flex: 30,
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: TextApp.label(text:toCurrency(controller.ptkp.value.toString()),weigh: FontWeight.bold))),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Divider()
                    ],
                  ),
                ),
                
                   Container(
                  padding: EdgeInsets.only(bottom: 4, top: 4),
                  child: Column(
                    children: [
                      Row(
                        children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                child: TextApp.label(text: "16",color: HexColor('#68778D')),
                              )),
                          Expanded(
                              flex: 70,
                              child: TextApp.label(
                                  text: "PENGAHASILAN KENA PAJAK SETAHUN/DISETAHUNKAN (14-15)",color: HexColor('#68778D'))),
                          Expanded(
                              flex: 30,
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: TextApp.label(text:toCurrency( controller.penghasilanKenapajaksetahun.value.toString()),weigh: FontWeight.bold))),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Divider()
                    ],
                  ),
                ),
                 Container(
                  padding: EdgeInsets.only(bottom: 4, top: 4),
                  child: Column(
                    children: [
                      Row(
                        children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                child: TextApp.label(text: "17",color: HexColor('#68778D')),
                              )),
                          Expanded(
                              flex: 70,
                              child: TextApp.label(
                                  text: "PPH PASAL 21 ATAS PENGHASILAN KENA PAJAK SETAHUN/DISETAHUNKAN",color: HexColor('#68778D'))),
                          Expanded(
                              flex: 30,
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: TextApp.label(text: toCurrency(controller.pphpasal21.value.toString()),weigh: FontWeight.bold))),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Divider()
                    ],
                  ),
                ),
                
                   Container(
                  padding: EdgeInsets.only(bottom: 4, top: 4),
                  child: Column(
                    children: [
                      Row(
                        children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                child: TextApp.label(text: "18",color: HexColor('#68778D')),
                              )),
                          Expanded(
                              flex: 70,
                              child: TextApp.label(
                                  text: "PPh Pasal 21 yang telah dipotong  masa sebelumnnya",color: HexColor('#68778D'))),
                          Expanded(
                              flex: 30,
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: TextApp.label(text: toCurrency(controller.pphPasal21yangtelahdipotong.value),weigh: FontWeight.bold))),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Divider()
                    ],
                  ),
                ),
                 
                   Container(
                  padding: EdgeInsets.only(bottom: 4, top: 4),
                  child: Column(
                    children: [
                      Row(
                        children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                child: TextApp.label(text: "19",color: HexColor('#68778D')),
                              )),
                          Expanded(
                              flex: 70,
                              child: TextApp.label(
                                  text: "PPh  PASAL 21 TERUTANG",color: HexColor('#68778D'))),
                          Expanded(
                              flex: 30,
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: TextApp.label(text: toCurrency(controller.pasal21Terutang.value.toString()),weigh: FontWeight.bold))),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Divider()
                    ],
                  ),
                ),
                    Container(
                  padding: EdgeInsets.only(bottom: 4, top: 4),
                  child: Column(
                    children: [
                      Row(
                        children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                child: TextApp.label(text: "20",color: HexColor('#68778D')),
                              )),
                          Expanded(
                              flex: 70,
                              child: TextApp.label(
                                  text: "PPh PASAL 21 DAN PASAL 26 YANG TELAH DIPOTONG DAN DILUNASI",color: HexColor('#68778D'))),
                          Expanded(
                              flex: 30,
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: TextApp.label(text: toCurrency(controller.pphpasal21DanPasal26.value.toString()),weigh: FontWeight.bold))),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Divider()
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
