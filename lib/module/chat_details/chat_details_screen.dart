import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app/constant/app_color.dart';
import 'package:social_app/constant/app_variable.dart';
import 'package:social_app/constant/toast.dart';
import 'package:social_app/cubit_state/chat/chat_cubit.dart';
import 'package:social_app/cubit_state/chat/chat_state.dart';
import 'package:social_app/model/chat_model.dart';
import 'package:social_app/model/user_model.dart';

class ChatDetailsScreen extends StatelessWidget {
  ChatDetailsScreen({Key? key, required this.model}) : super(key: key);
  dynamic model;

  @override
  Widget build(BuildContext context) {
    TextEditingController messageController = TextEditingController();
    return Builder(
      builder: (BuildContext context) {
        ChatCubit.get(context).getMessage(receiver: model.uId);

        return BlocConsumer<ChatCubit, ChatState>(
          listener: (BuildContext context, Object? state) {
            if (state is SendMessageSuccessState) {
              toastShown(text: 'DONE', state: ToastColor.success);
            }
          },
          builder: (BuildContext context, Object? state) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.grey[100],
                systemOverlayStyle:
                    SystemUiOverlayStyle(statusBarColor: Colors.grey[100]),
                titleSpacing: 0.0,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: ScreenUtil().radius(18),
                      backgroundImage: NetworkImage(model.profileImage),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(model.name),
                  ],
                ),
              ),
              body: ConditionalBuilder(
                condition: State is GetMessageLoadingState,
                builder: (BuildContext context) =>
                    const Center(child: CircularProgressIndicator()),
                fallback: (BuildContext context) => Padding(
                  padding: EdgeInsets.all(14.sp),
                  child: Column(
                    children: [
                      if (ChatCubit.get(context).message.isNotEmpty)
                        Expanded(
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              ChatModel model =
                                  ChatCubit.get(context).message[index];
                              if (model.sender == SocialAppVariable.userId) {
                                return messageSend(
                                    context: context, model: model);
                              }
                              return messageReceive(
                                  context: context, model: model);
                            },
                            itemCount: ChatCubit.get(context).message.length,
                            physics: const BouncingScrollPhysics(),
                          ),
                        )
                      else
                        Expanded(
                          child: Center(
                            child: Text('No Messages yet',
                                style:
                                    Theme.of(context).textTheme.displayLarge!),
                          ),
                        ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1.w,
                                  ),
                                  borderRadius: BorderRadius.circular(ScreenUtil().radius(18))),
                              padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w,),
                              child: TextFormField(

                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Type your message here ...',
                                ),
                                controller: messageController,
                                maxLines: null,
                                keyboardType: null,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          CircleAvatar(
                            minRadius: 1.sp,
                            backgroundColor: SocialAppColor.defaultColor,
                            child: MaterialButton(
                              height: 40.h,
                              shape: const CircleBorder(),
                              minWidth: 1.0,
                              onPressed: () {
                                ChatCubit.get(context).sendMessage(
                                  receiver: model.uId,
                                  message: messageController.text,
                                );
                                messageController.clear();
                              },
                              child: Icon(
                                Icons.send,
                                size: 18.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget messageSend({
    required BuildContext context,
    required ChatModel model,
  }) =>
      Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          decoration: BoxDecoration(
              color: SocialAppColor.defaultColor.withOpacity(0.3),
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(ScreenUtil().radius(10)),
                bottomEnd: Radius.circular(ScreenUtil().radius(10)),
                bottomStart: Radius.circular(ScreenUtil().radius(10)),
              )),
          margin: EdgeInsetsDirectional.only(
            bottom: 8.w,
          ),
          padding: EdgeInsetsDirectional.symmetric(
            vertical: 10.w,
            horizontal: 5.h,
          ),
          child: Text(
            model.message,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      );

  Widget messageReceive({
    required BuildContext context,
    required ChatModel model,
  }) =>
      Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadiusDirectional.only(
                topEnd: Radius.circular(ScreenUtil().radius(10)),
                bottomEnd: Radius.circular(ScreenUtil().radius(10)),
                bottomStart: Radius.circular(ScreenUtil().radius(10)),
              )),
          margin: EdgeInsetsDirectional.only(
            bottom: 8.w,
          ),
          padding: EdgeInsetsDirectional.symmetric(
            vertical: 10.w,
            horizontal: 5.h,
          ),
          child: Text(
            model.message,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      );
}
