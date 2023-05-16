import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app/general/iconly_broken.dart';
import 'app_color.dart';

abstract class SocialAppConstWidget {

  static Widget defaultFormField({
    required TextEditingController controller,
    required TextInputType? keyboardType,
    required Function validation,
    String? label,
    String? hint,
    Widget? prefixIcon,
    FocusNode? focusNode,
    Widget? suffixIcon,
    Color? cursorColor,
    int? maxLines,
    double radius = 18,
    double? hintHeight,
    Function? fieldSubmitted,
    bool isPass = false,

  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      reverse: true,
      child: TextFormField(
        onFieldSubmitted: (s) {
          fieldSubmitted;
        },
        keyboardType: keyboardType,
        validator: (value) {
          return validation(value);
        },
        focusNode: focusNode,
        controller: controller,
        obscureText: isPass,
        cursorColor: cursorColor ,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().radius(radius))),
          ),
          labelText: label,
          hintText: hint,
          hintStyle: TextStyle(
            height: hintHeight?.h,
          ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  static Widget defaultButton({
    required Function pressedFunction,
    required String text,
    Color textColor = Colors.white,
    MaterialColor color = SocialAppColor.defaultColor,
    double height = 42,
    double width = double.infinity,
    double radius = 20,
    double fontSize = 16,
    bool upperCase = true,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: height.h,
        minWidth: width.w,
      ),
      child: MaterialButton(
        onPressed: () {
          pressedFunction();
        },
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius
              .circular(radius)
              .w,
        ),
        child: Text(
          upperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize.sp,
          ),
        ),
      ),
    );
  }

  static Widget defaultDivider() =>
      Container(
        height: 1.0.h,
        width: double.infinity,
        color: Colors.grey[400],
        margin: EdgeInsetsDirectional.symmetric(vertical: 5.h),
      );

  static AppBar defaultAppBar(
      {
        required BuildContext context,
        List<Widget>? actions,
        String title ='',
      }) =>
      AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(IconBroken.arrow_Left_2),
        ),
        title: Text(title),
        actions: actions,
      );


}
