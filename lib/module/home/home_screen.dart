import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app/constant/toast.dart';
import 'package:social_app/cubit_state/home/home_cubit.dart';
import 'package:social_app/cubit_state/home/home_state.dart';
import 'package:social_app/cubit_state/social/social_cubit.dart';
import 'package:social_app/general/iconly_broken.dart';
import 'package:social_app/general/refreash_widget.dart';
import 'package:social_app/module/create_post/create_post_screen.dart';
import 'package:social_app/module/home/post_design.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final keyRefresh = GlobalKey<RefreshIndicatorState>();
    return SafeArea(
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is DeletePostSuccessState) {
            toastShown(text: 'Deleted', state: ToastColor.success);
          }
          if (state is AddCommentSuccessState) {
            toastShown(text: 'Commented', state: ToastColor.success);
          }

        },
        builder: (context, state) {
          return Scaffold(
            body: ConditionalBuilder(
              condition: SocialCubit.get(context).model == null ||
                  HomeCubit.get(context).posts.isEmpty,
              builder: (context) {
                return const Center(
                child: CircularProgressIndicator(),
              );
              },
              fallback: (context) => RefreshWidget(
                keyRefresh: keyRefresh,
                onRefresh:() {
                  return HomeCubit.get(context).refreshPosts(keyRefresh);
                },
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => BuildHomeScreen.buildPostItem(
                            context,
                            HomeCubit.get(context).posts[index],
                            index,
                          ),
                          itemCount: HomeCubit.get(context).posts.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: Visibility(
              visible: HomeCubit.get(context).fabShown,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreatePostScreen()),
                  );
                },
                child: Icon(
                  IconBroken.edit,
                  size: 25.sp,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// SizedBox(
//   width: double.infinity,
//   child: Wrap(
//     children: [
//       Container(
//         height: hashTagHeight,
//         margin: EdgeInsetsDirectional.only(
//           end: hashTagWidth,
//         ),
//         child: MaterialButton(
//           onPressed: () {},
//           minWidth: 1.0,
//           padding: EdgeInsetsDirectional.zero,
//           child: Text(
//             '#software',
//             style: Theme.of(context).textTheme.displayMedium,
//           ),
//         ),
//       ),
//       Container(
//         height: hashTagHeight,
//         margin: EdgeInsetsDirectional.only(
//           end: hashTagWidth,
//         ),
//         child: MaterialButton(
//           onPressed: () {},
//           minWidth: 1.0,
//           padding: EdgeInsetsDirectional.zero,
//           child: Text(
//             '#software',
//             style: Theme.of(context).textTheme.displayMedium,
//           ),
//         ),
//       ),
//       Container(
//         height: hashTagHeight,
//         margin: EdgeInsetsDirectional.only(
//           end: hashTagWidth,
//         ),
//         child: MaterialButton(
//           onPressed: () {},
//           minWidth: 1.0,
//           padding: EdgeInsetsDirectional.zero,
//           child: Text(
//             '#software_developer',
//             style: Theme.of(context).textTheme.displayMedium,
//           ),
//         ),
//       ),
//       Container(
//         height: hashTagHeight,
//         margin: EdgeInsetsDirectional.only(
//           end: hashTagWidth,
//         ),
//         child: MaterialButton(
//           onPressed: () {},
//           minWidth: 1.0,
//           padding: EdgeInsetsDirectional.zero,
//           child: Text(
//             '#flutter',
//             style: Theme.of(context).textTheme.displayMedium,
//           ),
//         ),
//       ),
//       Container(
//         height: hashTagHeight,
//         margin: EdgeInsetsDirectional.only(
//           end: hashTagWidth,
//         ),
//         child: MaterialButton(
//           onPressed: () {},
//           minWidth: 1.0,
//           padding: EdgeInsetsDirectional.zero,
//           child: Text(
//             '#software_developer',
//             style: Theme.of(context).textTheme.displayMedium,
//           ),
//         ),
//       ),
//     ],
//   ),
// ),


// Card(
//                 margin: EdgeInsetsDirectional.all(8.0.sp),
//                 clipBehavior: Clip.antiAliasWithSaveLayer,
//                 elevation: 8.sp,
//                 child: Stack(
//                   alignment: Alignment.bottomCenter,
//                   children: [
//                     Image.network(
//                       'https://img.freepik.com/free-photo/young-man-learning-virtual-classroom_23-2149200179.jpg?t=st=1675103031~exp=1675103631~hmac=d8ee9f33f57720ba843d3f2c74e07e86eea60d96ac8b699dd978291639f2c5d0',
//                       fit: BoxFit.cover,
//                       height: 200.0.h,
//                       width: double.infinity,
//                     ),
//                     Padding(
//                       padding: EdgeInsetsDirectional.only(
//                           bottom: 8.h
//                       ),
//                       child: Text(
//                         'Communicate with your friends',
//                         style: TextStyle(
//                           fontSize: 20.sp,
//                           color: SocialAppColor.defaultColor,
//                           backgroundColor: Colors.white.withOpacity(0.5),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
