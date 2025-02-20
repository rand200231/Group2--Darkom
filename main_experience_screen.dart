import 'package:flutter/material.dart';
import 'package:flutter_333/features/home/createAdLocal.dart';
import 'package:flutter_333/features/home/screens/homeScreenLocal.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../communities/communities_screen.dart';
import '../home/screens/tourist_home_screen.dart';
import '../profile/profile_screen.dart';

class MainExperienceScreen extends StatefulWidget {
  final String type;
  const MainExperienceScreen({
    super.key,
    required this.type,
  });

  @override
  State<MainExperienceScreen> createState() => _MainExperienceScreenState();
}

class _MainExperienceScreenState extends State<MainExperienceScreen> {
  late List<Widget> screens;
  int _selectedIndex = 0;

  @override
  void initState() {
    screens = [
      widget.type == 'local' ? HomeScreen() : TouristHomeScreen(),
      widget.type == 'local' ? AdvertisementScreen() : Container(),
      if (widget.type == 'tourist') CommunitiesScreen(),
      // widget.type == 'local'
          // ? ProfilePage(type: widget.type)
           ProfileScreen(type: widget.type)
          // EditprofileScreen(
          //     showBackButton: false,
          //   ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      child: Scaffold(
        body: screens[_selectedIndex],
        bottomNavigationBar: Theme(
          data: Theme.of(context)
              .copyWith(canvasColor: Theme.of(context).primaryColor),
          child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (index) {
                print(screens.length);
                _selectedIndex = index;
                setState(() {});
              },
              unselectedItemColor: Colors.grey.shade300,
              selectedItemColor: Colors.white,
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.local_fire_department_outlined),
                    label: "explore"),
                if (widget.type == 'tourist')
                  BottomNavigationBarItem(
                      icon: Icon(Icons.people), label: "Communities"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline), label: "profile"),
              ]),
        ),
      ),
    );
  }
}
