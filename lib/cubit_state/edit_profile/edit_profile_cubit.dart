import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/constant/app_variable.dart';
import 'package:social_app/cubit_state/edit_profile/edit_profile_state.dart';
import 'package:social_app/cubit_state/social/social_cubit.dart';
import 'package:social_app/model/user_model.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(EditProfileInitialState());

  static EditProfileCubit get(context) => BlocProvider.of(context);

  File? profileImage;
  Future<void> getProfileImage() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      print(profileImage);
      emit(GetProfileImageSuccessState());
     // _updateProfileImage();
    } else {
      print('no image selected');
      emit(GetProfileImageErrorState());
    }
  }

  File? coverImage;
  Future<void> getCoverImage() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      print(coverImage);
      emit(GetCoverImageSuccessState());
      _updateCoverImage();
    } else {
      print('no image selected');
      emit(GetCoverImageErrorState());
    }
  }

  String? profileUrl;
  Future<void> _updateProfileImage() async {
    try {
      TaskSnapshot? putFile = await FirebaseStorage.instance
          .ref()
          .child('users/${SocialAppVariable.userId}/profile images/${Uri.file(profileImage!.path).pathSegments.last}')
          .putFile(profileImage!);
      profileUrl = await putFile.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('posts')
          .get()
          .then((value) async {
            for(var element in value.docs){
              if(element.data()['uId'] == SocialAppVariable.userId)
              {
              await FirebaseFirestore.instance.collection('posts').doc(element.id).update(
                  {'profileImage': profileUrl}
              );
                print('========================================= $profileUrl');
              }
            }
      });

      emit(UploadProfileImageSuccessState());
    } catch (e) {
      if (kDebugMode) {
        print('error in update profile image  ${e.toString()}');
      }
      emit(UploadProfileImageErrorState1());
    }
  }

  // Future<void> _updateProfileImage() async {
  //   FirebaseStorage.instance
  //       .ref()
  //       .child(
  //           'users/${SocialAppVariable.userId}/profile images/${Uri.file(profileImage!.path).pathSegments.last}')
  //       .putFile(profileImage!)
  //       .then((value) {
  //     value.ref.getDownloadURL().then((value) {
  //       profileUrl = value;
  //       print('========================= profile url');
  //       print(profileUrl);
  //       emit(UploadProfileImageSuccessState());
  //     }).catchError((error) {
  //       if (kDebugMode) {
  //         print('error in update profile image 1 ${error.toString()}');
  //       }
  //       emit(UploadProfileImageErrorState1());
  //     });
  //   }).catchError((error) {
  //     if (kDebugMode) {
  //       print('error in update profile image 1 ${error.toString()}');
  //     }
  //     emit(UploadProfileImageErrorState2());
  //   });
  // }

  String? coverUrl;
  Future<void> _updateCoverImage() async {
    try {
      TaskSnapshot? putFile = await FirebaseStorage.instance
          .ref()
          .child('users/${SocialAppVariable.userId}/cover images/${Uri.file(coverImage!.path).pathSegments.last}')
          .putFile(coverImage!);

      coverUrl = await putFile.ref.getDownloadURL();


      emit(UploadCoverImageSuccessState());
    } catch (e) {
      if (kDebugMode) {
        print('error in update profile image  ${e.toString()}');
      }
      emit(UploadCoverImageErrorState1());
    }
  }

  // ==================== UPDATE ALL DATA ===============================

  Future<void> updateEdit({
    required BuildContext context,
    required String name,
    required String phone,
    required String? bio,
  }) async {
    emit(UpdateProfileLoadingState());

    if (profileImage != null) {
      emit(UpdateProfileImageLoadingState());
      await _updateProfileImage();
    }

    if (coverImage != null) {
      emit(UpdateCoverImageLoadingState());
      await _updateCoverImage();
    }

    UserModel model = UserModel(
      name: name,
      phone: phone,
      bio: bio,
      email: SocialCubit.get(context).model!.email,
      profileImage: profileUrl ?? SocialCubit.get(context).model!.profileImage,
      coverImage: coverUrl ?? SocialCubit.get(context).model!.coverImage,
      uId: SocialCubit.get(context).model!.uId,
    );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(SocialAppVariable.userId)
        .update(model.toMap())
        .then((value) async {
      print('================================= Updated');

      await SocialCubit.get(context).getUserData();
      emit(UpdateProfileSuccessState());
    }).catchError((error) {
      if (kDebugMode) {
        print('Error in update profile ${error.toString()}');
      }
      emit(UpdateProfileErrorState());
    });
  }


//   void update({
//     name = 'Ehab ahmed ali',
//     phone = '0987654321',
//     bio = 'new bio',
//     email = 'ehab22ahmed@gmail.com',
//     profileImage ='https://img.freepik.com/free-photo/no-problem-concept-bearded-man-makes-okay-gesture-has-everything-control-all-fine-gesture-wears-spectacles-jumper-poses-against-pink-wall-says-i-got-this-guarantees-something_273609-42817.jpg?size=626&ext=jpg',
//     coverImage = 'https://img.freepik.com/free-photo/no-problem-concept-bearded-man-makes-okay-gesture-has-everything-control-all-fine-gesture-wears-spectacles-jumper-poses-against-pink-wall-says-i-got-this-guarantees-something_273609-42817.jpg?size=626&ext=jpg',
//     uId = '4GOy3UXtNdbPXhcCUmKGy2TRzV43',
// })
//   {
//     UserModel model = UserModel(
//       name: name,
//       phone: phone,
//       bio: bio,
//       email: email,
//       profileImage: profileImage,
//       coverImage: coverImage,
//       uId: uId,
//     );
//
//     FirebaseFirestore.instance
//         .collection('users')
//         .doc(SocialAppVariable.userId)
//         .update(model.toMap()).then((value) {
//       print('================================= Updated');
//       emit(UpdateProfileSuccessState());
//     }).catchError((error){
//       emit(UpdateProfileErrorState());
//
//     });
//   }
//
}
