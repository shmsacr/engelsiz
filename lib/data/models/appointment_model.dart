import 'package:freezed_annotation/freezed_annotation.dart';

part 'appointment_model.freezed.dart';
part 'appointment_model.g.dart';

@freezed
class MyAppointment with _$MyAppointment {
  @JsonSerializable(explicitToJson: true)
  const factory MyAppointment(
      {required final String situation,
      required final String notes,
      required final String parentId,
      required final String teacherId,
      required final DateTime start,
      required final DateTime end,
      required final String title}) = _MyAppointment;

  factory MyAppointment.fromJson(Map<String, Object?> json) =>
      _$MyAppointmentFromJson(json);
}
