import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app/constant/app_variable.dart';
import 'package:social_app/constant/app_widget.dart';
import 'package:social_app/constant/toast.dart';
import 'package:social_app/cubit_state/chat/chat_cubit.dart';
import 'package:social_app/cubit_state/home/home_cubit.dart';
import 'package:social_app/cubit_state/register/register_cubit.dart';
import 'package:social_app/cubit_state/register/register_state.dart';
import 'package:social_app/cubit_state/social/social_cubit.dart';
import 'package:social_app/module/layout/layout_screen.dart';
import 'package:social_app/remote/hive/hive.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();

}

class _RegisterScreenState extends State<RegisterScreen> {

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool isPass = true;
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: REdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: BlocProvider(
                create: (context) => RegisterCubit(),
                child: BlocConsumer<RegisterCubit, RegisterState>(
                    listener: (context, state) {
                  if (state is RegisterSuccessState) {
                    toastShown(
                      text: 'REGISTER SUCCESSFULLY',
                      state: ToastColor.success,
                    );

                    HiveHelper.putHiveData(
                      key: 'uId',
                      value: state.uId,
                    ).then((value){
                      SocialAppVariable.userId = HiveHelper.getHiveData(key: 'uId');
                      SocialCubit.get(context).getUserData();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const LayoutScreen()),
                            (route) => false,
                      );
                    }).catchError((error){
                      if (kDebugMode) {
                        print('error in login screen in listener when put hive ${error.toString()}');
                      }
                    });
                    SocialAppVariable.userId = state.uId;
                    HomeCubit.get(context).getPosts();
                    ChatCubit.get(context).getAllUsers();

                  }

                  if (state is RegisterErrorState) {
                    toastShown(
                      text: state.error,
                      state: ToastColor.error,
                    );
                  }
                }, builder: (context, state)
                {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "REGISTER",
                        style: TextStyle(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      SocialAppConstWidget.defaultFormField(
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        validation: (String value) {
                          if (value.isEmpty) {
                            return "Name must not be empty".toUpperCase();
                          }
                          return null;
                        },
                        label: 'Name',
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                      SizedBox(
                        height: 14.h,
                      ),
                      SocialAppConstWidget.defaultFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validation: (String value) {
                          if (value.isEmpty) {
                            return "Email must not be empty".toUpperCase();
                          }
                          return null;
                        },
                        label: 'Email',
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                      SizedBox(
                        height: 14.h,
                      ),
                      SocialAppConstWidget.defaultFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        validation: (String value) {
                          if (value.isEmpty) {
                            return "Password must not be empty".toUpperCase();
                          }
                          return null;
                        },
                        label: 'Password',
                        prefixIcon: const Icon(Icons.lock_open_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPass
                                ? Icons.remove_red_eye
                                : Icons.visibility_off,
                            // ChangeVisibilityPasswordCubit.password ? Icons.visibility_off : Icons.visibility
                          ),
                          onPressed: () {
                            // cu.visibilityChanged();
                            setState(() {
                              isPass = !isPass;
                            });
                          },
                        ),
                        isPass: isPass,
                      ),
                      SizedBox(
                        height: 14.h,
                      ),
                      SocialAppConstWidget.defaultFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        validation: (String value) {
                          if (value.isEmpty) {
                            return "Phone must not be empty".toUpperCase();
                          }
                          return null;
                        },
                        label: 'Phone',
                        prefixIcon: const Icon(Icons.phone),
                      ),
                      SizedBox(
                        height: 14.h,
                      ),
                      ConditionalBuilder(
                        condition: state is RegisterLoadingState,
                        builder: (BuildContext context) =>
                            const Center(child: CircularProgressIndicator()),
                        fallback: (context) =>
                            SocialAppConstWidget.defaultButton(
                          pressedFunction: () {
                            RegisterCubit.get(context).userRegister(
                              email: emailController.text,
                              password: passwordController.text,
                              name: nameController.text,
                              phone: phoneController.text,
                            );
                          },
                          text: 'Register',
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
