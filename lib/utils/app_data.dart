import 'dart:convert';
import 'dart:ffi';

import 'package:siscom_operasional/model/setting_app_model.dart';
import 'package:siscom_operasional/model/user_model.dart';
import 'package:siscom_operasional/utils/local_storage.dart';

class AppData {
  // SET
  static set isOnboarding(bool value) =>
      LocalStorage.saveToDisk('isOnboarding', value);
  static set startPeriode(String value) =>
      LocalStorage.saveToDisk('startPeriode', value);

  static set endPeriode(String value) =>
      LocalStorage.saveToDisk('endPeriode', value);

// static set  periode(String value) =>
//       LocalStorage.saveToDisk('periode', value);

  static set statusAbsen(bool value) =>
      LocalStorage.saveToDisk('statusAbsen', value);
  static set kodeVerifikasi(String value) =>
      LocalStorage.saveToDisk('kodeVerifikasi', value);

  static set setFcmToken(String value) =>
      LocalStorage.saveToDisk('setFcmToken', value);

  static set isLogin(bool value) => LocalStorage.saveToDisk('isLogin', value);

  static set selectedDatabase(String value) =>
      LocalStorage.saveToDisk('selectedDatabase', value);

  static set selectedPerusahan(String value) =>
      LocalStorage.saveToDisk('selectedPerusahan', value);

  static set dateLastAbsen(String value) =>
      LocalStorage.saveToDisk('dateLastAbsen', value);

  static set latLon(String value) => LocalStorage.saveToDisk('latLon', value);

  static set emailUser(String value) =>
      LocalStorage.saveToDisk('emailUser', value);

  static set passwordUser(String value) =>
      LocalStorage.saveToDisk('passwordUser', value);

  static set informasiUser(List<UserModel>? value) {
    if (value != null) {
      List<String> listString = value.map((e) => e.toJson()).toList();
      LocalStorage.saveToDisk('informasiUser', listString);
    } else {
      LocalStorage.saveToDisk('informasiUser', null);
    }
  }

  static set signoutTime(String value) =>
      LocalStorage.saveToDisk('signoutTime', value);

  static set signingTime(String value) =>
      LocalStorage.saveToDisk('signingTime', value);

  static set statusAbsenOffline(bool value) =>
      LocalStorage.saveToDisk('statusAbsenOffline', value);

  static set temp(bool value) => LocalStorage.saveToDisk('temp', value);

  static set textPendingMasuk(bool value) =>
      LocalStorage.saveToDisk('textPendingMasuk', value);

  static set textPendingKeluar(bool value) =>
      LocalStorage.saveToDisk('textPendingKeluar', value);

  static set loginOffline(bool value) =>
      LocalStorage.saveToDisk('loginOffline', value);

  // static set firsLogin(bool value) =>
  //     LocalStorage.saveToDisk('firsLogin', value);

  static set infoSettingApp(List<SettingAppModel>? value) {
    if (value != null) {
      List<String> listString = value.map((e) => e.toJson()).toList();
      LocalStorage.saveToDisk('infoSettingApp', listString);
    } else {
      LocalStorage.saveToDisk('infoSettingApp', null);
    }
  }

  // GET

  static bool get statusAbsen {
    if (LocalStorage.getFromDisk('statusAbsen') != null) {
      return LocalStorage.getFromDisk('statusAbsen');
    }
    return false;
  }

  static String get startPeriode {
    if (LocalStorage.getFromDisk('startPeriode') != null) {
      return LocalStorage.getFromDisk('startPeriode');
    }
    return "";
  }

  static String get endPeriode {
    if (LocalStorage.getFromDisk('endPeriode') != null) {
      return LocalStorage.getFromDisk('endPeriode');
    }
    return "";
  }

  static bool get statusAbsenOffline {
    if (LocalStorage.getFromDisk('statusAbsenOffline') != null) {
      return LocalStorage.getFromDisk('statusAbsenOffline');
    }
    return false;
  }

