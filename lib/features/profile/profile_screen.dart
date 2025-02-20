import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_333/features/profile/edit_profile_screen.dart';
import 'package:flutter_333/features/profile/favorite_expereinces_screens.dart';

import '../auth/presentation/login_view.dart';
import '../settings/customerServiceScreen.dart';
import 'review_rating_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, this.type});

  final String? type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 60),
          _buildListTile(
            icon: Icons.person_outline,
            title: 'Edit Profile',
            onTap: () => _navigateToEditProfile(context),
          ),
          // const Divider(height: 2, color: Color(0xFFE0E0E0)),

          // if (type == 'tourist')
          //   _buildListTile(
          //     icon: Icons.people,
          //     title: 'Communities',
          //     showTrailing: false,
          //     onTap: () {},
          //   ),

          if (type == 'tourist')
            const Divider(height: 2, color: Color(0xFFE0E0E0)),

          if (type == 'tourist')
            _buildListTile(
              icon: Icons.favorite,
              title: 'Saved Experiences',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FavoriteExpereincesScreens())),
            ),

          if (type == 'tourist')
            const Divider(height: 2, color: Color(0xFFE0E0E0)),
            
          if (type == 'tourist')
            _buildListTile(
              icon: Icons.book_outlined,
              title: 'Bookings',
              onTap: () {},
            ),

          if (type == 'local')
            const Divider(height: 2, color: Color(0xFFE0E0E0)),
          
          _buildListTile(
            icon: Icons.headset_mic_outlined,
            title: 'Customer Service',
            onTap: () => _contactCustomerService(context),
          ),

          if (type == 'local')
            const Divider(height: 2, color: Color(0xFFE0E0E0)),

          if (type == 'local')
            _buildListTile(
              icon: Icons.rate_review_outlined,
              title: 'Review and rating',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ReviewRatingScreen())),
            ),
          
          


          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 32),
            child: ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB94545),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Log out',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required Function() onTap,
    bool showTrailing = true,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xFF6B4B3E),
        size: 28,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF6B4B3E),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: showTrailing
          ? const Icon(
              Icons.chevron_right,
              color: Color(0xFF6B4B3E),
              size: 24,
            )
          : null,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  void _navigateToEditProfile(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => EditProfileScreen(type: type ?? '',)));
  }

  void _contactCustomerService(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CustomerServiceScreen()),
    );
  }
}