import 'package:animes_io/core/error/exceptions.dart';
import 'package:animes_io/core/error/failures.dart';
import 'package:animes_io/features/category/data/datasources/category_remote_datasource.dart';
import 'package:animes_io/features/category/data/models/category_model.dart';
import 'package:animes_io/features/category/data/repositories/category_repository_impl.dart';
import 'package:animes_io/features/category/domain/entities/category.dart';
import 'package:animes_io/features/category/domain/repositories/category_repository.dart';
import 'package:animes_io/features/category/domain/usecases/get_all_categories.dart';
import 'package:animes_io/features/category/domain/usecases/get_trending_categories.dart';
import 'package:animes_io/features/category/presentation/bloc/category_bloc.dart';
import 'package:animes_io/features/category/presentation/bloc/category_event.dart';
import 'package:animes_io/features/category/presentation/bloc/category_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────────
class MockCategoryRepository extends Mock implements CategoryRepository {}

class MockCategoryRemoteDataSource extends Mock
    implements CategoryRemoteDataSource {}

class MockGetTrendingCategories extends Mock implements GetTrendingCategories {}

class MockGetAllCategories extends Mock implements GetAllCategories {}

// ── Fixtures ──────────────────────────────────────────────────────────────────
final tCategoryModel = CategoryModel(
  id: '1',
  title: 'Action',
  slug: 'action',
  description: 'Action anime',
  totalMediaCount: 500,
);

const tCategory = Category(
  id: '1',
  title: 'Action',
  slug: 'action',
  description: 'Action anime',
  totalMediaCount: 500,
);

final tCategoryList = [tCategory];
final List<CategoryModel> tModelList = [tCategoryModel];

