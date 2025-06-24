import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqliteDatabaseHelper {
  static final SqliteDatabaseHelper _instance =
      SqliteDatabaseHelper._internal();
  static Database? _database;

  factory SqliteDatabaseHelper() {
    return _instance;
  }

  SqliteDatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'my_database_hris.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    // Membuat table absensi
    await db.execute('''
      CREATE TABLE absensi (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        em_id TEXT,
        atten_date TEXT,
        signing_time TEXT,
        signout_time TEXT,
        place_in TEXT,
        place_out TEXT,
        signin_longlat TEXT,
        signout_longlat TEXT,
        signin_pict TEXT,
        signout_pict TEXT,
        signin_note TEXT,
        signout_note TEXT,
        signin_addr TEXT,
        signout_addr TEXT
      )
    ''');

    // await db.execute('''
    //   CREATE TABLE absensi_dua (
    //     signing_time TEXT,
    //     signout_time TEXT,
    //     status Text
    //   )
    // ''');

    // Membuat table menu
    await db.execute('''
      CREATE TABLE menu (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT,
        url TEXT,
        gambar TEXT,
        status TEXT
      )
    ''');

    // Membuat table menu utama
    await db.execute('''
      CREATE TABLE menu_utama (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT,
        url TEXT,
        gambar TEXT,
        status TEXT
      )
    ''');

    // Membuat table banner
    await db.execute('''
      CREATE TABLE banner (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        img TEXT
      )
    ''');

    // Membuat table tipe_lokasi
    await db.execute('''
      CREATE TABLE tipe_lokasi (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        place TEXT,
        place_longlat TEXT,
        place_radius REAL
      )
    ''');
  }

  // banner
  Future<void> insertBanners(List<Map<String, dynamic>> banners) async {
    final db = await database;
    await db.delete('banner');
    for (var banner in banners) {
      await db.insert(
        'banner',
        banner,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<Map<String, dynamic>>> getBanners() async {
    final db = await database;
    return await db.query('banner');
  }

  // menu
  Future<void> insertMenus(List<Map<String, dynamic>> menus) async {
    final db = await database;
    await db.delete('menu');
    for (var menu in menus) {
      await db.insert(
        'menu',
        menu,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<Map<String, dynamic>>> getMenus() async {
    final db = await database;
    return await db.query('menu');
  }

  // menu utama
  Future<void> insertMenusUtama(List<Map<String, dynamic>> menus) async {
    final db = await database;
    await db.delete('menu_utama');
    for (var menu in menus) {
      await db.insert(
        'menu_utama',
        menu,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<Map<String, dynamic>>> getMenusUtama() async {
    final db = await database;
    return await db.query('menu_utama');
  }

  //tipe_lokasi
  Future<void> insertTipeLokasi(
      List<Map<String, dynamic>> tipeLokasiList) async {
    final db = await database;
    await db.delete('tipe_lokasi');
    for (var tipeLokasi in tipeLokasiList) {
      await db.insert(
        'tipe_lokasi',
        tipeLokasi,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<Map<String, dynamic>>> getTipeLokasi() async {
    final db = await database;
    return await db.query('tipe_lokasi');
  }

  //absensi
  Future<void> insertAbsensi(Map<String, dynamic> absensi, Function onSuccess,
      Function onError) async {
    final db = await database;
    try {
      int rowId = await db.insert('absensi', absensi);
      if (rowId > 0) {
        onSuccess();
      } else {
        onError("Gagal menyimpan data");
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  Future<int> updateAbsensi(Map<String, dynamic> absensi) async {
    final db = await database;
    return await db.update(
      'absensi',
      absensi,
    );
  }

  Future<void> deleteAbsensi() async {
    final db = await database;
    try {
      await db.rawDelete(
          'DELETE FROM absensi WHERE id = (SELECT MIN(id) FROM absensi)');
      print('Data teratas berhasil dihapus');
    } catch (e) {
      print('Error saat menghapus data teratas: $e');
    }
  }

  Future<Map<String, dynamic>?> getAbsensi() async {
    final db = await database;
    var result = await db.query('absensi');
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  //absensi dua
  // Future<void> insertAbsensiDua(Map<String, dynamic> absensi,
  //     Function onSuccess, Function onError) async {
  //   final db = await database;
  //   try {
  //     int rowId = await db.insert('absensi_dua', absensi);
  //     if (rowId > 0) {
  //       onSuccess();
  //     } else {
  //       onError("Gagal menyimpan data");
  //     }
  //   } catch (e) {
  //     onError(e.toString());
  //   }
  // }

  // Future<int> updateAbsensiDua(Map<String, dynamic> absensi) async {
  //   final db = await database;
  //   return await db.update(
  //     'absensi_dua',
  //     absensi,
  //   );
  // }

  // Future<void> deleteAbsensiDua() async {
  //   final db = await database;
  //   await db.delete('absensi_dua');
  // }

  // Future<Map<String, dynamic>?> getAbsensiDua() async {
  //   final db = await database;
  //   var result = await db.query('absensi_dua');
  //   if (result.isNotEmpty) {
  //     return result.first;
  //   }
  //   return null;
  // }
}
