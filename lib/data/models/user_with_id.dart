import 'package:engelsiz/data/models/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_with_id.freezed.dart';
part 'user_with_id.g.dart';

@freezed
class UserWithId with _$UserWithId {
  @JsonSerializable(explicitToJson: true)
  const factory UserWithId({
    required String id,
    required User user,
  }) = _UserWithId;

  factory UserWithId.fromJson(Map<String, Object?> json) =>
      _$UserWithIdFromJson(json);
}
