import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app/constant/app_color.dart';

abstract class ShopTheme
{
  static ThemeData lightMode = ThemeData(
    primarySwatch: SocialAppColor.defaultColor,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: SocialAppColor.defaultColor ,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      elevation: 4.0,
      backgroundColor: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      titleSpacing: 15.0.sp,
      titleTextStyle: TextStyle(
        fontSize: 20.0.sp,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: const IconThemeData(color: Colors.black),
      backgroundColor: Colors.white,
      elevation: 0.0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    ),
    useMaterial3: true,
    textTheme: TextTheme(

      // for head or name
      displayLarge: TextStyle(
        color: Colors.black,
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
      ),

      // for body or text
      bodyLarge:TextStyle(
        color: Colors.black,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        height: 1.1.h,
      ),

      // for date
      bodySmall:TextStyle(
        color: Colors.grey,
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        height: 1.1.h,
      ),

      // for hashtag
      displayMedium: TextStyle(
        color: Colors.blue,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        height: 1.5.h,
        fontStyle: FontStyle.italic,
      ),

      // for chat
      headlineMedium: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),

    ),
  );
}