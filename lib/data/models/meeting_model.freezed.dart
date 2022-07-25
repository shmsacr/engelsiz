// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'meeting_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Meeting {
  DateTime get start => throw _privateConstructorUsedError;
  DateTime get end => throw _privateConstructorUsedError;
  String get subject => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;
  AppointmentColor get appColor => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MeetingCopyWith<Meeting> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MeetingCopyWith<$Res> {
  factory $MeetingCopyWith(Meeting value, $Res Function(Meeting) then) =
      _$MeetingCopyWithImpl<$Res>;
  $Res call(
      {DateTime start,
      DateTime end,
      String subject,
      String notes,
      AppointmentColor appColor});
}

/// @nodoc
class _$MeetingCopyWithImpl<$Res> implements $MeetingCopyWith<$Res> {
  _$MeetingCopyWithImpl(this._value, this._then);

  final Meeting _value;
  // ignore: unused_field
  final $Res Function(Meeting) _then;

  @override
  $Res call({
    Object? start = freezed,
    Object? end = freezed,
    Object? subject = freezed,
    Object? notes = freezed,
    Object? appColor = freezed,
  }) {
    return _then(_value.copyWith(
      start: start == freezed
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as DateTime,
      end: end == freezed
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as DateTime,
      subject: subject == freezed
          ? _value.subject
          : subject // ignore: cast_nullable_to_non_nullable
              as String,
      notes: notes == freezed
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      appColor: appColor == freezed
          ? _value.appColor
          : appColor // ignore: cast_nullable_to_non_nullable
              as AppointmentColor,
    ));
  }
}

/// @nodoc
abstract class _$$_MeetingCopyWith<$Res> implements $MeetingCopyWith<$Res> {
  factory _$$_MeetingCopyWith(
          _$_Meeting value, $Res Function(_$_Meeting) then) =
      __$$_MeetingCopyWithImpl<$Res>;
  @override
  $Res call(
      {DateTime start,
      DateTime end,
      String subject,
      String notes,
      AppointmentColor appColor});
}

/// @nodoc
class __$$_MeetingCopyWithImpl<$Res> extends _$MeetingCopyWithImpl<$Res>
    implements _$$_MeetingCopyWith<$Res> {
  __$$_MeetingCopyWithImpl(_$_Meeting _value, $Res Function(_$_Meeting) _then)
      : super(_value, (v) => _then(v as _$_Meeting));

  @override
  _$_Meeting get _value => super._value as _$_Meeting;

  @override
  $Res call({
    Object? start = freezed,
    Object? end = freezed,
    Object? subject = freezed,
    Object? notes = freezed,
    Object? appColor = freezed,
  }) {
    return _then(_$_Meeting(
      start: start == freezed
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as DateTime,
      end: end == freezed
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as DateTime,
      subject: subject == freezed
          ? _value.subject
          : subject // ignore: cast_nullable_to_non_nullable
              as String,
      notes: notes == freezed
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      appColor: appColor == freezed
          ? _value.appColor
          : appColor // ignore: cast_nullable_to_non_nullable
              as AppointmentColor,
    ));
  }
}

/// @nodoc

class _$_Meeting with DiagnosticableTreeMixin implements _Meeting {
  const _$_Meeting(
      {required this.start,
      required this.end,
      this.subject = '',
      this.notes = '',
      this.appColor = AppointmentColor.green});

  @override
  final DateTime start;
  @override
  final DateTime end;
  @override
  @JsonKey()
  final String subject;
  @override
  @JsonKey()
  final String notes;
  @override
  @JsonKey()
  final AppointmentColor appColor;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Meeting(start: $start, end: $end, subject: $subject, notes: $notes, appColor: $appColor)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Meeting'))
      ..add(DiagnosticsProperty('start', start))
      ..add(DiagnosticsProperty('end', end))
      ..add(DiagnosticsProperty('subject', subject))
      ..add(DiagnosticsProperty('notes', notes))
      ..add(DiagnosticsProperty('appColor', appColor));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Meeting &&
            const DeepCollectionEquality().equals(other.start, start) &&
            const DeepCollectionEquality().equals(other.end, end) &&
            const DeepCollectionEquality().equals(other.subject, subject) &&
            const DeepCollectionEquality().equals(other.notes, notes) &&
            const DeepCollectionEquality().equals(other.appColor, appColor));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(start),
      const DeepCollectionEquality().hash(end),
      const DeepCollectionEquality().hash(subject),
      const DeepCollectionEquality().hash(notes),
      const DeepCollectionEquality().hash(appColor));

  @JsonKey(ignore: true)
  @override
  _$$_MeetingCopyWith<_$_Meeting> get copyWith =>
      __$$_MeetingCopyWithImpl<_$_Meeting>(this, _$identity);
}

abstract class _Meeting implements Meeting {
  const factory _Meeting(
      {required final DateTime start,
      required final DateTime end,
      final String subject,
      final String notes,
      final AppointmentColor appColor}) = _$_Meeting;

  @override
  DateTime get start;
  @override
  DateTime get end;
  @override
  String get subject;
  @override
  String get notes;
  @override
  AppointmentColor get appColor;
  @override
  @JsonKey(ignore: true)
  _$$_MeetingCopyWith<_$_Meeting> get copyWith =>
      throw _privateConstructorUsedError;
}
