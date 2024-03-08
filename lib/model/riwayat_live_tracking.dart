import 'dart:convert';

List<RiwayatLiveTrackingModel> RiwayatLiveTrackingModelFromJson(String str) =>
    List<RiwayatLiveTrackingModel>.from(
        json.decode(str).map((x) => RiwayatLiveTrackingModel.fromJson(x)));

String RiwayatLiveTrackingModelToJson(List<RiwayatLiveTrackingModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RiwayatLiveTrackingModel {
  var atten_date;
  var deskripsi;

  RiwayatLiveTrackingModel({
    this.atten_date,
    this.deskripsi,
  });

  factory RiwayatLiveTrackingModel.fromJson(Map<String, dynamic> json) =>
      RiwayatLiveTrackingModel(
        atten_date: json["atten_date"] ?? "",
        deskripsi: json["deskripsi"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "atten_date": atten_date,
        "deskripsi": deskripsi,
      };

  static List<RiwayatLiveTrackingModel> fromJsonToList(List data) {
    return List<RiwayatLiveTrackingModel>.from(data.map(
      (item) => RiwayatLiveTrackingModel.fromJson(item),
    ));
  }
}
