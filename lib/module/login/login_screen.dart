import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app/constant/app_color.dart';
import 'package:social_app/constant/app_variable.dart';
import 'package:social_app/constant/app_widget.dart';
import 'package:social_app/constant/toast.dart';
import 'package:social_app/cubit_state/chat/chat_cubit.dart';
import 'package:social_app/cubit_state/home/home_cubit.dart';
import 'package:social_app/cubit_state/login/login_state.dart';
import 'package:social_app/cubit_state/show_password/password_state.dart';
import 'package:social_app/cubit_state/login/login_cubit.dart';
import 'package:social_app/cubit_state/social/social_cubit.dart';
import 'package:social_app/module/layout/layout_screen.dart';
import 'package:social_app/remote/hive/hive.dart';
import '../../cubit_state/show_password/password_cubit.dart';
import '../register/register_screen.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool isPass = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            toastShown(
              text: 'LOGIN SUCCESSFULLY',
              state: ToastColor.success,
            );
            HiveHelper.putHiveData(
              key: 'uId',
              value: state.uId,
            ).then((value){
              SocialAppVariable.userId = HiveHelper.getHiveData(key: 'uId');
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LayoutScreen()),
                    (route) => false,
              );
              SocialCubit.get(context).getUserData();

            }).catchError((error){
              if (kDebugMode) {
                print('error in login screen in listener when put hive ${error.toString()}');
              }
            });
            SocialAppVariable.userId = state.uId;
            HomeCubit.get(context).getPosts();
            ChatCubit.get(context).getAllUsers();
          }

          if (state is LoginErrorState) {
            toastShown(
              text: state.error,
              state: ToastColor.error,
            );
          }
        },
        builder: (context, state) {
          //  var cu = ChangeVisibilityPasswordCubit.get(context);
          return Scaffold(
            body: Center(
              child: Padding(
                padding: REdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'SOCIAL APP',
                            style: TextStyle(
                              fontSize: 30.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 100.h,
                        ),
                        Text(
                          "LOGIN",
                          style: TextStyle(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.bold,
                          ),
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
                          label: "Email",
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
                              return "password must not be empty".toUpperCase();
                            }
                            return null;
                          },
                          label: "Password",
                          prefixIcon: const Icon(Icons.lock_open_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPass ? Icons.remove_red_eye : Icons.visibility_off,
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
                        ConditionalBuilder(
                          condition: state is! LoginLoadingState,
                          fallback: (BuildContext context) {
                            return const Center(
                                child: CircularProgressIndicator()
                            );
                          },
                          builder: (BuildContext context) {
                            return SocialAppConstWidget.defaultButton(
                              pressedFunction: () {
                                if (formKey.currentState!.validate()) {
                                  LoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                }
                              },
                              text: 'LOGIN',
                            );
                          },
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Don\'t have an account ? ',
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterScreen()),
                                );
                              },
                              child: const Text(
                                'REGISTER NOW',
                                style: TextStyle(
                                  color: SocialAppColor.defaultColor,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
