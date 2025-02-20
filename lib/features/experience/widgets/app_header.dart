import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton; // ✅ Add this

  const AppHeader({super.key, this.showBackButton = true}); // ✅ Default is true

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: ScreenUtil().statusBarHeight),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ✅ Show back button only if showBackButton is true
          if (showBackButton && Navigator.of(context).canPop())
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: CircleAvatar(
                backgroundColor: Color(0XFFf0ecdc),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Theme.of(context).primaryColor,
                  size: 22.sp,
                ),
              ),
            ),

          const SizedBox.shrink(),
          Image.asset("assets/icons/welcome.png",
              width: 97.5.w, height: 60.5.h),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(120.h);
}
