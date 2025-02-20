import 'package:flutter/material.dart';

class CityWidget extends StatelessWidget {
  const CityWidget({
    super.key,
    required this.imagePath,
    required this.cityName,
    this.height = 110,
  });

  final String imagePath;
  final String cityName;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(23),
      child: Stack(
        children: [
          // الصورة الخلفية
          Container(
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(23),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // الطبقة السوداء الشفافة
          Container(
            height: height,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2), // التعتيم بنسبة 50%
              borderRadius: BorderRadius.circular(23),
            ),
          ),

          // النص والعناصر الأخرى
          Container(
            // color: Colors.amber,
            height: height,
            // width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  cityName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
