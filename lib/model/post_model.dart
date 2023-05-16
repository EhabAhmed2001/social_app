class PostModel
{
  late String name;
  late String uId;
  late String postId;
  late String profileImage;
  late String coverImage;
  late String postImage;
  late String text;
  late String dateTime;
  late String bio;
  int likesNum = 0 ;
  int commentsNum = 0 ;
  bool isLiked = false ;

  PostModel({
    required this.name,
    required this.uId,
    required this.profileImage,
    required this.coverImage,
    required this.postImage,
    required this.text,
    required this.dateTime,
    required this.bio,
  });

  PostModel.fromMap({
    required Map<String, dynamic>? map,
    required this.isLiked,
    required this.commentsNum,
    required this.postId,
    required this.likesNum,
  })
  {
    name = map?['name'];
    profileImage = map?['profileImage'];
    coverImage = map?['coverImage'];
    postImage = map?['postImage'];
    text = map?['text'];
    dateTime = map?['dateTime'];
    bio = map?['bio'];
    uId = map!['uId'];
  }

  Map<String,dynamic> toMap()
  {
    return {
      'name':name,
      'uId':uId,
      'profileImage':profileImage,
      'coverImage':coverImage,
      'postImage':postImage,
      'text':text,
      'dateTime':dateTime,
      'bio':bio,
    };
  }

}