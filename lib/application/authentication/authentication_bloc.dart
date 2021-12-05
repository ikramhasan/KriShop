import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:krishop/domain/authentication/interfaces/i_auth_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';
part 'authentication_bloc.freezed.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc(this._authRepository) : super(const Initial()) {
    on<AuthCheckRequested>((event, emit) async {
      final userOption = await _authRepository.getSignedInUser();
      emit(
        userOption.fold(
          () => const AuthenticationState.unauthenticated(),
          (_) => const AuthenticationState.authenticated(),
        ),
      );
    });

    on<SignedOut>((event, emit) async {
      await _authRepository.signOut();
      emit(const AuthenticationState.unauthenticated());
    });
  }

  final IAuthRepository _authRepository;
}
