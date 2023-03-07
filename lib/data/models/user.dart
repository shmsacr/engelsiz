import 'package:engelsiz/data/models/student.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@Freezed(unionKey: 'role')
class User with _$User {
  const factory User.teacher(
      {required final String fullName,
      required final String email,
      required final String phoneNumber,
        required final String? profilePicture,
      required final String tc,
      required final Gender gender}) = Teacher;

  @JsonSerializable(explicitToJson: true)
  const factory User.parent(
      {required final String fullName,
      required final String email,
      required final String phoneNumber,
      required final String tc,
      required final Gender gender,
        required final String? profilePicture,
      required final List<String> teachers,
      required final Student student}) = Parent;

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
}
