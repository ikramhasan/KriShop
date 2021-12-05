import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:krishop/domain/authentication/failures/auth_failure.dart';
import 'package:krishop/domain/authentication/interfaces/i_auth_repository.dart';

part 'sign_in_form_event.dart';
part 'sign_in_form_state.dart';
part 'sign_in_form_bloc.freezed.dart';

class SignInFormBloc extends Bloc<SignInFormEvent, SignInFormState> {
  SignInFormBloc(this._authRepository) : super(SignInFormState.initial()) {
    on<EmailChanged>((event, emit) {
      emit(
        state.copyWith(
          emailAddress: event.email,
          authFailureOrSuccessOption: none(),
        ),
      );
    });

    on<PasswordChanged>((event, emit) {
      emit(
        state.copyWith(
          emailAddress: event.password,
          authFailureOrSuccessOption: none(),
        ),
      );
    });

    on<UserNameChanged>((event, emit) {
      emit(
        state.copyWith(
          emailAddress: event.userName,
          authFailureOrSuccessOption: none(),
        ),
      );
    });

    on<SignInWithEmailAndPasswordPressed>((event, emit) async {
      Either<AuthFailure, Unit>? failureOrSuccess;

      failureOrSuccess = await _authRepository.signInWithEmailAndPassword(
        emailAddress: state.emailAddress,
        password: state.password,
      );

      emit(
        state.copyWith(
          isSubmitting: false,
          showErrorMessages: true,
          authFailureOrSuccessOption: optionOf(failureOrSuccess),
        ),
      );
    });

    on<RegisterWithEmailAndPasswordPressed>((event, emit) async {
      Either<AuthFailure, Unit>? failureOrSuccess;

      failureOrSuccess = await _authRepository.registerWithEmailAndPassword(
        userName: state.name,
        emailAddress: state.emailAddress,
        password: state.password,
      );

      emit(
        state.copyWith(
          isSubmitting: false,
          showErrorMessages: true,
          authFailureOrSuccessOption: optionOf(failureOrSuccess),
        ),
      );
    });

    on<SignInWithGooglePressed>((event, emit) async {
      emit(
        state.copyWith(
          isSubmitting: true,
          authFailureOrSuccessOption: none(),
        ),
      );

      final failureOrSuccess = await _authRepository.signInWithGoogle();

      emit(
        state.copyWith(
          isSubmitting: false,
          authFailureOrSuccessOption: some(failureOrSuccess),
        ),
      );
    });
  }
  final IAuthRepository _authRepository;
}