  static String get signoutTime {
    if (LocalStorage.getFromDisk('signoutTime') != null) {
      return LocalStorage.getFromDisk('signoutTime');
    }
    return "";
  }

  static String get signingTime {
    if (LocalStorage.getFromDisk('signingTime') != null) {
      return LocalStorage.getFromDisk('signingTime');
    }
    return "";
  }

  static bool get textPendingMasuk {
    if (LocalStorage.getFromDisk('textPendingMasuk') != null) {
      return LocalStorage.getFromDisk('textPendingMasuk');
    }
    return true;
  }

  static bool get textPendingKeluar {
    if (LocalStorage.getFromDisk('textPendingKeluar') != null) {
      return LocalStorage.getFromDisk('textPendingKeluar');
    }
    return true;
  }

  static bool get temp {
    if (LocalStorage.getFromDisk('temp') != null) {
      return LocalStorage.getFromDisk('temp');
    }
    return false;
  }

  static bool get loginOffline {
    if (LocalStorage.getFromDisk('loginOffline') != null) {
      return LocalStorage.getFromDisk('loginOffline');
    }
    return false;
  }

  // static bool get firsLogin {
  //   if (LocalStorage.getFromDisk('firsLogin') != null) {
  //     return LocalStorage.getFromDisk('firsLogin');
  //   }
  //   return false;
  // }

  static bool get isOnboarding {
    if (LocalStorage.getFromDisk('isOnboarding') != null) {
      return LocalStorage.getFromDisk('isOnboarding');
    }
    return false;
  }

  static String get kodeVerifikasi {
    if (LocalStorage.getFromDisk('kodeVerifikasi') != null) {
      return LocalStorage.getFromDisk('kodeVerifikasi');
    }
    return "";
  }

  static bool get isLogin {
    if (LocalStorage.getFromDisk('isLogin') != null) {
      return LocalStorage.getFromDisk('isLogin');
    }
    return false;
  }

  static String get selectedPerusahan {
    if (LocalStorage.getFromDisk('selectedPerusahan') != null) {
      return LocalStorage.getFromDisk('selectedPerusahan');
    }
    return "";
  }

  static String get selectedDatabase {
    if (LocalStorage.getFromDisk('selectedDatabase') != null) {
      return LocalStorage.getFromDisk('selectedDatabase');
    }
    return "";
  }

  static String get dateLastAbsen {
    if (LocalStorage.getFromDisk('dateLastAbsen') != null) {
      return LocalStorage.getFromDisk('dateLastAbsen');
    }
    return "";
  }

  static String get latLon {
    if (LocalStorage.getFromDisk('latLon') != null) {
      return LocalStorage.getFromDisk('latLon');
    }
    return "";
  }

  static String get emailUser {
    if (LocalStorage.getFromDisk('emailUser') != null) {
      return LocalStorage.getFromDisk('emailUser');
    }
    return "";
  }

  static String get passwordUser {
    if (LocalStorage.getFromDisk('passwordUser') != null) {
      return LocalStorage.getFromDisk('passwordUser');
    }
    return "";
  }

  static String get setFcmToken {
    if (LocalStorage.getFromDisk('setFcmToken') != null) {
      return LocalStorage.getFromDisk('setFcmToken');
    }
    return "";
  }

  static List<UserModel>? get informasiUser {
    if (LocalStorage.getFromDisk('informasiUser') != null) {
      List<String> listData = LocalStorage.getFromDisk('informasiUser');
      return listData.map((e) => UserModel.fromMap(jsonDecode(e))).toList();
    }
    return null;
  }

  static List<SettingAppModel>? get infoSettingApp {
    print("info setting ${LocalStorage.getFromDisk('infoSettingApp')}");

    if (LocalStorage.getFromDisk('infoSettingApp') != null) {
      List<String> listData = LocalStorage.getFromDisk('infoSettingApp');
      return listData
          .map((e) => SettingAppModel.fromMap(jsonDecode(e)))
          .toList();
    }
    return null;
  }

  // CLEAR ALL DATA

  static void clearAllData() =>
      LocalStorage.removeFromDisk(null, clearAll: true);
}
