import 'dart:convert';

class Peringatan {
  var id;
  var posisi;
  var nama;
  var sp;
  var hal;
  var nomor;
  var tanggalSuratDiberikan;
  var title;
  var tgl_surat;
  var em_id;
  var letter_id;
  var eff_date;
  var file_esign;
  var upload_file;
  var alasan;
  var approve_id;
  var approve_date;
  var status;
  var approve_by;
  var approve_status;
  var approve2_id;
  var approve2_date;
  var approve2_by;
  var approve2_status;
  var created_by;
  var created_on;
  var modified_by;
  var modified_on;
  var bab;
  var pasal;
  var nomorPasal;
  var lokasi;
  var isView;
  var pelanggaran;
  var nomor_surat;
  var diterbitkan_oleh;

  Peringatan(
      {this.id,
      this.posisi,
      this.nama,
      this.sp,
      this.nomor,
      this.tanggalSuratDiberikan,
      this.title,
      this.tgl_surat,
      this.em_id,
      this.letter_id,
      this.eff_date,
      this.upload_file,
      this.alasan,
      this.approve_id,
      this.approve_date,
      this.status,
      this.file_esign,
      this.approve_by,
      this.approve_status,
      this.approve2_id,
      this.approve2_date,
      this.approve2_by,
      this.approve2_status,
      this.created_on,
      this.created_by,
      this.modified_by,
      this.modified_on,
      this.bab,
      this.hal,
      this.pasal,
      this.lokasi,
      this.isView,
      this.pelanggaran,
      this.diterbitkan_oleh,
      this.nomor_surat,
      this.nomorPasal});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nomor': nomor,
      'nama': nama,
      'tanggalSuratDiberikan': tanggalSuratDiberikan,
      'title': title,
      'tgl_surat': tgl_surat,
      'em_id': em_id,
      "letter_id": letter_id,
      'eff_date': eff_date,
      'file_esign': file_esign,
      'upload_file': upload_file,
      'alasan': alasan,
      'approve_id': approve_id,
      'approve_date': approve_date,
      'status': status,
      'approve_by': approve_by,
      'approve_status': approve_status,
      'approve2_id': approve2_id,
      'approve2_date': approve2_date,
      'approve2_by': approve2_by,
      'approve2_status': approve2_status,
      'created_on': created_on,
      'created_by': created_by,
      'modified_by': modified_by,
      'modified _on': modified_on,
      'sp': sp,
      'posisi': posisi,
      'is_view': isView,
      'hal':hal,
      'yang_menerbitkan':diterbitkan_oleh,
      'pelanggaran': pelanggaran,
      'nomor_surat': nomor_surat
    };
  }

  factory Peringatan.fromMap(Map<String, dynamic> map) {
    return Peringatan(
        alasan: map['alasan'],
        approve2_by: map['approve2_by'],
        approve2_date: map['approve2_date'],
        approve2_id: map['id'],
        approve2_status: map['approve2_status'],
        approve_by: map['approve_by'],
        approve_date: map['approve_date'],
        approve_id: map['approve_id'],
        approve_status: map['approve_status'],
        created_by: map['created_by'],
        created_on: map['created_on'],
        eff_date: map['eff_date'],
        em_id: map['em_id'],
        id: map['id'],
        file_esign: map['file_esign'],
        letter_id: map['letter_id'],
        modified_by: map['modified_by'],
        modified_on: map['modified_on'],
        nomor: map['nomor'],
        status: map['status'],
        tanggalSuratDiberikan: map['tanggalSuratDiberikan'],
        tgl_surat: map['tgl_surat'],
        title: map['title'],
        upload_file: map['upload_file'],
        sp: map['sp'],
        posisi: map['posisi'],
        bab: map['bab'],
        pasal: map['pasal'],
        nomorPasal: map['nomor_pasal'],
        lokasi: map['lokasi'],
        nama: map['nama'],
        isView: map['is_view'],
        hal: map['hal'],
        pelanggaran: map['pelanggaran'],
        diterbitkan_oleh: map['yang_menerbitkan'],
        nomor_surat: map['nomor_surat']
        );
  }
  String toJson() => json.encode(toMap());
  static List<Peringatan> fromJsonToList(List data) {
    return List<Peringatan>.from(data.map(
      (item) => Peringatan.fromMap(item),
    ));
  }
}
