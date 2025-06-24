import 'dart:convert';
import 'package:get/get.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';

class PinjamanController extends GetxController {
  var pinjamanList = [].obs;
  var detailData = [].obs;
  var assetsBenda = [].obs;
  // Map<String,dynamic> assetBendaTemp=;
  //  Map<String, dynamic> assetBendaTemp= Map<String, dynamic>();
  Rx<List<String>> assetsBendaTemp = Rx<List<String>>([]);
  var tempData = [].obs;
  var detailDataList = [].obs;
  var detailDataListSimpan = [].obs;

  //
  var dataTypeAjuan = ["Semua Status", "Approve", "Rejected", "Pending"].obs;
  var statusSelected = "Semua Status".obs;
//  var dataTypeAjuanDummy1 = ["Semua Status", "Approve", "Rejected", "Pending"];

  Future<void> listBenda() async {
    var connect = Api.connectionApi("get", {}, 'pinjaman');
    connect.then((dynamic res) {
      var valueBody = jsonDecode(res.body);
      if (res.statusCode == 200) {
        if (valueBody['status'] == false) {
          pinjamanList.value = [];
          print("gada data : ${valueBody['remark']}");
        } else {
          var cekData = valueBody['data'];
          pinjamanList.value = cekData;
          tempData.value = cekData;
          filter();
        }
      } else {
        pinjamanList.value = [];
      }
    }).catchError((error) {
      print("Error: $error");
    });
  }

  void filter() {
    if (statusSelected.value == "Semua Status") {
      pinjamanList.value = tempData;
      //UtilsAlert.showToast("mmauk siniq");
    } else {
      //   UtilsAlert.showToast("mmauk sini");
      pinjamanList.value = tempData
          .where((i) =>
              i['status'].toString().toLowerCase() ==
              statusSelected.value.toLowerCase())
          .toList();
    }
  }

  Future<bool> detailBenda(String id) async {
    detailData.value = [];
    UtilsAlert.showLoadingIndicator(Get.context!);
    var response = await ApiRequest(url: 'pinjaman/detail/$id').get();

    var data = jsonDecode(response.body);

    try {
      if (response.statusCode == 200) {
        detailData.value = List.from(data['data']['detail']);
        print(detailData);
        Get.back();
        return true;
      }
      Get.back();
      return false;
    } catch (e) {
      return false;
    }

  }

  Future<bool> simpanData(tanggal, keterangan) async {
    detailData.value = [];

    // detailDataListSimpan.forEach((item) {
    //   if (item['assets'] == "" ||
    //       item['qty'] == "" ||
    //       item['qty'] == '0' ||
    //       item['keterangan'] == '') {
    //     UtilsAlert.showToast("Form * tidak boleh kosong");
    //     return;
    //   }
    // });

    var d = detailDataList
        .where((item) =>
            item['assets'] == "" ||
            item['qty'] == "" ||
            item['qty'] == '0' ||
            item['keterangan'] == '')
        .toList();

    if (d.isNotEmpty) {
      Get.back();
      UtilsAlert.showToast("Form * tidak boleh kosong");

      return false;
    }
    //return true;

    detailDataListSimpan.forEach((item) {
      var data =
          assetsBenda.where((p0) => p0['name'] == item['assets']).toList();
      if (data.isNotEmpty) {
        item['assets_id'] = data[0]['id'].toString();
      }
      detailData.add(item);
    });
    var body = {
      "tanggal_ajuan": tanggal,
      "keterangan": keterangan,
      'details': detailData
    };

    print(body);
    // Get.back();
    // return false;
    detailDataList.clear();

    UtilsAlert.showLoadingIndicator(Get.context!);
    var response = await ApiRequest(url: 'pinjaman', body: body).post();

    var data = jsonDecode(response.body);

    try {
      if (response.statusCode == 200) {
        Get.back();
        Get.back();
        listBenda();
        return true;
      }

      UtilsAlert.showToast(data['message']);
      Get.back();
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateData(tanggal, keterangan, id) async {
    detailData.value = [];

    detailDataListSimpan.forEach((item) {
      if (item['assets'] == "" ||
          item['qty'] == "" ||
          item['qty'] == '0' ||
          item['keterangan'] == '') {
        UtilsAlert.showToast("Form * tidak boleh kosong");
        return;
      }
    });

    detailDataListSimpan.forEach((item) {
      var data =
          assetsBenda.where((p0) => p0['name'] == item['assets']).toList();
      if (data.isNotEmpty) {
        item['assets_id'] = data[0]['id'].toString();
      }
      detailData.add(item);
    });
    var body = {
      "tanggal_ajuan": tanggal,
      "keterangan": keterangan,
      'details': detailData
    };

    print(body);
    // Get.back();
    // return false;
    detailDataList.clear();

    UtilsAlert.showLoadingIndicator(Get.context!);
    var response = await ApiRequest(url: 'pinjaman/${id}', body: body).patch();

    var data = jsonDecode(response.body);

    try {
      if (response.statusCode == 200) {
        Get.back();
        Get.back();
        Get.back();
        listBenda();
        return true;
      }

      UtilsAlert.showToast(data['message']);
      Get.back();
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteData(String id) async {
    detailData.value = [];
    UtilsAlert.showLoadingIndicator(Get.context!);
    var response = await ApiRequest(url: 'pinjaman/$id', body: {}).delete();

    // var data = jsonDecode(response.body);

    try {
      if (response.statusCode == 200) {
        print('kemari?');
        Get.back();
        Get.back();
        listBenda();
        return true;
      } else{

      }
      print('kemari?');
      Get.back();
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> getAssets(assetId) async {
    assetsBendaTemp.value.clear();
    assetsBendaTemp.value.add("");
    var body = {
      'assetId' : assetId
    };
    var connect = Api.connectionApi("post", body, "pinjaman/assets");
    connect.then((dynamic res) {
      var valueBody = jsonDecode(res.body);
      if (valueBody['status'] == true) {
        assetsBenda.value = List.from(valueBody['data']);
        assetsBenda.forEach((item) {
          assetsBendaTemp.value.add(item['name']);
        });
        print("berhasil : $valueBody");
      } else {
        print("value");
      }
    });
  }

  @override
  void onInit() {
    // getAssets();
    super.onInit();
  }
}
