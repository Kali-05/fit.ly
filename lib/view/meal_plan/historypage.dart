import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout_fitness/view/meal_plan/meal_plan_view_2.dart';

class ChatHistoryPage extends StatelessWidget {
  const ChatHistoryPage({Key? key}) : super(key: key);

  Future<List<ChatSession>> _loadAllSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionsJson = prefs.getString('chat_sessions');
    if (sessionsJson != null) {
      final List<dynamic> sessionList = json.decode(sessionsJson);
      return sessionList.map((json) => ChatSession.fromJson(json)).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _clearAllSessions(BuildContext context) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('chat_sessions');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('All chat history cleared.'),
      ));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => ChatHistoryPage()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          "Chat History",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Clear All') {
                _clearAllSessions(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Clear All'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<ChatSession>>(
        future: _loadAllSessions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading chat history.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No chat history available.'));
          }

          final sessions = snapshot.data!;

          return ListView.builder(
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              final session = sessions[index];
              final firstMessage = session.messages
                  .firstWhere((message) => message.user.id == "0");
              final previewText =
                  firstMessage.text.split(' ').take(20).join(' ');

              return ListTile(
                  title: Text('Chat ${index + 1}'),
                  subtitle: Text(previewText),
                  onTap: () {
                    Navigator.pop(context, session.messages);
                  });
            },
          );
        },
      ),
    );
  }
}
