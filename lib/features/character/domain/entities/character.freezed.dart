// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'character.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Character {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get japaneseName => throw _privateConstructorUsedError;
  List<String> get otherNames => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get image => throw _privateConstructorUsedError;
  String? get malId => throw _privateConstructorUsedError;

  /// Create a copy of Character
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CharacterCopyWith<Character> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CharacterCopyWith<$Res> {
  factory $CharacterCopyWith(Character value, $Res Function(Character) then) =
      _$CharacterCopyWithImpl<$Res, Character>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? japaneseName,
      List<String> otherNames,
      String? description,
      String image,
      String? malId});
}

/// @nodoc
class _$CharacterCopyWithImpl<$Res, $Val extends Character>
    implements $CharacterCopyWith<$Res> {
  _$CharacterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Character
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? japaneseName = freezed,
    Object? otherNames = null,
    Object? description = freezed,
    Object? image = null,
    Object? malId = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      japaneseName: freezed == japaneseName
          ? _value.japaneseName
          : japaneseName // ignore: cast_nullable_to_non_nullable
              as String?,
      otherNames: null == otherNames
          ? _value.otherNames
          : otherNames // ignore: cast_nullable_to_non_nullable
              as List<String>,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      malId: freezed == malId
          ? _value.malId
          : malId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CharacterImplCopyWith<$Res>
    implements $CharacterCopyWith<$Res> {
  factory _$$CharacterImplCopyWith(
          _$CharacterImpl value, $Res Function(_$CharacterImpl) then) =
      __$$CharacterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? japaneseName,
      List<String> otherNames,
      String? description,
      String image,
      String? malId});
}

/// @nodoc
class __$$CharacterImplCopyWithImpl<$Res>
    extends _$CharacterCopyWithImpl<$Res, _$CharacterImpl>
    implements _$$CharacterImplCopyWith<$Res> {
  __$$CharacterImplCopyWithImpl(
      _$CharacterImpl _value, $Res Function(_$CharacterImpl) _then)
      : super(_value, _then);

  /// Create a copy of Character
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? japaneseName = freezed,
    Object? otherNames = null,
    Object? description = freezed,
    Object? image = null,
    Object? malId = freezed,
  }) {
    return _then(_$CharacterImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      japaneseName: freezed == japaneseName
          ? _value.japaneseName
          : japaneseName // ignore: cast_nullable_to_non_nullable
              as String?,
      otherNames: null == otherNames
          ? _value._otherNames
          : otherNames // ignore: cast_nullable_to_non_nullable
              as List<String>,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      malId: freezed == malId
          ? _value.malId
          : malId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$CharacterImpl implements _Character {
  const _$CharacterImpl(
      {required this.id,
      required this.name,
      this.japaneseName,
      final List<String> otherNames = const [],
      this.description,
      required this.image,
      this.malId})
      : _otherNames = otherNames;

  @override
  final String id;
  @override
  final String name;
  @override
  final String? japaneseName;
  final List<String> _otherNames;
  @override
  @JsonKey()
  List<String> get otherNames {
    if (_otherNames is EqualUnmodifiableListView) return _otherNames;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_otherNames);
  }

  @override
  final String? description;
  @override
  final String image;
  @override
  final String? malId;

  @override
  String toString() {
    return 'Character(id: $id, name: $name, japaneseName: $japaneseName, otherNames: $otherNames, description: $description, image: $image, malId: $malId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CharacterImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.japaneseName, japaneseName) ||
                other.japaneseName == japaneseName) &&
            const DeepCollectionEquality()
                .equals(other._otherNames, _otherNames) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.malId, malId) || other.malId == malId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      japaneseName,
      const DeepCollectionEquality().hash(_otherNames),
      description,
      image,
      malId);

  /// Create a copy of Character
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CharacterImplCopyWith<_$CharacterImpl> get copyWith =>
      __$$CharacterImplCopyWithImpl<_$CharacterImpl>(this, _$identity);
}

abstract class _Character implements Character {
  const factory _Character(
      {required final String id,
      required final String name,
      final String? japaneseName,
      final List<String> otherNames,
      final String? description,
      required final String image,
      final String? malId}) = _$CharacterImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get japaneseName;
  @override
  List<String> get otherNames;
  @override
  String? get description;
  @override
  String get image;
  @override
  String? get malId;

  /// Create a copy of Character
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CharacterImplCopyWith<_$CharacterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
