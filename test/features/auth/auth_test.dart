import 'package:animes_io/core/error/exceptions.dart';
import 'package:animes_io/core/error/failures.dart';
import 'package:animes_io/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:animes_io/features/auth/data/models/user_model.dart';
import 'package:animes_io/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:animes_io/features/auth/domain/entities/app_user.dart';
import 'package:animes_io/features/auth/domain/repositories/auth_repository.dart';
import 'package:animes_io/features/auth/domain/usecases/get_current_user.dart';
import 'package:animes_io/features/auth/domain/usecases/sign_in_as_guest.dart';
import 'package:animes_io/features/auth/domain/usecases/sign_in_with_email.dart';
import 'package:animes_io/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:animes_io/features/auth/domain/usecases/sign_out.dart';
import 'package:animes_io/features/auth/domain/usecases/update_user_profile.dart';
import 'package:animes_io/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:animes_io/features/auth/presentation/bloc/auth_event.dart';
import 'package:animes_io/features/auth/presentation/bloc/auth_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────────
class MockAuthRepository extends Mock implements AuthRepository {}

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockGetCurrentUser extends Mock implements GetCurrentUser {}

class MockSignInWithEmail extends Mock implements SignInWithEmail {}

class MockSignInWithGoogle extends Mock implements SignInWithGoogle {}

class MockSignInAsGuest extends Mock implements SignInAsGuest {}

class MockSignOut extends Mock implements SignOut {}

class MockUpdateUserProfile extends Mock implements UpdateUserProfile {}

// ── Fixtures ──────────────────────────────────────────────────────────────────
const tAppUser = AppUser(
  uid: 'uid1',
  email: 'test@test.com',
  username: 'testuser',
);

const tUserModel = UserModel(
  uid: 'uid1',
  email: 'test@test.com',
  username: 'testuser',
);

