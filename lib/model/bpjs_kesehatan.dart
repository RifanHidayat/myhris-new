// To parse this JSON data, do
//
//     final bpjsKesehatanModel = bpjsKesehatanModelFromJson(jsonString);

import 'dart:convert';

List<BpjsKesehatanModel> bpjsKesehatanModelFromJson(String str) =>
    List<BpjsKesehatanModel>.from(
        json.decode(str).map((x) => BpjsKesehatanModel.fromJson(x)));

String bpjsKesehatanModelToJson(List<BpjsKesehatanModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BpjsKesehatanModel {
  BpjsKesehatanModel({
    this.pt,
    this.pt_percent,
    this.tk,
    this.tk_percent,
    this.premit,
    this.premi_percent,
    this.emBpjsKesehatan,
    this.fullName,
  });

  var pt;
  var pt_percent;
  var tk;
  var tk_percent;
  var premit;
  var premi_percent;
  var emBpjsKesehatan;
  var fullName;

  factory BpjsKesehatanModel.fromJson(Map<String, dynamic> json) =>
      BpjsKesehatanModel(
        pt: json["pt"],
        pt_percent: json["pt_percent"],
        tk: json["tk"],
        tk_percent: json["tk_percent"],
        premit: json["premit"],
        premi_percent: json["premi_percent"],
        emBpjsKesehatan: json["em_bpjs_kesehatan"],
        fullName: json["full_name"],
      );

  Map<String, dynamic> toJson() => {
        "pt": pt,
        "pt_percent": pt_percent,
        "tk": tk,
        "tk_percent": tk_percent,
        "premit": premit,
        "premi_percent": premi_percent,
        "em_bpjs_kesehatan": emBpjsKesehatan,
        "full_name": fullName,
      };

  static List<BpjsKesehatanModel> fromJsonToList(List data) {
    return List<BpjsKesehatanModel>.from(data.map(
      (item) => BpjsKesehatanModel.fromJson(item),
    ));
  }
}
