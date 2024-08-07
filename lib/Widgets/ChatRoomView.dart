import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signalr_chat/Services/ApiService.dart';
import 'package:signalr_chat/Widgets/States/ChatRoomHeader.dart';
import 'package:signalr_chat/Widgets/States/ChatRoomsDrawer.dart';
import 'package:signalr_chat/Widgets/States/GlobalTheme.dart';
import 'package:signalr_chat/Widgets/States/ThemeNotifier.dart';

class ChatRoomView extends StatefulWidget {
  const ChatRoomView({super.key});

  @override
  State<ChatRoomView> createState() => _ChatRoomViewState();
}

class _ChatRoomViewState extends State<ChatRoomView> with ChangeNotifier {
  //Map userData = {};
  //late Map chatRooms;
  Map<Map<String, dynamic>, Map<String, dynamic>> mappedData = {};
  final _searchController = TextEditingController();
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    //userData = ModalRoute.of(context)!.settings.arguments as Map;
    //chatRooms = ModalRoute.of(context)!.settings.arguments as Map;
    mappedData = ModalRoute.of(context)!.settings.arguments
        as Map<Map<String, dynamic>, Map<String, dynamic>>;
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
        drawer: const ChatRoomsDrawer(),
        appBar: const ChatRoomHeader(),
        body: Container(
          decoration: BoxDecoration(gradient: themeNotifier.getGradient()),
          child: Column(children: <Widget>[
            Container(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  autofocus: false,
                  controller: _searchController,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Search by name or message...',
                      hintStyle: const TextStyle(color: Color(0xFFC9C7C7)),
                      suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () async => mappedData = (await _apiService
                              .search(1491, _searchController.text))!)),
                ),
              ),
            ),
            Expanded(
                child: ListView.builder(
              itemCount: mappedData.keys.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> key = mappedData.keys.elementAt(index);
                Map<String, dynamic> value = mappedData[key]!;

                var userAvatar = value['avatar'].toString();
                var chatContents = key['chatContents'];

                //print(chatContents[0]);
                return Card(
                    color: Colors.transparent,
                    child: ListTile(
                      onTap: () async {
                        await Navigator.pushNamed(context, '/messages',
                            arguments: mappedData);
                      },
                      leading: CircleAvatar(
                        backgroundImage: userAvatar.isNotEmpty
                            ? NetworkImage(
                                "https://storage.googleapis.com/socialstream/$userAvatar")
                            : const AssetImage('assets/blank_profile_pic.png')
                                as ImageProvider,
                      ),
                      title: Text("${chatContents[0]['message']}"),
                      subtitle: Text("${chatContents[0]['sentDate']}"),
                      trailing: const Icon(
                        Icons.circle_rounded,
                        color: Colors.green,
                      ),
                    ));
              },
            ))
          ]),
        ));
  }
}
