import 'package:flutter/material.dart';
import 'package:secretsanta/components/my_list_tile.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onSignout;
  const MyDrawer(
      {super.key, required this.onProfileTap, required this.onSignout});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 28, 28, 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // header
              const DrawerHeader(
                  child: Icon(
                Icons.person,
                color: Colors.white,
                size: 64,
              )),

              // Home list tile
              MyListTile(
                icon: Icons.home,
                text: 'H O M E',
                onTap: () => Navigator.pop(context),
              ),

              // Profile list tile
              MyListTile(
                  icon: Icons.person,
                  text: 'P R O F I L E',
                  onTap: onProfileTap),
            ],
          ),

          // Logout list tile
          MyListTile(icon: Icons.logout, text: 'L O G O U T', onTap: onSignout),
        ],
      ),
    );
  }
}
