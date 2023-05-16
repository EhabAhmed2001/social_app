import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app/cubit_state/home/home_cubit.dart';
import 'package:social_app/cubit_state/show_popup/show_popup_state.dart';

class ShowPopupCubit extends Cubit<ShowPopupState> {
  ShowPopupCubit() : super(ShowPopupInitial());

  static ShowPopupCubit get(context) => BlocProvider.of(context);

  late Offset _tapPosition;

  void commentLongPress({
    required BuildContext context,
    required LongPressStartDetails details,
    required String postId,
    required int commentIndex,
    required int postIndex,
    required String commentId,
  }) {
    HomeCubit homeCubit = HomeCubit.get(context);

    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final Offset tapPosition = overlay.globalToLocal(details.globalPosition);

    // Store the tap position in the _tapPosition variable
    _tapPosition = tapPosition;

    // Show the context menu
    showMenu(
      context: context,
      color: Colors.grey[200],
      position: RelativeRect.fromLTRB(
        _tapPosition.dx,
        _tapPosition.dy,
        MediaQuery.of(context).size.width - _tapPosition.dx,
        MediaQuery.of(context).size.height - _tapPosition.dy,
      ),
      items: [
        PopupMenuItem(
          value: 'Delete',
          child: Row(
            children: [
              const Icon(Icons.delete),
              SizedBox(width: 5.w,),
              const Text('Delete'),
            ],
          ),
        ),
      ],
    ).then((value) async {
      if(value == 'Delete') {
        await homeCubit.deleteComment(postId: postId, postIndex: postIndex, commentId: commentId, commentIndex: commentIndex);
      }
    });
  }

}
