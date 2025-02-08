import 'package:flutter/material.dart';
import 'package:flutter_333/features/home/createAdLocal.dart';
import 'package:flutter_333/features/home/homeScreenLocal.dart';
import 'package:flutter_333/features/profile_screen_page/profile_screen_local.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      widget.type == 'local' ? HomeScreen() : Container(),
      widget.type == 'local' ? AdvertisementScreen() : Container(),
      if (widget.type == 'tourist') Container(),
      widget.type == 'local'
          ? ProfilePage(type: widget.type)
          : ProfilePage(type: widget.type)
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
