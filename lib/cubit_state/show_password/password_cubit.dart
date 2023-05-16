import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit_state/show_password/password_state.dart';

class ChangeVisibilityPasswordCubit extends Cubit<PasswordState>
{
  ChangeVisibilityPasswordCubit() : super(PasswordInitialState());

  static ChangeVisibilityPasswordCubit get(context) => BlocProvider.of(context);

  static bool password = true;

  void visibilityChanged()
  {
    password = !password;
    emit(PasswordChangeState());
  }

}