class CommentModel
{
  late String comment;
  late String date;
  late String uId;
  late String commentId;
  int numOfComments = 0 ;
  late String name;
  late String profileUrl;

  CommentModel({
    required this.comment,
    required this.uId,
    required this.date,
  });

  CommentModel.fromMap({
    required Map<String, dynamic>? map,
    required this.commentId,
    required this.numOfComments,
    required this.name,
    required this.profileUrl,
  })
  {
    String fullDate = map!['date'];
    String timeDate = fullDate.toString().substring(0,fullDate.length - 3);
    comment = map['comment'];
    uId = map['uId'];
    date = timeDate;
  }

  Map<String,dynamic> toMap()
  {
    return {
      'comment':comment,
      'uId':uId,
      'date':date,
    };
  }

}