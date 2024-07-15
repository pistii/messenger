import 'package:flutter/material.dart';

class ChatRoomsDrawer extends StatefulWidget {
  const ChatRoomsDrawer({super.key});

  @override
  State<ChatRoomsDrawer> createState() => _ChatRoomsDrawerState();
}

class _ChatRoomsDrawerState extends State<ChatRoomsDrawer> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-1.0, 0.0),
            end: Alignment(1.0, 0.0),
            colors: [Colors.blue, Color.fromARGB(186, 155, 39, 176)],
            stops: [0.0, 1.0],
            transform: GradientRotation(0.64),
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              currentAccountPicture: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/blank_profile_pic.png')
                      as ImageProvider,
                ),
              ),
              accountEmail: SizedBox.shrink(),
              accountName: Text(
                'Jane Doe',
                style: TextStyle(fontSize: 24.0),
              ),
              decoration: BoxDecoration(
                color: Colors.black45,
              ),
            ),
            ListTile(
              title: const Text('Settings'),
              textColor: Colors.white,
              onTap: () {
                // Update the state of the app
                _onItemTapped(0);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Help'),
              textColor: Colors.white,
              selected: _selectedIndex == 1,
              onTap: () {
                // Update the state of the app
                _onItemTapped(1);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Logout'),
              textColor: Colors.white,
              selected: _selectedIndex == 2,
              onTap: () {
                //TODO: delete user data from store
                Navigator.pushReplacementNamed(context, '/login');
                // Update the state of the app
                _onItemTapped(2);
              },
            ),
          ],
        ),
      ),
    );
  }
}
