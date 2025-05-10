import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class CustomYearchPicker extends DatePickerModel {
  CustomYearchPicker(
      {DateTime? currentTime,
      DateTime? minTime,
      DateTime? maxTime,
      LocaleType? locale})
      : super(
            locale: locale ?? LocaleType.id,
            minTime: minTime,
            maxTime: maxTime,
            currentTime: currentTime);

  @override
  List<int> layoutProportions() {
    return [1, 0, 0];
  }
}
