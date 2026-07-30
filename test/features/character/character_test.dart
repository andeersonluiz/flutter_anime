import 'package:animes_io/core/error/exceptions.dart';
import 'package:animes_io/core/error/failures.dart';
import 'package:animes_io/features/character/data/datasources/character_remote_datasource.dart';
import 'package:animes_io/features/character/data/models/character_model.dart';
import 'package:animes_io/features/character/data/repositories/character_repository_impl.dart';
import 'package:animes_io/features/character/domain/entities/character.dart';
import 'package:animes_io/features/character/domain/repositories/character_repository.dart';
import 'package:animes_io/features/character/domain/usecases/get_anime_characters.dart';
import 'package:animes_io/features/character/domain/usecases/get_characters.dart';
import 'package:animes_io/features/character/presentation/bloc/character_bloc.dart';
import 'package:animes_io/features/character/presentation/bloc/character_event.dart';
import 'package:animes_io/features/character/presentation/bloc/character_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────────
class MockCharacterRepository extends Mock implements CharacterRepository {}

class MockCharacterRemoteDataSource extends Mock
    implements CharacterRemoteDataSource {}

class MockGetCharacters extends Mock implements GetCharacters {}

class MockGetAnimeCharacters extends Mock implements GetAnimeCharacters {}

// ── Fixtures ──────────────────────────────────────────────────────────────────
const tCharacter = Character(
  id: '1',
  name: 'Naruto Uzumaki',
  japaneseName: 'うずまきナルト',
  otherNames: ['Naruto'],
  description: 'Main protagonist',
  image: 'https://example.com/naruto.jpg',
  malId: '1',
);

final List<Character> tCharacterList = [tCharacter];

final tCharacterModel = CharacterModel(
  id: '1',
  name: 'Naruto Uzumaki',
  names: CharacterNamesModel(ja: 'うずまきナルト', en: 'Naruto Uzumaki'),
  otherNames: ['Naruto'],
  description: 'Main protagonist',
  image: CharacterImageModel(original: 'https://example.com/naruto.jpg'),
  malId: '1',
);

