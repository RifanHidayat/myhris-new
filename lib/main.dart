import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
// import 'package:background_location_tracker/background_location_tracker.dart';
// import 'package:background_location_tracker/background_location_tracker.dart';
import 'package:flutter/material.dart';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:siscom_operasional/controller/absen_controller.dart';
import 'package:siscom_operasional/controller/global_controller.dart';
// import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/pesan_controller.dart';
import 'package:siscom_operasional/controller/tab_controller.dart';
// import 'package:siscom_operasional/screen/pesan/detail_persetujuan_lembur.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siscom_operasional/controller/approval_controller.dart';
import 'package:siscom_operasional/controller/init_controller.dart';
import 'package:siscom_operasional/controller/tracking_controller.dart';

import 'package:siscom_operasional/fireabase_option.dart';
import 'package:siscom_operasional/model/notification.dart';
// import 'package:siscom_operasional/screen/absen/history_absen.dart';
// import 'package:siscom_operasional/screen/absen/lembur.dart';
// import 'package:siscom_operasional/screen/absen/riwayat_cuti.dart';
// import 'package:siscom_operasional/screen/absen/riwayat_izin.dart';
// import 'package:siscom_operasional/screen/absen/tugas_luar.dart';
import 'package:siscom_operasional/screen/chatting/chat_page.dart';

// import 'package:siscom_operasional/screen/init_screen.dart';
// import 'package:siscom_operasional/screen/kandidat/list_kandidat.dart';
// import 'package:siscom_operasional/screen/klaim/riwayat_klaim.dart';
// import 'package:siscom_operasional/screen/pesan/detail_persetujuan_absensi.dart';
// import 'package:siscom_operasional/screen/pesan/detail_persetujuan_cuti.dart';
// import 'package:siscom_operasional/screen/pesan/detail_persetujuan_izin.dart';
// import 'package:siscom_operasional/screen/pesan/detail_persetujuan_klaim.dart';
// import 'package:siscom_operasional/screen/pesan/detail_persetujuan_payroll.dart';
// import 'package:siscom_operasional/screen/pesan/detail_persetujuan_tugas_luar.dart';
import 'package:siscom_operasional/utils/api.dart';

import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/local_storage.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:sqflite/sqflite.dart';
import 'package:web_socket_channel/io.dart';
// import 'database/database_services.dart';
import 'utils/app_data.dart';

// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:percent_indicator/percent_indicator.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
late List<CameraDescription> cameras;

// @pragma('vm:entry-point')
// void backgroundCallback() {
//   BackgroundLocationTrackerManager.handleBackgroundUpdated(
//     (data) async {
//       LocalStorage.prefs = await SharedPreferences.getInstance();
//       // print("informasiUser 1111 ${AppData.informasiUser![0].em_id}");
//       // print("informasiUser ${AppData.informasiUser![0].em_id}");
//       // Timer.periodic(Duration(seconds: 5), (timer) {
//       // Panggil fungsi yang ingin dijalankan setiap detik di sini
//       print('Fungsi dijalankan setiap detik');
//       controllerTracking.tracking(data.lat.toString(), data.lon.toString());
//       // Repo().tracking(data);
//       Repo().update(data);
//       // });
//       print("interval ${AppData.informasiUser![0].interval.toString()}");
//       return Repo().submitData(data);
//     },
//   );
// }

// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch

Future<void> main() async {
  Get.put(InitController());
  Get.put(GlobalController());
  Get.put(ApprovalController());
  Get.put(PesanController());
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.dark,
  ));
  await GetStorage.init();
  // AppData.clearAllData();

  cameras = await availableCameras();
  // await BackgroundLocationTrackerManager.initialize(
  //   () => backgroundCallback,
  //   config: const BackgroundLocationTrackerConfig(
  //     loggingEnabled: true,
  //     androidConfig: AndroidConfig(
  //       notificationIcon: 'explore',
  //       trackingInterval: Duration(seconds: 60),
  //       distanceFilterMeters: null,
  //     ),
  //     iOSConfig: IOSConfig(
  //       activityType: ActivityType.FITNESS,
  //       distanceFilterMeters: null,
  //       restartAfterKill: true,
  //     ),
  //   ),
  // );
  LocalStorage.prefs = await SharedPreferences.getInstance();
  // controllerTracking.em_id.value = er![0].em_id;
  // print("em_id param ${controllerTracking.em_id.value}");
  // await BackgroundLocationTrackerManager.initialize(
  //   backgroundCallback,
  //   config: BackgroundLocationTrackerConfig(
  //     loggingEnabled: true,
  //     androidConfig: AndroidConfig(
  //       notificationIcon: 'explore',
  //       trackingInterval: Duration(
  //         // minutes: int.parse(
  //         //     AppData.informasiUser == null || AppData.informasiUser!.isEmpty
  //         //         ? '1'
  //         //         : AppData.informasiUser![0].interval_tracking.toString()),
  //         seconds: 120,
  //       ),
  //       distanceFilterMeters: null,
  //     ),
  //     iOSConfig: IOSConfig(
  //       activityType: ActivityType.FITNESS,
  //       distanceFilterMeters: null,
  //       restartAfterKill: true,
  //     ),
  //   ),
  // );

  if (Platform.isIOS) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.ios);
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.android,
    );
  }

  FirebaseMessaging.instance.requestPermission();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  setupInteractedMessage();

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: true,
      criticalAlert: false,
      provisional: true,
      sound: true);
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print(
        'User declined or has not accepted permission ${settings.authorizationStatus}');
  }

  WidgetsFlutterBinding.ensureInitialized();
  // await Geolocator.requestPermission();
  // await initializeService();
  runApp(const MyApp());
  //await DatabaseService.database;
}

// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();
//   // FlutterBackgroundService().invoke("setAsBackground");

//   /// OPTIONAL, using custom notification channel id
//   const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'my_foreground', // id
//     'MY FOREGROUND SERVICE', // title
//     description:
//         'This channel is used for important notifications.', // description
//     importance: Importance.low, // importance must be at low or higher level
//   );

//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   if (Platform.isIOS || Platform.isAndroid) {
//     await flutterLocalNotificationsPlugin.initialize(
//       const InitializationSettings(
//         iOS: DarwinInitializationSettings(),
//         android: AndroidInitializationSettings('ic_bg_service_small'),
//       ),
//     );
//   }

//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);

//   await service.configure(
//     androidConfiguration: AndroidConfiguration(
//       // this will be executed when app is in foreground or background in separated isolate
//       onStart: onStart,

//       // auto start service
//       autoStart: false,
//       autoStartOnBoot: false,
//       isForegroundMode: true,
//       notificationChannelId: 'my_foreground',
//       initialNotificationTitle: 'SISCOM HRIS',
//       initialNotificationContent: 'Initializing',
//       foregroundServiceNotificationId: 888,
//     ),
//     iosConfiguration: IosConfiguration(
//       // auto start service
//       autoStart: false,

//       // this will be executed when app is in foreground in separated isolate
//       onForeground: onStart,

//       // you have to enable background fetch capability on xcode project
//       onBackground: onIosBackground,
//     ),
//   );
// }

// @pragma('vm:entry-point')
// Future<bool> onIosBackground(ServiceInstance service) async {
//   WidgetsFlutterBinding.ensureInitialized();
//   DartPluginRegistrant.ensureInitialized();

//   SharedPreferences preferences = await SharedPreferences.getInstance();
//   await preferences.reload();
//   final log = preferences.getStringList('log') ?? <String>[];
//   log.add(DateTime.now().toIso8601String());
//   await preferences.setStringList('log', log);

//   return true;
// }

// proses tracking
// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//   final controllerTracking = Get.find<TrackingController>(tag: 'iniScreen');
//   final prefs = await SharedPreferences.getInstance();
//   var time = prefs.getString('interval_tracking');
//   Timer? trackingTimer;

//   DartPluginRegistrant.ensureInitialized();

//   if (service is AndroidServiceInstance) {
//     service.on('setAsForeground').listen((event) {
//       service.setAsForegroundService();
//     });

//     service.on('setAsBackground').listen((event) {
//       service.setAsBackgroundService();
//     });
//   }

//   service.on('stopService').listen((event) {
//     service.stopSelf();
//     flutterLocalNotificationsPlugin.cancel(888);
//     trackingTimer?.cancel();
//     trackingTimer = null;
//   });

//   Timer.periodic(const Duration(seconds: 1), (timer) async {
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     // print('lat :${position.latitude.toString()}');
//     // print('long :${position.latitude.toString()}');
//     trackingTimer ??= Timer.periodic(
//         Duration(
//             minutes: int.parse(time ?? "2")), //minutes: int.parse(time ?? "2")
//         (timer) async {
//       controllerTracking.tracking(
//           position.latitude.toString(), position.longitude.toString());
//     });

//     if (service is AndroidServiceInstance) {
//       service.setForegroundNotificationInfo(
//         title: "Background Service",
//         content: "Updated at date ${DateTime.now()}",
//       );
//     }

//     flutterLocalNotificationsPlugin.show(
//       888,
//       'Background Service',
//       'Service Update at date ${DateTime.now()}',
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'my_foreground',
//           'MY FOREGROUND SERVICE',
//           channelDescription:
//               'This channel is used for important notifications.',
//           importance: Importance.low,
//           priority: Priority.low,
//           ongoing: true,
//         ),
//       ),
//     );

//     // print(
//     //     'FLUTTER BACKGROUND SERVICE: ${DateTime.now()} ${AppData.emailUser} -- email ${prefs.getString('selectedDatabase')}');

//     service.invoke('updateLocation', {
//       "latitude": position.latitude.toString(),
//       "longitude": position.longitude.toString(),
//       "timestamp": DateTime.now().toIso8601String(),
//     });
//   });
// }

// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();

//   // OPTIONAL, using custom notification channel id
//   const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'my_foreground', // id
//     'MY FOREGROUND SERVICE', // title
//     description:
//         'This channel is used for important notifications.', // description
//     importance: Importance.low, // default is low, other value is high
//   );

