import 'dart:convert';

List<TrackingListModel> TrackingListModelFromJson(String str) =>
    List<TrackingListModel>.from(
        json.decode(str).map((x) => TrackingListModel.fromJson(x)));

String TrackingListModelToJson(List<TrackingListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TrackingListModel {
  var em_id;
  var full_name;
  var em_role;
  var em_address;
  var em_image;
  var em_tracking;
  var token_notif;

  TrackingListModel({
    this.em_id,
    this.full_name,
    this.em_role,
    this.em_address,
    this.em_image,
    this.em_tracking,
    this.token_notif,
  });

  factory TrackingListModel.fromJson(Map<String, dynamic> json) =>
      TrackingListModel(
        em_id: json["em_id"] ?? "",
        full_name: json["full_name"] ?? "",
        em_role: json["em_role"] ?? "",
        em_address: json["em_address"] ?? "",
        em_image: json["em_image"] ?? "",
        em_tracking: json["em_tracking"] ?? "",
        token_notif: json["token_notif"],
      );

  Map<String, dynamic> toJson() => {
        "em_id": em_id,
        "full_name": full_name,
        "em_role": em_role,
        "em_address": em_address,
        "em_image": em_image,
        "em_tracking": em_tracking,
        "token_notif": token_notif,
      };

  static List<TrackingListModel> fromJsonToList(List data) {
    return List<TrackingListModel>.from(data.map(
      (item) => TrackingListModel.fromJson(item),
    ));
  }
}
