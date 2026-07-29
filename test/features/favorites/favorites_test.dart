import 'package:animes_io/core/error/exceptions.dart';
import 'package:animes_io/core/error/failures.dart';
import 'package:animes_io/features/favorites/data/datasources/favorites_remote_datasource.dart';
import 'package:animes_io/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:animes_io/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:animes_io/features/favorites/domain/usecases/get_favorites.dart';
import 'package:animes_io/features/favorites/domain/usecases/toggle_favorite.dart';
import 'package:animes_io/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:animes_io/features/favorites/presentation/bloc/favorites_event.dart';
import 'package:animes_io/features/favorites/presentation/bloc/favorites_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────────
class MockFavoritesRepository extends Mock implements FavoritesRepository {}

class MockFavoritesRemoteDataSource extends Mock
    implements FavoritesRemoteDataSource {}

class MockGetFavorites extends Mock implements GetFavorites {}

class MockToggleFavorite extends Mock implements ToggleFavorite {}

// ── Fixtures ──────────────────────────────────────────────────────────────────
const tUserId = 'user1';
const tAnimeId = 'anime1';
final tFavoriteIds = ['anime1', 'anime2'];

// ── FavoritesRepositoryImpl tests ─────────────────────────────────────────────
void main() {
  group('FavoritesRepositoryImpl', () {
    late FavoritesRepositoryImpl repository;
    late MockFavoritesRemoteDataSource mockRemote;

    setUp(() {
      mockRemote = MockFavoritesRemoteDataSource();
      repository = FavoritesRepositoryImpl(mockRemote);
    });

    group('getFavorites', () {
      test('returns Right(ids) on success', () async {
        when(() => mockRemote.getFavorites(tUserId))
            .thenAnswer((_) async => tFavoriteIds);

        final result = await repository.getFavorites(tUserId);

        expect(result.isRight(), true);
        result.fold((_) => fail(''), (ids) => expect(ids, tFavoriteIds));
      });

      test('returns Left(ServerFailure) on ServerException', () async {
        when(() => mockRemote.getFavorites(tUserId))
            .thenThrow(const ServerException('error'));

        final result = await repository.getFavorites(tUserId);
        expect(result.isLeft(), true);
        result.fold((f) => expect(f, isA<ServerFailure>()), (_) => fail(''));
      });

      test('returns Left on unexpected exception', () async {
        when(() => mockRemote.getFavorites(tUserId))
            .thenThrow(Exception('unknown'));
        final result = await repository.getFavorites(tUserId);
        expect(result.isLeft(), true);
      });
    });

    group('addFavorite', () {
      test('returns Right(unit) on success', () async {
        when(() => mockRemote.addFavorite(tUserId, tAnimeId))
            .thenAnswer((_) async {});

        final result = await repository.addFavorite(tUserId, tAnimeId);
        expect(result.isRight(), true);
      });

      test('returns Left on error', () async {
        when(() => mockRemote.addFavorite(tUserId, tAnimeId))
            .thenThrow(const ServerException('error'));

        final result = await repository.addFavorite(tUserId, tAnimeId);
        expect(result.isLeft(), true);
      });
    });

    group('removeFavorite', () {
      test('returns Right(unit) on success', () async {
        when(() => mockRemote.removeFavorite(tUserId, tAnimeId))
            .thenAnswer((_) async {});

        final result = await repository.removeFavorite(tUserId, tAnimeId);
        expect(result.isRight(), true);
      });

      test('returns Left on error', () async {
        when(() => mockRemote.removeFavorite(tUserId, tAnimeId))
            .thenThrow(const ServerException('error'));

        final result = await repository.removeFavorite(tUserId, tAnimeId);
        expect(result.isLeft(), true);
      });
    });

    group('isFavorite', () {
      test('returns Right(true) when document exists', () async {
        when(() => mockRemote.isFavorite(tUserId, tAnimeId))
            .thenAnswer((_) async => true);

        final result = await repository.isFavorite(tUserId, tAnimeId);
        expect(result.isRight(), true);
        result.fold((_) => fail(''), (v) => expect(v, true));
      });

      test('returns Right(false) when document not found', () async {
        when(() => mockRemote.isFavorite(tUserId, tAnimeId))
            .thenAnswer((_) async => false);

        final result = await repository.isFavorite(tUserId, tAnimeId);
        expect(result.isRight(), true);
        result.fold((_) => fail(''), (v) => expect(v, false));
      });
    });
  });

  // ── GetFavorites use case tests ───────────────────────────────────────────────
  group('GetFavorites', () {
    late MockFavoritesRepository mockRepo;
    late GetFavorites usecase;

    setUp(() {
      mockRepo = MockFavoritesRepository();
      usecase = GetFavorites(mockRepo);
    });

    test('returns favorite ids from repository', () async {
      when(() => mockRepo.getFavorites(tUserId))
          .thenAnswer((_) async => Right(tFavoriteIds));

      final result = await usecase(tUserId);
      expect(result.isRight(), true);
      result.fold((_) => fail(''), (ids) => expect(ids.length, 2));
    });

    test('propagates failure', () async {
      when(() => mockRepo.getFavorites(tUserId))
          .thenAnswer((_) async => const Left(ServerFailure('error')));

      final result = await usecase(tUserId);
      expect(result.isLeft(), true);
    });
  });

  // ── ToggleFavorite use case tests ─────────────────────────────────────────────
  group('ToggleFavorite', () {
    late MockFavoritesRepository mockRepo;
    late ToggleFavorite usecase;

    setUp(() {
      mockRepo = MockFavoritesRepository();
      usecase = ToggleFavorite(mockRepo);
    });

    test('calls addFavorite when anime is not yet favorite', () async {
      when(() => mockRepo.isFavorite(tUserId, tAnimeId))
          .thenAnswer((_) async => const Right(false));
      when(() => mockRepo.addFavorite(tUserId, tAnimeId))
          .thenAnswer((_) async => const Right(unit));

      await usecase(tUserId, tAnimeId);

      verify(() => mockRepo.addFavorite(tUserId, tAnimeId)).called(1);
      verifyNever(() => mockRepo.removeFavorite(tUserId, tAnimeId));
    });

    test('calls removeFavorite when anime is already favorite', () async {
      when(() => mockRepo.isFavorite(tUserId, tAnimeId))
          .thenAnswer((_) async => const Right(true));
      when(() => mockRepo.removeFavorite(tUserId, tAnimeId))
          .thenAnswer((_) async => const Right(unit));

      await usecase(tUserId, tAnimeId);

      verify(() => mockRepo.removeFavorite(tUserId, tAnimeId)).called(1);
      verifyNever(() => mockRepo.addFavorite(tUserId, tAnimeId));
    });
  });

  // ── FavoritesBloc tests ───────────────────────────────────────────────────────
  group('FavoritesBloc', () {
    late MockGetFavorites mockGetFavorites;
    late MockToggleFavorite mockToggleFavorite;

    setUp(() {
      mockGetFavorites = MockGetFavorites();
      mockToggleFavorite = MockToggleFavorite();
    });

    FavoritesBloc buildBloc() => FavoritesBloc(
          getFavorites: mockGetFavorites,
          toggleFavorite: mockToggleFavorite,
        );

    blocTest<FavoritesBloc, FavoritesState>(
      'LoadFavorites emits [Loading, Loaded] on success',
      build: () {
        when(() => mockGetFavorites(tUserId))
            .thenAnswer((_) async => Right(tFavoriteIds));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const LoadFavorites(tUserId)),
      expect: () => [
        FavoritesLoading(),
        FavoritesLoaded(favoriteIds: {'anime1', 'anime2'}),
      ],
    );

    blocTest<FavoritesBloc, FavoritesState>(
      'LoadFavorites emits [Loading, Error] on failure',
      build: () {
        when(() => mockGetFavorites(tUserId))
            .thenAnswer((_) async => const Left(ServerFailure('error')));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const LoadFavorites(tUserId)),
      expect: () => [
        FavoritesLoading(),
        const FavoritesError('error'),
      ],
    );

    blocTest<FavoritesBloc, FavoritesState>(
      'ToggleFavoriteEvent adds optimistically then persists',
      build: () {
        when(() => mockGetFavorites(tUserId))
            .thenAnswer((_) async => Right(['anime2']));
        when(() => mockToggleFavorite(tUserId, tAnimeId))
            .thenAnswer((_) async => const Right(unit));
        return buildBloc();
      },
      act: (bloc) async {
        bloc.add(const LoadFavorites(tUserId));
        await Future<void>.delayed(const Duration(milliseconds: 50));
        bloc.add(const ToggleFavoriteEvent(tUserId, tAnimeId));
      },
      expect: () => [
        FavoritesLoading(),
        FavoritesLoaded(favoriteIds: {'anime2'}),
        // Optimistically adds anime1
        FavoritesLoaded(favoriteIds: {'anime2', tAnimeId}),
      ],
    );

    blocTest<FavoritesBloc, FavoritesState>(
      'ToggleFavoriteEvent removes optimistically',
      build: () {
        when(() => mockGetFavorites(tUserId))
            .thenAnswer((_) async => Right(tFavoriteIds));
        when(() => mockToggleFavorite(tUserId, tAnimeId))
            .thenAnswer((_) async => const Right(unit));
        return buildBloc();
      },
      act: (bloc) async {
        bloc.add(const LoadFavorites(tUserId));
        await Future<void>.delayed(const Duration(milliseconds: 50));
        bloc.add(const ToggleFavoriteEvent(tUserId, tAnimeId));
      },
      expect: () => [
        FavoritesLoading(),
        FavoritesLoaded(favoriteIds: {'anime1', 'anime2'}),
        // Optimistically removes anime1
        FavoritesLoaded(favoriteIds: {'anime2'}),
      ],
    );

    blocTest<FavoritesBloc, FavoritesState>(
      'ToggleFavoriteEvent does nothing when state is not FavoritesLoaded',
      build: () => buildBloc(),
      act: (bloc) => bloc.add(const ToggleFavoriteEvent(tUserId, tAnimeId)),
      expect: () => [],
    );
  });
}