//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   // Create the notification channel
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);

//   await service.configure(
//     androidConfiguration: AndroidConfiguration(
//       onStart: onStart,
//       autoStart: true,
//       isForegroundMode: true,
//       notificationChannelId: channel.id,
//       initialNotificationTitle: 'Background Service',
//       initialNotificationContent: 'Service is running',
//       foregroundServiceNotificationId: 888,
//     ),
//     iosConfiguration: IosConfiguration(
//       autoStart: true,
//       onForeground: onStart,
//       onBackground: onIosBackground,
//     ),
//   );

//    service.startService();
// }

// to ensure this executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch
// bool onIosBackground(ServiceInstance service) {
//   WidgetsFlutterBinding.ensureInitialized();
//   print('FLUTTER BACKGROUND FETCH');
//   return true;
// }
// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//   // Only available for flutter 3.0.0 and later
//   DartPluginRegistrant.ensureInitialized();

//   // For flutter prior to version 3.0.0
//   // We have to register the plugin manually

//   SharedPreferences preferences = await SharedPreferences.getInstance();
//   await preferences.setString("hello", "world");

//   /// OPTIONAL when use custom notification
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   if (service is AndroidServiceInstance) {
//     service.on('setAsForeground').listen((event) {
//       service.setAsForegroundService();
//     });

//     service.on('setAsBackground').listen((event) {
//       service.setAsBackgroundService();
//     });
//   }

//   service.on('stopService').listen((event) {
//     service.stopSelf();
//   });

//   // LocalStorage.prefs = await SharedPreferences.getInstance();
//   // Position position = await Geolocator.getCurrentPosition(
//   //     desiredAccuracy: LocationAccuracy.high);
//   // controllerTracking.tracking(
//   //     position.latitude.toString(), position.longitude.toString());

//   // bring to foreground
//   Timer.periodic(
//       Duration(
//           minutes: int.parse(
//               "1")),
//       (timer) async {
//     print(
//         "timer ${int.parse(AppData.informasiUser == null || AppData.informasiUser!.isEmpty ? '1' : AppData.informasiUser![0].interval_tracking.toString())}");
//     LocalStorage.prefs = await SharedPreferences.getInstance();
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     controllerTracking.tracking(
//         position.latitude.toString(), position.longitude.toString());
//     if (service is AndroidServiceInstance) {
//       if (await service.isForegroundService()) {
//         /// OPTIONAL for use custom notification
//         /// the notification id must be equals with AndroidConfiguration when you call configure() method.
//         flutterLocalNotificationsPlugin.show(
//           888,
//           'COOL SERVICE',
//           'Awesome ${DateTime.now()}',
//           const NotificationDetails(
//             android: AndroidNotificationDetails(
//               'my_foreground',
//               'MY FOREGROUND SERVICE',
//               icon: 'ic_bg_service_small',
//               ongoing: true,
//             ),
//           ),
//         );

//         // if you don't using custom notification, uncomment this
//         service.setForegroundNotificationInfo(
//           title: "SISCOM HRIS",
//           content: "Updated at ${DateTime.now()}",
//         );
//       }
//     }

//     /// you can see this log in logcat
//     print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

//     // test using external plugin
//     final deviceInfo = DeviceInfoPlugin();
//     String? device;
//     if (Platform.isAndroid) {
//       final androidInfo = await deviceInfo.androidInfo;
//       device = androidInfo.model;
//     }

//     if (Platform.isIOS) {
//       final iosInfo = await deviceInfo.iosInfo;
//       device = iosInfo.model;
//     }

//     service.invoke(
//       'update',
//       {
//         "current_date": DateTime.now().toIso8601String(),
//         "device": device,
//       },
//     );
//   });
// }

Future showNotification(message) async {
  // IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails(
  //   threadIdentifier: "thread1",
  // );
  RemoteNotification notification = message.notification;
  // AndroidNotification android = message.notification?.android;
  var bigTextStyleInformation = const BigTextStyleInformation(
    'Body text that will be displayed in full without any truncation. You can add as much text as you need.',
    htmlFormatBigText: true,
    contentTitle: 'Title',
    htmlFormatContentTitle: true,
  );
  flutterLocalNotificationsPlugin.show(
      0,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
            // DateTime.now().millisecondsSinceEpoch.toString(),
            'channelId',
            'channelName',
            // playSound: true,
            // setAsGroupSummary: true,
            // ongoing: true,
            // groupAlertBehavior: GroupAlertBehavior.children,
            // when: 5,
            // maxProgress: 5,
            // progress: 5,
            // // timeoutAfter: 5,
            // channelAction: AndroidNotificationChannelAction.update,
            // visibility: NotificationVisibility.public,
            // onlyAlertOnce: true,
            // showWhen: false,
            // usesChronometer: true,
            // // category: AndroidNotificationCategory.alarm,
            // chronometerCountDown: true,
            // channelShowBadge: false,
            // showProgress: true,
            // indeterminate: true,
            // enableLights: true,
            // fullScreenIntent: true,
            visibility: NotificationVisibility.public,
            styleInformation: BigTextStyleInformation(
              "",
              htmlFormatBigText: true,
              // contentTitle: "",
              // htmlFormatContentTitle: true,
            ),
            priority: Priority.max,
            importance: Importance.max,
            icon: '@mipmap/ic_launcher'),
        iOS: DarwinNotificationDetails(),
      ),
      payload: message.data.toString());

  // flutterLocalNotificationsPlugin.show(
  //     0,
  //     notification.title,
  //     notification.body,
  //     NotificationDetails(
  //       android: AndroidNotificationDetails(
  //           DateTime.now().millisecondsSinceEpoch.toString(), "",
  //           playSound: true,
  //           priority: Priority.high,
  //           importance: Importance.high,
  //           icon: '@mipmap/ic_launcher'

  //           // TODO add a proper drawable resource to android, for now using
  //           //      one that already exists in example app.
  //           ),
  //       iOS: iosNotificationDetails,
  //     ),
  //     payload: "${message}");
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // var info = message.data['body'];
  // print("tes");
  var ringtonePlayer = FlutterRingtonePlayer();
  ringtonePlayer.playNotification();
}

