import 'dart:convert';

class Peraturan {
  var title;
  var keterangan;
  var tanggal_berlaku;
  var gambar;

  Peraturan({
    this.title,
    this.keterangan,
    this.tanggal_berlaku,
    this.gambar,
  });
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'keterangan': keterangan,
      'tanggal_berlaku': tanggal_berlaku,
      'gambar': gambar,
    };
  }

  factory Peraturan.fromMap(Map<String, dynamic> map) {
    return Peraturan(
      title: map['title'] ?? "kosong",
      keterangan: map['keterangan'] ?? "kosong",
      tanggal_berlaku: map['tanggal_berlaku']??"kosong",
      gambar: map['gambar']??"kosong",
    );
  }
  String toJson() => json.encode(toMap());
}
