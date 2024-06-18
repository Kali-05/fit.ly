import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout_fitness/view/meal_plan/historypage.dart';

class NourishNavi extends StatefulWidget {
  final List<ChatMessage>? initialMessages;

  const NourishNavi({Key? key, this.initialMessages}) : super(key: key);

  @override
  _NourishNaviState createState() => _NourishNaviState();
}

class ChatSession {
  final String sessionId;
  final List<ChatMessage> messages;

  ChatSession({required this.sessionId, required this.messages});

  Map<String, dynamic> toJson() => {
        'sessionId': sessionId,
        'messages': messages.map((message) => message.toJson()).toList(),
      };

  static ChatSession fromJson(Map<String, dynamic> json) => ChatSession(
        sessionId: json['sessionId'],
        messages: (json['messages'] as List)
            .map((item) => ChatMessage.fromJson(item))
            .toList(),
      );
}

class _NourishNaviState extends State<NourishNavi> {
  final Gemini gemini = Gemini.instance;
  List<ChatMessage> messages = [];
  late String currentSessionId;

  ChatUser currentUser = ChatUser(
    id: "0",
    firstName: 'User',
  );
  ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "Doctor Bot ",
    profileImage:
        "https://pbs.twimg.com/profile_images/1563031865748951040/ZTAKGgIj_400x400.jpg",
  );

  @override
  void initState() {
    super.initState();
    if (widget.initialMessages != null) {
      messages = widget.initialMessages!;
    }
    currentSessionId = DateTime.now().millisecondsSinceEpoch.toString();
  }

  @override
  void dispose() {
    _saveChatSession();
    super.dispose();
  }

  Future<void> _saveChatSession() async {
    if (messages.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final session =
          ChatSession(sessionId: currentSessionId, messages: messages);
      final sessions = await _loadAllSessions();
      sessions.add(session);
      final sessionsJson = sessions.map((s) => s.toJson()).toList();
      await prefs.setString('chat_sessions', json.encode(sessionsJson));
    }
  }

  Future<List<ChatSession>> _loadAllSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionsJson = prefs.getString('chat_sessions');
    if (sessionsJson != null) {
      final List<dynamic> sessionList = json.decode(sessionsJson);
      return sessionList.map((json) => ChatSession.fromJson(json)).toList();
    }
    return [];
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages.add(chatMessage);
    });
    _saveChatSession();

    try {
      String question = chatMessage.text;
      List<Uint8List>? images;
      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [
          File(chatMessage.medias!.first.url).readAsBytesSync(),
        ];
      }

      StringBuffer responseBuffer = StringBuffer();

      gemini
          .streamGenerateContent(
        question,
        images: images,
      )
          .listen(
        (event) {
          String responsePart = event.content?.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              "";
          responseBuffer.write(responsePart);
        },
        onDone: () {
          // When the response is fully received, create a single chat message.
          String response = responseBuffer.toString();
          ChatMessage message = ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: response,
          );
          setState(() {
            messages.add(message);
          });
          _saveChatSession();
        },
        onError: (error) {
          print(error);
        },
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          "Diet Plan",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'History') {
                _saveChatSession().then((_) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatHistoryPage(),
                    ),
                  );
                });
              }
            },
            itemBuilder: (BuildContext context) {
              return {'History'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
        child: _buildUI(),
      ),
    );
  }

  Widget _buildUI() {
    return DashChat(
      currentUser: currentUser,
      onSend: _sendMessage,
      messages: messages.reversed.toList(),
    );
  }
}