Future<void> setupInteractedMessage() async {
  flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
  var iOS = const DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  var initSetttings = new InitializationSettings(android: android, iOS: iOS);
  flutterLocalNotificationsPlugin.initialize(initSetttings,
      onDidReceiveNotificationResponse: onSelectNotification);

  // Get any messages which caused the application to open from
  // a terminated state.
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();

  // If the message also contains a data property with a "type" of "chat",
  // navigate to a chat screen
  if (initialMessage != null) {
    _handleMessage(initialMessage);
  }

  // Also handle any interaction when the aprRp is in the background via a
  // Stream listener
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    showNotification(message);
    print("ees");

    var ringtonePlayer = FlutterRingtonePlayer();
    ringtonePlayer.playNotification();
  });
  FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
}

var controllerPesan = Get.find<PesanController>();

void _handleMessage(RemoteMessage message) async {
  showNotification(message);
  final messageData = message.data;
  final route = messageData['route'];

  await Future.delayed(const Duration(seconds: 7));
  UtilsAlert.showToast("handle: $messageData");
  switch (route) {
    case 'pesan':
      Get.to(
        ChatPage(
          webSocketChannel:
              IOWebSocketChannel.connect(Uri.parse(Api.webSocket)),
          fullNamePenerima: messageData['full_name'],
          emIdPengirim: AppData.informasiUser![0].em_id,
          emIdPenerima: messageData['em_id_pengirim'],
          imageProfil: messageData['em_image'],
          title: messageData['job_title'],
        ),
      );
      break;
    case 'Lembur':
    case 'Cuti':
    case 'Izin':
    case 'TugasLuar':
    case 'DinasLuar':
    case 'Klaim':
    case 'Payroll':
    case 'Absensi':
    case 'WFH':
    case 'Kasbon':
      // controllerPesan.loadNotifikasi();
      final controllerTab = Get.find<TabbController>();
      controllerTab.currentIndex.value = 3;
      var emIdPengaju = messageData['em_id_pengajuan'];
      var idx = messageData['idx'];
      await Future.delayed(const Duration(seconds: 3), () {
        if (emIdPengaju != AppData.informasiUser![0].em_id && idx != null) {
          controllerPesan.routeApprovalNotif(
            emIdPengaju: emIdPengaju,
            title: route,
            idx: idx,
            delegasi: AppData.informasiUser![0].em_id,
            url: route,
          );
        } else if (emIdPengaju == AppData.informasiUser![0].em_id) {
          controllerPesan.redirectToPage(route, null);
        }
      });
      break;
    default:
      final controllerTab = Get.find<TabbController>();
      controllerTab.currentIndex.value = 0;
  }
}

