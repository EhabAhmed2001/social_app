import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit_state/login/login_state.dart';


class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  Future<void> userLogin({
    required String email,
    required String password,
  }) async {
    emit(LoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    ).then((value) {
      emit(LoginSuccessState(value.user!.uid));
    }).catchError((error){
      print("Error in Sign In ==> ${error.toString()}");
      emit(LoginErrorState(error.toString()));
    });
  }
}
