import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller = TextEditingController();

  final List<Map<String, dynamic>> messages = [
    {
      "isUser": false,
      "message":
          "Hi! I'm Laya 👋\nAsk me anything about your lesson.",
    },
  ];

  void sendMessage() {
    if (controller.text.trim().isEmpty) return;

    setState(() {
      messages.add({
        "isUser": true,
        "message": controller.text,
      });

      messages.add({
        "isUser": false,
        "message":
            "This is where Claude will answer later.",
      });
    });

    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),

      appBar: AppBar(
        title: const Text("Chat with Laya"),
      ),

      body: Column(
        children: [

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: messages.length,
              itemBuilder: (context, index) {

                final msg = messages[index];

                return Align(
                  alignment: msg["isUser"]
                      ? Alignment.centerRight
                      : Alignment.centerLeft,

                  child: Container(
                    margin:
                        const EdgeInsets.only(bottom: 12),

                    padding: const EdgeInsets.all(16),

                    constraints: const BoxConstraints(
                      maxWidth: 300,
                    ),

                    decoration: BoxDecoration(
                      color: msg["isUser"]
                          ? Colors.deepPurple
                          : Colors.white,

                      borderRadius:
                          BorderRadius.circular(20),
                    ),

                    child: Text(
                      msg["message"],
                      style: TextStyle(
                        color: msg["isUser"]
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),

              child: Row(
                children: [

                  Expanded(
                    child: TextField(
                      controller: controller,

                      decoration: InputDecoration(
                        hintText: "Ask Laya...",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  FloatingActionButton(
                    onPressed: sendMessage,
                    child: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}