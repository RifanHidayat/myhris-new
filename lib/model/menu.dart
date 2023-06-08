// To parse this JSON data, do
//
//     final menuModel = menuModelFromJson(jsonString);

import 'dart:convert';

List<MenuModel> menuModelFromJson(String str) => List<MenuModel>.from(json.decode(str).map((x) => MenuModel.fromJson(x)));

String menuModelToJson(List<MenuModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MenuModel {
  var emId;
  var menuId;
  var id;
  var nama;
  var url;
  var gambar;
  var status;

    MenuModel({
        required this.emId,
        required this.menuId,
        required this.id,
        required this.nama,
        required this.url,
        required this.gambar,
        required this.status,
    });

    factory MenuModel.fromJson(Map<String, dynamic> json) => MenuModel(
        emId: json["em_id"],
        menuId: json["menu_id"],
        id: json["id"],
        nama: json["nama"],
        url: json["url"],
        gambar: json["gambar"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "em_id": emId,
        "menu_id": menuId,
        "id": id,
        "nama": nama,
        "url": url,
        "gambar": gambar,
        "status": status,
    };

     static List<MenuModel> fromJsonToList(List data) {
    return List<MenuModel>.from(data.map(
      (item) => MenuModel.fromJson(item),
    ));
  }
}
