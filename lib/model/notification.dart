class NotificationsModel {
  String route;
  String nomor;
  String status;
  String emIdPengaju;
  String id;
  String delegasi;

  NotificationsModel({
    required this.route,
    required this.nomor,
    required this.status,
    required this.emIdPengaju,
    required this.id,
    required this.delegasi,
  });

  factory NotificationsModel.fromJson(Map<String, String> json) {
    return NotificationsModel(
      route: json['route']!,
      nomor: json['nomor']!,
      status: json['status']!,
      emIdPengaju: json['em_id']!,
      id: json['id']!,
      delegasi: json['delegasi']!,
    );
  }
}
