import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/constant/app_variable.dart';
import 'package:social_app/cubit_state/social/social_state.dart';
import 'package:social_app/model/user_model.dart';

class SocialCubit extends Cubit<SocialState> {
  SocialCubit() : super(SocialInitial());

  static SocialCubit get(context) => BlocProvider.of(context);

  UserModel? model = null;

  // Future<void> getUserData() async {
  //   emit(SocialLoading());
  //   FirebaseFirestore.instance.collection('users').doc(SocialAppVariable.userId).get()
  //       .then((value) {
  //     model = UserModel.fromMap(value.data());
  //     emit(SocialSuccess());
  //     print(' ============ in function =============== ');
  //     print(model);
  //   })
  //   .catchError((error) {
  //     if (kDebugMode) {
  //       print('error in get user data ${error.toString()}');
  //     }
  //     emit(SocialError(error));
  //   });
  // }

  Future<void> getUserData() async{
    emit(SocialLoading());
    try {
      DocumentSnapshot<Map<String, dynamic>> data =
      await FirebaseFirestore
          .instance
          .collection('users')
          .doc(SocialAppVariable.userId)
          .get();
      model = UserModel.fromMap(data.data());
      if (kDebugMode) {
        print(model);
      }
      emit(SocialSuccess());
    } catch (error) {
      if (kDebugMode) {
        print('error in get user data ${error.toString()}');
      }
      emit(SocialError(error.toString()));
    }
  }

}
