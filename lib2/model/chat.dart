// To parse this JSON data, do
//
//     final ChatModel = ChatModelFromJson(jsonString);

import 'dart:convert';

import 'package:get_storage/get_storage.dart';

List<ChatModel> ChatModelFromJson(String str) =>
    List<ChatModel>.from(json.decode(str).map((x) => ChatModel.fromJson(x)));

String ChatModelToJson(List<ChatModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChatModel {
  var emIdPengirim;
  var emIdPenerima;
  var tanggal;
  var waktu;
  var message;
  var isKirim;
  var id;

  ChatModel(
      {this.emIdPenerima,
      this.emIdPengirim,
      this.tanggal,
      this.waktu,
      this.message,
      this.isKirim,
      this.id});

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
      emIdPenerima: json["em_id_pengirim"],
      emIdPengirim: json["em_id_penerima"],
      tanggal: json["tanggal"],
      waktu: json["waktu"],
      message: json["pesan"],
      isKirim: json['is_kirim'],
      id: json['id']);

  Map<String, dynamic> toJson() => {
        "em_pengirim": emIdPenerima,
        "em_penerima": emIdPenerima,
        "tanggal": tanggal,
        "waktu": waktu,
        "pesan": message,
        "is_kirim": isKirim,
        "id":id
      };

  static List<ChatModel> fromJsonToList(List data) {
    return List<ChatModel>.from(data.map(
      (item) => ChatModel.fromJson(item),
    ));
  }
}
