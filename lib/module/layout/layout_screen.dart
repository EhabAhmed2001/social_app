import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social_app/constant/app_variable.dart';
import 'package:social_app/constant/toast.dart';
import 'package:social_app/cubit_state/edit_profile/edit_profile_cubit.dart';
import 'package:social_app/cubit_state/layout/layout_cubit.dart';
import 'package:social_app/cubit_state/layout/layout_state.dart';
import 'package:social_app/general/iconly_broken.dart';
import 'package:social_app/module/login/login_screen.dart';
import 'package:social_app/remote/hive/hive.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LayoutCubit(),
      child: BlocConsumer<LayoutCubit, LayoutState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cu = LayoutCubit.get(context);
          return Scaffold(
            extendBody: true,
            appBar: AppBar(
              title: Text(cu.title[cu.currentIndex]),
              actions: [
                IconButton(
                  icon: const Icon(
                    IconBroken.logout,
                  ),
                  tooltip: 'LOGOUT',
                  onPressed: () async {
                    HiveHelper.deleteHiveData(key: 'uId');
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                      (route) => false,
                    );
                    await FirebaseAuth.instance.signOut();
                    toastShown(text: 'Signed out', state: ToastColor.success);
                  },
                ),
              ],
            ),
            body: cu.screens[cu.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(IconBroken.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(IconBroken.chat),
                  label: 'Chats',
                ),
                BottomNavigationBarItem(
                  icon: Icon(IconBroken.setting),
                  label: 'Setting',
                ),
              ],
              currentIndex: cu.currentIndex,
              onTap: (index) {
                cu.indexChanged(index);
              },
            ),
          );
        },
      ),
    );
  }
}

//Theme(
//                   data: Theme.of(context).copyWith(
//                       iconTheme: const IconThemeData(color: Colors.black)),
//                   child: CurvedNavigationBar(
//                     items: const [
//                       Icon(
//                         IconBroken.home,
//                       ),
//                       Icon(
//                         IconBroken.chat,
//                       ),
//                       Icon(
//                         IconBroken.location,
//                       ),
//                       Icon(
//                         IconBroken.setting,
//                       ),
//                     ],
//                     index: cu.currentIndex,
//                     onTap: (index) {
//                       cu.indexChanged(index);
//                     },
//                     backgroundColor: Colors.transparent,
//                     color: Colors.grey.withOpacity(0.7),
//                     buttonBackgroundColor: Colors.transparent,
//                     animationDuration: const Duration(milliseconds: 400),
//                   ),
//                 ),

//BottomNavigationBar(
//                     items: const [
//                       BottomNavigationBarItem(
//                         icon: Icon(IconBroken.home),
//                         label: 'Home',
//                       ),
//                       BottomNavigationBarItem(
//                         icon: Icon(IconBroken.chat),
//                         label: 'Chats',
//                       ),
//                       BottomNavigationBarItem(
//                         icon: Icon(IconBroken.location),
//                         label: 'Location',
//                       ),
//                       BottomNavigationBarItem(
//                         icon: Icon(IconBroken.setting),
//                         label: 'Setting',
//                       ),
//                     ],
//                     currentIndex: cu.currentIndex,
//                     onTap: (index) {
//                       cu.indexChanged(index);
//                     },
//                   ),
