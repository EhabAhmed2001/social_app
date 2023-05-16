import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/constant/app_variable.dart';
import 'package:social_app/cubit_state/post/post_state.dart';
import 'package:social_app/cubit_state/social/social_cubit.dart';
import 'package:social_app/model/post_model.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit() : super(PostInitial());

  static PostCubit get(context) => BlocProvider.of(context);

  File? postImage;
  Future<void> getPostImage() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      if (kDebugMode) {
        print(postImage);
      }
      emit(GetPostImageSuccessState());
    } else {
      if (kDebugMode) {
        print('no image selected');
      }
      emit(GetPostImageErrorState());
    }
  }

  String? _postImageUrl;
  Future<void> _uploadPostImage() async {
    emit(UploadPostImageLoadingState());
    try {
      TaskSnapshot? putFile = await FirebaseStorage.instance
          .ref()
          .child(
              'posts/${SocialAppVariable.userId}/${Uri.file(postImage!.path).pathSegments.last}')
          .putFile(postImage!);
      _postImageUrl = await putFile.ref.getDownloadURL();

      emit(UploadPostImageSuccessState());
    } catch (e) {
      if (kDebugMode) {
        print('error in update profile image  ${e.toString()}');
      }
      emit(UploadPostImageErrorState());
    }
  }

  deletePostImage()
  {
    postImage = null;
    emit(DeletePostImageState());
  }


  Future<void> createPost({
    required BuildContext context,
    required String text,
  }) async {
    if (postImage != null) {
      await _uploadPostImage();
    }
    DateTime time = DateTime.now();
    String fullDate;
    if(time.second <= 9) {
      fullDate = "${time.year}/${time.month}/${time.day}  ${time.hour}:${time.minute}:0${time.second}";
    }
    else{
      fullDate = "${time.year}/${time.month}/${time.day}  ${time.hour}:${time.minute}:${time.second}";
    }

    PostModel model = PostModel(
      name: SocialCubit.get(context).model!.name,
      uId: SocialAppVariable.userId!,
      profileImage: SocialCubit.get(context).model!.profileImage,
      postImage: _postImageUrl ?? '',
      text: text,
      dateTime: fullDate,
      coverImage: SocialCubit.get(context).model!.coverImage,
      bio: SocialCubit.get(context).model!.bio??'no bio..',
    );

    emit(CreatePostLoadingState());

    await FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value)  {
      postImage = null;
      emit(CreatePostSuccessState());
    }).catchError((error) {
      if (kDebugMode) {
        print('error in create post ====> ${error.toString()}');
      }
      emit(CreatePostErrorState());
    });
  }
}
