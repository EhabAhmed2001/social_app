abstract class PostState {}

class PostInitial extends PostState {}

class GetPostImageSuccessState extends PostState {}

class GetPostImageErrorState extends PostState {}

class UploadPostImageLoadingState extends PostState {}

class UploadPostImageSuccessState extends PostState {}

class UploadPostImageErrorState extends PostState {}

class CreatePostLoadingState extends PostState {}

class CreatePostSuccessState extends PostState {}

class CreatePostErrorState extends PostState {}

class DeletePostImageState extends PostState {}