// ── UserModel tests ───────────────────────────────────────────────────────────
void main() {
  group('UserModel', () {
    const tJson = {
      'uid': 'uid1',
      'email': 'test@test.com',
      'username': 'testuser',
      'avatarUrl': 'https://example.com/avatar.jpg',
      'backgroundUrl': null,
      'isAnonymous': false,
      'favoriteAnimeIds': ['1', '2'],
    };

    test('fromJson parses all fields', () {
      final model = UserModel.fromJson(tJson);
      expect(model.uid, 'uid1');
      expect(model.email, 'test@test.com');
      expect(model.username, 'testuser');
      expect(model.avatarUrl, 'https://example.com/avatar.jpg');
      expect(model.backgroundUrl, isNull);
      expect(model.isAnonymous, false);
      expect(model.favoriteAnimeIds, ['1', '2']);
    });

    test('fromJson uses defaults for missing nullable fields', () {
      const minimalJson = {
        'uid': 'uid2',
        'email': 'x@x.com',
        'username': 'x',
      };
      final model = UserModel.fromJson(minimalJson);
      expect(model.isAnonymous, false);
      expect(model.favoriteAnimeIds, isEmpty);
    });

    test('toJson serializes correctly', () {
      const model = UserModel(
        uid: 'uid1',
        email: 'test@test.com',
        username: 'testuser',
        favoriteAnimeIds: ['1'],
      );
      final json = model.toJson();
      expect(json['uid'], 'uid1');
      expect(json['favoriteAnimeIds'], ['1']);
    });

    test('toEntity maps to AppUser correctly', () {
      final entity = tUserModel.toEntity();
      expect(entity.uid, 'uid1');
      expect(entity.email, 'test@test.com');
      expect(entity.username, 'testuser');
      expect(entity.isAnonymous, false);
    });

    test('fromEntity creates model from AppUser', () {
      const user = AppUser(
        uid: 'uid3',
        email: 'a@b.com',
        username: 'abc',
        isAnonymous: true,
      );
      final model = UserModel.fromEntity(user);
      expect(model.uid, 'uid3');
      expect(model.isAnonymous, true);
    });
  });

  // ── AuthRepositoryImpl tests ──────────────────────────────────────────────────
  group('AuthRepositoryImpl', () {
    late AuthRepositoryImpl repository;
    late MockAuthRemoteDataSource mockRemote;

    setUp(() {
      mockRemote = MockAuthRemoteDataSource();
      repository = AuthRepositoryImpl(mockRemote);
    });

    group('signInWithEmail', () {
      test('returns Right(AppUser) on success', () async {
        when(() => mockRemote.signInWithEmail('test@test.com', 'password'))
            .thenAnswer((_) async => tUserModel);

        final result =
            await repository.signInWithEmail('test@test.com', 'password');

        expect(result.isRight(), true);
        result.fold((_) => fail(''), (u) => expect(u.uid, 'uid1'));
      });

      test('returns Left(ServerFailure) on ServerException', () async {
        when(() => mockRemote.signInWithEmail('test@test.com', 'wrong'))
            .thenThrow(const ServerException('Invalid credentials'));

        final result =
            await repository.signInWithEmail('test@test.com', 'wrong');
        expect(result.isLeft(), true);
        result.fold((f) => expect(f, isA<ServerFailure>()), (_) => fail(''));
      });
    });

    group('signInWithGoogle', () {
      test('returns Right(AppUser) on success', () async {
        when(() => mockRemote.signInWithGoogle())
            .thenAnswer((_) async => tUserModel);
        final result = await repository.signInWithGoogle();
        expect(result.isRight(), true);
      });

      test('returns Left on error', () async {
        when(() => mockRemote.signInWithGoogle())
            .thenThrow(const ServerException('cancelled'));
        final result = await repository.signInWithGoogle();
        expect(result.isLeft(), true);
      });
    });

    group('signInAsGuest', () {
      test('returns Right(AppUser) on success', () async {
        when(() => mockRemote.signInAsGuest())
            .thenAnswer((_) async => tUserModel);
        final result = await repository.signInAsGuest();
        expect(result.isRight(), true);
      });
    });

    group('signOut', () {
      test('returns Right(unit) on success', () async {
        when(() => mockRemote.signOut()).thenAnswer((_) async {});
        final result = await repository.signOut();
        expect(result.isRight(), true);
      });

      test('returns Left on error', () async {
        when(() => mockRemote.signOut())
            .thenThrow(const ServerException('error'));
        final result = await repository.signOut();
        expect(result.isLeft(), true);
      });
    });

    group('getCurrentUser', () {
      test('returns AppUser when logged in', () {
        when(() => mockRemote.getCurrentUser()).thenReturn(tUserModel);
        final user = repository.getCurrentUser();
        expect(user?.uid, 'uid1');
      });

      test('returns null when not logged in', () {
        when(() => mockRemote.getCurrentUser()).thenReturn(null);
        final user = repository.getCurrentUser();
        expect(user, isNull);
      });
    });

    group('updateUserProfile', () {
      test('returns Right(AppUser) on success', () async {
        when(() => mockRemote.updateUserProfile(username: 'newname'))
            .thenAnswer((_) async => tUserModel);
        final result = await repository.updateUserProfile(username: 'newname');
        expect(result.isRight(), true);
      });

      test('returns Left on error', () async {
        when(() => mockRemote.updateUserProfile(username: 'newname'))
            .thenThrow(const ServerException('error'));
        final result = await repository.updateUserProfile(username: 'newname');
        expect(result.isLeft(), true);
      });
    });
  });

  // ── Auth use case tests ───────────────────────────────────────────────────────
  group('Auth use cases', () {
    late MockAuthRepository mockRepo;

    setUp(() => mockRepo = MockAuthRepository());

    test('GetCurrentUser returns user when logged in', () {
      when(() => mockRepo.getCurrentUser()).thenReturn(tAppUser);
      final result = GetCurrentUser(mockRepo)();
      expect(result?.uid, 'uid1');
    });

    test('GetCurrentUser returns null when not logged in', () {
      when(() => mockRepo.getCurrentUser()).thenReturn(null);
      final result = GetCurrentUser(mockRepo)();
      expect(result, isNull);
    });

    test('SignInWithGoogle propagates Right', () async {
      when(() => mockRepo.signInWithGoogle())
          .thenAnswer((_) async => const Right(tAppUser));
      final result = await SignInWithGoogle(mockRepo)();
      expect(result.isRight(), true);
    });

    test('SignInAsGuest propagates Right', () async {
      when(() => mockRepo.signInAsGuest())
          .thenAnswer((_) async => const Right(tAppUser));
      final result = await SignInAsGuest(mockRepo)();
      expect(result.isRight(), true);
    });

    test('SignOut propagates Right(unit)', () async {
      when(() => mockRepo.signOut()).thenAnswer((_) async => const Right(unit));
      final result = await SignOut(mockRepo)();
      expect(result.isRight(), true);
    });

    test('UpdateUserProfile propagates result', () async {
      when(() => mockRepo.updateUserProfile(username: 'new'))
          .thenAnswer((_) async => const Right(tAppUser));
      final result = await UpdateUserProfile(mockRepo)(username: 'new');
      expect(result.isRight(), true);
    });
  });

  // ── AuthBloc tests ────────────────────────────────────────────────────────────
  group('AuthBloc', () {
    late MockGetCurrentUser mockGetCurrentUser;
    late MockSignInWithEmail mockSignInWithEmail;
    late MockSignInWithGoogle mockSignInWithGoogle;
    late MockSignInAsGuest mockSignInAsGuest;
    late MockSignOut mockSignOut;
    late MockUpdateUserProfile mockUpdateUserProfile;

    setUp(() {
      mockGetCurrentUser = MockGetCurrentUser();
      mockSignInWithEmail = MockSignInWithEmail();
      mockSignInWithGoogle = MockSignInWithGoogle();
      mockSignInAsGuest = MockSignInAsGuest();
      mockSignOut = MockSignOut();
      mockUpdateUserProfile = MockUpdateUserProfile();
    });

    AuthBloc buildBloc() => AuthBloc(
          getCurrentUser: mockGetCurrentUser,
          signInWithEmail: mockSignInWithEmail,
          signInWithGoogle: mockSignInWithGoogle,
          signInAsGuest: mockSignInAsGuest,
          signOut: mockSignOut,
          updateUserProfile: mockUpdateUserProfile,
        );

    blocTest<AuthBloc, AuthState>(
      'CheckAuthStatus emits [Loading, Authenticated] when user exists',
      build: () {
        when(() => mockGetCurrentUser()).thenReturn(tAppUser);
        return buildBloc();
      },
      act: (bloc) => bloc.add(CheckAuthStatus()),
      expect: () => [
        AuthLoading(),
        const Authenticated(user: tAppUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'CheckAuthStatus emits [Loading, Unauthenticated] when no user',
      build: () {
        when(() => mockGetCurrentUser()).thenReturn(null);
        return buildBloc();
      },
      act: (bloc) => bloc.add(CheckAuthStatus()),
      expect: () => [
        AuthLoading(),
        Unauthenticated(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'SignInWithEmailEvent emits [Loading, Authenticated] on success',
      build: () {
        when(() => mockSignInWithEmail('test@test.com', 'password'))
            .thenAnswer((_) async => const Right(tAppUser));
        when(() => mockGetCurrentUser()).thenReturn(null);
        return buildBloc();
      },
      act: (bloc) =>
          bloc.add(const SignInWithEmailEvent('test@test.com', 'password')),
      expect: () => [
        AuthLoading(),
        const Authenticated(user: tAppUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'SignInWithEmailEvent emits [Loading, AuthError] on failure',
      build: () {
        when(() => mockSignInWithEmail('bad@bad.com', 'wrong')).thenAnswer(
            (_) async => const Left(ServerFailure('Invalid credentials')));
        when(() => mockGetCurrentUser()).thenReturn(null);
        return buildBloc();
      },
      act: (bloc) =>
          bloc.add(const SignInWithEmailEvent('bad@bad.com', 'wrong')),
      expect: () => [
        AuthLoading(),
        const AuthError('Invalid credentials'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'SignInWithGoogleEvent emits [Loading, Authenticated] on success',
      build: () {
        when(() => mockSignInWithGoogle())
            .thenAnswer((_) async => const Right(tAppUser));
        when(() => mockGetCurrentUser()).thenReturn(null);
        return buildBloc();
      },
      act: (bloc) => bloc.add(SignInWithGoogleEvent()),
      expect: () => [
        AuthLoading(),
        const Authenticated(user: tAppUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'SignInAsGuestEvent emits [Loading, Authenticated] on success',
      build: () {
        when(() => mockSignInAsGuest())
            .thenAnswer((_) async => const Right(tAppUser));
        when(() => mockGetCurrentUser()).thenReturn(null);
        return buildBloc();
      },
      act: (bloc) => bloc.add(SignInAsGuestEvent()),
      expect: () => [
        AuthLoading(),
        const Authenticated(user: tAppUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'SignOutEvent emits [Loading, Unauthenticated] on success',
      build: () {
        when(() => mockSignOut()).thenAnswer((_) async => const Right(unit));
        when(() => mockGetCurrentUser()).thenReturn(null);
        return buildBloc();
      },
      act: (bloc) => bloc.add(SignOutEvent()),
      expect: () => [
        AuthLoading(),
        Unauthenticated(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'UpdateUserProfileEvent emits [Loading, Authenticated] on success',
      build: () {
        when(() => mockGetCurrentUser()).thenReturn(tAppUser);
        when(() => mockUpdateUserProfile(username: 'newname'))
            .thenAnswer((_) async => const Right(tAppUser));
        return buildBloc();
      },
      seed: () => const Authenticated(user: tAppUser),
      act: (bloc) =>
          bloc.add(const UpdateUserProfileEvent(username: 'newname')),
      expect: () => [
        AuthLoading(),
        const Authenticated(user: tAppUser),
      ],
    );
  });
}
