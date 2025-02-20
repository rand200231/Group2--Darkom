import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
        child: Column(children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Text('Welcome,',
                    style: TextStyle(
                      fontFamily: 'Amoresa-Aged',
                      fontSize: 20,
                      color: Colors.white,
                    )),
              ),
              Image.asset(
                "assets/icons/welcome.png",
                height: 60,
              ),
            ],
          ),
        ]
            // Padding(
            //   padding: EdgeInsets.only(right: 10.w),
            //   child: Text(name,
            //       style: TextStyle(
            //           fontFamily: 'SpecialElite',
            //           fontSize: 20.sp,
            //           color: Colors.white,
            //           fontWeight: FontWeight.w600)),
            ));
  }
}
