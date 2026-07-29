// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'episode.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Episode {
  String get id => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get synopsis => throw _privateConstructorUsedError;
  String? get thumbnail => throw _privateConstructorUsedError;
  int? get episodeNumber => throw _privateConstructorUsedError;
  int? get seasonNumber => throw _privateConstructorUsedError;
  String? get airdate => throw _privateConstructorUsedError;
  int? get episodeLength => throw _privateConstructorUsedError;
  bool get isMovie => throw _privateConstructorUsedError;

  /// Create a copy of Episode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EpisodeCopyWith<Episode> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EpisodeCopyWith<$Res> {
  factory $EpisodeCopyWith(Episode value, $Res Function(Episode) then) =
      _$EpisodeCopyWithImpl<$Res, Episode>;
  @useResult
  $Res call(
      {String id,
      String? title,
      String? synopsis,
      String? thumbnail,
      int? episodeNumber,
      int? seasonNumber,
      String? airdate,
      int? episodeLength,
      bool isMovie});
}

/// @nodoc
class _$EpisodeCopyWithImpl<$Res, $Val extends Episode>
    implements $EpisodeCopyWith<$Res> {
  _$EpisodeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Episode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = freezed,
    Object? synopsis = freezed,
    Object? thumbnail = freezed,
    Object? episodeNumber = freezed,
    Object? seasonNumber = freezed,
    Object? airdate = freezed,
    Object? episodeLength = freezed,
    Object? isMovie = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      synopsis: freezed == synopsis
          ? _value.synopsis
          : synopsis // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      episodeNumber: freezed == episodeNumber
          ? _value.episodeNumber
          : episodeNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      seasonNumber: freezed == seasonNumber
          ? _value.seasonNumber
          : seasonNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      airdate: freezed == airdate
          ? _value.airdate
          : airdate // ignore: cast_nullable_to_non_nullable
              as String?,
      episodeLength: freezed == episodeLength
          ? _value.episodeLength
          : episodeLength // ignore: cast_nullable_to_non_nullable
              as int?,
      isMovie: null == isMovie
          ? _value.isMovie
          : isMovie // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EpisodeImplCopyWith<$Res> implements $EpisodeCopyWith<$Res> {
  factory _$$EpisodeImplCopyWith(
          _$EpisodeImpl value, $Res Function(_$EpisodeImpl) then) =
      __$$EpisodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String? title,
      String? synopsis,
      String? thumbnail,
      int? episodeNumber,
      int? seasonNumber,
      String? airdate,
      int? episodeLength,
      bool isMovie});
}

/// @nodoc
class __$$EpisodeImplCopyWithImpl<$Res>
    extends _$EpisodeCopyWithImpl<$Res, _$EpisodeImpl>
    implements _$$EpisodeImplCopyWith<$Res> {
  __$$EpisodeImplCopyWithImpl(
      _$EpisodeImpl _value, $Res Function(_$EpisodeImpl) _then)
      : super(_value, _then);

  /// Create a copy of Episode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = freezed,
    Object? synopsis = freezed,
    Object? thumbnail = freezed,
    Object? episodeNumber = freezed,
    Object? seasonNumber = freezed,
    Object? airdate = freezed,
    Object? episodeLength = freezed,
    Object? isMovie = null,
  }) {
    return _then(_$EpisodeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      synopsis: freezed == synopsis
          ? _value.synopsis
          : synopsis // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      episodeNumber: freezed == episodeNumber
          ? _value.episodeNumber
          : episodeNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      seasonNumber: freezed == seasonNumber
          ? _value.seasonNumber
          : seasonNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      airdate: freezed == airdate
          ? _value.airdate
          : airdate // ignore: cast_nullable_to_non_nullable
              as String?,
      episodeLength: freezed == episodeLength
          ? _value.episodeLength
          : episodeLength // ignore: cast_nullable_to_non_nullable
              as int?,
      isMovie: null == isMovie
          ? _value.isMovie
          : isMovie // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$EpisodeImpl implements _Episode {
  const _$EpisodeImpl(
      {required this.id,
      this.title,
      this.synopsis,
      this.thumbnail,
      this.episodeNumber,
      this.seasonNumber,
      this.airdate,
      this.episodeLength,
      this.isMovie = false});

  @override
  final String id;
  @override
  final String? title;
  @override
  final String? synopsis;
  @override
  final String? thumbnail;
  @override
  final int? episodeNumber;
  @override
  final int? seasonNumber;
  @override
  final String? airdate;
  @override
  final int? episodeLength;
  @override
  @JsonKey()
  final bool isMovie;

  @override
  String toString() {
    return 'Episode(id: $id, title: $title, synopsis: $synopsis, thumbnail: $thumbnail, episodeNumber: $episodeNumber, seasonNumber: $seasonNumber, airdate: $airdate, episodeLength: $episodeLength, isMovie: $isMovie)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EpisodeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.synopsis, synopsis) ||
                other.synopsis == synopsis) &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            (identical(other.episodeNumber, episodeNumber) ||
                other.episodeNumber == episodeNumber) &&
            (identical(other.seasonNumber, seasonNumber) ||
                other.seasonNumber == seasonNumber) &&
            (identical(other.airdate, airdate) || other.airdate == airdate) &&
            (identical(other.episodeLength, episodeLength) ||
                other.episodeLength == episodeLength) &&
            (identical(other.isMovie, isMovie) || other.isMovie == isMovie));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, title, synopsis, thumbnail,
      episodeNumber, seasonNumber, airdate, episodeLength, isMovie);

  /// Create a copy of Episode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EpisodeImplCopyWith<_$EpisodeImpl> get copyWith =>
      __$$EpisodeImplCopyWithImpl<_$EpisodeImpl>(this, _$identity);
}

abstract class _Episode implements Episode {
  const factory _Episode(
      {required final String id,
      final String? title,
      final String? synopsis,
      final String? thumbnail,
      final int? episodeNumber,
      final int? seasonNumber,
      final String? airdate,
      final int? episodeLength,
      final bool isMovie}) = _$EpisodeImpl;

  @override
  String get id;
  @override
  String? get title;
  @override
  String? get synopsis;
  @override
  String? get thumbnail;
  @override
  int? get episodeNumber;
  @override
  int? get seasonNumber;
  @override
  String? get airdate;
  @override
  int? get episodeLength;
  @override
  bool get isMovie;

  /// Create a copy of Episode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EpisodeImplCopyWith<_$EpisodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
