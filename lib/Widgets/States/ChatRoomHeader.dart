import 'package:flutter/material.dart';

class ChatRoomHeader extends StatelessWidget implements PreferredSizeWidget {
  const ChatRoomHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: const Color(0xFF39B0D2),
        centerTitle: true,
        title: const Text('Chats'),
        leading: GestureDetector(
          onTap: () => Scaffold.of(context).openDrawer(),
          child: const CircleAvatar(
            backgroundImage:
                AssetImage('assets/blank_profile_pic.png') as ImageProvider,
          ),
        ),
        actions: <Widget>[
          //Unused hamburger icon, on press opens the drawer
          // Builder(
          //   builder: (context) {
          //     return IconButton(
          //       icon: const Icon(Icons.menu),
          //       onPressed: () {
          //         Scaffold.of(context).openDrawer();
          //       },
          //     );
          //   },
          // ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Go to the next page',
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
        ]);
  }
}
