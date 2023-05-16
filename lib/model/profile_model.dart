class UsersProfileModel
{
  late String name;
  late String profileImage;
  late String coverImage;
  late String bio;
  late String uId;

  UsersProfileModel({
    required this.name,
    required this.profileImage,
    required this.coverImage,
    required this.bio,
    required this.uId,
  });

  UsersProfileModel.fromMap(Map<String,dynamic>? map)
  {
    name = map?['name'];
    profileImage = map?['profileImage'];
    coverImage = map?['coverImage'];
    bio = map?['bio'] ;
    uId = map!['uId'];
  }

}