Future onSelectNotification(notificationResponse) async {
  print(notificationResponse.payload);
  print("payload $notificationResponse");

  String jsonString = notificationResponse.payload.toString();
  // Hapus kurung kurawal dari string
  jsonString = jsonString.substring(1, jsonString.length - 1);

  // Pisahkan pasangan key-value
  List<String> keyValuePairs = jsonString.split(', ');

  // Buat map dari pasangan key-value
  Map<String, String> jsonMap = {};
  for (String pair in keyValuePairs) {
    List<String> parts = pair.split(': ');
    String key = parts[0].trim();
    String value = parts[1].trim();
    jsonMap[key] = value;
  }

  final message = Map.from(jsonMap);
  final route = message['route'];

  switch (route) {
    case 'pesan':
      Get.to(
        ChatPage(
          webSocketChannel:
              IOWebSocketChannel.connect(Uri.parse(Api.webSocket)),
          fullNamePenerima: message['full_name'],
          emIdPengirim: AppData.informasiUser![0].em_id,
          emIdPenerima: message['em_id_pengirim'],
          imageProfil: message['em_image'],
          title: message['job_title'],
        ),
      );
      break;
    case 'Lembur':
    case 'Cuti':
    case 'Izin':
    case 'TugasLuar':
    case 'DinasLuar':
    case 'Klaim':
    case 'Payroll':
    case 'Absensi':
    case 'WFH':
    case 'Kasbon':
      final controllerTab = Get.find<TabbController>();
      controllerTab.currentIndex.value = 3;
      var emIdPengaju = message['em_id_pengajuan'];
      var idx = message['idx'];
      await Future.delayed(const Duration(seconds: 2), () {
        if (emIdPengaju != AppData.informasiUser![0].em_id && idx != null) {
          controllerPesan.routeApprovalNotif(
            emIdPengaju: emIdPengaju,
            title: route,
            idx: idx,
            delegasi: AppData.informasiUser![0].em_id,
            url: route,
          );
        } else if (emIdPengaju == AppData.informasiUser![0].em_id) {
          controllerPesan.redirectToPage(route, null);
        }
      });
      break;
    default:
      final controllerTab = Get.find<TabbController>();
      controllerTab.currentIndex.value = 0;
  }

  // Gunakan map untuk membuat objek
  NotificationsModel notificationsModel = NotificationsModel.fromJson(jsonMap);

  // Cetak propertinya
  print('Route: ${notificationsModel.route}');
  print('Nomor: ${notificationsModel.nomor}');

  // notificationsModel.route == "sales_order"
  //     ? Get.toNamed('/salesOrder')
  //     : notificationsModel.route == "transfer_sementara"
  //         ? Get.toNamed('/temporaryTransfer')
  //         : notificationsModel.route == "purchase_request"
  //             ? Get.toNamed('/purchaseRequest')
  //             : notificationsModel.route == "purchase_order"
  //                 ? Get.toNamed('/purchaseOrder')
  //                 : notificationsModel.route == "deploy_order"
  //                     ? Get.toNamed('/deployOrder')
  //                     : notificationsModel.route == "payment_request"
  //                         ? Get.toNamed('/paymentRequest')
  //                         : null;

  // notificationsModel.route == "sales_order"
  //     ? salesOrderController.detail(nomor: notificationsModel.nomor.toString())
  //     : notificationsModel.route == "transfer_sementara"
  //         ? temporaryTransferController.detail(
  //             nomor: notificationsModel.nomor.toString())
  //         : notificationsModel.route == "purchase_request"
  //             ? purchaseRequestController.detail(
  //                 nomor: notificationsModel.nomor.toString())
  //             : notificationsModel.route == "purchase_order"
  //                 ? purchaseOrderController.detail(
  //                     nomor: notificationsModel.nomor.toString())
  //                 : notificationsModel.route == "deploy_order"
  //                     ? deployOrderController.detail(
  //                         nomor: notificationsModel.nomor.toString())
  //                     : notificationsModel.route == "payment_request"
  //                         ? paymentRequestController.detail(
  //                             nomor: notificationsModel.nomor.toString())
  //                         : null;

  // var emIdPengaju = controller.listData.value[index]['emId_pengaju'];
  // var typeAjuan = controller.listData.value[index]['type'];
  // var idx = controller.listData.value[index]['id'];
  // var delegasi = controller.listData.value[index]['delegasi'];

  // if (notificationsModel.status == "pengajuan") {
  //   notificationsModel.route == "Cuti"
  //       ? Get.to(RiwayatCuti())
  //       : notificationsModel.route == "Izin"
  //           ? Get.to(RiwayatIzin())
  //           : notificationsModel.route == "Tugas Luar"
  //               ? Get.to(TugasLuar())
  //               : notificationsModel.route == "Dinas Luar"
  //                   ? Get.to(TugasLuar())
  //                   : notificationsModel.route == "Klaim"
  //                       ? Get.to(Klaim())
  //                       : notificationsModel.route == "Absensi"
  //                           ? Get.to(HistoryAbsen())
  //                           : notificationsModel.route == "Lembur"
  //                               ? Get.to(Lembur())
  //                               : notificationsModel.route == "Kandidat"
  //                                   ? Get.to(Kandidat())
  //                                   : Get.to(HistoryAbsen());
  // } else {
  //   notificationsModel.route == "Cuti"
  //       ? Get.to(DetailPersetujuanCuti(
  //           emId: notificationsModel.emIdPengaju.toString(),
  //           title: "Cuti",
  //           idxDetail: notificationsModel.id.toString(),
  //           delegasi: notificationsModel.delegasi.toString(),
  //         ))
  //       : notificationsModel.route == "Izin"
  //           ? Get.to(DetailPersetujuanIzin(
  //               emId: notificationsModel.emIdPengaju.toString(),
  //               title: "Izin",
  //               idxDetail: notificationsModel.id.toString(),
  //               delegasi: notificationsModel.delegasi.toString(),
  //             ))
  //           : notificationsModel.route == "Tugas Luar"
  //               ? Get.to(DetailPersetujuanTugasLuar(
  //                   emId: notificationsModel.emIdPengaju.toString(),
  //                   title: "Tugas Luar",
  //                   idxDetail: notificationsModel.id.toString(),
  //                   delegasi: notificationsModel.delegasi.toString(),
  //                 ))
  //               : notificationsModel.route == "Dinas Luar"
  //                   ? Get.to(DetailPersetujuanTugasLuar(
  //                       emId: notificationsModel.emIdPengaju.toString(),
  //                       title: "Dinas Luar",
  //                       idxDetail: notificationsModel.id.toString(),
  //                       delegasi: notificationsModel.delegasi.toString(),
  //                     ))
  //                   : notificationsModel.route == "Klaim"
  //                       ? Get.to(DetailPersetujuanKlaim(
  //                           emId: notificationsModel.emIdPengaju.toString(),
  //                           title: "Klaim",
  //                           idxDetail: notificationsModel.id.toString(),
  //                           delegasi: notificationsModel.delegasi.toString(),
  //                         ))
  //                       : notificationsModel.route == "Payroll"
  //                           ? Get.to(DetailPersetujuanPayroll(
  //                               emId: notificationsModel.emIdPengaju.toString(),
  //                               title: "Payroll",
  //                               idxDetail: notificationsModel.id.toString(),
  //                               delegasi:
  //                                   notificationsModel.delegasi.toString(),
  //                             ))
  //                           : notificationsModel.route == "Absensi"
  //                               ? Get.to(DetailPersetujuanAbsensi(
  //                                   emId: notificationsModel.emIdPengaju
  //                                       .toString(),
  //                                   title: "Absensi",
  //                                   idxDetail: notificationsModel.id.toString(),
  //                                   delegasi:
  //                                       notificationsModel.delegasi.toString(),
  //                                 ))
  //                               : Get.to(DetailPersetujuanAbsensi(
  //                                   emId: notificationsModel.emIdPengaju
  //                                       .toString(),
  //                                   title: "Absensi",
  //                                   idxDetail: notificationsModel.id.toString(),
  //                                   delegasi:
  //                                       notificationsModel.delegasi.toString(),
  //                                 ));
  // }
}

