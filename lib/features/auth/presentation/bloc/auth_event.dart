import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class CheckAuthStatus extends AuthEvent {}

class SignInWithEmailEvent extends AuthEvent {
  final String email;
  final String password;
  const SignInWithEmailEvent(this.email, this.password);
  @override
  List<Object?> get props => [email, password];
}

class SignInWithGoogleEvent extends AuthEvent {}

class SignInAsGuestEvent extends AuthEvent {}

class SignOutEvent extends AuthEvent {}

class UpdateUserProfileEvent extends AuthEvent {
  final String? username;
  final String? avatarUrl;
  final String? backgroundUrl;
  const UpdateUserProfileEvent({this.username, this.avatarUrl, this.backgroundUrl});
  @override
  List<Object?> get props => [username, avatarUrl, backgroundUrl];
}
