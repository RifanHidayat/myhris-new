import 'dart:convert';

class UserModel {
  var em_id;
  var des_id;
  var dep_id;
  var dep_group;
  var full_name;
  var em_email;
  var em_phone;
  var em_birthday;
  var em_gender;
  var em_image;
  var em_joining_date;
  var em_status;
  var em_blood_group;
  var posisi;
  var emp_jobTitle;
  var emp_departmen;
  var em_control;
  var em_control_acess;
  var emp_att_working;
  var em_hak_akses;
  var face_recog;
  var branchName;
  var branchId;
  var beginPayroll;
  var endPayroll;
  var endDay;
  var startTime;
  var endTime;
  var nomorBpjsKesehatan;
  var nomorBpjsTenagakerja;
  var timeIn;
  var timeOut;
  var interval;
  var interval_tracking;
  var isViewTracking;
  var is_tracking;
  var tipeAbsen;
 

  var isBackDateSakit;
  var isBackDateIzin;
  var isBackDateCuti;
  var isBackDateTugasLuar;
  var isBackDateDinasLuar;
  var isBackDateLembur;
  var tanggalBerakhirKontrak;
  var sisaKontrak;
  var sisaKontrakFormat;
  var lamaBekerja;
  var lamaBekerjaFormat;

  UserModel({
    this.em_id,
    this.des_id,
    this.dep_id,
    this.dep_group,
    this.full_name,
    this.em_email,
    this.em_phone,
    this.em_birthday,
    this.em_gender,
    this.em_image,
    this.em_joining_date,
    this.em_status,
    this.em_blood_group,
    this.posisi,
    this.emp_jobTitle,
    this.emp_departmen,
    this.em_control,
    this.em_control_acess,
    this.emp_att_working,
    this.face_recog,
    this.branchName,
    this.branchId,
    this.beginPayroll,
    this.endPayroll,
    this.startTime,
    this.endTime,
    this.em_hak_akses,
    this.nomorBpjsKesehatan,
    this.nomorBpjsTenagakerja,
    this.timeIn,
    this.timeOut,
    this.interval,
    this.interval_tracking,
    this.isViewTracking,
    this.is_tracking,
    this.isBackDateSakit,
    this.isBackDateIzin,
    this.isBackDateCuti,
    this.isBackDateTugasLuar,
    this.isBackDateDinasLuar,
    this.isBackDateLembur,
    this.tanggalBerakhirKontrak,
    this.sisaKontrak,
    this.sisaKontrakFormat,
    this.lamaBekerja,
    this.lamaBekerjaFormat,
    this.tipeAbsen
  });

  Map<String, dynamic> toMap() {
    return {
      'em_id': em_id,
      'des_id': des_id,
      'dep_id': dep_id,
      'dep_group': dep_group,
      'full_name': full_name,
      'em_email': em_email,
      'em_phone': em_phone,
      'em_birthday': em_birthday,
      'em_gender': em_gender,
      'em_image': em_image,
      'em_joining_date': em_joining_date,
      'em_status': em_status,
      'em_blood_group': em_blood_group,
      'posisi': posisi,
      'emp_jobTitle': emp_jobTitle,
      'emp_departmen': emp_departmen,
      'em_control': em_control,
      'em_control_acess': em_control_acess,
      'emp_att_working': emp_att_working,
      'em_hak_akses': em_hak_akses,
      'face_recog': face_recog,
      'branch_name': branchName,
      'begin_payroll': beginPayroll,
      'end_payroll': endPayroll,
      'start_time': startTime,
      'end_time': endTime,
      'nomor_bpjs_kesehatan': nomorBpjsKesehatan,
      'nomor_bpjs_tenagakerja': nomorBpjsTenagakerja,
      'time_in': timeIn,
      'time_out': timeOut,
      'interval': interval ?? 0,
      'interval_tracking': interval_tracking,
      'is_view_tracking': isViewTracking,
      'is_tracking': is_tracking,
      "is_back_date_sakit": isBackDateSakit,
      "is_back_date_izin": isBackDateIzin,
      "is_back_date_cuti": isBackDateCuti,
      "is_back_date_dinas_luar": isBackDateDinasLuar,
      "is_back_date_lembur": isBackDateLembur,
      "is_back_date_tugas_luar": isBackDateTugasLuar,
      "tanggal_berakhir_kontrak": tanggalBerakhirKontrak,
      "sisa_kontrak": sisaKontrak,
      "sisa_kontrak_format": sisaKontrakFormat,
      "lama_bekerja": lamaBekerja,
      "lama_bekerja_format": lamaBekerjaFormat,
      'tipe_absen':tipeAbsen
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      em_id: map['em_id'],
      des_id: map['des_id'],
      dep_id: map['dep_id'],
      dep_group: map['dep_group'],
      full_name: map['full_name'],
      em_email: map['em_email'],
      em_phone: map['em_phone'],
      em_birthday: map['em_birthday'],
      em_gender: map['em_gender'],
      em_image: map['em_image'],
      em_joining_date: map['em_joining_date'],
      em_status: map['em_status'],
      em_blood_group: map['em_blood_group'],
      posisi: map['posisi'],
      emp_jobTitle: map['emp_jobTitle'],
      emp_departmen: map['emp_departmen'],
      em_control: map['em_control'],
      em_control_acess: map['em_control_acess'],
      emp_att_working: map['emp_att_working'],
      face_recog: map['face_recog'],
      branchName: map['branch_name'],
      endPayroll: map['end_payroll'],
      startTime: map['start_time'],
      endTime: map['end_time'],
      beginPayroll: map['begin_payroll'],
      em_hak_akses: map['em_hak_akses'],
      nomorBpjsKesehatan: map['nomor_bpjs_kesehatan'],
      nomorBpjsTenagakerja: map['nomor_bpjs_tenagakerja'],
      interval: map['interval'],
      timeIn: map['time_in'],
      timeOut: map['time_out'],
      interval_tracking: map['interval_tracking'],
      isViewTracking: map['is_view_tracking'],
      isBackDateSakit: map['is_back_date_sakit'],
      isBackDateIzin: map['is_back_date_izin'],
      isBackDateCuti: map['is_back_date_cuti'],
      isBackDateTugasLuar: map['is_back_date_tugas_luar'],
      isBackDateDinasLuar: map['is_back_date_dinas_luar'],
      isBackDateLembur: map['is_back_date_lembur'],
      is_tracking: map['is_tracking'],
      tanggalBerakhirKontrak: map['tanggal_berakhir_kontrak'],
      sisaKontrak: map['sisa_kontrak'],
      sisaKontrakFormat: map['sisa_kontrak_format'],
      lamaBekerja: map['lama_bekerja'],
      lamaBekerjaFormat: map['lama_bekerja_format'],

      tipeAbsen: map['tipe_absen']
    );
  }

  String toJson() => json.encode(toMap());
}
