class ChatModel {
  late String message;
  late String sender;
  late String receiver;
  late String date;

  ChatModel({
    required this.message,
    required this.sender,
    required this.receiver,
    required this.date,
  });

  ChatModel.fromMap(Map<String, dynamic>? map) {
    message = map?['message'];
    sender = map?['sender'];
    receiver = map?['receiver'];
    date = map?['date'];
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'sender': sender,
      'receiver': receiver,
      'date': date,
    };
  }
}
