import 'package:animes_io/core/error/exceptions.dart';
import 'package:animes_io/core/error/failures.dart';
import 'package:animes_io/features/episode/data/datasources/episode_remote_datasource.dart';
import 'package:animes_io/features/episode/data/models/episode_model.dart';
import 'package:animes_io/features/episode/data/repositories/episode_repository_impl.dart';
import 'package:animes_io/features/episode/domain/entities/episode.dart';
import 'package:animes_io/features/episode/domain/repositories/episode_repository.dart';
import 'package:animes_io/features/episode/domain/usecases/get_episodes.dart';
import 'package:animes_io/features/episode/presentation/bloc/episode_bloc.dart';
import 'package:animes_io/features/episode/presentation/bloc/episode_event.dart';
import 'package:animes_io/features/episode/presentation/bloc/episode_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────────
class MockEpisodeRepository extends Mock implements EpisodeRepository {}

class MockEpisodeRemoteDataSource extends Mock
    implements EpisodeRemoteDataSource {}

class MockGetEpisodes extends Mock implements GetEpisodes {}

// ── Fixtures ──────────────────────────────────────────────────────────────────
const tEpisode = Episode(
  id: 'ep1',
  title: 'Episode 1',
  synopsis: 'The beginning',
  thumbnail: 'https://example.com/ep1.jpg',
  episodeNumber: 1,
  seasonNumber: 1,
  airdate: '2002-10-03',
  isMovie: false,
);

final tEpisodeList = [tEpisode];

final tEpisodeModel = EpisodeModel(
  id: 'ep1',
  attributes: EpisodeAttributes(
    canonicalTitle: 'Episode 1',
    synopsis: 'The beginning',
    thumbnail: Thumbnail(original: 'https://example.com/ep1.jpg'),
    number: 1,
    seasonNumber: 1,
    airdate: '2002-10-03',
  ),
);

