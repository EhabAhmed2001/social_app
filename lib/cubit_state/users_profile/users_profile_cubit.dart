import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit_state/users_profile/users_profile_state.dart';
import 'package:social_app/model/profile_model.dart';

class UsersProfileCubit extends Cubit<UsersProfileState> {
  UsersProfileCubit() : super(UsersProfileInitial());

  static UsersProfileCubit get(context) => BlocProvider.of(context);

  late UsersProfileModel userModel;

  Future<void> getUserProfile({
    required String uId,
  }) async {
    emit(GetUsersProfileLoadingState());
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .get()
          .then((value) {
            userModel = UsersProfileModel.fromMap(value.data());
      });
      emit(GetUsersProfileSuccessState());
    } catch (error) {
      debugPrint('Error when get user profile ====> ${error..toString()}');
      emit(GetUsersProfileErrorState());
    }
  }
}
