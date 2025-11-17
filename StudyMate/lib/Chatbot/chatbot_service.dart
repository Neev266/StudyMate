import 'package:cloud_firestore/cloud_firestore.dart';

class ChatbotService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Create a new chat document
  Future<String> createNewChat(String userId) async {
    final chatRef = _firestore
        .collection('Users')
        .doc(userId)
        .collection('chats')
        .doc();

    await chatRef.set({
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'lastMessage': '',
    });

    return chatRef.id;
  }

  /// Save a message under an existing chat
  Future<void> saveMessage({
    required String userId,
    required String chatId,
    required String role,
    required String text,
  }) async {
    final messageRef = _firestore
        .collection('Users')
        .doc(userId)
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc();

    await messageRef.set({
      'role': role,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Update summary
    await _firestore
        .collection('Users')
        .doc(userId)
        .collection('chats')
        .doc(chatId)
        .update({
      'lastMessage': text,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Load all messages in a chat
  Future<List<Map<String, dynamic>>> loadChatMessages({
    required String userId,
    required String chatId,
  }) async {
    final query = await _firestore
        .collection('Users')
        .doc(userId)
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .get();

    return query.docs.map((doc) => doc.data()).toList();
  }

  /// Get chat history
  Future<List<Map<String, dynamic>>> getChatHistory(String userId) async {
    final query = await _firestore
        .collection('Users')
        .doc(userId)
        .collection('chats')
        .orderBy('updatedAt', descending: true)
        .get();

    return query.docs
        .map((doc) => {
              'id': doc.id,
              'lastMessage': doc['lastMessage'] ?? '',
            })
        .toList();
  }

  /// Delete entire chat
  Future<void> deleteChat({
    required String userId,
    required String chatId,
  }) async {
    final chatRef = _firestore
        .collection('Users')
        .doc(userId)
        .collection('chats')
        .doc(chatId);

    final messages = await chatRef.collection('messages').get();
    for (var msg in messages.docs) {
      await msg.reference.delete();
    }

    await chatRef.delete();
  }
}
