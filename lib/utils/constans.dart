import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class Constanst {
  // new color
  //
  static Color fgSecondary = HexColor('#68778D');
  static Color fgPrimary = HexColor('#202327');
  static Color fgBorder = HexColor('#CBD5E0');
  static Color warning = HexColor('#F2AA0D');
  static Color onPrimary = HexColor('#001767');
  static Color colorNeutralBgTertiary = HexColor('#E2E8F0');
  static Color colorNeutralBgSecondary = HexColor('#F1F4F9');
  static Color colorNeutralFgTertiary = HexColor('#A9B9CC');
  static Color colorStateInfoBorder = HexColor('#81BFF9');
  static Color secondary = HexColor('#68778D');
  static Color colotStateInfoBg = HexColor('#092371');
  static Color colorStateOnDangerBg = HexColor('#7A0B2B');
  static Color colorStateDangerBorder = HexColor('#FFA38A');
  static Color colorStateDangerBg = HexColor('#FFF2EB');

  static double defaultMarginPadding = 16.0;
  static double sizeTitle = 16.0;
  static double sizeText = 14.0;
  static Color greyLight300 = Color(0xffBCC2CE);
  static Color greyLight100 = Color(0xffE9EDF5);
  static Color greyLight50 = Color(0xffF8FAFF);
  // static Color coloBackgroundScreen = Color(0xffF8FAFF);
  static Color coloBackgroundScreen = Colors.white;
  static Color colorWhite = Colors.white;
  static Color colorBlack = Colors.black;
  static Color radiusColor = HexColor('#3d889c');
  static Color colorBGApprove = Color(0xffE6FCE6);
  static Color colorBGRejected = Color(0xffFFF2EB);
  static Color colorBGPending = Color(0xffFEF9E6);
  static Color colorText1 = Color(0xff687182);
  static Color colorText2 = Color(0xff868FA0);
  static Color colorText3 = Color(0xff333B4A);
  static Color colorText4 = HexColor('#333B4A');
  static Color border = HexColor('#CBD5E0');
  static Color Secondary = HexColor('#68778D');
  static Color blackSurface = HexColor('#202327');

  static Color colorNonAktif = Color(0xffD5DBE5);
  static Color colorButton1 = Color(0xff001767);
//  static Color colorButton1 = HexColor('#14A494');

  static Color colorButton2 = Color(0xffE9F5FE);
  static Color colorButton3 = Color(0xffE1E9FA);
  //static Color colorButton3 = HexColor('#DFFFF0');

  static Color colorPrimary = Color(0xff001767);
  // static Color colorPrimary = HexColor('#14A494');
  static Color colorPrimaryLight = HexColor('#CEFAE5');

  // static Color color1 = Color(0xffBCC2CE);
  static Color color1 = Color(0xffBCC2CE);
  static Color color2 = Color(0xff11151E);
  static Color color3 = Color(0xffF2AA0D);
  static Color color4 = Color(0xffFF463D);
  static Color color5 = Color(0xff14B156);
  static Color infoLight = HexColor('#2F80ED');
  static Color infoLight1 = HexColor('#E9F5FE');
  static Color grey = HexColor('#E9EDF5');

  static Color color6 = Color.fromARGB(88, 230, 230, 230);

  static BorderRadius borderStyle1 = BorderRadius.only(
      topLeft: Radius.circular(15),
      topRight: Radius.circular(15),
      bottomLeft: Radius.circular(15),
      bottomRight: Radius.circular(15));

  static BorderRadius borderStyle2 = BorderRadius.only(
      topLeft: Radius.circular(10),
      topRight: Radius.circular(10),
      bottomLeft: Radius.circular(10),
      bottomRight: Radius.circular(10));

  static BorderRadius borderStyle3 = BorderRadius.only(
      topLeft: Radius.circular(25),
      topRight: Radius.circular(25),
      bottomLeft: Radius.circular(25),
      bottomRight: Radius.circular(25));

  static BorderRadius borderStyle4 = BorderRadius.only(
      topLeft: Radius.circular(20),
      topRight: Radius.circular(20),
      bottomLeft: Radius.circular(20),
      bottomRight: Radius.circular(20));

  static BorderRadius borderStyle5 = BorderRadius.only(
      topLeft: Radius.circular(6),
      topRight: Radius.circular(6),
      bottomLeft: Radius.circular(6),
      bottomRight: Radius.circular(6));

  static TextStyle style1 =
      TextStyle(color: Colors.grey, fontWeight: FontWeight.bold);
  static TextStyle boldType1 =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 18);
  static TextStyle boldType2 =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 14);
  static TextStyle colorGreenBold =
      TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12);
  static TextStyle colorRedBold =
      TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12);

  static BoxDecoration styleBoxDecoration1 = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(6),
          bottomLeft: Radius.circular(6),
          bottomRight: Radius.circular(6)),
      border: Border.all(color: Color(0xffD5DBE5)));
  static BoxDecoration styleBoxDecoration2(color) {
    return BoxDecoration(
      color: color!,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10)),
    );
  }

  static String convertDateAndClock(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      final formatter = DateFormat('yyyy-MM-dd HH:mm');
      return formatter.format(dateTime);
    } catch (e) {
      return '-';
    }
  }

  static String convertDate(String date) {
    DateTime convert = DateTime.parse(date);
    var hari = DateFormat('EEEE');
    var tanggal = DateFormat('dd-MM-yyyy');
    var convertHari = hari.format(convert);
    var hasilConvertHari = hariIndo(convertHari);
    var valid2 = tanggal.format(convert);
    var validFinal = "$hasilConvertHari, $valid2";
    return validFinal;
  }

  static String convertDate1(String date) {
    var inputFormat = DateFormat('yyyy-MM-dd');
    var inputDate = inputFormat.parse(date);
    var outputFormat = DateFormat('dd-MM-yyyy', 'id_ID');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static String convertDate2(String date) {
    var inputFormat = DateFormat('yyyy-MM-dd');
    var inputDate = inputFormat.parse(date);
    var outputFormat = DateFormat('EEEE, dd-MM-yyyy');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static String convertDate3(String date) {
    DateTime convert = DateTime.parse(date);
    var tanggal = DateFormat('dd MMM');
    var valid2 = tanggal.format(convert);
    return valid2;
  }

  static String convertDate4(String date) {
    var inputFormat = DateFormat('yyyy-MM-dd');
    var inputDate = inputFormat.parse(date);
    var outputFormat = DateFormat('dd MMM');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static String convertDate5(String date) {
    List<String> parts = date.split('-');
    if (parts.length == 3) {
      parts[1] = parts[1].padLeft(2, '0'); // Perbaiki bulan
      parts[2] = parts[2].padLeft(2, '0'); // Perbaiki hari
    } else {
      throw FormatException("Invalid date format: $date");
    }
    String fixedDate = parts.join('-');
    DateTime convert = DateTime.parse(fixedDate);
    var bulan = DateFormat('MMMM');
    var hari = DateFormat('dd');
    var tahun = DateFormat('yyyy');
    var convertBulan = bulan.format(convert);
    var hasilConvertBulan = bulanIndo(convertBulan);
    var convertHari = hari.format(convert);
    var convertTahun = tahun.format(convert);
    // var valid2 = tanggal.format(convert);
    var validFinal = "$convertHari $hasilConvertBulan $convertTahun";
    return validFinal;
  }

  static String convertDate6(String date) {
    List<String> parts = date.split('-');
    if (parts.length == 3) {
      parts[1] = parts[1].padLeft(2, '0'); // Perbaiki bulan
      parts[2] = parts[2].padLeft(2, '0'); // Perbaiki hari
    } else {
      throw FormatException("Invalid date format: $date");
    }
    String fixedDate = parts.join('-');
    DateTime convert = DateTime.parse(fixedDate);
    var hari = DateFormat('EEEE');
    var tanggal = DateFormat('dd MMM yyyy', 'id');
    var convertHari = hari.format(convert);
    var hasilConvertHari = hariIndo(convertHari);
    var valid2 = tanggal.format(convert);
    var validFinal = "$hasilConvertHari, $valid2";
    return validFinal;
  }

  static String convertDateTgllembur(String date) {
    DateTime convert = DateTime.parse(date);
    var hari = DateFormat('EEEE');
    var tanggal = DateFormat('dd MMM yyyy', 'id');
    var convertHari = hari.format(convert);
    var hasilConvertHari = hariIndo(convertHari);
    var valid2 = tanggal.format(convert);
    var validFinal = "$hasilConvertHari, $valid2";
    return validFinal;
  }

  static String convertDate7(String date) {
    var inputFormat = DateFormat('yyyy-MM-dd');
    var inputDate = inputFormat.parse(date);
    var outputFormat = DateFormat('dd');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static String convertDateSimpan(String date) {
    try {
      // Jika format sudah "yyyy-MM-dd", langsung return
      if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(date)) {
        return date;
      }

      var inputFormat = DateFormat('dd-MM-yyyy');
      var inputDate = inputFormat.parse(date);
      var outputFormat = DateFormat('yyyy-MM-dd');

      return outputFormat.format(inputDate);
    } catch (e) {
      print('Error parsing date: $e');
      return '';
    }
  }

  static String convertDate8(String date) {
    var inputFormat = DateFormat('yyyy-MM-dd');
    var inputDate = inputFormat.parse(date);
    var outputFormat = DateFormat('dd MMM yyyy', 'id');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static String convertDate9(String date) {
    var inputDate = DateTime.parse(date);
    var outputFormat = DateFormat('yyyy-MM-dd', 'id_ID');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static String convertTime(String time) {
    var inputFormat = DateFormat('HH:mm:ss');
    var inputTime = inputFormat.parse(time);
    var outputFormat = DateFormat('HH:mm');
    var outputTime = outputFormat.format(inputTime);
    return outputTime;
  }

  static String convertDateBulanDanTahun(String date) {
    var inputFormat = DateFormat('MM-yyyy');
    var inputDate = inputFormat.parse(date);
    var outputFormat = DateFormat('MMMM yyyy', 'id');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static String convertDateBulanDanHari(String date) {
    var inputFormat = DateFormat('MM-dd');
    var inputDate = inputFormat.parse(date);
    var outputFormat = DateFormat('dd MMMM', 'id');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static String convertOnlyDate(String date) {
    var inputFormat = DateFormat('dd-MM-yyyy');
    var inputDate = inputFormat.parse(date);
    var outputFormat = DateFormat('dd');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static String convertGetMonth(String date) {
    DateTime convert = DateTime.parse(date);
    var outputDate = DateFormat('MMM');
    return bulanIndoLengkap(outputDate.format(convert));
  }

  static String convertGetDay(String date) {
    DateTime convert = DateTime.parse(date);
    var outputDate = DateFormat('EEEE');
    return hariIndo(outputDate.format(convert));
  }

  static String hariIndo(String hari) {
    if (hari == "Monday") {
      hari = "Senin";
    } else if (hari == "Tuesday") {
      hari = "Selasa";
    } else if (hari == "Wednesday") {
      hari = "Rabu";
    } else if (hari == "Thursday") {
      hari = "Kamis";
    } else if (hari == "Friday") {
      hari = "Jumat";
    } else if (hari == "Saturday") {
      hari = "Sabtu";
    } else if (hari == "Sunday") {
      hari = "Minggu";
    } else {
      hari = hari;
    }
    return hari;
  }

  static String bulanIndoLengkap(String bulan) {
    if (bulan == "Jan") {
      bulan = "Januari";
      // bulan = "Januari";
    } else if (bulan == "Feb") {
      bulan = "Febuari";
      // bulan = "Februari";
    } else if (bulan == "Mar") {
      bulan = "Maret";
      // bulan = "Maret";
    } else if (bulan == "Apr") {
      bulan = "April";
      // bulan = "April";
    } else if (bulan == "Mai") {
      bulan = "Mei";
      // bulan = "Mei";
    } else if (bulan == "Jun") {
      bulan = "Juni";
      // bulan = "Juni";
    } else if (bulan == "Jul") {
      bulan = "Juli";
      // bulan = "Juli";
    } else if (bulan == "Agu") {
      bulan = "Agustus";
      // bulan = "Agustus";
    } else if (bulan == "Sep") {
      bulan = "September";
      // bulan = "September";
    } else if (bulan == "Oct") {
      bulan = "Okttober";
      // bulan = "Oktober";
    } else if (bulan == "Nov") {
      bulan = "November";
      // bulan = "November";
    } else if (bulan == "Dec") {
      bulan = "Desember";
      // bulan = "Desember";
    } else {
      bulan = bulan;
    }
    return bulan;
  }

  static String bulanIndo(String bulan) {
    if (bulan == "January" || bulan == "01" || bulan == "1") {
      bulan = "Jan";
      // bulan = "Januari";
    } else if (bulan == "February" || bulan == "02" || bulan == "2") {
      bulan = "Feb";
      // bulan = "Februari";
    } else if (bulan == "March" || bulan == "03" || bulan == "3") {
      bulan = "Mar";
      // bulan = "Maret";
    } else if (bulan == "April" || bulan == "04" || bulan == "4") {
      bulan = "Apr";
      // bulan = "April";
    } else if (bulan == "May" || bulan == "05" || bulan == "5") {
      bulan = "Mei";
      // bulan = "Mei";
    } else if (bulan == "June" || bulan == "06" || bulan == "6") {
      bulan = "Jun";
      // bulan = "Juni";
    } else if (bulan == "July" || bulan == "07" || bulan == "7") {
      bulan = "Jul";
      // bulan = "Juli";
    } else if (bulan == "August" || bulan == "08" || bulan == "8") {
      bulan = "Agu";
      // bulan = "Agustus";
    } else if (bulan == "September" || bulan == "09" || bulan == "9") {
      bulan = "Sep";
      // bulan = "September";
    } else if (bulan == "October" || bulan == "10") {
      bulan = "Okt";
      // bulan = "Oktober";
    } else if (bulan == "November" || bulan == "11") {
      bulan = "Nov";
      // bulan = "November";
    } else if (bulan == "December" || bulan == "12") {
      bulan = "Des";
      // bulan = "Desember";
    } else {
      bulan = bulan;
    }
    return bulan;
  }

  // boxShadow: [
  //   BoxShadow(
  //     color: Color.fromARGB(255, 199, 199, 199).withOpacity(0.5),
  //     spreadRadius: 2,
  //     blurRadius: 1,
  //     offset: Offset(1, 1), // changes position of shadow
  //   ),
  // ],
}
