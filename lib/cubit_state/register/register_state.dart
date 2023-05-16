abstract class RegisterState {}

class RegisterInitialState extends RegisterState {}

class RegisterLoadingState extends RegisterState {}

class RegisterSuccessState extends RegisterState {
  final String uId;
  RegisterSuccessState(this.uId);
}

class RegisterErrorState extends RegisterState {
  final String error;
  RegisterErrorState(this.error);
}
class CreateUserSuccessState extends RegisterState {}

class CreateUserErrorState extends RegisterState {
  final String error;
  CreateUserErrorState(this.error);
}