void onDidReceiveLocalNotification(
    int id, String? title, String? body, String? payload) {
  print('id $id');
}

// class Repo {
//   static Repo? _instance;

//   Repo._();

//   factory Repo() => _instance ??= Repo._();

//   // Future<void> tracking(BackgroundLocationUpdateData data) async {
//   //   //  void tracking(String latitude, String longitude) async {
//   //   // print("informasiUser  ");
//   //   print("informasiUser 11 ${AppData.informasiUser![0].em_id}");
//   //   List<Placemark> placemarks =
//   //       await placemarkFromCoordinates(data.lat, data.lon);

//   //   var address =
//   //       "${placemarks[0].street} ${placemarks[0].name}, ${placemarks[0].subLocality}, ${placemarks[0].locality}, ${placemarks[0].subAdministrativeArea}, ${placemarks[0].administrativeArea}, ${placemarks[0].postalCode}";
//   //   print("Alamat kirim ${address}");

//   //   Map<String, dynamic> body = {
//   //     'tanggal': DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
//   //     // 'em_id': AppData.informasiUser == null || AppData.informasiUser!.isEmpty
//   //     //     ? ''
//   //     //     : AppData.informasiUser![0].em_id,

//   //     'em_id': AppData.informasiUser![0].em_id,
//   //     'waktu': DateFormat('HH:mm').format(DateTime.now()).toString(),
//   //     'longitude': data.lon.toString(),
//   //     "latitude": data.lat.toString(),
//   //     'alamat': address.toString(),
//   //     'database': 'demohr',
//   //   };
//   //   print('parameter 2563 ${body}');

//   //   try {
//   //     var response =
//   //         await ApiRequest(url: "employee-tracking-insert", body: body).post();
//   //     print('parameter ${response}');
//   //     var resp = jsonDecode(response.body);

//   //     print('parameter ${resp}');

//   //     if (response.statusCode == 200) {
//   //     } else {}
//   //     // Get.back();
//   //   } catch (e) {
//   //     print(e);
//   //     // Get.back();
//   //   }
//   // }

//   Future<void> update(BackgroundLocationUpdateData data) async {
//     // final text = 'Data: ${data.lat} Lon: ${data.lon}';
//     final text = 'SISCOM HRIS';
//     print(text); // ignore: avoid_print
//     sendNotification(text);

//     await LocationDao().saveLocation(data);
//   }

//   Future<void> submitData(BackgroundLocationUpdateData datat) async {
//     // setState(() {
//     //   loading = true;
//     // });
//     final response = await http.post(
//         Uri.https('www.appfordev.com',
//             'disperindag_web/api_disperindag/pegawai/tambah_location.php'),
//         body: {
//           "username": datat.lat.toString(),
//         });
//     final data = jsonDecode(response.body);
//     print("data json ${data}");
//     if (response.statusCode > 2) {
//       print("image upload");
//       // setState(() {
//       //   widget.reload();
//       //   widget._jumlahNotif();
//       //   Navigator.pop(context);
//       //   alertDialog('berhasil');
//       // });
//     } else {
//       print("image failed");
//     }
//   }
// }

