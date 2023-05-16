//WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//
//     });
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app/constant/app_color.dart';
import 'package:social_app/constant/app_widget.dart';
import 'package:social_app/constant/toast.dart';
import 'package:social_app/cubit_state/edit_profile/edit_profile_cubit.dart';
import 'package:social_app/cubit_state/edit_profile/edit_profile_state.dart';
import 'package:social_app/cubit_state/social/social_cubit.dart';
import 'package:social_app/cubit_state/social/social_state.dart';
import 'package:social_app/general/iconly_broken.dart';
import 'package:social_app/model/user_model.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel? model = SocialCubit.get(context).model;
    TextEditingController nameController = TextEditingController();
    TextEditingController bioController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    nameController.text = model!.name;
    bioController.text = model.bio ?? 'Write your bio...';
    phoneController.text = model.phone;

    return BlocProvider(
      create: (context) => EditProfileCubit(),
      child: BlocConsumer<EditProfileCubit, EditProfileState>(
        listener: (context, state) {
          if (state is GetCoverImageErrorState ||
              state is GetProfileImageErrorState) {
            toastShown(
              text: 'No image selected',
              state: ToastColor.error,
            );
          }

          if (state is UpdateProfileSuccessState) {
            toastShown(
              state: ToastColor.success,
              text: 'UPDATED SUCCESSFULLY',
            );
          }
        },
        builder: (context, state) {
          double widthSize = MediaQuery.of(context).size.width;
          double containerHeight = 50;
          File? coverImage = EditProfileCubit.get(context).coverImage;
          File? profileImage = EditProfileCubit.get(context).profileImage;

          return SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    if (state is UpdateProfileLoadingState ||
                        state is UpdateProfileImageLoadingState ||
                        state is UpdateCoverImageLoadingState ||
                        state is SocialLoading)
                      const LinearProgressIndicator(),
                    if (state is UpdateProfileLoadingState)
                      SizedBox(
                        height: 8.h,
                      ),
                    SizedBox(
                      height: 180.h,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Align(
                            alignment: AlignmentDirectional.topCenter,
                            child: Stack(
                              alignment: AlignmentDirectional.topEnd,
                              children: [
                                Container(
                                  height: 150.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadiusDirectional.only(
                                      topEnd: Radius.circular(
                                          ScreenUtil().radius(10)),
                                      topStart: Radius.circular(
                                          ScreenUtil().radius(10)),
                                    ),
                                    image: DecorationImage(
                                      image: coverImage == null
                                          ? NetworkImage(model.coverImage)
                                          : FileImage(coverImage)
                                              as ImageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    EditProfileCubit.get(context).getCoverImage();
                                  },
                                  icon: CircleAvatar(
                                    radius: ScreenUtil().radius(18),
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      size: 16.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: ScreenUtil().radius(52),
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: CircleAvatar(
                                  radius: ScreenUtil().radius(50),
                                  backgroundImage: profileImage == null
                                      ? NetworkImage(
                                          model.profileImage,
                                        )
                                      : FileImage(profileImage) as ImageProvider,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  EditProfileCubit.get(context).getProfileImage();
                                },
                                icon: CircleAvatar(
                                  radius: ScreenUtil().radius(14),
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    size: 12.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    SizedBox(
                      width: widthSize / 1.8,
                      child: Column(
                        children: [
                          SizedBox(
                            height: containerHeight.h,
                            child: SocialAppConstWidget.defaultFormField(
                              controller: nameController,
                              keyboardType: TextInputType.name,
                              validation: (String value) {
                                if (value.isEmpty) {
                                  return 'Name can\'t be empty';
                                }
                                return null;
                              },
                              label: 'Name',
                              prefixIcon: const Icon(IconBroken.user),
                            ),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          SizedBox(
                            height: containerHeight.h,
                            child: SocialAppConstWidget.defaultFormField(
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              validation: (String value) {
                                if (value.isEmpty) {
                                  return 'Phone can\'t be empty';
                                }
                                return null;
                              },
                              label: 'Phone',
                              prefixIcon: const Icon(
                                IconBroken.call,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          SizedBox(
                            height: containerHeight.h,
                            child: SocialAppConstWidget.defaultFormField(
                              controller: bioController,
                              keyboardType: TextInputType.name,
                              validation: () {},
                              label: 'Bio.....',
                              prefixIcon: const Icon(
                                IconBroken.info_Circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height/4.5,
                    ),
                    MaterialButton(
                      minWidth: double.infinity,
                      height: 50.h,
                      color: SocialAppColor.defaultColor.withOpacity(0.4),
                      splashColor: Colors.green,
                      highlightColor: Colors.green,
                      onPressed: () async {
                        await EditProfileCubit.get(context).updateEdit(
                          context: context,
                          name: nameController.text,
                          phone: phoneController.text,
                          bio: bioController.text,
                        );
                      },
                      child: const Text(
                        'UPDATE',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// File? coverImage;
// Future<void> getCoverImage() async {
//   XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//
//   if(pickedFile != null)
//   {
//     setState(() {
//       coverImage = File(pickedFile.path);
//     });
//     print(coverImage);
//
//   }else{
//     print('no image selected');
//   }
//
// }
//
