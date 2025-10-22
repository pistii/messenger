import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:signalr_chat/Models/chat_content.dart';
import 'package:signalr_chat/Services/api_service.dart';
import 'package:signalr_chat/Storage/user_storage.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:signalr_chat/utils/Provider.dart' show messagesProvider;

const externalAddr = "http://10.0.2.2:5050/hub"; //"http://192.168.0.105:5050/hub";

final transportProtLogger = Logger("SignalR - transport");
final api = ApiService();
final storage = UserStorage();
final token = storage.getToken();

final _hubConnection = HubConnectionBuilder()
        .withUrl(externalAddr,
          options: 
          HttpConnectionOptions(
            transport: HttpTransportType.WebSockets,
            accessTokenFactory: () => getToken()
          ),          
        )
        .build();

  Future<String> getToken() async => await storage.getToken();

  Future<void> startConnection() async {
    try {
      await _hubConnection.start();
      debugPrint("SignalR connected!");
    } catch (e) {
      debugPrint("Connection error: $e");
    }
  }

  void subscribeToConnection(ProviderContainer cont) {
    _hubConnection.on('ReceiveChatMessage', (arguments) {
      debugPrint(jsonEncode(arguments));
      try {
        if (arguments != null && arguments.isNotEmpty) {
          final payload = arguments[0];

          Map<String, dynamic> json;
          if (payload is String) {
            json = jsonDecode(payload) as Map<String, dynamic>;
          } else if (payload is Map) {
            json = Map<String, dynamic>.from(payload);
          } else {
            debugPrint('Unknown payload type: ${payload.runtimeType}');
            return;
          }

          final content = Chatcontent.fromJson(json);
          cont.read(messagesProvider.notifier).addMessage(content);
          debugPrint('Added message to provider: ${content.message}');
        }
      } catch (e, st) {
        debugPrint('Error processing incoming message: $e\n$st');
      }
    });
  }

  Future<Response?> sendMessage(String message, String roomId, String targetUserId) async {
    var resp = await api.sendMessage(message, roomId, targetUserId);
    return resp;
  }

