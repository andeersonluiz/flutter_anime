import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/sign_in_as_guest.dart';
import '../../domain/usecases/sign_in_with_email.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/update_user_profile.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetCurrentUser getCurrentUser;
  final SignInWithEmail signInWithEmail;
  final SignInWithGoogle signInWithGoogle;
  final SignInAsGuest signInAsGuest;
  final SignOut signOut;
  final UpdateUserProfile updateUserProfile;

  AuthBloc({
    required this.getCurrentUser,
    required this.signInWithEmail,
    required this.signInWithGoogle,
    required this.signInAsGuest,
    required this.signOut,
    required this.updateUserProfile,
  }) : super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<SignInWithEmailEvent>(_onSignInWithEmail);
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
    on<SignInAsGuestEvent>(_onSignInAsGuest);
    on<SignOutEvent>(_onSignOut);
    on<UpdateUserProfileEvent>(_onUpdateUserProfile);
  }

  void _onCheckAuthStatus(CheckAuthStatus event, Emitter<AuthState> emit) {
    emit(AuthLoading());
    final user = getCurrentUser();
    if (user != null) {
      emit(Authenticated(user: user));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onSignInWithEmail(
      SignInWithEmailEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signInWithEmail(event.email, event.password);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(Authenticated(user: user)),
    );
  }

  Future<void> _onSignInWithGoogle(
      SignInWithGoogleEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signInWithGoogle();
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(Authenticated(user: user)),
    );
  }

  Future<void> _onSignInAsGuest(
      SignInAsGuestEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signInAsGuest();
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(Authenticated(user: user)),
    );
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signOut();
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(Unauthenticated()),
    );
  }

  Future<void> _onUpdateUserProfile(
      UpdateUserProfileEvent event, Emitter<AuthState> emit) async {
    if (state is Authenticated) {
      emit(AuthLoading());
      final result = await updateUserProfile(
        username: event.username,
        avatarUrl: event.avatarUrl,
        backgroundUrl: event.backgroundUrl,
      );
      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (user) => emit(Authenticated(user: user)),
      );
    }
  }
}
