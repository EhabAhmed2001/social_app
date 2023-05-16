import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit_state/register/register_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/model/user_model.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  Future<void> userCreate({
    required String name,
    required String email,
    required String profileImage,
    required String coverImage,
    required String bio,
    required String phone,
    required String uId,
  }) async {
    UserModel model = UserModel(
      profileImage: profileImage,
      bio: bio,
      name: name,
      email: email,
      phone: phone,
      uId: uId,
      coverImage: coverImage,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(CreateUserSuccessState());
    }).catchError((error) {
      if (kDebugMode) {
        print("Error in Create account ==> ${error.toString()}");
      }
      emit(CreateUserErrorState(error.toString()));
    });
  }

  void userRegister({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) {
    emit(RegisterLoadingState());

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) async {
      await userCreate(
        name: name,
        email: email,
        coverImage: 'https://img.freepik.com/free-photo/young-man-learning-virtual-classroom_23-2149200179.jpg?t=st=1675103031~exp=1675103631~hmac=d8ee9f33f57720ba843d3f2c74e07e86eea60d96ac8b699dd978291639f2c5d0',
        profileImage: 'https://img.freepik.com/free-icon/user_318-168921.jpg?size=338&ext=jpg',
        bio: 'Enter your bio.....',
        phone: phone,
        uId: value.user!.uid,
      );

      emit(RegisterSuccessState(value.user!.uid));
    }).catchError((error) {
      if (kDebugMode) {
        print("Error in Register account ==> ${error.toString()}");
      }
      emit(RegisterErrorState(error.toString()));
    });
  }
}
