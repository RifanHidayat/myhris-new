import 'dart:convert';

class MonitoringModel {
  var full_name;
  var em_id;
  var isSelected;

  MonitoringModel({
    this.em_id,
    this.full_name,
    this.isSelected
  });
  Map<String, dynamic> toMap() {
    return {'em_id': em_id, 'full_name': full_name,'is_Selected':isSelected};
  }

  factory MonitoringModel.fromMap(Map<String, dynamic> map) {
    return MonitoringModel(
      full_name: map['full_name'],
      em_id: map['em_id'],
      isSelected: map['is_selected']??false,
    );
  }
  String toJson() => json.encode(toMap);
}
