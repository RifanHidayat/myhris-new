import 'dart:convert';

class UserModel {
  var em_id;
var des_id;
  var dep_id;
  var dep_group;
  var full_name;
var em_email;
 var  em_phone;
var em_birthday;
  var em_gender;
  var em_image;
  var em_joining_date;
var  em_status;
  var  em_blood_group;
  var  posisi;
  var  emp_jobTitle;
  var  emp_departmen;
  var  em_control;
  var  em_control_acess;
  var  emp_att_working;
  var em_hak_akses;
  var face_recog;

  UserModel(
      {this.em_id,
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
      this.em_hak_akses});

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
      'face_recog': face_recog
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
        em_hak_akses: map['em_hak_akses']);
  }

  String toJson() => json.encode(toMap());
}
