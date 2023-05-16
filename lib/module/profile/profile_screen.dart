import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app/constant/app_variable.dart';
import 'package:social_app/cubit_state/users_profile/users_profile_cubit.dart';
import 'package:social_app/cubit_state/users_profile/users_profile_state.dart';
import 'package:social_app/model/profile_model.dart';
import 'package:social_app/module/chat_details/chat_details_screen.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key, required this.uId}) : super(key: key);
  String uId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UsersProfileCubit()..getUserProfile(uId: uId),
      child: BlocConsumer<UsersProfileCubit, UsersProfileState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: ConditionalBuilder(
                condition: state is GetUsersProfileLoadingState,
                builder: (context)=> const Center(child: CircularProgressIndicator(),),
                fallback: (context) {
                  UsersProfileModel model = UsersProfileCubit.get(context).userModel;
                  return Padding(
                  padding: const EdgeInsets.all(8.0).w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 180.h,
                        child: Stack(
                          alignment: AlignmentDirectional.bottomStart,
                          children: [
                            Align(
                              alignment: AlignmentDirectional.topCenter,
                              child: Container(
                                height: 150.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadiusDirectional.only(
                                    topEnd:
                                    Radius.circular(ScreenUtil().radius(10)),
                                    topStart:
                                    Radius.circular(ScreenUtil().radius(10)),
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      model.coverImage,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.only(start: 12.w),
                              child: CircleAvatar(
                                radius: ScreenUtil().radius(62),
                                backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                                child: CircleAvatar(
                                  radius: ScreenUtil().radius(60),
                                  backgroundImage: NetworkImage(
                                    model.profileImage,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.only(start: 14.0.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              model.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.copyWith(fontSize: 26.sp),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              model.bio,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(fontSize: 18.sp),
                            ),
                          ],
                        ),
                      ),
                      if (model.uId != SocialAppVariable.userId)
                        Expanded(
                          child: Center(
                            child: Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ChatDetailsScreen(model: model),
                                        ),
                                      );
                                    },
                                    child: const Text('MESSAGE'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                );
                },
            ),
          );
        },
      ),
    );
  }
}

/*
return ConditionalBuilder(
            condition: state is GetUsersProfileLoadingState,
            builder: (context)=> const Center(child: CircularProgressIndicator(),),
            fallback: (context) {
              UsersProfileModel model = UsersProfileCubit.get(context).userModel;
              return Scaffold(
                appBar: AppBar(),
                body: Padding(
                  padding: const EdgeInsets.all(8.0).w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 180.h,
                        child: Stack(
                          alignment: AlignmentDirectional.bottomStart,
                          children: [
                            Align(
                              alignment: AlignmentDirectional.topCenter,
                              child: Container(
                                height: 150.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadiusDirectional.only(
                                    topEnd:
                                    Radius.circular(ScreenUtil().radius(10)),
                                    topStart:
                                    Radius.circular(ScreenUtil().radius(10)),
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      model.coverImage,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.only(start: 12.w),
                              child: CircleAvatar(
                                radius: ScreenUtil().radius(62),
                                backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                                child: CircleAvatar(
                                  radius: ScreenUtil().radius(60),
                                  backgroundImage: NetworkImage(
                                    model.profileImage,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.only(start: 14.0.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              model.name,
                              style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 26.sp),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              model.bio,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 18.sp),
                            ),
                          ],
                        ),
                      ),
                      if(model.uId != SocialAppVariable.userId)
                        Expanded(
                          child: Center(
                            child: Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context)=>ChatDetailsScreen(model: model),
                                        ),
                                      );
                                    },
                                    child: const Text('MESSAGE'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
 */
