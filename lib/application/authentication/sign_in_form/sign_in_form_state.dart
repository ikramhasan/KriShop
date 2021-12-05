part of 'sign_in_form_bloc.dart';

@freezed
class SignInFormState with _$SignInFormState {
  const factory SignInFormState({
    required String name,
    required String emailAddress,
    required String password,
    required bool isSubmitting,
    required bool showErrorMessages,
    required Option<Either<AuthFailure, Unit>> authFailureOrSuccessOption,
  }) = _SignInFormState;

  factory SignInFormState.initial() => SignInFormState(
        name: '',
        emailAddress: '',
        password: '',
        isSubmitting: false,
        showErrorMessages: false,
        authFailureOrSuccessOption: none(),
      );
}
