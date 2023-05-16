class UserModel
{
  late String name;
  late String email;
  late String phone;
  late String profileImage;
  late String coverImage;
  late String? bio;
  late String uId;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.profileImage,
    required this.coverImage,
    required this.bio,
    required this.uId,
});

  UserModel.fromMap(Map<String,dynamic>? map)
  {
   name = map?['name'];
   email = map?['email'];
   phone = map?['phone'];
   profileImage = map?['profileImage'];
   coverImage = map?['coverImage'];
   bio = map?['bio'] ?? 'Write your bio... ';
   uId = map!['uId'];
  }

  Map<String,dynamic> toMap()
  {
    return {
      'name':name,
      'email':email,
      'profileImage':profileImage,
      'coverImage':coverImage,
      'bio':bio,
      'phone':phone,
      'uId':uId,
    };
  }

}