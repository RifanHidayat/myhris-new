// ignore_for_file: deprecated_member_use
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/kasbon_controller.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/month_year_picker.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';

class FormKasbon extends StatefulWidget {
  List? dataForm;
  FormKasbon({Key? key, this.dataForm}) : super(key: key);
  @override
  _FormKasbonState createState() => _FormKasbonState();
}

class _FormKasbonState extends State<FormKasbon> {
  var controller = Get.put(KasbonController());

  @override
  void initState() {
    print(widget.dataForm![0]);
    if (widget.dataForm![1] == true) {
      // controller.selectedTypeKasbon.value = widget.dataForm![0]['type'];

      controller.tanggalKasbon.value.text =
          Constanst.convertDate("${widget.dataForm![0]['tanggal_pinjaman']}");
      controller.totalPinjaman.value.text =
          "${widget.dataForm![0]['total_loan']}";

      // String yang ingin dipisahkan
      String date = widget.dataForm![0]['periode'] ?? "2024-01";
      // Memisahkan string berdasarkan karakter "-"
      List<String> parts = date.split('-');
      String year = parts[0];
      String month = parts[1];

      controller.tahunSelectedSearchHistory.value = year;
      // controller.bulanSelectedSearchHistory.value = month;

      // var convertDariJam = widget.dataForm![0]['dari_jam'].split(":");
      // var convertSampaiJam = widget.dataForm![0]['sampai_jam'].split(":");
      // var hasilDarijam = "${convertDariJam[0]}:${convertDariJam[1]}";
      // var hasilSampaijam = "${convertSampaiJam[0]}:${convertSampaiJam[1]}";
      // controller.dariJam.value.text = hasilDarijam;
      // controller.sampaiJam.value.text = hasilSampaijam;
      controller.catatan.value.text = widget.dataForm![0]['description'];
      controller.statusForm.value = true;
      controller.idpengajuanKasbon.value = "${widget.dataForm![0]['id']}";
      controller.emIdDelegasi.value = "${widget.dataForm![0]['em_delegation']}";
      controller.durasiCicilan.value.text =
          widget.dataForm![0]['durasi_cicil'].toString();
      // controller.checkingDelegation(widget.dataForm![0]['em_delegation']);
      controller.nomorAjuan.value.text =
          "${widget.dataForm![0]['nomor_ajuan']}";

      // controller.id.value = widget.dataForm![0]['tanggal_pinjaman'];
    } else {
      // controller.selectedTypeKasbon.value = "";
      // controller.tanggalKasbon.value.text = "";
      controller.getTypeKasbon();
      controller.removeAll();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constanst.coloBackgroundScreen,
      appBar: AppBar(
        backgroundColor: Constanst.colorWhite,
        elevation: 0,
        leadingWidth: 50,
        titleSpacing: 0,
        centerTitle: true,
        title: Text(
          "Pengajuan Kasbon",
          style: GoogleFonts.inter(
              color: Constanst.fgPrimary,
              fontWeight: FontWeight.w500,
              fontSize: 20),
        ),
        leading: IconButton(
          icon: Icon(
            Iconsax.arrow_left,
            color: Constanst.fgPrimary,
            size: 24,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: WillPopScope(
          onWillPop: () async {
            Get.back();
            return true;
          },
          child: SafeArea(
            child: Obx(
              () => Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Constanst.fgBorder,
                          width: 1.0,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12))),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // controller.viewTypeKasbon.value == false
                        //     ? const SizedBox()
                        //     : formType(),
                        formHariDanTanggal(),
                        formTotalPinjaman(),
                        pickDate(),
                        durasiCician(),
                        formCatatan(),
                      ],
                    ),
                  )),
            ),
          )),
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
              )
            ]),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
          child: ElevatedButton(
            onPressed: () {
              print("tes ${controller.dariJam.value.text.toString()}");
              // TimeOfDay _startTime = TimeOfDay(
              //     hour: int.parse(
              //         controller.dariJam.value.text.toString().split(":")[0]),
              //     minute: int.parse(
              //         controller.dariJam.value.text.toString().split(":")[1]));
              // TimeOfDay _endTime = TimeOfDay(
              //     hour: int.parse(
              //         controller.sampaiJam.value.text.toString().split(":")[0]),
              //     minute: int.parse(controller.sampaiJam.value.text
              //         .toString()
              //         .split(":")[1]));

              // if (_endTime.hour >= _startTime.hour) {
              // if (_endTime.hour == _startTime.hour) {
              //   if (_endTime.minute < _startTime.minute) {
              //     UtilsAlert.showToast(
              //         "waktu yang dimasukan tidak valid, coba periksa lagi waktu kasbonmu");

              //     return;
              //   }
              // }
              print("masuk sini");
              controller.validasiKirimPengajuan();
              // } else {
              //   UtilsAlert.showToast(
              //       "waktu yang dimasukan tidak valid, coba periksa lagi waktu kasbonmu");
              // }

              //
            },
            style: ElevatedButton.styleFrom(
                foregroundColor: Constanst.colorWhite,
                backgroundColor: Constanst.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 12)),
            child: Text(
              'Kirim',
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Constanst.colorWhite),
            ),
          ),
        ),
      ),
    );
  }

  // Widget formType() {
  //   return InkWell(
  //     customBorder: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topRight: Radius.circular(12.0),
  //         topLeft: Radius.circular(12.0),
  //       ),
  //     ),
  //     onTap: () async {
  //       await showMenu(
  //         context: context,
  //         position: const RelativeRect.fromLTRB(16, 123, 16, 0),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(8.0),
  //         ),
  //         // initialValue: controller.selectedTypeKasbon.value,
  //         items: controller.typeKasbon.value
  //             .map<PopupMenuItem<String>>((String value) {
  //           return PopupMenuItem<String>(
  //             value: value,
  //             padding: EdgeInsets.zero,
  //             onTap: () => controller.selectedTypeKasbon.value = value,
  //             child: Padding(
  //               padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
  //               child: Text(
  //                 value,
  //                 style: GoogleFonts.inter(
  //                     fontSize: 14,
  //                     fontWeight: FontWeight.w500,
  //                     color: Constanst.fgPrimary),
  //               ),
  //             ),
  //           );
  //         }).toList(),
  //       );
  //     },
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.all(16.0),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             crossAxisAlignment: CrossAxisAlignment.end,
  //             children: [
  //               Row(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   const Icon(
  //                     Iconsax.note_2,
  //                     size: 26,
  //                   ),
  //                   const SizedBox(width: 12),
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         "Tipe Kasbon*",
  //                         style: GoogleFonts.inter(
  //                             fontSize: 14,
  //                             fontWeight: FontWeight.w400,
  //                             color: Constanst.fgPrimary),
  //                       ),
  //                       const SizedBox(height: 8),
  //                       Text(
  //                         controller.selectedTypeKasbon.value,
  //                         style: GoogleFonts.inter(
  //                             fontSize: 16,
  //                             fontWeight: FontWeight.w500,
  //                             color: Constanst.fgPrimary),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //               Icon(Iconsax.arrow_down_1,
  //                   size: 20, color: Constanst.fgPrimary),
  //             ],
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.only(left: 16.0, right: 16.0),
  //           child: Divider(
  //             height: 0,
  //             thickness: 1,
  //             color: Constanst.fgBorder,
  //           ),
  //         ),
  //         // Container(
  //         //   height: 50,
  //         //   decoration: BoxDecoration(
  //         //       color: Colors.white,
  //         //       borderRadius: Constanst.borderStyle1,
  //         //       border: Border.all(
  //         //           width: 0.5,
  //         //           color: const Color.fromARGB(255, 211, 205, 205))),
  //         //   child: Padding(
  //         //     padding: const EdgeInsets.all(8.0),
  //         //     child: DropdownButtonHideUnderline(
  //         //       child: DropdownButton<String>(
  //         //         isDense: true,
  //         //         autofocus: true,
  //         //         focusColor: Colors.grey,
  //         //         items: controller.typeKasbon.value
  //         //             .map<DropdownMenuItem<String>>((String value) {
  //         //           return DropdownMenuItem<String>(
  //         //             value: value,
  //         //             child: Text(
  //         //               value,
  //         //               style: GoogleFonts.inter(fontSize: 14),
  //         //             ),
  //         //           );
  //         //         }).toList(),
  //         //         value: controller.selectedTypeKasbon.value,
  //         //         onChanged: (selectedValue) {
  //         //           controller.selectedTypeKasbon.value = selectedValue!;
  //         //         },
  //         //         isExpanded: true,
  //         //       ),
  //         //     ),
  //         //   ),
  //         // ),
  //       ],
  //     ),
  //   );
  // }

  Widget formHariDanTanggal() {
    return InkWell(
      onTap: () async {
        // DateTime now = DateTime.now();
        // DateTime firstDateOfMonth =
        //     DateTime(now.year, now.month + 0, 1);
        // DateTime lastDayOfMonth =
        //     DateTime(now.year, now.month + 1, 0);
        var dateSelect = await showDatePicker(
          context: Get.context!,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          initialDate: controller.initialDate.value,
          cancelText: 'Batal',
          confirmText: 'Simpan',
          builder: (context, child) {
            return Theme(
              data: ThemeData(
                colorScheme: ColorScheme.dark(
                  primary: Constanst.onPrimary,
                  onPrimary: Constanst.colorWhite,
                  onSurface: Constanst.fgPrimary,
                  surface: Constanst.colorWhite,
                ),
                // useMaterial3: settings.useMaterial3,
                visualDensity: VisualDensity.standard,
                dialogTheme: const DialogTheme(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)))),
                primaryColor: Constanst.fgPrimary,
                textTheme: TextTheme(
                  titleMedium: GoogleFonts.inter(
                    color: Constanst.fgPrimary,
                  ),
                ),
                dialogBackgroundColor: Constanst.colorWhite,
                canvasColor: Colors.white,
                hintColor: Constanst.onPrimary,
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: Constanst.onPrimary,
                  ),
                ),
              ),
              child: child!,
            );
          },
        );
        if (dateSelect == null) {
          UtilsAlert.showToast("Tanggal tidak terpilih");
        } else {
          controller.initialDate.value = dateSelect;
          controller.tanggalKasbon.value.text =
              Constanst.convertDate("$dateSelect");
          print(controller.tanggalKasbon.value.text);
          this.controller.tanggalKasbon.refresh();
          // DateTime now = DateTime.now();
          // if (now.month == dateSelect.month) {
          //   controller.initialDate.value = dateSelect;
          //   controller.tanggalKasbon.value.text =
          //       Constanst.convertDate("$dateSelect");
          //   this.controller.tanggalKasbon.refresh();
          // } else {
          //   UtilsAlert.showToast(
          //       "Tidak bisa memilih tanggal di luar bulan ini");
          // }
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Iconsax.calendar_2,
                      size: 26,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tanggal Pinjaman *",
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Constanst.fgPrimary),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          controller.tanggalKasbon.value.text,
                          style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Constanst.fgPrimary),
                        ),
                      ],
                    ),
                  ],
                ),
                Icon(Iconsax.arrow_down_1,
                    size: 20, color: Constanst.fgPrimary),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Divider(
              height: 0,
              thickness: 1,
              color: Constanst.fgBorder,
            ),
          ),
        ],
      ),
    );
  }

  Widget formTotalPinjaman() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Divider(
            height: 0,
            thickness: 1,
            color: Constanst.fgBorder,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Iconsax.money_tick, size: 24),
                const SizedBox(width: 12),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Pinjaman *",
                      style: GoogleFonts.inter(
                          color: Constanst.fgPrimary,
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
                    ),
                    TextField(
                      inputFormatters: [
                        CurrencyTextInputFormatter.currency(
                          locale: 'id',
                          symbol: 'Rp ',
                          decimalDigits: 0,
                        )
                      ],
                      controller: controller.totalPinjaman.value,
                      keyboardType:
                          const TextInputType.numberWithOptions(signed: true),
                      textInputAction: TextInputAction.done,
                      onSubmitted: (value) {
                        controller.totalPinjaman.value.text = value;
                        this.controller.totalPinjaman.refresh();
                      },
                      decoration: InputDecoration(
                        hintText: 'Rp ',
                        border: InputBorder.none,
                        hintStyle: GoogleFonts.inter(
                            color: Constanst.fgSecondary,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                      maxLines: null,
                      style: GoogleFonts.inter(
                          color: Constanst.fgPrimary,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    )
                  ],
                ))
              ],
            ),
          ),
          Divider(
            height: 0,
            thickness: 1,
            color: Constanst.fgBorder,
          ),
        ],
      ),
    );
  }

  Widget durasiCician() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Divider(
            height: 0,
            thickness: 1,
            color: Constanst.fgBorder,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Iconsax.money_tick, size: 24),
                const SizedBox(width: 12),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Durasi Cicilan*",
                      style: GoogleFonts.inter(
                          color: Constanst.fgPrimary,
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
                    ),
                    TextField(
                      // inputFormatters: [
                      //   CurrencyTextInputFormatter(
                      //     locale: 'id',
                      //     symbol: 'Rp ',
                      //     decimalDigits: 0,
                      //   )
                      // ],
                      controller: controller.durasiCicilan.value,
                      keyboardType:
                          const TextInputType.numberWithOptions(signed: true),
                      textInputAction: TextInputAction.done,
                      onSubmitted: (value) {
                        controller.durasiCicilan.value.text = value;
                        this.controller.durasiCicilan.refresh();
                      },
                      decoration: InputDecoration(
                        hintText: '0',
                        border: InputBorder.none,
                        hintStyle: GoogleFonts.inter(
                            color: Constanst.fgSecondary,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                      maxLines: null,
                      style: GoogleFonts.inter(
                          color: Constanst.fgPrimary,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    )
                  ],
                ))
              ],
            ),
          ),
          Divider(
            height: 0,
            thickness: 1,
            color: Constanst.fgBorder,
          ),
        ],
      ),
    );
  }
  // Widget formJam() {
  //   return Row(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     children: [
  //       Expanded(
  //         child: InkWell(
  //           onTap: () {
  //             showTimePicker(
  //               context: Get.context!,
  //               initialTime: TimeOfDay.now(),
  //               // initialEntryMode: TimePickerEntryMode.input,
  //               builder: (context, child) {
  //                 return MediaQuery(
  //                   data: MediaQuery.of(context)
  //                       .copyWith(alwaysUse24HourFormat: true),
  //                   child: Theme(
  //                     data: ThemeData(
  //                       colorScheme: ColorScheme.light(
  //                         primary: Constanst.onPrimary,
  //                       ),
  //                       // useMaterial3: settings.useMaterial3,
  //                       dialogTheme: const DialogTheme(
  //                           shape: RoundedRectangleBorder(
  //                               borderRadius:
  //                                   BorderRadius.all(Radius.circular(16)))),
  //                       primaryColor: Constanst.fgPrimary,
  //                       textTheme: TextTheme(
  //                         titleMedium: GoogleFonts.inter(
  //                           color: Constanst.fgPrimary,
  //                         ),
  //                       ),
  //                       dialogBackgroundColor: Constanst.colorWhite,
  //                       canvasColor: Colors.white,
  //                       hintColor: Constanst.onPrimary,
  //                       textButtonTheme: TextButtonThemeData(
  //                         style: TextButton.styleFrom(
  //                           foregroundColor: Constanst.onPrimary,
  //                         ),
  //                       ),
  //                     ),
  //                     child: child!,
  //                   ),
  //                 );
  //               },
  //             ).then((value) {
  //               if (value == null) {
  //                 UtilsAlert.showToast('gagal pilih jam');
  //               } else {
  //                 var convertJam =
  //                     value.hour <= 9 ? "0${value.hour}" : "${value.hour}";
  //                 var convertMenit = value.minute <= 9
  //                     ? "0${value.minute}"
  //                     : "${value.minute}";
  //                 controller.dariJam.value.text = "$convertJam:$convertMenit";
  //                 this.controller.dariJam.refresh();
  //               }
  //             });
  //           },
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.all(16.0),
  //                 child: Row(
  //                   crossAxisAlignment: CrossAxisAlignment.end,
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Row(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         const Icon(
  //                           Iconsax.clock,
  //                           size: 26,
  //                         ),
  //                         const SizedBox(width: 12),
  //                         Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Text(
  //                               "Dari jam*",
  //                               style: GoogleFonts.inter(
  //                                   fontSize: 14,
  //                                   fontWeight: FontWeight.w400,
  //                                   color: Constanst.fgPrimary),
  //                             ),
  //                             const SizedBox(height: 8),
  //                             Text(
  //                               controller.dariJam.value.text,
  //                               style: GoogleFonts.inter(
  //                                   fontSize: 16,
  //                                   fontWeight: FontWeight.w500,
  //                                   color: Constanst.fgPrimary),
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                     Icon(Iconsax.arrow_down_1,
  //                         size: 20, color: Constanst.fgPrimary),
  //                   ],
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.only(left: 16.0),
  //                 child: Divider(
  //                   height: 0,
  //                   thickness: 1,
  //                   color: Constanst.fgBorder,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //       Expanded(
  //         child: InkWell(
  //           onTap: () {
  //             showTimePicker(
  //               context: Get.context!,
  //               initialTime: TimeOfDay.now(),
  //               // initialEntryMode: TimePickerEntryMode.input,
  //               builder: (context, child) {
  //                 return MediaQuery(
  //                   data: MediaQuery.of(context)
  //                       .copyWith(alwaysUse24HourFormat: true),
  //                   child: Theme(
  //                     data: ThemeData(
  //                       colorScheme: ColorScheme.light(
  //                         primary: Constanst.onPrimary,
  //                       ),
  //                       // useMaterial3: settings.useMaterial3,
  //                       dialogTheme: const DialogTheme(
  //                           shape: RoundedRectangleBorder(
  //                               borderRadius:
  //                                   BorderRadius.all(Radius.circular(16)))),
  //                       primaryColor: Constanst.fgPrimary,
  //                       textTheme: TextTheme(
  //                         titleMedium: GoogleFonts.inter(
  //                           color: Constanst.fgPrimary,
  //                         ),
  //                       ),
  //                       dialogBackgroundColor: Constanst.colorWhite,
  //                       canvasColor: Colors.white,
  //                       hintColor: Constanst.onPrimary,
  //                       textButtonTheme: TextButtonThemeData(
  //                         style: TextButton.styleFrom(
  //                           foregroundColor: Constanst.onPrimary,
  //                         ),
  //                       ),
  //                     ),
  //                     child: child!,
  //                   ),
  //                 );
  //               },
  //             ).then((value) {
  //               if (value == null) {
  //                 UtilsAlert.showToast('gagal pilih jam');
  //               } else {
  //                 var convertJam =
  //                     value.hour <= 9 ? "0${value.hour}" : "${value.hour}";
  //                 var convertMenit = value.minute <= 9
  //                     ? "0${value.minute}"
  //                     : "${value.minute}";
  //                 controller.sampaiJam.value.text = "$convertJam:$convertMenit";
  //                 this.controller.sampaiJam.refresh();
  //               }
  //             });
  //           },
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.all(16.0),
  //                 child: Row(
  //                   crossAxisAlignment: CrossAxisAlignment.end,
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           "Sampai jam*",
  //                           style: GoogleFonts.inter(
  //                               fontSize: 14,
  //                               fontWeight: FontWeight.w400,
  //                               color: Constanst.fgPrimary),
  //                         ),
  //                         const SizedBox(height: 8),
  //                         Text(
  //                           controller.sampaiJam.value.text,
  //                           style: GoogleFonts.inter(
  //                               fontSize: 16,
  //                               fontWeight: FontWeight.w500,
  //                               color: Constanst.fgPrimary),
  //                         ),
  //                       ],
  //                     ),
  //                     Icon(Iconsax.arrow_down_1,
  //                         size: 20, color: Constanst.fgPrimary),
  //                   ],
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.only(right: 16.0),
  //                 child: Divider(
  //                   height: 0,
  //                   thickness: 1,
  //                   color: Constanst.fgBorder,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  String getMonthName(int monthNumber) {
    // Menggunakan pustaka intl untuk mengonversi angka bulan menjadi teks
    final monthFormat = DateFormat.MMMM('id');
    DateTime date = DateTime(2000, monthNumber,
        1); // Tahun dan hari bebas, yang penting bulan sesuai
    return monthFormat.format(date);
  }

  Widget pickDate() {
    return InkWell(
      onTap: () {
        DatePicker.showPicker(
          Get.context!,
          pickerModel: CustomMonthPicker(
            minTime: DateTime(2020, 1, 1),
            maxTime: DateTime(2050, 1, 1),
            currentTime: DateTime(
                int.parse(controller.tahunSelectedSearchHistory.value),
                int.parse(controller.bulanSelectedSearchHistory.value),
                1),
          ),
          onConfirm: (time) {
            if (time != null) {
              print("$time");
              var filter = DateFormat('yyyy-MM').format(time);
              var array = filter.split('-');
              var bulan = array[1];
              var tahun = array[0];
              controller.bulanSelectedSearchHistory.value = bulan;
              controller.tahunSelectedSearchHistory.value = tahun;
              controller.bulanDanTahunNow.value = "$bulan-$tahun";
              controller.loadDataKasbon();
              this.controller.bulanSelectedSearchHistory.refresh();
              this.controller.tahunSelectedSearchHistory.refresh();
              this.controller.bulanDanTahunNow.refresh();
            }
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Iconsax.timer, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Periode cicilan *",
                    style: GoogleFonts.inter(
                        color: Constanst.fgPrimary,
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 8.0, 12.0, 0.0),
                    child: Text(
                      "${getMonthName(int.parse(controller.bulanSelectedSearchHistory.value))} ${controller.tahunSelectedSearchHistory.value}",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Constanst.fgPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget formDelegasiKepada() {
  //   return InkWell(
  //     onTap: () => bottomSheetPengajuanAbsen(),
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: SizedBox(
  //         width: double.infinity,
  //         child: Row(
  //           crossAxisAlignment: CrossAxisAlignment.end,
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Row(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Icon(
  //                   Iconsax.profile_add,
  //                   size: 26,
  //                   color: Constanst.fgPrimary,
  //                 ),
  //                 const SizedBox(width: 12),
  //                 Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       "Pemberi Tugas*",
  //                       style: GoogleFonts.inter(
  //                           fontSize: 14,
  //                           fontWeight: FontWeight.w400,
  //                           color: Constanst.fgPrimary),
  //                     ),
  //                     const SizedBox(height: 8),
  //                     Text(
  //                       controller.selectedDropdownDelegasi.value,
  //                       style: GoogleFonts.inter(
  //                           fontSize: 16,
  //                           fontWeight: FontWeight.w500,
  //                           color: Constanst.fgPrimary),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //             Icon(Iconsax.arrow_down_1, size: 20, color: Constanst.fgPrimary),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  void bottomSheetPengajuanAbsen() {
    showModalBottomSheet(
      context: Get.context!,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pemberi Tugas",
                    style: GoogleFonts.inter(
                        color: Constanst.fgPrimary,
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                  ),
                  InkWell(
                      customBorder: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      onTap: () {
                        Navigator.pop(Get.context!);
                      },
                      child: Icon(
                        Icons.close,
                        opticalSize: 24,
                        color: Constanst.fgSecondary,
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Divider(
                thickness: 1,
                height: 0,
                color: Constanst.border,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Obx(() => ListView.builder(
                    itemCount: controller.allEmployeeDelegasi.value.length,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      var data = controller.allEmployeeDelegasi.value[index];
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              controller.selectedDropdownDelegasi.value = data;
                              Get.back();
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 16, 16, 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(data,
                                      style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Constanst.fgPrimary)),
                                  controller.selectedDropdownDelegasiTemp
                                              .value ==
                                          data
                                      ? InkWell(
                                          onTap: () {},
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
                                            controller.selectedDropdownDelegasi
                                                .value = data;
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
                          ),
                        ],
                      );
                    })),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget formCatatan() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Divider(
            height: 0,
            thickness: 1,
            color: Constanst.fgBorder,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Iconsax.textalign_justifyleft, size: 24),
                const SizedBox(width: 12),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextLabell(
                      text: "Keterangan *",
                      color: Constanst.fgPrimary,
                      size: 14,
                      weight: FontWeight.w400,
                    ),
                    TextFormField(
                      controller: controller.catatan.value,
                      decoration: const InputDecoration(
                        hintText: 'Tulis keterangan disini',
                        border: InputBorder.none,
                      ),
                      style: GoogleFonts.inter(
                          color: Constanst.fgPrimary,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    )
                  ],
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
