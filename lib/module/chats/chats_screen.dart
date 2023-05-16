import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app/constant/app_widget.dart';
import 'package:social_app/cubit_state/chat/chat_cubit.dart';
import 'package:social_app/cubit_state/chat/chat_state.dart';
import 'package:social_app/general/refreash_widget.dart';
import 'package:social_app/model/user_model.dart';
import 'package:social_app/module/chat_details/chat_details_screen.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final keyRefresh = GlobalKey<RefreshIndicatorState>();
    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) {},
      builder: (context, state) {
        ChatCubit chatCubit = ChatCubit.get(context);
        return ConditionalBuilder(
          condition: state is GetAllUsersChatLoadingState,
          fallback: (context) => RefreshWidget(
            keyRefresh: keyRefresh,
            onRefresh:() {
              return ChatCubit.get(context).refreshChats(keyRefresh);
            },
            child: ListView.separated(
              separatorBuilder: (context, index) => Padding(
                padding: EdgeInsetsDirectional.only(start: 20.w),
                child: SocialAppConstWidget.defaultDivider(),
              ),
              itemBuilder: (context, index) => chatItemBuilder(
                context: context,
                user: chatCubit.allUsers[index],
              ),
              itemCount: chatCubit.allUsers.length,
            ),
          ),
          builder: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget chatItemBuilder({
    required BuildContext context,
    required UserModel user,
  }) =>
      InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context)=>ChatDetailsScreen(model: user),
              ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(20.sp),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25.0.r,
                backgroundImage: NetworkImage(
                  user.profileImage,
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Text(
                user.name,
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ],
          ),
        ),
      );
}
