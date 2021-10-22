// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'system_theme_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$SystemThemeStateTearOff {
  const _$SystemThemeStateTearOff();

  _SystemThemeState call({bool isDarkMode = false}) {
    return _SystemThemeState(
      isDarkMode: isDarkMode,
    );
  }
}

/// @nodoc
const $SystemThemeState = _$SystemThemeStateTearOff();

/// @nodoc
mixin _$SystemThemeState {
  bool get isDarkMode => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SystemThemeStateCopyWith<SystemThemeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SystemThemeStateCopyWith<$Res> {
  factory $SystemThemeStateCopyWith(
          SystemThemeState value, $Res Function(SystemThemeState) then) =
      _$SystemThemeStateCopyWithImpl<$Res>;
  $Res call({bool isDarkMode});
}

/// @nodoc
class _$SystemThemeStateCopyWithImpl<$Res>
    implements $SystemThemeStateCopyWith<$Res> {
  _$SystemThemeStateCopyWithImpl(this._value, this._then);

  final SystemThemeState _value;
  // ignore: unused_field
  final $Res Function(SystemThemeState) _then;

  @override
  $Res call({
    Object? isDarkMode = freezed,
  }) {
    return _then(_value.copyWith(
      isDarkMode: isDarkMode == freezed
          ? _value.isDarkMode
          : isDarkMode // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$SystemThemeStateCopyWith<$Res>
    implements $SystemThemeStateCopyWith<$Res> {
  factory _$SystemThemeStateCopyWith(
          _SystemThemeState value, $Res Function(_SystemThemeState) then) =
      __$SystemThemeStateCopyWithImpl<$Res>;
  @override
  $Res call({bool isDarkMode});
}

/// @nodoc
class __$SystemThemeStateCopyWithImpl<$Res>
    extends _$SystemThemeStateCopyWithImpl<$Res>
    implements _$SystemThemeStateCopyWith<$Res> {
  __$SystemThemeStateCopyWithImpl(
      _SystemThemeState _value, $Res Function(_SystemThemeState) _then)
      : super(_value, (v) => _then(v as _SystemThemeState));

  @override
  _SystemThemeState get _value => super._value as _SystemThemeState;

  @override
  $Res call({
    Object? isDarkMode = freezed,
  }) {
    return _then(_SystemThemeState(
      isDarkMode: isDarkMode == freezed
          ? _value.isDarkMode
          : isDarkMode // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_SystemThemeState
    with DiagnosticableTreeMixin
    implements _SystemThemeState {
  const _$_SystemThemeState({this.isDarkMode = false});

  @JsonKey(defaultValue: false)
  @override
  final bool isDarkMode;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SystemThemeState(isDarkMode: $isDarkMode)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SystemThemeState'))
      ..add(DiagnosticsProperty('isDarkMode', isDarkMode));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _SystemThemeState &&
            (identical(other.isDarkMode, isDarkMode) ||
                const DeepCollectionEquality()
                    .equals(other.isDarkMode, isDarkMode)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(isDarkMode);

  @JsonKey(ignore: true)
  @override
  _$SystemThemeStateCopyWith<_SystemThemeState> get copyWith =>
      __$SystemThemeStateCopyWithImpl<_SystemThemeState>(this, _$identity);
}

abstract class _SystemThemeState implements SystemThemeState {
  const factory _SystemThemeState({bool isDarkMode}) = _$_SystemThemeState;

  @override
  bool get isDarkMode => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$SystemThemeStateCopyWith<_SystemThemeState> get copyWith =>
      throw _privateConstructorUsedError;
}
