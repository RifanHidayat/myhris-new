import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/user_controller.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';

class JadwalKerja extends StatefulWidget {
  const JadwalKerja({super.key});

  @override
  State<JadwalKerja> createState() => _JadwalKerjaState();
}

class _JadwalKerjaState extends State<JadwalKerja> {
  final List<Map<String, dynamic>> dataJadwal = [];
  var userController=Get.put(UserController());

  @override
  void initState() {
    super.initState();
    generateJadwalKerja();
    userController.generateJadwalKerja();
  }

  void generateJadwalKerja() {
    final startDate = DateTime(2025, 6, 1);
    final endDate = DateTime(2025, 6, 30);

    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      DateTime currentDate = startDate.add(Duration(days: i));
      String dayName = DateFormat.EEEE('id_ID').format(currentDate); // Bahasa Indonesia
      String formattedDate = DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(currentDate);

      bool isSunday = currentDate.weekday == DateTime.sunday;

      dataJadwal.add({
        "tanggal": formattedDate,
        "jamMasuk": isSunday ? null : "08:00",
        "jamKeluar": isSunday ? null : "17:00",
        "istirahatKeluar": isSunday ? null : "12:00",
        "istirahatMasuk": isSunday ? null : "13:00",
        "libur": isSunday,
      });
    }
  }
String formatTanggalToBulanTahun(String tanggal) {
  DateTime date = DateTime.parse(tanggal);
  return DateFormat("MMMM yyyy", "id_ID").format(date);
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
   title: Text("Jadwal Kerja ${formatTanggalToBulanTahun(AppData.endPeriode)}"),
      ),
      body: Obx((){
        return userController.isLoading.value==true?Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(child: CircularProgressIndicator()),
        ): userController.jadwalKerja.length==0?Container(child: Center(
          child: TextLabell(text: "Jadwal Kerja belum tersedia",size: 14,),
        ),): ListView.builder(
        itemCount: userController.jadwalKerja.length,
        itemBuilder: (context, index) {
          final jadwal = userController.jadwalKerja[index];
          final bool isLibur = jadwal['off_date']=='0' || jadwal['off_date']==0?true:false ;

          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            color: isLibur ? Colors.red[50] : Colors.white,
            child: Padding(
              padding: EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                   Constanst.convertDate6( jadwal["atten_date"]),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  if (isLibur)
                    Text(
                      "Hari Libur",
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  else ...[
                    _rowItem("Jam Masuk", jadwal["time_in"]),
                    _rowItem("Jam Keluar", jadwal["time_out"]),
                    _rowItem("Istirahat Keluar", jadwal["break_in"]),
                    _rowItem("Istirahat Masuk", jadwal["break_out"]),
                  ],
                ],
              ),
            ),
          );
        },
      );
      }),
    );
  }

  Widget _rowItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value ?? "-",
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
