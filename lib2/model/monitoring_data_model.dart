import 'dart:convert';

class MonitoringDataModel {
  int? id;
  var emId;
  var branchId;
  var attenDate;
  var signinTime;
  var signoutTime;
  var workingHour;
  var placeIn;
  var placeOut;
  var absence;
  var overtime;
  var earnleave;
  var status;
  var signinLonglat;
  var signoutLonglat;
  var signinPict;
  var signoutPict;
  var signinNote;
  var signoutNote;
  var signinAddr;
  var signoutAddr;
  var breakoutTime;
  var breakinTime;
  var breakoutLonglat;
  var breakinLonglat;
  var breakoutPict;
  var breakinPict;
  var breakinNote;
  var breakoutNote;
  var placeBreakIn;
  var breakinAddr;
  var placeBreakOut;
  var breakoutAddr;
  var atttype;
  var regType;
    var jamKerja;
  var jamPulang;

  MonitoringDataModel({
    this.id,
    this.emId,
    this.branchId,
    this.attenDate,
    this.signinTime,
    this.signoutTime,
    this.workingHour,
    this.placeIn,
    this.placeOut,
    this.absence,
    this.overtime,
    this.earnleave,
    this.status,
    this.signinLonglat,
    this.signoutLonglat,
    this.signinPict,
    this.signoutPict,
    this.signinNote,
    this.signoutNote,
    this.signinAddr,
    this.signoutAddr,
    this.breakoutTime,
    this.breakinTime,
    this.breakoutLonglat,
    this.breakinLonglat,
    this.breakoutPict,
    this.breakinPict,
    this.breakinNote,
    this.breakoutNote,
    this.placeBreakIn,
    this.breakinAddr,
    this.placeBreakOut,
    this.breakoutAddr,
    this.atttype,
    this.regType,
    this.jamKerja,
    this.jamPulang
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'em_id': emId,
      'branch_id': branchId,
      'atten_date': attenDate,
      'signin_time': signinTime,
      'signout_time': signoutTime,
      'working_hour': workingHour,
      'place_in': placeIn,
      'place_out': placeOut,
      'absence': absence,
      'overtime': overtime,
      'earnleave': earnleave,
      'status': status,
      'signin_longlat': signinLonglat,
      'signout_longlat': signoutLonglat,
      'signin_pict': signinPict,
      'signout_pict': signoutPict,
      'signin_note': signinNote,
      'signout_note': signoutNote,
      'signin_addr': signinAddr,
      'signout_addr': signoutAddr,
      'breakout_time': breakoutTime,
      'breakin_time': breakinTime,
      'breakout_longlat': breakoutLonglat,
      'breakin_longlat': breakinLonglat,
      'breakout_pict': breakoutPict,
      'breakin_pict': breakinPict,
      'breakin_note': breakinNote,
      'breakout_note': breakoutNote,
      'place_break_in': placeBreakIn,
      'breakin_addr': breakinAddr,
      'place_break_out': placeBreakOut,
      'breakout_addr': breakoutAddr,
      'atttype': atttype,
      'reg_type': regType,
      'jam_pulang':jamPulang,
      'jam_kerja':jamKerja
    };
  }

  factory MonitoringDataModel.fromMap(Map<String, dynamic> map) {
    return MonitoringDataModel(
      id: map['id'],
      emId: map['em_id'],
      branchId: map['branch_id'],
      attenDate: map['atten_date'],
      signinTime: map['signin_time'],
      signoutTime: map['signout_time'],
      workingHour: map['working_hour'],
      placeIn: map['place_in'],
      placeOut: map['place_out'],
      absence: map['absence'],
      overtime: map['overtime'],
      earnleave: map['earnleave'],
      status: map['status'],
      signinLonglat: map['signin_longlat'],
      signoutLonglat: map['signout_longlat'],
      signinPict: map['signin_pict'],
      signoutPict: map['signout_pict'],
      signinNote: map['signin_note'],
      signoutNote: map['signout_note'],
      signinAddr: map['signin_addr'],
      signoutAddr: map['signout_addr'],
      breakoutTime: map['breakout_time'],
      breakinTime: map['breakin_time'],
      breakoutLonglat: map['breakout_longlat'],
      breakinLonglat: map['breakin_longlat'],
      breakoutPict: map['breakout_pict'],
      breakinPict: map['breakin_pict'],
      breakinNote: map['breakin_note'],
      breakoutNote: map['breakout_note'],
      placeBreakIn: map['place_break_in'],
      breakinAddr: map['breakin_addr'],
      placeBreakOut: map['place_break_out'],
      breakoutAddr: map['breakout_addr'],
      atttype: map['atttype'],
      regType: map['reg_type'],
      jamKerja: map['jam_kerja'],
      jamPulang: map['jam_pulang']
    );
  }

  String toJson() => json.encode(toMap());

  factory MonitoringDataModel.fromJson(String source) =>
      MonitoringDataModel.fromMap(json.decode(source));
}
