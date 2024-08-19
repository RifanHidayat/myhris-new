import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/services/request.dart';
import 'package:siscom_operasional/utils/app_data.dart';

class ChatController extends GetxController {

  var jumlahChat=0.obs;
void getCount() async{

  var emId=AppData.informasiUser==null || AppData.informasiUser!.isEmpty || AppData.informasiUser==""?"":AppData.informasiUser![0].em_id ;
  try{
var data=await Request(url: '/chatting/employee-history/count',params: '&em_id=${emId}').get();

  var response=jsonDecode(data.body);

  if (data.statusCode==200){
    jumlahChat.value=response['total'];
    
  }else{
     jumlahChat.value=0;

  }
  }catch(e){
    print(e);
    jumlahChat.value=0;
    

  }

}

  // var listFoto = [].obs;
  String getTanggal() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    return formattedDate;
  }

  String getWaktu() {
    DateTime now = DateTime.now();
    String formattedTime = DateFormat('HH:mm:ss').format(now);
    return formattedTime;
  }

  String getFileExtension(String filePath) {
    int dotIndex = filePath.lastIndexOf('.');
    if (dotIndex != -1 && dotIndex != filePath.length - 1) {
      return filePath.substring(dotIndex + 1);
    }
    return '';
  }
}