// ── CharacterModel tests ──────────────────────────────────────────────────────
void main() {
  group('CharacterModel', () {
    const tJson = {
      'id': '1',
      'attributes': {
        'canonicalName': 'Naruto Uzumaki',
        'names': {'ja': 'うずまきナルト', 'en': 'Naruto Uzumaki'},
        'otherNames': ['Naruto'],
        'description': 'Main protagonist',
        'image': {'original': 'https://example.com/naruto.jpg'},
        'malId': 1,
      },
    };

    test('fromJson parses all fields correctly', () {
      final model = CharacterModel.fromJson(tJson);
      expect(model.id, '1');
      expect(model.name, 'Naruto Uzumaki');
      expect(model.names?.ja, 'うずまきナルト');
      expect(model.otherNames, ['Naruto']);
      expect(model.description, 'Main protagonist');
      expect(model.image?.original, 'https://example.com/naruto.jpg');
      expect(model.malId, '1');
    });

    test('fromJson handles null names, image, malId, otherNames', () {
      const minimalJson = {
        'id': '2',
        'attributes': {
          'canonicalName': 'Unknown',
        },
      };
      final model = CharacterModel.fromJson(minimalJson);
      expect(model.names, isNull);
      expect(model.image, isNull);
      expect(model.malId, isNull);
      expect(model.otherNames, isEmpty);
    });

    test('toEntity maps fields correctly with fallback image', () {
      final modelNoImage = CharacterModel(
        id: '1',
        name: 'Test',
        otherNames: const [],
      );
      final entity = modelNoImage.toEntity();
      expect(entity.image, 'https://i.imgur.com/DIhR3Po.jpg');
    });

    test('toEntity maps fields with real image', () {
      final entity = tCharacterModel.toEntity();
      expect(entity.id, '1');
      expect(entity.name, 'Naruto Uzumaki');
      expect(entity.japaneseName, 'うずまきナルト');
      expect(entity.image, 'https://example.com/naruto.jpg');
      expect(entity.malId, '1');
    });

    test('malId null when malId is null in json', () {
      const json = {
        'id': '3',
        'attributes': {'canonicalName': 'X', 'malId': null},
      };
      final model = CharacterModel.fromJson(json);
      expect(model.malId, isNull);
    });

    test('malId converted to string from int', () {
      const json = {
        'id': '4',
        'attributes': {'canonicalName': 'Y', 'malId': 42},
      };
      final model = CharacterModel.fromJson(json);
      expect(model.malId, '42');
    });
  });

  // ── CharacterRepositoryImpl tests ─────────────────────────────────────────────
  group('CharacterRepositoryImpl', () {
    late CharacterRepositoryImpl repository;
    late MockCharacterRemoteDataSource mockRemote;

    setUp(() {
      mockRemote = MockCharacterRemoteDataSource();
      repository = CharacterRepositoryImpl(remoteDataSource: mockRemote);
    });

    group('getCharacters', () {
      test('returns Right(characters) on success', () async {
        when(() => mockRemote.getCharacters(offset: 0, limit: 20))
            .thenAnswer((_) async => [tCharacterModel]);

        final result = await repository.getCharacters(offset: 0, limit: 20);

        expect(result.isRight(), true);
        result.fold((_) => fail('expected Right'), (chars) {
          expect(chars.first.name, 'Naruto Uzumaki');
        });
      });

      test('returns Left(ServerFailure) on ServerException', () async {
        when(() => mockRemote.getCharacters(offset: 0, limit: 20))
            .thenThrow(const ServerException('network error'));

        final result = await repository.getCharacters();
        expect(result.isLeft(), true);
        result.fold((f) => expect(f, isA<ServerFailure>()), (_) => fail(''));
      });

      test('returns Left(ServerFailure) on unexpected error', () async {
        when(() => mockRemote.getCharacters(offset: 0, limit: 20))
            .thenThrow(Exception('unknown'));

        final result = await repository.getCharacters();
        expect(result.isLeft(), true);
      });
    });

    group('getAnimeCharacters', () {
      test('returns Right(characters) on success', () async {
        when(() =>
                mockRemote.getAnimeCharacters('anime1', offset: 0, limit: 20))
            .thenAnswer((_) async => [tCharacterModel]);

        final result =
            await repository.getAnimeCharacters('anime1', offset: 0, limit: 20);

        expect(result.isRight(), true);
      });

      test('returns Left on ServerException', () async {
        when(() =>
                mockRemote.getAnimeCharacters('anime1', offset: 0, limit: 20))
            .thenThrow(const ServerException('error'));

        final result = await repository.getAnimeCharacters('anime1');
        expect(result.isLeft(), true);
      });
    });
  });

  // ── GetCharacters use case tests ──────────────────────────────────────────────
  group('GetCharacters', () {
    late MockCharacterRepository mockRepo;
    late GetCharacters usecase;

    setUp(() {
      mockRepo = MockCharacterRepository();
      usecase = GetCharacters(mockRepo);
    });

    test('returns list on success', () async {
      when(() => mockRepo.getCharacters(offset: 0, limit: 20))
          .thenAnswer((_) async => Right(tCharacterList));

      final result = await usecase(offset: 0, limit: 20);
      expect(result.isRight(), true);
    });

    test('propagates failure', () async {
      when(() => mockRepo.getCharacters(offset: 0, limit: 20))
          .thenAnswer((_) async => const Left(ServerFailure('error')));

      final result = await usecase(offset: 0, limit: 20);
      expect(result.isLeft(), true);
    });
  });

  // ── GetAnimeCharacters use case tests ─────────────────────────────────────────
  group('GetAnimeCharacters', () {
    late MockCharacterRepository mockRepo;
    late GetAnimeCharacters usecase;

    setUp(() {
      mockRepo = MockCharacterRepository();
      usecase = GetAnimeCharacters(mockRepo);
    });

    test('returns list on success', () async {
      when(() => mockRepo.getAnimeCharacters('1', offset: 0, limit: 20))
          .thenAnswer((_) async => Right(tCharacterList));

      final result = await usecase('1', offset: 0, limit: 20);
      expect(result.isRight(), true);
    });

    test('propagates failure', () async {
      when(() => mockRepo.getAnimeCharacters('1', offset: 0, limit: 20))
          .thenAnswer((_) async => const Left(ServerFailure('error')));

      final result = await usecase('1', offset: 0, limit: 20);
      expect(result.isLeft(), true);
    });
  });

  // ── CharacterBloc tests ───────────────────────────────────────────────────────
  group('CharacterBloc', () {
    late MockGetCharacters mockGetCharacters;
    late MockGetAnimeCharacters mockGetAnimeCharacters;

    setUp(() {
      mockGetCharacters = MockGetCharacters();
      mockGetAnimeCharacters = MockGetAnimeCharacters();
    });

    CharacterBloc buildBloc() => CharacterBloc(
          getCharacters: mockGetCharacters,
          getAnimeCharacters: mockGetAnimeCharacters,
        );

    blocTest<CharacterBloc, CharacterState>(
      'LoadCharacters emits [Loading, Loaded] on success',
      build: () {
        when(() => mockGetCharacters(offset: 0, limit: 20))
            .thenAnswer((_) async => Right(tCharacterList));
        return buildBloc();
      },
      act: (bloc) => bloc.add(LoadCharacters()),
      expect: () => [
        CharacterLoading(),
        CharacterLoaded(characters: tCharacterList, hasMore: false),
      ],
    );

    blocTest<CharacterBloc, CharacterState>(
      'LoadCharacters emits [Loading, Error] on failure',
      build: () {
        when(() => mockGetCharacters(offset: 0, limit: 20)).thenAnswer(
            (_) async => const Left(ServerFailure('network error')));
        return buildBloc();
      },
      act: (bloc) => bloc.add(LoadCharacters()),
      expect: () => [
        CharacterLoading(),
        const CharacterError(message: 'network error'),
      ],
    );

    blocTest<CharacterBloc, CharacterState>(
      'LoadAnimeCharacters emits [Loading, Loaded] on success',
      build: () {
        when(() => mockGetAnimeCharacters('42', offset: 0, limit: 20))
            .thenAnswer((_) async => Right(tCharacterList));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const LoadAnimeCharacters('42')),
      expect: () => [
        CharacterLoading(),
        CharacterLoaded(characters: tCharacterList, hasMore: false),
      ],
    );

    blocTest<CharacterBloc, CharacterState>(
      'LoadMoreCharacters does nothing when hasMore=false',
      build: () {
        when(() => mockGetCharacters(offset: 0, limit: 20))
            .thenAnswer((_) async => Right(tCharacterList));
        return buildBloc();
      },
      act: (bloc) async {
        bloc.add(LoadCharacters());
        await Future<void>.delayed(const Duration(milliseconds: 50));
        bloc.add(LoadMoreCharacters());
      },
      expect: () => [
        CharacterLoading(),
        CharacterLoaded(characters: tCharacterList, hasMore: false),
        // LoadMoreCharacters is no-op because hasMore=false
      ],
    );
  });
}
