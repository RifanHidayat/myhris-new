import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:siscom_operasional/controller/global_controller.dart';
import 'package:siscom_operasional/controller/pesan_controller.dart';
import 'package:siscom_operasional/controller/tab_controller.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siscom_operasional/controller/approval_controller.dart';
import 'package:siscom_operasional/controller/init_controller.dart';
import 'package:siscom_operasional/fireabase_option.dart';
import 'package:siscom_operasional/model/notification.dart';
import 'package:siscom_operasional/screen/chatting/chat_page.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/local_storage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'dart:io';
import 'package:web_socket_channel/io.dart';
import 'utils/app_data.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
late List<CameraDescription> cameras;

Future<void> main() async {
  Get.put(InitController());
  Get.put(GlobalController());
  Get.put(ApprovalController());
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.dark,
  ));
  await GetStorage.init();
  // AppData.clearAllData();

  cameras = await availableCameras();

  LocalStorage.prefs = await SharedPreferences.getInstance();

  if (Platform.isIOS) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.ios);
  } else {
    await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.android,
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
  runApp(const MyApp());

}

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

}

void onDidReceiveLocalNotification(
    int id, String? title, String? body, String? payload) {
  print('id $id');
}


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

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final controller = Get.find<InitController>();
  final pesanController = Get.put(PesanController());

  @override
  void initState() {
    controller.loadDashboard();
    pesanController.getTimeNow();
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
