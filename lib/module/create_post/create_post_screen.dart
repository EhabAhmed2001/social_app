import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app/constant/app_widget.dart';
import 'package:social_app/constant/toast.dart';
import 'package:social_app/cubit_state/post/post_cubit.dart';
import 'package:social_app/cubit_state/post/post_state.dart';
import 'package:social_app/cubit_state/social/social_cubit.dart';
import 'package:social_app/general/iconly_broken.dart';
import 'package:social_app/model/user_model.dart';

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel? model = SocialCubit.get(context).model;
    TextEditingController postController = TextEditingController();
    return BlocProvider(
      create: (context) => PostCubit(),
      child: BlocConsumer<PostCubit, PostState>(
        listener: (context, state) {
          if (state is CreatePostSuccessState) {
            toastShown(text: 'POSTED', state: ToastColor.success);
          }
          if (state is CreatePostErrorState) {
            toastShown(text: 'error', state: ToastColor.error);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: SocialAppConstWidget.defaultAppBar(
              context: context,
              title: 'Create post',
              actions: [
                TextButton(
                  onPressed: () {
                    PostCubit.get(context).createPost(
                      context: context,
                      text: postController.text,
                    ).then((value) => Navigator.pop(context));
                  },
                  child: const Text('POST'),
                ),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.all(20.0.sp),
              child: Column(
                children: [
                  if (state is CreatePostLoadingState ||
                      state is UploadPostImageLoadingState)
                    Column(
                      children: [
                        const LinearProgressIndicator(),
                        SizedBox(
                          height: 8.h,
                        )
                      ],
                    ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25.0.r,
                        backgroundImage: NetworkImage(
                          model!.profileImage,
                        ),
                      ),
                      SizedBox(
                        width: 8.0.w,
                      ),
                      Text(
                        model.name,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Expanded(
                    child: TextFormField(
                      maxLines: null,
                      controller: postController,
                      decoration: const InputDecoration(
                        hintText: 'What\'s on your mind? ..... ',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  if (PostCubit.get(context).postImage != null)
                    Column(
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Container(
                              height: 150.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadiusDirectional.circular(ScreenUtil().radius(10)),
                                image: DecorationImage(
                                  image: FileImage(PostCubit.get(context).postImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                PostCubit.get(context).deletePostImage();
                              },
                              icon: CircleAvatar(
                                radius: ScreenUtil().radius(14),
                                child: Icon(
                                  Icons.close,
                                  size: 16.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                      ],
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            PostCubit.get(context).getPostImage();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(IconBroken.image_2),
                              SizedBox(
                                width: 8.w,
                              ),
                              const Text('Add photo'),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {},
                          child: const Text('# TAGS'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
