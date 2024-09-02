class Message {
  var id;
  var pesan;
  var tanggal;
  var waktu;
  var emIdPengirim;
  var emIdPenerima;
  var status;
  var lampiran;
  var dibaca;
  var type;
  var tipeLampiran;

  var isKirim;
  Message({
    required this.id,
    required this.pesan,
    required this.tanggal,
    required this.waktu,
    required this.emIdPengirim,
    required this.emIdPenerima,
    required this.lampiran,
    required this.dibaca,
    required this.type,
    required this.status,
    required this.tipeLampiran,
    required this.isKirim
  });

  // Convert a User into a Map. The keys must correspond to the names of the
  // JSON object attributes.
  Map<String, dynamic> toJson() => {
        'id': id,
        'pesan': pesan,
        'tanggal': tanggal,
        'waktu': waktu,
        'em_id_pengirim': emIdPengirim,
        'em_id_penerima': emIdPenerima,
        'status': status,
        'tipe_lampiran': tipeLampiran,
        'lampiran': tipeLampiran,
        'dibaca': dibaca,
        'type': type,
        'is_kirim':isKirim,
      };

  // A method that converts a Map into a User
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      pesan: json['pesan'],
      tanggal: json['tanggal'],
      emIdPengirim: json['em_id_pengirim'],
      emIdPenerima: json['em_id_penerima'],
      status: json['status'],
      lampiran: json['lampiran'],
      type: json['type'],
      dibaca: json['dibaca'],
      waktu: json['waktu'],
      tipeLampiran: json['tipe_lampiran'],
      isKirim: json['is_kirim']??1
    );
  }

    static List<Message> fromJsonToList(List data) {
    return List<Message>.from(data.map(
      (item) => Message.fromJson(item),
    ));
  }
}