// class LocationDao {
//   static const _locationsKey = 'background_updated_locations';
//   static const _locationSeparator = '-/-/-/';

//   static LocationDao? _instance;

//   LocationDao._();

//   factory LocationDao() => _instance ??= LocationDao._();

//   SharedPreferences? _prefs;

//   Future<SharedPreferences> get prefs async =>
//       _prefs ??= await SharedPreferences.getInstance();

//   Future<void> saveLocation(BackgroundLocationUpdateData data) async {
//     final locations = await getLocations();
//     locations
//         .add('${DateTime.now().toIso8601String()}*${data.lat}*${data.lon}');
//     await (await prefs)
//         .setString(_locationsKey, locations.join(_locationSeparator));
//   }

//   Future<List<String>> getLocations() async {
//     final prefs = await this.prefs;
//     await prefs.reload();
//     final locationsString = prefs.getString(_locationsKey);
//     if (locationsString == null) return [];
//     return locationsString.split(_locationSeparator);
//   }

//   // Future<void> clear() async => (await prefs).clear();
// }

void sendNotification(String text) {
  // const settings = InitializationSettings(
  //   android: AndroidInitializationSettings('app_icon'),
  //   iOS: DarwinInitializationSettings(
  //     requestAlertPermission: false,
  //     requestBadgePermission: false,
  //     requestSoundPermission: false,
  //   ),
  // );
  var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
  var iOS = const DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  var initSetttings = new InitializationSettings(android: android, iOS: iOS);
  FlutterLocalNotificationsPlugin().initialize(
    initSetttings,
    onDidReceiveNotificationResponse: (data) async {
      print('ON CLICK $data'); // ignore: avoid_print
    },
    onDidReceiveBackgroundNotificationResponse: (data) async {
      print('ON CLICK $data'); // ignore: avoid_print
    },
  );

  FlutterLocalNotificationsPlugin().show(
    Random().nextInt(9999),
    'Title',
    text,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'test_notification', 'Test',
        // ongoing: true
      ),
      iOS: DarwinNotificationDetails(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Aplikasi Operasional Siscom',
        theme: ThemeData(
          colorScheme: ColorScheme.light(
            primary: Constanst.onPrimary,
            onPrimary: Constanst.colorWhite,
            onSurface: Constanst.fgPrimary,
            surface: Constanst.colorWhite,
          ),
          visualDensity: VisualDensity.standard,
          dialogTheme: const DialogTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ),
          primaryColor: Constanst.fgPrimary,
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme.apply(
                  bodyColor: Constanst.fgPrimary,
                  displayColor: Constanst.fgPrimary,
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
          datePickerTheme: DatePickerThemeData(
            backgroundColor: Constanst.colorWhite,
            headerBackgroundColor: Constanst.onPrimary,
            dayStyle: TextStyle(color: Constanst.fgPrimary),
            // selectedDayStyle: TextStyle(color: Constanst.colorWhite),
            // todayBackgroundColor: Constanst.fgPrimary,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ),
        ),
        localizationsDelegates: const [
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
        ],
        debugShowCheckedModeBanner: false,
        home: SplashScreen()
        // home: SlipGaji(),
        );
  }
}
void _checkVersion(BuildContext context, InitController controller) async {
  try {
    final newVersion = NewVersionPlus(
      androidId: 'com.siscom.siscomhris',
    );

    final status = await newVersion.getVersionStatus();

    if (status != null && status.localVersion != status.storeVersion) {
      if (context.mounted) {
        _showForceUpdateDialog(context, status.appStoreLink, status.localVersion, status.storeVersion);
      }
    } else {
      if (context.mounted) {
        controller.loadDashboard();
        // UtilsAlert.showToast("Aplikasi sudah versi terbaru.");
      }
    }
  } catch (e) {
    if (context.mounted) {
      UtilsAlert.showToast("Gagal mengecek versi terbaru.");
    }
    debugPrint("Error saat cek versi: $e");
  }
}

void _showForceUpdateDialog(BuildContext context, String appStoreLink, String localVersion, String storeVersion) {
  showDialog(
    context: context,
    barrierDismissible: false, 
    builder: (context) => WillPopScope(
      onWillPop: () async => false, 
      child: AlertDialog(
        title: const Text("Update Diperlukan"),
        content: Text(
            "Versi saat ini ($localVersion) sudah tidak didukung. Silakan perbarui ke versi terbaru ($storeVersion) untuk melanjutkan."),
        actions: [
          TextButton(
            onPressed: () async {
              final url = Uri.parse(appStoreLink);
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } else {
                UtilsAlert.showToast("Gagal membuka Play Store");
              }
            },
            child: const Text("Update Sekarang"),
          ),
        ],
      ),
    ),
  );
}


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final controller = Get.find<InitController>();

  @override
  void initState() {
    _checkVersion(context, controller);
    Get.put(AbsenController(), tag: 'absen controller');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Constanst.colorWhite,
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(19)
            // ),
            // decoration: const BoxDecoration(
            //     image: DecorationImage(
            //         alignment: Alignment.topCenter,
            //         image: AssetImage('assets/Splash.png'),
            //         fit: BoxFit.cover)
            //         ),
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: Image.asset(
                        'assets/logo_login.png',
                        width: MediaQuery.of(context).size.width / 2,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Text(
                              "© Copyright 2022 PT. Shan Informasi Sistem\nBuilld Version 2022.10.17",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: HexColor('#68778D'), fontSize: 10)),
                        ),
                      ),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}

