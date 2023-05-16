import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app/constant/app_color.dart';
import 'package:social_app/constant/app_widget.dart';
import 'package:social_app/cubit_state/home/home_cubit.dart';
import 'package:social_app/cubit_state/home/home_state.dart';
import 'package:social_app/cubit_state/layout/layout_cubit.dart';
import 'package:social_app/cubit_state/show_popup/show_popup_cubit.dart';
import 'package:social_app/cubit_state/show_popup/show_popup_state.dart';
import 'package:social_app/cubit_state/social/social_cubit.dart';
import 'package:social_app/general/iconly_broken.dart';
import 'package:social_app/model/comment_model.dart';
import 'package:social_app/model/post_model.dart';
import 'package:social_app/module/profile/profile_screen.dart';

abstract class BuildHomeScreen {

  static Widget buildPostItem(
    BuildContext context,
    PostModel model,
    int postIndex,
  ) {

    bool like = model.isLiked;
    return Card(
      margin: EdgeInsetsDirectional.all(8.0.sp),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 8.sp,
      child: Padding(
        padding: EdgeInsets.all(8.0.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InkWell(
                  child: CircleAvatar(
                    radius: 25.0.r,
                    backgroundImage: NetworkImage(
                      model.profileImage,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(uId: model.uId,),
                      ),
                    );
                  },
                ),
                SizedBox(
                  width: 8.0.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.name,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      Text(
                        model.dateTime,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.more_horiz_outlined,
                    size: 16.sp,
                  ),
                  onPressed: () {
                    HomeCubit.get(context).changeBottomSheet();
                    HomeCubit.get(context).changeFAB();
                    if (HomeCubit.get(context).sheetShown) {
                      Navigator.pop(context);
                    } else {
                      Scaffold.of(context)
                          .showBottomSheet(
                            (context) => Container(
                              height: MediaQuery.of(context).size.height / 10,
                              color: SocialAppColor.defaultColor,
                              width: double.infinity,
                              child: TextButton(
                                onPressed: () {
                                  HomeCubit.get(context)
                                      .deletePost(model.postId, context);
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Delete post',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .closed
                          .then((value) {
                        if (!HomeCubit.get(context).sheetShown) {
                          HomeCubit.get(context).changeBottomSheet();
                          HomeCubit.get(context).changeFAB();
                        }
                      });
                    }
                  },
                ),
              ],
            ),
            SocialAppConstWidget.defaultDivider(),
            Text(
              model.text,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (model.postImage != '')
              Container(
                margin: EdgeInsetsDirectional.only(
                  top: 8.h,
                ),
                width: double.infinity,
                height: 160.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8).w,
                  image: DecorationImage(
                    image: NetworkImage(
                      model.postImage,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0.sp),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsetsDirectional.symmetric(vertical: 5.h),
                      child: Row(
                        children: [
                          Icon(
                            IconBroken.heart,
                            color: Colors.red[500],
                            size: 18.sp,
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          Text(
                            '${model.likesNum}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsetsDirectional.symmetric(vertical: 5.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            IconBroken.chat,
                            color: Colors.deepOrange,
                            size: 18.sp,
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          Text(
                            '${model.commentsNum}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SocialAppConstWidget.defaultDivider(),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18.0.r,
                          backgroundImage: NetworkImage(
                            SocialCubit.get(context).model!.profileImage,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.only(
                            top: 5.h,
                            bottom: 5.h,
                            start: 5.h,
                          ),
                          child: Text(
                            'Add a comment ....',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                    onTap: () async {
                      buildCommentItem(
                        context: context,
                        postModel: model,
                        like: like,
                        postIndex: postIndex,
                      );
                      await HomeCubit.get(context)
                          .getComments(postId: model.postId);
                    },
                  ),
                ),
                InkWell(
                  child: Padding(
                    padding: EdgeInsetsDirectional.all(5.sp),
                    child: Row(
                      children: [
                        Icon(
                          like ? Icons.favorite : IconBroken.heart,
                          color: Colors.red[900],
                          size: 20.sp,
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        Text(
                          like ? 'Liked' : 'Like',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    if (like) {
                      HomeCubit.get(context).deleteLike(model.postId, postIndex);
                    } else {
                      HomeCubit.get(context).likePost(model.postId, postIndex);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

// ================================================================

  static void buildCommentItem({
    required BuildContext context,
    required PostModel postModel,
    required bool like,
    required int postIndex,
  }) {

    var homeCubit = HomeCubit.get(context);
    TextEditingController commentController = TextEditingController();
    final scrollController = ScrollController();
    final focusNode = FocusNode();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {},
          builder: (context, state) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Container(
                height: MediaQuery.of(context).size.height - 28.h,
                padding: EdgeInsetsDirectional.only(
                  end: 10.w,
                  start: 10.w,
                  top: 10.w,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.red,
                                radius: ScreenUtil().radius(10),
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.white,
                                  size: 12.sp,
                                ),
                              ),
                              SizedBox(
                                width: 6.w,
                              ),
                              Text('${postModel.likesNum}'),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            like ? Icons.favorite : IconBroken.heart,
                            color: Colors.red[900],
                          ),
                          onPressed: () {
                            if (like) {
                              homeCubit.deleteLike(postModel.postId, postIndex);
                            } else {
                              homeCubit.likePost(postModel.postId, postIndex);
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    if (state is GetCommentsLoadingState)
                      const Expanded(
                          child: Center(child: CircularProgressIndicator()))
                    else
                      homeCubit.comments.isNotEmpty
                          ? Expanded(
                              child: ListView.separated(
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  CommentModel comment = homeCubit.comments[index];
                                  return Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            radius: ScreenUtil().radius(20),
                                            backgroundImage: NetworkImage(
                                              comment.profileUrl,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          Expanded(
                                            child: BlocBuilder<ShowPopupCubit,ShowPopupState>(
                                              builder: (context, state) =>
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      GestureDetector(
                                                        child: Container(
                                                          padding: EdgeInsetsDirectional.all(10.sp),
                                                          decoration: BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius.circular(ScreenUtil().radius(18)),
                                                            color: Colors.grey[200],
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                comment.name,
                                                                style: Theme.of(context)
                                                                    .textTheme
                                                                    .displayLarge
                                                                    ?.copyWith(
                                                                    fontSize: 16.sp),
                                                              ),
                                                              SizedBox(
                                                                height: 4.h,
                                                              ),
                                                              Text(
                                                                comment.comment,
                                                                style: Theme.of(context)
                                                                    .textTheme
                                                                    .bodySmall
                                                                    ?.copyWith(

                                                                    color:

                                                                    Colors.black),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        onLongPressStart: (details) {
                                                          ShowPopupCubit.get(context).commentLongPress(
                                                              context: context,
                                                              details: details,
                                                              postId: postModel.postId,
                                                              commentIndex: index,
                                                              postIndex: postIndex,
                                                              commentId: comment.commentId,
                                                          );
                                                          },
                                                      ),
                                                      Text(
                                                        comment.date,
                                                        style: Theme.of(context).textTheme.bodySmall,
                                                      ),
                                                    ],
                                                  ),
                                            ),
                                          ),
                                        ],
                                      );

                                },
                                itemCount: homeCubit.comments.length,
                                separatorBuilder: (BuildContext context, int index) => SizedBox(height: 8.h,),
                              ),
                      )
                          : Expanded(
                              child: Center(
                                child: Text(
                                    'No comments yet',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge!),
                              ),
                      ),
                    Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom,),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsetsDirectional.symmetric(
                                vertical: 6.h,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1.w,
                                    ),
                                    borderRadius: BorderRadius.circular(ScreenUtil().radius(18))
                                ),
                                padding: EdgeInsetsDirectional.symmetric(
                                  horizontal: 10.w,
                                ),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Write a comment ...',
                                  ),
                                  keyboardType: null,
                                  focusNode: focusNode,
                                  maxLines : null,
                                  onChanged: (value){
                                    homeCubit.changeSendIcon(value);
                                  },
                                  controller: commentController,
                                ),
                              ),
                            ),
                          ),
                          homeCubit.text.isEmpty
                              ? CircleAvatar(
                                minRadius: 1.sp,
                                backgroundColor: Colors.transparent,
                                child: MaterialButton(
                                  height: 40.h,
                                  shape: const CircleBorder(),
                                  minWidth: 1.0,
                                  onPressed: () {},
                                  child: const Icon(
                                    Icons.send,
                                  ),
                                ),
                          )
                              : CircleAvatar(
                                  minRadius: 1.sp,
                                  backgroundColor: Colors.transparent,
                                  child: MaterialButton(
                                    height: 40.h,
                                    shape: const CircleBorder(),
                                    minWidth: 1.0,
                                    onPressed: () async {
                                      await homeCubit.createComment(
                                        postId: postModel.postId,
                                        postIndex: postIndex,
                                        comment: commentController.text,
                                      );
                                      commentController.clear();
                                      homeCubit.text = '';
                                    },
                                    child: const Icon(
                                      Icons.send,
                                      color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((value) {
      commentController.clear();
      homeCubit.text = '';
    });
  }
}




// com ()=>  CircleAvatar(
//   minRadius: 1.sp,
//   backgroundColor: SocialAppColor.defaultColor,
//   child: MaterialButton(
//     height: 40.h,
//     shape: const CircleBorder(),
//     minWidth: 1.0,
//     onPressed: (){},
//     child: Icon(
//       Icons.send,
//       size: 18.sp,
//       color: Colors.white,
//     ),
//   ),
// );
//
//
// com2 () {
//   return Row(
//     children: [
//       homeCubit.comment.isEmpty
//           ? CircleAvatar(
//             minRadius: 1.sp,
//            child: MaterialButton(
//              height: 40.h,
//              shape: const CircleBorder(),
//              minWidth: 1.0,
//              onPressed: () {},
//              child: Icon(
//                Icons.send,
//                size: 18.sp,
//              ),
//            ),
//           )
//           : CircleAvatar(
//                   minRadius: 1.sp,
//                   backgroundColor: Colors.white,
//               child: MaterialButton(
//                   height: 40.h,
//                   shape: const CircleBorder(),
//                   minWidth: 1.0,
//                   onPressed: () async {
//                   await homeCubit.createComment(
//                     postId: postModel.postId,
//                     postIndex: postIndex,
//                     comment: commentController.text,
//                   );
//                   commentController.text = '';
//                   homeCubit.comment = '';
//                 },
//                 icon: const Icon(
//                   Icons.send,
//                   color: Colors.green,
//                 ),
//       ),
//           ),
//     ],
//   ),
// }
//
