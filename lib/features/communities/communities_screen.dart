import 'package:flutter/material.dart';
import 'package:flutter_333/core/widgets/app_header.dart';
import 'package:flutter_333/features/communities/widgets/city_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommunitiesScreen extends StatelessWidget {
  const CommunitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 80,
            color: Theme.of(context).primaryColor,
            child: Center(
              child: Row(
                children: [
                  Image.asset("assets/icons/welcome.png", width: 97.5.w, height: 105.5.h),
                  Text(
                    "Communities",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
      
          Expanded(
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: ScreenUtil().screenHeight - 220),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CityWidget(imagePath: "assets/images/riyadh.png", cityName: 'Riyadh'),
                    const SizedBox(height: 10),
                    
                    CityWidget(imagePath: "assets/images/jeddah.png", cityName: 'Jeddah'),
                    const SizedBox(height: 10),
                    
                    CityWidget(imagePath: "assets/images/qassim.png", cityName: 'Qassim'),
                    const SizedBox(height: 10),
                
                    CityWidget(imagePath: "assets/images/al_ula.png", cityName: 'Al Ula'),
                    const SizedBox(height: 10),
                
                    CityWidget(imagePath: "assets/images/asir.png", cityName: 'Asir'),
                    const SizedBox(height: 10),
                   
                   
                    CityWidget(imagePath: "assets/images/alahsa.png", cityName: 'Alahsa'),
                    const SizedBox(height: 10),
                
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}