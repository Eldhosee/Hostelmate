import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'model/user_model.dart';

class MessageScreen extends StatefulWidget {
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  late DatabaseReference _messagesRef;
  TextEditingController _textEditingController = TextEditingController();
  List<Message> messages = [];
  ScrollController _scrollController = ScrollController();
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().then((_) {
      _messagesRef = FirebaseDatabase.instance.ref().child('messages');
      _messagesRef.onChildAdded.listen(_onMessageAdded);
    });
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _scrollToLatestMessage();
    });
  }

  void _scrollToLatestMessage() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  void _onMessageAdded(DatabaseEvent event) {
    _messagesRef.onValue.listen((DatabaseEvent event) {
      final data = (event.snapshot.value as Map<dynamic, dynamic>)
          .cast<String, dynamic>();

      List<Message> newMessages = [];

      data.forEach((key, value) {
        final message = Message(
          id: key,
          auth: value['auth'] as String,
          sender: value['sender'] as String,
          content: value['content'] as String,
          timestamp: value['timestamp'] as int,
        );

        newMessages.add(message);
      });

      newMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      if (this.mounted) {
        setState(() {
          messages.clear();
          messages.addAll(newMessages);

          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  void _sendMessage(String content, String sender) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    _messagesRef.push().set({
      'content': content,
      'sender': sender,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'auth': authProvider.authToken
    });

    _textEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: const Color(0xFF8B5FBF),
      ),
      backgroundColor: const Color(0xFFE9E4ED),
      body: isLoading
          ? Center(
              child: const SpinKitCubeGrid(
                color: Color(0xFF8B5FBF),
                size: 50.0,
              ),
            ) // Show loading indicator
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ' ${message.sender}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              ' ${message.content}',
                              style: const TextStyle(fontSize: 19),
                            ),
                            const SizedBox(height: 28),
                            Text(
                              ' ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(message.timestamp))}',
                              style: const TextStyle(fontSize: 11),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                authProvider.role == 'university'
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _textEditingController,
                                decoration:
                                    const InputDecoration(hintText: 'Message'),
                                onSubmitted: (value) {
                                  if (value.isNotEmpty) {
                                    _sendMessage(value, 'University');
                                  }
                                },
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.send),
                              onPressed: () {
                                final text = _textEditingController.text.trim();
                                if (text.isNotEmpty) {
                                  _sendMessage(text, 'University');
                                }
                              },
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
              ],
            ),
    );
  }
}

class Message {
  final String id;
  final String auth;
  final String sender;
  final String content;
  final int timestamp;

  Message({
    required this.id,
    required this.auth,
    required this.sender,
    required this.content,
    required this.timestamp,
  });

  factory Message.fromSnapshot(DataSnapshot snapshot) {
    final data = snapshot.value as Map<String, dynamic>;
    return Message(
      id: snapshot.key!,
      auth: data['auth'] as String,
      sender: data['sender'] as String,
      content: data['content'] as String,
      timestamp: data['timestamp'] as int,
    );
  }
}