// ── CategoryModel tests ───────────────────────────────────────────────────────
void main() {
  group('CategoryModel', () {
    const tJson = {
      'id': '1',
      'attributes': {
        'title': 'Action',
        'slug': 'action',
        'description': 'Action anime',
        'totalMediaCount': 500,
      },
    };

    test('fromJson parses all fields correctly', () {
      final model = CategoryModel.fromJson(tJson);
      expect(model.id, '1');
      expect(model.title, 'Action');
      expect(model.slug, 'action');
      expect(model.description, 'Action anime');
      expect(model.totalMediaCount, 500);
    });

    test('fromJson handles nullable fields', () {
      const minimalJson = {
        'id': '2',
        'attributes': {
          'title': 'Drama',
          'slug': 'drama',
        },
      };
      final model = CategoryModel.fromJson(minimalJson);
      expect(model.description, isNull);
      expect(model.totalMediaCount, isNull);
    });

    test('toEntity maps to Category correctly', () {
      final entity = tCategoryModel.toEntity();
      expect(entity.id, '1');
      expect(entity.title, 'Action');
      expect(entity.slug, 'action');
      expect(entity.description, 'Action anime');
      expect(entity.totalMediaCount, 500);
    });

    test('toEntity uses default values for nulls', () {
      final model = CategoryModel(id: '1', title: 'X', slug: 'x');
      final entity = model.toEntity();
      expect(entity.description, '');
      expect(entity.totalMediaCount, 0);
    });
  });

  // ── CategoryRemoteDataSource tests ──────────────────────────────────────────
  group('CategoryRemoteDataSourceImpl', () {
    // These are covered via repository tests via mock below
  });

  // ── CategoryRepository tests ─────────────────────────────────────────────────
  group('CategoryRepositoryImpl', () {
    late CategoryRepositoryImpl repository;
    late MockCategoryRemoteDataSource mockRemote;

    setUp(() {
      mockRemote = MockCategoryRemoteDataSource();
      repository = CategoryRepositoryImpl(mockRemote);
    });

    group('getTrendingCategories', () {
      test('returns Right(categories) on success', () async {
        when(() => mockRemote.getTrendingCategories(limit: 20))
            .thenAnswer((_) async => tModelList);

        final result = await repository.getTrendingCategories(limit: 20);

        expect(result.isRight(), true);
        result.fold((_) => fail('expected Right'), (cats) {
          expect(cats.first.id, '1');
          expect(cats.first.slug, 'action');
        });
      });

      test('returns Left(ServerFailure) on ServerException', () async {
        when(() => mockRemote.getTrendingCategories(limit: 20))
            .thenThrow(const ServerException('server down'));

        final result = await repository.getTrendingCategories(limit: 20);

        expect(result.isLeft(), true);
        result.fold((f) => expect(f, isA<ServerFailure>()), (_) => fail(''));
      });

      test('returns Left(ServerFailure) on unexpected exception', () async {
        when(() => mockRemote.getTrendingCategories(limit: 20))
            .thenThrow(Exception('unknown'));

        final result = await repository.getTrendingCategories(limit: 20);
        expect(result.isLeft(), true);
      });
    });

    group('getAllCategories', () {
      test('returns Right(categories) on success', () async {
        when(() => mockRemote.getAllCategories(offset: 0, limit: 20))
            .thenAnswer((_) async => tModelList);

        final result = await repository.getAllCategories(offset: 0, limit: 20);

        expect(result.isRight(), true);
      });

      test('returns Left(ServerFailure) on error', () async {
        when(() => mockRemote.getAllCategories(offset: 0, limit: 20))
            .thenThrow(const ServerException('error'));

        final result = await repository.getAllCategories(offset: 0, limit: 20);
        expect(result.isLeft(), true);
      });
    });
  });

  // ── GetTrendingCategories use case tests ─────────────────────────────────────
  group('GetTrendingCategories', () {
    late MockCategoryRepository mockRepo;
    late GetTrendingCategories usecase;

    setUp(() {
      mockRepo = MockCategoryRepository();
      usecase = GetTrendingCategories(mockRepo);
    });

    test('returns categories from repository', () async {
      when(() => mockRepo.getTrendingCategories(limit: 20))
          .thenAnswer((_) async => Right(tCategoryList));

      final result = await usecase(limit: 20);

      expect(result.isRight(), true);
      verify(() => mockRepo.getTrendingCategories(limit: 20)).called(1);
    });

    test('propagates failure', () async {
      when(() => mockRepo.getTrendingCategories(limit: 20))
          .thenAnswer((_) async => const Left(ServerFailure('error')));

      final result = await usecase(limit: 20);
      expect(result.isLeft(), true);
    });
  });

  // ── GetAllCategories use case tests ──────────────────────────────────────────
  group('GetAllCategories', () {
    late MockCategoryRepository mockRepo;
    late GetAllCategories usecase;

    setUp(() {
      mockRepo = MockCategoryRepository();
      usecase = GetAllCategories(mockRepo);
    });

    test('returns categories from repository', () async {
      when(() => mockRepo.getAllCategories(offset: 0, limit: 20))
          .thenAnswer((_) async => Right(tCategoryList));

      final result = await usecase(offset: 0, limit: 20);
      expect(result.isRight(), true);
    });

    test('propagates failure', () async {
      when(() => mockRepo.getAllCategories(offset: 0, limit: 20))
          .thenAnswer((_) async => const Left(ServerFailure('error')));

      final result = await usecase(offset: 0, limit: 20);
      expect(result.isLeft(), true);
    });
  });

  // ── CategoryBloc tests ────────────────────────────────────────────────────────
  group('CategoryBloc', () {
    late MockGetTrendingCategories mockTrending;
    late MockGetAllCategories mockAll;

    setUp(() {
      mockTrending = MockGetTrendingCategories();
      mockAll = MockGetAllCategories();
    });

    CategoryBloc buildBloc() => CategoryBloc(
          getTrendingCategories: mockTrending,
          getAllCategories: mockAll,
        );

    blocTest<CategoryBloc, CategoryState>(
      'LoadTrendingCategories emits [Loading, Loaded] on success',
      build: () {
        when(() => mockTrending(limit: 20))
            .thenAnswer((_) async => Right(tCategoryList));
        return buildBloc();
      },
      act: (bloc) => bloc.add(LoadTrendingCategories()),
      expect: () => [
        CategoryLoading(),
        CategoryLoaded(categories: tCategoryList, isShowingTrending: true),
      ],
    );

    blocTest<CategoryBloc, CategoryState>(
      'LoadTrendingCategories emits [Loading, Error] on failure',
      build: () {
        when(() => mockTrending(limit: 20))
            .thenAnswer((_) async => const Left(ServerFailure('error')));
        return buildBloc();
      },
      act: (bloc) => bloc.add(LoadTrendingCategories()),
      expect: () => [
        CategoryLoading(),
        const CategoryError(message: 'error'),
      ],
    );

    blocTest<CategoryBloc, CategoryState>(
      'LoadAllCategories emits [Loading, Loaded] on success',
      build: () {
        when(() => mockAll(offset: 0, limit: 100))
            .thenAnswer((_) async => Right(tCategoryList));
        return buildBloc();
      },
      act: (bloc) => bloc.add(LoadAllCategories()),
      expect: () => [
        CategoryLoading(),
        CategoryLoaded(categories: tCategoryList, isShowingTrending: false),
      ],
    );

    blocTest<CategoryBloc, CategoryState>(
      'ToggleCategoryView switches from trending to all',
      build: () {
        when(() => mockTrending(limit: 20))
            .thenAnswer((_) async => Right(tCategoryList));
        when(() => mockAll(offset: 0, limit: 100))
            .thenAnswer((_) async => Right(tCategoryList));
        return buildBloc();
      },
      act: (bloc) async {
        bloc.add(LoadTrendingCategories());
        await Future<void>.delayed(const Duration(milliseconds: 50));
        bloc.add(ToggleCategoryView());
      },
      expect: () => [
        CategoryLoading(),
        CategoryLoaded(categories: tCategoryList, isShowingTrending: true),
        CategoryLoading(),
        CategoryLoaded(categories: tCategoryList, isShowingTrending: false),
      ],
    );
  });
}
