import 'package:engelsiz/data/models/appointment_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'appointment_with_id.freezed.dart';
part 'appointment_with_id.g.dart';

@freezed
class AppointmentWithId with _$AppointmentWithId {
  @JsonSerializable(explicitToJson: true)
  const factory AppointmentWithId({
    required String id,
    required MyAppointment appointment,
  }) = _AppointmentWithId;
  factory AppointmentWithId.fromJson(Map<String, Object?> json) =>
      _$AppointmentWithIdFromJson(json);
}
