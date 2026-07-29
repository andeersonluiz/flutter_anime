import 'package:animes_io/core/error/failures.dart';
import 'package:animes_io/features/auth/domain/entities/app_user.dart';
import 'package:animes_io/features/auth/domain/repositories/auth_repository.dart';
import 'package:animes_io/features/auth/domain/usecases/sign_in_with_email.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late SignInWithEmail usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = SignInWithEmail(mockAuthRepository);
  });

  const tEmail = 'test@test.com';
  const tPassword = 'password123';
  const tUser = AppUser(
    uid: '123',
    email: tEmail,
    username: 'TestUser',
  );

  test('should return AppUser on successful sign in', () async {
    when(() => mockAuthRepository.signInWithEmail(tEmail, tPassword))
        .thenAnswer((_) async => const Right<AuthFailure, AppUser>(tUser));

    final result = await usecase(tEmail, tPassword);

    expect(result, const Right<AuthFailure, AppUser>(tUser));
    verify(() => mockAuthRepository.signInWithEmail(tEmail, tPassword))
        .called(1);
  });
}