// ── EpisodeModel tests ────────────────────────────────────────────────────────
void main() {
  group('EpisodeModel', () {
    const tJson = {
      'id': 'ep1',
      'attributes': {
        'canonicalTitle': 'Episode 1',
        'synopsis': 'The beginning',
        'thumbnail': {'original': 'https://example.com/ep1.jpg'},
        'number': 1,
        'seasonNumber': 1,
        'airdate': '2002-10-03',
      },
    };

    test('fromJson parses all fields correctly', () {
      final model = EpisodeModel.fromJson(tJson);
      expect(model.id, 'ep1');
      expect(model.attributes.canonicalTitle, 'Episode 1');
      expect(model.attributes.synopsis, 'The beginning');
      expect(
          model.attributes.thumbnail?.original, 'https://example.com/ep1.jpg');
      expect(model.attributes.number, 1);
      expect(model.attributes.seasonNumber, 1);
      expect(model.attributes.airdate, '2002-10-03');
    });

    test('fromJson handles null fields gracefully', () {
      final Map<String, dynamic> minimalJson = {
        'id': 'ep2',
        'attributes': <String, dynamic>{},
      };
      final model = EpisodeModel.fromJson(minimalJson);
      expect(model.id, 'ep2');
      expect(model.attributes.canonicalTitle, isNull);
      expect(model.attributes.thumbnail, isNull);
      expect(model.attributes.number, isNull);
    });

    test('toEntity maps to Episode correctly', () {
      final entity = tEpisodeModel.toEntity();
      expect(entity.id, 'ep1');
      expect(entity.title, 'Episode 1');
      expect(entity.episodeNumber, 1);
      expect(entity.seasonNumber, 1);
      expect(entity.airdate, '2002-10-03');
      expect(entity.isMovie, false);
    });

    test('toEntity handles null thumbnail', () {
      final modelNoThumb = EpisodeModel(
        id: 'ep3',
        attributes: EpisodeAttributes(number: 2),
      );
      final entity = modelNoThumb.toEntity();
      expect(entity.thumbnail, isNull);
    });
  });

  // ── EpisodeRepositoryImpl tests ───────────────────────────────────────────────
  group('EpisodeRepositoryImpl', () {
    late EpisodeRepositoryImpl repository;
    late MockEpisodeRemoteDataSource mockRemote;

    setUp(() {
      mockRemote = MockEpisodeRemoteDataSource();
      repository = EpisodeRepositoryImpl(mockRemote);
    });

    test('returns Right(episodes) on success', () async {
      when(() => mockRemote.getEpisodes('anime1', offset: 0, limit: 20))
          .thenAnswer((_) async => [tEpisodeModel]);

      final result =
          await repository.getEpisodes('anime1', offset: 0, limit: 20);

      expect(result.isRight(), true);
      result.fold((_) => fail('expected Right'), (eps) {
        expect(eps.first.id, 'ep1');
        expect(eps.first.title, 'Episode 1');
      });
    });

    test('returns Left(ServerFailure) on ServerException', () async {
      when(() => mockRemote.getEpisodes('anime1', offset: 0, limit: 20))
          .thenThrow(const ServerException('server down'));

      final result =
          await repository.getEpisodes('anime1', offset: 0, limit: 20);

      expect(result.isLeft(), true);
      result.fold((f) => expect(f, isA<ServerFailure>()), (_) => fail(''));
    });

    test('returns Left on unexpected exception', () async {
      when(() => mockRemote.getEpisodes('anime1', offset: 0, limit: 20))
          .thenThrow(Exception('unknown'));

      final result =
          await repository.getEpisodes('anime1', offset: 0, limit: 20);
      expect(result.isLeft(), true);
    });
  });

  // ── GetEpisodes use case tests ────────────────────────────────────────────────
  group('GetEpisodes', () {
    late MockEpisodeRepository mockRepo;
    late GetEpisodes usecase;

    setUp(() {
      mockRepo = MockEpisodeRepository();
      usecase = GetEpisodes(mockRepo);
    });

    test('returns episodes from repository', () async {
      when(() => mockRepo.getEpisodes('1', offset: 0, limit: 20))
          .thenAnswer((_) async => Right(tEpisodeList));

      final result = await usecase('1', offset: 0, limit: 20);
      expect(result.isRight(), true);
    });

    test('propagates failure', () async {
      when(() => mockRepo.getEpisodes('1', offset: 0, limit: 20))
          .thenAnswer((_) async => const Left(ServerFailure('error')));

      final result = await usecase('1', offset: 0, limit: 20);
      expect(result.isLeft(), true);
    });
  });

  // ── EpisodeBloc tests ─────────────────────────────────────────────────────────
  group('EpisodeBloc', () {
    late MockGetEpisodes mockGetEpisodes;

    setUp(() {
      mockGetEpisodes = MockGetEpisodes();
    });

    EpisodeBloc buildBloc() => EpisodeBloc(getEpisodes: mockGetEpisodes);

    blocTest<EpisodeBloc, EpisodeState>(
      'LoadEpisodes emits [Loading, Loaded] on success',
      build: () {
        when(() => mockGetEpisodes('42', offset: 0, limit: 20))
            .thenAnswer((_) async => Right(tEpisodeList));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const LoadEpisodes('42')),
      expect: () => [
        EpisodeLoading(),
        EpisodeLoaded(episodes: tEpisodeList, hasMore: false, isMovie: false),
      ],
    );

    blocTest<EpisodeBloc, EpisodeState>(
      'LoadEpisodes emits [Loading, Error] on failure',
      build: () {
        when(() => mockGetEpisodes('42', offset: 0, limit: 20))
            .thenAnswer((_) async => const Left(ServerFailure('server error')));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const LoadEpisodes('42')),
      expect: () => [
        EpisodeLoading(),
        const EpisodeError('server error'),
      ],
    );

    blocTest<EpisodeBloc, EpisodeState>(
      'LoadEpisodes detects movie when single episode has no number',
      build: () {
        const movieEpisode = Episode(id: 'm1', isMovie: false);
        when(() => mockGetEpisodes('99', offset: 0, limit: 20))
            .thenAnswer((_) async => const Right([movieEpisode]));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const LoadEpisodes('99')),
      expect: () => [
        EpisodeLoading(),
        const EpisodeLoaded(
            episodes: [Episode(id: 'm1')], hasMore: false, isMovie: true),
      ],
    );

    blocTest<EpisodeBloc, EpisodeState>(
      'LoadMoreEpisodes does nothing when hasMore=false',
      build: () {
        when(() => mockGetEpisodes('42', offset: 0, limit: 20))
            .thenAnswer((_) async => Right(tEpisodeList));
        return buildBloc();
      },
      act: (bloc) async {
        bloc.add(const LoadEpisodes('42'));
        await Future<void>.delayed(const Duration(milliseconds: 50));
        bloc.add(const LoadMoreEpisodes('42'));
      },
      expect: () => [
        EpisodeLoading(),
        EpisodeLoaded(episodes: tEpisodeList, hasMore: false, isMovie: false),
        // LoadMoreEpisodes is a no-op because hasMore=false
      ],
    );

    blocTest<EpisodeBloc, EpisodeState>(
      'LoadMoreEpisodes does nothing when state is not EpisodeLoaded',
      build: () => buildBloc(),
      act: (bloc) => bloc.add(const LoadMoreEpisodes('42')),
      expect: () => <EpisodeState>[],
    );
  });
}
