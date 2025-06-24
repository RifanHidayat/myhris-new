import 'dart:convert';

List<DetailTrackingModel> DetailTrackingModelFromJson(String str) =>
    List<DetailTrackingModel>.from(
        json.decode(str).map((x) => DetailTrackingModel.fromJson(x)));

String DetailTrackingModelToJson(List<DetailTrackingModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DetailTrackingModel {
  var em_id;
  var atten_date;
  var time;
  var longlat;
  var address;

  DetailTrackingModel({
    this.em_id,
    this.atten_date,
    this.time,
    this.longlat,
    this.address,
  });

  factory DetailTrackingModel.fromJson(Map<String, dynamic> json) =>
      DetailTrackingModel(
        em_id: json["em_id"] ?? "",
        atten_date: json["atten_date"] ?? "",
        time: json["time"] ?? "",
        longlat: json["longlat"] ?? "",
        address: json["address"] ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "em_id": em_id,
        "atten_date": atten_date,
        "time": time,
        "longlat": longlat,
        "address": address,
      };

  static List<DetailTrackingModel> fromJsonToList(List data) {
    return List<DetailTrackingModel>.from(data.map(
      (item) => DetailTrackingModel.fromJson(item),
    ));
  }
}
