// To parse this JSON data, do
//
//     final bpjsKetenagakerjaanModel = bpjsKetenagakerjaanModelFromJson(jsonString);

import 'dart:convert';

List<BpjsKetenagakerjaanModel> bpjsKetenagakerjaanModelFromJson(String str) =>
    List<BpjsKetenagakerjaanModel>.from(
        json.decode(str).map((x) => BpjsKetenagakerjaanModel.fromJson(x)));

String bpjsKetenagakerjaanModelToJson(List<BpjsKetenagakerjaanModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BpjsKetenagakerjaanModel {
  BpjsKetenagakerjaanModel({
    this.jkkTk,
    this.jkkTkPercent,
    this.jkmTk,
    this.jkmTkPercent,
    this.jhtPt,
    this.jhtPtPercent,
    this.jhtTk,
    this.jhtTkPercent,
    this.jppPt,
    this.jppPtPercent,
    this.jppTk,
    this.jppTkPercent,
    this.emBpjsTenagakerja,
    this.fullName,
  });

  var jkkTk;
  var jkkTkPercent;
  var jkmTk;
  var jkmTkPercent;

  var jhtPt;
  var jhtPtPercent;
  var jhtTk;
  var jhtTkPercent;

  var jppPt;
  var jppPtPercent;
  var jppTk;
  var jppTkPercent;

  var emBpjsTenagakerja;
  var fullName;

  factory BpjsKetenagakerjaanModel.fromJson(Map<String, dynamic> json) =>
      BpjsKetenagakerjaanModel(
        jkkTk: json["jkk_tk"],
        jkkTkPercent: json["jkk_tk_percent"],
        jkmTk: json["jkm_tk"],
        jkmTkPercent: json["jkm_tk_percent"],
        jhtPt: json["jht_pt"],
        jhtPtPercent: json["jht_pt_percent"],
        jhtTk: json["jht_tk"],
        jhtTkPercent: json["jht_tk_percent"],
        jppPt: json["jpp_pt"],
        jppPtPercent: json["jpp_pt_percent"],
        jppTk: json["jpp_tk"],
        jppTkPercent: json["jpp_tk_percent"],
        emBpjsTenagakerja: json["em_bpjs_tenagakerja"],
        fullName: json["full_name"],
      );

  Map<String, dynamic> toJson() => {
        "jkk_tk": jkkTk,
        "jkk_tk_percent": jkkTkPercent,
        "jkm_tk": jkmTk,
        "jkm_tk_percent": jkmTkPercent,
        "jht_pt": jhtPt,
        "jht_pt_percent": jhtPtPercent,
        "jht_tk": jhtTk,
        "jht_tk_percent": jhtTkPercent,
        "jpp_pt": jppPt,
        "jpp_pt_percent": jppPtPercent,
        "jpp_tk": jppTk,
        "jpp_tk_percent": jppTkPercent,
        "em_bpjs_tenagakerja": emBpjsTenagakerja,
        "full_name": fullName,
      };

  static List<BpjsKetenagakerjaanModel> fromJsonToList(List data) {
    return List<BpjsKetenagakerjaanModel>.from(data.map(
      (item) => BpjsKetenagakerjaanModel.fromJson(item),
    ));
  }
}
