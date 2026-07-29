import 'package:freezed_annotation/freezed_annotation.dart';

part 'character.freezed.dart';

@freezed
class Character with _$Character {
  const factory Character({
    required String id,
    required String name,
    String? japaneseName,
    @Default([]) List<String> otherNames,
    String? description,
    required String image,
    String? malId,
  }) = _Character;
}
