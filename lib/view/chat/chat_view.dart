import 'package:benchmark_estimate_admin_panel/utils/common_function.dart';
import 'package:benchmark_estimate_admin_panel/utils/constants/MySize.dart';
import 'package:benchmark_estimate_admin_panel/utils/constants/colors.dart';
import 'package:benchmark_estimate_admin_panel/utils/custom_widgets/reusable_container.dart';
import 'package:benchmark_estimate_admin_panel/view_model/firebase/firebase_functions.dart';
import 'package:benchmark_estimate_admin_panel/view_model/firebase/push_notifications.dart';
import 'package:benchmark_estimate_admin_panel/view_model/provider/landing_view_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminChatScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FirestoreService _firestoreService = FirestoreService();
  final NotificationServices _notificationServices = NotificationServices();
  AdminChatScreen({super.key, });
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    final landingProvider = Provider.of<LandingViewProvider>(context,listen: false);
    return SingleChildScrollView(
      child: SizedBox(
        height: MySize.screenHeight < 300
            ? MySize.screenHeight * 0.6
            : MySize.screenHeight < 600
            ? MySize.screenHeight * 0.7
            : MySize.screenHeight * 0.85,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ReusableContainer3(
            width: 1200,
            bgColor: bgColor,
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Messages')
                        .where('projectId', isEqualTo: landingProvider.docId)
                        .orderBy('timestamp', descending: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                      final messages = snapshot.data!.docs.map((doc) => ChatMessage.fromFirestore(doc)).toList();
                      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          return ChatBubble(message: message);
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            hintText: 'Type a message',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () => _sendMessage(landingProvider, context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _sendMessage(LandingViewProvider landingProvider, BuildContext context) async {
    if (_controller.text.isNotEmpty) {
      final message = ChatMessage(
        message: _controller.text,
        timestamp: DateTime.now(),
        isSender: false, // Admin is sending the message
        projectId: landingProvider.docId,
      );

      await FirebaseFirestore.instance.collection('Messages').add(message.toFirestore());
      await _firestoreService.setNotifications(landingProvider.clientUid, 'New Message', _controller.text, landingProvider.docId);

      final token = await _firestoreService.getTokenFromUserCollection(landingProvider.clientUid);
      if (token != null) {
         await _notificationServices.sendNotification(token, context, 'New Message', _controller.text);
      }

      _controller.clear();
      _scrollToBottom();
    }
  }
}
class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: message.isSender ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (!message.isSender) const CircleAvatar(child: Icon(Icons.person)),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: message.isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: message.isSender ? primaryColor : const Color(0xffF2F4F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  message.message,
                  style: TextStyle(color: message.isSender ? whiteColor : blackColor),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${message.timestamp.hour}:${message.timestamp.minute}',
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
          if (message.isSender) const CircleAvatar(child: Icon(Icons.person)),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String message;
  final DateTime timestamp;
  final bool isSender;
  final String projectId;

  ChatMessage({
    required this.message,
    required this.timestamp,
    required this.isSender,
    required this.projectId,
  });

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return ChatMessage(
      message: data['message'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isSender: data['isSender'] ?? true,
      projectId: data['projectId'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'message': message,
      'timestamp': timestamp,
      'isSender': isSender,
      'projectId': projectId,
    };
  }


}