// import 'dart:io';

// import 'package:camera/camera.dart';

// import 'package:flutter/material.dart';

// List<CameraDescription> cameras = [];

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   cameras = await availableCameras();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Home(),
//     );
//   }
// }

// class Home extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Google ML Kit Demo App'),
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               child: Column(
//                 children: [
//                   ExpansionTile(
//                     title: const Text("Vision"),
//                     children: [
//                       CustomCard(
//                         'Face Detector',
//                         Container(),
//                         featureCompleted: true,
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class CustomCard extends StatelessWidget {
//   final String _label;
//   final Widget _viewPage;
//   final bool featureCompleted;

//   const CustomCard(this._label, this._viewPage,
//       {this.featureCompleted = false});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 5,
//       margin: EdgeInsets.only(bottom: 10),
//       child: ListTile(
//         tileColor: Theme.of(context).primaryColor,
//         title: Text(
//           _label,
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         onTap: () {
//           if (Platform.isIOS && !featureCompleted) {
//             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                 content: const Text(
//                     'This feature has not been implemented for iOS yet')));
//           } else
//             Navigator.push(
//                 context, MaterialPageRoute(builder: (context) => _viewPage));
//         },
//       ),
//     );
//   }
// }

// import 'package:camera/camera.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:siscom_operasional/scanner_screeen.dart';

// late List<CameraDescription> cameras;

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return CupertinoApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Photo Scanner',
//       home: ScannerScreen(),
//       theme: CupertinoThemeData(brightness: Brightness.dark),
//     );
//   }
// }


// import 'package:example/screens/login_page.dart';
// import 'package:example/screens/register_page.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const CupertinoApp(
//       debugShowCheckedModeBanner: false,
//       home: MyHome(),
//     );
//   }
// }

// class MyHome extends StatelessWidget {
//   final Color kDarkBlueColor = const Color(0xFF053149);

//   const MyHome({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return OnBoardingSlider(
//       finishButtonText: 'Register',
//       onFinish: () {
//         // Navigator.push(
//         //   context,
//         //   CupertinoPageRoute(
//         //     builder: (context) => const RegisterPage(),
//         //   ),
//         // );
//       },
//       finishButtonStyle: FinishButtonStyle(
//         backgroundColor: kDarkBlueColor,
//       ),
//       skipTextButton: Text(
//         'Skip',
//         style: TextStyle(
//           fontSize: 16,
//           color: kDarkBlueColor,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//       trailing: Text(
//         'Login',
//         style: TextStyle(
//           fontSize: 16,
//           color: kDarkBlueColor,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//       trailingFunction: () {
//         // Navigator.push(
//         //   context,
//         //   CupertinoPageRoute(
//         //     builder: (context) => const LoginPage(),
//         //   ),
//         // );
//       },
//       controllerColor: kDarkBlueColor,
//       totalPage: 3,
//       headerBackgroundColor: Colors.white,
//       pageBackgroundColor: Colors.white,
//       background: [
//         Image.asset(
//           'assets/slide_1.png',
//           height: 400,
//         ),
//         Image.asset(
//           'assets/slide_2.png',
//           height: 400,
//         ),
//         Image.asset(
//           'assets/slide_3.png',
//           height: 400,
//         ),
//       ],
//       speed: 1.8,
//       pageBodies: [
//         Container(
//           alignment: Alignment.center,
//           width: MediaQuery.of(context).size.width,
//           padding: const EdgeInsets.symmetric(horizontal: 40),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               const SizedBox(
//                 height: 480,
//               ),
//               Text(
//                 'On your way...',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: kDarkBlueColor,
//                   fontSize: 24.0,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               const Text(
//                 'to find the perfect looking Onboarding for your app?',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Colors.black26,
//                   fontSize: 18.0,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Container(
//           alignment: Alignment.center,
//           width: MediaQuery.of(context).size.width,
//           padding: const EdgeInsets.symmetric(horizontal: 40),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               const SizedBox(
//                 height: 480,
//               ),
//               Text(
//                 'You’ve reached your destination.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: kDarkBlueColor,
//                   fontSize: 24.0,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               const Text(
//                 'Sliding with animation',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Colors.black26,
//                   fontSize: 18.0,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Container(
//           alignment: Alignment.center,
//           width: MediaQuery.of(context).size.width,
//           padding: const EdgeInsets.symmetric(horizontal: 40),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               const SizedBox(
//                 height: 480,
//               ),
//               Text(
//                 'Start now!',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: kDarkBlueColor,
//                   fontSize: 24.0,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               const Text(
//                 'Where everything is possible and customize your onboarding.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Colors.black26,
//                   fontSize: 18.0,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }