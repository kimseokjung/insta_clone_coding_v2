import 'package:flutter/material.dart';
import 'package:instagram_clone_coding/constants/screen_size.dart';
import 'package:instagram_clone_coding/models/firebase_auth_state.dart';
import 'package:instagram_clone_coding/screens/auth_screen.dart';
import 'package:provider/provider.dart';

class ProfileSideMenu extends StatelessWidget {
  final double menuWidth;

  const ProfileSideMenu(
    this.menuWidth, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: menuWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                'Settings',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.black87,
              ),
              title: Text('Sign Out'),
              onTap: () {
                Provider.of<FirebaseAuthState>(context, listen: false)
                    .signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
