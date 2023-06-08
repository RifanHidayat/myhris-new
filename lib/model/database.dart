// To parse this JSON data, do
//
//     final databaseModel = databaseModelFromJson(jsonString);

import 'dart:convert';

import 'package:get_storage/get_storage.dart';

List<DatabaseModel> databaseModelFromJson(String str) => List<DatabaseModel>.from(json.decode(str).map((x) => DatabaseModel.fromJson(x)));

String databaseModelToJson(List<DatabaseModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DatabaseModel {
    var  email;
    var dbname;
    var pos;
  var password;
    var  name;
    var isSelected;

    DatabaseModel({
       this.email,
         this.dbname,
     this.pos,
       this.password,
     this.name,
     this.isSelected
    });

    factory DatabaseModel.fromJson(Map<String, dynamic> json) => DatabaseModel(
        email: json["email"],
        dbname: json["dbname"],
        pos: json["pos"],
        password: json["password"],
        name: json["name"],
        isSelected: json['is_selected']??false
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "dbname": dbname,
        "pos": pos,
        "password": password,
        "name": name,
    };

      static List<DatabaseModel> fromJsonToList(List data) {
    return List<DatabaseModel>.from(data.map(
      (item) => DatabaseModel.fromJson(item),
    ));
  }
}
