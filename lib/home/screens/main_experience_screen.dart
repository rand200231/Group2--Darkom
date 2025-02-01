import 'package:flutter/material.dart';
import 'package:darkom/home/screens/profile_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:darkom/screens/customer_service_screen.dart'; // ✅ Ensure import
import 'home_screen.dart';

class MainExperienceScreen extends StatefulWidget {
  final int pageIndex;
  const MainExperienceScreen({super.key, this.pageIndex = 0});

  @override
  State<MainExperienceScreen> createState() => _MainExperienceScreenState();
}

class _MainExperienceScreenState extends State<MainExperienceScreen> {
  PageController? _pageController;
  int _pageIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _pageIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex);

    _screens = [
      const HomeScreen(),
      Container(color: Colors.white),
      const CustomerServiceScreen(), // ✅ Now opens Customer Support page
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(414, 896),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 7, offset: const Offset(0, 3))],
            ),
            child: BottomAppBar(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              color: Theme.of(context).primaryColor,
              elevation: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _barItem(Icons.home_outlined, 'Home', 0, flex: 1),
                  _barItem(Icons.local_fire_department_outlined, 'Explore', 1, flex: 1),
                  _barItem(Icons.support_outlined, 'Customer Support', 2, flex: 2), // ✅ Click to open Customer Support
                  _barItem(Icons.person_outline, 'Profile', 3, flex: 1),
                ],
              ),
            ),
          ),
          body: PageView.builder(
            controller: _pageController,
            itemCount: _screens.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return _screens[index];
            },
          ),
        );
      }
    );
  }

  Widget _barItem(IconData icon, String label, int index, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: GestureDetector(
        onTap: () => _setPage(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: index == _pageIndex ? Colors.white : Colors.grey[300],
              size: index == _pageIndex ? 27 : 25,
            ),
            Text(
              label,
              style: TextStyle(
                color: index == _pageIndex ? Colors.white : Colors.grey[300],
                fontSize: index == _pageIndex ? 13 : 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController!.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }
}
