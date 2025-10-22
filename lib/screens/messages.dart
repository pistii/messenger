import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show WidgetRef, ConsumerWidget, ConsumerStatefulWidget, ConsumerState;
import 'package:provider/provider.dart';
import 'package:signalr_chat/Models/chat_content.dart';
import 'package:signalr_chat/Models/chat_partner_dto.dart';
import 'package:signalr_chat/Services/hub_connection.dart';
import 'package:signalr_chat/Widgets/States/theme_notifier.dart';
import 'package:signalr_chat/Widgets/gradient_scaffold.dart';
import 'package:signalr_chat/utils/Provider.dart' show messagesProvider, chatPartnerProvider;
import 'package:signalr_chat/utils/factory.dart';

class MessageView extends ConsumerStatefulWidget {
  const MessageView({super.key});

  @override
  ConsumerState<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends ConsumerState<MessageView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)!.settings.arguments as ChatPartnerDto;
      print("received chatpartner: ${args.chatPartnerId} | ${args.chatRoomId} | ${args.avatar}");
      ref.read(chatPartnerProvider.notifier).setChatPartner(args);
      ref.read(messagesProvider.notifier).loadMessages(args.chatRoomId);
    });
  }

  String _getUsername(ChatPartnerDto chatPartner) {
    return "${chatPartner.firstName} ${chatPartner.middleName} ${chatPartner.lastName}";
  }

  Widget _getMessagesHeader() {
    return 
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black38,
              border: Border.all(
                color: Colors.grey.shade400,
                width: 1,
              ),
              gradient: const LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0.1, 0.3],
                colors: [Colors.white, Colors.black]
              ),
            ),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.circular(999),
                splashColor: Colors.white,
                onTap: () {},
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: Icon(Icons.video_camera_front_sharp),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black38,
              border: Border.all(
                color: Colors.grey.shade400,
                width: 1,
              ),
              gradient: const LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0.1, 0.3],
                colors: [Colors.white, Colors.black]
              ),                        ),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.circular(999),
                splashColor: Colors.white,
                onTap: () {},
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: Icon(Icons.phone),
                  ),
                ),
              ),
            ),
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(messagesProvider);
    final chatPartner = ref.watch(chatPartnerProvider);
    //TODO: Display error
    if (chatPartner == null) return Container(child: Text("ERR"),);

    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    return GradientScaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: SafeArea(
            child: AppBar(          
                backgroundColor: themeNotifier.getAppBarColor(),
                excludeHeaderSemantics: true,
                elevation: 8,
                leading: 
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new),
                      color: themeNotifier.getSubtitleColor(),
                      onPressed: () => Navigator.pop(context),
                    ),
                title: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.green,
                            width: 2,
                          ),
                        ),
                        child: 
                        const CircleAvatar(
                          radius: 16,
                          backgroundImage: AssetImage('assets/blank_profile_pic.png'),                    
                        ),
                      ),
                      const SizedBox(width: 12.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center, 
                            children: [
                              Text(
                                _getUsername(chatPartner),
                                style: TextStyle(
                                  color: themeNotifier.getTextColor(),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                "Online",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900
                                ),
                              ),
                            ],
                          ),
                    ],              
                  ),
                ),
              actions: [
                _getMessagesHeader()                
              ],
            ),
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          constraints: const BoxConstraints.expand(), // teljes képernyő
          child: Column(
            children: <Widget>[
              Expanded(
                  child: ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return MessengerCard(content: messages[index]);
                },
              )),
              const MyTextField()
            ],
          ),
        ));
  }
}

class MessengerCard extends StatelessWidget {
  final Chatcontent content;

  const MessengerCard({super.key, required this.content});
  
  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    
    return Card(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      elevation: 0,
      color: Colors.transparent,
      child: ListTile(
    title: Wrap(
      alignment: content.isAuthor ? WrapAlignment.end : WrapAlignment.start,
      children: [
          Container(
            decoration: BoxDecoration(
              gradient: themeNotifier.getTextBoxHeader(),
              borderRadius: BorderRadius.circular(3),
              boxShadow: const [
                BoxShadow(
                    color: Color.fromARGB(60, 0, 0, 196), spreadRadius: 1),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 7.0),
              child: Text(content.message),
            ),
          ),
        ],
      ),
      )
    );
  }
}

class MyTextField extends ConsumerStatefulWidget {
  const MyTextField({super.key});

  @override
  ConsumerState<MyTextField> createState() => _MyTextFieldState();
}


class _MyTextFieldState extends ConsumerState<MyTextField> {
  final TextEditingController textareaController = TextEditingController();
  @override
  void dispose() {
    textareaController.dispose();
    super.dispose();
  }

  void receiveMessage(WidgetRef ref, Map<String, dynamic> json) {
    final message = Chatcontent.fromJson(json);
    ref.read(messagesProvider.notifier).addMessage(message);
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    final TextEditingController textareaController = TextEditingController();
    final chatPartner = ref.watch(chatPartnerProvider);
    
    Future<void> _sendMessage() async {
      if (textareaController.text.isEmpty) return;

      try {

        print("text: ${textareaController.text} | chatpartner: ${chatPartner?.chatPartnerId} | chatroom: ${chatPartner?.chatRoomId}");
        if (chatPartner == null) return;
        var resp = await sendMessage(textareaController.text, chatPartner.chatRoomId, chatPartner.chatPartnerId);
        if (resp == null) {
          //TODO: show error message
          return;
        }

        if (resp.statusCode == 200) {
          var jsonBody = jsonDecode(resp.body);
          var obj = Chatcontent.fromJson(jsonBody);
          ref.read(messagesProvider.notifier).addMessage(obj);
        }

        textareaController.clear();
      } catch (e) {
        debugPrint("Send error: $e");
      }
    }
    

    return Container(
        color: themeNotifier.getTextAreaColor(),
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: themeNotifier.getTextBoxHeader(),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          /// Bal oldali +
                          SizedBox(
                            width: 34,
                            height: 34,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                splashFactory: InkRipple.splashFactory,
                                splashColor: Colors.white24,
                                onTap: () {},
                                child: const Center(child: Icon(Icons.add, size: 18)),
                              ),
                            ),
                          ),


                            /// Szövegmező
                          Expanded(
                            child: TextField(
                              style: TextStyle(color: themeNotifier.getTextColor()),
                              controller: textareaController,
                              decoration: InputDecoration(
                                hintText: "Írj valamit...",
                                hintStyle: TextStyle(color: Colors.grey.shade700),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: const EdgeInsets.all(8),
                                fillColor: Color.lerp(Colors.black, Colors.black12, 4) 
                              ),
                              onSubmitted: (value) {
                                if (value.isNotEmpty) {
                                  _sendMessage();
                                }
                              },
                              maxLines: 1,
                            ),
                          ),
                          
                          /// Küldés gomb
                          SizedBox(
                            width: 34,
                            height: 34,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                splashFactory: InkRipple.splashFactory,
                                splashColor: Colors.white24,
                                onTap: () => _sendMessage(),
                                child: const Center(child: Icon(Icons.send, size: 18)),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
              
                  const SizedBox(width: 8),
              
                  /// Mikrofon gomb
                  createCircleButton(24, const Icon(Icons.mic, size: 18)),

                  const SizedBox(width: 8),

                  /// Kamera gomb
                  createCircleButton(24, const Icon(Icons.camera_alt, size: 18)),
                ],
              ),
            )
          ],
        ));
  }
}
