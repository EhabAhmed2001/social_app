import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_app/constant/app_variable.dart';
import 'package:social_app/constant/theme.dart';
import 'package:social_app/cubit_state/chat/chat_cubit.dart';
import 'package:social_app/cubit_state/home/home_cubit.dart';
import 'package:social_app/cubit_state/show_popup/show_popup_cubit.dart';
import 'package:social_app/cubit_state/social/social_cubit.dart';
import 'package:social_app/cubit_state/social/social_state.dart';
import 'package:social_app/general/firebase_options.dart';
import 'package:social_app/module/layout/layout_screen.dart';
import 'package:social_app/remote/hive/hive.dart';
import 'general/bloc_observer.dart';
import 'module/login/login_screen.dart';
import 'dart:async';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // to do line by line
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Directory dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);
  await Hive.openBox('hive');
  Bloc.observer = MyBlocObserver();

  SocialAppVariable.userId = HiveHelper.getHiveData(key: 'uId');
  late Widget screen;

  print('=================');
  print(SocialAppVariable.userId);

  if (SocialAppVariable.userId == null) {
    screen = LoginScreen();
  } else {
    screen = const LayoutScreen();
  }
  runApp(MyApp(screen: screen));
}

class MyApp extends StatelessWidget {
  final Widget screen;

  MyApp({
    super.key,
    required this.screen,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => ShowPopupCubit()),
              if(SocialAppVariable.userId != null)
                BlocProvider(create: (context) => SocialCubit()..getUserData(),),
              if(SocialAppVariable.userId != null)
                BlocProvider(create: (context) => HomeCubit()..getPosts()),
              if(SocialAppVariable.userId != null)
                BlocProvider(create: (context) => ChatCubit()..getAllUsers()),

              if(SocialAppVariable.userId == null)
                BlocProvider(create: (context) => SocialCubit()),
              if(SocialAppVariable.userId == null)
                BlocProvider(create: (context) => HomeCubit()),
              if(SocialAppVariable.userId == null)
                BlocProvider(create: (context) => ChatCubit()),
            ],
            child: BlocBuilder<SocialCubit,SocialState>(
                builder: (context, state)
                {
              return MaterialApp(
                title: "SOCIAL APP",
                debugShowCheckedModeBanner: false,
                theme: ShopTheme.lightMode,
                home: screen,
              );
            }
            ),
          );
        });
  }
}
