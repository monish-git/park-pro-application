import 'package:flutter/material.dart';

class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({super.key});

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  bool _isChatOpen = false;
  final List<Map<String, String>> _messages = [
    {"sender": "bot", "text": "Hello! How can I help you today?"}
  ];
  final TextEditingController _chatController = TextEditingController();

  void _sendMessage() {
    if (_chatController.text.trim().isEmpty) return;
    setState(() {
      _messages.add({"sender": "user", "text": _chatController.text});
      _messages.add({"sender": "bot", "text": "Got it 👍 We'll assist you soon."});
      _chatController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          children: [
            const Icon(Icons.local_parking, color: Colors.white),
            const SizedBox(width: 8),
            const Text(
              "PARK-PRO Help & Support",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                "Frequently Asked Questions",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              /// FAQ Section
              ExpansionTile(
                title: const Text("How can I book a parking slot?"),
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Go to the Home page → Search parking → Select a spot → Tap 'Book'.",
                    ),
                  )
                ],
              ),
              ExpansionTile(
                title: const Text("How do I recharge my wallet?"),
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Open Wallet page → Tap 'Add Money' → Choose payment method.",
                    ),
                  )
                ],
              ),
              ExpansionTile(
                title: const Text("Is FASTag supported?"),
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Yes, PARK-PRO supports FASTag payments at partnered locations.",
                    ),
                  )
                ],
              ),

              const SizedBox(height: 24),

              /// Contact Section
              const Text(
                "Contact Us",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.phone, color: Colors.green),
                title: const Text("Call Support"),
                subtitle: const Text("+91 98765 43210"),
                onTap: () {
                  // implement call function
                },
              ),
              ListTile(
                leading: const Icon(Icons.email, color: Colors.red),
                title: const Text("Email Support"),
                subtitle: const Text("support@parkpro.com"),
                onTap: () {
                  // implement email function
                },
              ),
              ListTile(
                leading: const Icon(Icons.chat, color: Colors.blue),
                title: const Text("Live Chat"),
                subtitle: const Text("Chat with our support team"),
                onTap: () {
                  setState(() {
                    _isChatOpen = true;
                  });
                },
              ),

              const SizedBox(height: 24),

              /// Feedback Form
              const Text(
                "Send Feedback",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Write your feedback here...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  // handle feedback submission
                },
                icon: const Icon(Icons.send),
                label: const Text("Submit Feedback"),
              ),
            ],
          ),

          /// Chatbot Overlay
          if (_isChatOpen)
            Positioned(
              bottom: 80,
              right: 20,
              left: 20,
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "PARK-PRO Assistant",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                _isChatOpen = false;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final msg = _messages[index];
                          bool isUser = msg["sender"] == "user";
                          return Container(
                            alignment: isUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 12),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isUser
                                    ? Colors.blue[100]
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(msg["text"] ?? ""),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _chatController,
                              decoration: InputDecoration(
                                hintText: "Type a message...",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.send, color: Colors.blue),
                            onPressed: _sendMessage,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
        ],
      ),

      /// Floating Chatbot Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isChatOpen = !_isChatOpen;
          });
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.chat),
      ),
    );
  }
}
