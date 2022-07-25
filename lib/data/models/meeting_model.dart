import 'package:engelsiz/controller/calendar_controller.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'meeting_model.freezed.dart';
// part 'meeting_model.g.dart';

@freezed
class Meeting with _$Meeting {
  const factory Meeting({
    required DateTime start,
    required DateTime end,
    @Default('') String subject,
    @Default('') String notes,
    @Default(AppointmentColor.green) AppointmentColor appColor,
  }) = _Meeting;

  // factory Meeting.fromJson(Map<String, Object?> json) =>
  //     _$MeetingFromJson(json);
}
