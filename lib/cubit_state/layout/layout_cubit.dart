import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit_state/layout/layout_state.dart';
import 'package:social_app/module/chats/chats_screen.dart';
import 'package:social_app/module/edit_profile/edit_profile_screen.dart';
import 'package:social_app/module/home/home_screen.dart';

class LayoutCubit extends Cubit<LayoutState> {
  LayoutCubit() : super(LayoutInitialState());

  static LayoutCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens=[
    const HomeScreen(),
    const ChatScreen(),
    const EditProfileScreen(),
  ];

  List<String> title = [
    'Home',
    'Chat',
    'Settings',
  ];

  void indexChanged(int index)
  {
    currentIndex = index;
    emit(LayoutChangedState());
  }

}
