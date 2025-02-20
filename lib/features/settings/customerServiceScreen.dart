import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomerServiceScreen extends StatelessWidget {
  const CustomerServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40), // Placeholder for balance

                Image.asset("assets/icons/welcome.png",
                    width: 97.5.w, height: 105.5.h),
              ],
            ),
            const SizedBox(height: 40),
            Icon(
              Icons.headset_mic,
              size: 100,
              color: Color(0xFFA5814F),
            ),
            const SizedBox(height: 24),
            const Text(
              'contact customer support',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B4B3E),
              ),
            ),
            const SizedBox(height: 40),
            _buildContactInfo(
              title: 'Email',
              value: 'appdarkom@gmail.com',
              onTap: () => _copyToClipboard('appdarkom@gmail.com', context),
            ),
            const SizedBox(height: 32),
            _buildContactInfo(
              title: 'phone Number',
              value: '+966 55 414 8890',
              onTap: () => _copyToClipboard('+966554148890', context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo({
    required String title,
    required String value,
    required Function() onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFFA5814F),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              color: Color(0xFF6B4B3E),
            ),
          ),
        ),
      ],
    );
  }

  void _copyToClipboard(String text, BuildContext context) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied to clipboard: $text'),
        backgroundColor: Color(0xFFA5814F),
      ),
    );
  }
}
