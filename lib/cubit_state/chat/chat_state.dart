abstract class ChatState {}

class ChatInitial extends ChatState {}

class RefreshChatPageState extends ChatState {}

class GetAllUsersChatLoadingState extends ChatState {}

class GetAllUsersChatSuccessState extends ChatState {}

class GetAllUsersChatErrorState extends ChatState {}

class SendMessageLoadingState extends ChatState {}

class SendMessageSuccessState extends ChatState {}

class SendMessageErrorState extends ChatState {}

class GetMessageLoadingState extends ChatState {}

class GetMessageSuccessState extends ChatState {}

class GetMessageErrorState extends ChatState {}