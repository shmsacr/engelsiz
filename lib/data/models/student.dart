import 'package:freezed_annotation/freezed_annotation.dart';

part 'student.freezed.dart';
part 'student.g.dart';

@JsonEnum(valueField: 'value')
enum Gender {
  male("Erkek"),
  female("Kadın");

  const Gender(this.value);
  final String value;
}

@freezed
class Student with _$Student {
  const factory Student(
      {required final String fullName,
      required final String tc,
      required final Gender gender,
      required final int age}) = _Student;

  factory Student.fromJson(Map<String, Object?> json) =>
      _$StudentFromJson(json);
}
