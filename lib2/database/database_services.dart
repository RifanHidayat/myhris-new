import 'package:get/get.dart';
import 'package:siscom_operasional/controller/chatting.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


// class DatabaseService {
//   static Database? _database;
//   static final kategoriDB = Get.put(ChattingController());

//   static Future<Database> get database async {
//     if (_database != null) {
//       return _database!;
//     }
//     _database = await _initialize();
//     return _database!;
//   }

//   static Future<String> get fullPath async {
//     return join(await getDatabasesPath(), 'sis.db');
//   }

//   static Future<Database> _initialize() async {
//     final path = await fullPath;
//     return openDatabase(path,
//         version: 2, onCreate: _create, singleInstance: true);
//   }

//   static Future<void> _create(Database db, int version) async {
//     await kategoriDB.createTable(db);
//     // await _barangDB.createTable(db);

//     // await _barangDB.insert(db,
//     //     namaBarang: "Mie Instan Goreng",
//     //     kategoriId: 1,
//     //     stok: 10,
//     //     kelompokBarang: "Mie",
//     //     harga: 4000);
//     // await _barangDB.insert(db,
//     //     namaBarang: "Keripik Kentang",
//     //     kategoriId: 1,
//     //     stok: 4,
//     //     kelompokBarang: "Snack",
//     //     harga: 12000);
//     // await _barangDB.insert(db,
//     //     namaBarang: "Es Buah",
//     //     kategoriId: 2,
//     //     stok: 5,
//     //     kelompokBarang: "Minuman Segar",
//     //     harga: 8000);
//     // await _barangDB.insert(db,
//     //     namaBarang: "Americano",
//     //     kategoriId: 2,
//     //     stok: 5,
//     //     kelompokBarang: "Kopi",
//     //     harga: 10000);
//   }
// }
