import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/services/request.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';

class ChatController extends GetxController {

 var loading = "Memuat data...".obs;
  var jumlahChat=0.obs;
    RxBool isSearching = false.obs;
    var isLoading=true.obs;
        RxBool isLoadingEnployee = false.obs;
      RxBool isSearchingEmployee = false.obs;
  var searchController = TextEditingController();
   var searchControllerEmployee = TextEditingController();
  var cari = TextEditingController().obs;
  void toggleSearch() {
    
    isSearching.value = !isSearching.value;
  }
  
  void toggleSearchEmployee() {
    isSearchingEmployee.value = !isSearchingEmployee.value;
   
  }


  

  void clearText() {
    searchController.clear();
    // pencarianNamaKaryawan('');
  }
   void clearTextEmployee() {
     searchControllerEmployee.clear();
     getAllEmployee();
    // pencarianNamaKaryawan('');
  }
  var infoEmployee = [].obs;
   var infoAllEmployee = [].obs;
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

Future<List<dynamic>>  getEmployee() async{
print('masuk sini history chat new  newnew ');

  var data=await Request(url: 'chatting/employee-history',params: '&em_id=${AppData.informasiUser![0].em_id}&search=${searchController.value.text}').get();
var response=jsonDecode(data.body);
print('masuk sini history chat new ${response}');

if (data.statusCode==200){
  isLoading.value=false;
return response;
  infoEmployee.value=response['data'];
  print('berhasil ambil data chat ${response['data']}');

}else {
   isLoading.value=false;

  var jumlahChat = 0.obs;
  var isSelectionMode = false.obs;
  var selectedMessage = Rxn<dynamic>();
  var isPressed = false.obs;

  void getCount() async {
    var emId = AppData.informasiUser == null ||
            AppData.informasiUser!.isEmpty ||
            AppData.informasiUser == ""
        ? ""
        : AppData.informasiUser![0].em_id;
    try {
      var data = await Request(
              url: '/chatting/employee-history/count', params: '&em_id=${emId}')
          .get();

      var response = jsonDecode(data.body);

      if (data.statusCode == 200) {
        jumlahChat.value = response['total'];
      } else {
        jumlahChat.value = 0;
      }
    } catch (e) {
      print(e);
      jumlahChat.value = 0;
    }
  }

  Future<List<dynamic>> getEmployee() async {
    print('masuk sini history chat new  newnew ');

    var data = await Request(
            url: 'chatting/employee-history',
            params:
                '&em_id=${AppData.informasiUser![0].em_id}&search=${searchController.value.text}')
        .get();
    var response = jsonDecode(data.body);
    print('masuk sini history chat new ${response}');

    if (data.statusCode == 200) {
      return response;
      infoEmployee.value = response['data'];
      print('berhasil ambil data chat ${response['data']}');
    } else {

      throw Exception('Failed to load data');
    }
  }


void  getAllEmployee() async{
isLoadingEnployee.value=true;
  infoAllEmployee.clear();
print('masuk sini history chat new  newnew new ');


    var data = await Request(
            url: 'chatting/employee',
            params:
                '&em_id=${AppData.informasiUser![0].em_id}&search=${searchControllerEmployee.text}')
        .get();
    var response = jsonDecode(data.body);
    print('masuk sini history chat new employee ${response}');


if (data.statusCode==200){
 isLoadingEnployee.value=false;

// return response;
  infoAllEmployee.value=response;


}else {
isLoadingEnployee.value=false;

      throw Exception('Failed to load data');
    }
  }
// Future<List<dynamic>> fetchDataFromApi() async {
//   final response = await http.get(Uri.parse('https://api.example.com/data'));

//   if (response.statusCode == 200) {
//     // Parse JSON data
//     return json.decode(response.body);
//   } else {
//     throw Exception('Failed to load data');
//   }
// }

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

  void tekanLamaPesan(dynamic messageData) {
    if (isSelectionMode.value) return;

    isSelectionMode.value = true;
    selectedMessage.value = messageData;
    isPressed.value = true;
    print("Message Data: $messageData");
  }

  void releasePesan() {
    isPressed.value = false; // Reset status ketika pesan dilepas
  }

  void forwardPesan() {
    isSelectionMode.value = false;
    selectedMessage.value = null;
    releasePesan(); // Pastikan status ditekan direset
  }

  void resetSelection() {
    isSelectionMode.value = false;
    selectedMessage.value = null;
  }
}
