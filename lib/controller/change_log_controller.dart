import 'dart:convert';

import 'package:get/get.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:siscom_operasional/model/change_log.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';

class ChangeLogController extends GetxController {
  var changeLogs = <ChangeLog>[].obs;
  var namaVersi = "".obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getChangeLog();
    checkversion();
  }

  Future<void> getChangeLog() async {
    var connect = Api.connectionApi("get", "", "mobile-version-last");

    connect.then((dynamic res) {
      if (res == false) {
        //UtilsAlert.koneksiBuruk();
      } else {
        if (res.statusCode == 200) {
          var valueBody = jsonDecode(res.body);
          if (valueBody is Map<String, dynamic> &&
              valueBody.containsKey('data')) {
            ChangeLog changeLog = ChangeLog.fromJson(valueBody['data']);
            changeLogs.add(changeLog);
          }
          update();
        }
      }
    });
  }

  void checkversion() async {
    try {
      final newVersion = NewVersionPlus(
        androidId: 'com.siscom.siscomhrisnew',
      );

      final status = await newVersion.getVersionStatus();

      if (status != null) {
        namaVersi.value = status.localVersion;
      } else {}
    } catch (e) {}
  }
}
