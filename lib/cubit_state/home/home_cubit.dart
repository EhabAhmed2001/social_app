import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/constant/app_variable.dart';
import 'package:social_app/cubit_state/home/home_state.dart';
import 'package:social_app/general/date_time.dart';
import 'package:social_app/model/comment_model.dart';
import 'package:social_app/model/post_model.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  static HomeCubit get(context) => BlocProvider.of(context);

  bool sheetShown = true;

  bool fabShown = true;

  List<PostModel> posts = [];

  List<CommentModel> comments = [] ;



  Future refreshPosts(keyRefresh) async {
    keyRefresh.currentState?.show();
    posts =[];
    await getPosts();
    emit(RefreshPostPageState());
  }


  Future<void> getPosts() async {
    emit(GetPostsLoadingState());
    try {
      posts =[];
      await FirebaseFirestore.instance.collection('posts').orderBy('dateTime',descending: true).get()
          .then((value) async {
          for (var element in value.docs) {
            var checkLike = element.reference.collection('likes');
            QuerySnapshot<Map<String, dynamic>> numOfLikes = await checkLike.get();

            var checkComment = element.reference.collection('comments');
            QuerySnapshot<Map<String, dynamic>> numOfComments = await checkComment.get();

            DocumentSnapshot<Map<String, dynamic>> exist = await checkLike.doc(SocialAppVariable.userId).get();

            posts.add(
                PostModel.fromMap(
                map : element.data(),
                postId: element.id,
                likesNum: numOfLikes.docs.length,
                isLiked: exist.exists,
                commentsNum: numOfComments.docs.length,
            ));

          }
          emit(GetPostsSuccessState());
        },
      );
    } catch (error) {
      if (kDebugMode) {
        print('error in get posts ======> ${error.toString()}');
        emit(GetPostsErrorState());
      }
    }
  }

  Future<void> likePost(String postId, int postIndex) async {
    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .doc(SocialAppVariable.userId)
          .set({
        'like': true,
      }).then((value) {
        posts[postIndex].isLiked = true;
        posts[postIndex].likesNum ++;
        emit(LikePostsSuccessState());
      });
    } catch (error) {
      emit(LikePostsErrorState());
    }
  }

  Future<void> deleteLike(String postId , int postIndex) async {
    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .doc(SocialAppVariable.userId)
          .delete()
          .then((value) {
        posts[postIndex].isLiked = false;
        posts[postIndex].likesNum --;
        emit(DeleteLikePostsSuccessState());
      });
    } catch (error) {
      emit(DeleteLikePostsErrorState());
    }
  }

  Future<void> deletePost(String postId,BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .delete()
          .then((value) async {
        emit(DeletePostSuccessState());
      });
    } catch (error) {
      emit(DeletePostErrorState());
    }
  }

  void changeBottomSheet() {
    sheetShown = !sheetShown;
    emit(ChangeBottomSheetState());
  }

  void changeFAB() {
    fabShown = !fabShown;
    emit(ChangeFABState());
  }

  Future<void> createComment({
    required String postId,
    required int postIndex,
    required String comment,
  }) async {
    try {
      // DateTime time = DateTime.now();
      // String fullDate;
      // if(time.second <= 9) {
      //   fullDate = "${time.year}/${time.month}/${time.day}  ${time.hour}:${time.minute}:0${time.second}";
      // }
      // else{
      //   fullDate = "${time.year}/${time.month}/${time.day}  ${time.hour}:${time.minute}:${time.second}";
      // }

      String fullDate = DateAndTime.dateWithSec();

      CommentModel commentModel = CommentModel(
        comment: comment,
        uId: SocialAppVariable.userId!,
        date: fullDate,
      );
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .add(commentModel.toMap())
          .then((value) async {
        posts[postIndex].commentsNum++;
        emit(AddCommentSuccessState());
        await getComments(postId: postId);
      });
    } catch (error) {
      emit(AddCommentErrorState());
    }
  }

  Future<void> deleteComment({
    required String postId,
    required int postIndex,
    required String commentId,
    required int commentIndex
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .delete()
          .then((value) {
        posts[postIndex].commentsNum --;
        comments.removeAt(commentIndex);
        emit(DeleteCommentSuccessState());
      });
    } catch (error) {
      if (kDebugMode) {
        print('error in delete comment ====> ${error.toString()}');
      }
      emit(DeleteCommentErrorState());
    }
  }


  Future<void> getComments({required String postId}) async {
    comments = [];
    emit(GetCommentsLoadingState());
    try {
      await FirebaseFirestore.instance.collection('posts').doc(postId).collection('comments').orderBy('date').get()
          .then((value) async {
        for (var element in value.docs) {
          int numOfComments = value.size;
          String uId = element.data()['uId'];
          var userInfo = await FirebaseFirestore.instance.collection('users').doc(uId).get();
          String name = userInfo.data()!['name'];
          String profileUrl = userInfo.data()!['profileImage'];

          comments.add(CommentModel.fromMap(
            map : element.data(),
            commentId: element.id, // comment id
            numOfComments: numOfComments,
            name: name,
            profileUrl: profileUrl,
          ),
          );
        }
        emit(GetCommentsSuccessState());
      },
      );
    } catch (error) {
      if (kDebugMode) {
        print('error in get comments ======> ${error.toString()}');
        emit(GetCommentsErrorState());
      }
    }
  }


  String text ='';
  void changeSendIcon(String value)
  {
    text = value;
    emit(SendIconChangedState());
  }


  // TextEditingController controllerEmpty(TextEditingController controller)
  // {
  //
  // }


}
