// import 'dart:convert';

// import 'package:flutter/widgets.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:siscom_operasional/model/chat.dart';

// import '../database/database_services.dart';
// import '../services/request.dart';
// import '../utils/app_data.dart';
// import 'package:sqflite/sqflite.dart';

// class ChattingController extends GetxController {
//   late final Database db;
//   @override
//   void onInit() async {
//     // TODO: implement onInit
//     super.onInit();
//     db = await DatabaseService.database;
//     refresh();
//   }

//   var messageCtr = TextEditingController().obs;

//   final tableName = 'em_chat';
//   var emIdUser="".obs;

//   var chat = <ChatModel>[].obs;

//   Future<void> createTable(Database db) async {
//     await db.execute('''
//       CREATE TABLE IF NOT EXISTS $tableName (
//         "id" INTEGER PRIMARY KEY AUTOINCREMENT,
//         "em_id_pengirim" TEXT,
//         "em_id_penerima" TEXT,
//         "tanggal" TEXT,
//         "waktu" TEXT,
//         "pesan" TEXT,
//         "is_kirim" INTEGER,
//         "is_read" INTEGER

//       );
//     ''');
//   }

//   var data = [
//     {
//       "message":
//           "3423cv 3223 23234324 32 Hello Ade 3423cv 3223 23234324 32 Hello Ade 3423cv 3223 23234324 32 Hello Ade 3423cv 3223 23234324 32 Hello Ade",
//       "images": "",
//       "tanggal": "03/07/2024",
//       "Waktu": "03:01:01",
//       "is_read": "1",
//       "em_id_sender": "SIS20220040",
//       "terkirim": ""
//     },
//     {
//       "message":
//           "Hello Ade 3423cv 3223 23234324 32 Hello Ade 3423cv 3223 23234324 32 Hello Ade 3423cv 3223 23234324 32 Hello Ade 3423cv 3223 23234324 32 Hello Ade 3423cv 3223 23234324 3 2 Hello Ade 3423cv 3223 23234324 3 2  Hello Ade 3423cv 3223 23234324 32 Hello Ade 3423cv 3223 23234324 32",
//       "images": "",
//       "tanggal": "03/07/2024",
//       "Waktu": "03:01:01",
//       "is_read": "1",
//       "em_id_sender": AppData.informasiUser![0].em_id.toString().trim(),
//       "terkirim": ""
//     },
//   ].obs;

//   void fetchLocal() async {
//     fetchAll(db).then((value) {
//       chat.value = value;
//       update();
//     });
//   }

//   Future<void> insertToServer() async {
//     var dataList = [];
//     print("insert bulk");
//     var data = chat.where((p0) => p0.isKirim.toString().trim() == "0").toList();
//         print("insert bulk ${chat[0].isKirim}");
//     if (data.length > 0) {
//       try {
//         data.forEach((element) {
//           var datum = [
//             element.emIdPenerima,
//             element.emIdPengirim,
//             element.message,
//             element.tanggal,
//             element.waktu
//           ];
//           dataList.add(datum);
//         });
//         var body = {"data": dataList};

//         print(body);
        

//         var response = await Request(url: "chatting-bulk", body: body).post();
//         var resp = jsonDecode(response.body);
//         print("resp ${resp}");
//         updateIsirim(data: data);

//         if (response.statusCode == 200) {
  
//         } else {
      
//         }
//       } catch (e) {
//         print(e);
      
//       }
//     }
//   }

//   void updateIsirim({List<ChatModel>? data}) async {
//     data!.forEach((element) async {
//       await db.update(
//           tableName,
//           {
//             'is_kirim': "1",
//           },
//           where: 'id = ?',
//           whereArgs: [element.id]);
//     });
//   }

//   Future<List<ChatModel>> fetchAll(Database db) async {
//     final result = await db.query(tableName, orderBy: "id ASC",where: "(em_id_pengirim=? AND em_id_penerima=?) OR (em_id_pengirim=? AND em_id_penerima=?) ",whereArgs: [AppData.informasiUser![0].em_id,emIdUser.value,emIdUser.value,AppData.informasiUser![0].em_id]);
//     return result.map((e) => ChatModel.fromJson(e)).toList();
//   }

//   Future<void> insert(Database db,
//       {required String emIdPengirim,
//       required String emIdPenerima,
//       required pesan}) async {
//     var body = {
//       'em_id_pengirim': emIdPenerima.toString(),
//       'em_id_penerima': emIdPengirim.toString(),
//       'tanggal': DateTime.now().toString(),
//       'waktu': DateFormat('hh:mm:ss').format(DateTime.now()).toString(),
//       'pesan': pesan.toString(),
//       'is_kirim': '0',
//       'is_read': '0'
//     };
//     print("body ${body}");
//     await db.insert(tableName, {
//       'em_id_pengirim': emIdPenerima.toString(),
//       'em_id_penerima': emIdPengirim.toString(),
//       'tanggal': DateTime.now().toString(),
//       'waktu': DateFormat('hh:mm:ss').format(DateTime.now()).toString(),
//       'pesan': pesan.toString(),
//       'is_kirim': '0',
//       'is_read': '0'
//     });
//     messageCtr.value.clear();
//     refresh();
//     insertToServer();
//   }

//   void refresh() async {
//     fetchAll(db);
//     fetchLocal();
//   }
// }
