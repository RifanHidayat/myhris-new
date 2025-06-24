class ChangeLog {
  var id;
  var nama;
  var tanggal;
  var deskripsi;

  ChangeLog({
    this.id,
    this.nama,
    this.tanggal,
    this.deskripsi,
  });

  factory ChangeLog.fromJson(Map<String, dynamic> json) {
    return ChangeLog(
      id: json['id'],
      nama: json['nama'],
      tanggal: json['tanggal'],
      deskripsi: json['deskripsi'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "tanggal": tanggal,
        "deskripsi": deskripsi,
      };

  List<dynamic> get deskripsiList {
    return deskripsi.split(',').map((item) => item.trim().toString()).toList();
  }
}
