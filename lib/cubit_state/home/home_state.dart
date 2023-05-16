abstract class HomeState {}

class HomeInitial extends HomeState {}

class GetPostsLoadingState extends HomeState {}

class GetPostsSuccessState extends HomeState {}

class GetPostsErrorState extends HomeState {}

class GetCommentsLoadingState extends HomeState {}

class GetCommentsSuccessState extends HomeState {}

class GetCommentsErrorState extends HomeState {}

class LikePostsSuccessState extends HomeState {}

class LikePostsErrorState extends HomeState {}

class DeleteLikePostsSuccessState extends HomeState {}

class DeleteLikePostsErrorState extends HomeState {}

class AddCommentSuccessState extends HomeState {}

class AddCommentErrorState extends HomeState {}

class DeleteCommentSuccessState extends HomeState {}

class DeleteCommentErrorState extends HomeState {}

class DeletePostSuccessState extends HomeState {}

class DeletePostErrorState extends HomeState {}

class ChangeBottomSheetState extends HomeState {}

class ChangeFABState extends HomeState {}

class SendIconChangedState extends HomeState {}

class RefreshPostPageState extends HomeState {}

class ControllerEmpty extends HomeState {}