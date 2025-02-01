import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget{
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      // height: 120.h,
      decoration: BoxDecoration(
        // color: Theme.of(context).primaryColor,
        // borderRadius: BorderRadius.circular(19.0.r),
      ),
      padding: EdgeInsets.only(top: ScreenUtil().statusBarHeight),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (Navigator.of(context).canPop() == true)
            IconButton(
              // padding: EdgeInsets.only(left: 10.w),
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
          
          Image.asset("assets/icons/welcome.png", width: 97.5.w, height: 105.5.h),
        ],
      ),
    );
  }
  
  @override
  Size get preferredSize => Size.fromHeight(120.h);
}