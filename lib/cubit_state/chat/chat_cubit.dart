import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/constant/app_variable.dart';
import 'package:social_app/cubit_state/chat/chat_state.dart';
import 'package:social_app/general/date_time.dart';
import 'package:social_app/model/chat_model.dart';
import 'package:social_app/model/user_model.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  static ChatCubit get(context) => BlocProvider.of(context);

  List<UserModel> allUsers = [];

  Future<void> getAllUsers() async {
    allUsers = [];
    emit(GetAllUsersChatLoadingState());
    try {
      await FirebaseFirestore.instance.collection('users').get().then((value) {
        for (var element in value.docs) {
          if (element.data()['uId'] != SocialAppVariable.userId) {
            allUsers.add(UserModel.fromMap(element.data()));
          }
        }
        emit(GetAllUsersChatSuccessState());
      });
    } catch (error) {
      if (kDebugMode) {
        print('Error in get users in chat screen ${error.toString()}');
      }
      emit(GetAllUsersChatErrorState());
    }
  }

  Future refreshChats(keyRefresh) async {
    keyRefresh.currentState?.show();
    allUsers = [];
    await getAllUsers();
    emit(RefreshChatPageState());
  }

  Future sendMessage({
    required String receiver,
    required String message,
  }) async {
    ChatModel model = ChatModel(
      message: message,
      sender: SocialAppVariable.userId!,
      receiver: receiver,
      date: DateAndTime.dateWithSec(),
    );

    emit(SendMessageLoadingState());
    try {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(SocialAppVariable.userId!)
          .collection(receiver)
          .add(model.toMap());
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(receiver)
          .collection(SocialAppVariable.userId!)
          .add(model.toMap());
      emit(SendMessageSuccessState());
    } catch (error) {
      if (kDebugMode) {
        print('error in send message =================> ${error.toString()}');
      }
      emit(SendMessageErrorState());
    }
  }

  List<ChatModel> message = [];

  void getMessage({required String receiver}) {
    emit(GetMessageLoadingState());
    try {
      FirebaseFirestore.instance
          .collection('chats')
          .doc(SocialAppVariable.userId!)
          .collection(receiver)
          .orderBy('date')
          .snapshots()
          .listen((event) {
          message = [];
        for (var element in event.docs) {
          message.add(ChatModel.fromMap(element.data()));
        }
        emit(GetMessageSuccessState());
      });
    } catch (error) {
      if (kDebugMode) {
        print('error in get message chat ====> ${error.toString()}');
      }
      emit(GetMessageErrorState());
    }
  }
}
